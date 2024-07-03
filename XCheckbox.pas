{
XCheckbox, mimics the Windows 10's checkbox capable of
adding over an aero glass form on Delphi

Author: vhanla

Changelog:
TODO:
  Add animation, and mouse drag
  Add touch support
- 24-07-02
  Add TCustomLabel as optional companion
  (!weird that adding TLabel was detected by Kaspersky as not-a-virus:HEUR:AdWare.Win32.Generic)
- 24-07-01
  Fix click event rushing to mouseup for bad checkstate setting
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
  StdCtrls, PNGimage, functions, GDIPApi, GDIPobj, Types;

type
  TLabelPosition = (lpLeft, lpRight);

  TXCheckBoxLabel = class(TCustomLabel)
  published
    property Caption;
    property Font;
  end;

  TXCheckbox = class(TGraphicControl)
  private
    FCaption : string;
    FDisabledColor: TColor;
    FEnabledColor: TColor;
    FPressedColor: TColor;
    FChecked: Boolean;
    FMouseHover: Boolean;
    FMousePressed: Boolean;

    FOnMouseDown: TMouseEvent;
    FOnMouseUp: TMouseEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnClick: TNotifyEvent;

    FLabel: TXCheckBoxLabel;
    FLabeled: Boolean;
    FLabelPosition: TLabelPosition;
    FLabelSpacing: Integer;
    FParentColor: TColor;

    procedure SetDisabledColor(Value: TColor);
    procedure SetEnabledColor(Value: TColor);
    procedure SetPressedColor(Value: TColor);
    procedure SetCaption(Value: string);
    procedure SetChecked(Value: Boolean);

    procedure SetLabeled(Value: Boolean);
    procedure SetLabelPosition(Value: TLabelPosition);
    procedure SetLabelSpacing(Value: Integer);
    procedure UpdateLabelPosition;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure Click; override;
    procedure SetParent(Value: TWinControl); override;
    procedure Resize; override;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure RepaintLabel;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FEnabledColor write SetEnabledColor;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor;
    property PressedColor: TColor read FPressedColor write SetPressedColor;
    property Checked: Boolean read FChecked write SetChecked;

    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property ShowHint;
    property ParentShowHint;
    property OnMouseMove;
    property Font;
    property Enabled;
    property ParentColor default False;

    property Labeled: Boolean read FLabeled write SetLabeled default False;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition default lpLeft;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 3;
  end;

procedure Register;

implementation

uses
  Math;

procedure Register;
begin
  RegisterComponents('codigobit', [TXCheckbox]);
end;

{ Helper Functions }
function DimColor(Color: TColor; DimLevel: Byte): TColor;
var
  R, G, B: Byte;
begin
  // Extract the red, green, and blue components from the TColor
  R := GetRValue(Color);
  G := GetGValue(Color);
  B := GetBValue(Color);

  // Reduce the brightness of each component by the DimLevel
  R := Max(0, R - DimLevel);
  G := Max(0, G - DimLevel);
  B := Max(0, B - DimLevel);

  // Combine the dimmed components back into a TColor
  Result := RGB(R, G, B);
end;


{ TXCheckbox }

procedure TXCheckbox.Click;
begin
    if Assigned(FOnClick) then
      FOnClick(Self);

end;

constructor TXCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := HighDpi(44);
  Height := HighDpi(20);
  FEnabledColor := clOlive;
  FDisabledColor := clBlack;
  FPressedColor := $666666;
  FMouseHover := False;
  FMousePressed := False;
  Canvas.Brush.Color := clBlack;
  Font.Name := 'Segoe UI';
  Font.Size := 10;
  Font.Style := [];
  ShowHint := False;
  ParentColor := False;

  FLabeled := False;
  FLabelPosition := lpLeft;
  FLabelSpacing := 3;
end;

destructor TXCheckbox.Destroy;
begin
  if Assigned(FLabel) then
    FLabel.Free;

  inherited;
end;

procedure TXCheckbox.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FMousePressed := True;
  if Assigned(FOnMouseDown) then
    FOnMouseDown(Self, Button, Shift, X, Y);
  Invalidate;
end;

procedure TXCheckbox.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouseHover := True;
  Invalidate;
end;

procedure TXCheckbox.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouseHover := False;
  FMousePressed := False;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
  Invalidate;
end;

procedure TXCheckbox.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  MousePos: TPoint;
begin
  inherited;
  FMousePressed := False;

  if (PtInRect(ClientRect, Point(X, Y))) and (Button = mbLeft) then
  begin
      SetChecked(not FChecked);
      if Assigned(FLabel) then
        if Checked then
          FLabel.Font.Color := Font.Color
        else
          FLabel.Font.Color := FDisabledColor;
      Click;
  end;

  if Assigned(FOnMouseUp) then
    FOnMouseUp(Self, Button, Shift, X, Y);
  Invalidate;
end;

procedure TXCheckbox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FLabel) then
    FLabel := nil;
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
    begin
      if SystemUsesLightTheme then
        bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha($dddddd,200)
      else
      begin
        if ParentColor then
            bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha(FParentColor,255)
        else
        begin
          if isWindows11 then
            bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BlendColors($2d2d2d, clBlack,25), 200)
          else
            bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha($222222,200);
        end;
      end;
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
        brush := TGPSolidBrush.Create(MakeGDIPColor(FDisabledColor));//any color for now
        try
          if not Enabled then
            pen := TGPPen.Create(MakeGDIPColor(DimColor(FDisabledColor, 30)))
          else
            pen := TGPPen.Create(MakeGDIPColor(FDisabledColor),2); // any color  for now
          try
            if FChecked then
            begin
              if FMouseHover then
                brush.SetColor(MakeGDIPColor(BlendColors(clWhite, FEnabledColor,20)))
              else
                brush.SetColor(MakeGDIPColor(FEnabledColor));
              if FMousePressed then
                brush.SetColor(MakeGDIPColor(FPressedColor));
              graph.FillPath(brush, path );
              brush.SetColor(MakeGDIPColor(clWhite));

              graph.FillEllipse(brush,MakeRect(Width-5-(h-10)-1,5,h-10,h-10));//white circle
            end
            else
            begin
              if FMousePressed then
              begin
                brush.SetColor(MakeGDIPColor(FPressedColor));
                graph.FillPath(brush, path );
                brush.SetColor(MakeGDIPColor(FDisabledColor));
              end
              else
              begin
                if not Enabled then
                  brush.SetColor(MakeGDIPColor(DimColor(FDisabledColor, 30)));


                graph.DrawArc(pen,l+1,t+1,d-2,d-2,180,90);
                graph.DrawLine(pen,l+s,t+1,l+w-s,t+1);
                graph.DrawArc(pen,l+w-d+1,t+1,d-2,d-2,270,90);
                graph.DrawLine(pen,l+w-1,t+s, l+w-1, t+h-s);
                graph.DrawArc(pen,l+w-d+1,t+h-d+1,d-2,d-2,0,90);
                graph.DrawArc(pen,l+1,t+h-d+1,d-2,d-2,90,90);
                graph.DrawLine(pen,l+s,t+h-1,l+w-s,t+h-1);
                graph.DrawLine(pen,l+1,t+s, l+1, t+h-s);
              end;

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
      //
      if FCaption <> '' then
      begin
      end;

    finally
      graph.Free;
    end;
    canvas.Draw(0,0,bmp);
  finally
    bmp.Free;
  end;

  if not (FLabeled and Assigned(FLabel)) then
  begin
  end;
