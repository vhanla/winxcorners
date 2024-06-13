{******************************************************************************}
{*                                                                            *}
{*  Copyright (C) Microsoft Corporation.  All Rights Reserved.                *}
{*                                                                            *}
{*  Files:      ddraw.h dvp.h                                                 *}
{*  Content:    DirectDraw and DirectDrawVideoPort include files              *}
{*                                                                            *}
{*  DirectX 9.0 Delphi adaptation by Alexey Barkovoy                          *}
{*  E-Mail: clootie@reactor.ru                                                *}
{*                                                                            *}
{*  Modified: 20-Dec-2002                                                     *}
{*                                                                            *}
{*  Based upon :                                                              *}
{*    DirectX 7.0 Object Pascal adaptation by                                 *}
{*      Erik Unger, e-Mail: DelphiDirectX@next-reality.com                    *}
{*                                                                            *}
{*  Latest version can be downloaded from:                                    *}
{*     http://clootie.narod.ru/delphi/                                        *}
{*                                                                            *}
{******************************************************************************}
{                                                                              }
{ Obtained through: Joint Endeavour of Delphi Innovators (Project JEDI)        }
{                                                                              }
{ The contents of this file are used with permission, subject to the Mozilla   }
{ Public License Version 1.1 (the "License"); you may not use this file except }
{ in compliance with the License. You may obtain a copy of the License at      }
{ http://www.mozilla.org/MPL/MPL-1.1.html                                      }
{                                                                              }
{ Software distributed under the License is distributed on an "AS IS" basis,   }
{ WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for }
{ the specific language governing rights and limitations under the License.    }
{                                                                              }
{ Alternatively, the contents of this file may be used under the terms of the  }
{ GNU Lesser General Public License (the  "LGPL License"), in which case the   }
{ provisions of the LGPL License are applicable instead of those above.        }
{ If you wish to allow use of your version of this file only under the terms   }
{ of the LGPL License and not to allow others to use your version of this file }
{ under the MPL, indicate your decision by deleting  the provisions above and  }
{ replace  them with the notice and other provisions required by the LGPL      }
{ License.  If you do not delete the provisions above, a recipient may use     }
{ your version of this file under either the MPL or the LGPL License.          }
{                                                                              }
{ For more information about the LGPL: http://www.gnu.org/copyleft/lesser.html }
{                                                                              }
{******************************************************************************}

///////////////////////////////////////////////////////////////////////////////
// Notes:
//----------------------------------------------------------------------------
// Possible input defines for this file, mapped to original C values:
//   DIRECTDRAW_VERSION_7 : DIRECTDRAW_VERSION = 0x0700,
//   DIRECTDRAW_VERSION_6 : DIRECTDRAW_VERSION = 0x0600,
//   DIRECTDRAW_VERSION_5 : DIRECTDRAW_VERSION = 0x0500,
//   DIRECTDRAW_VERSION_3 : DIRECTDRAW_VERSION = 0x0300,
//   DIRECTDRAW_VERSION_LESS_3 : DIRECTDRAW_VERSION < 0x0300,
//
// By default DIRECTDRAW_VERSION_7 (DIRECTDRAW_VERSION = 0x0700) is assumed
//
// Also you can use generic DIRECTXx defines, so:
//   DIRECTX7 equal to DIRECTDRAW_VERSION_7;
//   DIRECTX6 equal to DIRECTDRAW_VERSION_6;
//   DIRECTX5 equal to DIRECTDRAW_VERSION_5;
//   DIRECTX3 equal to DIRECTDRAW_VERSION_3
///////////////////////////////////////////////////////////////////////////////

unit DirectDraw;

interface

{$I DirectX.inc}

////////////////////////////////////////////////////////////////////////
// Global level dynamic loading support
{$IFDEF DYNAMIC_LINK_ALL}
  {$DEFINE DIRECTDRAW_DYNAMIC_LINK}
{$ENDIF}
{$IFDEF DYNAMIC_LINK_EXPLICIT_ALL}
  {$DEFINE DIRECTDRAW_DYNAMIC_LINK_EXPLICIT}
{$ENDIF}

// Remove "dots" below to force some kind of dynamic linking
{.$DEFINE DIRECTDRAW_DYNAMIC_LINK}
{.$DEFINE DIRECTDRAW_DYNAMIC_LINK_EXPLICIT}

////////////////////////////////////////////////////////////////////////
// Assume for what DirectDraw version we will compile headers
{$IFDEF DIRECTX7}
  {$DEFINE DIRECTDRAW_VERSION_7}
{$ENDIF}
{$IFDEF DIRECTX6}
  {$DEFINE DIRECTDRAW_VERSION_6}
{$ENDIF}
{$IFDEF DIRECTX5}
  {$DEFINE DIRECTDRAW_VERSION_5}
{$ENDIF}
{$IFDEF DIRECTX3}
  {$DEFINE DIRECTDRAW_VERSION_3}
{$ENDIF}

{$IFNDEF DIRECTDRAW_VERSION_7}
  {$IFNDEF DIRECTDRAW_VERSION_6}
    {$IFNDEF DIRECTDRAW_VERSION_5}
      {$IFNDEF DIRECTDRAW_VERSION_3}
        {$IFNDEF DIRECTDRAW_VERSION_LESS_3}
          {$DEFINE DIRECTDRAW_VERSION_7} // Compiling for DirectDraw7 by default
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

////////////////////////////////////////////////////////////////////////
// Emit conditionals to C++Builder compiler
{$IFDEF DIRECTDRAW_VERSION_LESS_3}
  {$HPPEMIT '#define DIRECTDRAW_VERSION         0x0100'}
{$ENDIF}
{$IFDEF DIRECTDRAW_VERSION_3}
  {$HPPEMIT '#define DIRECTDRAW_VERSION         0x0300'}
{$ENDIF}
{$IFDEF DIRECTDRAW_VERSION_5}
  {$HPPEMIT '#define DIRECTDRAW_VERSION         0x0500'}
{$ENDIF}
{$IFDEF DIRECTDRAW_VERSION_6}
  {$HPPEMIT '#define DIRECTDRAW_VERSION         0x0600'}
{$ENDIF}
{$IFDEF DIRECTDRAW_VERSION_7}
  {$HPPEMIT '#define DIRECTDRAW_VERSION         0x0700'}
{$ENDIF}

////////////////////////////////////////////////////////////////////////
// Define symbols for '<=' comparision
{$IFDEF DIRECTDRAW_VERSION_7}
  {$DEFINE DIRECTDRAW_VERSION_6}
{$ENDIF}
{$IFDEF DIRECTDRAW_VERSION_6}
  {$DEFINE DIRECTDRAW_VERSION_5}
{$ENDIF}
{$IFDEF DIRECTDRAW_VERSION_5}
  {$DEFINE DIRECTDRAW_VERSION_3}
{$ENDIF}
{$IFDEF DIRECTDRAW_VERSION_3}
  {$DEFINE DIRECTDRAW_VERSION_LESS_3}
{$ENDIF}

(*$HPPEMIT '#include "ddraw.h"' *)
(*$HPPEMIT '#include "dvp.h"' *)

uses
  Windows;

  
(*==========================================================================;
 *
 *  Copyright (C) Microsoft Corporation.  All Rights Reserved.
 *
 *  File:       ddraw.h
 *  Content:    DirectDraw include file
 *
 ***************************************************************************)

function MAKEFOURCC(ch0, ch1, ch2, ch3: Char): DWORD;
{$EXTERNALSYM MAKEFOURCC}

(*
 * FOURCC codes for DX compressed-texture pixel formats
 *)
const
  //#define FOURCC_DXT1  (MAKEFOURCC('D','X','T','1'))
  FOURCC_DXT1 = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('1') shl 24));
  {$EXTERNALSYM FOURCC_DXT1}
  //#define FOURCC_DXT2  (MAKEFOURCC('D','X','T','2'))
  FOURCC_DXT2 = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('2') shl 24));
  {$EXTERNALSYM FOURCC_DXT2}
  //#define FOURCC_DXT3  (MAKEFOURCC('D','X','T','3'))
  FOURCC_DXT3 = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('3') shl 24));
  {$EXTERNALSYM FOURCC_DXT3}
  //#define FOURCC_DXT4  (MAKEFOURCC('D','X','T','4'))
  FOURCC_DXT4 = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('4') shl 24));
  {$EXTERNALSYM FOURCC_DXT4}
  //#define FOURCC_DXT5  (MAKEFOURCC('D','X','T','5'))
  FOURCC_DXT5 = DWORD(Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('5') shl 24));
  {$EXTERNALSYM FOURCC_DXT5}

(*
 * GUIDS used by DirectDraw objects
 *)
const
  CLSID_DirectDraw: TGUID = '{D7B70EE0-4340-11CF-B063-0020AFC2CD35}';
  {$EXTERNALSYM CLSID_DirectDraw}
  CLSID_DirectDraw7: TGUID = '{3c305196-50db-11d3-9cfe-00c04fd930c5}';
  {$EXTERNALSYM CLSID_DirectDraw7}
  CLSID_DirectDrawClipper: TGUID = '{593817A0-7DB3-11CF-A2DE-00AA00b93356}';
  {$EXTERNALSYM CLSID_DirectDrawClipper}
  (* These GUID's defined later by typedefing to Delphi interfaces
  DEFINE_GUID( IID_IDirectDraw,                   0x6C14DB80,0xA733,0x11CE,0xA5,0x21,0x00,0x20,0xAF,0x0B,0xE5,0x60 );
  DEFINE_GUID( IID_IDirectDraw2,                  0xB3A6F3E0,0x2B43,0x11CF,0xA2,0xDE,0x00,0xAA,0x00,0xB9,0x33,0x56 );
  DEFINE_GUID( IID_IDirectDraw4,                  0x9c59509a,0x39bd,0x11d1,0x8c,0x4a,0x00,0xc0,0x4f,0xd9,0x30,0xc5 );
  DEFINE_GUID( IID_IDirectDraw7,                  0x15e65ec0,0x3b9c,0x11d2,0xb9,0x2f,0x00,0x60,0x97,0x97,0xea,0x5b );
  DEFINE_GUID( IID_IDirectDrawSurface,            0x6C14DB81,0xA733,0x11CE,0xA5,0x21,0x00,0x20,0xAF,0x0B,0xE5,0x60 );
  DEFINE_GUID( IID_IDirectDrawSurface2,           0x57805885,0x6eec,0x11cf,0x94,0x41,0xa8,0x23,0x03,0xc1,0x0e,0x27 );
  DEFINE_GUID( IID_IDirectDrawSurface3,           0xDA044E00,0x69B2,0x11D0,0xA1,0xD5,0x00,0xAA,0x00,0xB8,0xDF,0xBB );
  DEFINE_GUID( IID_IDirectDrawSurface4,           0x0B2B8630,0xAD35,0x11D0,0x8E,0xA6,0x00,0x60,0x97,0x97,0xEA,0x5B );
  DEFINE_GUID( IID_IDirectDrawSurface7,           0x06675a80,0x3b9b,0x11d2,0xb9,0x2f,0x00,0x60,0x97,0x97,0xea,0x5b );
  DEFINE_GUID( IID_IDirectDrawPalette,            0x6C14DB84,0xA733,0x11CE,0xA5,0x21,0x00,0x20,0xAF,0x0B,0xE5,0x60 );
  DEFINE_GUID( IID_IDirectDrawClipper,            0x6C14DB85,0xA733,0x11CE,0xA5,0x21,0x00,0x20,0xAF,0x0B,0xE5,0x60 );
  DEFINE_GUID( IID_IDirectDrawColorControl,       0x4B9F0EE0,0x0D7E,0x11D0,0x9B,0x06,0x00,0xA0,0xC9,0x03,0xA3,0xB8 );
  DEFINE_GUID( IID_IDirectDrawGammaControl,       0x69C11C3E,0xB46B,0x11D1,0xAD,0x7A,0x00,0xC0,0x4F,0xC2,0x9B,0x4E );
  *)

const
  DD_ROP_SPACE = (256 div 32);       // space required to store ROP array
  {$EXTERNALSYM DD_ROP_SPACE}

  MAX_DDDEVICEID_STRING	= 512;
  {$EXTERNALSYM MAX_DDDEVICEID_STRING}


(*============================================================================
 *
 * DirectDraw Structures
 *
 * Various structures used to invoke DirectDraw.
 *
 *==========================================================================*)

var
  NilGUID : TGUID = '{00000000-0000-0000-0000-000000000000}';


type
  //Clootie: This was originally in Erik Unger headers - don't know why, so leave it alone
  TRefGUID = packed record
    case Integer of
    1: (guid : PGUID);
    2: (dwFlags : DWORD);
  end;

  REFGUID = PGUID;
  {$EXTERNALSYM REFGUID}

  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDraw> _di_IDirectDraw;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDraw2> _di_IDirectDraw2;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDraw4> _di_IDirectDraw4;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDraw7> _di_IDirectDraw7;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawSurface> _di_IDirectDrawSurface;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawSurface2> _di_IDirectDrawSurface2;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawSurface3> _di_IDirectDrawSurface3;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawSurface4> _di_IDirectDrawSurface4;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawSurface7> _di_IDirectDrawSurface7;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawPalette> _di_IDirectDrawPalette;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawClipper> _di_IDirectDrawClipper;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawColorControl> _di_IDirectDrawColorControl;'}
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawGammaControl> _di_IDirectDrawGammaControl;'}
  IDirectDraw = interface;
  {$EXTERNALSYM IDirectDraw}
  IDirectDraw2 = interface;
  {$EXTERNALSYM IDirectDraw2}
  IDirectDraw4 = interface;
  {$EXTERNALSYM IDirectDraw4}
  IDirectDraw7 = interface;
  {$EXTERNALSYM IDirectDraw7}
  IDirectDrawSurface = interface;
  {$EXTERNALSYM IDirectDrawSurface}
  IDirectDrawSurface2 = interface;
  {$EXTERNALSYM IDirectDrawSurface2}
  IDirectDrawSurface3 = interface;
  {$EXTERNALSYM IDirectDrawSurface3}
  IDirectDrawSurface4 = interface;
  {$EXTERNALSYM IDirectDrawSurface4}
  IDirectDrawSurface7 = interface;
  {$EXTERNALSYM IDirectDrawSurface7}

  IDirectDrawPalette = interface;
  {$EXTERNALSYM IDirectDrawPalette}
  IDirectDrawClipper = interface;
  {$EXTERNALSYM IDirectDrawClipper}
  IDirectDrawColorControl = interface;
  {$EXTERNALSYM IDirectDrawColorControl}
  IDirectDrawGammaControl = interface;
  {$EXTERNALSYM IDirectDrawGammaControl}

(*
 * Generic pixel format with 8-bit RGB and alpha components
 *)
  PDDARGB = ^TDDARGB;
  _DDARGB = packed record
    blue:     Byte;
    green:    Byte;
    red:      Byte;
    alpha:    Byte;
  end;
  {$EXTERNALSYM _DDARGB}
  DDARGB = _DDARGB;
  {$EXTERNALSYM DDARGB}
  TDDARGB = _DDARGB;

(*
 * This version of the structure remains for backwards source compatibility.
 * The DDARGB structure is the one that should be used for all DirectDraw APIs.
 *)
  PDDRGBA = ^TDDRGBA;
  _DDRGBA = packed record
    red   : Byte;
    green : Byte;
    blue  : Byte;
    alpha : Byte;
  end;
  {$EXTERNALSYM _DDRGBA}
  DDRGBA = _DDRGBA;
  {$EXTERNALSYM DDRGBA}
  TDDRGBA = _DDRGBA;

(*
 * TDDColorKey
 *)
  PDDColorKey = ^TDDColorKey;
  _DDCOLORKEY = packed record
    dwColorSpaceLowValue: DWORD;   // low boundary of color space that is to
                                   // be treated as Color Key, inclusive
    dwColorSpaceHighValue: DWORD;  // high boundary of color space that is
                                   // to be treated as Color Key, inclusive
  end;
  {$EXTERNALSYM _DDCOLORKEY}
  DDCOLORKEY = _DDCOLORKEY;
  {$EXTERNALSYM DDCOLORKEY}
  TDDColorKey = _DDCOLORKEY;

// Delphi 5 and up don't allow interfaces in variant records
// so we have to use pointers instead (which can be type-casted into interfaces):

{$IFDEF COMPILER5_UP}
  PDirectDrawSurface = Pointer;
{$ELSE}
  PDirectDrawSurface = IDirectDrawSurface;
{$ENDIF}

(*
 * TDDBltFX
 * Used to pass override information to the DIRECTDRAWSURFACE callback Blt.
 *)
  PDDBltFX = ^TDDBltFX;
  _DDBLTFX = packed record
    dwSize                        : DWORD;     // size of structure
    dwDDFX                        : DWORD;     // FX operations
    dwROP                         : DWORD;     // Win32 raster operations
    dwDDROP                       : DWORD;     // Raster operations new for DirectDraw
    dwRotationAngle               : DWORD;     // Rotation angle for blt
    dwZBufferOpCode               : DWORD;     // ZBuffer compares
    dwZBufferLow                  : DWORD;     // Low limit of Z buffer
    dwZBufferHigh                 : DWORD;     // High limit of Z buffer
    dwZBufferBaseDest             : DWORD;     // Destination base value
    dwZDestConstBitDepth          : DWORD;     // Bit depth used to specify Z constant for destination
    case Integer of
    0: (
      dwZDestConst                : DWORD      // Constant to use as Z buffer for dest
     );
    1: (
      lpDDSZBufferDest            : ^PDirectDrawSurface; // Surface to use as Z buffer for dest
      dwZSrcConstBitDepth         : DWORD;     // Bit depth used to specify Z constant for source
      case integer of
      0: (
        dwZSrcConst               : DWORD;     // Constant to use as Z buffer for src
       );
      1: (
        lpDDSZBufferSrc           : ^PDirectDrawSurface; // Surface to use as Z buffer for src
        dwAlphaEdgeBlendBitDepth  : DWORD;     // Bit depth used to specify constant for alpha edge blend
        dwAlphaEdgeBlend          : DWORD;     // Alpha for edge blending
        dwReserved                : DWORD;
        dwAlphaDestConstBitDepth  : DWORD;     // Bit depth used to specify alpha constant for destination
        case integer of
        0: (
          dwAlphaDestConst        : DWORD;     // Constant to use as Alpha Channel
         );
        1: (
          lpDDSAlphaDest          : ^PDirectDrawSurface; // Surface to use as Alpha Channel
          dwAlphaSrcConstBitDepth : DWORD;     // Bit depth used to specify alpha constant for source
          case integer of
          0: (
            dwAlphaSrcConst       : DWORD;     // Constant to use as Alpha Channel
          );
          1: (
            lpDDSAlphaSrc         : ^PDirectDrawSurface; // Surface to use as Alpha Channel
            case integer of
            0: (
              dwFillColor         : DWORD;     // color in RGB or Palettized
            );
            1: (
              dwFillDepth         : DWORD;     // depth value for z-buffer
            );
            2: (
              dwFillPixel         : DWORD;     // pixel value
            );
            3: (
              lpDDSPattern        : ^PDirectDrawSurface; // Surface to use as pattern
              ddckDestColorkey    : TDDColorKey; // DestColorkey override
              ddckSrcColorkey     : TDDColorKey; // SrcColorkey override
            )
        )
      )
    )
  )
  end;
  {$EXTERNALSYM _DDBLTFX}
  DDBLTFX = _DDBLTFX;
  {$EXTERNALSYM DDBLTFX}
  TDDBltFX = _DDBLTFX;

(*
 * TDDSCaps
 *)
  PDDSCaps = ^TDDSCaps;
  _DDSCAPS = packed record
    dwCaps: DWORD;         // capabilities of surface wanted
  end;
  {$EXTERNALSYM _DDSCAPS}
  DDSCAPS = _DDSCAPS;
  {$EXTERNALSYM DDSCAPS}
  TDDSCaps = _DDSCAPS;

(*
 * TDDOSCaps
 *)
  PDDOSCaps = ^TDDOSCaps;
  _DDOSCAPS = packed record
    dwCaps: DWORD;         // capabilities of surface wanted
  end;
  {$EXTERNALSYM _DDOSCAPS}
  DDOSCAPS = _DDOSCAPS;
  {$EXTERNALSYM DDOSCAPS}
  TDDOSCaps = _DDOSCAPS;

(*
 * This structure is used internally by DirectDraw.
 *)
  PDDSCapsEx = ^TDDSCapsEx;
  _DDSCAPSEX = packed record
    dwCaps2 : DWORD;
    dwCaps3 : DWORD;
    dwCaps4 : DWORD;
  end;
  {$EXTERNALSYM _DDSCAPSEX}
  DDSCAPSEX = _DDSCAPSEX;
  {$EXTERNALSYM DDSCAPSEX}
  TDDSCapsEx = _DDSCAPSEX;

(*
 * TDDSCaps2
 *)
  PDDSCaps2 = ^TDDSCaps2;
  _DDSCAPS2 = packed record
    dwCaps: DWORD;         // capabilities of surface wanted
    dwCaps2 : DWORD;
    dwCaps3 : DWORD;
    dwCaps4 : DWORD;
  end;
  {$EXTERNALSYM _DDSCAPS2}
  DDSCAPS2 = _DDSCAPS2;
  {$EXTERNALSYM DDSCAPS2}
  TDDSCaps2 = _DDSCAPS2;

(*
 * NOTE: Our choosen structure number scheme is to append a single digit to
 * the end of the structure giving the version that structure is associated
 * with.
 *)

(*
 * This structure represents the DDCAPS structure released in DirectDraw 1.0.  It is used internally
 * by DirectDraw to interpret caps passed into ddraw by drivers written prior to the release of DirectDraw 2.0.
 * New applications should use the DDCAPS structure defined below.
 *)
  PDDCaps_DX1 = ^TDDCaps_DX1;
  _DDCAPS_DX1 = packed record
    dwSize: DWORD;                 // size of the DDDRIVERCAPS structure
    dwCaps: DWORD;                 // driver specific capabilities
    dwCaps2: DWORD;                // more driver specific capabilites
    dwCKeyCaps: DWORD;             // color key capabilities of the surface
    dwFXCaps: DWORD;               // driver specific stretching and effects capabilites
    dwFXAlphaCaps: DWORD;          // alpha driver specific capabilities
    dwPalCaps: DWORD;              // palette capabilities
    dwSVCaps: DWORD;               // stereo vision capabilities
    dwAlphaBltConstBitDepths: DWORD;       // DDBD_2,4,8
    dwAlphaBltPixelBitDepths: DWORD;       // DDBD_1,2,4,8
    dwAlphaBltSurfaceBitDepths: DWORD;     // DDBD_1,2,4,8
    dwAlphaOverlayConstBitDepths: DWORD;   // DDBD_2,4,8
    dwAlphaOverlayPixelBitDepths: DWORD;   // DDBD_1,2,4,8
    dwAlphaOverlaySurfaceBitDepths: DWORD; // DDBD_1,2,4,8
    dwZBufferBitDepths: DWORD;             // DDBD_8,16,24,32
    dwVidMemTotal: DWORD;          // total amount of video memory
    dwVidMemFree: DWORD;           // amount of free video memory
    dwMaxVisibleOverlays: DWORD;   // maximum number of visible overlays
    dwCurrVisibleOverlays: DWORD;  // current number of visible overlays
    dwNumFourCCCodes: DWORD;       // number of four cc codes
    dwAlignBoundarySrc: DWORD;     // source rectangle alignment
    dwAlignSizeSrc: DWORD;         // source rectangle byte size
    dwAlignBoundaryDest: DWORD;    // dest rectangle alignment
    dwAlignSizeDest: DWORD;        // dest rectangle byte size
    dwAlignStrideAlign: DWORD;     // stride alignment
    dwRops: Array [0..DD_ROP_SPACE-1] of DWORD;   // ROPS supported
    ddsCaps: TDDSCaps;             // TDDSCaps structure has all the general capabilities
    dwMinOverlayStretch: DWORD;    // minimum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxOverlayStretch: DWORD;    // maximum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinLiveVideoStretch: DWORD;  // minimum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxLiveVideoStretch: DWORD;  // maximum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinHwCodecStretch: DWORD;    // minimum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxHwCodecStretch: DWORD;    // maximum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwReserved1: DWORD;            // reserved
    dwReserved2: DWORD;            // reserved
    dwReserved3: DWORD;            // reserved
  end;
  {$EXTERNALSYM _DDCAPS_DX1}
  DDCAPS_DX1 = _DDCAPS_DX1;
  {$EXTERNALSYM DDCAPS_DX1}
  TDDCaps_DX1 = _DDCAPS_DX1;

