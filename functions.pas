(*
Functions that we will be using

Changelog:
22-11-15
- Add Windows 11 detection and apply rounded corners for systray popup window mainly.
22-07-11
- Add reinit functions from RichEdit demo, in order to reinitialize forms applying new language
20-09-27
- Detect if DirectX is running in full screen mode
20-09-07
- Detect Taskbar always on top status
20-08-12
- Detect FullScreen DirectX 3D apps
- Detect FullScreen normal apps
- Detect ShellExtensions to trigger correctly show desktop and task viewer
- Detect if start menu is shown
20-04-12
- GetCursorXY
19-06-06
- Support for light mode Windows 10 May 2019 Update
18-09-03
- Added detection of Acrylic Glass support Windows 10 1803 17134
16-08-07
- Added function to detect a process elevation
15-12-01
- Added uses OleAcc, Variants and imported DLL AccessibleChildren
- Added function TaskbarTaskViewButtonClick
*)
unit functions;

interface

uses
Windows, Forms, Classes, TlHelp32, PsAPI, SysUtils, Registry, Graphics, DWMApi, PNGImage{,
UXTHeme, Themes} {uxtheme and themes for rendering text on glass },
OleAcc, Variants, DirectDraw, ActiveX, ShellApi;

type
  AccentPolicy = packed record
    AccentState: Integer;
    AccentFlags: Integer;
    GradientColor: Integer;
    AnimationId: Integer;
  end;

  TWinCompAttrData = packed record
    attribute: THandle;
    pData: Pointer;
    dataSize: ULONG;
  end;

function ProcessIsElevated(Process: Cardinal): Boolean;
function GetProcessNameFromWnd(Wnd: HWND): string;
function isWindows10: boolean;
function isWindows11: boolean;
function isAcrylicSupported:boolean;
function SystemUsesLightTheme:boolean;
procedure EnableBlur(Wnd: HWND; Enable: Boolean = True);
function GetAccentColor:TColor;
function TaskbarTranslucent:Boolean;
function TaskbarAccented:Boolean;
procedure SetAlphaColorPicture(const Col: TColor; const Alpha: Integer; Picture: TPicture);
function GetRectOfPrimaryMonitor(const WorkArea: Boolean): TRect;
function BlendColors(Col1, Col2: TColor; A: Byte): TColor;
function CreatePreMultipliedRGBQuad(Color: TColor; Alpha: Byte = $FF): TRGBQuad;
function CreateSolidBrushWithAlpha(Color: TColor; Alpha: Byte = $FF): HBRUSH;
function TaskbarTaskViewBtnClick: Boolean;
{procedure DrawGlassText(Canvas: TCanvas; GlowSize: Integer; var Rect: TRect;
  var Text: UnicodeString; Format: DWORD); overload;}
function GetCursorXY: TPoint;

  procedure SwitchToThisWindow(h1: hWnd; x: bool); stdcall;
  external user32 Name 'SwitchToThisWindow';
function SetWindowCompositionAttribute(Wnd: HWND; const AttrData: TWinCompAttrData): BOOL; stdcall;
  external user32 Name 'SetWindowCompositionAttribute';

function AccessibleChildren(paccContainer: Pointer; iChildStart: LONGINT;
                             cChildren: LONGINT; out rgvarChildren: OleVariant;
                             out pcObtained: LONGINT): HRESULT; stdcall;
                             external 'OLEACC.DLL' name 'AccessibleChildren';

function IsDirectXAppRunningFullScreen: Boolean;
function DetectFullScreen3D: Boolean;
function DetectFullScreenApp: Boolean;
function DetectShellTaskSwitch: Boolean;
function DetectShellShowDesktop: Boolean;
function IsStartMenuVisible: Boolean;
function IsTaskbarAlwaysOnTop: Boolean;
function _Gui_BuildWindowList(in_hDesk: HDESK; in_hWnd: HWND; in_EnumChildren: BOOL;
         in_RemoveImmersive: BOOL; in_ThreadID: UINT; out out_Cnt: Integer): PHandle;
