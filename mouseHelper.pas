unit mouseHelper;

interface

uses
  Vcl.ExtCtrls, System.Classes, Winapi.Windows, Winapi.Messages, Vcl.Forms,
  Winapi.ShellAPI, Generics.Collections;

type
  TRunHook = procedure(Handle: HWND); cdecl;
  TKillHook = procedure; cdecl;

  // Monitor's handling
  TMsonitor = record
    FMonitorRect: TRect;
  end;

  // Dynamically load the WinXHelper mouse WM_MOUSE global hook
  THotMouseEvent = (meTopLeft, meTop, meTopRigh, meLeft, meBotLeft, meBot, meBotRight);

  // A non visible component that has WNDProc to receive messages from MouseHook.dll
  THotMouse = class(TComponent)
  private
    FMonitors: TList<TMonitor>;

    FInterval: Cardinal;
    FWindowHandle: HWND;
    FOnTimer: TNotifyEvent;
    FEnabled: Boolean;

    FX, FY: Cardinal;
    FHiddenWindowHandle: HWND;
    FParentWindow: HWND;
    FPrevWndProc: Pointer;
    FWndProcMethod: TWndMethod;

    // Handling optional (but recommended) dll global mouse hook
    FUseDllHook: Boolean; // This is better than the timer itself than of polling mousepos calls each time
    RunHook: TRunHook;
    KillHook: TKillHook;
    DllHandle: HMODULE;
    // However, it won't return values if this app runs non elevated while foreground window is elevated
    // IDEA: it run non elevated, let's fallback to normal timer method
    // but I guess it will require to use another hook to check window focus changes
    // and most likely another (x64 hook too) platform, even though Win11 is 64 bit only
    // yet there runs x86 apps.

    // Hot spot detection
    FCursorOnBlank: Boolean;
    FCursorOnBlankTimeStamp: Cardinal; // last time seen in that position
    FCursorOnHotSpot: Boolean;
    FCursorOnHotSpotTimeStamp: Cardinal; // last time seen in that position
    FCursorOnKnockSpot: Boolean;
    FCursorOnKnockSpotTimeStamp: Cardinal; // last time seen in that location
    FCursorOnKnockCount: Integer; // times to knock this hot spot
    // Shift keys to monitor, only considered if they're held since a blank area, not in the hotspot
    FShiftPressedFromBlank: Boolean;
    FAltPressedFromBlank: Boolean;
    FCtrlPressedFromBlank: Boolean;

    procedure UpdateMonitors;

    procedure SubWndProc(var Msg: TMessage);
    procedure UpdateTimer;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure WndProc(var Msg: TMessage);
  protected
    procedure Timer; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ParentWindow: HWND read FParentWindow write FParentWindow;
  published
    property X: Cardinal read FX;
    property Y: Cardinal read FY;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
  end;

implementation

uses
  sharedDefs;

{ TMouseHelper }

constructor THotMouse.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FInterval := 1000; // milliseconds
  FWindowHandle := AllocateHWnd(WndProc);
  FHiddenWindowHandle := AllocateHWnd(SubWndProc);

  // Assign our component the parent form for the subclassing to work
  if Assigned(AOwner) and (AOwner is TForm) then
    FParentWindow := TForm(AOwner).Handle;

  // SubClass the parent Form (class name WinXCorners in order to receive messages from WinXHelper.dll
  FPrevWndProc := Pointer(SetWindowLongPtr(FParentWindow, GWLP_WNDPROC, LONG_PTR(FHiddenWindowHandle)));

  // Monitor's handling
  FMonitors := TList<TMonitor>.Create;
end;

destructor THotMouse.Destroy;
begin
  FMonitors.Free;

  // Restore the original WndProc before deallocating the hidden window
  SetWindowLongPtr(FParentWindow, GWLP_WNDPROC, LONG_PTR(FPrevWndProc));
  DeallocateHWnd(FHiddenWindowHandle);

  FEnabled := False;
  if FWindowHandle <> 0 then
  begin
    UpdateTimer;
    DeallocateHWnd(FWindowHandle);
    FWindowHandle := 0;
  end;

  inherited Destroy;
end;

