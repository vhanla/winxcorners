{
Changelog:
- 24-06-11
  Fixed HighDpi drawing and positioning of components
  Fixed Windows 11 styling
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, StdCtrls, Menus,
  XMenu, XGraphics, PNGimage, GDIPApi, GDIPObj,  XCheckbox ,XCombobox ,
  Registry, IniFiles, DateUtils,
  //AnimateEasing,
  Math, jpeg;
const
  WM_DWMCOLORIZATIONCOLORCHANGED = 800;


type
  TFadeType = (ftIn, ftOut);
  TTaskbarPosition = (tpBottom, tpRight, tpTop, tpLeft); // using the taskbar position as guide
  TfrmTrayPopup = class(TForm)
    imgScreenShape: TImage;
    Label1: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    tmFader: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure XMenuItemClick(Sender: TObject);
    procedure OnCornerOptionEnter(Sender: TObject);
    procedure OnCornerOptionLeave(Sender: TObject);
    procedure OnCornerOptionClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure OnCheckBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure tmFaderTimer(Sender: TObject);
  private
    { Private declarations }
    CornerOption : TXCombobox;
    MaxTop, MaxLeft : Integer;
    WinPosition: TTaskbarPosition;
    fFadeType: TFadeType;
    procedure CloseApp(Sender: TObject);
    procedure UpdateColorization;
    procedure WndProc(var Msg: TMessage); override;
    procedure UpdatePosition;
    procedure PopupMenuPopup(Sender: TObject);
    procedure InitCustomComponents;
    procedure GetTaskbarMonitor;

    property FadeType: TFadeType read fFadeType write fFadeType;
  protected
    { Like private but accessible from subclasses}
  public
    { Public declarations }
    tempDisabled: Boolean;
    XPopupMenu: TXPopupMenu;
    XCheckbox1: TXCheckbox;
    XCombo1,XCombo2,XCombo3,XCombo4,XComboAsLabel: TXCombobox;
    easeT, easeB, easeC, easeD: LongInt;
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
  functions, main, Types;
{$R *.dfm}


procedure TfrmTrayPopup.CloseApp(Sender: TObject);
begin
  XPopupMenu.Hide;
  if GetForegroundWindow = FindWindow('Shell_TrayWnd',nil) then
  begin
    //start timer that will look if user  get's a different foregound
    Timer2.Enabled := True;
    Timer3.Enabled := True; // to prevnt app window stay in a poits position if user moves taskbar
  end
  else
    Close;
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


  begin
  //Screen1 := GetRectOfPrimaryMonitor(False);
  GetTaskbarMonitor;
  case WinPosition of
    tpBottom:
    begin
      repeat
        if Top < (Screen1.Bottom - Screen1.Top) then  Top := Top + 50;
        delay(10);
      until (Top >= (Screen1.Bottom - Screen1.Top)) ;//or ( Form2.Visible);
    end;
    tpRight:
    begin
      repeat
        if Left < Screen1.Left then  Left := Left + 50;
        delay(10);
      until Left >= Screen1.Left;
    end;
    tpTop:
    begin
      repeat
        if Top > Screen1.Top then  Top := Top - 50;
        delay(10);
      until Top <= Screen1.Top;
    end;
    tpLeft:
    begin
      repeat
        if Left > Screen1.Left then  Left := Left - 50;
        delay(10);
      until Left <= Screen1.Left;
    end;
  end;
  end;
  Action := caHide;

  // fade animation
  AlphaBlendValue := 0;
end;

procedure TfrmTrayPopup.FormCreate(Sender: TObject);
begin
//  if not SystemUsesLightTheme then
//    UseImmersiveDarkMode(Handle, True);

  EnableNCShadow(Handle);

  // initialize the custom components before using them, it will be destroyed on OnDestroy
  InitCustomComponents;

  DoubleBuffered := True;
  Color := clBlack;
  BorderStyle := bsNone;

  imgScreenShape.Stretch := True;
  // set the correct colorization settings as well as blur aero
  UpdateColorization;

  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);

  Application.OnDeactivate := CloseApp;

  // Create the popup menu to select the hot corner's behavior
  XPopupMenu := TXPopupMenu.Create(nil);
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
    Text := 'Start Menu';
    OnClick := XMenuItemClick;
    Visible := True;
  end;

  with XPopupMenu.Items.Add do
  begin
    Name := 'N7';
    Text := 'Custom Command 1';
    OnClick := XMenuItemClick;
    Visible := False;
  end;

    with XPopupMenu.Items.Add do
  begin
    Name := 'N7';
    Text := 'Custom Command 2';
    OnClick := XMenuItemClick;
    Visible := False;
  end;

    with XPopupMenu.Items.Add do
  begin
    Name := 'N7';
    Text := 'Custom Command 3';
    OnClick := XMenuItemClick;
    Visible := False;
  end;

    with XPopupMenu.Items.Add do
  begin
    Name := 'N7';
    Text := 'Custom Command 4';
    OnClick := XMenuItemClick;
    Visible := False;
  end;


  with XPopupMenu.Items.Add do
  begin
    Name := 'N8';
    Text := 'Hide Other Windows';
    OnClick := XMenuItemClick;
  end;

  with XPopupMenu.Items.Add do
  begin
    Name := 'N0';
    Text := '';
    OnClick := XMenuItemClick;
  end;

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
  Timer1.Enabled := False;
  Timer1.Interval := 3;

  // fading animation
  AlphaBlend := True;
  AlphaBlendValue := 0;
  fFadeType := ftIn;
