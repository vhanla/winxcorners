unit UCL.Popup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, UWP.Form, DWMAPI, UWP.ColorManager,
  Winapi.UXTheme;

type
  TFormPopup = class;

  TPopupStyles = (psShowArrow, psAnimate, psShadow, psFrame);

  TPopupStyle = set of TPopupStyles;

  TFreeMethod = TProc<TFormPopup>;

  TFormPopup = class(TForm)

    Shape1: TShape;

    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure WmActivate(var Msg: TWMActivate); message WM_ACTIVATE;
  private
    FOwner: TForm;
    FControl: TWinControl;
    FAnimate: Boolean;
    FClosing: Boolean;
    FFreeMethod: TFreeMethod;
    procedure DoRelease;
    procedure WndProc(var Msg: TMessage); override;
  public
    constructor CreatePopup(AOwner: TForm; AControl: TWinControl; FreeMethod: TFreeMethod; X, Y: Integer; Style: TPopupStyle); overload;
  end;

implementation

{$R *.dfm}

uses functions;

{ TFormPopup }

procedure TFormPopup.DoRelease;
begin
  FControl.Hide;
  Winapi.Windows.SetParent(FControl.Handle, FOwner.Handle);
  Release;
end;

constructor TFormPopup.CreatePopup(AOwner: TForm; AControl: TWinControl; FreeMethod: TFreeMethod; X, Y: Integer; Style: TPopupStyle);
var
  margs: TMargins;
begin
  inherited Create(AOwner);
  GlassFrame.Enabled := True;
  GlassFrame.SheetOfGlass := True;
  margs.cyTopHeight := 1;
  if DwmCompositionEnabled then
    DwmExtendFrameIntoClientArea(Handle, margs);
  EnableBlur(Handle);

//  ThemeManager.ThemeType := TUThemeType.ttDark;
  FClosing := False;
  FOwner := AOwner;
  FControl := AControl;
  FAnimate := psAnimate in Style;
  FFreeMethod := FreeMethod;
  Winapi.Windows.SetParent(FControl.Handle, Handle);
  Left := X;
  Top := Y;

  begin
    if psShadow in Style then
    begin
      SetClassLong(Handle, GCL_STYLE, GetWindowLong(Handle, GCL_STYLE) or CS_DROPSHADOW);
      Color := $00404040;
    end
    else
    begin
      Shape1.Hide;
      Color := clBtnFace;
    end;
    ClientWidth := FControl.Width;
    ClientHeight := FControl.Height;
    FControl.Left := 0;
    FControl.Top := 0;
    TransparentColor := False;
  end;
  if psFrame in Style then
  begin
    FControl.Left := FControl.Left + 1;
    FControl.Top := FControl.Top + 1;
    ClientWidth := ClientWidth + 2;
    ClientHeight := ClientHeight + 2;
  end;
  FControl.Show;
  FControl.BringToFront;
  FControl.SetFocus;
end;

procedure TFormPopup.FormActivate(Sender: TObject);
begin
  SendMessage(FOwner.Handle, WM_NCACTIVATE, Integer(True), 0);
end;

procedure TFormPopup.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPopup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FClosing then
  begin
    Action := caNone;
    Exit;
  end
  else if Assigned(FFreeMethod) then
    FFreeMethod(Self);
  FClosing := True;
end;

procedure TFormPopup.FormHide(Sender: TObject);
begin
  if FAnimate then
    AnimateWindow(Handle, 100, AW_BLEND or AW_HIDE);
  DoRelease;
end;

procedure TFormPopup.FormShow(Sender: TObject);
var
  LMonitor: TMonitor;
  LPadding: Integer;
begin
  LMonitor := Screen.MonitorFromWindow(Handle);
  if Left + Width > LMonitor.WorkareaRect.Right then
  begin
    LPadding := Monitor.Width - Monitor.WorkareaRect.Width;
    Left := LMonitor.WorkareaRect.Right - Width;
    if LPadding > 0 then Left := Left + 8;
  end;
  if Top + Height > LMonitor.WorkareaRect.Bottom then
  begin
    LPadding := Monitor.Height - Monitor.WorkareaRect.Height;
    Top := LMonitor.WorkareaRect.Bottom - Height;
    if LPadding > 0 then Top := Top + 8;
  end;

  if Left < 0 then
    Left := 0;
  if Top < 0 then
    Top := 0;
  if FAnimate then
  begin
    AnimateWindow(Handle, 150, AW_VER_POSITIVE);
  end;
end;

procedure TFormPopup.WmActivate(var Msg: TWMActivate);
begin
  SendMessage(FOwner.Handle, WM_NCACTIVATE, Ord(Msg.Active <> WA_INACTIVE), 0);
  inherited;
  if Msg.Active = WA_INACTIVE then
    DoRelease;
end;

procedure TFormPopup.WndProc(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_NCCALCSIZE: Msg.Msg := WM_NULL;
  end;

  inherited WndProc(Msg);
end;

end.


