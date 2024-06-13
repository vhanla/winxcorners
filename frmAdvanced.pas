unit frmAdvanced;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Spin,
  ExtCtrls, ShellApi, IniFiles, ComCtrls, frameCommands //IPPeerClient, Data.Bind.Components,
  //Data.Bind.ObjectScope, REST.Client,
  {, REST.Client, JSon};

const
  VERSION = '1.2';

type
  TfrmAdvSettings = class(TForm)
    GroupBox1: TGroupBox;
    chkDelayGlobal: TCheckBox;
    valDelayGlobal: TSpinEdit;
    chkDelayTopLeft: TCheckBox;
    valDelayTopLeft: TSpinEdit;
    chkDelayTopRight: TCheckBox;
    valDelayTopRight: TSpinEdit;
    chkDelayBotLeft: TCheckBox;
    valDelayBotLeft: TSpinEdit;
    chkDelayBotRight: TCheckBox;
    valDelayBotRight: TSpinEdit;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    edCommand: TEdit;
    chkCustom: TCheckBox;
    Label4: TLabel;
    chkHidden: TCheckBox;
    edParams: TEdit;
    Label1: TLabel;
    Label5: TLabel;
    chkShowCount: TCheckBox;
    chkFullScreen: TCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure chkDelayGlobalClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure chkFullScreenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure edCommandChange(Sender: TObject);
    procedure edParamsChange(Sender: TObject);
    procedure chkHiddenClick(Sender: TObject);
  private
    { Private declarations }
    procedure Temp2Cmd; // dump changes to official
    procedure Cmd2Temp; // restore from temp to official cmd
  public
    { Public declarations }
    procedure SaveAdvancedIni;
    procedure ReadAdvancedIni;
  end;

var
  frmAdvSettings: TfrmAdvSettings;
  cmdcli: array [0..3] of string;
  cmdarg: array [0..3] of string;
  cmdhid: array [0..3] of boolean;
  tmpcmdcli: array [0..3] of string;
  tmpcmdarg: array [0..3] of string;
  tmpcmdhid: array [0..3] of boolean;


implementation

{$R *.dfm}

uses frmSettings, main, functions;

procedure TfrmAdvSettings.Button1Click(Sender: TObject);
begin
  SaveAdvancedIni;
  Close
end;

procedure TfrmAdvSettings.Button2Click(Sender: TObject);
begin
  ReadAdvancedIni;
  close
end;

procedure TfrmAdvSettings.chkDelayGlobalClick(Sender: TObject);
begin
  if chkDelayGlobal.Checked then
  begin
    valDelayGlobal.Enabled := True;
    chkDelayTopLeft.Enabled := False;
    valDelayTopLeft.Enabled := False;
    chkDelayTopRight.Enabled := False;
    valDelayTopRight.Enabled := False;
    chkDelayBotLeft.Enabled := False;
    valDelayBotLeft.Enabled := False;
    chkDelayBotRight.Enabled := False;
    valDelayBotRight.Enabled := False;
  end
  else
  begin
    valDelayGlobal.Enabled := False;
    chkDelayTopLeft.Enabled := True;
    valDelayTopLeft.Enabled := True;
    chkDelayTopRight.Enabled := True;
    valDelayTopRight.Enabled := True;
    chkDelayBotLeft.Enabled := True;
    valDelayBotLeft.Enabled := True;
    chkDelayBotRight.Enabled := True;
    valDelayBotRight.Enabled := True;
  end;

end;

procedure TfrmAdvSettings.chkFullScreenClick(Sender: TObject);
begin
  frmMain.tmFullScreen.Checked := chkFullScreen.Checked;
end;

procedure TfrmAdvSettings.chkHiddenClick(Sender: TObject);
begin
  if Sender is TCheckBox then
    tmpcmdhid[PageControl1.ActivePageIndex] := chkHidden.Checked;
end;

procedure TfrmAdvSettings.Cmd2Temp;
var
  I : Integer;
begin
  for I := 0 to 3 do
  begin
    tmpcmdcli[I] := cmdcli[I];
    tmpcmdarg[I] := cmdarg[I];
    tmpcmdhid[I] := cmdhid[I];
  end;
end;

procedure TfrmAdvSettings.edCommandChange(Sender: TObject);
begin
  if Sender is TEdit then
    tmpcmdcli[PageControl1.ActivePageIndex] := edCommand.Text;
end;

procedure TfrmAdvSettings.edParamsChange(Sender: TObject);
begin
  if Sender is TEdit then
    tmpcmdarg[PageControl1.ActivePageIndex] := edParams.Text;
end;

procedure TfrmAdvSettings.FormCreate(Sender: TObject);
begin
//  if not SystemUsesLightTheme then
//  begin
    AllowDarkModeForWindow(Handle, True);
    AllowDarkModeForApp(True);
    SetPreferredAppMode(1);
    DarkMode;
