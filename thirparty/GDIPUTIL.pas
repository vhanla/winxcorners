      {******************************************************************}
      { GDI+ Util                                                         }
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

unit rkGDIPUTIL;

interface
uses
  Windows,
  rkGDIPAPI,
  rkGDIPOBJ;

function ValueTypeFromULONG(Type_: ULONG): String;
function GetMetaDataIDString(id: ULONG): string;
function GetEncoderClsid(format: String; out pClsid: TGUID): integer;
function GetStatus(Stat: TStatus): string;
function PixelFormatString(PixelFormat: TPixelFormat): string;

{from WinNT.h}
// creates a language identifier from a primary language identifier and a
// sublanguage identifier for the TStringFormat & TFontFamily class.
function MakeLangID(PrimaryLanguage, SubLanguage: LANGID): WORD;

implementation

function ValueTypeFromULONG(Type_: ULONG): String;
begin
  case Type_ of
    0 : result := 'Nothing';
    1 : result := 'PropertyTagTypeByte';
    2 : result := 'PropertyTagTypeASCII';
    3 : result := 'PropertyTagTypeShort';
    4 : result := 'PropertyTagTypeLong';
    5 : result := 'PropertyTagTypeRational';
    6 : result := 'Nothing';
    7 : result := 'PropertyTagTypeUndefined';
    8 : result := 'Nothing';
    9 : result := 'PropertyTagTypeSLONG';
    10: result := 'PropertyTagTypeSRational';
  else
    result := '<UnKnown>';
  end;
end;

