object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 294
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object UPanel1: TUWPPanel
    Left = 232
    Top = 24
    Width = 209
    Height = 130
    AutoSize = True
    Caption = 'UPanel1'
    Color = 10526880
    Ctl3D = False
    DoubleBuffered = True
    Padding.Left = 1
    Padding.Top = 1
    Padding.Right = 1
    Padding.Bottom = 1
    ParentCtl3D = False
    ParentDoubleBuffered = False
    TabOrder = 0
    CustomBackColor.Enabled = True
    CustomBackColor.Color = 10526880
    CustomBackColor.LightColor = 10526880
    CustomBackColor.DarkColor = 10526880
    object ulbExit: TUWPListButton
      Left = 1
      Top = 97
      Width = 207
      Height = 32
      Align = alTop
      Caption = 'E&xit'
      TabOrder = 0
      OnClick = ulbExitClick
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 12105912
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = #62385
      Detail = ''
    end
    object ulbSettings: TUWPListButton
      Left = 1
      Top = 65
      Width = 207
      Height = 32
      Align = alTop
      Caption = 'Settings'
      TabOrder = 1
      OnClick = ulbSettingsClick
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 12105912
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = #59155
      Detail = ''
    end
    object ulbAbout: TUWPListButton
      Left = 1
      Top = 1
      Width = 207
      Height = 32
      Align = alTop
      Caption = '&About'
      TabOrder = 2
      OnClick = ulbAboutClick
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 12105912
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = #59718
      Detail = ''
    end
    object ulbStartWithWindows: TUWPListButton
      Left = 1
      Top = 33
      Width = 207
      Height = 32
      Align = alTop
      Caption = '&Start with Windows'
      TabOrder = 3
      OnClick = ulbStartWithWindowsClick
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 12105912
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = ''
      Detail = ''
    end
  end
  object tmrHotSpot: TTimer
    Enabled = False
    Interval = 250
    OnTimer = tmrHotSpotTimer
    Left = 24
    Top = 24
  end
  object tmrDelay: TTimer
    Enabled = False
    Interval = 300
    OnTimer = tmrDelayTimer
    Left = 184
    Top = 24
  end
  object MadExceptionHandler1: TMadExceptionHandler
    Left = 240
    Top = 168
  end
  object ActionList1: TActionList
    Left = 56
    Top = 208
    object actCtrlAltTab: TAction
      Caption = 'actCtrlAltTab'
      OnExecute = actCtrlAltTabExecute
    end
    object actShowTaskView: TAction
      Caption = 'actShowTaskView'
      OnExecute = actShowTaskViewExecute
    end
    object actShowActionCenterSidebar: TAction
      Caption = 'actShowActionCenterSidebar'
      OnExecute = actShowActionCenterSidebarExecute
    end
    object actShowDesktop: TAction
      Caption = 'actShowDesktop'
      OnExecute = actShowDesktopExecute
    end
    object actShowStartMenu: TAction
      Caption = 'actShowStartMenu'
      OnExecute = actShowStartMenuExecute
    end
  end
  object tmrSideGestures: TTimer
    OnTimer = tmrSideGesturesTimer
    Left = 336
    Top = 216
  end
  object tmrShakeMouse: TTimer
    Interval = 50
    OnTimer = tmrShakeMouseTimer
    Left = 200
    Top = 240
  end
end