function GetShellWindow:HWND;stdcall;
    external user32 Name 'GetShellWindow';
function RtlGetVersion(var RTL_OSVERSIONINFOEXW): LONG; stdcall;
  external 'ntdll.dll' Name 'RtlGetVersion';

procedure ReinitializeForms;
function LoadNewResourceModule(Locale: LCID): LongInt;

implementation

{ ReInit}
uses Controls, Messages;

type
  TAsInheritedReader = class(TReader)
  public
    procedure ReadPrefix(var Flags: TFilerFlags; var AChildPos: Integer); override;
  end;
{!ReInit}

const
//https://stackoverflow.com/a/22105803/537347 Windows 8 or newer only
  IID_AppVisibility: TGUID = '{2246EA2D-CAEA-4444-A3C4-6DE827E44313}';
  CLSID_AppVisibility: TGUID = '{7E5FE3D9-985F-4908-91F9-EE19F9FD1514}';
type
  MONITOR_APP_VISIBILITY = (
    MAV_UNKNOWN = 0,
    MAV_NO_APP_VISIBLE = 1,
    MAV_APP_VISIBLE = 2
  );
// *********************************************************************//
// Interface: IAppVisibilityEvents
// Flags:     (0)
// GUID:      {6584CE6B-7D82-49C2-89C9-C6BC02BA8C38}
// *********************************************************************//
  IAppVisibilityEvents = interface(IUnknown)
    ['{6584CE6B-7D82-49C2-89C9-C6BC02BA8C38}']
    function AppVisibilityOnMonitorChanged(hMonitor: HMONITOR;
              previousMode: MONITOR_APP_VISIBILITY;
              currentMode: MONITOR_APP_VISIBILITY):HRESULT; stdcall;
    function LauncherVisibilityChange(currentVisibleState: BOOL): HRESULT; stdcall;
  end;
// *********************************************************************//
// Interface: IAppVisibility
// Flags:     (0)
// GUID:      {2246EA2D-CAEA-4444-A3C4-6DE827E44313}
// *********************************************************************//
  IAppVisibility = interface(IUnknown)
    ['{2246EA2D-CAEA-4444-A3C4-6DE827E44313}']
    function GetAppVisibilityOnMonitor(monitor: HMONITOR; out pMode: MONITOR_APP_VISIBILITY): HRESULT; stdcall;
    function IsLauncherVisible(out pfVisible: BOOL): HRESULT; stdcall;
    function Advise(pCallBack: IAppVisibilityEvents; out pdwCookie: DWORD): HRESULT; stdcall;
    function Unadvise(dwCookie: DWORD): HRESULT; stdcall;
  end;

//http://stackoverflow.com/questions/95912/how-can-i-detect-if-my-process-is-running-uac-elevated-or-not
function ProcessIsElevated(Process: Cardinal): Boolean;
var
  hToken, hProcess : THandle;
  pTokenInformation: Pointer;
  ReturnLength: DWORD;
  TokenInformation: TTokenElevation;
begin
  //hProcess := GetCurrentProcess;
  hProcess := Process;
  try
    if OpenProcessToken(hProcess, TOKEN_QUERY, hToken) then
    try
      TokenInformation.TokenIsElevated := 0;
      pTokenInformation := @TokenInformation;
      GetTokenInformation(hToken, TokenElevation, pTokenInformation, SizeOf(TokenInformation), ReturnLength);
      Result := (TokenInformation.TokenIsElevated > 0);
    finally
      CloseHandle(hToken);
    end;
  except
    Result := False;
  end;
end;

