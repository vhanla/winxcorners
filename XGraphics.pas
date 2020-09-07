unit XGraphics;

interface

uses
  Windows, SysUtils, Classes, Graphics, Dialogs, Math, ActiveX, GDIPAPI, GDIPAPIExtra;

type
  PARGB = ^TARGB;
  TARGB = packed record
  case Integer of
    0: (c: ARGB);
    1: (b, g, r, a: Byte);
    2: (Flag: Byte; Reserved: array[0..2] of Byte);
  end;

PARGBArray = ^TARGBArray;
  TARGBArray = array[0..0] of TARGB;

  TGdipBitmap = class
  private
    FWidth: Integer;
    FHeight: Integer;
    FBitmapData: TBitmapData;
    FBits: Pointer;
    FIsLock: Boolean;

    function GetRect: TRect;
    function GetSize: Integer;

    procedure SetStatus(Value: TStatus);

    procedure AfterCreate;
  public
    GPBitmap: GpBitmap;

    constructor Create(const FileName: String); overload;
    constructor Create(Width, Height: Integer); overload;
    constructor Create(Width, Height, Stride: Integer; Format: TPixelFormat; Bits: Pointer); overload;
    constructor Create(Icon: HICON); overload;
    constructor Create(Bitmap: TGdipBitmap); overload;
    constructor Create(Bitmap: GpBitmap); overload;
    constructor CreateFromBitmap(Bitmap: GpBitmap);
    destructor Destroy; override;

    procedure ReCreate(Width, Height: Integer);

    procedure Assign(Bitmap: TGdipBitmap); overload;
    procedure Assign(Bitmap: GpBitmap); overload;
    procedure Assign(Bitmap: TGdipBitmap; Width, Height: Integer); overload;
    procedure Assign(Bitmap: GpBitmap; Width, Height: Integer); overload;

    procedure LockBits(PixelFormat: TPixelFormat = PixelFormat32bppARGB);
    procedure UnLockBits;

    procedure SaveToFile(const FileName: String; Encoder: TGUID);

    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Rect: TRect read GetRect;
    property Bits: Pointer read FBits;
    property Size: Integer read GetSize;
  end;

  TGdipDIB = class
  private
    FWidth: Integer;
    FHeight: Integer;
    FBits: Pointer;
    FDC: HDC;
    FBitmap: HBITMAP;
    FOldBitmap: HBITMAP;
    FBitmapInfo: TBitmapInfo;
    FLastStatus: TStatus;

    FFontName: String;
    FFontSize: Single;
    FFontStyle: TFontStyle;
    FBrushColor: TARGB;
    FPenColor: TARGB;
    FPenWidth: Integer;
    FAlpha: Byte;
    FAngle: Single;
    FContrast: Single;
    FAngleCenter: TPoint;
    FAlignStringHor: TStringAlignment;
    FAlignStringVer: TStringAlignment;
    FColorMatrix: TColorMatrix;

    FGPContext: GpGraphics;
    FGPBitmap: GpBitmap;
    FGPSolidBrush: GpSolidFill;
    FGPPen: GpPen;
    FGPFontFamily: GpFontFamily;
    FGPFont: GpFont;
    FGPStringFormat: GpStringFormat;
    FGPImageAttributes: GpImageAttributes;
    FGPMatrix: GPMatrix;

    function GetPixels(X, Y: Integer): Pointer;
    function GetSize: Integer;
    function GetRect: TRect;

    procedure SetStatus(Value: TStatus);
  public
    constructor Create; overload;
    constructor Create(Width, Height: Integer); overload;
    destructor Destroy; override;

    procedure Assign(DIB: TGdipDIB);

    procedure NewDIB(Width, Height: Integer);
    procedure FreeDIB;

    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(FileName: String);
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(FileName: String);

    procedure Fill; overload;
    procedure Fill(Color: ARGB); overload;
    procedure Fill(ARect: TRect; Color: ARGB); overload;

    procedure Premultiply;
    procedure AlphaBlend(Alpha: Byte); overload;
    procedure AlphaBlend(ARect: TRect; Alpha: Byte); overload;

    procedure Copy(DestRect: TRect; Src: TGdipDIB; SrcRect: TRect);

    procedure FillPath(Src: GpPath);
    procedure DrawPath(Src: GpPath);

    procedure RoundRect(ARect: TRect; Radius: Integer; Fill, Draw: Boolean);

    procedure Draw(DestRect: TRect; Src: TGdipDIB; SrcRect: TRect);
    procedure DrawMirror(DestX, DestY: Integer; Src: TGdipDIB; SrcX, SrcY,
      Width, Height: Integer; Alpha: Byte);
    procedure DrawBitmap(DestRect: TRect; Src: GpBitmap; SrcRect: TRect); overload;
    procedure DrawBitmap(DestRect: TRect; Src: TGdipBitmap; SrcRect: TRect); overload;
    procedure DrawBitmapTile(DestRect: TRect; Src: TGdipBitmap; SrcRect: TRect; StrechHeight: Boolean = False);
    procedure DrawString(ARect: TRect; const Text: WideString);
    procedure DrawTo(DC: HDC; DestRect, SrcRect: TRect);

    procedure SetFont(FontName: String; FontSize: Integer; FontStyle: TFontStyle);
    procedure SetBrush(Color: ARGB);
    procedure SetPen(Color: ARGB; Width: Integer);
    procedure SetAlpha(Value: Byte);
    procedure SetAngle(Value: Single; CenterX, CenterY: Integer);
    procedure SetContrast(Value: Single);
    procedure SetStringAlign(Horizontal, Vertical: TStringAlignment);

    function TextSize(const Text: WideString): TSize;
    function TextHeight(const Text: WideString): Integer;
    function TextWidth(const Text: WideString): Integer;

    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Pixels[X, Y: Integer]: Pointer read GetPixels; default;
    property Bits: Pointer read FBits;
    property Size: Integer read GetSize;
    property Rect: TRect read GetRect;
    property DC: HDC read FDC;
    property Bitmap: HBITMAP read FBitmap;
    property LastStatus: TStatus read FLastStatus;

    property FontName: String read FFontName;
    property FontSize: Single read FFontSize;
    property FontStyle: TFontStyle read FFontStyle;
    property BrushColor: TARGB read FBrushColor;
    property PenColor: TARGB read FPenColor;
    property PenWidth: Integer read FPenWidth;
    property Alpha: Byte read FAlpha;
    property Angle: Single read FAngle;
    property AngleCenter: TPoint read FAngleCenter;
    property Contrast: Single read FContrast;
    property AlignStringHor: TStringAlignment read FAlignStringHor;
    property AlignStringVer: TStringAlignment read FAlignStringVer;

    property GPContext: GpGraphics read FGPContext;
    property GPBitmap: GPBitmap read FGPBitmap;
    property GPSolidBrush: GpSolidFill read FGPSolidBrush;
    property GPPen: GPPen read FGPPen;
    property GPFontFamily: GPFontFamily read FGPFontFamily;
    property GPFont: GPFont read FGPFont;
    property GPStringFormat: GPStringFormat read FGPStringFormat;
    property GPMatrix: GPMatrix read FGPMatrix;
    property GPImageAttributes: GpImageAttributes read FGPImageAttributes;
  end;

