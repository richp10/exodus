unit NGConst;

{****************************************************************************}
{*                                                                          *}
{*  for copyright and version information see header in NGImages.pas        *}
{*                                                                          *}
{****************************************************************************}
{*                                                                          *}
{*  Changelog:                            * reverse chronological order *   *}
{*                                                                          *}
{*  * 1.2.0  *                                                              *}
{*  2002/10/03 - GJU - Updated to libmng 1.0.5                              *}
{*                                                                          *}
{*  * 1.0.1  *                                                              *}
{*  2001/10/23 - GJU - Adapted to work with Kylix                           *}
{*                                                                          *}
{*  * 0.9.8 *                                                               *}
{*  2001/06/26 - GJU - Added stuff for late binding                         *}
{*  2001/06/16 - GJU - Moved all string-constants here                      *}
{*  2001/05/08 - SPR - Restructured for Maintainability                     *}
{*             - SPR - Seperated original NGImage.pas into multiple units   *}
{*                                                                          *}
{****************************************************************************}


{$INCLUDE NGDefs.inc}


interface


{****************************************************************************}

const
  { Library Name for early/late Binding }
{$IFDEF LINUX}
  mngdll              = 'libmng.so.1';                     // do not localize
  zdll                = 'libz.so.1';                       // do not localize
  jpegdll             = 'libjpeg.so.62';                   // do not localize
{$ELSE}
  mngdll              = 'libmng.dll';                      // do not localize
{$ENDIF}

  { Build Version Information - MODIFIED ON PUBLIC RELEASES ONLY! }
  TNGVersionStr       = '1.2.0';                           // do not localize
  TNGVersionMajor     = 1;
  TNGVersionMinor     = 2;
  TNGVersionRelease   = 0;

  TNGLibmngRequired   = '1.0.5';                           // do not localize

  { PNG & MNG spec constants }
  MNG_PNG_VERSION     = '1.2';                             // do not localize
  MNG_PNG_VERSION_MAJ = 1;
  MNG_PNG_VERSION_MIN = 2;

  MNG_MNG_VERSION     = '1.0';                             // do not localize
  MNG_MNG_VERSION_MAJ = 1;
  MNG_MNG_VERSION_MIN = 0;
  MNG_MNG_DRAFT       = 99;            // deprecated

  { Library Defined Constant Equivalents }
  MNG_TRUE            = TRUE;
  MNG_FALSE           = FALSE;
  MNG_NULL            = nil;

{****************************************************************************}
{* local constants & types                                                  *}
{****************************************************************************}

resourcestring
  SCClipboardNotSupported  = 'PNG/JNG/MNG clipboard not yet supported'; // do not localize
  SCNGImageException       = 'PNG/JNG/MNG error %s '#13#10'in function %s'#13#10 + // do not localize
                             'Code=%d; Severity=%d; Chunknr=%d; Extra=%d/%d'; // do not localize
  SCNGSavePNGillegal       = 'PNG save not supported in this state'; // do not localize
  SCNGSaveJNGillegal       = 'JNG save not supported in this state'; // do not localize
  SCNGVideoNotSupported    = 'Function not supported in video playback mode'; // do not localize
  SCNGVersionError         = 'NGImage %s requires libmng %s or later'; // do not localize

  SCZLIBError              = 'Serious ZLIB error...';      // do not localize

{$IFDEF LATE_BINDING}
{$IFDEF LINUX}
  SCDLLNotLoaded           = 'libmng.so was not loaded correctly'; // do not localize
  SCDLLNotLoaded2          = 'zlib.so was not loaded correctly'; // do not localize
{$ELSE}
  SCDLLNotLoaded           = 'libmng.dll was not loaded correctly'; // do not localize
{$ENDIF}
  SCFuncUnknown            = 'Function not available in this version'; // do not localize
{$ENDIF}

const
  SCPNGExt                 = 'PNG';                        // do not localize
  SCJNGExt                 = 'JNG';                        // do not localize
  SCMNGExt                 = 'MNG';                        // do not localize
  SCJPEGExt1               = 'JPE';                        // do not localize
  SCJPEGExt2               = 'JFIF';                       // do not localize
  SCJPEGExt3               = 'JPEG';                       // do not localize
  SCJPEGExt4               = 'JPG';                        // do not localize

  SCPNGImageFile           = 'Portable Network Graphics';  // do not localize
  SCJNGImageFile           = 'JPEG Network Graphics';      // do not localize
  SCMNGImageFile           = 'Multiple-image Network Graphics'; // do not localize
  SCJPEGImageFile          = 'JPEG image';                 // do not localize

