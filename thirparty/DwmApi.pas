{*******************************************************}
{                                                       }
{                Delphi Runtime Library                 }
{                                                       }
{          File: dwmapi.h                               }
{          Copyright (c) Microsoft Corporation          }
{          All Rights Reserved.                         }
{                                                       }
{       Translator: Embarcadero Technologies, Inc.      }
{ Copyright(c) 1995-2010 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}


{*******************************************************}
{    Win32 API Desktop Window Manager Interface Unit    }
{*******************************************************}

unit Dwmapi;

{$WEAKPACKAGEUNIT}

{$HPPEMIT ''}
{$HPPEMIT '#include "dwmapi.h"'}
{$HPPEMIT '#pragma link "dwmapi.lib"'}
{$HPPEMIT ''}

interface

uses Windows, Uxtheme;

const
  // Blur behind data structures
  DWM_BB_ENABLE                    = $00000001; // fEnable has been specified
  {$EXTERNALSYM DWM_BB_ENABLE}
  DWM_BB_BLURREGION                = $00000002; // hRgnBlur has been specified
  {$EXTERNALSYM DWM_BB_BLURREGION}
  DWM_BB_TRANSITIONONMAXIMIZED     = $00000004; // fTransitionOnMaximized has been specified
  {$EXTERNALSYM DWM_BB_TRANSITIONONMAXIMIZED}

type
  PDWM_BLURBEHIND = ^DWM_BLURBEHIND;
  DWM_BLURBEHIND = record 
    dwFlags: DWORD;
    fEnable: BOOL;
    hRgnBlur: HRGN;
    fTransitionOnMaximized: BOOL;
  end;
  _DWM_BLURBEHIND = DWM_BLURBEHIND;
  TDwmBlurBehind = DWM_BLURBEHIND;
  PDwmBlurBehind = ^TDwmBlurbehind;
  {$EXTERNALSYM DWM_BLURBEHIND}
  {$EXTERNALSYM PDWM_BLURBEHIND}

// Window attributes
  DWMWINDOWATTRIBUTE = type Integer; 
  {$EXTERNALSYM DWMWINDOWATTRIBUTE}
const
  DWMWA_NCRENDERING_ENABLED         = 1; // [get] Is non-client rendering enabled/disabled
  {$EXTERNALSYM DWMWA_NCRENDERING_ENABLED}
  DWMWA_NCRENDERING_POLICY          = 2; // [set] Non-client rendering policy
  {$EXTERNALSYM DWMWA_NCRENDERING_POLICY}
  DWMWA_TRANSITIONS_FORCEDISABLED   = 3; // [set] Potentially enable/forcibly disable transitions
  {$EXTERNALSYM DWMWA_TRANSITIONS_FORCEDISABLED}
  DWMWA_ALLOW_NCPAINT               = 4; // [set] Allow contents rendered in the non-client area to be visible on the DWM-drawn frame.
  {$EXTERNALSYM DWMWA_ALLOW_NCPAINT}
  DWMWA_CAPTION_BUTTON_BOUNDS       = 5; // [get] Bounds of the caption button area in window-relative space.
  {$EXTERNALSYM DWMWA_CAPTION_BUTTON_BOUNDS}
  DWMWA_NONCLIENT_RTL_LAYOUT        = 6; // [set] Is non-client content RTL mirrored
  {$EXTERNALSYM DWMWA_NONCLIENT_RTL_LAYOUT}
  DWMWA_FORCE_ICONIC_REPRESENTATION = 7; // [set] Force this window to display iconic thumbnails.
  {$EXTERNALSYM DWMWA_FORCE_ICONIC_REPRESENTATION}
  DWMWA_FLIP3D_POLICY               = 8; // [set] Designates how Flip3D will treat the window.
  {$EXTERNALSYM DWMWA_FLIP3D_POLICY}
  DWMWA_EXTENDED_FRAME_BOUNDS       = 9; // [get] Gets the extended frame bounds rectangle in screen space
  {$EXTERNALSYM DWMWA_EXTENDED_FRAME_BOUNDS}
  DWMWA_HAS_ICONIC_BITMAP           = 10; // [set] Indicates an available bitmap when there is no better thumbnail representation.
  {$EXTERNALSYM DWMWA_HAS_ICONIC_BITMAP}
  DWMWA_DISALLOW_PEEK               = 11; // [set] Don't invoke Peek on the window.
  {$EXTERNALSYM DWMWA_DISALLOW_PEEK}
  DWMWA_EXCLUDED_FROM_PEEK          = 12; // [set] LivePreview exclusion information
  {$EXTERNALSYM DWMWA_EXCLUDED_FROM_PEEK}
  DWMWA_LAST                        = 13; 
  {$EXTERNALSYM DWMWA_LAST}

  // Non-client rendering policy attribute values
  {$EXTERNALSYM DWMNCRP_USEWINDOWSTYLE}
  DWMNCRP_USEWINDOWSTYLE          = 0; // Enable/disable non-client rendering based on window style
  {$EXTERNALSYM DWMNCRP_DISABLED}
  DWMNCRP_DISABLED                = 1; // Disabled non-client rendering; window style is ignored
  {$EXTERNALSYM DWMNCRP_ENABLED}
  DWMNCRP_ENABLED                 = 2; // Enabled non-client rendering; window style is ignored
  {$EXTERNALSYM DWMNCRP_LAST}
  DWMNCRP_LAST                    = 3;

  // Values designating how Flip3D treats a given window.

  {$EXTERNALSYM DWMFLIP3D_DEFAULT}
  DWMFLIP3D_DEFAULT                     = 0; // Hide or include the window in Flip3D based on window style and visibility.
  {$EXTERNALSYM DWMFLIP3D_EXCLUDEBELOW}
  DWMFLIP3D_EXCLUDEBELOW                = 1; // Display the window under Flip3D and disabled.
  {$EXTERNALSYM DWMFLIP3D_EXCLUDEABOVE}
  DWMFLIP3D_EXCLUDEABOVE                = 2; // Display the window above Flip3D and enabled.
  {$EXTERNALSYM DWMFLIP3D_LAST}
  DWMFLIP3D_LAST                        = 3;