const
  _ColorMatrix: TColorMatrix = (
  (1.0, 0.0, 0.0, 0.0, 0.0),
  (0.0, 1.0, 0.0, 0.0, 0.0),
  (0.0, 0.0, 1.0, 0.0, 0.0),
  (0.0, 0.0, 0.0, 1.0, 0.0),
  (0.0, 0.0, 0.0, 0.0, 1.0));

  function RectToRectF(const ARect: TRect): TGPRectF;

type
  TBlurProc = function(r1, g1, b1, a1, r2, g2, b2, a2: Byte): TARGB;

  procedure Blur(Src, Dest: Pointer; SrcWidth, SrcHeight, DestWidth, DestHeight,
    SrcX, SrcY, DestX, DestY, Width, Height, Radius: Integer; BlurProc: TBlurProc = NIL);
  procedure AlphaBlend(Src: Pointer; Width, Height: Integer; Painted: Boolean; AlphaValue: Byte);

implementation

uses ConvUtils;

var
  StartupInput: TGDIPlusStartupInput;
  {$ifdef VER340} //fix to Delphi 10.4
  GDIPlusToken: NativeUint;
  {$else}
  GDIPlusToken: DWORD;
  {$endif}

function RectToRectF(const ARect: TRect): TGPRectF;
begin
  Result.X := ARect.Left;
  Result.Y := ARect.Top;
  Result.Width := ARect.Right - ARect.Left;
  Result.Height := ARect.Bottom - ARect.Top;
end;

procedure AlphaBlend(Src: Pointer; Width, Height: Integer; Painted: Boolean; AlphaValue: Byte);
var
  y: Integer;
  p: PARGB;
begin
  p := Src;
  for y:= 0 to Height * Width - 1 do
  begin
    if (p^.a > 0) then
    begin
      if Painted then
      begin
        p^.r := Round(p^.r * AlphaValue / 255);
        p^.g := Round(p^.g * AlphaValue / 255);
        p^.b := Round(p^.b * AlphaValue / 255);
      end;
      p^.a := Round(AlphaValue * p^.a / 255);
    end;
    inc(p);
  end;
end;

procedure Blur(Src, Dest: Pointer; SrcWidth, SrcHeight, DestWidth, DestHeight,
  SrcX, SrcY, DestX, DestY, Width, Height, Radius: Integer; BlurProc: TBlurProc = NIL);