//  end;

  FormStyle := fsStayOnTop;
  BorderStyle := bsSingle;
  BorderIcons := [biSystemMenu, biMinimize];
  Position := poScreenCenter;
  valDelayGlobal.Enabled := False;
  ReadAdvancedIni;
    UseImmersiveDarkMode(Handle, True);
//  EnableNCShadow(Handle);

end;

procedure TfrmAdvSettings.FormShow(Sender: TObject);
begin
//  if SystemUsesLightTheme then
//  begin
//    Color := clWhite;
//    AllowDarkModeForWindow(Handle, False);
//    AllowDarkModeForApp(False);
//    SetPreferredAppMode(0);
//    DarkMode;
//    UseImmersiveDarkMode(Handle, False);
//  end
//  else
//  begin
//    Color := $999999;
//    AllowDarkModeForWindow(Handle, True);
//    AllowDarkModeForApp(True);
//    SetPreferredAppMode(1);
//    DarkMode;
//    UseImmersiveDarkMode(Handle, True);
//  end;

end;

procedure TfrmAdvSettings.Label4Click(Sender: TObject);
begin
  ShellExecute(Handle, 'OPEN', 'http://apps.codigobit.info/p/support.html','','',SW_SHOWNORMAL);
end;

procedure TfrmAdvSettings.Label5Click(Sender: TObject);
var
//  jValue: TJSonValue;
  rversion: String;
begin
  ShellExecute(0, 'OPEN', PChar('https://github.com/vhanla/winxcorners/releases'), nil, nil, SW_SHOWNORMAL);
{  RESTClient1.BaseURL := 'https://updates.codigobit.net/app/winxcorners';
  RESTRequest1.Execute;
  try
    jValue := RESTResponse1.JSONValue;
    if Assigned(jValue) then
    begin
      rversion := jValue.GetValue('latestversion', '1.2');
      if rversion = VERSION then
        MessageDlg('You have the latest version.', mtInformation, [mbOK],0)
      else
        MessageDlg('', mtInformation, [mbOK],0);
    end
    else
      MessageDlg('Couldn''t retrieve info. Please visit official page.', mtError, [mbOK],0);
  except
    MessageDlg('Error', mtInformation, [mbOK],0);
  end;}
end;

procedure TfrmAdvSettings.PageControl1Change(Sender: TObject);
begin
 Windows.SetParent(GroupBox2.Handle, PageControl1.ActivePage.Handle);
 edCommand.Text := tmpcmdcli[PageControl1.ActivePageIndex];
 edParams.Text := tmpcmdarg[PageControl1.ActivePageIndex];
 chkHidden.Checked := tmpcmdhid[PageControl1.ActivePageIndex];
end;

procedure TfrmAdvSettings.ReadAdvancedIni;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+'settings.ini');
  try
    chkDelayGlobal.Checked := ini.ReadBool('Advanced','GlobalDelay',False);
    valDelayGlobal.Text := ini.ReadString('Advanced','GlobalDelayVal', '3');

    chkDelayTopLeft.Checked := ini.ReadBool('Advanced','TopLeftDelay', False);
    valDelayTopLeft.Text := ini.ReadString('Advanced','TopLeftVal', '3');
    chkDelayTopRight.Checked := ini.ReadBool('Advanced','TopRightDelay', False);
    valDelayTopRight.Text := ini.ReadString('Advanced','TopRightDelayVal', '3');
    chkDelayBotLeft.Checked := ini.ReadBool('Advanced','BotLeftDelay', False);
    valDelayBotLeft.Text := ini.ReadString('Advanced','BotLeftDelayVal', '3');
    chkDelayBotRight.Checked := ini.ReadBool('Advanced','BotRightDelay', False);
    valDelayBotRight.Text := ini.ReadString('Advanced','BotRightDelayVal', '3');

    chkShowCount.Checked := ini.ReadBool('Advanced', 'ShowCountDown', False);

    chkCustom.Checked := ini.ReadBool('Advanced', 'CustomCommand', False);
    frmTrayPopup.XPopupMenu.Items[6].Visible := chkCustom.Checked;
    frmTrayPopup.XPopupMenu.Items[7].Visible := chkCustom.Checked;
    frmTrayPopup.XPopupMenu.Items[8].Visible := chkCustom.Checked;
    frmTrayPopup.XPopupMenu.Items[9].Visible := chkCustom.Checked;
    frmTrayPopup.UpdateXCombos;

    cmdcli[0] := ini.ReadString('Advanced', 'CustomCommandline', '');
    cmdarg[0] := ini.ReadString('Advanced', 'CustomCommandparms', '');
    cmdhid[0] := ini.ReadBool('Advanced', 'CustomCommandHidden', False);

    cmdcli[1] := ini.ReadString('Advanced', 'CustomCommandline2', '');
    cmdarg[1] := ini.ReadString('Advanced', 'CustomCommandparms2', '');
    cmdhid[1] := ini.ReadBool('Advanced', 'CustomCommandHidden2', False);

    cmdcli[2] := ini.ReadString('Advanced', 'CustomCommandline3', '');
    cmdarg[2] := ini.ReadString('Advanced', 'CustomCommandparms3', '');
    cmdhid[2] := ini.ReadBool('Advanced', 'CustomCommandHidden3', False);

    cmdcli[3] := ini.ReadString('Advanced', 'CustomCommandline4', '');
    cmdarg[3] := ini.ReadString('Advanced', 'CustomCommandparms4', '');
    cmdhid[3] := ini.ReadBool('Advanced', 'CustomCommandHidden4', False);

    // clone values
    cmd2temp;

    edCommand.Text := cmdcli[PageControl1.ActivePageIndex];
    edParams.Text := cmdarg[PageControl1.ActivePageIndex];
    chkHidden.Checked := cmdhid[PageControl1.ActivePageIndex];

    chkFullScreen.Checked := ini.ReadBool('Advanced', 'IgnoreFullScreen', True);
    frmMain.tmFullScreen.Checked := chkFullScreen.Checked;
  finally
    ini.Free;
  end;
