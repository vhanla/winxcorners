{
Changelog:
- 23-05-07
  Added partial HiDPI support
- 21-04-22
  Switched to UWP component
- 20-09-08
  Replaced XPopupMenu(XMenu) with newer custom UCL.Popup
- 20-09-01
  Replaced OnShow animation with AnyiQuack
- 20-08-14
  Replaced popup menu with UCL.Popup, simpler
- 19-06-10
  Fixed window resize on screen resolution change
  using WM_DISPLAYCHANGE event
- 17-06-03
  Added multimonitor support
- 16-08-05
  Fixed on show easing updateposition to correctly show the window in the taskbar location relative
- 16-02-28
  FadeIn animation added
- 02-11-15
  FormStyle = TopMost since it won't show if another topmost is in front
- 15-10-15
  Added Timer3 in order to monitor taskbar position changes

  Changed checkbox usability, now it will be used as temporal disabler
  Fixed OnDeactivate using a timer2 to monitor if user clicked the taskbar
  that also fixes losing focus when systray popup is launched
  and to avoid double clicking before calling popup disable timer2
  Timer1 disables after detecting user has focused on another window different
  than taskbar or our app window
  Firest working version

  Added Logo about
  Functionl as it seems, it is working well

- 15-10-14
  Replaced TTransparentCanvas with functions to create alpha channel aware brushes to
  paint with thanks to Delphi Haven
  Update Paint function to use custom brushes with alpha values
- 15-10-13
  Added Animation from bottom, left top or right
  Replaced TImages with TTransparentCanvas
- 15-10-12
  Added XPopupMenu
- 15-10-11
  Aero Glass, rewrite from scratch
}
unit frmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  {XMenu,} XGraphics, PNGimage, GDIPApi, GDIPObj,  XCheckbox ,XCombobox ,
  Registry, IniFiles, DateUtils, AnimateEasing, Math, UCL.Popup, UWP.ListButton,
  UWP.Form, UWP.ColorManager;

type
  TFadeType = (ftIn, ftOut);
  TTaskbarPosition = (tpBottom, tpRight, tpTop, tpLeft); // using the taskbar position as guide
  TfrmTrayPopup = class(TForm)
    imgScreenShape: TImage;
    Label1: TLabel;
    tmrTaskbarFocus: TTimer;
    tmrUpdatePosition: TTimer;
    pnlPopup: TPanel;
    ulbAllWindows: TUWPListButton;
    ulbDesktop: TUWPListButton;
    ulbScreenSaver: TUWPListButton;
    ulbMonitorsOff: TUWPListButton;
    ulbActionCenter: TUWPListButton;
    ulbCustomCommand: TUWPListButton;
    ulbHideOthers: TUWPListButton;
    ulbNoAction: TUWPListButton;
    ulbStartMenu: TUWPListButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure XMenuItemClick(Sender: TObject);
    procedure OnCornerOptionEnter(Sender: TObject);
    procedure OnCornerOptionLeave(Sender: TObject);
    procedure OnCornerOptionClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure OnCheckBoxClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrTaskbarFocusTimer(Sender: TObject);
    procedure tmrUpdatePositionTimer(Sender: TObject);
  private
    { Private declarations }
    CornerOption : TXCombobox;
    MaxTop, MaxLeft : Integer;
    WinPosition: TTaskbarPosition;
    //fFadeType: TFadeType;
    PopMenu: TFormPopup;
    procedure CloseApp(Sender: TObject);
    procedure UpdateColorization;
    procedure UpdatePosition;
    procedure PopupMenuPopup(Sender: TObject);
    procedure InitCustomComponents;
    procedure GetTaskbarMonitor;
    procedure ShowPopup(X,Y: Integer);
    procedure ClosePopup;

    //property FadeType: TFadeType read fFadeType write fFadeType;
  protected
    { Like private but accessible from subclasses}
    procedure WndProc(var Msg: TMessage); override;
    procedure ChangeScale(M, D: Integer; DpiChanged: Boolean); override;
  public
    { Public declarations }
    tempDisabled: Boolean;
    //XPopupMenu: TXPopupMenu;
    XCheckbox1: TXCheckbox;
    XCombo1,XCombo2,XCombo3,XCombo4,XComboAsLabel: TXCombobox;
    //easeT, easeB, easeC, easeD: LongInt;
    procedure SaveINI;
    procedure LoadINI;
    procedure UpdateXCombos;
  end;