(*
 * This structure is the TDDCaps structure as it was in version 2 and 3 of Direct X.
 * It is present for back compatability.
 *)
  PDDCaps_DX3 = ^TDDCaps_DX3;
  _DDCAPS_DX3 = packed record
    dwSize: DWORD;                 // size of the DDDRIVERCAPS structure
    dwCaps: DWORD;                 // driver specific capabilities
    dwCaps2: DWORD;                // more driver specific capabilites
    dwCKeyCaps: DWORD;             // color key capabilities of the surface
    dwFXCaps: DWORD;               // driver specific stretching and effects capabilites
    dwFXAlphaCaps: DWORD;          // alpha driver specific capabilities
    dwPalCaps: DWORD;              // palette capabilities
    dwSVCaps: DWORD;               // stereo vision capabilities
    dwAlphaBltConstBitDepths: DWORD;       // DDBD_2,4,8
    dwAlphaBltPixelBitDepths: DWORD;       // DDBD_1,2,4,8
    dwAlphaBltSurfaceBitDepths: DWORD;     // DDBD_1,2,4,8
    dwAlphaOverlayConstBitDepths: DWORD;   // DDBD_2,4,8
    dwAlphaOverlayPixelBitDepths: DWORD;   // DDBD_1,2,4,8
    dwAlphaOverlaySurfaceBitDepths: DWORD; // DDBD_1,2,4,8
    dwZBufferBitDepths: DWORD;             // DDBD_8,16,24,32
    dwVidMemTotal: DWORD;          // total amount of video memory
    dwVidMemFree: DWORD;           // amount of free video memory
    dwMaxVisibleOverlays: DWORD;   // maximum number of visible overlays
    dwCurrVisibleOverlays: DWORD;  // current number of visible overlays
    dwNumFourCCCodes: DWORD;       // number of four cc codes
    dwAlignBoundarySrc: DWORD;     // source rectangle alignment
    dwAlignSizeSrc: DWORD;         // source rectangle byte size
    dwAlignBoundaryDest: DWORD;    // dest rectangle alignment
    dwAlignSizeDest: DWORD;        // dest rectangle byte size
    dwAlignStrideAlign: DWORD;     // stride alignment
    dwRops: Array [0..DD_ROP_SPACE-1] of DWORD;   // ROPS supported
    ddsCaps: TDDSCaps;             // TDDSCaps structure has all the general capabilities
    dwMinOverlayStretch: DWORD;    // minimum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxOverlayStretch: DWORD;    // maximum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinLiveVideoStretch: DWORD;  // minimum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxLiveVideoStretch: DWORD;  // maximum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinHwCodecStretch: DWORD;    // minimum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxHwCodecStretch: DWORD;    // maximum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwReserved1: DWORD;            // reserved
    dwReserved2: DWORD;            // reserved
    dwReserved3: DWORD;            // reserved
    dwSVBCaps: DWORD;              // driver specific capabilities for System->Vmem blts
    dwSVBCKeyCaps: DWORD;          // driver color key capabilities for System->Vmem blts
    dwSVBFXCaps: DWORD;            // driver FX capabilities for System->Vmem blts
    dwSVBRops: array[0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->Vmem blts
    dwVSBCaps: DWORD;              // driver specific capabilities for Vmem->System blts
    dwVSBCKeyCaps: DWORD;          // driver color key capabilities for Vmem->System blts
    dwVSBFXCaps: DWORD;            // driver FX capabilities for Vmem->System blts
    dwVSBRops: array[0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for Vmem->System blts
    dwSSBCaps: DWORD;              // driver specific capabilities for System->System blts
    dwSSBCKeyCaps: DWORD;          // driver color key capabilities for System->System blts
    dwSSBFXCaps: DWORD;            // driver FX capabilities for System->System blts
    dwSSBRops: array[0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->System blts
    dwReserved4 : DWORD;
    dwReserved5 : DWORD;
    dwReserved6 : DWORD;
  end;
  {$EXTERNALSYM _DDCAPS_DX3}
  DDCAPS_DX3 = _DDCAPS_DX3;
  {$EXTERNALSYM DDCAPS_DX3}
  TDDCaps_DX3 = _DDCAPS_DX3;

(*
 * This structure is the TDDCaps structure as it was in version 5 of Direct X.
 * It is present for back compatability.
 *)
  PDDCaps_DX5 = ^TDDCaps_DX5;
  _DDCAPS_DX5 = packed record
    dwSize: DWORD;                 // size of the DDDRIVERCAPS structure
    dwCaps: DWORD;                 // driver specific capabilities
    dwCaps2: DWORD;                // more driver specific capabilites
    dwCKeyCaps: DWORD;             // color key capabilities of the surface
    dwFXCaps: DWORD;               // driver specific stretching and effects capabilites
    dwFXAlphaCaps: DWORD;          // alpha driver specific capabilities
    dwPalCaps: DWORD;              // palette capabilities
    dwSVCaps: DWORD;               // stereo vision capabilities
    dwAlphaBltConstBitDepths: DWORD;       // DDBD_2,4,8
    dwAlphaBltPixelBitDepths: DWORD;       // DDBD_1,2,4,8
    dwAlphaBltSurfaceBitDepths: DWORD;     // DDBD_1,2,4,8
    dwAlphaOverlayConstBitDepths: DWORD;   // DDBD_2,4,8
    dwAlphaOverlayPixelBitDepths: DWORD;   // DDBD_1,2,4,8
    dwAlphaOverlaySurfaceBitDepths: DWORD; // DDBD_1,2,4,8
    dwZBufferBitDepths: DWORD;             // DDBD_8,16,24,32
    dwVidMemTotal: DWORD;          // total amount of video memory
    dwVidMemFree: DWORD;           // amount of free video memory
    dwMaxVisibleOverlays: DWORD;   // maximum number of visible overlays
    dwCurrVisibleOverlays: DWORD;  // current number of visible overlays
    dwNumFourCCCodes: DWORD;       // number of four cc codes
    dwAlignBoundarySrc: DWORD;     // source rectangle alignment
    dwAlignSizeSrc: DWORD;         // source rectangle byte size
    dwAlignBoundaryDest: DWORD;    // dest rectangle alignment
    dwAlignSizeDest: DWORD;        // dest rectangle byte size
    dwAlignStrideAlign: DWORD;     // stride alignment
    dwRops: Array [0..DD_ROP_SPACE-1] of DWORD;   // ROPS supported
    ddsCaps: TDDSCaps;             // TDDSCaps structure has all the general capabilities
    dwMinOverlayStretch: DWORD;    // minimum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxOverlayStretch: DWORD;    // maximum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinLiveVideoStretch: DWORD;  // minimum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxLiveVideoStretch: DWORD;  // maximum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinHwCodecStretch: DWORD;    // minimum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxHwCodecStretch: DWORD;    // maximum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwReserved1: DWORD;            // reserved
    dwReserved2: DWORD;            // reserved
    dwReserved3: DWORD;            // reserved
    dwSVBCaps: DWORD;              // driver specific capabilities for System->Vmem blts
    dwSVBCKeyCaps: DWORD;          // driver color key capabilities for System->Vmem blts
    dwSVBFXCaps: DWORD;            // driver FX capabilities for System->Vmem blts
    dwSVBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->Vmem blts
    dwVSBCaps: DWORD;              // driver specific capabilities for Vmem->System blts
    dwVSBCKeyCaps: DWORD;          // driver color key capabilities for Vmem->System blts
    dwVSBFXCaps: DWORD;            // driver FX capabilities for Vmem->System blts
    dwVSBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for Vmem->System blts
    dwSSBCaps: DWORD;              // driver specific capabilities for System->System blts
    dwSSBCKeyCaps: DWORD;          // driver color key capabilities for System->System blts
    dwSSBFXCaps: DWORD;            // driver FX capabilities for System->System blts
    dwSSBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->System blts
    // Members added for DX5:
    dwMaxVideoPorts: DWORD;	   // maximum number of usable video ports
    dwCurrVideoPorts: DWORD;	   // current number of video ports used
    dwSVBCaps2: DWORD;		   // more driver specific capabilities for System->Vmem blts
    dwNLVBCaps: DWORD;		   // driver specific capabilities for non-local->local vidmem blts
    dwNLVBCaps2: DWORD;		   // more driver specific capabilities non-local->local vidmem blts
    dwNLVBCKeyCaps: DWORD;	   // driver color key capabilities for non-local->local vidmem blts
    dwNLVBFXCaps: DWORD;	   // driver FX capabilities for non-local->local blts
    dwNLVBRops: Array [0..DD_ROP_SPACE-1] of DWORD; // ROPS supported for non-local->local blts
  end;
  {$EXTERNALSYM _DDCAPS_DX5}
  DDCAPS_DX5 = _DDCAPS_DX5;
  {$EXTERNALSYM DDCAPS_DX5}
  TDDCaps_DX5 = _DDCAPS_DX5;

  PDDCaps_DX6 = ^TDDCaps_DX6;
  _DDCAPS_DX6 = packed record
    dwSize: DWORD;                 // size of the DDDRIVERCAPS structure
    dwCaps: DWORD;                 // driver specific capabilities
    dwCaps2: DWORD;                // more driver specific capabilites
    dwCKeyCaps: DWORD;             // color key capabilities of the surface
    dwFXCaps: DWORD;               // driver specific stretching and effects capabilites
    dwFXAlphaCaps: DWORD;          // alpha driver specific capabilities
    dwPalCaps: DWORD;              // palette capabilities
    dwSVCaps: DWORD;               // stereo vision capabilities
    dwAlphaBltConstBitDepths: DWORD;       // DDBD_2,4,8
    dwAlphaBltPixelBitDepths: DWORD;       // DDBD_1,2,4,8
    dwAlphaBltSurfaceBitDepths: DWORD;     // DDBD_1,2,4,8
    dwAlphaOverlayConstBitDepths: DWORD;   // DDBD_2,4,8
    dwAlphaOverlayPixelBitDepths: DWORD;   // DDBD_1,2,4,8
    dwAlphaOverlaySurfaceBitDepths: DWORD; // DDBD_1,2,4,8
    dwZBufferBitDepths: DWORD;             // DDBD_8,16,24,32
    dwVidMemTotal: DWORD;          // total amount of video memory
    dwVidMemFree: DWORD;           // amount of free video memory
    dwMaxVisibleOverlays: DWORD;   // maximum number of visible overlays
    dwCurrVisibleOverlays: DWORD;  // current number of visible overlays
    dwNumFourCCCodes: DWORD;       // number of four cc codes
    dwAlignBoundarySrc: DWORD;     // source rectangle alignment
    dwAlignSizeSrc: DWORD;         // source rectangle byte size
    dwAlignBoundaryDest: DWORD;    // dest rectangle alignment
    dwAlignSizeDest: DWORD;        // dest rectangle byte size
    dwAlignStrideAlign: DWORD;     // stride alignment
    dwRops: Array [0..DD_ROP_SPACE-1] of DWORD;   // ROPS supported
    ddsOldCaps: TDDSCaps;          // Was dssCaps: TDDSCaps. ddsCaps is of type TDDScaps2 for DX6
    dwMinOverlayStretch: DWORD;    // minimum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxOverlayStretch: DWORD;    // maximum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinLiveVideoStretch: DWORD;  // minimum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxLiveVideoStretch: DWORD;  // maximum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinHwCodecStretch: DWORD;    // minimum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxHwCodecStretch: DWORD;    // maximum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwReserved1: DWORD;            // reserved
    dwReserved2: DWORD;            // reserved
    dwReserved3: DWORD;            // reserved
    dwSVBCaps: DWORD;              // driver specific capabilities for System->Vmem blts
    dwSVBCKeyCaps: DWORD;          // driver color key capabilities for System->Vmem blts
    dwSVBFXCaps: DWORD;            // driver FX capabilities for System->Vmem blts
    dwSVBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->Vmem blts
    dwVSBCaps: DWORD;              // driver specific capabilities for Vmem->System blts
    dwVSBCKeyCaps: DWORD;          // driver color key capabilities for Vmem->System blts
    dwVSBFXCaps: DWORD;            // driver FX capabilities for Vmem->System blts
    dwVSBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for Vmem->System blts
    dwSSBCaps: DWORD;              // driver specific capabilities for System->System blts
    dwSSBCKeyCaps: DWORD;          // driver color key capabilities for System->System blts
    dwSSBFXCaps: DWORD;            // driver FX capabilities for System->System blts
    dwSSBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->System blts
    // Members added for DX5:
    dwMaxVideoPorts: DWORD;	   // maximum number of usable video ports
    dwCurrVideoPorts: DWORD;	   // current number of video ports used
    dwSVBCaps2: DWORD;		   // more driver specific capabilities for System->Vmem blts
    dwNLVBCaps: DWORD;		   // driver specific capabilities for non-local->local vidmem blts
    dwNLVBCaps2: DWORD;		   // more driver specific capabilities non-local->local vidmem blts
    dwNLVBCKeyCaps: DWORD;	   // driver color key capabilities for non-local->local vidmem blts
    dwNLVBFXCaps: DWORD;	   // driver FX capabilities for non-local->local blts
    dwNLVBRops: Array [0..DD_ROP_SPACE-1] of DWORD; // ROPS supported for non-local->local blts
    // Members added for DX6 release
    ddsCaps : TDDSCaps2 ;          // Surface Caps
  end;
  {$EXTERNALSYM _DDCAPS_DX6}
  DDCAPS_DX6 = _DDCAPS_DX6;
  {$EXTERNALSYM DDCAPS_DX6}
  TDDCaps_DX6 = _DDCAPS_DX6;

  _DDCAPS_DX7 = TDDCaps_DX6;
  {$EXTERNALSYM _DDCAPS_DX7}
  DDCAPS_DX7 = _DDCAPS_DX7;
  {$EXTERNALSYM DDCAPS_DX7}
  PDDCaps_DX7 = ^TDDCaps_DX7;
  TDDCaps_DX7 = TDDCaps_DX6;

{$IFDEF DIRECTDRAW_VERSION_7}
  PDDCaps = PDDCaps_DX7;
  TDDCaps = TDDCaps_DX7;
{$ELSE}
{$IFDEF DIRECTDRAW_VERSION_6}
  PDDCaps = PDDCaps_DX6;
  TDDCaps = TDDCaps_DX6;
{$ELSE}
{$IFDEF DIRECTDRAW_VERSION_5}
  PDDCaps = PDDCaps_DX5;
  TDDCaps = TDDCaps_DX5;
{$ELSE}
{$IFDEF DIRECTDRAW_VERSION_3}
  PDDCaps = PDDCaps_DX3;
  TDDCaps = TDDCaps_DX3;
{$ELSE}
  PDDCaps = PDDCaps_DX1;
  TDDCaps = TDDCaps_DX1;
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}



(*
 * TDDPixelFormat
 *)
  PDDPixelFormat = ^TDDPixelFormat;
  _DDPIXELFORMAT = packed record
    dwSize: DWORD;                 // size of structure
    dwFlags: DWORD;                // pixel format flags
    dwFourCC: DWORD;               // (FOURCC code)
    case Integer of
      1: (
          dwRGBBitCount : DWORD;          // how many bits per pixel
          dwRBitMask : DWORD;             // mask for red bit
          dwGBitMask : DWORD;             // mask for green bits
          dwBBitMask : DWORD;             // mask for blue bits
          dwRGBAlphaBitMask : DWORD;      // mask for alpha channel
          );
      2: (
          dwYUVBitCount : DWORD;          // how many bits per pixel
          dwYBitMask : DWORD;             // mask for Y bits
          dwUBitMask : DWORD;             // mask for U bits
          dwVBitMask : DWORD;             // mask for V bits
          dwYUVAlphaBitMask : DWORD;      // mask for alpha channel
          );
      3: (
          dwZBufferBitDepth : DWORD;      // how many total bits/pixel in z buffer (including any stencil bits)
          dwStencilBitDepth : DWORD;      // how many stencil bits (note: dwZBufferBitDepth-dwStencilBitDepth is total Z-only bits)
          dwZBitMask : DWORD;             // mask for Z bits
          dwStencilBitMask : DWORD;       // mask for stencil bits
          dwLuminanceAlphaBitMask : DWORD; // mask for alpha channel
          );
      4: (
          dwAlphaBitDepth : DWORD;        // how many bits for alpha channels
          dwLuminanceBitMask : DWORD;     // mask for luminance bits
          dwBumpDvBitMask : DWORD;        // mask for bump map V delta bits
          dwBumpLuminanceBitMask : DWORD; // mask for luminance in bump map
          dwRGBZBitMask : DWORD;          // mask for Z channel
          );
      5: (
           dwLuminanceBitCount : DWORD;   // how many bits per pixel
           dwBumpDuBitMask : DWORD;       // mask for bump map U delta bits
           Fill1, Fill2    : DWORD;
           dwYUVZBitMask   : DWORD;       // mask for Z channel
         );
      6: ( dwBumpBitCount  : DWORD;       // how many bits per "buxel", total
         );
  end;
  {$EXTERNALSYM _DDPIXELFORMAT}
  DDPIXELFORMAT = _DDPIXELFORMAT;
  {$EXTERNALSYM DDPIXELFORMAT}
  TDDPixelFormat = _DDPIXELFORMAT;

  // These definitions are for compatibility with Erik Unger original conversion
  PDDPixelFormat_DX3 = PDDPixelFormat;
  TDDPixelFormat_DX3 = TDDPixelFormat;

  PDDPixelFormat_DX5 = PDDPixelFormat;
  TDDPixelFormat_DX5 = TDDPixelFormat;

  PDDPixelFormat_DX6 = PDDPixelFormat;
  TDDPixelFormat_DX6 = TDDPixelFormat;

  PDDPixelFormat_DX7 = PDDPixelFormat;
  TDDPixelFormat_DX7 = TDDPixelFormat;



(*
 * TDDOverlayFX
 *)
  PDDOverlayFX = ^TDDOverlayFX;
  _DDOVERLAYFX = packed record
    dwSize: DWORD;                         // size of structure
    dwAlphaEdgeBlendBitDepth: DWORD;       // Bit depth used to specify constant for alpha edge blend
    dwAlphaEdgeBlend: DWORD;               // Constant to use as alpha for edge blend
    dwReserved: DWORD;
    dwAlphaDestConstBitDepth: DWORD;       // Bit depth used to specify alpha constant for destination
    case Integer of
    0: (
      dwAlphaDestConst: DWORD;             // Constant to use as alpha channel for dest
      dwAlphaSrcConstBitDepth: DWORD;      // Bit depth used to specify alpha constant for source
      dwAlphaSrcConst: DWORD;              // Constant to use as alpha channel for src
      dckDestColorkey: TDDColorKey;        // DestColorkey override
      dckSrcColorkey: TDDColorKey;         // DestColorkey override
      dwDDFX: DWORD;                       // Overlay FX
      dwFlags: DWORD;                      // flags
     );
    1: (
      lpDDSAlphaDest: ^PDirectDrawSurface;  // Surface to use as alpha channel for dest
      filler: DWORD;
      lpDDSAlphaSrc: ^PDirectDrawSurface;   // Surface to use as alpha channel for src
     );
  end;
  {$EXTERNALSYM _DDOVERLAYFX}
  DDOVERLAYFX = _DDOVERLAYFX;
  {$EXTERNALSYM DDOVERLAYFX}
  TDDOverlayFX = _DDOVERLAYFX;

(*
 * TDDBltBatch: BltBatch entry structure
 *)
  PDDBltBatch = ^TDDBltBatch;
  _DDBLTBATCH = packed record
    lprDest: PRect;
    lpDDSSrc: IDirectDrawSurface;
    lprSrc: PRect;
    dwFlags: DWORD;
    lpDDBltFx: TDDBltFX;
  end;
  {$EXTERNALSYM _DDBLTBATCH}
  DDBLTBATCH = _DDBLTBATCH;
  {$EXTERNALSYM DDBLTBATCH}
  TDDBltBatch = _DDBLTBATCH;

(*
 * TDDGammaRamp
 *)
  PDDGammaRamp = ^TDDGammaRamp;
  _DDGAMMARAMP = packed record
    red   : array[0..255] of WORD;
    green : array[0..255] of WORD;
    blue  : array[0..255] of WORD;
  end;
  {$EXTERNALSYM _DDGAMMARAMP}
  DDGAMMARAMP = _DDGAMMARAMP;
  {$EXTERNALSYM DDGAMMARAMP}
  TDDGammaRamp = _DDGAMMARAMP;

(*
 *  This is the structure within which DirectDraw returns data about the current graphics driver and chipset
 *)

  PDDDeviceIdentifier = ^TDDDeviceIdentifier;
  tagDDDEVICEIDENTIFIER = packed record
    //
    // These elements are for presentation to the user only. They should not be used to identify particular
    // drivers, since this is unreliable and many different strings may be associated with the same
    // device, and the same driver from different vendors.
    //
    szDriver: array[0..MAX_DDDEVICEID_STRING-1] of Char;
    szDescription: array[0..MAX_DDDEVICEID_STRING-1] of Char;

    //
    // This element is the version of the DirectDraw/3D driver. It is legal to do <, > comparisons
    // on the whole 64 bits. Caution should be exercised if you use this element to identify problematic
    // drivers. It is recommended that guidDeviceIdentifier is used for this purpose.
    //
    // This version has the form:
    //  wProduct = HIWORD(liDriverVersion.HighPart)
    //  wVersion = LOWORD(liDriverVersion.HighPart)
    //  wSubVersion = HIWORD(liDriverVersion.LowPart)
    //  wBuild = LOWORD(liDriverVersion.LowPart)
    //
    liDriverVersion: TLargeInteger;     // Defined for applications and other 32 bit components

    //
    // These elements can be used to identify particular chipsets. Use with extreme caution.
    //   dwVendorId     Identifies the manufacturer. May be zero if unknown.
    //   dwDeviceId     Identifies the type of chipset. May be zero if unknown.
    //   dwSubSysId     Identifies the subsystem, typically this means the particular board. May be zero if unknown.
    //   dwRevision     Identifies the revision level of the chipset. May be zero if unknown.
    //
    dwVendorId: DWORD;
    dwDeviceId: DWORD;
    dwSubSysId: DWORD;
    dwRevision: DWORD;

    //
    // This element can be used to check changes in driver/chipset. This GUID is a unique identifier for the
    // driver/chipset pair. Use this element if you wish to track changes to the driver/chipset in order to
    // reprofile the graphics subsystem.
    // This element can also be used to identify particular problematic drivers.
    //
    guidDeviceIdentifier: TGUID;
  end;
  {$EXTERNALSYM tagDDDEVICEIDENTIFIER}
  DDDEVICEIDENTIFIER = tagDDDEVICEIDENTIFIER;
  {$EXTERNALSYM DDDEVICEIDENTIFIER}
  TDDDeviceIdentifier = tagDDDEVICEIDENTIFIER;

  PDDDeviceIdentifier2 = ^TDDDeviceIdentifier2;
  tagDDDEVICEIDENTIFIER2 = packed record
    //
    // These elements are for presentation to the user only. They should not be used to identify particular
    // drivers, since this is unreliable and many different strings may be associated with the same
    // device, and the same driver from different vendors.
    //
    szDriver: array[0..MAX_DDDEVICEID_STRING-1] of Char;
    szDescription: array[0..MAX_DDDEVICEID_STRING-1] of Char;

    //
    // This element is the version of the DirectDraw/3D driver. It is legal to do <, > comparisons
    // on the whole 64 bits. Caution should be exercised if you use this element to identify problematic
    // drivers. It is recommended that guidDeviceIdentifier is used for this purpose.
    //
    // This version has the form:
    //  wProduct = HIWORD(liDriverVersion.HighPart)
    //  wVersion = LOWORD(liDriverVersion.HighPart)
    //  wSubVersion = HIWORD(liDriverVersion.LowPart)
    //  wBuild = LOWORD(liDriverVersion.LowPart)
    //
    liDriverVersion: TLargeInteger;     // Defined for applications and other 32 bit components

    //
    // These elements can be used to identify particular chipsets. Use with extreme caution.
    //   dwVendorId     Identifies the manufacturer. May be zero if unknown.
    //   dwDeviceId     Identifies the type of chipset. May be zero if unknown.
    //   dwSubSysId     Identifies the subsystem, typically this means the particular board. May be zero if unknown.
    //   dwRevision     Identifies the revision level of the chipset. May be zero if unknown.
    //
    dwVendorId: DWORD;
    dwDeviceId: DWORD;
    dwSubSysId: DWORD;
    dwRevision: DWORD;

    //
    // This element can be used to check changes in driver/chipset. This GUID is a unique identifier for the
    // driver/chipset pair. Use this element if you wish to track changes to the driver/chipset in order to
    // reprofile the graphics subsystem.
    // This element can also be used to identify particular problematic drivers.
    //
    guidDeviceIdentifier: TGUID;

    (*
     * This element is used to determine the Windows Hardware Quality Lab (WHQL)
     * certification level for this driver/device pair.
     *)
    dwWHQLLevel: DWORD;
  end;
  {$EXTERNALSYM tagDDDEVICEIDENTIFIER2}
  DDDEVICEIDENTIFIER2 = tagDDDEVICEIDENTIFIER2;
  {$EXTERNALSYM DDDEVICEIDENTIFIER2}
  TDDDeviceIdentifier2 = tagDDDEVICEIDENTIFIER2;

(*
 * callbacks
 *)
  TClipperCallback = function(lpDDClipper: IDirectDrawClipper; hWnd: HWND;
      Code: DWORD; lpContext: Pointer): HResult; stdcall;
  {$NODEFINE TClipperCallback}
  {$HPPEMIT 'typedef LPCLIPPERCALLBACK TClipperCallback;'}
  TSurfacesStreamingCallback = function(arg: DWORD): HResult; stdcall;
  {$NODEFINE TSurfacesStreamingCallback}

(*
 * TDDSurfaceDesc
 *)
  PDDSurfaceDesc = ^TDDSurfaceDesc;
  _DDSURFACEDESC = packed record
    dwSize: DWORD;                        // size of the TDDSurfaceDesc structure
    dwFlags: DWORD;                       // determines what fields are valid
    dwHeight: DWORD;                      // height of surface to be created
    dwWidth: DWORD;                       // width of input surface
    case Integer of
    0: (
      dwLinearSize: DWORD;                // unused at the moment
     );
    1: (
      lPitch: Longint;                    // distance to start of next line (return value only)
      dwBackBufferCount: DWORD;           // number of back buffers requested
      case Integer of
      0: (
        dwMipMapCount: DWORD;             // number of mip-map levels requested
        dwAlphaBitDepth: DWORD;           // depth of alpha buffer requested
        dwReserved: DWORD;                // reserved
        lpSurface: Pointer;               // pointer to the associated surface memory
        ddckCKDestOverlay: TDDColorKey;   // color key for destination overlay use
        ddckCKDestBlt: TDDColorKey;       // color key for destination blt use
        ddckCKSrcOverlay: TDDColorKey;    // color key for source overlay use
        ddckCKSrcBlt: TDDColorKey;        // color key for source blt use
        ddpfPixelFormat: TDDPixelFormat;  // pixel format description of the surface
        ddsCaps: TDDSCaps;                // direct draw surface capabilities
       );
      1: (
        dwZBufferBitDepth: DWORD;         // depth of Z buffer requested
       );
      2: (
        dwRefreshRate: DWORD;             // refresh rate (used when display mode is described)
       );
     );
  end;
  {$EXTERNALSYM _DDSURFACEDESC}
  DDSURFACEDESC = _DDSURFACEDESC;
  {$EXTERNALSYM DDSURFACEDESC}
  TDDSurfaceDesc = _DDSURFACEDESC;

  // These definitions are for compatibility with Erik Unger original conversion
  PDDSurfaceDesc_DX5 = PDDSurfaceDesc;
  TDDSurfaceDesc_DX5 = TDDSurfaceDesc;

  PDDSurfaceDesc_DX6 = PDDSurfaceDesc;
  TDDSurfaceDesc_DX6 = TDDSurfaceDesc;


(*
 * TDDSurfaceDesc2
 *)
  PDDSurfaceDesc2 = ^TDDSurfaceDesc2;
  _DDSURFACEDESC2 = packed record
    dwSize: DWORD;                      // size of the TDDSurfaceDesc structure
    dwFlags: DWORD;                     // determines what fields are valid
    dwHeight: DWORD;                    // height of surface to be created
    dwWidth: DWORD;                     // width of input surface
    case Integer of
    0: (
      lPitch : Longint;                  // distance to start of next line (return value only)
     );
    1: (
      dwLinearSize : DWORD;              // Formless late-allocated optimized surface size
      dwBackBufferCount: DWORD;          // number of back buffers requested
      case Integer of
      0: (
        dwMipMapCount: DWORD;            // number of mip-map levels requested
        dwAlphaBitDepth: DWORD;          // depth of alpha buffer requested
        dwReserved: DWORD;               // reserved
        lpSurface: Pointer;              // pointer to the associated surface memory
        ddckCKDestOverlay: TDDColorKey;  // color key for destination overlay use
        ddckCKDestBlt: TDDColorKey;      // color key for destination blt use
        ddckCKSrcOverlay: TDDColorKey;   // color key for source overlay use
        ddckCKSrcBlt: TDDColorKey;       // color key for source blt use
        ddpfPixelFormat: TDDPixelFormat; // pixel format description of the surface
        ddsCaps: TDDSCaps2;              // direct draw surface capabilities
        dwTextureStage: DWORD;           // stage in multitexture cascade
       );
      1: (
        dwRefreshRate: DWORD;            // refresh rate (used when display mode is described)
       );
     );
  end;
  {$EXTERNALSYM _DDSURFACEDESC2}
  DDSURFACEDESC2 = _DDSURFACEDESC2;
  {$EXTERNALSYM DDSURFACEDESC2}
  TDDSurfaceDesc2 = _DDSURFACEDESC2;

(*
 * TDDOptSurfaceDesc
 *)

  PDDOptSurfaceDesc = ^TDDOptSurfaceDesc;
  _DDOPTSURFACEDESC = packed record
    dwSize : DWORD;             // size of the DDOPTSURFACEDESC structure
    dwFlags : DWORD;            // determines what fields are valid
    ddSCaps : TDDSCaps2;        // Common caps like: Memory type
    ddOSCaps : TDDOSCaps;       // Common caps like: Memory type
    guid : TGUID;               // Compression technique GUID
    dwCompressionRatio : DWORD; // Compression ratio
  end;
  {$EXTERNALSYM _DDOPTSURFACEDESC}
  DDOPTSURFACEDESC = _DDOPTSURFACEDESC;
  {$EXTERNALSYM DDOPTSURFACEDESC}
  TDDOptSurfaceDesc = _DDOPTSURFACEDESC;

(*
 * DDCOLORCONTROL
 *)
  PDDColorControl = ^TDDColorControl;
  _DDCOLORCONTROL = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    lBrightness: Longint;
    lContrast: Longint;
    lHue: Longint;
    lSaturation: Longint;
    lSharpness: Longint;
    lGamma: Longint;
    lColorEnable: Longint;
    dwReserved1: DWORD;
  end;
  {$EXTERNALSYM _DDCOLORCONTROL}
  DDCOLORCONTROL = _DDCOLORCONTROL;
  {$EXTERNALSYM DDCOLORCONTROL}
  TDDColorControl = _DDCOLORCONTROL;

(*
 * callbacks
 *)

//{$IFNDEF WINNT}
  TDDEnumModesCallback = function (const lpDDSurfaceDesc: TDDSurfaceDesc;
      lpContext: Pointer): HResult; stdcall;
  {$NODEFINE TDDEnumModesCallback}
  {$HPPEMIT 'typedef LPCLIPPERCALLBACK TDDEnumModesCallback;'}
  TDDEnumModesCallback2 = function (const lpDDSurfaceDesc: TDDSurfaceDesc2;
      lpContext: Pointer): HResult; stdcall;
  {$NODEFINE TDDEnumModesCallback2}
  {$HPPEMIT 'typedef LPDDENUMMODESCALLBACK2 TDDEnumModesCallback2;'}
  TDDEnumSurfacesCallback = function (lpDDSurface: IDirectDrawSurface;
      const lpDDSurfaceDesc: TDDSurfaceDesc; lpContext: Pointer): HResult; stdcall;
  {$NODEFINE TDDEnumSurfacesCallback}
  {$HPPEMIT 'typedef LPDDENUMSURFACESCALLBACK TDDEnumSurfacesCallback;'}
  TDDEnumSurfacesCallback2 = function (lpDDSurface: IDirectDrawSurface4;
      const lpDDSurfaceDesc: TDDSurfaceDesc2; lpContext: Pointer): HResult; stdcall;
  {$NODEFINE TDDEnumSurfacesCallback2}
  {$HPPEMIT 'typedef LPDDENUMSURFACESCALLBACK2 TDDEnumSurfacesCallback2;'}
  TDDEnumSurfacesCallback7 = function (lpDDSurface: IDirectDrawSurface7;
      const lpDDSurfaceDesc: TDDSurfaceDesc2; lpContext: Pointer): HResult; stdcall;
  {$NODEFINE TDDEnumSurfacesCallback7}
  {$HPPEMIT 'typedef LPDDENUMSURFACESCALLBACK7 TDDEnumSurfacesCallback7;'}
//{$ENDIF}

(*
 * INTERACES FOLLOW:
 *      IDirectDraw
 *      IDirectDrawClipper
 *      IDirectDrawPalette
 *      IDirectDrawSurface
 *)

(*
 * IDirectDraw
 *)

  IDirectDraw = interface(IUnknown)
    ['{6C14DB80-A733-11CE-A521-0020AF0BE560}']
    (*** IDirectDraw methods ***)
    function Compact: HResult; stdcall;
    function CreateClipper(dwFlags: DWORD;
        out lplpDDClipper: IDirectDrawClipper;
        pUnkOuter: IUnknown): HResult; stdcall;
    function CreatePalette(dwFlags: DWORD; lpColorTable: Pointer;
        out lplpDDPalette: IDirectDrawPalette;
        pUnkOuter: IUnknown): HResult; stdcall;
    function CreateSurface(var lpDDSurfaceDesc: TDDSurfaceDesc;
        out lplpDDSurface: IDirectDrawSurface;
        pUnkOuter: IUnknown): HResult; stdcall;
    function DuplicateSurface(lpDDSurface: IDirectDrawSurface;
        out lplpDupDDSurface: IDirectDrawSurface): HResult; stdcall;
    function EnumDisplayModes(dwFlags: DWORD;
        lpDDSurfaceDesc: PDDSurfaceDesc; lpContext: Pointer;
        lpEnumModesCallback: TDDEnumModesCallback): HResult; stdcall;
    function EnumSurfaces(dwFlags: DWORD; const lpDDSD: TDDSurfaceDesc;
        lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback) :
        HResult; stdcall;
    function FlipToGDISurface: HResult; stdcall;
    function GetCaps(lpDDDriverCaps: PDDCaps; lpDDHELCaps: PDDCaps): HResult; stdcall;
    function GetDisplayMode(out lpDDSurfaceDesc: TDDSurfaceDesc): HResult; stdcall;
    function GetFourCCCodes(var lpNumCodes: DWORD; lpCodes: PDWORD): HResult; stdcall;
    function GetGDISurface(out lplpGDIDDSSurface: IDirectDrawSurface): HResult; stdcall;
    function GetMonitorFrequency(out lpdwFrequency: DWORD): HResult; stdcall;
    function GetScanLine(out lpdwScanLine: DWORD): HResult; stdcall;
    function GetVerticalBlankStatus(out lpbIsInVB: BOOL): HResult; stdcall;
    function Initialize(lpGUID: PGUID): HResult; stdcall;
    function RestoreDisplayMode: HResult; stdcall;
    function SetCooperativeLevel(hWnd: HWND; dwFlags: DWORD): HResult; stdcall;
    (*** Warning!  SetDisplayMode differs between DirectDraw 1 and DirectDraw 2 ***)
    function SetDisplayMode(dwWidth: DWORD; dwHeight: DWORD;
        dwBpp: DWORD): HResult; stdcall;
    function WaitForVerticalBlank(dwFlags: DWORD; hEvent: THandle): HResult; stdcall;
  end;

  IDirectDraw2 = interface(IUnknown)
    ['{B3A6F3E0-2B43-11CF-A2DE-00AA00B93356}']
    (*** IDirectDraw methods ***)
    function Compact: HResult; stdcall;
    function CreateClipper(dwFlags: DWORD;
        out lplpDDClipper: IDirectDrawClipper;
        pUnkOuter: IUnknown): HResult; stdcall;
    function CreatePalette(dwFlags: DWORD; lpColorTable: Pointer;
        out lplpDDPalette: IDirectDrawPalette;
        pUnkOuter: IUnknown): HResult; stdcall;
    function CreateSurface(var lpDDSurfaceDesc: TDDSurfaceDesc;
        out lplpDDSurface: IDirectDrawSurface;
        pUnkOuter: IUnknown): HResult; stdcall;
    function DuplicateSurface(lpDDSurface: IDirectDrawSurface;
        out lplpDupDDSurface: IDirectDrawSurface): HResult; stdcall;
    function EnumDisplayModes(dwFlags: DWORD;
        lpDDSurfaceDesc: PDDSurfaceDesc; lpContext: Pointer;
        lpEnumModesCallback: TDDEnumModesCallback): HResult; stdcall;
    function EnumSurfaces(dwFlags: DWORD; var lpDDSD: TDDSurfaceDesc;
        lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback): HResult; stdcall;
    function FlipToGDISurface: HResult; stdcall;
    function GetCaps(lpDDDriverCaps: PDDCaps; lpDDHELCaps: PDDCaps): HResult; stdcall;
    function GetDisplayMode(out lpDDSurfaceDesc: TDDSurfaceDesc): HResult; stdcall;
    function GetFourCCCodes(var lpNumCodes: DWORD; lpCodes: PDWORD): HResult; stdcall;
    function GetGDISurface(out lplpGDIDDSSurface: IDirectDrawSurface): HResult; stdcall;
    function GetMonitorFrequency(out lpdwFrequency: DWORD): HResult; stdcall;
    function GetScanLine(out lpdwScanLine: DWORD): HResult; stdcall;
    function GetVerticalBlankStatus(out lpbIsInVB: BOOL): HResult; stdcall;
    function Initialize(lpGUID: PGUID): HResult; stdcall;
    function RestoreDisplayMode: HResult; stdcall;
    function SetCooperativeLevel(hWnd: HWND; dwFlags: DWORD): HResult; stdcall;
    function SetDisplayMode(dwWidth: DWORD; dwHeight: DWORD; dwBPP: DWORD;
        dwRefreshRate: DWORD; dwFlags: DWORD): HResult; stdcall;
    function WaitForVerticalBlank(dwFlags: DWORD; hEvent: THandle): HResult; stdcall;
    (*** Added in the v2 interface ***)
    function GetAvailableVidMem(var lpDDSCaps: TDDSCaps;
        out lpdwTotal, lpdwFree: DWORD): HResult; stdcall;
  end;

  IDirectDraw4 = interface(IUnknown)
    ['{9c59509a-39bd-11d1-8c4a-00c04fd930c5}']
    (*** IDirectDraw methods ***)
    function Compact: HResult; stdcall;
    function CreateClipper(dwFlags: DWORD;
        out lplpDDClipper: IDirectDrawClipper;
        pUnkOuter: IUnknown): HResult; stdcall;
    function CreatePalette(dwFlags: DWORD; lpColorTable: Pointer;
        out lplpDDPalette: IDirectDrawPalette;
        pUnkOuter: IUnknown): HResult; stdcall;
    function CreateSurface(const lpDDSurfaceDesc: TDDSurfaceDesc2;
        out lplpDDSurface: IDirectDrawSurface4;
        pUnkOuter: IUnknown): HResult; stdcall;
    function DuplicateSurface(lpDDSurface: IDirectDrawSurface4;
        out lplpDupDDSurface: IDirectDrawSurface4): HResult; stdcall;
    function EnumDisplayModes(dwFlags: DWORD;
        lpDDSurfaceDesc: PDDSurfaceDesc2; lpContext: Pointer;
        lpEnumModesCallback: TDDEnumModesCallback2): HResult; stdcall;
    function EnumSurfaces(dwFlags: DWORD; const lpDDSD: TDDSurfaceDesc2;
        lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback2):
        HResult; stdcall;
    function FlipToGDISurface: HResult; stdcall;
    function GetCaps(lpDDDriverCaps: PDDCaps; lpDDHELCaps: PDDCaps): HResult; stdcall;
    function GetDisplayMode(out lpDDSurfaceDesc: TDDSurfaceDesc2): HResult; stdcall;
    function GetFourCCCodes(var lpNumCodes: DWORD; lpCodes: PDWORD): HResult; stdcall;
    function GetGDISurface(out lplpGDIDDSSurface: IDirectDrawSurface4): HResult; stdcall;
    function GetMonitorFrequency(out lpdwFrequency: DWORD): HResult; stdcall;
    function GetScanLine(out lpdwScanLine: DWORD): HResult; stdcall;
    function GetVerticalBlankStatus(out lpbIsInVB: BOOL): HResult; stdcall;
    function Initialize(lpGUID: PGUID): HResult; stdcall;
    function RestoreDisplayMode: HResult; stdcall;
    function SetCooperativeLevel(hWnd: HWND; dwFlags: DWORD): HResult; stdcall;
    function SetDisplayMode(dwWidth: DWORD; dwHeight: DWORD; dwBPP: DWORD;
        dwRefreshRate: DWORD; dwFlags: DWORD): HResult; stdcall;
    function WaitForVerticalBlank(dwFlags: DWORD; hEvent: THandle): HResult; stdcall;
    (*** Added in the v2 interface ***)
    function GetAvailableVidMem(const lpDDSCaps: TDDSCaps2;
        out lpdwTotal, lpdwFree: DWORD): HResult; stdcall;
    (*** Added in the V4 Interface ***)
    function GetSurfaceFromDC(hdc: Windows.HDC;
        out lpDDS4: IDirectDrawSurface4): HResult; stdcall;
    function RestoreAllSurfaces: HResult; stdcall;
    function TestCooperativeLevel: HResult; stdcall;
    function GetDeviceIdentifier(out lpdddi: TDDDeviceIdentifier;
        dwFlags: DWORD): HResult; stdcall;
  end;

  IDirectDraw7 = interface(IUnknown)
    ['{15e65ec0-3b9c-11d2-b92f-00609797ea5b}']
    (*** IDirectDraw methods ***)
    function Compact: HResult; stdcall;
    function CreateClipper(dwFlags: DWORD;
        out lplpDDClipper: IDirectDrawClipper;
        pUnkOuter: IUnknown): HResult; stdcall;
    function CreatePalette(dwFlags: DWORD; lpColorTable: Pointer;
        out lplpDDPalette: IDirectDrawPalette;
        pUnkOuter: IUnknown): HResult; stdcall;
    function CreateSurface(const lpDDSurfaceDesc: TDDSurfaceDesc2;
        out lplpDDSurface: IDirectDrawSurface7;
        pUnkOuter: IUnknown): HResult; stdcall;
    function DuplicateSurface(lpDDSurface: IDirectDrawSurface7;
        out lplpDupDDSurface: IDirectDrawSurface7): HResult; stdcall;
    function EnumDisplayModes(dwFlags: DWORD;
        lpDDSurfaceDesc: PDDSurfaceDesc2; lpContext: Pointer;
        lpEnumModesCallback: TDDEnumModesCallback2): HResult; stdcall;
    function EnumSurfaces(dwFlags: DWORD; const lpDDSD: TDDSurfaceDesc2;
        lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback7) :
        HResult; stdcall;
    function FlipToGDISurface: HResult; stdcall;
    function GetCaps(lpDDDriverCaps: PDDCaps; lpDDHELCaps: PDDCaps): HResult; stdcall;
    function GetDisplayMode(out lpDDSurfaceDesc: TDDSurfaceDesc2): HResult; stdcall;
    function GetFourCCCodes(var lpNumCodes: DWORD; lpCodes: PDWORD): HResult; stdcall;
    function GetGDISurface(out lplpGDIDDSSurface: IDirectDrawSurface7) :
        HResult; stdcall;
    function GetMonitorFrequency(out lpdwFrequency: DWORD): HResult; stdcall;
    function GetScanLine(out lpdwScanLine: DWORD): HResult; stdcall;
    function GetVerticalBlankStatus(out lpbIsInVB: BOOL): HResult; stdcall;
    function Initialize(lpGUID: PGUID): HResult; stdcall;
    function RestoreDisplayMode: HResult; stdcall;
    function SetCooperativeLevel(hWnd: HWND; dwFlags: DWORD): HResult; stdcall;
    function SetDisplayMode(dwWidth: DWORD; dwHeight: DWORD; dwBPP: DWORD;
        dwRefreshRate: DWORD; dwFlags: DWORD): HResult; stdcall;
    function WaitForVerticalBlank(dwFlags: DWORD; hEvent: THandle) :
        HResult; stdcall;
    (*** Added in the v2 interface ***)
    function GetAvailableVidMem(const lpDDSCaps: TDDSCaps2;
        out lpdwTotal, lpdwFree: DWORD): HResult; stdcall;
    (*** Added in the V4 Interface ***)
    function GetSurfaceFromDC(hdc: Windows.HDC;
        out lpDDS: IDirectDrawSurface7): HResult; stdcall;
    function RestoreAllSurfaces: HResult; stdcall;
    function TestCooperativeLevel: HResult; stdcall;
    function GetDeviceIdentifier(out lpdddi: TDDDeviceIdentifier2;
        dwFlags: DWORD): HResult; stdcall;
    function StartModeTest(const lpModesToTest; dwNumEntries, dwFlags: DWORD): HResult; stdcall;
    function EvaluateMode(dwFlags: DWORD; out pSecondsUntilTimeout: DWORD): HResult; stdcall;
  end;



(*
 * IDirectDrawPalette
 *)

  IDirectDrawPalette = interface(IUnknown)
    ['{6C14DB84-A733-11CE-A521-0020AF0BE560}']
    (*** IDirectDrawPalette methods ***)
    function GetCaps(out lpdwCaps: DWORD): HResult; stdcall;
    function GetEntries(dwFlags: DWORD; dwBase: DWORD; dwNumEntries: DWORD;
        lpEntries: Pointer): HResult; stdcall;
    function Initialize(lpDD: IDirectDraw; dwFlags: DWORD;
        lpDDColorTable: Pointer): HResult; stdcall;
    function SetEntries(dwFlags: DWORD; dwStartingEntry: DWORD;
        dwCount: DWORD; lpEntries: Pointer): HResult; stdcall;
  end;

(*
 * IDirectDrawClipper
 *)

  IDirectDrawClipper = interface(IUnknown)
    ['{6C14DB85-A733-11CE-A521-0020AF0BE560}']
    (*** IDirectDrawClipper methods ***)
    function GetClipList(lpRect: PRect; lpClipList: PRgnData;
        var lpdwSize: DWORD): HResult; stdcall;
    function GetHWnd(out lphWnd: HWND): HResult; stdcall;
    function Initialize(lpDD: IDirectDraw; dwFlags: DWORD): HResult; stdcall;
    function IsClipListChanged(out lpbChanged: BOOL): HResult; stdcall;
    function SetClipList(lpClipList: PRgnData; dwFlags: DWORD): HResult; stdcall;
    function SetHWnd(dwFlags: DWORD; hWnd: HWND): HResult; stdcall;
  end;

(*
 * IDirectDrawSurface and related interfaces
 *)

  IDirectDrawSurface = interface(IUnknown)
    ['{6C14DB81-A733-11CE-A521-0020AF0BE560}']
    (*** IDirectDrawSurface methods ***)
    function AddAttachedSurface(lpDDSAttachedSurface: IDirectDrawSurface) :
        HResult; stdcall;
    function AddOverlayDirtyRect(const lpRect: TRect): HResult; stdcall;
    function Blt(lpDestRect: PRect;
        lpDDSrcSurface: IDirectDrawSurface; lpSrcRect: PRect;
        dwFlags: DWORD; lpDDBltFx: PDDBltFX): HResult; stdcall;
    function BltBatch(const lpDDBltBatch: TDDBltBatch; dwCount: DWORD;
        dwFlags: DWORD): HResult; stdcall;
    function BltFast(dwX: DWORD; dwY: DWORD;
        lpDDSrcSurface: IDirectDrawSurface; lpSrcRect: PRect;
        dwTrans: DWORD): HResult; stdcall;
    function DeleteAttachedSurface(dwFlags: DWORD;
        lpDDSAttachedSurface: IDirectDrawSurface): HResult; stdcall;
    function EnumAttachedSurfaces(lpContext: Pointer;
        lpEnumSurfacesCallback: TDDEnumSurfacesCallback): HResult; stdcall;
    function EnumOverlayZOrders(dwFlags: DWORD; lpContext: Pointer;
        lpfnCallback: TDDEnumSurfacesCallback): HResult; stdcall;
    function Flip(lpDDSurfaceTargetOverride: IDirectDrawSurface;
        dwFlags: DWORD): HResult; stdcall;
    function GetAttachedSurface(var lpDDSCaps: TDDSCaps;
        (*out*)var lplpDDAttachedSurface: IDirectDrawSurface): HResult; stdcall;
    function GetBltStatus(dwFlags: DWORD): HResult; stdcall;
    function GetCaps(out lpDDSCaps: TDDSCaps): HResult; stdcall;
    function GetClipper(out lplpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function GetColorKey(dwFlags: DWORD; out lpDDColorKey: TDDColorKey) :
        HResult; stdcall;
    function GetDC(out lphDC: HDC): HResult; stdcall;
    function GetFlipStatus(dwFlags: DWORD): HResult; stdcall;
    function GetOverlayPosition(out lplX, lplY: Longint): HResult; stdcall;
    function GetPalette(out lplpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function GetPixelFormat(out lpDDPixelFormat: TDDPixelFormat): HResult; stdcall;
    function GetSurfaceDesc(out lpDDSurfaceDesc: TDDSurfaceDesc): HResult; stdcall;
    function Initialize(lpDD: IDirectDraw;
        out lpDDSurfaceDesc: TDDSurfaceDesc): HResult; stdcall;
    function IsLost: HResult; stdcall;
    function Lock(lpDestRect: PRect; out lpDDSurfaceDesc:
        TDDSurfaceDesc; dwFlags: DWORD; hEvent: THandle): HResult; stdcall;
    function ReleaseDC(hDC: Windows.HDC): HResult; stdcall;
    function _Restore: HResult; stdcall;
    function SetClipper(lpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function SetColorKey(dwFlags: DWORD; lpDDColorKey: PDDColorKey) :
        HResult; stdcall;
    function SetOverlayPosition(lX, lY: Longint): HResult; stdcall;
    function SetPalette(lpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function Unlock(lpSurfaceData: Pointer): HResult; stdcall;
    function UpdateOverlay(lpSrcRect: PRect;
        lpDDDestSurface: IDirectDrawSurface; lpDestRect: PRect;
        dwFlags: DWORD; lpDDOverlayFx: PDDOverlayFX): HResult; stdcall;
    function UpdateOverlayDisplay(dwFlags: DWORD): HResult; stdcall;
    function UpdateOverlayZOrder(dwFlags: DWORD;
        lpDDSReference: IDirectDrawSurface): HResult; stdcall;
  end;

(*
 * IDirectDrawSurface2 and related interfaces
 *)

  IDirectDrawSurface2 = interface(IUnknown)
    ['{57805885-6eec-11cf-9441-a82303c10e27}']
    (*** IDirectDrawSurface methods ***)
    function AddAttachedSurface(lpDDSAttachedSurface: IDirectDrawSurface2) :
        HResult; stdcall;
    function AddOverlayDirtyRect(const lpRect: TRect): HResult; stdcall;
    function Blt(lpDestRect: PRect;
        lpDDSrcSurface: IDirectDrawSurface2; lpSrcRect: PRect;
        dwFlags: DWORD; lpDDBltFx: PDDBltFX): HResult; stdcall;
    function BltBatch(const lpDDBltBatch: TDDBltBatch; dwCount: DWORD;
        dwFlags: DWORD): HResult; stdcall;
    function BltFast(dwX: DWORD; dwY: DWORD;
        lpDDSrcSurface: IDirectDrawSurface2; lpSrcRect: PRect;
        dwTrans: DWORD): HResult; stdcall;
    function DeleteAttachedSurface(dwFlags: DWORD;
        lpDDSAttachedSurface: IDirectDrawSurface2): HResult; stdcall;
    function EnumAttachedSurfaces(lpContext: Pointer;
        lpEnumSurfacesCallback: TDDEnumSurfacesCallback): HResult; stdcall;
    function EnumOverlayZOrders(dwFlags: DWORD; lpContext: Pointer;
        lpfnCallback: TDDEnumSurfacesCallback): HResult; stdcall;
    function Flip(lpDDSurfaceTargetOverride: IDirectDrawSurface2;
        dwFlags: DWORD): HResult; stdcall;
    function GetAttachedSurface(var lpDDSCaps: TDDSCaps;
        out lplpDDAttachedSurface: IDirectDrawSurface2): HResult; stdcall;
    function GetBltStatus(dwFlags: DWORD): HResult; stdcall;
    function GetCaps(out lpDDSCaps: TDDSCaps): HResult; stdcall;
    function GetClipper(out lplpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function GetColorKey(dwFlags: DWORD; out lpDDColorKey: TDDColorKey) :
        HResult; stdcall;
    function GetDC(out lphDC: HDC): HResult; stdcall;
    function GetFlipStatus(dwFlags: DWORD): HResult; stdcall;
    function GetOverlayPosition(out lplX, lplY: Longint): HResult; stdcall;
    function GetPalette(out lplpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function GetPixelFormat(out lpDDPixelFormat: TDDPixelFormat): HResult; stdcall;
    function GetSurfaceDesc(out lpDDSurfaceDesc: TDDSurfaceDesc): HResult; stdcall;
    function Initialize(lpDD: IDirectDraw;
        out lpDDSurfaceDesc: TDDSurfaceDesc): HResult; stdcall;
    function IsLost: HResult; stdcall;
    function Lock(lpDestRect: PRect;
        out lpDDSurfaceDesc: TDDSurfaceDesc; dwFlags: DWORD;
        hEvent: THandle): HResult; stdcall;
    function ReleaseDC(hDC: Windows.HDC): HResult; stdcall;
    function _Restore: HResult; stdcall;
    function SetClipper(lpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function SetColorKey(dwFlags: DWORD; lpDDColorKey: PDDColorKey) :
        HResult; stdcall;
    function SetOverlayPosition(lX, lY: Longint): HResult; stdcall;
    function SetPalette(lpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function Unlock(lpSurfaceData: Pointer): HResult; stdcall;
    function UpdateOverlay(lpSrcRect: PRect;
        lpDDDestSurface: IDirectDrawSurface2; lpDestRect: PRect;
        dwFlags: DWORD; lpDDOverlayFx: PDDOverlayFX): HResult; stdcall;
    function UpdateOverlayDisplay(dwFlags: DWORD): HResult; stdcall;
    function UpdateOverlayZOrder(dwFlags: DWORD;
        lpDDSReference: IDirectDrawSurface2): HResult; stdcall;
    (*** Added in the v2 interface ***)
    function GetDDInterface(var lplpDD: IDirectDraw): HResult; stdcall;
    function PageLock(dwFlags: DWORD): HResult; stdcall;
    function PageUnlock(dwFlags: DWORD): HResult; stdcall;
  end;

  IDirectDrawSurface3 = interface(IUnknown)
    ['{DA044E00-69B2-11D0-A1D5-00AA00B8DFBB}']
    (*** IDirectDrawSurface methods ***)
    function AddAttachedSurface(lpDDSAttachedSurface: IDirectDrawSurface3) :
        HResult; stdcall;
    function AddOverlayDirtyRect(const lpRect: TRect): HResult; stdcall;
    function Blt(lpDestRect: PRect;
        lpDDSrcSurface: IDirectDrawSurface3; lpSrcRect: PRect;
        dwFlags: DWORD; lpDDBltFx: PDDBltFX): HResult; stdcall;
    function BltBatch(const lpDDBltBatch: TDDBltBatch; dwCount: DWORD;
        dwFlags: DWORD): HResult; stdcall;
    function BltFast(dwX: DWORD; dwY: DWORD;
        lpDDSrcSurface: IDirectDrawSurface3; lpSrcRect: PRect;
        dwTrans: DWORD): HResult; stdcall;
    function DeleteAttachedSurface(dwFlags: DWORD;
        lpDDSAttachedSurface: IDirectDrawSurface3): HResult; stdcall;
    function EnumAttachedSurfaces(lpContext: Pointer;
        lpEnumSurfacesCallback: TDDEnumSurfacesCallback): HResult; stdcall;
    function EnumOverlayZOrders(dwFlags: DWORD; lpContext: Pointer;
        lpfnCallback: TDDEnumSurfacesCallback): HResult; stdcall;
    function Flip(lpDDSurfaceTargetOverride: IDirectDrawSurface3;
        dwFlags: DWORD): HResult; stdcall;
    function GetAttachedSurface(var lpDDSCaps: TDDSCaps;
        out lplpDDAttachedSurface: IDirectDrawSurface3): HResult; stdcall;
    function GetBltStatus(dwFlags: DWORD): HResult; stdcall;
    function GetCaps(out lpDDSCaps: TDDSCaps): HResult; stdcall;
    function GetClipper(out lplpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function GetColorKey(dwFlags: DWORD; out lpDDColorKey: TDDColorKey) :
        HResult; stdcall;
    function GetDC(out lphDC: HDC): HResult; stdcall;
    function GetFlipStatus(dwFlags: DWORD): HResult; stdcall;
    function GetOverlayPosition(out lplX, lplY: Longint): HResult; stdcall;
    function GetPalette(out lplpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function GetPixelFormat(out lpDDPixelFormat: TDDPixelFormat): HResult; stdcall;
    function GetSurfaceDesc(out lpDDSurfaceDesc: TDDSurfaceDesc): HResult; stdcall;
    function Initialize(lpDD: IDirectDraw;
        out lpDDSurfaceDesc: TDDSurfaceDesc): HResult; stdcall;
    function IsLost: HResult; stdcall;
    function Lock(lpDestRect: PRect;
        out lpDDSurfaceDesc: TDDSurfaceDesc; dwFlags: DWORD;
        hEvent: THandle): HResult; stdcall;
    function ReleaseDC(hDC: Windows.HDC): HResult; stdcall;
    function _Restore: HResult; stdcall;
    function SetClipper(lpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function SetColorKey(dwFlags: DWORD; lpDDColorKey: PDDColorKey) :
        HResult; stdcall;
    function SetOverlayPosition(lX, lY: Longint): HResult; stdcall;
    function SetPalette(lpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function Unlock(lpSurfaceData: Pointer): HResult; stdcall;
    function UpdateOverlay(lpSrcRect: PRect;
        lpDDDestSurface: IDirectDrawSurface3; lpDestRect: PRect;
        dwFlags: DWORD; lpDDOverlayFx: PDDOverlayFX): HResult; stdcall;
    function UpdateOverlayDisplay(dwFlags: DWORD): HResult; stdcall;
    function UpdateOverlayZOrder(dwFlags: DWORD;
        lpDDSReference: IDirectDrawSurface3): HResult; stdcall;
    (*** Added in the v2 interface ***)
    function GetDDInterface(out lplpDD: IDirectDraw): HResult; stdcall;
    function PageLock(dwFlags: DWORD): HResult; stdcall;
    function PageUnlock(dwFlags: DWORD): HResult; stdcall;
    (*** Added in the V3 interface ***)
    function SetSurfaceDesc(const lpddsd: TDDSurfaceDesc; dwFlags: DWORD): HResult; stdcall;
  end;

(*
 * IDirectDrawSurface4 and related interfaces
 *)
  IDirectDrawSurface4 = interface(IUnknown)
    ['{0B2B8630-AD35-11D0-8EA6-00609797EA5B}']
    (*** IDirectDrawSurface methods ***)
    function AddAttachedSurface(lpDDSAttachedSurface: IDirectDrawSurface4) :
        HResult; stdcall;
    function AddOverlayDirtyRect(const lpRect: TRect): HResult; stdcall;
    function Blt(lpDestRect: PRect;
        lpDDSrcSurface: IDirectDrawSurface4; lpSrcRect: PRect;
        dwFlags: DWORD; lpDDBltFx: PDDBltFX): HResult; stdcall;
    function BltBatch(const lpDDBltBatch: TDDBltBatch; dwCount: DWORD;
        dwFlags: DWORD): HResult; stdcall;
    function BltFast(dwX: DWORD; dwY: DWORD;
        lpDDSrcSurface: IDirectDrawSurface4; lpSrcRect: PRect;
        dwTrans: DWORD): HResult; stdcall;
    function DeleteAttachedSurface(dwFlags: DWORD;
        lpDDSAttachedSurface: IDirectDrawSurface4): HResult; stdcall;
    function EnumAttachedSurfaces(lpContext: Pointer;
        lpEnumSurfacesCallback: TDDEnumSurfacesCallback2): HResult; stdcall;
    function EnumOverlayZOrders(dwFlags: DWORD; lpContext: Pointer;
        lpfnCallback: TDDEnumSurfacesCallback2): HResult; stdcall;
    function Flip(lpDDSurfaceTargetOverride: IDirectDrawSurface4;
        dwFlags: DWORD): HResult; stdcall;
    function GetAttachedSurface(const lpDDSCaps: TDDSCaps2;
        out lplpDDAttachedSurface: IDirectDrawSurface4): HResult; stdcall;
    function GetBltStatus(dwFlags: DWORD): HResult; stdcall;
    function GetCaps(out lpDDSCaps: TDDSCaps2): HResult; stdcall;
    function GetClipper(out lplpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function GetColorKey(dwFlags: DWORD; out lpDDColorKey: TDDColorKey) :
        HResult; stdcall;
    function GetDC(out lphDC: HDC): HResult; stdcall;
    function GetFlipStatus(dwFlags: DWORD): HResult; stdcall;
    function GetOverlayPosition(out lplX, lplY: Longint): HResult; stdcall;
    function GetPalette(out lplpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function GetPixelFormat(out lpDDPixelFormat: TDDPixelFormat): HResult; stdcall;
    function GetSurfaceDesc(out lpDDSurfaceDesc: TDDSurfaceDesc2): HResult; stdcall;
    function Initialize(lpDD: IDirectDraw;
        out lpDDSurfaceDesc: TDDSurfaceDesc2): HResult; stdcall;
    function IsLost: HResult; stdcall;
    function Lock(lpDestRect: PRect;
        out lpDDSurfaceDesc: TDDSurfaceDesc2; dwFlags: DWORD;
        hEvent: THandle): HResult; stdcall;
    function ReleaseDC(hDC: Windows.HDC): HResult; stdcall;
    function _Restore: HResult; stdcall;
    function SetClipper(lpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function SetColorKey(dwFlags: DWORD; lpDDColorKey: PDDColorKey) :
        HResult; stdcall;
    function SetOverlayPosition(lX, lY: Longint): HResult; stdcall;
    function SetPalette(lpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function Unlock(lpRect: PRect): HResult; stdcall;
    function UpdateOverlay(lpSrcRect: PRect;
        lpDDDestSurface: IDirectDrawSurface4; lpDestRect: PRect;
        dwFlags: DWORD; lpDDOverlayFx: PDDOverlayFX): HResult; stdcall;
    function UpdateOverlayDisplay(dwFlags: DWORD): HResult; stdcall;
    function UpdateOverlayZOrder(dwFlags: DWORD;
        lpDDSReference: IDirectDrawSurface4): HResult; stdcall;
    (*** Added in the v2 interface ***)
    function GetDDInterface(out lplpDD: IUnknown): HResult; stdcall;
    function PageLock(dwFlags: DWORD): HResult; stdcall;
    function PageUnlock(dwFlags: DWORD): HResult; stdcall;
    (*** Added in the V3 interface ***)
    function SetSurfaceDesc(const lpddsd2: TDDSurfaceDesc2; dwFlags: DWORD): HResult; stdcall;
    (*** Added in the v4 interface ***)
    function SetPrivateData(const guidTag: TGUID; lpData: Pointer;
        cbSize: DWORD; dwFlags: DWORD): HResult; stdcall;
    function GetPrivateData(const guidTag: TGUID; lpBuffer: Pointer;
        var lpcbBufferSize: DWORD): HResult; stdcall;
    function FreePrivateData(const guidTag: TGUID): HResult; stdcall;
    function GetUniquenessValue(out lpValue: DWORD): HResult; stdcall;
    function ChangeUniquenessValue: HResult; stdcall;
  end;

  IDirectDrawSurface7 = interface(IUnknown)
    ['{06675a80-3b9b-11d2-b92f-00609797ea5b}']
    (*** IDirectDrawSurface methods ***)
    function AddAttachedSurface(lpDDSAttachedSurface: IDirectDrawSurface7) :
        HResult; stdcall;
    function AddOverlayDirtyRect(const lpRect: TRect): HResult; stdcall;
    function Blt(lpDestRect: PRect;
        lpDDSrcSurface: IDirectDrawSurface7; lpSrcRect: PRect;
        dwFlags: DWORD; lpDDBltFx: PDDBltFX): HResult; stdcall;
    function BltBatch(const lpDDBltBatch: TDDBltBatch; dwCount: DWORD;
        dwFlags: DWORD): HResult; stdcall;
    function BltFast(dwX: DWORD; dwY: DWORD;
        lpDDSrcSurface: IDirectDrawSurface7; lpSrcRect: PRect;
        dwTrans: DWORD): HResult; stdcall;
    function DeleteAttachedSurface(dwFlags: DWORD;
        lpDDSAttachedSurface: IDirectDrawSurface7): HResult; stdcall;
    function EnumAttachedSurfaces(lpContext: Pointer;
        lpEnumSurfacesCallback: TDDEnumSurfacesCallback7): HResult; stdcall;
    function EnumOverlayZOrders(dwFlags: DWORD; lpContext: Pointer;
        lpfnCallback: TDDEnumSurfacesCallback7): HResult; stdcall;
    function Flip(lpDDSurfaceTargetOverride: IDirectDrawSurface7;
        dwFlags: DWORD): HResult; stdcall;
    function GetAttachedSurface(const lpDDSCaps: TDDSCaps2;
        out lplpDDAttachedSurface: IDirectDrawSurface7): HResult; stdcall;
    function GetBltStatus(dwFlags: DWORD): HResult; stdcall;
    function GetCaps(out lpDDSCaps: TDDSCaps2): HResult; stdcall;
    function GetClipper(out lplpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function GetColorKey(dwFlags: DWORD; out lpDDColorKey: TDDColorKey) :
        HResult; stdcall;
    function GetDC(out lphDC: HDC): HResult; stdcall;
    function GetFlipStatus(dwFlags: DWORD): HResult; stdcall;
    function GetOverlayPosition(out lplX, lplY: Longint): HResult; stdcall;
    function GetPalette(out lplpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function GetPixelFormat(out lpDDPixelFormat: TDDPixelFormat): HResult; stdcall;
    function GetSurfaceDesc(out lpDDSurfaceDesc: TDDSurfaceDesc2): HResult; stdcall;
    function Initialize(lpDD: IDirectDraw;
        out lpDDSurfaceDesc: TDDSurfaceDesc2): HResult; stdcall;
    function IsLost: HResult; stdcall;
    function Lock(lpDestRect: PRect;
        out lpDDSurfaceDesc: TDDSurfaceDesc2; dwFlags: DWORD;
        hEvent: THandle): HResult; stdcall;
    function ReleaseDC(hDC: Windows.HDC): HResult; stdcall;
    function _Restore: HResult; stdcall;
    function SetClipper(lpDDClipper: IDirectDrawClipper): HResult; stdcall;
    function SetColorKey(dwFlags: DWORD; lpDDColorKey: PDDColorKey) :
        HResult; stdcall;
    function SetOverlayPosition(lX, lY: Longint): HResult; stdcall;
    function SetPalette(lpDDPalette: IDirectDrawPalette): HResult; stdcall;
    function Unlock(lpRect: PRect): HResult; stdcall;
    function UpdateOverlay(lpSrcRect: PRect;
        lpDDDestSurface: IDirectDrawSurface7; lpDestRect: PRect;
        dwFlags: DWORD; lpDDOverlayFx: PDDOverlayFX): HResult; stdcall;
    function UpdateOverlayDisplay(dwFlags: DWORD): HResult; stdcall;
    function UpdateOverlayZOrder(dwFlags: DWORD;
        lpDDSReference: IDirectDrawSurface7): HResult; stdcall;
    (*** Added in the v2 interface ***)
    function GetDDInterface(out lplpDD: IUnknown): HResult; stdcall;
    function PageLock(dwFlags: DWORD): HResult; stdcall;
    function PageUnlock(dwFlags: DWORD): HResult; stdcall;
    (*** Added in the V3 interface ***)
    function SetSurfaceDesc(const lpddsd2: TDDSurfaceDesc2; dwFlags: DWORD): HResult; stdcall;
    (*** Added in the v4 interface ***)
    function SetPrivateData(const guidTag: TGUID; lpData: Pointer;
        cbSize: DWORD; dwFlags: DWORD): HResult; stdcall;
    function GetPrivateData(const guidTag: TGUID; lpBuffer: Pointer;
        var lpcbBufferSize: DWORD): HResult; stdcall;
    function FreePrivateData(const guidTag: TGUID): HResult; stdcall;
    function GetUniquenessValue(out lpValue: DWORD): HResult; stdcall;
    function ChangeUniquenessValue: HResult; stdcall;
    (*** Moved Texture7 methods here ***)
    function SetPriority(dwPriority: DWORD): HResult; stdcall;
    function GetPriority(out lpdwPriority: DWORD): HResult; stdcall;
    function SetLOD(dwMaxLOD: DWORD): HResult; stdcall;
    function GetLOD(out lpdwMaxLOD: DWORD): HResult; stdcall;
  end;

  IDirectDrawColorControl = interface(IUnknown)
    ['{4B9F0EE0-0D7E-11D0-9B06-00A0C903A3B8}']
    function GetColorControls(out lpColorControl: TDDColorControl): HResult; stdcall;
    function SetColorControls(const lpColorControl: TDDColorControl): HResult; stdcall;
  end;

(*
 * IDirectDrawGammaControl
 *)
  IDirectDrawGammaControl = interface(IUnknown)
    ['{69C11C3E-B46B-11D1-AD7A-00C04FC29B4E}']
    function GetGammaRamp(dwFlags: DWORD; out lpRampData: TDDGammaRamp): HResult; stdcall;
    function SetGammaRamp(dwFlags: DWORD; const lpRampData: TDDGammaRamp): HResult; stdcall;
  end;

type
  IID_IDirectDraw = IDirectDraw;
  {$EXTERNALSYM IID_IDirectDraw}
  IID_IDirectDraw2 = IDirectDraw2;
  {$EXTERNALSYM IID_IDirectDraw2}
  IID_IDirectDraw4 = IDirectDraw4;
  {$EXTERNALSYM IID_IDirectDraw4}
  IID_IDirectDraw7 = IDirectDraw7;
  {$EXTERNALSYM IID_IDirectDraw7}
  IID_IDirectDrawSurface = IDirectDrawSurface;
  {$EXTERNALSYM IID_IDirectDrawSurface}
  IID_IDirectDrawSurface2 = IDirectDrawSurface2;
  {$EXTERNALSYM IID_IDirectDrawSurface2}
  IID_IDirectDrawSurface3 = IDirectDrawSurface3;
  {$EXTERNALSYM IID_IDirectDrawSurface3}
  IID_IDirectDrawSurface4 = IDirectDrawSurface4;
  {$EXTERNALSYM IID_IDirectDrawSurface4}
  IID_IDirectDrawSurface7 = IDirectDrawSurface7;
  {$EXTERNALSYM IID_IDirectDrawSurface7}

  IID_IDirectDrawPalette = IDirectDrawPalette;
  {$EXTERNALSYM IID_IDirectDrawPalette}
  IID_IDirectDrawClipper = IDirectDrawClipper;
  {$EXTERNALSYM IID_IDirectDrawClipper}
  IID_IDirectDrawColorControl = IDirectDrawColorControl;
  {$EXTERNALSYM IID_IDirectDrawColorControl}
  IID_IDirectDrawGammaControl = IDirectDrawGammaControl;
  {$EXTERNALSYM IID_IDirectDrawGammaControl}

const
(*
 * ddsCaps field is valid.
 *)
  DDSD_CAPS               = $00000001;     // default
  {$EXTERNALSYM DDSD_CAPS}

(*
 * dwHeight field is valid.
 *)
  DDSD_HEIGHT             = $00000002;
  {$EXTERNALSYM DDSD_HEIGHT}

(*
 * dwWidth field is valid.
 *)
  DDSD_WIDTH              = $00000004;
  {$EXTERNALSYM DDSD_WIDTH}

(*
 * lPitch is valid.
 *)
  DDSD_PITCH              = $00000008;
  {$EXTERNALSYM DDSD_PITCH}

(*
 * dwBackBufferCount is valid.
 *)
  DDSD_BACKBUFFERCOUNT    = $00000020;
  {$EXTERNALSYM DDSD_BACKBUFFERCOUNT}

(*
 * dwZBufferBitDepth is valid.  (shouldnt be used in DDSURFACEDESC2)
 *)
  DDSD_ZBUFFERBITDEPTH    = $00000040;
  {$EXTERNALSYM DDSD_ZBUFFERBITDEPTH}

(*
 * dwAlphaBitDepth is valid.
 *)
   DDSD_ALPHABITDEPTH      = $00000080;
   {$EXTERNALSYM DDSD_ALPHABITDEPTH}

(*
 * lpSurface is valid.
 *)
  DDSD_LPSURFACE	   = $00000800;
  {$EXTERNALSYM DDSD_LPSURFACE}

(*
 * ddpfPixelFormat is valid.
 *)
  DDSD_PIXELFORMAT        = $00001000;
  {$EXTERNALSYM DDSD_PIXELFORMAT}

(*
 * ddckCKDestOverlay is valid.
 *)
  DDSD_CKDESTOVERLAY      = $00002000;
  {$EXTERNALSYM DDSD_CKDESTOVERLAY}

(*
 * ddckCKDestBlt is valid.
 *)
  DDSD_CKDESTBLT          = $00004000;
  {$EXTERNALSYM DDSD_CKDESTBLT}

(*
 * ddckCKSrcOverlay is valid.
 *)
  DDSD_CKSRCOVERLAY       = $00008000;
  {$EXTERNALSYM DDSD_CKSRCOVERLAY}

(*
 * ddckCKSrcBlt is valid.
 *)
  DDSD_CKSRCBLT           = $00010000;
  {$EXTERNALSYM DDSD_CKSRCBLT}

(*
 * dwMipMapCount is valid.
 *)
  DDSD_MIPMAPCOUNT        = $00020000;
  {$EXTERNALSYM DDSD_MIPMAPCOUNT}

 (*
  * dwRefreshRate is valid
  *)
  DDSD_REFRESHRATE        = $00040000;
  {$EXTERNALSYM DDSD_REFRESHRATE}

(*
 * dwLinearSize is valid
 *)
  DDSD_LINEARSIZE	  = $00080000;
  {$EXTERNALSYM DDSD_LINEARSIZE}

(*
 * dwTextureStage is valid
 *)
  DDSD_TEXTURESTAGE       = $00100000;
  {$EXTERNALSYM DDSD_TEXTURESTAGE}

(*
 * dwFVF is valid
 *)
  DDSD_FVF                = $00200000;
  {$EXTERNALSYM DDSD_FVF}

(*
 * dwSrcVBHandle is valid
 *)
  DDSD_SRCVBHANDLE        = $00400000;
  {$EXTERNALSYM DDSD_SRCVBHANDLE}

(*
 * dwDepth is valid
 *)
  DDSD_DEPTH              = $00800000;
  {$EXTERNALSYM DDSD_DEPTH}

(*
 * All input fields are valid.
 *)
  DDSD_ALL		  = $00fff9ee;
  {$EXTERNALSYM DDSD_ALL}


(*
 * guid field is valid.
 *)
  DDOSD_GUID                  = $00000001;
  {$EXTERNALSYM DDOSD_GUID}

(*
 * dwCompressionRatio field is valid.
 *)
  DDOSD_COMPRESSION_RATIO     = $00000002;
  {$EXTERNALSYM DDOSD_COMPRESSION_RATIO}

(*
 * ddSCaps field is valid.
 *)
  DDOSD_SCAPS                 = $00000004;
  {$EXTERNALSYM DDOSD_SCAPS}

(*
 * ddOSCaps field is valid.
 *)
  DDOSD_OSCAPS                = $00000008;
  {$EXTERNALSYM DDOSD_OSCAPS}

(*
 * All input fields are valid.
 *)
  DDOSD_ALL                   = $0000000f;
  {$EXTERNALSYM DDOSD_ALL}

(*
 * The surface's optimized pixelformat is compressed
 *)
  DDOSDCAPS_OPTCOMPRESSED			= $00000001;
  {$EXTERNALSYM DDOSDCAPS_OPTCOMPRESSED}

(*
 * The surface's optimized pixelformat is reordered
 *)
  DDOSDCAPS_OPTREORDERED			= $00000002;
  {$EXTERNALSYM DDOSDCAPS_OPTREORDERED}

(*
 * The opt surface is a monolithic mipmap
 *)
  DDOSDCAPS_MONOLITHICMIPMAP		= $00000004;
  {$EXTERNALSYM DDOSDCAPS_MONOLITHICMIPMAP}

(*
 * The valid Surf caps:
 *   DDSCAPS_SYSTEMMEMORY  	= $00000800;
 *   DDSCAPS_VIDEOMEMORY        = $00004000;
 *   DDSCAPS_LOCALVIDMEM        = $10000000;
 *   DDSCAPS_NONLOCALVIDMEM     = $20000000;
 *)
  DDOSDCAPS_VALIDSCAPS         	= $30004800;
  {$EXTERNALSYM DDOSDCAPS_VALIDSCAPS}

(*
 * The valid OptSurf caps
 *)
  DDOSDCAPS_VALIDOSCAPS         	= $00000007;
  {$EXTERNALSYM DDOSDCAPS_VALIDOSCAPS}


(*
 * DDCOLORCONTROL
 *)

(*
 * lBrightness field is valid.
 *)
  DDCOLOR_BRIGHTNESS		= $00000001;
  {$EXTERNALSYM DDCOLOR_BRIGHTNESS}

(*
 * lContrast field is valid.
 *)
  DDCOLOR_CONTRAST		= $00000002;
  {$EXTERNALSYM DDCOLOR_CONTRAST}

(*
 * lHue field is valid.
 *)
  DDCOLOR_HUE			= $00000004;
  {$EXTERNALSYM DDCOLOR_HUE}

(*
 * lSaturation field is valid.
 *)
  DDCOLOR_SATURATION		= $00000008;
  {$EXTERNALSYM DDCOLOR_SATURATION}

(*
 * lSharpness field is valid.
 *)
  DDCOLOR_SHARPNESS		= $00000010;
  {$EXTERNALSYM DDCOLOR_SHARPNESS}

(*
 * lGamma field is valid.
 *)
  DDCOLOR_GAMMA			= $00000020;
  {$EXTERNALSYM DDCOLOR_GAMMA}

(*
 * lColorEnable field is valid.
 *)
  DDCOLOR_COLORENABLE		= $00000040;
  {$EXTERNALSYM DDCOLOR_COLORENABLE}



(*============================================================================
 *
 * Direct Draw Capability Flags
 *
 * These flags are used to describe the capabilities of a given Surface.
 * All flags are bit flags.
 *
 *==========================================================================*)

(****************************************************************************
 *
 * DIRECTDRAWSURFACE CAPABILITY FLAGS
 *
 ****************************************************************************)
(*
 * This bit currently has no meaning.
 *)
  DDSCAPS_RESERVED1                       = $00000001;
  {$EXTERNALSYM DDSCAPS_RESERVED1}

(*
 * Indicates that this surface contains alpha-only information.
 * (To determine if a surface is RGBA/YUVA, the pixel format must be
 * interrogated.)
 *)
  DDSCAPS_ALPHA                           = $00000002;
  {$EXTERNALSYM DDSCAPS_ALPHA}

(*
 * Indicates that this surface is a backbuffer.  It is generally
 * set by CreateSurface when the DDSCAPS_FLIP capability bit is set.
 * It indicates that this surface is THE back buffer of a surface
 * flipping structure.  DirectDraw supports N surfaces in a
 * surface flipping structure.  Only the surface that immediately
 * precedeces the DDSCAPS_FRONTBUFFER has this capability bit set.
 * The other surfaces are identified as back buffers by the presence
 * of the DDSCAPS_FLIP capability, their attachment order, and the
 * absence of the DDSCAPS_FRONTBUFFER and DDSCAPS_BACKBUFFER
 * capabilities.  The bit is sent to CreateSurface when a standalone
 * back buffer is being created.  This surface could be attached to
 * a front buffer and/or back buffers to form a flipping surface
 * structure after the CreateSurface call.  See AddAttachments for
 * a detailed description of the behaviors in this case.
 *)
  DDSCAPS_BACKBUFFER                      = $00000004;
  {$EXTERNALSYM DDSCAPS_BACKBUFFER}

(*
 * Indicates a complex surface structure is being described.  A
 * complex surface structure results in the creation of more than
 * one surface.  The additional surfaces are attached to the root
 * surface.  The complex structure can only be destroyed by
 * destroying the root.
 *)
  DDSCAPS_COMPLEX                         = $00000008;
  {$EXTERNALSYM DDSCAPS_COMPLEX}

(*
 * Indicates that this surface is a part of a surface flipping structure.
 * When it is passed to CreateSurface the DDSCAPS_FRONTBUFFER and
 * DDSCAP_BACKBUFFER bits are not set.  They are set by CreateSurface
 * on the resulting creations.  The dwBackBufferCount field in the
 * TDDSurfaceDesc structure must be set to at least 1 in order for
 * the CreateSurface call to succeed.  The DDSCAPS_COMPLEX capability
 * must always be set with creating multiple surfaces through CreateSurface.
 *)
  DDSCAPS_FLIP                            = $00000010;
  {$EXTERNALSYM DDSCAPS_FLIP}

(*
 * Indicates that this surface is THE front buffer of a surface flipping
 * structure.  It is generally set by CreateSurface when the DDSCAPS_FLIP
 * capability bit is set.
 * If this capability is sent to CreateSurface then a standalonw front buffer
 * is created.  This surface will not have the DDSCAPS_FLIP capability.
 * It can be attached to other back buffers to form a flipping structure.
 * See AddAttachments for a detailed description of the behaviors in this
 * case.
 *)
  DDSCAPS_FRONTBUFFER                     = $00000020;
  {$EXTERNALSYM DDSCAPS_FRONTBUFFER}

(*
 * Indicates that this surface is any offscreen surface that is not an overlay,
 * texture, zbuffer, front buffer, back buffer, or alpha surface.  It is used
 * to identify plain vanilla surfaces.
 *)
  DDSCAPS_OFFSCREENPLAIN                  = $00000040;
  {$EXTERNALSYM DDSCAPS_OFFSCREENPLAIN}

(*
 * Indicates that this surface is an overlay.  It may or may not be directly visible
 * depending on whether or not it is currently being overlayed onto the primary
 * surface.  DDSCAPS_VISIBLE can be used to determine whether or not it is being
 * overlayed at the moment.
 *)
  DDSCAPS_OVERLAY                         = $00000080;
  {$EXTERNALSYM DDSCAPS_OVERLAY}

(*
 * Indicates that unique DirectDrawPalette objects can be created and
 * attached to this surface.
 *)
  DDSCAPS_PALETTE                         = $00000100;
  {$EXTERNALSYM DDSCAPS_PALETTE}

(*
 * Indicates that this surface is the primary surface.  The primary
 * surface represents what the user is seeing at the moment.
 *)
  DDSCAPS_PRIMARYSURFACE                  = $00000200;
  {$EXTERNALSYM DDSCAPS_PRIMARYSURFACE}

(*
 * This flag used to be DDSCAPS_PRIMARYSURFACELEFT, which is now
 * obsolete.
 *)
  DDSCAPS_RESERVED3              = $00000400;
  {$EXTERNALSYM DDSCAPS_RESERVED3}
  DDSCAPS_PRIMARYSURFACELEFT = DDSCAPS_RESERVED3;
  {$EXTERNALSYM DDSCAPS_PRIMARYSURFACELEFT}

(*
 * Indicates that this surface memory was allocated in system memory
 *)
  DDSCAPS_SYSTEMMEMORY                    = $00000800;
  {$EXTERNALSYM DDSCAPS_SYSTEMMEMORY}

(*
 * Indicates that this surface can be used as a 3D texture.  It does not
 * indicate whether or not the surface is being used for that purpose.
 *)
  DDSCAPS_TEXTURE                         = $00001000;
  {$EXTERNALSYM DDSCAPS_TEXTURE}

(*
 * Indicates that a surface may be a destination for 3D rendering.  This
 * bit must be set in order to query for a Direct3D Device Interface
 * from this surface.
 *)
  DDSCAPS_3DDEVICE                        = $00002000;
  {$EXTERNALSYM DDSCAPS_3DDEVICE}

(*
 * Indicates that this surface exists in video memory.
 *)
  DDSCAPS_VIDEOMEMORY                     = $00004000;
  {$EXTERNALSYM DDSCAPS_VIDEOMEMORY}

(*
 * Indicates that changes made to this surface are immediately visible.
 * It is always set for the primary surface and is set for overlays while
 * they are being overlayed and texture maps while they are being textured.
 *)
  DDSCAPS_VISIBLE                         = $00008000;
  {$EXTERNALSYM DDSCAPS_VISIBLE}

(*
 * Indicates that only writes are permitted to the surface.  Read accesses
 * from the surface may or may not generate a protection fault, but the
 * results of a read from this surface will not be meaningful.  READ ONLY.
 *)
  DDSCAPS_WRITEONLY                       = $00010000;
  {$EXTERNALSYM DDSCAPS_WRITEONLY}

(*
 * Indicates that this surface is a z buffer. A z buffer does not contain
 * displayable information.  Instead it contains bit depth information that is
 * used to determine which pixels are visible and which are obscured.
 *)
  DDSCAPS_ZBUFFER                         = $00020000;
  {$EXTERNALSYM DDSCAPS_ZBUFFER}

(*
 * Indicates surface will have a DC associated long term
 *)
  DDSCAPS_OWNDC                           = $00040000;
  {$EXTERNALSYM DDSCAPS_OWNDC}

(*
 * Indicates surface should be able to receive live video
 *)
  DDSCAPS_LIVEVIDEO                       = $00080000;
  {$EXTERNALSYM DDSCAPS_LIVEVIDEO}

(*
 * Indicates surface should be able to have a stream decompressed
 * to it by the hardware.
 *)
  DDSCAPS_HWCODEC                         = $00100000;
  {$EXTERNALSYM DDSCAPS_HWCODEC}

(*
 * Surface is a ModeX surface.
 *
 *)
  DDSCAPS_MODEX                           = $00200000;
  {$EXTERNALSYM DDSCAPS_MODEX}

(*
 * Indicates surface is one level of a mip-map. This surface will
 * be attached to other DDSCAPS_MIPMAP surfaces to form the mip-map.
 * This can be done explicitly, by creating a number of surfaces and
 * attaching them with AddAttachedSurface or by implicitly by CreateSurface.
 * If this bit is set then DDSCAPS_TEXTURE must also be set.
 *)
  DDSCAPS_MIPMAP                          = $00400000;
  {$EXTERNALSYM DDSCAPS_MIPMAP}

(*
 * This bit is reserved. It should not be specified.
 *)
  DDSCAPS_RESERVED2                       = $00800000;
  {$EXTERNALSYM DDSCAPS_RESERVED2}

(*
 * Indicates that memory for the surface is not allocated until the surface
 * is loaded (via the Direct3D texture Load() function).
 *)
  DDSCAPS_ALLOCONLOAD                     = $04000000;
  {$EXTERNALSYM DDSCAPS_ALLOCONLOAD}

(*
 * Indicates that the surface will recieve data from a video port.
 *)
  DDSCAPS_VIDEOPORT		          = $08000000;
  {$EXTERNALSYM DDSCAPS_VIDEOPORT}

(*
 * Indicates that a video memory surface is resident in true, local video
 * memory rather than non-local video memory. If this flag is specified then
 * so must DDSCAPS_VIDEOMEMORY. This flag is mutually exclusive with
 * DDSCAPS_NONLOCALVIDMEM.
 *)
  DDSCAPS_LOCALVIDMEM                     = $10000000;
  {$EXTERNALSYM DDSCAPS_LOCALVIDMEM}

(*
 * Indicates that a video memory surface is resident in non-local video
 * memory rather than true, local video memory. If this flag is specified
 * then so must DDSCAPS_VIDEOMEMORY. This flag is mutually exclusive with
 * DDSCAPS_LOCALVIDMEM.
 *)
  DDSCAPS_NONLOCALVIDMEM                  = $20000000;
  {$EXTERNALSYM DDSCAPS_NONLOCALVIDMEM}

(*
 * Indicates that this surface is a standard VGA mode surface, and not a
 * ModeX surface. (This flag will never be set in combination with the
 * DDSCAPS_MODEX flag).
 *)
  DDSCAPS_STANDARDVGAMODE                 = $40000000;
  {$EXTERNALSYM DDSCAPS_STANDARDVGAMODE}

(*
 * Indicates that this surface will be an optimized surface. This flag is
 * currently only valid in conjunction with the DDSCAPS_TEXTURE flag. The surface
 * will be created without any underlying video memory until loaded.
 *)
  DDSCAPS_OPTIMIZED                       = $80000000;
  {$EXTERNALSYM DDSCAPS_OPTIMIZED}



(*
 * This bit is reserved
 *)
  DDSCAPS2_RESERVED4                      = $00000002;
  {$EXTERNALSYM DDSCAPS2_RESERVED4}
  DDSCAPS2_HARDWAREDEINTERLACE            = $00000000;
  {$EXTERNALSYM DDSCAPS2_HARDWAREDEINTERLACE}

(*
 * Indicates to the driver that this surface will be locked very frequently
 * (for procedural textures, dynamic lightmaps, etc). Surfaces with this cap
 * set must also have DDSCAPS_TEXTURE. This cap cannot be used with
 * DDSCAPS2_HINTSTATIC and DDSCAPS2_OPAQUE.
 *)
  DDSCAPS2_HINTDYNAMIC 			= $00000004;
  {$EXTERNALSYM DDSCAPS2_HINTDYNAMIC}

(*
 * Indicates to the driver that this surface can be re-ordered/retiled on
 * load. This operation will not change the size of the texture. It is
 * relatively fast and symmetrical, since the application may lock these
 * bits (although it will take a performance hit when doing so). Surfaces
 * with this cap set must also have DDSCAPS_TEXTURE. This cap cannot be
 * used with DDSCAPS2_HINTDYNAMIC and DDSCAPS2_OPAQUE.
 *)
  DDSCAPS2_HINTSTATIC 			= $00000008;
  {$EXTERNALSYM DDSCAPS2_HINTSTATIC}

(*
 * Indicates that the client would like this texture surface to be managed by the
 * DirectDraw/Direct3D runtime. Surfaces with this cap set must also have
 * DDSCAPS_TEXTURE and DDSCAPS_SYSTEMMEMORY.
 *)
  DDSCAPS2_TEXTUREMANAGE                  = $00000010;
  {$EXTERNALSYM DDSCAPS2_TEXTUREMANAGE}

(*
 * These bits are reserved for internal use *)
  DDSCAPS2_RESERVED1                      = $00000020;
  {$EXTERNALSYM DDSCAPS2_RESERVED1}
  DDSCAPS2_RESERVED2                      = $00000040;
  {$EXTERNALSYM DDSCAPS2_RESERVED2}

(*
 * Indicates to the driver that this surface will never be locked again.
 * The driver is free to optimize this surface via retiling and actual compression.
 * All calls to Lock() or Blts from this surface will fail. Surfaces with this
 * cap set must also have DDSCAPS_TEXTURE. This cap cannot be used with
 * DDSCAPS2_HINTDYNAMIC and DDSCAPS2_HINTSTATIC.
 *)
  DDSCAPS2_OPAQUE                         = $00000080;
  {$EXTERNALSYM DDSCAPS2_OPAQUE}

(*
 * Applications should set this bit at CreateSurface time to indicate that they
 * intend to use antialiasing. Only valid if DDSCAPS_3DDEVICE is also set.
 *)
  DDSCAPS2_HINTANTIALIASING               = $00000100;
  {$EXTERNALSYM DDSCAPS2_HINTANTIALIASING}

(*
 * This flag is used at CreateSurface time to indicate that this set of
 * surfaces is a cubic environment map
 *)
  DDSCAPS2_CUBEMAP                        = $00000200;
  {$EXTERNALSYM DDSCAPS2_CUBEMAP}

(*
 * These flags preform two functions:
 * - At CreateSurface time, they define which of the six cube faces are
 *   required by the application.
 * - After creation, each face in the cubemap will have exactly one of these
 *   bits set.
 *)
  DDSCAPS2_CUBEMAP_POSITIVEX              = $00000400;
  {$EXTERNALSYM DDSCAPS2_CUBEMAP_POSITIVEX}
  DDSCAPS2_CUBEMAP_NEGATIVEX              = $00000800;
  {$EXTERNALSYM DDSCAPS2_CUBEMAP_NEGATIVEX}
  DDSCAPS2_CUBEMAP_POSITIVEY              = $00001000;
  {$EXTERNALSYM DDSCAPS2_CUBEMAP_POSITIVEY}
  DDSCAPS2_CUBEMAP_NEGATIVEY              = $00002000;
  {$EXTERNALSYM DDSCAPS2_CUBEMAP_NEGATIVEY}
  DDSCAPS2_CUBEMAP_POSITIVEZ              = $00004000;
  {$EXTERNALSYM DDSCAPS2_CUBEMAP_POSITIVEZ}
  DDSCAPS2_CUBEMAP_NEGATIVEZ              = $00008000;
  {$EXTERNALSYM DDSCAPS2_CUBEMAP_NEGATIVEZ}

(*
 * This macro may be used to specify all faces of a cube map at CreateSurface time
 *)
  DDSCAPS2_CUBEMAP_ALLFACES = ( DDSCAPS2_CUBEMAP_POSITIVEX or
                                DDSCAPS2_CUBEMAP_NEGATIVEX or
                                DDSCAPS2_CUBEMAP_POSITIVEY or
                                DDSCAPS2_CUBEMAP_NEGATIVEY or
                                DDSCAPS2_CUBEMAP_POSITIVEZ or
                                DDSCAPS2_CUBEMAP_NEGATIVEZ );
  {$EXTERNALSYM DDSCAPS2_CUBEMAP_ALLFACES}


(*
 * This flag is an additional flag which is present on mipmap sublevels from DX7 onwards
 * It enables easier use of GetAttachedSurface rather than EnumAttachedSurfaces for surface
 * constructs such as Cube Maps, wherein there are more than one mipmap surface attached
 * to the root surface.
 * This caps bit is ignored by CreateSurface
 *)
  DDSCAPS2_MIPMAPSUBLEVEL                 = $00010000;
  {$EXTERNALSYM DDSCAPS2_MIPMAPSUBLEVEL}

(* This flag indicates that the texture should be managed by D3D only *)
  DDSCAPS2_D3DTEXTUREMANAGE               = $00020000;
  {$EXTERNALSYM DDSCAPS2_D3DTEXTUREMANAGE}

(* This flag indicates that the managed surface can be safely lost *)
  DDSCAPS2_DONOTPERSIST                   = $00040000;
  {$EXTERNALSYM DDSCAPS2_DONOTPERSIST}

(* indicates that this surface is part of a stereo flipping chain *)
  DDSCAPS2_STEREOSURFACELEFT              = $00080000;
  {$EXTERNALSYM DDSCAPS2_STEREOSURFACELEFT}


(*
 * Indicates that the surface is a volume.
 * Can be combined with DDSCAPS_MIPMAP to indicate a multi-level volume
 *)
  DDSCAPS2_VOLUME                         = $00200000;
  {$EXTERNALSYM DDSCAPS2_VOLUME}

(*
 * Indicates that the surface may be locked multiple times by the application.
 * This cap cannot be used with DDSCAPS2_OPAQUE.
 *)
  DDSCAPS2_NOTUSERLOCKABLE                = $00400000;
  {$EXTERNALSYM DDSCAPS2_NOTUSERLOCKABLE}

(*
 * Indicates that the vertex buffer data can be used to render points and
 * point sprites.
 *)
  DDSCAPS2_POINTS                         = $00800000;
  {$EXTERNALSYM DDSCAPS2_POINTS}

(*
 * Indicates that the vertex buffer data can be used to render rt pactches.
 *)
  DDSCAPS2_RTPATCHES                      = $01000000;
  {$EXTERNALSYM DDSCAPS2_RTPATCHES}

(*
 * Indicates that the vertex buffer data can be used to render n patches.
 *)
  DDSCAPS2_NPATCHES                       = $02000000;
  {$EXTERNALSYM DDSCAPS2_NPATCHES}

(*
 * This bit is reserved for internal use
 *)
  DDSCAPS2_RESERVED3                      = $04000000;
  {$EXTERNALSYM DDSCAPS2_RESERVED3}


(*
 * Indicates that the contents of the backbuffer do not have to be preserved
 * the contents of the backbuffer after they are presented.
 *)
  DDSCAPS2_DISCARDBACKBUFFER              = $10000000;
  {$EXTERNALSYM DDSCAPS2_DISCARDBACKBUFFER}

(*
 * Indicates that all surfaces in this creation chain should be given an alpha channel.
 * This flag will be set on primary surface chains that may have no explicit pixel format
 * (and thus take on the format of the current display mode).
 * The driver should infer that all these surfaces have a format having an alpha channel.
 * (e.g. assume D3DFMT_A8R8G8B8 if the display mode is x888.)
 *)
  DDSCAPS2_ENABLEALPHACHANNEL             = $20000000;
  {$EXTERNALSYM DDSCAPS2_ENABLEALPHACHANNEL}

(*
 * Indicates that all surfaces in this creation chain is extended primary surface format.
 * This flag will be set on extended primary surface chains that always have explicit pixel
 * format and the pixel format is typically GDI (Graphics Device Interface) couldn't handle,
 * thus only used with fullscreen application. (e.g. D3DFMT_A2R10G10B10 format)
 *)
  DDSCAPS2_EXTENDEDFORMATPRIMARY          = $40000000;
  {$EXTERNALSYM DDSCAPS2_EXTENDEDFORMATPRIMARY}

(*
 * Indicates that all surfaces in this creation chain is additional primary surface.
 * This flag will be set on primary surface chains which must present on the adapter
 * id provided on dwCaps4. Typically this will be used to create secondary primary surface
 * on DualView display adapter.
 *)
  DDSCAPS2_ADDITIONALPRIMARY              = $80000000;
  {$EXTERNALSYM DDSCAPS2_ADDITIONALPRIMARY}

(*
 * This is a mask that indicates the set of bits that may be set
 * at createsurface time to indicate number of samples per pixel
 * when multisampling
 *)
  DDSCAPS3_MULTISAMPLE_MASK               = $0000001F;
  {$EXTERNALSYM DDSCAPS3_MULTISAMPLE_MASK}

(*
 * This is a mask that indicates the set of bits that may be set
 * at createsurface time to indicate the quality level of rendering
 * for the current number of samples per pixel
 *)
  DDSCAPS3_MULTISAMPLE_QUALITY_MASK       = $000000E0;
  {$EXTERNALSYM DDSCAPS3_MULTISAMPLE_QUALITY_MASK}
  DDSCAPS3_MULTISAMPLE_QUALITY_SHIFT      = 5;
  {$EXTERNALSYM DDSCAPS3_MULTISAMPLE_QUALITY_SHIFT}

(*
 * This bit is reserved for internal use
 *)
  DDSCAPS3_RESERVED1                      = $00000100;
  {$EXTERNALSYM DDSCAPS3_RESERVED1}

(*
 * This bit is reserved for internal use
 *)
  DDSCAPS3_RESERVED2                      = $00000200;
  {$EXTERNALSYM DDSCAPS3_RESERVED2}

(*
 * This indicates whether this surface has light-weight miplevels
 *)
  DDSCAPS3_LIGHTWEIGHTMIPMAP              = $00000400;
  {$EXTERNALSYM DDSCAPS3_LIGHTWEIGHTMIPMAP}

(*
 * This indicates that the mipsublevels for this surface are auto-generated
 *)
  DDSCAPS3_AUTOGENMIPMAP                  = $00000800;
  {$EXTERNALSYM DDSCAPS3_AUTOGENMIPMAP}

(*
 * This indicates that the mipsublevels for this surface are auto-generated
 *)
  DDSCAPS3_DMAP                           = $00001000;
  {$EXTERNALSYM DDSCAPS3_DMAP}


 (****************************************************************************
 *
 * DIRECTDRAW DRIVER CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Display hardware has 3D acceleration.
 *)
  DDCAPS_3D                       = $00000001;
  {$EXTERNALSYM DDCAPS_3D}

(*
 * Indicates that DirectDraw will support only dest rectangles that are aligned
 * on DIRECTDRAWCAPS.dwAlignBoundaryDest boundaries of the surface, respectively.
 * READ ONLY.
 *)
  DDCAPS_ALIGNBOUNDARYDEST        = $00000002;
  {$EXTERNALSYM DDCAPS_ALIGNBOUNDARYDEST}

(*
 * Indicates that DirectDraw will support only source rectangles  whose sizes in
 * BYTEs are DIRECTDRAWCAPS.dwAlignSizeDest multiples, respectively.  READ ONLY.
 *)
  DDCAPS_ALIGNSIZEDEST            = $00000004;
  {$EXTERNALSYM DDCAPS_ALIGNSIZEDEST}
(*
 * Indicates that DirectDraw will support only source rectangles that are aligned
 * on DIRECTDRAWCAPS.dwAlignBoundarySrc boundaries of the surface, respectively.
 * READ ONLY.
 *)
  DDCAPS_ALIGNBOUNDARYSRC         = $00000008;
  {$EXTERNALSYM DDCAPS_ALIGNBOUNDARYSRC}

(*
 * Indicates that DirectDraw will support only source rectangles  whose sizes in
 * BYTEs are DIRECTDRAWCAPS.dwAlignSizeSrc multiples, respectively.  READ ONLY.
 *)
  DDCAPS_ALIGNSIZESRC             = $00000010;
  {$EXTERNALSYM DDCAPS_ALIGNSIZESRC}

(*
 * Indicates that DirectDraw will create video memory surfaces that have a stride
 * alignment equal to DIRECTDRAWCAPS.dwAlignStride.  READ ONLY.
 *)
  DDCAPS_ALIGNSTRIDE              = $00000020;
  {$EXTERNALSYM DDCAPS_ALIGNSTRIDE}

(*
 * Display hardware is capable of blt operations.
 *)
  DDCAPS_BLT                      = $00000040;
  {$EXTERNALSYM DDCAPS_BLT}

(*
 * Display hardware is capable of asynchronous blt operations.
 *)
  DDCAPS_BLTQUEUE                 = $00000080;
  {$EXTERNALSYM DDCAPS_BLTQUEUE}

(*
 * Display hardware is capable of color space conversions during the blt operation.
 *)
  DDCAPS_BLTFOURCC                = $00000100;
  {$EXTERNALSYM DDCAPS_BLTFOURCC}

(*
 * Display hardware is capable of stretching during blt operations.
 *)
  DDCAPS_BLTSTRETCH               = $00000200;
  {$EXTERNALSYM DDCAPS_BLTSTRETCH}

(*
 * Display hardware is shared with GDI.
 *)
  DDCAPS_GDI                      = $00000400;
  {$EXTERNALSYM DDCAPS_GDI}

(*
 * Display hardware can overlay.
 *)
  DDCAPS_OVERLAY                  = $00000800;
  {$EXTERNALSYM DDCAPS_OVERLAY}

(*
 * Set if display hardware supports overlays but can not clip them.
 *)
  DDCAPS_OVERLAYCANTCLIP          = $00001000;
  {$EXTERNALSYM DDCAPS_OVERLAYCANTCLIP}

(*
 * Indicates that overlay hardware is capable of color space conversions during
 * the overlay operation.
 *)
  DDCAPS_OVERLAYFOURCC            = $00002000;
  {$EXTERNALSYM DDCAPS_OVERLAYFOURCC}

(*
 * Indicates that stretching can be done by the overlay hardware.
 *)
  DDCAPS_OVERLAYSTRETCH           = $00004000;
  {$EXTERNALSYM DDCAPS_OVERLAYSTRETCH}

(*
 * Indicates that unique DirectDrawPalettes can be created for DirectDrawSurfaces
 * other than the primary surface.
 *)
  DDCAPS_PALETTE                  = $00008000;
  {$EXTERNALSYM DDCAPS_PALETTE}

(*
 * Indicates that palette changes can be syncd with the veritcal refresh.
 *)
  DDCAPS_PALETTEVSYNC             = $00010000;
  {$EXTERNALSYM DDCAPS_PALETTEVSYNC}

(*
 * Display hardware can return the current scan line.
 *)
  DDCAPS_READSCANLINE             = $00020000;
  {$EXTERNALSYM DDCAPS_READSCANLINE}

(*
 * This flag used to bo DDCAPS_STEREOVIEW, which is now obsolete
 *)
  DDCAPS_RESERVED1                = $00040000;
  {$EXTERNALSYM DDCAPS_RESERVED1}

(*
 * Display hardware is capable of generating a vertical blank interrupt.
 *)
  DDCAPS_VBI                      = $00080000;
  {$EXTERNALSYM DDCAPS_VBI}

(*
 * Supports the use of z buffers with blt operations.
 *)
  DDCAPS_ZBLTS                    = $00100000;
  {$EXTERNALSYM DDCAPS_ZBLTS}

(*
 * Supports Z Ordering of overlays.
 *)
  DDCAPS_ZOVERLAYS                = $00200000;
  {$EXTERNALSYM DDCAPS_ZOVERLAYS}

(*
 * Supports color key
 *)
  DDCAPS_COLORKEY                 = $00400000;
  {$EXTERNALSYM DDCAPS_COLORKEY}

(*
 * Supports alpha surfaces
 *)
  DDCAPS_ALPHA                    = $00800000;
  {$EXTERNALSYM DDCAPS_ALPHA}

(*
 * colorkey is hardware assisted(DDCAPS_COLORKEY will also be set)
 *)
  DDCAPS_COLORKEYHWASSIST         = $01000000;
  {$EXTERNALSYM DDCAPS_COLORKEYHWASSIST}

(*
 * no hardware support at all
 *)
  DDCAPS_NOHARDWARE               = $02000000;
  {$EXTERNALSYM DDCAPS_NOHARDWARE}

(*
 * Display hardware is capable of color fill with bltter
 *)
  DDCAPS_BLTCOLORFILL             = $04000000;
  {$EXTERNALSYM DDCAPS_BLTCOLORFILL}

(*
 * Display hardware is bank switched, and potentially very slow at
 * random access to VRAM.
 *)
  DDCAPS_BANKSWITCHED             = $08000000;
  {$EXTERNALSYM DDCAPS_BANKSWITCHED}

(*
 * Display hardware is capable of depth filling Z-buffers with bltter
 *)
  DDCAPS_BLTDEPTHFILL             = $10000000;
  {$EXTERNALSYM DDCAPS_BLTDEPTHFILL}

(*
 * Display hardware is capable of clipping while bltting.
 *)
  DDCAPS_CANCLIP                  = $20000000;
  {$EXTERNALSYM DDCAPS_CANCLIP}

(*
 * Display hardware is capable of clipping while stretch bltting.
 *)
  DDCAPS_CANCLIPSTRETCHED         = $40000000;
  {$EXTERNALSYM DDCAPS_CANCLIPSTRETCHED}

(*
 * Display hardware is capable of bltting to or from system memory
 *)
  DDCAPS_CANBLTSYSMEM             = $80000000;
  {$EXTERNALSYM DDCAPS_CANBLTSYSMEM}


 (****************************************************************************
 *
 * MORE DIRECTDRAW DRIVER CAPABILITY FLAGS (dwCaps2)
 *
 ****************************************************************************)

(*
 * Display hardware is certified
 *)
  DDCAPS2_CERTIFIED               = $00000001;
  {$EXTERNALSYM DDCAPS2_CERTIFIED}

(*
 * Driver cannot interleave 2D operations (lock and blt) to surfaces with
 * Direct3D rendering operations between calls to BeginScene() and EndScene()
 *)
  DDCAPS2_NO2DDURING3DSCENE       = $00000002;
  {$EXTERNALSYM DDCAPS2_NO2DDURING3DSCENE}

(*
 * Display hardware contains a video port
 *)
  DDCAPS2_VIDEOPORT	          = $00000004;
  {$EXTERNALSYM DDCAPS2_VIDEOPORT}

(*
 * The overlay can be automatically flipped according to the video port
 * VSYNCs, providing automatic doubled buffered display of video port
 * data using an overlay
 *)
  DDCAPS2_AUTOFLIPOVERLAY	  = $00000008;
  {$EXTERNALSYM DDCAPS2_AUTOFLIPOVERLAY}

(*
 * Overlay can display each field of interlaced data individually while
 * it is interleaved in memory without causing jittery artifacts.
 *)
  DDCAPS2_CANBOBINTERLEAVED	  = $00000010;
  {$EXTERNALSYM DDCAPS2_CANBOBINTERLEAVED}

(*
 * Overlay can display each field of interlaced data individually while
 * it is not interleaved in memory without causing jittery artifacts.
 *)
  DDCAPS2_CANBOBNONINTERLEAVED	  = $00000020;
  {$EXTERNALSYM DDCAPS2_CANBOBNONINTERLEAVED}

(*
 * The overlay surface contains color controls (brightness, sharpness, etc.)
 *)
  DDCAPS2_COLORCONTROLOVERLAY	  = $00000040;
  {$EXTERNALSYM DDCAPS2_COLORCONTROLOVERLAY}

(*
 * The primary surface contains color controls (gamma, etc.)
 *)
  DDCAPS2_COLORCONTROLPRIMARY     = $00000080;
  {$EXTERNALSYM DDCAPS2_COLORCONTROLPRIMARY}

(*
 * RGBZ -> RGB supported for 16:16 RGB:Z
 *)
  DDCAPS2_CANDROPZ16BIT		  = $00000100;
  {$EXTERNALSYM DDCAPS2_CANDROPZ16BIT}

(*
 * Driver supports non-local video memory.
 *)
  DDCAPS2_NONLOCALVIDMEM          = $00000200;
  {$EXTERNALSYM DDCAPS2_NONLOCALVIDMEM}

(*
 * Dirver supports non-local video memory but has different capabilities for
 * non-local video memory surfaces. If this bit is set then so must
 * DDCAPS2_NONLOCALVIDMEM.
 *)
  DDCAPS2_NONLOCALVIDMEMCAPS      = $00000400;
  {$EXTERNALSYM DDCAPS2_NONLOCALVIDMEMCAPS}

(*
 * Driver neither requires nor prefers surfaces to be pagelocked when performing
 * blts involving system memory surfaces
 *)
  DDCAPS2_NOPAGELOCKREQUIRED      = $00000800;
  {$EXTERNALSYM DDCAPS2_NOPAGELOCKREQUIRED}

(*
 * Driver can create surfaces which are wider than the primary surface
 *)
  DDCAPS2_WIDESURFACES            = $00001000;
  {$EXTERNALSYM DDCAPS2_WIDESURFACES}

(*
 * Driver supports bob without using a video port by handling the
 * DDFLIP_ODD and DDFLIP_EVEN flags specified in Flip.
 *)
  DDCAPS2_CANFLIPODDEVEN          = $00002000;
  {$EXTERNALSYM DDCAPS2_CANFLIPODDEVEN}

(*
 * Driver supports bob using hardware
 *)
  DDCAPS2_CANBOBHARDWARE          = $00004000;
  {$EXTERNALSYM DDCAPS2_CANBOBHARDWARE}

(*
 * Driver supports bltting any FOURCC surface to another surface of the same FOURCC
 *)
  DDCAPS2_COPYFOURCC              = $00008000;
  {$EXTERNALSYM DDCAPS2_COPYFOURCC}


(*
 * Driver supports loadable gamma ramps for the primary surface
 *)
  DDCAPS2_PRIMARYGAMMA            = $00020000;
  {$EXTERNALSYM DDCAPS2_PRIMARYGAMMA}

(*
 * Driver can render in windowed mode.
 *)
  DDCAPS2_CANRENDERWINDOWED       = $00080000;
  {$EXTERNALSYM DDCAPS2_CANRENDERWINDOWED}

(*
 * A calibrator is available to adjust the gamma ramp according to the
 * physical display properties so that the result will be identical on
 * all calibrated systems.
 *)
  DDCAPS2_CANCALIBRATEGAMMA       = $00100000;
  {$EXTERNALSYM DDCAPS2_CANCALIBRATEGAMMA}

(*
 * Indicates that the driver will respond to DDFLIP_INTERVALn flags
 *)
  DDCAPS2_FLIPINTERVAL            = $00200000;
  {$EXTERNALSYM DDCAPS2_FLIPINTERVAL}

(*
 * Indicates that the driver will respond to DDFLIP_NOVSYNC
 *)
   DDCAPS2_FLIPNOVSYNC            = $00400000;
   {$EXTERNALSYM DDCAPS2_FLIPNOVSYNC}

(*
 * Driver supports management of video memory, if this flag is ON,
 * driver manages the texture if requested with DDSCAPS2_TEXTUREMANAGE on
 * DirectX manages the texture if this flag is OFF and surface has DDSCAPS2_TEXTUREMANAGE on
 *)
  DDCAPS2_CANMANAGETEXTURE        = $00800000;
  {$EXTERNALSYM DDCAPS2_CANMANAGETEXTURE}

(*
 * The Direct3D texture manager uses this cap to decide whether to put managed
 * surfaces in non-local video memory. If the cap is set, the texture manager will
 * put managed surfaces in non-local vidmem. Drivers that cannot texture from
 * local vidmem SHOULD NOT set this cap.
 *)
  DDCAPS2_TEXMANINNONLOCALVIDMEM  = $01000000;
  {$EXTERNALSYM DDCAPS2_TEXMANINNONLOCALVIDMEM}

(*
 * Indicates that the driver supports DX7 type of stereo in at least one mode (which may
 * not necessarily be the current mode). Applications should use IDirectDraw7 (or higher)
 * ::EnumDisplayModes and check the DDSURFACEDESC.ddsCaps.dwCaps2 field for the presence of
 * DDSCAPS2_STEREOSURFACELEFT to check if a particular mode supports stereo. The application
 * can also use IDirectDraw7(or higher)::GetDisplayMode to check the current mode.
 *)
  DDCAPS2_STEREO                  = $02000000;
  {$EXTERNALSYM DDCAPS2_STEREO}

(*
 * This caps bit is intended for internal DirectDraw use.
 * -It is only valid if DDCAPS2_NONLOCALVIDMEMCAPS is set.
 * -If this bit is set, then DDCAPS_CANBLTSYSMEM MUST be set by the driver (and
 *  all the assoicated system memory blt caps must be correct).
 * -It implies that the system->video blt caps in DDCAPS also apply to system to
 *  nonlocal blts. I.e. the dwSVBCaps, dwSVBCKeyCaps, dwSVBFXCaps and dwSVBRops
 *  members of DDCAPS (DDCORECAPS) are filled in correctly.
 * -Any blt from system to nonlocal memory that matches these caps bits will
 *  be passed to the driver.
 *
 * NOTE: This is intended to enable the driver itself to do efficient reordering
 * of textures. This is NOT meant to imply that hardware can write into AGP memory.
 * This operation is not currently supported.
 *)
  DDCAPS2_SYSTONONLOCAL_AS_SYSTOLOCAL   = $04000000;
  {$EXTERNALSYM DDCAPS2_SYSTONONLOCAL_AS_SYSTOLOCAL}

(*
 * was DDCAPS2_PUREHAL
 *)
  DDCAPS2_RESERVED1                     = $08000000;
  {$EXTERNALSYM DDCAPS2_RESERVED1}

(*
 * Driver supports management of video memory, if this flag is ON,
 * driver manages the resource if requested with DDSCAPS2_TEXTUREMANAGE on
 * DirectX manages the resource if this flag is OFF and surface has DDSCAPS2_TEXTUREMANAGE on
 *)
  DDCAPS2_CANMANAGERESOURCE             = $10000000;
  {$EXTERNALSYM DDCAPS2_CANMANAGERESOURCE}

(*
 * Driver supports dynamic textures. This will allow the application to set
 * D3DUSAGE_DYNAMIC (DDSCAPS2_HINTDYNAMIC for drivers) at texture create time.
 * Video memory dynamic textures WILL be lockable by applications. It is
 * expected that these locks will be very efficient (which implies that the
 * driver should always maintain a linear copy, a pointer to which can be
 * quickly handed out to the application).
 *)
  DDCAPS2_DYNAMICTEXTURES               = $20000000;
  {$EXTERNALSYM DDCAPS2_DYNAMICTEXTURES}

(*
 * Driver supports auto-generation of mipmaps.
 *)
  DDCAPS2_CANAUTOGENMIPMAP              = $40000000;
  {$EXTERNALSYM DDCAPS2_CANAUTOGENMIPMAP}


(****************************************************************************
 *
 * DIRECTDRAW FX ALPHA CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Supports alpha blending around the edge of a source color keyed surface.
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHAEDGEBLEND         = $00000001;
  {$EXTERNALSYM DDFXALPHACAPS_BLTALPHAEDGEBLEND}

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha
 * information in the pixel format can be 1,2,4, or 8.  The alpha value becomes
 * more opaque as the alpha value increases.  (0 is transparent.)
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHAPIXELS            = $00000002;
  {$EXTERNALSYM DDFXALPHACAPS_BLTALPHAPIXELS}

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha
 * information in the pixel format can be 1,2,4, or 8.  The alpha value
 * becomes more transparent as the alpha value increases.  (0 is opaque.)
 * This flag can only be set if DDCAPS_ALPHA is set.
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHAPIXELSNEG         = $00000004;
  {$EXTERNALSYM DDFXALPHACAPS_BLTALPHAPIXELSNEG}

(*
 * Supports alpha only surfaces.  The bit depth of an alpha only surface can be
 * 1,2,4, or 8.  The alpha value becomes more opaque as the alpha value increases.
 * (0 is transparent.)
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHASURFACES          = $00000008;
  {$EXTERNALSYM DDFXALPHACAPS_BLTALPHASURFACES}

(*
 * The depth of the alpha channel data can range can be 1,2,4, or 8.
 * The NEG suffix indicates that this alpha channel becomes more transparent
 * as the alpha value increases. (0 is opaque.)  This flag can only be set if
 * DDCAPS_ALPHA is set.
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHASURFACESNEG       = $00000010;
  {$EXTERNALSYM DDFXALPHACAPS_BLTALPHASURFACESNEG}

(*
 * Supports alpha blending around the edge of a source color keyed surface.
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHAEDGEBLEND     = $00000020;
  {$EXTERNALSYM DDFXALPHACAPS_OVERLAYALPHAEDGEBLEND}

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha
 * information in the pixel format can be 1,2,4, or 8.  The alpha value becomes
 * more opaque as the alpha value increases.  (0 is transparent.)
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHAPIXELS        = $00000040;
  {$EXTERNALSYM DDFXALPHACAPS_OVERLAYALPHAPIXELS}

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha
 * information in the pixel format can be 1,2,4, or 8.  The alpha value
 * becomes more transparent as the alpha value increases.  (0 is opaque.)
 * This flag can only be set if DDCAPS_ALPHA is set.
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHAPIXELSNEG     = $00000080;
  {$EXTERNALSYM DDFXALPHACAPS_OVERLAYALPHAPIXELSNEG}

(*
 * Supports alpha only surfaces.  The bit depth of an alpha only surface can be
 * 1,2,4, or 8.  The alpha value becomes more opaque as the alpha value increases.
 * (0 is transparent.)
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHASURFACES      = $00000100;
  {$EXTERNALSYM DDFXALPHACAPS_OVERLAYALPHASURFACES}

(*
 * The depth of the alpha channel data can range can be 1,2,4, or 8.
 * The NEG suffix indicates that this alpha channel becomes more transparent
 * as the alpha value increases. (0 is opaque.)  This flag can only be set if
 * DDCAPS_ALPHA is set.
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHASURFACESNEG   = $00000200;
  {$EXTERNALSYM DDFXALPHACAPS_OVERLAYALPHASURFACESNEG}

(****************************************************************************
 *
 * DIRECTDRAW FX CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Uses arithmetic operations to stretch and shrink surfaces during blt
 * rather than pixel doubling techniques.  Along the Y axis.
 *)
  DDFXCAPS_BLTARITHSTRETCHY       = $00000020;
  {$EXTERNALSYM DDFXCAPS_BLTARITHSTRETCHY}

(*
 * Uses arithmetic operations to stretch during blt
 * rather than pixel doubling techniques.  Along the Y axis. Only
 * works for x1, x2, etc.
 *)
  DDFXCAPS_BLTARITHSTRETCHYN      = $00000010;
  {$EXTERNALSYM DDFXCAPS_BLTARITHSTRETCHYN}

(*
 * Supports mirroring left to right in blt.
 *)
  DDFXCAPS_BLTMIRRORLEFTRIGHT     = $00000040;
  {$EXTERNALSYM DDFXCAPS_BLTMIRRORLEFTRIGHT}

(*
 * Supports mirroring top to bottom in blt.
 *)
  DDFXCAPS_BLTMIRRORUPDOWN        = $00000080;
  {$EXTERNALSYM DDFXCAPS_BLTMIRRORUPDOWN}

(*
 * Supports arbitrary rotation for blts.
 *)
  DDFXCAPS_BLTROTATION            = $00000100;
  {$EXTERNALSYM DDFXCAPS_BLTROTATION}

(*
 * Supports 90 degree rotations for blts.
 *)
   DDFXCAPS_BLTROTATION90          = $00000200;
   {$EXTERNALSYM DDFXCAPS_BLTROTATION90}

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKX             = $00000400;
  {$EXTERNALSYM DDFXCAPS_BLTSHRINKX}

(*
 * DirectDraw supports integer shrinking (1x,2x,) of a surface
 * along the x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKXN            = $00000800;
  {$EXTERNALSYM DDFXCAPS_BLTSHRINKXN}

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * y axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKY             = $00001000;
  {$EXTERNALSYM DDFXCAPS_BLTSHRINKY}

(*
 * DirectDraw supports integer shrinking (1x,2x,) of a surface
 * along the y axis (vertical direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKYN            = $00002000;
  {$EXTERNALSYM DDFXCAPS_BLTSHRINKYN}

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSTRETCHX            = $00004000;
  {$EXTERNALSYM DDFXCAPS_BLTSTRETCHX}

(*
 * DirectDraw supports integer stretching (1x,2x,) of a surface
 * along the x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSTRETCHXN           = $00008000;
  {$EXTERNALSYM DDFXCAPS_BLTSTRETCHXN}

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * y axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSTRETCHY            = $00010000;
  {$EXTERNALSYM DDFXCAPS_BLTSTRETCHY}

(*
 * DirectDraw supports integer stretching (1x,2x,) of a surface
 * along the y axis (vertical direction) for blts.
 *)
  DDFXCAPS_BLTSTRETCHYN           = $00020000;
  {$EXTERNALSYM DDFXCAPS_BLTSTRETCHYN}

(*
 * Uses arithmetic operations to stretch and shrink surfaces during
 * overlay rather than pixel doubling techniques.  Along the Y axis
 * for overlays.
 *)
  DDFXCAPS_OVERLAYARITHSTRETCHY   = $00040000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYARITHSTRETCHY}

(*
 * Uses arithmetic operations to stretch surfaces during
 * overlay rather than pixel doubling techniques.  Along the Y axis
 * for overlays. Only works for x1, x2, etc.
 *)
  DDFXCAPS_OVERLAYARITHSTRETCHYN  = $00000008;
  {$EXTERNALSYM DDFXCAPS_OVERLAYARITHSTRETCHYN}

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSHRINKX         = $00080000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYSHRINKX}

(*
 * DirectDraw supports integer shrinking (1x,2x,) of a surface
 * along the x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSHRINKXN        = $00100000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYSHRINKXN}

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * y axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSHRINKY         = $00200000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYSHRINKY}

(*
 * DirectDraw supports integer shrinking (1x,2x,) of a surface
 * along the y axis (vertical direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSHRINKYN        = $00400000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYSHRINKYN}

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSTRETCHX        = $00800000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYSTRETCHX}

(*
 * DirectDraw supports integer stretching (1x,2x,) of a surface
 * along the x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSTRETCHXN       = $01000000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYSTRETCHXN}

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * y axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSTRETCHY        = $02000000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYSTRETCHY}

(*
 * DirectDraw supports integer stretching (1x,2x,) of a surface
 * along the y axis (vertical direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSTRETCHYN       = $04000000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYSTRETCHYN}

(*
 * DirectDraw supports mirroring of overlays across the vertical axis
 *)
  DDFXCAPS_OVERLAYMIRRORLEFTRIGHT = $08000000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYMIRRORLEFTRIGHT}

(*
 * DirectDraw supports mirroring of overlays across the horizontal axis
 *)
  DDFXCAPS_OVERLAYMIRRORUPDOWN    = $10000000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYMIRRORUPDOWN}

(*
 * DirectDraw supports deinterlacing of overlay surfaces
 *)
  DDFXCAPS_OVERLAYDEINTERLACE	  = $20000000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYDEINTERLACE}


(*
 * Driver can do alpha blending for blits.
 *)
  DDFXCAPS_BLTALPHA 		  = $00000001;
  {$EXTERNALSYM DDFXCAPS_BLTALPHA}

(*
 * Driver can do geometric transformations (or warps) for blits.
 *)
  DDFXCAPS_BLTTRANSFORM		  = $00000002;
  {$EXTERNALSYM DDFXCAPS_BLTTRANSFORM}

(*
 * Driver can do surface-reconstruction filtering for warped blits.
 *)
  DDFXCAPS_BLTFILTER 	          = DDFXCAPS_BLTARITHSTRETCHY;
  {$EXTERNALSYM DDFXCAPS_BLTFILTER}

(*
 * Driver can do alpha blending for overlays.
 *)
  DDFXCAPS_OVERLAYALPHA 	  = $00000004;
  {$EXTERNALSYM DDFXCAPS_OVERLAYALPHA}

(*
 * Driver can do geometric transformations (or warps) for overlays.
 *)
  DDFXCAPS_OVERLAYTRANSFORM 	  = $20000000;
  {$EXTERNALSYM DDFXCAPS_OVERLAYTRANSFORM}

(*
 * Driver can do surface-reconstruction filtering for warped overlays.
 *)
  DDFXCAPS_OVERLAYFILTER 	  = DDFXCAPS_OVERLAYARITHSTRETCHY;
  {$EXTERNALSYM DDFXCAPS_OVERLAYFILTER}

(****************************************************************************
 *
 * DIRECTDRAW STEREO VIEW CAPABILITIES
 *
 ****************************************************************************)

(*
 * This flag used to be DDSVCAPS_ENIGMA, which is now obsolete
 *)
  DDSVCAPS_RESERVED1              = $00000001;
  {$EXTERNALSYM DDSVCAPS_RESERVED1}

(*
 * This flag used to be DDSVCAPS_FLICKER, which is now obsolete
 *)
  DDSVCAPS_RESERVED2              = $00000002;
  {$EXTERNALSYM DDSVCAPS_RESERVED2}

(*
 * This flag used to be DDSVCAPS_REDBLUE, which is now obsolete
 *)
  DDSVCAPS_RESERVED3              = $00000004;
  {$EXTERNALSYM DDSVCAPS_RESERVED3}

(*
 * This flag used to be DDSVCAPS_SPLIT, which is now obsolete
 *)
  DDSVCAPS_RESERVED4              = $00000008;
  {$EXTERNALSYM DDSVCAPS_RESERVED4}

(*
 * The stereo view is accomplished with switching technology
 *)
  DDSVCAPS_STEREOSEQUENTIAL       = $00000010;
  {$EXTERNALSYM DDSVCAPS_STEREOSEQUENTIAL}

(****************************************************************************
 *
 * DIRECTDRAWPALETTE CAPABILITIES
 *
 ****************************************************************************)

(*
 * Index is 4 bits.  There are sixteen color entries in the palette table.
 *)
  DDPCAPS_4BIT                    = $00000001;
  {$EXTERNALSYM DDPCAPS_4BIT}

(*
 * Index is onto a 8 bit color index.  This field is only valid with the
 * DDPCAPS_1BIT, DDPCAPS_2BIT or DDPCAPS_4BIT capability and the target
 * surface is in 8bpp. Each color entry is one byte long and is an index
 * into destination surface's 8bpp palette.
 *)
  DDPCAPS_8BITENTRIES             = $00000002;
  {$EXTERNALSYM DDPCAPS_8BITENTRIES}

(*
 * Index is 8 bits.  There are 256 color entries in the palette table.
 *)
  DDPCAPS_8BIT                    = $00000004;
  {$EXTERNALSYM DDPCAPS_8BIT}

(*
 * Indicates that this DIRECTDRAWPALETTE should use the palette color array
 * passed into the lpDDColorArray parameter to initialize the DIRECTDRAWPALETTE
 * object.
 * This flag is obsolete. DirectDraw always initializes the color array from
 * the lpDDColorArray parameter. The definition remains for source-level
 * compatibility.
 *)
  DDPCAPS_INITIALIZE              = $00000008;
  {$EXTERNALSYM DDPCAPS_INITIALIZE}

(*
 * This palette is the one attached to the primary surface.  Changing this
 * table has immediate effect on the display unless DDPSETPAL_VSYNC is specified
 * and supported.
 *)
  DDPCAPS_PRIMARYSURFACE          = $00000010;
  {$EXTERNALSYM DDPCAPS_PRIMARYSURFACE}

(*
 * This palette is the one attached to the primary surface left.  Changing
 * this table has immediate effect on the display for the left eye unless
 * DDPSETPAL_VSYNC is specified and supported.
 *)
  DDPCAPS_PRIMARYSURFACELEFT      = $00000020;
  {$EXTERNALSYM DDPCAPS_PRIMARYSURFACELEFT}

(*
 * This palette can have all 256 entries defined
 *)
  DDPCAPS_ALLOW256                = $00000040;
  {$EXTERNALSYM DDPCAPS_ALLOW256}

(*
 * This palette can have modifications to it synced with the monitors
 * refresh rate.
 *)
  DDPCAPS_VSYNC                   = $00000080;
  {$EXTERNALSYM DDPCAPS_VSYNC}

(*
 * Index is 1 bit.  There are two color entries in the palette table.
 *)
  DDPCAPS_1BIT                    = $00000100;
  {$EXTERNALSYM DDPCAPS_1BIT}

(*
 * Index is 2 bit.  There are four color entries in the palette table.
 *)
  DDPCAPS_2BIT                    = $00000200;
  {$EXTERNALSYM DDPCAPS_2BIT}

(*
 * The peFlags member of PALETTEENTRY denotes an 8 bit alpha value
 *)
  DDPCAPS_ALPHA		          = $00000400;
  {$EXTERNALSYM DDPCAPS_ALPHA}


(****************************************************************************
 *
 * DIRECTDRAWPALETTE SETENTRY CONSTANTS
 *
 ****************************************************************************)


(****************************************************************************
 *
 * DIRECTDRAWPALETTE GETENTRY CONSTANTS
 *
 ****************************************************************************)

(* 0 is the only legal value *)

(****************************************************************************
 *
 * DIRECTDRAWSURFACE SETPRIVATEDATA CONSTANTS
 *
 ****************************************************************************)

(*
 * The passed pointer is an IUnknown ptr. The cbData argument to SetPrivateData
 * must be set to SizeOf(IUnknown^). DirectDraw will call AddRef through this
 * pointer and Release when the private data is destroyed. This includes when
 * the surface or palette is destroyed before such priovate data is destroyed.
 *)
  DDSPD_IUNKNOWNPOINTER           = $00000001;
  {$EXTERNALSYM DDSPD_IUNKNOWNPOINTER}

(*
 * Private data is only valid for the current state of the object,
 * as determined by the uniqueness value.
 *)
  DDSPD_VOLATILE                  = $00000002;
  {$EXTERNALSYM DDSPD_VOLATILE}


(****************************************************************************
 *
 * DIRECTDRAWSURFACE SETPALETTE CONSTANTS
 *
 ****************************************************************************)


(****************************************************************************
 *
 * DIRECTDRAW BITDEPTH CONSTANTS
 *
 * NOTE:  These are only used to indicate supported bit depths.   These
 * are flags only, they are not to be used as an actual bit depth.   The
 * absolute numbers 1, 2, 4, 8, 16, 24 and 32 are used to indicate actual
 * bit depths in a surface or for changing the display mode.
 *
 ****************************************************************************)

(*
 * 1 bit per pixel.
 *)
  DDBD_1                  = $00004000;
  {$EXTERNALSYM DDBD_1}

(*
 * 2 bits per pixel.
 *)
  DDBD_2                  = $00002000;
  {$EXTERNALSYM DDBD_2}

(*
 * 4 bits per pixel.
 *)
  DDBD_4                  = $00001000;
  {$EXTERNALSYM DDBD_4}

(*
 * 8 bits per pixel.
 *)
  DDBD_8                  = $00000800;
  {$EXTERNALSYM DDBD_8}

(*
 * 16 bits per pixel.
 *)
  DDBD_16                 = $00000400;
  {$EXTERNALSYM DDBD_16}

(*
 * 24 bits per pixel.
 *)
  DDBD_24                 = $00000200;
  {$EXTERNALSYM DDBD_24}

(*
 * 32 bits per pixel.
 *)
  DDBD_32                 = $00000100;
  {$EXTERNALSYM DDBD_32}

(****************************************************************************
 *
 * DIRECTDRAWSURFACE SET/GET COLOR KEY FLAGS
 *
 ****************************************************************************)

(*
 * Set if the structure contains a color space.  Not set if the structure
 * contains a single color key.
 *)
  DDCKEY_COLORSPACE       = $00000001;
  {$EXTERNALSYM DDCKEY_COLORSPACE}

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a destination color key for blt operations.
 *)
  DDCKEY_DESTBLT          = $00000002;
  {$EXTERNALSYM DDCKEY_DESTBLT}

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a destination color key for overlay operations.
 *)
  DDCKEY_DESTOVERLAY      = $00000004;
  {$EXTERNALSYM DDCKEY_DESTOVERLAY}

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a source color key for blt operations.
 *)
  DDCKEY_SRCBLT           = $00000008;
  {$EXTERNALSYM DDCKEY_SRCBLT}

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a source color key for overlay operations.
 *)
  DDCKEY_SRCOVERLAY       = $00000010;
  {$EXTERNALSYM DDCKEY_SRCOVERLAY}


(****************************************************************************
 *
 * DIRECTDRAW COLOR KEY CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Supports transparent blting using a color key to identify the replaceable
 * bits of the destination surface for RGB colors.
 *)
  DDCKEYCAPS_DESTBLT                      = $00000001;
  {$EXTERNALSYM DDCKEYCAPS_DESTBLT}

(*
 * Supports transparent blting using a color space to identify the replaceable
 * bits of the destination surface for RGB colors.
 *)
  DDCKEYCAPS_DESTBLTCLRSPACE              = $00000002;
  {$EXTERNALSYM DDCKEYCAPS_DESTBLTCLRSPACE}

(*
 * Supports transparent blting using a color space to identify the replaceable
 * bits of the destination surface for YUV colors.
 *)
  DDCKEYCAPS_DESTBLTCLRSPACEYUV           = $00000004;
  {$EXTERNALSYM DDCKEYCAPS_DESTBLTCLRSPACEYUV}

(*
 * Supports transparent blting using a color key to identify the replaceable
 * bits of the destination surface for YUV colors.
 *)
  DDCKEYCAPS_DESTBLTYUV                   = $00000008;
  {$EXTERNALSYM DDCKEYCAPS_DESTBLTYUV}

(*
 * Supports overlaying using colorkeying of the replaceable bits of the surface
 * being overlayed for RGB colors.
 *)
  DDCKEYCAPS_DESTOVERLAY                  = $00000010;
  {$EXTERNALSYM DDCKEYCAPS_DESTOVERLAY}

(*
 * Supports a color space as the color key for the destination for RGB colors.
 *)
  DDCKEYCAPS_DESTOVERLAYCLRSPACE          = $00000020;
  {$EXTERNALSYM DDCKEYCAPS_DESTOVERLAYCLRSPACE}

(*
 * Supports a color space as the color key for the destination for YUV colors.
 *)
  DDCKEYCAPS_DESTOVERLAYCLRSPACEYUV       = $00000040;
  {$EXTERNALSYM DDCKEYCAPS_DESTOVERLAYCLRSPACEYUV}

(*
 * Supports only one active destination color key value for visible overlay
 * surfaces.
 *)
  DDCKEYCAPS_DESTOVERLAYONEACTIVE         = $00000080;
  {$EXTERNALSYM DDCKEYCAPS_DESTOVERLAYONEACTIVE}

(*
 * Supports overlaying using colorkeying of the replaceable bits of the
 * surface being overlayed for YUV colors.
 *)
  DDCKEYCAPS_DESTOVERLAYYUV               = $00000100;
  {$EXTERNALSYM DDCKEYCAPS_DESTOVERLAYYUV}

(*
 * Supports transparent blting using the color key for the source with
 * this surface for RGB colors.
 *)
  DDCKEYCAPS_SRCBLT                       = $00000200;
  {$EXTERNALSYM DDCKEYCAPS_SRCBLT}

(*
 * Supports transparent blting using a color space for the source with
 * this surface for RGB colors.
 *)
  DDCKEYCAPS_SRCBLTCLRSPACE               = $00000400;
  {$EXTERNALSYM DDCKEYCAPS_SRCBLTCLRSPACE}

(*
 * Supports transparent blting using a color space for the source with
 * this surface for YUV colors.
 *)
  DDCKEYCAPS_SRCBLTCLRSPACEYUV            = $00000800;
  {$EXTERNALSYM DDCKEYCAPS_SRCBLTCLRSPACEYUV}

(*
 * Supports transparent blting using the color key for the source with
 * this surface for YUV colors.
 *)
  DDCKEYCAPS_SRCBLTYUV                    = $00001000;
  {$EXTERNALSYM DDCKEYCAPS_SRCBLTYUV}

(*
 * Supports overlays using the color key for the source with this
 * overlay surface for RGB colors.
 *)
  DDCKEYCAPS_SRCOVERLAY                   = $00002000;
  {$EXTERNALSYM DDCKEYCAPS_SRCOVERLAY}

(*
 * Supports overlays using a color space as the source color key for
 * the overlay surface for RGB colors.
 *)
  DDCKEYCAPS_SRCOVERLAYCLRSPACE           = $00004000;
  {$EXTERNALSYM DDCKEYCAPS_SRCOVERLAYCLRSPACE}

(*
 * Supports overlays using a color space as the source color key for
 * the overlay surface for YUV colors.
 *)
  DDCKEYCAPS_SRCOVERLAYCLRSPACEYUV        = $00008000;
  {$EXTERNALSYM DDCKEYCAPS_SRCOVERLAYCLRSPACEYUV}

(*
 * Supports only one active source color key value for visible
 * overlay surfaces.
 *)
  DDCKEYCAPS_SRCOVERLAYONEACTIVE          = $00010000;
  {$EXTERNALSYM DDCKEYCAPS_SRCOVERLAYONEACTIVE}

(*
 * Supports overlays using the color key for the source with this
 * overlay surface for YUV colors.
 *)
  DDCKEYCAPS_SRCOVERLAYYUV                = $00020000;
  {$EXTERNALSYM DDCKEYCAPS_SRCOVERLAYYUV}

(*
 * there are no bandwidth trade-offs for using colorkey with an overlay
 *)
  DDCKEYCAPS_NOCOSTOVERLAY                = $00040000;
  {$EXTERNALSYM DDCKEYCAPS_NOCOSTOVERLAY}


(****************************************************************************
 *
 * DIRECTDRAW PIXELFORMAT FLAGS
 *
 ****************************************************************************)

(*
 * The surface has alpha channel information in the pixel format.
 *)
  DDPF_ALPHAPIXELS                        = $00000001;
  {$EXTERNALSYM DDPF_ALPHAPIXELS}

(*
 * The pixel format contains alpha only information
 *)
  DDPF_ALPHA                              = $00000002;
  {$EXTERNALSYM DDPF_ALPHA}

(*
 * The FourCC code is valid.
 *)
  DDPF_FOURCC                             = $00000004;
  {$EXTERNALSYM DDPF_FOURCC}

(*
 * The surface is 4-bit color indexed.
 *)
  DDPF_PALETTEINDEXED4                    = $00000008;
  {$EXTERNALSYM DDPF_PALETTEINDEXED4}

(*
 * The surface is indexed into a palette which stores indices
 * into the destination surface's 8-bit palette.
 *)
  DDPF_PALETTEINDEXEDTO8                  = $00000010;
  {$EXTERNALSYM DDPF_PALETTEINDEXEDTO8}

(*
 * The surface is 8-bit color indexed.
 *)
  DDPF_PALETTEINDEXED8                    = $00000020;
  {$EXTERNALSYM DDPF_PALETTEINDEXED8}

(*
 * The RGB data in the pixel format structure is valid.
 *)
  DDPF_RGB                                = $00000040;
  {$EXTERNALSYM DDPF_RGB}

(*
 * The surface will accept pixel data in the format specified
 * and compress it during the write.
 *)
  DDPF_COMPRESSED                         = $00000080;
  {$EXTERNALSYM DDPF_COMPRESSED}

(*
 * The surface will accept RGB data and translate it during
 * the write to YUV data.  The format of the data to be written
 * will be contained in the pixel format structure.  The DDPF_RGB
 * flag will be set.
 *)
  DDPF_RGBTOYUV                           = $00000100;
  {$EXTERNALSYM DDPF_RGBTOYUV}

(*
 * pixel format is YUV - YUV data in pixel format struct is valid
 *)
  DDPF_YUV                                = $00000200;
  {$EXTERNALSYM DDPF_YUV}

(*
 * pixel format is a z buffer only surface
 *)
  DDPF_ZBUFFER                            = $00000400;
  {$EXTERNALSYM DDPF_ZBUFFER}

(*
 * The surface is 1-bit color indexed.
 *)
  DDPF_PALETTEINDEXED1                    = $00000800;
  {$EXTERNALSYM DDPF_PALETTEINDEXED1}

(*
 * The surface is 2-bit color indexed.
 *)
  DDPF_PALETTEINDEXED2                    = $00001000;
  {$EXTERNALSYM DDPF_PALETTEINDEXED2}

(*
 * The surface contains Z information in the pixels
 *)
  DDPF_ZPIXELS				  = $00002000;
  {$EXTERNALSYM DDPF_ZPIXELS}

(*
 * The surface contains stencil information along with Z
 *)
  DDPF_STENCILBUFFER			  = $00004000;
  {$EXTERNALSYM DDPF_STENCILBUFFER}

(*
 * Premultiplied alpha format -- the color components have been
 * premultiplied by the alpha component.
 *)
  DDPF_ALPHAPREMULT 			  = $00008000;
  {$EXTERNALSYM DDPF_ALPHAPREMULT}


(*
 * Luminance data in the pixel format is valid.
 * Use this flag for luminance-only or luminance+alpha surfaces,
 * the bit depth is then ddpf.dwLuminanceBitCount.
 *)
  DDPF_LUMINANCE                          = $00020000;
  {$EXTERNALSYM DDPF_LUMINANCE}

(*
 * Luminance data in the pixel format is valid.
 * Use this flag when hanging luminance off bumpmap surfaces,
 * the bit mask for the luminance portion of the pixel is then
 * ddpf.dwBumpLuminanceBitMask
 *)
  DDPF_BUMPLUMINANCE                      = $00040000;
  {$EXTERNALSYM DDPF_BUMPLUMINANCE}

(*
 * Bump map dUdV data in the pixel format is valid.
 *)
  DDPF_BUMPDUDV                           = $00080000;
  {$EXTERNALSYM DDPF_BUMPDUDV}


(*===========================================================================
 *
 *
 * DIRECTDRAW CALLBACK FLAGS
 *
 *
 *==========================================================================*)

(****************************************************************************
 *
 * DIRECTDRAW ENUMSURFACES FLAGS
 *
 ****************************************************************************)

(*
 * Enumerate all of the surfaces that meet the search criterion.
 *)
  DDENUMSURFACES_ALL                      = $00000001;
  {$EXTERNALSYM DDENUMSURFACES_ALL}
  {$EXTERNALSYM DDENUMSURFACES_ALL}

(*
 * A search hit is a surface that matches the surface description.
 *)
  DDENUMSURFACES_MATCH                    = $00000002;
  {$EXTERNALSYM DDENUMSURFACES_MATCH}

(*
 * A search hit is a surface that does not match the surface description.
 *)
  DDENUMSURFACES_NOMATCH                  = $00000004;
  {$EXTERNALSYM DDENUMSURFACES_NOMATCH}

(*
 * Enumerate the first surface that can be created which meets the search criterion.
 *)
  DDENUMSURFACES_CANBECREATED             = $00000008;
  {$EXTERNALSYM DDENUMSURFACES_CANBECREATED}

(*
 * Enumerate the surfaces that already exist that meet the search criterion.
 *)
  DDENUMSURFACES_DOESEXIST                = $00000010;
  {$EXTERNALSYM DDENUMSURFACES_DOESEXIST}


(****************************************************************************
 *
 * DIRECTDRAW SETDISPLAYMODE FLAGS
 *
 ****************************************************************************)

(*
 * The desired mode is a standard VGA mode
 *)
  DDSDM_STANDARDVGAMODE                   = $00000001;
  {$EXTERNALSYM DDSDM_STANDARDVGAMODE}


(****************************************************************************
 *
 * DIRECTDRAW ENUMDISPLAYMODES FLAGS
 *
 ****************************************************************************)

(*
 * Enumerate Modes with different refresh rates.  EnumDisplayModes guarantees
 * that a particular mode will be enumerated only once.  This flag specifies whether
 * the refresh rate is taken into account when determining if a mode is unique.
 *)
  DDEDM_REFRESHRATES                      = $00000001;
  {$EXTERNALSYM DDEDM_REFRESHRATES}

(*
 * Enumerate VGA modes. Specify this flag if you wish to enumerate supported VGA
 * modes such as mode 0x13 in addition to the usual ModeX modes (which are always
 * enumerated if the application has previously called SetCooperativeLevel with the
 * DDSCL_ALLOWMODEX flag set).
 *)
  DDEDM_STANDARDVGAMODES                  = $00000002;
  {$EXTERNALSYM DDEDM_STANDARDVGAMODES}


(****************************************************************************
 *
 * DIRECTDRAW SETCOOPERATIVELEVEL FLAGS
 *
 ****************************************************************************)

(*
 * Exclusive mode owner will be responsible for the entire primary surface.
 * GDI can be ignored. used with DD
 *)
  DDSCL_FULLSCREEN                        = $00000001;
  {$EXTERNALSYM DDSCL_FULLSCREEN}

(*
 * allow CTRL_ALT_DEL to work while in fullscreen exclusive mode
 *)
  DDSCL_ALLOWREBOOT                       = $00000002;
  {$EXTERNALSYM DDSCL_ALLOWREBOOT}

(*
 * prevents DDRAW from modifying the application window.
 * prevents DDRAW from minimize/restore the application window on activation.
 *)
  DDSCL_NOWINDOWCHANGES                   = $00000004;
  {$EXTERNALSYM DDSCL_NOWINDOWCHANGES}

(*
 * app wants to work as a regular Windows application
 *)
  DDSCL_NORMAL                            = $00000008;
  {$EXTERNALSYM DDSCL_NORMAL}

(*
 * app wants exclusive access
 *)
  DDSCL_EXCLUSIVE                         = $00000010;
  {$EXTERNALSYM DDSCL_EXCLUSIVE}


(*
 * app can deal with non-windows display modes
 *)
  DDSCL_ALLOWMODEX                        = $00000040;
  {$EXTERNALSYM DDSCL_ALLOWMODEX}

(*
 * this window will receive the focus messages
 *)
  DDSCL_SETFOCUSWINDOW                    = $00000080;
  {$EXTERNALSYM DDSCL_SETFOCUSWINDOW}

(*
 * this window is associated with the DDRAW object and will
 * cover the screen in fullscreen mode
 *)
  DDSCL_SETDEVICEWINDOW                   = $00000100;
  {$EXTERNALSYM DDSCL_SETDEVICEWINDOW}

(*
 * app wants DDRAW to create a window to be associated with the
 * DDRAW object
 *)
  DDSCL_CREATEDEVICEWINDOW                = $00000200;
  {$EXTERNALSYM DDSCL_CREATEDEVICEWINDOW}

(*
 * App explicitly asks DDRAW/D3D to be multithread safe. This makes D3D
 * take the global crtisec more frequently.
 *)
  DDSCL_MULTITHREADED                     = $00000400;
  {$EXTERNALSYM DDSCL_MULTITHREADED}

(*
 * App specifies that it would like to keep the FPU set up for optimal Direct3D
 * performance (single precision and exceptions disabled) so Direct3D
 * does not need to explicitly set the FPU each time. This is assumed by
 * default in DirectX 7. See also DDSCL_FPUPRESERVE
 *)
  DDSCL_FPUSETUP                          = $00000800;
  {$EXTERNALSYM DDSCL_FPUSETUP}

(*
 * App specifies that it needs either double precision FPU or FPU exceptions
 * enabled. This makes Direct3D explicitly set the FPU state eah time it is
 * called. Setting the flag will reduce Direct3D performance. The flag is
 * assumed by default in DirectX 6 and earlier. See also DDSCL_FPUSETUP
 *)
  DDSCL_FPUPRESERVE                       = $00001000;
  {$EXTERNALSYM DDSCL_FPUPRESERVE}


(****************************************************************************
 *
 * DIRECTDRAW BLT FLAGS
 *
 ****************************************************************************)

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the destination surface as the alpha channel for this blt.
 *)
  DDBLT_ALPHADEST                         = $00000001;
  {$EXTERNALSYM DDBLT_ALPHADEST}

(*
 * Use the dwConstAlphaDest field in the DDBLTFX structure as the alpha channel
 * for the destination surface for this blt.
 *)
  DDBLT_ALPHADESTCONSTOVERRIDE            = $00000002;
  {$EXTERNALSYM DDBLT_ALPHADESTCONSTOVERRIDE}

(*
 * The NEG suffix indicates that the destination surface becomes more
 * transparent as the alpha value increases. (0 is opaque)
 *)
  DDBLT_ALPHADESTNEG                      = $00000004;
  {$EXTERNALSYM DDBLT_ALPHADESTNEG}

(*
 * Use the lpDDSAlphaDest field in the DDBLTFX structure as the alpha
 * channel for the destination for this blt.
 *)
  DDBLT_ALPHADESTSURFACEOVERRIDE          = $00000008;
  {$EXTERNALSYM DDBLT_ALPHADESTSURFACEOVERRIDE}

(*
 * Use the dwAlphaEdgeBlend field in the DDBLTFX structure as the alpha channel
 * for the edges of the image that border the color key colors.
 *)
  DDBLT_ALPHAEDGEBLEND                    = $00000010;
  {$EXTERNALSYM DDBLT_ALPHAEDGEBLEND}

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the source surface as the alpha channel for this blt.
 *)
  DDBLT_ALPHASRC                          = $00000020;
  {$EXTERNALSYM DDBLT_ALPHASRC}

(*
 * Use the dwConstAlphaSrc field in the DDBLTFX structure as the alpha channel
 * for the source for this blt.
 *)
  DDBLT_ALPHASRCCONSTOVERRIDE             = $00000040;
  {$EXTERNALSYM DDBLT_ALPHASRCCONSTOVERRIDE}

(*
 * The NEG suffix indicates that the source surface becomes more transparent
 * as the alpha value increases. (0 is opaque)
 *)
  DDBLT_ALPHASRCNEG                       = $00000080;
  {$EXTERNALSYM DDBLT_ALPHASRCNEG}

(*
 * Use the lpDDSAlphaSrc field in the DDBLTFX structure as the alpha channel
 * for the source for this blt.
 *)
  DDBLT_ALPHASRCSURFACEOVERRIDE           = $00000100;
  {$EXTERNALSYM DDBLT_ALPHASRCSURFACEOVERRIDE}

(*
 * Do this blt asynchronously through the FIFO in the order received.  If
 * there is no room in the hardware FIFO fail the call.
 *)
  DDBLT_ASYNC                             = $00000200;
  {$EXTERNALSYM DDBLT_ASYNC}

(*
 * Uses the dwFillColor field in the DDBLTFX structure as the RGB color
 * to fill the destination rectangle on the destination surface with.
 *)
  DDBLT_COLORFILL                         = $00000400;
  {$EXTERNALSYM DDBLT_COLORFILL}

(*
 * Uses the dwDDFX field in the DDBLTFX structure to specify the effects
 * to use for the blt.
 *)
  DDBLT_DDFX                              = $00000800;
  {$EXTERNALSYM DDBLT_DDFX}

(*
 * Uses the dwDDROPS field in the DDBLTFX structure to specify the ROPS
 * that are not part of the Win32 API.
 *)
  DDBLT_DDROPS                            = $00001000;
  {$EXTERNALSYM DDBLT_DDROPS}

(*
 * Use the color key associated with the destination surface.
 *)
  DDBLT_KEYDEST                           = $00002000;
  {$EXTERNALSYM DDBLT_KEYDEST}

(*
 * Use the dckDestColorkey field in the DDBLTFX structure as the color key
 * for the destination surface.
 *)
  DDBLT_KEYDESTOVERRIDE                   = $00004000;
  {$EXTERNALSYM DDBLT_KEYDESTOVERRIDE}

(*
 * Use the color key associated with the source surface.
 *)
  DDBLT_KEYSRC                            = $00008000;
  {$EXTERNALSYM DDBLT_KEYSRC}

(*
 * Use the dckSrcColorkey field in the DDBLTFX structure as the color key
 * for the source surface.
 *)
  DDBLT_KEYSRCOVERRIDE                    = $00010000;
  {$EXTERNALSYM DDBLT_KEYSRCOVERRIDE}

(*
 * Use the dwROP field in the DDBLTFX structure for the raster operation
 * for this blt.  These ROPs are the same as the ones defined in the Win32 API.
 *)
  DDBLT_ROP                               = $00020000;
  {$EXTERNALSYM DDBLT_ROP}

(*
 * Use the dwRotationAngle field in the DDBLTFX structure as the angle
 * (specified in 1/100th of a degree) to rotate the surface.
 *)
  DDBLT_ROTATIONANGLE                     = $00040000;
  {$EXTERNALSYM DDBLT_ROTATIONANGLE}

(*
 * Z-buffered blt using the z-buffers attached to the source and destination
 * surfaces and the dwZBufferOpCode field in the DDBLTFX structure as the
 * z-buffer opcode.
 *)
  DDBLT_ZBUFFER                           = $00080000;
  {$EXTERNALSYM DDBLT_ZBUFFER}

(*
 * Z-buffered blt using the dwConstDest Zfield and the dwZBufferOpCode field
 * in the DDBLTFX structure as the z-buffer and z-buffer opcode respectively
 * for the destination.
 *)
  DDBLT_ZBUFFERDESTCONSTOVERRIDE          = $00100000;
  {$EXTERNALSYM DDBLT_ZBUFFERDESTCONSTOVERRIDE}

(*
 * Z-buffered blt using the lpDDSDestZBuffer field and the dwZBufferOpCode
 * field in the DDBLTFX structure as the z-buffer and z-buffer opcode
 * respectively for the destination.
 *)
  DDBLT_ZBUFFERDESTOVERRIDE               = $00200000;
  {$EXTERNALSYM DDBLT_ZBUFFERDESTOVERRIDE}

(*
 * Z-buffered blt using the dwConstSrcZ field and the dwZBufferOpCode field
 * in the DDBLTFX structure as the z-buffer and z-buffer opcode respectively
 * for the source.
 *)
  DDBLT_ZBUFFERSRCCONSTOVERRIDE           = $00400000;
  {$EXTERNALSYM DDBLT_ZBUFFERSRCCONSTOVERRIDE}

(*
 * Z-buffered blt using the lpDDSSrcZBuffer field and the dwZBufferOpCode
 * field in the DDBLTFX structure as the z-buffer and z-buffer opcode
 * respectively for the source.
 *)
   DDBLT_ZBUFFERSRCOVERRIDE               = $00800000;
   {$EXTERNALSYM DDBLT_ZBUFFERSRCOVERRIDE}

(*
 * wait until the device is ready to handle the blt
 * this will cause blt to not return DDERR_WASSTILLDRAWING
 *)
  DDBLT_WAIT                              = $01000000;
  {$EXTERNALSYM DDBLT_WAIT}

(*
 * Uses the dwFillDepth field in the DDBLTFX structure as the depth value
 * to fill the destination rectangle on the destination Z-buffer surface
 * with.
 *)
  DDBLT_DEPTHFILL                         = $02000000;
  {$EXTERNALSYM DDBLT_DEPTHFILL}


(*
 * Return immediately (with DDERR_WASSTILLDRAWING) if the device is not
 * ready to schedule the blt at the time Blt() is called.
 *)
  DDBLT_DONOTWAIT                         = $08000000;
  {$EXTERNALSYM DDBLT_DONOTWAIT}

(*
 * These flags indicate a presentation blt (i.e. a blt
 * that moves surface contents from an offscreen back buffer to the primary
 * surface). The driver is not allowed to "queue"  more than three such blts.
 * The "end" of the presentation blt is indicated, since the
 * blt may be clipped, in which case the runtime will call the driver with
 * several blts. All blts (even if not clipped) are tagged with DDBLT_PRESENTATION
 * and the last (even if not clipped) additionally with DDBLT_LAST_PRESENTATION.
 * Thus the true rule is that the driver must not schedule a DDBLT_PRESENTATION
 * blt if there are 3 or more DDBLT_PRESENTLAST blts in the hardware pipe.
 * If there are such blts in the pipe, the driver should return DDERR_WASSTILLDRAWING
 * until the oldest queued DDBLT_LAST_PRESENTATION blts has been retired (i.e. the
 * pixels have been actually written to the primary surface). Once the oldest blt
 * has been retired, the driver is free to schedule the current blt.
 * The goal is to provide a mechanism whereby the device's hardware queue never
 * gets more than 3 frames ahead of the frames being generated by the application.
 * When excessive queueing occurs, applications become unusable because the application
 * visibly lags user input, and such problems make windowed interactive applications impossible.
 * Some drivers may not have sufficient knowledge of their hardware's FIFO to know
 * when a certain blt has been retired. Such drivers should code cautiously, and
 * simply not allow any frames to be queued at all. DDBLT_LAST_PRESENTATION should cause
 * such drivers to return DDERR_WASSTILLDRAWING until the accelerator is completely
 * finished- exactly as if the application had called Lock on the source surface
 * before calling Blt.
 * In other words, the driver is allowed and encouraged to
 * generate as much latency as it can, but never more than 3 frames worth.
 * Implementation detail: Drivers should count blts against the SOURCE surface, not
 * against the primary surface. This enables multiple parallel windowed application
 * to function more optimally.
 * This flag is passed only to DX8 or higher drivers.
 *
 * APPLICATIONS DO NOT SET THESE FLAGS. THEY ARE SET BY THE DIRECTDRAW RUNTIME.
 *
 *)
  DDBLT_PRESENTATION                      = $10000000;
  {$EXTERNALSYM DDBLT_PRESENTATION}
  DDBLT_LAST_PRESENTATION                 = $20000000;
  {$EXTERNALSYM DDBLT_LAST_PRESENTATION}

(*
 * If DDBLT_EXTENDED_FLAGS is set, then the driver should re-interpret
 * other flags according to the definitions that follow.
 * For example, bit 0 (0x00000001L) means DDBLT_ALPHADEST, unless
 * DDBLT_EXTENDED_FLAGS is also set, in which case bit 0 means
 * DDBLT_EXTENDED_LINEAR_CONTENT.
 * Only DirectX9 and higher drivers will be given extended blt flags.
 * Only flags explicitly mentioned here should be re-interpreted.
 * All other flags retain their original meanings.
 *
 * List of re-interpreted flags:
 *
 * Bit Hex value   New meaning                                  old meaning
 * ---------------------------------------------------------------
 *  2  0x00000004  DDBLT_EXTENDED_LINEAR_CONTENT                DDBLT_ALPHADESTNEG
 *  4  0x00000010  DDBLT_EXTENDED_PRESENTATION_STRETCHFACTOR    DDBLT_ALPHAEDGEBLEND
 *
 *
 * NOTE: APPLICATIONS SHOULD NOT SET THIS FLAG. THIS FLAG IS INTENDED
 * FOR USE BY THE DIRECT3D RUNTIME.
 *)
  DDBLT_EXTENDED_FLAGS                    = $40000000;
  {$EXTERNALSYM DDBLT_EXTENDED_FLAGS}

(*
 * EXTENDED FLAG. SEE DEFINITION OF DDBLT_EXTENDED_FLAGS.
 * This flag indidcates that the source surface contains content in a
 * linear color space. The driver may perform gamma correction to the
 * desktop color space (i.e. sRGB, gamma 2.2) as part of this blt.
 * If the device can perform such a conversion as part of the copy,
 * the driver should also set D3DCAPS3_LINEAR_TO_SRGB_PRESENTATION
 *
 * NOTE: APPLICATIONS SHOULD NOT SET THIS FLAG. THIS FLAG IS INTENDED
 * FOR USE BY THE DIRECT3D RUNTIME. Use IDirect3DSwapChain9::Present
 * and specify D3DPRESENT_LINEAR_CONTENT in order to use this functionality.
 *)
  DDBLT_EXTENDED_LINEAR_CONTENT           = $00000004;
  {$EXTERNALSYM DDBLT_EXTENDED_LINEAR_CONTENT}


(****************************************************************************
 *
 * BLTFAST FLAGS
 *
 ****************************************************************************)

  DDBLTFAST_NOCOLORKEY                    = $00000000;
  {$EXTERNALSYM DDBLTFAST_NOCOLORKEY}
  DDBLTFAST_SRCCOLORKEY                   = $00000001;
  {$EXTERNALSYM DDBLTFAST_SRCCOLORKEY}
  DDBLTFAST_DESTCOLORKEY                  = $00000002;
  {$EXTERNALSYM DDBLTFAST_DESTCOLORKEY}
  DDBLTFAST_WAIT                          = $00000010;
  {$EXTERNALSYM DDBLTFAST_WAIT}
  DDBLTFAST_DONOTWAIT                     = $00000020;
  {$EXTERNALSYM DDBLTFAST_DONOTWAIT}

(****************************************************************************
 *
 * FLIP FLAGS
 *
 ****************************************************************************)

  DDFLIP_WAIT                          = $00000001;
  {$EXTERNALSYM DDFLIP_WAIT}

(*
 * Indicates that the target surface contains the even field of video data.
 * This flag is only valid with an overlay surface.
 *)
  DDFLIP_EVEN                          = $00000002;
  {$EXTERNALSYM DDFLIP_EVEN}

(*
 * Indicates that the target surface contains the odd field of video data.
 * This flag is only valid with an overlay surface.
 *)
  DDFLIP_ODD                           = $00000004;
  {$EXTERNALSYM DDFLIP_ODD}

(*
 * Causes DirectDraw to perform the physical flip immediately and return
 * to the application. Typically, what was the front buffer but is now the back
 * buffer will still be visible (depending on timing) until the next vertical
 * retrace. Subsequent operations involving the two flipped surfaces will
 * not check to see if the physical flip has finished (i.e. will not return
 * DDERR_WASSTILLDRAWING for that reason (but may for other reasons)).
 * This allows an application to perform Flips at a higher frequency than the
 * monitor refresh rate, but may introduce visible artifacts.
 * Only effective if DDCAPS2_FLIPNOVSYNC is set. If that bit is not set,
 * DDFLIP_NOVSYNC has no effect.
 *)
  DDFLIP_NOVSYNC                       = $00000008;
  {$EXTERNALSYM DDFLIP_NOVSYNC}


(*
 * Flip Interval Flags. These flags indicate how many vertical retraces to wait between
 * each flip. The default is one. DirectDraw will return DDERR_WASSTILLDRAWING for each
 * surface involved in the flip until the specified number of vertical retraces has
 * ocurred. Only effective if DDCAPS2_FLIPINTERVAL is set. If that bit is not set,
 * DDFLIP_INTERVALn has no effect.
 *)

(*
 * DirectDraw will flip on every other vertical sync
 *)
  DDFLIP_INTERVAL2                     = $02000000;
  {$EXTERNALSYM DDFLIP_INTERVAL2}


(*
 * DirectDraw will flip on every third vertical sync
 *)
  DDFLIP_INTERVAL3                     = $03000000;
  {$EXTERNALSYM DDFLIP_INTERVAL3}


(*
 * DirectDraw will flip on every fourth vertical sync
 *)
  DDFLIP_INTERVAL4                     = $04000000;
  {$EXTERNALSYM DDFLIP_INTERVAL4}

(*
 * DirectDraw will flip and display a main stereo surface
 *)
  DDFLIP_STEREO                        = $00000010;
  {$EXTERNALSYM DDFLIP_STEREO}

(*
 * On IDirectDrawSurface7 and higher interfaces, the default is DDFLIP_WAIT. If you wish
 * to override the default and use time when the accelerator is busy (as denoted by
 * the DDERR_WASSTILLDRAWING return code) then use DDFLIP_DONOTWAIT.
 *)
  DDFLIP_DONOTWAIT                     = $00000020;
  {$EXTERNALSYM DDFLIP_DONOTWAIT}


(****************************************************************************
 *
 * DIRECTDRAW SURFACE OVERLAY FLAGS
 *
 ****************************************************************************)

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the destination surface as the alpha channel for the
 * destination overlay.
 *)
  DDOVER_ALPHADEST                        = $00000001;
  {$EXTERNALSYM DDOVER_ALPHADEST}

(*
 * Use the dwConstAlphaDest field in the DDOVERLAYFX structure as the
 * destination alpha channel for this overlay.
 *)
  DDOVER_ALPHADESTCONSTOVERRIDE           = $00000002;
  {$EXTERNALSYM DDOVER_ALPHADESTCONSTOVERRIDE}

(*
 * The NEG suffix indicates that the destination surface becomes more
 * transparent as the alpha value increases.
 *)
  DDOVER_ALPHADESTNEG                     = $00000004;
  {$EXTERNALSYM DDOVER_ALPHADESTNEG}

(*
 * Use the lpDDSAlphaDest field in the DDOVERLAYFX structure as the alpha
 * channel destination for this overlay.
 *)
  DDOVER_ALPHADESTSURFACEOVERRIDE         = $00000008;
  {$EXTERNALSYM DDOVER_ALPHADESTSURFACEOVERRIDE}

(*
 * Use the dwAlphaEdgeBlend field in the DDOVERLAYFX structure as the alpha
 * channel for the edges of the image that border the color key colors.
 *)
  DDOVER_ALPHAEDGEBLEND                   = $00000010;
  {$EXTERNALSYM DDOVER_ALPHAEDGEBLEND}

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the source surface as the source alpha channel for this overlay.
 *)
  DDOVER_ALPHASRC                         = $00000020;
  {$EXTERNALSYM DDOVER_ALPHASRC}

(*
 * Use the dwConstAlphaSrc field in the DDOVERLAYFX structure as the source
 * alpha channel for this overlay.
 *)
  DDOVER_ALPHASRCCONSTOVERRIDE            = $00000040;
  {$EXTERNALSYM DDOVER_ALPHASRCCONSTOVERRIDE}

(*
 * The NEG suffix indicates that the source surface becomes more transparent
 * as the alpha value increases.
 *)
  DDOVER_ALPHASRCNEG                      = $00000080;
  {$EXTERNALSYM DDOVER_ALPHASRCNEG}

(*
 * Use the lpDDSAlphaSrc field in the DDOVERLAYFX structure as the alpha channel
 * source for this overlay.
 *)
  DDOVER_ALPHASRCSURFACEOVERRIDE          = $00000100;
  {$EXTERNALSYM DDOVER_ALPHASRCSURFACEOVERRIDE}

(*
 * Turn this overlay off.
 *)
  DDOVER_HIDE                             = $00000200;
  {$EXTERNALSYM DDOVER_HIDE}

(*
 * Use the color key associated with the destination surface.
 *)
  DDOVER_KEYDEST                          = $00000400;
  {$EXTERNALSYM DDOVER_KEYDEST}

(*
 * Use the dckDestColorkey field in the DDOVERLAYFX structure as the color key
 * for the destination surface
 *)
  DDOVER_KEYDESTOVERRIDE                  = $00000800;
  {$EXTERNALSYM DDOVER_KEYDESTOVERRIDE}

(*
 * Use the color key associated with the source surface.
 *)
  DDOVER_KEYSRC                           = $00001000;
  {$EXTERNALSYM DDOVER_KEYSRC}

(*
 * Use the dckSrcColorkey field in the DDOVERLAYFX structure as the color key
 * for the source surface.
 *)
  DDOVER_KEYSRCOVERRIDE                   = $00002000;
  {$EXTERNALSYM DDOVER_KEYSRCOVERRIDE}

(*
 * Turn this overlay on.
 *)
  DDOVER_SHOW                             = $00004000;
  {$EXTERNALSYM DDOVER_SHOW}

(*
 * Add a dirty rect to an emulated overlayed surface.
 *)
  DDOVER_ADDDIRTYRECT                     = $00008000;
  {$EXTERNALSYM DDOVER_ADDDIRTYRECT}

(*
 * Redraw all dirty rects on an emulated overlayed surface.
 *)
  DDOVER_REFRESHDIRTYRECTS                = $00010000;
  {$EXTERNALSYM DDOVER_REFRESHDIRTYRECTS}

(*
 * Redraw the entire surface on an emulated overlayed surface.
 *)
  DDOVER_REFRESHALL                       = $00020000;
  {$EXTERNALSYM DDOVER_REFRESHALL}


(*
 * Use the overlay FX flags to define special overlay FX
 *)
  DDOVER_DDFX                             = $00080000;
  {$EXTERNALSYM DDOVER_DDFX}

(*
 * Autoflip the overlay when ever the video port autoflips
 *)
  DDOVER_AUTOFLIP                      	  = $00100000;
  {$EXTERNALSYM DDOVER_AUTOFLIP}

(*
 * Display each field of video port data individually without
 * causing any jittery artifacts
 *)
  DDOVER_BOB                       	  = $00200000;
  {$EXTERNALSYM DDOVER_BOB}

(*
 * Indicates that bob/weave decisions should not be overridden by other
 * interfaces.
 *)
  DDOVER_OVERRIDEBOBWEAVE		  = $00400000;
  {$EXTERNALSYM DDOVER_OVERRIDEBOBWEAVE}

(*
 * Indicates that the surface memory is composed of interleaved fields.
 *)
  DDOVER_INTERLEAVED			  = $00800000;
  {$EXTERNALSYM DDOVER_INTERLEAVED}

(*
 * Indicates that bob will be performed using hardware rather than
 * software or emulated.
 *)
  DDOVER_BOBHARDWARE		       	= $01000000;
  {$EXTERNALSYM DDOVER_BOBHARDWARE}

(*
 * Indicates that overlay FX structure contains valid ARGB scaling factors.
 *)
  DDOVER_ARGBSCALEFACTORS                 = $02000000;
  {$EXTERNALSYM DDOVER_ARGBSCALEFACTORS}

(*
 * Indicates that ARGB scaling factors can be degraded to fit driver capabilities.
 *)
  DDOVER_DEGRADEARGBSCALING               = $04000000;
  {$EXTERNALSYM DDOVER_DEGRADEARGBSCALING}


(****************************************************************************
 *
 * DIRECTDRAWSURFACE LOCK FLAGS
 *
 ****************************************************************************)

(*
 * The default.  Set to indicate that Lock should return a valid memory pointer
 * to the top of the specified rectangle.  If no rectangle is specified then a
 * pointer to the top of the surface is returned.
 *)
  DDLOCK_SURFACEMEMORYPTR                 = $00000000;    // = default
  {$EXTERNALSYM DDLOCK_SURFACEMEMORYPTR}

(*
 * Set to indicate that Lock should wait until it can obtain a valid memory
 * pointer before returning.  If this bit is set, Lock will never return
 * DDERR_WASSTILLDRAWING.
 *)
  DDLOCK_WAIT                             = $00000001;
  {$EXTERNALSYM DDLOCK_WAIT}

(*
 * Set if an event handle is being passed to Lock.  Lock will trigger the event
 * when it can return the surface memory pointer requested.
 *)
  DDLOCK_EVENT                            = $00000002;
  {$EXTERNALSYM DDLOCK_EVENT}

(*
 * Indicates that the surface being locked will only be read from.
 *)
  DDLOCK_READONLY                         = $00000010;
  {$EXTERNALSYM DDLOCK_READONLY}

(*
 * Indicates that the surface being locked will only be written to
 *)
  DDLOCK_WRITEONLY                        = $00000020;
  {$EXTERNALSYM DDLOCK_WRITEONLY}


(*
 * Indicates that a system wide lock should not be taken when this surface
 * is locked. This has several advantages (cursor responsiveness, ability
 * to call more Windows functions, easier debugging) when locking video
 * memory surfaces. However, an application specifying this flag must
 * comply with a number of conditions documented in the help file.
 * Furthermore, this flag cannot be specified when locking the primary.
 *)
  DDLOCK_NOSYSLOCK                        = $00000800;
  {$EXTERNALSYM DDLOCK_NOSYSLOCK}

(*
 * Used only with Direct3D Vertex Buffer Locks. Indicates that no vertices
 * that were referred to in Draw*PrimtiveVB calls since the start of the
 * frame (or the last lock without this flag) will be modified during the
 * lock. This can be useful when one is only appending data to the vertex
 * buffer
 *)
  DDLOCK_NOOVERWRITE                      = $00001000;
  {$EXTERNALSYM DDLOCK_NOOVERWRITE}

(*
 * Indicates that no assumptions will be made about the contents of the
 * surface or vertex buffer during this lock.
 * This enables two things:
 * -    Direct3D or the driver may provide an alternative memory
 *      area as the vertex buffer. This is useful when one plans to clear the
 *      contents of the vertex buffer and fill in new data.
 * -    Drivers sometimes store surface data in a re-ordered format.
 *      When the application locks the surface, the driver is forced to un-re-order
 *      the surface data before allowing the application to see the surface contents.
 *      This flag is a hint to the driver that it can skip the un-re-ordering process
 *      since the application plans to overwrite every single pixel in the surface
 *      or locked rectangle (and so erase any un-re-ordered pixels anyway).
 *      Applications should always set this flag when they intend to overwrite the entire
 *      surface or locked rectangle.
 *)
  DDLOCK_DISCARDCONTENTS                  = $00002000;
  {$EXTERNALSYM DDLOCK_DISCARDCONTENTS}
 (*
  * DDLOCK_OKTOSWAP is an older, less informative name for DDLOCK_DISCARDCONTENTS
  *)
  DDLOCK_OKTOSWAP                         = $00002000;
  {$EXTERNALSYM DDLOCK_OKTOSWAP}

(*
 * On IDirectDrawSurface7 and higher interfaces, the default is DDLOCK_WAIT. If you wish
 * to override the default and use time when the accelerator is busy (as denoted by
 * the DDERR_WASSTILLDRAWING return code) then use DDLOCK_DONOTWAIT.
 *)
  DDLOCK_DONOTWAIT                        = $00004000;
  {$EXTERNALSYM DDLOCK_DONOTWAIT}

(*
 * This indicates volume texture lock with front and back specified.
 *)
  DDLOCK_HASVOLUMETEXTUREBOXRECT          = $00008000;
  {$EXTERNALSYM DDLOCK_HASVOLUMETEXTUREBOXRECT}

(*
 * This indicates that the driver should not update dirty rect information for this lock.
 *)
  DDLOCK_NODIRTYUPDATE                    = $00010000;
  {$EXTERNALSYM DDLOCK_NODIRTYUPDATE}


(****************************************************************************
 *
 * DIRECTDRAWSURFACE PAGELOCK FLAGS
 *
 ****************************************************************************)

(*
 * No flags defined at present
 *)


(****************************************************************************
 *
 * DIRECTDRAWSURFACE PAGEUNLOCK FLAGS
 *
 ****************************************************************************)

(*
 * No flags defined at present
 *)


(****************************************************************************
 *
 * DIRECTDRAWSURFACE BLT FX FLAGS
 *
 ****************************************************************************)

(*
 * If stretching, use arithmetic stretching along the Y axis for this blt.
 *)
  DDBLTFX_ARITHSTRETCHY                   = $00000001;
  {$EXTERNALSYM DDBLTFX_ARITHSTRETCHY}

(*
 * Do this blt mirroring the surface left to right.  Spin the
 * surface around its y-axis.
 *)
  DDBLTFX_MIRRORLEFTRIGHT                 = $00000002;
  {$EXTERNALSYM DDBLTFX_MIRRORLEFTRIGHT}

(*
 * Do this blt mirroring the surface up and down.  Spin the surface
 * around its x-axis.
 *)
  DDBLTFX_MIRRORUPDOWN                    = $00000004;
  {$EXTERNALSYM DDBLTFX_MIRRORUPDOWN}

(*
 * Schedule this blt to avoid tearing.
 *)
  DDBLTFX_NOTEARING                       = $00000008;
  {$EXTERNALSYM DDBLTFX_NOTEARING}

(*
 * Do this blt rotating the surface one hundred and eighty degrees.
 *)
  DDBLTFX_ROTATE180                       = $00000010;
  {$EXTERNALSYM DDBLTFX_ROTATE180}

(*
 * Do this blt rotating the surface two hundred and seventy degrees.
 *)
  DDBLTFX_ROTATE270                       = $00000020;
  {$EXTERNALSYM DDBLTFX_ROTATE270}

(*
 * Do this blt rotating the surface ninety degrees.
 *)
  DDBLTFX_ROTATE90                        = $00000040;
  {$EXTERNALSYM DDBLTFX_ROTATE90}

(*
 * Do this z blt using dwZBufferLow and dwZBufferHigh as  range values
 * specified to limit the bits copied from the source surface.
 *)
  DDBLTFX_ZBUFFERRANGE                    = $00000080;
  {$EXTERNALSYM DDBLTFX_ZBUFFERRANGE}

(*
 * Do this z blt adding the dwZBufferBaseDest to each of the sources z values
 * before comparing it with the desting z values.
 *)
  DDBLTFX_ZBUFFERBASEDEST                 = $00000100;
  {$EXTERNALSYM DDBLTFX_ZBUFFERBASEDEST}

(****************************************************************************
 *
 * DIRECTDRAWSURFACE OVERLAY FX FLAGS
 *
 ****************************************************************************)

(*
 * If stretching, use arithmetic stretching along the Y axis for this overlay.
 *)
  DDOVERFX_ARITHSTRETCHY                  = $00000001;
  {$EXTERNALSYM DDOVERFX_ARITHSTRETCHY}

(*
 * Mirror the overlay across the vertical axis
 *)
  DDOVERFX_MIRRORLEFTRIGHT                = $00000002;
  {$EXTERNALSYM DDOVERFX_MIRRORLEFTRIGHT}

(*
 * Mirror the overlay across the horizontal axis
 *)
  DDOVERFX_MIRRORUPDOWN                   = $00000004;
  {$EXTERNALSYM DDOVERFX_MIRRORUPDOWN}

(*
 * Deinterlace the overlay, if possible
 *)
  DDOVERFX_DEINTERLACE                    = $00000008;
  {$EXTERNALSYM DDOVERFX_DEINTERLACE}


(****************************************************************************
 *
 * DIRECTDRAW WAITFORVERTICALBLANK FLAGS
 *
 ****************************************************************************)

(*
 * return when the vertical blank interval begins
 *)
  DDWAITVB_BLOCKBEGIN                     = $00000001;
  {$EXTERNALSYM DDWAITVB_BLOCKBEGIN}

(*
 * set up an event to trigger when the vertical blank begins
 *)
  DDWAITVB_BLOCKBEGINEVENT                = $00000002;
  {$EXTERNALSYM DDWAITVB_BLOCKBEGINEVENT}

(*
 * return when the vertical blank interval ends and display begins
 *)
  DDWAITVB_BLOCKEND                       = $00000004;
  {$EXTERNALSYM DDWAITVB_BLOCKEND}

(****************************************************************************
 *
 * DIRECTDRAW GETFLIPSTATUS FLAGS
 *
 ****************************************************************************)

(*
 * is it OK to flip now?
 *)
  DDGFS_CANFLIP                   = $00000001;
  {$EXTERNALSYM DDGFS_CANFLIP}

(*
 * is the last flip finished?
 *)
  DDGFS_ISFLIPDONE                = $00000002;
  {$EXTERNALSYM DDGFS_ISFLIPDONE}

(****************************************************************************
 *
 * DIRECTDRAW GETBLTSTATUS FLAGS
 *
 ****************************************************************************)

(*
 * is it OK to blt now?
 *)
  DDGBS_CANBLT                    = $00000001;
  {$EXTERNALSYM DDGBS_CANBLT}

(*
 * is the blt to the surface finished?
 *)
  DDGBS_ISBLTDONE                 = $00000002;
  {$EXTERNALSYM DDGBS_ISBLTDONE}


(****************************************************************************
 *
 * DIRECTDRAW ENUMOVERLAYZORDER FLAGS
 *
 ****************************************************************************)

(*
 * Enumerate overlays back to front.
 *)
  DDENUMOVERLAYZ_BACKTOFRONT      = $00000000;
  {$EXTERNALSYM DDENUMOVERLAYZ_BACKTOFRONT}

(*
 * Enumerate overlays front to back
 *)
  DDENUMOVERLAYZ_FRONTTOBACK      = $00000001;
  {$EXTERNALSYM DDENUMOVERLAYZ_FRONTTOBACK}

(****************************************************************************
 *
 * DIRECTDRAW UPDATEOVERLAYZORDER FLAGS
 *
 ****************************************************************************)

(*
 * Send overlay to front
 *)
  DDOVERZ_SENDTOFRONT             = $00000000;
  {$EXTERNALSYM DDOVERZ_SENDTOFRONT}

(*
 * Send overlay to back
 *)
  DDOVERZ_SENDTOBACK              = $00000001;
  {$EXTERNALSYM DDOVERZ_SENDTOBACK}

(*
 * Move Overlay forward
 *)
  DDOVERZ_MOVEFORWARD             = $00000002;
  {$EXTERNALSYM DDOVERZ_MOVEFORWARD}

(*
 * Move Overlay backward
 *)
  DDOVERZ_MOVEBACKWARD            = $00000003;
  {$EXTERNALSYM DDOVERZ_MOVEBACKWARD}

(*
 * Move Overlay in front of relative surface
 *)
  DDOVERZ_INSERTINFRONTOF         = $00000004;
  {$EXTERNALSYM DDOVERZ_INSERTINFRONTOF}

(*
 * Move Overlay in back of relative surface
 *)
  DDOVERZ_INSERTINBACKOF          = $00000005;
  {$EXTERNALSYM DDOVERZ_INSERTINBACKOF}


(****************************************************************************
 *
 * DIRECTDRAW SETGAMMARAMP FLAGS
 *
 ****************************************************************************)

(*
 * Request calibrator to adjust the gamma ramp according to the physical
 * properties of the display so that the result should appear identical
 * on all systems.
 *)
  DDSGR_CALIBRATE                        = $00000001;
  {$EXTERNALSYM DDSGR_CALIBRATE}


(****************************************************************************
 *
 * DIRECTDRAW STARTMODETEST FLAGS
 *
 ****************************************************************************)

(*
 * Indicates that the mode being tested has passed
 *)
 DDSMT_ISTESTREQUIRED                   = $00000001;
 {$EXTERNALSYM DDSMT_ISTESTREQUIRED}


(****************************************************************************
 *
 * DIRECTDRAW EVALUATEMODE FLAGS
 *
 ****************************************************************************)

(*
 * Indicates that the mode being tested has passed
 *)
 DDEM_MODEPASSED                        = $00000001;
 {$EXTERNALSYM DDEM_MODEPASSED}

(*
 * Indicates that the mode being tested has failed
 *)
 DDEM_MODEFAILED                        = $00000002;
 {$EXTERNALSYM DDEM_MODEFAILED}


(*===========================================================================
 *
 *
 * DIRECTDRAW RETURN CODES
 *
 * The return values from DirectDraw Commands and Surface that return an HRESULT
 * are codes from DirectDraw concerning the results of the action
 * requested by DirectDraw.
 *
 *==========================================================================*)

(*
 * Status is OK
 *
 * Issued by: DirectDraw Commands and all callbacks
 *)
  DD_OK                                   = 0;
  {$EXTERNALSYM DD_OK}
  DD_FALSE                                = S_FALSE;
  {$EXTERNALSYM DD_FALSE}

(****************************************************************************
 *
 * DIRECTDRAW ENUMCALLBACK RETURN VALUES
 *
 * EnumCallback returns are used to control the flow of the DIRECTDRAW and
 * DIRECTDRAWSURFACE object enumerations.   They can only be returned by
 * enumeration callback routines.
 *
 ****************************************************************************)

(*
 * stop the enumeration
 *)
  DDENUMRET_CANCEL                        = 0;
  {$EXTERNALSYM DDENUMRET_CANCEL}

(*
 * continue the enumeration
 *)
  DDENUMRET_OK                            = 1;
  {$EXTERNALSYM DDENUMRET_OK}

(****************************************************************************
 *
 * DIRECTDRAW ERRORS
 *
 * Errors are represented by negative values and cannot be combined.
 *
 ****************************************************************************)

const
  _FACDD = $876;
  {$EXTERNALSYM _FACDD}
  _MAKE_DDHRESULT = HResult(1 shl 31) or HResult(_FACDD shl 16);

//#define MAKE_DDHRESULT( code )  MAKE_HRESULT( 1, _FACDD, code )
function MAKE_DDHRESULT(Code: DWORD): HResult;
{$EXTERNALSYM MAKE_DDHRESULT}

const
(*
 * This object is already initialized
 *)
  DDERR_ALREADYINITIALIZED                = HResult(_MAKE_DDHRESULT + 5);
  {$EXTERNALSYM DDERR_ALREADYINITIALIZED}

(*
 * This surface can not be attached to the requested surface.
 *)
  DDERR_CANNOTATTACHSURFACE               = HResult(_MAKE_DDHRESULT + 10);
  {$EXTERNALSYM DDERR_CANNOTATTACHSURFACE}

(*
 * This surface can not be detached from the requested surface.
 *)
  DDERR_CANNOTDETACHSURFACE               = HResult(_MAKE_DDHRESULT + 20);
  {$EXTERNALSYM DDERR_CANNOTDETACHSURFACE}

(*
 * Support is currently not available.
 *)
  DDERR_CURRENTLYNOTAVAIL                 = HResult(_MAKE_DDHRESULT + 40);
  {$EXTERNALSYM DDERR_CURRENTLYNOTAVAIL}

(*
 * An exception was encountered while performing the requested operation
 *)
  DDERR_EXCEPTION                         = HResult(_MAKE_DDHRESULT + 55);
  {$EXTERNALSYM DDERR_EXCEPTION}

(*
 * Generic failure.
 *)
  DDERR_GENERIC                           = E_FAIL;
  {$EXTERNALSYM DDERR_GENERIC}

(*
 * Height of rectangle provided is not a multiple of reqd alignment
 *)
  DDERR_HEIGHTALIGN                       = HResult(_MAKE_DDHRESULT + 90);
  {$EXTERNALSYM DDERR_HEIGHTALIGN}

(*
 * Unable to match primary surface creation request with existing
 * primary surface.
 *)
  DDERR_INCOMPATIBLEPRIMARY               = HResult(_MAKE_DDHRESULT + 95);
  {$EXTERNALSYM DDERR_INCOMPATIBLEPRIMARY}

(*
 * One or more of the caps bits passed to the callback are incorrect.
 *)
  DDERR_INVALIDCAPS                       = HResult(_MAKE_DDHRESULT + 100);
  {$EXTERNALSYM DDERR_INVALIDCAPS}

(*
 * DirectDraw does not support provided Cliplist.
 *)
  DDERR_INVALIDCLIPLIST                   = HResult(_MAKE_DDHRESULT + 110);
  {$EXTERNALSYM DDERR_INVALIDCLIPLIST}

(*
 * DirectDraw does not support the requested mode
 *)
  DDERR_INVALIDMODE                       = HResult(_MAKE_DDHRESULT + 120);
  {$EXTERNALSYM DDERR_INVALIDMODE}

(*
 * DirectDraw received a pointer that was an invalid DIRECTDRAW object.
 *)
  DDERR_INVALIDOBJECT                     = HResult(_MAKE_DDHRESULT + 130);
  {$EXTERNALSYM DDERR_INVALIDOBJECT}

(*
 * One or more of the parameters passed to the callback function are
 * incorrect.
 *)
  DDERR_INVALIDPARAMS                     = E_INVALIDARG;
  {$EXTERNALSYM DDERR_INVALIDPARAMS}

(*
 * pixel format was invalid as specified
 *)
  DDERR_INVALIDPIXELFORMAT                = HResult(_MAKE_DDHRESULT + 145);
  {$EXTERNALSYM DDERR_INVALIDPIXELFORMAT}

(*
 * Rectangle provided was invalid.
 *)
  DDERR_INVALIDRECT                       = HResult(_MAKE_DDHRESULT + 150);
  {$EXTERNALSYM DDERR_INVALIDRECT}

(*
 * Operation could not be carried out because one or more surfaces are locked
 *)
  DDERR_LOCKEDSURFACES                    = HResult(_MAKE_DDHRESULT + 160);
  {$EXTERNALSYM DDERR_LOCKEDSURFACES}

(*
 * There is no 3D present.
 *)
  DDERR_NO3D                              = HResult(_MAKE_DDHRESULT + 170);
  {$EXTERNALSYM DDERR_NO3D}

(*
 * Operation could not be carried out because there is no alpha accleration
 * hardware present or available.
 *)
  DDERR_NOALPHAHW                         = HResult(_MAKE_DDHRESULT + 180);
  {$EXTERNALSYM DDERR_NOALPHAHW}

(*
 * Operation could not be carried out because there is no stereo
 * hardware present or available.
 *)
  DDERR_NOSTEREOHARDWARE                  = HResult(_MAKE_DDHRESULT + 181);
  {$EXTERNALSYM DDERR_NOSTEREOHARDWARE}

(*
 * Operation could not be carried out because there is no hardware
 * present which supports stereo surfaces
 *)
  DDERR_NOSURFACELEFT                     = HResult(_MAKE_DDHRESULT + 182);
  {$EXTERNALSYM DDERR_NOSURFACELEFT}



(*
 * no clip list available
 *)
  DDERR_NOCLIPLIST                        = HResult(_MAKE_DDHRESULT + 205);
  {$EXTERNALSYM DDERR_NOCLIPLIST}

(*
 * Operation could not be carried out because there is no color conversion
 * hardware present or available.
 *)
  DDERR_NOCOLORCONVHW                     = HResult(_MAKE_DDHRESULT + 210);
  {$EXTERNALSYM DDERR_NOCOLORCONVHW}

(*
 * Create function called without DirectDraw object method SetCooperativeLevel
 * being called.
 *)
  DDERR_NOCOOPERATIVELEVELSET             = HResult(_MAKE_DDHRESULT + 212);
  {$EXTERNALSYM DDERR_NOCOOPERATIVELEVELSET}

(*
 * Surface doesn't currently have a color key
 *)
  DDERR_NOCOLORKEY                        = HResult(_MAKE_DDHRESULT + 215);
  {$EXTERNALSYM DDERR_NOCOLORKEY}

(*
 * Operation could not be carried out because there is no hardware support
 * of the dest color key.
 *)
  DDERR_NOCOLORKEYHW                      = HResult(_MAKE_DDHRESULT + 220);
  {$EXTERNALSYM DDERR_NOCOLORKEYHW}

(*
 * No DirectDraw support possible with current display driver
 *)
  DDERR_NODIRECTDRAWSUPPORT               = HResult(_MAKE_DDHRESULT + 222);
  {$EXTERNALSYM DDERR_NODIRECTDRAWSUPPORT}

(*
 * Operation requires the application to have exclusive mode but the
 * application does not have exclusive mode.
 *)
  DDERR_NOEXCLUSIVEMODE                   = HResult(_MAKE_DDHRESULT + 225);
  {$EXTERNALSYM DDERR_NOEXCLUSIVEMODE}

(*
 * Flipping visible surfaces is not supported.
 *)
  DDERR_NOFLIPHW                          = HResult(_MAKE_DDHRESULT + 230);
  {$EXTERNALSYM DDERR_NOFLIPHW}

(*
 * There is no GDI present.
 *)
  DDERR_NOGDI                             = HResult(_MAKE_DDHRESULT + 240);
  {$EXTERNALSYM DDERR_NOGDI}

(*
 * Operation could not be carried out because there is no hardware present
 * or available.
 *)
  DDERR_NOMIRRORHW                        = HResult(_MAKE_DDHRESULT + 250);
  {$EXTERNALSYM DDERR_NOMIRRORHW}

(*
 * Requested item was not found
 *)
  DDERR_NOTFOUND                          = HResult(_MAKE_DDHRESULT + 255);
  {$EXTERNALSYM DDERR_NOTFOUND}

(*
 * Operation could not be carried out because there is no overlay hardware
 * present or available.
 *)
  DDERR_NOOVERLAYHW                       = HResult(_MAKE_DDHRESULT + 260);
  {$EXTERNALSYM DDERR_NOOVERLAYHW}

(*
 * Operation could not be carried out because the source and destination
 * rectangles are on the same surface and overlap each other.
 *)
  DDERR_OVERLAPPINGRECTS                  = HResult(_MAKE_DDHRESULT + 270);
  {$EXTERNALSYM DDERR_OVERLAPPINGRECTS}

(*
 * Operation could not be carried out because there is no appropriate raster
 * op hardware present or available.
 *)
  DDERR_NORASTEROPHW                      = HResult(_MAKE_DDHRESULT + 280);
  {$EXTERNALSYM DDERR_NORASTEROPHW}

(*
 * Operation could not be carried out because there is no rotation hardware
 * present or available.
 *)
  DDERR_NOROTATIONHW                      = HResult(_MAKE_DDHRESULT + 290);
  {$EXTERNALSYM DDERR_NOROTATIONHW}

(*
 * Operation could not be carried out because there is no hardware support
 * for stretching
 *)
  DDERR_NOSTRETCHHW                       = HResult(_MAKE_DDHRESULT + 310);
  {$EXTERNALSYM DDERR_NOSTRETCHHW}

(*
 * DirectDrawSurface is not in 4 bit color palette and the requested operation
 * requires 4 bit color palette.
 *)
  DDERR_NOT4BITCOLOR                      = HResult(_MAKE_DDHRESULT + 316);
  {$EXTERNALSYM DDERR_NOT4BITCOLOR}

(*
 * DirectDrawSurface is not in 4 bit color index palette and the requested
 * operation requires 4 bit color index palette.
 *)
  DDERR_NOT4BITCOLORINDEX                 = HResult(_MAKE_DDHRESULT + 317);
  {$EXTERNALSYM DDERR_NOT4BITCOLORINDEX}

(*
 * DirectDraw Surface is not in 8 bit color mode and the requested operation
 * requires 8 bit color.
 *)
  DDERR_NOT8BITCOLOR                      = HResult(_MAKE_DDHRESULT + 320);
  {$EXTERNALSYM DDERR_NOT8BITCOLOR}

(*
 * Operation could not be carried out because there is no texture mapping
 * hardware present or available.
 *)
  DDERR_NOTEXTUREHW                       = HResult(_MAKE_DDHRESULT + 330);
  {$EXTERNALSYM DDERR_NOTEXTUREHW}

(*
 * Operation could not be carried out because there is no hardware support
 * for vertical blank synchronized operations.
 *)
  DDERR_NOVSYNCHW                         = HResult(_MAKE_DDHRESULT + 335);
  {$EXTERNALSYM DDERR_NOVSYNCHW}

(*
 * Operation could not be carried out because there is no hardware support
 * for zbuffer blting.
 *)
  DDERR_NOZBUFFERHW                       = HResult(_MAKE_DDHRESULT + 340);
  {$EXTERNALSYM DDERR_NOZBUFFERHW}

(*
 * Overlay surfaces could not be z layered based on their BltOrder because
 * the hardware does not support z layering of overlays.
 *)
  DDERR_NOZOVERLAYHW                      = HResult(_MAKE_DDHRESULT + 350);
  {$EXTERNALSYM DDERR_NOZOVERLAYHW}

(*
 * The hardware needed for the requested operation has already been
 * allocated.
 *)
  DDERR_OUTOFCAPS                         = HResult(_MAKE_DDHRESULT + 360);
  {$EXTERNALSYM DDERR_OUTOFCAPS}

(*
 * DirectDraw does not have enough memory to perform the operation.
 *)
  DDERR_OUTOFMEMORY                       = E_OUTOFMEMORY;
  {$EXTERNALSYM DDERR_OUTOFMEMORY}

(*
 * DirectDraw does not have enough memory to perform the operation.
 *)
  DDERR_OUTOFVIDEOMEMORY                  = HResult(_MAKE_DDHRESULT + 380);
  {$EXTERNALSYM DDERR_OUTOFVIDEOMEMORY}

(*
 * hardware does not support clipped overlays
 *)
  DDERR_OVERLAYCANTCLIP                   = HResult(_MAKE_DDHRESULT + 382);
  {$EXTERNALSYM DDERR_OVERLAYCANTCLIP}

(*
 * Can only have ony color key active at one time for overlays
 *)
  DDERR_OVERLAYCOLORKEYONLYONEACTIVE      = HResult(_MAKE_DDHRESULT + 384);
  {$EXTERNALSYM DDERR_OVERLAYCOLORKEYONLYONEACTIVE}

(*
 * Access to this palette is being refused because the palette is already
 * locked by another thread.
 *)
  DDERR_PALETTEBUSY                       = HResult(_MAKE_DDHRESULT + 387);
  {$EXTERNALSYM DDERR_PALETTEBUSY}

(*
 * No src color key specified for this operation.
 *)
  DDERR_COLORKEYNOTSET                    = HResult(_MAKE_DDHRESULT + 400);
  {$EXTERNALSYM DDERR_COLORKEYNOTSET}

(*
 * This surface is already attached to the surface it is being attached to.
 *)
  DDERR_SURFACEALREADYATTACHED            = HResult(_MAKE_DDHRESULT + 410);
  {$EXTERNALSYM DDERR_SURFACEALREADYATTACHED}

(*
 * This surface is already a dependency of the surface it is being made a
 * dependency of.
 *)
  DDERR_SURFACEALREADYDEPENDENT           = HResult(_MAKE_DDHRESULT + 420);
  {$EXTERNALSYM DDERR_SURFACEALREADYDEPENDENT}

(*
 * Access to this surface is being refused because the surface is already
 * locked by another thread.
 *)
  DDERR_SURFACEBUSY                       = HResult(_MAKE_DDHRESULT + 430);
  {$EXTERNALSYM DDERR_SURFACEBUSY}

(*
 * Access to this surface is being refused because no driver exists
 * which can supply a pointer to the surface.
 * This is most likely to happen when attempting to lock the primary
 * surface when no DCI provider is present.
 * Will also happen on attempts to lock an optimized surface.
 *)
  DDERR_CANTLOCKSURFACE                   = HResult(_MAKE_DDHRESULT + 435);
  {$EXTERNALSYM DDERR_CANTLOCKSURFACE}

(*
 * Access to Surface refused because Surface is obscured.
 *)
  DDERR_SURFACEISOBSCURED                 = HResult(_MAKE_DDHRESULT + 440);
  {$EXTERNALSYM DDERR_SURFACEISOBSCURED}

(*
 * Access to this surface is being refused because the surface is gone.
 * The DIRECTDRAWSURFACE object representing this surface should
 * have Restore called on it.
 *)
  DDERR_SURFACELOST                       = HResult(_MAKE_DDHRESULT + 450);
  {$EXTERNALSYM DDERR_SURFACELOST}

(*
 * The requested surface is not attached.
 *)
  DDERR_SURFACENOTATTACHED                = HResult(_MAKE_DDHRESULT + 460);
  {$EXTERNALSYM DDERR_SURFACENOTATTACHED}

(*
 * Height requested by DirectDraw is too large.
 *)
  DDERR_TOOBIGHEIGHT                      = HResult(_MAKE_DDHRESULT + 470);
  {$EXTERNALSYM DDERR_TOOBIGHEIGHT}

(*
 * Size requested by DirectDraw is too large --  The individual height and
 * width are OK.
 *)
  DDERR_TOOBIGSIZE                        = HResult(_MAKE_DDHRESULT + 480);
  {$EXTERNALSYM DDERR_TOOBIGSIZE}

(*
 * Width requested by DirectDraw is too large.
 *)
  DDERR_TOOBIGWIDTH                       = HResult(_MAKE_DDHRESULT + 490);
  {$EXTERNALSYM DDERR_TOOBIGWIDTH}

(*
 * Action not supported.
 *)
  DDERR_UNSUPPORTED                       = E_NOTIMPL;
  {$EXTERNALSYM DDERR_UNSUPPORTED}

(*
 * FOURCC format requested is unsupported by DirectDraw
 *)
  DDERR_UNSUPPORTEDFORMAT                 = HResult(_MAKE_DDHRESULT + 510);
  {$EXTERNALSYM DDERR_UNSUPPORTEDFORMAT}

(*
 * Bitmask in the pixel format requested is unsupported by DirectDraw
 *)
  DDERR_UNSUPPORTEDMASK                   = HResult(_MAKE_DDHRESULT + 520);
  {$EXTERNALSYM DDERR_UNSUPPORTEDMASK}

(*
 * The specified stream contains invalid data
 *)
  DDERR_INVALIDSTREAM                     = HResult(_MAKE_DDHRESULT + 521);
  {$EXTERNALSYM DDERR_INVALIDSTREAM}

(*
 * vertical blank is in progress
 *)
  DDERR_VERTICALBLANKINPROGRESS           = HResult(_MAKE_DDHRESULT + 537);
  {$EXTERNALSYM DDERR_VERTICALBLANKINPROGRESS}

(*
 * Informs DirectDraw that the previous Blt which is transfering information
 * to or from this Surface is incomplete.
 *)
  DDERR_WASSTILLDRAWING                   = HResult(_MAKE_DDHRESULT + 540);
  {$EXTERNALSYM DDERR_WASSTILLDRAWING}


(*
 * The specified surface type requires specification of the COMPLEX flag
 *)
  DDERR_DDSCAPSCOMPLEXREQUIRED            = HResult(_MAKE_DDHRESULT + 542);
  {$EXTERNALSYM DDERR_DDSCAPSCOMPLEXREQUIRED}


(*
 * Rectangle provided was not horizontally aligned on reqd. boundary
 *)
  DDERR_XALIGN                            = HResult(_MAKE_DDHRESULT + 560);
  {$EXTERNALSYM DDERR_XALIGN}

(*
 * The GUID passed to DirectDrawCreate is not a valid DirectDraw driver
 * identifier.
 *)
  DDERR_INVALIDDIRECTDRAWGUID             = HResult(_MAKE_DDHRESULT + 561);
  {$EXTERNALSYM DDERR_INVALIDDIRECTDRAWGUID}

(*
 * A DirectDraw object representing this driver has already been created
 * for this process.
 *)
  DDERR_DIRECTDRAWALREADYCREATED          = HResult(_MAKE_DDHRESULT + 562);
  {$EXTERNALSYM DDERR_DIRECTDRAWALREADYCREATED}

(*
 * A hardware only DirectDraw object creation was attempted but the driver
 * did not support any hardware.
 *)
  DDERR_NODIRECTDRAWHW                    = HResult(_MAKE_DDHRESULT + 563);
  {$EXTERNALSYM DDERR_NODIRECTDRAWHW}

(*
 * this process already has created a primary surface
 *)
  DDERR_PRIMARYSURFACEALREADYEXISTS       = HResult(_MAKE_DDHRESULT + 564);
  {$EXTERNALSYM DDERR_PRIMARYSURFACEALREADYEXISTS}

(*
 * software emulation not available.
 *)
  DDERR_NOEMULATION                       = HResult(_MAKE_DDHRESULT + 565);
  {$EXTERNALSYM DDERR_NOEMULATION}

(*
 * region passed to Clipper::GetClipList is too small.
 *)
  DDERR_REGIONTOOSMALL                    = HResult(_MAKE_DDHRESULT + 566);
  {$EXTERNALSYM DDERR_REGIONTOOSMALL}

(*
 * an attempt was made to set a clip list for a clipper objec that
 * is already monitoring an hwnd.
 *)
  DDERR_CLIPPERISUSINGHWND                = HResult(_MAKE_DDHRESULT + 567);
  {$EXTERNALSYM DDERR_CLIPPERISUSINGHWND}

(*
 * No clipper object attached to surface object
 *)
  DDERR_NOCLIPPERATTACHED                 = HResult(_MAKE_DDHRESULT + 568);
  {$EXTERNALSYM DDERR_NOCLIPPERATTACHED}

(*
 * Clipper notification requires an HWND or
 * no HWND has previously been set as the CooperativeLevel HWND.
 *)
  DDERR_NOHWND                            = HResult(_MAKE_DDHRESULT + 569);
  {$EXTERNALSYM DDERR_NOHWND}

(*
 * HWND used by DirectDraw CooperativeLevel has been subclassed,
 * this prevents DirectDraw from restoring state.
 *)
  DDERR_HWNDSUBCLASSED                    = HResult(_MAKE_DDHRESULT + 570);
  {$EXTERNALSYM DDERR_HWNDSUBCLASSED}

(*
 * The CooperativeLevel HWND has already been set.
 * It can not be reset while the process has surfaces or palettes created.
 *)
  DDERR_HWNDALREADYSET                    = HResult(_MAKE_DDHRESULT + 571);
  {$EXTERNALSYM DDERR_HWNDALREADYSET}

(*
 * No palette object attached to this surface.
 *)
  DDERR_NOPALETTEATTACHED                 = HResult(_MAKE_DDHRESULT + 572);
  {$EXTERNALSYM DDERR_NOPALETTEATTACHED}

(*
 * No hardware support for 16 or 256 color palettes.
 *)
  DDERR_NOPALETTEHW                       = HResult(_MAKE_DDHRESULT + 573);
  {$EXTERNALSYM DDERR_NOPALETTEHW}

(*
 * If a clipper object is attached to the source surface passed into a
 * BltFast call.
 *)
  DDERR_BLTFASTCANTCLIP                   = HResult(_MAKE_DDHRESULT + 574);
  {$EXTERNALSYM DDERR_BLTFASTCANTCLIP}

(*
 * No blter.
 *)
  DDERR_NOBLTHW                           = HResult(_MAKE_DDHRESULT + 575);
  {$EXTERNALSYM DDERR_NOBLTHW}

(*
 * No DirectDraw ROP hardware.
 *)
  DDERR_NODDROPSHW                        = HResult(_MAKE_DDHRESULT + 576);
  {$EXTERNALSYM DDERR_NODDROPSHW}

(*
 * returned when GetOverlayPosition is called on a hidden overlay
 *)
  DDERR_OVERLAYNOTVISIBLE                 = HResult(_MAKE_DDHRESULT + 577);
  {$EXTERNALSYM DDERR_OVERLAYNOTVISIBLE}

(*
 * returned when GetOverlayPosition is called on a overlay that UpdateOverlay
 * has never been called on to establish a destionation.
 *)
  DDERR_NOOVERLAYDEST                     = HResult(_MAKE_DDHRESULT + 578);
  {$EXTERNALSYM DDERR_NOOVERLAYDEST}

(*
 * returned when the position of the overlay on the destionation is no longer
 * legal for that destionation.
 *)
  DDERR_INVALIDPOSITION                   = HResult(_MAKE_DDHRESULT + 579);
  {$EXTERNALSYM DDERR_INVALIDPOSITION}

(*
 * returned when an overlay member is called for a non-overlay surface
 *)
  DDERR_NOTAOVERLAYSURFACE                = HResult(_MAKE_DDHRESULT + 580);
  {$EXTERNALSYM DDERR_NOTAOVERLAYSURFACE}

(*
 * An attempt was made to set the cooperative level when it was already
 * set to exclusive.
 *)
  DDERR_EXCLUSIVEMODEALREADYSET           = HResult(_MAKE_DDHRESULT + 581);
  {$EXTERNALSYM DDERR_EXCLUSIVEMODEALREADYSET}

(*
 * An attempt has been made to flip a surface that is not flippable.
 *)
  DDERR_NOTFLIPPABLE                      = HResult(_MAKE_DDHRESULT + 582);
  {$EXTERNALSYM DDERR_NOTFLIPPABLE}

(*
 * Can't duplicate primary & 3D surfaces, or surfaces that are implicitly
 * created.
 *)
  DDERR_CANTDUPLICATE                     = HResult(_MAKE_DDHRESULT + 583);
  {$EXTERNALSYM DDERR_CANTDUPLICATE}

(*
 * Surface was not locked.  An attempt to unlock a surface that was not
 * locked at all, or by this process, has been attempted.
 *)
  DDERR_NOTLOCKED                         = HResult(_MAKE_DDHRESULT + 584);
  {$EXTERNALSYM DDERR_NOTLOCKED}

(*
 * Windows can not create any more DCs, or a DC was requested for a paltte-indexed
 * surface when the surface had no palette AND the display mode was not palette-indexed
 * (in this case DirectDraw cannot select a proper palette into the DC)
 *)
  DDERR_CANTCREATEDC                      = HResult(_MAKE_DDHRESULT + 585);
  {$EXTERNALSYM DDERR_CANTCREATEDC}

(*
 * No DC was ever created for this surface.
 *)
  DDERR_NODC                              = HResult(_MAKE_DDHRESULT + 586);
  {$EXTERNALSYM DDERR_NODC}

(*
 * This surface can not be restored because it was created in a different
 * mode.
 *)
  DDERR_WRONGMODE                         = HResult(_MAKE_DDHRESULT + 587);
  {$EXTERNALSYM DDERR_WRONGMODE}

(*
 * This surface can not be restored because it is an implicitly created
 * surface.
 *)
  DDERR_IMPLICITLYCREATED                 = HResult(_MAKE_DDHRESULT + 588);
  {$EXTERNALSYM DDERR_IMPLICITLYCREATED}

(*
 * The surface being used is not a palette-based surface
 *)
  DDERR_NOTPALETTIZED                     = HResult(_MAKE_DDHRESULT + 589);
  {$EXTERNALSYM DDERR_NOTPALETTIZED}


(*
 * The display is currently in an unsupported mode
 *)
  DDERR_UNSUPPORTEDMODE                   = HResult(_MAKE_DDHRESULT + 590);
  {$EXTERNALSYM DDERR_UNSUPPORTEDMODE}

(*
 * Operation could not be carried out because there is no mip-map
 * texture mapping hardware present or available.
 *)
  DDERR_NOMIPMAPHW                        = HResult(_MAKE_DDHRESULT + 591);
  {$EXTERNALSYM DDERR_NOMIPMAPHW}

(*
 * The requested action could not be performed because the surface was of
 * the wrong type.
 *)
  DDERR_INVALIDSURFACETYPE                = HResult(_MAKE_DDHRESULT + 592);
  {$EXTERNALSYM DDERR_INVALIDSURFACETYPE}


(*
 * Device does not support optimized surfaces, therefore no video memory optimized surfaces
 *)
  DDERR_NOOPTIMIZEHW                      = HResult(_MAKE_DDHRESULT + 600);
  {$EXTERNALSYM DDERR_NOOPTIMIZEHW}

(*
 * Surface is an optimized surface, but has not yet been allocated any memory
 *)
  DDERR_NOTLOADED                         = HResult(_MAKE_DDHRESULT + 601);
  {$EXTERNALSYM DDERR_NOTLOADED}

(*
 * Attempt was made to create or set a device window without first setting
 * the focus window
 *)
  DDERR_NOFOCUSWINDOW                     = HResult(_MAKE_DDHRESULT + 602);
  {$EXTERNALSYM DDERR_NOFOCUSWINDOW}

(*
 * Attempt was made to set a palette on a mipmap sublevel
 *)
  DDERR_NOTONMIPMAPSUBLEVEL               = HResult(_MAKE_DDHRESULT + 603);
  {$EXTERNALSYM DDERR_NOTONMIPMAPSUBLEVEL}

(*
 * A DC has already been returned for this surface. Only one DC can be
 * retrieved per surface.
 *)
  DDERR_DCALREADYCREATED                  = HResult(_MAKE_DDHRESULT + 620);
  {$EXTERNALSYM DDERR_DCALREADYCREATED}

(*
 * An attempt was made to allocate non-local video memory from a device
 * that does not support non-local video memory.
 *)
  DDERR_NONONLOCALVIDMEM                  = HResult(_MAKE_DDHRESULT + 630);
  {$EXTERNALSYM DDERR_NONONLOCALVIDMEM}

(*
 * The attempt to page lock a surface failed.
 *)
  DDERR_CANTPAGELOCK                      = HResult(_MAKE_DDHRESULT + 640);
  {$EXTERNALSYM DDERR_CANTPAGELOCK}


(*
 * The attempt to page unlock a surface failed.
 *)
  DDERR_CANTPAGEUNLOCK                    = HResult(_MAKE_DDHRESULT + 660);
  {$EXTERNALSYM DDERR_CANTPAGEUNLOCK}

(*
 * An attempt was made to page unlock a surface with no outstanding page locks.
 *)
  DDERR_NOTPAGELOCKED                     = HResult(_MAKE_DDHRESULT + 680);
  {$EXTERNALSYM DDERR_NOTPAGELOCKED}

(*
 * There is more data available than the specified buffer size could hold
 *)
  DDERR_MOREDATA                          = HResult(_MAKE_DDHRESULT + 690);
  {$EXTERNALSYM DDERR_MOREDATA}

(*
 * The data has expired and is therefore no longer valid.
 *)
  DDERR_EXPIRED                           = HResult(_MAKE_DDHRESULT + 691);
  {$EXTERNALSYM DDERR_EXPIRED}

(*
 * The mode test has finished executing.
 *)
 DDERR_TESTFINISHED                       = HResult(_MAKE_DDHRESULT + 692);
 {$EXTERNALSYM DDERR_TESTFINISHED}

(*
 * The mode test has switched to a new mode.
 *)
 DDERR_NEWMODE                            = HResult(_MAKE_DDHRESULT + 693);
 {$EXTERNALSYM DDERR_NEWMODE}

(*
 * D3D has not yet been initialized.
 *)
 DDERR_D3DNOTINITIALIZED                  = HResult(_MAKE_DDHRESULT + 694);
 {$EXTERNALSYM DDERR_D3DNOTINITIALIZED}

(*
 * The video port is not active
 *)
  DDERR_VIDEONOTACTIVE                    = HResult(_MAKE_DDHRESULT + 695);
  {$EXTERNALSYM DDERR_VIDEONOTACTIVE}

(*
 * The monitor does not have EDID data.
 *)
 DDERR_NOMONITORINFORMATION               = HResult(_MAKE_DDHRESULT + 696);
 {$EXTERNALSYM DDERR_NOMONITORINFORMATION}

(*
 * The driver does not enumerate display mode refresh rates.
 *)
 DDERR_NODRIVERSUPPORT                    = HResult(_MAKE_DDHRESULT + 697);
 {$EXTERNALSYM DDERR_NODRIVERSUPPORT}

(*
 * Surfaces created by one direct draw device cannot be used directly by
 * another direct draw device.
 *)
  DDERR_DEVICEDOESNTOWNSURFACE            = HResult(_MAKE_DDHRESULT + 699);
  {$EXTERNALSYM DDERR_DEVICEDOESNTOWNSURFACE}



(*
 * An attempt was made to invoke an interface member of a DirectDraw object
 * created by CoCreateInstance() before it was initialized.
 *)
  DDERR_NOTINITIALIZED                    = CO_E_NOTINITIALIZED;
  {$EXTERNALSYM DDERR_NOTINITIALIZED}

(* Alpha bit depth constants *)



(*
 * API's
 *)

const
  DirectDrawDll = 'ddraw.dll';

type
  HMonitor = THandle;
  {$EXTERNALSYM HMonitor}

  TDDEnumCallbackA = function (lpGUID: PGUID; lpDriverDescription: PAnsiChar;
      lpDriverName: PAnsiChar; lpContext: Pointer): BOOL; stdcall;
  {$EXTERNALSYM TDDEnumCallbackA}
  TDDEnumCallbackW = function (lpGUID: PGUID; lpDriverDescription: PWideChar;
      lpDriverName: PWideChar; lpContext: Pointer): BOOL; stdcall;
  {$EXTERNALSYM TDDEnumCallbackW}
  TDDEnumCallback = function (lpGUID: PGUID; lpDriverDescription: PChar;
      lpDriverName: PChar; lpContext: Pointer): BOOL; stdcall;
  {$EXTERNALSYM TDDEnumCallback}

  TDDEnumCallbackExA = function (lpGUID: PGUID; lpDriverDescription: PAnsiChar;
      lpDriverName: PAnsiChar; lpContext: Pointer; Monitor: HMonitor): BOOL;
      stdcall;
  {$EXTERNALSYM TDDEnumCallbackExA}
  TDDEnumCallbackExW = function (lpGUID: PGUID; lpDriverDescription: PWideChar;
      lpDriverName: PWideChar; lpContext: Pointer; Monitor: HMonitor): BOOL;
      stdcall;
  {$EXTERNALSYM TDDEnumCallbackExW}
  TDDEnumCallbackEx = function (lpGUID: PGUID; lpDriverDescription: PChar;
      lpDriverName: PChar; lpContext: Pointer; Monitor: HMonitor): BOOL;
      stdcall;
  {$EXTERNALSYM TDDEnumCallbackEx}

function DirectDrawLoaded: Boolean;
function UnLoadDirectDraw: Boolean;
function LoadDirectDraw: Boolean;

{$IFDEF DIRECTDRAW_DYNAMIC_LINK}
var
  DirectDrawEnumerateA : function (lpCallback: TDDEnumCallbackA;
       lpContext: Pointer): HResult; stdcall;
  {$EXTERNALSYM DirectDrawEnumerateA}
  DirectDrawEnumerateW : function (lpCallback: TDDEnumCallbackW;
       lpContext: Pointer): HResult; stdcall;
  {$EXTERNALSYM DirectDrawEnumerateW}
  DirectDrawEnumerate  : function (lpCallback: TDDEnumCallback;
       lpContext: Pointer): HResult; stdcall;
  {$EXTERNALSYM DirectDrawEnumerate}

  DirectDrawEnumerateExA : function (lpCallback: TDDEnumCallbackExA;
       lpContext: Pointer; dwFlags: DWORD): HResult; stdcall;
  {$EXTERNALSYM DirectDrawEnumerateExA}
  DirectDrawEnumerateExW : function (lpCallback: TDDEnumCallbackExW;
       lpContext: Pointer; dwFlags: DWORD): HResult; stdcall;
  {$EXTERNALSYM DirectDrawEnumerateExW}
  DirectDrawEnumerateEx  : function (lpCallback: TDDEnumCallbackEx;
       lpContext: Pointer; dwFlags: DWORD): HResult; stdcall;
  {$EXTERNALSYM DirectDrawEnumerateEx}

  DirectDrawCreate : function (lpGUID: PGUID;
       out lplpDD: IDirectDraw;
       pUnkOuter: IUnknown): HResult; stdcall;
  {$EXTERNALSYM DirectDrawCreate}
  DirectDrawCreateEx : function  (lpGUID: PGUID;
       out lplpDD: IDirectDraw7; const iid: TGUID;
       pUnkOuter: IUnknown): HResult; stdcall;
  {$EXTERNALSYM DirectDrawCreateEx}
  DirectDrawCreateClipper : function (dwFlags: DWORD;
       out lplpDDClipper: IDirectDrawClipper;
       pUnkOuter: IUnknown): HResult; stdcall;
  {$EXTERNALSYM DirectDrawCreateClipper}
{$ELSE}

function DirectDrawEnumerateA(lpCallback: TDDEnumCallbackA; lpContext: Pointer): HResult; stdcall; external DirectDrawDll;
{$EXTERNALSYM DirectDrawEnumerateA}
function DirectDrawEnumerateW(lpCallback: TDDEnumCallbackW; lpContext: Pointer): HResult; stdcall; external DirectDrawDll;
{$EXTERNALSYM DirectDrawEnumerateW}
function DirectDrawEnumerate(lpCallback: TDDEnumCallback; lpContext: Pointer): HResult; stdcall;
  external DirectDrawDll name {$IFDEF UNICODE}'DirectDrawEnumerateW'{$ELSE}'DirectDrawEnumerateA'{$ENDIF};
{$EXTERNALSYM DirectDrawEnumerate}

function DirectDrawEnumerateExA(lpCallback: TDDEnumCallbackExA; lpContext: Pointer; dwFlags: DWORD): HResult; stdcall; external DirectDrawDll;
{$EXTERNALSYM DirectDrawEnumerateExA}
function DirectDrawEnumerateExW(lpCallback: TDDEnumCallbackExW; lpContext: Pointer; dwFlags: DWORD): HResult; stdcall; external DirectDrawDll;
{$EXTERNALSYM DirectDrawEnumerateExW}
function DirectDrawEnumerateEx(lpCallback: TDDEnumCallbackEx; lpContext: Pointer; dwFlags: DWORD): HResult; stdcall;
  external DirectDrawDll name {$IFDEF UNICODE}'DirectDrawEnumerateExW'{$ELSE}'DirectDrawEnumerateExA'{$ENDIF};
{$EXTERNALSYM DirectDrawEnumerateEx}

function DirectDrawCreate(lpGUID: PGUID; out lplpDD: IDirectDraw;
    pUnkOuter: IUnknown): HResult; stdcall; external DirectDrawDll;
{$EXTERNALSYM DirectDrawCreate}

function DirectDrawCreateEx(lpGUID: PGUID; out lplpDD: IDirectDraw7;
    const iid: TGUID; pUnkOuter: IUnknown): HResult; stdcall; external DirectDrawDll;
{$EXTERNALSYM DirectDrawCreateEx}

function DirectDrawCreateClipper(dwFlags: DWORD; out lplpDDClipper: IDirectDrawClipper;
    pUnkOuter: IUnknown): HResult; stdcall; external DirectDrawDll;
{$EXTERNALSYM DirectDrawCreateClipper}

{$ENDIF}

const
(*
 * Flags for DirectDrawEnumerateEx
 * DirectDrawEnumerateEx supercedes DirectDrawEnumerate. You must use GetProcAddress to
 * obtain a function pointer (of type LPDIRECTDRAWENUMERATEEX) to DirectDrawEnumerateEx.
 * By default, only the primary display device is enumerated.
 * DirectDrawEnumerate is equivalent to DirectDrawEnumerate(,,DDENUM_NONDISPLAYDEVICES)
 *)

(*
 * This flag causes enumeration of any GDI display devices which are part of
 * the Windows Desktop
 *)
  DDENUM_ATTACHEDSECONDARYDEVICES     = $00000001;
  {$EXTERNALSYM DDENUM_ATTACHEDSECONDARYDEVICES}

(*
 * This flag causes enumeration of any GDI display devices which are not
 * part of the Windows Desktop
 *)
  DDENUM_DETACHEDSECONDARYDEVICES     = $00000002;
  {$EXTERNALSYM DDENUM_DETACHEDSECONDARYDEVICES}

(*
 * This flag causes enumeration of non-display devices
 *)
  DDENUM_NONDISPLAYDEVICES            = $00000004;
  {$EXTERNALSYM DDENUM_NONDISPLAYDEVICES}


  REGSTR_KEY_DDHW_DESCRIPTION = 'Description';
  {$EXTERNALSYM REGSTR_KEY_DDHW_DESCRIPTION}
  REGSTR_KEY_DDHW_DRIVERNAME  = 'DriverName';
  {$EXTERNALSYM REGSTR_KEY_DDHW_DRIVERNAME}
  REGSTR_PATH_DDHW            = 'Hardware\DirectDrawDrivers';
  {$EXTERNALSYM REGSTR_PATH_DDHW}

  DDCREATE_HARDWAREONLY       = $00000001;
  {$EXTERNALSYM DDCREATE_HARDWAREONLY}
  DDCREATE_EMULATIONONLY      = $00000002;
  {$EXTERNALSYM DDCREATE_EMULATIONONLY}

(*
 * Flags for the IDirectDraw4::GetDeviceIdentifier method
 *)

(*
 * This flag causes GetDeviceIdentifier to return information about the host (typically 2D) adapter in a system equipped
 * with a stacked secondary 3D adapter. Such an adapter appears to the application as if it were part of the
 * host adapter, but is typically physcially located on a separate card. The stacked secondary's information is
 * returned when GetDeviceIdentifier's dwFlags field is zero, since this most accurately reflects the qualities
 * of the DirectDraw object involved.
 *)
  DDGDI_GETHOSTIDENTIFIER         = $00000001;
  {$EXTERNALSYM DDGDI_GETHOSTIDENTIFIER}

(*
 * Macros for interpretting DDEVICEIDENTIFIER2.dwWHQLLevel
 *)
function GET_WHQL_YEAR(dwWHQLLevel: DWORD): DWORD;
{$EXTERNALSYM GET_WHQL_YEAR}
function GET_WHQL_MONTH(dwWHQLLevel: DWORD): DWORD;
{$EXTERNALSYM GET_WHQL_MONTH}
function GET_WHQL_DAY(dwWHQLLevel: DWORD): DWORD;
{$EXTERNALSYM GET_WHQL_DAY}


(*==========================================================================;
 *
 *  Copyright (C) 1996-1997 Microsoft Corporation.  All Rights Reserved.
 *
 *  File:	dvp.h
 *  Content:	DirectDrawVideoPort include file
 *
 ***************************************************************************)

const
(*
 * GUIDS used by DirectDrawVideoPort objects
 *)

(*
  IID_IDDVideoPortContainer,
  IID_IDirectDrawVideoPort,
  IID_IDirectDrawVideoPortNotify
    - are defined later in Delphi header
*)

  DDVPTYPE_E_HREFH_VREFH: TGUID = (D1:$54F39980;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  {$EXTERNALSYM DDVPTYPE_E_HREFH_VREFH}
  DDVPTYPE_E_HREFH_VREFL: TGUID = (D1:$92783220;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  {$EXTERNALSYM DDVPTYPE_E_HREFH_VREFL}
  DDVPTYPE_E_HREFL_VREFH: TGUID = (D1:$A07A02E0;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  {$EXTERNALSYM DDVPTYPE_E_HREFL_VREFH}
  DDVPTYPE_E_HREFL_VREFL: TGUID = (D1:$E09C77E0;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  {$EXTERNALSYM DDVPTYPE_E_HREFL_VREFL}
  DDVPTYPE_CCIR656:       TGUID = (D1:$FCA326A0;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  {$EXTERNALSYM DDVPTYPE_CCIR656}
  DDVPTYPE_BROOKTREE:     TGUID = (D1:$1352A560;D2:$DA61;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  {$EXTERNALSYM DDVPTYPE_BROOKTREE}
  DDVPTYPE_PHILIPS:       TGUID = (D1:$332CF160;D2:$DA61;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  {$EXTERNALSYM DDVPTYPE_PHILIPS}


(*
 * These definitions are required to allow polymorphic structure members (i.e. those
 * that are referred to both as DWORDs and as pointers) to resolve into a type
 * of correct size to hold the largest of those two types (i.e. pointer) on 64 bit
 * systems. For 32 bit environments, ULONG_PTR resolves to a DWORD.
 *)
type
  ULONG_PTR = DWORD;
  {$EXTERNALSYM ULONG_PTR}

(*============================================================================
 *
 * DirectDraw Structures
 *
 * Various structures used to invoke DirectDraw.
 *
 *==========================================================================*)

type

(*
 * DDVIDEOPORTCONNECT
 *)
  PDDVideoPortConnect = ^TDDVideoPortConnect;
  _DDVIDEOPORTCONNECT = packed record
    dwSize: DWORD;              // size of the TDDVideoPortConnect structure
    dwPortWidth: DWORD;         // Width of the video port
    guidTypeID: TGUID;          // Description of video port connection
    dwFlags: DWORD;             // Connection flags
    dwReserved1: ULONG_PTR;     // Reserved, set to zero.
  end;
  {$EXTERNALSYM _DDVIDEOPORTCONNECT}
  DDVIDEOPORTCONNECT = _DDVIDEOPORTCONNECT;
  {$EXTERNALSYM DDVIDEOPORTCONNECT}
  TDDVideoPortConnect = _DDVIDEOPORTCONNECT;

(*
 * DDVIDEOPORTCAPS
 *)
  PDDVideoPortCaps = ^TDDVideoPortCaps;
  _DDVIDEOPORTCAPS = packed record
    dwSize: DWORD;                          // size of the TDDVideoPortCaps structure
    dwFlags: DWORD;                         // indicates which fields contain data
    dwMaxWidth: DWORD;                      // max width of the video port field
    dwMaxVBIWidth: DWORD;                   // max width of the VBI data
    dwMaxHeight: DWORD;                     // max height of the video port field
    dwVideoPortID: DWORD;                   // Video port ID (0 - (dwMaxVideoPorts -1))
    dwCaps: DWORD;                          // Video port capabilities
    dwFX: DWORD;                            // More video port capabilities
    dwNumAutoFlipSurfaces: DWORD;           // Number of autoflippable surfaces
    dwAlignVideoPortBoundary: DWORD;        // Byte restriction of placement within the surface
    dwAlignVideoPortPrescaleWidth: DWORD;   // Byte restriction of width after prescaling
    dwAlignVideoPortCropBoundary: DWORD;    // Byte restriction of left cropping
    dwAlignVideoPortCropWidth: DWORD;       // Byte restriction of cropping width
    dwPreshrinkXStep: DWORD;                // Width can be shrunk in steps of 1/x
    dwPreshrinkYStep: DWORD;                // Height can be shrunk in steps of 1/x
    dwNumVBIAutoFlipSurfaces: DWORD;        // Number of VBI autoflippable surfaces allowed
    dwNumPreferredAutoflip: DWORD;          // Optimal number of autoflippable surfaces for hardware
    wNumFilterTapsX: Word;                  // Number of taps the prescaler uses in the X direction (0 - no prescale, 1 - replication, etc.)
    wNumFilterTapsY: Word;                  // Number of taps the prescaler uses in the Y direction (0 - no prescale, 1 - replication, etc.)
  end;
  {$EXTERNALSYM _DDVIDEOPORTCAPS}
  DDVIDEOPORTCAPS = _DDVIDEOPORTCAPS;
  {$EXTERNALSYM DDVIDEOPORTCAPS}
  TDDVideoPortCaps = _DDVIDEOPORTCAPS;

const
(*
 * The dwMaxWidth and dwMaxVBIWidth members are valid
 *)
  DDVPD_WIDTH = $00000001;
  {$EXTERNALSYM DDVPD_WIDTH}

(*
 * The dwMaxHeight member is valid
 *)
  DDVPD_HEIGHT = $00000002;
  {$EXTERNALSYM DDVPD_HEIGHT}

(*
 * The dwVideoPortID member is valid
 *)
  DDVPD_ID = $00000004;
  {$EXTERNALSYM DDVPD_ID}

(*
 * The dwCaps member is valid
 *)
  DDVPD_CAPS = $00000008;
  {$EXTERNALSYM DDVPD_CAPS}

(*
 * The dwFX member is valid
 *)
  DDVPD_FX = $00000010;
  {$EXTERNALSYM DDVPD_FX}

(*
 * The dwNumAutoFlipSurfaces member is valid
 *)
  DDVPD_AUTOFLIP = $00000020;
  {$EXTERNALSYM DDVPD_AUTOFLIP}

(*
 * All of the alignment members are valid
 *)
  DDVPD_ALIGN = $00000040;
  {$EXTERNALSYM DDVPD_ALIGN}

(*
 * The dwNumPreferredAutoflip member is valid
 *)
  DDVPD_PREFERREDAUTOFLIP = $00000080;
  {$EXTERNALSYM DDVPD_PREFERREDAUTOFLIP}

(*
 * The wNumFilterTapsX and wNumFilterTapsY fields are valid
 *)
  DDVPD_FILTERQUALITY     = $00000100;
  {$EXTERNALSYM DDVPD_FILTERQUALITY}

type
(*
 * DDVIDEOPORTDESC
 *)
  PDDVideoPortDesc = ^TDDVideoPortDesc;
  _DDVIDEOPORTDESC = packed record
    dwSize: DWORD;                       // size of the TDDVideoPortDesc structure
    dwFieldWidth: DWORD;                 // width of the video port field
    dwVBIWidth: DWORD;                   // width of the VBI data
    dwFieldHeight: DWORD;                // height of the video port field
    dwMicrosecondsPerField: DWORD;       // Microseconds per video field
    dwMaxPixelsPerSecond: DWORD;         // Maximum pixel rate per second
    dwVideoPortID: DWORD;                // Video port ID (0 - (dwMaxVideoPorts -1))
    dwReserved1: DWORD;                  // Reserved for future use - set to zero (struct padding)
    VideoPortType: TDDVideoPortConnect;  // Description of video port connection
    dwReserved2: DWORD;                  // Reserved for future use - set to zero
    dwReserved3: DWORD;                  // Reserved for future use - set to zero
  end;
  {$EXTERNALSYM _DDVIDEOPORTDESC}
  DDVIDEOPORTDESC = _DDVIDEOPORTDESC;
  {$EXTERNALSYM DDVIDEOPORTDESC}
  TDDVideoPortDesc = _DDVIDEOPORTDESC;

(*
 * DDVIDEOPORTINFO
 *)
  PDDVideoPortInfo = ^TDDVideoPortInfo;
  _DDVIDEOPORTINFO = packed record
    dwSize: DWORD;                            // Size of the structure
    dwOriginX: DWORD;                         // Placement of the video data within the surface.
    dwOriginY: DWORD;                         // Placement of the video data within the surface.
    dwVPFlags: DWORD;                         // Video port options
    rCrop: TRect;                             // Cropping rectangle (optional).
    dwPrescaleWidth: DWORD;                   // Determines pre-scaling/zooming in the X direction (optional).
    dwPrescaleHeight: DWORD;                  // Determines pre-scaling/zooming in the Y direction (optional).
    lpddpfInputFormat: PDDPixelFormat;        // Video format written to the video port
    lpddpfVBIInputFormat: PDDPixelFormat;     // Input format of the VBI data
    lpddpfVBIOutputFormat: PDDPixelFormat;    // Output format of the data
    dwVBIHeight: DWORD;                       // Specifies the number of lines of data within the vertical blanking interval.
    dwReserved1: DWORD;                       // Reserved for future use - set to zero
    dwReserved2: DWORD;                       // Reserved for future use - set to zero
  end;
  {$EXTERNALSYM _DDVIDEOPORTINFO}
  DDVIDEOPORTINFO = _DDVIDEOPORTINFO;
  {$EXTERNALSYM DDVIDEOPORTINFO}
  TDDVideoPortInfo = _DDVIDEOPORTINFO;

(*
 * DDVIDEOPORTBANDWIDTH
 *)
  PDDVideoPortBandWidth = ^TDDVideoPortBandWidth;
  _DDVIDEOPORTBANDWIDTH = packed record
    dwSize: DWORD;                 // Size of the structure
    dwCaps: DWORD;
    dwOverlay: DWORD;              // Zoom factor at which overlay is supported
    dwColorkey: DWORD;             // Zoom factor at which overlay w/ colorkey is supported
    dwYInterpolate: DWORD;         // Zoom factor at which overlay w/ Y interpolation is supported
    dwYInterpAndColorkey: DWORD;   // Zoom factor at which ovelray w/ Y interpolation and colorkeying is supported
    dwReserved1: DWORD;            // Reserved for future use - set to zero
    dwReserved2: DWORD;            // Reserved for future use - set to zero
  end;
  {$EXTERNALSYM _DDVIDEOPORTBANDWIDTH}
  DDVIDEOPORTBANDWIDTH = _DDVIDEOPORTBANDWIDTH;
  {$EXTERNALSYM DDVIDEOPORTBANDWIDTH}
  TDDVideoPortBandWidth = _DDVIDEOPORTBANDWIDTH;

(*
 * DDVIDEOPORTSTATUS
 *)
  PDDVideoPortStatus = ^TDDVideoPortStatus;
  _DDVIDEOPORTSTATUS = record
    dwSize: DWORD;                       // Size of the structure
    bInUse: BOOL;                        // TRUE if video port is currently being used
    dwFlags: DWORD;                      // Currently not used
    dwReserved1: DWORD;                  // Reserved for future use
    VideoPortType: TDDVideoPortConnect;  // Information about the connection
    dwReserved2: DWORD;                  // Reserved for future use
    dwReserved3: DWORD;                  // Reserved for future use
  end;
  {$EXTERNALSYM _DDVIDEOPORTSTATUS}
  DDVIDEOPORTSTATUS = _DDVIDEOPORTSTATUS;
  {$EXTERNALSYM DDVIDEOPORTSTATUS}
  TDDVideoPortStatus = _DDVIDEOPORTSTATUS;

(*
 * DDVIDEOPORTNOTIFY
 *)
  PDDVideoPortNotify = ^TDDVideoPortNotify;
  _DDVIDEOPORTNOTIFY = packed record
    ApproximateTimeStamp: Int64;        // Timestamp in the event notification
    lField: Longint;                    // 0 if even, 1 if odd, -1 if unknown
    dwSurfaceIndex: Longword;           // Index in the surface chain of the surface that received the sample
    lDone: Longint;                     // Call InterlockedIncrement on this when done with sample
  end;
  {$EXTERNALSYM _DDVIDEOPORTNOTIFY}
  DDVIDEOPORTNOTIFY = _DDVIDEOPORTNOTIFY;
  {$EXTERNALSYM DDVIDEOPORTNOTIFY}
  TDDVideoPortNotify = _DDVIDEOPORTNOTIFY;


(*============================================================================
 *
 * Video Port Flags
 *
 * All flags are bit flags.
 *
 *==========================================================================*)
const
(****************************************************************************
 *
 * VIDEOPORT DDVIDEOPORTCONNECT / TDDVideoPortConnect FLAGS
 *
 ****************************************************************************)

(*
 * When this is set by the driver and passed to the client, this
 * indicates that the video port is capable of double clocking the data.
 * When this is set by the client, this indicates that the video port
 * should enable double clocking.  This flag is only valid with external
 * syncs.
 *)
  DDVPCONNECT_DOUBLECLOCK = $00000001;
  {$EXTERNALSYM DDVPCONNECT_DOUBLECLOCK}

(*
 * When this is set by the driver and passed to the client, this
 * indicates that the video port is capable of using an external VACT
 * signal. When this is set by the client, this indicates that the
 * video port should use the external VACT signal.
 *)
  DDVPCONNECT_VACT = $00000002;
  {$EXTERNALSYM DDVPCONNECT_VACT}

(*
 * When this is set by the driver and passed to the client, this
 * indicates that the video port is capable of treating even fields
 * like odd fields and visa versa.  When this is set by the client,
 * this indicates that the video port should treat even fields like odd
 * fields.
 *)
  DDVPCONNECT_INVERTPOLARITY = $00000004;
  {$EXTERNALSYM DDVPCONNECT_INVERTPOLARITY}

(*
 * Indicates that any data written to the video port during the VREF
 * period will not be written into the frame buffer. This flag is read only.
 *)
  DDVPCONNECT_DISCARDSVREFDATA = $00000008;
  {$EXTERNALSYM DDVPCONNECT_DISCARDSVREFDATA}

(*
 * When this is set be the driver and passed to the client, this
 * indicates that the device will write half lines into the frame buffer
 * if half lines are provided by the decoder.  If this is set by the client,
 * this indicates that the decoder will be supplying half lines.
 *)
  DDVPCONNECT_HALFLINE = $00000010;
  {$EXTERNALSYM DDVPCONNECT_HALFLINE}

(*
 * Indicates that the signal is interlaced. This flag is only
 * set by the client.
 *)
  DDVPCONNECT_INTERLACED = $00000020;
  {$EXTERNALSYM DDVPCONNECT_INTERLACED}

(*
 * Indicates that video port is shareable and that this video port
 * will use the even fields.  This flag is only set by the client.
 *)
  DDVPCONNECT_SHAREEVEN = $00000040;
  {$EXTERNALSYM DDVPCONNECT_SHAREEVEN}

(*
 * Indicates that video port is shareable and that this video port
 * will use the odd fields.  This flag is only set by the client.
 *)
  DDVPCONNECT_SHAREODD = $00000080;
  {$EXTERNALSYM DDVPCONNECT_SHAREODD}

(****************************************************************************
 *
 * VIDEOPORT DDVIDEOPORTDESC / TDDVideoPortDesc CAPS
 *
 ****************************************************************************)

(*
 * Flip can be performed automatically to avoid tearing.
 *)
  DDVPCAPS_AUTOFLIP = $00000001;
  {$EXTERNALSYM DDVPCAPS_AUTOFLIP}

(*
 * Supports interlaced video
 *)
  DDVPCAPS_INTERLACED = $00000002;
  {$EXTERNALSYM DDVPCAPS_INTERLACED}

(*
 * Supports non-interlaced video
 *)
  DDVPCAPS_NONINTERLACED = $00000004;
  {$EXTERNALSYM DDVPCAPS_NONINTERLACED}

(*
 * Indicates that the device can return whether the current field
 * of an interlaced signal is even or odd.
 *)
  DDVPCAPS_READBACKFIELD = $00000008;
  {$EXTERNALSYM DDVPCAPS_READBACKFIELD}

(*
 * Indicates that the device can return the current line of video
 * being written into the frame buffer.
 *)
  DDVPCAPS_READBACKLINE = $00000010;
  {$EXTERNALSYM DDVPCAPS_READBACKLINE}

(*
 * Allows two gen-locked video streams to share a single video port,
 * where one stream uses the even fields and the other uses the odd
 * fields. Separate parameters (including address, scaling,
 * cropping, etc.) are maintained for both fields.)
 *)
  DDVPCAPS_SHAREABLE = $00000020;
  {$EXTERNALSYM DDVPCAPS_SHAREABLE}

(*
 * Even fields of video can be automatically discarded.
 *)
  DDVPCAPS_SKIPEVENFIELDS = $00000040;
  {$EXTERNALSYM DDVPCAPS_SKIPEVENFIELDS}

(*
 * Odd fields of video can be automatically discarded.
 *)
  DDVPCAPS_SKIPODDFIELDS = $00000080;
  {$EXTERNALSYM DDVPCAPS_SKIPODDFIELDS}

(*
 * Indicates that the device is capable of driving the graphics
 * VSYNC with the video port VSYNC.
 *)
  DDVPCAPS_SYNCMASTER = $00000100;
  {$EXTERNALSYM DDVPCAPS_SYNCMASTER}

(*
 * Indicates that data within the vertical blanking interval can
 * be written to a different surface.
 *)
  DDVPCAPS_VBISURFACE = $00000200;
  {$EXTERNALSYM DDVPCAPS_VBISURFACE}

(*
 * Indicates that the video port can perform color operations
 * on the incoming data before it is written to the frame buffer.
 *)
  DDVPCAPS_COLORCONTROL = $00000400;
  {$EXTERNALSYM DDVPCAPS_COLORCONTROL}

(*
 * Indicates that the video port can accept VBI data in a different
 * width or format than the regular video data.
 *)
  DDVPCAPS_OVERSAMPLEDVBI = $00000800;
  {$EXTERNALSYM DDVPCAPS_OVERSAMPLEDVBI}

(*
 * Indicates that the video port can write data directly to system memory
 *)
  DDVPCAPS_SYSTEMMEMORY = $00001000;
  {$EXTERNALSYM DDVPCAPS_SYSTEMMEMORY}

(*
 * Indicates that the VBI and video portions of the video stream can
 * be controlled by an independent processes.
 *)
  DDVPCAPS_VBIANDVIDEOINDEPENDENT	= $00002000;
  {$EXTERNALSYM DDVPCAPS_VBIANDVIDEOINDEPENDENT}

(*
 * Indicates that the video port contains high quality hardware
 * de-interlacing hardware that should be used instead of the
 * bob/weave algorithms.
 *)
  DDVPCAPS_HARDWAREDEINTERLACE		= $00004000;
  {$EXTERNALSYM DDVPCAPS_HARDWAREDEINTERLACE}


(****************************************************************************
 *
 * VIDEOPORT DDVIDEOPORTDESC / TDDVideoPortDesc FX
 *
 ****************************************************************************)

(*
 * Limited cropping is available to crop out the vertical interval data.
 *)
  DDVPFX_CROPTOPDATA = $00000001;
  {$EXTERNALSYM DDVPFX_CROPTOPDATA}

(*
 * Incoming data can be cropped in the X direction before it is written
 * to the surface.
 *)
  DDVPFX_CROPX = $00000002;
  {$EXTERNALSYM DDVPFX_CROPX}

(*
 * Incoming data can be cropped in the Y direction before it is written
 * to the surface.
 *)
  DDVPFX_CROPY = $00000004;
  {$EXTERNALSYM DDVPFX_CROPY}

(*
 * Supports interleaving interlaced fields in memory.
 *)
  DDVPFX_INTERLEAVE = $00000008;
  {$EXTERNALSYM DDVPFX_INTERLEAVE}

(*
 * Supports mirroring left to right as the video data is written
 * into the frame buffer.
 *)
  DDVPFX_MIRRORLEFTRIGHT = $00000010;
  {$EXTERNALSYM DDVPFX_MIRRORLEFTRIGHT}

(*
 * Supports mirroring top to bottom as the video data is written
 * into the frame buffer.
 *)
  DDVPFX_MIRRORUPDOWN = $00000020;
  {$EXTERNALSYM DDVPFX_MIRRORUPDOWN}

(*
 * Data can be arbitrarily shrunk in the X direction before it
 * is written to the surface.
 *)
  DDVPFX_PRESHRINKX = $00000040;
  {$EXTERNALSYM DDVPFX_PRESHRINKX}

(*
 * Data can be arbitrarily shrunk in the Y direction before it
 * is written to the surface.
 *)
  DDVPFX_PRESHRINKY = $00000080;
  {$EXTERNALSYM DDVPFX_PRESHRINKY}

(*
 * Data can be binary shrunk (1/2, 1/4, 1/8, etc.) in the X
 * direction before it is written to the surface.
 *)
  DDVPFX_PRESHRINKXB = $00000100;
  {$EXTERNALSYM DDVPFX_PRESHRINKXB}

(*
 * Data can be binary shrunk (1/2, 1/4, 1/8, etc.) in the Y
 * direction before it is written to the surface.
 *)
  DDVPFX_PRESHRINKYB = $00000200;
  {$EXTERNALSYM DDVPFX_PRESHRINKYB}

(*
 * Data can be shrunk in increments of 1/x in the X direction
 * (where X is specified in the TDDVideoPortCaps.dwPreshrinkXStep)
 * before it is written to the surface.
 *)
  DDVPFX_PRESHRINKXS = $00000400;
  {$EXTERNALSYM DDVPFX_PRESHRINKXS}

(*
 * Data can be shrunk in increments of 1/x in the Y direction
 * (where X is specified in the TDDVideoPortCaps.dwPreshrinkYStep)
 * before it is written to the surface.
 *)
  DDVPFX_PRESHRINKYS = $00000800;
  {$EXTERNALSYM DDVPFX_PRESHRINKYS}

(*
 * Data can be arbitrarily stretched in the X direction before
 * it is written to the surface.
 *)
  DDVPFX_PRESTRETCHX = $00001000;
  {$EXTERNALSYM DDVPFX_PRESTRETCHX}

(*
 * Data can be arbitrarily stretched in the Y direction before
 * it is written to the surface.
 *)
  DDVPFX_PRESTRETCHY = $00002000;
  {$EXTERNALSYM DDVPFX_PRESTRETCHY}

(*
 * Data can be integer stretched in the X direction before it is
 * written to the surface.
 *)
  DDVPFX_PRESTRETCHXN = $00004000;
  {$EXTERNALSYM DDVPFX_PRESTRETCHXN}

(*
 * Data can be integer stretched in the Y direction before it is
 * written to the surface.
 *)
  DDVPFX_PRESTRETCHYN = $00008000;
  {$EXTERNALSYM DDVPFX_PRESTRETCHYN}

(*
 * Indicates that data within the vertical blanking interval can
 * be converted independently of the remaining video data.
 *)
  DDVPFX_VBICONVERT = $00010000;
  {$EXTERNALSYM DDVPFX_VBICONVERT}

(*
 * Indicates that scaling can be disabled for data within the
 * vertical blanking interval.
 *)
  DDVPFX_VBINOSCALE = $00020000;
  {$EXTERNALSYM DDVPFX_VBINOSCALE}

(*
 * Indicates that the video data can ignore the left and right
 * cropping coordinates when cropping oversampled VBI data.
 *)
  DDVPFX_IGNOREVBIXCROP = $00040000;
  {$EXTERNALSYM DDVPFX_IGNOREVBIXCROP}

(*
 * Indicates that interleaving can be disabled for data within the
 * vertical blanking interval.
 *)
  DDVPFX_VBINOINTERLEAVE     = $00080000;
  {$EXTERNALSYM DDVPFX_VBINOINTERLEAVE}


(****************************************************************************
 *
 * VIDEOPORT DDVIDEOPORTINFO / TDDVideoPortInfo FLAGS
 *
 ****************************************************************************)

(*
 * Perform automatic flipping.   Auto-flipping is performed between
 * the overlay surface that was attached to the video port using
 * IDirectDrawVideoPort::AttachSurface and the overlay surfaces that
 * are attached to the surface via the IDirectDrawSurface::AttachSurface
 * method.  The flip order is the order in which the overlay surfaces
 * were. attached.
 *)
  DDVP_AUTOFLIP = $00000001;
  {$EXTERNALSYM DDVP_AUTOFLIP}

(*
 * Perform conversion using the ddpfOutputFormat information.
 *)
  DDVP_CONVERT = $00000002;
  {$EXTERNALSYM DDVP_CONVERT}

(*
 * Perform cropping using the specified rectangle.
 *)
  DDVP_CROP = $00000004;
  {$EXTERNALSYM DDVP_CROP}

(*
 * Indicates that interlaced fields should be interleaved in memory.
 *)
  DDVP_INTERLEAVE = $00000008;
  {$EXTERNALSYM DDVP_INTERLEAVE}

(*
 * Indicates that the data should be mirrored left to right as it's
 * written into the frame buffer.
 *)
  DDVP_MIRRORLEFTRIGHT = $00000010;
  {$EXTERNALSYM DDVP_MIRRORLEFTRIGHT}

(*
 * Indicates that the data should be mirrored top to bottom as it's
 * written into the frame buffer.
 *)
  DDVP_MIRRORUPDOWN = $00000020;
  {$EXTERNALSYM DDVP_MIRRORUPDOWN}

(*
 * Perform pre-scaling/zooming based on the pre-scale parameters.
 *)
  DDVP_PRESCALE = $00000040;
  {$EXTERNALSYM DDVP_PRESCALE}

(*
 * Ignore input of even fields.
 *)
  DDVP_SKIPEVENFIELDS = $00000080;
  {$EXTERNALSYM DDVP_SKIPEVENFIELDS}

(*
 * Ignore input of odd fields.
 *)
  DDVP_SKIPODDFIELDS = $00000100;
  {$EXTERNALSYM DDVP_SKIPODDFIELDS}

(*
 * Drive the graphics VSYNCs using the video port VYSNCs.
 *)
  DDVP_SYNCMASTER = $00000200;
  {$EXTERNALSYM DDVP_SYNCMASTER}

(*
 * The ddpfVBIOutputFormatFormat member contains data that should be used
 * to convert the data within the vertical blanking interval.
 *)
  DDVP_VBICONVERT = $00000400;
  {$EXTERNALSYM DDVP_VBICONVERT}

(*
 * Indicates that data within the vertical blanking interval
 * should not be scaled.
 *)
  DDVP_VBINOSCALE = $00000800;
  {$EXTERNALSYM DDVP_VBINOSCALE}

(*
 * Indicates that these bob/weave decisions should not be
 * overriden by other interfaces.
 *)
  DDVP_OVERRIDEBOBWEAVE = $00001000;
  {$EXTERNALSYM DDVP_OVERRIDEBOBWEAVE}

(*
 * Indicates that the video data should ignore the left and right
 * cropping coordinates when cropping the VBI data.
 *)
  DDVP_IGNOREVBIXCROP = $00002000;
  {$EXTERNALSYM DDVP_IGNOREVBIXCROP}

(*
 * Indicates that interleaving can be disabled for data within the
 * vertical blanking interval.
 *)
  DDVP_VBINOINTERLEAVE			= $00004000;
  {$EXTERNALSYM DDVP_VBINOINTERLEAVE}

(*
 * Indicates that the video port should use the hardware
 * de-interlacing hardware.
 *)
  DDVP_HARDWAREDEINTERLACE		= $00008000;
  {$EXTERNALSYM DDVP_HARDWAREDEINTERLACE}

(****************************************************************************
 *
 * DIRIRECTDRAWVIDEOPORT GETINPUTFORMAT/GETOUTPUTFORMAT FLAGS
 *
 ****************************************************************************)

(*
 * Return formats for the video data
 *)
  DDVPFORMAT_VIDEO = $00000001;
  {$EXTERNALSYM DDVPFORMAT_VIDEO}

(*
 * Return formats for the VBI data
 *)
  DDVPFORMAT_VBI = $00000002;
  {$EXTERNALSYM DDVPFORMAT_VBI}

(****************************************************************************
 *
 * DIRIRECTDRAWVIDEOPORT SETTARGETSURFACE FLAGS
 *
 ****************************************************************************)

(*
 * Surface should receive video data (and VBI data if a surface
 * is not explicitly attached for that purpose)
 *)
  DDVPTARGET_VIDEO = $00000001;
  {$EXTERNALSYM DDVPTARGET_VIDEO}

(*
 * Surface should receive VBI data
 *)
  DDVPTARGET_VBI = $00000002;
  {$EXTERNALSYM DDVPTARGET_VBI}


(****************************************************************************
 *
 * DIRIRECTDRAWVIDEOPORT WAITFORSYNC FLAGS
 *
 ****************************************************************************)

(*
 * Waits until the beginning of the next VSYNC
 *)
  DDVPWAIT_BEGIN = $00000001;
  {$EXTERNALSYM DDVPWAIT_BEGIN}

(*
 * Waits until the end of the next/current VSYNC
 *)
  DDVPWAIT_END = $00000002;
  {$EXTERNALSYM DDVPWAIT_END}

(*
 * Waits until the beginning of the specified line
 *)
  DDVPWAIT_LINE = $00000003;
  {$EXTERNALSYM DDVPWAIT_LINE}

(****************************************************************************
 *
 * DIRECTDRAWVIDEOPORT FLIP FLAGS
 *
 ****************************************************************************)

(*
 * Flips the normal video surface
 *)
  DDVPFLIP_VIDEO = $00000001;
  {$EXTERNALSYM DDVPFLIP_VIDEO}

(*
 * Flips the VBI surface
 *)
  DDVPFLIP_VBI = $00000002;
  {$EXTERNALSYM DDVPFLIP_VBI}

(****************************************************************************
 *
 * DIRIRECTDRAWVIDEOPORT GETVIDEOSIGNALSTATUS VALUES
 *
 ****************************************************************************)

(*
 * No video signal is present at the video port
 *)
  DDVPSQ_NOSIGNAL = $00000001;
  {$EXTERNALSYM DDVPSQ_NOSIGNAL}

(*
 * A valid video signal is present at the video port
 *)
  DDVPSQ_SIGNALOK = $00000002;
  {$EXTERNALSYM DDVPSQ_SIGNALOK}

(****************************************************************************
 *
 * VIDEOPORTBANDWIDTH Flags
 *
 ****************************************************************************)

(*
 * The specified height/width refer to the size of the video port data
 * written into memory, after prescaling has occured.
 *)
  DDVPB_VIDEOPORT = $00000001;
  {$EXTERNALSYM DDVPB_VIDEOPORT}

(*
 * The specified height/width refer to the source size of the overlay.
 *)
  DDVPB_OVERLAY = $00000002;
  {$EXTERNALSYM DDVPB_OVERLAY}

(*
 * This is a query for the device to return which caps this device requires.
 *)
  DDVPB_TYPE = $00000004;
  {$EXTERNALSYM DDVPB_TYPE}

(****************************************************************************
 *
 * VIDEOPORTBANDWIDTH Caps
 *
 ****************************************************************************)

(*
 * The bandwidth for this device is dependant on the overlay source size.
 *)
  DDVPBCAPS_SOURCE = $00000001;
  {$EXTERNALSYM DDVPBCAPS_SOURCE}

(*
 * The bandwidth for this device is dependant on the overlay destination
 * size.
 *)
  DDVPBCAPS_DESTINATION = $00000002;
  {$EXTERNALSYM DDVPBCAPS_DESTINATION}

(****************************************************************************
 *
 * DDVIDEOPORTCONTAINER CreateVideoPort flags
 *
 ****************************************************************************)

(*
 * The process only wants to control the VBI portion of the video stream.
 *)
  DDVPCREATE_VBIONLY			= $00000001;
  {$EXTERNALSYM DDVPCREATE_VBIONLY}

(*
 * The process only wants to control the non-VBI (video) portion of
 * the video stream.
 *)
  DDVPCREATE_VIDEOONLY			= $00000002;
  {$EXTERNALSYM DDVPCREATE_VIDEOONLY}

(****************************************************************************
 *
 * DDVIDEOPORTSTATUS flags
 *
 ****************************************************************************)

(*
 * The video port interface is only controlling the VBI portion of the
 * video stream
 *)
  DDVPSTATUS_VBIONLY			= $00000001;
  {$EXTERNALSYM DDVPSTATUS_VBIONLY}

(*
 * The video port interface is only controlling the video portion of the
 * video stream
 *)
  DDVPSTATUS_VIDEOONLY			= $00000002;
  {$EXTERNALSYM DDVPSTATUS_VIDEOONLY}


type
(*
 * API's
 *)

  TDDEnumVideoCallback = function (lpTDDVideoPortCaps: PDDVideoPortCaps;
      lpContext: Pointer): HResult; stdcall;
  {$EXTERNALSYM TDDEnumVideoCallback}

(*
 * INTERACES FOLLOW:
 *	IDirectDrawVideoPort
 *	IVideoPort
 *)
  IDirectDrawVideoPort = interface;
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawVideoPort> _di_IDirectDrawVideoPort;'}
  {$EXTERNALSYM IDirectDrawVideoPort}

(*
 * IDirectDrawVideoPortContainer
 *)
  {$HPPEMIT 'typedef System::DelphiInterface<IDDVideoPortContainer> _di_IDDVideoPortContainer;'}
  {$EXTERNALSYM IDDVideoPortContainer}
  IDDVideoPortContainer = interface(IUnknown)
    ['{6C142760-A733-11CE-A521-0020AF0BE560}']
    (*** IDDVideoPortContainer methods ***)
    function CreateVideoPort(dwFlags: DWORD; var lpTDDVideoPortDesc:
        TDDVideoPortDesc; var lplpDDVideoPort: IDirectDrawVideoPort;
        pUnkOuter: IUnknown): HResult; stdcall;
    function EnumVideoPorts(dwFlags: DWORD;
        lpTDDVideoPortCaps: PDDVideoPortCaps; lpContext: Pointer;
        lpEnumVideoCallback: TDDEnumVideoCallback): HResult; stdcall;
    function GetVideoPortConnectInfo(dwPortId: DWORD; var lpNumEntries: DWORD;
        lpConnectInfo: PDDVideoPortConnect): HResult; stdcall;
    function QueryVideoPortStatus(dwPortId: DWORD;
        var lpVPStatus: TDDVideoPortStatus): HResult; stdcall;
  end;

(*
 * IDirectDrawVideoPort
 *)
  IDirectDrawVideoPort = interface(IUnknown)
    ['{B36D93E0-2B43-11CF-A2DE-00AA00B93356}']
    (*** IDirectDrawVideoPort methods ***)
    function Flip(lpDDSurface: IDirectDrawSurface; dwFlags: DWORD): HResult; stdcall;
    function GetBandwidthInfo(var lpddpfFormat: TDDPixelFormat;
        dwWidth: DWORD; dwHeight: DWORD; dwFlags: DWORD;
        var lpBandwidth: TDDVideoPortBandWidth): HResult; stdcall;
    function GetColorControls(var lpColorControl: TDDColorControl): HResult; stdcall;
    function GetInputFormats(var lpNumFormats: DWORD; var lpFormats:
        TDDPixelFormat; dwFlags: DWORD): HResult; stdcall;
    function GetOutputFormats(var lpInputFormat: TDDPixelFormat;
        var lpNumFormats: DWORD; lpFormats: PDDPixelFormat; dwFlags: DWORD):
        HResult; stdcall;
    function GetFieldPolarity(var lpbVideoField: BOOL): HResult; stdcall;
    function GetVideoLine(var lpdwLine: DWORD): HResult; stdcall;
    function GetVideoSignalStatus(varlpdwStatus: DWORD): HResult; stdcall;
    function SetColorControls(var lpColorControl: TDDColorControl): HResult; stdcall;
    function SetTargetSurface(lpDDSurface: IDirectDrawSurface; dwFlags: DWORD):
        HResult; stdcall;
    function StartVideo(var lpVideoInfo: TDDVideoPortInfo): HResult; stdcall;
    function StopVideo: HResult; stdcall;
    function UpdateVideo(var lpVideoInfo: TDDVideoPortInfo): HResult; stdcall;
    function WaitForSync(dwFlags: DWORD; dwLine: DWORD; dwTimeout: DWORD):
        HResult; stdcall;
  end;

  IID_IDDVideoPortContainer = IDDVideoPortContainer;
  {$EXTERNALSYM IID_IDDVideoPortContainer}
  IID_IDirectDrawVideoPort = IDirectDrawVideoPort;
  {$EXTERNALSYM IID_IDirectDrawVideoPort}

(*
 * IDirectDrawVideoPort
 *)
  {$HPPEMIT 'typedef System::DelphiInterface<IDirectDrawVideoPortNotify> _di_IDirectDrawVideoPortNotify;'}
  {$EXTERNALSYM IDirectDrawVideoPortNotify}
  IDirectDrawVideoPortNotify = interface(IUnknown)
    ['{6C142760-A733-11CE-A521-0020AF0BE560}']
    (*** IVideoPort methods ***)
    function AcquireNotification(hEvent: THandle; const params: TDDVideoPortNotify): HResult; stdcall;
    function ReleaseNotification(hEvent: THandle): HResult; stdcall;
  end;


var
  DDrawDLL : HMODULE = 0;

function DDErrorString(Value: HResult): String;

implementation

//#define MAKE_DDHRESULT( code )  MAKE_HRESULT( 1, _FACDD, code )
function MAKE_DDHRESULT(Code: DWORD): HResult;
begin
  Result:= MakeResult(1, _FACDD, code);
end;

//#define GET_WHQL_YEAR( dwWHQLLevel ) \
//    ( (dwWHQLLevel) / 0x10000 )
function GET_WHQL_YEAR(dwWHQLLevel: DWORD): DWORD;
begin
  Result := (dwWHQLLevel) div $10000;
end;

//#define GET_WHQL_MONTH( dwWHQLLevel ) \
//    ( ( (dwWHQLLevel) / 0x100 ) & 0x00ff )
function GET_WHQL_MONTH(dwWHQLLevel: DWORD): DWORD;
begin
  Result := ((dwWHQLLevel) div $100) and $00ff;
end;

//#define GET_WHQL_DAY( dwWHQLLevel ) \
//    ( (dwWHQLLevel) & 0xff )
function GET_WHQL_DAY(dwWHQLLevel: DWORD): DWORD;
begin
  Result := (dwWHQLLevel) and $ff;
end;


function MAKEFOURCC(ch0, ch1, ch2, ch3: Char): DWORD;
begin
  Result := DWORD(Byte(ch0) shl 0) or
            DWORD(Byte(ch1) shl 8) or
            DWORD(Byte(ch2) shl 16) or
            DWORD(Byte(ch3) shl 24);
end;

function DDErrorString(Value: HResult): String;
begin
  case Value of
    DD_OK: Result := 'The request completed successfully.';
    DDERR_ALREADYINITIALIZED: Result := 'This object is already initialized.';
    DDERR_BLTFASTCANTCLIP: Result := ' if a clipper object is attached to the source surface passed into a BltFast call.';
    DDERR_CANNOTATTACHSURFACE: Result := 'This surface can not be attached to the requested surface.';
    DDERR_CANNOTDETACHSURFACE: Result := 'This surface can not be detached from the requested surface.';
    DDERR_CANTCREATEDC: Result := 'Windows can not create any more DCs.';
    DDERR_CANTDUPLICATE: Result := 'Cannot duplicate primary & 3D surfaces, or surfaces that are implicitly created.';
    DDERR_CLIPPERISUSINGHWND: Result := 'An attempt was made to set a cliplist for a clipper object that is already monitoring an hwnd.';
    DDERR_COLORKEYNOTSET: Result := 'No src color key specified for this operation.';
    DDERR_CURRENTLYNOTAVAIL: Result := 'Support is currently not available.';
    DDERR_DIRECTDRAWALREADYCREATED: Result := 'A DirectDraw object representing this driver has already been created for this process.';
    DDERR_EXCEPTION: Result := 'An exception was encountered while performing the requested operation.';
    DDERR_EXCLUSIVEMODEALREADYSET: Result := 'An attempt was made to set the cooperative level when it was already set to exclusive.';
    DDERR_GENERIC: Result := 'Generic failure.';
    DDERR_HEIGHTALIGN: Result := 'Height of rectangle provided is not a multiple of reqd alignment.';
    DDERR_HWNDALREADYSET: Result := 'The CooperativeLevel HWND has already been set. It can not be reset while the process has surfaces or palettes created.';
    DDERR_HWNDSUBCLASSED: Result := 'HWND used by DirectDraw CooperativeLevel has been subclassed, this prevents DirectDraw from restoring state.';
    DDERR_IMPLICITLYCREATED: Result := 'This surface can not be restored because it is an implicitly created surface.';
    DDERR_INCOMPATIBLEPRIMARY: Result := 'Unable to match primary surface creation request with existing primary surface.';
    DDERR_INVALIDCAPS: Result := 'One or more of the caps bits passed to the callback are incorrect.';
    DDERR_INVALIDCLIPLIST: Result := 'DirectDraw does not support the provided cliplist.';
    DDERR_INVALIDDIRECTDRAWGUID: Result := 'The GUID passed to DirectDrawCreate is not a valid DirectDraw driver identifier.';
    DDERR_INVALIDMODE: Result := 'DirectDraw does not support the requested mode.';
    DDERR_INVALIDOBJECT: Result := 'DirectDraw received a pointer that was an invalid DIRECTDRAW object.';
    DDERR_INVALIDPARAMS: Result := 'One or more of the parameters passed to the function are incorrect.';
    DDERR_INVALIDPIXELFORMAT: Result := 'The pixel format was invalid as specified.';
    DDERR_INVALIDPOSITION: Result := 'Returned when the position of the overlay on the destination is no longer legal for that destination.';
    DDERR_INVALIDRECT: Result := 'Rectangle provided was invalid.';
    DDERR_LOCKEDSURFACES: Result := 'Operation could not be carried out because one or more surfaces are locked.';
    DDERR_NO3D: Result := 'There is no 3D present.';
    DDERR_NOALPHAHW: Result := 'Operation could not be carried out because there is no alpha accleration hardware present or available.';
    DDERR_NOBLTHW: Result := 'No blitter hardware present.';
    DDERR_NOCLIPLIST: Result := 'No cliplist available.';
    DDERR_NOCLIPPERATTACHED: Result := 'No clipper object attached to surface object.';
    DDERR_NOCOLORCONVHW: Result := 'Operation could not be carried out because there is no color conversion hardware present or available.';
    DDERR_NOCOLORKEY: Result := 'Surface does not currently have a color key';
    DDERR_NOCOLORKEYHW: Result := 'Operation could not be carried out because there is no hardware support of the destination color key.';
    DDERR_NOCOOPERATIVELEVELSET: Result := 'Create function called without DirectDraw object method SetCooperativeLevel being called.';
    DDERR_NODC: Result := 'No DC was ever created for this surface.';
    DDERR_NODDROPSHW: Result := 'No DirectDraw ROP hardware.';
    DDERR_NODIRECTDRAWHW: Result := 'A hardware-only DirectDraw object creation was attempted but the driver did not support any hardware.';
    DDERR_NOEMULATION: Result := 'Software emulation not available.';
    DDERR_NOEXCLUSIVEMODE: Result := 'Operation requires the application to have exclusive mode but the application does not have exclusive mode.';
    DDERR_NOFLIPHW: Result := 'Flipping visible surfaces is not supported.';
    DDERR_NOGDI: Result := 'There is no GDI present.';
    DDERR_NOHWND: Result := 'Clipper notification requires an HWND or no HWND has previously been set as the CooperativeLevel HWND.';
    DDERR_NOMIRRORHW: Result := 'Operation could not be carried out because there is no hardware present or available.';
    DDERR_NOOVERLAYDEST: Result := 'Returned when GetOverlayPosition is called on an overlay that UpdateOverlay has never been called on to establish a destination.';
    DDERR_NOOVERLAYHW: Result := 'Operation could not be carried out because there is no overlay hardware present or available.';
    DDERR_NOPALETTEATTACHED: Result := 'No palette object attached to this surface.';
    DDERR_NOPALETTEHW: Result := 'No hardware support for 16 or 256 color palettes.';
    DDERR_NORASTEROPHW: Result := 'Operation could not be carried out because there is no appropriate raster op hardware present or available.';
    DDERR_NOROTATIONHW: Result := 'Operation could not be carried out because there is no rotation hardware present or available.';
    DDERR_NOSTRETCHHW: Result := 'Operation could not be carried out because there is no hardware support for stretching.';
    DDERR_NOT4BITCOLOR: Result := 'DirectDrawSurface is not in 4 bit color palette and the requested operation requires 4 bit color palette.';
    DDERR_NOT4BITCOLORINDEX: Result := 'DirectDrawSurface is not in 4 bit color index palette and the requested operation requires 4 bit color index palette.';
    DDERR_NOT8BITCOLOR: Result := 'DirectDrawSurface is not in 8 bit color mode and the requested operation requires 8 bit color.';
    DDERR_NOTAOVERLAYSURFACE: Result := 'Returned when an overlay member is called for a non-overlay surface.';
    DDERR_NOTEXTUREHW: Result := 'Operation could not be carried out because there is no texture mapping hardware present or available.';
    DDERR_NOTFLIPPABLE: Result := 'An attempt has been made to flip a surface that is not flippable.';
    DDERR_NOTFOUND: Result := 'Requested item was not found.';
    DDERR_NOTLOCKED: Result := 'Surface was not locked.  An attempt to unlock a surface that was not locked at all, or by this process, has been attempted.';
    DDERR_NOTPALETTIZED: Result := 'The surface being used is not a palette-based surface.';
    DDERR_NOVSYNCHW: Result := 'Operation could not be carried out because there is no hardware support for vertical blank synchronized operations.';
    DDERR_NOZBUFFERHW: Result := 'Operation could not be carried out because there is no hardware support for zbuffer blitting.';
    DDERR_NOZOVERLAYHW: Result := 'Overlay surfaces could not be z layered based on their BltOrder because the hardware does not support z layering of overlays.';
    DDERR_OUTOFCAPS: Result := 'The hardware needed for the requested operation has already been allocated.';
    DDERR_OUTOFMEMORY: Result := 'DirectDraw does not have enough memory to perform the operation.';
    DDERR_OUTOFVIDEOMEMORY: Result := 'DirectDraw does not have enough memory to perform the operation.';
    DDERR_OVERLAYCANTCLIP: Result := 'The hardware does not support clipped overlays.';
    DDERR_OVERLAYCOLORKEYONLYONEACTIVE: Result := 'Can only have ony color key active at one time for overlays.';
    DDERR_OVERLAYNOTVISIBLE: Result := 'Returned when GetOverlayPosition is called on a hidden overlay.';
    DDERR_PALETTEBUSY: Result := 'Access to this palette is being refused because the palette is already locked by another thread.';
    DDERR_PRIMARYSURFACEALREADYEXISTS: Result := 'This process already has created a primary surface.';
    DDERR_REGIONTOOSMALL: Result := 'Region passed to Clipper::GetClipList is too small.';
    DDERR_SURFACEALREADYATTACHED: Result := 'This surface is already attached to the surface it is being attached to.';
    DDERR_SURFACEALREADYDEPENDENT: Result := 'This surface is already a dependency of the surface it is being made a dependency of.';
    DDERR_SURFACEBUSY: Result := 'Access to this surface is being refused because the surface is already locked by another thread.';
    DDERR_SURFACEISOBSCURED: Result := 'Access to surface refused because the surface is obscured.';
    DDERR_SURFACELOST: Result := 'Access to this surface is being refused because the surface memory is gone. The DirectDrawSurface object representing this surface should have Restore called on it.';
    DDERR_SURFACENOTATTACHED: Result := 'The requested surface is not attached.';
    DDERR_TOOBIGHEIGHT: Result := 'Height requested by DirectDraw is too large.';
    DDERR_TOOBIGSIZE: Result := 'Size requested by DirectDraw is too large, but the individual height and width are OK.';
    DDERR_TOOBIGWIDTH: Result := 'Width requested by DirectDraw is too large.';
    DDERR_UNSUPPORTED: Result := 'Action not supported.';
    DDERR_UNSUPPORTEDFORMAT: Result := 'FOURCC format requested is unsupported by DirectDraw.';
    DDERR_UNSUPPORTEDMASK: Result := 'Bitmask in the pixel format requested is unsupported by DirectDraw.';
    DDERR_VERTICALBLANKINPROGRESS: Result := 'Vertical blank is in progress.';
    DDERR_WASSTILLDRAWING: Result := 'Informs DirectDraw that the previous Blt which is transfering information to or from this Surface is incomplete.';
    DDERR_WRONGMODE: Result := 'This surface can not be restored because it was created in a different mode.';
    DDERR_XALIGN: Result := 'Rectangle provided was not horizontally aligned on required boundary.';
    // new:
    DDERR_OVERLAPPINGRECTS: Result := 'Operation could not be carried out because the source and destination rectangles are on the same surface and overlap each other.';
    DDERR_INVALIDSTREAM: Result := 'The specified stream contains invalid data';
    DDERR_UNSUPPORTEDMODE: Result := 'The display is currently in an unsupported mode';
    DDERR_NOMIPMAPHW: Result := 'Operation could not be carried out because there is no mip-map texture mapping hardware present or available.';
    DDERR_INVALIDSURFACETYPE: Result := 'The requested action could not be performed because the surface was of the wrong type.';
    DDERR_NOOPTIMIZEHW: Result := 'Device does not support optimized surfaces, therefore no video memory optimized surfaces';
    DDERR_NOTLOADED: Result := 'Surface is an optimized surface, but has not yet been allocated any memory';
    DDERR_NOFOCUSWINDOW: Result := 'Attempt was made to create or set a device window without first setting the focus window';
    DDERR_DCALREADYCREATED: Result := 'A DC has already been returned for this surface. Only one DC can be retrieved per surface.';
    DDERR_NONONLOCALVIDMEM: Result := 'An attempt was made to allocate non-local video memory from a device that does not support non-local video memory.';
    DDERR_CANTPAGELOCK: Result := 'The attempt to page lock a surface failed.';
    DDERR_CANTPAGEUNLOCK: Result := 'The attempt to page unlock a surface failed.';
    DDERR_NOTPAGELOCKED: Result := 'An attempt was made to page unlock a surface with no outstanding page locks.';
    DDERR_MOREDATA: Result := 'There is more data available than the specified buffer size could hold';
    DDERR_EXPIRED: Result := 'The data has expired and is therefore no longer valid.';
    DDERR_VIDEONOTACTIVE: Result := 'The video port is not active';
    DDERR_DEVICEDOESNTOWNSURFACE: Result := 'Surfaces created by one direct draw device cannot be used directly by another direct draw device.';
    DDERR_NOTINITIALIZED: Result := 'An attempt was made to invoke an interface member of a DirectDraw object created by CoCreateInstance() before it was initialized.';
    else Result := 'Unrecognized Error';
  end;
end;

{$IFDEF DIRECTDRAW_DYNAMIC_LINK}
var
  DirectDrawLib: THandle = 0;

function DirectDrawLoaded: Boolean;
begin
  Result:= DirectDrawLib <> 0;
end;

function UnLoadDirectDraw: Boolean;
begin
  Result:= True;
  if DirectDrawLoaded then
  begin
    Result:= FreeLibrary(DirectDrawLib);

    DirectDrawEnumerateA := nil;
    DirectDrawEnumerateW := nil;
    DirectDrawEnumerate := nil;

    DirectDrawEnumerateExA := nil;
    DirectDrawEnumerateExW := nil;
    DirectDrawEnumerateEx := nil;

    DirectDrawCreate := nil;
    DirectDrawCreateEx := nil;
    DirectDrawCreateClipper := nil;
    {$IFDEF WINNT}
    NtDirectDrawCreate := nil;
    {$ENDIF}

    DirectDrawLib:= 0;
  end;
end;

function LoadDirectDraw: Boolean;
begin
  Result:= DirectDrawLoaded;
  if (not Result) then
  begin
    DirectDrawLib:= LoadLibrary(DirectDrawDll);
    if DirectDrawLoaded then
    begin
      DirectDrawEnumerateA := GetProcAddress(DirectDrawLib, 'DirectDrawEnumerateA');
      DirectDrawEnumerateW := GetProcAddress(DirectDrawLib, 'DirectDrawEnumerateW');
      {$IFDEF UNICODE}
      DirectDrawEnumerate := GetProcAddress(DirectDrawLib, 'DirectDrawEnumerateW');
      {$ELSE}
      DirectDrawEnumerate := GetProcAddress(DirectDrawLib, 'DirectDrawEnumerateA');
      {$ENDIF}

      DirectDrawEnumerateExA := GetProcAddress(DirectDrawLib, 'DirectDrawEnumerateExA');
      DirectDrawEnumerateExW := GetProcAddress(DirectDrawLib, 'DirectDrawEnumerateExW');
      {$IFDEF UNICODE}
      DirectDrawEnumerateEx := GetProcAddress(DirectDrawLib, 'DirectDrawEnumerateExW');
      {$ELSE}
      DirectDrawEnumerateEx := GetProcAddress(DirectDrawLib, 'DirectDrawEnumerateExA');
      {$ENDIF}

      DirectDrawCreate := GetProcAddress(DDrawDLL,'DirectDrawCreate');
      DirectDrawCreateEx := GetProcAddress(DDrawDLL,'DirectDrawCreateEx');
      DirectDrawCreateClipper := GetProcAddress(DDrawDLL,'DirectDrawCreateClipper');
      {$IFDEF WINNT}
      NtDirectDrawCreate := GetProcAddress(DDrawDLL,'NtDirectDrawCreate');
      {$ENDIF}

      Result:= Assigned(DirectDrawCreate); // At least basic procedure is found!
      if not Result then UnLoadDirectDraw;
    end;
  end;
end;
{$ELSE}
function DirectDrawLoaded: Boolean;
begin // Stub function for static linking
  Result:= True;
end;

function UnLoadDirectDraw: Boolean;
begin // Stub function for static linking
  Result:= True; // should emulate "normal" behaviour
end;

function LoadDirectDraw: Boolean;
begin // Stub function for static linking
  Result:= True;
end;

{$ENDIF}

{$IFDEF DIRECTDRAW_DYNAMIC_LINK}
initialization
{$IFNDEF DIRECTDRAW_DYNAMIC_LINK_EXPLICIT}
  LoadDirectDraw;
{$ENDIF}
finalization
  UnLoadDirectDraw;
{$ENDIF}
end.