{****************************************************************************}

  { function names for errormessages }
const
  SCCreate             = 'Create/';                        // do not localize
  SCInitialize         = 'initialize';                     // do not localize
  SCSetStoreChunks     = 'set_storechunks';                // do not localize
  SCSetCBxxxx          = 'setcb_xxxx';                     // do not localize
  SCSetCanvasStyle     = 'set_canvasstyle';                // do not localize
  SCDestroy            = 'Destroy/';                       // do not localize
  SCCleanup            = 'cleanup';                        // do not localize
  SCLoadFromStream     = 'LoadFromStream/';                // do not localize
  SCLoadFromFile       = 'LoadFromFile/';                  // do not localize
  SCSaveToStream       = 'SaveToStream/';                  // do not localize
  SCSaveToFile         = 'SaveToFile/';                    // do not localize
  SCTrapEvent          = 'TrapEvent/trapevent';            // do not localize
  SCLoadFromResource   = 'LoadFromResource/';              // do not localize
  SCRead               = 'read';                           // do not localize
  SCWrite              = 'write';                          // do not localize
  SCDisplay            = 'display';                        // do not localize
  SCProcessTimer       = 'ProcessTimer/';                  // do not localize
  SCDisplayResume      = 'display_resume';                 // do not localize
  SCRewind             = 'Rewind/';                        // do not localize
  SCDisplayReset       = 'display_reset';                  // do not localize
  SCPause              = 'Pause/';                         // do not localize
  SCDisplayFreeze      = 'display_freeze';                 // do not localize
  SCPlay               = 'Play/';                          // do not localize
  SCReset              = 'Reset/';                         // do not localize
  SCCreatePNG          = 'CreatePNG/';                     // do not localize
  SCCreateJNG          = 'CreateJNG/';                     // do not localize
  SCReset2             = 'reset';                          // do not localize
  SCCreate2            = 'create';                         // do not localize
  SCPutChunkIHDR       = 'putchunk_ihdr';                  // do not localize
  SCPutChunkJHDR       = 'putchunk_jhdr';                  // do not localize
  SCPutChunkSRGB       = 'putchunk_srgb';                  // do not localize
  SCPutChunkPLTE       = 'putchunk_plte';                  // do not localize
  SCPutChunkTRNS       = 'putchunk_trns';                  // do not localize
  SCPutChunkIDAT       = 'putchunk_idat';                  // do not localize
  SCPutChunkJDAT       = 'putchunk_jdat';                  // do not localize
  SCPutChunkIEND       = 'putchunk_iend';                  // do not localize
  SCSetCachePlayback   = 'set_cacheplayback';              // do not localize
  SCReadDisplay        = 'readdisplay';                    // do not localize
  SCSetBGImage         = 'setbgimage';                     // do not localize

{****************************************************************************}

  { Return Values }
const
  MNG_NOERROR          = 0;

  MNG_OUTOFMEMORY      = 1;
  MNG_INVALIDHANDLE    = 2;
  MNG_NOCALLBACK       = 3;
  MNG_UNEXPECTEDEOF    = 4;
  MNG_ZLIBERROR        = 5;
  MNG_JPEGERROR        = 6;
  MNG_LCMSERROR        = 7;
  MNG_NOOUTPUTPROFILE  = 8;
  MNG_NOSRGBPROFILE    = 9;
  MNG_BUFOVERFLOW      = 10;
  MNG_FUNCTIONINVALID  = 11;
  MNG_OUTPUTERROR      = 12;
  MNG_JPEGBUFTOOSMALL  = 13;
  MNG_NEEDMOREDATA     = 14;
  MNG_NEEDTIMERWAIT    = 15;
  MNG_NEEDSECTIONWAIT  = 16;
  MNG_LOOPWITHCACHEOFF = 17;

