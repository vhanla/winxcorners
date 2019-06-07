{
Changelog:
- 19-06-07
  Added GetVisibleCount to return count of visible items only
  Disabled automatic single monitor popup positioning TXMenuItems.Popup
- 15-10-11
  Added WS_EX_TOOLWINDOW to ex_style in order to make it dissappear from alt-tab
  Set to 44 item height to make it look like Windows 10 combo box menu size
  in order to make it look like start menu item size we need it to make it a modifiebable property if not

  Combo box height = 44
  Menu Item height = 30
  Font size = 12 both
}
unit XMenu;

interface

uses
  Windows, Messages, SysUtils, Forms, Classes, Controls, Graphics, GDIPAPI,GDIPAPIEXtra,
  XGraphics, DWMApi;

type
  TXPopupMenu = class;
  TXMenuItems = class;

  TXMenuItem = class
  private
    FText: String;
    FChecked: Boolean;
    FIndex: Integer;
    FData: Pointer;
    FParent: TXMenuItems;
    FItems: TXMenuItems;
    FAutoCheck: Boolean;
    FName: String;
    FVisible: Boolean;
    FOnClick: TNotifyEvent;

    procedure SetText(Value: String);
    procedure SetChecked(Value: Boolean);
    procedure SetVisible(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    property Data: Pointer read FData write FData;
  published
    property Name: String read FName write FName;
    property Text: String read FText write SetText;
    property Visible: Boolean read FVisible write SetVisible;
    property Checked: Boolean read FChecked write SetChecked default False;
    property AutoCheck: Boolean read FAutoCheck write FAutoCheck;
    property Index: Integer read FIndex nodefault;
    property Items: TXMenuItems read FItems;
    property Parent: TXMenuItems read FParent;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TArrowPos = (apLeftTop, apLeftBottom, apRightTop, apRightBottom);

  TXMenuItems = class
  private
    FZSize: TSize;
    FZPoint: TPoint;
    FZBF: TBlendFunction;
    FZTopLeft: TPoint;
    FDIB: TGdipDIB;
    FWND: HWND;
    FLeft, FTop, FWidth, FHeight: Integer;
    FItems: TList;
    FArrowPos: TArrowPos;
    FSelectIndex: Integer;
    FParent: TXMenuItem;
    FMenu: TXPopupMenu;
    FFade: Integer;
    FPopup: Boolean;

    function GetCount: Integer;
    function GetItem(Index: Integer): TXMenuItem;
    procedure SetSelectIndex(Value: Integer);
    function GetVisibleCount: Integer;
  protected
    procedure UpdateSize;

    function ItemRect(Index: Integer): TRect;
    function ItemAt(X, Y: Integer): Integer;

    procedure OnTimer(Index: Integer);
    procedure OnKillFocus;
    procedure OnMouseLeave;
    procedure OnMouseMove(X, Y: Integer);
    procedure OnClick(X, Y: Integer);

    procedure Popup(X, Y: Integer);
    procedure Hide;

    procedure DrawItem(Index: Integer);
    procedure DrawWindow;
    procedure Update;
    procedure Draw;
  public
    constructor Create;
    destructor Destroy; override;

    function Insert(Index: Integer): TXMenuItem;
    function Add: TXMenuItem;
    procedure Delete(Index: Integer);
    procedure Clear;

    property Count: Integer read GetCount;
    property VisibleCount: Integer read GetVisibleCount;
    property Items[Index: Integer]: TXMenuItem read GetItem; default;
    property SelectIndex: Integer read FSelectIndex write SetSelectIndex nodefault;
    property Parent: TXMenuItem read FParent;
    property Menu: TXPopupMenu read FMenu;
  end;

  TOnEventItems = procedure(Sender: TObject; Items: TXMenuItems) of object;

  TXPopupMenu = class(TComponent)
  private
    FItems: TXMenuItems;
    FOnPopup: TNotifyEvent;
    FOnPopupItems: TOnEventItems;
    FOnHide: TOnEventItems;

    function GetMenuItem(Name: String): TXMenuItem;
    function GetIsPopup: Boolean;
  protected
    procedure DoHideItems(Items: TXMenuItems);
    procedure DoPopupItems(Items: TXMenuItems);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Popup(X, Y: Integer);
    procedure Hide;

    property IsPopup: Boolean read GetIsPopup;
    property Items: TXMenuItems read FItems;
    property MenuItem[Name: String]: TXMenuItem read GetMenuItem; default;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
    property OnPopupItems: TOnEventItems read FOnPopupItems write FOnPopupItems;
    property OnHide: TOnEventItems read FOnHide write FOnHide;
  end;

  function CheckPopupWindow(hWnd: HWND): Boolean;
  function AnyOnePopupIsShowed: Boolean;
  procedure PopupHideAll;

implementation

uses Types;

const
  WndClassName = 'TXPopupWindow';
  ArrowSize = 1;
  Diameter = 1;
  ItemHeight = 44;
  MenuAlpha = 255;//210;
  FontSize = 12;
  FontName = 'Segoe UI';
  FontStyle = FontStyleRegular;

var
  WndClass: TWndClass =
  (
    style: CS_HREDRAW or CS_VREDRAW;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: NIL;
    lpszClassName: WndClassName;
  );
  WindowsList: TList;
  WindowParent: HWND;


{FreeFuncs}
procedure SetTopWindow(hwnd: HWND; Top: Boolean);
begin
  if Top then
  begin
    //SetWindowLong(hwnd, GWL_EXSTYLE, GetWindowLong(hwnd, GWL_EXSTYLE) or WS_EX_TOPMOST);
    SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or
      SWP_NOACTIVATE);
  end else
  begin
    //SetWindowLong(hwnd, GWL_EXSTYLE, GetWindowLong(hwnd, GWL_EXSTYLE) and not WS_EX_TOPMOST);
    SetWindowPos(hwnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or
      SWP_NOACTIVATE);
  end;
