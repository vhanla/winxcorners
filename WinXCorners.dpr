program WinXCorners;
{.$R *.dres}

uses
  Forms,
  Windows,
  Main in 'Main.pas' {frmMain},
  frmSettings in 'frmSettings.pas' {frmTrayPopup},
  XCombobox in 'XCombobox.pas',
  osdgui in 'osdgui.pas' {frmOSD},
  frmAdvanced in 'frmAdvanced.pas' {frmAdvSettings},
  functions in 'functions.pas',
  hotkeyhelper in 'hotkeyhelper.pas',
  settingsHelper in 'settingsHelper.pas',
  conditionsHelper in 'conditionsHelper.pas';

{$R *.res}
{$R PNGIMAGE_1.res}
{$R PNGIMAGE_2.res}
{$R ICON_1.res}
{$R ICON_2.res}
{$R ICON_3.res}
//{$ifdef ver360}
{$R Manifest1.res}
//{$endif}

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
//  Application.MainFormOnTaskbar := False;
  Application.Title := 'WinXCorners';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTrayPopup, frmTrayPopup);
  Application.CreateForm(TfrmOSD, frmOSD);
  Application.CreateForm(TfrmAdvSettings, frmAdvSettings);
  Application.Run;
end.
