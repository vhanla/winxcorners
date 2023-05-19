unit frmAdvanced;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls, ShellApi, IniFiles, IPPeerClient, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Client, Vcl.ComCtrls, UWP.Form, UWP.Classes,
  UWP.QuickButton, UWP.Caption, UWP.Button, Vcl.WinXPanels, Vcl.WinXCtrls,
  UWP.ListButton, UWP.ScrollBox, UWP.Panel, Vcl.Imaging.pngimage,
  ES.BaseControls, ES.Switch, scStyledForm, VirtualTrees
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
    chkShowCount: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox3: TGroupBox;
    HotKey1: THotKey;
    Label6: TLabel;
    SplitView1: TSplitView;
    CardPanel1: TCardPanel;
    crdSettings: TCard;
    crdAbout: TCard;
    ulbtnSettings: TUWPListButton;
    ulbtnAbout: TUWPListButton;
    StackPanel1: TStackPanel;
    Panel1: TPanel;
    ulbtnAdvanced: TUWPListButton;
    pnlContent: TUWPPanel;
    Image1: TImage;
    crdAdvanced: TCard;
    EsSwitch1: TEsSwitch;
    EsSwitch2: TEsSwitch;
    EsSwitch3: TEsSwitch;
    btnAdvApply: TButton;
    btnAdvCancel: TButton;
    ulbActions: TUWPListButton;
    crdActions: TCard;
    gbLanguage: TGroupBox;
    ComboBox1: TComboBox;
    VirtualStringTree1: TVirtualStringTree;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label1: TLabel;
    edCommand: TEdit;
    chkCustom: TCheckBox;
    chkHidden: TCheckBox;
    edParams: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure chkDelayGlobalClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure ulbtnSettingsClick(Sender: TObject);
    procedure ulbtnAboutClick(Sender: TObject);
    procedure ulbtnAdvancedClick(Sender: TObject);
    procedure btnAdvApplyClick(Sender: TObject);
    procedure btnAdvCancelClick(Sender: TObject);
    procedure ulbActionsClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SaveAdvancedIni;
    procedure ReadAdvancedIni;
  end;

var
  frmAdvSettings: TfrmAdvSettings;

implementation

{$R *.dfm}

uses frmSettings, functions;

procedure TfrmAdvSettings.btnAdvApplyClick(Sender: TObject);
begin
  SaveAdvancedIni;
  Close

end;

procedure TfrmAdvSettings.btnAdvCancelClick(Sender: TObject);
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

procedure TfrmAdvSettings.ComboBox1Change(Sender: TObject);
var
  res: LongInt;
begin
  Exit; //fails
  res := LoadNewResourceModule(LANG_JAPANESE);
  if res <> NO_ERROR then
    ReinitializeForms;

end;

procedure TfrmAdvSettings.FormCreate(Sender: TObject);
begin
  FormStyle := fsStayOnTop;
//  BorderStyle := bsSingle;
//  BorderIcons := [biSystemMenu, biMinimize];
  Position := poScreenCenter;
  valDelayGlobal.Enabled := False;
  ReadAdvancedIni;
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
    {frmTrayPopup.XPopupMenu.Items[5].Visible := chkCustom.Checked;
    frmTrayPopup.UpdateXCombos;}
    frmTrayPopup.ulbCustomCommand.Visible := chkCustom.Checked;
    frmTrayPopup.UpdateXCombos;
    edCommand.Text := ini.ReadString('Advanced', 'CustomCommandline', '');
    edParams.Text := ini.ReadString('Advanced', 'CustomCommandparms', '');
    chkHidden.Checked := ini.ReadBool('Advanced', 'CustomCommandHidden', False);
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
    {frmTrayPopup.XPopupMenu.Items[5].Visible := chkCustom.Checked;
    frmTrayPopup.UpdateXCombos;}
    frmTrayPopup.ulbCustomCommand.Visible := chkCustom.Checked;
    frmTrayPopup.UpdateXCombos;
    ini.WriteString('Advanced', 'CustomCommandline', edCommand.Text);
    ini.WriteString('Advanced', 'CustomCommandparms', edParams.Text);
    ini.WriteBool('Advanced', 'CustomCommandHidden', chkHidden.Checked);
  finally
    ini.Free;
  end;
end;

procedure TfrmAdvSettings.ulbtnSettingsClick(Sender: TObject);
begin
  CardPanel1.ActiveCard := crdSettings;
end;

procedure TfrmAdvSettings.ulbActionsClick(Sender: TObject);
begin
  CardPanel1.ActiveCard := crdActions;
end;

procedure TfrmAdvSettings.ulbtnAboutClick(Sender: TObject);
begin
  CardPanel1.ActiveCard := crdAbout;
end;

procedure TfrmAdvSettings.ulbtnAdvancedClick(Sender: TObject);
begin
  CardPanel1.ActiveCard := crdAdvanced;
end;

end.

