object frmTrayPopup: TfrmTrayPopup
  Left = 0
  Top = 0
  Caption = 'frmTrayPopup'
  ClientHeight = 232
  ClientWidth = 404
  Color = 16744448
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClick = FormClick
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 21
  object imgScreenShape: TImage
    Left = 143
    Top = 45
    Width = 96
    Height = 96
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    OnClick = FormClick
  end
  object Label1: TLabel
    Left = 168
    Top = 45
    Width = 23
    Height = 87
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -65
    Font.Name = 'Segoe UI Light'
    Font.Style = []
    ParentFont = False
    OnClick = FormClick
  end
  object Timer1: TTimer
    Interval = 3
    OnTimer = Timer1Timer
    Left = 208
    Top = 184
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer2Timer
    Left = 200
    Top = 120
  end
  object Timer3: TTimer
    Enabled = False
    OnTimer = Timer3Timer
    Left = 136
    Top = 144
  end
  object tmFader: TTimer
    Enabled = False
    Interval = 20
    OnTimer = tmFaderTimer
    Left = 56
    Top = 160
  end
end