end;
{</FreeCFuncs}

function AnyOnePopupIsShowed: Boolean;
var
  i: Integer;
begin
  Result := False;
  i := 0;
  while (i < WindowsList.Count) do
  begin
    if TXMenuItems(WindowsList[i]).FPopup then
    begin
      Result := True;
      Break;
    end;
    inc(i);
  end;
end;

procedure PopupHideAll;
var
  i: Integer;
begin
  i := 0;
  while (i < WindowsList.Count) do
  begin
    if (TXMenuItems(WindowsList[i]).Parent = NIL) then
      TXMenuItems(WindowsList[i]).Hide;
    inc(i);
  end;
end;

function CheckPopupWindow(hWnd: HWND): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := 0;
  while (i < WindowsList.Count) do
  begin
    if (TXMenuItems(WindowsList[i]).FWND = hWnd) then
    begin
      Result := True;
      Break;
    end;
    inc(i);
  end;
end;

function XPopupWindowProc(hWnd: HWND; uMessage: UINT; wParam: UINT; lParam: UINT): LRESULT; stdcall;
var
  i, n: Integer;
  tme: TTRACKMOUSEEVENT;
  h: DWORD;
  DoHide: Boolean;
begin
  i := 0;
  while (i < WindowsList.Count) do
  begin
    with TXMenuItems(WindowsList[i]) do
    if (FWND = hWnd) then
    begin
      case uMessage of
        WM_TIMER:
          OnTimer(wParam);

        WM_KILLFOCUS:
        if FPopup then
        begin
          h := GetForegroundWindow;
          DoHide := True;
          n := 0;
          while (n < WindowsList.Count) do
          begin
            if (TXMenuItems(WindowsList[n]).FWND = h) then
            begin
              DoHide := False;
              Break;
            end;
            inc(n);
          end;
          if DoHide then
            OnKillFocus;
        end;

        WM_MOUSELEAVE:
          OnMouseLeave;

        WM_MOUSEMOVE:
        begin
          tme.cbSize := SizeOf(TTRACKMOUSEEVENT);
          tme.dwFlags := TME_LEAVE;
          tme.dwHoverTime := HOVER_DEFAULT;
          tme.hwndTrack := hWnd;
          TrackMouseEvent(tme);
          OnMouseMove(LOWORD(lParam), HIWORD(lParam));
        end;

        WM_LBUTTONDOWN:
          OnClick(LOWORD(lParam), HIWORD(lParam));
      end;
      Break;
    end;
    inc(i);
  end;
  Result := DefWindowProc(hWnd, uMessage, wParam, lParam);
end;

{ TXMenuItem }

constructor TXMenuItem.Create;
begin
  inherited;
  FText := '';
  FChecked := False;
  FIndex := -1;
  FAutoCheck := False;
  FVisible := True;
  FData := NIL;
  FParent := NIL;
  FItems := TXMenuItems.Create;
  FItems.FParent := Self;
  FOnClick := NIL;
end;

