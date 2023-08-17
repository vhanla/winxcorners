{
  A better settings popup window instead of VCL, FMX behaves more modern like
}
unit fmxSettings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.ListBox,
  Windows, FMX.Platform.Win, Messages, FMX.Menus, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.TabControl, FMX.ExtCtrls, System.Actions, FMX.ActnList,
  FMX.Layouts, FMX.Edit, FMX.EditBox, FMX.SpinBox;

type
  TfmxSettingsForm = class(TForm)
    Rectangle1: TRectangle;
    StyleBook1: TStyleBook;
    Button1: TButton;
    TabControl1: TTabControl;
    tabPopup: TTabItem;
    Switch1: TSwitch;
    PopupBox1: TPopupBox;
    PopupBox2: TPopupBox;
    PopupBox3: TPopupBox;
    PopupBox4: TPopupBox;
    tabSettings: TTabItem;
    Rectangle2: TRectangle;
    Button2: TButton;
    ActionList1: TActionList;
    ChangeTabAction1: TChangeTabAction;
    ChangeTabAction2: TChangeTabAction;
    VertScrollBox1: TVertScrollBox;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    SpinBox1: TSpinBox;
    SpinBox2: TSpinBox;
    SpinBox3: TSpinBox;
    SpinBox4: TSpinBox;
    SpinBox5: TSpinBox;
    GroupBox2: TGroupBox;
    Switch2: TSwitch;
    Label1: TLabel;
    Label2: TLabel;
    Switch3: TSwitch;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Rectangle3: TRectangle;
    popupShiftKeys: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Label5: TLabel;
    Switch4: TSwitch;
    procedure FormShow(Sender: TObject);
    procedure Rectangle1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure UpdatePosition;
  public
    { Public declarations }
    procedure EnableBlur(enable: Boolean = True);
    procedure Focus;
  end;

  AccentPolicy = packed record
    AccentState: Integer;
    AccentFlags: Integer;
    GradientColor: Integer;
    AnimationId: Integer;
  end;

  TWinCompAttrData = packed record
    attribute: THandle;
    pData: Pointer;
    dataSize: ULONG;
  end;

var
  fmxSettingsForm: TfmxSettingsForm;
  WndProcHook: THandle;

  SetWindowCompositionAttribute: function (Wnd: HWND; const AttrData: TWinCompAttrData): BOOL; stdcall = Nil;

implementation

uses
  ActiveX, JSON, ShellAPI, Dynamic_Bass, ComObj,
  System.Net.HttpClient, System.Net.URLClient, Generics.Collections,
  FMX.Platform,
  Winapi.DwmApi, functions, Main;

{$R *.fmx}

{ TfmxSettingsForm }

procedure TfmxSettingsForm.Button1Click(Sender: TObject);
begin
  ChangeTabAction2.Execute;
end;

procedure TfmxSettingsForm.Button2Click(Sender: TObject);
begin
  ChangeTabAction1.Execute;
end;

procedure TfmxSettingsForm.EnableBlur(enable: Boolean);
const
  WCA_ACCENT_POLICY = 19;
  ACCENT_ENABLE_BLURBEHIND = 3;
  ACCENT_ENABLE_ACRYLICBLURBEHIND = 4; // RS4-1803
  ACCENT_ENABLE_HOSTBACKDROP = 5; // RS5-1809
  DrawLeftBorder = $20;
  DrawTopBorder = $40;
  DrawRightBorder = $80;
  DrawBottomBorder = $100;
  DWMWCP_DEFAULT    = 0; // Let the system decide whether or not to round window corners
  DWMWCP_DONOTROUND = 1; // Never round window corners
  DWMWCP_ROUND      = 2; // Round the corners if appropriate
  DWMWCP_ROUNDSMALL = 3; // Round the corners if appropriate, with a small radius

  DWMWA_WINDOW_CORNER_PREFERENCE = 33; // [set] WINDOW_CORNER_PREFERENCE, Controls the policy that rounds top-level window corners

var
  dwm10: THandle;
  data : TWinCompAttrData;
  accent: AccentPolicy;
begin

      dwm10 := LoadLibrary('user32.dll');
      try
        @SetWindowCompositionAttribute := GetProcAddress(dwm10, 'SetWindowCompositionAttribute');
        if @SetWindowCompositionAttribute <> nil then
        begin
          if enable then
            accent.AccentState := ACCENT_ENABLE_ACRYLICBLURBEHIND
          else
          begin
              accent.AccentState := ACCENT_ENABLE_BLURBEHIND;
          end;
          //accent.GradientColor :=
          accent.AccentFlags := DrawLeftBorder or DrawTopBorder or DrawRightBorder or DrawBottomBorder;
