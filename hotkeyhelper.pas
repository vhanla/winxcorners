unit hotkeyhelper;

interface

uses
  Windows, Classes, SysUtils, Messages, IniFiles, Generics.Collections;

const
  WH_KEYBOARD_LL = 13;
  WH_MOUSE_LL = 14;
{ Define a record for recording and passing information process wide }
type
  PKBDLLHOOKSTRUCT = ^TKBDLLHOOKSTRUCT;
  TKBDLLHOOKSTRUCT = record
    vkCode: Cardinal;
    scanCode: Cardinal;
    flags: Cardinal;
    time: Cardinal;
    dwExtrainfo: Cardinal;
  end;

type
  THotkeyInvoker = class
  private
    FHook: HHOOK;
    FBlockInput: Boolean;
    class var FInstance: THotkeyInvoker;
    procedure SetBlockInput(const value: Boolean);
    class function GetInstance: THotkeyInvoker; static;
  protected
    constructor Create;
    destructor Destroy; override;
  public
    class property Instance: THotkeyInvoker read GetInstance;
    property BlockInput: Boolean read FBlockInput write SetBlockInput;
    function InvokeHotKey(const Hotkey: string; Delay: Integer = 10; RepeatCount: Integer = 1): Boolean;
  end;

function LowLevelKeyboardProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

implementation

var
  BlockedKeys: TStringList;
  VKMap: TDictionary<string,Byte>;


// Helper functions
function StartsWith(const Str, Prefix: string): Boolean;
begin
  Result := (Length(Str) >= Length(Prefix)) and
              (Copy(Str, 1, Length(Prefix)) = Prefix);
end;

function EndsWith(const Str, Suffix: string): Boolean;
begin
  Result := (Length(Str) >= Length(Suffix))and
              (Copy(Str, Length(Str) - Length(Suffix) + 1, Length(Suffix)) = Suffix);
end;

function TrimUnderscores(const Str: string): string;
var
  StartPos, EndPos: Integer;
begin
  StartPos := 1;
  EndPos := Length(Str);
  while (StartPos <= EndPos) and (Str[StartPos] = '_') do
    Inc(StartPos);
  while (EndPos >= StartPos) and (Str[EndPos] = '_') do
    Dec(EndPos);
  Result := Copy(Str, StartPos, EndPos - StartPos + 1);
  

end;

function LowLevelKeyboardProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  pkbhs: PKBDLLHOOKSTRUCT;
begin
  if (nCode = HC_ACTION) and THotkeyInvoker.Instance.BlockInput then
  begin
    pkbhs := PKBDLLHOOKSTRUCT(lParam);
    if BlockedKeys.IndexOf(IntToStr(pkbhs.vkCode)) <> -1 then
    begin
//      Result := 1;
//      Exit;
    end;
  end;
  Result := CallNextHookEx(THotKeyInvoker.Instance.FHook, nCode, wParam, lParam);
end;

{ THotkeyInvoker }

constructor THotkeyInvoker.Create;
begin
  inherited;
  FHook := SetWindowsHookEx(WH_KEYBOARD_LL, @LowLevelKeyboardproc, 0, 0);
  BlockedKeys := TStringList.Create;
  VKMap := TDictionary<string,Byte>.Create;

  // allowed virtual keys
  VKMap.Add('LBUTTON',VK_LBUTTON );
  VKMap.Add('RBUTTON',VK_RBUTTON );
  VKMap.Add('CANCEL',VK_CANCEL );
  VKMap.Add('MBUTTON',VK_MBUTTON );
  VKMap.Add('XBUTTON1',VK_XBUTTON1 );
  VKMap.Add('XBUTTON2',VK_XBUTTON2 );
  VKMap.Add('BACK',VK_BACK );
  VKMap.Add('TAB',VK_TAB );
  VKMap.Add('CLEAR',VK_CLEAR );
  VKMap.Add('RETURN',VK_RETURN );
  VKMap.Add('SHIFT',VK_SHIFT );
  VKMap.Add('CONTROL',VK_CONTROL );
