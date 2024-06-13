{
XCheckbox, mimics the Windows 10's checkbox capable of
adding over an aero glass form on Delphi

Author: vhanla

Changelog:
TODO:
  Add touch support
  Add items support using maybe XPopupMenu
- 16-08-05
  Change rendering text method for gdiplus to make it look better
  https://theartofdev.com/2014/03/02/blurryfuzzy-gdi-text-rendering-using-antialias-and-floating-point-y-coordinates/
  http://stackoverflow.com/questions/11307509/drawing-text-on-glass-background-becomes-blurred-as-alpha-is-lowered

- 15-10-14
  Looks like Windows'
  Twetaked to use it as a label when disabled, temporary solution :P
  Fixed OnClick property in order to programmatically assign a function
  to handle it, just removed the extra read an write events
}
unit XCombobox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PNGimage, functions, GDIPApi, GDIPobj;

type
  TXCombobox = class(TGraphicControl)
  private
    _caption: string;
    _disabledColor: TColor;
    _enabledColor: TColor;
    _pressedColor: TColor;
    _chkstate: Boolean;
    _mousehover: Boolean;
    _mousepressed: Boolean;
    _enabled: Boolean;

    MDown: TMouseEvent;
    MUp: TMouseEvent;
    MLeave: TNotifyEvent;
    BtnClick: TNotifyEvent;
    FOnclick: TNotifyEvent;
    _font: TFont;

    procedure SetDisabledColor(Value: TColor);
    procedure SetEnabledColor(Value: TColor);
    procedure SetEnabled(Value: Boolean);
    procedure SetPressedColor(Value: TColor);
    procedure SetCaption(Value: string);
    procedure SetCheckState(Value: Boolean);
    procedure SetFont(Value: TFont);

  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure Click; override;
    procedure SetParent(Value: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption: string read _caption write SetCaption;
    property Color: TColor read _enabledColor write SetEnabledColor;
    property DisabledColor: TColor read _disabledColor write SetDisabledColor;
    property PressedColor: TColor read _pressedColor write SetPressedColor;
    property Checked: Boolean read _chkstate write SetCheckState;

    property OnMouseDown: TMouseEvent read MDown write MDown;
    property OnMouseUp: TMouseEvent read MUp write MUp;
    property OnMouseLeave: TNotifyEvent read MLeave write MLeave;
    property ShowHint;
    property ParentShowHint;
    property OnMouseMove;
//    property Font;
    property Font: TFont read _font write SetFont;
    property Enabled: Boolean read _enabled write SetEnabled;
    property OnClick; //: TNotifyEvent read FOnClick write FOnClick;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('codigobit', [TXCombobox]);
end;

{ TXCombobox }

procedure TXCombobox.Click;
begin
  inherited;
//  ShowMessage(inttostr(Width));
//  _chkstate := not _chkstate;
  //Paint;
end;

constructor TXCombobox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  Width := MulDiv(167, Screen.PixelsPerInch, 96); //win10
  Width := MulDiv(151, Screen.PixelsPerInch, 96);
  Height := MulDiv(31, Screen.PixelsPerInch, 96);
  _enabledcolor := clOlive;
  _disabledColor := clBlack;
  _enabled := True; // this will show as label if disabled
  _pressedColor := $666666;
  _mousehover := False;
  _mousepressed := False;
  Canvas.Brush.Color := clBlack;
  _font := TFont.Create;
  _font.Color := clWhite;
  _font.Size := 14; //12 win10
  FOnclick := nil;
  ShowHint := False;
end;

destructor TXCombobox.Destroy;
begin
  _font.Free;
  inherited;
end;

procedure TXCombobox.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  _mousepressed := True;
  Paint;
end;

procedure TXCombobox.MouseEnter(var Message: TMessage);
begin
  _mousehover := True;
  Paint;
end;

procedure TXCombobox.MouseLeave(var Message: TMessage);
begin
  _mousehover := False;
  Paint;
end;

procedure TXCombobox.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  _mousepressed := False;
  Paint;
end;

procedure TXCombobox.Paint;

  function MakeGDIPColor(C: TColor; A: Integer = 255): Cardinal;
  var
    tmpRGB: TColorRef;
  begin
    tmpRGB := ColorToRGB(C);
    Result := ((DWORD(GetBValue(tmpRGB)) shl BlueShift) or
      (DWORD(GetGValue(tmpRGB)) shl GreenShift) or
      (DWORD(GetRValue(tmpRGB)) shl RedShift) or
      (DWORD(A) shl AlphaShift));
  end;

  function hidpi(value: Integer): Integer;
  begin
    Result := MulDiv(value, Screen.PixelsPerInch, 96);
  end;

var
  bmp: TBitmap;
  xfont: TGPFont;
  style: Integer;
  graph: TGPGraphics;
  pen: TGPPen;
  brush: TGPSolidBrush;
  stringFormat: TGPStringFormat;
  l, t, w, h, d, s, radio: Integer;
  txt: WideString;
  DPI: Integer;
  ScaleFactor: Single;
  path: TGPGraphicsPath;
begin
  inherited;

  DPI := Screen.PixelsPerInch;
  ScaleFactor := 1; //DPI / 96; // Assuming 96 DPI as the baseline

  radio := 42;
  d := radio div 2;
  s := d div 2; // guide for lines width

  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf32bit;
    bmp.SetSize(Width, Height);

    // Clear the canvas with appropriate color
    if TaskbarAccented then
      bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BlendColors(clBlack, GetAccentColor, 50), 200)
    else if SystemUsesLightTheme then
      bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha($DDDDDD, 200)
    else
    begin
      if isWindows11 then
        bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BlendColors($2d2d2d, clBlack,25), 200)
      else
        bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha($222222, 200);
    end;

    bmp.Canvas.FillRect(Rect(0, 0, Width, Height));

    graph := TGPGraphics.Create(bmp.Canvas.Handle);
    try
      graph.SetSmoothingMode(SmoothingModeAntiAlias);

      l := 0; t := 0; w := Width - 1; h := Height - 1;
      style := FontStyleRegular;

      xfont := TGPFont.Create(_font.Name, hidpi(_font.Size), style, UnitPixel);
      try
        brush := TGPSolidBrush.Create(MakeGDIPColor(_disabledColor));
        try
          if SystemUsesLightTheme then
            pen := TGPPen.Create(MakeGDIPColor(clBlack, 100), 2 * ScaleFactor)
          else
            pen := TGPPen.Create(MakeGDIPColor(_disabledColor, 100), 2 * ScaleFactor);
            
          try
            if _enabled then
            begin
              if _mousepressed then
              begin
                if isWindows11 then
                begin
                end
                else // win10
                begin
                  brush.SetColor(MakeGDIPColor(_pressedColor));
                  graph.FillRectangle(brush, MakeRect(0, 0, Width - 1, Height - 1));
                  brush.SetColor(MakeGDIPColor(_disabledColor));
                end;
              end
              else if _mousehover then
              begin
                if SystemUsesLightTheme then
                  pen.SetColor(MakeGDIPColor($333333))
                else
                  pen.SetColor(MakeGDIPColor(_disabledColor));
              end;

              //draw button
              d := HighDpi(8); //radio

              if isWindows11 then
              begin
                path := TGPGraphicsPath.Create();
                try
                  path.AddArc(l + 1, t + 1, d, d, 180, 90);
                  path.AddArc(l + w - d - 1, t + 1, d, d, 270, 90);
                  path.AddArc(l + w - d - 1, t + h - 1 - d, d, d, 0, 90);
                  path.AddArc(l + 1, t + h - d - 1, d, d, 90, 90);
                  path.CloseFigure;
                  if _mousepressed then
                    brush.SetColor(MakeGDIPColor($303030))
                  else
                  begin
                    if SystemUsesLightTheme then
                      brush.SetColor(MakeGDIPColor($cccccc))
                    else
                      brush.SetColor($FF353535);
                  end;
                  graph.FillPath(brush, path);
                finally
                  path.Free;
                end;
                path := TGPGraphicsPath.Create();
                try
                  path.AddArc(l + 2, t + 2, d, d, 180, 90);
                  path.AddArc(l + w - d - 2, t + 2, d, d, 270, 90);
                  path.AddArc(l + w - d - 2, t + h - 2 - d, d, d, 0, 90);
                  path.AddArc(l + 2, t + h - d - 2, d, d, 90, 90);
                  path.CloseFigure;
                  if _mousehover then
                  begin
                    if SystemUsesLightTheme then
                      brush.SetColor($FFF5F5F5)
                    else
                      brush.SetColor($FF323232)
                  end
                  else
                    if SystemUsesLightTheme then
                      brush.SetColor($effbfbfb)
                    else
                      brush.SetColor($FF2D2D2D);

                  if _mousepressed then
                  begin
                    if SystemUsesLightTheme then
                      brush.SetColor($FFf5f5f5)
                    else
                      brush.SetColor($FF272727);
                  end;

                  graph.FillPath(brush, path);
                finally
                  path.Free;
                end;

              end
              else //win10
              begin
                graph.DrawLine(pen, l, t, l + w, t);
                graph.DrawLine(pen, l, t, l, t + h);
                graph.DrawLine(pen, l, t + h, l + w, t + h);
                graph.DrawLine(pen, l + w, t, l + w, t + h);
              end;

              // Draw knob
              pen.SetWidth(1);
              if SystemUsesLightTheme then
                pen.SetColor($FF333333)
              else
                pen.SetColor(MakeGDIPColor(_disabledColor, 100));
              graph.DrawLine(pen, l + w - hidpi(22), t + hidpi(13), l + w - hidpi(22) + 6, t + hidpi(13) + 6);
              graph.DrawLine(pen, l + w - hidpi(22) + 6 + 1, t + hidpi(13) + 6, l + w - hidpi(22) + 6 + 1 + 6, t + hidpi(13));
              pen.SetWidth(2);
            end;

            // Draw the caption
            stringFormat := TGPStringFormat.Create;
            try
              stringFormat.SetAlignment(StringAlignmentNear);
              stringFormat.SetLineAlignment(StringAlignmentCenter);
              stringFormat.SetTrimming(StringTrimmingEllipsisCharacter);
              stringFormat.SetFormatFlags(StringFormatFlagsNoWrap);

              brush.SetColor(MakeGDIPColor($BBBBBB));
              graph.SetTextRenderingHint(TextRenderingHintAntiAliasGridFit);
              txt := _caption;
              graph.DrawString(txt, Length(txt), xfont, MakePoint(15.0 * ScaleFactor, (Height / 2 - hidpi(_font.Size)) * ScaleFactor + hidpi(_font.size div 3)), nil, brush);

              graph.SetTextRenderingHint(TextRenderingHintSingleBitPerPixelGridFit);
              if SystemUsesLightTheme then
                brush.SetColor(MakeGDIPColor($333333))
              else
                brush.SetColor(MakeGDIPColor($FFFFFF));

              if SystemUsesLightTheme then
                graph.DrawString(txt, Length(txt), xfont, MakePoint(15.0 * ScaleFactor, (Height / 2 - _font.Size) * ScaleFactor), nil, brush);
            finally
              stringFormat.Free;
            end;
          finally
            pen.Free;
          end;
        finally
          brush.Free;
        end;
      finally
        xfont.Free;
      end;
    finally
      graph.Free;
    end;

    Canvas.Draw(0, 0, bmp);
  finally
    bmp.Free;
  end;
end;


procedure TXCombobox.SetCaption(Value: string);
begin
  _caption := Value;
  Paint;
end;

procedure TXCombobox.SetCheckState(Value: Boolean);
begin
  _chkstate := Value;
  Paint;
end;

procedure TXCombobox.SetDisabledColor(Value: TColor);
begin
  _disabledColor := Value;
  Paint;
end;

procedure TXCombobox.SetEnabled(Value: Boolean);
begin
  _enabled := Value;
  Paint;
end;

procedure TXCombobox.SetEnabledColor(Value: TColor);
begin
  _enabledColor := Value;
  Paint;
end;

procedure TXCombobox.SetFont(Value: TFont);
begin
  _font.Assign(Value);
  Invalidate;
end;

procedure TXCombobox.SetParent(Value: TWinControl);
begin
  inherited;
  if Value <> nil then _caption := Name;

end;

procedure TXCombobox.SetPressedColor(Value: TColor);
begin
  _pressedColor := Value;
  Paint;
end;

end.

