unit frmAdvanced;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Spin,
  ExtCtrls, ShellApi, IniFiles, ComCtrls, Buttons, Menus, rkSmartTabs, XCheckbox,
  Tabs, attabs;

const
  VERSION = '1.3';

type

{  TBitBtn = class(Buttons.TBitBtn)
  private
    procedure CNDrawItem(var Msg: TWMDrawItem); message CN_DRAWITEM;
    procedure CNFocusChanged(var Msg: TMessage); message CM_FOCUSCHANGED;
  protected
    procedure DrawButton(const DrawItemStruct: TDrawItemStruct); virtual;
  end;}

  TfrmAdvSettings = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    edCommand: TButtonedEdit;
    edParams: TButtonedEdit;
    cbValDelayGlobal: TComboBox;
    btnCancel: TButton;
    btnOK: TButton;
    chkDelayGlobal: TXCheckbox;
    ATTabs1: TATTabs;
    chkShowCount: TXCheckbox;
    chkFullScreen: TXCheckbox;
    chkDelayTopLeft: TXCheckbox;
    chkDelayBotLeft: TXCheckbox;
    chkDelayTopRight: TXCheckbox;
    chkDelayBotRight: TXCheckbox;
    chkCustom: TXCheckbox;
    chkHidden: TXCheckbox;
    Panel1: TPanel;
    Panel2: TPanel;
    cbValDelayTopLeft: TComboBox;
    cbValDelayBotLeft: TComboBox;
    cbValDelayTopRight: TComboBox;
    cbValDelayBotRight: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure chkDelayGlobalClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure chkFullScreenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edCommandChange(Sender: TObject);
    procedure edParamsChange(Sender: TObject);
    procedure chkHiddenClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rkSmartTabs1TabChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure ATTabs1TabClick(Sender: TObject);
    procedure chkDelayTopLeftClick(Sender: TObject);
    procedure chkDelayTopRightClick(Sender: TObject);
    procedure chkDelayBotLeftClick(Sender: TObject);
    procedure chkDelayBotRightClick(Sender: TObject);

  protected
    FBitmap: TBitmap;
    FBrush: HBRUSH;
    procedure WndProc(var Msg: TMessage); override;
  private
    { Private declarations }
    FCurTab: Integer;
    procedure Temp2Cmd; // dump changes to official
    procedure Cmd2Temp; // restore from temp to official cmd
  public
    { Public declarations }
    procedure SaveAdvancedIni;
    procedure ReadAdvancedIni;
    procedure ToggleEachCornersDelay(Enable: Boolean);
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

uses frmSettings, main, functions, conditionshelper;

  function SetWindowTheme(hwnd: HWND; pszSubAppName: LPCWSTR; pszSubIdList: LPCWSTR): HRESULT; stdcall;
    external 'uxtheme.dll';

procedure TfrmAdvSettings.ATTabs1TabClick(Sender: TObject);
begin
  FCurTab := ATTabs1.TabIndex;
//  caption := inttostr(curTab);
  edCommand.Text := tmpcmdcli[FCurTab];
  edParams.Text := tmpcmdarg[FCurTab];
  chkHidden.Checked := tmpcmdhid[FCurTab];
end;

procedure TfrmAdvSettings.btnCancelClick(Sender: TObject);
begin
  ReadAdvancedIni;
  close
end;

procedure TfrmAdvSettings.btnOKClick(Sender: TObject);
begin
  SaveAdvancedIni;
  Close
end;

procedure TfrmAdvSettings.chkDelayBotLeftClick(Sender: TObject);
begin
  cbValDelayBotLeft.Enabled := chkDelayBotLeft.Checked;
end;

procedure TfrmAdvSettings.chkDelayBotRightClick(Sender: TObject);
begin
  cbValDelayBotRight.Enabled := chkDelayBotRight.Checked;
end;

procedure TfrmAdvSettings.chkDelayGlobalClick(Sender: TObject);
begin
  if chkDelayGlobal.Checked then
  begin
    cbValDelayGlobal.Enabled := True;
    ToggleEachCornersDelay(False);
  end
  else
  begin
    cbValDelayGlobal.Enabled := False;
    ToggleEachCornersDelay(True);
  end;

end;

procedure TfrmAdvSettings.chkDelayTopLeftClick(Sender: TObject);
begin
  cbValDelayTopLeft.Enabled := chkDelayTopLeft.Checked;
end;

procedure TfrmAdvSettings.chkDelayTopRightClick(Sender: TObject);
begin
  cbValDelayTopRight.Enabled := chkDelayTopRight.Checked;
end;

procedure TfrmAdvSettings.chkFullScreenClick(Sender: TObject);
begin
  frmMain.tmFullScreen.Checked := chkFullScreen.Checked;
end;

procedure TfrmAdvSettings.chkHiddenClick(Sender: TObject);
begin
  if Sender is TCheckBox then
    tmpcmdhid[FCurTab] := chkHidden.Checked;
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
    tmpcmdcli[FCurTab] := edCommand.Text;