//  VKMap.Add('MENU',VK_MENU );
  VKMap.Add('ALT',VK_MENU );
  VKMap.Add('PAUSE',VK_PAUSE );
  VKMap.Add('CAPITAL',VK_CAPITAL );
  VKMap.Add('KANA',VK_KANA );
  VKMap.Add('HANGUL',VK_HANGUL );
  VKMap.Add('JUNJA',VK_JUNJA );
  VKMap.Add('FINAL',VK_FINAL );
  VKMap.Add('HANJA',VK_HANJA );
  VKMap.Add('KANJI',VK_KANJI );
  VKMap.Add('CONVERT',VK_CONVERT );
  VKMap.Add('NONCONVERT',VK_NONCONVERT );
  VKMap.Add('ACCEPT',VK_ACCEPT );
  VKMap.Add('MODECHANGE',VK_MODECHANGE );
  VKMap.Add('ESCAPE',VK_ESCAPE );
  VKMap.Add('SPACE',VK_SPACE );
  VKMap.Add('PRIOR',VK_PRIOR );
  VKMap.Add('NEXT',VK_NEXT );
  VKMap.Add('END',VK_END );
  VKMap.Add('HOME',VK_HOME );
  VKMap.Add('LEFT',VK_LEFT );
  VKMap.Add('UP',VK_UP );
  VKMap.Add('RIGHT',VK_RIGHT );
  VKMap.Add('DOWN',VK_DOWN );
  VKMap.Add('SELECT',VK_SELECT );
  VKMap.Add('PRINT',VK_PRINT );
  VKMap.Add('EXECUTE',VK_EXECUTE );
  VKMap.Add('SNAPSHOT',VK_SNAPSHOT );
  VKMap.Add('INSERT',VK_INSERT );
  VKMap.Add('DELETE',VK_DELETE );
  VKMap.Add('HELP',VK_HELP );
  VKMap.Add('WIN',VK_LWIN );
  VKMap.Add('RWIN',VK_RWIN );
  VKMap.Add('APPS',VK_APPS );
  VKMap.Add('SLEEP',VK_SLEEP );
  VKMap.Add('NUMPAD0',VK_NUMPAD0 );
  VKMap.Add('NUMPAD1',VK_NUMPAD1 );
  VKMap.Add('NUMPAD2',VK_NUMPAD2 );
  VKMap.Add('NUMPAD3',VK_NUMPAD3 );
  VKMap.Add('NUMPAD4',VK_NUMPAD4 );
  VKMap.Add('NUMPAD5',VK_NUMPAD5 );
  VKMap.Add('NUMPAD6',VK_NUMPAD6 );
  VKMap.Add('NUMPAD7',VK_NUMPAD7 );
  VKMap.Add('NUMPAD8',VK_NUMPAD8 );
  VKMap.Add('NUMPAD9',VK_NUMPAD9 );
  VKMap.Add('MULTIPLY',VK_MULTIPLY );
  VKMap.Add('ADD',VK_ADD );
  VKMap.Add('SEPARATOR',VK_SEPARATOR );
  VKMap.Add('SUBTRACT',VK_SUBTRACT );
  VKMap.Add('DECIMAL',VK_DECIMAL );
  VKMap.Add('DIVIDE',VK_DIVIDE );
  VKMap.Add('F1',VK_F1 );
  VKMap.Add('F2',VK_F2 );
  VKMap.Add('F3',VK_F3 );
  VKMap.Add('F4',VK_F4 );
  VKMap.Add('F5',VK_F5 );
  VKMap.Add('F6',VK_F6 );
  VKMap.Add('F7',VK_F7 );
  VKMap.Add('F8',VK_F8 );
  VKMap.Add('F9',VK_F9 );
  VKMap.Add('F10',VK_F10 );
  VKMap.Add('F11',VK_F11 );
  VKMap.Add('F12',VK_F12 );
  VKMap.Add('F13',VK_F13 );
  VKMap.Add('F14',VK_F14 );
  VKMap.Add('F15',VK_F15 );
  VKMap.Add('F16',VK_F16 );
  VKMap.Add('F17',VK_F17 );
  VKMap.Add('F18',VK_F18 );
  VKMap.Add('F19',VK_F19 );
  VKMap.Add('F20',VK_F20 );
  VKMap.Add('F21',VK_F21 );
  VKMap.Add('F22',VK_F22 );
  VKMap.Add('F23',VK_F23 );
  VKMap.Add('F24',VK_F24 );
  VKMap.Add('NUMLOCK',VK_NUMLOCK );
  VKMap.Add('SCROLL',VK_SCROLL );