var
  frmTrayPopup: TfrmTrayPopup;
  Shell_TrayWnd: HWND;
  Shell_TrayWndRect: TRect;
  Screen1: TRect;

implementation

uses
  functions, main, AnyiQuack, AQPSystemTypesAnimations;
{$R *.dfm}

procedure TfrmTrayPopup.ChangeScale(M, D: Integer; DpiChanged: Boolean);
begin
  inherited;
  Width := MulDiv(420, Self.PixelsPerInch, 96);
  Height := MulDiv(270, Self.PixelsPerInch, 96);
end;

procedure TfrmTrayPopup.CloseApp(Sender: TObject);
begin
  //XPopupMenu.Hide;
  ClosePopup;
  if GetForegroundWindow = FindWindow('Shell_TrayWnd',nil) then
  begin
    //start timer that will look if user  get's a different foregound
    tmrTaskbarFocus.Enabled := True;
    tmrUpdatePosition.Enabled := True; // to prevnt app window stay in a poits position if user moves taskbar
  end
  else
    Close;
end;

procedure TfrmTrayPopup.ClosePopup;
begin
  if Assigned(PopMenu) then
  begin
    FreeAndNil(PopMenu);
  end;
end;

procedure TfrmTrayPopup.FormClose(Sender: TObject; var Action: TCloseAction);
  procedure Delay(msec: LongInt);
  var
    start,stop: LongInt;
  begin
    start := GetTickCount;
    repeat
      stop := GetTickCount;
      Application.ProcessMessages;
    until (stop-start)>=msec;

  end;
//var
//  Screen1: TRect;
begin

  Action := caNone;


//  begin
//  //Screen1 := GetRectOfPrimaryMonitor(False);
//  GetTaskbarMonitor;
//  case WinPosition of
//    tpBottom:
//    begin
//      repeat
//        if Top < Screen1.Height then  Top := Top + 50;
//        delay(10);
//      until (Top >= Screen1.Height) ;//or ( Form2.Visible);
//    end;
//    tpRight:
//    begin
//      repeat
//        if Left < Screen1.Left then  Left := Left + 50;
//        delay(10);
//      until Left >= Screen1.Left;
//    end;
//    tpTop:
//    begin
//      repeat
//        if Top > Screen1.Top then  Top := Top - 50;
//        delay(10);
//      until Top <= Screen1.Top;
//    end;
//    tpLeft:
//    begin
//      repeat
//        if Left > Screen1.Left then  Left := Left - 50;
//        delay(10);
//      until Left <= Screen1.Left;
//    end;
//  end;
//  end;
  Action := caHide;

  // fade animation
  AlphaBlendValue := 0;
end;

procedure TfrmTrayPopup.FormCreate(Sender: TObject);
var
  DPI: Integer;
