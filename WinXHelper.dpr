library WinXHelper;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
//  SysUtils,
  Messages;

const
  MemMapFile = 'WinXCorners';
type
  PDLLGlobal = ^TDLLGlobal;
  TDLLGlobal = packed record
    HookHandle: HHOOK;
  end;

var
  GlobalData: PDLLGlobal;
  MMF: THandle;

{$R *.res}

function HookProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
//  CurWnd: THandle;
  TargetWnd: THandle;
  Msg: PCopyDataStruct;
//  MsgStr: String;
begin
  //if Code < 0 then
  if (Code < 0) or (Code = HC_NOREMOVE) then
  begin
    Result := CallNextHookEx(GlobalData^.HookHandle, Code, wParam, lParam);
    Exit;
  end;

  if (wParam = WM_MOUSEMOVE) then
  begin
//    CurWnd := PMouseHookStruct(lParam)^.hwnd;
//    CurWnd := GetAncestor(CurWnd, GA_ROOTOWNER);
    //SendMessage(CurWnd, WM_SYSCOMMAND,)
    // Send IPC command to let main app trigger according to data (X,Y) sent
    TargetWnd := FindWindow('WinXCorners', nil);
    if TargetWnd <> 0 then
    begin
//      MsgStr := IntToStr(PMouseHookStruct(lParam)^.pt.X) + ','
//                +IntToStr(PMouseHookStruct(lParam)^.pt.Y);
      New(Msg);
      Msg^.dwData := 0;
      //Msg^.cbData := Length(MsgStr) + 1;
      //Msg^.lpData := PAnsiChar(MsgStr);
      Msg^.cbData := SizeOf(TMouseHookStruct) + 1;
      Msg^.lpData := PMouseHookStruct(lParam);
      //PostMessage(TargetWnd, WM_COPYDATA, CurWnd, Integer(Msg));
      SendMessageTimeout(TargetWnd, WM_COPYDATA, 0, Integer(Msg), SMTO_ABORTIFHUNG, 50, nil);
      Dispose(Msg);
    end;
  end;

  Result := CallNextHookEx(GlobalData^.HookHandle, Code, wParam, lParam);
end;

procedure CreateGlobalHeap;
begin
  MMF := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0,
    SizeOf(TDLLGlobal), MemMapFile);

  if MMF = 0 then
  begin
    MessageBox(0, 'CreateFileMapping -', '', 0);
    Exit;
  end;

  GlobalData := MapViewOfFile(MMF, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(TDLLGlobal));
  if GlobalData = nil then
  begin
    CloseHandle(MMF);
    MessageBox(0, 'MapViewFile -', '', 0);
  end;
end;

procedure DeleteGlobalHeap;
begin
  if GlobalData <> nil then
    UnmapViewOfFile(GlobalData);

  if MMF <> INVALID_HANDLE_VALUE then
    CloseHandle(MMF);
end;

procedure RunHook; stdcall;
begin
  GlobalData^.HookHandle := SetWindowsHookEx(WH_MOUSE_LL, @HookProc, HInstance, 0);
  if GlobalData^.HookHandle = INVALID_HANDLE_VALUE then
  begin
    MessageBox(0, 'Error :)', '', MB_OK);
    Exit;
  end;
end;

procedure KillHook; stdcall;
begin
  if (GlobalData <> nil) and (GlobalData^.HookHandle <> INVALID_HANDLE_VALUE) then
    UnhookWindowsHookEx(GlobalData^.HookHandle);
end;

procedure DLLEntry(dwReason: DWORD);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: CreateGlobalHeap;
    DLL_PROCESS_DETACH: DeleteGlobalHeap;
  end;
end;

exports
  KillHook,
  RunHook;

begin
  DllProc := @DLLEntry;
  DLLEntry(DLL_PROCESS_ATTACH);
end.