function GetMetaDataIDString(id: ULONG): string;
begin
  case id of
    PropertyTagExifIFD                        : result := 'PropertyTagExifIFD';
    PropertyTagGpsIFD                         : result := 'PropertyTagGpsIFD';
    PropertyTagNewSubfileType                 : result := 'PropertyTagNewSubfileType';
    PropertyTagSubfileType                    : result := 'PropertyTagSubfileType';
    PropertyTagImageWidth                     : result := 'PropertyTagImageWidth';
    PropertyTagImageHeight                    : result := 'PropertyTagImageHeight';
    PropertyTagBitsPerSample                  : result := 'PropertyTagBitsPerSample';
    PropertyTagCompression                    : result := 'PropertyTagCompression';
    PropertyTagPhotometricInterp              : result := 'PropertyTagPhotometricInterp';
    PropertyTagThreshHolding                  : result := 'PropertyTagThreshHolding';
    PropertyTagCellWidth                      : result := 'PropertyTagCellWidth';
    PropertyTagCellHeight                     : result := 'PropertyTagCellHeight';
    PropertyTagFillOrder                      : result := 'PropertyTagFillOrder';
    PropertyTagDocumentName                   : result := 'PropertyTagDocumentName';
    PropertyTagImageDescription               : result := 'PropertyTagImageDescription';
    PropertyTagEquipMake                      : result := 'PropertyTagEquipMake';
    PropertyTagEquipModel                     : result := 'PropertyTagEquipModel';
    PropertyTagStripOffsets                   : result := 'PropertyTagStripOffsets';
    PropertyTagOrientation                    : result := 'PropertyTagOrientation';
    PropertyTagSamplesPerPixel                : result := 'PropertyTagSamplesPerPixel';
    PropertyTagRowsPerStrip                   : result := 'PropertyTagRowsPerStrip';
    PropertyTagStripBytesCount                : result := 'PropertyTagStripBytesCount';
    PropertyTagMinSampleValue                 : result := 'PropertyTagMinSampleValue';
    PropertyTagMaxSampleValue                 : result := 'PropertyTagMaxSampleValue';
    PropertyTagXResolution                    : result := 'PropertyTagXResolution';
    PropertyTagYResolution                    : result := 'PropertyTagYResolution';
    PropertyTagPlanarConfig                   : result := 'PropertyTagPlanarConfig';
    PropertyTagPageName                       : result := 'PropertyTagPageName';
    PropertyTagXPosition                      : result := 'PropertyTagXPosition';
    PropertyTagYPosition                      : result := 'PropertyTagYPosition';
    PropertyTagFreeOffset                     : result := 'PropertyTagFreeOffset';
    PropertyTagFreeByteCounts                 : result := 'PropertyTagFreeByteCounts';
    PropertyTagGrayResponseUnit               : result := 'PropertyTagGrayResponseUnit';
    PropertyTagGrayResponseCurve              : result := 'PropertyTagGrayResponseCurve';
    PropertyTagT4Option                       : result := 'PropertyTagT4Option';
    PropertyTagT6Option                       : result := 'PropertyTagT6Option';
    PropertyTagResolutionUnit                 : result := 'PropertyTagResolutionUnit';
    PropertyTagPageNumber                     : result := 'PropertyTagPageNumber';
    PropertyTagTransferFuncition              : result := 'PropertyTagTransferFuncition';
    PropertyTagSoftwareUsed                   : result := 'PropertyTagSoftwareUsed';
    PropertyTagDateTime                       : result := 'PropertyTagDateTime';
    PropertyTagArtist                         : result := 'PropertyTagArtist';
    PropertyTagHostComputer                   : result := 'PropertyTagHostComputer';
    PropertyTagPredictor                      : result := 'PropertyTagPredictor';
    PropertyTagWhitePoint                     : result := 'PropertyTagWhitePoint';
    PropertyTagPrimaryChromaticities          : result := 'PropertyTagPrimaryChromaticities';
    PropertyTagColorMap                       : result := 'PropertyTagColorMap';
    PropertyTagHalftoneHints                  : result := 'PropertyTagHalftoneHints';
    PropertyTagTileWidth                      : result := 'PropertyTagTileWidth';
    PropertyTagTileLength                     : result := 'PropertyTagTileLength';
    PropertyTagTileOffset                     : result := 'PropertyTagTileOffset';
    PropertyTagTileByteCounts                 : result := 'PropertyTagTileByteCounts';
    PropertyTagInkSet                         : result := 'PropertyTagInkSet';
    PropertyTagInkNames                       : result := 'PropertyTagInkNames';
    PropertyTagNumberOfInks                   : result := 'PropertyTagNumberOfInks';
    PropertyTagDotRange                       : result := 'PropertyTagDotRange';
    PropertyTagTargetPrinter                  : result := 'PropertyTagTargetPrinter';
    PropertyTagExtraSamples                   : result := 'PropertyTagExtraSamples';
    PropertyTagSampleFormat                   : result := 'PropertyTagSampleFormat';
    PropertyTagSMinSampleValue                : result := 'PropertyTagSMinSampleValue';
    PropertyTagSMaxSampleValue                : result := 'PropertyTagSMaxSampleValue';
    PropertyTagTransferRange                  : result := 'PropertyTagTransferRange';
    PropertyTagJPEGProc                       : result := 'PropertyTagJPEGProc';
    PropertyTagJPEGInterFormat                : result := 'PropertyTagJPEGInterFormat';
    PropertyTagJPEGInterLength                : result := 'PropertyTagJPEGInterLength';
    PropertyTagJPEGRestartInterval            : result := 'PropertyTagJPEGRestartInterval';
    PropertyTagJPEGLosslessPredictors         : result := 'PropertyTagJPEGLosslessPredictors';
    PropertyTagJPEGPointTransforms            : result := 'PropertyTagJPEGPointTransforms';
    PropertyTagJPEGQTables                    : result := 'PropertyTagJPEGQTables';
    PropertyTagJPEGDCTables                   : result := 'PropertyTagJPEGDCTables';
    PropertyTagJPEGACTables                   : result := 'PropertyTagJPEGACTables';
    PropertyTagYCbCrCoefficients              : result := 'PropertyTagYCbCrCoefficients';
    PropertyTagYCbCrSubsampling               : result := 'PropertyTagYCbCrSubsampling';
    PropertyTagYCbCrPositioning               : result := 'PropertyTagYCbCrPositioning';
    PropertyTagREFBlackWhite                  : result := 'PropertyTagREFBlackWhite';
    PropertyTagICCProfile                     : result := 'PropertyTagICCProfile';
    PropertyTagGamma                          : result := 'PropertyTagGamma';
    PropertyTagICCProfileDescriptor           : result := 'PropertyTagICCProfileDescriptor';
    PropertyTagSRGBRenderingIntent            : result := 'PropertyTagSRGBRenderingIntent';
    PropertyTagImageTitle                     : result := 'PropertyTagImageTitle';
    PropertyTagCopyright                      : result := 'PropertyTagCopyright';
    PropertyTagResolutionXUnit                : result := 'PropertyTagResolutionXUnit';
    PropertyTagResolutionYUnit                : result := 'PropertyTagResolutionYUnit';
    PropertyTagResolutionXLengthUnit          : result := 'PropertyTagResolutionXLengthUnit';
    PropertyTagResolutionYLengthUnit          : result := 'PropertyTagResolutionYLengthUnit';
    PropertyTagPrintFlags                     : result := 'PropertyTagPrintFlags';
    PropertyTagPrintFlagsVersion              : result := 'PropertyTagPrintFlagsVersion';
    PropertyTagPrintFlagsCrop                 : result := 'PropertyTagPrintFlagsCrop';
    PropertyTagPrintFlagsBleedWidth           : result := 'PropertyTagPrintFlagsBleedWidth';
    PropertyTagPrintFlagsBleedWidthScale      : result := 'PropertyTagPrintFlagsBleedWidthScale';
    PropertyTagHalftoneLPI                    : result := 'PropertyTagHalftoneLPI';
    PropertyTagHalftoneLPIUnit                : result := 'PropertyTagHalftoneLPIUnit';
    PropertyTagHalftoneDegree                 : result := 'PropertyTagHalftoneDegree';
    PropertyTagHalftoneShape                  : result := 'PropertyTagHalftoneShape';
    PropertyTagHalftoneMisc                   : result := 'PropertyTagHalftoneMisc';
    PropertyTagHalftoneScreen                 : result := 'PropertyTagHalftoneScreen';
    PropertyTagJPEGQuality                    : result := 'PropertyTagJPEGQuality';
    PropertyTagGridSize                       : result := 'PropertyTagGridSize';
    PropertyTagThumbnailFormat                : result := 'PropertyTagThumbnailFormat';
    PropertyTagThumbnailWidth                 : result := 'PropertyTagThumbnailWidth';
    PropertyTagThumbnailHeight                : result := 'PropertyTagThumbnailHeight';
    PropertyTagThumbnailColorDepth            : result := 'PropertyTagThumbnailColorDepth';
    PropertyTagThumbnailPlanes                : result := 'PropertyTagThumbnailPlanes';
    PropertyTagThumbnailRawBytes              : result := 'PropertyTagThumbnailRawBytes';
    PropertyTagThumbnailSize                  : result := 'PropertyTagThumbnailSize';
    PropertyTagThumbnailCompressedSize        : result := 'PropertyTagThumbnailCompressedSize';
    PropertyTagColorTransferFunction          : result := 'PropertyTagColorTransferFunction';
    PropertyTagThumbnailData                  : result := 'PropertyTagThumbnailData';
    PropertyTagThumbnailImageWidth            : result := 'PropertyTagThumbnailImageWidth';
    PropertyTagThumbnailImageHeight           : result := 'PropertyTagThumbnailImageHeight';
    PropertyTagThumbnailBitsPerSample         : result := 'PropertyTagThumbnailBitsPerSample';
    PropertyTagThumbnailCompression           : result := 'PropertyTagThumbnailCompression';
    PropertyTagThumbnailPhotometricInterp     : result := 'PropertyTagThumbnailPhotometricInterp';
    PropertyTagThumbnailImageDescription      : result := 'PropertyTagThumbnailImageDescription';
    PropertyTagThumbnailEquipMake             : result := 'PropertyTagThumbnailEquipMake';
    PropertyTagThumbnailEquipModel            : result := 'PropertyTagThumbnailEquipModel';
    PropertyTagThumbnailStripOffsets          : result := 'PropertyTagThumbnailStripOffsets';
    PropertyTagThumbnailOrientation           : result := 'PropertyTagThumbnailOrientation';
    PropertyTagThumbnailSamplesPerPixel       : result := 'PropertyTagThumbnailSamplesPerPixel';
    PropertyTagThumbnailRowsPerStrip          : result := 'PropertyTagThumbnailRowsPerStrip';
    PropertyTagThumbnailStripBytesCount       : result := 'PropertyTagThumbnailStripBytesCount';
    PropertyTagThumbnailResolutionX           : result := 'PropertyTagThumbnailResolutionX';
    PropertyTagThumbnailResolutionY           : result := 'PropertyTagThumbnailResolutionY';
    PropertyTagThumbnailPlanarConfig          : result := 'PropertyTagThumbnailPlanarConfig';
    PropertyTagThumbnailResolutionUnit        : result := 'PropertyTagThumbnailResolutionUnit';
    PropertyTagThumbnailTransferFunction      : result := 'PropertyTagThumbnailTransferFunction';
    PropertyTagThumbnailSoftwareUsed          : result := 'PropertyTagThumbnailSoftwareUsed';
    PropertyTagThumbnailDateTime              : result := 'PropertyTagThumbnailDateTime';
    PropertyTagThumbnailArtist                : result := 'PropertyTagThumbnailArtist';
    PropertyTagThumbnailWhitePoint            : result := 'PropertyTagThumbnailWhitePoint';
    PropertyTagThumbnailPrimaryChromaticities : result := 'PropertyTagThumbnailPrimaryChromaticities';
    PropertyTagThumbnailYCbCrCoefficients     : result := 'PropertyTagThumbnailYCbCrCoefficients';
    PropertyTagThumbnailYCbCrSubsampling      : result := 'PropertyTagThumbnailYCbCrSubsampling';
    PropertyTagThumbnailYCbCrPositioning      : result := 'PropertyTagThumbnailYCbCrPositioning';
    PropertyTagThumbnailRefBlackWhite         : result := 'PropertyTagThumbnailRefBlackWhite';
    PropertyTagThumbnailCopyRight             : result := 'PropertyTagThumbnailCopyRight';
    PropertyTagLuminanceTable                 : result := 'PropertyTagLuminanceTable';
    PropertyTagChrominanceTable               : result := 'PropertyTagChrominanceTable';
    PropertyTagFrameDelay                     : result := 'PropertyTagFrameDelay';
    PropertyTagLoopCount                      : result := 'PropertyTagLoopCount';
    PropertyTagPixelUnit                      : result := 'PropertyTagPixelUnit';
    PropertyTagPixelPerUnitX                  : result := 'PropertyTagPixelPerUnitX';
    PropertyTagPixelPerUnitY                  : result := 'PropertyTagPixelPerUnitY';
    PropertyTagPaletteHistogram               : result := 'PropertyTagPaletteHistogram';
    PropertyTagExifExposureTime               : result := 'PropertyTagExifExposureTime';
    PropertyTagExifFNumber                    : result := 'PropertyTagExifFNumber';
    PropertyTagExifExposureProg               : result := 'PropertyTagExifExposureProg';
    PropertyTagExifSpectralSense              : result := 'PropertyTagExifSpectralSense';
    PropertyTagExifISOSpeed                   : result := 'PropertyTagExifISOSpeed';
    PropertyTagExifOECF                       : result := 'PropertyTagExifOECF';
    PropertyTagExifVer                        : result := 'PropertyTagExifVer';
    PropertyTagExifDTOrig                     : result := 'PropertyTagExifDTOrig';
    PropertyTagExifDTDigitized                : result := 'PropertyTagExifDTDigitized';
    PropertyTagExifCompConfig                 : result := 'PropertyTagExifCompConfig';
    PropertyTagExifCompBPP                    : result := 'PropertyTagExifCompBPP';
    PropertyTagExifShutterSpeed               : result := 'PropertyTagExifShutterSpeed';
    PropertyTagExifAperture                   : result := 'PropertyTagExifAperture';
    PropertyTagExifBrightness                 : result := 'PropertyTagExifBrightness';
    PropertyTagExifExposureBias               : result := 'PropertyTagExifExposureBias';
    PropertyTagExifMaxAperture                : result := 'PropertyTagExifMaxAperture';
    PropertyTagExifSubjectDist                : result := 'PropertyTagExifSubjectDist';
    PropertyTagExifMeteringMode               : result := 'PropertyTagExifMeteringMode';
    PropertyTagExifLightSource                : result := 'PropertyTagExifLightSource';
    PropertyTagExifFlash                      : result := 'PropertyTagExifFlash';
    PropertyTagExifFocalLength                : result := 'PropertyTagExifFocalLength';
    PropertyTagExifMakerNote                  : result := 'PropertyTagExifMakerNote';
    PropertyTagExifUserComment                : result := 'PropertyTagExifUserComment';
    PropertyTagExifDTSubsec                   : result := 'PropertyTagExifDTSubsec';
    PropertyTagExifDTOrigSS                   : result := 'PropertyTagExifDTOrigSS';
    PropertyTagExifDTDigSS                    : result := 'PropertyTagExifDTDigSS';
    PropertyTagExifFPXVer                     : result := 'PropertyTagExifFPXVer';
    PropertyTagExifColorSpace                 : result := 'PropertyTagExifColorSpace';
    PropertyTagExifPixXDim                    : result := 'PropertyTagExifPixXDim';
    PropertyTagExifPixYDim                    : result := 'PropertyTagExifPixYDim';
    PropertyTagExifRelatedWav                 : result := 'PropertyTagExifRelatedWav';
    PropertyTagExifInterop                    : result := 'PropertyTagExifInterop';
    PropertyTagExifFlashEnergy                : result := 'PropertyTagExifFlashEnergy';
    PropertyTagExifSpatialFR                  : result := 'PropertyTagExifSpatialFR';
    PropertyTagExifFocalXRes                  : result := 'PropertyTagExifFocalXRes';
    PropertyTagExifFocalYRes                  : result := 'PropertyTagExifFocalYRes';
    PropertyTagExifFocalResUnit               : result := 'PropertyTagExifFocalResUnit';
    PropertyTagExifSubjectLoc                 : result := 'PropertyTagExifSubjectLoc';
    PropertyTagExifExposureIndex              : result := 'PropertyTagExifExposureIndex';
    PropertyTagExifSensingMethod              : result := 'PropertyTagExifSensingMethod';
    PropertyTagExifFileSource                 : result := 'PropertyTagExifFileSource';
    PropertyTagExifSceneType                  : result := 'PropertyTagExifSceneType';
    PropertyTagExifCfaPattern                 : result := 'PropertyTagExifCfaPattern';
    PropertyTagGpsVer                         : result := 'PropertyTagGpsVer';
    PropertyTagGpsLatitudeRef                 : result := 'PropertyTagGpsLatitudeRef';
    PropertyTagGpsLatitude                    : result := 'PropertyTagGpsLatitude';
    PropertyTagGpsLongitudeRef                : result := 'PropertyTagGpsLongitudeRef';
    PropertyTagGpsLongitude                   : result := 'PropertyTagGpsLongitude';
    PropertyTagGpsAltitudeRef                 : result := 'PropertyTagGpsAltitudeRef';
    PropertyTagGpsAltitude                    : result := 'PropertyTagGpsAltitude';
    PropertyTagGpsGpsTime                     : result := 'PropertyTagGpsGpsTime';
    PropertyTagGpsGpsSatellites               : result := 'PropertyTagGpsGpsSatellites';
    PropertyTagGpsGpsStatus                   : result := 'PropertyTagGpsGpsStatus';
    PropertyTagGpsGpsMeasureMode              : result := 'PropertyTagGpsGpsMeasureMode';
    PropertyTagGpsGpsDop                      : result := 'PropertyTagGpsGpsDop';
    PropertyTagGpsSpeedRef                    : result := 'PropertyTagGpsSpeedRef';
    PropertyTagGpsSpeed                       : result := 'PropertyTagGpsSpeed';
    PropertyTagGpsTrackRef                    : result := 'PropertyTagGpsTrackRef';
    PropertyTagGpsTrack                       : result := 'PropertyTagGpsTrack';
    PropertyTagGpsImgDirRef                   : result := 'PropertyTagGpsImgDirRef';
    PropertyTagGpsImgDir                      : result := 'PropertyTagGpsImgDir';
    PropertyTagGpsMapDatum                    : result := 'PropertyTagGpsMapDatum';
    PropertyTagGpsDestLatRef                  : result := 'PropertyTagGpsDestLatRef';
    PropertyTagGpsDestLat                     : result := 'PropertyTagGpsDestLat';
    PropertyTagGpsDestLongRef                 : result := 'PropertyTagGpsDestLongRef';
    PropertyTagGpsDestLong                    : result := 'PropertyTagGpsDestLong';
    PropertyTagGpsDestBearRef                 : result := 'PropertyTagGpsDestBearRef';
    PropertyTagGpsDestBear                    : result := 'PropertyTagGpsDestBear';
    PropertyTagGpsDestDistRef                 : result := 'PropertyTagGpsDestDistRef';
    PropertyTagGpsDestDist                    : result := 'PropertyTagGpsDestDist';
  else
    result := '<UnKnown>';
  end;