begin
  Width := MulDiv(420, Screen.PixelsPerInch, 96);
  Height := MulDiv(270, Screen.PixelsPerInch, 96);
  // initialize the custom components before using them, it will be destroyed on OnDestroy
  InitCustomComponents;

  Width := XCombo1.Width + XCombo2.Width + imgScreenShape.Width;

  DoubleBuffered := True;
  Color := clBlack;
  BorderStyle := bsNone;

  imgScreenShape.Stretch := True;
  // set the correct colorization settings as well as blur aero
  UpdateColorization;

  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);

  Application.OnDeactivate := CloseApp;

  // Create the popup menu to select the hot corner's behavior
{  XPopupMenu := TXPopupMenu.Create(nil);
  XPopupMenu.OnPopup := PopupMenuPopup;

  with XPopupMenu.Items.Add do
  begin
    Name := 'N1';
    Text := 'All Windows';
    OnClick := XMenuItemClick;
  end;

  with XPopupMenu.Items.Add do
  begin
    Name := 'N2';
    Text := 'Desktop';
    OnClick := XMenuItemClick;
  end;

  with XPopupMenu.Items.Add do
  begin
    Name := 'N3';
    Text := 'Start Screen Saver';
    OnClick := XMenuItemClick;
  end;

  with XPopupMenu.Items.Add do
  begin
    Name := 'N4';
    Text := 'Monitors Off';
    OnClick := XMenuItemClick;
  end;

  with XPopupMenu.Items.Add do
  begin
    Name := 'N5';
    Text := 'Action Center';
    OnClick := XMenuItemClick;
  end;

  with XPopupMenu.Items.Add do
  begin
    Name := 'N6';
    Text := 'Custom Command';
    OnClick := XMenuItemClick;
    Visible := False;
  end;

  with XPopupMenu.Items.Add do
  begin
    Name := 'N7';
    Text := 'Hide Other Windows';
    OnClick := XMenuItemClick;
  end;

  with XPopupMenu.Items.Add do
  begin
    Name := 'N0';
    Text := '';
    OnClick := XMenuItemClick;
  end;}

  //UpdatePosition;
//  FormPaint(Self);

  LoadINI;

  tempDisabled := False;

  // precalculate starting details for easing animation
 { case WinPosition of
    tpBottom:
    begin
      easeB := Shell_TrayWndRect.Top; //starting position
      Top := Shell_TrayWndRect.Bottom + Height;
    end;
    tpRight:
    begin
      easeB := Shell_TrayWndRect.Left;
      Left := Shell_TrayWndRect.Right + Width;
    end;
    tpTop:
    begin
      easeB := Shell_TrayWndRect.Bottom; //starting position
      Top := Shell_TrayWndRect.Top - Height;
    end;
    tpLeft:
    begin
      easeB := Shell_TrayWndRect.Right;
      Left := Shell_TrayWndRect.Left - Width;
    end;
  end;}
//  tmrAnimation.Enabled := False;
//  tmrAnimation.Interval := 3;

  // fading animation
  AlphaBlend := True;
  //AlphaBlendValue := 0;
//  fFadeType := ftIn;
//  EnableBlur(Handle);

  if isWindows11 then
  begin
    for var I := 0 to ComponentCount - 1 do
    begin
      if Components[I] is TUWPListButton then
      begin
        TfrmTrayPopup(Components[I]).Height := 33;
      end;
    end;
  end;

end;

procedure TfrmTrayPopup.FormDestroy(Sender: TObject);
begin
  //XPopupMenu.Free;
  XCheckbox1.Free;
  XCombo1.Free;
  XCombo2.Free;
  XCombo3.Free;
  XCombo4.Free;
  XComboAsLabel.Free;
end;

procedure TfrmTrayPopup.FormPaint(Sender: TObject);
begin
  if TaskbarAccented then
  begin
    Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BlendColors(GetAccentColor, clBlack,50), 200);
  end
  else
  begin
    if SystemUsesLightTheme then
      Canvas.Brush.Handle := CreateSolidBrushWithAlpha($dddddd, 200)    else
      Canvas.Brush.Handle := CreateSolidBrushWithAlpha($222222, 200);
  end;
  Canvas.FillRect(Rect(0,0,Width,Height));
end;

procedure TfrmTrayPopup.FormShow(Sender: TObject);
  procedure Delay(msec: LongInt);
  var
    start,stop: LongInt;
  begin
    start := GetTickCount;
    repeat
      stop := GetTickCount;
      Application.ProcessMessages;
    until (stop-start)>=msec;

  end;

//var
//  Screen1: TRect;
const
  ANIMATIONPADDING = 33; // copied from windows network systray animation padding
var
  TypesAniPlugin: TAQPSystemTypesAnimations;
  LAlphaBlendValue: Byte;
  LNewRect: TRect;
