object frmAdvSettings: TfrmAdvSettings
  Left = 0
  Top = 0
  AlphaBlend = True
  Caption = 'WinXCorners - Advanced Options'
  ClientHeight = 427
  ClientWidth = 438
  Color = 2960685
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    438
    427)
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 16
    Top = 398
    Width = 91
    Height = 15
    Cursor = crHandPoint
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akBottom]
    Caption = 'Support my work'
    Font.Charset = ANSI_CHARSET
    Font.Color = 15626577
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = Label4Click
  end
  object Label5: TLabel
    Left = 147
    Top = 398
    Width = 96
    Height = 15
    Cursor = crHandPoint
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akBottom]
    Caption = 'Check for updates'
    Color = 16744448
    Font.Charset = ANSI_CHARSET
    Font.Color = 15626577
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnClick = Label5Click
  end
  object Label2: TLabel
    Left = 307
    Top = 163
    Width = 124
    Height = 14
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Beta build (20240630)'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object btnCancel: TButton
    Left = 351
    Top = 394
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 270
    Top = 394
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
  object ATTabs1: TATTabs
    AlignWithMargins = True
    Left = 8
    Top = 191
    Width = 422
    Height = 35
    Margins.Left = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alBottom
    Tabs = <
      item
        TabCaption = 'Command 1'
        TabHideXButton = True
      end
      item
        TabCaption = 'Command 2'
        TabHideXButton = True
      end
      item
        TabCaption = 'Command 3'
        TabHideXButton = True
      end
      item
        TabCaption = 'Command 4'
        TabHideXButton = True
      end>
    DoubleBuffered = True
    ColorBg = 2960685
    ColorBorderPassive = 6579300
    ColorTabPassive = 2960685
    ColorActiveMark = 16744448
    OptButtonLayout = '<>,v'
    OptShowAngleTangent = 2.599999904632568000
    OptShowFlat = True
    OptShowFlatSepar = False
    OptShowXButtons = atbxShowNone
    OptShowPlusTab = False
    OptShowModifiedText = '*'
    OptMouseDragOutEnabled = False
    OptHintForX = 'Close tab'
    OptHintForPlus = 'Add tab'
    OptHintForArrowLeft = 'Scroll tabs left'
    OptHintForArrowRight = 'Scroll tabs right'
    OptHintForArrowMenu = 'Show tabs list'
    OptHintForUser0 = '0'
    OptHintForUser1 = '1'
    OptHintForUser2 = '2'
    OptHintForUser3 = '3'
    OptHintForUser4 = '4'
    OnTabClick = ATTabs1TabClick
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 422
    Height = 145
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Panel1'
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 3
    object chkDelayBotLeft: TXCheckbox
      Left = 24
      Top = 71
      Width = 44
      Height = 20
      Caption = 'Top Bottom Delay'
      Color = 16744448
      DisabledColor = 5592405
      PressedColor = 6710886
      Checked = False
      OnClick = chkDelayBotLeftClick
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = True
      Labeled = True
      LabelPosition = lpRight
    end
    object chkDelayBotRight: TXCheckbox
      Left = 213
      Top = 71
      Width = 44
      Height = 20
      Caption = 'Top Bottom delay'
      Color = 16744448
      DisabledColor = 5592405
      PressedColor = 6710886
      Checked = False
      OnClick = chkDelayBotRightClick
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = True
      Labeled = True
      LabelPosition = lpRight
    end
    object chkDelayGlobal: TXCheckbox
      Left = 16
      Top = 5
      Width = 44
      Height = 20
      Caption = 'Set a global delay in seconds:'
      Color = 16744448
      DisabledColor = 5592405
      PressedColor = 6710886
      Checked = False
      OnClick = chkDelayGlobalClick
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = True
      Labeled = True
      LabelPosition = lpRight
    end
    object chkDelayTopLeft: TXCheckbox
      Left = 24
      Top = 37
      Width = 44
      Height = 20
      Caption = 'Top Left Delay'
      Color = 16744448
      DisabledColor = 5592405
      PressedColor = 6710886
      Checked = False
      OnClick = chkDelayTopLeftClick
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = True
      Labeled = True
      LabelPosition = lpRight
    end
    object chkDelayTopRight: TXCheckbox
      Left = 213
      Top = 37
      Width = 44
      Height = 20
      Caption = 'Top Right delay'
      Color = 16744448
      DisabledColor = 5592405
      PressedColor = 6710886
      Checked = False
      OnClick = chkDelayTopRightClick
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = True
      Labeled = True
      LabelPosition = lpRight
    end
    object chkFullScreen: TXCheckbox
      Left = 163
      Top = 116
      Width = 44
      Height = 20
      Caption = 'Do nothing on Full Screen'
      Color = 16744448
      DisabledColor = 5592405
      PressedColor = 6710886
      Checked = False
      OnClick = chkFullScreenClick
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = True
      Labeled = True
      LabelPosition = lpRight
    end
    object chkShowCount: TXCheckbox
      Left = 16
      Top = 116
      Width = 44
      Height = 20
      Caption = 'Show Countdown'
      Color = 16744448
      DisabledColor = 5592405
      PressedColor = 6710886
      Checked = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = True
      Labeled = True
      LabelPosition = lpRight
    end
    object cbValDelayGlobal: TComboBox
      Left = 240
      Top = 5
      Width = 40
      Height = 21
      Style = csDropDownList
      Color = clNone
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        '0.25'
        '0.50'
        '0.75'
        '1.00'
        '1.25'
        '1.50')
    end
    object cbValDelayTopLeft: TComboBox
      Left = 172
      Top = 38
      Width = 40
      Height = 21
      Style = csDropDownList
      Color = clNone
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        '0.25'
        '0.50'
        '0.75'
        '1.00'
        '1.25'
        '1.50')
    end
    object cbValDelayBotLeft: TComboBox
      Left = 172
      Top = 72
      Width = 40
      Height = 21
      Style = csDropDownList
      Color = clNone
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        '0.25'
        '0.50'
        '0.75'
        '1.00'
        '1.25'
        '1.50')
    end
    object cbValDelayTopRight: TComboBox
      Left = 364
      Top = 38
      Width = 40
      Height = 21
      Style = csDropDownList
      Color = clNone
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        '0.25'
        '0.50'
        '0.75'
        '1.00'
        '1.25'
        '1.50')
    end
    object cbValDelayBotRight: TComboBox
      Left = 364
      Top = 72
      Width = 40
      Height = 21
      Style = csDropDownList
      Color = clNone
      ItemHeight = 13
      TabOrder = 4
      Items.Strings = (
        '0.25'
        '0.50'
        '0.75'
        '1.00'
        '1.25'
        '1.50')
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 8
    Top = 226
    Width = 422
    Height = 153
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 48
    Align = alBottom
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Panel2'
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 4
    object chkCustom: TXCheckbox
      Left = 16
      Top = 121
      Width = 44
      Height = 20
      Caption = 'Enable Custom Commands'
      Color = 16744448
      DisabledColor = 5592405
      PressedColor = 6710886
      Checked = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = True
      Labeled = True
      LabelPosition = lpRight
    end
    object chkHidden: TXCheckbox
      Left = 251
      Top = 121
      Width = 44
      Height = 20
      Caption = 'Launch Hidden'
      Color = 16744448
      DisabledColor = 5592405
      PressedColor = 6710886
      Checked = False
      OnClick = chkHiddenClick
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = True
      Labeled = True
      LabelPosition = lpRight
    end
    object Label1: TLabel
      Left = 16
      Top = 70
      Width = 104
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Parameters (optional)'
      Color = clBackground
      ParentColor = False
    end
    object Label3: TLabel
      Left = 16
      Top = 26
      Width = 370
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 
        'Write a custom command (executable path + parameters): e.g. note' +
        'pad.exe'
      Color = 2960685
      ParentColor = False
    end
    object edCommand: TButtonedEdit
      Left = 16
      Top = 46
      Width = 368
      Height = 19
      Color = clNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      TextHint = 
        'You can also trigger hotkeys by prepending !, eg. !_control+_alt' +
        '+tab'
      OnChange = edCommandChange
    end
    object edParams: TButtonedEdit
      Left = 16
      Top = 88
      Width = 368
      Height = 19
      Color = clNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      TextHint = 
        'You can also trigger hotkeys by prepending !, eg. !_control+_alt' +
        '+tab'
      OnChange = edParamsChange
    end
  end
end
