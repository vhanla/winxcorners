      {******************************************************************}
      { GDI+ API                                                         }
      {                                                                  }
      { home page : http://www.progdigy.com                              }
      { email     : hgourvest@progdigy.com                               }
      {                                                                  }
      { date      : 15-02-2002                                           }
      {                                                                  }
      { The contents of this file are used with permission, subject to   }
      { the Mozilla Public License Version 1.1 (the "License"); you may  }
      { not use this file except in compliance with the License. You may }
      { obtain a copy of the License at                                  }
      { http://www.mozilla.org/MPL/MPL-1.1.html                          }
      {                                                                  }
      { Software distributed under the License is distributed on an      }
      { "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
      { implied. See the License for the specific language governing     }
      { rights and limitations under the License.                        }
      {                                                                  }
      { *****************************************************************}

unit GDIPAPI;

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

(**************************************************************************\
*
*   GDI+ public header file
*
\**************************************************************************)

uses
  Windows,
  ActiveX,
  DirectDraw,
  Math;

type
  INT16   = type Smallint;
  UINT16  = type Word;
  PUINT16 = ^UINT16;
  UINT32  = type Cardinal;
  TSingleDynArray = array of Single;

(**************************************************************************\
*
*   GDI+ Private Memory Management APIs
*
\**************************************************************************)

const WINGDIPDLL = 'gdiplus.dll';

//----------------------------------------------------------------------------
// Memory Allocation APIs
//----------------------------------------------------------------------------

{$EXTERNALSYM GdipAlloc}
function GdipAlloc(size: ULONG): pointer; stdcall;
{$EXTERNALSYM GdipFree}
procedure GdipFree(ptr: pointer); stdcall;

(**************************************************************************\
*
*   GDI+ base memory allocation class
*
\**************************************************************************)

type
  TGdiplusBase = class
  public
    class function NewInstance: TObject; override;
    procedure FreeInstance; override;
  end;

(**************************************************************************\
*
*   GDI+ Enumeration Types
*
\**************************************************************************)

//--------------------------------------------------------------------------
// Default bezier flattening tolerance in device pixels.
//--------------------------------------------------------------------------

const
  {$EXTERNALSYM FlatnessDefault}
  FlatnessDefault = 0.25;

//--------------------------------------------------------------------------
// Graphics and Container State cookies
//--------------------------------------------------------------------------
type
  {$EXTERNALSYM GraphicsState}
  GraphicsState     = UINT;
  {$EXTERNALSYM GraphicsContainer}
  GraphicsContainer = UINT;

//--------------------------------------------------------------------------
// Fill mode constants
//--------------------------------------------------------------------------

  {$EXTERNALSYM FillMode}
  FillMode = (
    FillModeAlternate,        // 0
    FillModeWinding           // 1
  );
  TFillMode = FillMode;

//--------------------------------------------------------------------------
// Quality mode constants
//--------------------------------------------------------------------------

{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM QualityMode}
  QualityMode = (
    QualityModeInvalid   = -1,
    QualityModeDefault   =  0,
    QualityModeLow       =  1, // Best performance
    QualityModeHigh      =  2  // Best rendering quality
  );
  TQualityMode = QualityMode;
{$ELSE}
  {$EXTERNALSYM QualityMode}
  QualityMode = Integer;
  const
    QualityModeInvalid   = -1;
    QualityModeDefault   =  0;
    QualityModeLow       =  1; // Best performance
    QualityModeHigh      =  2; // Best rendering quality
{$ENDIF}

//--------------------------------------------------------------------------
// Alpha Compositing mode constants
//--------------------------------------------------------------------------
type
  {$EXTERNALSYM CompositingMode}
  CompositingMode = (
    CompositingModeSourceOver,    // 0
    CompositingModeSourceCopy     // 1
  );
  TCompositingMode = CompositingMode;

//--------------------------------------------------------------------------
// Alpha Compositing quality constants
//--------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM CompositingQuality}
  CompositingQuality = (
    CompositingQualityInvalid          = ord(QualityModeInvalid),
    CompositingQualityDefault          = ord(QualityModeDefault),
    CompositingQualityHighSpeed        = ord(QualityModeLow),
    CompositingQualityHighQuality      = ord(QualityModeHigh),
    CompositingQualityGammaCorrected,
    CompositingQualityAssumeLinear
  );
  TCompositingQuality = CompositingQuality;
{$ELSE}
  {$EXTERNALSYM CompositingQuality}
  CompositingQuality = Integer;
  const
    CompositingQualityInvalid          = QualityModeInvalid;
    CompositingQualityDefault          = QualityModeDefault;
    CompositingQualityHighSpeed        = QualityModeLow;
    CompositingQualityHighQuality      = QualityModeHigh;
    CompositingQualityGammaCorrected   = 3;
    CompositingQualityAssumeLinear     = 4;

type
  TCompositingQuality = CompositingQuality;
{$ENDIF}

//--------------------------------------------------------------------------
// Unit constants
//--------------------------------------------------------------------------

 // {$EXTERNALSYM Unit}
  Unit_ = (
    UnitWorld,      // 0 -- World coordinate (non-physical unit)
    UnitDisplay,    // 1 -- Variable -- for PageTransform only
    UnitPixel,      // 2 -- Each unit is one device pixel.
    UnitPoint,      // 3 -- Each unit is a printer's point, or 1/72 inch.
    UnitInch,       // 4 -- Each unit is 1 inch.
    UnitDocument,   // 5 -- Each unit is 1/300 inch.
    UnitMillimeter  // 6 -- Each unit is 1 millimeter.
  );
  TUnit = Unit_;

//--------------------------------------------------------------------------
// MetafileFrameUnit
//
// The frameRect for creating a metafile can be specified in any of these
// units.  There is an extra frame unit value (MetafileFrameUnitGdi) so
// that units can be supplied in the same units that GDI expects for
// frame rects -- these units are in .01 (1/100ths) millimeter units
// as defined by GDI.
//--------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM MetafileFrameUnit}
  MetafileFrameUnit = (
    MetafileFrameUnitPixel      = ord(UnitPixel),
    MetafileFrameUnitPoint      = ord(UnitPoint),
    MetafileFrameUnitInch       = ord(UnitInch),
    MetafileFrameUnitDocument   = ord(UnitDocument),
    MetafileFrameUnitMillimeter = ord(UnitMillimeter),
    MetafileFrameUnitGdi        // GDI compatible .01 MM units
  );
  TMetafileFrameUnit = MetafileFrameUnit;
{$ELSE}
  {$EXTERNALSYM MetafileFrameUnit}
  MetafileFrameUnit = Integer;
  const
    MetafileFrameUnitPixel      = 2;
    MetafileFrameUnitPoint      = 3;
    MetafileFrameUnitInch       = 4;
    MetafileFrameUnitDocument   = 5;
    MetafileFrameUnitMillimeter = 6;
    MetafileFrameUnitGdi        = 7; // GDI compatible .01 MM units

type
  TMetafileFrameUnit = MetafileFrameUnit;
{$ENDIF}
//--------------------------------------------------------------------------
// Coordinate space identifiers
//--------------------------------------------------------------------------

  {$EXTERNALSYM CoordinateSpace}
  CoordinateSpace = (
    CoordinateSpaceWorld,     // 0
    CoordinateSpacePage,      // 1
    CoordinateSpaceDevice     // 2
  );
  TCoordinateSpace = CoordinateSpace;

//--------------------------------------------------------------------------
// Various wrap modes for brushes
//--------------------------------------------------------------------------

  {$EXTERNALSYM WrapMode}
  WrapMode = (
    WrapModeTile,        // 0
    WrapModeTileFlipX,   // 1
    WrapModeTileFlipY,   // 2
    WrapModeTileFlipXY,  // 3
    WrapModeClamp        // 4
  );
  TWrapMode = WrapMode;

//--------------------------------------------------------------------------
// Various hatch styles
//--------------------------------------------------------------------------

  {$EXTERNALSYM HatchStyle}
  HatchStyle = (
    HatchStyleHorizontal,                  // = 0,
    HatchStyleVertical,                    // = 1,
    HatchStyleForwardDiagonal,             // = 2,
    HatchStyleBackwardDiagonal,            // = 3,
    HatchStyleCross,                       // = 4,
    HatchStyleDiagonalCross,               // = 5,
    HatchStyle05Percent,                   // = 6,
    HatchStyle10Percent,                   // = 7,
    HatchStyle20Percent,                   // = 8,
    HatchStyle25Percent,                   // = 9,
    HatchStyle30Percent,                   // = 10,
    HatchStyle40Percent,                   // = 11,
    HatchStyle50Percent,                   // = 12,
    HatchStyle60Percent,                   // = 13,
    HatchStyle70Percent,                   // = 14,
    HatchStyle75Percent,                   // = 15,
    HatchStyle80Percent,                   // = 16,
    HatchStyle90Percent,                   // = 17,
    HatchStyleLightDownwardDiagonal,       // = 18,
    HatchStyleLightUpwardDiagonal,         // = 19,
    HatchStyleDarkDownwardDiagonal,        // = 20,
    HatchStyleDarkUpwardDiagonal,          // = 21,
    HatchStyleWideDownwardDiagonal,        // = 22,
    HatchStyleWideUpwardDiagonal,          // = 23,
    HatchStyleLightVertical,               // = 24,
    HatchStyleLightHorizontal,             // = 25,
    HatchStyleNarrowVertical,              // = 26,
    HatchStyleNarrowHorizontal,            // = 27,
    HatchStyleDarkVertical,                // = 28,
    HatchStyleDarkHorizontal,              // = 29,
    HatchStyleDashedDownwardDiagonal,      // = 30,
    HatchStyleDashedUpwardDiagonal,        // = 31,
    HatchStyleDashedHorizontal,            // = 32,
    HatchStyleDashedVertical,              // = 33,
    HatchStyleSmallConfetti,               // = 34,
    HatchStyleLargeConfetti,               // = 35,
    HatchStyleZigZag,                      // = 36,
    HatchStyleWave,                        // = 37,
    HatchStyleDiagonalBrick,               // = 38,
    HatchStyleHorizontalBrick,             // = 39,
    HatchStyleWeave,                       // = 40,
    HatchStylePlaid,                       // = 41,
    HatchStyleDivot,                       // = 42,
    HatchStyleDottedGrid,                  // = 43,
    HatchStyleDottedDiamond,               // = 44,
    HatchStyleShingle,                     // = 45,
    HatchStyleTrellis,                     // = 46,
    HatchStyleSphere,                      // = 47,
    HatchStyleSmallGrid,                   // = 48,
    HatchStyleSmallCheckerBoard,           // = 49,
    HatchStyleLargeCheckerBoard,           // = 50,
    HatchStyleOutlinedDiamond,             // = 51,
    HatchStyleSolidDiamond,                // = 52,

    HatchStyleTotal                        // = 53,
  );

  const
    HatchStyleLargeGrid = HatchStyleCross; // 4
    HatchStyleMin       = HatchStyleHorizontal;
    HatchStyleMax       = HatchStyleSolidDiamond;

type
  THatchStyle = HatchStyle;

//--------------------------------------------------------------------------
// Dash style constants
//--------------------------------------------------------------------------

  {$EXTERNALSYM DashStyle}
  DashStyle = (
    DashStyleSolid,          // 0
    DashStyleDash,           // 1
    DashStyleDot,            // 2
    DashStyleDashDot,        // 3
    DashStyleDashDotDot,     // 4
    DashStyleCustom          // 5
  );
  TDashStyle = DashStyle;

//--------------------------------------------------------------------------
// Dash cap constants
//--------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM DashCap}
  DashCap = (
    DashCapFlat             = 0,
    DashCapRound            = 2,
    DashCapTriangle         = 3
  );
  TDashCap = DashCap;
{$ELSE}
  {$EXTERNALSYM DashCap}
  DashCap = Integer;
  const
    DashCapFlat             = 0;
    DashCapRound            = 2;
    DashCapTriangle         = 3;

type
  TDashCap = DashCap;
{$ENDIF}

//--------------------------------------------------------------------------
// Line cap constants (only the lowest 8 bits are used).
//--------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM LineCap}
  LineCap = (
    LineCapFlat             = 0,
    LineCapSquare           = 1,
    LineCapRound            = 2,
    LineCapTriangle         = 3,

    LineCapNoAnchor         = $10, // corresponds to flat cap
    LineCapSquareAnchor     = $11, // corresponds to square cap
    LineCapRoundAnchor      = $12, // corresponds to round cap
    LineCapDiamondAnchor    = $13, // corresponds to triangle cap
    LineCapArrowAnchor      = $14, // no correspondence

    LineCapCustom           = $ff, // custom cap

    LineCapAnchorMask       = $f0  // mask to check for anchor or not.
  );
  TLineCap = LineCap;
{$ELSE}
  {$EXTERNALSYM LineCap}
  LineCap = Integer;
  const
    LineCapFlat             = 0;
    LineCapSquare           = 1;
    LineCapRound            = 2;
    LineCapTriangle         = 3;

    LineCapNoAnchor         = $10; // corresponds to flat cap
    LineCapSquareAnchor     = $11; // corresponds to square cap
    LineCapRoundAnchor      = $12; // corresponds to round cap
    LineCapDiamondAnchor    = $13; // corresponds to triangle cap
    LineCapArrowAnchor      = $14; // no correspondence

    LineCapCustom           = $ff; // custom cap

    LineCapAnchorMask       = $f0; // mask to check for anchor or not.

type
  TLineCap = LineCap;
{$ENDIF}

//--------------------------------------------------------------------------
// Custom Line cap type constants
//--------------------------------------------------------------------------

  {$EXTERNALSYM CustomLineCapType}
  CustomLineCapType = (
    CustomLineCapTypeDefault,
    CustomLineCapTypeAdjustableArrow
  );
  TCustomLineCapType = CustomLineCapType;

//--------------------------------------------------------------------------
// Line join constants
//--------------------------------------------------------------------------

  {$EXTERNALSYM LineJoin}
  LineJoin = (
    LineJoinMiter,
    LineJoinBevel,
    LineJoinRound,
    LineJoinMiterClipped
  );
  TLineJoin = LineJoin;

//--------------------------------------------------------------------------
// Path point types (only the lowest 8 bits are used.)
//  The lowest 3 bits are interpreted as point type
//  The higher 5 bits are reserved for flags.
//--------------------------------------------------------------------------

{$IFDEF DELPHI6_UP}
  {$Z1}
  {$EXTERNALSYM PathPointType}
  PathPointType = (
    PathPointTypeStart           = $00, // move
    PathPointTypeLine            = $01, // line
    PathPointTypeBezier          = $03, // default Bezier (= cubic Bezier)
    PathPointTypePathTypeMask    = $07, // type mask (lowest 3 bits).
    PathPointTypeDashMode        = $10, // currently in dash mode.
    PathPointTypePathMarker      = $20, // a marker for the path.
    PathPointTypeCloseSubpath    = $80, // closed flag

    // Path types used for advanced path.
    PathPointTypeBezier3         = $03  // cubic Bezier
  );
  TPathPointType = PathPointType;
  {$Z4}
{$ELSE}
  {$EXTERNALSYM PathPointType}
  PathPointType = Byte;
  const
    PathPointTypeStart          : Byte = $00; // move
    PathPointTypeLine           : Byte = $01; // line
    PathPointTypeBezier         : Byte = $03; // default Bezier (= cubic Bezier)
    PathPointTypePathTypeMask   : Byte = $07; // type mask (lowest 3 bits).
    PathPointTypeDashMode       : Byte = $10; // currently in dash mode.
    PathPointTypePathMarker     : Byte = $20; // a marker for the path.
    PathPointTypeCloseSubpath   : Byte = $80; // closed flag

    // Path types used for advanced path.
    PathPointTypeBezier3        : Byte = $03;  // cubic Bezier

type
  TPathPointType = PathPointType;
{$ENDIF}

//--------------------------------------------------------------------------
// WarpMode constants
//--------------------------------------------------------------------------

  {$EXTERNALSYM WarpMode}
  WarpMode = (
    WarpModePerspective,    // 0
    WarpModeBilinear        // 1
  );
  TWarpMode = WarpMode;

//--------------------------------------------------------------------------
// LineGradient Mode
//--------------------------------------------------------------------------

  {$EXTERNALSYM LinearGradientMode}
  LinearGradientMode = (
    LinearGradientModeHorizontal,         // 0
    LinearGradientModeVertical,           // 1
    LinearGradientModeForwardDiagonal,    // 2
    LinearGradientModeBackwardDiagonal    // 3
  );
  TLinearGradientMode = LinearGradientMode;

//--------------------------------------------------------------------------
// Region Comine Modes
//--------------------------------------------------------------------------

  {$EXTERNALSYM CombineMode}
  CombineMode = (
    CombineModeReplace,     // 0
    CombineModeIntersect,   // 1
    CombineModeUnion,       // 2
    CombineModeXor,         // 3
    CombineModeExclude,     // 4
    CombineModeComplement   // 5 (Exclude From)
  );
  TCombineMode = CombineMode;

//--------------------------------------------------------------------------
 // Image types
//--------------------------------------------------------------------------

  {$EXTERNALSYM ImageType}
  ImageType = (
    ImageTypeUnknown,   // 0
    ImageTypeBitmap,    // 1
    ImageTypeMetafile   // 2
  );
  TImageType = ImageType;

//--------------------------------------------------------------------------
// Interpolation modes
//--------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM InterpolationMode}
  InterpolationMode = (
    InterpolationModeInvalid          = ord(QualityModeInvalid),
    InterpolationModeDefault          = ord(QualityModeDefault),
    InterpolationModeLowQuality       = ord(QualityModeLow),
    InterpolationModeHighQuality      = ord(QualityModeHigh),
    InterpolationModeBilinear,
    InterpolationModeBicubic,
    InterpolationModeNearestNeighbor,
    InterpolationModeHighQualityBilinear,
    InterpolationModeHighQualityBicubic
  );
  TInterpolationMode = InterpolationMode;
{$ELSE}
  {$EXTERNALSYM InterpolationMode}
  InterpolationMode = Integer;
  const
    InterpolationModeInvalid             = QualityModeInvalid;
    InterpolationModeDefault             = QualityModeDefault;
    InterpolationModeLowQuality          = QualityModeLow;
    InterpolationModeHighQuality         = QualityModeHigh;
    InterpolationModeBilinear            = 3;
    InterpolationModeBicubic             = 4;
    InterpolationModeNearestNeighbor     = 5;
    InterpolationModeHighQualityBilinear = 6;
    InterpolationModeHighQualityBicubic  = 7;

type
  TInterpolationMode = InterpolationMode;
{$ENDIF}

//--------------------------------------------------------------------------
// Pen types
//--------------------------------------------------------------------------

  {$EXTERNALSYM PenAlignment}
  PenAlignment = (
    PenAlignmentCenter,
    PenAlignmentInset
  );
  TPenAlignment = PenAlignment;

//--------------------------------------------------------------------------
// Brush types
//--------------------------------------------------------------------------

  {$EXTERNALSYM BrushType}
  BrushType = (
   BrushTypeSolidColor,
   BrushTypeHatchFill,
   BrushTypeTextureFill,
   BrushTypePathGradient,
   BrushTypeLinearGradient 
  );
  TBrushType = BrushType;

//--------------------------------------------------------------------------
// Pen's Fill types
//--------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM PenType}
  PenType = (
   PenTypeSolidColor       =  ord(BrushTypeSolidColor),
   PenTypeHatchFill        =  ord(BrushTypeHatchFill),
   PenTypeTextureFill      =  ord(BrushTypeTextureFill),
   PenTypePathGradient     =  ord(BrushTypePathGradient),
   PenTypeLinearGradient   =  ord(BrushTypeLinearGradient),
   PenTypeUnknown          = -1
  );
  TPenType = PenType;
{$ELSE}
  {$EXTERNALSYM PenType}
  PenType = Integer;
  const
    PenTypeSolidColor       =  0;
    PenTypeHatchFill        =  1;
    PenTypeTextureFill      =  2;
    PenTypePathGradient     =  3;
    PenTypeLinearGradient   =  4;
    PenTypeUnknown          = -1;

type
  TPenType = PenType;
{$ENDIF}

//--------------------------------------------------------------------------
// Matrix Order
//--------------------------------------------------------------------------

  {$EXTERNALSYM MatrixOrder}
  MatrixOrder = (
    MatrixOrderPrepend,
    MatrixOrderAppend
  );
  TMatrixOrder = MatrixOrder;

//--------------------------------------------------------------------------
// Generic font families
//--------------------------------------------------------------------------

  {$EXTERNALSYM GenericFontFamily}
  GenericFontFamily = (
    GenericFontFamilySerif,
    GenericFontFamilySansSerif,
    GenericFontFamilyMonospace
  );
  TGenericFontFamily = GenericFontFamily;

//--------------------------------------------------------------------------
// FontStyle: face types and common styles
//--------------------------------------------------------------------------
type
  {$EXTERNALSYM FontStyle}
  FontStyle = Integer;
  const
    FontStyleRegular    = Integer(0);
    FontStyleBold       = Integer(1);
    FontStyleItalic     = Integer(2);
    FontStyleBoldItalic = Integer(3);
    FontStyleUnderline  = Integer(4);
    FontStyleStrikeout  = Integer(8);
  Type
  TFontStyle = FontStyle;

//---------------------------------------------------------------------------
// Smoothing Mode
//---------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM SmoothingMode}
  SmoothingMode = (
    SmoothingModeInvalid     = ord(QualityModeInvalid),
    SmoothingModeDefault     = ord(QualityModeDefault),
    SmoothingModeHighSpeed   = ord(QualityModeLow),
    SmoothingModeHighQuality = ord(QualityModeHigh),
    SmoothingModeNone,
    SmoothingModeAntiAlias
  );
  TSmoothingMode = SmoothingMode;
{$ELSE}
  {$EXTERNALSYM SmoothingMode}
  SmoothingMode = Integer;
  const
    SmoothingModeInvalid     = QualityModeInvalid;
    SmoothingModeDefault     = QualityModeDefault;
    SmoothingModeHighSpeed   = QualityModeLow;
    SmoothingModeHighQuality = QualityModeHigh;
    SmoothingModeNone        = 3;
    SmoothingModeAntiAlias   = 4;

type
  TSmoothingMode = SmoothingMode;
{$ENDIF}

//---------------------------------------------------------------------------
// Pixel Format Mode
//---------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM PixelOffsetMode}
  PixelOffsetMode = (
    PixelOffsetModeInvalid     = Ord(QualityModeInvalid),
    PixelOffsetModeDefault     = Ord(QualityModeDefault),
    PixelOffsetModeHighSpeed   = Ord(QualityModeLow),
    PixelOffsetModeHighQuality = Ord(QualityModeHigh),
    PixelOffsetModeNone,    // No pixel offset
    PixelOffsetModeHalf     // Offset by -0.5, -0.5 for fast anti-alias perf
  );
  TPixelOffsetMode = PixelOffsetMode;
{$ELSE}
  {$EXTERNALSYM PixelOffsetMode}
  PixelOffsetMode = Integer;
  const
    PixelOffsetModeInvalid     = QualityModeInvalid;
    PixelOffsetModeDefault     = QualityModeDefault;
    PixelOffsetModeHighSpeed   = QualityModeLow;
    PixelOffsetModeHighQuality = QualityModeHigh;
    PixelOffsetModeNone        = 3;    // No pixel offset
    PixelOffsetModeHalf        = 4;    // Offset by -0.5, -0.5 for fast anti-alias perf

type
  TPixelOffsetMode = PixelOffsetMode;
{$ENDIF}

//---------------------------------------------------------------------------
// Text Rendering Hint
//---------------------------------------------------------------------------

  {$EXTERNALSYM TextRenderingHint}
  TextRenderingHint = (
    TextRenderingHintSystemDefault,                // Glyph with system default rendering hint
    TextRenderingHintSingleBitPerPixelGridFit,     // Glyph bitmap with hinting
    TextRenderingHintSingleBitPerPixel,            // Glyph bitmap without hinting
    TextRenderingHintAntiAliasGridFit,             // Glyph anti-alias bitmap with hinting
    TextRenderingHintAntiAlias,                    // Glyph anti-alias bitmap without hinting
    TextRenderingHintClearTypeGridFit              // Glyph CT bitmap with hinting
  );
  TTextRenderingHint = TextRenderingHint;

//---------------------------------------------------------------------------
// Metafile Types
//---------------------------------------------------------------------------

  {$EXTERNALSYM MetafileType}
  MetafileType = (
    MetafileTypeInvalid,            // Invalid metafile
    MetafileTypeWmf,                // Standard WMF
    MetafileTypeWmfPlaceable,       // Placeable WMF
    MetafileTypeEmf,                // EMF (not EMF+)
    MetafileTypeEmfPlusOnly,        // EMF+ without dual, down-level records
    MetafileTypeEmfPlusDual         // EMF+ with dual, down-level records
  );
  TMetafileType = MetafileType;

//---------------------------------------------------------------------------
// Specifies the type of EMF to record
//---------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM EmfType}
  EmfType = (
    EmfTypeEmfOnly     = Ord(MetafileTypeEmf),          // no EMF+, only EMF
    EmfTypeEmfPlusOnly = Ord(MetafileTypeEmfPlusOnly),  // no EMF, only EMF+
    EmfTypeEmfPlusDual = Ord(MetafileTypeEmfPlusDual)   // both EMF+ and EMF
  );
  TEmfType = EmfType;
{$ELSE}
  {$EXTERNALSYM EmfType}
  EmfType = Integer;
  const
    EmfTypeEmfOnly     = Ord(MetafileTypeEmf);          // no EMF+, only EMF
    EmfTypeEmfPlusOnly = Ord(MetafileTypeEmfPlusOnly);  // no EMF, only EMF+
    EmfTypeEmfPlusDual = Ord(MetafileTypeEmfPlusDual);   // both EMF+ and EMF

type
  TEmfType = EmfType;
{$ENDIF}

//---------------------------------------------------------------------------
// EMF+ Persistent object types
//---------------------------------------------------------------------------

  {$EXTERNALSYM ObjectType}
  ObjectType = (
    ObjectTypeInvalid,
    ObjectTypeBrush,
    ObjectTypePen,
    ObjectTypePath,
    ObjectTypeRegion,
    ObjectTypeImage,
    ObjectTypeFont,
    ObjectTypeStringFormat,
    ObjectTypeImageAttributes,
    ObjectTypeCustomLineCap
  );
  TObjectType = ObjectType;

const
  ObjectTypeMax = ObjectTypeCustomLineCap;
  ObjectTypeMin = ObjectTypeBrush;

function ObjectTypeIsValid(type_: ObjectType): BOOL;

//---------------------------------------------------------------------------
// EMF+ Records
//---------------------------------------------------------------------------

  // We have to change the WMF record numbers so that they don't conflict with
  // the EMF and EMF+ record numbers.

const
  GDIP_EMFPLUS_RECORD_BASE      = $00004000;
  {$EXTERNALSYM GDIP_EMFPLUS_RECORD_BASE}
  GDIP_WMF_RECORD_BASE          = $00010000;
  {$EXTERNALSYM GDIP_WMF_RECORD_BASE}

// macros
function GDIP_WMF_RECORD_TO_EMFPLUS(n: integer): Integer;
function GDIP_EMFPLUS_RECORD_TO_WMF(n: integer): Integer;
function GDIP_IS_WMF_RECORDTYPE(n: integer): BOOL;


{$IFDEF DELPHI6_UP}
type
  {$EXTERNALSYM EmfPlusRecordType}
  EmfPlusRecordType = (
   // Since we have to enumerate GDI records right along with GDI+ records,
   // We list all the GDI records here so that they can be part of the
   // same enumeration type which is used in the enumeration callback.

    WmfRecordTypeSetBkColor              = (META_SETBKCOLOR or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetBkMode               = (META_SETBKMODE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetMapMode              = (META_SETMAPMODE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetROP2                 = (META_SETROP2 or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetRelAbs               = (META_SETRELABS or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetPolyFillMode         = (META_SETPOLYFILLMODE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetStretchBltMode       = (META_SETSTRETCHBLTMODE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetTextCharExtra        = (META_SETTEXTCHAREXTRA or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetTextColor            = (META_SETTEXTCOLOR or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetTextJustification    = (META_SETTEXTJUSTIFICATION or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetWindowOrg            = (META_SETWINDOWORG or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetWindowExt            = (META_SETWINDOWEXT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetViewportOrg          = (META_SETVIEWPORTORG or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetViewportExt          = (META_SETVIEWPORTEXT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeOffsetWindowOrg         = (META_OFFSETWINDOWORG or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeScaleWindowExt          = (META_SCALEWINDOWEXT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeOffsetViewportOrg       = (META_OFFSETVIEWPORTORG or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeScaleViewportExt        = (META_SCALEVIEWPORTEXT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeLineTo                  = (META_LINETO or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeMoveTo                  = (META_MOVETO or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeExcludeClipRect         = (META_EXCLUDECLIPRECT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeIntersectClipRect       = (META_INTERSECTCLIPRECT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeArc                     = (META_ARC or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeEllipse                 = (META_ELLIPSE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeFloodFill               = (META_FLOODFILL or GDIP_WMF_RECORD_BASE),
    WmfRecordTypePie                     = (META_PIE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeRectangle               = (META_RECTANGLE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeRoundRect               = (META_ROUNDRECT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypePatBlt                  = (META_PATBLT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSaveDC                  = (META_SAVEDC or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetPixel                = (META_SETPIXEL or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeOffsetClipRgn           = (META_OFFSETCLIPRGN or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeTextOut                 = (META_TEXTOUT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeBitBlt                  = (META_BITBLT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeStretchBlt              = (META_STRETCHBLT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypePolygon                 = (META_POLYGON or GDIP_WMF_RECORD_BASE),
    WmfRecordTypePolyline                = (META_POLYLINE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeEscape                  = (META_ESCAPE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeRestoreDC               = (META_RESTOREDC or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeFillRegion              = (META_FILLREGION or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeFrameRegion             = (META_FRAMEREGION or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeInvertRegion            = (META_INVERTREGION or GDIP_WMF_RECORD_BASE),
    WmfRecordTypePaintRegion             = (META_PAINTREGION or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSelectClipRegion        = (META_SELECTCLIPREGION or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSelectObject            = (META_SELECTOBJECT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetTextAlign            = (META_SETTEXTALIGN or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeDrawText                = ($062F or GDIP_WMF_RECORD_BASE),  // META_DRAWTEXT
    WmfRecordTypeChord                   = (META_CHORD or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetMapperFlags          = (META_SETMAPPERFLAGS or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeExtTextOut              = (META_EXTTEXTOUT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetDIBToDev             = (META_SETDIBTODEV or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSelectPalette           = (META_SELECTPALETTE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeRealizePalette          = (META_REALIZEPALETTE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeAnimatePalette          = (META_ANIMATEPALETTE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetPalEntries           = (META_SETPALENTRIES or GDIP_WMF_RECORD_BASE),
    WmfRecordTypePolyPolygon             = (META_POLYPOLYGON or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeResizePalette           = (META_RESIZEPALETTE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeDIBBitBlt               = (META_DIBBITBLT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeDIBStretchBlt           = (META_DIBSTRETCHBLT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeDIBCreatePatternBrush   = (META_DIBCREATEPATTERNBRUSH or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeStretchDIB              = (META_STRETCHDIB or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeExtFloodFill            = (META_EXTFLOODFILL or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeSetLayout               = ($0149 or GDIP_WMF_RECORD_BASE),  // META_SETLAYOUT
    WmfRecordTypeResetDC                 = ($014C or GDIP_WMF_RECORD_BASE),  // META_RESETDC
    WmfRecordTypeStartDoc                = ($014D or GDIP_WMF_RECORD_BASE),  // META_STARTDOC
    WmfRecordTypeStartPage               = ($004F or GDIP_WMF_RECORD_BASE),  // META_STARTPAGE
    WmfRecordTypeEndPage                 = ($0050 or GDIP_WMF_RECORD_BASE),  // META_ENDPAGE
    WmfRecordTypeAbortDoc                = ($0052 or GDIP_WMF_RECORD_BASE),  // META_ABORTDOC
    WmfRecordTypeEndDoc                  = ($005E or GDIP_WMF_RECORD_BASE),  // META_ENDDOC
    WmfRecordTypeDeleteObject            = (META_DELETEOBJECT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeCreatePalette           = (META_CREATEPALETTE or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeCreateBrush             = ($00F8 or GDIP_WMF_RECORD_BASE),  // META_CREATEBRUSH
    WmfRecordTypeCreatePatternBrush      = (META_CREATEPATTERNBRUSH or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeCreatePenIndirect       = (META_CREATEPENINDIRECT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeCreateFontIndirect      = (META_CREATEFONTINDIRECT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeCreateBrushIndirect     = (META_CREATEBRUSHINDIRECT or GDIP_WMF_RECORD_BASE),
    WmfRecordTypeCreateBitmapIndirect    = ($02FD or GDIP_WMF_RECORD_BASE),  // META_CREATEBITMAPINDIRECT
    WmfRecordTypeCreateBitmap            = ($06FE or GDIP_WMF_RECORD_BASE),  // META_CREATEBITMAP
    WmfRecordTypeCreateRegion            = (META_CREATEREGION or GDIP_WMF_RECORD_BASE),

    EmfRecordTypeHeader                  = EMR_HEADER,
    EmfRecordTypePolyBezier              = EMR_POLYBEZIER,
    EmfRecordTypePolygon                 = EMR_POLYGON,
    EmfRecordTypePolyline                = EMR_POLYLINE,
    EmfRecordTypePolyBezierTo            = EMR_POLYBEZIERTO,
    EmfRecordTypePolyLineTo              = EMR_POLYLINETO,
    EmfRecordTypePolyPolyline            = EMR_POLYPOLYLINE,
    EmfRecordTypePolyPolygon             = EMR_POLYPOLYGON,
    EmfRecordTypeSetWindowExtEx          = EMR_SETWINDOWEXTEX,
    EmfRecordTypeSetWindowOrgEx          = EMR_SETWINDOWORGEX,
    EmfRecordTypeSetViewportExtEx        = EMR_SETVIEWPORTEXTEX,
    EmfRecordTypeSetViewportOrgEx        = EMR_SETVIEWPORTORGEX,
    EmfRecordTypeSetBrushOrgEx           = EMR_SETBRUSHORGEX,
    EmfRecordTypeEOF                     = EMR_EOF,
    EmfRecordTypeSetPixelV               = EMR_SETPIXELV,
    EmfRecordTypeSetMapperFlags          = EMR_SETMAPPERFLAGS,
    EmfRecordTypeSetMapMode              = EMR_SETMAPMODE,
    EmfRecordTypeSetBkMode               = EMR_SETBKMODE,
    EmfRecordTypeSetPolyFillMode         = EMR_SETPOLYFILLMODE,
    EmfRecordTypeSetROP2                 = EMR_SETROP2,
    EmfRecordTypeSetStretchBltMode       = EMR_SETSTRETCHBLTMODE,
    EmfRecordTypeSetTextAlign            = EMR_SETTEXTALIGN,
    EmfRecordTypeSetColorAdjustment      = EMR_SETCOLORADJUSTMENT,
    EmfRecordTypeSetTextColor            = EMR_SETTEXTCOLOR,
    EmfRecordTypeSetBkColor              = EMR_SETBKCOLOR,
    EmfRecordTypeOffsetClipRgn           = EMR_OFFSETCLIPRGN,
    EmfRecordTypeMoveToEx                = EMR_MOVETOEX,
    EmfRecordTypeSetMetaRgn              = EMR_SETMETARGN,
    EmfRecordTypeExcludeClipRect         = EMR_EXCLUDECLIPRECT,
    EmfRecordTypeIntersectClipRect       = EMR_INTERSECTCLIPRECT,
    EmfRecordTypeScaleViewportExtEx      = EMR_SCALEVIEWPORTEXTEX,
    EmfRecordTypeScaleWindowExtEx        = EMR_SCALEWINDOWEXTEX,
    EmfRecordTypeSaveDC                  = EMR_SAVEDC,
    EmfRecordTypeRestoreDC               = EMR_RESTOREDC,
    EmfRecordTypeSetWorldTransform       = EMR_SETWORLDTRANSFORM,
    EmfRecordTypeModifyWorldTransform    = EMR_MODIFYWORLDTRANSFORM,
    EmfRecordTypeSelectObject            = EMR_SELECTOBJECT,
    EmfRecordTypeCreatePen               = EMR_CREATEPEN,
    EmfRecordTypeCreateBrushIndirect     = EMR_CREATEBRUSHINDIRECT,
    EmfRecordTypeDeleteObject            = EMR_DELETEOBJECT,
    EmfRecordTypeAngleArc                = EMR_ANGLEARC,
    EmfRecordTypeEllipse                 = EMR_ELLIPSE,
    EmfRecordTypeRectangle               = EMR_RECTANGLE,
    EmfRecordTypeRoundRect               = EMR_ROUNDRECT,
    EmfRecordTypeArc                     = EMR_ARC,
    EmfRecordTypeChord                   = EMR_CHORD,
    EmfRecordTypePie                     = EMR_PIE,
    EmfRecordTypeSelectPalette           = EMR_SELECTPALETTE,
    EmfRecordTypeCreatePalette           = EMR_CREATEPALETTE,
    EmfRecordTypeSetPaletteEntries       = EMR_SETPALETTEENTRIES,
    EmfRecordTypeResizePalette           = EMR_RESIZEPALETTE,
    EmfRecordTypeRealizePalette          = EMR_REALIZEPALETTE,
    EmfRecordTypeExtFloodFill            = EMR_EXTFLOODFILL,
    EmfRecordTypeLineTo                  = EMR_LINETO,
    EmfRecordTypeArcTo                   = EMR_ARCTO,
    EmfRecordTypePolyDraw                = EMR_POLYDRAW,
    EmfRecordTypeSetArcDirection         = EMR_SETARCDIRECTION,
    EmfRecordTypeSetMiterLimit           = EMR_SETMITERLIMIT,
    EmfRecordTypeBeginPath               = EMR_BEGINPATH,
    EmfRecordTypeEndPath                 = EMR_ENDPATH,
    EmfRecordTypeCloseFigure             = EMR_CLOSEFIGURE,
    EmfRecordTypeFillPath                = EMR_FILLPATH,
    EmfRecordTypeStrokeAndFillPath       = EMR_STROKEANDFILLPATH,
    EmfRecordTypeStrokePath              = EMR_STROKEPATH,
    EmfRecordTypeFlattenPath             = EMR_FLATTENPATH,
    EmfRecordTypeWidenPath               = EMR_WIDENPATH,
    EmfRecordTypeSelectClipPath          = EMR_SELECTCLIPPATH,
    EmfRecordTypeAbortPath               = EMR_ABORTPATH,
    EmfRecordTypeReserved_069            = 69,  // Not Used
    EmfRecordTypeGdiComment              = EMR_GDICOMMENT,
    EmfRecordTypeFillRgn                 = EMR_FILLRGN,
    EmfRecordTypeFrameRgn                = EMR_FRAMERGN,
    EmfRecordTypeInvertRgn               = EMR_INVERTRGN,
    EmfRecordTypePaintRgn                = EMR_PAINTRGN,
    EmfRecordTypeExtSelectClipRgn        = EMR_EXTSELECTCLIPRGN,
    EmfRecordTypeBitBlt                  = EMR_BITBLT,
    EmfRecordTypeStretchBlt              = EMR_STRETCHBLT,
    EmfRecordTypeMaskBlt                 = EMR_MASKBLT,
    EmfRecordTypePlgBlt                  = EMR_PLGBLT,
    EmfRecordTypeSetDIBitsToDevice       = EMR_SETDIBITSTODEVICE,
    EmfRecordTypeStretchDIBits           = EMR_STRETCHDIBITS,
    EmfRecordTypeExtCreateFontIndirect   = EMR_EXTCREATEFONTINDIRECTW,
    EmfRecordTypeExtTextOutA             = EMR_EXTTEXTOUTA,
    EmfRecordTypeExtTextOutW             = EMR_EXTTEXTOUTW,
    EmfRecordTypePolyBezier16            = EMR_POLYBEZIER16,
    EmfRecordTypePolygon16               = EMR_POLYGON16,
    EmfRecordTypePolyline16              = EMR_POLYLINE16,
    EmfRecordTypePolyBezierTo16          = EMR_POLYBEZIERTO16,
    EmfRecordTypePolylineTo16            = EMR_POLYLINETO16,
    EmfRecordTypePolyPolyline16          = EMR_POLYPOLYLINE16,
    EmfRecordTypePolyPolygon16           = EMR_POLYPOLYGON16,
    EmfRecordTypePolyDraw16              = EMR_POLYDRAW16,
    EmfRecordTypeCreateMonoBrush         = EMR_CREATEMONOBRUSH,
    EmfRecordTypeCreateDIBPatternBrushPt = EMR_CREATEDIBPATTERNBRUSHPT,
    EmfRecordTypeExtCreatePen            = EMR_EXTCREATEPEN,
    EmfRecordTypePolyTextOutA            = EMR_POLYTEXTOUTA,
    EmfRecordTypePolyTextOutW            = EMR_POLYTEXTOUTW,
    EmfRecordTypeSetICMMode              = 98,  // EMR_SETICMMODE,
    EmfRecordTypeCreateColorSpace        = 99,  // EMR_CREATECOLORSPACE,
    EmfRecordTypeSetColorSpace           = 100, // EMR_SETCOLORSPACE,
    EmfRecordTypeDeleteColorSpace        = 101, // EMR_DELETECOLORSPACE,
    EmfRecordTypeGLSRecord               = 102, // EMR_GLSRECORD,
    EmfRecordTypeGLSBoundedRecord        = 103, // EMR_GLSBOUNDEDRECORD,
    EmfRecordTypePixelFormat             = 104, // EMR_PIXELFORMAT,
    EmfRecordTypeDrawEscape              = 105, // EMR_RESERVED_105,
    EmfRecordTypeExtEscape               = 106, // EMR_RESERVED_106,
    EmfRecordTypeStartDoc                = 107, // EMR_RESERVED_107,
    EmfRecordTypeSmallTextOut            = 108, // EMR_RESERVED_108,
    EmfRecordTypeForceUFIMapping         = 109, // EMR_RESERVED_109,
    EmfRecordTypeNamedEscape             = 110, // EMR_RESERVED_110,
    EmfRecordTypeColorCorrectPalette     = 111, // EMR_COLORCORRECTPALETTE,
    EmfRecordTypeSetICMProfileA          = 112, // EMR_SETICMPROFILEA,
    EmfRecordTypeSetICMProfileW          = 113, // EMR_SETICMPROFILEW,
    EmfRecordTypeAlphaBlend              = 114, // EMR_ALPHABLEND,
    EmfRecordTypeSetLayout               = 115, // EMR_SETLAYOUT,
    EmfRecordTypeTransparentBlt          = 116, // EMR_TRANSPARENTBLT,
    EmfRecordTypeReserved_117            = 117, // Not Used
    EmfRecordTypeGradientFill            = 118, // EMR_GRADIENTFILL,
    EmfRecordTypeSetLinkedUFIs           = 119, // EMR_RESERVED_119,
    EmfRecordTypeSetTextJustification    = 120, // EMR_RESERVED_120,
    EmfRecordTypeColorMatchToTargetW     = 121, // EMR_COLORMATCHTOTARGETW,
    EmfRecordTypeCreateColorSpaceW       = 122, // EMR_CREATECOLORSPACEW,
    EmfRecordTypeMax                     = 122,
    EmfRecordTypeMin                     = 1,

    // That is the END of the GDI EMF records.

    // Now we start the list of EMF+ records.  We leave quite
    // a bit of room here for the addition of any new GDI
    // records that may be added later.

    EmfPlusRecordTypeInvalid = GDIP_EMFPLUS_RECORD_BASE,
    EmfPlusRecordTypeHeader,
    EmfPlusRecordTypeEndOfFile,

    EmfPlusRecordTypeComment,

    EmfPlusRecordTypeGetDC,

    EmfPlusRecordTypeMultiFormatStart,
    EmfPlusRecordTypeMultiFormatSection,
    EmfPlusRecordTypeMultiFormatEnd,

    // For all persistent objects

    EmfPlusRecordTypeObject,

    // Drawing Records

    EmfPlusRecordTypeClear,
    EmfPlusRecordTypeFillRects,
    EmfPlusRecordTypeDrawRects,
    EmfPlusRecordTypeFillPolygon,
    EmfPlusRecordTypeDrawLines,
    EmfPlusRecordTypeFillEllipse,
    EmfPlusRecordTypeDrawEllipse,
    EmfPlusRecordTypeFillPie,
    EmfPlusRecordTypeDrawPie,
    EmfPlusRecordTypeDrawArc,
    EmfPlusRecordTypeFillRegion,
    EmfPlusRecordTypeFillPath,
    EmfPlusRecordTypeDrawPath,
    EmfPlusRecordTypeFillClosedCurve,
    EmfPlusRecordTypeDrawClosedCurve,
    EmfPlusRecordTypeDrawCurve,
    EmfPlusRecordTypeDrawBeziers,
    EmfPlusRecordTypeDrawImage,
    EmfPlusRecordTypeDrawImagePoints,
    EmfPlusRecordTypeDrawString,

    // Graphics State Records

    EmfPlusRecordTypeSetRenderingOrigin,
    EmfPlusRecordTypeSetAntiAliasMode,
    EmfPlusRecordTypeSetTextRenderingHint,
    EmfPlusRecordTypeSetTextContrast,
    EmfPlusRecordTypeSetInterpolationMode,
    EmfPlusRecordTypeSetPixelOffsetMode,
    EmfPlusRecordTypeSetCompositingMode,
    EmfPlusRecordTypeSetCompositingQuality,
    EmfPlusRecordTypeSave,
    EmfPlusRecordTypeRestore,
    EmfPlusRecordTypeBeginContainer,
    EmfPlusRecordTypeBeginContainerNoParams,
    EmfPlusRecordTypeEndContainer,
    EmfPlusRecordTypeSetWorldTransform,
    EmfPlusRecordTypeResetWorldTransform,
    EmfPlusRecordTypeMultiplyWorldTransform,
    EmfPlusRecordTypeTranslateWorldTransform,
    EmfPlusRecordTypeScaleWorldTransform,
    EmfPlusRecordTypeRotateWorldTransform,
    EmfPlusRecordTypeSetPageTransform,
    EmfPlusRecordTypeResetClip,
    EmfPlusRecordTypeSetClipRect,
    EmfPlusRecordTypeSetClipPath,
    EmfPlusRecordTypeSetClipRegion,
    EmfPlusRecordTypeOffsetClip,

    EmfPlusRecordTypeDrawDriverString,

    EmfPlusRecordTotal,

    EmfPlusRecordTypeMax = EmfPlusRecordTotal-1,
    EmfPlusRecordTypeMin = EmfPlusRecordTypeHeader
  );
  TEmfPlusRecordType = EmfPlusRecordType;
{$ELSE}
type
  {$EXTERNALSYM EmfPlusRecordType}
  EmfPlusRecordType = Integer;
  // Since we have to enumerate GDI records right along with GDI+ records,
  // We list all the GDI records here so that they can be part of the
  // same enumeration type which is used in the enumeration callback.
  const
    WmfRecordTypeSetBkColor              = (META_SETBKCOLOR or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetBkMode               = (META_SETBKMODE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetMapMode              = (META_SETMAPMODE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetROP2                 = (META_SETROP2 or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetRelAbs               = (META_SETRELABS or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetPolyFillMode         = (META_SETPOLYFILLMODE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetStretchBltMode       = (META_SETSTRETCHBLTMODE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetTextCharExtra        = (META_SETTEXTCHAREXTRA or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetTextColor            = (META_SETTEXTCOLOR or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetTextJustification    = (META_SETTEXTJUSTIFICATION or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetWindowOrg            = (META_SETWINDOWORG or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetWindowExt            = (META_SETWINDOWEXT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetViewportOrg          = (META_SETVIEWPORTORG or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetViewportExt          = (META_SETVIEWPORTEXT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeOffsetWindowOrg         = (META_OFFSETWINDOWORG or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeScaleWindowExt          = (META_SCALEWINDOWEXT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeOffsetViewportOrg       = (META_OFFSETVIEWPORTORG or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeScaleViewportExt        = (META_SCALEVIEWPORTEXT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeLineTo                  = (META_LINETO or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeMoveTo                  = (META_MOVETO or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeExcludeClipRect         = (META_EXCLUDECLIPRECT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeIntersectClipRect       = (META_INTERSECTCLIPRECT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeArc                     = (META_ARC or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeEllipse                 = (META_ELLIPSE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeFloodFill               = (META_FLOODFILL or GDIP_WMF_RECORD_BASE);
    WmfRecordTypePie                     = (META_PIE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeRectangle               = (META_RECTANGLE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeRoundRect               = (META_ROUNDRECT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypePatBlt                  = (META_PATBLT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSaveDC                  = (META_SAVEDC or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetPixel                = (META_SETPIXEL or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeOffsetClipRgn           = (META_OFFSETCLIPRGN or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeTextOut                 = (META_TEXTOUT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeBitBlt                  = (META_BITBLT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeStretchBlt              = (META_STRETCHBLT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypePolygon                 = (META_POLYGON or GDIP_WMF_RECORD_BASE);
    WmfRecordTypePolyline                = (META_POLYLINE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeEscape                  = (META_ESCAPE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeRestoreDC               = (META_RESTOREDC or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeFillRegion              = (META_FILLREGION or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeFrameRegion             = (META_FRAMEREGION or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeInvertRegion            = (META_INVERTREGION or GDIP_WMF_RECORD_BASE);
    WmfRecordTypePaintRegion             = (META_PAINTREGION or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSelectClipRegion        = (META_SELECTCLIPREGION or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSelectObject            = (META_SELECTOBJECT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetTextAlign            = (META_SETTEXTALIGN or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeDrawText                = ($062F or GDIP_WMF_RECORD_BASE);  // META_DRAWTEXT
    WmfRecordTypeChord                   = (META_CHORD or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetMapperFlags          = (META_SETMAPPERFLAGS or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeExtTextOut              = (META_EXTTEXTOUT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetDIBToDev             = (META_SETDIBTODEV or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSelectPalette           = (META_SELECTPALETTE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeRealizePalette          = (META_REALIZEPALETTE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeAnimatePalette          = (META_ANIMATEPALETTE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetPalEntries           = (META_SETPALENTRIES or GDIP_WMF_RECORD_BASE);
    WmfRecordTypePolyPolygon             = (META_POLYPOLYGON or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeResizePalette           = (META_RESIZEPALETTE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeDIBBitBlt               = (META_DIBBITBLT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeDIBStretchBlt           = (META_DIBSTRETCHBLT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeDIBCreatePatternBrush   = (META_DIBCREATEPATTERNBRUSH or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeStretchDIB              = (META_STRETCHDIB or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeExtFloodFill            = (META_EXTFLOODFILL or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeSetLayout               = ($0149 or GDIP_WMF_RECORD_BASE);  // META_SETLAYOUT
    WmfRecordTypeResetDC                 = ($014C or GDIP_WMF_RECORD_BASE);  // META_RESETDC
    WmfRecordTypeStartDoc                = ($014D or GDIP_WMF_RECORD_BASE);  // META_STARTDOC
    WmfRecordTypeStartPage               = ($004F or GDIP_WMF_RECORD_BASE);  // META_STARTPAGE
    WmfRecordTypeEndPage                 = ($0050 or GDIP_WMF_RECORD_BASE);  // META_ENDPAGE
    WmfRecordTypeAbortDoc                = ($0052 or GDIP_WMF_RECORD_BASE);  // META_ABORTDOC
    WmfRecordTypeEndDoc                  = ($005E or GDIP_WMF_RECORD_BASE);  // META_ENDDOC
    WmfRecordTypeDeleteObject            = (META_DELETEOBJECT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeCreatePalette           = (META_CREATEPALETTE or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeCreateBrush             = ($00F8 or GDIP_WMF_RECORD_BASE);  // META_CREATEBRUSH
    WmfRecordTypeCreatePatternBrush      = (META_CREATEPATTERNBRUSH or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeCreatePenIndirect       = (META_CREATEPENINDIRECT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeCreateFontIndirect      = (META_CREATEFONTINDIRECT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeCreateBrushIndirect     = (META_CREATEBRUSHINDIRECT or GDIP_WMF_RECORD_BASE);
    WmfRecordTypeCreateBitmapIndirect    = ($02FD or GDIP_WMF_RECORD_BASE);  // META_CREATEBITMAPINDIRECT
    WmfRecordTypeCreateBitmap            = ($06FE or GDIP_WMF_RECORD_BASE);  // META_CREATEBITMAP
    WmfRecordTypeCreateRegion            = (META_CREATEREGION or GDIP_WMF_RECORD_BASE);

    EmfRecordTypeHeader                  = EMR_HEADER;
    EmfRecordTypePolyBezier              = EMR_POLYBEZIER;
    EmfRecordTypePolygon                 = EMR_POLYGON;
    EmfRecordTypePolyline                = EMR_POLYLINE;
    EmfRecordTypePolyBezierTo            = EMR_POLYBEZIERTO;
    EmfRecordTypePolyLineTo              = EMR_POLYLINETO;
    EmfRecordTypePolyPolyline            = EMR_POLYPOLYLINE;
    EmfRecordTypePolyPolygon             = EMR_POLYPOLYGON;
    EmfRecordTypeSetWindowExtEx          = EMR_SETWINDOWEXTEX;
    EmfRecordTypeSetWindowOrgEx          = EMR_SETWINDOWORGEX;
    EmfRecordTypeSetViewportExtEx        = EMR_SETVIEWPORTEXTEX;
    EmfRecordTypeSetViewportOrgEx        = EMR_SETVIEWPORTORGEX;
    EmfRecordTypeSetBrushOrgEx           = EMR_SETBRUSHORGEX;
    EmfRecordTypeEOF                     = EMR_EOF;
    EmfRecordTypeSetPixelV               = EMR_SETPIXELV;
    EmfRecordTypeSetMapperFlags          = EMR_SETMAPPERFLAGS;
    EmfRecordTypeSetMapMode              = EMR_SETMAPMODE;
    EmfRecordTypeSetBkMode               = EMR_SETBKMODE;
    EmfRecordTypeSetPolyFillMode         = EMR_SETPOLYFILLMODE;
    EmfRecordTypeSetROP2                 = EMR_SETROP2;
    EmfRecordTypeSetStretchBltMode       = EMR_SETSTRETCHBLTMODE;
    EmfRecordTypeSetTextAlign            = EMR_SETTEXTALIGN;
    EmfRecordTypeSetColorAdjustment      = EMR_SETCOLORADJUSTMENT;
    EmfRecordTypeSetTextColor            = EMR_SETTEXTCOLOR;
    EmfRecordTypeSetBkColor              = EMR_SETBKCOLOR;
    EmfRecordTypeOffsetClipRgn           = EMR_OFFSETCLIPRGN;
    EmfRecordTypeMoveToEx                = EMR_MOVETOEX;
    EmfRecordTypeSetMetaRgn              = EMR_SETMETARGN;
    EmfRecordTypeExcludeClipRect         = EMR_EXCLUDECLIPRECT;
    EmfRecordTypeIntersectClipRect       = EMR_INTERSECTCLIPRECT;
    EmfRecordTypeScaleViewportExtEx      = EMR_SCALEVIEWPORTEXTEX;
    EmfRecordTypeScaleWindowExtEx        = EMR_SCALEWINDOWEXTEX;
    EmfRecordTypeSaveDC                  = EMR_SAVEDC;
    EmfRecordTypeRestoreDC               = EMR_RESTOREDC;
    EmfRecordTypeSetWorldTransform       = EMR_SETWORLDTRANSFORM;
    EmfRecordTypeModifyWorldTransform    = EMR_MODIFYWORLDTRANSFORM;
    EmfRecordTypeSelectObject            = EMR_SELECTOBJECT;
    EmfRecordTypeCreatePen               = EMR_CREATEPEN;
    EmfRecordTypeCreateBrushIndirect     = EMR_CREATEBRUSHINDIRECT;
    EmfRecordTypeDeleteObject            = EMR_DELETEOBJECT;
    EmfRecordTypeAngleArc                = EMR_ANGLEARC;
    EmfRecordTypeEllipse                 = EMR_ELLIPSE;
    EmfRecordTypeRectangle               = EMR_RECTANGLE;
    EmfRecordTypeRoundRect               = EMR_ROUNDRECT;
    EmfRecordTypeArc                     = EMR_ARC;
    EmfRecordTypeChord                   = EMR_CHORD;
    EmfRecordTypePie                     = EMR_PIE;
    EmfRecordTypeSelectPalette           = EMR_SELECTPALETTE;
    EmfRecordTypeCreatePalette           = EMR_CREATEPALETTE;
    EmfRecordTypeSetPaletteEntries       = EMR_SETPALETTEENTRIES;
    EmfRecordTypeResizePalette           = EMR_RESIZEPALETTE;
    EmfRecordTypeRealizePalette          = EMR_REALIZEPALETTE;
    EmfRecordTypeExtFloodFill            = EMR_EXTFLOODFILL;
    EmfRecordTypeLineTo                  = EMR_LINETO;
    EmfRecordTypeArcTo                   = EMR_ARCTO;
    EmfRecordTypePolyDraw                = EMR_POLYDRAW;
    EmfRecordTypeSetArcDirection         = EMR_SETARCDIRECTION;
    EmfRecordTypeSetMiterLimit           = EMR_SETMITERLIMIT;
    EmfRecordTypeBeginPath               = EMR_BEGINPATH;
    EmfRecordTypeEndPath                 = EMR_ENDPATH;
    EmfRecordTypeCloseFigure             = EMR_CLOSEFIGURE;
    EmfRecordTypeFillPath                = EMR_FILLPATH;
    EmfRecordTypeStrokeAndFillPath       = EMR_STROKEANDFILLPATH;
    EmfRecordTypeStrokePath              = EMR_STROKEPATH;
    EmfRecordTypeFlattenPath             = EMR_FLATTENPATH;
    EmfRecordTypeWidenPath               = EMR_WIDENPATH;
    EmfRecordTypeSelectClipPath          = EMR_SELECTCLIPPATH;
    EmfRecordTypeAbortPath               = EMR_ABORTPATH;
    EmfRecordTypeReserved_069            = 69;  // Not Used
    EmfRecordTypeGdiComment              = EMR_GDICOMMENT;
    EmfRecordTypeFillRgn                 = EMR_FILLRGN;
    EmfRecordTypeFrameRgn                = EMR_FRAMERGN;
    EmfRecordTypeInvertRgn               = EMR_INVERTRGN;
    EmfRecordTypePaintRgn                = EMR_PAINTRGN;
    EmfRecordTypeExtSelectClipRgn        = EMR_EXTSELECTCLIPRGN;
    EmfRecordTypeBitBlt                  = EMR_BITBLT;
    EmfRecordTypeStretchBlt              = EMR_STRETCHBLT;
    EmfRecordTypeMaskBlt                 = EMR_MASKBLT;
    EmfRecordTypePlgBlt                  = EMR_PLGBLT;
    EmfRecordTypeSetDIBitsToDevice       = EMR_SETDIBITSTODEVICE;
    EmfRecordTypeStretchDIBits           = EMR_STRETCHDIBITS;
    EmfRecordTypeExtCreateFontIndirect   = EMR_EXTCREATEFONTINDIRECTW;
    EmfRecordTypeExtTextOutA             = EMR_EXTTEXTOUTA;
    EmfRecordTypeExtTextOutW             = EMR_EXTTEXTOUTW;
    EmfRecordTypePolyBezier16            = EMR_POLYBEZIER16;
    EmfRecordTypePolygon16               = EMR_POLYGON16;
    EmfRecordTypePolyline16              = EMR_POLYLINE16;
    EmfRecordTypePolyBezierTo16          = EMR_POLYBEZIERTO16;
    EmfRecordTypePolylineTo16            = EMR_POLYLINETO16;
    EmfRecordTypePolyPolyline16          = EMR_POLYPOLYLINE16;
    EmfRecordTypePolyPolygon16           = EMR_POLYPOLYGON16;
    EmfRecordTypePolyDraw16              = EMR_POLYDRAW16;
    EmfRecordTypeCreateMonoBrush         = EMR_CREATEMONOBRUSH;
    EmfRecordTypeCreateDIBPatternBrushPt = EMR_CREATEDIBPATTERNBRUSHPT;
    EmfRecordTypeExtCreatePen            = EMR_EXTCREATEPEN;
    EmfRecordTypePolyTextOutA            = EMR_POLYTEXTOUTA;
    EmfRecordTypePolyTextOutW            = EMR_POLYTEXTOUTW;
    EmfRecordTypeSetICMMode              = 98;  // EMR_SETICMMODE,
    EmfRecordTypeCreateColorSpace        = 99;  // EMR_CREATECOLORSPACE,
    EmfRecordTypeSetColorSpace           = 100; // EMR_SETCOLORSPACE,
    EmfRecordTypeDeleteColorSpace        = 101; // EMR_DELETECOLORSPACE,
    EmfRecordTypeGLSRecord               = 102; // EMR_GLSRECORD,
    EmfRecordTypeGLSBoundedRecord        = 103; // EMR_GLSBOUNDEDRECORD,
    EmfRecordTypePixelFormat             = 104; // EMR_PIXELFORMAT,
    EmfRecordTypeDrawEscape              = 105; // EMR_RESERVED_105,
    EmfRecordTypeExtEscape               = 106; // EMR_RESERVED_106,
    EmfRecordTypeStartDoc                = 107; // EMR_RESERVED_107,
    EmfRecordTypeSmallTextOut            = 108; // EMR_RESERVED_108,
    EmfRecordTypeForceUFIMapping         = 109; // EMR_RESERVED_109,
    EmfRecordTypeNamedEscape             = 110; // EMR_RESERVED_110,
    EmfRecordTypeColorCorrectPalette     = 111; // EMR_COLORCORRECTPALETTE,
    EmfRecordTypeSetICMProfileA          = 112; // EMR_SETICMPROFILEA,
    EmfRecordTypeSetICMProfileW          = 113; // EMR_SETICMPROFILEW,
    EmfRecordTypeAlphaBlend              = 114; // EMR_ALPHABLEND,
    EmfRecordTypeSetLayout               = 115; // EMR_SETLAYOUT,
    EmfRecordTypeTransparentBlt          = 116; // EMR_TRANSPARENTBLT,
    EmfRecordTypeReserved_117            = 117; // Not Used
    EmfRecordTypeGradientFill            = 118; // EMR_GRADIENTFILL,
    EmfRecordTypeSetLinkedUFIs           = 119; // EMR_RESERVED_119,
    EmfRecordTypeSetTextJustification    = 120; // EMR_RESERVED_120,
    EmfRecordTypeColorMatchToTargetW     = 121; // EMR_COLORMATCHTOTARGETW,
    EmfRecordTypeCreateColorSpaceW       = 122; // EMR_CREATECOLORSPACEW,
    EmfRecordTypeMax                     = 122;
    EmfRecordTypeMin                     = 1;

    // That is the END of the GDI EMF records.

    // Now we start the list of EMF+ records.  We leave quite
    // a bit of room here for the addition of any new GDI
    // records that may be added later.

    EmfPlusRecordTypeInvalid   = GDIP_EMFPLUS_RECORD_BASE;
    EmfPlusRecordTypeHeader    = GDIP_EMFPLUS_RECORD_BASE + 1;
    EmfPlusRecordTypeEndOfFile = GDIP_EMFPLUS_RECORD_BASE + 2;

    EmfPlusRecordTypeComment   = GDIP_EMFPLUS_RECORD_BASE + 3;

    EmfPlusRecordTypeGetDC     = GDIP_EMFPLUS_RECORD_BASE + 4;

    EmfPlusRecordTypeMultiFormatStart   = GDIP_EMFPLUS_RECORD_BASE + 5;
    EmfPlusRecordTypeMultiFormatSection = GDIP_EMFPLUS_RECORD_BASE + 6;
    EmfPlusRecordTypeMultiFormatEnd     = GDIP_EMFPLUS_RECORD_BASE + 7;

    // For all persistent objects

    EmfPlusRecordTypeObject = GDIP_EMFPLUS_RECORD_BASE + 8;

    // Drawing Records

    EmfPlusRecordTypeClear           = GDIP_EMFPLUS_RECORD_BASE + 9;
    EmfPlusRecordTypeFillRects       = GDIP_EMFPLUS_RECORD_BASE + 10;
    EmfPlusRecordTypeDrawRects       = GDIP_EMFPLUS_RECORD_BASE + 11;
    EmfPlusRecordTypeFillPolygon     = GDIP_EMFPLUS_RECORD_BASE + 12;
    EmfPlusRecordTypeDrawLines       = GDIP_EMFPLUS_RECORD_BASE + 13;
    EmfPlusRecordTypeFillEllipse     = GDIP_EMFPLUS_RECORD_BASE + 14;
    EmfPlusRecordTypeDrawEllipse     = GDIP_EMFPLUS_RECORD_BASE + 15;
    EmfPlusRecordTypeFillPie         = GDIP_EMFPLUS_RECORD_BASE + 16;
    EmfPlusRecordTypeDrawPie         = GDIP_EMFPLUS_RECORD_BASE + 17;
    EmfPlusRecordTypeDrawArc         = GDIP_EMFPLUS_RECORD_BASE + 18;
    EmfPlusRecordTypeFillRegion      = GDIP_EMFPLUS_RECORD_BASE + 19;
    EmfPlusRecordTypeFillPath        = GDIP_EMFPLUS_RECORD_BASE + 20;
    EmfPlusRecordTypeDrawPath        = GDIP_EMFPLUS_RECORD_BASE + 21;
    EmfPlusRecordTypeFillClosedCurve = GDIP_EMFPLUS_RECORD_BASE + 22;
    EmfPlusRecordTypeDrawClosedCurve = GDIP_EMFPLUS_RECORD_BASE + 23;
    EmfPlusRecordTypeDrawCurve       = GDIP_EMFPLUS_RECORD_BASE + 24;
    EmfPlusRecordTypeDrawBeziers     = GDIP_EMFPLUS_RECORD_BASE + 25;
    EmfPlusRecordTypeDrawImage       = GDIP_EMFPLUS_RECORD_BASE + 26;
    EmfPlusRecordTypeDrawImagePoints = GDIP_EMFPLUS_RECORD_BASE + 27;
    EmfPlusRecordTypeDrawString      = GDIP_EMFPLUS_RECORD_BASE + 28;

    // Graphics State Records

    EmfPlusRecordTypeSetRenderingOrigin      = GDIP_EMFPLUS_RECORD_BASE + 29;
    EmfPlusRecordTypeSetAntiAliasMode        = GDIP_EMFPLUS_RECORD_BASE + 30;
    EmfPlusRecordTypeSetTextRenderingHint    = GDIP_EMFPLUS_RECORD_BASE + 31;
    EmfPlusRecordTypeSetTextContrast         = GDIP_EMFPLUS_RECORD_BASE + 32;
    EmfPlusRecordTypeSetInterpolationMode    = GDIP_EMFPLUS_RECORD_BASE + 33;
    EmfPlusRecordTypeSetPixelOffsetMode      = GDIP_EMFPLUS_RECORD_BASE + 34;
    EmfPlusRecordTypeSetCompositingMode      = GDIP_EMFPLUS_RECORD_BASE + 35;
    EmfPlusRecordTypeSetCompositingQuality   = GDIP_EMFPLUS_RECORD_BASE + 36;
    EmfPlusRecordTypeSave                    = GDIP_EMFPLUS_RECORD_BASE + 37;
    EmfPlusRecordTypeRestore                 = GDIP_EMFPLUS_RECORD_BASE + 38;
    EmfPlusRecordTypeBeginContainer          = GDIP_EMFPLUS_RECORD_BASE + 39;
    EmfPlusRecordTypeBeginContainerNoParams  = GDIP_EMFPLUS_RECORD_BASE + 40;
    EmfPlusRecordTypeEndContainer            = GDIP_EMFPLUS_RECORD_BASE + 41;
    EmfPlusRecordTypeSetWorldTransform       = GDIP_EMFPLUS_RECORD_BASE + 42;
    EmfPlusRecordTypeResetWorldTransform     = GDIP_EMFPLUS_RECORD_BASE + 43;
    EmfPlusRecordTypeMultiplyWorldTransform  = GDIP_EMFPLUS_RECORD_BASE + 44;
    EmfPlusRecordTypeTranslateWorldTransform = GDIP_EMFPLUS_RECORD_BASE + 45;
    EmfPlusRecordTypeScaleWorldTransform     = GDIP_EMFPLUS_RECORD_BASE + 46;
    EmfPlusRecordTypeRotateWorldTransform    = GDIP_EMFPLUS_RECORD_BASE + 47;
    EmfPlusRecordTypeSetPageTransform        = GDIP_EMFPLUS_RECORD_BASE + 48;
    EmfPlusRecordTypeResetClip               = GDIP_EMFPLUS_RECORD_BASE + 49;
    EmfPlusRecordTypeSetClipRect             = GDIP_EMFPLUS_RECORD_BASE + 50;
    EmfPlusRecordTypeSetClipPath             = GDIP_EMFPLUS_RECORD_BASE + 51;
    EmfPlusRecordTypeSetClipRegion           = GDIP_EMFPLUS_RECORD_BASE + 52;
    EmfPlusRecordTypeOffsetClip              = GDIP_EMFPLUS_RECORD_BASE + 53;

    EmfPlusRecordTypeDrawDriverString        = GDIP_EMFPLUS_RECORD_BASE + 54;

    EmfPlusRecordTotal                       = GDIP_EMFPLUS_RECORD_BASE + 55;

    EmfPlusRecordTypeMax = EmfPlusRecordTotal-1;
    EmfPlusRecordTypeMin = EmfPlusRecordTypeHeader;

type
  TEmfPlusRecordType = EmfPlusRecordType;
{$ENDIF}
//---------------------------------------------------------------------------
// StringFormatFlags
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// String format flags
//
//  DirectionRightToLeft          - For horizontal text, the reading order is
//                                  right to left. This value is called
//                                  the base embedding level by the Unicode
//                                  bidirectional engine.
//                                  For vertical text, columns are read from
//                                  right to left.
//                                  By default, horizontal or vertical text is
//                                  read from left to right.
//
//  DirectionVertical             - Individual lines of text are vertical. In
//                                  each line, characters progress from top to
//                                  bottom.
//                                  By default, lines of text are horizontal,
//                                  each new line below the previous line.
//
//  NoFitBlackBox                 - Allows parts of glyphs to overhang the
//                                  bounding rectangle.
//                                  By default glyphs are first aligned
//                                  inside the margines, then any glyphs which
//                                  still overhang the bounding box are
//                                  repositioned to avoid any overhang.
//                                  For example when an italic
//                                  lower case letter f in a font such as
//                                  Garamond is aligned at the far left of a
//                                  rectangle, the lower part of the f will
//                                  reach slightly further left than the left
//                                  edge of the rectangle. Setting this flag
//                                  will ensure the character aligns visually
//                                  with the lines above and below, but may
//                                  cause some pixels outside the formatting
//                                  rectangle to be clipped or painted.
//
//  DisplayFormatControl          - Causes control characters such as the
//                                  left-to-right mark to be shown in the
//                                  output with a representative glyph.
//
//  NoFontFallback                - Disables fallback to alternate fonts for
//                                  characters not supported in the requested
//                                  font. Any missing characters will be
//                                  be displayed with the fonts missing glyph,
//                                  usually an open square.
//
//  NoWrap                        - Disables wrapping of text between lines
//                                  when formatting within a rectangle.
//                                  NoWrap is implied when a point is passed
//                                  instead of a rectangle, or when the
//                                  specified rectangle has a zero line length.
//
//  NoClip                        - By default text is clipped to the
//                                  formatting rectangle. Setting NoClip
//                                  allows overhanging pixels to affect the
//                                  device outside the formatting rectangle.
//                                  Pixels at the end of the line may be
//                                  affected if the glyphs overhang their
//                                  cells, and either the NoFitBlackBox flag
//                                  has been set, or the glyph extends to far
//                                  to be fitted.
//                                  Pixels above/before the first line or
//                                  below/after the last line may be affected
//                                  if the glyphs extend beyond their cell
//                                  ascent / descent. This can occur rarely
//                                  with unusual diacritic mark combinations.

//---------------------------------------------------------------------------

  {$EXTERNALSYM StringFormatFlags}
  StringFormatFlags = Integer;
  const
    StringFormatFlagsDirectionRightToLeft        = $00000001;
    StringFormatFlagsDirectionVertical           = $00000002;
    StringFormatFlagsNoFitBlackBox               = $00000004;
    StringFormatFlagsDisplayFormatControl        = $00000020;
    StringFormatFlagsNoFontFallback              = $00000400;
    StringFormatFlagsMeasureTrailingSpaces       = $00000800;
    StringFormatFlagsNoWrap                      = $00001000;
    StringFormatFlagsLineLimit                   = $00002000;

    StringFormatFlagsNoClip                      = $00004000;

Type
  TStringFormatFlags = StringFormatFlags;

//---------------------------------------------------------------------------
// StringTrimming
//---------------------------------------------------------------------------

  {$EXTERNALSYM StringTrimming}
  StringTrimming = (
    StringTrimmingNone,
    StringTrimmingCharacter,
    StringTrimmingWord,
    StringTrimmingEllipsisCharacter,
    StringTrimmingEllipsisWord,
    StringTrimmingEllipsisPath
  );
  TStringTrimming = StringTrimming;

//---------------------------------------------------------------------------
// National language digit substitution
//---------------------------------------------------------------------------

  {$EXTERNALSYM StringDigitSubstitute}
  StringDigitSubstitute = (
    StringDigitSubstituteUser,          // As NLS setting
    StringDigitSubstituteNone,
    StringDigitSubstituteNational,
    StringDigitSubstituteTraditional
  );
  TStringDigitSubstitute = StringDigitSubstitute;
  PStringDigitSubstitute = ^TStringDigitSubstitute;

//---------------------------------------------------------------------------
// Hotkey prefix interpretation
//---------------------------------------------------------------------------

  {$EXTERNALSYM HotkeyPrefix}
  HotkeyPrefix = (
    HotkeyPrefixNone,
    HotkeyPrefixShow,
    HotkeyPrefixHide
  );
  THotkeyPrefix = HotkeyPrefix;

//---------------------------------------------------------------------------
// String alignment flags
//---------------------------------------------------------------------------

  {$EXTERNALSYM StringAlignment}
  StringAlignment = (
    // Left edge for left-to-right text,
    // right for right-to-left text,
    // and top for vertical
    StringAlignmentNear,
    StringAlignmentCenter,
    StringAlignmentFar
  );
  TStringAlignment = StringAlignment;

//---------------------------------------------------------------------------
// DriverStringOptions
//---------------------------------------------------------------------------

  {$EXTERNALSYM DriverStringOptions}
  DriverStringOptions = Integer;
  const
    DriverStringOptionsCmapLookup             = 1;
    DriverStringOptionsVertical               = 2;
    DriverStringOptionsRealizedAdvance        = 4;
    DriverStringOptionsLimitSubpixel          = 8;

type
  TDriverStringOptions = DriverStringOptions;

//---------------------------------------------------------------------------
// Flush Intention flags
//---------------------------------------------------------------------------

  {$EXTERNALSYM FlushIntention}
  FlushIntention = (
    FlushIntentionFlush,  // Flush all batched rendering operations
    FlushIntentionSync    // Flush all batched rendering operations
                          // and wait for them to complete
  );
  TFlushIntention = FlushIntention;

//---------------------------------------------------------------------------
// Image encoder parameter related types
//---------------------------------------------------------------------------

  {$EXTERNALSYM EncoderParameterValueType}
  EncoderParameterValueType = Integer;
  const
    EncoderParameterValueTypeByte          : Integer = 1;    // 8-bit unsigned int
    EncoderParameterValueTypeASCII         : Integer = 2;    // 8-bit byte containing one 7-bit ASCII
                                                             // code. NULL terminated.
    EncoderParameterValueTypeShort         : Integer = 3;    // 16-bit unsigned int
    EncoderParameterValueTypeLong          : Integer = 4;    // 32-bit unsigned int
    EncoderParameterValueTypeRational      : Integer = 5;    // Two Longs. The first Long is the
                                                             // numerator, the second Long expresses the
                                                             // denomintor.
    EncoderParameterValueTypeLongRange     : Integer = 6;    // Two longs which specify a range of
                                                             // integer values. The first Long specifies
                                                             // the lower end and the second one
                                                             // specifies the higher end. All values
                                                             // are inclusive at both ends
    EncoderParameterValueTypeUndefined     : Integer = 7;    // 8-bit byte that can take any value
                                                             // depending on field definition
    EncoderParameterValueTypeRationalRange : Integer = 8;    // Two Rationals. The first Rational
                                                             // specifies the lower end and the second
                                                             // specifies the higher end. All values
                                                             // are inclusive at both ends
type
  TEncoderParameterValueType = EncoderParameterValueType;

//---------------------------------------------------------------------------
// Image encoder value types
//---------------------------------------------------------------------------

  {$EXTERNALSYM EncoderValue}
  EncoderValue = (
    EncoderValueColorTypeCMYK,
    EncoderValueColorTypeYCCK,
    EncoderValueCompressionLZW,
    EncoderValueCompressionCCITT3,
    EncoderValueCompressionCCITT4,
    EncoderValueCompressionRle,
    EncoderValueCompressionNone,
    EncoderValueScanMethodInterlaced,
    EncoderValueScanMethodNonInterlaced,
    EncoderValueVersionGif87,
    EncoderValueVersionGif89,
    EncoderValueRenderProgressive,
    EncoderValueRenderNonProgressive,
    EncoderValueTransformRotate90,
    EncoderValueTransformRotate180,
    EncoderValueTransformRotate270,
    EncoderValueTransformFlipHorizontal,
    EncoderValueTransformFlipVertical,
    EncoderValueMultiFrame,
    EncoderValueLastFrame,
    EncoderValueFlush,
    EncoderValueFrameDimensionTime,
    EncoderValueFrameDimensionResolution,
    EncoderValueFrameDimensionPage
  );
  TEncoderValue = EncoderValue;

//---------------------------------------------------------------------------
// Conversion of Emf To WMF Bits flags
//---------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM EmfToWmfBitsFlags}
  EmfToWmfBitsFlags = (
    EmfToWmfBitsFlagsDefault          = $00000000,
    EmfToWmfBitsFlagsEmbedEmf         = $00000001,
    EmfToWmfBitsFlagsIncludePlaceable = $00000002,
    EmfToWmfBitsFlagsNoXORClip        = $00000004
  );
  TEmfToWmfBitsFlags = EmfToWmfBitsFlags;
{$ELSE}
  {$EXTERNALSYM EmfToWmfBitsFlags}
  EmfToWmfBitsFlags = Integer;
  const
    EmfToWmfBitsFlagsDefault          = $00000000;
    EmfToWmfBitsFlagsEmbedEmf         = $00000001;
    EmfToWmfBitsFlagsIncludePlaceable = $00000002;
    EmfToWmfBitsFlagsNoXORClip        = $00000004;
    
type
  TEmfToWmfBitsFlags = EmfToWmfBitsFlags;
{$ENDIF}
(**************************************************************************\
*
*   GDI+ Types
*
\**************************************************************************)

//--------------------------------------------------------------------------
// Callback functions
//--------------------------------------------------------------------------

  {$EXTERNALSYM ImageAbort}
  ImageAbort = function: BOOL; stdcall;
  {$EXTERNALSYM DrawImageAbort}
  DrawImageAbort         = ImageAbort;
  {$EXTERNALSYM GetThumbnailImageAbort}
  GetThumbnailImageAbort = ImageAbort;


  // Callback for EnumerateMetafile methods.  The parameters are:

  //      recordType      WMF, EMF, or EMF+ record type
  //      flags           (always 0 for WMF/EMF records)
  //      dataSize        size of the record data (in bytes), or 0 if no data
  //      data            pointer to the record data, or NULL if no data
  //      callbackData    pointer to callbackData, if any

  // This method can then call Metafile::PlayRecord to play the
  // record that was just enumerated.  If this method  returns
  // FALSE, the enumeration process is aborted.  Otherwise, it continues.

  {$EXTERNALSYM EnumerateMetafileProc}
  EnumerateMetafileProc = function(recordType: EmfPlusRecordType; flags: UINT;
    dataSize: UINT; data: PBYTE; callbackData: pointer): BOOL; stdcall;

//--------------------------------------------------------------------------
// Primitive data types
//
// NOTE:
//  Types already defined in standard header files:
//      INT8
//      UINT8
//      INT16
//      UINT16
//      INT32
//      UINT32
//      INT64
//      UINT64
//
//  Avoid using the following types:
//      LONG - use INT
//      ULONG - use UINT
//      DWORD - use UINT32
//--------------------------------------------------------------------------

const
  { from float.h }
  FLT_MAX =  3.402823466e+38; // max value
  FLT_MIN =  1.175494351e-38; // min positive value

  REAL_MAX           = FLT_MAX;
  {$EXTERNALSYM REAL_MAX}
  REAL_MIN           = FLT_MIN;
  {$EXTERNALSYM REAL_MIN}
  REAL_TOLERANCE     = (FLT_MIN * 100);
  {$EXTERNALSYM REAL_TOLERANCE}
  REAL_EPSILON       = 1.192092896e-07;        // FLT_EPSILON
  {$EXTERNALSYM REAL_EPSILON}

//--------------------------------------------------------------------------
// Status return values from GDI+ methods
//--------------------------------------------------------------------------
type
  {$EXTERNALSYM Status}
  Status = (
    Ok,
    GenericError,
    InvalidParameter,
    OutOfMemory,
    ObjectBusy,
    InsufficientBuffer,
    NotImplemented,
    Win32Error,
    WrongState,
    Aborted,
    FileNotFound,
    ValueOverflow,
    AccessDenied,
    UnknownImageFormat,
    FontFamilyNotFound,
    FontStyleNotFound,
    NotTrueTypeFont,
    UnsupportedGdiplusVersion,
    GdiplusNotInitialized,
    PropertyNotFound,
    PropertyNotSupported
  );
  TStatus = Status;

//--------------------------------------------------------------------------
// Represents a dimension in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

type
  PGPSizeF = ^TGPSizeF;
  TGPSizeF = packed record
    Width  : Single;
    Height : Single;
  end;

  function MakeSize(Width, Height: Single): TGPSizeF; overload;

//--------------------------------------------------------------------------
// Represents a dimension in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

type
  PGPSize = ^TGPSize;
  TGPSize = packed record
    Width  : Integer;
    Height : Integer;
  end;

  function MakeSize(Width, Height: Integer): TGPSize; overload;

//--------------------------------------------------------------------------
// Represents a location in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

type
  PGPPointF = ^TGPPointF;
  TGPPointF = packed record
    X : Single;
    Y : Single;
  end;
  TPointFDynArray = array of TGPPointF;

  function MakePoint(X, Y: Single): TGPPointF; overload;

//--------------------------------------------------------------------------
// Represents a location in a 2D coordinate system (integer coordinates)
//--------------------------------------------------------------------------

type
  PGPPoint = ^TGPPoint;
  TGPPoint = packed record
    X : Integer;
    Y : Integer;
  end;
  TPointDynArray = array of TGPPoint;

  function MakePoint(X, Y: Integer): TGPPoint; overload;

//--------------------------------------------------------------------------
// Represents a rectangle in a 2D coordinate system (floating-point coordinates)
//--------------------------------------------------------------------------

type
  PGPRectF = ^TGPRectF;
  TGPRectF = packed record
    X     : Single;
    Y     : Single;
    Width : Single;
    Height: Single;
  end;
  TRectFDynArray = array of TGPRectF;

  function MakeRect(x, y, width, height: Single): TGPRectF; overload;
  function MakeRect(location: TGPPointF; size: TGPSizeF): TGPRectF; overload;

type
  PGPRect = ^TGPRect;
  TGPRect = packed record
    X     : Integer;
    Y     : Integer;
    Width : Integer;
    Height: Integer;
  end;
  TRectDynArray = array of TGPRect;

  function MakeRect(x, y, width, height: Integer): TGPRect; overload;
  function MakeRect(location: TGPPoint; size: TGPSize): TGPRect; overload;
  function MakeRect(const Rect: TRect): TGPRect; overload;

type
  TPathData = packed class
  public
    Count  : Integer;
    Points : PGPPointF;
    Types  : PBYTE;
    constructor Create;
    destructor destroy; override;
  end;

  PCharacterRange = ^TCharacterRange;
  TCharacterRange = packed record
    First  : Integer;
    Length : Integer;
  end;

  function MakeCharacterRange(First, Length: Integer): TCharacterRange;

(**************************************************************************
*
*   GDI+ Startup and Shutdown APIs
*
**************************************************************************)
type
  {$EXTERNALSYM DebugEventLevel}
  DebugEventLevel = (
    DebugEventLevelFatal,
    DebugEventLevelWarning
  );
  TDebugEventLevel = DebugEventLevel;

  // Callback function that GDI+ can call, on debug builds, for assertions
  // and warnings.

  {$EXTERNALSYM DebugEventProc}
  DebugEventProc = procedure(level: DebugEventLevel; message: PChar); stdcall;

  // Notification functions which the user must call appropriately if
  // "SuppressBackgroundThread" (below) is set.

  {$EXTERNALSYM NotificationHookProc}
  NotificationHookProc = function(out token: ULONG): Status; stdcall;
  {$EXTERNALSYM NotificationUnhookProc}
  NotificationUnhookProc = procedure(token: ULONG); stdcall;

  // Input structure for GdiplusStartup

  {$EXTERNALSYM GdiplusStartupInput}
  GdiplusStartupInput = packed record
    GdiplusVersion          : Cardinal;       // Must be 1
    DebugEventCallback      : DebugEventProc; // Ignored on free builds
    SuppressBackgroundThread: BOOL;           // FALSE unless you're prepared to call
                                              // the hook/unhook functions properly
    SuppressExternalCodecs  : BOOL;           // FALSE unless you want GDI+ only to use
  end;                                        // its internal image codecs.
  TGdiplusStartupInput = GdiplusStartupInput;
  PGdiplusStartupInput = ^TGdiplusStartupInput;

  // Output structure for GdiplusStartup()

  {$EXTERNALSYM GdiplusStartupOutput}
  GdiplusStartupOutput = packed record
    // The following 2 fields are NULL if SuppressBackgroundThread is FALSE.
    // Otherwise, they are functions which must be called appropriately to
    // replace the background thread.
    //
    // These should be called on the application's main message loop - i.e.
    // a message loop which is active for the lifetime of GDI+.
    // "NotificationHook" should be called before starting the loop,
    // and "NotificationUnhook" should be called after the loop ends.

    NotificationHook  : NotificationHookProc;
    NotificationUnhook: NotificationUnhookProc;
  end;
  TGdiplusStartupOutput = GdiplusStartupOutput;
  PGdiplusStartupOutput = ^TGdiplusStartupOutput;

  // GDI+ initialization. Must not be called from DllMain - can cause deadlock.
  //
  // Must be called before GDI+ API's or constructors are used.
  //
  // token  - may not be NULL - accepts a token to be passed in the corresponding
  //          GdiplusShutdown call.
  // input  - may not be NULL
  // output - may be NULL only if input->SuppressBackgroundThread is FALSE.

  {$EXTERNALSYM GdiplusStartup}
 function GdiplusStartup(out token: ULONG; input: PGdiplusStartupInput;
   output: PGdiplusStartupOutput): Status; stdcall;

  // GDI+ termination. Must be called before GDI+ is unloaded.
  // Must not be called from DllMain - can cause deadlock.
  //
  // GDI+ API's may not be called after GdiplusShutdown. Pay careful attention
  // to GDI+ object destructors.

  {$EXTERNALSYM GdiplusShutdown}
  procedure GdiplusShutdown(token: ULONG); stdcall;


(**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
* Module Name:
*   Gdiplus Pixel Formats
* Abstract:
*   GDI+ Pixel Formats
*
\**************************************************************************)

type
  PARGB  = ^ARGB;
  ARGB   = DWORD;
  {$EXTERNALSYM ARGB}
  ARGB64 = Int64;
  {$EXTERNALSYM ARGB64}

const
  ALPHA_SHIFT = 24;
  {$EXTERNALSYM ALPHA_SHIFT}
  RED_SHIFT   = 16;
  {$EXTERNALSYM RED_SHIFT}
  GREEN_SHIFT = 8;
  {$EXTERNALSYM GREEN_SHIFT}
  BLUE_SHIFT  = 0;
  {$EXTERNALSYM BLUE_SHIFT}
  ALPHA_MASK  = (ARGB($ff) shl ALPHA_SHIFT);
  {$EXTERNALSYM ALPHA_MASK}

  // In-memory pixel data formats:
  // bits 0-7 = format index
  // bits 8-15 = pixel size (in bits)
  // bits 16-23 = flags
  // bits 24-31 = reserved

type
  PixelFormat = Integer;
  {$EXTERNALSYM PixelFormat}
  TPixelFormat = PixelFormat;

const
  PixelFormatIndexed     = $00010000; // Indexes into a palette
  {$EXTERNALSYM PixelFormatIndexed}
  PixelFormatGDI         = $00020000; // Is a GDI-supported format
  {$EXTERNALSYM PixelFormatGDI}
  PixelFormatAlpha       = $00040000; // Has an alpha component
  {$EXTERNALSYM PixelFormatAlpha}
  PixelFormatPAlpha      = $00080000; // Pre-multiplied alpha
  {$EXTERNALSYM PixelFormatPAlpha}
  PixelFormatExtended    = $00100000; // Extended color 16 bits/channel
  {$EXTERNALSYM PixelFormatExtended}
  PixelFormatCanonical   = $00200000;
  {$EXTERNALSYM PixelFormatCanonical}

  PixelFormatUndefined      = 0;
  {$EXTERNALSYM PixelFormatUndefined}
  PixelFormatDontCare       = 0;
  {$EXTERNALSYM PixelFormatDontCare}

  PixelFormat1bppIndexed    = (1  or ( 1 shl 8) or PixelFormatIndexed or PixelFormatGDI);
  {$EXTERNALSYM PixelFormat1bppIndexed}
  PixelFormat4bppIndexed    = (2  or ( 4 shl 8) or PixelFormatIndexed or PixelFormatGDI);
  {$EXTERNALSYM PixelFormat4bppIndexed}
  PixelFormat8bppIndexed    = (3  or ( 8 shl 8) or PixelFormatIndexed or PixelFormatGDI);
  {$EXTERNALSYM PixelFormat8bppIndexed}
  PixelFormat16bppGrayScale = (4  or (16 shl 8) or PixelFormatExtended);
  {$EXTERNALSYM PixelFormat16bppGrayScale}
  PixelFormat16bppRGB555    = (5  or (16 shl 8) or PixelFormatGDI);
  {$EXTERNALSYM PixelFormat16bppRGB555}
  PixelFormat16bppRGB565    = (6  or (16 shl 8) or PixelFormatGDI);
  {$EXTERNALSYM PixelFormat16bppRGB565}
  PixelFormat16bppARGB1555  = (7  or (16 shl 8) or PixelFormatAlpha or PixelFormatGDI);
  {$EXTERNALSYM PixelFormat16bppARGB1555}
  PixelFormat24bppRGB       = (8  or (24 shl 8) or PixelFormatGDI);
  {$EXTERNALSYM PixelFormat24bppRGB}
  PixelFormat32bppRGB       = (9  or (32 shl 8) or PixelFormatGDI);
  {$EXTERNALSYM PixelFormat32bppRGB}
  PixelFormat32bppARGB      = (10 or (32 shl 8) or PixelFormatAlpha or PixelFormatGDI or PixelFormatCanonical);
  {$EXTERNALSYM PixelFormat32bppARGB}
  PixelFormat32bppPARGB     = (11 or (32 shl 8) or PixelFormatAlpha or PixelFormatPAlpha or PixelFormatGDI);
  {$EXTERNALSYM PixelFormat32bppPARGB}
  PixelFormat48bppRGB       = (12 or (48 shl 8) or PixelFormatExtended);
  {$EXTERNALSYM PixelFormat48bppRGB}
  PixelFormat64bppARGB      = (13 or (64 shl 8) or PixelFormatAlpha  or PixelFormatCanonical or PixelFormatExtended);
  {$EXTERNALSYM PixelFormat64bppARGB}
  PixelFormat64bppPARGB     = (14 or (64 shl 8) or PixelFormatAlpha  or PixelFormatPAlpha or PixelFormatExtended);
  {$EXTERNALSYM PixelFormat64bppPARGB}
  PixelFormatMax            = 15;
  {$EXTERNALSYM PixelFormatMax}

{$EXTERNALSYM GetPixelFormatSize}
function GetPixelFormatSize(pixfmt: PixelFormat): UINT;
{$EXTERNALSYM IsIndexedPixelFormat}
function IsIndexedPixelFormat(pixfmt: PixelFormat): BOOL;
{$EXTERNALSYM IsAlphaPixelFormat}
function IsAlphaPixelFormat(pixfmt: PixelFormat): BOOL;
{$EXTERNALSYM IsExtendedPixelFormat}
function IsExtendedPixelFormat(pixfmt: PixelFormat): BOOL;

//--------------------------------------------------------------------------
// Determine if the Pixel Format is Canonical format:
//   PixelFormat32bppARGB
//   PixelFormat32bppPARGB
//   PixelFormat64bppARGB
//   PixelFormat64bppPARGB
//--------------------------------------------------------------------------

{$EXTERNALSYM IsCanonicalPixelFormat}
function IsCanonicalPixelFormat(pixfmt: PixelFormat): BOOL;

{$IFDEF DELPHI6_UP}
type
  {$EXTERNALSYM PaletteFlags}
  PaletteFlags = (
    PaletteFlagsHasAlpha    = $0001,
    PaletteFlagsGrayScale   = $0002,
    PaletteFlagsHalftone    = $0004
  );
  TPaletteFlags = PaletteFlags;
{$ELSE}
type
  {$EXTERNALSYM PaletteFlags}
  PaletteFlags = Integer;
  const
    PaletteFlagsHasAlpha    = $0001;
    PaletteFlagsGrayScale   = $0002;
    PaletteFlagsHalftone    = $0004;

type
  TPaletteFlags = PaletteFlags;
{$ENDIF}

  {$EXTERNALSYM ColorPalette}
  ColorPalette = packed record
    Flags  : UINT ;                 // Palette flags
    Count  : UINT ;                 // Number of color entries
    Entries: array [0..0] of ARGB ; // Palette color entries
  end;

  TColorPalette = ColorPalette;
  PColorPalette = ^TColorPalette;

(**************************************************************************\
*
*   GDI+ Color Object
*
\**************************************************************************)

//----------------------------------------------------------------------------
// Color mode
//----------------------------------------------------------------------------

  {$EXTERNALSYM ColorMode}
  ColorMode = (
    ColorModeARGB32,
    ColorModeARGB64
  );
  TColorMode = ColorMode;

//----------------------------------------------------------------------------
// Color Channel flags 
//----------------------------------------------------------------------------

  {$EXTERNALSYM ColorChannelFlags}
  ColorChannelFlags = (
    ColorChannelFlagsC,
    ColorChannelFlagsM,
    ColorChannelFlagsY,
    ColorChannelFlagsK,
    ColorChannelFlagsLast
  );
  TColorChannelFlags = ColorChannelFlags;

//----------------------------------------------------------------------------
// Color
//----------------------------------------------------------------------------

  // Common color constants
const
  aclAliceBlue            = $FFF0F8FF;
  aclAntiqueWhite         = $FFFAEBD7;
  aclAqua                 = $FF00FFFF;
  aclAquamarine           = $FF7FFFD4;
  aclAzure                = $FFF0FFFF;
  aclBeige                = $FFF5F5DC;
  aclBisque               = $FFFFE4C4;
  aclBlack                = $FF000000;
  aclBlanchedAlmond       = $FFFFEBCD;
  aclBlue                 = $FF0000FF;
  aclBlueViolet           = $FF8A2BE2;
  aclBrown                = $FFA52A2A;
  aclBurlyWood            = $FFDEB887;
  aclCadetBlue            = $FF5F9EA0;
  aclChartreuse           = $FF7FFF00;
  aclChocolate            = $FFD2691E;
  aclCoral                = $FFFF7F50;
  aclCornflowerBlue       = $FF6495ED;
  aclCornsilk             = $FFFFF8DC;
  aclCrimson              = $FFDC143C;
  aclCyan                 = $FF00FFFF;
  aclDarkBlue             = $FF00008B;
  aclDarkCyan             = $FF008B8B;
  aclDarkGoldenrod        = $FFB8860B;
  aclDarkGray             = $FFA9A9A9;
  aclDarkGreen            = $FF006400;
  aclDarkKhaki            = $FFBDB76B;
  aclDarkMagenta          = $FF8B008B;
  aclDarkOliveGreen       = $FF556B2F;
  aclDarkOrange           = $FFFF8C00;
  aclDarkOrchid           = $FF9932CC;
  aclDarkRed              = $FF8B0000;
  aclDarkSalmon           = $FFE9967A;
  aclDarkSeaGreen         = $FF8FBC8B;
  aclDarkSlateBlue        = $FF483D8B;
  aclDarkSlateGray        = $FF2F4F4F;
  aclDarkTurquoise        = $FF00CED1;
  aclDarkViolet           = $FF9400D3;
  aclDeepPink             = $FFFF1493;
  aclDeepSkyBlue          = $FF00BFFF;
  aclDimGray              = $FF696969;
  aclDodgerBlue           = $FF1E90FF;
  aclFirebrick            = $FFB22222;
  aclFloralWhite          = $FFFFFAF0;
  aclForestGreen          = $FF228B22;
  aclFuchsia              = $FFFF00FF;
  aclGainsboro            = $FFDCDCDC;
  aclGhostWhite           = $FFF8F8FF;
  aclGold                 = $FFFFD700;
  aclGoldenrod            = $FFDAA520;
  aclGray                 = $FF808080;
  aclGreen                = $FF008000;
  aclGreenYellow          = $FFADFF2F;
  aclHoneydew             = $FFF0FFF0;
  aclHotPink              = $FFFF69B4;
  aclIndianRed            = $FFCD5C5C;
  aclIndigo               = $FF4B0082;
  aclIvory                = $FFFFFFF0;
  aclKhaki                = $FFF0E68C;
  aclLavender             = $FFE6E6FA;
  aclLavenderBlush        = $FFFFF0F5;
  aclLawnGreen            = $FF7CFC00;
  aclLemonChiffon         = $FFFFFACD;
  aclLightBlue            = $FFADD8E6;
  aclLightCoral           = $FFF08080;
  aclLightCyan            = $FFE0FFFF;
  aclLightGoldenrodYellow = $FFFAFAD2;
  aclLightGray            = $FFD3D3D3;
  aclLightGreen           = $FF90EE90;
  aclLightPink            = $FFFFB6C1;
  aclLightSalmon          = $FFFFA07A;
  aclLightSeaGreen        = $FF20B2AA;
  aclLightSkyBlue         = $FF87CEFA;
  aclLightSlateGray       = $FF778899;
  aclLightSteelBlue       = $FFB0C4DE;
  aclLightYellow          = $FFFFFFE0;
  aclLime                 = $FF00FF00;
  aclLimeGreen            = $FF32CD32;
  aclLinen                = $FFFAF0E6;
  aclMagenta              = $FFFF00FF;
  aclMaroon               = $FF800000;
  aclMediumAquamarine     = $FF66CDAA;
  aclMediumBlue           = $FF0000CD;
  aclMediumOrchid         = $FFBA55D3;
  aclMediumPurple         = $FF9370DB;
  aclMediumSeaGreen       = $FF3CB371;
  aclMediumSlateBlue      = $FF7B68EE;
  aclMediumSpringGreen    = $FF00FA9A;
  aclMediumTurquoise      = $FF48D1CC;
  aclMediumVioletRed      = $FFC71585;
  aclMidnightBlue         = $FF191970;
  aclMintCream            = $FFF5FFFA;
  aclMistyRose            = $FFFFE4E1;
  aclMoccasin             = $FFFFE4B5;
  aclNavajoWhite          = $FFFFDEAD;
  aclNavy                 = $FF000080;
  aclOldLace              = $FFFDF5E6;
  aclOlive                = $FF808000;
  aclOliveDrab            = $FF6B8E23;
  aclOrange               = $FFFFA500;
  aclOrangeRed            = $FFFF4500;
  aclOrchid               = $FFDA70D6;
  aclPaleGoldenrod        = $FFEEE8AA;
  aclPaleGreen            = $FF98FB98;
  aclPaleTurquoise        = $FFAFEEEE;
  aclPaleVioletRed        = $FFDB7093;
  aclPapayaWhip           = $FFFFEFD5;
  aclPeachPuff            = $FFFFDAB9;
  aclPeru                 = $FFCD853F;
  aclPink                 = $FFFFC0CB;
  aclPlum                 = $FFDDA0DD;
  aclPowderBlue           = $FFB0E0E6;
  aclPurple               = $FF800080;
  aclRed                  = $FFFF0000;
  aclRosyBrown            = $FFBC8F8F;
  aclRoyalBlue            = $FF4169E1;
  aclSaddleBrown          = $FF8B4513;
  aclSalmon               = $FFFA8072;
  aclSandyBrown           = $FFF4A460;
  aclSeaGreen             = $FF2E8B57;
  aclSeaShell             = $FFFFF5EE;
  aclSienna               = $FFA0522D;
  aclSilver               = $FFC0C0C0;
  aclSkyBlue              = $FF87CEEB;
  aclSlateBlue            = $FF6A5ACD;
  aclSlateGray            = $FF708090;
  aclSnow                 = $FFFFFAFA;
  aclSpringGreen          = $FF00FF7F;
  aclSteelBlue            = $FF4682B4;
  aclTan                  = $FFD2B48C;
  aclTeal                 = $FF008080;
  aclThistle              = $FFD8BFD8;
  aclTomato               = $FFFF6347;
  aclTransparent          = $00FFFFFF;
  aclTurquoise            = $FF40E0D0;
  aclViolet               = $FFEE82EE;
  aclWheat                = $FFF5DEB3;
  aclWhite                = $FFFFFFFF;
  aclWhiteSmoke           = $FFF5F5F5;
  aclYellow               = $FFFFFF00;
  aclYellowGreen          = $FF9ACD32;

  // Shift count and bit mask for A, R, G, B components
  AlphaShift  = 24;
  {$EXTERNALSYM AlphaShift}
  RedShift    = 16;
  {$EXTERNALSYM RedShift}
  GreenShift  = 8;
  {$EXTERNALSYM GreenShift}
  BlueShift   = 0;
  {$EXTERNALSYM BlueShift}

  AlphaMask   = $ff000000;
  {$EXTERNALSYM AlphaMask}
  RedMask     = $00ff0000;
  {$EXTERNALSYM RedMask}
  GreenMask   = $0000ff00;
  {$EXTERNALSYM GreenMask}
  BlueMask    = $000000ff;
  {$EXTERNALSYM BlueMask}


type
{  TGPColor = class
  protected
     Argb: ARGB;
  public
    constructor Create; overload;
    constructor Create(r, g, b: Byte); overload;
    constructor Create(a, r, g, b: Byte); overload;
    constructor Create(Value: ARGB); overload;
    function GetAlpha: BYTE;
    function GetA: BYTE;
    function GetRed: BYTE;
    function GetR: BYTE;
    function GetGreen: Byte;
    function GetG: Byte;
    function GetBlue: Byte;
    function GetB: Byte;
    function GetValue: ARGB;
    procedure SetValue(Value: ARGB);
    procedure SetFromCOLORREF(rgb: COLORREF);
    function ToCOLORREF: COLORREF;
    function MakeARGB(a, r, g, b: Byte): ARGB;
  end;  }

  PGPColor = ^TGPColor;
  TGPColor = ARGB;
  TColorDynArray = array of TGPColor;

  function MakeColor(r, g, b: Byte): ARGB; overload;
  function MakeColor(a, r, g, b: Byte): ARGB; overload;
  function GetAlpha(color: ARGB): BYTE;
  function GetRed(color: ARGB): BYTE;
  function GetGreen(color: ARGB): BYTE;
  function GetBlue(color: ARGB): BYTE;
  function ColorRefToARGB(rgb: COLORREF): ARGB;
  function ARGBToColorRef(Color: ARGB): COLORREF;


(**************************************************************************\
*
*   GDI+ Metafile Related Structures
*
\**************************************************************************)

type
  { from Windef.h }
  RECTL = Windows.TRect;
  SIZEL = Windows.TSize;

  {$EXTERNALSYM ENHMETAHEADER3}
  ENHMETAHEADER3 = packed record
    iType          : DWORD;  // Record type EMR_HEADER
    nSize          : DWORD;  // Record size in bytes.  This may be greater
                             // than the sizeof(ENHMETAHEADER).
    rclBounds      : RECTL;  // Inclusive-inclusive bounds in device units
    rclFrame       : RECTL;  // Inclusive-inclusive Picture Frame .01mm unit
    dSignature     : DWORD;  // Signature.  Must be ENHMETA_SIGNATURE.
    nVersion       : DWORD;  // Version number
    nBytes         : DWORD;  // Size of the metafile in bytes
    nRecords       : DWORD;  // Number of records in the metafile
    nHandles       : WORD;   // Number of handles in the handle table
                             // Handle index zero is reserved.
    sReserved      : WORD;   // Reserved.  Must be zero.
    nDescription   : DWORD;  // Number of chars in the unicode desc string
                             // This is 0 if there is no description string
    offDescription : DWORD;  // Offset to the metafile description record.
                             // This is 0 if there is no description string
    nPalEntries    : DWORD;  // Number of entries in the metafile palette.
    szlDevice      : SIZEL;  // Size of the reference device in pels
    szlMillimeters : SIZEL;  // Size of the reference device in millimeters
  end;
  TENHMETAHEADER3 = ENHMETAHEADER3;
  PENHMETAHEADER3 = ^TENHMETAHEADER3;

  // Placeable WMFs

  // Placeable Metafiles were created as a non-standard way of specifying how
  // a metafile is mapped and scaled on an output device.
  // Placeable metafiles are quite wide-spread, but not directly supported by
  // the Windows API. To playback a placeable metafile using the Windows API,
  // you will first need to strip the placeable metafile header from the file.
  // This is typically performed by copying the metafile to a temporary file
  // starting at file offset 22 (0x16). The contents of the temporary file may
  // then be used as input to the Windows GetMetaFile(), PlayMetaFile(),
  // CopyMetaFile(), etc. GDI functions.

  // Each placeable metafile begins with a 22-byte header,
  //  followed by a standard metafile:

  {$EXTERNALSYM PWMFRect16}
  PWMFRect16 = packed record
    Left   : INT16;
    Top    : INT16;
    Right  : INT16;
    Bottom : INT16;
  end;
  TPWMFRect16 = PWMFRect16;
  PPWMFRect16 = ^TPWMFRect16;

  {$EXTERNALSYM WmfPlaceableFileHeader}
  WmfPlaceableFileHeader = packed record
    Key         : UINT32;      // GDIP_WMF_PLACEABLEKEY
    Hmf         : INT16;       // Metafile HANDLE number (always 0)
    BoundingBox : PWMFRect16;  // Coordinates in metafile units
    Inch        : INT16;       // Number of metafile units per inch
    Reserved    : UINT32;      // Reserved (always 0)
    Checksum    : INT16;       // Checksum value for previous 10 WORDs
  end;
  TWmfPlaceableFileHeader = WmfPlaceableFileHeader;
  PWmfPlaceableFileHeader = ^TWmfPlaceableFileHeader;

  // Key contains a special identification value that indicates the presence
  // of a placeable metafile header and is always 0x9AC6CDD7.

  // Handle is used to stored the handle of the metafile in memory. When written
  // to disk, this field is not used and will always contains the value 0.

  // Left, Top, Right, and Bottom contain the coordinates of the upper-left
  // and lower-right corners of the image on the output device. These are
  // measured in twips.

  // A twip (meaning "twentieth of a point") is the logical unit of measurement
  // used in Windows Metafiles. A twip is equal to 1/1440 of an inch. Thus 720
  // twips equal 1/2 inch, while 32,768 twips is 22.75 inches.

  // Inch contains the number of twips per inch used to represent the image.
  // Normally, there are 1440 twips per inch; however, this number may be
  // changed to scale the image. A value of 720 indicates that the image is
  // double its normal size, or scaled to a factor of 2:1. A value of 360
  // indicates a scale of 4:1, while a value of 2880 indicates that the image
  // is scaled down in size by a factor of two. A value of 1440 indicates
  // a 1:1 scale ratio.

  // Reserved is not used and is always set to 0.

  // Checksum contains a checksum value for the previous 10 WORDs in the header.
  // This value can be used in an attempt to detect if the metafile has become
  // corrupted. The checksum is calculated by XORing each WORD value to an
  // initial value of 0.

  // If the metafile was recorded with a reference Hdc that was a display.

const
  GDIP_EMFPLUSFLAGS_DISPLAY      = $00000001;
  {$EXTERNALSYM GDIP_EMFPLUSFLAGS_DISPLAY}

type
  TMetafileHeader = packed class
  public
    Type_        : TMetafileType;
    Size         : UINT;           // Size of the metafile (in bytes)
    Version      : UINT;           // EMF+, EMF, or WMF version
    EmfPlusFlags : UINT;
    DpiX         : Single;
    DpiY         : Single;
    X            : Integer;        // Bounds in device units
    Y            : Integer;
    Width        : Integer;
    Height       : Integer;
    Header       : record
    case integer of
      0: (WmfHeader: TMETAHEADER;);
      1: (EmfHeader: TENHMETAHEADER3);
    end;
    EmfPlusHeaderSize : Integer; // size of the EMF+ header in file
    LogicalDpiX       : Integer; // Logical Dpi of reference Hdc
    LogicalDpiY       : Integer; // usually valid only for EMF+
  public
    property GetType: TMetafileType read Type_;
    property GetMetafileSize: UINT read Size;
    // If IsEmfPlus, this is the EMF+ version; else it is the WMF or EMF ver
    property GetVersion: UINT read Version;
     // Get the EMF+ flags associated with the metafile
    property GetEmfPlusFlags: UINT read EmfPlusFlags;
    property GetDpiX: Single read DpiX;
    property GetDpiY: Single read DpiY;
    procedure GetBounds(out Rect: TGPRect);
    // Is it any type of WMF (standard or Placeable Metafile)?
    function IsWmf: BOOL;
    // Is this an Placeable Metafile?
    function IsWmfPlaceable: BOOL;
    // Is this an EMF (not an EMF+)?
    function IsEmf: BOOL;
    // Is this an EMF or EMF+ file?
    function IsEmfOrEmfPlus: BOOL;
    // Is this an EMF+ file?
    function IsEmfPlus: BOOL;
    // Is this an EMF+ dual (has dual, down-level records) file?
    function IsEmfPlusDual: BOOL;
    // Is this an EMF+ only (no dual records) file?
    function IsEmfPlusOnly: BOOL;
    // If it's an EMF+ file, was it recorded against a display Hdc?
    function IsDisplay: BOOL;
    // Get the WMF header of the metafile (if it is a WMF)
    function GetWmfHeader: PMetaHeader;
    // Get the EMF header of the metafile (if it is an EMF)
    function GetEmfHeader: PENHMETAHEADER3;
  end;

(**************************************************************************\
*
*   GDI+ Imaging GUIDs
*
\**************************************************************************)

//---------------------------------------------------------------------------
// Image file format identifiers
//---------------------------------------------------------------------------

const
  ImageFormatUndefined : TGUID = '{b96b3ca9-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatUndefined}
  ImageFormatMemoryBMP : TGUID = '{b96b3caa-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatMemoryBMP}
  ImageFormatBMP       : TGUID = '{b96b3cab-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatBMP}
  ImageFormatEMF       : TGUID = '{b96b3cac-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatEMF}
  ImageFormatWMF       : TGUID = '{b96b3cad-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatWMF}
  ImageFormatJPEG      : TGUID = '{b96b3cae-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatJPEG}
  ImageFormatPNG       : TGUID = '{b96b3caf-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatPNG}
  ImageFormatGIF       : TGUID = '{b96b3cb0-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatGIF}
  ImageFormatTIFF      : TGUID = '{b96b3cb1-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatTIFF}
  ImageFormatEXIF      : TGUID = '{b96b3cb2-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatEXIF}
  ImageFormatIcon      : TGUID = '{b96b3cb5-0728-11d3-9d7b-0000f81ef32e}';
  {$EXTERNALSYM ImageFormatIcon}

//---------------------------------------------------------------------------
// Predefined multi-frame dimension IDs
//---------------------------------------------------------------------------

  FrameDimensionTime       : TGUID = '{6aedbd6d-3fb5-418a-83a6-7f45229dc872}';
  {$EXTERNALSYM FrameDimensionTime}
  FrameDimensionResolution : TGUID = '{84236f7b-3bd3-428f-8dab-4ea1439ca315}';
  {$EXTERNALSYM FrameDimensionResolution}
  FrameDimensionPage       : TGUID = '{7462dc86-6180-4c7e-8e3f-ee7333a7a483}';
  {$EXTERNALSYM FrameDimensionPage}

//---------------------------------------------------------------------------
// Property sets
//---------------------------------------------------------------------------

  FormatIDImageInformation : TGUID = '{e5836cbe-5eef-4f1d-acde-ae4c43b608ce}';
  {$EXTERNALSYM FormatIDImageInformation}
  FormatIDJpegAppHeaders   : TGUID = '{1c4afdcd-6177-43cf-abc7-5f51af39ee85}';
  {$EXTERNALSYM FormatIDJpegAppHeaders}

//---------------------------------------------------------------------------
// Encoder parameter sets
//---------------------------------------------------------------------------

  EncoderCompression      : TGUID = '{e09d739d-ccd4-44ee-8eba-3fbf8be4fc58}';
  {$EXTERNALSYM EncoderCompression}
  EncoderColorDepth       : TGUID = '{66087055-ad66-4c7c-9a18-38a2310b8337}';
  {$EXTERNALSYM EncoderColorDepth}
  EncoderScanMethod       : TGUID = '{3a4e2661-3109-4e56-8536-42c156e7dcfa}';
  {$EXTERNALSYM EncoderScanMethod}
  EncoderVersion          : TGUID = '{24d18c76-814a-41a4-bf53-1c219cccf797}';
  {$EXTERNALSYM EncoderVersion}
  EncoderRenderMethod     : TGUID = '{6d42c53a-229a-4825-8bb7-5c99e2b9a8b8}';
  {$EXTERNALSYM EncoderRenderMethod}
  EncoderQuality          : TGUID = '{1d5be4b5-fa4a-452d-9cdd-5db35105e7eb}';
  {$EXTERNALSYM EncoderQuality}
  EncoderTransformation   : TGUID = '{8d0eb2d1-a58e-4ea8-aa14-108074b7b6f9}';
  {$EXTERNALSYM EncoderTransformation}
  EncoderLuminanceTable   : TGUID = '{edb33bce-0266-4a77-b904-27216099e717}';
  {$EXTERNALSYM EncoderLuminanceTable}
  EncoderChrominanceTable : TGUID = '{f2e455dc-09b3-4316-8260-676ada32481c}';
  {$EXTERNALSYM EncoderChrominanceTable}
  EncoderSaveFlag         : TGUID = '{292266fc-ac40-47bf-8cfc-a85b89a655de}';
  {$EXTERNALSYM EncoderSaveFlag}

  CodecIImageBytes : TGUID = '{025d1823-6c7d-447b-bbdb-a3cbc3dfa2fc}';
  {$EXTERNALSYM CodecIImageBytes}

type
  {$EXTERNALSYM IImageBytes}
  IImageBytes = Interface(IUnknown)
    ['{025D1823-6C7D-447B-BBDB-A3CBC3DFA2FC}']
    // Return total number of bytes in the IStream
    function CountBytes(out pcb: UINT): HRESULT; stdcall;
    // Locks "cb" bytes, starting from "ulOffset" in the stream, and returns the
    // pointer to the beginning of the locked memory chunk in "ppvBytes"
    function LockBytes(cb: UINT; ulOffset: ULONG; out ppvBytes: pointer): HRESULT; stdcall;
    // Unlocks "cb" bytes, pointed by "pvBytes", starting from "ulOffset" in the
    // stream
    function UnlockBytes(pvBytes: pointer; cb: UINT; ulOffset: ULONG): HRESULT; stdcall;
  end;

//--------------------------------------------------------------------------
// ImageCodecInfo structure
//--------------------------------------------------------------------------

  {$EXTERNALSYM ImageCodecInfo}
  ImageCodecInfo = packed record
    Clsid             : TGUID;
    FormatID          : TGUID;
    CodecName         : PWCHAR;
    DllName           : PWCHAR;
    FormatDescription : PWCHAR;
    FilenameExtension : PWCHAR;
    MimeType          : PWCHAR;
    Flags             : DWORD;
    Version           : DWORD;
    SigCount          : DWORD;
    SigSize           : DWORD;
    SigPattern        : PBYTE;
    SigMask           : PBYTE;
  end;
  TImageCodecInfo = ImageCodecInfo;
  PImageCodecInfo = ^TImageCodecInfo;

//--------------------------------------------------------------------------
// Information flags about image codecs
//--------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM ImageCodecFlags}
  ImageCodecFlags = (
    ImageCodecFlagsEncoder            = $00000001,
    ImageCodecFlagsDecoder            = $00000002,
    ImageCodecFlagsSupportBitmap      = $00000004,
    ImageCodecFlagsSupportVector      = $00000008,
    ImageCodecFlagsSeekableEncode     = $00000010,
    ImageCodecFlagsBlockingDecode     = $00000020,

    ImageCodecFlagsBuiltin            = $00010000,
    ImageCodecFlagsSystem             = $00020000,
    ImageCodecFlagsUser               = $00040000
  );
  TImageCodecFlags = ImageCodecFlags;
{$ELSE}
  {$EXTERNALSYM ImageCodecFlags}
  ImageCodecFlags = Integer;
  const
    ImageCodecFlagsEncoder            = $00000001;
    ImageCodecFlagsDecoder            = $00000002;
    ImageCodecFlagsSupportBitmap      = $00000004;
    ImageCodecFlagsSupportVector      = $00000008;
    ImageCodecFlagsSeekableEncode     = $00000010;
    ImageCodecFlagsBlockingDecode     = $00000020;

    ImageCodecFlagsBuiltin            = $00010000;
    ImageCodecFlagsSystem             = $00020000;
    ImageCodecFlagsUser               = $00040000;

type
  TImageCodecFlags = ImageCodecFlags;
{$ENDIF}
//---------------------------------------------------------------------------
// Access modes used when calling Image::LockBits
//---------------------------------------------------------------------------

  {$EXTERNALSYM ImageLockMode}
  ImageLockMode = Integer;
  const
    ImageLockModeRead         = $0001;
    ImageLockModeWrite        = $0002;
    ImageLockModeUserInputBuf = $0004;
type
  TImageLockMode = ImageLockMode;

//---------------------------------------------------------------------------
// Information about image pixel data
//---------------------------------------------------------------------------

  {$EXTERNALSYM BitmapData}
  BitmapData = packed record
    Width       : UINT;
    Height      : UINT;
    Stride      : Integer;
    PixelFormat : PixelFormat;
    Scan0       : Pointer;
    Reserved    : UINT;
  end;
  TBitmapData = BitmapData;
  PBitmapData = ^TBitmapData;

//---------------------------------------------------------------------------
// Image flags
//---------------------------------------------------------------------------
{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM ImageFlags}
  ImageFlags = (
    ImageFlagsNone                = 0,

    // Low-word: shared with SINKFLAG_x

    ImageFlagsScalable            = $0001,
    ImageFlagsHasAlpha            = $0002,
    ImageFlagsHasTranslucent      = $0004,
    ImageFlagsPartiallyScalable   = $0008,

    // Low-word: color space definition

    ImageFlagsColorSpaceRGB       = $0010,
    ImageFlagsColorSpaceCMYK      = $0020,
    ImageFlagsColorSpaceGRAY      = $0040,
    ImageFlagsColorSpaceYCBCR     = $0080,
    ImageFlagsColorSpaceYCCK      = $0100,

    // Low-word: image size info

    ImageFlagsHasRealDPI          = $1000,
    ImageFlagsHasRealPixelSize    = $2000,

    // High-word

    ImageFlagsReadOnly            = $00010000,
    ImageFlagsCaching             = $00020000
  );
  TImageFlags = ImageFlags;
{$ELSE}
  {$EXTERNALSYM ImageFlags}
  ImageFlags = Integer;
  const
    ImageFlagsNone                = 0;

    // Low-word: shared with SINKFLAG_x

    ImageFlagsScalable            = $0001;
    ImageFlagsHasAlpha            = $0002;
    ImageFlagsHasTranslucent      = $0004;
    ImageFlagsPartiallyScalable   = $0008;

    // Low-word: color space definition

    ImageFlagsColorSpaceRGB       = $0010;
    ImageFlagsColorSpaceCMYK      = $0020;
    ImageFlagsColorSpaceGRAY      = $0040;
    ImageFlagsColorSpaceYCBCR     = $0080;
    ImageFlagsColorSpaceYCCK      = $0100;

    // Low-word: image size info

    ImageFlagsHasRealDPI          = $1000;
    ImageFlagsHasRealPixelSize    = $2000;

    // High-word

    ImageFlagsReadOnly            = $00010000;
    ImageFlagsCaching             = $00020000;

type
  TImageFlags = ImageFlags;
{$ENDIF}


{$IFDEF DELPHI6_UP}
  {$EXTERNALSYM RotateFlipType}
  RotateFlipType = (
    RotateNoneFlipNone = 0,
    Rotate90FlipNone   = 1,
    Rotate180FlipNone  = 2,
    Rotate270FlipNone  = 3,

    RotateNoneFlipX    = 4,
    Rotate90FlipX      = 5,
    Rotate180FlipX     = 6,
    Rotate270FlipX     = 7,

    RotateNoneFlipY    = Rotate180FlipX,
    Rotate90FlipY      = Rotate270FlipX,
    Rotate180FlipY     = RotateNoneFlipX,
    Rotate270FlipY     = Rotate90FlipX,

    RotateNoneFlipXY   = Rotate180FlipNone,
    Rotate90FlipXY     = Rotate270FlipNone,
    Rotate180FlipXY    = RotateNoneFlipNone,
    Rotate270FlipXY    = Rotate90FlipNone
  );
  TRotateFlipType = RotateFlipType;
{$ELSE}
  {$EXTERNALSYM RotateFlipType}
  RotateFlipType = (
    RotateNoneFlipNone, // = 0,
    Rotate90FlipNone,   // = 1,
    Rotate180FlipNone,  // = 2,
    Rotate270FlipNone,  // = 3,

    RotateNoneFlipX,    // = 4,
    Rotate90FlipX,      // = 5,
    Rotate180FlipX,     // = 6,
    Rotate270FlipX      // = 7,
  );
  const
    RotateNoneFlipY    = Rotate180FlipX;
    Rotate90FlipY      = Rotate270FlipX;
    Rotate180FlipY     = RotateNoneFlipX;
    Rotate270FlipY     = Rotate90FlipX;

    RotateNoneFlipXY   = Rotate180FlipNone;
    Rotate90FlipXY     = Rotate270FlipNone;
    Rotate180FlipXY    = RotateNoneFlipNone;
    Rotate270FlipXY    = Rotate90FlipNone;

type
  TRotateFlipType = RotateFlipType;
{$ENDIF}

//---------------------------------------------------------------------------
// Encoder Parameter structure
//---------------------------------------------------------------------------

  {$EXTERNALSYM EncoderParameter}
  EncoderParameter = packed record
    Guid           : TGUID;   // GUID of the parameter
    NumberOfValues : ULONG;   // Number of the parameter values
    Type_          : ULONG;   // Value type, like ValueTypeLONG  etc.
    Value          : Pointer; // A pointer to the parameter values
  end;
  TEncoderParameter = EncoderParameter;
  PEncoderParameter = ^TEncoderParameter;

//---------------------------------------------------------------------------
// Encoder Parameters structure
//---------------------------------------------------------------------------

  {$EXTERNALSYM EncoderParameters}
  EncoderParameters = packed record
    Count     : UINT;               // Number of parameters in this structure
    Parameter : array[0..0] of TEncoderParameter;  // Parameter values
  end;
  TEncoderParameters = EncoderParameters;
  PEncoderParameters = ^TEncoderParameters;

//---------------------------------------------------------------------------
// Property Item
//---------------------------------------------------------------------------

  {$EXTERNALSYM PropertyItem}
  PropertyItem = record // NOT PACKED !!
    id       : PROPID;  // ID of this property
    length   : ULONG;   // Length of the property value, in bytes
    type_    : WORD;    // Type of the value, as one of TAG_TYPE_XXX
    value    : Pointer; // property value
  end;
  TPropertyItem = PropertyItem;
  PPropertyItem = ^TPropertyItem;

//---------------------------------------------------------------------------
// Image property types
//---------------------------------------------------------------------------

const
  PropertyTagTypeByte      : Integer =  1;
  {$EXTERNALSYM PropertyTagTypeByte}
  PropertyTagTypeASCII     : Integer =  2;
  {$EXTERNALSYM PropertyTagTypeASCII}
  PropertyTagTypeShort     : Integer =  3;
  {$EXTERNALSYM PropertyTagTypeShort}
  PropertyTagTypeLong      : Integer =  4;
  {$EXTERNALSYM PropertyTagTypeLong}
  PropertyTagTypeRational  : Integer =  5;
  {$EXTERNALSYM PropertyTagTypeRational}
  PropertyTagTypeUndefined : Integer =  7;
  {$EXTERNALSYM PropertyTagTypeUndefined}
  PropertyTagTypeSLONG     : Integer =  9;
  {$EXTERNALSYM PropertyTagTypeSLONG}
  PropertyTagTypeSRational : Integer = 10;
  {$EXTERNALSYM PropertyTagTypeSRational}

//---------------------------------------------------------------------------
// Image property ID tags
//---------------------------------------------------------------------------

  PropertyTagExifIFD            = $8769;
  {$EXTERNALSYM PropertyTagExifIFD}
  PropertyTagGpsIFD             = $8825;
  {$EXTERNALSYM PropertyTagGpsIFD}

  PropertyTagNewSubfileType     = $00FE;
  {$EXTERNALSYM PropertyTagNewSubfileType}
  PropertyTagSubfileType        = $00FF;
  {$EXTERNALSYM PropertyTagSubfileType}
  PropertyTagImageWidth         = $0100;
  {$EXTERNALSYM PropertyTagImageWidth}
  PropertyTagImageHeight        = $0101;
  {$EXTERNALSYM PropertyTagImageHeight}
  PropertyTagBitsPerSample      = $0102;
  {$EXTERNALSYM PropertyTagBitsPerSample}
  PropertyTagCompression        = $0103;
  {$EXTERNALSYM PropertyTagCompression}
  PropertyTagPhotometricInterp  = $0106;
  {$EXTERNALSYM PropertyTagPhotometricInterp}
  PropertyTagThreshHolding      = $0107;
  {$EXTERNALSYM PropertyTagThreshHolding}
  PropertyTagCellWidth          = $0108;
  {$EXTERNALSYM PropertyTagCellWidth}
  PropertyTagCellHeight         = $0109;
  {$EXTERNALSYM PropertyTagCellHeight}
  PropertyTagFillOrder          = $010A;
  {$EXTERNALSYM PropertyTagFillOrder}
  PropertyTagDocumentName       = $010D;
  {$EXTERNALSYM PropertyTagDocumentName}
  PropertyTagImageDescription   = $010E;
  {$EXTERNALSYM PropertyTagImageDescription}
  PropertyTagEquipMake          = $010F;
  {$EXTERNALSYM PropertyTagEquipMake}
  PropertyTagEquipModel         = $0110;
  {$EXTERNALSYM PropertyTagEquipModel}
  PropertyTagStripOffsets       = $0111;
  {$EXTERNALSYM PropertyTagStripOffsets}
  PropertyTagOrientation        = $0112;
  {$EXTERNALSYM PropertyTagOrientation}
  PropertyTagSamplesPerPixel    = $0115;
  {$EXTERNALSYM PropertyTagSamplesPerPixel}
  PropertyTagRowsPerStrip       = $0116;
  {$EXTERNALSYM PropertyTagRowsPerStrip}
  PropertyTagStripBytesCount    = $0117;
  {$EXTERNALSYM PropertyTagStripBytesCount}
  PropertyTagMinSampleValue     = $0118;
  {$EXTERNALSYM PropertyTagMinSampleValue}
  PropertyTagMaxSampleValue     = $0119;
  {$EXTERNALSYM PropertyTagMaxSampleValue}
  PropertyTagXResolution        = $011A;   // Image resolution in width direction
  {$EXTERNALSYM PropertyTagXResolution}
  PropertyTagYResolution        = $011B;   // Image resolution in height direction
  {$EXTERNALSYM PropertyTagYResolution}
  PropertyTagPlanarConfig       = $011C;   // Image data arrangement
  {$EXTERNALSYM PropertyTagPlanarConfig}
  PropertyTagPageName           = $011D;
  {$EXTERNALSYM PropertyTagPageName}
  PropertyTagXPosition          = $011E;
  {$EXTERNALSYM PropertyTagXPosition}
  PropertyTagYPosition          = $011F;
  {$EXTERNALSYM PropertyTagYPosition}
  PropertyTagFreeOffset         = $0120;
  {$EXTERNALSYM PropertyTagFreeOffset}
  PropertyTagFreeByteCounts     = $0121;
  {$EXTERNALSYM PropertyTagFreeByteCounts}
  PropertyTagGrayResponseUnit   = $0122;
  {$EXTERNALSYM PropertyTagGrayResponseUnit}
  PropertyTagGrayResponseCurve  = $0123;
  {$EXTERNALSYM PropertyTagGrayResponseCurve}
  PropertyTagT4Option           = $0124;
  {$EXTERNALSYM PropertyTagT4Option}
  PropertyTagT6Option           = $0125;
  {$EXTERNALSYM PropertyTagT6Option}
  PropertyTagResolutionUnit     = $0128;   // Unit of X and Y resolution
  {$EXTERNALSYM PropertyTagResolutionUnit}
  PropertyTagPageNumber         = $0129;
  {$EXTERNALSYM PropertyTagPageNumber}
  PropertyTagTransferFuncition  = $012D;
  {$EXTERNALSYM PropertyTagTransferFuncition}
  PropertyTagSoftwareUsed       = $0131;
  {$EXTERNALSYM PropertyTagSoftwareUsed}
  PropertyTagDateTime           = $0132;
  {$EXTERNALSYM PropertyTagDateTime}
  PropertyTagArtist             = $013B;
  {$EXTERNALSYM PropertyTagArtist}
  PropertyTagHostComputer       = $013C;
  {$EXTERNALSYM PropertyTagHostComputer}
  PropertyTagPredictor          = $013D;
  {$EXTERNALSYM PropertyTagPredictor}
  PropertyTagWhitePoint         = $013E;
  {$EXTERNALSYM PropertyTagWhitePoint}
  PropertyTagPrimaryChromaticities = $013F;
  {$EXTERNALSYM PropertyTagPrimaryChromaticities}
  PropertyTagColorMap           = $0140;
  {$EXTERNALSYM PropertyTagColorMap}
  PropertyTagHalftoneHints      = $0141;
  {$EXTERNALSYM PropertyTagHalftoneHints}
  PropertyTagTileWidth          = $0142;
  {$EXTERNALSYM PropertyTagTileWidth}
  PropertyTagTileLength         = $0143;
  {$EXTERNALSYM PropertyTagTileLength}
  PropertyTagTileOffset         = $0144;
  {$EXTERNALSYM PropertyTagTileOffset}
  PropertyTagTileByteCounts     = $0145;
  {$EXTERNALSYM PropertyTagTileByteCounts}
  PropertyTagInkSet             = $014C;
  {$EXTERNALSYM PropertyTagInkSet}
  PropertyTagInkNames           = $014D;
  {$EXTERNALSYM PropertyTagInkNames}
  PropertyTagNumberOfInks       = $014E;
  {$EXTERNALSYM PropertyTagNumberOfInks}
  PropertyTagDotRange           = $0150;
  {$EXTERNALSYM PropertyTagDotRange}
  PropertyTagTargetPrinter      = $0151;
  {$EXTERNALSYM PropertyTagTargetPrinter}
  PropertyTagExtraSamples       = $0152;
  {$EXTERNALSYM PropertyTagExtraSamples}
  PropertyTagSampleFormat       = $0153;
  {$EXTERNALSYM PropertyTagSampleFormat}
  PropertyTagSMinSampleValue    = $0154;
  {$EXTERNALSYM PropertyTagSMinSampleValue}
  PropertyTagSMaxSampleValue    = $0155;
  {$EXTERNALSYM PropertyTagSMaxSampleValue}
  PropertyTagTransferRange      = $0156;
  {$EXTERNALSYM PropertyTagTransferRange}

  PropertyTagJPEGProc               = $0200;
  {$EXTERNALSYM PropertyTagJPEGProc}
  PropertyTagJPEGInterFormat        = $0201;
  {$EXTERNALSYM PropertyTagJPEGInterFormat}
  PropertyTagJPEGInterLength        = $0202;
  {$EXTERNALSYM PropertyTagJPEGInterLength}
  PropertyTagJPEGRestartInterval    = $0203;
  {$EXTERNALSYM PropertyTagJPEGRestartInterval}
  PropertyTagJPEGLosslessPredictors = $0205;
  {$EXTERNALSYM PropertyTagJPEGLosslessPredictors}
  PropertyTagJPEGPointTransforms    = $0206;
  {$EXTERNALSYM PropertyTagJPEGPointTransforms}
  PropertyTagJPEGQTables            = $0207;
  {$EXTERNALSYM PropertyTagJPEGQTables}
  PropertyTagJPEGDCTables           = $0208;
  {$EXTERNALSYM PropertyTagJPEGDCTables}
  PropertyTagJPEGACTables           = $0209;
  {$EXTERNALSYM PropertyTagJPEGACTables}

  PropertyTagYCbCrCoefficients  = $0211;
  {$EXTERNALSYM PropertyTagYCbCrCoefficients}
  PropertyTagYCbCrSubsampling   = $0212;
  {$EXTERNALSYM PropertyTagYCbCrSubsampling}
  PropertyTagYCbCrPositioning   = $0213;
  {$EXTERNALSYM PropertyTagYCbCrPositioning}
  PropertyTagREFBlackWhite      = $0214;
  {$EXTERNALSYM PropertyTagREFBlackWhite}

  PropertyTagICCProfile         = $8773;   // This TAG is defined by ICC
  {$EXTERNALSYM PropertyTagICCProfile}
                                           // for embedded ICC in TIFF
  PropertyTagGamma                = $0301;
  {$EXTERNALSYM PropertyTagGamma}
  PropertyTagICCProfileDescriptor = $0302;
  {$EXTERNALSYM PropertyTagICCProfileDescriptor}
  PropertyTagSRGBRenderingIntent  = $0303;
  {$EXTERNALSYM PropertyTagSRGBRenderingIntent}

  PropertyTagImageTitle         = $0320;
  {$EXTERNALSYM PropertyTagImageTitle}
  PropertyTagCopyright          = $8298;
  {$EXTERNALSYM PropertyTagCopyright}

// Extra TAGs (Like Adobe Image Information tags etc.)

  PropertyTagResolutionXUnit           = $5001;
  {$EXTERNALSYM PropertyTagResolutionXUnit}
  PropertyTagResolutionYUnit           = $5002;
  {$EXTERNALSYM PropertyTagResolutionYUnit}
  PropertyTagResolutionXLengthUnit     = $5003;
  {$EXTERNALSYM PropertyTagResolutionXLengthUnit}
  PropertyTagResolutionYLengthUnit     = $5004;
  {$EXTERNALSYM PropertyTagResolutionYLengthUnit}
  PropertyTagPrintFlags                = $5005;
  {$EXTERNALSYM PropertyTagPrintFlags}
  PropertyTagPrintFlagsVersion         = $5006;
  {$EXTERNALSYM PropertyTagPrintFlagsVersion}
  PropertyTagPrintFlagsCrop            = $5007;
  {$EXTERNALSYM PropertyTagPrintFlagsCrop}
  PropertyTagPrintFlagsBleedWidth      = $5008;
  {$EXTERNALSYM PropertyTagPrintFlagsBleedWidth}
  PropertyTagPrintFlagsBleedWidthScale = $5009;
  {$EXTERNALSYM PropertyTagPrintFlagsBleedWidthScale}
  PropertyTagHalftoneLPI               = $500A;
  {$EXTERNALSYM PropertyTagHalftoneLPI}
  PropertyTagHalftoneLPIUnit           = $500B;
  {$EXTERNALSYM PropertyTagHalftoneLPIUnit}
  PropertyTagHalftoneDegree            = $500C;
  {$EXTERNALSYM PropertyTagHalftoneDegree}
  PropertyTagHalftoneShape             = $500D;
  {$EXTERNALSYM PropertyTagHalftoneShape}
  PropertyTagHalftoneMisc              = $500E;
  {$EXTERNALSYM PropertyTagHalftoneMisc}
  PropertyTagHalftoneScreen            = $500F;
  {$EXTERNALSYM PropertyTagHalftoneScreen}
  PropertyTagJPEGQuality               = $5010;
  {$EXTERNALSYM PropertyTagJPEGQuality}
  PropertyTagGridSize                  = $5011;
  {$EXTERNALSYM PropertyTagGridSize}
  PropertyTagThumbnailFormat           = $5012;  // 1 = JPEG, 0 = RAW RGB
  {$EXTERNALSYM PropertyTagThumbnailFormat}
  PropertyTagThumbnailWidth            = $5013;
  {$EXTERNALSYM PropertyTagThumbnailWidth}
  PropertyTagThumbnailHeight           = $5014;
  {$EXTERNALSYM PropertyTagThumbnailHeight}
  PropertyTagThumbnailColorDepth       = $5015;
  {$EXTERNALSYM PropertyTagThumbnailColorDepth}
  PropertyTagThumbnailPlanes           = $5016;
  {$EXTERNALSYM PropertyTagThumbnailPlanes}
  PropertyTagThumbnailRawBytes         = $5017;
  {$EXTERNALSYM PropertyTagThumbnailRawBytes}
  PropertyTagThumbnailSize             = $5018;
  {$EXTERNALSYM PropertyTagThumbnailSize}
  PropertyTagThumbnailCompressedSize   = $5019;
  {$EXTERNALSYM PropertyTagThumbnailCompressedSize}
  PropertyTagColorTransferFunction     = $501A;
  {$EXTERNALSYM PropertyTagColorTransferFunction}
  PropertyTagThumbnailData             = $501B;    // RAW thumbnail bits in
  {$EXTERNALSYM PropertyTagThumbnailData}
                                                   // JPEG format or RGB format
                                                   // depends on
                                                   // PropertyTagThumbnailFormat

  // Thumbnail related TAGs

  PropertyTagThumbnailImageWidth        = $5020;   // Thumbnail width
  {$EXTERNALSYM PropertyTagThumbnailImageWidth}
  PropertyTagThumbnailImageHeight       = $5021;   // Thumbnail height
  {$EXTERNALSYM PropertyTagThumbnailImageHeight}
  PropertyTagThumbnailBitsPerSample     = $5022;   // Number of bits per
  {$EXTERNALSYM PropertyTagThumbnailBitsPerSample}
                                                   // component
  PropertyTagThumbnailCompression       = $5023;   // Compression Scheme
  {$EXTERNALSYM PropertyTagThumbnailCompression}
  PropertyTagThumbnailPhotometricInterp = $5024;   // Pixel composition
  {$EXTERNALSYM PropertyTagThumbnailPhotometricInterp}
  PropertyTagThumbnailImageDescription  = $5025;   // Image Tile
  {$EXTERNALSYM PropertyTagThumbnailImageDescription}
  PropertyTagThumbnailEquipMake         = $5026;   // Manufacturer of Image
  {$EXTERNALSYM PropertyTagThumbnailEquipMake}
                                                   // Input equipment
  PropertyTagThumbnailEquipModel        = $5027;   // Model of Image input
  {$EXTERNALSYM PropertyTagThumbnailEquipModel}
                                                   // equipment
  PropertyTagThumbnailStripOffsets    = $5028;  // Image data location
  {$EXTERNALSYM PropertyTagThumbnailStripOffsets}
  PropertyTagThumbnailOrientation     = $5029;  // Orientation of image
  {$EXTERNALSYM PropertyTagThumbnailOrientation}
  PropertyTagThumbnailSamplesPerPixel = $502A;  // Number of components
  {$EXTERNALSYM PropertyTagThumbnailSamplesPerPixel}
  PropertyTagThumbnailRowsPerStrip    = $502B;  // Number of rows per strip
  {$EXTERNALSYM PropertyTagThumbnailRowsPerStrip}
  PropertyTagThumbnailStripBytesCount = $502C;  // Bytes per compressed
  {$EXTERNALSYM PropertyTagThumbnailStripBytesCount}
                                                // strip
  PropertyTagThumbnailResolutionX     = $502D;  // Resolution in width
  {$EXTERNALSYM PropertyTagThumbnailResolutionX}
                                                // direction
  PropertyTagThumbnailResolutionY     = $502E;  // Resolution in height
  {$EXTERNALSYM PropertyTagThumbnailResolutionY}
                                                // direction
  PropertyTagThumbnailPlanarConfig    = $502F;  // Image data arrangement
  {$EXTERNALSYM PropertyTagThumbnailPlanarConfig}
  PropertyTagThumbnailResolutionUnit  = $5030;  // Unit of X and Y
  {$EXTERNALSYM PropertyTagThumbnailResolutionUnit}
                                                // Resolution
  PropertyTagThumbnailTransferFunction = $5031;  // Transfer function
  {$EXTERNALSYM PropertyTagThumbnailTransferFunction}
  PropertyTagThumbnailSoftwareUsed     = $5032;  // Software used
  {$EXTERNALSYM PropertyTagThumbnailSoftwareUsed}
  PropertyTagThumbnailDateTime         = $5033;  // File change date and
  {$EXTERNALSYM PropertyTagThumbnailDateTime}
                                                 // time
  PropertyTagThumbnailArtist          = $5034;  // Person who created the
  {$EXTERNALSYM PropertyTagThumbnailArtist}
                                                // image
  PropertyTagThumbnailWhitePoint      = $5035;  // White point chromaticity
  {$EXTERNALSYM PropertyTagThumbnailWhitePoint}
  PropertyTagThumbnailPrimaryChromaticities = $5036;
  {$EXTERNALSYM PropertyTagThumbnailPrimaryChromaticities}
                                                    // Chromaticities of
                                                    // primaries
  PropertyTagThumbnailYCbCrCoefficients = $5037; // Color space transforma-
  {$EXTERNALSYM PropertyTagThumbnailYCbCrCoefficients}
                                                 // tion coefficients
  PropertyTagThumbnailYCbCrSubsampling = $5038;  // Subsampling ratio of Y
  {$EXTERNALSYM PropertyTagThumbnailYCbCrSubsampling}
                                                 // to C
  PropertyTagThumbnailYCbCrPositioning = $5039;  // Y and C position
  {$EXTERNALSYM PropertyTagThumbnailYCbCrPositioning}
  PropertyTagThumbnailRefBlackWhite    = $503A;  // Pair of black and white
  {$EXTERNALSYM PropertyTagThumbnailRefBlackWhite}
                                                 // reference values
  PropertyTagThumbnailCopyRight       = $503B;   // CopyRight holder
  {$EXTERNALSYM PropertyTagThumbnailCopyRight}

  PropertyTagLuminanceTable           = $5090;
  {$EXTERNALSYM PropertyTagLuminanceTable}
  PropertyTagChrominanceTable         = $5091;
  {$EXTERNALSYM PropertyTagChrominanceTable}

  PropertyTagFrameDelay               = $5100;
  {$EXTERNALSYM PropertyTagFrameDelay}
  PropertyTagLoopCount                = $5101;
  {$EXTERNALSYM PropertyTagLoopCount}

  PropertyTagPixelUnit         = $5110;  // Unit specifier for pixel/unit
  {$EXTERNALSYM PropertyTagPixelUnit}
  PropertyTagPixelPerUnitX     = $5111;  // Pixels per unit in X
  {$EXTERNALSYM PropertyTagPixelPerUnitX}
  PropertyTagPixelPerUnitY     = $5112;  // Pixels per unit in Y
  {$EXTERNALSYM PropertyTagPixelPerUnitY}
  PropertyTagPaletteHistogram  = $5113;  // Palette histogram
  {$EXTERNALSYM PropertyTagPaletteHistogram}

  // EXIF specific tag

  PropertyTagExifExposureTime  = $829A;
  {$EXTERNALSYM PropertyTagExifExposureTime}
  PropertyTagExifFNumber       = $829D;
  {$EXTERNALSYM PropertyTagExifFNumber}

  PropertyTagExifExposureProg  = $8822;
  {$EXTERNALSYM PropertyTagExifExposureProg}
  PropertyTagExifSpectralSense = $8824;
  {$EXTERNALSYM PropertyTagExifSpectralSense}
  PropertyTagExifISOSpeed      = $8827;
  {$EXTERNALSYM PropertyTagExifISOSpeed}
  PropertyTagExifOECF          = $8828;
  {$EXTERNALSYM PropertyTagExifOECF}

  PropertyTagExifVer           = $9000;
  {$EXTERNALSYM PropertyTagExifVer}
  PropertyTagExifDTOrig        = $9003; // Date & time of original
  {$EXTERNALSYM PropertyTagExifDTOrig}
  PropertyTagExifDTDigitized   = $9004; // Date & time of digital data generation
  {$EXTERNALSYM PropertyTagExifDTDigitized}

  PropertyTagExifCompConfig    = $9101;
  {$EXTERNALSYM PropertyTagExifCompConfig}
  PropertyTagExifCompBPP       = $9102;
  {$EXTERNALSYM PropertyTagExifCompBPP}

  PropertyTagExifShutterSpeed  = $9201;
  {$EXTERNALSYM PropertyTagExifShutterSpeed}
  PropertyTagExifAperture      = $9202;
  {$EXTERNALSYM PropertyTagExifAperture}
  PropertyTagExifBrightness    = $9203;
  {$EXTERNALSYM PropertyTagExifBrightness}
  PropertyTagExifExposureBias  = $9204;
  {$EXTERNALSYM PropertyTagExifExposureBias}
  PropertyTagExifMaxAperture   = $9205;
  {$EXTERNALSYM PropertyTagExifMaxAperture}
  PropertyTagExifSubjectDist   = $9206;
  {$EXTERNALSYM PropertyTagExifSubjectDist}
  PropertyTagExifMeteringMode  = $9207;
  {$EXTERNALSYM PropertyTagExifMeteringMode}
  PropertyTagExifLightSource   = $9208;
  {$EXTERNALSYM PropertyTagExifLightSource}
  PropertyTagExifFlash         = $9209;
  {$EXTERNALSYM PropertyTagExifFlash}
  PropertyTagExifFocalLength   = $920A;
  {$EXTERNALSYM PropertyTagExifFocalLength}
  PropertyTagExifMakerNote     = $927C;
  {$EXTERNALSYM PropertyTagExifMakerNote}
  PropertyTagExifUserComment   = $9286;
  {$EXTERNALSYM PropertyTagExifUserComment}
  PropertyTagExifDTSubsec      = $9290;  // Date & Time subseconds
  {$EXTERNALSYM PropertyTagExifDTSubsec}
  PropertyTagExifDTOrigSS      = $9291;  // Date & Time original subseconds
  {$EXTERNALSYM PropertyTagExifDTOrigSS}
  PropertyTagExifDTDigSS       = $9292;  // Date & TIme digitized subseconds
  {$EXTERNALSYM PropertyTagExifDTDigSS}

  PropertyTagExifFPXVer        = $A000;
  {$EXTERNALSYM PropertyTagExifFPXVer}
  PropertyTagExifColorSpace    = $A001;
  {$EXTERNALSYM PropertyTagExifColorSpace}
  PropertyTagExifPixXDim       = $A002;
  {$EXTERNALSYM PropertyTagExifPixXDim}
  PropertyTagExifPixYDim       = $A003;
  {$EXTERNALSYM PropertyTagExifPixYDim}
  PropertyTagExifRelatedWav    = $A004;  // related sound file
  {$EXTERNALSYM PropertyTagExifRelatedWav}
  PropertyTagExifInterop       = $A005;
  {$EXTERNALSYM PropertyTagExifInterop}
  PropertyTagExifFlashEnergy   = $A20B;
  {$EXTERNALSYM PropertyTagExifFlashEnergy}
  PropertyTagExifSpatialFR     = $A20C;  // Spatial Frequency Response
  {$EXTERNALSYM PropertyTagExifSpatialFR}
  PropertyTagExifFocalXRes     = $A20E;  // Focal Plane X Resolution
  {$EXTERNALSYM PropertyTagExifFocalXRes}
  PropertyTagExifFocalYRes     = $A20F;  // Focal Plane Y Resolution
  {$EXTERNALSYM PropertyTagExifFocalYRes}
  PropertyTagExifFocalResUnit  = $A210;  // Focal Plane Resolution Unit
  {$EXTERNALSYM PropertyTagExifFocalResUnit}
  PropertyTagExifSubjectLoc    = $A214;
  {$EXTERNALSYM PropertyTagExifSubjectLoc}
  PropertyTagExifExposureIndex = $A215;
  {$EXTERNALSYM PropertyTagExifExposureIndex}
  PropertyTagExifSensingMethod = $A217;
  {$EXTERNALSYM PropertyTagExifSensingMethod}
  PropertyTagExifFileSource    = $A300;
  {$EXTERNALSYM PropertyTagExifFileSource}
  PropertyTagExifSceneType     = $A301;
  {$EXTERNALSYM PropertyTagExifSceneType}
  PropertyTagExifCfaPattern    = $A302;
  {$EXTERNALSYM PropertyTagExifCfaPattern}

  PropertyTagGpsVer            = $0000;
  {$EXTERNALSYM PropertyTagGpsVer}
  PropertyTagGpsLatitudeRef    = $0001;
  {$EXTERNALSYM PropertyTagGpsLatitudeRef}
  PropertyTagGpsLatitude       = $0002;
  {$EXTERNALSYM PropertyTagGpsLatitude}
  PropertyTagGpsLongitudeRef   = $0003;
  {$EXTERNALSYM PropertyTagGpsLongitudeRef}
  PropertyTagGpsLongitude      = $0004;
  {$EXTERNALSYM PropertyTagGpsLongitude}
  PropertyTagGpsAltitudeRef    = $0005;
  {$EXTERNALSYM PropertyTagGpsAltitudeRef}
  PropertyTagGpsAltitude       = $0006;
  {$EXTERNALSYM PropertyTagGpsAltitude}
  PropertyTagGpsGpsTime        = $0007;
  {$EXTERNALSYM PropertyTagGpsGpsTime}
  PropertyTagGpsGpsSatellites  = $0008;
  {$EXTERNALSYM PropertyTagGpsGpsSatellites}
  PropertyTagGpsGpsStatus      = $0009;
  {$EXTERNALSYM PropertyTagGpsGpsStatus}
  PropertyTagGpsGpsMeasureMode = $00A;
  {$EXTERNALSYM PropertyTagGpsGpsMeasureMode}
  PropertyTagGpsGpsDop         = $000B;  // Measurement precision
  {$EXTERNALSYM PropertyTagGpsGpsDop}
  PropertyTagGpsSpeedRef       = $000C;
  {$EXTERNALSYM PropertyTagGpsSpeedRef}
  PropertyTagGpsSpeed          = $000D;
  {$EXTERNALSYM PropertyTagGpsSpeed}
  PropertyTagGpsTrackRef       = $000E;
  {$EXTERNALSYM PropertyTagGpsTrackRef}
  PropertyTagGpsTrack          = $000F;
  {$EXTERNALSYM PropertyTagGpsTrack}
  PropertyTagGpsImgDirRef      = $0010;
  {$EXTERNALSYM PropertyTagGpsImgDirRef}
  PropertyTagGpsImgDir         = $0011;
  {$EXTERNALSYM PropertyTagGpsImgDir}
  PropertyTagGpsMapDatum       = $0012;
  {$EXTERNALSYM PropertyTagGpsMapDatum}
  PropertyTagGpsDestLatRef     = $0013;
  {$EXTERNALSYM PropertyTagGpsDestLatRef}
  PropertyTagGpsDestLat        = $0014;
  {$EXTERNALSYM PropertyTagGpsDestLat}
  PropertyTagGpsDestLongRef    = $0015;
  {$EXTERNALSYM PropertyTagGpsDestLongRef}
  PropertyTagGpsDestLong       = $0016;
  {$EXTERNALSYM PropertyTagGpsDestLong}
  PropertyTagGpsDestBearRef    = $0017;
  {$EXTERNALSYM PropertyTagGpsDestBearRef}
  PropertyTagGpsDestBear       = $0018;
  {$EXTERNALSYM PropertyTagGpsDestBear}
  PropertyTagGpsDestDistRef    = $0019;
  {$EXTERNALSYM PropertyTagGpsDestDistRef}
  PropertyTagGpsDestDist       = $001A;
  {$EXTERNALSYM PropertyTagGpsDestDist}

(**************************************************************************\
*
*  GDI+ Color Matrix object, used with Graphics.DrawImage
*
\**************************************************************************)

//----------------------------------------------------------------------------
// Color matrix
//----------------------------------------------------------------------------

type
  {$EXTERNALSYM ColorMatrix}
  ColorMatrix = packed array[0..4, 0..4] of Single;
  TColorMatrix = ColorMatrix;
  PColorMatrix = ^TColorMatrix;

//----------------------------------------------------------------------------
// Color Matrix flags
//----------------------------------------------------------------------------

  {$EXTERNALSYM ColorMatrixFlags}
  ColorMatrixFlags = (
    ColorMatrixFlagsDefault,
    ColorMatrixFlagsSkipGrays,
    ColorMatrixFlagsAltGray
  );
  TColorMatrixFlags = ColorMatrixFlags;

//----------------------------------------------------------------------------
// Color Adjust Type
//----------------------------------------------------------------------------

  {$EXTERNALSYM ColorAdjustType}
  ColorAdjustType = (
    ColorAdjustTypeDefault,
    ColorAdjustTypeBitmap,
    ColorAdjustTypeBrush,
    ColorAdjustTypePen,
    ColorAdjustTypeText,
    ColorAdjustTypeCount,
    ColorAdjustTypeAny      // Reserved
  );
  TColorAdjustType = ColorAdjustType;

//----------------------------------------------------------------------------
// Color Map
//----------------------------------------------------------------------------

  {$EXTERNALSYM ColorMap}
  ColorMap = packed record
    oldColor: TGPColor;
    newColor: TGPColor;
  end;
  TColorMap = ColorMap;
  PColorMap = ^TColorMap;

//---------------------------------------------------------------------------
// Private GDI+ classes for internal type checking
//---------------------------------------------------------------------------

  GpGraphics = Pointer;

  GpBrush = Pointer;
  GpTexture = Pointer;
  GpSolidFill = Pointer;
  GpLineGradient = Pointer;
  GpPathGradient = Pointer;
  GpHatch =  Pointer;

  GpPen = Pointer;
  GpCustomLineCap = Pointer;
  GpAdjustableArrowCap = Pointer;

  GpImage = Pointer;
  GpBitmap = Pointer;
  GpMetafile = Pointer;
  GpImageAttributes = Pointer;

  GpPath = Pointer;
  GpRegion = Pointer;
  GpPathIterator = Pointer;

  GpFontFamily = Pointer;
  GpFont = Pointer;
  GpStringFormat = Pointer;
  GpFontCollection = Pointer;
  GpCachedBitmap = Pointer;

  GpStatus          = TStatus;
  GpFillMode        = TFillMode;
  GpWrapMode        = TWrapMode;
  GpUnit            = TUnit;
  GpCoordinateSpace = TCoordinateSpace;
  GpPointF          = PGPPointF;
  GpPoint           = PGPPoint;
  GpRectF           = PGPRectF;
  GpRect            = PGPRect;
  GpSizeF           = PGPSizeF;
  GpHatchStyle      = THatchStyle;
  GpDashStyle       = TDashStyle;
  GpLineCap         = TLineCap;
  GpDashCap         = TDashCap;

  GpPenAlignment    = TPenAlignment;

  GpLineJoin        = TLineJoin;
  GpPenType         = TPenType;

  GpMatrix          = Pointer; 
  GpBrushType       = TBrushType;
  GpMatrixOrder     = TMatrixOrder;
  GpFlushIntention  = TFlushIntention;
  GpPathData        = TPathData;

(**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
* Module Name:
*   GdiplusFlat.h
* Abstract:
*   Private GDI+ header file.
*
\**************************************************************************)

  function GdipCreatePath(brushMode: GPFILLMODE;
    out path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreatePath}

  function GdipCreatePath2(v1: GPPOINTF; v2: PBYTE; v3: Integer; v4: GPFILLMODE;
    out path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreatePath2}

  function GdipCreatePath2I(v1: GPPOINT; v2: PBYTE; v3: Integer; v4: GPFILLMODE;
    out path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreatePath2I}

  function GdipClonePath(path: GPPATH;
    out clonePath: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipClonePath}

  function GdipDeletePath(path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeletePath}

  function GdipResetPath(path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipResetPath}

  function GdipGetPointCount(path: GPPATH;
    out count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPointCount}

  function GdipGetPathTypes(path: GPPATH; types: PBYTE;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathTypes}

  function GdipGetPathPoints(v1: GPPATH; points: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathPoints}

  function GdipGetPathPointsI(v1: GPPATH; points: GPPOINT;
             count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathPointsI}

  function GdipGetPathFillMode(path: GPPATH;
    var fillmode: GPFILLMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathFillMode}

  function GdipSetPathFillMode(path: GPPATH;
    fillmode: GPFILLMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathFillMode}

  function GdipGetPathData(path: GPPATH;
    pathData: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathData}

  function GdipStartPathFigure(path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipStartPathFigure}

  function GdipClosePathFigure(path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipClosePathFigure}

  function GdipClosePathFigures(path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipClosePathFigures}

  function GdipSetPathMarker(path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathMarker}

  function GdipClearPathMarkers(path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipClearPathMarkers}

  function GdipReversePath(path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipReversePath}

  function GdipGetPathLastPoint(path: GPPATH;
    lastPoint: GPPOINTF): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathLastPoint}

  function GdipAddPathLine(path: GPPATH;
    x1, y1, x2, y2: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathLine}

  function GdipAddPathLine2(path: GPPATH; points: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathLine2}

  function GdipAddPathArc(path: GPPATH; x, y, width, height, startAngle,
    sweepAngle: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathArc}

  function GdipAddPathBezier(path: GPPATH;
    x1, y1, x2, y2, x3, y3, x4, y4: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathBezier}

  function GdipAddPathBeziers(path: GPPATH; points: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathBeziers}

  function GdipAddPathCurve(path: GPPATH; points: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathCurve}

  function GdipAddPathCurve2(path: GPPATH; points: GPPOINTF; count: Integer;
    tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathCurve2}

  function GdipAddPathCurve3(path: GPPATH; points: GPPOINTF; count: Integer;
    offset: Integer; numberOfSegments: Integer;
    tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathCurve3}

  function GdipAddPathClosedCurve(path: GPPATH; points: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathClosedCurve}

  function GdipAddPathClosedCurve2(path: GPPATH; points: GPPOINTF;
    count: Integer; tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathClosedCurve2}

  function GdipAddPathRectangle(path: GPPATH; x: Single; y: Single;
    width: Single; height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathRectangle}

  function GdipAddPathRectangles(path: GPPATH; rects: GPRECTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathRectangles}

  function GdipAddPathEllipse(path: GPPATH;  x: Single; y: Single;
    width: Single; height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathEllipse}

  function GdipAddPathPie(path: GPPATH; x: Single; y: Single; width: Single;
    height: Single; startAngle: Single; sweepAngle: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathPie}

  function GdipAddPathPolygon(path: GPPATH; points: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathPolygon}

  function GdipAddPathPath(path: GPPATH; addingPath: GPPATH;
    connect: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathPath}

  function GdipAddPathString(path: GPPATH; string_: PWCHAR; length: Integer;
    family: GPFONTFAMILY; style: Integer; emSize: Single; layoutRect: PGPRectF;
    format: GPSTRINGFORMAT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathString}

  function GdipAddPathStringI(path: GPPATH; string_: PWCHAR; length: Integer;
    family: GPFONTFAMILY; style: Integer; emSize: Single; layoutRect: PGPRect;
    format: GPSTRINGFORMAT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathStringI}

  function GdipAddPathLineI(path: GPPATH; x1: Integer; y1: Integer; x2: Integer;
    y2: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathLineI}

  function GdipAddPathLine2I(path: GPPATH; points: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathLine2I}

  function GdipAddPathArcI(path: GPPATH; x: Integer; y: Integer; width: Integer;
    height: Integer; startAngle: Single; sweepAngle: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathArcI}

  function GdipAddPathBezierI(path: GPPATH; x1: Integer; y1: Integer;
    x2: Integer; y2: Integer; x3: Integer; y3: Integer; x4: Integer;
    y4: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathBezierI}

  function GdipAddPathBeziersI(path: GPPATH; points: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathBeziersI}

  function GdipAddPathCurveI(path: GPPATH; points: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathCurveI}

  function GdipAddPathCurve2I(path: GPPATH; points: GPPOINT; count: Integer;
    tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathCurve2I}

  function GdipAddPathCurve3I(path: GPPATH; points: GPPOINT; count: Integer;
    offset: Integer; numberOfSegments: Integer;
    tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathCurve3I}

  function GdipAddPathClosedCurveI(path: GPPATH; points: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathClosedCurveI}

  function GdipAddPathClosedCurve2I(path: GPPATH; points: GPPOINT;
    count: Integer; tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathClosedCurve2I}

  function GdipAddPathRectangleI(path: GPPATH; x: Integer; y: Integer;
    width: Integer; height: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathRectangleI}

  function GdipAddPathRectanglesI(path: GPPATH; rects: GPRECT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathRectanglesI}

  function GdipAddPathEllipseI(path: GPPATH; x: Integer; y: Integer;
    width: Integer; height: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathEllipseI}

  function GdipAddPathPieI(path: GPPATH; x: Integer; y: Integer; width: Integer;
    height: Integer; startAngle: Single; sweepAngle: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathPieI}

  function GdipAddPathPolygonI(path: GPPATH; points: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipAddPathPolygonI}

  function GdipFlattenPath(path: GPPATH; matrix: GPMATRIX;
    flatness: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFlattenPath}

  function GdipWindingModeOutline(path: GPPATH; matrix: GPMATRIX;
    flatness: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipWindingModeOutline}

  function GdipWidenPath(nativePath: GPPATH; pen: GPPEN; matrix: GPMATRIX;
    flatness: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipWidenPath}

  function GdipWarpPath(path: GPPATH; matrix: GPMATRIX; points: GPPOINTF;
    count: Integer; srcx: Single; srcy: Single; srcwidth: Single;
    srcheight: Single; warpMode: WARPMODE; flatness: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipWarpPath}

  function GdipTransformPath(path: GPPATH; matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTransformPath}

  function GdipGetPathWorldBounds(path: GPPATH; bounds: GPRECTF;
    matrix: GPMATRIX; pen: GPPEN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathWorldBounds}

  function GdipGetPathWorldBoundsI(path: GPPATH; bounds: GPRECT;
    matrix: GPMATRIX; pen: GPPEN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathWorldBoundsI}

  function GdipIsVisiblePathPoint(path: GPPATH; x: Single; y: Single;
    graphics: GPGRAPHICS; out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisiblePathPoint}

  function GdipIsVisiblePathPointI(path: GPPATH; x: Integer; y: Integer;
    graphics: GPGRAPHICS; out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisiblePathPointI}

  function GdipIsOutlineVisiblePathPoint(path: GPPATH; x: Single; y: Single;
    pen: GPPEN; graphics: GPGRAPHICS; out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsOutlineVisiblePathPoint}

  function GdipIsOutlineVisiblePathPointI(path: GPPATH; x: Integer; y: Integer;
    pen: GPPEN; graphics: GPGRAPHICS; out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsOutlineVisiblePathPointI}

//----------------------------------------------------------------------------
// PathIterator APIs 
//----------------------------------------------------------------------------

  function GdipCreatePathIter(out iterator: GPPATHITERATOR;
    path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreatePathIter}

  function GdipDeletePathIter(iterator: GPPATHITERATOR): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeletePathIter}

  function GdipPathIterNextSubpath(iterator: GPPATHITERATOR;
    var resultCount: Integer; var startIndex: Integer; var endIndex: Integer;
    out isClosed: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterNextSubpath}

  function GdipPathIterNextSubpathPath(iterator: GPPATHITERATOR;
    var resultCount: Integer; path: GPPATH;
    out isClosed: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterNextSubpathPath}

  function GdipPathIterNextPathType(iterator: GPPATHITERATOR;
    var resultCount: Integer; pathType: PBYTE; var startIndex: Integer;
    var endIndex: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterNextPathType}

  function GdipPathIterNextMarker(iterator: GPPATHITERATOR;
    var resultCount: Integer; var startIndex: Integer;
    var endIndex: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterNextMarker}

  function GdipPathIterNextMarkerPath(iterator: GPPATHITERATOR;
    var resultCount: Integer; path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterNextMarkerPath}

  function GdipPathIterGetCount(iterator: GPPATHITERATOR;
    out count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterGetCount}

  function GdipPathIterGetSubpathCount(iterator: GPPATHITERATOR;
    out count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterGetSubpathCount}

  function GdipPathIterIsValid(iterator: GPPATHITERATOR;
    out valid: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterIsValid}

  function GdipPathIterHasCurve(iterator: GPPATHITERATOR;
    out hasCurve: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterHasCurve}

  function GdipPathIterRewind(iterator: GPPATHITERATOR): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterRewind}

  function GdipPathIterEnumerate(iterator: GPPATHITERATOR;
    var resultCount: Integer; points: GPPOINTF; types: PBYTE;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterEnumerate}

  function GdipPathIterCopyData(iterator: GPPATHITERATOR;
    var resultCount: Integer; points: GPPOINTF; types: PBYTE;
    startIndex: Integer; endIndex: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPathIterCopyData}

//----------------------------------------------------------------------------
// Matrix APIs
//----------------------------------------------------------------------------

  function GdipCreateMatrix(out matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateMatrix}

  function GdipCreateMatrix2(m11: Single; m12: Single; m21: Single; m22: Single;
    dx: Single; dy: Single; out matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateMatrix2}

  function GdipCreateMatrix3(rect: GPRECTF; dstplg: GPPOINTF;
    out matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateMatrix3}

  function GdipCreateMatrix3I(rect: GPRECT; dstplg: GPPOINT;
    out matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateMatrix3I}

  function GdipCloneMatrix(matrix: GPMATRIX;
    out cloneMatrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneMatrix}

  function GdipDeleteMatrix(matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeleteMatrix}

  function GdipSetMatrixElements(matrix: GPMATRIX; m11: Single; m12: Single;
    m21: Single; m22: Single; dx: Single; dy: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetMatrixElements}

  function GdipMultiplyMatrix(matrix: GPMATRIX; matrix2: GPMATRIX;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipMultiplyMatrix}

  function GdipTranslateMatrix(matrix: GPMATRIX; offsetX: Single;
    offsetY: Single; order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTranslateMatrix}

  function GdipScaleMatrix(matrix: GPMATRIX; scaleX: Single; scaleY: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipScaleMatrix}

  function GdipRotateMatrix(matrix: GPMATRIX; angle: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRotateMatrix}

  function GdipShearMatrix(matrix: GPMATRIX; shearX: Single; shearY: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipShearMatrix}

  function GdipInvertMatrix(matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipInvertMatrix}

  function GdipTransformMatrixPoints(matrix: GPMATRIX; pts: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTransformMatrixPoints}

  function GdipTransformMatrixPointsI(matrix: GPMATRIX; pts: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTransformMatrixPointsI}

  function GdipVectorTransformMatrixPoints(matrix: GPMATRIX; pts: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipVectorTransformMatrixPoints}

  function GdipVectorTransformMatrixPointsI(matrix: GPMATRIX; pts: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipVectorTransformMatrixPointsI}

  function GdipGetMatrixElements(matrix: GPMATRIX;
    matrixOut: PSingle): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetMatrixElements}

  function GdipIsMatrixInvertible(matrix: GPMATRIX;
    out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsMatrixInvertible}

  function GdipIsMatrixIdentity(matrix: GPMATRIX;
    out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsMatrixIdentity}

  function GdipIsMatrixEqual(matrix: GPMATRIX; matrix2: GPMATRIX;
    out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsMatrixEqual}

//----------------------------------------------------------------------------
// Region APIs
//----------------------------------------------------------------------------

  function GdipCreateRegion(out region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateRegion}

  function GdipCreateRegionRect(rect: GPRECTF;
    out region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateRegionRect}

  function GdipCreateRegionRectI(rect: GPRECT;
    out region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateRegionRectI}

  function GdipCreateRegionPath(path: GPPATH;
    out region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateRegionPath}

  function GdipCreateRegionRgnData(regionData: PBYTE; size: Integer;
    out region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateRegionRgnData}

  function GdipCreateRegionHrgn(hRgn: HRGN;
    out region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateRegionHrgn}

  function GdipCloneRegion(region: GPREGION;
    out cloneRegion: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneRegion}

  function GdipDeleteRegion(region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeleteRegion}

  function GdipSetInfinite(region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetInfinite}

  function GdipSetEmpty(region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetEmpty}

  function GdipCombineRegionRect(region: GPREGION; rect: GPRECTF;
    combineMode: COMBINEMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCombineRegionRect}

  function GdipCombineRegionRectI(region: GPREGION; rect: GPRECT;
    combineMode: COMBINEMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCombineRegionRectI}

  function GdipCombineRegionPath(region: GPREGION; path: GPPATH;
    combineMode: COMBINEMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCombineRegionPath}

  function GdipCombineRegionRegion(region: GPREGION; region2: GPREGION;
    combineMode: COMBINEMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCombineRegionRegion}

  function GdipTranslateRegion(region: GPREGION; dx: Single;
    dy: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTranslateRegion}

  function GdipTranslateRegionI(region: GPREGION; dx: Integer;
    dy: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTranslateRegionI}

  function GdipTransformRegion(region: GPREGION;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTransformRegion}

  function GdipGetRegionBounds(region: GPREGION; graphics: GPGRAPHICS;
    rect: GPRECTF): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetRegionBounds}

  function GdipGetRegionBoundsI(region: GPREGION; graphics: GPGRAPHICS;
    rect: GPRECT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetRegionBoundsI}

  function GdipGetRegionHRgn(region: GPREGION; graphics: GPGRAPHICS;
    out hRgn: HRGN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetRegionHRgn}

  function GdipIsEmptyRegion(region: GPREGION; graphics: GPGRAPHICS;
    out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsEmptyRegion}

  function GdipIsInfiniteRegion(region: GPREGION; graphics: GPGRAPHICS;
    out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsInfiniteRegion}

  function GdipIsEqualRegion(region: GPREGION; region2: GPREGION;
    graphics: GPGRAPHICS; out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsEqualRegion}

  function GdipGetRegionDataSize(region: GPREGION;
    out bufferSize: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetRegionDataSize}

  function GdipGetRegionData(region: GPREGION; buffer: PBYTE;
    bufferSize: UINT; sizeFilled: PUINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetRegionData}

  function GdipIsVisibleRegionPoint(region: GPREGION; x: Single; y: Single;
    graphics: GPGRAPHICS; out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisibleRegionPoint}

  function GdipIsVisibleRegionPointI(region: GPREGION; x: Integer; y: Integer;
    graphics: GPGRAPHICS; out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisibleRegionPointI}

  function GdipIsVisibleRegionRect(region: GPREGION; x: Single; y: Single;
    width: Single; height: Single; graphics: GPGRAPHICS;
    out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisibleRegionRect}

  function GdipIsVisibleRegionRectI(region: GPREGION; x: Integer; y: Integer;
    width: Integer; height: Integer; graphics: GPGRAPHICS;
    out result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisibleRegionRectI}

  function GdipGetRegionScansCount(region: GPREGION; out count: UINT;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetRegionScansCount}

  function GdipGetRegionScans(region: GPREGION; rects: GPRECTF;
    out count: Integer; matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetRegionScans}

  function GdipGetRegionScansI(region: GPREGION; rects: GPRECT;
    out count: Integer; matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetRegionScansI}

//----------------------------------------------------------------------------
// Brush APIs
//----------------------------------------------------------------------------

  function GdipCloneBrush(brush: GPBRUSH;
    out cloneBrush: GPBRUSH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneBrush}

  function GdipDeleteBrush(brush: GPBRUSH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeleteBrush}

  function GdipGetBrushType(brush: GPBRUSH;
    out type_: GPBRUSHTYPE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetBrushType}

//----------------------------------------------------------------------------
// HatchBrush APIs
//----------------------------------------------------------------------------

  function GdipCreateHatchBrush(hatchstyle: Integer; forecol: ARGB;
    backcol: ARGB; out brush: GPHATCH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateHatchBrush}

  function GdipGetHatchStyle(brush: GPHATCH;
    out hatchstyle: GPHATCHSTYLE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetHatchStyle}

  function GdipGetHatchForegroundColor(brush: GPHATCH;
    out forecol: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetHatchForegroundColor}

  function GdipGetHatchBackgroundColor(brush: GPHATCH;
    out backcol: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetHatchBackgroundColor}

//----------------------------------------------------------------------------
// TextureBrush APIs
//----------------------------------------------------------------------------


  function GdipCreateTexture(image: GPIMAGE; wrapmode: GPWRAPMODE;
    var texture: GPTEXTURE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateTexture}

  function GdipCreateTexture2(image: GPIMAGE; wrapmode: GPWRAPMODE;
    x: Single; y: Single; width: Single; height: Single;
    out texture: GPTEXTURE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateTexture2}

  function GdipCreateTextureIA(image: GPIMAGE;
    imageAttributes: GPIMAGEATTRIBUTES; x: Single; y: Single; width: Single;
    height: Single; out texture: GPTEXTURE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateTextureIA}

  function GdipCreateTexture2I(image: GPIMAGE; wrapmode: GPWRAPMODE; x: Integer;
    y: Integer; width: Integer; height: Integer;
    out texture: GPTEXTURE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateTexture2I}

  function GdipCreateTextureIAI(image: GPIMAGE;
    imageAttributes: GPIMAGEATTRIBUTES; x: Integer; y: Integer; width: Integer;
    height: Integer; out texture: GPTEXTURE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateTextureIAI}

  function GdipGetTextureTransform(brush: GPTEXTURE;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetTextureTransform}

  function GdipSetTextureTransform(brush: GPTEXTURE;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetTextureTransform}

  function GdipResetTextureTransform(brush: GPTEXTURE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipResetTextureTransform}

  function GdipMultiplyTextureTransform(brush: GPTEXTURE; matrix: GPMATRIX;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipMultiplyTextureTransform}

  function GdipTranslateTextureTransform(brush: GPTEXTURE; dx: Single;
    dy: Single; order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTranslateTextureTransform}

  function GdipScaleTextureTransform(brush: GPTEXTURE; sx: Single; sy: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipScaleTextureTransform}

  function GdipRotateTextureTransform(brush: GPTEXTURE; angle: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRotateTextureTransform}

  function GdipSetTextureWrapMode(brush: GPTEXTURE;
    wrapmode: GPWRAPMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetTextureWrapMode}

  function GdipGetTextureWrapMode(brush: GPTEXTURE;
    var wrapmode: GPWRAPMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetTextureWrapMode}

  function GdipGetTextureImage(brush: GPTEXTURE;
    out image: GPIMAGE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetTextureImage}

//----------------------------------------------------------------------------
// SolidBrush APIs
//----------------------------------------------------------------------------

  function GdipCreateSolidFill(color: ARGB;
    out brush: GPSOLIDFILL): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateSolidFill}

  function GdipSetSolidFillColor(brush: GPSOLIDFILL;
    color: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetSolidFillColor}

  function GdipGetSolidFillColor(brush: GPSOLIDFILL;
    out color: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetSolidFillColor}

//----------------------------------------------------------------------------
// LineBrush APIs
//----------------------------------------------------------------------------

  function GdipCreateLineBrush(point1: GPPOINTF; point2: GPPOINTF; color1: ARGB;
    color2: ARGB; wrapMode: GPWRAPMODE;
    out lineGradient: GPLINEGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateLineBrush}

  function GdipCreateLineBrushI(point1: GPPOINT; point2: GPPOINT; color1: ARGB;
    color2: ARGB; wrapMode: GPWRAPMODE;
    out lineGradient: GPLINEGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateLineBrushI}

  function GdipCreateLineBrushFromRect(rect: GPRECTF; color1: ARGB;
    color2: ARGB; mode: LINEARGRADIENTMODE; wrapMode: GPWRAPMODE;
    out lineGradient: GPLINEGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateLineBrushFromRect}

  function GdipCreateLineBrushFromRectI(rect: GPRECT; color1: ARGB;
    color2: ARGB; mode: LINEARGRADIENTMODE; wrapMode: GPWRAPMODE;
    out lineGradient: GPLINEGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateLineBrushFromRectI}

  function GdipCreateLineBrushFromRectWithAngle(rect: GPRECTF; color1: ARGB;
    color2: ARGB; angle: Single; isAngleScalable: Bool; wrapMode: GPWRAPMODE;
    out lineGradient: GPLINEGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateLineBrushFromRectWithAngle}

  function GdipCreateLineBrushFromRectWithAngleI(rect: GPRECT; color1: ARGB;
    color2: ARGB; angle: Single; isAngleScalable: Bool; wrapMode: GPWRAPMODE;
    out lineGradient: GPLINEGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateLineBrushFromRectWithAngleI}

  function GdipSetLineColors(brush: GPLINEGRADIENT; color1: ARGB;
    color2: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetLineColors}

  function GdipGetLineColors(brush: GPLINEGRADIENT;
    colors: PARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLineColors}

  function GdipGetLineRect(brush: GPLINEGRADIENT;
    rect: GPRECTF): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLineRect}

  function GdipGetLineRectI(brush: GPLINEGRADIENT;
    rect: GPRECT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLineRectI}

  function GdipSetLineGammaCorrection(brush: GPLINEGRADIENT;
    useGammaCorrection: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetLineGammaCorrection}

  function GdipGetLineGammaCorrection(brush: GPLINEGRADIENT;
    out useGammaCorrection: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLineGammaCorrection}

  function GdipGetLineBlendCount(brush: GPLINEGRADIENT;
    out count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLineBlendCount}

  function GdipGetLineBlend(brush: GPLINEGRADIENT; blend: PSingle;
    positions: PSingle; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLineBlend}

  function GdipSetLineBlend(brush: GPLINEGRADIENT; blend: PSingle;
    positions: PSingle; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetLineBlend}

  function GdipGetLinePresetBlendCount(brush: GPLINEGRADIENT;
    out count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLinePresetBlendCount}

  function GdipGetLinePresetBlend(brush: GPLINEGRADIENT; blend: PARGB;
    positions: PSingle; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLinePresetBlend}

  function GdipSetLinePresetBlend(brush: GPLINEGRADIENT; blend: PARGB;
    positions: PSingle; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetLinePresetBlend}

  function GdipSetLineSigmaBlend(brush: GPLINEGRADIENT; focus: Single;
    scale: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetLineSigmaBlend}

  function GdipSetLineLinearBlend(brush: GPLINEGRADIENT; focus: Single;
    scale: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetLineLinearBlend}

  function GdipSetLineWrapMode(brush: GPLINEGRADIENT;
    wrapmode: GPWRAPMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetLineWrapMode}

  function GdipGetLineWrapMode(brush: GPLINEGRADIENT;
    out wrapmode: GPWRAPMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLineWrapMode}

  function GdipGetLineTransform(brush: GPLINEGRADIENT;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLineTransform}

  function GdipSetLineTransform(brush: GPLINEGRADIENT;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetLineTransform}

  function GdipResetLineTransform(brush: GPLINEGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipResetLineTransform}

  function GdipMultiplyLineTransform(brush: GPLINEGRADIENT; matrix: GPMATRIX;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipMultiplyLineTransform}

  function GdipTranslateLineTransform(brush: GPLINEGRADIENT; dx: Single;
    dy: Single; order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTranslateLineTransform}

  function GdipScaleLineTransform(brush: GPLINEGRADIENT; sx: Single; sy: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipScaleLineTransform}

  function GdipRotateLineTransform(brush: GPLINEGRADIENT; angle: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRotateLineTransform}

//----------------------------------------------------------------------------
// PathGradientBrush APIs
//----------------------------------------------------------------------------

  function GdipCreatePathGradient(points: GPPOINTF; count: Integer;
    wrapMode: GPWRAPMODE; out polyGradient: GPPATHGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreatePathGradient}

  function GdipCreatePathGradientI(points: GPPOINT; count: Integer;
    wrapMode: GPWRAPMODE; out polyGradient: GPPATHGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreatePathGradientI}

  function GdipCreatePathGradientFromPath(path: GPPATH;
    out polyGradient: GPPATHGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreatePathGradientFromPath}

  function GdipGetPathGradientCenterColor(brush: GPPATHGRADIENT;
    out colors: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientCenterColor}

  function GdipSetPathGradientCenterColor(brush: GPPATHGRADIENT;
    colors: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientCenterColor}

  function GdipGetPathGradientSurroundColorsWithCount(brush: GPPATHGRADIENT;
    color: PARGB; var count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientSurroundColorsWithCount}

  function GdipSetPathGradientSurroundColorsWithCount(brush: GPPATHGRADIENT;
    color: PARGB; var count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientSurroundColorsWithCount}

  function GdipGetPathGradientPath(brush: GPPATHGRADIENT;
    path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientPath}

  function GdipSetPathGradientPath(brush: GPPATHGRADIENT;
    path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientPath}

  function GdipGetPathGradientCenterPoint(brush: GPPATHGRADIENT;
    points: GPPOINTF): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientCenterPoint}

  function GdipGetPathGradientCenterPointI(brush: GPPATHGRADIENT;
    points: GPPOINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientCenterPointI}

  function GdipSetPathGradientCenterPoint(brush: GPPATHGRADIENT;
    points: GPPOINTF): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientCenterPoint}

  function GdipSetPathGradientCenterPointI(brush: GPPATHGRADIENT;
    points: GPPOINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientCenterPointI}

  function GdipGetPathGradientRect(brush: GPPATHGRADIENT;
    rect: GPRECTF): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientRect}

  function GdipGetPathGradientRectI(brush: GPPATHGRADIENT;
    rect: GPRECT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientRectI}

  function GdipGetPathGradientPointCount(brush: GPPATHGRADIENT;
    var count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientPointCount}

  function GdipGetPathGradientSurroundColorCount(brush: GPPATHGRADIENT;
    var count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientSurroundColorCount}

  function GdipSetPathGradientGammaCorrection(brush: GPPATHGRADIENT;
    useGammaCorrection: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientGammaCorrection}

  function GdipGetPathGradientGammaCorrection(brush: GPPATHGRADIENT;
    var useGammaCorrection: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientGammaCorrection}

  function GdipGetPathGradientBlendCount(brush: GPPATHGRADIENT;
    var count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientBlendCount}

  function GdipGetPathGradientBlend(brush: GPPATHGRADIENT;
    blend: PSingle; positions: PSingle; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientBlend}

  function GdipSetPathGradientBlend(brush: GPPATHGRADIENT;
    blend: PSingle; positions: PSingle; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientBlend}

  function GdipGetPathGradientPresetBlendCount(brush: GPPATHGRADIENT;
    var count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientPresetBlendCount}

  function GdipGetPathGradientPresetBlend(brush: GPPATHGRADIENT;
    blend: PARGB; positions: PSingle; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientPresetBlend}

  function GdipSetPathGradientPresetBlend(brush: GPPATHGRADIENT;
    blend: PARGB; positions: PSingle; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientPresetBlend}

  function GdipSetPathGradientSigmaBlend(brush: GPPATHGRADIENT;
    focus: Single; scale: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientSigmaBlend}

  function GdipSetPathGradientLinearBlend(brush: GPPATHGRADIENT;
    focus: Single; scale: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientLinearBlend}

  function GdipGetPathGradientWrapMode(brush: GPPATHGRADIENT;
    var wrapmode: GPWRAPMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientWrapMode}

  function GdipSetPathGradientWrapMode(brush: GPPATHGRADIENT;
    wrapmode: GPWRAPMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientWrapMode}

  function GdipGetPathGradientTransform(brush: GPPATHGRADIENT;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientTransform}

  function GdipSetPathGradientTransform(brush: GPPATHGRADIENT;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientTransform}

  function GdipResetPathGradientTransform(
    brush: GPPATHGRADIENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipResetPathGradientTransform}

  function GdipMultiplyPathGradientTransform(brush: GPPATHGRADIENT;
    matrix: GPMATRIX; order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipMultiplyPathGradientTransform}

  function GdipTranslatePathGradientTransform(brush: GPPATHGRADIENT;
    dx: Single; dy: Single; order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTranslatePathGradientTransform}

  function GdipScalePathGradientTransform(brush: GPPATHGRADIENT;
    sx: Single; sy: Single; order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipScalePathGradientTransform}

  function GdipRotatePathGradientTransform(brush: GPPATHGRADIENT;
    angle: Single; order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRotatePathGradientTransform}

  function GdipGetPathGradientFocusScales(brush: GPPATHGRADIENT;
    var xScale: Single; var yScale: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPathGradientFocusScales}

  function GdipSetPathGradientFocusScales(brush: GPPATHGRADIENT;
    xScale: Single; yScale: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPathGradientFocusScales}

//----------------------------------------------------------------------------
// Pen APIs
//----------------------------------------------------------------------------

  function GdipCreatePen1(color: ARGB; width: Single; unit_: GPUNIT;
    out pen: GPPEN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreatePen1}

  function GdipCreatePen2(brush: GPBRUSH; width: Single; unit_: GPUNIT;
    out pen: GPPEN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreatePen2}

  function GdipClonePen(pen: GPPEN; out clonepen: GPPEN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipClonePen}

  function GdipDeletePen(pen: GPPEN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeletePen}

  function GdipSetPenWidth(pen: GPPEN; width: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenWidth}

  function GdipGetPenWidth(pen: GPPEN; out width: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenWidth}

  function GdipSetPenUnit(pen: GPPEN; unit_: GPUNIT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenUnit}

  function GdipGetPenUnit(pen: GPPEN; var unit_: GPUNIT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenUnit}

  function GdipSetPenLineCap197819(pen: GPPEN; startCap: GPLINECAP;
    endCap: GPLINECAP; dashCap: GPDASHCAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenLineCap197819}

  function GdipSetPenStartCap(pen: GPPEN;
    startCap: GPLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenStartCap}

  function GdipSetPenEndCap(pen: GPPEN; endCap: GPLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenEndCap}

  function GdipSetPenDashCap197819(pen: GPPEN;
    dashCap: GPDASHCAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenDashCap197819}

  function GdipGetPenStartCap(pen: GPPEN;
    out startCap: GPLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenStartCap}

  function GdipGetPenEndCap(pen: GPPEN;
    out endCap: GPLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenEndCap}

  function GdipGetPenDashCap197819(pen: GPPEN;
    out dashCap: GPDASHCAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenDashCap197819}

  function GdipSetPenLineJoin(pen: GPPEN;
    lineJoin: GPLINEJOIN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenLineJoin}

  function GdipGetPenLineJoin(pen: GPPEN;
    var lineJoin: GPLINEJOIN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenLineJoin}

  function GdipSetPenCustomStartCap(pen: GPPEN;
    customCap: GPCUSTOMLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenCustomStartCap}

  function GdipGetPenCustomStartCap(pen: GPPEN;
    out customCap: GPCUSTOMLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenCustomStartCap}

  function GdipSetPenCustomEndCap(pen: GPPEN;
    customCap: GPCUSTOMLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenCustomEndCap}

  function GdipGetPenCustomEndCap(pen: GPPEN;
    out customCap: GPCUSTOMLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenCustomEndCap}

  function GdipSetPenMiterLimit(pen: GPPEN;
    miterLimit: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenMiterLimit}

  function GdipGetPenMiterLimit(pen: GPPEN;
    out miterLimit: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenMiterLimit}

  function GdipSetPenMode(pen: GPPEN;
    penMode: GPPENALIGNMENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenMode}

  function GdipGetPenMode(pen: GPPEN;
    var penMode: GPPENALIGNMENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenMode}

  function GdipSetPenTransform(pen: GPPEN;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenTransform}

  function GdipGetPenTransform(pen: GPPEN;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenTransform}

  function GdipResetPenTransform(pen: GPPEN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipResetPenTransform}

  function GdipMultiplyPenTransform(pen: GPPEN; matrix: GPMATRIX;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipMultiplyPenTransform}

  function GdipTranslatePenTransform(pen: GPPEN; dx: Single; dy: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTranslatePenTransform}

  function GdipScalePenTransform(pen: GPPEN; sx: Single; sy: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipScalePenTransform}

  function GdipRotatePenTransform(pen: GPPEN; angle: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRotatePenTransform}

  function GdipSetPenColor(pen: GPPEN; argb: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenColor}

  function GdipGetPenColor(pen: GPPEN; out argb: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenColor}

  function GdipSetPenBrushFill(pen: GPPEN; brush: GPBRUSH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenBrushFill}

  function GdipGetPenBrushFill(pen: GPPEN;
    out brush: GPBRUSH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenBrushFill}

  function GdipGetPenFillType(pen: GPPEN;
    out type_: GPPENTYPE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenFillType}

  function GdipGetPenDashStyle(pen: GPPEN;
    out dashstyle: GPDASHSTYLE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenDashStyle}

  function GdipSetPenDashStyle(pen: GPPEN;
    dashstyle: GPDASHSTYLE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenDashStyle}

  function GdipGetPenDashOffset(pen: GPPEN;
    out offset: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenDashOffset}

  function GdipSetPenDashOffset(pen: GPPEN; offset: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenDashOffset}

  function GdipGetPenDashCount(pen: GPPEN;
    var count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenDashCount}

  function GdipSetPenDashArray(pen: GPPEN; dash: PSingle;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenDashArray}

  function GdipGetPenDashArray(pen: GPPEN; dash: PSingle;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenDashArray}

  function GdipGetPenCompoundCount(pen: GPPEN;
    out count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenCompoundCount}

  function GdipSetPenCompoundArray(pen: GPPEN; dash: PSingle;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPenCompoundArray}

  function GdipGetPenCompoundArray(pen: GPPEN; dash: PSingle;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPenCompoundArray}

//----------------------------------------------------------------------------
// CustomLineCap APIs
//----------------------------------------------------------------------------

  function GdipCreateCustomLineCap(fillPath: GPPATH; strokePath: GPPATH;
    baseCap: GPLINECAP; baseInset: Single;
    out customCap: GPCUSTOMLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateCustomLineCap}

  function GdipDeleteCustomLineCap(
    customCap: GPCUSTOMLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeleteCustomLineCap}

  function GdipCloneCustomLineCap(customCap: GPCUSTOMLINECAP;
    out clonedCap: GPCUSTOMLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneCustomLineCap}

  function GdipGetCustomLineCapType(customCap: GPCUSTOMLINECAP;
    var capType: CUSTOMLINECAPTYPE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetCustomLineCapType}

  function GdipSetCustomLineCapStrokeCaps(customCap: GPCUSTOMLINECAP;
    startCap: GPLINECAP; endCap: GPLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetCustomLineCapStrokeCaps}

  function GdipGetCustomLineCapStrokeCaps(customCap: GPCUSTOMLINECAP;
    var startCap: GPLINECAP; var endCap: GPLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetCustomLineCapStrokeCaps}

  function GdipSetCustomLineCapStrokeJoin(customCap: GPCUSTOMLINECAP;
  lineJoin: GPLINEJOIN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetCustomLineCapStrokeJoin}

  function GdipGetCustomLineCapStrokeJoin(customCap: GPCUSTOMLINECAP;
  var lineJoin: GPLINEJOIN): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetCustomLineCapStrokeJoin}

  function GdipSetCustomLineCapBaseCap(customCap: GPCUSTOMLINECAP;
  baseCap: GPLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetCustomLineCapBaseCap}

  function GdipGetCustomLineCapBaseCap(customCap: GPCUSTOMLINECAP;
  var baseCap: GPLINECAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetCustomLineCapBaseCap}

  function GdipSetCustomLineCapBaseInset(customCap: GPCUSTOMLINECAP;
  inset: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetCustomLineCapBaseInset}

  function GdipGetCustomLineCapBaseInset(customCap: GPCUSTOMLINECAP;
  var inset: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetCustomLineCapBaseInset}

  function GdipSetCustomLineCapWidthScale(customCap: GPCUSTOMLINECAP;
  widthScale: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetCustomLineCapWidthScale}

  function GdipGetCustomLineCapWidthScale(customCap: GPCUSTOMLINECAP;
  var widthScale: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetCustomLineCapWidthScale}

//----------------------------------------------------------------------------
// AdjustableArrowCap APIs
//----------------------------------------------------------------------------

  function GdipCreateAdjustableArrowCap(height: Single;
  width: Single;
  isFilled: Bool;
  out cap: GPADJUSTABLEARROWCAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateAdjustableArrowCap}

  function GdipSetAdjustableArrowCapHeight(cap: GPADJUSTABLEARROWCAP;
  height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetAdjustableArrowCapHeight}

  function GdipGetAdjustableArrowCapHeight(cap: GPADJUSTABLEARROWCAP;
  var height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetAdjustableArrowCapHeight}

  function GdipSetAdjustableArrowCapWidth(cap: GPADJUSTABLEARROWCAP;
  width: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetAdjustableArrowCapWidth}

  function GdipGetAdjustableArrowCapWidth(cap: GPADJUSTABLEARROWCAP;
  var width: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetAdjustableArrowCapWidth}

  function GdipSetAdjustableArrowCapMiddleInset(cap: GPADJUSTABLEARROWCAP;
  middleInset: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetAdjustableArrowCapMiddleInset}

  function GdipGetAdjustableArrowCapMiddleInset(cap: GPADJUSTABLEARROWCAP;
  var middleInset: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetAdjustableArrowCapMiddleInset}

  function GdipSetAdjustableArrowCapFillState(cap: GPADJUSTABLEARROWCAP;
  fillState: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetAdjustableArrowCapFillState}

  function GdipGetAdjustableArrowCapFillState(cap: GPADJUSTABLEARROWCAP;
  var fillState: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetAdjustableArrowCapFillState}

//---------------------------------------------------------------------------- 
// Image APIs
//----------------------------------------------------------------------------

  function GdipLoadImageFromStream(stream: ISTREAM;
  out image: GPIMAGE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipLoadImageFromStream}

  function GdipLoadImageFromFile(filename: PWCHAR;
  out image: GPIMAGE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipLoadImageFromFile}

  function GdipLoadImageFromStreamICM(stream: ISTREAM;
  out image: GPIMAGE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipLoadImageFromStreamICM}

  function GdipLoadImageFromFileICM(filename: PWCHAR;
  out image: GPIMAGE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipLoadImageFromFileICM}

  function GdipCloneImage(image: GPIMAGE;
  out cloneImage: GPIMAGE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneImage}

  function GdipDisposeImage(image: GPIMAGE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDisposeImage}

  function GdipSaveImageToFile(image: GPIMAGE;
  filename: PWCHAR;
  clsidEncoder: PGUID;
  encoderParams: PENCODERPARAMETERS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSaveImageToFile}

  function GdipSaveImageToStream(image: GPIMAGE;
  stream: ISTREAM;
  clsidEncoder: PGUID;
  encoderParams: PENCODERPARAMETERS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSaveImageToStream}

  function GdipSaveAdd(image: GPIMAGE;
  encoderParams: PENCODERPARAMETERS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSaveAdd}

  function GdipSaveAddImage(image: GPIMAGE;
  newImage: GPIMAGE;
  encoderParams: PENCODERPARAMETERS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSaveAddImage}

  function GdipGetImageGraphicsContext(image: GPIMAGE;
  out graphics: GPGRAPHICS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageGraphicsContext}

  function GdipGetImageBounds(image: GPIMAGE;
  srcRect: GPRECTF;
  var srcUnit: GPUNIT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageBounds}

  function GdipGetImageDimension(image: GPIMAGE;
  var width: Single;
  var height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageDimension}

  function GdipGetImageType(image: GPIMAGE;
  var type_: IMAGETYPE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageType}

  function GdipGetImageWidth(image: GPIMAGE;
  var width: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageWidth}

  function GdipGetImageHeight(image: GPIMAGE;
  var height: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageHeight}

  function GdipGetImageHorizontalResolution(image: GPIMAGE;
  var resolution: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageHorizontalResolution}

  function GdipGetImageVerticalResolution(image: GPIMAGE;
  var resolution: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageVerticalResolution}

  function GdipGetImageFlags(image: GPIMAGE;
  var flags: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageFlags}

  function GdipGetImageRawFormat(image: GPIMAGE;
  format: PGUID): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageRawFormat}

  function GdipGetImagePixelFormat(image: GPIMAGE;
  out format: TPIXELFORMAT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImagePixelFormat}

  function GdipGetImageThumbnail(image: GPIMAGE; thumbWidth: UINT;
    thumbHeight: UINT; out thumbImage: GPIMAGE;
    callback: GETTHUMBNAILIMAGEABORT; callbackData: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageThumbnail}

  function GdipGetEncoderParameterListSize(image: GPIMAGE;
    clsidEncoder: PGUID; out size: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetEncoderParameterListSize}

  function GdipGetEncoderParameterList(image: GPIMAGE; clsidEncoder: PGUID;
    size: UINT; buffer: PENCODERPARAMETERS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetEncoderParameterList}

  function GdipImageGetFrameDimensionsCount(image: GPIMAGE;
    var count: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipImageGetFrameDimensionsCount}

  function GdipImageGetFrameDimensionsList(image: GPIMAGE; dimensionIDs: PGUID;
    count: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipImageGetFrameDimensionsList}

  function GdipImageGetFrameCount(image: GPIMAGE; dimensionID: PGUID;
    var count: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipImageGetFrameCount}

  function GdipImageSelectActiveFrame(image: GPIMAGE; dimensionID: PGUID;
    frameIndex: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipImageSelectActiveFrame}

  function GdipImageRotateFlip(image: GPIMAGE;
    rfType: ROTATEFLIPTYPE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipImageRotateFlip}

  function GdipGetImagePalette(image: GPIMAGE; palette: PCOLORPALETTE;
    size: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImagePalette}

  function GdipSetImagePalette(image: GPIMAGE;
    palette: PCOLORPALETTE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImagePalette}

  function GdipGetImagePaletteSize(image: GPIMAGE;
    var size: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImagePaletteSize}

  function GdipGetPropertyCount(image: GPIMAGE;
    var numOfProperty: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPropertyCount}

  function GdipGetPropertyIdList(image: GPIMAGE; numOfProperty: UINT;
    list: PPROPID): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPropertyIdList}

  function GdipGetPropertyItemSize(image: GPIMAGE; propId: PROPID;
    var size: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPropertyItemSize}

  function GdipGetPropertyItem(image: GPIMAGE; propId: PROPID; propSize: UINT;
    buffer: PPROPERTYITEM): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPropertyItem}

  function GdipGetPropertySize(image: GPIMAGE; var totalBufferSize: UINT;
    var numProperties: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPropertySize}

  function GdipGetAllPropertyItems(image: GPIMAGE; totalBufferSize: UINT;
    numProperties: UINT; allItems: PPROPERTYITEM): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetAllPropertyItems}

  function GdipRemovePropertyItem(image: GPIMAGE;
    propId: PROPID): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRemovePropertyItem}

  function GdipSetPropertyItem(image: GPIMAGE;
    item: PPROPERTYITEM): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPropertyItem}

  function GdipImageForceValidation(image: GPIMAGE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipImageForceValidation}

//---------------------------------------------------------------------------- 
// Bitmap APIs
//----------------------------------------------------------------------------

  function GdipCreateBitmapFromStream(stream: ISTREAM;
    out bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromStream}

  function GdipCreateBitmapFromFile(filename: PWCHAR;
    out bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromFile}

  function GdipCreateBitmapFromStreamICM(stream: ISTREAM;
    out bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromStreamICM}

  function GdipCreateBitmapFromFileICM(filename: PWCHAR;
    var bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromFileICM}

  function GdipCreateBitmapFromScan0(width: Integer; height: Integer;
    stride: Integer; format: PIXELFORMAT; scan0: PBYTE;
    out bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromScan0}

  function GdipCreateBitmapFromGraphics(width: Integer; height: Integer;
    target: GPGRAPHICS; out bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromGraphics}

  function GdipCreateBitmapFromDirectDrawSurface(surface: IDIRECTDRAWSURFACE7;
    out bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromDirectDrawSurface}

  function GdipCreateBitmapFromGdiDib(gdiBitmapInfo: PBitmapInfo;
    gdiBitmapData: Pointer; out bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromGdiDib}

  function GdipCreateBitmapFromHBITMAP(hbm: HBITMAP; hpal: HPALETTE;
    out bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromHBITMAP}

  function GdipCreateHBITMAPFromBitmap(bitmap: GPBITMAP; out hbmReturn: HBITMAP;
    background: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateHBITMAPFromBitmap}

  function GdipCreateBitmapFromHICON(hicon: HICON;
    out bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromHICON}

  function GdipCreateHICONFromBitmap(bitmap: GPBITMAP;
    out hbmReturn: HICON): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateHICONFromBitmap}

  function GdipCreateBitmapFromResource(hInstance: HMODULE;
    lpBitmapName: PWCHAR; out bitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateBitmapFromResource}

  function GdipCloneBitmapArea(x: Single; y: Single; width: Single;
    height: Single; format: PIXELFORMAT; srcBitmap: GPBITMAP;
    out dstBitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneBitmapArea}

  function GdipCloneBitmapAreaI(x: Integer; y: Integer; width: Integer;
    height: Integer; format: PIXELFORMAT; srcBitmap: GPBITMAP;
    out dstBitmap: GPBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneBitmapAreaI}

  function GdipBitmapLockBits(bitmap: GPBITMAP; rect: GPRECT; flags: UINT;
    format: PIXELFORMAT; lockedBitmapData: PBITMAPDATA): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipBitmapLockBits}

  function GdipBitmapUnlockBits(bitmap: GPBITMAP;
    lockedBitmapData: PBITMAPDATA): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipBitmapUnlockBits}

  function GdipBitmapGetPixel(bitmap: GPBITMAP; x: Integer; y: Integer;
    var color: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipBitmapGetPixel}

  function GdipBitmapSetPixel(bitmap: GPBITMAP; x: Integer; y: Integer;
    color: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipBitmapSetPixel}

  function GdipBitmapSetResolution(bitmap: GPBITMAP; xdpi: Single;
    ydpi: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipBitmapSetResolution}

//----------------------------------------------------------------------------
// ImageAttributes APIs
//----------------------------------------------------------------------------

  function GdipCreateImageAttributes(
    out imageattr: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateImageAttributes}

  function GdipCloneImageAttributes(imageattr: GPIMAGEATTRIBUTES;
    out cloneImageattr: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneImageAttributes}

  function GdipDisposeImageAttributes(
    imageattr: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDisposeImageAttributes}

  function GdipSetImageAttributesToIdentity(imageattr: GPIMAGEATTRIBUTES;
    type_: COLORADJUSTTYPE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesToIdentity}

  function GdipResetImageAttributes(imageattr: GPIMAGEATTRIBUTES;
    type_: COLORADJUSTTYPE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipResetImageAttributes}

  function GdipSetImageAttributesColorMatrix(imageattr: GPIMAGEATTRIBUTES;
    type_: COLORADJUSTTYPE; enableFlag: Bool; colorMatrix: PCOLORMATRIX;
    grayMatrix: PCOLORMATRIX; flags: COLORMATRIXFLAGS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesColorMatrix}

  function GdipSetImageAttributesThreshold(imageattr: GPIMAGEATTRIBUTES;
    type_: COLORADJUSTTYPE; enableFlag: Bool;
    threshold: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesThreshold}

  function GdipSetImageAttributesGamma(imageattr: GPIMAGEATTRIBUTES;
    type_: COLORADJUSTTYPE; enableFlag: Bool; gamma: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesGamma}

  function GdipSetImageAttributesNoOp(imageattr: GPIMAGEATTRIBUTES;
  type_: COLORADJUSTTYPE; enableFlag: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesNoOp}

  function GdipSetImageAttributesColorKeys(imageattr: GPIMAGEATTRIBUTES;
    type_: COLORADJUSTTYPE; enableFlag: Bool; colorLow: ARGB;
    colorHigh: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesColorKeys}

  function GdipSetImageAttributesOutputChannel(imageattr: GPIMAGEATTRIBUTES;
    type_: COLORADJUSTTYPE; enableFlag: Bool;
    channelFlags: COLORCHANNELFLAGS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesOutputChannel}

  function GdipSetImageAttributesOutputChannelColorProfile(imageattr: GPIMAGEATTRIBUTES;
    type_: COLORADJUSTTYPE; enableFlag: Bool;
    colorProfileFilename: PWCHAR): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesOutputChannelColorProfile}

  function GdipSetImageAttributesRemapTable(imageattr: GPIMAGEATTRIBUTES;
    type_: COLORADJUSTTYPE; enableFlag: Bool; mapSize: UINT;
    map: PCOLORMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesRemapTable}

  function GdipSetImageAttributesWrapMode(imageAttr: GPIMAGEATTRIBUTES;
    wrap: WRAPMODE; argb: ARGB; clamp: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesWrapMode}

  function GdipSetImageAttributesICMMode(imageAttr: GPIMAGEATTRIBUTES;
    on_: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetImageAttributesICMMode}

  function GdipGetImageAttributesAdjustedPalette(imageAttr: GPIMAGEATTRIBUTES;
    colorPalette: PCOLORPALETTE;
    colorAdjustType: COLORADJUSTTYPE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageAttributesAdjustedPalette}

//----------------------------------------------------------------------------
// Graphics APIs
//----------------------------------------------------------------------------

  function GdipFlush(graphics: GPGRAPHICS;
    intention: GPFLUSHINTENTION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFlush}

  function GdipCreateFromHDC(hdc: HDC;
    out graphics: GPGRAPHICS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateFromHDC}

  function GdipCreateFromHDC2(hdc: HDC; hDevice: THandle;
    out graphics: GPGRAPHICS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateFromHDC2}

  function GdipCreateFromHWND(hwnd: HWND;
    out graphics: GPGRAPHICS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateFromHWND}

  function GdipCreateFromHWNDICM(hwnd: HWND;
    out graphics: GPGRAPHICS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateFromHWNDICM}

  function GdipDeleteGraphics(graphics: GPGRAPHICS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeleteGraphics}

  function GdipGetDC(graphics: GPGRAPHICS; var hdc: HDC): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetDC}

  function GdipReleaseDC(graphics: GPGRAPHICS; hdc: HDC): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipReleaseDC}

  function GdipSetCompositingMode(graphics: GPGRAPHICS;
    compositingMode: COMPOSITINGMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetCompositingMode}

  function GdipGetCompositingMode(graphics: GPGRAPHICS;
    var compositingMode: COMPOSITINGMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetCompositingMode}

  function GdipSetRenderingOrigin(graphics: GPGRAPHICS; x: Integer;
    y: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetRenderingOrigin}

  function GdipGetRenderingOrigin(graphics: GPGRAPHICS; var x: Integer;
    var y: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetRenderingOrigin}

  function GdipSetCompositingQuality(graphics: GPGRAPHICS;
    compositingQuality: COMPOSITINGQUALITY): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetCompositingQuality}

  function GdipGetCompositingQuality(graphics: GPGRAPHICS;
    var compositingQuality: COMPOSITINGQUALITY): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetCompositingQuality}

  function GdipSetSmoothingMode(graphics: GPGRAPHICS;
    smoothingMode: SMOOTHINGMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetSmoothingMode}

  function GdipGetSmoothingMode(graphics: GPGRAPHICS;
    var smoothingMode: SMOOTHINGMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetSmoothingMode}

  function GdipSetPixelOffsetMode(graphics: GPGRAPHICS;
    pixelOffsetMode: PIXELOFFSETMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPixelOffsetMode}

  function GdipGetPixelOffsetMode(graphics: GPGRAPHICS;
    var pixelOffsetMode: PIXELOFFSETMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPixelOffsetMode}

  function GdipSetTextRenderingHint(graphics: GPGRAPHICS;
    mode: TEXTRENDERINGHINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetTextRenderingHint}

  function GdipGetTextRenderingHint(graphics: GPGRAPHICS;
    var mode: TEXTRENDERINGHINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetTextRenderingHint}

  function GdipSetTextContrast(graphics: GPGRAPHICS;
    contrast: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetTextContrast}

  function GdipGetTextContrast(graphics: GPGRAPHICS;
    var contrast: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetTextContrast}

  function GdipSetInterpolationMode(graphics: GPGRAPHICS;
    interpolationMode: INTERPOLATIONMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetInterpolationMode}

  function GdipGetInterpolationMode(graphics: GPGRAPHICS;
    var interpolationMode: INTERPOLATIONMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetInterpolationMode}

  function GdipSetWorldTransform(graphics: GPGRAPHICS;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetWorldTransform}

  function GdipResetWorldTransform(graphics: GPGRAPHICS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipResetWorldTransform}

  function GdipMultiplyWorldTransform(graphics: GPGRAPHICS; matrix: GPMATRIX;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipMultiplyWorldTransform}

  function GdipTranslateWorldTransform(graphics: GPGRAPHICS; dx: Single;
    dy: Single; order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTranslateWorldTransform}

  function GdipScaleWorldTransform(graphics: GPGRAPHICS; sx: Single; sy: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipScaleWorldTransform}

  function GdipRotateWorldTransform(graphics: GPGRAPHICS; angle: Single;
    order: GPMATRIXORDER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRotateWorldTransform}

  function GdipGetWorldTransform(graphics: GPGRAPHICS;
    matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetWorldTransform}

  function GdipResetPageTransform(graphics: GPGRAPHICS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipResetPageTransform}

  function GdipGetPageUnit(graphics: GPGRAPHICS;
    var unit_: GPUNIT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPageUnit}

  function GdipGetPageScale(graphics: GPGRAPHICS;
    var scale: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetPageScale}

  function GdipSetPageUnit(graphics: GPGRAPHICS;
    unit_: GPUNIT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPageUnit}

  function GdipSetPageScale(graphics: GPGRAPHICS;
    scale: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetPageScale}

  function GdipGetDpiX(graphics: GPGRAPHICS;
    var dpi: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetDpiX}

  function GdipGetDpiY(graphics: GPGRAPHICS;
    var dpi: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetDpiY}

  function GdipTransformPoints(graphics: GPGRAPHICS;
    destSpace: GPCOORDINATESPACE; srcSpace: GPCOORDINATESPACE;
    points: GPPOINTF; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTransformPoints}

  function GdipTransformPointsI(graphics: GPGRAPHICS;
    destSpace: GPCOORDINATESPACE; srcSpace: GPCOORDINATESPACE;
    points: GPPOINT; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTransformPointsI}

  function GdipGetNearestColor(graphics: GPGRAPHICS;
    argb: PARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetNearestColor}

// Creates the Win9x Halftone Palette (even on NT) with correct Desktop colors

  function GdipCreateHalftonePalette: HPALETTE; stdcall;
  {$EXTERNALSYM GdipCreateHalftonePalette}

  function GdipDrawLine(graphics: GPGRAPHICS; pen: GPPEN; x1: Single;
    y1: Single; x2: Single; y2: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawLine}

  function GdipDrawLineI(graphics: GPGRAPHICS; pen: GPPEN; x1: Integer;
    y1: Integer; x2: Integer; y2: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawLineI}

  function GdipDrawLines(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawLines}

  function GdipDrawLinesI(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawLinesI}

  function GdipDrawArc(graphics: GPGRAPHICS; pen: GPPEN; x: Single; y: Single;
    width: Single; height: Single; startAngle: Single;
    sweepAngle: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawArc}

  function GdipDrawArcI(graphics: GPGRAPHICS; pen: GPPEN; x: Integer;
    y: Integer; width: Integer; height: Integer; startAngle: Single;
    sweepAngle: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawArcI}

  function GdipDrawBezier(graphics: GPGRAPHICS; pen: GPPEN; x1: Single;
    y1: Single; x2: Single; y2: Single; x3: Single; y3: Single; x4: Single;
    y4: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawBezier}

  function GdipDrawBezierI(graphics: GPGRAPHICS; pen: GPPEN; x1: Integer;
    y1: Integer; x2: Integer; y2: Integer; x3: Integer; y3: Integer;
    x4: Integer; y4: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawBezierI}

  function GdipDrawBeziers(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawBeziers}

  function GdipDrawBeziersI(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawBeziersI}

  function GdipDrawRectangle(graphics: GPGRAPHICS; pen: GPPEN; x: Single;
    y: Single; width: Single; height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawRectangle}

  function GdipDrawRectangleI(graphics: GPGRAPHICS; pen: GPPEN; x: Integer;
    y: Integer; width: Integer; height: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawRectangleI}

  function GdipDrawRectangles(graphics: GPGRAPHICS; pen: GPPEN; rects: GPRECTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawRectangles}

  function GdipDrawRectanglesI(graphics: GPGRAPHICS; pen: GPPEN; rects: GPRECT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawRectanglesI}

  function GdipDrawEllipse(graphics: GPGRAPHICS; pen: GPPEN; x: Single;
    y: Single; width: Single; height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawEllipse}

  function GdipDrawEllipseI(graphics: GPGRAPHICS; pen: GPPEN; x: Integer;
    y: Integer; width: Integer; height: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawEllipseI}

  function GdipDrawPie(graphics: GPGRAPHICS; pen: GPPEN; x: Single; y: Single;
    width: Single;  height: Single; startAngle: Single;
    sweepAngle: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawPie}

  function GdipDrawPieI(graphics: GPGRAPHICS; pen: GPPEN; x: Integer;
    y: Integer; width: Integer; height: Integer; startAngle: Single;
    sweepAngle: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawPieI}

  function GdipDrawPolygon(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawPolygon}

  function GdipDrawPolygonI(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawPolygonI}

  function GdipDrawPath(graphics: GPGRAPHICS; pen: GPPEN;
    path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawPath}

  function GdipDrawCurve(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINTF;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawCurve}

  function GdipDrawCurveI(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINT;
    count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawCurveI}

  function GdipDrawCurve2(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINTF;
    count: Integer; tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawCurve2}

  function GdipDrawCurve2I(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINT;
    count: Integer; tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawCurve2I}

  function GdipDrawCurve3(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINTF;
    count: Integer; offset: Integer; numberOfSegments: Integer;
    tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawCurve3}

  function GdipDrawCurve3I(graphics: GPGRAPHICS; pen: GPPEN; points: GPPOINT;
    count: Integer; offset: Integer; numberOfSegments: Integer;
    tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawCurve3I}

  function GdipDrawClosedCurve(graphics: GPGRAPHICS; pen: GPPEN;
    points: GPPOINTF; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawClosedCurve}

  function GdipDrawClosedCurveI(graphics: GPGRAPHICS; pen: GPPEN;
    points: GPPOINT; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawClosedCurveI}

  function GdipDrawClosedCurve2(graphics: GPGRAPHICS; pen: GPPEN;
    points: GPPOINTF; count: Integer; tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawClosedCurve2}

  function GdipDrawClosedCurve2I(graphics: GPGRAPHICS; pen: GPPEN;
    points: GPPOINT; count: Integer; tension: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawClosedCurve2I}

  function GdipGraphicsClear(graphics: GPGRAPHICS;
    color: ARGB): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGraphicsClear}

  function GdipFillRectangle(graphics: GPGRAPHICS; brush: GPBRUSH; x: Single;
    y: Single; width: Single; height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillRectangle}

  function GdipFillRectangleI(graphics: GPGRAPHICS; brush: GPBRUSH; x: Integer;
    y: Integer; width: Integer; height: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillRectangleI}

  function GdipFillRectangles(graphics: GPGRAPHICS; brush: GPBRUSH;
    rects: GPRECTF; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillRectangles}

  function GdipFillRectanglesI(graphics: GPGRAPHICS; brush: GPBRUSH;
    rects: GPRECT; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillRectanglesI}

  function GdipFillPolygon(graphics: GPGRAPHICS; brush: GPBRUSH;
    points: GPPOINTF; count: Integer; fillMode: GPFILLMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillPolygon}

  function GdipFillPolygonI(graphics: GPGRAPHICS; brush: GPBRUSH;
    points: GPPOINT; count: Integer; fillMode: GPFILLMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillPolygonI}

  function GdipFillPolygon2(graphics: GPGRAPHICS; brush: GPBRUSH;
    points: GPPOINTF; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillPolygon2}

  function GdipFillPolygon2I(graphics: GPGRAPHICS; brush: GPBRUSH;
    points: GPPOINT; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillPolygon2I}

  function GdipFillEllipse(graphics: GPGRAPHICS; brush: GPBRUSH; x: Single;
    y: Single; width: Single; height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillEllipse}

  function GdipFillEllipseI(graphics: GPGRAPHICS; brush: GPBRUSH; x: Integer;
    y: Integer; width: Integer; height: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillEllipseI}

  function GdipFillPie(graphics: GPGRAPHICS; brush: GPBRUSH; x: Single;
    y: Single; width: Single; height: Single; startAngle: Single;
    sweepAngle: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillPie}

  function GdipFillPieI(graphics: GPGRAPHICS; brush: GPBRUSH; x: Integer;
    y: Integer; width: Integer; height: Integer; startAngle: Single;
    sweepAngle: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillPieI}

  function GdipFillPath(graphics: GPGRAPHICS; brush: GPBRUSH;
    path: GPPATH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillPath}

  function GdipFillClosedCurve(graphics: GPGRAPHICS; brush: GPBRUSH;
    points: GPPOINTF; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillClosedCurve}

  function GdipFillClosedCurveI(graphics: GPGRAPHICS; brush: GPBRUSH;
    points: GPPOINT; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillClosedCurveI}

  function GdipFillClosedCurve2(graphics: GPGRAPHICS; brush: GPBRUSH;
    points: GPPOINTF; count: Integer; tension: Single;
    fillMode: GPFILLMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillClosedCurve2}

  function GdipFillClosedCurve2I(graphics: GPGRAPHICS; brush: GPBRUSH;
    points: GPPOINT; count: Integer; tension: Single;
    fillMode: GPFILLMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillClosedCurve2I}

  function GdipFillRegion(graphics: GPGRAPHICS; brush: GPBRUSH;
    region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFillRegion}

  function GdipDrawImage(graphics: GPGRAPHICS; image: GPIMAGE; x: Single;
    y: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImage}

  function GdipDrawImageI(graphics: GPGRAPHICS; image: GPIMAGE; x: Integer;
    y: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImageI}

  function GdipDrawImageRect(graphics: GPGRAPHICS; image: GPIMAGE; x: Single;
    y: Single; width: Single; height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImageRect}

  function GdipDrawImageRectI(graphics: GPGRAPHICS; image: GPIMAGE; x: Integer;
    y: Integer; width: Integer; height: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImageRectI}

  function GdipDrawImagePoints(graphics: GPGRAPHICS; image: GPIMAGE;
    dstpoints: GPPOINTF; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImagePoints}

  function GdipDrawImagePointsI(graphics: GPGRAPHICS; image: GPIMAGE;
    dstpoints: GPPOINT; count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImagePointsI}

  function GdipDrawImagePointRect(graphics: GPGRAPHICS; image: GPIMAGE;
    x: Single; y: Single; srcx: Single; srcy: Single; srcwidth: Single;
    srcheight: Single; srcUnit: GPUNIT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImagePointRect}

  function GdipDrawImagePointRectI(graphics: GPGRAPHICS; image: GPIMAGE;
    x: Integer; y: Integer; srcx: Integer; srcy: Integer; srcwidth: Integer;
    srcheight: Integer; srcUnit: GPUNIT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImagePointRectI}

  function GdipDrawImageRectRect(graphics: GPGRAPHICS; image: GPIMAGE;
    dstx: Single; dsty: Single; dstwidth: Single; dstheight: Single;
    srcx: Single; srcy: Single; srcwidth: Single; srcheight: Single;
    srcUnit: GPUNIT; imageAttributes: GPIMAGEATTRIBUTES;
    callback: DRAWIMAGEABORT; callbackData: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImageRectRect}

  function GdipDrawImageRectRectI(graphics: GPGRAPHICS; image: GPIMAGE;
    dstx: Integer; dsty: Integer; dstwidth: Integer; dstheight: Integer;
    srcx: Integer; srcy: Integer; srcwidth: Integer; srcheight: Integer;
    srcUnit: GPUNIT; imageAttributes: GPIMAGEATTRIBUTES;
    callback: DRAWIMAGEABORT; callbackData: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImageRectRectI}

  function GdipDrawImagePointsRect(graphics: GPGRAPHICS; image: GPIMAGE;
    points: GPPOINTF; count: Integer; srcx: Single; srcy: Single;
    srcwidth: Single; srcheight: Single; srcUnit: GPUNIT;
    imageAttributes: GPIMAGEATTRIBUTES; callback: DRAWIMAGEABORT;
    callbackData: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImagePointsRect}

  function GdipDrawImagePointsRectI(graphics: GPGRAPHICS; image: GPIMAGE;
    points: GPPOINT; count: Integer; srcx: Integer; srcy: Integer;
    srcwidth: Integer; srcheight: Integer; srcUnit: GPUNIT;
    imageAttributes: GPIMAGEATTRIBUTES; callback: DRAWIMAGEABORT;
    callbackData: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawImagePointsRectI}

  function GdipEnumerateMetafileDestPoint(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destPoint: PGPPointF; callback: ENUMERATEMETAFILEPROC;
    callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileDestPoint}

  function GdipEnumerateMetafileDestPointI(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destPoint: PGPPoint; callback: ENUMERATEMETAFILEPROC;
    callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileDestPointI}

  function GdipEnumerateMetafileDestRect(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destRect: PGPRectF; callback: ENUMERATEMETAFILEPROC;
    callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileDestRect}

  function GdipEnumerateMetafileDestRectI(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destRect: PGPRect; callback: ENUMERATEMETAFILEPROC;
    callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileDestRectI}

  function GdipEnumerateMetafileDestPoints(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destPoints: PGPPointF; count: Integer;
    callback: ENUMERATEMETAFILEPROC; callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileDestPoints}

  function GdipEnumerateMetafileDestPointsI(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destPoints: PGPPoint; count: Integer;
    callback: ENUMERATEMETAFILEPROC; callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileDestPointsI}

  function GdipEnumerateMetafileSrcRectDestPoint(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destPoint: PGPPointF; srcRect: PGPRectF; srcUnit: TUNIT;
    callback: ENUMERATEMETAFILEPROC; callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileSrcRectDestPoint}

  function GdipEnumerateMetafileSrcRectDestPointI(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destPoint: PGPPoint; srcRect: PGPRect; srcUnit: TUNIT;
    callback: ENUMERATEMETAFILEPROC; callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileSrcRectDestPointI}

  function GdipEnumerateMetafileSrcRectDestRect(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destRect: PGPRectF; srcRect: PGPRectF; srcUnit: TUNIT;
    callback: ENUMERATEMETAFILEPROC; callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileSrcRectDestRect}

  function GdipEnumerateMetafileSrcRectDestRectI(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destRect: PGPRect; srcRect: PGPRect; srcUnit: TUNIT;
    callback: ENUMERATEMETAFILEPROC; callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileSrcRectDestRectI}

  function GdipEnumerateMetafileSrcRectDestPoints(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destPoints: PGPPointF; count: Integer; srcRect: PGPRectF;
    srcUnit: TUNIT; callback: ENUMERATEMETAFILEPROC; callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileSrcRectDestPoints}

  function GdipEnumerateMetafileSrcRectDestPointsI(graphics: GPGRAPHICS;
    metafile: GPMETAFILE; destPoints: PGPPoint; count: Integer; srcRect: PGPRect;
    srcUnit: TUNIT; callback: ENUMERATEMETAFILEPROC; callbackData: Pointer;
    imageAttributes: GPIMAGEATTRIBUTES): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEnumerateMetafileSrcRectDestPointsI}

  function GdipPlayMetafileRecord(metafile: GPMETAFILE;
    recordType: EMFPLUSRECORDTYPE; flags: UINT; dataSize: UINT;
    data: PBYTE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPlayMetafileRecord}

  function GdipSetClipGraphics(graphics: GPGRAPHICS; srcgraphics: GPGRAPHICS;
    combineMode: COMBINEMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetClipGraphics}

  function GdipSetClipRect(graphics: GPGRAPHICS; x: Single; y: Single;
    width: Single; height: Single; combineMode: COMBINEMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetClipRect}

  function GdipSetClipRectI(graphics: GPGRAPHICS; x: Integer; y: Integer;
    width: Integer; height: Integer;
    combineMode: COMBINEMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetClipRectI}

  function GdipSetClipPath(graphics: GPGRAPHICS; path: GPPATH;
    combineMode: COMBINEMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetClipPath}

  function GdipSetClipRegion(graphics: GPGRAPHICS; region: GPREGION;
    combineMode: COMBINEMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetClipRegion}

  function GdipSetClipHrgn(graphics: GPGRAPHICS; hRgn: HRGN;
    combineMode: COMBINEMODE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetClipHrgn}

  function GdipResetClip(graphics: GPGRAPHICS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipResetClip}

  function GdipTranslateClip(graphics: GPGRAPHICS; dx: Single;
    dy: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTranslateClip}

  function GdipTranslateClipI(graphics: GPGRAPHICS; dx: Integer;
    dy: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipTranslateClipI}

  function GdipGetClip(graphics: GPGRAPHICS;
    region: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetClip}

  function GdipGetClipBounds(graphics: GPGRAPHICS;
    rect: GPRECTF): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetClipBounds}

  function GdipGetClipBoundsI(graphics: GPGRAPHICS;
    rect: GPRECT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetClipBoundsI}

  function GdipIsClipEmpty(graphics: GPGRAPHICS;
    result: PBool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsClipEmpty}

  function GdipGetVisibleClipBounds(graphics: GPGRAPHICS;
    rect: GPRECTF): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetVisibleClipBounds}

  function GdipGetVisibleClipBoundsI(graphics: GPGRAPHICS;
    rect: GPRECT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetVisibleClipBoundsI}

  function GdipIsVisibleClipEmpty(graphics: GPGRAPHICS;
    var result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisibleClipEmpty}

  function GdipIsVisiblePoint(graphics: GPGRAPHICS; x: Single; y: Single;
    var result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisiblePoint}

  function GdipIsVisiblePointI(graphics: GPGRAPHICS; x: Integer; y: Integer;
    var result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisiblePointI}

  function GdipIsVisibleRect(graphics: GPGRAPHICS; x: Single; y: Single;
    width: Single; height: Single; var result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisibleRect}

  function GdipIsVisibleRectI(graphics: GPGRAPHICS; x: Integer; y: Integer;
    width: Integer; height: Integer; var result: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsVisibleRectI}

  function GdipSaveGraphics(graphics: GPGRAPHICS;
    var state: GRAPHICSSTATE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSaveGraphics}

  function GdipRestoreGraphics(graphics: GPGRAPHICS;
    state: GRAPHICSSTATE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRestoreGraphics}

  function GdipBeginContainer(graphics: GPGRAPHICS; dstrect: GPRECTF;
    srcrect: GPRECTF; unit_: GPUNIT;
    var state: GRAPHICSCONTAINER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipBeginContainer}

  function GdipBeginContainerI(graphics: GPGRAPHICS; dstrect: GPRECT;
    srcrect: GPRECT; unit_: GPUNIT;
    var state: GRAPHICSCONTAINER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipBeginContainerI}

  function GdipBeginContainer2(graphics: GPGRAPHICS;
    var state: GRAPHICSCONTAINER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipBeginContainer2}

  function GdipEndContainer(graphics: GPGRAPHICS;
    state: GRAPHICSCONTAINER): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipEndContainer}

  function GdipGetMetafileHeaderFromWmf(hWmf: HMETAFILE;
    wmfPlaceableFileHeader: PWMFPLACEABLEFILEHEADER;
    header: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetMetafileHeaderFromWmf}

  function GdipGetMetafileHeaderFromEmf(hEmf: HENHMETAFILE;
    header: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetMetafileHeaderFromEmf}

  function GdipGetMetafileHeaderFromFile(filename: PWCHAR;
    header: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetMetafileHeaderFromFile}

  function GdipGetMetafileHeaderFromStream(stream: ISTREAM;
    header: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetMetafileHeaderFromStream}

  function GdipGetMetafileHeaderFromMetafile(metafile: GPMETAFILE;
    header: Pointer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetMetafileHeaderFromMetafile}

  function GdipGetHemfFromMetafile(metafile: GPMETAFILE;
    var hEmf: HENHMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetHemfFromMetafile}

  function GdipCreateStreamOnFile(filename: PWCHAR; access: UINT;
    out stream: ISTREAM): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateStreamOnFile}

  function GdipCreateMetafileFromWmf(hWmf: HMETAFILE; deleteWmf: Bool;
    wmfPlaceableFileHeader: PWMFPLACEABLEFILEHEADER;
    out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateMetafileFromWmf}

  function GdipCreateMetafileFromEmf(hEmf: HENHMETAFILE; deleteEmf: Bool;
    out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateMetafileFromEmf}

  function GdipCreateMetafileFromFile(file_: PWCHAR;
    out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateMetafileFromFile}

  function GdipCreateMetafileFromWmfFile(file_: PWCHAR;
    wmfPlaceableFileHeader: PWMFPLACEABLEFILEHEADER;
    out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateMetafileFromWmfFile}

  function GdipCreateMetafileFromStream(stream: ISTREAM;
    out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateMetafileFromStream}

  function GdipRecordMetafile(referenceHdc: HDC; type_: EMFTYPE;
    frameRect: GPRECTF; frameUnit: METAFILEFRAMEUNIT;
    description: PWCHAR; out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRecordMetafile}

  function GdipRecordMetafileI(referenceHdc: HDC; type_: EMFTYPE;
    frameRect: GPRECT; frameUnit: METAFILEFRAMEUNIT; description: PWCHAR;
    out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRecordMetafileI}

  function GdipRecordMetafileFileName(fileName: PWCHAR; referenceHdc: HDC;
    type_: EMFTYPE; frameRect: GPRECTF; frameUnit: METAFILEFRAMEUNIT;
    description: PWCHAR; out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRecordMetafileFileName}

  function GdipRecordMetafileFileNameI(fileName: PWCHAR; referenceHdc: HDC;
    type_: EMFTYPE; frameRect: GPRECT; frameUnit: METAFILEFRAMEUNIT;
    description: PWCHAR; out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRecordMetafileFileNameI}

  function GdipRecordMetafileStream(stream: ISTREAM; referenceHdc: HDC;
    type_: EMFTYPE; frameRect: GPRECTF; frameUnit: METAFILEFRAMEUNIT;
    description: PWCHAR; out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRecordMetafileStream}

  function GdipRecordMetafileStreamI(stream: ISTREAM; referenceHdc: HDC;
    type_: EMFTYPE; frameRect: GPRECT; frameUnit: METAFILEFRAMEUNIT;
    description: PWCHAR; out metafile: GPMETAFILE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipRecordMetafileStreamI}

  function GdipSetMetafileDownLevelRasterizationLimit(metafile: GPMETAFILE;
    metafileRasterizationLimitDpi: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetMetafileDownLevelRasterizationLimit}

  function GdipGetMetafileDownLevelRasterizationLimit(metafile: GPMETAFILE;
    var metafileRasterizationLimitDpi: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetMetafileDownLevelRasterizationLimit}

  function GdipGetImageDecodersSize(out numDecoders: UINT;
    out size: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageDecodersSize}

  function GdipGetImageDecoders(numDecoders: UINT; size: UINT;
    decoders: PIMAGECODECINFO): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageDecoders}

  function GdipGetImageEncodersSize(out numEncoders: UINT;
    out size: UINT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageEncodersSize}

  function GdipGetImageEncoders(numEncoders: UINT; size: UINT;
    encoders: PIMAGECODECINFO): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetImageEncoders}

  function GdipComment(graphics: GPGRAPHICS; sizeData: UINT;
    data: PBYTE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipComment}

//----------------------------------------------------------------------------
// FontFamily APIs
//----------------------------------------------------------------------------

  function GdipCreateFontFamilyFromName(name: PWCHAR;
    fontCollection: GPFONTCOLLECTION;
    out FontFamily: GPFONTFAMILY): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateFontFamilyFromName}

  function GdipDeleteFontFamily(FontFamily: GPFONTFAMILY): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeleteFontFamily}

  function GdipCloneFontFamily(FontFamily: GPFONTFAMILY;
    out clonedFontFamily: GPFONTFAMILY): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneFontFamily}

  function GdipGetGenericFontFamilySansSerif(
    out nativeFamily: GPFONTFAMILY): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetGenericFontFamilySansSerif}

  function GdipGetGenericFontFamilySerif(
    out nativeFamily: GPFONTFAMILY): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetGenericFontFamilySerif}

  function GdipGetGenericFontFamilyMonospace(
    out nativeFamily: GPFONTFAMILY): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetGenericFontFamilyMonospace}

  function GdipGetFamilyName(family: GPFONTFAMILY; name: PWideChar;
    language: LANGID): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetFamilyName}

  function GdipIsStyleAvailable(family: GPFONTFAMILY; style: Integer;
    var IsStyleAvailable: Bool): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipIsStyleAvailable}

  function GdipFontCollectionEnumerable(fontCollection: GPFONTCOLLECTION;
    graphics: GPGRAPHICS; var numFound: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFontCollectionEnumerable}

  function GdipFontCollectionEnumerate(fontCollection: GPFONTCOLLECTION;
    numSought: Integer; gpfamilies: array of GPFONTFAMILY;
    var numFound: Integer; graphics: GPGRAPHICS): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipFontCollectionEnumerate}

  function GdipGetEmHeight(family: GPFONTFAMILY; style: Integer;
    out EmHeight: UINT16): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetEmHeight}

  function GdipGetCellAscent(family: GPFONTFAMILY; style: Integer;
    var CellAscent: UINT16): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetCellAscent}

  function GdipGetCellDescent(family: GPFONTFAMILY; style: Integer;
    var CellDescent: UINT16): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetCellDescent}

  function GdipGetLineSpacing(family: GPFONTFAMILY; style: Integer;
    var LineSpacing: UINT16): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLineSpacing}

//----------------------------------------------------------------------------
// Font APIs
//----------------------------------------------------------------------------

  function GdipCreateFontFromDC(hdc: HDC; out font: GPFONT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateFontFromDC}

  function GdipCreateFontFromLogfontA(hdc: HDC; logfont: PLOGFONTA;
    out font: GPFONT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateFontFromLogfontA}

  function GdipCreateFontFromLogfontW(hdc: HDC; logfont: PLOGFONTW;
    out font: GPFONT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateFontFromLogfontW}

  function GdipCreateFont(fontFamily: GPFONTFAMILY; emSize: Single;
    style: Integer; unit_: Integer; out font: GPFONT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateFont}

  function GdipCloneFont(font: GPFONT;
    out cloneFont: GPFONT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneFont}

  function GdipDeleteFont(font: GPFONT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeleteFont}

  function GdipGetFamily(font: GPFONT;
    out family: GPFONTFAMILY): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetFamily}

  function GdipGetFontStyle(font: GPFONT;
    var style: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetFontStyle}

  function GdipGetFontSize(font: GPFONT; var size: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetFontSize}

  function GdipGetFontUnit(font: GPFONT; var unit_: TUNIT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetFontUnit}

  function GdipGetFontHeight(font: GPFONT; graphics: GPGRAPHICS;
    var height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetFontHeight}

  function GdipGetFontHeightGivenDPI(font: GPFONT; dpi: Single;
    var height: Single): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetFontHeightGivenDPI}

  function GdipGetLogFontA(font: GPFONT; graphics: GPGRAPHICS;
    var logfontA: LOGFONTA): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLogFontA}

  function GdipGetLogFontW(font: GPFONT; graphics: GPGRAPHICS;
    var logfontW: LOGFONTW): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetLogFontW}

  function GdipNewInstalledFontCollection(
    out fontCollection: GPFONTCOLLECTION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipNewInstalledFontCollection}

  function GdipNewPrivateFontCollection(
    out fontCollection: GPFONTCOLLECTION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipNewPrivateFontCollection}

  function GdipDeletePrivateFontCollection(
    out fontCollection: GPFONTCOLLECTION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeletePrivateFontCollection}

  function GdipGetFontCollectionFamilyCount(fontCollection: GPFONTCOLLECTION;
    var numFound: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetFontCollectionFamilyCount}

  function GdipGetFontCollectionFamilyList(fontCollection: GPFONTCOLLECTION;
    numSought: Integer; gpfamilies: GPFONTFAMILY;
    var numFound: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetFontCollectionFamilyList}

  function GdipPrivateAddFontFile(fontCollection: GPFONTCOLLECTION;
    filename: PWCHAR): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPrivateAddFontFile}

  function GdipPrivateAddMemoryFont(fontCollection: GPFONTCOLLECTION;
    memory: Pointer; length: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipPrivateAddMemoryFont}

//----------------------------------------------------------------------------
// Text APIs
//----------------------------------------------------------------------------

  function GdipDrawString(graphics: GPGRAPHICS; string_: PWCHAR;
    length: Integer; font: GPFONT; layoutRect: PGPRectF;
    stringFormat: GPSTRINGFORMAT; brush: GPBRUSH): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawString}

  function GdipMeasureString(graphics: GPGRAPHICS; string_: PWCHAR;
    length: Integer; font: GPFONT; layoutRect: PGPRectF;
    stringFormat: GPSTRINGFORMAT; boundingBox: PGPRectF;
    codepointsFitted: PInteger; linesFilled: PInteger): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipMeasureString}

  function GdipMeasureCharacterRanges(graphics: GPGRAPHICS; string_: PWCHAR;
    length: Integer; font: GPFONT; layoutRect: PGPRectF;
    stringFormat: GPSTRINGFORMAT; regionCount: Integer;
    const regions: GPREGION): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipMeasureCharacterRanges}

  function GdipDrawDriverString(graphics: GPGRAPHICS; const text: PUINT16;
    length: Integer; const font: GPFONT; const brush: GPBRUSH;
    const positions: PGPPointF; flags: Integer;
    const matrix: GPMATRIX): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawDriverString}

  function GdipMeasureDriverString(graphics: GPGRAPHICS; text: PUINT16;
    length: Integer; font: GPFONT; positions: PGPPointF; flags: Integer;
    matrix: GPMATRIX; boundingBox: PGPRectF): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipMeasureDriverString}

//----------------------------------------------------------------------------
// String format APIs
//----------------------------------------------------------------------------

  function GdipCreateStringFormat(formatAttributes: Integer; language: LANGID;
    out format: GPSTRINGFORMAT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateStringFormat}

  function GdipStringFormatGetGenericDefault(
    out format: GPSTRINGFORMAT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipStringFormatGetGenericDefault}

  function GdipStringFormatGetGenericTypographic(
    out format: GPSTRINGFORMAT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipStringFormatGetGenericTypographic}

  function GdipDeleteStringFormat(format: GPSTRINGFORMAT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeleteStringFormat}

  function GdipCloneStringFormat(format: GPSTRINGFORMAT;
    out newFormat: GPSTRINGFORMAT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCloneStringFormat}

  function GdipSetStringFormatFlags(format: GPSTRINGFORMAT;
    flags: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetStringFormatFlags}

  function GdipGetStringFormatFlags(format: GPSTRINGFORMAT;
    out flags: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetStringFormatFlags}

  function GdipSetStringFormatAlign(format: GPSTRINGFORMAT;
    align: STRINGALIGNMENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetStringFormatAlign}

  function GdipGetStringFormatAlign(format: GPSTRINGFORMAT;
    out align: STRINGALIGNMENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetStringFormatAlign}

  function GdipSetStringFormatLineAlign(format: GPSTRINGFORMAT;
    align: STRINGALIGNMENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetStringFormatLineAlign}

  function GdipGetStringFormatLineAlign(format: GPSTRINGFORMAT;
    out align: STRINGALIGNMENT): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetStringFormatLineAlign}

  function GdipSetStringFormatTrimming(format: GPSTRINGFORMAT;
    trimming: STRINGTRIMMING): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetStringFormatTrimming}

  function GdipGetStringFormatTrimming(format: GPSTRINGFORMAT;
    out trimming: STRINGTRIMMING): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetStringFormatTrimming}

  function GdipSetStringFormatHotkeyPrefix(format: GPSTRINGFORMAT;
    hotkeyPrefix: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetStringFormatHotkeyPrefix}

  function GdipGetStringFormatHotkeyPrefix(format: GPSTRINGFORMAT;
    out hotkeyPrefix: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetStringFormatHotkeyPrefix}

  function GdipSetStringFormatTabStops(format: GPSTRINGFORMAT;
    firstTabOffset: Single; count: Integer;
    tabStops: PSingle): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetStringFormatTabStops}

  function GdipGetStringFormatTabStops(format: GPSTRINGFORMAT;
    count: Integer; firstTabOffset: PSingle;
    tabStops: PSingle): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetStringFormatTabStops}

  function GdipGetStringFormatTabStopCount(format: GPSTRINGFORMAT;
    out count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetStringFormatTabStopCount}

  function GdipSetStringFormatDigitSubstitution(format: GPSTRINGFORMAT;
    language: LANGID;
    substitute: STRINGDIGITSUBSTITUTE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetStringFormatDigitSubstitution}

  function GdipGetStringFormatDigitSubstitution(format: GPSTRINGFORMAT;
    language: PUINT; substitute: PSTRINGDIGITSUBSTITUTE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetStringFormatDigitSubstitution}

  function GdipGetStringFormatMeasurableCharacterRangeCount(format: GPSTRINGFORMAT;
    out count: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipGetStringFormatMeasurableCharacterRangeCount}

  function GdipSetStringFormatMeasurableCharacterRanges(format: GPSTRINGFORMAT;
    rangeCount: Integer; ranges: PCHARACTERRANGE): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipSetStringFormatMeasurableCharacterRanges}

//----------------------------------------------------------------------------
// Cached Bitmap APIs
//----------------------------------------------------------------------------

  function GdipCreateCachedBitmap(bitmap: GPBITMAP; graphics: GPGRAPHICS;
    out cachedBitmap: GPCACHEDBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipCreateCachedBitmap}

  function GdipDeleteCachedBitmap(
    cachedBitmap: GPCACHEDBITMAP): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDeleteCachedBitmap}

  function GdipDrawCachedBitmap(graphics: GPGRAPHICS;
    cachedBitmap: GPCACHEDBITMAP; x: Integer;
    y: Integer): GPSTATUS; stdcall;
  {$EXTERNALSYM GdipDrawCachedBitmap}

  function GdipEmfToWmfBits(hemf: HENHMETAFILE; cbData16: UINT; pData16: PBYTE;
    iMapMode: Integer; eFlags: Integer): UINT; stdcall;
  {$EXTERNALSYM GdipEmfToWmfBits}

implementation

  function GdipAlloc; external WINGDIPDLL name 'GdipAlloc';
  procedure GdipFree; external WINGDIPDLL name 'GdipFree';
  function GdiplusStartup; external WINGDIPDLL name 'GdiplusStartup';
  procedure GdiplusShutdown; external WINGDIPDLL name 'GdiplusShutdown';

  function GdipCreatePath; external WINGDIPDLL name 'GdipCreatePath';
  function GdipCreatePath2; external WINGDIPDLL name 'GdipCreatePath2';
  function GdipCreatePath2I; external WINGDIPDLL name 'GdipCreatePath2I';
  function GdipClonePath; external WINGDIPDLL name 'GdipClonePath';
  function GdipDeletePath; external WINGDIPDLL name 'GdipDeletePath';
  function GdipResetPath; external WINGDIPDLL name 'GdipResetPath';
  function GdipGetPointCount; external WINGDIPDLL name 'GdipGetPointCount';
  function GdipGetPathTypes; external WINGDIPDLL name 'GdipGetPathTypes';
  function GdipGetPathPoints; external WINGDIPDLL name 'GdipGetPathPoints';
  function GdipGetPathPointsI; external WINGDIPDLL name 'GdipGetPathPointsI';
  function GdipGetPathFillMode; external WINGDIPDLL name 'GdipGetPathFillMode';
  function GdipSetPathFillMode; external WINGDIPDLL name 'GdipSetPathFillMode';
  function GdipGetPathData; external WINGDIPDLL name 'GdipGetPathData';
  function GdipStartPathFigure; external WINGDIPDLL name 'GdipStartPathFigure';
  function GdipClosePathFigure; external WINGDIPDLL name 'GdipClosePathFigure';
  function GdipClosePathFigures; external WINGDIPDLL name 'GdipClosePathFigures';
  function GdipSetPathMarker; external WINGDIPDLL name 'GdipSetPathMarker';
  function GdipClearPathMarkers; external WINGDIPDLL name 'GdipClearPathMarkers';
  function GdipReversePath; external WINGDIPDLL name 'GdipReversePath';
  function GdipGetPathLastPoint; external WINGDIPDLL name 'GdipGetPathLastPoint';
  function GdipAddPathLine; external WINGDIPDLL name 'GdipAddPathLine';
  function GdipAddPathLine2; external WINGDIPDLL name 'GdipAddPathLine2';
  function GdipAddPathArc; external WINGDIPDLL name 'GdipAddPathArc';
  function GdipAddPathBezier; external WINGDIPDLL name 'GdipAddPathBezier';
  function GdipAddPathBeziers; external WINGDIPDLL name 'GdipAddPathBeziers';
  function GdipAddPathCurve; external WINGDIPDLL name 'GdipAddPathCurve';
  function GdipAddPathCurve2; external WINGDIPDLL name 'GdipAddPathCurve2';
  function GdipAddPathCurve3; external WINGDIPDLL name 'GdipAddPathCurve3';
  function GdipAddPathClosedCurve; external WINGDIPDLL name 'GdipAddPathClosedCurve';
  function GdipAddPathClosedCurve2; external WINGDIPDLL name 'GdipAddPathClosedCurve2';
  function GdipAddPathRectangle; external WINGDIPDLL name 'GdipAddPathRectangle';
  function GdipAddPathRectangles; external WINGDIPDLL name 'GdipAddPathRectangles';
  function GdipAddPathEllipse; external WINGDIPDLL name 'GdipAddPathEllipse';
  function GdipAddPathPie; external WINGDIPDLL name 'GdipAddPathPie';
  function GdipAddPathPolygon; external WINGDIPDLL name 'GdipAddPathPolygon';
  function GdipAddPathPath; external WINGDIPDLL name 'GdipAddPathPath';
  function GdipAddPathString; external WINGDIPDLL name 'GdipAddPathString';
  function GdipAddPathStringI; external WINGDIPDLL name 'GdipAddPathStringI';
  function GdipAddPathLineI; external WINGDIPDLL name 'GdipAddPathLineI';
  function GdipAddPathLine2I; external WINGDIPDLL name 'GdipAddPathLine2I';
  function GdipAddPathArcI; external WINGDIPDLL name 'GdipAddPathArcI';
  function GdipAddPathBezierI; external WINGDIPDLL name 'GdipAddPathBezierI';
  function GdipAddPathBeziersI; external WINGDIPDLL name 'GdipAddPathBeziersI';
  function GdipAddPathCurveI; external WINGDIPDLL name 'GdipAddPathCurveI';
  function GdipAddPathCurve2I; external WINGDIPDLL name 'GdipAddPathCurve2I';
  function GdipAddPathCurve3I; external WINGDIPDLL name 'GdipAddPathCurve3I';
  function GdipAddPathClosedCurveI; external WINGDIPDLL name 'GdipAddPathClosedCurveI';
  function GdipAddPathClosedCurve2I; external WINGDIPDLL name 'GdipAddPathClosedCurve2I';
  function GdipAddPathRectangleI; external WINGDIPDLL name 'GdipAddPathRectangleI';
  function GdipAddPathRectanglesI; external WINGDIPDLL name 'GdipAddPathRectanglesI';
  function GdipAddPathEllipseI; external WINGDIPDLL name 'GdipAddPathEllipseI';
  function GdipAddPathPieI; external WINGDIPDLL name 'GdipAddPathPieI';
  function GdipAddPathPolygonI; external WINGDIPDLL name 'GdipAddPathPolygonI';
  function GdipFlattenPath; external WINGDIPDLL name 'GdipFlattenPath';
  function GdipWindingModeOutline; external WINGDIPDLL name 'GdipWindingModeOutline';
  function GdipWidenPath; external WINGDIPDLL name 'GdipWidenPath';
  function GdipWarpPath; external WINGDIPDLL name 'GdipWarpPath';
  function GdipTransformPath; external WINGDIPDLL name 'GdipTransformPath';
  function GdipGetPathWorldBounds; external WINGDIPDLL name 'GdipGetPathWorldBounds';
  function GdipGetPathWorldBoundsI; external WINGDIPDLL name 'GdipGetPathWorldBoundsI';
  function GdipIsVisiblePathPoint; external WINGDIPDLL name 'GdipIsVisiblePathPoint';
  function GdipIsVisiblePathPointI; external WINGDIPDLL name 'GdipIsVisiblePathPointI';
  function GdipIsOutlineVisiblePathPoint; external WINGDIPDLL name 'GdipIsOutlineVisiblePathPoint';
  function GdipIsOutlineVisiblePathPointI; external WINGDIPDLL name 'GdipIsOutlineVisiblePathPointI';
  function GdipCreatePathIter; external WINGDIPDLL name 'GdipCreatePathIter';
  function GdipDeletePathIter; external WINGDIPDLL name 'GdipDeletePathIter';
  function GdipPathIterNextSubpath; external WINGDIPDLL name 'GdipPathIterNextSubpath';
  function GdipPathIterNextSubpathPath; external WINGDIPDLL name 'GdipPathIterNextSubpathPath';
  function GdipPathIterNextPathType; external WINGDIPDLL name 'GdipPathIterNextPathType';
  function GdipPathIterNextMarker; external WINGDIPDLL name 'GdipPathIterNextMarker';
  function GdipPathIterNextMarkerPath; external WINGDIPDLL name 'GdipPathIterNextMarkerPath';
  function GdipPathIterGetCount; external WINGDIPDLL name 'GdipPathIterGetCount';
  function GdipPathIterGetSubpathCount; external WINGDIPDLL name 'GdipPathIterGetSubpathCount';
  function GdipPathIterIsValid; external WINGDIPDLL name 'GdipPathIterIsValid';
  function GdipPathIterHasCurve; external WINGDIPDLL name 'GdipPathIterHasCurve';
  function GdipPathIterRewind; external WINGDIPDLL name 'GdipPathIterRewind';
  function GdipPathIterEnumerate; external WINGDIPDLL name 'GdipPathIterEnumerate';
  function GdipPathIterCopyData; external WINGDIPDLL name 'GdipPathIterCopyData';
  function GdipCreateMatrix; external WINGDIPDLL name 'GdipCreateMatrix';
  function GdipCreateMatrix2; external WINGDIPDLL name 'GdipCreateMatrix2';
  function GdipCreateMatrix3; external WINGDIPDLL name 'GdipCreateMatrix3';
  function GdipCreateMatrix3I; external WINGDIPDLL name 'GdipCreateMatrix3I';
  function GdipCloneMatrix; external WINGDIPDLL name 'GdipCloneMatrix';
  function GdipDeleteMatrix; external WINGDIPDLL name 'GdipDeleteMatrix';
  function GdipSetMatrixElements; external WINGDIPDLL name 'GdipSetMatrixElements';
  function GdipMultiplyMatrix; external WINGDIPDLL name 'GdipMultiplyMatrix';
  function GdipTranslateMatrix; external WINGDIPDLL name 'GdipTranslateMatrix';
  function GdipScaleMatrix; external WINGDIPDLL name 'GdipScaleMatrix';
  function GdipRotateMatrix; external WINGDIPDLL name 'GdipRotateMatrix';
  function GdipShearMatrix; external WINGDIPDLL name 'GdipShearMatrix';
  function GdipInvertMatrix; external WINGDIPDLL name 'GdipInvertMatrix';
  function GdipTransformMatrixPoints; external WINGDIPDLL name 'GdipTransformMatrixPoints';
  function GdipTransformMatrixPointsI; external WINGDIPDLL name 'GdipTransformMatrixPointsI';
  function GdipVectorTransformMatrixPoints; external WINGDIPDLL name 'GdipVectorTransformMatrixPoints';
  function GdipVectorTransformMatrixPointsI; external WINGDIPDLL name 'GdipVectorTransformMatrixPointsI';
  function GdipGetMatrixElements; external WINGDIPDLL name 'GdipGetMatrixElements';
  function GdipIsMatrixInvertible; external WINGDIPDLL name 'GdipIsMatrixInvertible';
  function GdipIsMatrixIdentity; external WINGDIPDLL name 'GdipIsMatrixIdentity';
  function GdipIsMatrixEqual; external WINGDIPDLL name 'GdipIsMatrixEqual';
  function GdipCreateRegion; external WINGDIPDLL name 'GdipCreateRegion';
  function GdipCreateRegionRect; external WINGDIPDLL name 'GdipCreateRegionRect';
  function GdipCreateRegionRectI; external WINGDIPDLL name 'GdipCreateRegionRectI';
  function GdipCreateRegionPath; external WINGDIPDLL name 'GdipCreateRegionPath';
  function GdipCreateRegionRgnData; external WINGDIPDLL name 'GdipCreateRegionRgnData';
  function GdipCreateRegionHrgn; external WINGDIPDLL name 'GdipCreateRegionHrgn';
  function GdipCloneRegion; external WINGDIPDLL name 'GdipCloneRegion';
  function GdipDeleteRegion; external WINGDIPDLL name 'GdipDeleteRegion';
  function GdipSetInfinite; external WINGDIPDLL name 'GdipSetInfinite';
  function GdipSetEmpty; external WINGDIPDLL name 'GdipSetEmpty';
  function GdipCombineRegionRect; external WINGDIPDLL name 'GdipCombineRegionRect';
  function GdipCombineRegionRectI; external WINGDIPDLL name 'GdipCombineRegionRectI';
  function GdipCombineRegionPath; external WINGDIPDLL name 'GdipCombineRegionPath';
  function GdipCombineRegionRegion; external WINGDIPDLL name 'GdipCombineRegionRegion';
  function GdipTranslateRegion; external WINGDIPDLL name 'GdipTranslateRegion';
  function GdipTranslateRegionI; external WINGDIPDLL name 'GdipTranslateRegionI';
  function GdipTransformRegion; external WINGDIPDLL name 'GdipTransformRegion';
  function GdipGetRegionBounds; external WINGDIPDLL name 'GdipGetRegionBounds';
  function GdipGetRegionBoundsI; external WINGDIPDLL name 'GdipGetRegionBoundsI';
  function GdipGetRegionHRgn; external WINGDIPDLL name 'GdipGetRegionHRgn';
  function GdipIsEmptyRegion; external WINGDIPDLL name 'GdipIsEmptyRegion';
  function GdipIsInfiniteRegion; external WINGDIPDLL name 'GdipIsInfiniteRegion';
  function GdipIsEqualRegion; external WINGDIPDLL name 'GdipIsEqualRegion';
  function GdipGetRegionDataSize; external WINGDIPDLL name 'GdipGetRegionDataSize';
  function GdipGetRegionData; external WINGDIPDLL name 'GdipGetRegionData';
  function GdipIsVisibleRegionPoint; external WINGDIPDLL name 'GdipIsVisibleRegionPoint';
  function GdipIsVisibleRegionPointI; external WINGDIPDLL name 'GdipIsVisibleRegionPointI';
  function GdipIsVisibleRegionRect; external WINGDIPDLL name 'GdipIsVisibleRegionRect';
  function GdipIsVisibleRegionRectI; external WINGDIPDLL name 'GdipIsVisibleRegionRectI';
  function GdipGetRegionScansCount; external WINGDIPDLL name 'GdipGetRegionScansCount';
  function GdipGetRegionScans; external WINGDIPDLL name 'GdipGetRegionScans';
  function GdipGetRegionScansI; external WINGDIPDLL name 'GdipGetRegionScansI';
  function GdipCloneBrush; external WINGDIPDLL name 'GdipCloneBrush';
  function GdipDeleteBrush; external WINGDIPDLL name 'GdipDeleteBrush';
  function GdipGetBrushType; external WINGDIPDLL name 'GdipGetBrushType';
  function GdipCreateHatchBrush; external WINGDIPDLL name 'GdipCreateHatchBrush';
  function GdipGetHatchStyle; external WINGDIPDLL name 'GdipGetHatchStyle';
  function GdipGetHatchForegroundColor; external WINGDIPDLL name 'GdipGetHatchForegroundColor';
  function GdipGetHatchBackgroundColor; external WINGDIPDLL name 'GdipGetHatchBackgroundColor';
  function GdipCreateTexture; external WINGDIPDLL name 'GdipCreateTexture';
  function GdipCreateTexture2; external WINGDIPDLL name 'GdipCreateTexture2';
  function GdipCreateTextureIA; external WINGDIPDLL name 'GdipCreateTextureIA';
  function GdipCreateTexture2I; external WINGDIPDLL name 'GdipCreateTexture2I';
  function GdipCreateTextureIAI; external WINGDIPDLL name 'GdipCreateTextureIAI';
  function GdipGetTextureTransform; external WINGDIPDLL name 'GdipGetTextureTransform';
  function GdipSetTextureTransform; external WINGDIPDLL name 'GdipSetTextureTransform';
  function GdipResetTextureTransform; external WINGDIPDLL name 'GdipResetTextureTransform';
  function GdipMultiplyTextureTransform; external WINGDIPDLL name 'GdipMultiplyTextureTransform';
  function GdipTranslateTextureTransform; external WINGDIPDLL name 'GdipTranslateTextureTransform';
  function GdipScaleTextureTransform; external WINGDIPDLL name 'GdipScaleTextureTransform';
  function GdipRotateTextureTransform; external WINGDIPDLL name 'GdipRotateTextureTransform';
  function GdipSetTextureWrapMode; external WINGDIPDLL name 'GdipSetTextureWrapMode';
  function GdipGetTextureWrapMode; external WINGDIPDLL name 'GdipGetTextureWrapMode';
  function GdipGetTextureImage; external WINGDIPDLL name 'GdipGetTextureImage';
  function GdipCreateSolidFill; external WINGDIPDLL name 'GdipCreateSolidFill';
  function GdipSetSolidFillColor; external WINGDIPDLL name 'GdipSetSolidFillColor';
  function GdipGetSolidFillColor; external WINGDIPDLL name 'GdipGetSolidFillColor';
  function GdipCreateLineBrush; external WINGDIPDLL name 'GdipCreateLineBrush';
  function GdipCreateLineBrushI; external WINGDIPDLL name 'GdipCreateLineBrushI';
  function GdipCreateLineBrushFromRect; external WINGDIPDLL name 'GdipCreateLineBrushFromRect';
  function GdipCreateLineBrushFromRectI; external WINGDIPDLL name 'GdipCreateLineBrushFromRectI';
  function GdipCreateLineBrushFromRectWithAngle; external WINGDIPDLL name 'GdipCreateLineBrushFromRectWithAngle';
  function GdipCreateLineBrushFromRectWithAngleI; external WINGDIPDLL name 'GdipCreateLineBrushFromRectWithAngleI';
  function GdipSetLineColors; external WINGDIPDLL name 'GdipSetLineColors';
  function GdipGetLineColors; external WINGDIPDLL name 'GdipGetLineColors';
  function GdipGetLineRect; external WINGDIPDLL name 'GdipGetLineRect';
  function GdipGetLineRectI; external WINGDIPDLL name 'GdipGetLineRectI';
  function GdipSetLineGammaCorrection; external WINGDIPDLL name 'GdipSetLineGammaCorrection';
  function GdipGetLineGammaCorrection; external WINGDIPDLL name 'GdipGetLineGammaCorrection';
  function GdipGetLineBlendCount; external WINGDIPDLL name 'GdipGetLineBlendCount';
  function GdipGetLineBlend; external WINGDIPDLL name 'GdipGetLineBlend';
  function GdipSetLineBlend; external WINGDIPDLL name 'GdipSetLineBlend';
  function GdipGetLinePresetBlendCount; external WINGDIPDLL name 'GdipGetLinePresetBlendCount';
  function GdipGetLinePresetBlend; external WINGDIPDLL name 'GdipGetLinePresetBlend';
  function GdipSetLinePresetBlend; external WINGDIPDLL name 'GdipSetLinePresetBlend';
  function GdipSetLineSigmaBlend; external WINGDIPDLL name 'GdipSetLineSigmaBlend';
  function GdipSetLineLinearBlend; external WINGDIPDLL name 'GdipSetLineLinearBlend';
  function GdipSetLineWrapMode; external WINGDIPDLL name 'GdipSetLineWrapMode';
  function GdipGetLineWrapMode; external WINGDIPDLL name 'GdipGetLineWrapMode';
  function GdipGetLineTransform; external WINGDIPDLL name 'GdipGetLineTransform';
  function GdipSetLineTransform; external WINGDIPDLL name 'GdipSetLineTransform';
  function GdipResetLineTransform; external WINGDIPDLL name 'GdipResetLineTransform';
  function GdipMultiplyLineTransform; external WINGDIPDLL name 'GdipMultiplyLineTransform';
  function GdipTranslateLineTransform; external WINGDIPDLL name 'GdipTranslateLineTransform';
  function GdipScaleLineTransform; external WINGDIPDLL name 'GdipScaleLineTransform';
  function GdipRotateLineTransform; external WINGDIPDLL name 'GdipRotateLineTransform';
  function GdipCreatePathGradient; external WINGDIPDLL name 'GdipCreatePathGradient';
  function GdipCreatePathGradientI; external WINGDIPDLL name 'GdipCreatePathGradientI';
  function GdipCreatePathGradientFromPath; external WINGDIPDLL name 'GdipCreatePathGradientFromPath';
  function GdipGetPathGradientCenterColor; external WINGDIPDLL name 'GdipGetPathGradientCenterColor';
  function GdipSetPathGradientCenterColor; external WINGDIPDLL name 'GdipSetPathGradientCenterColor';
  function GdipGetPathGradientSurroundColorsWithCount; external WINGDIPDLL name 'GdipGetPathGradientSurroundColorsWithCount';
  function GdipSetPathGradientSurroundColorsWithCount; external WINGDIPDLL name 'GdipSetPathGradientSurroundColorsWithCount';
  function GdipGetPathGradientPath; external WINGDIPDLL name 'GdipGetPathGradientPath';
  function GdipSetPathGradientPath; external WINGDIPDLL name 'GdipSetPathGradientPath';
  function GdipGetPathGradientCenterPoint; external WINGDIPDLL name 'GdipGetPathGradientCenterPoint';
  function GdipGetPathGradientCenterPointI; external WINGDIPDLL name 'GdipGetPathGradientCenterPointI';
  function GdipSetPathGradientCenterPoint; external WINGDIPDLL name 'GdipSetPathGradientCenterPoint';
  function GdipSetPathGradientCenterPointI; external WINGDIPDLL name 'GdipSetPathGradientCenterPointI';
  function GdipGetPathGradientRect; external WINGDIPDLL name 'GdipGetPathGradientRect';
  function GdipGetPathGradientRectI; external WINGDIPDLL name 'GdipGetPathGradientRectI';
  function GdipGetPathGradientPointCount; external WINGDIPDLL name 'GdipGetPathGradientPointCount';
  function GdipGetPathGradientSurroundColorCount; external WINGDIPDLL name 'GdipGetPathGradientSurroundColorCount';
  function GdipSetPathGradientGammaCorrection; external WINGDIPDLL name 'GdipSetPathGradientGammaCorrection';
  function GdipGetPathGradientGammaCorrection; external WINGDIPDLL name 'GdipGetPathGradientGammaCorrection';
  function GdipGetPathGradientBlendCount; external WINGDIPDLL name 'GdipGetPathGradientBlendCount';
  function GdipGetPathGradientBlend; external WINGDIPDLL name 'GdipGetPathGradientBlend';
  function GdipSetPathGradientBlend; external WINGDIPDLL name 'GdipSetPathGradientBlend';
  function GdipGetPathGradientPresetBlendCount; external WINGDIPDLL name 'GdipGetPathGradientPresetBlendCount';
  function GdipGetPathGradientPresetBlend; external WINGDIPDLL name 'GdipGetPathGradientPresetBlend';
  function GdipSetPathGradientPresetBlend; external WINGDIPDLL name 'GdipSetPathGradientPresetBlend';
  function GdipSetPathGradientSigmaBlend; external WINGDIPDLL name 'GdipSetPathGradientSigmaBlend';
  function GdipSetPathGradientLinearBlend; external WINGDIPDLL name 'GdipSetPathGradientLinearBlend';
  function GdipGetPathGradientWrapMode; external WINGDIPDLL name 'GdipGetPathGradientWrapMode';
  function GdipSetPathGradientWrapMode; external WINGDIPDLL name 'GdipSetPathGradientWrapMode';
  function GdipGetPathGradientTransform; external WINGDIPDLL name 'GdipGetPathGradientTransform';
  function GdipSetPathGradientTransform; external WINGDIPDLL name 'GdipSetPathGradientTransform';
  function GdipResetPathGradientTransform; external WINGDIPDLL name 'GdipResetPathGradientTransform';
  function GdipMultiplyPathGradientTransform; external WINGDIPDLL name 'GdipMultiplyPathGradientTransform';
  function GdipTranslatePathGradientTransform; external WINGDIPDLL name 'GdipTranslatePathGradientTransform';
  function GdipScalePathGradientTransform; external WINGDIPDLL name 'GdipScalePathGradientTransform';
  function GdipRotatePathGradientTransform; external WINGDIPDLL name 'GdipRotatePathGradientTransform';
  function GdipGetPathGradientFocusScales; external WINGDIPDLL name 'GdipGetPathGradientFocusScales';
  function GdipSetPathGradientFocusScales; external WINGDIPDLL name 'GdipSetPathGradientFocusScales';
  function GdipCreatePen1; external WINGDIPDLL name 'GdipCreatePen1';
  function GdipCreatePen2; external WINGDIPDLL name 'GdipCreatePen2';
  function GdipClonePen; external WINGDIPDLL name 'GdipClonePen';
  function GdipDeletePen; external WINGDIPDLL name 'GdipDeletePen';
  function GdipSetPenWidth; external WINGDIPDLL name 'GdipSetPenWidth';
  function GdipGetPenWidth; external WINGDIPDLL name 'GdipGetPenWidth';
  function GdipSetPenUnit; external WINGDIPDLL name 'GdipSetPenUnit';
  function GdipGetPenUnit; external WINGDIPDLL name 'GdipGetPenUnit';
  function GdipSetPenLineCap197819; external WINGDIPDLL name 'GdipSetPenLineCap197819';
  function GdipSetPenStartCap; external WINGDIPDLL name 'GdipSetPenStartCap';
  function GdipSetPenEndCap; external WINGDIPDLL name 'GdipSetPenEndCap';
  function GdipSetPenDashCap197819; external WINGDIPDLL name 'GdipSetPenDashCap197819';
  function GdipGetPenStartCap; external WINGDIPDLL name 'GdipGetPenStartCap';
  function GdipGetPenEndCap; external WINGDIPDLL name 'GdipGetPenEndCap';
  function GdipGetPenDashCap197819; external WINGDIPDLL name 'GdipGetPenDashCap197819';
  function GdipSetPenLineJoin; external WINGDIPDLL name 'GdipSetPenLineJoin';
  function GdipGetPenLineJoin; external WINGDIPDLL name 'GdipGetPenLineJoin';
  function GdipSetPenCustomStartCap; external WINGDIPDLL name 'GdipSetPenCustomStartCap';
  function GdipGetPenCustomStartCap; external WINGDIPDLL name 'GdipGetPenCustomStartCap';
  function GdipSetPenCustomEndCap; external WINGDIPDLL name 'GdipSetPenCustomEndCap';
  function GdipGetPenCustomEndCap; external WINGDIPDLL name 'GdipGetPenCustomEndCap';
  function GdipSetPenMiterLimit; external WINGDIPDLL name 'GdipSetPenMiterLimit';
  function GdipGetPenMiterLimit; external WINGDIPDLL name 'GdipGetPenMiterLimit';
  function GdipSetPenMode; external WINGDIPDLL name 'GdipSetPenMode';
  function GdipGetPenMode; external WINGDIPDLL name 'GdipGetPenMode';
  function GdipSetPenTransform; external WINGDIPDLL name 'GdipSetPenTransform';
  function GdipGetPenTransform; external WINGDIPDLL name 'GdipGetPenTransform';
  function GdipResetPenTransform; external WINGDIPDLL name 'GdipResetPenTransform';
  function GdipMultiplyPenTransform; external WINGDIPDLL name 'GdipMultiplyPenTransform';
  function GdipTranslatePenTransform; external WINGDIPDLL name 'GdipTranslatePenTransform';
  function GdipScalePenTransform; external WINGDIPDLL name 'GdipScalePenTransform';
  function GdipRotatePenTransform; external WINGDIPDLL name 'GdipRotatePenTransform';
  function GdipSetPenColor; external WINGDIPDLL name 'GdipSetPenColor';
  function GdipGetPenColor; external WINGDIPDLL name 'GdipGetPenColor';
  function GdipSetPenBrushFill; external WINGDIPDLL name 'GdipSetPenBrushFill';
  function GdipGetPenBrushFill; external WINGDIPDLL name 'GdipGetPenBrushFill';
  function GdipGetPenFillType; external WINGDIPDLL name 'GdipGetPenFillType';
  function GdipGetPenDashStyle; external WINGDIPDLL name 'GdipGetPenDashStyle';
  function GdipSetPenDashStyle; external WINGDIPDLL name 'GdipSetPenDashStyle';
  function GdipGetPenDashOffset; external WINGDIPDLL name 'GdipGetPenDashOffset';
  function GdipSetPenDashOffset; external WINGDIPDLL name 'GdipSetPenDashOffset';
  function GdipGetPenDashCount; external WINGDIPDLL name 'GdipGetPenDashCount';
  function GdipSetPenDashArray; external WINGDIPDLL name 'GdipSetPenDashArray';
  function GdipGetPenDashArray; external WINGDIPDLL name 'GdipGetPenDashArray';
  function GdipGetPenCompoundCount; external WINGDIPDLL name 'GdipGetPenCompoundCount';
  function GdipSetPenCompoundArray; external WINGDIPDLL name 'GdipSetPenCompoundArray';
  function GdipGetPenCompoundArray; external WINGDIPDLL name 'GdipGetPenCompoundArray';
  function GdipCreateCustomLineCap; external WINGDIPDLL name 'GdipCreateCustomLineCap';
  function GdipDeleteCustomLineCap; external WINGDIPDLL name 'GdipDeleteCustomLineCap';
  function GdipCloneCustomLineCap; external WINGDIPDLL name 'GdipCloneCustomLineCap';
  function GdipGetCustomLineCapType; external WINGDIPDLL name 'GdipGetCustomLineCapType';
  function GdipSetCustomLineCapStrokeCaps; external WINGDIPDLL name 'GdipSetCustomLineCapStrokeCaps';
  function GdipGetCustomLineCapStrokeCaps; external WINGDIPDLL name 'GdipGetCustomLineCapStrokeCaps';
  function GdipSetCustomLineCapStrokeJoin; external WINGDIPDLL name 'GdipSetCustomLineCapStrokeJoin';
  function GdipGetCustomLineCapStrokeJoin; external WINGDIPDLL name 'GdipGetCustomLineCapStrokeJoin';
  function GdipSetCustomLineCapBaseCap; external WINGDIPDLL name 'GdipSetCustomLineCapBaseCap';
  function GdipGetCustomLineCapBaseCap; external WINGDIPDLL name 'GdipGetCustomLineCapBaseCap';
  function GdipSetCustomLineCapBaseInset; external WINGDIPDLL name 'GdipSetCustomLineCapBaseInset';
  function GdipGetCustomLineCapBaseInset; external WINGDIPDLL name 'GdipGetCustomLineCapBaseInset';
  function GdipSetCustomLineCapWidthScale; external WINGDIPDLL name 'GdipSetCustomLineCapWidthScale';
  function GdipGetCustomLineCapWidthScale; external WINGDIPDLL name 'GdipGetCustomLineCapWidthScale';
  function GdipCreateAdjustableArrowCap; external WINGDIPDLL name 'GdipCreateAdjustableArrowCap';
  function GdipSetAdjustableArrowCapHeight; external WINGDIPDLL name 'GdipSetAdjustableArrowCapHeight';
  function GdipGetAdjustableArrowCapHeight; external WINGDIPDLL name 'GdipGetAdjustableArrowCapHeight';
  function GdipSetAdjustableArrowCapWidth; external WINGDIPDLL name 'GdipSetAdjustableArrowCapWidth';
  function GdipGetAdjustableArrowCapWidth; external WINGDIPDLL name 'GdipGetAdjustableArrowCapWidth';
  function GdipSetAdjustableArrowCapMiddleInset; external WINGDIPDLL name 'GdipSetAdjustableArrowCapMiddleInset';
  function GdipGetAdjustableArrowCapMiddleInset; external WINGDIPDLL name 'GdipGetAdjustableArrowCapMiddleInset';
  function GdipSetAdjustableArrowCapFillState; external WINGDIPDLL name 'GdipSetAdjustableArrowCapFillState';
  function GdipGetAdjustableArrowCapFillState; external WINGDIPDLL name 'GdipGetAdjustableArrowCapFillState';
  function GdipLoadImageFromStream; external WINGDIPDLL name 'GdipLoadImageFromStream';
  function GdipLoadImageFromFile; external WINGDIPDLL name 'GdipLoadImageFromFile';
  function GdipLoadImageFromStreamICM; external WINGDIPDLL name 'GdipLoadImageFromStreamICM';
  function GdipLoadImageFromFileICM; external WINGDIPDLL name 'GdipLoadImageFromFileICM';
  function GdipCloneImage; external WINGDIPDLL name 'GdipCloneImage';
  function GdipDisposeImage; external WINGDIPDLL name 'GdipDisposeImage';
  function GdipSaveImageToFile; external WINGDIPDLL name 'GdipSaveImageToFile';
  function GdipSaveImageToStream; external WINGDIPDLL name 'GdipSaveImageToStream';
  function GdipSaveAdd; external WINGDIPDLL name 'GdipSaveAdd';
  function GdipSaveAddImage; external WINGDIPDLL name 'GdipSaveAddImage';
  function GdipGetImageGraphicsContext; external WINGDIPDLL name 'GdipGetImageGraphicsContext';
  function GdipGetImageBounds; external WINGDIPDLL name 'GdipGetImageBounds';
  function GdipGetImageDimension; external WINGDIPDLL name 'GdipGetImageDimension';
  function GdipGetImageType; external WINGDIPDLL name 'GdipGetImageType';
  function GdipGetImageWidth; external WINGDIPDLL name 'GdipGetImageWidth';
  function GdipGetImageHeight; external WINGDIPDLL name 'GdipGetImageHeight';
  function GdipGetImageHorizontalResolution; external WINGDIPDLL name 'GdipGetImageHorizontalResolution';
  function GdipGetImageVerticalResolution; external WINGDIPDLL name 'GdipGetImageVerticalResolution';
  function GdipGetImageFlags; external WINGDIPDLL name 'GdipGetImageFlags';
  function GdipGetImageRawFormat; external WINGDIPDLL name 'GdipGetImageRawFormat';
  function GdipGetImagePixelFormat; external WINGDIPDLL name 'GdipGetImagePixelFormat';
  function GdipGetImageThumbnail; external WINGDIPDLL name 'GdipGetImageThumbnail';
  function GdipGetEncoderParameterListSize; external WINGDIPDLL name 'GdipGetEncoderParameterListSize';
  function GdipGetEncoderParameterList; external WINGDIPDLL name 'GdipGetEncoderParameterList';
  function GdipImageGetFrameDimensionsCount; external WINGDIPDLL name 'GdipImageGetFrameDimensionsCount';
  function GdipImageGetFrameDimensionsList; external WINGDIPDLL name 'GdipImageGetFrameDimensionsList';
  function GdipImageGetFrameCount; external WINGDIPDLL name 'GdipImageGetFrameCount';
  function GdipImageSelectActiveFrame; external WINGDIPDLL name 'GdipImageSelectActiveFrame';
  function GdipImageRotateFlip; external WINGDIPDLL name 'GdipImageRotateFlip';
  function GdipGetImagePalette; external WINGDIPDLL name 'GdipGetImagePalette';
  function GdipSetImagePalette; external WINGDIPDLL name 'GdipSetImagePalette';
  function GdipGetImagePaletteSize; external WINGDIPDLL name 'GdipGetImagePaletteSize';
  function GdipGetPropertyCount; external WINGDIPDLL name 'GdipGetPropertyCount';
  function GdipGetPropertyIdList; external WINGDIPDLL name 'GdipGetPropertyIdList';
  function GdipGetPropertyItemSize; external WINGDIPDLL name 'GdipGetPropertyItemSize';
  function GdipGetPropertyItem; external WINGDIPDLL name 'GdipGetPropertyItem';
  function GdipGetPropertySize; external WINGDIPDLL name 'GdipGetPropertySize';
  function GdipGetAllPropertyItems; external WINGDIPDLL name 'GdipGetAllPropertyItems';
  function GdipRemovePropertyItem; external WINGDIPDLL name 'GdipRemovePropertyItem';
  function GdipSetPropertyItem; external WINGDIPDLL name 'GdipSetPropertyItem';
  function GdipImageForceValidation; external WINGDIPDLL name 'GdipImageForceValidation';
  function GdipCreateBitmapFromStream; external WINGDIPDLL name 'GdipCreateBitmapFromStream';
  function GdipCreateBitmapFromFile; external WINGDIPDLL name 'GdipCreateBitmapFromFile';
  function GdipCreateBitmapFromStreamICM; external WINGDIPDLL name 'GdipCreateBitmapFromStreamICM';
  function GdipCreateBitmapFromFileICM; external WINGDIPDLL name 'GdipCreateBitmapFromFileICM';
  function GdipCreateBitmapFromScan0; external WINGDIPDLL name 'GdipCreateBitmapFromScan0';
  function GdipCreateBitmapFromGraphics; external WINGDIPDLL name 'GdipCreateBitmapFromGraphics';
  function GdipCreateBitmapFromDirectDrawSurface; external WINGDIPDLL name 'GdipCreateBitmapFromDirectDrawSurface';
  function GdipCreateBitmapFromGdiDib; external WINGDIPDLL name 'GdipCreateBitmapFromGdiDib';
  function GdipCreateBitmapFromHBITMAP; external WINGDIPDLL name 'GdipCreateBitmapFromHBITMAP';
  function GdipCreateHBITMAPFromBitmap; external WINGDIPDLL name 'GdipCreateHBITMAPFromBitmap';
  function GdipCreateBitmapFromHICON; external WINGDIPDLL name 'GdipCreateBitmapFromHICON';
  function GdipCreateHICONFromBitmap; external WINGDIPDLL name 'GdipCreateHICONFromBitmap';
  function GdipCreateBitmapFromResource; external WINGDIPDLL name 'GdipCreateBitmapFromResource';
  function GdipCloneBitmapArea; external WINGDIPDLL name 'GdipCloneBitmapArea';
  function GdipCloneBitmapAreaI; external WINGDIPDLL name 'GdipCloneBitmapAreaI';
  function GdipBitmapLockBits; external WINGDIPDLL name 'GdipBitmapLockBits';
  function GdipBitmapUnlockBits; external WINGDIPDLL name 'GdipBitmapUnlockBits';
  function GdipBitmapGetPixel; external WINGDIPDLL name 'GdipBitmapGetPixel';
  function GdipBitmapSetPixel; external WINGDIPDLL name 'GdipBitmapSetPixel';
  function GdipBitmapSetResolution; external WINGDIPDLL name 'GdipBitmapSetResolution';
  function GdipCreateImageAttributes; external WINGDIPDLL name 'GdipCreateImageAttributes';
  function GdipCloneImageAttributes; external WINGDIPDLL name 'GdipCloneImageAttributes';
  function GdipDisposeImageAttributes; external WINGDIPDLL name 'GdipDisposeImageAttributes';
  function GdipSetImageAttributesToIdentity; external WINGDIPDLL name 'GdipSetImageAttributesToIdentity';
  function GdipResetImageAttributes; external WINGDIPDLL name 'GdipResetImageAttributes';
  function GdipSetImageAttributesColorMatrix; external WINGDIPDLL name 'GdipSetImageAttributesColorMatrix';
  function GdipSetImageAttributesThreshold; external WINGDIPDLL name 'GdipSetImageAttributesThreshold';
  function GdipSetImageAttributesGamma; external WINGDIPDLL name 'GdipSetImageAttributesGamma';
  function GdipSetImageAttributesNoOp; external WINGDIPDLL name 'GdipSetImageAttributesNoOp';
  function GdipSetImageAttributesColorKeys; external WINGDIPDLL name 'GdipSetImageAttributesColorKeys';
  function GdipSetImageAttributesOutputChannel; external WINGDIPDLL name 'GdipSetImageAttributesOutputChannel';
  function GdipSetImageAttributesOutputChannelColorProfile; external WINGDIPDLL name 'GdipSetImageAttributesOutputChannelColorProfile';
  function GdipSetImageAttributesRemapTable; external WINGDIPDLL name 'GdipSetImageAttributesRemapTable';
  function GdipSetImageAttributesWrapMode; external WINGDIPDLL name 'GdipSetImageAttributesWrapMode';
  function GdipSetImageAttributesICMMode; external WINGDIPDLL name 'GdipSetImageAttributesICMMode';
  function GdipGetImageAttributesAdjustedPalette; external WINGDIPDLL name 'GdipGetImageAttributesAdjustedPalette';
  function GdipFlush; external WINGDIPDLL name 'GdipFlush';
  function GdipCreateFromHDC; external WINGDIPDLL name 'GdipCreateFromHDC';
  function GdipCreateFromHDC2; external WINGDIPDLL name 'GdipCreateFromHDC2';
  function GdipCreateFromHWND; external WINGDIPDLL name 'GdipCreateFromHWND';
  function GdipCreateFromHWNDICM; external WINGDIPDLL name 'GdipCreateFromHWNDICM';
  function GdipDeleteGraphics; external WINGDIPDLL name 'GdipDeleteGraphics';
  function GdipGetDC; external WINGDIPDLL name 'GdipGetDC';
  function GdipReleaseDC; external WINGDIPDLL name 'GdipReleaseDC';
  function GdipSetCompositingMode; external WINGDIPDLL name 'GdipSetCompositingMode';
  function GdipGetCompositingMode; external WINGDIPDLL name 'GdipGetCompositingMode';
  function GdipSetRenderingOrigin; external WINGDIPDLL name 'GdipSetRenderingOrigin';
  function GdipGetRenderingOrigin; external WINGDIPDLL name 'GdipGetRenderingOrigin';
  function GdipSetCompositingQuality; external WINGDIPDLL name 'GdipSetCompositingQuality';
  function GdipGetCompositingQuality; external WINGDIPDLL name 'GdipGetCompositingQuality';
  function GdipSetSmoothingMode; external WINGDIPDLL name 'GdipSetSmoothingMode';
  function GdipGetSmoothingMode; external WINGDIPDLL name 'GdipGetSmoothingMode';
  function GdipSetPixelOffsetMode; external WINGDIPDLL name 'GdipSetPixelOffsetMode';
  function GdipGetPixelOffsetMode; external WINGDIPDLL name 'GdipGetPixelOffsetMode';
  function GdipSetTextRenderingHint; external WINGDIPDLL name 'GdipSetTextRenderingHint';
  function GdipGetTextRenderingHint; external WINGDIPDLL name 'GdipGetTextRenderingHint';
  function GdipSetTextContrast; external WINGDIPDLL name 'GdipSetTextContrast';
  function GdipGetTextContrast; external WINGDIPDLL name 'GdipGetTextContrast';
  function GdipSetInterpolationMode; external WINGDIPDLL name 'GdipSetInterpolationMode';
  function GdipGetInterpolationMode; external WINGDIPDLL name 'GdipGetInterpolationMode';
  function GdipSetWorldTransform; external WINGDIPDLL name 'GdipSetWorldTransform';
  function GdipResetWorldTransform; external WINGDIPDLL name 'GdipResetWorldTransform';
  function GdipMultiplyWorldTransform; external WINGDIPDLL name 'GdipMultiplyWorldTransform';
  function GdipTranslateWorldTransform; external WINGDIPDLL name 'GdipTranslateWorldTransform';
  function GdipScaleWorldTransform; external WINGDIPDLL name 'GdipScaleWorldTransform';
  function GdipRotateWorldTransform; external WINGDIPDLL name 'GdipRotateWorldTransform';
  function GdipGetWorldTransform; external WINGDIPDLL name 'GdipGetWorldTransform';
  function GdipResetPageTransform; external WINGDIPDLL name 'GdipResetPageTransform';
  function GdipGetPageUnit; external WINGDIPDLL name 'GdipGetPageUnit';
  function GdipGetPageScale; external WINGDIPDLL name 'GdipGetPageScale';
  function GdipSetPageUnit; external WINGDIPDLL name 'GdipSetPageUnit';
  function GdipSetPageScale; external WINGDIPDLL name 'GdipSetPageScale';
  function GdipGetDpiX; external WINGDIPDLL name 'GdipGetDpiX';
  function GdipGetDpiY; external WINGDIPDLL name 'GdipGetDpiY';
  function GdipTransformPoints; external WINGDIPDLL name 'GdipTransformPoints';
  function GdipTransformPointsI; external WINGDIPDLL name 'GdipTransformPointsI';
  function GdipGetNearestColor; external WINGDIPDLL name 'GdipGetNearestColor';
  function GdipCreateHalftonePalette; external WINGDIPDLL name 'GdipCreateHalftonePalette';
  function GdipDrawLine; external WINGDIPDLL name 'GdipDrawLine';
  function GdipDrawLineI; external WINGDIPDLL name 'GdipDrawLineI';
  function GdipDrawLines; external WINGDIPDLL name 'GdipDrawLines';
  function GdipDrawLinesI; external WINGDIPDLL name 'GdipDrawLinesI';
  function GdipDrawArc; external WINGDIPDLL name 'GdipDrawArc';
  function GdipDrawArcI; external WINGDIPDLL name 'GdipDrawArcI';
  function GdipDrawBezier; external WINGDIPDLL name 'GdipDrawBezier';
  function GdipDrawBezierI; external WINGDIPDLL name 'GdipDrawBezierI';
  function GdipDrawBeziers; external WINGDIPDLL name 'GdipDrawBeziers';
  function GdipDrawBeziersI; external WINGDIPDLL name 'GdipDrawBeziersI';
  function GdipDrawRectangle; external WINGDIPDLL name 'GdipDrawRectangle';
  function GdipDrawRectangleI; external WINGDIPDLL name 'GdipDrawRectangleI';
  function GdipDrawRectangles; external WINGDIPDLL name 'GdipDrawRectangles';
  function GdipDrawRectanglesI; external WINGDIPDLL name 'GdipDrawRectanglesI';
  function GdipDrawEllipse; external WINGDIPDLL name 'GdipDrawEllipse';
  function GdipDrawEllipseI; external WINGDIPDLL name 'GdipDrawEllipseI';
  function GdipDrawPie; external WINGDIPDLL name 'GdipDrawPie';
  function GdipDrawPieI; external WINGDIPDLL name 'GdipDrawPieI';
  function GdipDrawPolygon; external WINGDIPDLL name 'GdipDrawPolygon';
  function GdipDrawPolygonI; external WINGDIPDLL name 'GdipDrawPolygonI';
  function GdipDrawPath; external WINGDIPDLL name 'GdipDrawPath';
  function GdipDrawCurve; external WINGDIPDLL name 'GdipDrawCurve';
  function GdipDrawCurveI; external WINGDIPDLL name 'GdipDrawCurveI';
  function GdipDrawCurve2; external WINGDIPDLL name 'GdipDrawCurve2';
  function GdipDrawCurve2I; external WINGDIPDLL name 'GdipDrawCurve2I';
  function GdipDrawCurve3; external WINGDIPDLL name 'GdipDrawCurve3';
  function GdipDrawCurve3I; external WINGDIPDLL name 'GdipDrawCurve3I';
  function GdipDrawClosedCurve; external WINGDIPDLL name 'GdipDrawClosedCurve';
  function GdipDrawClosedCurveI; external WINGDIPDLL name 'GdipDrawClosedCurveI';
  function GdipDrawClosedCurve2; external WINGDIPDLL name 'GdipDrawClosedCurve2';
  function GdipDrawClosedCurve2I; external WINGDIPDLL name 'GdipDrawClosedCurve2I';
  function GdipGraphicsClear; external WINGDIPDLL name 'GdipGraphicsClear';
  function GdipFillRectangle; external WINGDIPDLL name 'GdipFillRectangle';
  function GdipFillRectangleI; external WINGDIPDLL name 'GdipFillRectangleI';
  function GdipFillRectangles; external WINGDIPDLL name 'GdipFillRectangles';
  function GdipFillRectanglesI; external WINGDIPDLL name 'GdipFillRectanglesI';
  function GdipFillPolygon; external WINGDIPDLL name 'GdipFillPolygon';
  function GdipFillPolygonI; external WINGDIPDLL name 'GdipFillPolygonI';
  function GdipFillPolygon2; external WINGDIPDLL name 'GdipFillPolygon2';
  function GdipFillPolygon2I; external WINGDIPDLL name 'GdipFillPolygon2I';
  function GdipFillEllipse; external WINGDIPDLL name 'GdipFillEllipse';
  function GdipFillEllipseI; external WINGDIPDLL name 'GdipFillEllipseI';
  function GdipFillPie; external WINGDIPDLL name 'GdipFillPie';
  function GdipFillPieI; external WINGDIPDLL name 'GdipFillPieI';
  function GdipFillPath; external WINGDIPDLL name 'GdipFillPath';
  function GdipFillClosedCurve; external WINGDIPDLL name 'GdipFillClosedCurve';
  function GdipFillClosedCurveI; external WINGDIPDLL name 'GdipFillClosedCurveI';
  function GdipFillClosedCurve2; external WINGDIPDLL name 'GdipFillClosedCurve2';
  function GdipFillClosedCurve2I; external WINGDIPDLL name 'GdipFillClosedCurve2I';
  function GdipFillRegion; external WINGDIPDLL name 'GdipFillRegion';
  function GdipDrawImage; external WINGDIPDLL name 'GdipDrawImage';
  function GdipDrawImageI; external WINGDIPDLL name 'GdipDrawImageI';
  function GdipDrawImageRect; external WINGDIPDLL name 'GdipDrawImageRect';
  function GdipDrawImageRectI; external WINGDIPDLL name 'GdipDrawImageRectI';
  function GdipDrawImagePoints; external WINGDIPDLL name 'GdipDrawImagePoints';
  function GdipDrawImagePointsI; external WINGDIPDLL name 'GdipDrawImagePointsI';
  function GdipDrawImagePointRect; external WINGDIPDLL name 'GdipDrawImagePointRect';
  function GdipDrawImagePointRectI; external WINGDIPDLL name 'GdipDrawImagePointRectI';
  function GdipDrawImageRectRect; external WINGDIPDLL name 'GdipDrawImageRectRect';
  function GdipDrawImageRectRectI; external WINGDIPDLL name 'GdipDrawImageRectRectI';
  function GdipDrawImagePointsRect; external WINGDIPDLL name 'GdipDrawImagePointsRect';
  function GdipDrawImagePointsRectI; external WINGDIPDLL name 'GdipDrawImagePointsRectI';
  function GdipEnumerateMetafileDestPoint; external WINGDIPDLL name 'GdipEnumerateMetafileDestPoint';
  function GdipEnumerateMetafileDestPointI; external WINGDIPDLL name 'GdipEnumerateMetafileDestPointI';
  function GdipEnumerateMetafileDestRect; external WINGDIPDLL name 'GdipEnumerateMetafileDestRect';
  function GdipEnumerateMetafileDestRectI; external WINGDIPDLL name 'GdipEnumerateMetafileDestRectI';
  function GdipEnumerateMetafileDestPoints; external WINGDIPDLL name 'GdipEnumerateMetafileDestPoints';
  function GdipEnumerateMetafileDestPointsI; external WINGDIPDLL name 'GdipEnumerateMetafileDestPointsI';
  function GdipEnumerateMetafileSrcRectDestPoint; external WINGDIPDLL name 'GdipEnumerateMetafileSrcRectDestPoint';
  function GdipEnumerateMetafileSrcRectDestPointI; external WINGDIPDLL name 'GdipEnumerateMetafileSrcRectDestPointI';
  function GdipEnumerateMetafileSrcRectDestRect; external WINGDIPDLL name 'GdipEnumerateMetafileSrcRectDestRect';
  function GdipEnumerateMetafileSrcRectDestRectI; external WINGDIPDLL name 'GdipEnumerateMetafileSrcRectDestRectI';
  function GdipEnumerateMetafileSrcRectDestPoints; external WINGDIPDLL name 'GdipEnumerateMetafileSrcRectDestPoints';
  function GdipEnumerateMetafileSrcRectDestPointsI; external WINGDIPDLL name 'GdipEnumerateMetafileSrcRectDestPointsI';
  function GdipPlayMetafileRecord; external WINGDIPDLL name 'GdipPlayMetafileRecord';
  function GdipSetClipGraphics; external WINGDIPDLL name 'GdipSetClipGraphics';
  function GdipSetClipRect; external WINGDIPDLL name 'GdipSetClipRect';
  function GdipSetClipRectI; external WINGDIPDLL name 'GdipSetClipRectI';
  function GdipSetClipPath; external WINGDIPDLL name 'GdipSetClipPath';
  function GdipSetClipRegion; external WINGDIPDLL name 'GdipSetClipRegion';
  function GdipSetClipHrgn; external WINGDIPDLL name 'GdipSetClipHrgn';
  function GdipResetClip; external WINGDIPDLL name 'GdipResetClip';
  function GdipTranslateClip; external WINGDIPDLL name 'GdipTranslateClip';
  function GdipTranslateClipI; external WINGDIPDLL name 'GdipTranslateClipI';
  function GdipGetClip; external WINGDIPDLL name 'GdipGetClip';
  function GdipGetClipBounds; external WINGDIPDLL name 'GdipGetClipBounds';
  function GdipGetClipBoundsI; external WINGDIPDLL name 'GdipGetClipBoundsI';
  function GdipIsClipEmpty; external WINGDIPDLL name 'GdipIsClipEmpty';
  function GdipGetVisibleClipBounds; external WINGDIPDLL name 'GdipGetVisibleClipBounds';
  function GdipGetVisibleClipBoundsI; external WINGDIPDLL name 'GdipGetVisibleClipBoundsI';
  function GdipIsVisibleClipEmpty; external WINGDIPDLL name 'GdipIsVisibleClipEmpty';
  function GdipIsVisiblePoint; external WINGDIPDLL name 'GdipIsVisiblePoint';
  function GdipIsVisiblePointI; external WINGDIPDLL name 'GdipIsVisiblePointI';
  function GdipIsVisibleRect; external WINGDIPDLL name 'GdipIsVisibleRect';
  function GdipIsVisibleRectI; external WINGDIPDLL name 'GdipIsVisibleRectI';
  function GdipSaveGraphics; external WINGDIPDLL name 'GdipSaveGraphics';
  function GdipRestoreGraphics; external WINGDIPDLL name 'GdipRestoreGraphics';
  function GdipBeginContainer; external WINGDIPDLL name 'GdipBeginContainer';
  function GdipBeginContainerI; external WINGDIPDLL name 'GdipBeginContainerI';
  function GdipBeginContainer2; external WINGDIPDLL name 'GdipBeginContainer2';
  function GdipEndContainer; external WINGDIPDLL name 'GdipEndContainer';
  function GdipGetMetafileHeaderFromWmf; external WINGDIPDLL name 'GdipGetMetafileHeaderFromWmf';
  function GdipGetMetafileHeaderFromEmf; external WINGDIPDLL name 'GdipGetMetafileHeaderFromEmf';
  function GdipGetMetafileHeaderFromFile; external WINGDIPDLL name 'GdipGetMetafileHeaderFromFile';
  function GdipGetMetafileHeaderFromStream; external WINGDIPDLL name 'GdipGetMetafileHeaderFromStream';
  function GdipGetMetafileHeaderFromMetafile; external WINGDIPDLL name 'GdipGetMetafileHeaderFromMetafile';
  function GdipGetHemfFromMetafile; external WINGDIPDLL name 'GdipGetHemfFromMetafile';
  function GdipCreateStreamOnFile; external WINGDIPDLL name 'GdipCreateStreamOnFile';
  function GdipCreateMetafileFromWmf; external WINGDIPDLL name 'GdipCreateMetafileFromWmf';
  function GdipCreateMetafileFromEmf; external WINGDIPDLL name 'GdipCreateMetafileFromEmf';
  function GdipCreateMetafileFromFile; external WINGDIPDLL name 'GdipCreateMetafileFromFile';
  function GdipCreateMetafileFromWmfFile; external WINGDIPDLL name 'GdipCreateMetafileFromWmfFile';
  function GdipCreateMetafileFromStream; external WINGDIPDLL name 'GdipCreateMetafileFromStream';
  function GdipRecordMetafile; external WINGDIPDLL name 'GdipRecordMetafile';
  function GdipRecordMetafileI; external WINGDIPDLL name 'GdipRecordMetafileI';
  function GdipRecordMetafileFileName; external WINGDIPDLL name 'GdipRecordMetafileFileName';
  function GdipRecordMetafileFileNameI; external WINGDIPDLL name 'GdipRecordMetafileFileNameI';
  function GdipRecordMetafileStream; external WINGDIPDLL name 'GdipRecordMetafileStream';
  function GdipRecordMetafileStreamI; external WINGDIPDLL name 'GdipRecordMetafileStreamI';
  function GdipSetMetafileDownLevelRasterizationLimit; external WINGDIPDLL name 'GdipSetMetafileDownLevelRasterizationLimit';
  function GdipGetMetafileDownLevelRasterizationLimit; external WINGDIPDLL name 'GdipGetMetafileDownLevelRasterizationLimit';
  function GdipGetImageDecodersSize; external WINGDIPDLL name 'GdipGetImageDecodersSize';
  function GdipGetImageDecoders; external WINGDIPDLL name 'GdipGetImageDecoders';
  function GdipGetImageEncodersSize; external WINGDIPDLL name 'GdipGetImageEncodersSize';
  function GdipGetImageEncoders; external WINGDIPDLL name 'GdipGetImageEncoders';
  function GdipComment; external WINGDIPDLL name 'GdipComment';
  function GdipCreateFontFamilyFromName; external WINGDIPDLL name 'GdipCreateFontFamilyFromName';
  function GdipDeleteFontFamily; external WINGDIPDLL name 'GdipDeleteFontFamily';
  function GdipCloneFontFamily; external WINGDIPDLL name 'GdipCloneFontFamily';
  function GdipGetGenericFontFamilySansSerif; external WINGDIPDLL name 'GdipGetGenericFontFamilySansSerif';
  function GdipGetGenericFontFamilySerif; external WINGDIPDLL name 'GdipGetGenericFontFamilySerif';
  function GdipGetGenericFontFamilyMonospace; external WINGDIPDLL name 'GdipGetGenericFontFamilyMonospace';
  function GdipGetFamilyName; external WINGDIPDLL name 'GdipGetFamilyName';
  function GdipIsStyleAvailable; external WINGDIPDLL name 'GdipIsStyleAvailable';
  function GdipFontCollectionEnumerable; external WINGDIPDLL name 'GdipFontCollectionEnumerable';
  function GdipFontCollectionEnumerate; external WINGDIPDLL name 'GdipFontCollectionEnumerate';
  function GdipGetEmHeight; external WINGDIPDLL name 'GdipGetEmHeight';
  function GdipGetCellAscent; external WINGDIPDLL name 'GdipGetCellAscent';
  function GdipGetCellDescent; external WINGDIPDLL name 'GdipGetCellDescent';
  function GdipGetLineSpacing; external WINGDIPDLL name 'GdipGetLineSpacing';
  function GdipCreateFontFromDC; external WINGDIPDLL name 'GdipCreateFontFromDC';
  function GdipCreateFontFromLogfontA; external WINGDIPDLL name 'GdipCreateFontFromLogfontA';
  function GdipCreateFontFromLogfontW; external WINGDIPDLL name 'GdipCreateFontFromLogfontW';
  function GdipCreateFont; external WINGDIPDLL name 'GdipCreateFont';
  function GdipCloneFont; external WINGDIPDLL name 'GdipCloneFont';
  function GdipDeleteFont; external WINGDIPDLL name 'GdipDeleteFont';
  function GdipGetFamily; external WINGDIPDLL name 'GdipGetFamily';
  function GdipGetFontStyle; external WINGDIPDLL name 'GdipGetFontStyle';
  function GdipGetFontSize; external WINGDIPDLL name 'GdipGetFontSize';
  function GdipGetFontUnit; external WINGDIPDLL name 'GdipGetFontUnit';
  function GdipGetFontHeight; external WINGDIPDLL name 'GdipGetFontHeight';
  function GdipGetFontHeightGivenDPI; external WINGDIPDLL name 'GdipGetFontHeightGivenDPI';
  function GdipGetLogFontA; external WINGDIPDLL name 'GdipGetLogFontA';
  function GdipGetLogFontW; external WINGDIPDLL name 'GdipGetLogFontW';
  function GdipNewInstalledFontCollection; external WINGDIPDLL name 'GdipNewInstalledFontCollection';
  function GdipNewPrivateFontCollection; external WINGDIPDLL name 'GdipNewPrivateFontCollection';
  function GdipDeletePrivateFontCollection; external WINGDIPDLL name 'GdipDeletePrivateFontCollection';
  function GdipGetFontCollectionFamilyCount; external WINGDIPDLL name 'GdipGetFontCollectionFamilyCount';
  function GdipGetFontCollectionFamilyList; external WINGDIPDLL name 'GdipGetFontCollectionFamilyList';
  function GdipPrivateAddFontFile; external WINGDIPDLL name 'GdipPrivateAddFontFile';
  function GdipPrivateAddMemoryFont; external WINGDIPDLL name 'GdipPrivateAddMemoryFont';
  function GdipDrawString; external WINGDIPDLL name 'GdipDrawString';
  function GdipMeasureString; external WINGDIPDLL name 'GdipMeasureString';
  function GdipMeasureCharacterRanges; external WINGDIPDLL name 'GdipMeasureCharacterRanges';
  function GdipDrawDriverString; external WINGDIPDLL name 'GdipDrawDriverString';
  function GdipMeasureDriverString; external WINGDIPDLL name 'GdipMeasureDriverString';
  function GdipCreateStringFormat; external WINGDIPDLL name 'GdipCreateStringFormat';
  function GdipStringFormatGetGenericDefault; external WINGDIPDLL name 'GdipStringFormatGetGenericDefault';
  function GdipStringFormatGetGenericTypographic; external WINGDIPDLL name 'GdipStringFormatGetGenericTypographic';
  function GdipDeleteStringFormat; external WINGDIPDLL name 'GdipDeleteStringFormat';
  function GdipCloneStringFormat; external WINGDIPDLL name 'GdipCloneStringFormat';
  function GdipSetStringFormatFlags; external WINGDIPDLL name 'GdipSetStringFormatFlags';
  function GdipGetStringFormatFlags; external WINGDIPDLL name 'GdipGetStringFormatFlags';
  function GdipSetStringFormatAlign; external WINGDIPDLL name 'GdipSetStringFormatAlign';
  function GdipGetStringFormatAlign; external WINGDIPDLL name 'GdipGetStringFormatAlign';
  function GdipSetStringFormatLineAlign; external WINGDIPDLL name 'GdipSetStringFormatLineAlign';
  function GdipGetStringFormatLineAlign; external WINGDIPDLL name 'GdipGetStringFormatLineAlign';
  function GdipSetStringFormatTrimming; external WINGDIPDLL name 'GdipSetStringFormatTrimming';
  function GdipGetStringFormatTrimming; external WINGDIPDLL name 'GdipGetStringFormatTrimming';
  function GdipSetStringFormatHotkeyPrefix; external WINGDIPDLL name 'GdipSetStringFormatHotkeyPrefix';
  function GdipGetStringFormatHotkeyPrefix; external WINGDIPDLL name 'GdipGetStringFormatHotkeyPrefix';
  function GdipSetStringFormatTabStops; external WINGDIPDLL name 'GdipSetStringFormatTabStops';
  function GdipGetStringFormatTabStops; external WINGDIPDLL name 'GdipGetStringFormatTabStops';
  function GdipGetStringFormatTabStopCount; external WINGDIPDLL name 'GdipGetStringFormatTabStopCount';
  function GdipSetStringFormatDigitSubstitution; external WINGDIPDLL name 'GdipSetStringFormatDigitSubstitution';
  function GdipGetStringFormatDigitSubstitution; external WINGDIPDLL name 'GdipGetStringFormatDigitSubstitution';
  function GdipGetStringFormatMeasurableCharacterRangeCount; external WINGDIPDLL name 'GdipGetStringFormatMeasurableCharacterRangeCount';
  function GdipSetStringFormatMeasurableCharacterRanges; external WINGDIPDLL name 'GdipSetStringFormatMeasurableCharacterRanges';
  function GdipCreateCachedBitmap; external WINGDIPDLL name 'GdipCreateCachedBitmap';
  function GdipDeleteCachedBitmap; external WINGDIPDLL name 'GdipDeleteCachedBitmap';
  function GdipDrawCachedBitmap; external WINGDIPDLL name 'GdipDrawCachedBitmap';
  function GdipEmfToWmfBits; external WINGDIPDLL name 'GdipEmfToWmfBits';

// -----------------------------------------------------------------------------
// TGdiplusBase class
// -----------------------------------------------------------------------------

  class function TGdiplusBase.NewInstance: TObject;
  begin
    Result := InitInstance(GdipAlloc(ULONG(instanceSize)));
  end;

  procedure TGdiplusBase.FreeInstance;
  begin
    CleanupInstance;
    GdipFree(Self);
  end;

// -----------------------------------------------------------------------------
// macros
// -----------------------------------------------------------------------------

function ObjectTypeIsValid(type_: ObjectType): BOOL;
begin
  result :=  ((type_ >= ObjectTypeMin) and (type_ <= ObjectTypeMax));
end;

function GDIP_WMF_RECORD_TO_EMFPLUS(n: integer): Integer;
begin
  result := (n or GDIP_WMF_RECORD_BASE);
end;

function GDIP_EMFPLUS_RECORD_TO_WMF(n: integer): Integer;
begin
  result := n and (not GDIP_WMF_RECORD_BASE);
end;

function GDIP_IS_WMF_RECORDTYPE(n: integer): BOOL;
begin
  result := ((n and GDIP_WMF_RECORD_BASE) <> 0);
end;


//--------------------------------------------------------------------------
// TGPPoint Util
//--------------------------------------------------------------------------

  function MakePoint(X, Y: Integer): TGPPoint;
  begin
    result.X := X;
    result.Y := Y;
  end;

  function MakePoint(X, Y: Single): TGPPointF;
  begin
    Result.X := X;
    result.Y := Y;
  end;

//--------------------------------------------------------------------------
// TGPSize Util
//--------------------------------------------------------------------------

  function MakeSize(Width, Height: Single): TGPSizeF;
  begin
    result.Width := Width;
    result.Height := Height;
  end;

  function MakeSize(Width, Height: Integer): TGPSize;
  begin
    result.Width := Width;
    result.Height := Height;
  end;

//--------------------------------------------------------------------------
// TCharacterRange Util
//--------------------------------------------------------------------------

  function MakeCharacterRange(First, Length: Integer): TCharacterRange;
  begin
    result.First  := First;
    result.Length := Length;
  end;

// -----------------------------------------------------------------------------
// RectF class
// -----------------------------------------------------------------------------

  function MakeRect(x, y, width, height: Single): TGPRectF; overload;
  begin
    Result.X      := x;
    Result.Y      := y;
    Result.Width  := width;
    Result.Height := height;
  end;

  function MakeRect(location: TGPPointF; size: TGPSizeF): TGPRectF; overload;
  begin
    Result.X      := location.X;
    Result.Y      := location.Y;
    Result.Width  := size.Width;
    Result.Height := size.Height;
  end;

// -----------------------------------------------------------------------------
// Rect class
// -----------------------------------------------------------------------------

  function MakeRect(x, y, width, height: Integer): TGPRect; overload;
  begin
    Result.X      := x;
    Result.Y      := y;
    Result.Width  := width;
    Result.Height := height;
  end;

  function MakeRect(location: TGPPoint; size: TGPSize): TGPRect; overload;
  begin
    Result.X      := location.X;
    Result.Y      := location.Y;
    Result.Width  := size.Width;
    Result.Height := size.Height;
  end;

  function MakeRect(const Rect: TRect): TGPRect;
  begin
    Result.X := rect.Left;
    Result.Y := Rect.Top;
    Result.Width := Rect.Right-Rect.Left;
    Result.Height:= Rect.Bottom-Rect.Top;
  end;

// -----------------------------------------------------------------------------
// PathData class
// -----------------------------------------------------------------------------

  constructor TPathData.Create;
  begin
    Count := 0;
    Points := nil;
    Types := nil;
  end;

  destructor TPathData.destroy;
  begin
    if assigned(Points) then freemem(Points);
    if assigned(Types) then freemem(Types);
  end;


function GetPixelFormatSize(pixfmt: PixelFormat): UINT;
begin
  result := (pixfmt shr 8) and $ff;
end;

function IsIndexedPixelFormat(pixfmt: PixelFormat): BOOL;
begin
  result := (pixfmt and PixelFormatIndexed) <> 0;
end;

function IsAlphaPixelFormat(pixfmt: PixelFormat): BOOL;
begin
  result := (pixfmt and PixelFormatAlpha) <> 0;
end;

function IsExtendedPixelFormat(pixfmt: PixelFormat): BOOL;
begin
  result := (pixfmt and PixelFormatExtended) <> 0;
end;

function IsCanonicalPixelFormat(pixfmt: PixelFormat): BOOL;
begin
  result := (pixfmt and PixelFormatCanonical) <> 0;
end;

// -----------------------------------------------------------------------------
// Color class
// -----------------------------------------------------------------------------

{  constructor TGPColor.Create;
  begin
    Argb := DWORD(Black);
  end;

  // Construct an opaque Color object with
  // the specified Red, Green, Blue values.
  //
  // Color values are not premultiplied.

  constructor TGPColor.Create(r, g, b: Byte);
  begin
    Argb := MakeARGB(255, r, g, b);
  end;

  constructor TGPColor.Create(a, r, g, b: Byte);
  begin
    Argb := MakeARGB(a, r, g, b);
  end;

  constructor TGPColor.Create(Value: ARGB);
  begin
    Argb := Value;
  end;

  function TGPColor.GetAlpha: BYTE;
  begin
    result := BYTE(Argb shr AlphaShift);
  end;

  function TGPColor.GetA: BYTE;
  begin
    result := GetAlpha;
  end;

  function TGPColor.GetRed: BYTE;
  begin
    result := BYTE(Argb shr RedShift);
  end;

  function TGPColor.GetR: BYTE;
  begin
    result := GetRed;
  end;

  function TGPColor.GetGreen: Byte;
  begin
    result := BYTE(Argb shr GreenShift);
  end;

  function TGPColor.GetG: Byte;
  begin
    result := GetGreen;
  end;

  function TGPColor.GetBlue: Byte;
  begin
    result := BYTE(Argb shr BlueShift);
  end;

  function TGPColor.GetB: Byte;
  begin
    result := GetBlue;
  end;

  function TGPColor.GetValue: ARGB;
  begin
    result := Argb;
  end;

  procedure TGPColor.SetValue(Value: ARGB);
  begin
    Argb := Value;
  end;

  procedure TGPColor.SetFromCOLORREF(rgb: COLORREF);
  begin
    Argb := MakeARGB(255, GetRValue(rgb), GetGValue(rgb), GetBValue(rgb));
  end;

  function TGPColor.ToCOLORREF: COLORREF;
  begin
    result := RGB(GetRed, GetGreen, GetBlue);
  end;

  function TGPColor.MakeARGB(a, r, g, b: Byte): ARGB;
  begin
    result := ((DWORD(b) shl  BlueShift) or
               (DWORD(g) shl GreenShift) or
               (DWORD(r) shl   RedShift) or
               (DWORD(a) shl AlphaShift));
  end;  }

  function MakeColor(r, g, b: Byte): ARGB; overload;
  begin
    result := MakeColor(255, r, g, b);
  end;

  function MakeColor(a, r, g, b: Byte): ARGB; overload;
  begin
    result := ((DWORD(b) shl  BlueShift) or
               (DWORD(g) shl GreenShift) or
               (DWORD(r) shl   RedShift) or
               (DWORD(a) shl AlphaShift));
  end;

  function GetAlpha(color: ARGB): BYTE;
  begin
    result := BYTE(color shr AlphaShift);
  end;

  function GetRed(color: ARGB): BYTE;
  begin
    result := BYTE(color shr RedShift);
  end;

  function GetGreen(color: ARGB): BYTE;
  begin
    result := BYTE(color shr GreenShift);
  end;

  function GetBlue(color: ARGB): BYTE;
  begin
    result := BYTE(color shr BlueShift);
  end;

  function ColorRefToARGB(rgb: COLORREF): ARGB;
  begin
    result := MakeColor(255, GetRValue(rgb), GetGValue(rgb), GetBValue(rgb));
  end;

  function ARGBToColorRef(Color: ARGB): COLORREF;
  begin
    result := RGB(GetRed(Color), GetGreen(Color), GetBlue(Color));
  end;


// -----------------------------------------------------------------------------
// MetafileHeader class
// -----------------------------------------------------------------------------

  procedure TMetafileHeader.GetBounds(out Rect: TGPRect);
  begin
    rect.X      := X;
    rect.Y      := Y;
    rect.Width  := Width;
    rect.Height := Height;
  end;

  function TMetafileHeader.IsWmf: BOOL;
  begin
    result :=  ((Type_ = MetafileTypeWmf) or (Type_ = MetafileTypeWmfPlaceable));
  end;

  function TMetafileHeader.IsWmfPlaceable: BOOL;
  begin
    result := (Type_ = MetafileTypeWmfPlaceable);
  end;

  function TMetafileHeader.IsEmf: BOOL;
  begin
    result := (Type_ = MetafileTypeEmf);
  end;

  function TMetafileHeader.IsEmfOrEmfPlus: BOOL;
  begin
    result := (Type_ >= MetafileTypeEmf);
  end;

  function TMetafileHeader.IsEmfPlus: BOOL;
  begin
    result := (Type_ >= MetafileTypeEmfPlusOnly)
  end;

  function TMetafileHeader.IsEmfPlusDual: BOOL;
  begin
    result := (Type_ = MetafileTypeEmfPlusDual)
  end;

  function TMetafileHeader.IsEmfPlusOnly: BOOL;
  begin
    result := (Type_ = MetafileTypeEmfPlusOnly)
  end;

  function TMetafileHeader.IsDisplay: BOOL;
  begin
    result := (IsEmfPlus and ((EmfPlusFlags and GDIP_EMFPLUSFLAGS_DISPLAY) <> 0));
  end;

  function TMetafileHeader.GetWmfHeader: PMetaHeader;
  begin
    if IsWmf then result :=  @Header.WmfHeader
             else result := nil;
  end;

  function TMetafileHeader.GetEmfHeader: PENHMETAHEADER3;
  begin
    if IsEmfOrEmfPlus then result := @Header.EmfHeader
                      else result := nil;
  end;

end.