begin
  FormStyle := fsNormal;
  //Screen1 := GetRectOfPrimaryMonitor(False);
  GetTaskbarMonitor;
  imgScreenShape.Height := 96;
  imgScreenShape.Width := Trunc(Screen1.Width / Screen1.Height * 96);
  imgScreenShape.Left := (Width - imgScreenShape.Width) div 2;
  imgScreenShape.Top := (Height - imgScreenShape.Height) div 2;

{  if tempDisabled then
    Label1.Caption := 'off'
  else
    Label1.Caption := '1';}
  Label1.Left := (Self.Width - Label1.Width) div 2;
  Label1.Top := (Self.Height - Label1.Height) div 2;

  UpdateColorization;

  UpdatePosition;
  // copy current position before modifying it for new starting position
  LNewRect := BoundsRect;
  // precalculate starting details for easing animation
  case WinPosition of
    tpBottom:
    begin
      //easeB := Shell_TrayWndRect.Top; //starting position
      //Top := Shell_TrayWndRect.Bottom + Height;
      Top := Top + ANIMATIONPADDING;
      Height := Height - ANIMATIONPADDING;
    end;
    tpRight:
    begin
      //easeB := Shell_TrayWndRect.Left;
      //Left := Shell_TrayWndRect.Right + Width;
      Left := Left + ANIMATIONPADDING;
      Width := Width - ANIMATIONPADDING;
    end;
    tpTop:
    begin
      //easeB := Shell_TrayWndRect.Bottom; //starting position
      //Top := Shell_TrayWndRect.Top - Height;
      Top := Top - ANIMATIONPADDING;
      Height := Height - ANIMATIONPADDING;
      //AnimatePosition(XCombo1, ANIMATIONPADDING, True);
    end;
    tpLeft:
    begin
      //easeB := Shell_TrayWndRect.Right;
      //Left := Shell_TrayWndRect.Left - Width;
      Left := Left - ANIMATIONPADDING;
      Width := Width - ANIMATIONPADDING;
      //AnimatePosition(XCombo1, ANIMATIONPADDING, False);
    end;
  end;

  SwitchToThisWindow(Handle, True);

  ShowWindow(Application.Handle, SW_HIDE);

  //easing animation
//  if (WinPosition = tpBottom) or (WinPosition = tpTop) then
//  easeC := Height + 1// change in value, i.e. how many pixels to move our form
//  else if (WinPosition = tpLeft) or (WinPosition = tpRight) then
//  easeC := Width + 1;
//  easeD := 105; // duration
//  easeT := 0; // time set to 0
//  tmrAnimation.Enabled := True;

  TypesAniPlugin := Take(Sender)
    .FinishAnimations.Plugin<TAQPSystemTypesAnimations>;

  TypesAniPlugin.RectAnimation(LNewRect,
    function(RefObject: TObject): TRect
    begin
      Result := TForm(RefObject).BoundsRect;
    end,
    procedure(RefObject: TObject; const NewRect: TRect)
    begin
      TForm(RefObject).BoundsRect := NewRect;
    end,
    300, 0, TAQ.Ease(etSext, emInInverted)
  );
  FormStyle := fsStayOnTop;
  // fade animation
//  tmFader.Enabled := True;
  LAlphaBlendValue := 255;

  TypesAniPlugin.IntegerAnimation(LAlphaBlendValue,
    function(RefObject: TObject): Integer
    begin
      Result := TForm(RefObject).AlphaBlendValue;
    end,
    procedure(RefObject: TObject; const NewValue: Integer)
    begin
      TForm(RefObject).AlphaBlendValue := Byte(NewValue);
    end,
    300, 0, TAQ.Ease(etLinear, emIn)
  );
end;

procedure TfrmTrayPopup.GetTaskbarMonitor;
var
  I: Integer;
  Shell_TrayWnd: HWND;
  Shell_TrayWndRect: TRect;
