format PE GUI 4.0 DLL
entry DllEntryPoint

include 'win32a.inc'

section '.data' data readable writeable

;MSLLHOOKSTRUCT:
;  .pt   POINT
;  .mouseData    dd ?
;  .flags        dd ?
;  .time         dd ?
;  .dwExtraInfo  dd ?

MOUSELLHOOKSTRUCT:
  .pt POINT
  .hwnd dd ?
  .wHitTestCode dd ?
  .dwExtraInfo dd ?

SMTO_NORMAL=0

WMU_MOUSE_EVENT     equ WM_USER + 100
MOUSE_EVENT_TIMEOUT equ 3000 ; 3 seconds in milliseconds
DEBOUNCE_TIME       equ 10 ; 10 milliseconds

section '.data' data readable writeable
  hInstance     dd ?
  hHook         dd ?
  hTargetWindow dd ?
  lastX         dd -1
  lastY         dd -1
  lastEventTime dd 0
  lastSendTime  dd 0
  isTargetReady dd 1

section '.code' code readable executable

proc DllEntryPoint hinstDLL, fdwReason, lpvReserved
  push eax
  mov eax,  [hinstDLL]
  mov [hInstance], eax
  pop eax
  mov eax, TRUE
  ret
endp

proc MouseHookProc nCode, wParam, lParam
  push ebx ecx esi edi

  ; Call the next hook in the chain
  invoke CallNextHookEx, [hHook], [nCode], [wParam], [lParam]

  ; Check if we should process this message
  cmp dword [nCode], HC_ACTION
  jl .exit

  ; Get current time
  invoke GetTickCount
  mov ebx, eax

  ; Check for timeout and reset if necessary
;  mov ecx, [lastSendTime]
;  add ecx, MOUSE_EVENT_TIMEOUT
;  cmp ebx, ecx
;  jl .checkReady
;  mov dword [isTargetReady], 1

.checkReady:
  ; Check if target is ready for new message
  cmp dword [isTargetReady], 0
  je .exit

  ; Check debounce time
  mov ecx, [lastEventTime]
  add ecx, DEBOUNCE_TIME
  cmp ebx, ecx
  jl .exit

  ; Get mouse coordinates
;  mov esi, [lParam]
;  mov edi, [esi + MOUSELLHOOKSTRUCT.pt.x]
;  mov ecx, [esi + MOUSELLHOOKSTRUCT.pt.y]

  ; Check if mouse has moved or clicked
;  cmp edi, [lastX]
;  jne .sendMessage
;  cmp ecx, [lastY]
;  jne .sendMessage
;  cmp dword [wParam], 0
;  jne .sendMessage
;  jmp .exit

.sendMessage:
  ; Update last known position and time
;  mov [lastX], edi
;  mov [lastY], ecx
  mov [lastEventTime], ebx

  ; Set target as not ready
  mov dword [isTargetReady], 0

  ; Send message to target window
  invoke SendMessageTimeout, [hTargetWindow], WMU_MOUSE_EVENT, [wParam], [lParam], SMTO_NORMAL, 1000, 0

  ; Check if message was sent successfully
  test eax, eax
  jz .messageFailed

  ; Message sent successfully
  mov [lastSendTime], ebx
  jmp .exit

.messageFailed:
  ; Message failed to send, set target as ready for next attempt
  mov dword [isTargetReady], 1

.exit:
  pop edi esi ecx ebx
  xor eax, eax
  ret
endp

proc InstallMouseHook hTargetWnd
  push eax ebx

  mov eax, [hTargetWnd]
  mov [hTargetWindow], eax
  invoke SetWindowsHookEx, WH_MOUSE_LL, MouseHookProc, [hInstance], NULL
  test eax, eax
  jz .fail
  mov [hHook], eax
  mov ebx, 1 ; Return TRUE
  jmp .exit
.fail:
  xor ebx, ebx ; Return FALSE
.exit:
  mov eax, ebx
  pop ebx eax
  ret
endp

proc UninstallMouseHook
  push eax ebx
  xor ebx, ebx ; Default return FALSE
  cmp [hHook], 0
  je .exit
  invoke UnhookWindowsHookEx, [hHook]
  test eax, eax
  jz .exit
  mov dword [hHook], 0
  inc ebx ; Return TRUE
.exit:
  mov eax, ebx
  pop ebx eax
  ret
endp

proc NotifyTargetReady
  mov dword [isTargetReady], 1
  ret
endp

section '.idata' import data readable
  library KERNEL32, 'KERNEL32.DLL',\
          USER32, 'USER32.DLL'

  import KERNEL32,\
         GetTickCount, 'GetTickCount'

  import USER32,\
         CallNextHookEx, 'CallNextHookEx',\
         SendMessageTimeout, 'SendMessageTimeoutA',\
         SetWindowsHookEx, 'SetWindowsHookExA',\
         UnhookWindowsHookEx, 'UnhookWindowsHookEx'

section '.edata' export data readable

  export 'WINXCORNERS.DLL',\
    InstallMouseHook, 'InstallMouseHook',\
    UninstallMouseHook, 'UninstallMouseHook',\
    NotifyTargetReady, 'NotifyTargetReady'

section '.reloc' fixups data readable discardable

  if $=$$
    dd 0,8 ; if there are no fixups, generate dummy entry
  end if