var
  rs, gs, bs, Alpha, y, x, y1, x1, i: Integer;
  pd: PARGB;
begin
  for y:= 0 to Height - 1 do
  begin
    pd := Pointer(Integer(Dest) + ((DestHeight - 1 - DestY - y) * DestWidth + DestX) * 4);
    for x:= 0 to Width - 1 do
    begin
      rs := 0;
      gs := 0;
      bs := 0;
      Alpha := 0;
      i := 0;
      for y1:= y - Radius to y + Radius do
      for x1:= x - Radius to x + Radius do
      begin
        if (y1 >= 0) and (y1 < SrcHeight - SrcY) and (x1 >= 0) and (x1 < SrcWidth - SrcX) then
        with PARGB(Integer(Src) + ((SrcHeight - 1 - SrcY - y1) * SrcWidth + (SrcX + x1)) * 4)^ do
        begin
          inc(rs, r);
          inc(gs, g);
          inc(bs, b);
          inc(Alpha, a);
          inc(i);
        end;
      end;
      if (@BlurProc = NIL) then
      begin
        pd^.r := Round(rs div i * Alpha / 255);
        pd^.g := Round(gs div i * Alpha / 255);
        pd^.b := Round(bs div i * Alpha / 255);
        pd^.a := Alpha div i;
      end else
        pd^.c := BlurProc(rs div i, gs div i, bs div i, Alpha div i, pd^.r, pd^.g, pd^.b, pd^.a).c;
      inc(pd);
    end;
  end;
end;

{ TGdipBitmap }

constructor TGdipBitmap.Create(Width, Height: Integer);
begin
  inherited Create;
  SetStatus(GdipCreateBitmapFromScan0(Width, Height, Width * 4, PixelFormat32bppARGB, NIL, GPBitmap));
  AfterCreate;
end;

constructor TGdipBitmap.Create(Width, Height, Stride: Integer; Format: TPixelFormat; Bits: Pointer);
begin
  inherited Create;
  SetStatus(GdipCreateBitmapFromScan0(Width, Height, Stride, Format, Bits, GPBitmap));
  AfterCreate;
end;

procedure TGdipBitmap.ReCreate(Width, Height: Integer);
begin
  if (FWidth <> Width) or (FHeight <> Height) then
  begin
    SetStatus(GdipDisposeImage(GPBitmap));
    SetStatus(GdipCreateBitmapFromScan0(Width, Height, Width * 4, PixelFormat32bppARGB, NIL, GPBitmap));
    AfterCreate;
  end;
end;

constructor TGdipBitmap.Create(const FileName: String);
begin
  inherited Create;
  SetStatus(GdipCreateBitmapFromFile(PWCHAR(WideString(FileName)), GPBitmap));
  AfterCreate;
end;

constructor TGdipBitmap.Create(Bitmap: GpBitmap);
begin
  inherited Create;
  SetStatus(GdipCloneImage(Bitmap, GPBitmap));
  AfterCreate;
end;

constructor TGdipBitmap.CreateFromBitmap(Bitmap: GpBitmap);
begin
  inherited Create;
  GPBitmap := Bitmap;
  AfterCreate;
end;

constructor TGdipBitmap.Create(Bitmap: TGdipBitmap);
begin
  Create(Bitmap.GPBitmap);
end;

constructor TGdipBitmap.Create(Icon: HICON);
begin
  inherited Create;
  SetStatus(GdipCreateBitmapFromHICON(Icon, GPBitmap));
  AfterCreate;
end;

destructor TGdipBitmap.Destroy;
begin
  SetStatus(GdipDisposeImage(GPBitmap));
  inherited;
end;

procedure TGdipBitmap.Assign(Bitmap: GpBitmap);
begin
  SetStatus(GdipDisposeImage(GPBitmap));
  SetStatus(GdipCloneImage(Bitmap, GPBitmap));
  AfterCreate;
end;

procedure TGdipBitmap.Assign(Bitmap: TGdipBitmap);
begin
  Assign(Bitmap.GPBitmap);
end;

procedure TGdipBitmap.Assign(Bitmap: GpBitmap; Width, Height: Integer);
begin
  SetStatus(GdipDisposeImage(GPBitmap));
  SetStatus(GdipGetImageThumbnail(Bitmap, Width, Height, GPBitmap, NIL, NIL));
  AfterCreate;
end;

procedure TGdipBitmap.Assign(Bitmap: TGdipBitmap; Width, Height: Integer);
begin
  Assign(Bitmap.GPBitmap, Width, Height);
end;

procedure TGdipBitmap.AfterCreate;
var
  v: DWORD;
begin
  FIsLock := False;
  SetStatus(GdipGetImageWidth(GPBitmap, v));
  FWidth := Integer(v);
  SetStatus(GdipGetImageHeight(GPBitmap, v));
  FHeight := Integer(v);