procedure THotMouse.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure THotMouse.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure THotMouse.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value;
  UpdateTimer;
end;

procedure THotMouse.SubWndProc(var Msg: TMessage);
var
  Mods: TKeyStatus;
  Data: PCopyDataStruct;
  Mous: PMouseHookStruct;
  CopyDataHandled: Boolean;
begin
  CopyDataHandled := False;

  case Msg.Msg of
    WM_KEYSTATUSCHANGED:
    begin
      Mods := PKeyStatus(Msg.LParam)^;
    end;
    WM_COPYDATA:
    begin
      Msg.Result := 0;
      Data := PCopyDataStruct(Msg.LParam);
      if Data <> nil then
      begin
        Mous := PMouseHookStruct(Data.lpData);
        if Mous <> nil then
        begin
          FX := Mous^.pt.X;
          FY := Mous^.pt.Y;
        end;
        CopyDataHandled := True;
      end;
      Msg.Result := 1;
    end;
  end;

  // Call the original WndProc to ensure normal message handling
  if not CopyDataHandled then
  Msg.Result := CallWindowProc(FPrevWndProc, FParentWindow, Msg.Msg, Msg.WParam, Msg.LParam);
end;

procedure THotMouse.Timer;
var
  MPos: TPoint;
  Cur: THandle;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);

  // update mouse position
  Cur := 0;
  try
    if not Winapi.Windows.GetCursorPos(MPos) then
    begin
    // Since it would probably (highly) fail on locked screens, would return 0,0 and might trigger
    // top left hot corner actions, which we don't want, so return the center of main screen instead
      MPos := Point(Screen.Width div 2, Screen.Height div 2);
      FX := MPos.X;
      FY := MPos.Y;
    end;

    // let's check again
    Cur := GetForegroundWindow; // won't get if locked
    // we could call SystemParametersInfo(SPI_GETSCREENSAVERSECURE, 0, &isLocked, 0); to check locked mode
    // but seems to be more resource intensive which is unnecessary
  except
    Cur := 0;
  end;

//  if Cur = 0 then
  // avoid triggering
//    FDontTrigger := True;
//   HotSpotAction(MPos);

end;

procedure THotMouse.UpdateMonitors;
var
  I: Integer;
  mc: Integer;
begin
  FMonitors.Clear;

  mc := Screen.MonitorCount;
  if mc > 0 then
  begin
    for I := 0 to mc - 1 do
    begin
      FMonitors.Add(Screen.Monitors[I]);
    end;
  end;
end;

procedure THotMouse.UpdateTimer;
begin
  KillTimer(FWindowHandle, 1);
  if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
    if SetTimer(FWindowHandle, 1, FInterval, nil) = 0 then
      raise EOutOfResources.Create('No timers available');
end;

procedure THotMouse.WndProc(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_TIMER:
      try
        Timer;
      except
        Application.HandleException(Self);
      end;
    WM_CREATE:
      begin
//        FTaskbarCreated := RegisterWindowMessage('TaskbarCreated');
      end;
    WM_WTSSESSION_CHANGE:
      begin
        case Msg.WParam of
          WTS_SESSION_LOCK:
            begin
              // Do nothing when user is locked (Win+L)
            end;
          WTS_SESSION_UNLOCK:
            begin
              // Re enable mouse events tracking
            end;
        end;
      end;
    WM_DISPLAYCHANGE: // Display resolution change
      begin
        // Update Monitors count, resolution
        UpdateMonitors;
      end;
    WM_SETTINGCHANGE: // look for WorkArea or Wallpaper event, those are related to monitor changes (add/remove)
      begin
        if (Msg.WParam = SPI_SETWORKAREA) or (Msg.WParam = SPI_SETDESKWALLPAPER)  then
        begin
          // Handle monitor change
          UpdateMonitors;
        end;
      end;
    WM_DPICHANGED:
      begin
        // Update ScaleFactor ??? (it might not be necessary
        UpdateMonitors;
      end;
    //------------- DEFAULT ------------//
    else
    begin

    end;
  end;
  // Call the default window procedure for unhandled messages
  Msg.Result := DefWindowProc(FWindowHandle, Msg.Msg, Msg.WParam, Msg.LParam);
end;

end.