// This procedure assumes WinXP or superior only : suorce http://www.delphitricks.com/source-code/windows/get_exe_path_from_window_handle.html
function GetProcessNameFromWnd(Wnd: HWND): string;

  function RunningProcessesList(const List: TStrings; FullPath: Boolean): Boolean;

    function ProcessFilename(PID: DWORD): string;
    var
      Handle: THandle;
    begin
      Result := '';
      Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
      if Handle <> 0 then
      try
        SetLength(Result, MAX_PATH);
        if FullPath then
        begin
          if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
            SetLength(Result, strlen(PChar(Result)))
          else
            Result := '';
        end
        else
        begin
          if GetModuleBaseName(Handle, 0, PChar(Result), MAX_PATH) > 0 then
            SetLength(Result, StrLen(PChar(Result)))
          else
            Result := '';
        end;
      finally
        CloseHandle(Handle);
      end;
    end;

  var
    SnapProcHandle: THandle;
    ProcEntry: TProcessEntry32;
    NextProc: Boolean;
    Filename: string;
  begin
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
    try
      ProcEntry.dwSize := SizeOf(ProcEntry);
      NextProc := Process32First(SnapProcHandle, ProcEntry);
      while NextProc do
      begin
        if ProcEntry.th32ProcessID = 0 then
        begin
          Filename := 'System Idle Process';
        end
        else begin
          Filename := ProcessFilename(ProcEntry.th32ProcessID);
          if Filename = '' then
            Filename := ProcEntry.szExeFile;
        end;
        List.AddObject(Filename, Pointer(ProcEntry.th32ProcessID));
        NextProc := Process32Next(SnapProcHandle, ProcEntry);
      end;
    finally
      CloseHandle(SnapProcHandle);
    end;
  end;
var
  List: TStringList;
  PID: DWORD;
  I: Integer;
begin
  Result := '';
  if IsWindow(Wnd) then
  begin
    PID := INVALID_HANDLE_VALUE;
    GetWindowThreadProcessId(Wnd, @PID);
    List := TStringList.Create;
    try
      if RunningProcessesList(List, True) then
      begin
        I := List.IndexOfObject(Pointer(PID));
        if I > -1 then
          Result := List[I];
      end;
    finally
      List.Free;
    end;
  end;

end;

(* IsWindows10 function supports official RTM and above only *)
function isWindows10:boolean;
var
  Reg: TRegistry;
begin
  Result := False;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows NT\CurrentVersion') then
    begin
      if Reg.ValueExists('CurrentVersion') then
        if (Reg.ReadString('CurrentVersion') = '6.3')
        and (StrToInt (Reg.ReadString('CurrentBuildNumber')) >= 10240) then
          Result := True;
    end;
  finally
    Reg.Free;
  end;
end;

function isWindows11:Boolean;
var
  winver: RTL_OSVERSIONINFOEXW;
begin
  Result := False;
  if ((RtlGetVersion(winver) = 0) and (winver.dwMajorVersion>=10) and (winver.dwBuildNumber > 22000))  then
    Result := True;
end;

// Check Windows 10 RS4 version which onwards supports Acrylic Glass
function isAcrylicSupported:boolean;
var
  Reg: TRegistry;
begin
  Result := False;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows NT\CurrentVersion') then
    begin
      if Reg.ValueExists('CurrentVersion') then
        if (Reg.ReadString('CurrentVersion') = '6.3')
        and (StrToInt(Reg.ReadString('CurrentBuildNumber')) >= 17134) then
          Result := True;
    end;
  finally
    Reg.Free;
  end;
end;

// Checks whether registry value which registers system's light mode is on
function SystemUsesLightTheme:boolean;
var
  Reg: TRegistry;
begin
  Result := False;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Themes\Personalize') then
    begin
      if Reg.ValueExists('SystemUsesLightTheme') then
        if (Reg.ReadInteger('SystemUsesLightTheme') = 1) then
          Result := True;
    end;
  finally
    Reg.Free;
  end;
end;

const

  //
  // More information:
  //      https://docs.microsoft.com/en-us/windows/apps/desktop/modernize/apply-rounded-corners
  //      https://docs.microsoft.com/en-us/windows/win32/api/dwmapi/ne-dwmapi-dwmwindowattribute
  //      https://docs.microsoft.com/en-us/windows/win32/api/dwmapi/nf-dwmapi-dwmsetwindowattribute
  //

  DWMWCP_DEFAULT    = 0; // Let the system decide whether or not to round window corners
  DWMWCP_DONOTROUND = 1; // Never round window corners
  DWMWCP_ROUND      = 2; // Round the corners if appropriate
  DWMWCP_ROUNDSMALL = 3; // Round the corners if appropriate, with a small radius

  DWMWA_WINDOW_CORNER_PREFERENCE = 33; // [set] WINDOW_CORNER_PREFERENCE, Controls the policy that rounds top-level window corners