end;

procedure TGdipBitmap.SetStatus(Value: TStatus);
begin
  if (Value <> Ok) then ;
    //RaiseConversionError('Error GDI+');
end;

function TGdipBitmap.GetRect: TRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := FWidth;
  Result.Bottom := FHeight;
end;

procedure TGdipBitmap.LockBits(PixelFormat: TPixelFormat);
var
  R: TGPRect;
begin
  if not FIsLock then
  begin
    R.X := 0;
    R.Y := 0;
    R.Width := FWidth;
    R.Height := FHeight;
    SetStatus(GdipBitmapLockBits(GPBitmap, NIL, ImageLockModeRead or ImageLockModeWrite,
      PixelFormat, @FBitmapData));
    FBits := FBitmapData.Scan0;
    FIsLock := True;
  end;
end;

procedure TGdipBitmap.UnLockBits;
begin
  if FIsLock then
  begin
    SetStatus(GdipBitmapUnlockBits(GPBitmap, @FBitmapData));
    FIsLock := False;
  end;
end;

function TGdipBitmap.GetSize: Integer;
begin
  Result := FWidth * FHeight * 4;
end;

procedure TGdipBitmap.SaveToFile(const FileName: String; Encoder: TGUID);
begin
  SetStatus(GdipSaveImageToFile(GPBitmap, PWCHAR(WideString(FileName)), @Encoder, NIL));
end;

{ TGdipDIB }

constructor TGdipDIB.Create;
begin
  inherited;
  FWidth := 0;
  FHeight := 0;
  FDC := 0;
  FBits := NIL;
  FGPContext := NIL;
  FGPBitmap := NIL;
  FLastStatus := Ok;
  FColorMatrix := _ColorMatrix;

  FBrushColor.c := ARGBMake(255, 0, 0, 0);
  FPenColor.c := ARGBMake(255, 0, 0, 0);
  FPenWidth := 1;
  FAngle := 0;
  FAngleCenter.X := 0;
  FAngleCenter.Y := 0;
  FFontName := 'Tahoma';
  FFontSize := 8;
  FFontStyle := FontStyleRegular;
  FAlpha := 255;
  FContrast := 0;
  FAlignStringHor := StringAlignmentNear;
  FAlignStringVer := StringAlignmentCenter;

  SetStatus(GdipCreateSolidFill(FBrushColor.c, FGPSolidBrush));
  SetStatus(GdipCreatePen1(FPenColor.c, FPenWidth, UnitPixel, FGPPen));
  SetStatus(GdipCreateStringFormat(0, LANG_NEUTRAL, FGPStringFormat));
  SetStatus(GdipCreateFontFamilyFromName(PWCHAR(WideString(FFontName)), NIL, FGPFontFamily));
  SetStatus(GdipCreateFont(FGPFontFamily, FFontSize, FFontStyle, Integer(UnitPoint), FGPFont));
  SetStatus(GdipCreateImageAttributes(FGPImageAttributes));
  SetStatus(GdipCreateMatrix(FGPMatrix));
  SetStatus(GdipSetStringFormatAlign(FGPStringFormat, FAlignStringHor));
  SetStatus(GdipSetStringFormatLineAlign(FGPStringFormat, FAlignStringVer));
end;

constructor TGdipDIB.Create(Width, Height: Integer);
begin
  Create;
  NewDIB(Width, Height);
end;

destructor TGdipDIB.Destroy;
begin
  SetStatus(GdipDeleteFont(FGPFont));
  SetStatus(GdipDeleteFontFamily(FGPFontFamily));
  SetStatus(GdipDeleteBrush(FGPSolidBrush));
  SetStatus(GdipDeletePen(FGPPen));
  SetStatus(GdipDeleteStringFormat(FGPStringFormat));
  SetStatus(GdipDeleteMatrix(FGPMatrix));
  SetStatus(GdipDisposeImageAttributes(FGPImageAttributes));
  FreeDIB;
  inherited;
end;

procedure TGdipDIB.SetStatus(Value: TStatus);
begin
  FLastStatus := Value;
  if (FLastStatus <> Ok) then;
  //  RaiseConversionError('Error GDI+');
end;

procedure TGdipDIB.Assign(DIB: TGdipDIB);
begin
  NewDIB(DIB.FWidth, DIB.FHeight);
  Move(DIB.FBits^, FBits^, GetSize);
end;

procedure TGdipDIB.FreeDIB;
begin
  if (GetSize > 0) then
  begin
    SetStatus(GdipDeleteGraphics(FGPContext));
    SetStatus(GdipDisposeImage(FGPBitmap));
    SelectObject(FDC, FOldBitmap);
    DeleteDC(FDC);
    DeleteObject(FBitmap);
    FWidth := 0;
    FHeight := 0;
    FDC := 0;
    FBits := NIL;
  end;