//          accent.AccentFlags := $4000; // this won't show shadows but it will make faster on drag&drop

          data.Attribute := WCA_ACCENT_POLICY;
          data.dataSize := SizeOf(accent);
          data.pData := @accent;
          SetWindowCompositionAttribute(FMX.Platform.Win.FmxHandleToHWND(Handle), data);

          var PTrue: Integer;
          var PFalse: Integer;
          PTrue := 1;
          PFalse := 0;
          DwmSetWindowAttribute(FmxHandleToHWND(Handle), 20, @PFalse, SizeOf(Integer));
          DwmSetWindowAttribute(FmxHandleToHWND(Handle), 1029, @PTrue, SizeOf(Integer));

           var DWM_WINDOW_CORNER_PREFERENCE: Cardinal;
          DWM_WINDOW_CORNER_PREFERENCE := DWMWCP_ROUND;
          DwmSetWindowAttribute(FmxHandleToHWND(Handle), DWMWA_WINDOW_CORNER_PREFERENCE, @DWM_WINDOW_CORNER_PREFERENCE, sizeof(DWM_WINDOW_CORNER_PREFERENCE));
        end
        else
        begin
          ShowMessage('Not found Windows 10 blur API');
        end;
      finally
        FreeLibrary(dwm10);
      end;
end;

procedure TfmxSettingsForm.Focus;
begin
  SwitchToThisWindow(FmxHandleToHWND(Handle), True);
end;

procedure TfmxSettingsForm.FormCreate(Sender: TObject);
begin
  FormStyle := TFormStyle.StayOnTop;
  Width := 528;
  Height := 336;
end;

procedure TfmxSettingsForm.FormShow(Sender: TObject);
begin
  EnableBlur;
  UpdatePosition;
  SwitchToThisWindow(FmxHandleToHWND(Handle), True);

end;

procedure TfmxSettingsForm.Rectangle1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  ReleaseCapture;
  PostMessage(FmxHandleToHWND(Handle), WM_SYSCOMMAND, $F012, 0);
end;

procedure TfmxSettingsForm.UpdatePosition;
begin
  var ScaleFactor := frmMain.ScaleFactor;
//        var DPI := frmMain.PixelsPerInch; //Winapi.Windows.screen GetDpiForWindow(frmMain.Handle);
  case frmMain.FMainTaskbar.Position of
    ABE_LEFT:
      begin
        var MaxLeft := Round(frmMain.FMainTaskbar.Rect.Right / ScaleFactor); //+10;
        Left := MaxLeft;// - 20;
        if Left < 1 then Left := 10;
        Top := Round(frmMain.FMainTaskbar.ScreenRect.Height / ScaleFactor) - Height - 10;
        if Top<1 then Top:=10;
      end;
    ABE_TOP:
      begin
        Left := Round(frmMain.FMainTaskbar.ScreenRect.Width / ScaleFactor) - Width - 10;
        if Left < 1 then Left := 10;
        var MaxTop := Round(frmMain.FMainTaskbar.Rect.Bottom / ScaleFactor); //+10;
        Top := MaxTop;
        if Top < 1 then Top := 10;
      end;
    ABE_RIGHT:
      begin
//        var MaxLeft := Round(frmMain.FMainTaskbar.Rect.Left / ScaleFactor) - Width; //-10;
        var MaxLeft := frmMain.FMainTaskbar.Rect.Left - Width; //-10;
        Left := MaxLeft;// + 20;
        if Left < 1 then Left := 10;
        Top := Round(frmMain.FMainTaskbar.ScreenRect.Height / ScaleFactor) - Height - 10;
        if Top<1 then Top:=10;
      end;
    ABE_BOTTOM:
      begin
        Left := Round(frmMain.FMainTaskbar.ScreenRect.Width / ScaleFactor) - Width - 10;
        if Left < 1 then Left := 10;
        var MaxTop := Round(frmMain.FMainTaskbar.ScreenRect.Height / ScaleFactor) - Height - frmMain.FMainTaskbar.Rect.Bottom+frmMain.FMainTaskbar.Rect.Top;//-10;
        Top := MaxTop;// + 20;
        if Top < 1 then Top := 10;
      end;
  end;

end;

{ WndProc accepts messages sent to ApplicationHWND}
procedure BlurForm(Handle: HWND);
const
  WCA_ACCENT_POLICY = 19;
  ACCENT_ENABLE_BLURBEHIND = 3;
  ACCENT_ENABLE_ACRYLICBLURBEHIND = 4; // RS4-1803
  ACCENT_ENABLE_HOSTBACKDROP = 5; // RS5-1809
  DrawLeftBorder = $20;
  DrawTopBorder = $40;
  DrawRightBorder = $80;
  DrawBottomBorder = $100;
  DWMWCP_DEFAULT    = 0; // Let the system decide whether or not to round window corners
  DWMWCP_DONOTROUND = 1; // Never round window corners
  DWMWCP_ROUND      = 2; // Round the corners if appropriate
  DWMWCP_ROUNDSMALL = 3; // Round the corners if appropriate, with a small radius

  DWMWA_WINDOW_CORNER_PREFERENCE = 33; // [set] WINDOW_CORNER_PREFERENCE, Controls the policy that rounds top-level window corners
  DWMWA_MICA:Integer = 1029;