begin
  Shell_TrayWnd := FindWindow('Shell_TrayWnd', nil);
  if Shell_TrayWnd = 0 then Exit;

  for I := 0 to Screen.MonitorCount -1 do
  begin
    Screen1 := Screen.Monitors[I].BoundsRect;

    GetWindowRect(Shell_TrayWnd, Shell_TrayWndRect);

    if (Screen1.Left <= Shell_TrayWndRect.Left)
    and (Screen1.Right >= Shell_TrayWndRect.Right)
    and (Screen1.Top <= Shell_TrayWndRect.Top)
    and (Screen1.Bottom >= Shell_TrayWndRect.Bottom)
    then
      Break;
  end;
end;

procedure TfrmTrayPopup.Image1Click(Sender: TObject);
begin
  //Image1.Visible := False;

  frmTrayPopup.XCombo1.Visible := True;
  frmTrayPopup.XCombo2.Visible := True;
  frmTrayPopup.XCombo3.Visible := True;
  frmTrayPopup.XCombo4.Visible := True;
  frmTrayPopup.XCheckbox1.Visible := True;
  frmTrayPopup.XComboAsLabel.Visible := True;
end;

procedure TfrmTrayPopup.InitCustomComponents;
begin
  XCheckbox1 := TXCheckbox.Create(Self);
  with XCheckbox1 do
  begin
    Parent := Self;
    ControlState := [];
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    Left := 100;
    Top := Self.Height - MulDiv(Height + 36, Self.PixelsPerInch, 96);
    Checked := True;
    OnClick := OnCheckBoxClick;
//    Width := Round(Width * (Self.PixelsPerInch/96));
    Width := MulDiv(Width, Self.PixelsPerInch, 96); // faster
//    Height := Round(Height * (Self.PixelsPerInch/96));
    Height := MulDiv(Height, Self.PixelsPerInch, 96);
  end;

  XCombo1 := TXCombobox.Create(Self);
  with XCombo1 do
  begin
    Parent := Self;
    Caption := 'All Windows';
    ControlState := [];
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    Left := 14;
    Top := 35;
    Font.Name := Self.Font.Name;
    OnClick := OnCornerOptionClick;
  end;

  XCombo2 := TXCombobox.Create(Self);
  with XCombo2 do
  begin
    Anchors := [TAnchorKind.akTop, TAnchorKind.akRight];
    Parent := Self;
    Caption := 'All Windows';
    ControlState := [];
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    //Left := Self.Width - 167 - 14;
    //DPI Aware alignment
    Left := Self.Width - MulDiv(Width - 14, Screen.PixelsPerInch, 96);
    Top := 35;
    Font.Name := Self.Font.Name;
    OnClick := OnCornerOptionClick;
  end;

  XCombo3 := TXCombobox.Create(Self);
  with XCombo3 do
  begin
    Parent := Self;
    Anchors := [TAnchorKind.akBottom, TAnchorKind.akLeft];
    Caption := 'All Windows';
    ControlState := [];
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    Left := 14;
    Top := Self.Height - MulDiv(Height + 70, Screen.PixelsPerInch, 96);
    Font.Name := Self.Font.Name;
    OnClick := OnCornerOptionClick;
  end;

  XCombo4 := TXCombobox.Create(Self);
  with XCombo4 do
  begin
    Parent := Self;
    Anchors := [TAnchorKind.akBottom, TAnchorKind.akRight];
    Caption := 'All Windows';
    ControlState := [];
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    //Left := Self.Width - 167 - 14;
    Left := Self.Width - MulDiv(Width - 14, Screen.PixelsPerInch, 96);
    Top := Self.Height - MulDiv(Height + 70, Screen.PixelsPerInch, 96);
    Font.Name := Self.Font.Name;
    OnClick := OnCornerOptionClick;
  end;

  XComboAsLabel := TXCombobox.Create(Self);
  with XComboAsLabel do
  begin
    Parent := Self;
    Caption := 'Hot corners enabled';
    ControlState := [];
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    Enabled:= False;
    Width := 167;
    Height := 31;//44;
    Left := XCheckbox1.Left + XCheckbox1.Width;
    Top := Self.Height - MulDiv(Height + 36, Screen.PixelsPerInch, 96);
    Font.Name := Self.Font.Name;
  end;

  // Adjusting
  XCheckbox1.Left := (frmTrayPopup.Width - (XCheckbox1.Width + XComboAsLabel.Width)) div 2;
  XCheckbox1.Anchors := [TAnchorKind.akBottom, TAnchorKind.akLeft];
  XComboAsLabel.Left := XCheckbox1.Left + XCheckbox1.Width;
  XComboAsLabel.Anchors := [TAnchorKind.akBottom, TAnchorKind.akLeft];
  if (XCombo3.Top + XCombo3.Height > XComboAsLabel.Top) then
    XCombo3.Top := XComboAsLabel.Top - XCombo3.Height;
  if (XCombo4.Top + XCombo4.Height > XComboAsLabel.Top) then
    XCombo4.Top := XComboAsLabel.Top - XCombo4.Height;