end;

procedure TGdipDIB.NewDIB(Width, Height: Integer);
begin
  if (FWidth = Width) and (FHeight = Height) then Exit;

  FreeDIB;

  FWidth := Width;
  FHeight := Height;

  with FBitmapInfo.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := FWidth;
    biHeight := FHeight;
    biPlanes := 1;
    biBitCount := 32;
    biCompression := BI_RGB;
    biSizeImage := GetSize;
    biXPelsPerMeter := 0;
    biYPelsPerMeter := 0;
    biClrUsed := 0;
    biClrImportant := 0;
  end;

  FDC := CreateCompatibleDC(0);
  FBitmap := CreateDIBSection(FDC, FBitmapInfo, DIB_RGB_COLORS, FBits, 0, 0);
  FOldBitmap := SelectObject(FDC, FBitmap);

  SetStatus(GdipCreateBitmapFromScan0(FWidth, FHeight, FWidth * 4, PixelFormat32bppARGB, FBits, FGPBitmap));
  SetStatus(GdipCreateFromHDC(FDC, FGPContext));
  SetStatus(GdipSetSmoothingMode(FGPContext, SmoothingModeAntiAlias));
end;

procedure TGdipDIB.SetFont(FontName: String; FontSize: Integer; FontStyle: TFontStyle);
begin
  if (CompareStr(FFontName, FontName) = 0) and (FFontSize = FontSize) and
    (FFontStyle = FontStyle) then Exit;
  FFontName := FontName;
  FFontSize := FontSize;
  FFontStyle := FontStyle;
  if (FGPFontFamily <> NIL) then
  begin
    SetStatus(GdipDeleteFont(FGPFont));
    SetStatus(GdipDeleteFontFamily(FGPFontFamily));
  end;
  SetStatus(GdipCreateFontFamilyFromName(PWCHAR(WideString(FFontName)), NIL, FGPFontFamily));
  SetStatus(GdipCreateFont(FGPFontFamily, FFontSize, FFontStyle, Integer(UnitPoint), FGPFont));
end;

procedure TGdipDIB.SetAlpha(Value: Byte);
begin
  if (FAlpha <> Value) then
  begin
    FAlpha := Value;
    FColorMatrix[3, 3] := FAlpha / 255;
    SetStatus(GdipSetImageAttributesColorMatrix(FGPImageAttributes, ColorAdjustTypeDefault,
      True, @FColorMatrix, NIL, ColorMatrixFlagsDefault));
  end;
end;

procedure TGdipDIB.SetContrast(Value: Single);
begin
  if (FContrast <> Value) then
  begin
    FContrast := Value;
    FColorMatrix[0, 0] := FContrast;
    FColorMatrix[1, 1] := FContrast;
    FColorMatrix[2, 2] := FContrast;
    SetStatus(GdipSetImageAttributesColorMatrix(FGPImageAttributes, ColorAdjustTypeDefault,
      True, @FColorMatrix, NIL, ColorMatrixFlagsDefault));
  end;
end;

procedure TGdipDIB.SetAngle(Value: Single; CenterX, CenterY: Integer);
begin
  if (FAngle = Value) and (FAngleCenter.X = CenterX) and (FAngleCenter.Y = CenterY) then
    Exit;
  FAngle := Value;
  FAngleCenter.X := CenterX;
  FAngleCenter.Y := CenterY;
  SetStatus(GdipResetWorldTransform(FGPContext));
  SetStatus(GdipSetMatrixElements(FGPMatrix, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0));
  if (FAngle > 0) then
  begin
    SetStatus(GdipTranslateMatrix(FGPMatrix, FAngleCenter.X, FAngleCenter.Y, MatrixOrderPrepend));
    SetStatus(GdipRotateMatrix(FGPMatrix, FAngle, MatrixOrderPrepend));
    SetStatus(GdipTranslateMatrix(FGPMatrix, -FAngleCenter.X, -FAngleCenter.Y, MatrixOrderPrepend));
    SetStatus(GdipSetWorldTransform(FGPContext, FGPMatrix));
  end;
end;

procedure TGdipDIB.SetBrush(Color: ARGB);
begin
  if (FBrushColor.c <> Color) then
  begin
    FBrushColor.c := Color;
    SetStatus(GdipSetSolidFillColor(FGPSolidBrush, FBrushColor.c));
  end;
end;

procedure TGdipDIB.SetPen(Color: ARGB; Width: Integer);
begin
  if (FPenColor.c = Color) and (FPenWidth = Width) then
    Exit;
  FPenColor.c := Color;
  FPenWidth := Width;
  SetStatus(GdipSetPenColor(FGPPen, FPenColor.c));
  SetStatus(GdipSetPenWidth(FGPPen, FPenWidth));
end;