end;

procedure TfrmAdvSettings.SaveAdvancedIni;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+'settings.ini');
  try
    ini.WriteBool('Advanced','GlobalDelay',chkDelayGlobal.Checked);
    ini.WriteInteger('Advanced','GlobalDelayVal', StrToInt(valDelayGlobal.Text));

    ini.WriteBool('Advanced','TopLeftDelay',chkDelayTopLeft.Checked);
    ini.WriteInteger('Advanced','TopLeftVal', StrToInt(valDelayTopLeft.Text));
    ini.WriteBool('Advanced','TopRightDelay',chkDelayTopRight.Checked);
    ini.WriteInteger('Advanced','TopRightDelayVal', StrToInt(valDelayTopRight.Text));
    ini.WriteBool('Advanced','BotLeftDelay',chkDelayBotLeft.Checked);
    ini.WriteInteger('Advanced','BotLeftDelayVal', StrToInt(valDelayBotLeft.Text));
    ini.WriteBool('Advanced','BotRightDelay',chkDelayBotRight.Checked);
    ini.WriteInteger('Advanced','BotRightDelayVal', StrToInt(valDelayBotRight.Text));

    ini.WriteBool('Advanced', 'ShowCountDown', chkShowCount.Checked);

    ini.WriteBool('Advanced', 'CustomCommand', chkCustom.Checked);
    frmTrayPopup.XPopupMenu.Items[6].Visible := chkCustom.Checked;
    frmTrayPopup.XPopupMenu.Items[7].Visible := chkCustom.Checked;
    frmTrayPopup.XPopupMenu.Items[8].Visible := chkCustom.Checked;
    frmTrayPopup.XPopupMenu.Items[9].Visible := chkCustom.Checked;
    frmTrayPopup.UpdateXCombos;

    temp2cmd; // accept all the changes to commands

    ini.WriteString('Advanced', 'CustomCommandline', cmdcli[0]);
    ini.WriteString('Advanced', 'CustomCommandparms', cmdarg[0]);
    ini.WriteBool('Advanced', 'CustomCommandHidden', cmdhid[0]);

    ini.WriteString('Advanced', 'CustomCommandline2', cmdcli[1]);
    ini.WriteString('Advanced', 'CustomCommandparms2', cmdarg[1]);
    ini.WriteBool('Advanced', 'CustomCommandHidden2', cmdhid[1]);

    ini.WriteString('Advanced', 'CustomCommandline3', cmdcli[2]);
    ini.WriteString('Advanced', 'CustomCommandparms3', cmdarg[2]);
    ini.WriteBool('Advanced', 'CustomCommandHidden3', cmdhid[2]);

    ini.WriteString('Advanced', 'CustomCommandline4', cmdcli[3]);
    ini.WriteString('Advanced', 'CustomCommandparms4', cmdarg[3]);
    ini.WriteBool('Advanced', 'CustomCommandHidden4', cmdhid[3]);


    ini.WriteBool('Advanced', 'IgnoreFullScreen', chkFullScreen.Checked);
    frmMain.tmFullScreen.Checked := chkFullScreen.Checked;
  finally
    ini.Free;
  end;
end;

procedure TfrmAdvSettings.Temp2Cmd;
var
  I : Integer;
begin
  for I := 0 to 3 do
  begin
    cmdcli[I] := tmpcmdcli[I];
    cmdarg[I] := tmpcmdarg[I];
    cmdhid[I] := tmpcmdhid[I];
  end;
end;

end.

