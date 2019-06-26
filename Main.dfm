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
  PixelsPerInch = 96
  TextHeight = 13
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
end