procedure TGdipDIB.SetStringAlign(Horizontal, Vertical: TStringAlignment);
begin
  if (FAlignStringHor = Horizontal) and (FAlignStringVer = Vertical) then
    Exit;
  FAlignStringHor := Horizontal;
  FAlignStringVer := Vertical;
  SetStatus(GdipSetStringFormatAlign(FGPStringFormat, FAlignStringHor));
  SetStatus(GdipSetStringFormatLineAlign(FGPStringFormat, FAlignStringVer));
end;

function TGdipDIB.GetRect: TRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := FWidth;
  Result.Bottom := FHeight;
end;

function TGdipDIB.GetPixels(X, Y: Integer): Pointer;
begin
  Result := Pointer(Integer(FBits) + (FWidth * (FHeight - 1 - Y) + X) * 4);
end;

function TGdipDIB.GetSize: Integer;
begin
  Result := FWidth * FHeight * 4;
end;

procedure TGdipDIB.LoadFromFile(FileName: String);
var
  F: TFileStream;
begin
  F := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(F);
  finally
    F.Free;
  end;
end;

procedure TGdipDIB.LoadFromStream(Stream: TStream);
var
  bitFileHeader: TBitmapFileHeader;
  bitInfo: TBitmapInfo;
begin
  Stream.Read(bitFileHeader, SizeOf(TBitmapFileHeader));
  Stream.Read(bitInfo, SizeOf(TBitmapInfo));
  if (bitInfo.bmiHeader.biBitCount <> 32) then Exit;
  NewDIB(bitInfo.bmiHeader.biWidth, bitInfo.bmiHeader.biHeight);
  Stream.Seek(bitFileHeader.bfOffBits, 0);
  Stream.Read(FBits^, GetSize);
end;

procedure TGdipDIB.SaveToFile(FileName: String);
var
  F: TFileStream;
begin
  F := TFileStream.Create(FileName, fmCreate or fmOpenWrite);
  try
    SaveToStream(F);
  finally
    F.Free;
  end;
end;

procedure TGdipDIB.SaveToStream(Stream: TStream);
var
  bitFileHeader: TBitmapFileHeader;
begin
  bitFileHeader.bfType := $4D42;
  bitFileHeader.bfSize := SizeOf(TBitmapFileHeader) + SizeOf(TBitmapInfo) + GetSize;
  bitFileHeader.bfReserved1 := 0;
  bitFileHeader.bfReserved2 := 0;
  bitFileHeader.bfOffBits := SizeOf(TBitmapFileHeader) + SizeOf(TBitmapInfo);

  Stream.Write(bitFileHeader, SizeOf(TBitmapFileHeader));
  Stream.Write(FBitmapInfo, SizeOf(TBitmapInfo));
  Stream.Write(FBits^, GetSize);
end;

procedure TGdipDIB.Fill(ARect: TRect; Color: ARGB);
var
  x, y: Integer;
  p: PARGBArray;
begin
  for y:= ARect.Top to ARect.Bottom - 1 do
  if (y >= 0) and (y < FHeight) then
  begin
    Integer(p) := Integer(FBits) + (FHeight - 1 - y) * 4 * FWidth;
    for x:= ARect.Left to ARect.Right - 1 do
    if (x >= 0) and (x < Width) then
      p[x].c := Color;
  end;
end;

procedure TGdipDIB.Fill(Color: ARGB);
begin
  Fill(GetRect, Color);
end;

procedure TGdipDIB.Fill;
begin
  Fill(GetRect, 0);
end;

procedure TGdipDIB.Premultiply;
var
  i: Integer;
  p: PARGB;
begin
  p := FBits;
  for i:= 1 to FHeight * FWidth do
  begin
    p^.a := 255;
    inc(p);
  end;
end;

procedure TGdipDIB.AlphaBlend(ARect: TRect; Alpha: Byte);
var
  x, y: Integer;
  p: PARGBArray;
begin
  for y:= ARect.Top to ARect.Bottom - 1 do
  begin
    if (y < 0) or (y >= FHeight) then Break;
    Integer(p) := Integer(FBits) + (FHeight - 1 - y) * 4 * FWidth;
    for x:= ARect.Left to ARect.Right - 1 do
    begin
      if (x < 0) or (x >= FWidth) then Break;
      if (p[x].a > 0) then
      begin
        p[x].b := Round(p[x].b * Alpha / p[x].a);
        p[x].g := Round(p[x].g * Alpha / p[x].a);
        p[x].r := Round(p[x].r * Alpha / p[x].a);
        p[x].a := Alpha;
      end;
    end;
  end;
end;

procedure TGdipDIB.AlphaBlend(Alpha: Byte);
begin
  AlphaBlend(GetRect, Alpha);
end;

procedure TGdipDIB.Copy(DestRect: TRect; Src: TGdipDIB; SrcRect: TRect);
var
  x, y: Integer;
  pD, pS: PARGB;
  sD, sS: Integer;