end;

procedure TfrmTrayPopup.FormDestroy(Sender: TObject);
begin
  XPopupMenu.Free;
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
      Canvas.Brush.Handle := CreateSolidBrushWithAlpha($dddddd, 200)
    else
    begin
      if isWindows11 then
        Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BlendColors($2d2d2d, clBlack,25), 200)
      else
        Canvas.Brush.Handle := CreateSolidBrushWithAlpha($222222, 200);
    end;
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
begin
  FormStyle := fsNormal;
  //Screen1 := GetRectOfPrimaryMonitor(False);
  GetTaskbarMonitor;
  imgScreenShape.Height := HighDpi(96);
  imgScreenShape.Width := HighDpi(Trunc((Screen1.Right - Screen1.Left) / (Screen1.Bottom - Screen1.Top) * 96));
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
  // precalculate starting details for easing animation
  case WinPosition of
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
  end;

  SwitchToThisWindow(Handle, True);

  ShowWindow(Application.Handle, SW_HIDE);

  //easing animation
  if (WinPosition = tpBottom) or (WinPosition = tpTop) then
  easeC := Height + 1// change in value, i.e. how many pixels to move our form
  else if (WinPosition = tpLeft) or (WinPosition = tpRight) then
  easeC := Width + 1;
  easeD := 105; // duration
  easeT := 0; // time set to 0
  Timer1.Enabled := True;

  // fade animation
  tmFader.Enabled := True;
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

procedure TfrmTrayPopup.InitCustomComponents;
begin
  XCheckbox1 := TXCheckbox.Create(Self);
  with XCheckbox1 do
  begin
    Parent := Self;
    ControlState := [];
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    Left := HighDpi(100);
    Top := Self.Height - HighDpi(30);
    Checked := True;
    OnClick := OnCheckBoxClick;
//    Width := Round(Width * (Self.PixelsPerInch/96));
//    Height := Round(Height * (Self.PixelsPerInch/96));
  end;

  XCombo1 := TXCombobox.Create(Self);
  with XCombo1 do
  begin
    Parent := Self;
    Caption := 'All Windows';
    ControlState := [];
    Font.Name := 'Segoe UI';
//    Font.Size := 9;
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    Left := HighDpi(14);
    Top := HighDpi(35);
    Font.Name := Self.Font.Name;
    OnClick := OnCornerOptionClick;
  end;

  XCombo2 := TXCombobox.Create(Self);
  with XCombo2 do
  begin
    Parent := Self;
    Caption := 'All Windows';
    ControlState := [];
    Font.Name := 'Segoe UI';
//    Font.Size := 9;
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    //Left := Self.Width - 167 - 14;
    Left := Self.Width - Width - HighDpi(14);
    Top := HighDpi(35);
    Font.Name := Self.Font.Name;
    OnClick := OnCornerOptionClick;
  end;

  XCombo3 := TXCombobox.Create(Self);
  with XCombo3 do
  begin
    Parent := Self;
    Caption := 'All Windows';
    ControlState := [];
    Font.Name := 'Segoe UI';
//    Font.Size := 9;
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    Left := HighDpi(14);
    Top := Self.Height - HighDpi(70);
    Font.Name := Self.Font.Name;
    OnClick := OnCornerOptionClick;
  end;

  XCombo4 := TXCombobox.Create(Self);
  with XCombo4 do
  begin
    Parent := Self;
    Caption := 'All Windows';
    ControlState := [];
    Font.Name := 'Segoe UI';