destructor TXMenuItem.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TXMenuItem.SetChecked(Value: Boolean);
begin
  if (Value <> FChecked) then
  begin
    FChecked := Value;
    if Assigned(FParent) and (FIndex >= 0) then
      FParent.DrawItem(FIndex);
  end;
end;

procedure TXMenuItem.SetText(Value: String);
begin
  FText := Value;
  if Assigned(FParent) and (FIndex >= 0) then
    FParent.DrawItem(FIndex);
end;

procedure TXMenuItem.SetVisible(Value: Boolean);
begin
  if (Value <> FVisible) then
  begin
    FVisible := Value;
    if Assigned(FParent) and (FIndex >= 0) then
    begin
      FParent.UpdateSize;
      FParent.Draw;
    end;
  end;
end;

{ TXMenuItems }

constructor TXMenuItems.Create;
begin
  inherited;
  FWND := CreateWindow(WndClassName, #0, WS_POPUP, 0, 0, 0, 0, WindowParent, 0, HInstance, NIL);
  SetWindowLong(FWND, GWL_EXSTYLE, GetWindowLong(FWND, GWL_EXSTYLE) or WS_EX_LAYERED or WS_EX_TOOLWINDOW );

  FZPoint := Point(0, 0);
  with FZBF do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    AlphaFormat := AC_SRC_ALPHA;
    SourceConstantAlpha := 255;
  end;

  FPopup := False;
  FDIB := TGdipDIB.Create(1, 1);
  FItems := TList.Create;
  FSelectIndex := -1;
  FParent := NIL;
  FMenu := NIL;

  WindowsList.Add(Self);
end;

destructor TXMenuItems.Destroy;
begin
  WindowsList.Remove(Self);

  Clear;
  FItems.Free;
  FDIB.Free;
  DestroyWindow(FWND);
  inherited;
end;

function TXMenuItems.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TXMenuItems.GetItem(Index: Integer): TXMenuItem;
begin
  Result := FItems[Index];
end;

function TXMenuItems.GetVisibleCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0  to FItems.Count - 1 do
  begin
    if TXMenuItem(FItems[I]).Visible then
      Result := Result + 1;
  end;
end;

procedure TXMenuItems.SetSelectIndex(Value: Integer);
var
  i: Integer;
begin
  if (Value <> FSelectIndex) then
  begin
    i := FSelectIndex;
    FSelectIndex := Value;
    if (i >= 0) and (i < FItems.Count) then
      DrawItem(i);
    if (FSelectIndex >= 0) and (FSelectIndex < FItems.Count) then
      DrawItem(FSelectIndex);
    Update;
  end;
end;

function TXMenuItems.Insert(Index: Integer): TXMenuItem;
var
  p: TXMenuItem;
begin
  p := TXMenuItem.Create;
  p.FIndex := Index;
  p.FParent := Self;
  p.FItems.FMenu := FMenu;
  FItems.Insert(Index, p);
  Result := p;
end;

function TXMenuItems.Add: TXMenuItem;
begin
  Result := Insert(FItems.Count);
end;

procedure TXMenuItems.Delete(Index: Integer);
begin
  TXMenuItem(FItems[Index]).Free;
  FItems.Delete(Index);
end;

procedure TXMenuItems.Clear;
var
  i: Integer;
begin
  for i:= 0 to FItems.Count - 1 do
    TXMenuItem(FItems[i]).Free;
  FItems.Clear;
end;

function TXMenuItems.ItemRect(Index: Integer): TRect;
var
  i: Integer;
begin
  FillChar(Result, SizeOf(TRect), 0);
  if (Index < 0) or (Index >= FItems.Count) then Exit;
  Result.Left := 4;
  Result.Right := FWidth - 14;
  Result.Top := 3 + Diameter div 2;
  for i:= 0 to Index - 1 do
  if TXMenuItem(FItems[i]).Visible then
  if (TXMenuItem(FItems[i]).Text = '-') then // is line
    inc(Result.Top, 3)
  else
    inc(Result.Top, ItemHeight);
  case FArrowPos of
    apLeftTop, apRightTop:
      inc(Result.Top, ArrowSize div 2 * Integer(FParent = NIL));
  end;
  if (TXMenuItem(FItems[Index]).Text = '-') then
    Result.Bottom := Result.Top + 3
  else
    Result.Bottom := Result.Top + ItemHeight;
end;

function TXMenuItems.ItemAt(X, Y: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:= 0 to FItems.Count - 1 do
  if TXMenuItem(FItems[i]).Visible and PtInRect(ItemRect(i), Point(X, Y)) then
  begin
    Result := i;
    Break;
  end;
end;

procedure TXMenuItems.UpdateSize;
var
  i: Integer;
begin
  FDIB.SetFont(FontName, FontSize, FontStyle);
  FHeight := ArrowSize div 2 * Integer(FParent = NIL) + Diameter + 16;
  FWidth := 0;
  for i:= 0 to FItems.Count - 1 do
  if TXMenuItem(FItems[i]).Visible then
  begin
    with FDIB.TextSize(TXMenuItem(FItems[i]).Text) do
    if (FWidth < cx) then FWidth := cx;
    if (TXMenuItem(FItems[i]).Text = '-') then // is line
    inc(FHeight, 3) else inc(FHeight, ItemHeight);
  end;
  inc(FWidth, 49);
  FZSize.cx := FWidth;
  FZSize.cy := FHeight;
  FDIB.NewDIB(FWidth, FHeight);
end;

procedure TXMenuItems.Popup(X, Y: Integer);

function AnyOneVisible: Boolean;
var
  i: Integer;
begin
  Result := True;
  for i:= 0 to FItems.Count - 1 do
  if TXMenuItem(FItems[i]).Visible then
  begin
    Result := False;
    Break;
  end;
end;

begin
  if Assigned(FMenu) then
    FMenu.DoPopupItems(Self);
  if (FItems.Count = 0) or AnyOneVisible then Exit;
  UpdateSize;
  FLeft := X;
  FTop := Y;
  //if (FLeft + FWidth < GetSystemMetrics(SM_CXSCREEN)) then
  begin
    dec(FLeft, ArrowSize div 2 + Diameter div 2 + 3);
    if (FTop + FHeight > GetSystemMetrics(SM_CYSCREEN)) then
    begin
      FArrowPos := apLeftBottom;
      dec(FTop, FHeight + 2 - 8);
      if (FParent <> NIL) then
        inc(FTop, 37);
    end else
    begin
      FArrowPos := apLeftTop;
      inc(FTop, 1);
    end;
  end {else
  begin
    if Assigned(FParent) then
      dec(FLeft, FWidth + FParent.Parent.FWidth - 18)
    else
      inc(FLeft, ArrowSize div 2 + Diameter div 2 - FWidth + 14);
    if (FTop + FHeight > GetSystemMetrics(SM_CYSCREEN)) then
    begin
      FArrowPos := apRightBottom;
      dec(FTop, FHeight + 2 - 8);
      if (FParent <> NIL) then
        inc(FTop, 37);
    end else
    begin
      FArrowPos := apRightTop;
      inc(FTop, 1);
    end;
  end};
  FSelectIndex := -1;
  FFade := 0;
  Draw;
  FPopup := True;
  KillTimer(FWND, 1);
  SetTimer(FWND, 1, 30, NIL);

  ShowWindow(FWND, SW_SHOWNOACTIVATE);
  SetTopWindow(FWND, True);

  //DockSounds.Play(SOUND_ONPOPUPMENU);
end;

procedure TXMenuItems.Hide;

procedure HideItems(Items: TXMenuItems);
var
  i: Integer;
begin
  if Items.FPopup then
  begin
    Items.FPopup := False;
    KillTimer(Items.FWND, 1);
    KillTimer(Items.FWND, 2);
    ShowWindow(Items.FWND, SW_HIDE);
    i := 0;
    while (i < Items.Count) do
    begin
      HideItems(Items[i].Items);
      inc(i);
    end;
  end;
end;

begin
  if FPopup then
  begin
    HideItems(Self);
    if Assigned(FMenu) then
      FMenu.DoHideItems(Self);
    //DockSounds.Play(SOUND_ONHIDEPOPUPMENU);
  end;
end;

procedure TXMenuItems.DrawItem(Index: Integer);
var
  r: TRect;
  rf: TGPRectF;
  Path: GpPath;
  Brush: GpBrush;
  Points: array[0..2] of TGPPointF;
  IsLine: Boolean;
  x, y: Integer;
  p: PARGB;

  //this is to get colorization from dwmapi
  dwmcol: cardinal;
  dwmopaque: longbool;
begin
  if (Index < 0) or (Index >= FItems.Count) or not TXMenuItem(FItems[Index]).Visible then Exit;

  IsLine := (TXMenuItem(FItems[Index]).Text = '-');
  r := ItemRect(Index);

  GdipSetSmoothingMode(FDIB.GPContext, SmoothingModeDefault);
  GdipSetCompositingMode(FDIB.GPContext, CompositingModeSourceCopy);

  if not IsLine and (FSelectIndex = Index) then
  begin
    rf.X := r.Left;
    rf.Y := r.Top - 1;
    rf.Width := r.Right - r.Left;
    rf.Height := r.Bottom - r.Top;

    DwmGetColorizationColor(dwmcol , dwmopaque);
   { GdipCreateLineBrushFromRect(@rf, ARGBMake(Round(255 * FFade / 3), $60, $A0, $FF),
      ARGBMake(255, $20, $60, $FF), LinearGradihideentModeVertical, WrapModeTile, Brush); }
   // Colorized menu item
    GdipCreateLineBrushFromRect(@rf, ARGBMake(Byte(dwmcol shr 24), Byte(dwmcol shr 16), Byte(dwmcol shr 8), Byte(dwmcol)),
      ARGBMake(Byte(dwmcol shr 24), Byte(dwmcol shr 16), Byte(dwmcol shr 8), Byte(dwmcol)),
       LinearGradientModeVertical, WrapModeTile, Brush);

    GdipFillRectangle(FDIB.GPContext, Brush, r.Left, r.Top,
      r.Right - r.Left, r.Bottom - r.Top);
    GdipDeleteBrush(Brush);
  end else
  begin
    FDIB.SetBrush(ARGBMake(Round(MenuAlpha * FFade / 3), $E6, $E6, $E6));
    GdipFillRectangle(FDIB.GPContext, FDIB.GPSolidBrush, r.Left, r.Top,
      r.Right - r.Left, r.Bottom - r.Top);
  end;

  GdipSetSmoothingMode(FDIB.GPContext, SmoothingModeAntiAlias);
  GdipSetCompositingMode(FDIB.GPContext, CompositingModeSourceOver);
  GdipSetTextRenderingHint(FDIB.GPContext, TextRenderingHintClearTypeGridFit);//GdipSetTextRenderingHint(FDIB.GPContext, TextRenderingHintAntiAlias);

  if IsLine then
  begin
    FDIB.SetPen(ARGBMake(Round(230 * FFade / 3), $C0, $C0, $C0), 1);
    GdipDrawLine(FDIB.GPContext, FDIB.GPPen, r.Left, r.Top + 1, r.Right - 1, r.Top + 1);
  end else
  begin
    if (FSelectIndex = Index) then
      FDIB.SetBrush(ARGBMake(Round(255 * FFade / 3), $F0, $F0, $F0))
    else
      FDIB.SetBrush(ARGBMake(Round(255 * FFade / 3), $00, $00, $00));
    inc(r.Left, 15);
    dec(r.Right, 10);
    FDIB.SetFont(FontName, FontSize, FontStyle);
    FDIB.SetStringAlign(StringAlignmentNear, StringAlignmentCenter);
    FDIB.DrawString(r, TXMenuItem(FItems[Index]).Text);

    // check text
    if (FFade = 3) then
    for y:= r.Top to r.Bottom - 1 do
    for x:= r.Left to r.Right - 1 do
    begin
      p := FDIB.Pixels[x, y];
      if (p^.a = 0) then
        p^.a := 255;
    end;

    if (TXMenuItem(FItems[Index]).Items.Count > 0) then
    begin
      if (FSelectIndex = Index) then
        FDIB.SetBrush(ARGBMake(Round(255 * FFade / 3), $F0, $F0, $F0))
      else
        FDIB.SetBrush(ARGBMake(Round(255 * FFade / 3), $50, $50, $50));
      GdipCreatePath(FillModeAlternate, Path);
      Points[0].X := r.Right + 1;
      Points[0].Y := r.Top + ItemHeight div 4;
      Points[1].X := r.Right + 6;
      Points[1].Y := r.Top + ItemHeight div 2;
      Points[2].X := r.Right + 1;
      Points[2].Y := r.Bottom - ItemHeight div 4;
      GdipAddPathLine2(Path, @Points, 3);
      GdipClosePathFigure(Path);
      GdipFillPath(FDIB.GPContext, FDIB.GPSolidBrush, Path);
      GdipDeletePath(Path);
    end;

    if TXMenuItem(FItems[Index]).Checked then
    begin
      if (FSelectIndex = Index) then
        FDIB.SetPen(ARGBMake(Round(255 * FFade / 3), $F0, $F0, $F0), 2)
      else
        FDIB.SetPen(ARGBMake(Round(255 * FFade / 3), $50, $50, $50), 2);
      GdipCreatePath(FillModeAlternate, Path);
      GdipAddPathLine(Path, 8, r.Bottom - 10 , 11, r.Bottom - 6);
      GdipClosePathFigure(Path);
      GdipAddPathLine(Path, 11, r.Bottom - 6, 16, r.Top + 5);
      GdipClosePathFigure(Path);
      GdipDrawPath(FDIB.GPContext, FDIB.GpPen, Path);
      GdipDeletePath(Path);
    end;
  end;
end;

procedure TXMenuItems.DrawWindow;
var
  Path: GpPath;
  Tmp: TGdipBitmap;
  Shadow: GpBitmap;
  Context: GpGraphics;
  ShadowAttr: GpImageAttributes;
  Points: array[0..2] of TGPPointF;
  ColorMatrix: TColorMatrix;
begin
  FDIB.Fill;
  GdipCreatePath(FillModeAlternate, Path);

  Tmp := TGdipBitmap.Create(FDIB.Width - 3 - 5, FDIB.Height - 3 - 5);

(*  case FArrowPos of
    apLeftTop:
    begin
      GdipAddPathArc(Path, 3, 3 + ArrowSize div 2 * Integer(FParent = NIL), Diameter - 1, Diameter - 1, 180, 90);
      GdipAddPathArc(Path, Tmp.Width - 5 - Diameter, 3 + ArrowSize div 2 * Integer(FParent = NIL), Diameter - 1, Diameter - 1, 270, 90);
      GdipAddPathArc(Path, Tmp.Width - 5 - Diameter, Tmp.Height - 5 - Diameter, Diameter - 1, Diameter - 1, 0, 90);
      GdipAddPathArc(Path, 3, Tmp.Height - 5 - Diameter, Diameter - 1, Diameter - 1, 90, 90);
      GdipClosePathFigure(Path);

      if (FParent = NIL) then
      begin
        Points[0].X := 3 + Diameter div 2;
        Points[1].X := 3 + Diameter div 2 + ArrowSize;
        Points[2].X := 3 + Diameter div 2 + ArrowSize div 2;
        Points[0].Y := 3 + ArrowSize div 2;
        Points[1].Y := 3 + ArrowSize div 2;
        Points[2].Y := 3;
        GdipAddPathLine2(Path, @Points, 3);
        GdipClosePathFigure(Path);
      end;
    end;

    apLeftBottom:
    begin
      GdipAddPathArc(Path, 3, 3, Diameter - 1, Diameter - 1, 180, 90);
      GdipAddPathArc(Path, Tmp.Width - 5 - Diameter, 3, Diameter - 1, Diameter - 1, 270, 90);
      GdipAddPathArc(Path, Tmp.Width - 5 - Diameter, Tmp.Height - 5 - Diameter - ArrowSize div 2 * Integer(FParent = NIL), Diameter - 1, Diameter - 1, 0, 90);
      GdipAddPathArc(Path, 3, Tmp.Height - 5 - Diameter - ArrowSize div 2 * Integer(FParent = NIL), Diameter - 1, Diameter - 1, 90, 90);
      GdipClosePathFigure(Path);

      if (FParent = NIL) then
      begin
        Points[0].X := 3 + Diameter div 2;
        Points[1].X := 3 + Diameter div 2 + ArrowSize;
        Points[2].X := 3 + Diameter div 2 + ArrowSize div 2;
        Points[0].Y := Tmp.Height - 5 - 1 - ArrowSize div 2;
        Points[1].Y := Tmp.Height - 5 - 1 - ArrowSize div 2;
        Points[2].Y := Tmp.Height - 5;
        GdipAddPathLine2(Path, @Points, 3);
        GdipClosePathFigure(Path);
      end;
    end;

    apRightTop:
    begin
      GdipAddPathArc(Path, 3, 3 + ArrowSize div 2 * Integer(FParent = NIL), Diameter - 1, Diameter - 1, 180, 90);
      GdipAddPathArc(Path, Tmp.Width - 5 - Diameter, 3 + ArrowSize div 2 * Integer(FParent = NIL), Diameter - 1, Diameter - 1, 270, 90);
      GdipAddPathArc(Path, Tmp.Width - 5 - Diameter, Tmp.Height - 5 - Diameter, Diameter - 1, Diameter - 1, 0, 90);
      GdipAddPathArc(Path, 3, Tmp.Height - 5 - Diameter, Diameter - 1, Diameter - 1, 90, 90);
      GdipClosePathFigure(Path);

      if (FParent = NIL) then
      begin
        Points[0].X := Tmp.Width - 5 - 1 - Diameter div 2;
        Points[1].X := Tmp.Width - 5 - 1 - Diameter div 2 - ArrowSize;
        Points[2].X := Tmp.Width - 5 - 1 - Diameter div 2 - ArrowSize div 2;
        Points[0].Y := 3 + ArrowSize div 2;
        Points[1].Y := 3 + ArrowSize div 2;
        Points[2].Y := 3;
        GdipAddPathLine2(Path, @Points, 3);
        GdipClosePathFigure(Path);
      end;
    end;

    apRightBottom:
    begin
      GdipAddPathArc(Path, 3, 3, Diameter - 1, Diameter - 1, 180, 90);
      GdipAddPathArc(Path, Tmp.Width - 5 - Diameter, 3, Diameter - 1, Diameter - 1, 270, 90);
      GdipAddPathArc(Path, Tmp.Width - 5 - Diameter, Tmp.Height - 5 - Diameter - ArrowSize div 2 * Integer(FParent = NIL), Diameter - 1, Diameter - 1, 0, 90);
      GdipAddPathArc(Path, 3, Tmp.Height - 5 - Diameter - ArrowSize div 2 * Integer(FParent = NIL), Diameter - 1, Diameter - 1, 90, 90);
      GdipClosePathFigure(Path);

      if (FParent = NIL) then
      begin
        Points[0].X := Tmp.Width - 5 - 1 - Diameter div 2;
        Points[1].X := Tmp.Width - 5 - 1 - Diameter div 2 - ArrowSize;
        Points[2].X := Tmp.Width - 5 - 1 - Diameter div 2 - ArrowSize div 2;
        Points[0].Y := Tmp.Height - 5 - 1 - ArrowSize div 2;
        Points[1].Y := Tmp.Height - 5 - 1 - ArrowSize div 2;
        Points[2].Y := Tmp.Height - 5;
        GdipAddPathLine2(Path, @Points, 3);
        GdipClosePathFigure(Path);
      end;
    end;
  end;*)

  FDIB.SetBrush(ARGBMake(Round(MenuAlpha * FFade / 3), $E6, $E6, $E6));
  GdipGetImageGraphicsContext(Tmp.GPBitmap, Context);
  GdipFillPath(Context, FDIB.GPSolidBrush, Path);
  GdipDeleteGraphics(Context);

  GdipGetImageThumbnail(Tmp.GPBitmap, Tmp.Width div 4, Tmp.Height div 4, Shadow, NIL, NIL);
  GdipCreateImageAttributes(ShadowAttr);

  ColorMatrix := _ColorMatrix;
  ColorMatrix[0, 0] := 0;
  ColorMatrix[1, 1] := 0;
  ColorMatrix[2, 2] := 0;
  ColorMatrix[3, 3] := 0.45;

  GdipSetImageAttributesColorMatrix(ShadowAttr, ColorAdjustTypeDefault, True,
    @ColorMatrix, NIL, ColorMatrixFlagsDefault);

  GdipDrawImageRectRect(FDIB.GPContext, Shadow,
    0, 0, FDIB.Width, FDIB.Height,
    0, 0, Tmp.Width div 4, Tmp.Height div 4,
    UnitPixel, ShadowAttr, NIL, NIL);

  GdipSetImageAttributesColorMatrix(ShadowAttr, ColorAdjustTypeDefault, False,
    NIL, NIL, ColorMatrixFlagsDefault);

  GdipFillPath(FDIB.GPContext, FDIB.GPSolidBrush, Path);

  Tmp.Free;
  GdipDisposeImage(Shadow);
  GdipDisposeImageAttributes(ShadowAttr);
  GdipDeletePath(Path);
end;

procedure TXMenuItems.Update;
begin
  FZTopLeft.X := FLeft;
  FZTopLeft.Y := FTop;
  UpdateLayeredWindow(FWND, 0, @FZTopLeft, @FZSize, FDIB.DC, @FZPoint, 0, @FZBF, ULW_ALPHA);
end;

procedure TXMenuItems.Draw;
var
  i: Integer;
begin
  DrawWindow;
  for i:= 0 to FItems.Count - 1 do
    DrawItem(i);
  Update;
end;

procedure TXMenuItems.OnMouseMove(X, Y: Integer);
var
  i: Integer;
begin
  i := ItemAt(X, Y);
  if (i >= 0) and (i <> SelectIndex) then
  begin
    if (SelectIndex >= 0) then
      TXMenuItem(FItems[SelectIndex]).Items.Hide;
    KillTimer(FWND, 2);
    if (FItems.Count > 0) and (i < FItems.Count) then
    begin
      SetSelectIndex(i);
      if (TXMenuItem(FItems[i]).Items.Count > 0) then
        SetTimer(FWND, 2, 300, NIL);
    end else
      SetSelectIndex(-1);
  end else
  if (i < 0) then
  begin
    if (SelectIndex >= 0) then
      TXMenuItem(FItems[SelectIndex]).Items.Hide;
    SetSelectIndex(-1);
  end;
end;

procedure TXMenuItems.OnMouseLeave;
begin
  if (SelectIndex >= 0) and (SelectIndex < FItems.Count) and
    (WindowFromPoint(Mouse.CursorPos) <> TXMenuItem(FItems[SelectIndex]).Items.FWND) then
  begin
    TXMenuItem(FItems[SelectIndex]).Items.Hide;
    SetSelectIndex(-1);
  end;
end;

procedure TXMenuItems.OnClick(X, Y: Integer);
var
  i: Integer;
begin
  i := ItemAt(X, Y);
  if (i >= 0) then
  begin
    if TXMenuItem(FItems[i]).AutoCheck then
      TXMenuItem(FItems[i]).Checked := not TXMenuItem(FItems[i]).Checked;
    if Assigned(TXMenuItem(FItems[i]).FOnClick) then
      TXMenuItem(FItems[i]).FOnClick(FItems[i]);
    if (i < FItems.Count) and Assigned(TXMenuItem(FItems[i]).FOnClick) or
      (TXMenuItem(FItems[i]).Items.Count = 0) then
      OnKillFocus;
    //DockSounds.Play(SOUND_ONSELECTPOPUPMENU);
  end;
end;

procedure TXMenuItems.OnKillFocus;
var
  Items: TXMenuItems;
begin
  if FPopup then
  begin
    Items := Self;
    while (Items.Parent <> NIL) do
      Items := Items.Parent.Parent;
    Items.Hide;
  end;
end;

procedure TXMenuItems.OnTimer(Index: Integer);
begin
  case Index of
    1: // fade
    begin
      if (FFade + 1 >= 3) then
      begin
        FFade := 3;
        KillTimer(FWND, 1);
      end else
        inc(FFade);
      Draw;
    end;

    2: // show sub menu
    begin
      if (FSelectIndex >= 0) then
      TXMenuItem(FItems[FSelectIndex]).Items.Popup(
        FLeft + FWidth, FTop + ItemRect(FSelectIndex).Top - 8);
      KillTimer(FWND, 2);
    end;
  end;
end;

{ TXPopupMenu }

constructor TXPopupMenu.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TXMenuItems.Create;
  FItems.FMenu := Self;
end;

destructor TXPopupMenu.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TXPopupMenu.GetMenuItem(Name: String): TXMenuItem;

function FindNext(Items: TXMenuItems): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i:= 0 to Items.Count - 1 do
  if SameText(Items[i].Name, Name) then
  begin
    GetMenuItem := Items[i];
    Result := True;
    Break;
  end;
  if not Result then
  for i:= 0 to Items.Count - 1 do
  if FindNext(Items[i].Items) then
    Break;
end;

begin
  FindNext(FItems);
end;

procedure TXPopupMenu.Hide;
begin
  FItems.Hide;
end;

procedure TXPopupMenu.DoHideItems(Items: TXMenuItems);
begin
  if Assigned(FOnHide) then
    FOnHide(Self, Items);
end;

procedure TXPopupMenu.DoPopupItems(Items: TXMenuItems);
begin
  if Assigned(FOnPopupItems) then
    FOnPopupItems(Self, Items);
end;

procedure TXPopupMenu.Popup(X, Y: Integer);
begin
  FItems.Hide;
  if Assigned(FOnPopup) then
    FOnPopup(Self);
  FItems.Popup(X, Y);
end;

function TXPopupMenu.GetIsPopup: Boolean;
begin
  Result := FItems.FPopup;
end;

initialization
  WndClass.lpfnWndProc := @XPopupWindowProc;
  WndClass.hInstance := HInstance;
  Windows.RegisterClass(WndClass);
  WindowsList := TList.Create;
  WindowParent := CreateWindow(WndClassName, #0, WS_POPUP, 0, 0, 0, 0, 0, 0, HInstance, NIL);

finalization
  DestroyWindow(WindowParent);
  WindowsList.Free;

end.