end;

procedure TfrmAdvSettings.edParamsChange(Sender: TObject);
begin
  if Sender is TEdit then
    tmpcmdarg[FCurTab] := edParams.Text;
end;


procedure TfrmAdvSettings.FormCreate(Sender: TObject);
begin

  FCurTab := 0;
  FBitmap := TBitmap.Create;
  FBitmap.SetSize(64,64);
  FBitmap.PixelFormat := pf24bit;
  FBitmap.Canvas.Brush.Style := bsSolid;
  FBitmap.Canvas.Brush.Color := $2d2d2d;
  FBitmap.Canvas.FillRect(ClientRect);
//  FBitmap.LoadFromFile('T:\Program Files (x86)\Caphyon\Advanced Installer 21.0.1\themes\surface\resources\variations\metropurple\background.bmp');
  FBrush := 0;
  FBrush := CreatePatternBrush(FBitmap.Handle);
//  if not SystemUsesLightTheme then
//  begin
//    AllowDarkModeForWindow(Handle, True);
//    AllowDarkModeForApp(True);
//    SetPreferredAppMode(1);
//    DarkMode;
//  end;

  FormStyle := fsStayOnTop;
  BorderStyle := bsSingle;
  BorderIcons := [biSystemMenu, biMinimize];
  Position := poScreenCenter;
  cbValDelayGlobal.Enabled := False;
  ReadAdvancedIni;
    UseImmersiveDarkMode(Handle, True);
//  EnableNCShadow(Handle);
//  setwindowtheme(Edit1.Handle, 'CFD', nil);
//  AllowDarkModeForWindow(Edit1.Handle, True);
//  sendmessagew(Edit1.Handle, WM_THEMECHANGED, 0, 0);

  setwindowtheme(cbValDelayGlobal.Handle, 'CFD', nil);
  AllowDarkModeForWindow(cbValDelayGlobal.Handle, True);
  sendmessagew(cbValDelayGlobal.Handle, WM_THEMECHANGED, 0, 0);

  setwindowtheme(cbValDelayTopLeft.Handle, 'CFD', nil);
  AllowDarkModeForWindow(cbValDelayTopLeft.Handle, True);
  sendmessagew(cbValDelayTopLeft.Handle, WM_THEMECHANGED, 0, 0);

  setwindowtheme(cbValDelayTopRight.Handle, 'CFD', nil);
  AllowDarkModeForWindow(cbValDelayTopRight.Handle, True);
  sendmessagew(cbValDelayTopRight.Handle, WM_THEMECHANGED, 0, 0);

  setwindowtheme(cbValDelayBotLeft.Handle, 'CFD', nil);
  AllowDarkModeForWindow(cbValDelayBotLeft.Handle, True);
  sendmessagew(cbValDelayBotLeft.Handle, WM_THEMECHANGED, 0, 0);

  setwindowtheme(cbValDelayBotRight.Handle, 'CFD', nil);
  AllowDarkModeForWindow(cbValDelayBotRight.Handle, True);
  sendmessagew(cbValDelayBotRight.Handle, WM_THEMECHANGED, 0, 0);


//  setwindowtheme(ComboBox2.Handle, 'CFD', nil);
//  AllowDarkModeForWindow(ComboBox2.Handle, True);
//  sendmessagew(ComboBox2.Handle, WM_THEMECHANGED, 0, 0);


  setwindowtheme(btnOK.Handle, 'Explorer', nil);
  AllowDarkModeForWindow(btnOK.Handle, True);
  sendmessagew(btnOK.Handle, WM_THEMECHANGED, 0, 0);

  setwindowtheme(btnCancel.Handle, 'Explorer', nil);
  AllowDarkModeForWindow(btnCancel.Handle, True);
  sendmessagew(btnCancel.Handle, WM_THEMECHANGED, 0, 0);


end;

procedure TfrmAdvSettings.FormDestroy(Sender: TObject);
begin
  FBitmap.Free;
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
//  ShowMessage(IntToStr(Windows.GetWindowTextLength(GetForegroundWindow)));
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
    cbValDelayGlobal.ItemIndex := ini.ReadInteger('Advanced','GlobalDelayVal', 3);

    chkDelayTopLeft.Checked := ini.ReadBool('Advanced','TopLeftDelay', False);
    cbValDelayTopLeft.ItemIndex := ini.ReadInteger('Advanced','TopLeftVal', 3);
    chkDelayTopRight.Checked := ini.ReadBool('Advanced','TopRightDelay', False);
    cbValDelayTopRight.ItemIndex := ini.ReadInteger('Advanced','TopRightDelayVal', 3);
    chkDelayBotLeft.Checked := ini.ReadBool('Advanced','BotLeftDelay', False);
    cbValDelayBotLeft.ItemIndex := ini.ReadInteger('Advanced','BotLeftDelayVal', 3);
    chkDelayBotRight.Checked := ini.ReadBool('Advanced','BotRightDelay', False);
    cbValDelayBotRight.ItemIndex := ini.ReadInteger('Advanced','BotRightDelayVal', 3);

    ToggleEachCornersDelay(not chkDelayGlobal.Checked);

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

    edCommand.Text := cmdcli[FCurTab];
    edParams.Text := cmdarg[FCurTab];
    chkHidden.Checked := cmdhid[FCurTab];

    chkFullScreen.Checked := ini.ReadBool('Advanced', 'IgnoreFullScreen', True);
    frmMain.tmFullScreen.Checked := chkFullScreen.Checked;
  finally
    ini.Free;
  end;