var
  dwm10: THandle;
  data : TWinCompAttrData;
  accent: AccentPolicy;
begin

      dwm10 := LoadLibrary('user32.dll');
      try
        @SetWindowCompositionAttribute := GetProcAddress(dwm10, 'SetWindowCompositionAttribute');
        if @SetWindowCompositionAttribute <> nil then
        begin
//          if enable then
            accent.AccentState := ACCENT_ENABLE_ACRYLICBLURBEHIND;
//          else
//          begin
//              accent.AccentState := ACCENT_ENABLE_BLURBEHIND;
//          end;
//          accent.GradientColor := $ffffff;
          accent.AccentFlags := DrawLeftBorder or DrawTopBorder or DrawRightBorder or DrawBottomBorder;
//          accent.AccentFlags := $4000; // this won't show shadows but it will make faster on drag&drop

          data.Attribute := WCA_ACCENT_POLICY;
          data.dataSize := SizeOf(accent);
          data.pData := @accent;
          SetWindowCompositionAttribute(Handle, data);

          var PTrue: Integer;
          var PFalse: Integer;
          PTrue := 1;
          PFalse := 0;
          DwmSetWindowAttribute(Handle, 20, @PFalse, SizeOf(Integer));
          DwmSetWindowAttribute(Handle, 1029, @PTrue, SizeOf(Integer));

           var DWM_WINDOW_CORNER_PREFERENCE: Cardinal;
          DWM_WINDOW_CORNER_PREFERENCE := DWMWCP_ROUND;
          DwmSetWindowAttribute(Handle, DWMWA_WINDOW_CORNER_PREFERENCE, @DWM_WINDOW_CORNER_PREFERENCE, sizeof(DWM_WINDOW_CORNER_PREFERENCE));
          DwmSetWindowAttribute(Handle, DWMWA_MICA, @DWM_WINDOW_CORNER_PREFERENCE, sizeof(Integer));
        end
        else
        begin
          ShowMessage('Not found Windows 10 blur API');
        end;
      finally
        FreeLibrary(dwm10);
      end;
end;

function WndProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  msg: TCWPRetStruct;
  clase: array[0..254] of widechar;
  ps: TPaintStruct;
  dc: HDC;
  pr: TRect;
begin
  if (nCode >= HC_ACTION) and (lParam > 0) then
  begin
    msg := PCWPRetStruct(LParam)^;

    if msg.message = WM_WINDOWPOSCHANGING then
    begin
      // disable sluggish acrylic effect
//      frmRadio.EnableBlur(False);
    end;

    if msg.message = WM_WINDOWPOSCHANGED then
    begin
//      frmRadio.EnableBlur;
    end;

    if msg.message = WM_CREATE then
    begin
//      GetClassName(msg.hwnd, @clase, 255);
//      if Pos('FMTCustomPopupForm', clase) = 1 then
      begin
        BlurForm(msg.hwnd);
        SetWindowLong(msg.hwnd, GWL_EXSTYLE, GetWindowLong(msg.hwnd, GWL_EXSTYLE) or WS_EX_TOPMOST);
      end;
//      SetWindowLong(msg.hwnd, GWL_EXSTYLE, GetWindowLong(msg.hwnd, GWL_EXSTYLE) and not WS_EX_LAYERED);

    end;

    if msg.message = WM_PAINT then
    begin
      GetClassName(msg.hwnd, @clase, 255);
      if Pos('FMTCustomPopupForm', clase) = 1 then
      begin
        GetWindowRect(msg.hwnd, pr);
        BeginPaint(msg.hwnd, ps);
        try
          FillRect(dc, pr, GetStockObject(WHITE_BRUSH));
        finally
          EndPaint(msg.hwnd, ps);
          ReleaseDC(msg.hwnd, dc);
        end;
      end;
    end;

    if msg.message = WM_ACTIVATEAPP then
    begin
      if msg.wParam = 0 then
        fmxSettingsForm.Close;
    end;


  end;

  Result := CallNextHookEx(WndProcHook, nCode, wParam, lParam);
end;

initialization
  CoInitialize(nil);
  WndProcHook := 0;
  WndProcHook := SetWindowsHookEx(WH_CALLWNDPROCRET, @WndProc, 0, GetCurrentThreadId);
  if WndProcHook = 0 then
    raise Exception.Create('Hook procedure failed!');
finalization
  UnhookWindowsHookEx(WndProcHook);
  CoUninitialize;

end.