end;

procedure TfrmTrayPopup.LoadINI;
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+'settings.ini');
  try
    XCombo1.Caption := ini.ReadString('WinXBorders','topleft','');
    XCombo2.Caption := ini.ReadString('WinXBorders','topright','');
    XCombo3.Caption := ini.ReadString('WinXBorders','bottomleft','');
    XCombo4.Caption := ini.ReadString('WinXBorders','bottomright','');
  finally
    ini.Free;
  end;
end;

procedure TfrmTrayPopup.OnCheckBoxClick(Sender: TObject);
begin
  if Sender is TXCheckbox then
  begin
    if Sender = XCheckbox1 then
    begin
      tempDisabled := not TXCheckbox(Sender).Checked;
      if tempDisabled then
      begin
        XComboAsLabel.Caption := 'Temporary disabled';
        SetAlphaColorPicture(GetAccentColor, 75, imgScreenShape.Picture);
        //update trayicon
        frmMain.UpdateTrayIcon(True);
      end
      else
      begin
        XComboAsLabel.Caption := 'Hot corners enabled';
        SetAlphaColorPicture(GetAccentColor, 255, imgScreenShape.Picture);
        frmMain.UpdateTrayIcon();
      end;
    end;
  end;

end;

procedure TfrmTrayPopup.OnCornerOptionClick(Sender: TObject);
const
  MENUHEIGHT = 44; //* 5; //6 - 1 items each 44 in height
var
  x,y: Integer;
  totalMenuHeight: Integer;
begin
  if sender is TXCombobox then
  begin
    //totalMenuHeight := XPopupMenu.Items.VisibleCount * MENUHEIGHT;
    totalMenuHeight := pnlPopup.Height;
    x := Self.Left + (Sender as TXCombobox).Left;
    //y := Self.Top + TXCombobox(Sender).Top - 110;

    if TXCombobox(Sender).Top < 100 then
    begin
      y := Self.Top + TXCombobox(Sender).Top - 11;
    end
    else
    begin
      y := Self.Top + TXCombobox(Sender).Top - totalMenuHeight - 4;
    end;

    CornerOption := TXCombobox(Sender);
    ShowPopup(x-1, Mouse.CursorPos.Y);
    //XPopupMenu.Popup(x-1, y);
  end;

end;

procedure TfrmTrayPopup.OnCornerOptionEnter(Sender: TObject);
begin
  if Sender is TLabel then
    TLabel(Sender).Transparent := False;
end;

procedure TfrmTrayPopup.OnCornerOptionLeave(Sender: TObject);
begin
  if Sender is TLabel then
    TLabel(Sender).Transparent := True;
end;

procedure TfrmTrayPopup.PopupMenuPopup(Sender: TObject);
begin
//
end;



