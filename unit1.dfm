object Form1: TForm1
  Left = 270
  Top = 115
  Width = 1000
  Height = 588
  Caption = 'Csiiiz!'
  Color = 8404992
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 335
    Top = 65
    Width = 640
    Height = 480
    Stretch = True
  end
  object Label2: TLabel
    Left = 10
    Top = 40
    Width = 80
    Height = 13
    Caption = 'Ment'#233's helye:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object cap: TVideoCapture
    Left = 10
    Top = 65
    Width = 320
    Height = 240
    DVResolution = dvrDontWorry
    WantBitmaps = True
    BitmapPixelFormat = pf24bit
    WantAudio = False
    WantDVAudio = False
    WantAudioPreview = False
    WantPreview = True
    WantCapture = True
    UseFrameRate = False
    FrameRate = 10.000000000000000000
    UseTempFile = False
    UseTimeLimit = False
    TimeLimit = 0
    DoPreallocFile = False
    PreallocFileSize = 1
    OnStartPreview = capStartPreview
    OnBitmapGrabbed = capBitmapGrabbed
    Color = clBlack
  end
  object cbVModes: TComboBox
    Left = 235
    Top = 10
    Width = 221
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbVModesChange
  end
  object cbVSources: TComboBox
    Left = 10
    Top = 10
    Width = 221
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = cbVSourcesChange
  end
  object Edit2: TEdit
    Left = 95
    Top = 35
    Width = 376
    Height = 21
    TabOrder = 3
    Text = '.\'
  end
  object run: TCheckBox
    Left = 10
    Top = 310
    Width = 97
    Height = 17
    Caption = 'Run?'
    TabOrder = 4
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 500
    Top = 25
  end
end