// Thumbnails
type
  HTHUMBNAIL = THandle; 
  {$EXTERNALSYM HTHUMBNAIL}
  PHTHUMBNAIL = ^HTHUMBNAIL; 
  {$EXTERNALSYM PHTHUMBNAIL}

const
  DWM_TNP_RECTDESTINATION                     = $00000001;
  {$EXTERNALSYM DWM_TNP_RECTDESTINATION}
  DWM_TNP_RECTSOURCE                          = $00000002;
  {$EXTERNALSYM DWM_TNP_RECTSOURCE}
  DWM_TNP_OPACITY                             = $00000004;
  {$EXTERNALSYM DWM_TNP_OPACITY}
  DWM_TNP_VISIBLE                             = $00000008;
  {$EXTERNALSYM DWM_TNP_VISIBLE}
  DWM_TNP_SOURCECLIENTAREAONLY                = $00000010;
  {$EXTERNALSYM DWM_TNP_SOURCECLIENTAREAONLY}

type
  PDWM_THUMBNAIL_PROPERTIES = ^DWM_THUMBNAIL_PROPERTIES;
  DWM_THUMBNAIL_PROPERTIES = record 
    dwFlags: DWORD;
    rcDestination: TRect;
    rcSource: TRect;
    opacity: Byte;
    fVisible: BOOL;
    fSourceClientAreaOnly: BOOL;
  end;
  _DWM_THUMBNAIL_PROPERTIES = DWM_THUMBNAIL_PROPERTIES;
  TDwmThumbnailProperties = DWM_THUMBNAIL_PROPERTIES;
  PDwmThumbnailProperties = ^TDwmThumbnailProperties;
  {$EXTERNALSYM DWM_THUMBNAIL_PROPERTIES}
  {$EXTERNALSYM PDWM_THUMBNAIL_PROPERTIES}

// Video enabling apis

//  DWM_FRAME_COUNT = ULONGLONG;
//  {$EXTERNALSYM DWM_FRAME_COUNT}
//  QPC_TIME        = ULONGLONG;
//  {$EXTERNALSYM QPC_TIME}

  UNSIGNED_RATIO = record 
    uiNumerator: Cardinal;
    uiDenominator: Cardinal;
  end;
  _UNSIGNED_RATIO = UNSIGNED_RATIO;
  TUnsignedRatio = UNSIGNED_RATIO;
  PUnsignedRatio = ^TUnsignedRatio;
  {$EXTERNALSYM UNSIGNED_RATIO}

  DWM_TIMING_INFO = record 
    cbSize: Cardinal;

    // Data on DWM composition overall

    // Monitor refresh rate
    rateRefresh: TUnsignedRatio;

    // Actual period