{$IFDEF LATE_BINDING}
  MNG_DLLNOTLOADED     = 99;
{$ENDIF}

  MNG_APPIOERROR       = 901;
  MNG_APPTIMERERROR    = 902;
  MNG_APPCMSERROR      = 903;
  MNG_APPMISCERROR     = 904;
  MNG_APPTRACEABORT    = 905;

  MNG_INTERNALERROR    = 999;

  MNG_INVALIDSIG       = 1025;
  MNG_INVALIDCRC       = 1027;
  MNG_INVALIDLENGTH    = 1028;
  MNG_SEQUENCEERROR    = 1029;
  MNG_CHUNKNOTALLOWED  = 1030;
  MNG_MULTIPLEERROR    = 1031;
  MNG_PLTEMISSING      = 1032;
  MNG_IDATMISSING      = 1033;
  MNG_CANNOTBEEMPTY    = 1034;
  MNG_GLOBALLENGTHERR  = 1035;
  MNG_INVALIDBITDEPTH  = 1036;
  MNG_INVALIDCOLORTYPE = 1037;
  MNG_INVALIDCOMPRESS  = 1038;
  MNG_INVALIDFILTER    = 1039;
  MNG_INVALIDINTERLACE = 1040;
  MNG_NOTENOUGHIDAT    = 1041;
  MNG_PLTEINDEXERROR   = 1042;
  MNG_NULLNOTFOUND     = 1043;
  MNG_KEYWORDNULL      = 1044;
  MNG_OBJECTUNKNOWN    = 1045;
  MNG_OBJECTEXISTS     = 1046;
  MNG_TOOMUCHIDAT      = 1047;
  MNG_INVSAMPLEDEPTH   = 1048;
  MNG_INVOFFSETSIZE    = 1049;
  MNG_INVENTRYTYPE     = 1050;
  MNG_ENDWITHNULL      = 1051;
  MNG_INVIMAGETYPE     = 1052;
  MNG_INVDELTATYPE     = 1053;
  MNG_INVALIDINDEX     = 1054;
  MNG_TOOMUCHJDAT      = 1055;
  MNG_JPEGPARMSERR     = 1056;
  MNG_INVFILLMETHOD    = 1057;
  MNG_OBJNOTCONCRETE   = 1058;
  MNG_TARGETNOALPHA    = 1059;
  MNG_MNGTOOCOMPLEX    = 1060;
  MNG_UNKNOWNCRITICAL  = 1061;
  MNG_UNSUPPORTEDNEED  = 1062;
  MNG_INVALIDDELTA     = 1063;
  MNG_INVALIDMETHOD    = 1064;
  MNG_IMPROBABLELENGTH = 1065;
  MNG_INVALIDBLOCK     = 1066;
  MNG_INVALIDEVENT     = 1067;
  MNG_INVALIDMASK      = 1068;
  MNG_NOMATCHINGLOOP   = 1069;
  MNG_SEEKNOTFOUND     = 1070;
  MNG_OBJNOTABSTRACT   = 1071;

  MNG_INVALIDCNVSTYLE  = 2049;
  MNG_WRONGCHUNK       = 2050;
  MNG_INVALIDENTRYIX   = 2051;
  MNG_NOHEADER         = 2052;
  MNG_NOCORRCHUNK      = 2053;
  MNG_NOMHDR           = 2054;

  MNG_IMAGETOOLARGE    = 4097;
  MNG_NOTANANIMATION   = 4098;
  MNG_FRAMENRTOOHIGH   = 4099;
  MNG_LAYERNRTOOHIGH   = 4100;
  MNG_PLAYTIMETOOHIGH  = 4101;
  MNG_FNNOTIMPLEMENTED = 4102;

  MNG_IMAGEFROZEN      = 8193;

  MNG_LCMS_NOHANDLE    = 1;
  MNG_LCMS_NOMEM       = 2;
  MNG_LCMS_NOTRANS     = 3;

{****************************************************************************}