end;

procedure TXCheckbox.RepaintLabel;
begin
  if Assigned(FLabel) then
  begin
    if Enabled then
      FLabel.Font.Color := Font.Color
    else
      FLabel.Font.Color := FDisabledColor;
    if not Checked then
      FLabel.Font.Color := FDisabledColor;

    FLabel.Repaint;

  end;
end;

procedure TXCheckbox.Resize;
begin
  inherited;
  Invalidate;
end;

procedure TXCheckbox.SetCaption(Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    if Assigned(FLabel) then
      FLabel.Caption := Value;

    Invalidate;
    RepaintLabel;
  end;
end;

procedure TXCheckbox.SetChecked(Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    Invalidate;
    RepaintLabel;
  end;
end;

procedure TXCheckbox.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    Invalidate;
  end;
end;

procedure TXCheckbox.SetEnabledColor(Value: TColor);
begin
  if FEnabledColor <> Value then
  begin
    FEnabledColor := Value;
    Invalidate;
    RepaintLabel;
  end;
end;

procedure TXCheckbox.SetLabeled(Value: Boolean);
begin
  if FLabeled <> Value then
  begin
    FLabeled := Value;
    if FLabeled then
    begin
      if not Assigned(FLabel) then
      begin
        FLabel := TXCheckBoxLabel.Create(Self);
        FLabel.Font := Font;
        if Checked then
          FLabel.Font.Color := Font.Color
        else
          FLabel.Font.Color := FDisabledColor;
        FLabel.Parent := Parent;
        FLabel.FreeNotification(Self);
      end;
      FLabel.Caption := FCaption;
      UpdateLabelPosition;
    end
    else if Assigned(FLabel) then
    begin
      FLabel.Free;
      FLabel := nil;
    end;
  end;
end;

procedure TXCheckbox.SetLabelPosition(Value: TLabelPosition);
begin
  if FLabelPosition <> Value then
  begin
    FLabelPosition := Value;
    UpdateLabelPosition;
  end;

end;

procedure TXCheckbox.SetLabelSpacing(Value: Integer);
begin
  if FLabelSpacing <> Value then
  begin
    FLabelSpacing := Value;
    UpdateLabelPosition;
  end;

end;

procedure TXCheckbox.SetParent(Value: TWinControl);
var
  ParentControl: TWinControl;
begin
  inherited;
  if (Value <> nil) and (FCaption = '') then
    FCaption := Name;
  if Assigned(FLabel) then
    FLabel.Parent := Value;
  RepaintLabel;

  // Let's get the parent color
  ParentControl := Value;
  while Assigned(ParentControl) do
  begin
    if ParentControl is TCustomForm then
    begin
      FParentColor := TCustomForm(ParentControl).Color;
      break;
    end;
    ParentControl := ParentControl.Parent;
  end;
end;

procedure TXCheckbox.SetPressedColor(Value: TColor);
begin
  if FPressedColor <> Value then
  begin
    FPressedColor := Value;
    Invalidate;
    RepaintLabel;
  end;
end;


procedure TXCheckbox.UpdateLabelPosition;
begin
  if Assigned(FLabel) then
  begin
    case FLabelPosition of
      lpLeft:
      begin
        FLabel.Left := Left - FLabel.Width - FLabelSpacing;
        FLabel.Top := Top + (Height - FLabel.Height) div 2;
      end;
      lpRight:
      begin
        FLabel.Left := Left + Width + FLabelSpacing;
        FLabel.Top := Top + (Height - FLabel.Height) div 2;
      end;
    end;
    RepaintLabel;
  end;
end;


end.

