{
XCheckbox, mimics the Windows 10's checkbox capable of
adding over an aero glass form on Delphi

Author: vhanla

Changelog:
TODO:
  Add animation, and mouse drag
  Add touch support
- 24-06-11
  Fix HighDpi support to draw radius correctly
  Add Windows 11 style
- 17-06-02
  Fixed vertical disabled line on HiDpi 125% or more
  Fixed knob ellipse relative to height ratio
- 15-10-14
  Works as expected
  Added functions.pas to use custom alpha brush to draw, but it looks ugly,... butttt now is
  FIXED using GDIPlus mixing with custom brush to set transparency hack
}
unit XCheckbox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PNGimage, functions, GDIPApi, GDIPobj;

type
  TXCheckbox = class(TGraphicControl)
  private
    _caption : string;
    _disabledColor: TColor;
    _enabledColor: TColor;
    _pressedColor: TColor;
    _chkstate: Boolean;
    _mousehover: Boolean;
    _mousepressed: Boolean;

    MDown: TMouseEvent;
    MUp: TMouseEvent;
    MLeave: TNotifyEvent;
    BtnClick: TNotifyEvent;

    procedure SetDisabledColor(Value: TColor);
    procedure SetEnabledColor(Value: TColor);
    procedure SetPressedColor(Value: TColor);
    procedure SetCaption(Value: string);
    procedure SetCheckState(Value: Boolean);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
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
    property OnClick;//: TNotifyEvent read BtnClick write BtnClick;
    property ShowHint;
    property ParentShowHint;
    property OnMouseMove;
    property Font;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('codigobit', [TXCheckbox]);
end;

{ TXCheckbox }

procedure TXCheckbox.Click;
begin
_chkstate := not _chkstate; // changing it before actually informing user that it was clicked
  inherited;

  Paint;
end;

constructor TXCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := HighDpi(44);
  Height := HighDpi(20);
  _enabledcolor := clOlive;
  _disabledColor := clBlack;
  _pressedColor := $666666;
  _mousehover := False;
  _mousepressed := False;
  Canvas.Brush.Color := clBlack;
  Font.Name := 'Segoe UI';
  Font.Size := 12;
  Font.Style := [];
  ShowHint := False;

end;

destructor TXCheckbox.Destroy;
begin

  inherited;
end;

procedure TXCheckbox.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  _mousepressed := True;
  Paint;
end;

procedure TXCheckbox.MouseEnter(var Message: TMessage);
begin
  _mousehover := True;
  Paint;
end;

procedure TXCheckbox.MouseLeave(var Message: TMessage);
begin
  _mousehover := False;
  Paint;
end;

procedure TXCheckbox.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  _mousepressed := False;
  Paint;
end;

procedure TXCheckbox.Paint;
function MakeGDIPColor(C: TColor; A: Integer = 255): Cardinal;
var
  tmpRGB : TColorRef;
begin
  tmpRGB := ColorToRGB(C);
  result := ((DWORD(GetBValue(tmpRGB)) shl  BlueShift) or
             (DWORD(GetGValue(tmpRGB)) shl GreenShift) or
             (DWORD(GetRValue(tmpRGB)) shl   RedShift) or
             (DWORD(A) shl AlphaShift));
end;
{const
  MergeFunc: TBlendFunction = (BlendOp: AC_SRC_OVER; BlendFlags: 0;
    SourceConstantAlpha: $FF; AlphaFormat: AC_SRC_ALPHA);}

var
  bmp: TBitmap;
  path: TGPGraphicsPath;
  graph: TGPGraphics;
  pen: TGPPen;
  brush: TGPSolidBrush;
  l,t,w,h,d,s,radio: integer;