procedure EnableBlur(Wnd: HWND; Enable: Boolean = True);
const
  WCA_ACCENT_POLICY = 19;
  ACCENT_NORMAL = 0;
  ACCENT_ENABLE_GRADIENT = 1;
  ACCENT_ENABLE_TRANSPARENTGRADIENT = 2;
  ACCENT_ENABLE_BLURBEHIND = 3;
  ACCENT_ENABLE_ACRYLICBLURBEHIND = 4;
  DRAW_LEFT_BORDER = $20;
  DRAW_TOP_BORDER = $40;
  DRAW_RIGHT_BORDER = $80;
  DRAW_BOTTOM_BORDER = $100;
var
  data: TWinCompAttrData;
  accent: AccentPolicy;
begin
  if Enable then
  begin
    if isAcrylicSupported then    
      accent.AccentState := ACCENT_ENABLE_ACRYLICBLURBEHIND
    else
      accent.AccentState := ACCENT_ENABLE_BLURBEHIND
  end
  else
  accent.AccentState := ACCENT_NORMAL;
  accent.AccentFlags := DRAW_LEFT_BORDER or DRAW_TOP_BORDER or DRAW_RIGHT_BORDER or DRAW_BOTTOM_BORDER;

  data.attribute := WCA_ACCENT_POLICY;
  data.dataSize := SizeOf(accent);
  data.pData := @accent;
  SetWindowCompositionAttribute(Wnd, data);

  if isWindows11  then
  begin
    var DWM_WINDOW_CORNER_PREFERENCE: Cardinal;
    DWM_WINDOW_CORNER_PREFERENCE := DWMWCP_ROUND;
     DwmSetWindowAttribute(Wnd, DWMWA_WINDOW_CORNER_PREFERENCE, @DWM_WINDOW_CORNER_PREFERENCE, sizeof(DWM_WINDOW_CORNER_PREFERENCE));

  end;
end;

function GetAccentColor:TColor;
var
  col: Cardinal;
  opaque: LongBool;
  newColor: TColor;
  a,r,g,b: byte;
begin
  DwmGetColorizationColor(col, opaque);
  a := Byte(col shr 24);
  r := Byte(col shr 16);
  g := Byte(col shr 8);
  b := Byte(col);


  newcolor := RGB(
      round(r*(a/255)+255-a),
      round(g*(a/255)+255-a),
      round(b*(a/255)+255-a)
  );

  Result := newcolor;
end;

function TaskbarTranslucent: Boolean;
var
  reg: TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize');
    try
      if reg.ValueExists('EnableTransparency') then
        if reg.ReadInteger('EnableTransparency') = 1 then
        Result := True;
    except
      Result := False;
    end;
    reg.CloseKey;

  finally
    reg.Free;
  end;
end;

function TaskbarAccented:Boolean;
var
  reg: TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize');
    try
      if reg.ValueExists('ColorPrevalence') then
        if reg.ReadInteger('ColorPrevalence') = 1 then
        Result := True;
    except
      Result := False;
    end;
    reg.CloseKey;

  finally
    reg.Free;
  end;
end;

procedure SetAlphaColorPicture(const Col: TColor; const Alpha: Integer; Picture: TPicture);
var
  png: TPngImage;
  J: Integer;
  sl: pByteArray;
begin
    png := TPNGImage.CreateBlank(COLOR_RGBALPHA, 8, 10, 10);
    try
      png.Canvas.Brush.Color := Col;
      png.Canvas.FillRect(Rect(0,0,10,10));
      for J := 0 to png.Height - 1 do
      begin
        sl := png.AlphaScanline[J];
        FillChar(sl^, png.Width, Alpha);
      end;
      Picture.Assign(png);
    finally
      png.Free;
    end;

