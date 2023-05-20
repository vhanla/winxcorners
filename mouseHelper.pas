unit mouseHelper;

interface

uses
  Vcl.ExtCtrls, System.Classes, Winapi.Windows, Winapi.Messages, Vcl.Forms, Winapi.ShellAPI;

type
  // Dynamically load the WinXHelper mouse WM_MOUSE global hook


  // A non visible component that has WNDProc to receive messages from MouseHook.dll
  TMouseHelper = class(TComponent)
  private
    FInterval: Cardinal;
    FWindowHandle: HWND;
    FOnTimer: TNotifyEvent;
    FEnabled: Boolean;

    FX, FY: Cardinal;
    FHiddenWindowHandle: HWND;
    FParentWindow: HWND;
    FPrevWndProc: Pointer;
    FWndProcMethod: TWndMethod;
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

{ TMouseHelper }

constructor TMouseHelper.Create(AOwner: TComponent);
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
end;

destructor TMouseHelper.Destroy;
begin
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

procedure TMouseHelper.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TMouseHelper.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TMouseHelper.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value;
  UpdateTimer;
end;

procedure TMouseHelper.SubWndProc(var Msg: TMessage);
begin
  // Call the original WndProc to ensure normal message handling
  Msg.Result := CallWindowProc(FPrevWndProc, FParentWindow, Msg.Msg, Msg.WParam, Msg.LParam);
end;

procedure TMouseHelper.Timer;
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

procedure TMouseHelper.UpdateTimer;
begin
  KillTimer(FWindowHandle, 1);
  if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
    if SetTimer(FWindowHandle, 1, FInterval, nil) = 0 then
      raise EOutOfResources.Create('No timers available');
end;

procedure TMouseHelper.WndProc(var Msg: TMessage);
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

    else
    begin

    end;
  end;
  // Call the default window procedure for unhandled messages
  Msg.Result := DefWindowProc(FWindowHandle, Msg.Msg, Msg.WParam, Msg.LParam);
end;

end.