//    Font.Size := 9;
    Color := GetAccentColor;
    DisabledColor := $dddddd;
    //Left := Self.Width - 167 - 14;
    Left := Self.Width - Width - HighDpi(14);
    Top := Self.Height - HighDpi(70);
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
    Width := HighDpi(167);
    Height := HighDpi(31);//44;
    Left := XCheckbox1.Left + XCheckbox1.Width;
    Top := Self.Height - HighDpi(36);
    Font.Name := Self.Font.Name;
  end;

  // Adjusting
  XCheckbox1.Left := (frmTrayPopup.Width - (XCheckbox1.Width + XComboAsLabel.Width)) div 2;
  XComboAsLabel.Left := XCheckbox1.Left + XCheckbox1.Width;
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
  if (Sender is TXCheckbox) then
  begin
    if (Sender = XCheckbox1) then
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
        SetAlphaColorPicture(GetAccentColor, 250, imgScreenShape.Picture);
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
    totalMenuHeight := XPopupMenu.Items.VisibleCount * MENUHEIGHT;
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
//      y := HighDpi(y);
    CornerOption := TXCombobox(Sender);
    XPopupMenu.Popup(x-1, y);
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

procedure TfrmTrayPopup.Timer1Timer(Sender: TObject);
begin

{ //previous animation with no easing
  case WinPosition of
    tpBottom:
      begin
        if Top > MaxTop then  Top := Top - 2;

      end;
    tpRight: if Left > MaxLeft then  Left := Left - 2;
    tpTop: if Top < MaxTop then  Top := Top + 2;
    tpLeft: if Left < MaxLeft then  Left := Left + 2;
  end;
}

//new easing animation
if easeT <= easeD then
  begin
    case WinPosition of
      tpBottom: Self.Top:= easeB - (Trunc(easeC*(-Power(2,-10*easeT/easeD)+1)+easeB)-easeB);
      tpRight: Self.Left:= easeB - (Trunc(easeC*(-Power(2,-10*easeT/easeD)+1)+easeB)-easeB);
      tpTop: Self.Top:= (Trunc(easeC*(-Power(2,-10*easeT/easeD)+1)+easeB)-Height);
      tpLeft: Self.Left:= (Trunc(easeC*(-Power(2,-10*easeT/easeD)+1)+easeB)-Width);
    end;

    easeT := easeT + Timer1.Interval;
  end
  else
  begin
    Timer1.Enabled:=False;
    FormStyle := fsStayOnTop;
  end;
end;

procedure TfrmTrayPopup.Timer2Timer(Sender: TObject);
begin
  if GetForegroundWindow = frmTrayPopup.Handle then
  begin
    Timer2.Enabled := False;
    Timer3.Enabled := False;
  end;

  if (GetForegroundWindow <> FindWindow('Shell_TrayWnd',nil))
  and (GetForegroundWindow <> frmTrayPopup.Handle) then
  begin
    Timer2.Enabled := False;
    Timer3.Enabled := False;
    Close;
  end;

end;

{
It might contain bugs, but the purpose is
to monitor the taskbar in order to attach the window to the right place
as this timer only works when app is not focused but taskbar is
}
procedure TfrmTrayPopup.Timer3Timer(Sender: TObject);
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

procedure TfrmTrayPopup.tmFaderTimer(Sender: TObject);
const
  FADE_IN_SPEED = 15;
  FADE_OUT_SPEED = 5;
var
  newBlendValue: integer;
begin
  case FadeType of
    ftIn:
    begin
      if AlphaBlendValue < 255 then
        AlphaBlendValue := FADE_IN_SPEED + AlphaBlendValue
      else
      begin
        AlphaBlendValue := 255;
        tmFader.Enabled := False;
      end;
    end;
    ftOut:
    begin
      if AlphaBlendValue > 0  then
      begin
        newBlendValue := -1 * FADE_OUT_SPEED + AlphaBlendValue;
        if newBlendValue > 0 then
          AlphaBlendValue := newBlendValue
        else
          AlphaBlendValue := 0;
      end
      else
      begin
        tmFader.Enabled := False;
        Close;
      end;
    end;
  end;
end;