//VK_L & VK_R - left and right Alt, Ctrl and Shift virtual keys.
//Used only as parameters to GetAsyncKeyState() and GetKeyState().);
//No other API or message will distinguish left and right keys in this way. });
  VKMap.Add('LSHIFT',VK_LSHIFT );
  VKMap.Add('RSHIFT',VK_RSHIFT );
  VKMap.Add('LCONTROL',VK_LCONTROL );
  VKMap.Add('RCONTROL',VK_RCONTROL );
  VKMap.Add('LMENU',VK_LMENU );
  VKMap.Add('RMENU',VK_RMENU );
  VKMap.Add('BROWSER_BACK',VK_BROWSER_BACK );
  VKMap.Add('BROWSER_FORWARD',VK_BROWSER_FORWARD );
  VKMap.Add('BROWSER_REFRESH',VK_BROWSER_REFRESH );
  VKMap.Add('BROWSER_STOP',VK_BROWSER_STOP );
  VKMap.Add('BROWSER_SEARCH',VK_BROWSER_SEARCH );
  VKMap.Add('BROWSER_FAVORITES',VK_BROWSER_FAVORITES );
  VKMap.Add('BROWSER_HOME',VK_BROWSER_HOME );
  VKMap.Add('VOLUME_MUTE',VK_VOLUME_MUTE );
  VKMap.Add('VOLUME_DOWN',VK_VOLUME_DOWN );
  VKMap.Add('VOLUME_UP',VK_VOLUME_UP );
  VKMap.Add('MEDIA_NEXT_TRACK',VK_MEDIA_NEXT_TRACK );
  VKMap.Add('MEDIA_PREV_TRACK',VK_MEDIA_PREV_TRACK );
  VKMap.Add('MEDIA_STOP',VK_MEDIA_STOP );
  VKMap.Add('MEDIA_PLAY_PAUSE',VK_MEDIA_PLAY_PAUSE );
  VKMap.Add('LAUNCH_MAIL',VK_LAUNCH_MAIL );
  VKMap.Add('LAUNCH_MEDIA_SELECT',VK_LAUNCH_MEDIA_SELECT );
  VKMap.Add('LAUNCH_APP1',VK_LAUNCH_APP1 );
  VKMap.Add('LAUNCH_APP2',VK_LAUNCH_APP2 );
  VKMap.Add('OEM_1',VK_OEM_1 );
  VKMap.Add('OEM_PLUS',VK_OEM_PLUS );
  VKMap.Add('OEM_COMMA',VK_OEM_COMMA );
  VKMap.Add('OEM_MINUS',VK_OEM_MINUS );
  VKMap.Add('OEM_PERIOD',VK_OEM_PERIOD );
  VKMap.Add('OEM_2',VK_OEM_2 );
  VKMap.Add('OEM_3',VK_OEM_3 );
  VKMap.Add('OEM_4',VK_OEM_4 );
  VKMap.Add('OEM_5',VK_OEM_5 );
  VKMap.Add('OEM_6',VK_OEM_6 );
  VKMap.Add('OEM_7',VK_OEM_7 );
  VKMap.Add('OEM_8',VK_OEM_8 );
  VKMap.Add('OEM_102',VK_OEM_102 );
  VKMap.Add('PACKET',VK_PACKET );
  VKMap.Add('PROCESSKEY',VK_PROCESSKEY );
  VKMap.Add('ATTN',VK_ATTN );
  VKMap.Add('CRSEL',VK_CRSEL );
  VKMap.Add('EXSEL',VK_EXSEL );
  VKMap.Add('EREOF',VK_EREOF );
  VKMap.Add('PLAY',VK_PLAY );
  VKMap.Add('ZOOM',VK_ZOOM );
  VKMap.Add('NONAME',VK_NONAME );
  VKMap.Add('PA1',VK_PA1 );
  VKMap.Add('OEM_CLEAR',VK_OEM_CLEAR);
end;

destructor THotkeyInvoker.Destroy;
begin
  if FHook <> 0 then
    UnhookWindowsHookEx(FHook);
  VKMap.Clear;
  VKMap.Free;
  BlockedKeys.Free;

  inherited;