procedure TfrmTrayPopup.SaveINI;
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+'settings.ini');
  try
    ini.WriteString('WinXBorders','topleft',XCombo1.Caption);
    ini.WriteString('WinXBorders','topright',XCombo2.Caption);
    ini.WriteString('WinXBorders','bottomleft',XCombo3.Caption);
    ini.WriteString('WinXBorders','bottomright',XCombo4.Caption);
  finally
    ini.Free;
  end;
end;

procedure TfrmTrayPopup.ShowPopup(X, Y: Integer);
begin
  PopMenu := TFormPopup.CreatePopup(Self, pnlPopup, nil, X, Y, []);
end;

procedure TfrmTrayPopup.tmrTaskbarFocusTimer(Sender: TObject);
begin
  if GetForegroundWindow = frmTrayPopup.Handle then
  begin
    tmrTaskbarFocus.Enabled := False;
    tmrUpdatePosition.Enabled := False;
  end;

  if (GetForegroundWindow <> FindWindow('Shell_TrayWnd',nil))
  and (GetForegroundWindow <> frmTrayPopup.Handle) then
  begin
    tmrTaskbarFocus.Enabled := False;
    tmrUpdatePosition.Enabled := False;
    Close;
  end;

end;

{
It might contain bugs, but the purpose is
to monitor the taskbar in order to attach the window to the right place
as this timer only works when app is not focused but taskbar is
}
procedure TfrmTrayPopup.tmrUpdatePositionTimer(Sender: TObject);
var
  Shell_TrayWndRect: TRect;
  //Screen1 : TRect;
begin
  //Screen1 := GetRectOfPrimaryMonitor(True);
  GetTaskbarMonitor;
  GetWindowRect(FindWindow('Shell_TrayWnd',nil), Shell_TrayWndRect);
  case WinPosition of
    tpBottom:
      if Shell_TrayWndRect.Top <> Screen1.Bottom then
      begin
        UpdatePosition;
      end;
    tpRight:
      if Shell_TrayWndRect.Left <> Screen1.Right then
      begin
        UpdatePosition;
      end;
    tpTop:
      if Shell_TrayWndRect.Bottom <> Screen1.Top then
      begin
        UpdatePosition;
      end;
    tpLeft:
      if Shell_TrayWndRect.Right <> Screen1.Left then
      begin
        UpdatePosition;
      end;
  end;

end;

procedure TfrmTrayPopup.UpdateColorization;
begin
  if TaskbarTranslucent then
  begin
    EnableBlur(Handle)
  end
  else
    EnableBlur(Handle, False);
  // force window to repaint
  FormPaint(imgScreenShape);

  // update checkbox color
  XCheckbox1.Color := GetAccentColor;
  // update scrren
  if tempDisabled then
    SetAlphaColorPicture(GetAccentColor, 75, imgScreenShape.Picture)
  else
    SetAlphaColorPicture(GetAccentColor, 255, imgScreenShape.Picture);
end;