procedure TfrmTrayPopup.UpdateColorization;
begin
  if TaskbarTranslucent then
    EnableBlur(Handle)
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
    SetAlphaColorPicture(GetAccentColor, 250, imgScreenShape.Picture);
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
      and(Shell_TrayWndRect.Right=(Screen1.Right - Screen1.Left))
      and(Shell_TrayWndRect.Top>0)
      then
      begin
      //ShowMessage('está abajo')
      //posicionamos a la derecha en el systray
      Left:=(Screen1.Right - Screen1.Left)-Width-10;
      if Left<1 then Left:=10;
      WinPosition := tpBottom;
      MaxTop:=(Screen1.Bottom - Screen1.Top)-Height-Shell_TrayWndRect.Bottom+Shell_TrayWndRect.Top;//-10;
      Top := MaxTop + 20;
      if Top<1 then Top:=10;
      end
      //arriba
      else if (Shell_TrayWndRect.Left=0)
      and(Shell_TrayWndRect.Right=(Screen1.Right - Screen1.Left))
      and(Shell_TrayWndRect.Top<1)
      then
      begin
      //ShowMessage('Está arriba');
      Left:=(Screen1.Right - Screen1.Left)-Width-10;
      if Left<1 then Left:=10;
      WinPosition := tpTop;
      MaxTop := Shell_TrayWndRect.Bottom; //+10;
      Top := MaxTop - 20;
      if Top<1 then Top:=10;
      end
      //izquierda
      else if (Shell_TrayWndRect.Left<1)
      and (Shell_TrayWndRect.Top=0)
      and(Shell_TrayWndRect.Bottom=(Screen1.Bottom - Screen1.Top))
      then
      begin
      //ShowMessage('Está a la izquierda')
      WinPosition := tpLeft;
      MaxLeft := Shell_TrayWndRect.Right; //+10;
      Left := MaxLeft - 20;
      if Left<1 then Left:=10;
      Top:=(Screen1.Bottom - Screen1.Top)-Height-10;
      if Top<1 then Top:=10;
      end
      //derecha
      else if (Shell_TrayWndRect.Left>0)
      and(Shell_TrayWndRect.Top=0)
      and(Shell_TrayWndRect.Bottom=(Screen1.Bottom - Screen1.Top))
      then
      begin
      //ShowMessage('Está a la derecha');
      WinPosition := tpRight;
      MaxLeft := Shell_TrayWndRect.Left-Width; //-10;
      Left := MaxLeft + 20;
      if Left<1 then Left:=10;
      Top:=(Screen1.Bottom - Screen1.Top)-Height-10;
      if Top<1 then Top:=10;
      end;
  end;
end;



// It will update values
procedure TfrmTrayPopup.UpdateXCombos;
begin
  if not XPopupMenu.Items[6].Visible
  then
  begin
    if XCombo1.Caption = 'Custom Command 1' then XCombo1.Caption := '';
    if XCombo2.Caption = 'Custom Command 1' then XCombo2.Caption := '';
    if XCombo3.Caption = 'Custom Command 1' then XCombo3.Caption := '';
    if XCombo4.Caption = 'Custom Command 1' then XCombo4.Caption := '';

    if XCombo1.Caption = 'Custom Command 2' then XCombo1.Caption := '';
    if XCombo2.Caption = 'Custom Command 2' then XCombo2.Caption := '';
    if XCombo3.Caption = 'Custom Command 2' then XCombo3.Caption := '';
    if XCombo4.Caption = 'Custom Command 2' then XCombo4.Caption := '';

    if XCombo1.Caption = 'Custom Command 3' then XCombo1.Caption := '';
    if XCombo2.Caption = 'Custom Command 3' then XCombo2.Caption := '';
    if XCombo3.Caption = 'Custom Command 3' then XCombo3.Caption := '';
    if XCombo4.Caption = 'Custom Command 3' then XCombo4.Caption := '';

    if XCombo1.Caption = 'Custom Command 4' then XCombo1.Caption := '';
    if XCombo2.Caption = 'Custom Command 4' then XCombo2.Caption := '';
    if XCombo3.Caption = 'Custom Command 4' then XCombo3.Caption := '';
    if XCombo4.Caption = 'Custom Command 4' then XCombo4.Caption := '';

  end;
end;

procedure TfrmTrayPopup.WndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DWMCOLORIZATIONCOLORCHANGED then
  begin
    UpdateColorization;
  end;

  if Msg.Msg = WM_DISPLAYCHANGE then
  begin
    Self.Width := XCombo2.Left + XCombo2.Width + 14;
  end;


  inherited WndProc(Msg);
end;

procedure TfrmTrayPopup.XMenuItemClick(Sender: TObject);
begin
  if Sender <> nil then
  begin
    CornerOption.Caption := ''+TXMenuItem(Sender).Text;
    if TXMenuItem(Sender).Text = 'Start Screen Saver' then
    CornerOption.Caption := 'Screen Saver';

    if TXMenuItem(Sender).Text = 'Hide Other Windows' then
    CornerOption.Caption := 'Hide Windows';

    SaveINI;
  end;
end;

end.
