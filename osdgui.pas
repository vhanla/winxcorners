unit osdgui;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DWMApi, ActiveX, GDIPapi, GDIPObj;

type
  TfrmOSD = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DrawBubble(const text: String = '');
  end;

var
  frmOSD: TfrmOSD;

implementation

{$R *.dfm}

uses main;
type
  TFixedStreamAdapter = class(TStreamAdapter)
  public
    function Stat(out statstg: TStatStg; grfStatFlag: DWORD): HResult; override; stdcall;
  end;

function TFixedStreamAdapter.Stat(out statstg: TStatStg; grfStatFlag: DWORD): HResult;
begin
  Result := inherited Stat(statstg, grfStatFlag);
  statstg.pwcsName := nil;
end;

procedure TfrmOSD.DrawBubble(const text: String = '');
var
  bmp: TBitmap;
  Stream: TStream;
  StreamAdapter: IStream;
  PNGBitmap: TGPBitmap;
  BitmapHandle: HBITMAP;
  BlendFunction: TBlendFunction;
  BitmapPos: TPoint;
  BitmapSize: TSize;


  xfont: TGPFont;
  //style: Integer;
  graph: TGPGraphics;
  brush: TGPSolidBrush;
  stringFormat: TGPStringFormat;

  textval : Integer;
begin
  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf32bit;

    textval := 1;
    if Trim(text) <> '' then
      textval := StrToInt(text);


    if textval and 1 = 1then
      Stream := TResourceStream.Create(HInstance, 'PngImage_1', RT_RCDATA)
    else
      Stream := TResourceStream.Create(HInstance, 'PngImage_2', RT_RCDATA);
    try
      StreamAdapter := TFixedStreamAdapter.Create(Stream);
      try
        PNGBitmap := TGPBitmap.Create(StreamAdapter);
        try
          PNGBitmap.GetHBITMAP(MakeColor(0, 0, 0, 0), BitmapHandle);
          bmp.Handle := BitmapHandle;
        finally
          PNGBitmap.Free;
        end;
      finally
        StreamAdapter := nil;
      end;
    finally
      Stream.Free;
    end;

    Assert(bmp.PixelFormat = pf32bit, 'Wrong bitmap format, must be 32 bits/pixel');

    //PremultiplyBitmap(bmp);
    //bmp.Canvas.FillRect(Rect(0,0,Width,Height));

    graph := TGPGraphics.Create(bmp.Canvas.Handle);
    try
      graph.SetSmoothingMode(SmoothingModeAntiAlias);
      //style := FontStyleRegular;
      //xfont := TGPFont.Create(font.Name, font.Size, style, UnitPoint);
      xfont := TGPFont.Create(Canvas.Handle, Font.Handle);
      try
        brush := TGPSolidBrush.Create(MakeColor(GetRValue(Font.Color), GetGValue(Font.Color), GetBValue(Font.Color)));
        try
          stringFormat := TGPStringFormat.Create;
          try
            stringFormat.SetAlignment(StringAlignmentCenter);
            stringFormat.SetLineAlignment(StringAlignmentCenter);
            stringFormat.SetTrimming(StringTrimmingEllipsisCharacter);
            stringFormat.SetFormatFlags(StringFormatFlagsNoWrap);
            graph.SetTextRenderingHint(TextRenderingHintAntiAliasGridFit);
            graph.DrawString(text,Length(text),xfont,MakePoint((bmp.Width/2 ),(bmp.Height/2 )),stringFormat,brush);
            //graph.SetTextRenderingHint(TextRenderingHintSingleBitPerPixelGridFit);
            //graph.DrawString(text,Length(text),xfont,MakePoint(12.0,12.0),nil,brush);
          finally
            stringFormat.Free;
          end;
        finally
          brush.Free;
        end;
      finally
        xfont.Free;
      end;
    finally
      graph.Free;
    end;

    ClientWidth := bmp.Width;
    ClientHeight := bmp.Height;

    // Position bitmap on form
    BitmapPos := Point(0, 0);
    BitmapSize.cx := bmp.Width;
    BitmapSize.cy := bmp.Height;

    // Setup alpha blending parameters
    BlendFunction.BlendOp := AC_SRC_OVER;
    BlendFunction.BlendFlags := 0;
    BlendFunction.SourceConstantAlpha := 255; // Start completely transparent
    BlendFunction.AlphaFormat := AC_SRC_ALPHA;

    UpdateLayeredWindow(Handle, 0, nil, @BitmapSize, bmp.Canvas.Handle,
        @BitmapPos, 0, @BlendFunction, ULW_ALPHA);

  finally
    bmp.Free;
  end;
end;

procedure TfrmOSD.FormActivate(Sender: TObject);
begin
//  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
end;

{procedure PremultiplyBitmap(Bitmap: TBitmap);
var
  Row, Col: integer;
  p: PRGBQuad;
  PreMult: array[byte, byte] of byte;
begin
  // precalculate all possible values of a*b
  for Row := 0 to 255 do
    for Col := Row to 255 do
    begin
      PreMult[Row, Col] := Row*Col div 255;
      if (Row <> Col) then
        PreMult[Col, Row] := PreMult[Row, Col]; // a*b = b*a
    end;

  for Row := 0 to Bitmap.Height-1 do
  begin
    Col := Bitmap.Width;
    p := Bitmap.ScanLine[Row];
    while (Col > 0) do
    begin
      p.rgbBlue := PreMult[p.rgbReserved, p.rgbBlue];
      p.rgbGreen := PreMult[p.rgbReserved, p.rgbGreen];
      p.rgbRed := PreMult[p.rgbReserved, p.rgbRed];
      inc(p);
      dec(Col);
    end;
  end;
end;
 }

procedure TfrmOSD.FormCreate(Sender: TObject);
var
  renderPolicy: DWMWINDOWATTRIBUTE; //integer;//DWMWINDOWATTRIBUTE;
begin
  frmMain.tmrHotSpot.Enabled := True;
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  Font.Size := 18;
  //Font.Color := $00DBBEA6;
  Font.Color := $00333333;


  DwmSetWindowAttribute(Handle, DWMWA_EXCLUDED_FROM_PEEK or DWMWA_FLIP3D_POLICY, @renderpolicy, SizeOf(Integer));
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) Or WS_EX_LAYERED or WS_EX_TRANSPARENT or WS_EX_TOOLWINDOW{ and not WS_EX_APPWINDOW});
  //SetLayeredWindowAttributes(Handle,0,255, LWA_ALPHA);
  //SetWindowPos(Handle,HWND_TOPMOST,Left,Top,Width, Height,SWP_NOMOVE or SWP_NOACTIVATE or SWP_NOSIZE);

  DrawBubble();
end;

procedure TfrmOSD.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

end.