//    qpcRefreshPeriod: QPC_TIME;

    // composition rate    
    rateCompose: TUnsignedRatio;

    // QPC time at a VSync interupt
//    qpcVBlank: QPC_TIME;

    // DWM refresh count of the last vsync
    // DWM refresh count is a 64bit number where zero is
    // the first refresh the DWM woke up to process
//    cRefresh: DWM_FRAME_COUNT;

    // DX refresh count at the last Vsync Interupt
    // DX refresh count is a 32bit number with zero
    // being the first refresh after the card was initialized
    // DX increments a counter when ever a VSync ISR is processed
    // It is possible for DX to miss VSyncs
    // 
    // There is not a fixed mapping between DX and DWM refresh counts
    // because the DX will rollover and may miss VSync interupts
    cDXRefresh: UINT;

    // QPC time at a compose time. 
//    qpcCompose: QPC_TIME;

    // Frame number that was composed at qpcCompose
//    cFrame: DWM_FRAME_COUNT;

    // The present number DX uses to identify renderer frames
    cDXPresent: UINT;

    // Refresh count of the frame that was composed at qpcCompose
//    cRefreshFrame: DWM_FRAME_COUNT;


    // DWM frame number that was last submitted
//    cFrameSubmitted: DWM_FRAME_COUNT;

    // DX Present number that was last submitted
    cDXPresentSubmitted: UINT;

    // DWM frame number that was last confirmed presented
//    cFrameConfirmed: DWM_FRAME_COUNT;

    // DX Present number that was last confirmed presented
    cDXPresentConfirmed: UINT;

    // The target refresh count of the last
    // frame confirmed completed by the GPU
//    cRefreshConfirmed: DWM_FRAME_COUNT;

    // DX refresh count when the frame was confirmed presented
    cDXRefreshConfirmed: UINT;

    // Number of frames the DWM presented late
    // AKA Glitches
//    cFramesLate: DWM_FRAME_COUNT;

    // the number of composition frames that
    // have been issued but not confirmed completed
    cFramesOutstanding: UINT;


    // Following fields are only relavent when an HWND is specified
    // Display frame


    // Last frame displayed
//    cFrameDisplayed: DWM_FRAME_COUNT;

    // QPC time of the composition pass when the frame was displayed
//    qpcFrameDisplayed: QPC_TIME;

    // Count of the VSync when the frame should have become visible
//    cRefreshFrameDisplayed: DWM_FRAME_COUNT;

    // Complete frames: DX has notified the DWM that the frame is done rendering

    // ID of the the last frame marked complete (starts at 0)
//    cFrameComplete: DWM_FRAME_COUNT;

    // QPC time when the last frame was marked complete
//    qpcFrameComplete: QPC_TIME;

    // Pending frames:
    // The application has been submitted to DX but not completed by the GPU

    // ID of the the last frame marked pending (starts at 0)
//    cFramePending: DWM_FRAME_COUNT;

    // QPC time when the last frame was marked pending
//    qpcFramePending: QPC_TIME;

    // number of unique frames displayed
//    cFramesDisplayed: DWM_FRAME_COUNT;

    // number of new completed frames that have been received
//    cFramesComplete: DWM_FRAME_COUNT;

     // number of new frames submitted to DX but not yet complete
//    cFramesPending: DWM_FRAME_COUNT;

    // number of frames available but not displayed, used or dropped
//    cFramesAvailable: DWM_FRAME_COUNT;

    // number of rendered frames that were never
    // displayed because composition occured too late
//    cFramesDropped: DWM_FRAME_COUNT;

    // number of times an old frame was composed
    // when a new frame should have been used
    // but was not available
//    cFramesMissed: DWM_FRAME_COUNT;

    // the refresh at which the next frame is
    // scheduled to be displayed
//    cRefreshNextDisplayed: DWM_FRAME_COUNT;

    // the refresh at which the next DX present is
    // scheduled to be displayed
