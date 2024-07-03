{
  Simple pseudo language parser for handling an inline command for invoking hotkeys
}
unit conditionsHelper;

interface

uses
  Windows, SysUtils, Classes, StrUtils;

type
  TConditionType = (ctForeground, ctGlobal);

  PCondition = ^TCondition;
  TCondition = record
    ConditionType: TConditionType;
    ClassName: string;
    TitleText: string;
  end;

  TParserState = (psStart, psClass, psTitle, psHotkey, psElseHotkey);

function ParseAndExecuteCondition(const Input: string): Boolean;
function CheckCondition(const Condition: PCondition): Boolean;
function GetWindowTextSafe(Handle: HWND): string;
implementation

uses
  hotkeyhelper;

const
  TIMEOUT_MS = 100; // 100 ms timeout

function GetWindowTextSafe(Handle: HWND): string;
var
  Length: Integer;
begin
  Length := GetWindowTextLength(Handle);
  if Length > 0 then
  begin
    SetLength(Result, Length);
    GetWindowText(Handle, PChar(Result), Length + 1);
  end
  else
    Result := '';
end;

function GetWindowClassname(hWnd: HWND): string;
var
  Buffer: array[0..255] of Char;
begin
  if GetClassName(hWnd, Buffer, Length(Buffer)) > 0 then
    Result := Buffer
  else
    Result := '';
end;

function ParseAndExecuteCondition(const Input: string): Boolean;
var
  State: TParserState;
  Conditions: TList;
  CurrentCondition: PCondition;
  I: Integer;
  HotkeySequence, ElseHotkeySequence: string;
  ConditionMet: Boolean;
begin
  State := psStart;
  Conditions := TList.Create;
  try
    CurrentCondition := nil;
    HotkeySequence := '';
    ElseHotkeySequence := '';

    for I := 1 to Length(Input) do
    begin
      case Input[I] of
        '#', '@':
        begin
          if State = psStart then
          begin
            New(CurrentCondition);
            if Input[I] = '#' then
              CurrentCondition^.ConditionType := ctForeground
            else
              CurrentCondition^.ConditionType := ctGlobal;
            CurrentCondition^.ClassName := '';
            CurrentCondition^.TitleText := '';
            State := psClass;
          end;
        end;
        '[':; // Do nothing, just start of class name
        ']':
        begin
          if State in [psClass, psTitle] then
          begin
            Conditions.Add(CurrentCondition);
            CurrentCondition := nil;
            State := psStart;
          end;
        end;
        ',':
        begin
          if State = psClass then
            State := psTitle;
        end;
        '|':
        begin
          if State = psStart then
            State := psClass;
        end;
        ':':
        begin
          if State = psStart then
            State := psHotkey;
        end;
        '(':
        begin
          if State = psHotkey then
            HotkeySequence := '';
          if State = psElseHotkey then
            ElseHotkeySequence := '';
        end;
        ')':
        begin
          if State in [psHotkey, psElseHotkey] then
            State := psStart;
        end;
        '?':
        begin
          if State = psStart then
            State := psElseHotkey;
        end;
        else
          case State of
            psClass: CurrentCondition^.ClassName := CurrentCondition^.ClassName + Input[I];
            psTitle: CurrentCondition^.TitleText := CurrentCondition^.TitleText + Input[I];
            psHotkey: HotkeySequence := HotkeySequence + Input[I];
            psElseHotkey: ElseHotkeySequence := ElseHotkeySequence + Input[I];
          end;
      end;
    end;

    ConditionMet := False;
    for I := 0 to Conditions.Count - 1 do
    begin
      if CheckCondition(PCondition(Conditions[I])) then
      begin
        ConditionMet := True;
        Break;
      end;
    end;

    if ConditionMet then
      Result := THotkeyInvoker.Instance.InvokeHotKey(HotkeySequence)
    else
      Result := THotkeyInvoker.Instance.InvokeHotKey(ElseHotkeySequence);

  finally
    for I := 0 to Conditions.Count - 1 do
      Dispose(PCondition(Conditions[I]));
    Conditions.Free;
  end;
end;

function CheckCondition(const Condition: PCondition): Boolean;
var
  ahWnd: HWND;
  WindowClass, WindowTitle: string;
begin
  Result := False;

  case Condition^.ConditionType of
    ctForeground:
      begin
        ahWnd := GetForegroundWindow;
        if ahWnd <> 0 then
        begin
          WindowClass := GetWindowClassname(ahWnd);
          WindowTitle := GetWindowTextSafe(ahWnd);
          Result := (CompareText(WindowClass, Condition^.ClassName) = 0) and
                    ((Condition^.TitleText = '') or ContainsText(WindowTitle, Condition^.TitleText));
        end;
      end;
    ctGlobal:
      begin
        if Condition^.TitleText <> '' then
          ahWnd := FindWindow(PChar(Condition^.ClassName), Pchar(Condition^.TitleText))
        else
          ahWnd := FindWindow(PChar(Condition^.ClassName), nil);
        Result := (ahWnd <> 0);
      end;
  end;
end;


end.
