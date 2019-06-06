program WinXCorners;





















{$R *.dres}

uses
  Vcl.Forms,
  Winapi.Windows,
  Main in 'Main.pas' {frmMain},
  frmSettings in 'frmSettings.pas' {frmTrayPopup},
  XCombobox in 'XCombobox.pas',
  osdgui in 'osdgui.pas' {frmOSD},
  frmAdvanced in 'frmAdvanced.pas' {frmAdvSettings};

{$R *.res}

var
  AppHandle: HWND;
begin
  AppHandle := FindWindow('WinXCorners', nil);
  if AppHandle > 0 then
  begin
//    Application.Terminate;
    Exit;
  end;

  Application.Initialize;
  Application.ShowMainForm := False;
  Application.MainFormOnTaskbar := False;
  Application.Title := 'WinXCorners';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTrayPopup, frmTrayPopup);
  Application.CreateForm(TfrmOSD, frmOSD);
  Application.CreateForm(TfrmAdvSettings, frmAdvSettings);
  Application.Run;
end.