//    cRefreshNextPresented: DWM_FRAME_COUNT;

    // The total number of refreshes worth of content
    // for this HWND that have been displayed by the DWM
    // since DwmSetPresentParameters was called
//    cRefreshesDisplayed: DWM_FRAME_COUNT;

    // The total number of refreshes worth of content
    // that have been presented by the application
    // since DwmSetPresentParameters was called
//    cRefreshesPresented: DWM_FRAME_COUNT;


    // The actual refresh # when content for this
    // window started to be displayed
    // it may be different than that requested
    // DwmSetPresentParameters
//    cRefreshStarted: DWM_FRAME_COUNT;

    // Total number of pixels DX redirected
    // to the DWM.
    // If Queueing is used the full buffer
    // is transfered on each present.
    // If not queuing it is possible only
    // a dirty region is updated
//    cPixelsReceived: ULONGLONG;

    // Total number of pixels drawn.
    // Does not take into account if
    // if the window is only partial drawn
    // do to clipping or dirty rect management
//    cPixelsDrawn: ULONGLONG;

    // The number of buffers in the flipchain
    // that are empty.   An application can
    // present that number of times and guarantee
    // it won't be blocked waiting for a buffer to
    // become empty to present to
//    cBuffersEmpty: DWM_FRAME_COUNT;

  end;
  _DWM_TIMING_INFO = DWM_TIMING_INFO;
  TDwmTimingInfo = DWM_TIMING_INFO;
  PDwmTimingInfo = ^TDwmTimingInfo;
  {$EXTERNALSYM DWM_TIMING_INFO}

  DWM_SOURCE_FRAME_SAMPLING = type Integer; 
  {$EXTERNALSYM DWM_SOURCE_FRAME_SAMPLING}
const
    // includes the first refresh of the output frame
  DWM_SOURCE_FRAME_SAMPLING_POINT    = 0; 
  {$EXTERNALSYM DWM_SOURCE_FRAME_SAMPLING_POINT}

    // use the source frame that includes the most
    // refreshes of out the output frame
    // in case of multiple source frames with the
    // same coverage the last will be used
  DWM_SOURCE_FRAME_SAMPLING_COVERAGE = 1; 
  {$EXTERNALSYM DWM_SOURCE_FRAME_SAMPLING_COVERAGE}

       // Sentinel value
  DWM_SOURCE_FRAME_SAMPLING_LAST     = 2; 
  {$EXTERNALSYM DWM_SOURCE_FRAME_SAMPLING_LAST}

const 
  c_DwmMaxQueuedBuffers = 8;
  c_DwmMaxMonitors = 16;
  c_DwmMaxAdapters = 16; 

type
  DWM_PRESENT_PARAMETERS = record 
    cbSize: Cardinal;
    fQueue: BOOL;
//    cRefreshStart: DWM_FRAME_COUNT;
    cBuffer: UINT;
    fUseSourceRate: BOOL;
    rateSource: TUnsignedRatio;
    cRefreshesPerFrame: UINT;
    eSampling: DWM_SOURCE_FRAME_SAMPLING;
  end;
  _DWM_PRESENT_PARAMETERS = DWM_PRESENT_PARAMETERS;
  TDwmPresentParameters = DWM_PRESENT_PARAMETERS;
  PDwmPresentParameters = ^TDwmPresentParameters;
  {$EXTERNALSYM DWM_PRESENT_PARAMETERS}



const
  DWM_FRAME_DURATION_DEFAULT = -1; 
  {$EXTERNALSYM DWM_FRAME_DURATION_DEFAULT}

function DwmDefWindowProc(hWnd: HWND; msg: UINT; wParam: WPARAM; lParam: LPARAM; 
  var plResult: LRESULT): BOOL; stdcall;
{$EXTERNALSYM DwmDefWindowProc}

function DwmEnableBlurBehindWindow(hWnd: HWND; 
  var pBlurBehind: TDwmBlurbehind): HResult; stdcall;
{$EXTERNALSYM DwmEnableBlurBehindWindow}

const
  DWM_EC_DISABLECOMPOSITION = 0; 
  {$EXTERNALSYM DWM_EC_DISABLECOMPOSITION}
  DWM_EC_ENABLECOMPOSITION = 1; 
  {$EXTERNALSYM DWM_EC_ENABLECOMPOSITION}