end;

function GetEncoderClsid(format: String; out pClsid: TGUID): integer;
var
  num, size, j: UINT;
  ImageCodecInfo: PImageCodecInfo;
Type
  ArrIMgInf = array of TImageCodecInfo;
begin
  num  := 0; // number of image encoders
  size := 0; // size of the image encoder array in bytes
  result := -1;

  GetImageEncodersSize(num, size);
  if (size = 0) then exit;

  GetMem(ImageCodecInfo, size);
  if(ImageCodecInfo = nil) then exit;

  GetImageEncoders(num, size, ImageCodecInfo);

  for j := 0 to num - 1 do
  begin
    if( ArrIMgInf(ImageCodecInfo)[j].MimeType = format) then
    begin
      pClsid := ArrIMgInf(ImageCodecInfo)[j].Clsid;
      result := j;  // Success
    end;
  end;
  FreeMem(ImageCodecInfo, size);
end;

function GetStatus(Stat: TStatus): string;
begin
  case Stat of
    Ok                        : result := 'Ok';
    GenericError              : result := 'GenericError';
    InvalidParameter          : result := 'InvalidParameter';
    OutOfMemory               : result := 'OutOfMemory';
    ObjectBusy                : result := 'ObjectBusy';
    InsufficientBuffer        : result := 'InsufficientBuffer';
    NotImplemented            : result := 'NotImplemented';
    Win32Error                : result := 'Win32Error';
    WrongState                : result := 'WrongState';
    Aborted                   : result := 'Aborted';
    FileNotFound              : result := 'FileNotFound';
    ValueOverflow             : result := 'ValueOverflow';
    AccessDenied              : result := 'AccessDenied';
    UnknownImageFormat        : result := 'UnknownImageFormat';
    FontFamilyNotFound        : result := 'FontFamilyNotFound';
    FontStyleNotFound         : result := 'FontStyleNotFound';
    NotTrueTypeFont           : result := 'NotTrueTypeFont';
    UnsupportedGdiplusVersion : result := 'UnsupportedGdiplusVersion';
    GdiplusNotInitialized     : result := 'GdiplusNotInitialized';
    PropertyNotFound          : result := 'PropertyNotFound';
    PropertyNotSupported      : result := 'PropertyNotSupported';
  else
    result := '<UnKnown>';
  end;