end;

function GetRectOfPrimaryMonitor(const WorkArea: Boolean): TRect;
begin
  if not WorkArea or not SystemParametersInfo(SPI_GETWORKAREA, 0, @Result, 0) then
  Result := Rect(0, 0, GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN));

end;

{Credits to Roy M Klever http://rmklever.com/?p=116}
function BlendColors(Col1, Col2: TColor; A: Byte): TColor;
var
  c1,c2: LongInt;
  r,g,b,v1,v2: byte;
begin
  A := Round(2.55 * A);
  c1 := ColorToRGB(Col1);
  c2 := ColorToRGB(Col2);
  v1 := Byte(c1);
  v2 := Byte(c2);
  r := A * (v1 - v2) shr 8 + v2;
  v1 := Byte(c1 shr 8);
  v2 := Byte(c2 shr 8);
  g := A * (v1 - v2) shr 8 + v2;
  v1 := Byte(c1 shr 16);
  v2 := Byte(c2 shr 16);
  b := A * (v1 - v2) shr 8 + v2;
  Result := (b shl 16) + (g shl 8) + r;
end;


// Functions to create alpha channel aware brushes to paint on canvas
// from Delphi Haven https://delphihaven.wordpress.com/2010/09/06/custom-drawing-on-glass-2/
function CreatePreMultipliedRGBQuad(Color: TColor; Alpha: Byte = $FF): TRGBQuad;
  begin
    Color := ColorToRGB(Color);
    Result.rgbBlue := MulDiv(GetBValue(Color), Alpha, $FF);
    Result.rgbGreen := MulDiv(GetGValue(Color), Alpha, $FF);
    Result.rgbRed := MulDiv(GetRValue(Color), Alpha, $FF);
    Result.rgbReserved := Alpha;
  end;
function CreateSolidBrushWithAlpha(Color: TColor; Alpha: Byte = $FF): HBRUSH;
  var
    Info: TBitmapInfo;
  begin
    FillChar(Info, SizeOf(Info), 0);
    with Info.bmiHeader do
    begin
      biSize := SizeOf(Info.bmiHeader);
      biWidth := 1;
      biHeight := 1;
      biPlanes := 1;
      biBitCount := 32;
      biCompression := BI_RGB;
    end;
    Info.bmiColors[0] := CreatePreMultipliedRGBQuad(Color, Alpha);
    Result := CreateDIBPatternBrushPt(@Info, 0);
  end;

// Using IAccessible we first capture the tasview button handle then trigger iaccessible default action
function TaskbarTaskViewBtnClick: Boolean;
var
  btnHandle: HWND;
  res : HRESULT;
  Acc, ChildAccessible: IAccessible;
  btnCaption, ChildName: WideString;
  iChildCount, iObtained: Integer;
  ChildArray: array of OleVariant;
  ChildDispatch: IDispatch;
  I: Integer;
begin
  Result := False;

  btnHandle := FindWindow('Shell_TrayWnd', nil);
  if btnHandle > 0 then
  begin
    btnHandle := FindWindowEx(btnHandle, 0, 'TrayButton', nil);
    if not IsWindowVisible(btnHandle) then
    //ShowMessage('Task View Button is hidden');
      Exit;

    if (btnHandle > 0 ) then
    begin
      //PostMessage(btnHandle, WM_LBUTTONUP, 0, 0);
      res := AccessibleObjectFromWindow(btnHandle, 0, IID_IAccessible, Acc);
      if res = S_OK then
      begin
        if Acc.Get_accName(CHILDID_SELF, btnCaption) = S_OK then
        begin
          //memo1.Lines.Add('btnCaption: '+btnCaption);
        end
        else
          Exit;


        // Let's find the correct button whic is named as previous btnCaption
        // i.e. previous name found was 'Vista de tareas', so the button child is named the same
        // that is our trigger access
        if (Acc.Get_accChildCount(iChildCount) = S_OK) and (iChildCount > 0) then
        begin
          //memo1.Lines.Add('Childs:'+IntToStr(iChildCount));

          SetLength(ChildArray, iChildCount);
          if AccessibleChildren(Pointer(Acc), 0, iChildCount, ChildArray[0], iObtained) = S_OK then
          begin
            for I := 0 to iObtained - 1 do
            begin
              ChildDispatch := nil;
              if VarType(ChildArray[I]) = varDispatch then
              begin
                ChildDispatch := ChildArray[I];
                if (ChildDispatch <> nil) and (ChildDispatch.QueryInterface(IAccessible, ChildAccessible) = S_OK) then
                begin
                  if (ChildAccessible.Get_accName(CHILDID_SELF, ChildName) = S_OK) and (ChildName = btnCaption) then
                  begin
                    //Memo1.Lines.Add('ChildName: ' + ChildName);
                    if ChildAccessible.Get_accDefaultAction(CHILDID_SELF, btnCaption) = S_OK then
                    begin
                      //memo1.Lines.Add('Default Action: ' + btnCaption);
                      //ChildAccessible.accSelect(SELFLAG_TAKEFOCUS, CHILDID_SELF);
                      if ChildAccessible.accDoDefaultAction(CHILDID_SELF) = S_OK then
                        Result := True;
                    end;
                  end;
                end;
              end;

            end;
          end;

        end;

      end;
    end;
  end;
end;
{  procedure DrawGlassText(Canvas: TCanvas; GlowSize: Integer; var Rect: TRect;
  var Text: UnicodeString; Format: DWORD); overload;
var
  DTTOpts: TDTTOpts;
begin
  if Win32MajorVersion < 6 then
  begin
    DrawTextW(Canvas.Handle, PWideChar(Text), Length(Text), Rect, Format);
    Exit;
  end;
  ZeroMemory(@DTTOpts, SizeOf(DTTOpts));
  DTTOpts.dwSize := SizeOf(DTTOpts);
  DTTOpts.dwFlags := DTT_COMPOSITED or DTT_TEXTCOLOR;
  if Format and DT_CALCRECT = DT_CALCRECT then
    DTTOpts.dwFlags := DTTOpts.dwFlags or DTT_CALCRECT;
  DTTOpts.crText := ColorToRGB(Canvas.Font.Color);
  if GlowSize > 0 then
  begin
    DTTOpts.dwFlags := DTTOpts.dwFlags or DTT_GLOWSIZE;
    DTTOpts.iGlowSize := GlowSize;
  end;
  with ThemeServices.GetElementDetails(teEditTextNormal) do
    DrawThemeTextEx(ThemeServices.Theme[teEdit], Canvas.Handle, Part, State,
      PWideChar(Text), Length(Text), Format, @Rect, DTTOpts);
end;}

function GetCursorXY:TPoint;
begin
  if not Windows.GetCursorPos(Result) then
  begin
    Result := Point(Screen.Width div 2, Screen.Height div 2);
  end;
end;

function IsDirectXAppRunningFullScreen;
var
  LSPI: Boolean;
begin
  if SystemParametersInfo(SPI_GETCURSORSHADOW, 0, @LSPI, 0) and not LSPI then
  begin
    if SystemParametersInfo(SPI_GETHOTTRACKING, 0, @LSPI, 0) and not LSPI then
    begin
      Result := DetectFullScreen3D;
    end;
  end;
end;

function DetectFullScreen3D: Boolean;
var
  DW: IDirectDraw7;
  HR: HRESULT;
begin
  Result := False;

  HR := coinitialize(nil);
  if Succeeded(HR) then
  begin
    HR := DirectDrawCreateEx(PGUID(DDCREATE_EMULATIONONLY), DW, IDirectDraw7, nil);
    if HR = DD_OK then
    begin
      HR := DW.TestCooperativeLevel;
      if HR = DDERR_EXCLUSIVEMODEALREADYSET then
        Result := True;
    end;
  end;

  CoUninitialize;
end;

function DetectFullScreenApp: Boolean;
var
  curwnd: HWND;
  wndPlm: WINDOWPLACEMENT;
  R: TRect;
  Mon: TMonitor;
begin
  Result := False;
  curwnd := GetForegroundWindow;
  if curwnd <= 0 then Exit;

  // ignore maximized windows with caption bar
  if GetWindowLong(curwnd, GWL_STYLE) and WS_CAPTION = WS_CAPTION then
    Exit;

  if not IsWindow(curwnd) then Exit;
  if curwnd = GetShellWindow then Exit;
  // Exclude WorkerW that have ClassName:SHELLDLL_DefView child since it is the Desktop hwnd
  if FindWindowEx(curwnd, 0, 'SHELLDLL_DefView', nil) > 0 then Exit;


  Mon := Screen.MonitorFromWindow(curwnd);
  GetWindowRect(curwnd, R);
  GetWindowPlacement(curwnd, wndPlm);
  if (wndPlm.showCmd and SW_SHOWMAXIMIZED) = SW_SHOWMAXIMIZED then
  begin
    if (Mon.BoundsRect.Width = R.Width) and (Mon.BoundsRect.Height = R.Height) then
      Result := True;
  end
  else
  begin
    // some applications do not set SW_SHOWMAXIMIZED flag e.g. MPC-HC media player
    // ignore maximized when workarearect is similar (i.e. taskbar is on top, might not be the same on secondary monitor)
//    if IsTaskbarAlwaysOnTop then
//    begin
//      if (Screen.MonitorCount > 1) and (Mon.Handle =
//    if ((Screen.MonitorCount > 1) and (FindWindow('Shell_SecondaryTrayWnd', nil)<>0) and (Mon.WorkareaRect <> Mon.BoundsRect))
//    // if there is another monitor without taskbar then
//    or ((Screen.MonitorCount > 1) and (FindWindow('Shell_SecondaryTrayWnd', nil)=0) and (Mon.WorkareaRect = Mon.BoundsRect))
//    then
    begin
      if (Mon.BoundsRect.Width = R.Width) and (Mon.BoundsRect.Height = R.Height) then
        Result := True;
   // end;
    end;
  end;
end;

function DetectShellTaskSwitch: Boolean;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;
    reg.OpenKeyReadOnly('CLSID');
    Result := reg.KeyExists('{3080F90E-D7AD-11D9-BD98-0000947B0257}');
  finally
    reg.Free;
  end;
end;

function DetectShellShowDesktop: Boolean;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;
    reg.OpenKeyReadOnly('CLSID');
  finally
    Result := reg.KeyExists('{3080F90D-D7AD-11D9-BD98-0000947B0257}');
    reg.Free;
  end;
end;

function IsStartMenuVisible: Boolean;
var
  acc: IAppVisibility;
  res: HRESULT;
  isLauncherVisible: BOOL;
begin
  Result := False;
  // Initialization of COM is required to use the AppVisibility (CLSID_AppVisibility) object
  res := CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  if Succeeded(res) then
  begin
    // Create the App Visibility component
    res := CoCreateInstance(CLSID_AppVisibility, nil, CLSCTX_ALL, IID_AppVisibility, acc);
    if Succeeded(res) then
    begin
      res := acc.IsLauncherVisible(isLauncherVisible);
      if Succeeded(res) then
        Result := Boolean(isLauncherVisible);
    end;

  end;
  CoUninitialize;
end;

function IsTaskbarAlwaysOnTop: Boolean;
var
  ABData: TAppBarData;
begin
  Result := False;
  ABData.cbSize := SizeOf(TAppBarData);
  if (SHAppBarMessage(ABM_GETSTATE, ABData) and ABS_AUTOHIDE) = ABS_AUTOHIDE then
    Result := True;
end;

function _Gui_BuildWindowList(in_hDesk: HDESK; in_hWnd: HWND; in_EnumChildren: BOOL;
         in_RemoveImmersive: BOOL; in_ThreadID: UINT; out out_Cnt: Integer): PHandle;
var
  lv_Max: UINT;
  lv_Cnt: UINT;
  lv_NtStatus: UINT;
  lv_List: PHandle;
begin
//  initwin32

end;

{ TAsInheritedReader }

procedure TAsInheritedReader.ReadPrefix(var Flags: TFilerFlags;
  var AChildPos: Integer);
begin
  inherited ReadPrefix(Flags, AChildPos);
  Include(Flags, ffInherited);
end;

{ ReInit}

function InternalReloadComponentRes(const ResName: String; HInst: THandle; var Instance: TComponent): Boolean;
var
  HRsrc: THandle;
  ResStream: TResourceStream;
  AsInheritedReader: TAsInheritedReader;
begin                   { avoid possible EResNotFound exception }

  if HInst = 0 then HInst := HInstance;
  Result := HRsrc <> 0;
  if not Result then Exit;
  ResStream := TResourceStream.Create(HInst, ResName, RT_RCDATA);
  try
    AsInheritedReader := TAsInheritedReader.Create(ResStream, 4096);
    try
      Instance := AsInheritedReader.ReadRootComponent(Instance);
    finally
      AsInheritedReader.Free;
    end;
  finally
    ResStream.Free;
  end;
  Result := True;
end;

function ReloadInheritedComponent(Instance: TComponent; RootAncestor: TClass): Boolean;
  function InitComponent(ClassType: TClass): Boolean;
  begin
    Result := False;
    if (ClassType = TComponent) or (ClassType = RootAncestor) then Exit;
    Result := InitComponent(ClassType.ClassParent);
    Result := InternalReloadComponentRes(ClassType.ClassName, FindResourceHInstance(
      FindClassHInstance(ClassType)), Instance) or Result;
  end;
begin
  Result := InitComponent(Instance.ClassType);
end;

procedure ReinitializeForms;
var
  Count: Integer;
  I: Integer;
  Form: TForm;
begin
  Count := Screen.FormCount;
  for I := 0 to Count - 1 do
  begin
    Form := Screen.Forms[I];
    ReloadInheritedComponent(Form, TForm);
  end;

end;

function SetResourceHInstance(NewInstance: LongInt): LongInt;
var
  CurModule: PLibModule;
begin
  CurModule := LibModuleList;
  Result := 0;
  while CurModule <> nil do
  begin
    if CurModule.Instance = HInstance then
    begin
      if CurModule.ResInstance <> CurModule.Instance then
        FreeLibrary(CurModule.ResInstance);
      CurModule.ResInstance := NewInstance;
      Result := NewInstance;
      Exit;
    end;
    CurModule := CurModule.Next;
  end;
end;

function LoadNewResourceModule(Locale: LCID): LongInt;
var
  FileName: array [0..260] of Char;
  P: PChar;
  LocaleName: array [0..4] of Char;
  NewInst: LongInt;
begin
  GetModuleFileName(HInstance, FileName, SizeOf(FileName));
  GetLocaleInfo(Locale, LOCALE_SABBREVLANGNAME, LocaleName, SizeOf(LocaleName));
  P := PChar(@FileName) + lstrlen(FileName);
  while (P^ <> '.') and (P <> @FileName) do Dec(P);
  NewInst := 0;
  Result := 0;
  if P <> @FileName then
  begin
    Inc(P);
    if LocaleName[0] <> #0 then
    begin
      // Then look for a potential language/country translation
      lstrcpy(P, LocaleName);
      NewInst := LoadLibraryEx(FileName, 0, LOAD_LIBRARY_AS_DATAFILE);
      if NewInst = 0 then
      begin
        // Finally look for a language only translation
        LocaleName[2] := #0;
        lstrcpy(P, LocaleName);
        NewInst := LoadLibraryEx(FileName, 0, LOAD_LIBRARY_AS_DATAFILE);
      end;

    end;

  end;
  if NewInst <> 0 then
    Result := SetResourceHInstance(NewInst);
end;

end.
