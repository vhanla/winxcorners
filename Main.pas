{
WinXCorners
Author: Victor Alberto Gil <vhanla>
A rewrite from scratch of Win7sé for Windows 10

TODO:
HiDPI support - Works 75%

Hook DLL - Advantages, less CPU usage
           Cons: doesn't trigger from privileged focused programs
            current approach using WM_COPYDATA breaks on software delay like using rest
              connection
           Needs more tests and improvement, disabled for now.

Features requested:
- Detect Fullscreen applications
- Blacklist applications
- Win+Home (done)
- Disable Sleep Mode
- Windows Start
- Disable Screen Saver
- Hotkey from command
- Minimize
- Ctrl-Esc or Win+X
- Virtual Desktop Screen switcher

CHANGELOG:
- 24-12-01
  Add function to get TaskView title name in order to detect its window with FindWindow
- 24-11-28
  Add logging window in order to log actions
- 24-07-25
  Add DLL (system wide) low level mouse hook (this might be optional otherwise it won't work on elevated windows)
  Clean code/comments and refactor HotSpotAction repeated code
- 24-06-30
  Add settings helper with json support
  Add improved workaround for activating on elevated process while being unelevated
- 24-06-29
  Add custom hotkey support (hotkeyhelper unit)
  Add ctrl+alt+tab alternative to win+tab
  !Add explorer CLSID special arguments for Task View and Show Desktop, but they're slow compared to hotkeys
- 24-06-09
  Add VirtualDesktop support for Windows 10 and 11
  Add DarkMode support for Windows 10 and 11 (partial)
- 19-06-06
  Detect DarkMode/LightMode Windows 10 May Update 2019
- 18-09-03
  Detect Lock/Unlock to disable temporarily
  Removed incomplete update checker to release memory usage from 8MB to 6MB
  Reduced speed of hotspot timer from 100 to 250
  Hacky workaround to avoid activating TopLeft hotscreen on LogonUI (Ctrl+Alt+Del)
    checking GetForeground, which fails and returns 0 as well we make sure is zero
    if not return on exception.

- 17-06-02
  Added feature, Win+Home to hide/show background windows
   Suggested by Anthony Dodd at comments
   Solution found at https://blogs.msdn.microsoft.com/oldnewthing/20170530-00/?p=96246
   Raymond Chen says that restoring might not preserve z-order if one windows is not responding
   Known limitation: some apps capture win+home and won't allow to trigger it
  Added Multimonitor Support. I wanted to use generic collections, but it wasn't necessary :P
  Fixed XCheckbox HiDpi rendering (see XCheckbox.pas changelog)

- 16-08-08
  Fixed incorrect delay timer, which wasn't reset after it triggers the selected hotaction
- 16-08-07
  Fixed showing animation while holding mouse button :P
  A workaround using switch to this window to override UAC windows in foreground
  //if GetForegroundWindow <> FindWindow('MultitaskingViewFrame','Vista Tareas') then
  to avoid switching to the alt-tab window so it won't be called again due to lost focus

- 16-08-05
  Updated and modified trayicon to update it accordingly, i.e. if temporarily disabled, a grayed icon is set
  Added main.pas to uses in frmsettings and created a public procedure (UpdateTrayIcon)

  Fixed "bug" (feature :P ) that ignored mouse pressed before detecting hot corners events
  Now it is disabled so if user is selecting a text and reaches a hot corner it won't trigger the event

  Added CountDown animation (kinda)
  Added advanced options for delaying response of hotcorners
  Added execution of command line

- 16-02-27
  Fix systray dissapearance under Windows 10, it seems previous workaround doesn't match this
  new windows version, well it was the message string, now set correctly to "TaskbarCreated"
- 15-12-01
  Added support to trigger default action of taskbar's button 'task views'
- 15-11-02
  DPI Aware support, since Delphi offers a bad support with custom components
- 15-10-12
  A complete rewrite in order to only use it on Windows 10

}
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, ShellApi, Menus, Registry, //System.Generics.Collections,
  VirtualDesktopManager, MultiMon
  ;

const
  WM_DPICHANGED = $02E0;
  WM_MOUSE_EVENT = WM_USER + 100;

type

  PMSLLHOOKSTRUCT = ^TMSLLHOOKSTRUCT;
  TMSLLHOOKSTRUCT = record
    pt: TPoint;             // Mouse Coordinates
    mouseData: DWORD;       // Additional mouse data
    flags: DWORD;           // Event-injection flags
    time: DWORD;            // Timestamp
    dwExtraInfo: ULONG_PTR; // Extra information
  end;

  THotArea = (haNone, haLeft, haTopLeft, haTop, haTopRight, haRight, haBottomRight, haBottom, haBottomLeft);

  TfrmMain = class(TForm)
    tmrHotSpot: TTimer;
    PopupMenu1: TPopupMenu;
    Exit1: TMenuItem;
    emporarydisabled1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    tmrDelay: TTimer;
    Advanced1: TMenuItem;
    tmFullScreen: TMenuItem;
    tmLine2: TMenuItem;
    LogWindow1: TMenuItem;
    procedure tmrHotSpotTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure emporarydisabled1Click(Sender: TObject);
    procedure tmrDelayTimer(Sender: TObject);
    procedure Advanced1Click(Sender: TObject);
    procedure tmFullScreenClick(Sender: TObject);
    procedure LogWindow1Click(Sender: TObject);
  private
    { Private declarations }
    iconData: TNotifyIconData;
    SystrayIcon: TIcon;
    OnHotSpot: Boolean;
    hotActionStr: string;
    hotActionDelay: Integer;
    hotActionDelayCounter: Integer;
    FRegisteredSessionNotification: Boolean;
    procedure Iconito(var Msg: TMessage); message WM_USER + 1;
    procedure HotAction(hAction: string);
    procedure AutoStartState;
    procedure RegAutoStart(registerasrun: boolean = true);
    procedure WMDpiChanged(var Message: TMessage); message WM_DPICHANGED;
    procedure WMMouseEvent(var Message: TMessage); message WM_MOUSE_EVENT;
  protected
    procedure WndProc(var Msg: TMessage); override;
    procedure HotSpotAction(MPos: TPoint);

    procedure CurrentDesktopChanged(Sender: TObject; OldDesktop, NewDesktop: TVirtualDesktop);
    procedure CurrentDesktopChangedW11(Sender: TObject; OldDesktop, NewDesktop: TVirtualDesktopW11);

  public
    { Public declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure UpdateTrayIcon(grayed: boolean = False; recreate: Boolean = False);
    procedure Log(const Msg: string);
    function GetTaskViewTitleFromMUI: string;
  end;

var
  frmMain: TfrmMain;
  CurrentForegroundHwnd: HWND;
  wmTaskbarRestartMsg: Cardinal;
  taskViewTitle: string;

  // Mouse Hook DLL function declarations
  function InstallMouseHook(hTargetWnd: HWND): Boolean; stdcall; external 'WINXCORNERS.DLL';
  function UninstallMouseHook: Boolean; stdcall; external 'WINXCORNERS.DLL';
//  procedure NotifyTargetReady; stdcall; external 'WINXCORNERS.DLL';

implementation

uses
  functions, frmSettings, osdgui, frmAdvanced, Types, hotkeyhelper, frmLoggingWindow;
{$R *.dfm}

const
  WM_MOUSE_COORDS = WM_USER + 9;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if not isWindows10 then
  begin
    MessageDlg('Error. You need Windows 10 build 10240 or newer', mtError, [mbOK], 0);
    Application.Terminate;
  end;

  if not InstallMouseHook(Handle) then
    raise Exception.Create('Failed to install mouse hook!');

  SetPriorityClass(GetCurrentProcess, $4000);

  taskViewTitle := GetTaskViewTitleFromMUI;

  wmTaskbarRestartMsg := RegisterWindowMessage('TaskbarCreated');

  UpdateTrayIcon();


  FormStyle := fsStayOnTop;
  AutoStartState;

  //Screens := TObjectList<TScreens>.Create;
//  FRegisteredSessionNotification := WTSRegisterSessionNotification(Handle, NOTIFY_FOR_THIS_SESSION);

//  RunHook(Handle);
  if Win32MajorVersion > 10 then
  begin
    if Win32BuildNumber >= 22000 then
      DesktopManagerW11.OnCurrentDesktopChanged := CurrentDesktopChangedW11
    else
      DesktopManager.OnCurrentDesktopChanged := CurrentDesktopChanged;
  end;

  if not SystemUsesLightTheme then
  begin
    AllowDarkModeForWindow(Handle, True);
    AllowDarkModeForApp(True);
    SetPreferredAppMode(1);
    DarkMode;
//    SetPreferredAppMode(1);
//    DarkMode;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  UninstallMouseHook;
  //Screens.Free;
//  KillHook;

  if iconData.Wnd <> 0 then
    Shell_NotifyIcon(NIM_DELETE, @iconData);

  SystrayIcon.Free;

//  if FRegisteredSessionNotification then
//    WTSUnRegisterSessionNotification(Handle);
end;

function TfrmMain.GetTaskViewTitleFromMUI: string;
const
  TASKVIEWID = 900; // this one is located in the explorer.exe.mui strings
var
  lLocale: string;
  lWindowsPath: string;
begin
  Result := 'Task View'; // en-US default title
  lLocale := GetPreferredUILanguages;
  lWindowsPath := GetWindowsPath;
  Result := LoadMUIString(lWindowsPath + '\' + lLocale + '\explorer.exe.mui', TASKVIEWID);
end;

procedure TfrmMain.HotAction(hAction: string);
// this neat fun method comes from http://stackoverflow.com/questions/12960702/enum-from-string
type
  THotAction = (
    haWindows,
    haDesktop,
    haScreenSaver,
    haMonitorOff,
    haActionCenter,
    haStartMenu,
    haCustomCmd,
    haCustomCmd2,
    haCustomCmd3,
    haCustomCmd4,
    haToggleOtherWindows,
    haNoAction);
const
  HotActions: array[THotAction]
  of string = (
    'All Windows',
    'Desktop',
    'Screen Saver',
    'Monitors Off',
    'Action Center',
    'Start Menu',
    'Custom Command 1',
    'Custom Command 2',
    'Custom Command 3',
    'Custom Command 4',
    'Hide Windows',
    '');

  function GetAction(const str: string): THotAction;
  begin
    for Result := Low(Result) to High(Result) do
      if HotActions[Result] = str then
        Exit;
    // if nothing matches or is empty we return the no action
    Result := haNoAction;
  end;

//var
//  Shell_SecondaryTrayWnd: HWND;
//  procid: integer;
begin
  if frmTrayPopup.tempDisabled then
    Exit;

  if frmAdvSettings.chkFullScreen.Checked then
  begin
    if DetectFullScreen3D or DetectFullScreenApp then
    begin
      Log('Full Screen hot action blocked');
      Exit;
    end;
  end;

  Log('HotAction event.');

  // avoid usage if mouse is in use (buttons down e.g.)
  // if value is negative, it means is in use (aka held down)
{  if (GetKeyState(VK_LBUTTON) < 0)
  or (GetKeyState(VK_MBUTTON) < 0)
  or (GetKeyState(VK_RBUTTON) < 0)
  then
    Exit;}
  case GetAction(hAction) of
    haWindows:
      begin
      // let's first attempt using the taskview button
//      if not TaskbarTaskViewBtnClick then
        begin
        //this method works but ironically fails because it only works if app is elevated :V
        //GetWindowThreadProcessId(GetForegroundWindow, @procid);
        //if ProcessIsElevated(OpenProcess(PROCESS_ALL_ACCESS, False, procid)) then
          //SwitchToThisWindow(Application.Handle, True);

          //Windows.UI.Core.CoreWindow = classname of the Windows 10 Task View

          if ((Win32BuildNumber >= 22000) and (GetForegroundWindow = FindWindow('XamlExplorerHostIslandWindow', nil)))
          or ((Win32BuildNumber < 22000) and (GetForegroundWindow = FindWindow('Windows.UI.Core.CoreWindow', PChar(taskViewTitle)))) then
              THotkeyInvoker.Instance.InvokeHotKey('escape')
//            if GetForegroundWindow <> FindWindow('MultitaskingViewFrame','Vista Tareas') then  //XamlExplorerHostIslandWindow on Win11
//          if GetForegroundWindow = FindWindow('MultitaskingViewFrame', nil) then // for ctrl+alt+tab
//            THotkeyInvoker.Instance.InvokeHotKey('escape')
          else
          begin
            SwitchToThisWindowEx(Application.Handle, True);

//          ShellExecute(0, 'open', 'C:\Windows\explorer.exe', 'shell:::{3080F90E-D7AD-11D9-BD98-0000947B0257}', nil, SW_SHOWNORMAL);
//          keybd_event(VK_LWIN, MapVirtualKey(VK_LWIN, 0), 0, 0);
//          Sleep(10);
//          keybd_event(VK_TAB, MapVirtualKey(VK_TAB, 0), 0, 0);
//          Sleep(10);
//          keybd_event(VK_TAB, MapVirtualKey(VK_TAB, 0), KEYEVENTF_KEYUP, 0);
//          Sleep(100);
//          keybd_event(VK_LWIN, MapVirtualKey(VK_LWIN, 0), KEYEVENTF_KEYUP, 0);
//          Sleep(100);
            THotkeyInvoker.Instance.InvokeHotKey('_win+tab');
          end;
        end;
      end;
    haActionCenter:
      begin
//        SwitchToThisWindow(Application.Handle, True);
//        keybd_event(VK_LWIN, MapVirtualKey(VK_LWIN, 0), 0, 0);
//        Sleep(10);
//        keybd_event(Ord('A'), MapVirtualKey(Ord('A'), 0), 0, 0);
//        Sleep(10);
//        keybd_event(Ord('A'), MapVirtualKey(Ord('A'), 0), KEYEVENTF_KEYUP, 0);
//        Sleep(100);
//        keybd_event(VK_LWIN, MapVirtualKey(VK_LWIN, 0), KEYEVENTF_KEYUP, 0);
//        Sleep(100);
          THotkeyInvoker.Instance.InvokeHotKey('_win+a');
      end;
    haDesktop:
      begin
        SwitchToThisWindowEx(Application.Handle, True);
//        ShellExecute(0, 'open', 'C:\Windows\explorer.exe', 'shell:::{3080F90D-D7AD-11D9-BD98-0000947B0257}', nil, SW_SHOWNORMAL);
//        keybd_event(VK_LWIN, MapVirtualKey(VK_LWIN, 0), 0, 0);
//        Sleep(10);
//        keybd_event(Ord('D'), MapVirtualKey(Ord('D'), 0), 0, 0);
//        Sleep(10);
//        keybd_event(Ord('D'), MapVirtualKey(Ord('D'), 0), KEYEVENTF_KEYUP, 0);
//        Sleep(100);
//        keybd_event(VK_LWIN, MapVirtualKey(VK_LWIN, 0), KEYEVENTF_KEYUP, 0);
//        Sleep(100);
        THotkeyInvoker.Instance.InvokeHotKey('_win+d');
      end;
    haScreenSaver:
      begin
        SendMessage(Application.Handle, WM_SYSCOMMAND, SC_SCREENSAVE, 0);
      end;
    haMonitorOff:
      begin
        SendMessage(Application.Handle, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
      end;
    haCustomCmd:
      begin
        if frmAdvSettings.chkCustom.Checked then
        begin
          RunCommand(cmdcli[0], cmdarg[0], frmAdvSettings.chkHidden.Checked);
        end;
      end;
    haCustomCmd2:
      begin
        if frmAdvSettings.chkCustom.Checked then
        begin
          RunCommand(cmdcli[1], cmdarg[1], frmAdvSettings.chkHidden.Checked);
        end;
      end;
    haCustomCmd3:
      begin
        if frmAdvSettings.chkCustom.Checked then
        begin
          RunCommand(cmdcli[2], cmdarg[2], frmAdvSettings.chkHidden.Checked);
        end;
      end;
    haCustomCmd4:
      begin
        if frmAdvSettings.chkCustom.Checked then
        begin
          RunCommand(cmdcli[3], cmdarg[3], frmAdvSettings.chkHidden.Checked);
        end;
      end;
    haToggleOtherWindows:
      begin
        keybd_event(VK_LWIN, MapVirtualKey(VK_LWIN, 0), 0, 0);
        Sleep(10);
        keybd_event(VK_HOME, MapVirtualKey(VK_HOME, 0), 0, 0);
        Sleep(10);
        keybd_event(VK_HOME, MapVirtualKey(VK_HOME, 0), KEYEVENTF_KEYUP, 0);
        Sleep(100);
        keybd_event(VK_LWIN, MapVirtualKey(VK_LWIN, 0), KEYEVENTF_KEYUP, 0);
        Sleep(100);

      // to minimize, not yet included xD
      {Shell_SecondaryTrayWnd := FindWindow('Shell_SecondaryTrayWnd', nil);
      if IsWindow(GetForegroundWindow)
      and (GetForegroundWindow <> Shell_SecondaryTrayWnd)
       then
        PostMessage(GetForegroundWindow, WM_SYSCOMMAND, SC_MINIMIZE, 0);}
      end;
    haStartMenu:
      begin
        Perform(WM_SYSCOMMAND, SC_TASKLIST, 0);
      end;
    haNoAction:
      begin
      end;
  end;
end;

procedure TfrmMain.HotSpotAction(MPos: TPoint);
const
  HOTAREA = 10;
var
  Screen1: TRect;
  I: Integer;
  HotActionDelayEnabled: Boolean;

  function GetHotArea: THotArea;
  begin
    Result := haNone;
    if (MPos.X >= Screen1.Left) and (MPos.X < Screen1.Left + HOTAREA)
      and (MPos.Y >= Screen1.Top) and (MPos.Y < Screen1.Top + HOTAREA) then
        Result := haTopLeft
    else if (MPos.X > Screen1.Right - HotArea) and (MPos.X <= Screen1.Right - 1)
      and (MPos.Y >= Screen1.Top) and (MPos.Y < Screen1.Top + HotArea) then
        Result := haTopRight
    else if (MPos.X >= Screen1.Left) and (MPos.X < Screen1.Left + HotArea)
      and (MPos.Y <= Screen1.Bottom - 1) and (MPos.Y > Screen1.Bottom - HotArea) then
        Result := haBottomLeft
    else if (MPos.X <= Screen1.Right - 1) and (MPos.X > Screen1.Right - HotArea)
      and (MPos.Y <= Screen1.Bottom - 1) and (MPos.Y > Screen1.Bottom - HotArea) then
        Result := haBottomRight;
  end;
begin
  for I := 0 to Screen.MonitorCount - 1 do
  begin
    Screen1 := Screen.Monitors[I].BoundsRect;
    if (MPos.X >= Screen1.Left) and (MPos.X < Screen1.Right)
      and (MPos.Y >= Screen1.Top) and (MPos.Y < Screen1.Bottom)
    then
    begin // limit to check mouse coordinates within a monitor area

      hotActionDelay := frmAdvSettings.cbValDelayGlobal.ItemIndex + 1; // start from 1 loop, since 0 would be disabled
      case GetHotArea() of
        haTopLeft:
          begin
            hotActionStr := frmTrayPopup.XCombo1.Caption;
            HotActionDelayEnabled := frmAdvSettings.chkDelayGlobal.Checked or frmAdvSettings.chkDelayTopLeft.Checked;
            if frmAdvSettings.chkDelayTopLeft.Enabled then
              hotActionDelay := frmAdvSettings.cbValDelayTopLeft.ItemIndex + 1;
            frmOSD.Left := Screen1.Left;
            frmOSD.Top := Screen1.Top;
          end;
        haTopRight:
          begin
            hotActionStr := frmTrayPopup.XCombo2.Caption;
            HotActionDelayEnabled := frmAdvSettings.chkDelayGlobal.Checked or frmAdvSettings.chkDelayTopRight.Checked;
            if frmAdvSettings.chkDelayTopRight.Enabled then
              hotActionDelay := frmAdvSettings.cbValDelayTopRight.ItemIndex + 1;
            frmOSD.Left := Screen1.Right - frmOSD.Width;
            frmOSD.Top := Screen1.Top;
          end;
        haBottomLeft:
          begin
            hotActionStr := frmTrayPopup.XCombo3.Caption;
            HotActionDelayEnabled := frmAdvSettings.chkDelayGlobal.Checked or frmAdvSettings.chkDelayBotLeft.Checked;
            if frmAdvSettings.chkDelayBotLeft.Enabled then
              hotActionDelay := frmAdvSettings.cbValDelayBotLeft.ItemIndex + 1;
            frmOSD.Left := Screen1.Left;
            frmOSD.Top := Screen1.Bottom - frmOSD.Height;
          end;
        haBottomRight:
          begin
            hotActionStr := frmTrayPopup.XCombo4.Caption;
            HotActionDelayEnabled := frmAdvSettings.chkDelayGlobal.Checked or frmAdvSettings.chkDelayBotRight.Checked;
            if frmAdvSettings.chkDelayBotRight.Enabled then
              hotActionDelay := frmAdvSettings.cbValDelayBotRight.ItemIndex + 1;
            frmOSD.Left := Screen1.Right - frmOSD.Width;
            frmOSD.Top := Screen1.Bottom - frmOSD.Height;
          end;
        else
        begin
          OnHotSpot := False;
          frmOSD.Hide;
          break;// to no do the code below
        end;
      end; //.case of

      if not OnHotSpot then
      begin
        OnHotSpot := True;
        if Trim(hotActionStr) = '' then Exit;
        if not frmTrayPopup.XCheckbox1.Checked then Exit;
        // avoid usage if mouse is in use (buttons down e.g.)
        // if value is negative, it means is in use (aka held down)
        if (GetKeyState(VK_LBUTTON) < 0)
          or (GetKeyState(VK_MBUTTON) < 0)
          or (GetKeyState(VK_RBUTTON) < 0)
          then
            Exit;

        if HotActionDelayEnabled then
          begin
            hotActionDelayCounter := 0;
            tmrDelay.Enabled := True;
            if frmAdvSettings.chkShowCount.Checked then
            begin
              frmOSD.DrawBubble(IntToStr(hotActionDelay - hotActionDelayCounter));
              if frmAdvSettings.chkFullScreen.Checked then
              begin
                if not DetectFullScreenApp then
                  frmOSD.Show;
              end
              else
                frmOSD.Show;
            end;
          end
          else
            HotAction(hotActionStr);
        end;
      end;

    // let's break here since the other monitors won't be necessary to check against
    break;
  end;//
end;

procedure TfrmMain.Iconito(var Msg: TMessage);
var
  coord: TPoint;
begin
  if Msg.LParam = WM_RBUTTONUP then
  begin
    GetCursorPos(coord);
{    if IsWindowVisible(Form2.Handle) then
      About1.Enabled := False
    else
      About1.Enabled := True;}
    frmTrayPopup.Timer2.Enabled := False; // this will fix twice clicks on popup menu if form2 is visble
    frmTrayPopup.Close;
    PopupMenu1.Popup(coord.X, coord.Y);
    PostMessage(Handle, WM_NULL, 0, 0);
    SwitchToThisWindow(PopupMenu1.Handle, True);
  end
  else if Msg.LParam = WM_LBUTTONUP then
  begin
    if not IsWindowVisible(frmTrayPopup.Handle) then
    begin

      frmTrayPopup.Show;

    end
    else
      frmTrayPopup.Close
  end;


end;

procedure TfrmMain.Log(const Msg: string);
var
  TimeStamp: string;
begin
  if frmLogWindow.Visible then
  begin
    TimeStamp := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now);

    if frmLogWindow.Memo1.Lines.Count > 500 then
      frmLogWindow.Memo1.Lines.Clear;

    frmLogWindow.Memo1.Lines.Add(Format('[%s] %s', [TimeStamp, Msg]));
  end;
end;

procedure TfrmMain.LogWindow1Click(Sender: TObject);
begin
  frmLogWindow.Show;
end;

procedure TfrmMain.RegAutoStart(registerasrun: boolean);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);
    try
      if not registerasrun then
        reg.DeleteValue('WinXCorners')
      else
        reg.WriteString('WinXCorners', ParamStr(0));
    except
    end;
    reg.CloseKey;
  finally
    reg.Free;
  end;
end;

procedure TfrmMain.tmFullScreenClick(Sender: TObject);
begin
  tmFullScreen.Checked := not tmFullScreen.Checked;
  frmAdvSettings.chkFullScreen.Checked := tmFullScreen.Checked;
  frmAdvSettings.SaveAdvancedIni;
end;

procedure TfrmMain.tmrDelayTimer(Sender: TObject);
begin
  Inc(hotActionDelayCounter);
  if hotActionDelay = hotActionDelayCounter then
  begin
    if OnHotSpot then
      HotAction(hotActionStr);
    frmOSD.Hide;
    tmrDelay.Enabled := False;
  end;
  frmOSD.DrawBubble(IntToStr(hotActionDelay - hotActionDelayCounter));
end;

procedure TfrmMain.tmrHotSpotTimer(Sender: TObject);
var
  MPos: TPoint;
//  Desk: HDESK;
  Cur: THandle;
begin
  Exit;
//  Desk := OpenInputDesktop(0, False, READ_CONTROL or DESKTOP_READOBJECTS);
//  if Desk <> NULL then
//  begin
  Cur := 0;
  try
    // fix for some screen resolutions changing or some errors, avoid a hot screen accidental invoke
    if not Windows.GetCursorPos(MPos) then
      MPos := Point(120, 120);
      // LogonUI (Ctrl+Alt+Del) doesn't return GetForegroundWindow
    Cur := GetForegroundWindow;
  except
    Cur := 0;
//      CloseHandle(Desk);
    Exit;
  end;
  if cur = 0 then
    Exit;
//    CloseHandle(Desk);
//  end
//  else Exit;
//  frmAdvSettings.Caption := IntToStr(MPos.X);
  HotSpotAction(MPos);

end;

procedure TfrmMain.UpdateTrayIcon(grayed: boolean = False; recreate: Boolean = False);
var
  toUpdate: Boolean;
  usesLightTheme: Boolean;
begin
  if SystrayIcon = nil then
    SystrayIcon := TIcon.Create;

  usesLightTheme := SystemUsesLightTheme;

  if grayed then
    if usesLightTheme then
      SystrayIcon.Handle := LoadIcon(HInstance, 'Icon_1')
    else
      SystrayIcon.Handle := LoadIcon(HInstance, 'Icon_2')
  else
    if usesLightTheme then
      SystrayIcon.Handle := LoadIcon(HInstance, 'Icon_3')
    else
      SystrayIcon.Handle := LoadIcon(HInstance, 'Icon_1');

  toUpdate := False;
  
  if (iconData.Wnd <> 0) and not recreate then
    toUpdate := True;

  with iconData do
  begin
    {$ifdef ver360}
    cbSize := iconData.SizeOf;
    {$else}
    cbSize := SizeOf(iconData);
    {$endif}
    Wnd := Handle;
    uID := 100;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallbackMessage := WM_USER + 1;
    hIcon := SysTrayIcon.Handle;
    StrCopy(szTip, 'WinXCorners');
  end;

  if toUpdate then
    Shell_NotifyIcon(NIM_MODIFY, @iconData)
  else
    Shell_NotifyIcon(NIM_ADD, @iconData);
end;

{-$DEFINE DELPHI_STYLE_SCALING}

procedure TfrmMain.WMDpiChanged(var Message: TMessage);
{$IFDEF DELPHI_STYLE_SCALING}
  function FontHeightAtDpi(aDPI, aFontSize: integer): integer;
  var
    tmpCanvas: TCanvas;
  begin
    tmpCanvas := TCanvas.Create;
    try
      tmpCanvas.Handle := GetDC(0);
      tmpCanvas.Font.Assign(Self.Font);
      tmpCanvas.Font.PixelsPerInch := aDPI; // must be set before SIZE
      tmpCanvas.Font.Size := aFontSize;
      result := tmpCanvas.TextHeight('0');
    finally
      tmpCanvas.Free;
    end;
  end;
{$ENDIF}
begin
  inherited;
{$IFDEF DELPHI_STYLE_SCALING}
  ChangeScale(FontHeightAtDpi(LOWORD(Message.wParam), self.Font.Size), FontHeightAtDpi(self.PixelsPerInch, self.Font.Size));
{$ELSE}
  ChangeScale(LOWORD(Message.wParam), self.PixelsPerInch);
{$ENDIF}
  Self.PixelsPerInch := LOWORD(Message.WParam);
end;

procedure TfrmMain.WMMouseEvent(var Message: TMessage);
var
  Cur: THandle;
  MPos: TPoint;
begin
  Cur := 0;
  try
    // the DLL hook doesn't return correct coordinates
    if not Windows.GetCursorPos(MPos) then
    MPos := Point(120, 120);

    Cur := GetForegroundWindow; // it will likely fail on windows locked (Win+L)
  except
    Cur := 0;
  end;

  if Cur <> 0 then
  begin
    HotSpotAction(MPos);
  end;

  if frmLogWindow.Visible and frmLogWindow.chkMonMouse.Checked then
    Log(Format('X:%d, Y:%d',[MPos.X, MPos.Y]));
//  frmAdvSettings.Caption := IntToStr(MPos.X); // just to check if the mouse coordinates are correct

//  NotifyTargetReady; // tell the mouse hook we are ready for new messages
end;

procedure TfrmMain.WndProc(var Msg: TMessage);
begin
  if Msg.Msg = wmTaskbarRestartMsg then
  begin
    UpdateTrayIcon(False, True);
  end
  else if Msg.Msg = WM_SETTINGCHANGE then
  begin
    if Msg.WParam = WPARAM(SPI_SETFLATMENU) then // menues change coloring on light theme or dark theme
    begin
      UpdateTrayIcon();
      if not SystemUsesLightTheme then
      begin
        AllowDarkModeForWindow(Handle, True);
        AllowDarkModeForApp(True);
        SetPreferredAppMode(1);
        DarkMode;
      end
      else
      begin
        AllowDarkModeForWindow(Handle, False);
        AllowDarkModeForApp(False);
        SetPreferredAppMode(0);
        DarkMode;
      end;
    end;

  end;


  if Msg.Msg = WM_WTSSESSION_CHANGE then
  begin
    {TODO -oOwner -cGeneral : Improve enabling it after unlock if was manually disabled before lock}
    case Msg.WParam of
      WTS_SESSION_LOCK:
        begin
          if not frmTrayPopup.tempDisabled then
            frmTrayPopup.tempDisabled := True;
        end;
      WTS_SESSION_UNLOCK:
        begin
          frmTrayPopup.tempDisabled := False;
        end;
    end;
  end;

  inherited WndProc(Msg);
end;

procedure TfrmMain.About1Click(Sender: TObject);
begin
  MessageDlg('WinXCorners 1.3.1'#13#10'Author: vhanla'#13#10'https://apps.codigobit.info', mtInformation, [mbok], 0);
end;

procedure TfrmMain.Advanced1Click(Sender: TObject);
begin
  frmAdvSettings.Show;
end;

procedure TfrmMain.AutoStartState;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
    try
      if reg.ReadString('WinXCorners') <> '' then
        emporarydisabled1.Checked := True;
    except
    end;
    reg.CloseKey;
  finally
    reg.Free;
  end;
end;

procedure TfrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WinClassName := 'WinXCorners';
end;

procedure TfrmMain.CurrentDesktopChanged(Sender: TObject; OldDesktop,
  NewDesktop: TVirtualDesktop);
begin
  DesktopManager.MoveWindowToDesktop(Handle, NewDesktop);
end;

procedure TfrmMain.CurrentDesktopChangedW11(Sender: TObject; OldDesktop,
  NewDesktop: TVirtualDesktopW11);
begin
  DesktopManagerW11.MoveWindowToDesktop(Handle, NewDesktop);
end;

procedure TfrmMain.emporarydisabled1Click(Sender: TObject);
begin
  if emporarydisabled1.Checked then
    RegAutoStart(False)
  else
    RegAutoStart;

  emporarydisabled1.Checked := not emporarydisabled1.Checked;
end;

end.

