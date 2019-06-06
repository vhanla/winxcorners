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
    _caption : string;
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
    _font : TFont;

    procedure SetDisabledColor(Value: TColor);
    procedure SetEnabledColor(Value: TColor);
    procedure SetEnabled(Value: Boolean);
    procedure SetPressedColor(Value: TColor);
    procedure SetCaption(Value: string);
    procedure SetCheckState(Value: Boolean);
    procedure SetFont(Value: TFont);

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
    property ShowHint;
    property ParentShowHint;
    property OnMouseMove;
//    property Font;
    property Font: TFont read _font write SetFont;
    property Enabled: Boolean read _enabled write SetEnabled;
    property OnClick;//: TNotifyEvent read FOnClick write FOnClick;

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
  Width := 167;
  Height := 31;
  _enabledcolor := clOlive;
  _disabledColor := clBlack;
  _enabled := True; // this will show as label if disabled
  _pressedColor := $666666;
  _mousehover := False;
  _mousepressed := False;
  Canvas.Brush.Color := clBlack;
  _font:=TFont.Create;
  _font.Color := clWhite;
  _font.Size := 12;
  FOnclick := NIL;
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
  xfont: TGPFont;
  style: Integer;
  graph: TGPGraphics;
  pen: TGPPen;
  brush: TGPSolidBrush;
  stringFormat: TGPStringFormat;
  l,t,w,h,d,s,radio: integer;
  txt: WideString;
begin
  inherited;

  radio := 42;
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
        bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha($222222,200)
      else
        bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha($222222,200);
    bmp.Canvas.FillRect(Rect(0,0,Width,Height));

    graph := TGPGraphics.Create(bmp.Canvas.Handle);
    try
      //GdipSetSmoothingMode(graph, SmoothingModeAntiAlias);
      //GdipSetCompositingMode(graph, CompositingModeSourceCopy);
      graph.SetSmoothingMode(SmoothingModeAntiAlias);

      l := 0; t := 0;  w := Width-1;   h := Height-1;
      style := FontStyleRegular;
      //xfont := TGPFont.Create(bmp.canvas.Handle, _font.Handle);//.
      xfont := TGPFont.Create(_font.Name, _font.Size, style, UnitPoint);
      try

        // let's draw
        brush := TGPSolidBrush.Create(MakeGDIPColor(_disabledColor));//any color for now
        try
          pen := TGPPen.Create(MakeGDIPColor(_disabledColor,100),2); // any color  for now
          try
            if _enabled then
            begin
              if _mousepressed then
              begin
                brush.SetColor(MakeGDIPColor(_pressedColor));
                graph.FillRectangle(brush,MakeRect(0,0,Width-1,Height-1));
                brush.SetColor(MakeGDIPColor(_disabledColor));
              end;
              if not _mousepressed and _mousehover then
                pen.SetColor(MakeGDIPColor(_disabledColor));//(BlendColors(_disabledColor,clWhite,70)));

              graph.DrawLine(pen,l,t,l+w,t);
              graph.DrawLine(pen,l,t,l,t+h);
              graph.DrawLine(pen,l,t+h,l+w,t+h);
              graph.DrawLine(pen,l+w,t,l+w,t+h);
              //draw knob
              pen.SetWidth(1);
              pen.SetColor(MakeGDIPColor(_disabledColor,100));
              graph.DrawLine(pen,l+w-22,t+13,l+w-22+6,t+13+6);
              graph.DrawLine(pen,l+w-22+6+1,t+13+6,l+w-22+6+1+6,t+13);
              pen.SetWidth(2);
            end;
              //let's draw the string - caption
              stringFormat := TGPStringFormat.Create;
              try
                stringFormat.SetAlignment(StringAlignmentNear);
                stringFormat.SetLineAlignment(StringAlignmentCenter);
                stringFormat.SetTrimming(StringTrimmingEllipsisCharacter);
                stringFormat.SetFormatFlags(StringFormatFlagsNoWrap);
                brush.SetColor(MakeGDIPColor($BBBBBB));
                //graph.SetTextRenderingHint(TextRenderingHintClearTypeGridFit);                //graph.SetTextRenderingHint(TextRenderingHintAntiAlias);
                graph.SetTextRenderingHint(TextRenderingHintAntiAliasGridFit);
                txt := _caption;
                graph.DrawString(txt,Length(txt),xfont,MakePoint(15.0,(Height/2-_font.Size)),nil,brush);
                graph.SetTextRenderingHint(TextRenderingHintSingleBitPerPixelGridFit);
                brush.SetColor(MakeGDIPColor($FFFFFF));
                graph.DrawString(txt,Length(txt),xfont,MakePoint(15.0,(Height/2-_font.Size)),nil,brush);
                {graph.DrawString(txt,
                                  length(txt),
                                  xfont,
                                  rectF,
                                  stringFormat,
                                  brush);}
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
    canvas.Draw(0,0,bmp);

    //Windows.AlphaBlend(Canvas.Handle,0,0,Width, Height,bmp.Canvas.Handle, 0,0,Width,Height,MergeFunc);
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
