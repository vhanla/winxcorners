object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 319
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object UPanel1: TUPanel
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
    object UListButton1: TUListButton
      Left = 1
      Top = 97
      Width = 207
      Height = 32
      Align = alTop
      Caption = 'E&xit'
      TabOrder = 0
      OnClick = UListButton1Click
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
    object UListButton2: TUListButton
      Left = 1
      Top = 65
      Width = 207
      Height = 32
      Align = alTop
      Caption = 'Settings'
      TabOrder = 1
      OnClick = UListButton2Click
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
    object UListButton3: TUListButton
      Left = 1
      Top = 1
      Width = 207
      Height = 32
      Align = alTop
      Caption = '&About'
      TabOrder = 2
      OnClick = UListButton3Click
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
    object UListButton4: TUListButton
      Left = 1
      Top = 33
      Width = 207
      Height = 32
      Align = alTop
      Caption = '&Start with Windows'
      TabOrder = 3
      OnClick = UListButton4Click
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
  object PopupMenu1: TPopupMenu
    Left = 96
    Top = 24
    object About1: TMenuItem
      Caption = '&About'
      OnClick = About1Click
    end
    object emporarydisabled1: TMenuItem
      Caption = '&Start with Windows'
      OnClick = emporarydisabled1Click
    end
    object Advanced1: TMenuItem
      Caption = 'Ad&vanced'
      OnClick = Advanced1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = 'E&xit'
      OnClick = Exit1Click
    end
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
  end
end