procedure TfrmTrayPopup.UpdatePosition;
begin
  //Screen1 := GetRectOfPrimaryMonitor(False);
  GetTaskbarMonitor;
  Shell_TrayWnd := FindWindow('Shell_TrayWnd', nil);
  if Shell_TrayWnd > 0 then
  begin
    GetWindowRect(Shell_TrayWnd, Shell_TrayWndRect);
      if (Shell_TrayWndRect.Left=0)
      and(Shell_TrayWndRect.Right=Screen1.Width)
      and(Shell_TrayWndRect.Top>0)
      then
      begin
      //ShowMessage('está abajo')
      //posicionamos a la derecha en el systray
      Left:=Screen1.Width-Width-10;
      if Left<1 then Left:=10;
      WinPosition := tpBottom;
      MaxTop:=Screen1.Height-Height-Shell_TrayWndRect.Bottom+Shell_TrayWndRect.Top;//-10;
      Top := MaxTop;// + 20;
      if Top<1 then Top:=10;
      end
      //arriba
      else if (Shell_TrayWndRect.Left=0)
      and(Shell_TrayWndRect.Right=Screen1.Width)
      and(Shell_TrayWndRect.Top<1)
      then
      begin
      //ShowMessage('Está arriba');
      Left:=Screen1.Width-Width-10;
      if Left<1 then Left:=10;
      WinPosition := tpTop;
      MaxTop := Shell_TrayWndRect.Bottom; //+10;
      Top := MaxTop;// - 20;
      if Top<1 then Top:=10;
      end
      //izquierda
      else if (Shell_TrayWndRect.Left<1)
      and (Shell_TrayWndRect.Top=0)
      and(Shell_TrayWndRect.Bottom=Screen1.Height)
      then
      begin
      //ShowMessage('Está a la izquierda')
      WinPosition := tpLeft;
      MaxLeft := Shell_TrayWndRect.Right; //+10;
      Left := MaxLeft;// - 20;
      if Left<1 then Left:=10;
      Top:=Screen1.Height-Height-10;
      if Top<1 then Top:=10;
      end
      //derecha
      else if (Shell_TrayWndRect.Left>0)
      and(Shell_TrayWndRect.Top=0)
      and(Shell_TrayWndRect.Bottom=Screen1.Height)
      then
      begin
      //ShowMessage('Está a la derecha');
      WinPosition := tpRight;
      MaxLeft := Shell_TrayWndRect.Left-Width; //-10;
      Left := MaxLeft;// + 20;
      if Left<1 then Left:=10;
      Top:=Screen1.Height-Height-10;
      if Top<1 then Top:=10;
      end;
  end;
end;



// It will update values
procedure TfrmTrayPopup.UpdateXCombos;
begin
  {if not XPopupMenu.Items[5].Visible then
  begin
    if XCombo1.Caption = 'Custom Command' then
      XCombo1.Caption := '';
    if XCombo2.Caption = 'Custom Command' then
      XCombo2.Caption := '';
    if XCombo3.Caption = 'Custom Command' then
      XCombo3.Caption := '';
    if XCombo4.Caption = 'Custom Command' then
      XCombo4.Caption := '';
  end;}
  if not ulbCustomCommand.Visible then
  begin
    if XCombo1.Caption = 'Custom Command' then
      XCombo1.Caption := '';
    if XCombo2.Caption = 'Custom Command' then
      XCombo2.Caption := '';
    if XCombo3.Caption = 'Custom Command' then
      XCombo3.Caption := '';
    if XCombo4.Caption = 'Custom Command' then
      XCombo4.Caption := '';
  end;
end;

procedure TfrmTrayPopup.WndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DWMCOLORIZATIONCOLORCHANGED then
  begin
    UpdateColorization;
    frmMain.UpdateTrayIcon();
  end;

  if Msg.Msg = WM_DISPLAYCHANGE then
  begin
    Self.Width := XCombo2.Left + XCombo2.Width + 14;
    pnlPopup.Width := XCombo2.Width;
  end;

  if Msg.Msg = WM_DPICHANGED then
  begin
    //The Msg.WParam parameter contains the new DPI value after the change,
    //and the second parameter of ChangeScale should be the old DPI value, which is 96 in this case.
    ChangeScale(Msg.WParam, 96);
  end;


  inherited WndProc(Msg);
end;

procedure TfrmTrayPopup.XMenuItemClick(Sender: TObject);
begin
  if Sender <> nil then
  begin
    ClosePopup;
    {CornerOption.Caption := ''+TXMenuItem(Sender).Text;
    if TXMenuItem(Sender).Text = 'Start Screen Saver' then
    CornerOption.Caption := 'Screen Saver';

    if TXMenuItem(Sender).Text = 'Hide Other Windows' then
    CornerOption.Caption := 'Hide Windows';}
    CornerOption.Caption := ''+TUWPListButton(Sender).Caption;
    if TUWPListButton(Sender).Caption = 'Start Screen Saver' then
      CornerOption.Caption := 'Screen Saver';
    if TUWPListButton(Sender).Caption = 'Hide Other Windows' then
      CornerOption.Caption := 'Hide Windows';

    SaveINI;
  end;
end;

end.