function DwmEnableComposition(uCompositionAction: UINT): HResult; stdcall;
{$EXTERNALSYM DwmEnableComposition}

function DwmEnableMMCSS(fEnableMMCSS: BOOL): HResult; stdcall;
{$EXTERNALSYM DwmEnableMMCSS}

function DwmExtendFrameIntoClientArea(hWnd: HWND; const pMarInset: TMargins): HResult; stdcall;
{$EXTERNALSYM DwmExtendFrameIntoClientArea}

function DwmGetColorizationColor(var pcrColorization: DWORD; 
  var pfOpaqueBlend: BOOL): HResult; stdcall;
{$EXTERNALSYM DwmGetColorizationColor}

function DwmGetCompositionTimingInfo(hwnd: HWND; 
  var pTimingInfo: TDwmTimingInfo): HResult; stdcall;
{$EXTERNALSYM DwmGetCompositionTimingInfo}


function DwmGetWindowAttribute(hwnd: HWND; dwAttribute: DWORD; 
  pvAttribute: Pointer; cbAttribute: DWORD): HResult; stdcall;
{$EXTERNALSYM DwmGetWindowAttribute}

{$EXTERNALSYM DwmIsCompositionEnabled}
function DwmIsCompositionEnabled(var pfEnabled: BOOL): HResult; stdcall;

function DwmModifyPreviousDxFrameDuration(hwnd: HWND; cRefreshes: Integer; 
  fRelative: BOOL): HResult; stdcall;
{$EXTERNALSYM DwmModifyPreviousDxFrameDuration}

function DwmQueryThumbnailSourceSize(hThumbnail: HTHUMBNAIL; 
  pSize: PSIZE): HResult; stdcall;
{$EXTERNALSYM DwmQueryThumbnailSourceSize}

function DwmRegisterThumbnail(hwndDestination: HWND; hwndSource: HWND; 
  phThumbnailId: PHTHUMBNAIL): HResult; stdcall;
{$EXTERNALSYM DwmRegisterThumbnail}

function DwmSetDxFrameDuration(hwnd: HWND; cRefreshes: Integer): HResult; stdcall;
{$EXTERNALSYM DwmSetDxFrameDuration}

function DwmSetPresentParameters(hwnd: HWND; 
  var pPresentParams: TDwmPresentParameters): HResult; stdcall;
{$EXTERNALSYM DwmSetPresentParameters}

function DwmSetWindowAttribute(hwnd: HWND; dwAttribute: DWORD; 
  pvAttribute: Pointer; cbAttribute: DWORD): HResult; stdcall;
{$EXTERNALSYM DwmSetWindowAttribute}

function DwmUnregisterThumbnail(hThumbnailId: HTHUMBNAIL): HResult; stdcall;
{$EXTERNALSYM DwmUnregisterThumbnail}

function DwmUpdateThumbnailProperties(hThumbnailId: HTHUMBNAIL; 
  var ptnProperties: TDwmThumbnailProperties): HResult; stdcall;
{$EXTERNALSYM DwmUpdateThumbnailProperties}

const
  DWM_SIT_DISPLAYFRAME = $00000001;     // Display a window frame around the provided bitmap
  {$EXTERNALSYM DWM_SIT_DISPLAYFRAME}

function DwmSetIconicThumbnail(hwnd: HWND; hbmp: HBITMAP; 
  dwSITFlags: DWORD): HResult; stdcall;
{$EXTERNALSYM DwmSetIconicThumbnail}

function DwmSetIconicLivePreviewBitmap(hwnd: HWND; hbmp: HBITMAP; 
  var pptClient: TPoint; dwSITFlags: DWORD): HResult; stdcall;
{$EXTERNALSYM DwmSetIconicLivePreviewBitmap}

function DwmInvalidateIconicBitmaps(hwnd: HWND): HResult; stdcall;
{$EXTERNALSYM DwmInvalidateIconicBitmaps}

function DwmAttachMilContent(hwnd: HWND): HResult; stdcall;
{$EXTERNALSYM DwmAttachMilContent}

