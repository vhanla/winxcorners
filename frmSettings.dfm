object frmTrayPopup: TfrmTrayPopup
  Left = 0
  Top = 0
  Caption = 'frmTrayPopup'
  ClientHeight = 354
  ClientWidth = 616
  Color = 16744448
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 144
  TextHeight = 32
  object imgScreenShape: TImage
    Left = 218
    Top = 69
    Width = 146
    Height = 146
  end
  object Label1: TLabel
    Left = 256
    Top = 69
    Width = 36
    Height = 133
    Caption = '1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -100
    Font.Name = 'Segoe UI Light'
    Font.Style = []
    ParentFont = False
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
