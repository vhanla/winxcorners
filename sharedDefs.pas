unit sharedDefs;

interface

uses
  Windows, Messages;

const
  WM_KEYSTATUSCHANGED = WM_USER + 3;

type
  PKeyStatus = ^TKeyStatus;
  TKeyStatus = record
    ShiftPressed: Boolean;
    CtrlPressed: Boolean;
    AltPressed: Boolean;
  end;

implementation

end.