function DwmDetachMilContent(hwnd: HWND): HResult; stdcall;
{$EXTERNALSYM DwmDetachMilContent}

function DwmFlush: HResult; stdcall;
{$EXTERNALSYM DwmFlush}

type
  MilMatrix3x2D = record 
    S_11: Double;
    S_12: Double;
    S_21: Double;
    S_22: Double;
    DX: Double;
    DY: Double;
  end;
  _MilMatrix3x2D = MilMatrix3x2D;
  TMilMatrix3x2D = MilMatrix3x2D;
  PMilMatrix3x2D = ^TMilMatrix3x2D;
  {$EXTERNALSYM MilMatrix3x2D}

// Compatibility for Vista dwm api.
  MIL_MATRIX3X2D = MilMatrix3x2D; 
  {$EXTERNALSYM MIL_MATRIX3X2D}

function DwmGetGraphicsStreamTransformHint(uIndex: UINT; 
  var pTransform: TMilMatrix3x2D): HResult;
{$EXTERNALSYM DwmGetGraphicsStreamTransformHint}

function DwmGetGraphicsStreamClient(uIndex: UINT; 
  var pClientUuid: TGUID): HResult;
{$EXTERNALSYM DwmGetGraphicsStreamClient}

function DwmGetTransportAttributes(var pfIsRemoting: BOOL; 
  var pfIsConnected: BOOL; var pDwGeneration: DWORD): HResult;
{$EXTERNALSYM DwmGetTransportAttributes}

function DwmCompositionEnabled: Boolean;

implementation

uses
  SysUtils;

const
  ModName = 'DWMAPI.DLL';

function DwmDefWindowProc; external ModName name 'DwmDefWindowProc';
function DwmEnableBlurBehindWindow; external ModName name 'DwmEnableBlurBehindWindow';
function DwmEnableComposition; external ModName name 'DwmEnableComposition';
function DwmEnableMMCSS; external ModName name 'DwmEnableMMCSS';
function DwmExtendFrameIntoClientArea; external ModName name 'DwmExtendFrameIntoClientArea';
function DwmGetColorizationColor; external ModName name 'DwmGetColorizationColor';
function DwmGetCompositionTimingInfo; external ModName name 'DwmGetCompositionTimingInfo';
function DwmGetWindowAttribute; external ModName name 'DwmGetWindowAttribute';
function DwmIsCompositionEnabled; external ModName name 'DwmIsCompositionEnabled';
function DwmModifyPreviousDxFrameDuration; external ModName name 'DwmModifyPreviousDxFrameDuration';
function DwmQueryThumbnailSourceSize; external ModName name 'DwmQueryThumbnailSourceSize';
function DwmRegisterThumbnail; external ModName name 'DwmRegisterThumbnail';
function DwmSetDxFrameDuration; external ModName name 'DwmSetDxFrameDuration';
function DwmSetPresentParameters; external ModName name 'DwmSetPresentParameters';
function DwmSetWindowAttribute; external ModName name 'DwmSetWindowAttribute';
function DwmUnregisterThumbnail; external ModName name 'DwmUnregisterThumbnail';
function DwmUpdateThumbnailProperties; external ModName name 'DwmUpdateThumbnailProperties';
function DwmSetIconicThumbnail; external ModName name 'DwmSetIconicThumbnail';
function DwmSetIconicLivePreviewBitmap; external ModName name 'DwmSetIconicLivePreviewBitmap';
function DwmInvalidateIconicBitmaps; external ModName name 'DwmInvalidateIconicBitmaps';
function DwmAttachMilContent; external ModName name 'DwmAttachMilContent';
function DwmDetachMilContent; external ModName name 'DwmDetachMilContent';
function DwmFlush; external ModName name 'DwmFlush';
function DwmGetGraphicsStreamTransformHint; external ModName name 'DwmGetGraphicsStreamTransformHint';
function DwmGetGraphicsStreamClient; external ModName name 'DwmGetGraphicsStreamClient';
function DwmGetTransportAttributes; external ModName name 'DwmGetTransportAttributes';

function DwmCompositionEnabled: Boolean;
var
  LEnabled: BOOL;
begin
  Result := (Win32MajorVersion >= 6) and (DwmIsCompositionEnabled(LEnabled) = S_OK) and LEnabled;
end;

end.