end;

function PixelFormatString(PixelFormat: TPixelFormat): string;
begin
  case PixelFormat of
    PixelFormatIndexed        : result := 'PixelFormatIndexed';
    PixelFormatGDI            : result := 'PixelFormatGDI';
    PixelFormatAlpha          : result := 'PixelFormatAlpha';
    PixelFormatPAlpha         : result := 'PixelFormatPAlpha';
    PixelFormatExtended       : result := 'PixelFormatExtended';
    PixelFormatCanonical      : result := 'PixelFormatCanonical';
    PixelFormatUndefined      : result := 'PixelFormatUndefined';
    PixelFormat1bppIndexed    : result := 'PixelFormat1bppIndexed';
    PixelFormat4bppIndexed    : result := 'PixelFormat4bppIndexed';
    PixelFormat8bppIndexed    : result := 'PixelFormat8bppIndexed';
    PixelFormat16bppGrayScale : result := 'PixelFormat16bppGrayScale';
    PixelFormat16bppRGB555    : result := 'PixelFormat16bppRGB555';
    PixelFormat16bppRGB565    : result := 'PixelFormat16bppRGB565';
    PixelFormat16bppARGB1555  : result := 'PixelFormat16bppARGB1555';
    PixelFormat24bppRGB       : result := 'PixelFormat24bppRGB';
    PixelFormat32bppRGB       : result := 'PixelFormat32bppRGB';
    PixelFormat32bppARGB      : result := 'PixelFormat32bppARGB';
    PixelFormat32bppPARGB     : result := 'PixelFormat32bppPARGB';
    PixelFormat48bppRGB       : result := 'PixelFormat48bppRGB';
    PixelFormat64bppARGB      : result := 'PixelFormat64bppARGB';
    PixelFormat64bppPARGB     : result := 'PixelFormat64bppPARGB';
    PixelFormatMax            : result := 'PixelFormatMax';
  else
    result := '<UnKnown>';
  end;
end;

function MakeLangID(PrimaryLanguage, SubLanguage: LANGID): Word;
begin
  result := (SubLanguage shl 10) or PrimaryLanguage;
end;

end.
