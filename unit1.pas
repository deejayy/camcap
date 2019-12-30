unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VCap, StdCtrls, ExtCtrls, Buttons, Jpeg;

type
  TForm1 = class(TForm)
    cap: TVideoCapture;
    cbVModes: TComboBox;
    cbVSources: TComboBox;
    Image1: TImage;
    Edit2: TEdit;
    Label2: TLabel;
    Timer1: TTimer;
    run: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure cbVSourcesChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbVModesChange(Sender: TObject);
    procedure capStartPreview(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure capbtnClick(Sender: TObject);
    procedure capBitmapGrabbed(CapturedImage: TCapturedBitmap);
    procedure Timer1Timer(Sender: TObject);
  private
    function InitCapture: Boolean;
    function calcbmp(bm: TBitmap): double;
    { Private declarations }
  public
    directory, fname: string;
    ecrc, crc: double;
    throotle: integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses winsock, DateUtils;

var

  config: TGraphConfig;

function TForm1.InitCapture: Boolean;
begin
  Result:= cap.Init;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  config := TGraphConfig.Create;
  config.WantCapture := true;
  config.WantPreview := true;
  config.WantBitmaps := true;
  config.WantAudio := false;
  config.WantDVAudio := false;
  config.WantAudioPreview := false;

  edit2.Text := extractfilepath(paramstr(0));
end;

procedure TForm1.cbVSourcesChange(Sender: TObject);
var i: integer;
begin
  config.VCapSource := cbVSources.text;
  cap.RestoreGraph(config);

  for i:= 0 to cbVSources.Items.Count-1 do
  if cbVSources.Items[i]=config.VCapSource then begin
    cbVSources.ItemIndex:= i;
    break;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    s2: TStringList;
    cvcapMode: TVCapMode;

begin
  s2:= GetVideoDevicesList;
  try
    cbVSources.Items.Assign(s2);
  finally
    s2.Free;
  end;
  cvcapMode:= cap.VCapMode;
end;

procedure TForm1.Button2Click(Sender: TObject);
var capCount, i: integer;
    vcapMode, cvcapMode: TVCapMode;
    s: string;
begin
  cbVModes.Items.Clear;
  capCount := cap.VCapModeCount;
  for i := 0 to capCount-1 do begin
    vcapMode := cap.VCapModes[i];
    s := GetModeString(vcapMode);
    cbVModes.Items.Add(s);
    if IsEqualModes(cvcapMode, vcapMode) then
      cbVModes.ItemIndex:= i;
  end;
end;

procedure TForm1.cbVModesChange(Sender: TObject);
begin
  cap.SetVCapMode(cbVModes.ItemIndex);
  cap.StartPreview;
end;

procedure TForm1.capStartPreview(Sender: TObject);
begin
  cbVModes.ItemIndex:= cap.VCapModeIdx;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  cap.StartCapture(false);
end;

procedure TForm1.FormShow(Sender: TObject);
var i: integer;
begin
  if not InitCapture then begin
    ShowMessage('Can''t init capture!');
    Application.Terminate;
  end;

  Button1Click(sender);
  cbVSources.ItemIndex := 0;
  cbVSourcesChange(sender);
  Button2Click(sender);
  for i := 0 to cbVModes.Items.Count-1 do begin
    if pos('1600x1200x24b', cbVModes.items[i]) <> 0 then begin
      cbVModes.ItemIndex := i;
      break;
    end;
  end;
  cbVModesChange(sender);
end;

procedure TForm1.capbtnClick(Sender: TObject);
begin
  if edit2.text[length(edit2.text)] <> '\' then
    edit2.text := edit2.text + '\';
  if assigned(image1.Picture.Graphic) then begin
  end;
end;

procedure TForm1.capBitmapGrabbed(CapturedImage: TCapturedBitmap);
var
  j: TJPEGImage;
  myYear, myMonth, myDay, myHour, myMin, mySec, myMilli: word;
  path: string;
  tick: longword;
begin
  crc := calcbmp(CapturedImage);
  form1.caption := format('%.2f : %.2f', [ecrc, crc]);
  if abs(ecrc-crc) > 1 then begin
    tick := GetTickCount;
    DecodeDateTime(now, myYear, myMonth, myDay, myHour, myMin, mySec, myMilli);
    path := format('%s\%.4d-%.2d-%.2d.%.2d', [edit2.text, myyear, mymonth, myday, myhour]);
    fname := format('%.2d.%.2d.%.2d.%4d', [myhour, mymin, mysec, mymilli]);
    if not DirectoryExists(path) then mkdir(path);
    j := TJPEGImage.Create;
    j.Assign(CapturedImage);
    j.SaveToFile(format('%s\%s%s', [path, fname, '.jpg']));
    j.Destroy;
    image1.Picture.Bitmap.Assign(CapturedImage);
    // form1.Caption := inttostr(GetTickCount - tick);
    timer1.Interval := 100;
    throotle := 0;
  end else begin
    inc(throotle);
    if throotle > 4 then
      timer1.Interval := 1000;
  end;
  ecrc := crc;
end;

function TForm1.calcbmp(bm: TBitmap): double;
var
  crc: int64;
  ms: tmemorystream;
  buf: array of byte;
  i: cardinal;
begin
  crc := 0;
  ms := tmemorystream.Create;
  bm.SaveToStream(ms);
  ms.Seek(0, 0);
  setlength(buf, ms.Size + 1024);
  ms.read(buf[1], ms.Size);
  for i := 1 to ms.size-1 do begin
    crc := crc + buf[i];
  end;
  result := crc/ms.size;
  ms.Destroy;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if run.Checked then
    cap.CaptureFrame;
end;

end.