begin
  Integer(pD) := Integer(FBits) + (DestRect.Top * FWidth + DestRect.Left) * 4;
  Integer(pS) := Integer(Src.FBits) + (SrcRect.Top * Src.FWidth + SrcRect.Left) * 4;
  sD := FWidth - DestRect.Right + DestRect.Left;
  sS := Src.FWidth - SrcRect.Right + SrcRect.Left;
  for y:= DestRect.Top to DestRect.Bottom - 1 do
  begin
    if (DestRect.Top >= 0) and (DestRect.Top < FHeight) and
      (SrcRect.Top + y - DestRect.Top >= 0) and (SrcRect.Top + y - DestRect.Top < Src.FHeight) then
    for x:= DestRect.Left to DestRect.Right - 1 do
    begin
      if (DestRect.Left >= 0) and (DestRect.Left < FWidth) and
      (SrcRect.Left + x - DestRect.Left >= 0) and (SrcRect.Left + x - DestRect.Left < Src.FWidth) then
        pD^.c := pS^.c;
      inc(pD);
      inc(pS);
    end;
    inc(pD, sD);
    inc(pS, sS);
  end;
end;

procedure TGdipDIB.DrawString(ARect: TRect; const Text: WideString);
var
  R: TGPRectF;
begin
  R := RectToRectF(ARect);
  SetStatus(GdipDrawString(FGPContext, PWCHAR(Text), Length(Text), FGPFont, @R,
    FGPStringFormat, FGPSolidBrush));
end;

procedure TGdipDIB.DrawTo(DC: HDC; DestRect, SrcRect: TRect);
begin
  StretchBlt(DC, DestRect.Left, DestRect.Top, DestRect.Right - DestRect.Left,
    DestRect.Bottom - DestRect.Top, FDC, SrcRect.Left, SrcRect.Top,
    SrcRect.Right - SrcRect.Left, SrcRect.Bottom - SrcRect.Top, SRCCOPY);
end;

procedure TGdipDIB.Draw(DestRect: TRect; Src: TGdipDIB; SrcRect: TRect);
begin
  SetStatus(GdipDrawImageRectRect(FGPContext, Src.GPBitmap, DestRect.Left,
    DestRect.Top, DestRect.Right - DestRect.Left, DestRect.Bottom - DestRect.Top,
    SrcRect.Left, SrcRect.Top, SrcRect.Right - SrcRect.Left,
    SrcRect.Bottom - SrcRect.Top, UnitPixel, FGPImageAttributes, NIL, NIL));
end;

procedure TGdipDIB.DrawBitmap(DestRect: TRect; Src: GpBitmap; SrcRect: TRect);
begin
  SetStatus(GdipDrawImageRectRect(FGPContext, Src, DestRect.Left, DestRect.Top,
    DestRect.Right - DestRect.Left, DestRect.Bottom - DestRect.Top,
    SrcRect.Left, SrcRect.Top, SrcRect.Right - SrcRect.Left,
    SrcRect.Bottom - SrcRect.Top, UnitPixel, FGPImageAttributes, NIL, NIL));
end;

procedure TGdipDIB.DrawBitmap(DestRect: TRect; Src: TGdipBitmap; SrcRect: TRect);
begin
  DrawBitmap(DestRect, Src.GPBitmap, SrcRect);
end;

function TGdipDIB.TextSize(const Text: WideString): TSize;
var
  R: TGPRectF;
begin
  FillChar(R, SizeOf(R), 0);
  SetStatus(GdipMeasureString(FGPContext, PWCHAR(Text), Length(Text),
    FGPFont, @R, FGPStringFormat, @R, NIL, NIL));
  Result.cx := Round(R.Width);
  Result.cy := Round(R.Height);
end;

function TGdipDIB.TextHeight(const Text: WideString): Integer;
begin
  Result := TextSize(Text).cy;
end;

function TGdipDIB.TextWidth(const Text: WideString): Integer;
begin
  Result := TextSize(Text).cx;
end;

procedure TGdipDIB.FillPath(Src: GpPath);
begin
  SetStatus(GdipFillPath(FGPContext, FGPSolidBrush, Src));
end;

procedure TGdipDIB.DrawPath(Src: GpPath);
begin
  SetStatus(GdipDrawPath(FGPContext, FGPPen, Src));
end;

procedure TGdipDIB.RoundRect(ARect: TRect; Radius: Integer; Fill, Draw: Boolean);
var
  R: Integer;
  Path: GpPath;
