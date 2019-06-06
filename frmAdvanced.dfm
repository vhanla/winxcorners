object frmAdvSettings: TfrmAdvSettings
  Left = 0
  Top = 0
  Caption = 'WinXCorners - Advanced Options'
  ClientHeight = 385
  ClientWidth = 442
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 319
    Top = 173
    Width = 106
    Height = 13
    Caption = 'Beta build (20170602)'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 348
    Width = 81
    Height = 13
    Cursor = crHandPoint
    Caption = 'Support my work'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 15626577
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = Label4Click
  end
  object Label5: TLabel
    Left = 128
    Top = 348
    Width = 88
    Height = 13
    Cursor = crHandPoint
    Caption = 'Check for updates'
    Color = 16744448
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 15626577
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnClick = Label5Click
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 14
    Width = 409
    Height = 158
    Caption = 
      'Delayed response (delay unit 300ms, i.e. 3 = 900ms almost a seco' +
      'nd)'
    TabOrder = 0
    object chkDelayGlobal: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Global Delay'
      TabOrder = 0
      OnClick = chkDelayGlobalClick
    end
    object valDelayGlobal: TSpinEdit
      Left = 112
      Top = 22
      Width = 41
      Height = 22
      MaxValue = 10
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
    object chkDelayTopLeft: TCheckBox
      Left = 56
      Top = 64
      Width = 97
      Height = 17
      Caption = 'Top Left Delay'
      TabOrder = 2
    end
    object valDelayTopLeft: TSpinEdit
      Left = 152
      Top = 62
      Width = 33
      Height = 22
      MaxValue = 10
      MinValue = 1
      TabOrder = 3
      Value = 1
    end
    object chkDelayTopRight: TCheckBox
      Left = 224
      Top = 64
      Width = 97
      Height = 17
      Caption = 'Top Right Delay'
      TabOrder = 4
    end
    object valDelayTopRight: TSpinEdit
      Left = 320
      Top = 65
      Width = 33
      Height = 22
      MaxValue = 10
      MinValue = 1
      TabOrder = 5
      Value = 1
    end
    object chkDelayBotLeft: TCheckBox
      Left = 56
      Top = 93
      Width = 97
      Height = 17
      Caption = 'Bot Left Delay'
      TabOrder = 6
    end
    object valDelayBotLeft: TSpinEdit
      Left = 152
      Top = 91
      Width = 33
      Height = 22
      MaxValue = 10
      MinValue = 1
      TabOrder = 7
      Value = 1
    end
    object chkDelayBotRight: TCheckBox
      Left = 224
      Top = 93
      Width = 97
      Height = 17
      Caption = 'Bot Right Delay'
      TabOrder = 8
    end
    object valDelayBotRight: TSpinEdit
      Left = 320
      Top = 91
      Width = 33
      Height = 22
      MaxValue = 10
      MinValue = 1
      TabOrder = 9
      Value = 1
    end
    object chkShowCount: TCheckBox
      Left = 16
      Top = 128
      Width = 123
      Height = 17
      Caption = 'Show Countdown'
      TabOrder = 10
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 192
    Width = 409
    Height = 145
    Caption = 'Custom Command (Launcher)'
    TabOrder = 1
    object Label3: TLabel
      Left = 16
      Top = 24
      Width = 370
      Height = 13
      Caption = 
        'Write a custom command (executable path + parameters): e.g. note' +
        'pad.exe'
    end
    object Label1: TLabel
      Left = 16
      Top = 70
      Width = 104
      Height = 13
      Caption = 'Parameters (optional)'
    end
    object edCommand: TEdit
      Left = 18
      Top = 43
      Width = 368
      Height = 21
      TabOrder = 0
    end
    object chkCustom: TCheckBox
      Left = 16
      Top = 116
      Width = 209
      Height = 17
      Caption = 'Enable Custom Command'
      TabOrder = 2
    end
    object chkHidden: TCheckBox
      Left = 289
      Top = 116
      Width = 97
      Height = 17
      Caption = 'Launch Hidden'
      TabOrder = 3
    end
    object edParams: TEdit
      Left = 18
      Top = 89
      Width = 368
      Height = 21
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 262
    Top = 343
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 350
    Top = 343
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = Button2Click
  end
end
