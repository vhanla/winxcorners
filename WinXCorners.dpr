program WinXCorners;





















{$R *.dres}

uses
  FMX.Forms,
  Skia.FMX,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  Winapi.Windows,
  Main in 'Main.pas' {frmMain},
  frmSettings in 'frmSettings.pas' {frmTrayPopup},
  XCombobox in 'XCombobox.pas',
  osdgui in 'osdgui.pas' {frmOSD},
  frmAdvanced in 'frmAdvanced.pas' {frmAdvSettings},
  functions in 'functions.pas',
  frmWinTiles in 'frmWinTiles.pas' {wndListWindows},
  actionsManager in 'actionsManager.pas',
  Vcl.Themes,
  Vcl.Styles,
  InfDesktopWallpaper in 'InfDesktopWallpaper.pas',
  frmMouseShake in 'frmMouseShake.pas' {formMouseShake},
  mouseHelper in 'mouseHelper.pas',
  fmxSettings in 'fmxSettings.pas' {fmxSettingsForm},
  fmxLaunchpad in 'fmxLaunchpad.pas' {Form1},
  taskbarHelper in 'taskbarHelper.pas',
  settingsHelper in 'settingsHelper.pas';

//  fmxStageManager in 'fmxStageManager.pas' {Form1};

{$R *.res}

var
  AppHandle: HWND;
begin
  GlobalUseSkia := True;
  AppHandle := FindWindow('WinXCorners', nil);
  if AppHandle > 0 then
  begin
//    Application.Terminate;
    Exit;
  end;

  Application.Initialize;
  Application.ShowMainForm := False;
  Application.MainFormOnTaskbar := False;
  TStyleManager.TrySetStyle('Windows11 Polar Dark');
  Application.Title := 'WinXCorners';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTrayPopup, frmTrayPopup);
  Application.CreateForm(TfrmOSD, frmOSD);
  Application.CreateForm(TfrmAdvSettings, frmAdvSettings);
  Application.CreateForm(TwndListWindows, wndListWindows);
  Application.CreateForm(TformMouseShake, formMouseShake);
  Application.CreateForm(TfmxSettingsForm, fmxSettingsForm);
  Application.CreateForm(TForm1, Form1);
  //  formMouseShake.Show;
  //  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
