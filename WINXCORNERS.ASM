format PE GUI 4.0 DLL
entry DllEntryPoint

include 'win32ax.inc'

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

struct MouseStat
  x    dd ? ; Current X coordinate
  y    dd ? ; Current Y coordinate
  time dq ? ; Timestamp of last event
ends

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

  ; First, check if we should process this message
  cmp dword [nCode], HC_ACTION
  jl .callNextHook

  ; Check if this is a mouse-related message
  cmp [wParam], WM_MOUSEMOVE
  jne .callNextHook

  jmp .sendMessage

.readTimestamp:
  rdtsc                         ; Read the time-stamp counter
  shl edx, 32                   ; Shift high part to upper 32 bits
  or eax, edx                   ; Combine into a 64-bit value EAX (low) and EDX (high)
  mov ebx, eax                  ; Store the result in EBX for comparison

  ; Handle potential overflow (if needed for specific environments)
  cmp eax, [lastEventTime]      ; Compare with last timestamp
  jb .reset                     ; If overflow occurred, reset lastEventTime
  jmp .normal
.reset:
  mov [lastEventTime], 0        ; Reset timestamp

  ; Get current time — seems that GetTickCount might be disabled or corrupted by anticheat software for specific games hence we use rdtsc instead
;  invoke GetTickCount
;  mov ebx, eax

.normal:
  ; Check debounce time
  mov ecx, [lastEventTime]
  add ecx, DEBOUNCE_TIME
  cmp ebx, ecx
  jl .exit

  ; Update last known time
  mov [lastEventTime], ebx

.sendMessage:

  ; Send message to target window
  invoke SendMessageTimeout, [hTargetWindow], WMU_MOUSE_EVENT, [wParam], [lParam], SMTO_NORMAL, 1000, 0
  test eax, eax
  jnz .exit

  ; If sending message failed, update target window
  invoke FindWindow, 'WinXCorners', NULL
  test eax, eax
  jz .exit
  mov [hTargetWindow], eax

.callNextHook:
  ; Call the next hook in the chain
  invoke CallNextHookEx, [hHook], [nCode], [wParam], [lParam]

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

section '.idata' import data readable
  library KERNEL32, 'KERNEL32.DLL',\
          USER32, 'USER32.DLL'

  import KERNEL32,\
         GetTickCount, 'GetTickCount'

  import USER32,\
         CallNextHookEx, 'CallNextHookEx',\
         SendMessageTimeout, 'SendMessageTimeoutA',\
         SetWindowsHookEx, 'SetWindowsHookExA',\
         UnhookWindowsHookEx, 'UnhookWindowsHookEx',\
         FindWindow, 'FindWindowA'

section '.edata' export data readable

  export 'WINXCORNERS.DLL',\
    InstallMouseHook, 'InstallMouseHook',\
    UninstallMouseHook, 'UninstallMouseHook'

section '.reloc' fixups data readable discardable

  if $=$$
    dd 0,8 ; if there are no fixups, generate dummy entry
  end if