begin
  inherited;

  radio := HighDpi(42);
  d := radio div 2;
  s := d div 2; // guide for lines width

  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf32bit;
    bmp.SetSize(Width, Height);
    // let's clear the canvas with the color that is used as translucent in our aero
    // it needs some tweaks though
    if TaskbarAccented then
      bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BlendColors(clBlack,GetAccentColor,50),200)
    else
      if SystemUsesLightTheme then
        bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha($dddddd,200)
      else
      begin
        if isWindows11 then
          bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BlendColors($2d2d2d, clBlack,25), 200)
        else
          bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha($222222,200);
      end;
    bmp.Canvas.FillRect(Rect(0,0,Width,Height));

    graph := TGPGraphics.Create(bmp.Canvas.Handle);
    try
      graph.SetSmoothingMode(SmoothingModeAntiAlias);

      l := 0; t := 0;  w := Width-1;   h := Height-1;
      path := TGPGraphicsPath.Create();
      try
        path.AddArc(l,t,d,d,180,90);
        path.AddArc(l+w-d,t,d,d,270,90);
        path.AddArc(l+w-d,t+h-d,d,d,0,90);
        path.AddArc(l,t+h-d,d,d,90,90);
        path.CloseFigure;

        // let's draw
        brush := TGPSolidBrush.Create(MakeGDIPColor(_disabledColor));//any color for now
        try
          pen := TGPPen.Create(MakeGDIPColor(_disabledColor),2); // any color  for now
          try
            if _chkstate then
            begin
              if _mousehover then
                brush.SetColor(MakeGDIPColor(BlendColors(clWhite, _enabledColor,20)))
              else
                brush.SetColor(MakeGDIPColor(_enabledColor));
              if _mousepressed then
                brush.SetColor(MakeGDIPColor(_pressedColor));
              graph.FillPath(brush, path );
              brush.SetColor(MakeGDIPColor(clWhite));

              //graph.FillEllipse(brush,MakeRect(Width-5-9-1,5,9,9));
              graph.FillEllipse(brush,MakeRect(Width-5-(h-10)-1,5,h-10,h-10));//white circle
            end
            else
            begin
              if _mousepressed then
              begin
                brush.SetColor(MakeGDIPColor(_pressedColor));
                graph.FillPath(brush, path );
                brush.SetColor(MakeGDIPColor(_disabledColor));
              end
              else
              begin
              //  graph.DrawPath(pen,path); // this has glitches
                graph.DrawArc(pen,l+1,t+1,d-2,d-2,180,90);
                graph.DrawLine(pen,l+s,t+1,l+w-s,t+1);
                graph.DrawArc(pen,l+w-d+1,t+1,d-2,d-2,270,90);
                graph.DrawLine(pen,l+w-1,t+s, l+w-1, t+h-s);
                graph.DrawArc(pen,l+w-d+1,t+h-d+1,d-2,d-2,0,90);
                graph.DrawArc(pen,l+1,t+h-d+1,d-2,d-2,90,90);
                graph.DrawLine(pen,l+s,t+h-1,l+w-s,t+h-1);
                graph.DrawLine(pen,l+1,t+s, l+1, t+h-s);
              end;

              //graph.FillEllipse(brush,MakeRect(5,5,9,9));
              graph.FillEllipse(brush,MakeRect(5,5,h-10,h-10));
            end;
          finally
            pen.Free;
          end;
        finally
          brush.Free;
        end;
      finally
        path.Free;
      end;
    finally
      graph.Free;
    end;
    canvas.Draw(0,0,bmp);
    //Windows.AlphaBlend(Canvas.Handle,0,0,Width, Height,bmp.Canvas.Handle, 0,0,Width,Height,MergeFunc);
  finally
    bmp.Free;
  end;
{  Canvas.Pen.Style := psClear;
  if _chkstate then
  begin
    Canvas.Brush.Handle := CreateSolidBrushWithAlpha(_enabledColor);
    Canvas.RoundRect(0,0,Width,Height,15,15);
    Canvas.Brush.Handle := CreateSolidBrushWithAlpha(clWhite);
    Canvas.Ellipse(Width - 5,5,Width - 15,15);

  end
  else
  begin
    Canvas.Brush.Handle := CreateSolidBrushWithAlpha(_disabledColor);
    Canvas.RoundRect(0,0,Width,Height,15,15);
    if TaskbarAccented then
      Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BlendColors(_enabledColor,clBlack,50),200)
    else
      Canvas.Brush.Handle := CreateSolidBrushWithAlpha($222222,200);
    Canvas.RoundRect(2,2,Width-2,Height-2,15,15);
    Canvas.Brush.Handle := CreateSolidBrushWithAlpha(_disabledColor);
    Canvas.Ellipse(5,5,15,15);
  end;}
end;

procedure TXCheckbox.SetCaption(Value: string);
begin
  _caption := Value;
  Paint;
end;

procedure TXCheckbox.SetCheckState(Value: Boolean);
begin
  _chkstate := Value;
  Paint;
end;

procedure TXCheckbox.SetDisabledColor(Value: TColor);
begin
  _disabledColor := Value;
  Paint;
end;

procedure TXCheckbox.SetEnabledColor(Value: TColor);
begin
  _enabledColor := Value;
  Paint;
end;

procedure TXCheckbox.SetParent(Value: TWinControl);
begin
  inherited;
  if Value <> nil then _caption := Name;

end;

procedure TXCheckbox.SetPressedColor(Value: TColor);
begin
  _pressedColor := Value;
  Paint;
end;

end.
