unit taskbarHelper;

interface

uses
  System.Classes, Winapi.Windows, Winapi.Messages, Vcl.Forms, Winapi.ShellAPI;
const
  APPBAR_CALLBACK = WM_APP + 11; // Custom message ID
type
  TMainTaskbar = class(TComponent)
  private
    FShell_TrayWnd: HWND;
    FShell_TrayWndRect: TRect;
    FScreenRect: TRect;
    FPosition: Cardinal; // ABE_TOP, ABE_BOTTOM, ABE_LEFT, ABE_RIGHT
    FTaskbarCreated: Cardinal;
    FOnTaskbarRestarted: TNotifyEvent;
    FHidden: Boolean;
    FDummyWindowHandle: HWND;
    FDummyAppBarData: TAppBarData;
    // make this component aware of windows messages, like monitor changes, taskbar restarts, etc
    procedure WndProc(var Msg: TMessage);
    procedure SetOnTaskbarRestarted(const Value: TNotifyEvent);
    procedure RegisterDummyAppBar;
    procedure UnregisterDummyAppBar;
  protected
    procedure DoTaskbarRestarted;
    procedure UpdateTaskbarInfo;
    procedure GetTaskbarMonitor; // might be redundant since Main Monitor is always assigned to the systray
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnTaskbarRestarted: TNotifyEvent read FOnTaskbarRestarted write SetOnTaskbarRestarted;
    property Handle: HWND read FShell_TrayWnd;
    property Rect: TRect read FShell_TrayWndRect;
    property Position: Cardinal read FPosition;
    property ScreenRect: TRect read FScreenRect;
    property Hidden: Boolean read FHidden;
  end;

implementation

{ TMainTaskbar }

constructor TMainTaskbar.Create(AOwner: TComponent);
begin
  inherited;
  FDummyWindowHandle := AllocateHWnd(WndProc);
  RegisterDummyAppBar;
  UpdateTaskbarInfo;
end;

destructor TMainTaskbar.Destroy;
begin
  UnregisterDummyAppBar;
  DeallocateHWnd(FDummyWindowHandle);
  inherited Destroy;
end;

procedure TMainTaskbar.DoTaskbarRestarted;
begin
  if Assigned(FOnTaskbarRestarted) then
    FOnTaskbarRestarted(Self);
end;

procedure TMainTaskbar.RegisterDummyAppBar;
begin
  FDummyAppBarData.cbSize := SizeOf(TAppBarData);
  FDummyAppBarData.hWnd := FDummyWindowHandle;
  FDummyAppBarData.uCallbackMessage := APPBAR_CALLBACK;
  SHAppBarMessage(ABM_NEW, FDummyAppBarData);
  SHAppBarMessage(ABM_SETPOS, FDummyAppBarData);
  SHAppBarMessage(ABM_ACTIVATE, FDummyAppBarData);
  SHAppBarMessage(ABM_GETTASKBARPOS, FDummyAppBarData);
  SHAppBarMessage(ABM_GETSTATE, FDummyAppBarData);
end;

procedure TMainTaskbar.GetTaskbarMonitor;
var
  I: Integer;
  LShell_TrayWnd: HWND;
  LShell_TrayWndRect: TRect;
begin
  LShell_TrayWnd := FindWindow('Shell_TrayWnd', nil);
  if LShell_TrayWnd = 0 then Exit;

  for I := 0 to Screen.MonitorCount -1 do
  begin
    FScreenRect := Screen.Monitors[I].BoundsRect;

    GetWindowRect(LShell_TrayWnd, LShell_TrayWndRect);

    if (FScreenRect.Left <= LShell_TrayWndRect.Left)
    and (FScreenRect.Right >= LShell_TrayWndRect.Right)
    and (FScreenRect.Top <= LShell_TrayWndRect.Top)
    and (FScreenRect.Bottom >= LShell_TrayWndRect.Bottom)
    then
      Break;
  end;
end;

procedure TMainTaskbar.SetOnTaskbarRestarted(const Value: TNotifyEvent);
begin
  FOnTaskbarRestarted := Value;
end;

procedure TMainTaskbar.UnregisterDummyAppBar;
begin
  SHAppBarMessage(ABM_REMOVE, FDummyAppBarData);
end;

procedure TMainTaskbar.UpdateTaskbarInfo;
var
  ABData: TAppBarData;
begin
  GetTaskbarMonitor;
  ABData.cbSize := SizeOf(TAppBarData);
  FHidden := (SHAppBarMessage(ABM_GETSTATE, ABData) and ABS_AUTOHIDE) = ABS_AUTOHIDE;
  if SHAppBarMessage(ABM_GETTASKBARPOS, ABData) <> 0 then
  begin
    FShell_TrayWnd := ABData.hWnd;
    FShell_TrayWndRect := ABData.rc;
    FPosition := ABData.uEdge;
  end;

end;

procedure TMainTaskbar.WndProc(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_CREATE:
      begin
        FTaskbarCreated := RegisterWindowMessage('TaskbarCreated');
      end;
    APPBAR_CALLBACK:
      begin
        case Msg.LParam of
          ABN_STATECHANGE:
            begin
              // Handle taskbar state change here
              UpdateTaskbarInfo;
              DoTaskbarRestarted;
            end;
          ABN_POSCHANGED:
            begin
              // Handle taskbar position change here
              UpdateTaskbarInfo;
              DoTaskbarRestarted;
            end;
          ABN_FULLSCREENAPP:
            begin
              // Handle full-screen app change here
            end;
          ABN_WINDOWARRANGE:
            begin
              // Handle window arrangement change here
            end;
        end;
      end;
    else
    begin
      if Msg.Msg = FTaskbarCreated then
      begin
        // Update Taskbar Info
        UpdateTaskbarInfo;
        // Also notify this event, in order to let the user do anything with new data
        DoTaskbarRestarted;
      end;
    end;
  end;
  // Call the default window procedure for unhandled messages
  Msg.Result := DefWindowProc(FDummyWindowHandle, Msg.Msg, Msg.WParam, Msg.LParam);
end;

end.