begin
  R := Radius shl 1;
  SetStatus(GdipCreatePath(FillModeAlternate, Path));
  SetStatus(GdipAddPathArc(Path, ARect.Left, ARect.Top, R - 1, R - 1, 180, 90));
  SetStatus(GdipAddPathArc(Path, ARect.Left + (ARect.Right - ARect.Left) - R, ARect.Top, R - 1, R - 1, 270, 90));
  SetStatus(GdipAddPathArc(Path, ARect.Left + (ARect.Right - ARect.Left) - R, ARect.Top + (ARect.Bottom - ARect.Top) - R, R - 1, R - 1, 0, 90));
  SetStatus(GdipAddPathArc(Path, ARect.Left, ARect.Top + (ARect.Bottom - ARect.Top) - R, R - 1, R - 1, 90, 90));
  SetStatus(GdipClosePathFigure(Path));
  if Fill then FillPath(Path);
  if Draw then DrawPath(Path);
  SetStatus(GdipDeletePath(Path));
end;

procedure TGdipDIB.DrawMirror(DestX, DestY: Integer; Src: TGdipDIB; SrcX, SrcY,
  Width, Height: Integer; Alpha: Byte);
var
  x, y: Integer;
  pD, pS: PARGB;
begin
  for y:= 0 to Height - 1 do
  begin
    if (DestY + y >= 0) and (DestY + y < FHeight) and
      (SrcY + y >= 0) and (SrcY + y < Src.FHeight) then
    begin
      Integer(pD) := Integer(FBits) + ((FHeight - 1 - DestY - (Height - 1 - y)) * FWidth + DestX) * 4;
      Integer(pS) := Integer(Src.FBits) + ((Src.FHeight - 1 - SrcY - y) * Src.FWidth + SrcX) * 4;
      for x:= 0 to Width - 1 do
      begin
        if (DestX + x >= 0) and (DestX + x < FWidth) and
          (SrcX + x >= 0) and (SrcX + x < Src.FWidth) then
      {  if (pD^.a > 0) then
        begin
          pD^.r := (pD^.r * Alpha + pS^.r * (not pD^.a)) shr 8;
          pD^.g := (pD^.g * Alpha + pS^.g * (not pD^.a)) shr 8;
          pD^.b := (pD^.b * Alpha + pS^.b * (not pD^.a)) shr 8;
        end; }
          pD^.c := pS^.c;
        inc(pD);
        inc(pS);
      end;
    end;
  end;
end;

procedure TGdipDIB.DrawBitmapTile(DestRect: TRect; Src: TGdipBitmap; SrcRect: TRect;
  StrechHeight: Boolean = False);
var
  rt: TRect;
begin
  rt.Top := DestRect.Top;
  if StrechHeight then
    rt.Bottom := DestRect.Bottom
  else
    rt.Bottom := rt.Top + SrcRect.Bottom - SrcRect.Top;
  while (rt.Bottom <= DestRect.Bottom) do
  begin
    rt.Left := DestRect.Left;
    rt.Right := rt.Left + SrcRect.Right - SrcRect.Left;
    while (rt.Right <= DestRect.Right) do
    begin
      DrawBitmap(rt, Src, SrcRect);
      inc(rt.Left, SrcRect.Right - SrcRect.Left);
      inc(rt.Right, SrcRect.Right - SrcRect.Left);
    end;
    if not StrechHeight then
    if (rt.Left < DestRect.Right) then
    begin
      rt.Right := DestRect.Right;
      DrawBitmap(rt, Src, Classes.Rect(SrcRect.Left, SrcRect.Top,
        SrcRect.Left + (rt.Right - rt.Left), SrcRect.Bottom));
    end;
    inc(rt.Top, SrcRect.Bottom - SrcRect.Top);
    inc(rt.Bottom, SrcRect.Bottom - SrcRect.Top);
  end;
  if (rt.Top < DestRect.Bottom) or StrechHeight then
  begin
    rt.Bottom := DestRect.Bottom;
    if StrechHeight then
    begin
      rt.Top := DestRect.Top;
    end else
    begin
      rt.Left := DestRect.Left;
      rt.Right := rt.Left + SrcRect.Right - SrcRect.Left;
    end;
    while (rt.Right <= DestRect.Right) do
    begin
      DrawBitmap(rt, Src, SrcRect);
      inc(rt.Left, SrcRect.Right - SrcRect.Left);
      inc(rt.Right, SrcRect.Right - SrcRect.Left);
    end;
    if (rt.Left < DestRect.Right) then
    begin
      rt.Right := DestRect.Right;
      DrawBitmap(rt, Src, Classes.Rect(SrcRect.Left, SrcRect.Top,
        SrcRect.Left + (rt.Right - rt.Left), SrcRect.Bottom));
    end;
  end;
end;

initialization
  StartupInput.DebugEventCallback := NIL;
  StartupInput.SuppressBackgroundThread := False;
  StartupInput.SuppressExternalCodecs := False;
  StartupInput.GdiplusVersion := 1;
  GdiplusStartup(GDIPlusToken, @StartupInput, NIL);

finalization
  GdiplusShutdown(GDIPlusToken);

end.