end;

class function THotkeyInvoker.GetInstance: THotkeyInvoker;
begin
  if FInstance = nil then
    FInstance := THotkeyInvoker.Create;
  Result := FInstance;
end;

function THotkeyInvoker.InvokeHotKey(const Hotkey: string; Delay,
  RepeatCount: Integer): Boolean;
var
  Keys: TStringList;
  Key: string;
  VK: Byte;
  IsHoldDown, IsRelease: Boolean;
  I, J: Integer;
  HeldKeys: TList;

  procedure SendKey(VirtualKey: Byte; Flag: DWORD);
  begin
    keybd_event(VirtualKey, MapVirtualKey(VirtualKey, 0), Flag, 0);
    Sleep(Delay);
  end;

  function GetVirtualKey(const Key: string): Byte;
  var
    VK: Byte;
  begin
    if VKMap.TryGetValue(Key,VK) then
      Result := VK
    else
      Result := Ord(Key[1]);
  end;


begin
  Result := False;
  Keys := TStringList.Create;
  HeldKeys := TList.Create;
  try
    Keys.Delimiter := '+';
    Keys.DelimitedText := UpperCase(HotKey);// StringReplace(Hotkey, '\+', #1, [rfReplaceAll]);

//    for I := 0 to Keys.Count - 1 do
//      Keys[I] := StringReplace(Keys[I], #1, '+', [rfReplaceAll]);

    BlockedKeys.Clear;
    for I := 0 to Keys.Count - 1 do
    begin
      Key := Keys[I];
      IsHoldDown := StartsWith(Key, '_');
      IsRelease := EndsWith(Key, '_');
      Key := TrimUnderscores(Key);

//      if Key = 'CTRL' then VK := VK_CONTROL
//      else if Key = 'ALT' then VK := VK_MENU
//      else if Key = 'SHIFT' then VK := VK_SHIFT
//      else if Key = 'WIN' then VK := VK_LWIN
//      else if Key = 'TAB' then VK := VK_TAB
//      else VK := Ord(UpperCase(Key)[1]);
      VK := GetVirtualKey(Key);

      BlockedKeys.Add(IntToStr(VK));
    end;

    BlockInput := True;
    try
      for J := 1 to RepeatCount do
      begin
        for I := 0 to Keys.Count - 1 do
        begin
          Key := Keys[I];
          IsHoldDown := StartsWith(Key, '_');
          IsRelease := EndsWith(Key, '_');
          Key := TrimUnderscores(Key);

//          if Key = 'CTRL' then VK := VK_CONTROL
//          else if Key = 'ALT' then VK := VK_MENU
//          else if Key = 'SHIFT' then VK := VK_SHIFT
//          else if Key = 'WIN' then VK := VK_LWIN
//          else if Key = 'TAB' then VK := VK_TAB
//          else VK := Ord(UpperCase(Key)[1]);
          VK := GetVirtualKey(Key);

          if IsHoldDown and not IsRelease then
          begin
            SendKey(VK, 0);
            HeldKeys.Add(Pointer(VK));
          end
          else if not IsHoldDown and not IsRelease then
          begin
            SendKey(VK, 0);
            SendKey(VK, KEYEVENTF_KEYUP);
          end
          else if IsRelease  then
          begin
            if HeldKeys.IndexOf(Pointer(VK)) >= 0 then
              HeldKeys.Remove(Pointer(VK));
            SendKey(VK, KEYEVENTF_KEYUP);
          end;
        end;

        // Release any remaining held keys in reverse order
        for I := HeldKeys.Count - 1 downto 0 do
        begin
          SendKey(Byte(HeldKeys[I]), KEYEVENTF_KEYUP);
        end;

        HeldKeys.Clear;

        if J < RepeatCount then
          Sleep(Delay);
      end;

      Result := True;

    finally
      BlockInput := False;
    end;


  finally
    HeldKeys.Free;
    Keys.Free;
  end;
end;

procedure THotkeyInvoker.SetBlockInput(const value: Boolean);
begin
  FBlockInput := Value;
end;

initialization
  THotkeyInvoker.FInstance := THotkeyInvoker.Create;

finalization
  FreeAndNil(THotkeyInvoker.FInstance);

end.
