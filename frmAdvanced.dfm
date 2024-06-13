object frmAdvSettings: TfrmAdvSettings
  Left = 0
  Top = 0
  AlphaBlend = True
  Caption = 'WinXCorners - Advanced Options'
  ClientHeight = 622
  ClientWidth = 714
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 144
  TextHeight = 21
  object Label2: TLabel
    Left = 515
    Top = 279
    Width = 200
    Height = 24
    Caption = 'Beta build (20240612)'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label4: TLabel
    Left = 26
    Top = 562
    Width = 152
    Height = 28
    Cursor = crHandPoint
    Caption = 'Support my work'
    Font.Charset = ANSI_CHARSET
    Font.Color = 15626577
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = Label4Click
  end
  object Label5: TLabel
    Left = 207
    Top = 562
    Width = 157
    Height = 28
    Cursor = crHandPoint
    Caption = 'Check for updates'
    Color = 16744448
    Font.Charset = ANSI_CHARSET
    Font.Color = 15626577
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnClick = Label5Click
  end
  object GroupBox1: TGroupBox
    Left = 26
    Top = 23
    Width = 661
    Height = 255
    Caption = 
      'Delayed response (delay unit 300ms, i.e. 3 = 900ms almost a seco' +
      'nd)'
    TabOrder = 0
    object chkDelayGlobal: TCheckBox
      Left = 26
      Top = 39
      Width = 157
      Height = 27
      Caption = 'Global Delay'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -18
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = chkDelayGlobalClick
    end
    object valDelayGlobal: TSpinEdit
      Left = 181
      Top = 36
      Width = 66
      Height = 32
      MaxValue = 10
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
    object chkDelayTopLeft: TCheckBox
      Left = 90
      Top = 103
      Width = 157
      Height = 28
      Caption = 'Top Left Delay'
      TabOrder = 2
    end
    object valDelayTopLeft: TSpinEdit
      Left = 246
      Top = 100
      Width = 53
      Height = 32
      MaxValue = 10
      MinValue = 1
      TabOrder = 3
      Value = 1
    end
    object chkDelayTopRight: TCheckBox
      Left = 362
      Top = 103
      Width = 157
      Height = 28
      Caption = 'Top Right Delay'
      TabOrder = 4
    end
    object valDelayTopRight: TSpinEdit
      Left = 517
      Top = 105
      Width = 53
      Height = 32
      MaxValue = 10
      MinValue = 1
      TabOrder = 5
      Value = 1
    end
    object chkDelayBotLeft: TCheckBox
      Left = 90
      Top = 150
      Width = 157
      Height = 28
      Caption = 'Bot Left Delay'
      TabOrder = 6
    end
    object valDelayBotLeft: TSpinEdit
      Left = 246
      Top = 147
      Width = 53
      Height = 32
      MaxValue = 10
      MinValue = 1
      TabOrder = 7
      Value = 1
    end
    object chkDelayBotRight: TCheckBox
      Left = 362
      Top = 150
      Width = 157
      Height = 28
      Caption = 'Bot Right Delay'
      TabOrder = 8
    end
    object valDelayBotRight: TSpinEdit
      Left = 517
      Top = 147
      Width = 53
      Height = 32
      MaxValue = 10
      MinValue = 1
      TabOrder = 9
      Value = 1
    end
    object chkShowCount: TCheckBox
      Left = 26
      Top = 207
      Width = 199
      Height = 27
      Caption = 'Show Countdown'
      TabOrder = 10
    end
    object chkFullScreen: TCheckBox
      Left = 246
      Top = 207
      Width = 259
      Height = 27
      Caption = 'Do nothing on Full Screen '
      TabOrder = 11
      OnClick = chkFullScreenClick
    end
  end
  object Button1: TButton
    Left = 423
    Top = 554
    Width = 121
    Height = 40
    Caption = '&OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 565
    Top = 554
    Width = 122
    Height = 40
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
  object PageControl1: TPageControl
    Left = 26
    Top = 296
    Width = 661
    Height = 252
    ActivePage = TabSheet1
    TabOrder = 3
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Command 1'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 653
        Height = 216
        Align = alClient
        Caption = 'Custom Command (Launcher)'
        TabOrder = 0
        object Label3: TLabel
          Left = 26
          Top = 39
          Width = 569
          Height = 21
          Caption = 
            'Write a custom command (executable path + parameters): e.g. note' +
            'pad.exe'
        end
        object Label1: TLabel
          Left = 26
          Top = 113
          Width = 163
          Height = 21
          Caption = 'Parameters (optional)'
        end
        object edCommand: TEdit
          Left = 29
          Top = 69
          Width = 595
          Height = 29
          TabOrder = 0
          OnChange = edCommandChange
        end
        object chkCustom: TCheckBox
          Left = 26
          Top = 187
          Width = 337
          Height = 28
          Caption = 'Enable Custom Commands'
          TabOrder = 2
        end
        object chkHidden: TCheckBox
          Left = 467
          Top = 187
          Width = 157
          Height = 28
          Caption = 'Launch Hidden'
          TabOrder = 3
          OnClick = chkHiddenClick
        end
        object edParams: TEdit
          Left = 29
          Top = 144
          Width = 595
          Height = 29
          TabOrder = 1
          OnChange = edParamsChange
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Command 2'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TabSheet3: TTabSheet
      Caption = 'Command 3'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TabSheet4: TTabSheet
      Caption = 'Command 4'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
end