end;

procedure TfrmAdvSettings.rkSmartTabs1TabChange(Sender: TObject);
var
  curTab: Integer;
begin
  //
//  curTab := rkSmartTabs1.ActiveTab;
  caption := inttostr(curTab);
  edCommand.Text := tmpcmdcli[curTab];
  edParams.Text := tmpcmdarg[curTab];
  chkHidden.Checked := tmpcmdhid[curTab];
end;

procedure TfrmAdvSettings.SaveAdvancedIni;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+'settings.ini');
  try
    ini.WriteBool('Advanced','GlobalDelay',chkDelayGlobal.Checked);
    ini.WriteInteger('Advanced','GlobalDelayVal', cbValDelayGlobal.ItemIndex);

    ini.WriteBool('Advanced','TopLeftDelay',chkDelayTopLeft.Checked);
    ini.WriteInteger('Advanced','TopLeftVal', cbValDelayTopLeft.ItemIndex);
    ini.WriteBool('Advanced','TopRightDelay',chkDelayTopRight.Checked);
    ini.WriteInteger('Advanced','TopRightDelayVal', cbValDelayTopRight.ItemIndex);
    ini.WriteBool('Advanced','BotLeftDelay',chkDelayBotLeft.Checked);
    ini.WriteInteger('Advanced','BotLeftDelayVal', cbValDelayBotLeft.ItemIndex);
    ini.WriteBool('Advanced','BotRightDelay',chkDelayBotRight.Checked);
    ini.WriteInteger('Advanced','BotRightDelayVal', cbValDelayBotRight.ItemIndex);

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

procedure TfrmAdvSettings.ToggleEachCornersDelay(Enable: Boolean);
begin
  if Enable then
  begin
    chkDelayTopLeft.Enabled := True;
    cbValDelayTopLeft.Enabled := chkDelayTopLeft.Checked;

    chkDelayTopRight.Enabled := True;
    cbValDelayTopRight.Enabled := chkDelayTopRight.Checked;

    chkDelayBotLeft.Enabled := True;
    cbValDelayBotLeft.Enabled := chkDelayBotLeft.Checked;

    chkDelayBotRight.Enabled := True;
    cbValDelayBotRight.Enabled := chkDelayBotRight.Checked;
  end
  else
  begin
    chkDelayTopLeft.Enabled := False;
    chkDelayTopLeft.Checked := False;
    cbValDelayTopLeft.Enabled := False;

    chkDelayTopRight.Enabled := False;
    chkDelayTopRight.Checked := False;
    cbValDelayTopRight.Enabled := False;

    chkDelayBotLeft.Enabled := False;
    chkDelayBotLeft.Checked := False;
    cbValDelayBotLeft.Enabled := False;

    chkDelayBotRight.Enabled := False;
    chkDelayBotRight.Checked := False;
    cbValDelayBotRight.Enabled := False;
  end;

end;

procedure TfrmAdvSettings.WndProc(var Msg: TMessage);
begin
  inherited;

  case Msg.Msg of
    WM_CTLCOLOREDIT, WM_CTLCOLORSTATIC:
    begin
      if ((Msg.LParam = edCommand.Handle) or (Msg.LParam = edParams.Handle) ) and (FBrush <> 0) then
      begin
        SetBkMode(Msg.WParam, TRANSPARENT);
        Msg.Result := FBrush;
      end;
    end;
  end;
end;

{procedure TfrmAdvSettings.XCheckbox1Click(Sender: TObject);
begin

end;

 TBitBtn }

{procedure TBitBtn.CNDrawItem(var Msg: TWMDrawItem);
begin
  DrawButton(Msg.DrawItemStruct^);
  Msg.Result := Integer(True);
end;

procedure TBitBtn.CNFocusChanged(var Msg: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TBitBtn.DrawButton(const DrawItemStruct: TDrawItemStruct);
var
  Canvas: TCanvas;
begin
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := DrawItemStruct.hDC;

    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := $2d2d2d;
    Canvas.Rectangle(ClientRect);
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Assign(Font);
    Canvas.TextRect(ClientRect, 12,10,Self.Caption);//, [tfVerticalCenter, tfCenter, tfSingleLine]);
  finally
//    ReleaseDC(Canvas.Handle);
    Canvas.Handle := 0;
    Canvas.Free;
  end;
end;}



end.