const
  MNG_CANVAS_RGB8                  = $00000000;
  MNG_CANVAS_RGBA8                 = $00001000;
  MNG_CANVAS_ARGB8                 = $00003000;
  MNG_CANVAS_RGB8_A8               = $00005000;
  MNG_CANVAS_BGR8                  = $00000001;
  MNG_CANVAS_BGRA8                 = $00001001;
  MNG_CANVAS_BGRX8                 = $00010001;
  MNG_CANVAS_ABGR8                 = $00003001;

  MNG_BITDEPTH_1                   = 1;       { IHDR, BASI, JHDR, PROM }
  MNG_BITDEPTH_2                   = 2;
  MNG_BITDEPTH_4                   = 4;
  MNG_BITDEPTH_8                   = 8;       { sPLT }
  MNG_BITDEPTH_16                  = 16;

  MNG_COLORTYPE_GRAY               = 0;       { IHDR, BASI, PROM }
  MNG_COLORTYPE_RGB                = 2;
  MNG_COLORTYPE_INDEXED            = 3;
  MNG_COLORTYPE_GRAYA              = 4;
  MNG_COLORTYPE_RGBA               = 6;

  MNG_COMPRESSION_DEFLATE          = 0;       { IHDR, zTXt, iTXt, iCCP,
                                                BASI, JHDR }

  MNG_FILTER_ADAPTIVE              = 0;       { IHDR, BASI, JHDR }

  MNG_INTERLACE_NONE               = 0;       { IHDR, BASI, JHDR }
  MNG_INTERLACE_ADAM7              = 1;

  MNG_FILTER_NONE                  = 0;       { IDAT }
  MNG_FILTER_SUB                   = 1;
  MNG_FILTER_UP                    = 2;
  MNG_FILTER_AVERAGE               = 3;
  MNG_FILTER_PAETH                 = 4;

  MNG_INTENT_PERCEPTUAL            = 0;       { sRGB }
  MNG_INTENT_RELATIVECOLORIMETRIC  = 1;
  MNG_INTENT_SATURATION            = 2;
  MNG_INTENT_ABSOLUTECOLORIMETRIC  = 3;
                                              { tEXt, zTXt, iTXt }
  MNG_TEXT_TITLE                   = 'Title';              // do not localize
  MNG_TEXT_AUTHOR                  = 'Author';             // do not localize
  MNG_TEXT_DESCRIPTION             = 'Description';        // do not localize
  MNG_TEXT_COPYRIGHT               = 'Copyright';          // do not localize
  MNG_TEXT_CREATIONTIME            = 'Creation Time';      // do not localize
  MNG_TEXT_SOFTWARE                = 'Software';           // do not localize
  MNG_TEXT_DISCLAIMER              = 'Disclaimer';         // do not localize
  MNG_TEXT_WARNING                 = 'Warning';            // do not localize
  MNG_TEXT_SOURCE                  = 'Source';             // do not localize
  MNG_TEXT_COMMENT                 = 'Comment';            // do not localize

  MNG_FLAG_UNCOMPRESSED            = 0;       { iTXt }
  MNG_FLAG_COMPRESSED              = 1;

  MNG_UNIT_UNKNOWN                 = 0;       { pHYs, pHYg }
  MNG_UNIT_METER                   = 1;
                                              { MHDR }
  MNG_SIMPLICITY_VALID             = $00000001;
  MNG_SIMPLICITY_SIMPLEFEATURES    = $00000002;
  MNG_SIMPLICITY_COMPLEXFEATURES   = $00000004;
  MNG_SIMPLICITY_TRANSPARENCY      = $00000008;
  MNG_SIMPLICITY_JNG               = $00000010;
  MNG_SIMPLICITY_DELTAPNG          = $00000020;

  MNG_TERMINATION_DECODER_NC       = 0;       { LOOP }
  MNG_TERMINATION_USER_NC          = 1;
  MNG_TERMINATION_EXTERNAL_NC      = 2;
  MNG_TERMINATION_DETERMINISTIC_NC = 3;
  MNG_TERMINATION_DECODER_C        = 4;
  MNG_TERMINATION_USER_C           = 5;
  MNG_TERMINATION_EXTERNAL_C       = 6;
  MNG_TERMINATION_DETERMINISTIC_C  = 7;

  MNG_DONOTSHOW_VISIBLE            = 0;       { DEFI }
  MNG_DONOTSHOW_NOTVISIBLE         = 1;

  MNG_ABSTRACT                     = 0;       { DEFI }
  MNG_CONCRETE                     = 1;

  MNG_NOTVIEWABLE                  = 0;       { BASI }
  MNG_VIEWABLE                     = 1;

  MNG_FULL_CLONE                   = 0;       { CLON }
  MNG_PARTIAL_CLONE                = 1;
  MNG_RENUMBER                     = 2;

  MNG_CONCRETE_ASPARENT            = 0;       { CLON }
  MNG_CONCRETE_MAKEABSTRACT        = 1;

  MNG_LOCATION_ABSOLUTE            = 0;       { CLON, MOVE }
  MNG_LOCATION_RELATIVE            = 1;

  MNG_TARGET_ABSOLUTE              = 0;       { PAST }
  MNG_TARGET_RELATIVE_SAMEPAST     = 1;
  MNG_TARGET_RELATIVE_PREVPAST     = 2;

  MNG_COMPOSITE_OVER               = 0;       { PAST }
  MNG_COMPOSITE_REPLACE            = 1;
  MNG_COMPOSITE_UNDER              = 2;

  MNG_ORIENTATION_SAME             = 0;       { PAST }
  MNG_ORIENTATION_180DEG           = 2;
  MNG_ORIENTATION_FLIPHORZ         = 4;
  MNG_ORIENTATION_FLIPVERT         = 6;
  MNG_ORIENTATION_TILED            = 8;

  MNG_OFFSET_ABSOLUTE              = 0;       { PAST }
  MNG_OFFSET_RELATIVE              = 1;

  MNG_BOUNDARY_ABSOLUTE            = 0;       { PAST, FRAM }
  MNG_BOUNDARY_RELATIVE            = 1;

  MNG_BACKGROUNDCOLOR_MANDATORY    = $01;     { BACK }
  MNG_BACKGROUNDIMAGE_MANDATORY    = $02;     { BACK }

  MNG_BACKGROUNDIMAGE_NOTILE       = 0;       { BACK }
  MNG_BACKGROUNDIMAGE_TILE         = 1;

  MNG_FRAMINGMODE_NOCHANGE         = 0;       { FRAM }
  MNG_FRAMINGMODE_1                = 1;
  MNG_FRAMINGMODE_2                = 2;
  MNG_FRAMINGMODE_3                = 3;
  MNG_FRAMINGMODE_4                = 4;

  MNG_CHANGEDELAY_NO               = 0;       { FRAM }
  MNG_CHANGEDELAY_NEXTSUBFRAME     = 1;
  MNG_CHANGEDELAY_DEFAULT          = 2;

  MNG_CHANGETIMOUT_NO              = 0;       { FRAM }
  MNG_CHANGETIMOUT_DETERMINISTIC_1 = 1;
  MNG_CHANGETIMOUT_DETERMINISTIC_2 = 2;
  MNG_CHANGETIMOUT_DECODER_1       = 3;
  MNG_CHANGETIMOUT_DECODER_2       = 4;
  MNG_CHANGETIMOUT_USER_1          = 5;
  MNG_CHANGETIMOUT_USER_2          = 6;
  MNG_CHANGETIMOUT_EXTERNAL_1      = 7;
  MNG_CHANGETIMOUT_EXTERNAL_2      = 8;

  MNG_CHANGECLIPPING_NO            = 0;       { FRAM }
  MNG_CHANGECLIPPING_NEXTSUBFRAME  = 1;
  MNG_CHANGECLIPPING_DEFAULT       = 2;

  MNG_CHANGESYNCID_NO              = 0;       { FRAM }
  MNG_CHANGESYNCID_NEXTSUBFRAME    = 1;
  MNG_CHANGESYNCID_DEFAULT         = 2;

  MNG_CLIPPING_ABSOLUTE            = 0;       { CLIP }
  MNG_CLIPPING_RELATIVE            = 1;

  MNG_SHOWMODE_0                   = 0;       { SHOW }
  MNG_SHOWMODE_1                   = 1;
  MNG_SHOWMODE_2                   = 2;
  MNG_SHOWMODE_3                   = 3;
  MNG_SHOWMODE_4                   = 4;
  MNG_SHOWMODE_5                   = 5;
  MNG_SHOWMODE_6                   = 6;
  MNG_SHOWMODE_7                   = 7;

  MNG_TERMACTION_LASTFRAME         = 0;       { TERM }
  MNG_TERMACTION_CLEAR             = 1;
  MNG_TERMACTION_FIRSTFRAME        = 2;
  MNG_TERMACTION_REPEAT            = 3;

  MNG_ITERACTION_LASTFRAME         = 0;       { TERM }
  MNG_ITERACTION_CLEAR             = 1;
  MNG_ITERACTION_FIRSTFRAME        = 2;

  MNG_SAVEOFFSET_4BYTE             = 4;       { SAVE }
  MNG_SAVEOFFSET_8BYTE             = 8;

  MNG_SAVEENTRY_SEGMENTFULL        = 0;       { SAVE }
  MNG_SAVEENTRY_SEGMENT            = 1;
  MNG_SAVEENTRY_SUBFRAME           = 2;
  MNG_SAVEENTRY_EXPORTEDIMAGE      = 3;

  MNG_PRIORITY_ABSOLUTE            = 0;       { fPRI }
  MNG_PRIORITY_RELATIVE            = 1;

  MNG_COLORTYPE_JPEGGRAY           = 8;       { JHDR }
  MNG_COLORTYPE_JPEGCOLOR          = 10;
  MNG_COLORTYPE_JPEGGRAYA          = 12;
  MNG_COLORTYPE_JPEGCOLORA         = 14;

  MNG_BITDEPTH_JPEG8               = 8;       { JHDR }
  MNG_BITDEPTH_JPEG12              = 12;
  MNG_BITDEPTH_JPEG8AND12          = 20;

  MNG_COMPRESSION_BASELINEJPEG     = 8;       { JHDR }

  MNG_INTERLACE_SEQUENTIAL         = 0;       { JHDR }
  MNG_INTERLACE_PROGRESSIVE        = 8;

  MNG_IMAGETYPE_UNKNOWN            = 0;       { DHDR }
  MNG_IMAGETYPE_PNG                = 1;
  MNG_IMAGETYPE_JNG                = 2;

  MNG_DELTATYPE_REPLACE            = 0;       { DHDR }
  MNG_DELTATYPE_BLOCKPIXELADD      = 1;
  MNG_DELTATYPE_BLOCKALPHAADD      = 2;
  MNG_DELTATYPE_BLOCKCOLORADD      = 3;
  MNG_DELTATYPE_BLOCKPIXELREPLACE  = 4;
  MNG_DELTATYPE_BLOCKALPHAREPLACE  = 5;
  MNG_DELTATYPE_BLOCKCOLORREPLACE  = 6;
  MNG_DELTATYPE_NOCHANGE           = 7;

  MNG_FILLMETHOD_LEFTBITREPLICATE  = 0;       { PROM }
  MNG_FILLMETHOD_ZEROFILL          = 1;

  MNG_DELTATYPE_REPLACERGB         = 0;       { PPLT }
  MNG_DELTATYPE_DELTARGB           = 1;
  MNG_DELTATYPE_REPLACEALPHA       = 2;
  MNG_DELTATYPE_DELTAALPHA         = 3;
  MNG_DELTATYPE_REPLACERGBA        = 4;
  MNG_DELTATYPE_DELTARGBA          = 5;

  MNG_POLARITY_ONLY                = 0;       { DBYK }
  MNG_POLARITY_ALLBUT              = 1;

  MNG_EVENT_NONE                   = 0;       { EvNT }
  MNG_EVENT_MOUSEENTER             = 1;
  MNG_EVENT_MOUSEMOVE              = 2;
  MNG_EVENT_MOUSEEXIT              = 3;
  MNG_EVENT_MOUSEDOWN              = 4;
  MNG_EVENT_MOUSEUP                = 5;

  MNG_MASK_NONE                    = 0;       { EvNT }
  MNG_MASK_BOX                     = 1;
  MNG_MASK_OBJECT                  = 2;
  MNG_MASK_OBJECTIX                = 3;
  MNG_MASK_BOXOBJECT               = 4;
  MNG_MASK_BOXOBJECTIX             = 5;

  MNG_TYPE_TEXT                    = 0;
  MNG_TYPE_ZTXT                    = 1;
  MNG_TYPE_ITXT                    = 2;

{****************************************************************************}

implementation

{****************************************************************************}

end.





