unit NGTypes;

{****************************************************************************}
{*                                                                          *}
{*  for copyright and version information see header in NGImages.pas        *}
{*                                                                          *}
{****************************************************************************}
{*                                                                          *}
{*  Changelog:                            * reverse chronological order *   *}
{*                                                                          *}
{*  * 1.2.0  *                                                              *}
{*  2002/10/16 - GJU - Fixed string (de)compression routines                *}
{*  2002/10/03 - GJU - Updated to libmng 1.0.5                              *}
{*                                                                          *}
{*  * 1.0.1  *                                                              *}
{*  2001/10/23 - GJU - Adapted to work with Kylix                           *}
{*                                                                          *}
{*  * 0.9.8 *                                                               *}
{*  2001/07/16 - SPR - Added late binding for ZLIB                          *}
{*  2001/06/26 - GJU - Changed most CheckLIBMNGLoaded to assigned/exception *}
{*  2001/06/23 - SPR - Added stuff for late binding                         *}
{*  2001/05/08 - SPR - Restructured for Maintainability                     *}
{*             - SPR - Seperated original NGImage.pas into multiple units   *}
{*                                                                          *}
{****************************************************************************}


{$INCLUDE NGDefs.inc}



interface



{****************************************************************************}
{* LIBMNG interface definitions                                             *}
{* (translated from libmng.h)                                               *}
{****************************************************************************}


uses { Borland Standard Units }
{$IFDEF LINUX}
     SysUtils, QGraphics;
{$ELSE}
     Windows, Graphics;
{$ENDIF}


type
  { Exception Types }
  ENGImageException = class (EInvalidGraphicOperation);
  ENGDLLNotLoaded   = class (EInvalidGraphicOperation);
  ENGFuncUnknown    = class (EInvalidGraphicOperation);

  { Library Defined Data Types }
  { Note:  Items ending with the following are pointer types
      - The character "p"
      - The characters "ptr" or "pchar" }
  mng_uint32     = cardinal;
  mng_uint32p    = ^mng_uint32;

  mng_uint16     = word;
  mng_uint16p    = ^mng_uint16;

  mng_int32      = integer;
  mng_int16      = smallint;

  mng_uint8      = byte;
  mng_uint8p     = ^mng_uint8;

  mng_int8       = shortint;
  mng_bool       = boolean;
  mng_ptr        = pointer;
  mng_pchar      = pchar;

  mng_handle     = pointer;
  mng_retcode    = mng_int32;
  mng_chunkid    = mng_uint32;
  mng_chunkidp   = ^mng_chunkid;

  mng_size_t     = cardinal;

  mng_imgtype    = (mng_it_unknown, mng_it_png, mng_it_mng, mng_it_jng);
  mng_speedtype  = (mng_st_normal, mng_st_fast, mng_st_slow, mng_st_slowest);


  mng_palette8e  = packed record             // 8-bit palette element
                     iRed   : mng_uint8;
                     iGreen : mng_uint8;
                     iBlue  : mng_uint8;
                   end;

  mng_palette8   = packed array [0 .. 255] of mng_palette8e;

  mng_uint8arr   = packed array [0 .. 255] of mng_uint8;
  mng_uint8arr4  = packed array [0 ..   3] of mng_uint8;
  mng_uint16arr  = packed array [0 .. 255] of mng_uint16;
  mng_uint32arr  = packed array [0 .. 255] of mng_uint32;
  mng_uint32arr2 = packed array [0 ..   1] of mng_uint32;

{****************************************************************************}
{ Call-Back Function Definitions }
type
  { Function Types Referenced by Other Function Definitions }
  Tmng_memalloc            = function  (    iLen         : mng_size_t) : mng_ptr;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_memfree             = procedure (    iPtr         : mng_ptr;
                                            iLen         : mng_size_t);
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_openstream          = function  (    hHandle      : mng_handle) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_closestream         = function  (    hHandle      : mng_handle) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_readdata            = function  (    hHandle      : mng_handle;
                                            pBuf         : mng_ptr;
                                            iBuflen      : mng_uint32;
                                        var pRead        : mng_uint32) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_writedata           = function  (    hHandle      : mng_handle;
                                            pBuf         : mng_ptr;
                                            iBuflen      : mng_uint32;
                                        var pWritten     : mng_uint32) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_errorproc           = function  (    hHandle      : mng_handle;
                                            iErrorcode   : mng_retcode;
                                            iSeverity    : mng_uint8;
                                            iChunkname   : mng_chunkid;
                                            iChunkseq    : mng_uint32;
                                            iExtra1      : mng_int32;
                                            iExtra2      : mng_int32;
                                            zErrortext   : mng_pchar ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_traceproc           = function  (    hHandle      : mng_handle;
                                            iFuncnr      : mng_int32;
                                            iFuncseq     : mng_uint32;
                                            zFuncname    : mng_pchar ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_processheader       = function  (    hHandle      : mng_handle;
                                            iWidth       : mng_uint32;
                                            iHeight      : mng_uint32) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_processtext         = function  (    hHandle      : mng_handle;
                                            iType        : mng_uint8;
                                            zKeyword     : mng_pchar;
                                            zText        : mng_pchar;
                                            zLanguage    : mng_pchar;
                                            zTranslation : mng_pchar ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_processsave         = function  (    hHandle      : mng_handle) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_processseek         = function  (    hHandle      : mng_handle;
                                            zName        : mng_pchar ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_processneed         = function  (    hHandle      : mng_handle;
                                            zName        : mng_pchar ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_processmend         = function  (    hHandle      : mng_handle;
                                            iIterationsdone : mng_uint32;
                                            iIterationsleft : mng_uint32) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_processunknown      = function  (    hHandle      : mng_handle;
                                            iChunkid     : mng_chunkid;
                                            iRawlen      : mng_uint32;
                                            pRawdata     : mng_ptr   ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_processterm         = function  (    hHandle      : mng_handle;
                                            iTermaction  : mng_uint8;
                                            iIteraction  : mng_uint8;
                                            iDelay       : mng_uint32;
                                            iItermax     : mng_uint32) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_getcanvasline       = function  (    hHandle      : mng_handle;
                                            iLinenr      : mng_uint32) : mng_ptr;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getalphaline        = function  (    hHandle      : mng_handle;
                                            iLinenr      : mng_uint32) : mng_ptr;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getbkgdline         = function  (    hHandle      : mng_handle;
                                            iLinenr      : mng_uint32) : mng_ptr;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_refresh             = function  (    hHandle      : mng_handle;
                                            iX           : mng_uint32;
                                            iY           : mng_uint32;
                                            iWidth       : mng_uint32;
                                            iHeight      : mng_uint32) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_gettickcount        = function  (    hHandle      : mng_handle) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_settimer            = function  (    hHandle      : mng_handle;
                                            iMsecs       : mng_uint32) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_iteratechunk        = function  (    hHandle      : mng_handle;
                                            hChunk       : mng_handle;
                                            iChunkid     : mng_chunkid;
                                            iChunkseq    : mng_uint32) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}
  { Interface for either the Early or Late Binding to the DLL }
  function mng_version_text    : mng_pchar;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_version_so      : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_version_dll     : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_version_major   : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_version_minor   : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_version_release : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_version_beta    : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

{****************************************************************************}

  function mng_supports_func        (zFunction          : mng_pchar;
                                     var iMajor         : mng_uint8;
                                     var iMinor         : mng_uint8;
                                     var iRelease       : mng_uint8         ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

{****************************************************************************}

  function mng_initialize           (pUserdata          : mng_ptr;
                                     fMemalloc          : Tmng_memalloc;
                                     fMemfree           : Tmng_memfree;
                                     fTraceproc         : Tmng_traceproc    ) : mng_handle;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_reset                (hHandle            : mng_handle        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_cleanup              (var hHandle        : mng_handle        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_read(hHandle                             : mng_handle        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_write(hHandle                            : mng_handle        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_create(hHandle                           : mng_handle        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_readdisplay          (hHandle            : mng_handle        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_display              (hHandle            : mng_handle        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_display_resume       (hHandle            : mng_handle        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_display_freeze       (hHandle            : mng_handle        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_display_reset        (hHandle            : mng_handle        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_trapevent            (hHandle            : mng_handle;
                                     iEventtype         : mng_uint8;
                                     iX                 : mng_int32;
                                     iY                 : mng_int32         ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_getlasterror         (hHandle            : mng_handle;
                                     var iSeverity      : mng_uint8;
                                     var iChunkname     : mng_chunkid;
                                     var iChunkseq      : mng_uint32;
                                     var iExtra1        : mng_int32;
                                     var iExtra2        : mng_int32;
                                     var zErrortext     : mng_pchar         ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

{****************************************************************************}

  function mng_setcb_memalloc       (hHandle            : mng_handle;
                                     fProc              : Tmng_memalloc     ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_memfree        (hHandle            : mng_handle;
                                     fProc              : Tmng_memfree      ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_setcb_openstream     (hHandle            : mng_handle;
                                     fProc              : Tmng_openstream   ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_closestream    (hHandle            : mng_handle;
                                     fProc              : Tmng_closestream  ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_setcb_readdata       (hHandle            : mng_handle;
                                     fProc              : Tmng_readdata     ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_setcb_writedata      (hHandle            : mng_handle;
                                     fProc              : Tmng_writedata    ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_setcb_errorproc      (hHandle            : mng_handle;
                                     fProc              : Tmng_errorproc    ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_setcb_processheader  (hHandle            : mng_handle;
                                     fProc              : Tmng_processheader) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_processtext    (hHandle            : mng_handle;
                                     fProc              : Tmng_processtext  ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_processsave    (hHandle            : mng_handle;
                                     fProc              : Tmng_processsave  ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_processseek    (hHandle            : mng_handle;
                                     fProc              : Tmng_processseek  ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_processneed    (hHandle            : mng_handle;
                                     fProc              : Tmng_processneed  ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_processmend    (hHandle            : mng_handle;
                                     fProc              : Tmng_processmend  ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_processunknown (hHandle            : mng_handle;
                                     fProc              : Tmng_processunknown) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_processterm    (hHandle            : mng_handle;
                                     fProc              : Tmng_processterm  ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_setcb_getcanvasline  (hHandle            : mng_handle;
                                     fProc              : Tmng_getcanvasline) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_getalphaline   (hHandle            : mng_handle;
                                     fProc              : Tmng_getalphaline ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_getbkgdline    (hHandle            : mng_handle;
                                     fProc              : Tmng_getbkgdline  ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_refresh        (hHandle            : mng_handle;
                                     fProc              : Tmng_refresh      ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_setcb_gettickcount   (hHandle            : mng_handle;
                                     fProc              : Tmng_gettickcount ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_setcb_settimer       (hHandle            : mng_handle;
                                     fProc              : Tmng_settimer     ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

{****************************************************************************}

  function mng_getcb_memalloc       (hHandle            : mng_handle       ) : Tmng_memalloc;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_memfree        (hHandle            : mng_handle       ) : Tmng_memfree;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_getcb_openstream     (hHandle            : mng_handle       ) : Tmng_openstream;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_closestream    (hHandle            : mng_handle       ) : Tmng_closestream;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_getcb_readdata       (hHandle            : mng_handle       ) : Tmng_readdata;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_getcb_writedata      (hHandle            : mng_handle       ) : Tmng_writedata;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_getcb_errorproc      (hHandle            : mng_handle       ) : Tmng_errorproc;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_getcb_processheader  (hHandle            : mng_handle       ) : Tmng_processheader;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_processtext    (hHandle            : mng_handle       ) : Tmng_processtext;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_processsave    (hHandle            : mng_handle       ) : Tmng_processsave;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_processseek    (hHandle            : mng_handle       ) : Tmng_processseek;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_processneed    (hHandle            : mng_handle       ) : Tmng_processneed;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_processmend    (hHandle            : mng_handle       ) : Tmng_processmend;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_processunknown (hHandle            : mng_handle       ) : Tmng_processunknown;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_processterm    (hHandle            : mng_handle       ) : Tmng_processterm;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_getcb_getcanvasline  (hHandle            : mng_handle       ) : Tmng_getcanvasline;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_getalphaline   (hHandle            : mng_handle       ) : Tmng_getalphaline;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_getbkgdline    (hHandle            : mng_handle       ) : Tmng_getbkgdline;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_refresh        (hHandle            : mng_handle       ) : Tmng_refresh;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_getcb_gettickcount   (hHandle            : mng_handle       ) : Tmng_gettickcount;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_getcb_settimer       (hHandle            : mng_handle       ) : Tmng_settimer;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

{****************************************************************************}

  function mng_set_userdata         (hHandle            : mng_handle;
                                     pUserdata          : mng_ptr          ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_set_canvasstyle      (hHandle            : mng_handle;
                                     iStyle             : mng_uint32       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_set_bkgdstyle        (hHandle            : mng_handle;
                                     iStyle             : mng_uint32       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_set_bgcolor          (hHandle            : mng_handle;
                                     iRed               : mng_uint16;
                                     iGreen             : mng_uint16;
                                     iBlue              : mng_uint16       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_set_usebkgd          (hHandle            : mng_handle;
                                     bUseBKGD           : mng_bool         ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_set_storechunks      (hHandle            : mng_handle;
                                     bStorechunks       : mng_bool         ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_set_cacheplayback    (hHandle            : mng_handle;
                                     bCacheplayback     : mng_bool         ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_set_viewgammaint     (hHandle            : mng_handle;
                                     iGamma             : mng_uint32       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_set_displaygammaint  (hHandle            : mng_handle;
                                     iGamma             : mng_uint32       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_set_dfltimggammaint  (hHandle            : mng_handle;
                                     iGamma             : mng_uint32       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_set_srgb             (hHandle            : mng_handle;
                                     bIssRGB            : mng_bool         ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_set_outputprofile    (hHandle            : mng_handle;
                                     zFilename          : mng_pchar        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_set_outputprofile2   (hHandle            : mng_handle;
                                     iProfilesize       : mng_uint32;
                                     pProfile           : mng_ptr          ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_set_outputsrgb       (hHandle            : mng_handle       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_set_srgbprofile      (hHandle            : mng_handle;
                                     zFilename          : mng_pchar        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_set_srgbprofile2     (hHandle            : mng_handle;
                                     iProfilesize       : mng_uint32;
                                     pProfile           : mng_ptr          ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_set_srgbimplicit     (hHandle            : mng_handle       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_set_maxcanvassize    (hHandle            : mng_handle;
                                     iMaxwidth          : mng_uint32;
                                     iMaxheight         : mng_uint32       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

{****************************************************************************}

  function mng_get_userdata         (hHandle            : mng_handle       ) : mng_ptr;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_get_sigtype          (hHandle            : mng_handle       ) : mng_imgtype;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_imagetype        (hHandle            : mng_handle       ) : mng_imgtype;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_imagewidth       (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_imageheight      (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_ticks            (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_framecount       (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_layercount       (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_playtime         (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_simplicity       (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_get_bitdepth         (hHandle            : mng_handle       ) : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_colortype        (hHandle            : mng_handle       ) : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_compression      (hHandle            : mng_handle       ) : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_filter           (hHandle            : mng_handle       ) : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_interlace        (hHandle            : mng_handle       ) : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_alphabitdepth    (hHandle            : mng_handle       ) : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_alphacompression (hHandle            : mng_handle       ) : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_alphafilter      (hHandle            : mng_handle       ) : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_alphainterlace   (hHandle            : mng_handle       ) : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_get_alphadepth       (hHandle            : mng_handle       ) : mng_uint8;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  procedure mng_get_bgcolor         (hHandle            : mng_handle;
                                     var iRed           : mng_uint16;
                                     var iGreen         : mng_uint16;
                                     var iBlue          : mng_uint16       );
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_get_usebkgd          (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_get_viewgammaint     (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_displaygammaint  (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_dfltimggammaint  (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_get_srgb             (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_get_maxcanvaswidth   (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_maxcanvasheight  (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_get_starttime        (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_runtime          (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_currentframe     (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_currentlayer     (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_get_currentplaytime  (hHandle            : mng_handle       ) : mng_uint32;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

  function mng_status_error         (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_status_reading       (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_status_suspendbreak  (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_status_creating      (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_status_writing       (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_status_displaying    (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_status_running       (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_status_timerbreak    (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_status_dynamic       (hHandle            : mng_handle       ) : mng_bool;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

{****************************************************************************}

  function mng_putchunk_ihdr        (hHandle            : mng_handle;
                                     iWidth             : mng_uint32;
                                     iHeight            : mng_uint32;
                                     iBitdepth          : mng_uint8;
                                     iColortype         : mng_uint8;
                                     iCompression       : mng_uint8;
                                     iFilter            : mng_uint8;
                                     iInterlace         : mng_uint8        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_plte        (hHandle            : mng_handle;
                                     iCount             : mng_uint32;
                                     aPalette           : mng_palette8     ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_idat        (hHandle            : mng_handle;
                                     iRawlen            : mng_uint32;
                                     pRawdata           : mng_ptr          ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_iend        (hHandle            : mng_handle       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_trns        (hHandle            : mng_handle;
                                     bEmpty             : mng_bool;
                                     bGlobal            : mng_bool;
                                     iType              : mng_uint8;
                                     iCount             : mng_uint32;
                                     aAlphas            : mng_uint8arr;
                                     iGray              : mng_uint16;
                                     iRed               : mng_uint16;
                                     iGreen             : mng_uint16;
                                     iBlue              : mng_uint16;
                                     iRawlen            : mng_uint32;
                                     aRawdata           : mng_uint8arr     ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_gama        (hHandle            : mng_handle;
                                     bEmpty             : mng_bool;
                                     iGamma             : mng_uint32       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_chrm        (hHandle            : mng_handle;
                                     bEmpty             : mng_bool;
                                     iWhitepointx       : mng_uint32;
                                     iWhitepointy       : mng_uint32;
                                     iRedx              : mng_uint32;
                                     iRedy              : mng_uint32;
                                     iGreenx            : mng_uint32;
                                     iGreeny            : mng_uint32;
                                     iBluex             : mng_uint32;
                                     iBluey             : mng_uint32       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_srgb        (hHandle            : mng_handle;
                                     bEmpty             : mng_bool;
                                     iRenderingintent   : mng_uint8        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_iccp        (hHandle            : mng_handle;
                                     bEmpty             : mng_bool;
                                     iNamesize          : mng_uint32;
                                     zName              : mng_pchar;
                                     iCompression       : mng_uint8;
                                     iProfilesize       : mng_uint32;
                                     pProfile           : mng_ptr          ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_text        (hHandle            : mng_handle;
                                     iKeywordsize       : mng_uint32;
                                     zKeyword           : mng_pchar;
                                     iTextsize          : mng_uint32;
                                     zText              : mng_pchar        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_ztxt        (hHandle            : mng_handle;
                                     iKeywordsize       : mng_uint32;
                                     zKeyword           : mng_pchar;
                                     iCompression       : mng_uint8;
                                     iTextsize          : mng_uint32;
                                     zText              : mng_pchar        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_itxt        (hHandle            : mng_handle;
                                     iKeywordsize       : mng_uint32;
                                     zKeyword           : mng_pchar;
                                     iCompressionflag   : mng_uint8;
                                     iCompressionmethod : mng_uint8;
                                     iLanguagesize      : mng_uint32;
                                     zLanguage          : mng_pchar;
                                     iTranslationsize   : mng_uint32;
                                     zTranslation       : mng_pchar;
                                     iTextsize          : mng_uint32;
                                     zText              : mng_pchar        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_bkgd        (hHandle            : mng_handle;
                                     bEmpty             : mng_bool;
                                     iType              : mng_uint8;
                                     iIndex             : mng_uint8;
                                     iGray              : mng_uint16;
                                     iRed               : mng_uint16;
                                     iGreen             : mng_uint16;
                                     iBlue              : mng_uint16       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_phys        (hHandle            : mng_handle;
                                     bEmpty             : mng_bool;
                                     iSizex             : mng_uint32;
                                     iSizey             : mng_uint32;
                                     iUnit              : mng_uint8        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_sbit        (hHandle            : mng_handle;
                                     bEmpty             : mng_bool;
                                     iType              : mng_uint8;
                                     aBits              : mng_uint8arr4    ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_splt        (hHandle            : mng_handle;
                                     bEmpty             : mng_bool;
                                     iNamesize          : mng_uint32;
                                     zName              : mng_pchar;
                                     iSampledepth       : mng_uint8;
                                     iEntrycount        : mng_uint32;
                                     pEntries           : mng_ptr          ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_hist        (hHandle            : mng_handle;
                                     iEntrycount        : mng_uint32;
                                     aEntries           : mng_uint16arr    ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_time        (hHandle            : mng_handle;
                                     iYear              : mng_uint16;
                                     iMonth             : mng_uint8;
                                     iDay               : mng_uint8;
                                     iHour              : mng_uint8;
                                     iMinute            : mng_uint8;
                                     iSecond            : mng_uint8        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_jhdr        (hHandle            : mng_handle;
                                     iWidth             : mng_uint32;
                                     iHeight            : mng_uint32;
                                     iColortype         : mng_uint8;
                                     iImagesampledepth  : mng_uint8;
                                     iImagecompression  : mng_uint8;
                                     iImageinterlace    : mng_uint8;
                                     iAlphasampledepth  : mng_uint8;
                                     iAlphacompression  : mng_uint8;
                                     iAlphafilter       : mng_uint8;
                                     iAlphainterlace    : mng_uint8        ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_jdat        (hHandle            : mng_handle;
                                     iRawlen            : mng_uint32;
                                     pRawdata           : mng_ptr          ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}
  function mng_putchunk_jsep        (hHandle            : mng_handle       ) : mng_retcode;
  {$IFNDEF LATE_BINDING} {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF} {$ENDIF}

{****************************************************************************}
{* LIBMNG interface definitions for ZLIB                                    *}
{****************************************************************************}
{*                                                                          *}
{*  Uses "zlib" - a mighty, patent-free(!) (de)compression-library          *}
{*  copyright (C) 1995-2002 Jean-loup Gailly and Mark Adler                 *}
{*  http://www.info-zip.org/pub/infozip/zlib                                *}
{*                                                                          *}
{****************************************************************************}

{$IFDEF INCLUDE_ZLIB}

{****************************************************************************}

function InflateString  (    Input      : string;
                         var Output     : string ) : integer;

function DeflateString  (    Input      : string;
                         var Output     : string ) : integer;

function InflateString2 (    Input      : string;
                         var Output     : string;
                             windowBits : integer) : integer;

function DeflateString2 (    Input      : string;
                         var Output     : string;
                             level      : integer;
                             method     : integer;
                             windowBits : integer;
                             memLevel   : integer;
                             strategy   : integer) : integer;

{****************************************************************************}

const
  ZLIB_VERSION          = '1.1.4';                         // do not localize

  { Return Values }
  Z_NO_FLUSH            = 0;
  Z_PARTIAL_FLUSH       = 1;
  Z_SYNC_FLUSH          = 2;
  Z_FULL_FLUSH          = 3;
  Z_FINISH              = 4;

  Z_OK                  = 0;
  Z_STREAM_END          = 1;
  Z_NEED_DICT           = 2;
  Z_ERRNO               = -1;
  Z_STREAM_ERROR        = -2;
  Z_DATA_ERROR          = -3;
  Z_MEM_ERROR           = -4;
  Z_BUF_ERROR           = -5;
  Z_VERSION_ERROR       = -6;

  Z_NO_COMPRESSION      = 0;
  Z_BEST_SPEED          = 1;
  Z_BEST_COMPRESSION    = 9;
  Z_DEFAULT_COMPRESSION = -1;

  Z_FILTERED            = 1;
  Z_HUFFMAN_ONLY        = 2;
  Z_DEFAULT_STRATEGY    = 0;

  Z_BINARY              = 0;
  Z_ASCII               = 1;
  Z_UNKNOWN             = 2;

  Z_DEFLATED            = 8;

  Z_NULL                = 0;

  Z_MAX_MEM_LEVEL       = 9;
  Z_DEF_MEM_LEVEL       = 8;

{****************************************************************************}

type
  alloc_func = function  (opaque  : pointer;
                          items   : integer;
                          size    : integer) : pointer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  free_func  = procedure (opaque  : pointer;
                          address : pointer);
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

type
  z_stream   = packed record
                 next_in   : pointer;
                 avail_in  : integer;
                 total_in  : cardinal;

                 next_out  : pointer;
                 avail_out : integer;
                 total_out : cardinal;

                 msg       : pchar;
                 state     : pointer;    { reserved }

                 zalloc    : alloc_func;
                 zfree     : free_func;
                 opaque    : pointer;

                 data_type : integer;
                 adler     : cardinal;
                 reserved  : cardinal;
               end;

  z_streamp  = ^z_stream;

{****************************************************************************}

function zlibVersion : pchar;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function deflateInit          (strm        : z_streamp;
                               level       : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function deflate              (strm        : z_streamp;
                               flush       : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function deflateEnd           (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function inflateInit          (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function inflate              (strm        : z_streamp;
                               flush       : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function inflateEnd           (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function deflateInit2         (strm        : z_streamp;
                               level       : integer;
                               method      : integer;
                               windowBits  : integer;
                               memLevel    : integer;
                               strategy    : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function deflateSetDictionary (strm        : z_streamp;
                               dictionary  : pointer;
                               dictLength  : cardinal ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function deflateCopy          (dest        : z_streamp;
                               source      : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function deflateReset         (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function deflateParams        (strm        : z_streamp;
                               level       : integer;
                               strategy    : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function inflateInit2         (strm        : z_streamp;
                               windowBits  : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function inflateSetDictionary (strm        : z_streamp;
                               dictionary  : pointer;
                               dictLength  : cardinal ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function inflateSync          (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function inflateReset         (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function compress             (dest        : pointer;
                               var destLen : cardinal;
                               source      : pointer;
                               sourceLen   : cardinal ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function compress2            (dest        : pointer;
                               var destLen : cardinal;
                               source      : pointer;
                               sourceLen   : cardinal;
                               level       : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function uncompress           (dest        : pointer;
                               var destLen : cardinal;
                               source      : pointer;
                               sourceLen   : cardinal ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function adler32              (adler       : cardinal;
                               buf         : pointer;
                               len         : cardinal ) : cardinal;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function crc32                (crc         : cardinal;
                               buf         : pointer;
                               len         : cardinal ) : cardinal;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function zError               (err         : integer  ) : pchar;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function inflateSyncPoint     (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

function get_crc_table : pointer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

{$ENDIF} // INCLUDE_ZLIB


{****************************************************************************}

{$IFDEF LATE_BINDING}

procedure BeginUseLibmng;
procedure EndUseLibmng;
procedure BeginUseZLib;
procedure EndUseZLib;

{$ENDIF}

{****************************************************************************}


implementation


uses { Own Units }
     NGConst;


{****************************************************************************}

  { Working Function Definitions for implementation of both Early and Late Binding to the DLL }
type
  Tmng_version_text        = function: mng_pchar;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_version_so          = function: mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_version_dll         = function: mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_version_major       = function: mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_version_minor       = function: mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_version_release     = function: mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_version_beta        = function: mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

  Tmng_supports_func       = function (zFunction          : mng_pchar;
                                       var iMajor         : mng_uint8;
                                       var iMinor         : mng_uint8;
                                       var iRelease       : mng_uint8        ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

  Tmng_initialize          = function (pUserdata          : mng_ptr;
                                       fMemalloc          : Tmng_memalloc;
                                       fMemfree           : Tmng_memfree;
                                       fTraceproc         : Tmng_traceproc   ) : mng_handle;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_reset               = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_cleanup             = function (var hHandle        : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_read                = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_write               = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_create              = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_readdisplay         = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_display             = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_display_resume      = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_display_freeze      = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_display_reset       = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_trapevent           = function (hHandle            : mng_handle;
                                       iEventtype         : mng_uint8;
                                       iX                 : mng_int32;
                                       iY                 : mng_int32        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_getlasterror        = function (hHandle            : mng_handle;
                                       var iSeverity      : mng_uint8;
                                       var iChunkname     : mng_chunkid;
                                       var iChunkseq      : mng_uint32;
                                       var iExtra1        : mng_int32;
                                       var iExtra2        : mng_int32;
                                       var zErrortext     : mng_pchar        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

  Tmng_setcb_memalloc      = function (hHandle            : mng_handle;
                                       fProc              : Tmng_memalloc     ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_memfree       = function (hHandle            : mng_handle;
                                       fProc              : Tmng_memfree      ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_setcb_openstream    = function (hHandle            : mng_handle;
                                       fProc              : Tmng_openstream   ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_closestream   = function (hHandle            : mng_handle;
                                       fProc              : Tmng_closestream  ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_setcb_readdata      = function (hHandle            : mng_handle;
                                       fProc              : Tmng_readdata     ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_setcb_writedata     = function (hHandle            : mng_handle;
                                       fProc              : Tmng_writedata    ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_setcb_errorproc     = function (hHandle            : mng_handle;
                                       fProc              : Tmng_errorproc    ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_setcb_processheader = function (hHandle            : mng_handle;
                                       fProc              : Tmng_processheader) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_processtext   = function (hHandle            : mng_handle;
                                       fProc              : Tmng_processtext  ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_processsave   = function (hHandle            : mng_handle;
                                       fProc              : Tmng_processsave  ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_processseek   = function (hHandle            : mng_handle;
                                       fProc              : Tmng_processseek  ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_processneed   = function (hHandle            : mng_handle;
                                       fProc              : Tmng_processneed  ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_processmend   = function (hHandle            : mng_handle;
                                       fProc              : Tmng_processmend  ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_processunknown = function (hHandle            : mng_handle;
                                       fProc              : Tmng_processunknown) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_processterm   = function (hHandle            : mng_handle;
                                       fProc              : Tmng_processterm  ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_setcb_getcanvasline = function (hHandle            : mng_handle;
                                       fProc              : Tmng_getcanvasline) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_getalphaline  = function (hHandle            : mng_handle;
                                       fProc              : Tmng_getalphaline ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_getbkgdline   = function (hHandle            : mng_handle;
                                       fProc              : Tmng_getbkgdline  ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_refresh       = function (hHandle            : mng_handle;
                                       fProc              : Tmng_refresh      ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_setcb_gettickcount  = function (hHandle            : mng_handle;
                                       fProc              : Tmng_gettickcount ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_setcb_settimer      = function (hHandle            : mng_handle;
                                       fProc              : Tmng_settimer     ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

  Tmng_getcb_memalloc      = function (hHandle            : mng_handle       ) : Tmng_memalloc;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_memfree       = function (hHandle            : mng_handle       ) : Tmng_memfree;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_getcb_openstream    = function (hHandle            : mng_handle       ) : Tmng_openstream;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_closestream   = function (hHandle            : mng_handle       ) : Tmng_closestream;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_getcb_readdata      = function (hHandle            : mng_handle       ) : Tmng_readdata;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_getcb_writedata     = function (hHandle            : mng_handle       ) : Tmng_writedata;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_getcb_errorproc     = function (hHandle            : mng_handle       ) : Tmng_errorproc;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_getcb_processheader = function (hHandle            : mng_handle       ) : Tmng_processheader;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_processtext   = function (hHandle            : mng_handle       ) : Tmng_processtext;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_processsave   = function (hHandle            : mng_handle       ) : Tmng_processsave;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_processseek   = function (hHandle            : mng_handle       ) : Tmng_processseek;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_processneed   = function (hHandle            : mng_handle       ) : Tmng_processneed;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_processmend   = function (hHandle            : mng_handle       ) : Tmng_processmend;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_processunknown = function (hHandle           : mng_handle       ) : Tmng_processunknown;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_processterm   = function (hHandle            : mng_handle       ) : Tmng_processterm;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_getcb_getcanvasline = function (hHandle            : mng_handle       ) : Tmng_getcanvasline;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_getalphaline  = function (hHandle            : mng_handle       ) : Tmng_getalphaline;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_getbkgdline   = function (hHandle            : mng_handle       ) : Tmng_getbkgdline;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_refresh       = function (hHandle            : mng_handle       ) : Tmng_refresh;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_getcb_gettickcount  = function (hHandle            : mng_handle       ) : Tmng_gettickcount;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_getcb_settimer      = function (hHandle            : mng_handle       ) : Tmng_settimer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

  Tmng_set_userdata        = function (hHandle            : mng_handle;
                                       pUserdata          : mng_ptr          ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_set_canvasstyle     = function (hHandle            : mng_handle;
                                       iStyle             : mng_uint32       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_set_bkgdstyle       = function (hHandle            : mng_handle;
                                       iStyle             : mng_uint32       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_set_bgcolor         = function (hHandle            : mng_handle;
                                       iRed               : mng_uint16;
                                       iGreen             : mng_uint16;
                                       iBlue              : mng_uint16       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_set_usebkgd         = function (hHandle            : mng_handle;
                                       bUseBKGD           : mng_bool         ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_set_storechunks     = function (hHandle            : mng_handle;
                                       bStorechunks       : mng_bool         ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_set_cacheplayback   = function (hHandle            : mng_handle;
                                       bCacheplayback     : mng_bool         ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_set_viewgammaint    = function (hHandle            : mng_handle;
                                       iGamma             : mng_uint32       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_set_displaygammaint = function (hHandle            : mng_handle;
                                       iGamma             : mng_uint32       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_set_dfltimggammaint = function (hHandle            : mng_handle;
                                       iGamma             : mng_uint32       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_set_srgb            = function (hHandle            : mng_handle;
                                       bIssRGB            : mng_bool         ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_set_outputprofile   = function (hHandle            : mng_handle;
                                       zFilename          : mng_pchar        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_set_outputprofile2  = function (hHandle            : mng_handle;
                                       iProfilesize       : mng_uint32;
                                       pProfile           : mng_ptr          ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_set_outputsrgb      = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_set_srgbprofile     = function (hHandle            : mng_handle;
                                       zFilename          : mng_pchar        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_set_srgbprofile2    = function (hHandle            : mng_handle;
                                       iProfilesize       : mng_uint32;
                                       pProfile           : mng_ptr          ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_set_srgbimplicit    = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_set_maxcanvassize   = function (hHandle            : mng_handle;
                                       iMaxwidth          : mng_uint32;
                                       iMaxheight         : mng_uint32       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

  Tmng_get_userdata        = function (hHandle            : mng_handle       ) : mng_ptr;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_get_sigtype         = function (hHandle            : mng_handle       ) : mng_imgtype;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_imagetype       = function (hHandle            : mng_handle       ) : mng_imgtype;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_imagewidth      = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_imageheight     = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_ticks           = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_framecount      = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_layercount      = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_playtime        = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_simplicity      = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_get_bitdepth        = function (hHandle            : mng_handle       ) : mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_colortype       = function (hHandle            : mng_handle       ) : mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_compression     = function (hHandle            : mng_handle       ) : mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_filter          = function (hHandle            : mng_handle       ) : mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_interlace       = function (hHandle            : mng_handle       ) : mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_alphabitdepth   = function (hHandle            : mng_handle       ) : mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_alphacompression= function (hHandle            : mng_handle       ) : mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_alphafilter     = function (hHandle            : mng_handle       ) : mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_alphainterlace  = function (hHandle            : mng_handle       ) : mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_get_alphadepth      = function (hHandle            : mng_handle       ) : mng_uint8;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_get_bgcolor         = procedure (hHandle           : mng_handle;
                                        var iRed          : mng_uint16;
                                        var iGreen        : mng_uint16;
                                        var iBlue         : mng_uint16       );
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_get_usebkgd         = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_get_viewgammaint    = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_displaygammaint = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_dfltimggammaint = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_get_srgb            = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_get_maxcanvaswidth  = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_maxcanvasheight = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_get_starttime       = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_runtime         = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_currentframe    = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_currentlayer    = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_get_currentplaytime = function (hHandle            : mng_handle       ) : mng_uint32;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_status_error        = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_status_reading      = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_status_suspendbreak = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_status_creating     = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_status_writing      = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_status_displaying   = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_status_running      = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_status_timerbreak   = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tmng_status_dynamic      = function (hHandle            : mng_handle       ) : mng_bool;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

  Tmng_putchunk_ihdr       = function (hHandle            : mng_handle;
                                       iWidth             : mng_uint32;
                                       iHeight            : mng_uint32;
                                       iBitdepth          : mng_uint8;
                                       iColortype         : mng_uint8;
                                       iCompression       : mng_uint8;
                                       iFilter            : mng_uint8;
                                       iInterlace         : mng_uint8        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_plte       = function (hHandle            : mng_handle;
                                       iCount             : mng_uint32;
                                       aPalette           : mng_palette8     ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_idat       = function (hHandle            : mng_handle;
                                       iRawlen            : mng_uint32;
                                       pRawdata           : mng_ptr          ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_iend       = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_trns       = function (hHandle            : mng_handle;
                                       bEmpty             : mng_bool;
                                       bGlobal            : mng_bool;
                                       iType              : mng_uint8;
                                       iCount             : mng_uint32;
                                       aAlphas            : mng_uint8arr;
                                       iGray              : mng_uint16;
                                       iRed               : mng_uint16;
                                       iGreen             : mng_uint16;
                                       iBlue              : mng_uint16;
                                       iRawlen            : mng_uint32;
                                       aRawdata           : mng_uint8arr     ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_gama       = function (hHandle            : mng_handle;
                                       bEmpty             : mng_bool;
                                       iGamma             : mng_uint32       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_chrm       = function (hHandle            : mng_handle;
                                       bEmpty             : mng_bool;
                                       iWhitepointx       : mng_uint32;
                                       iWhitepointy       : mng_uint32;
                                       iRedx              : mng_uint32;
                                       iRedy              : mng_uint32;
                                       iGreenx            : mng_uint32;
                                       iGreeny            : mng_uint32;
                                       iBluex             : mng_uint32;
                                       iBluey             : mng_uint32       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_srgb       = function (hHandle            : mng_handle;
                                       bEmpty             : mng_bool;
                                       iRenderingintent   : mng_uint8        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_iccp       = function (hHandle            : mng_handle;
                                       bEmpty             : mng_bool;
                                       iNamesize          : mng_uint32;
                                       zName              : mng_pchar;
                                       iCompression       : mng_uint8;
                                       iProfilesize       : mng_uint32;
                                       pProfile           : mng_ptr          ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_text       = function (hHandle            : mng_handle;
                                       iKeywordsize       : mng_uint32;
                                       zKeyword           : mng_pchar;
                                       iTextsize          : mng_uint32;
                                       zText              : mng_pchar        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_ztxt       = function (hHandle            : mng_handle;
                                       iKeywordsize       : mng_uint32;
                                       zKeyword           : mng_pchar;
                                       iCompression       : mng_uint8;
                                       iTextsize          : mng_uint32;
                                       zText              : mng_pchar        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_itxt       = function (hHandle            : mng_handle;
                                       iKeywordsize       : mng_uint32;
                                       zKeyword           : mng_pchar;
                                       iCompressionflag   : mng_uint8;
                                       iCompressionmethod : mng_uint8;
                                       iLanguagesize      : mng_uint32;
                                       zLanguage          : mng_pchar;
                                       iTranslationsize   : mng_uint32;
                                       zTranslation       : mng_pchar;
                                       iTextsize          : mng_uint32;
                                       zText              : mng_pchar        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_bkgd       = function (hHandle            : mng_handle;
                                       bEmpty             : mng_bool;
                                       iType              : mng_uint8;
                                       iIndex             : mng_uint8;
                                       iGray              : mng_uint16;
                                       iRed               : mng_uint16;
                                       iGreen             : mng_uint16;
                                       iBlue              : mng_uint16       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_phys       = function (hHandle            : mng_handle;
                                       bEmpty             : mng_bool;
                                       iSizex             : mng_uint32;
                                       iSizey             : mng_uint32;
                                       iUnit              : mng_uint8        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_sbit       = function (hHandle            : mng_handle;
                                       bEmpty             : mng_bool;
                                       iType              : mng_uint8;
                                       aBits              : mng_uint8arr4    ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_splt       = function (hHandle            : mng_handle;
                                       bEmpty             : mng_bool;
                                       iNamesize          : mng_uint32;
                                       zName              : mng_pchar;
                                       iSampledepth       : mng_uint8;
                                       iEntrycount        : mng_uint32;
                                       pEntries           : mng_ptr          ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_hist       = function (hHandle            : mng_handle;
                                       iEntrycount        : mng_uint32;
                                       aEntries           : mng_uint16arr    ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_time       = function (hHandle            : mng_handle;
                                       iYear              : mng_uint16;
                                       iMonth             : mng_uint8;
                                       iDay               : mng_uint8;
                                       iHour              : mng_uint8;
                                       iMinute            : mng_uint8;
                                       iSecond            : mng_uint8        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_jhdr       = function (hHandle            : mng_handle;
                                       iWidth             : mng_uint32;
                                       iHeight            : mng_uint32;
                                       iColortype         : mng_uint8;
                                       iImagesampledepth  : mng_uint8;
                                       iImagecompression  : mng_uint8;
                                       iImageinterlace    : mng_uint8;
                                       iAlphasampledepth  : mng_uint8;
                                       iAlphacompression  : mng_uint8;
                                       iAlphafilter       : mng_uint8;
                                       iAlphainterlace    : mng_uint8        ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_jdat       = function (hHandle            : mng_handle;
                                       iRawlen            : mng_uint32;
                                       pRawdata           : mng_ptr          ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  Tmng_putchunk_jsep       = function (hHandle            : mng_handle       ) : mng_retcode;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

{$IFDEF INCLUDE_ZLIB}

type
  TdeflateInit_ = function (strm        : z_streamp;
                            level       : integer;
                            version     : pchar;
                            stream_size : integer) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  TinflateInit_ = function (strm        : z_streamp;
                            version     : pchar;
                            stream_size : integer) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  TdeflateInit2_ = function (strm        : z_streamp;
                             level       : integer;
                             method      : integer;
                             windowBits  : integer;
                             memLevel    : integer;
                             strategy    : integer;
                             version     : pchar;
                             stream_size : integer) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

  TinflateInit2_ = function (strm        : z_streamp;
                             windowBits  : integer;
                             version     : pchar;
                             stream_size : integer) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{****************************************************************************}

  TzLibVersion          = function: PChar;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TdeflateInit          = function (strm        : z_streamp;
                                    level       : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tdeflate              = function (strm        : z_streamp;
                                    flush       : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TdeflateEnd           = function (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TinflateInit          = function (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tinflate              = function (strm        : z_streamp;
                                    flush       : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TinflateEnd           = function (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TdeflateInit2         = function (strm        : z_streamp;
                                    level       : integer;
                                    method      : integer;
                                    windowBits  : integer;
                                    memLevel    : integer;
                                    strategy    : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TdeflateSetDictionary = function (strm        : z_streamp;
                                    dictionary  : pointer;
                                    dictLength  : cardinal ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TdeflateCopy          = function (dest        : z_streamp;
                                    source      : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TdeflateReset         = function (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TdeflateParams        = function (strm        : z_streamp;
                                    level       : integer;
                                    strategy    : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TinflateInit2         = function (strm        : z_streamp;
                                    windowBits  : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TinflateSetDictionary = function (strm        : z_streamp;
                                    dictionary  : pointer;
                                    dictLength  : cardinal ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TinflateSync          = function (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TinflateReset         = function (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tcompress             = function (dest        : pointer;
                                    var destLen : cardinal;
                                    source      : pointer;
                                    sourceLen   : cardinal ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tcompress2            = function (dest        : pointer;
                                    var destLen : cardinal;
                                    source      : pointer;
                                    sourceLen   : cardinal;
                                    level       : integer  ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tuncompress           = function (dest        : pointer;
                                    var destLen : cardinal;
                                    source      : pointer;
                                    sourceLen   : cardinal ) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tadler32              = function (adler       : cardinal;
                                    buf         : pointer;
                                    len         : cardinal ) : cardinal;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tcrc32                = function (crc         : cardinal;
                                    buf         : pointer;
                                    len         : cardinal ) : cardinal;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TzError               = function (err         : integer  ) : pchar;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  TinflateSyncPoint     = function (strm        : z_streamp) : integer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}
  Tget_crc_table        = function : pointer;
  {$IFDEF LINUX} cdecl; {$ELSE} stdcall; {$ENDIF}

{$ENDIF} // INCLUDE_ZLIB

{****************************************************************************}

{$IFDEF LATE_BINDING}

type
  TMNGFuncType = (lmf_unknown,
                  lmf_version_text, lmf_version_so, lmf_version_dll,
                  lmf_version_major, lmf_version_minor, lmf_version_release,
                  lmf_version_beta, lmf_supports_func,
                  lmf_initialize, lmf_reset, lmf_cleanup, lmf_read,
                  lmf_write, lmf_create, lmf_readdisplay, lmf_display,
                  lmf_display_resume, lmf_display_freeze, lmf_display_reset,
                  lmf_trapevent, lmf_getlasterror,
                  lmf_setcb_memalloc, lmf_setcb_memfree,
                  lmf_setcb_openstream, lmf_setcb_closestream,
                  lmf_setcb_readdata, lmf_setcb_writedata, lmf_setcb_errorproc,
                  lmf_setcb_processheader, lmf_setcb_processtext,
                  lmf_setcb_processsave, lmf_setcb_processseek, lmf_setcb_processneed,
                  lmf_setcb_processmend, lmf_setcb_processunknown, lmf_setcb_processterm,
                  lmf_setcb_getcanvasline, lmf_setcb_getalphaline, lmf_setcb_getbkgdline,
                  lmf_setcb_refresh, lmf_setcb_gettickcount, lmf_setcb_settimer,
                  lmf_getcb_memalloc, lmf_getcb_memfree,
                  lmf_getcb_openstream, lmf_getcb_closestream,
                  lmf_getcb_readdata, lmf_getcb_writedata, lmf_getcb_errorproc,
                  lmf_getcb_processheader, lmf_getcb_processtext,
                  lmf_getcb_processsave, lmf_getcb_processseek, lmf_getcb_processneed,
                  lmf_getcb_processmend, lmf_getcb_processunknown, lmf_getcb_processterm,
                  lmf_getcb_getcanvasline, lmf_getcb_getalphaline, lmf_getcb_getbkgdline,
                  lmf_getcb_refresh, lmf_getcb_gettickcount, lmf_getcb_settimer,
                  lmf_set_userdata, lmf_set_canvasstyle, lmf_set_bkgdstyle,
                  lmf_set_bgcolor, lmf_set_usebkgd, lmf_set_storechunks,
                  lmf_set_cacheplayback, lmf_set_viewgammaint,
                  lmf_set_displaygammaint, lmf_set_dfltimggammaint,
                  lmf_set_srgb, lmf_set_outputprofile, lmf_set_outputprofile2,
                  lmf_set_outputsrgb, lmf_set_srgbprofile, lmf_set_srgbprofile2,
                  lmf_set_srgbimplicit, lmf_set_maxcanvassize,
                  lmf_get_userdata, lmf_get_sigtype, lmf_get_imagetype,
                  lmf_get_imagewidth, lmf_get_imageheight,
                  lmf_get_ticks, lmf_get_framecount, lmf_get_layercount,
                  lmf_get_playtime, lmf_get_simplicity,
                  lmf_get_bitdepth, lmf_get_colortype, lmf_get_compression,
                  lmf_get_filter, lmf_get_interlace,
                  lmf_get_alphabitdepth, lmf_get_alphacompression,
                  lmf_get_alphafilter, lmf_get_alphainterlace, lmf_get_alphadepth,
                  lmf_get_bgcolor, lmf_get_usebkgd,
                  lmf_get_viewgammaint, lmf_get_displaygammaint, lmf_get_dfltimggammaint,
                  lmf_get_srgb, lmf_get_maxcanvaswidth, lmf_get_maxcanvasheight,
                  lmf_get_starttime, lmf_get_runtime,
                  lmf_get_currentframe, lmf_get_currentlayer, lmf_get_currentplaytime,
                  lmf_status_error, lmf_status_reading, lmf_status_suspendbreak,
                  lmf_status_creating, lmf_status_writing, lmf_status_displaying,
                  lmf_status_running, lmf_status_timerbreak, lmf_status_dynamic,
                  lmf_putchunk_ihdr, lmf_putchunk_plte, lmf_putchunk_idat,
                  lmf_putchunk_iend, lmf_putchunk_trns, lmf_putchunk_gama,
                  lmf_putchunk_chrm, lmf_putchunk_srgb, lmf_putchunk_iccp,
                  lmf_putchunk_text, lmf_putchunk_ztxt, lmf_putchunk_itxt,
                  lmf_putchunk_bkgd, lmf_putchunk_phys, lmf_putchunk_sbit,
                  lmf_putchunk_splt, lmf_putchunk_hist, lmf_putchunk_time,
                  lmf_putchunk_jhdr, lmf_putchunk_jdat, lmf_putchunk_jsep);

  TMNGFunc = record case TMNGFuncType of
               lmf_unknown              : (f_ptr                  : pointer);
               lmf_version_text         : (f_version_text         : Tmng_version_text);
               lmf_version_so           : (f_version_so           : Tmng_version_so);
               lmf_version_dll          : (f_version_dll          : Tmng_version_dll);
               lmf_version_major        : (f_version_major        : Tmng_version_major);
               lmf_version_minor        : (f_version_minor        : Tmng_version_minor);
               lmf_version_release      : (f_version_release      : Tmng_version_release);
               lmf_version_beta         : (f_version_beta         : Tmng_version_beta);
               lmf_supports_func        : (f_supports_func        : Tmng_supports_func);
               lmf_initialize           : (f_initialize           : Tmng_initialize);
               lmf_reset                : (f_reset                : Tmng_reset);
               lmf_cleanup              : (f_cleanup              : Tmng_cleanup);
               lmf_read                 : (f_read                 : Tmng_read);
               lmf_write                : (f_write                : Tmng_write);
               lmf_create               : (f_create               : Tmng_create);
               lmf_readdisplay          : (f_readdisplay          : Tmng_readdisplay);
               lmf_display              : (f_display              : Tmng_display);
               lmf_display_resume       : (f_display_resume       : Tmng_display_resume);
               lmf_display_freeze       : (f_display_freeze       : Tmng_display_freeze);
               lmf_display_reset        : (f_display_reset        : Tmng_display_reset);
               lmf_trapevent            : (f_trapevent            : Tmng_trapevent);
               lmf_getlasterror         : (f_getlasterror         : Tmng_getlasterror);
               lmf_setcb_memalloc       : (f_setcb_memalloc       : Tmng_setcb_memalloc);
               lmf_setcb_memfree        : (f_setcb_memfree        : Tmng_setcb_memfree);       
               lmf_setcb_openstream     : (f_setcb_openstream     : Tmng_setcb_openstream);    
               lmf_setcb_closestream    : (f_setcb_closestream    : Tmng_setcb_closestream);   
               lmf_setcb_readdata       : (f_setcb_readdata       : Tmng_setcb_readdata);      
               lmf_setcb_writedata      : (f_setcb_writedata      : Tmng_setcb_writedata);     
               lmf_setcb_errorproc      : (f_setcb_errorproc      : Tmng_setcb_errorproc);     
               lmf_setcb_processheader  : (f_setcb_processheader  : Tmng_setcb_processheader); 
               lmf_setcb_processtext    : (f_setcb_processtext    : Tmng_setcb_processtext);   
               lmf_setcb_processsave    : (f_setcb_processsave    : Tmng_setcb_processsave);
               lmf_setcb_processseek    : (f_setcb_processseek    : Tmng_setcb_processseek);   
               lmf_setcb_processneed    : (f_setcb_processneed    : Tmng_setcb_processneed);   
               lmf_setcb_processmend    : (f_setcb_processmend    : Tmng_setcb_processmend);
               lmf_setcb_processunknown : (f_setcb_processunknown : Tmng_setcb_processunknown);
               lmf_setcb_processterm    : (f_setcb_processterm    : Tmng_setcb_processterm);   
               lmf_setcb_getcanvasline  : (f_setcb_getcanvasline  : Tmng_setcb_getcanvasline); 
               lmf_setcb_getalphaline   : (f_setcb_getalphaline   : Tmng_setcb_getalphaline);
               lmf_setcb_getbkgdline    : (f_setcb_getbkgdline    : Tmng_setcb_getbkgdline);   
               lmf_setcb_refresh        : (f_setcb_refresh        : Tmng_setcb_refresh);       
               lmf_setcb_gettickcount   : (f_setcb_gettickcount   : Tmng_setcb_gettickcount);
               lmf_setcb_settimer       : (f_setcb_settimer       : Tmng_setcb_settimer);      
               lmf_getcb_memalloc       : (f_getcb_memalloc       : Tmng_getcb_memalloc);      
               lmf_getcb_memfree        : (f_getcb_memfree        : Tmng_getcb_memfree);
               lmf_getcb_openstream     : (f_getcb_openstream     : Tmng_getcb_openstream);    
               lmf_getcb_closestream    : (f_getcb_closestream    : Tmng_getcb_closestream);   
               lmf_getcb_readdata       : (f_getcb_readdata       : Tmng_getcb_readdata);      
               lmf_getcb_writedata      : (f_getcb_writedata      : Tmng_getcb_writedata);     
               lmf_getcb_errorproc      : (f_getcb_errorproc      : Tmng_getcb_errorproc);     
               lmf_getcb_processheader  : (f_getcb_processheader  : Tmng_getcb_processheader);
               lmf_getcb_processtext    : (f_getcb_processtext    : Tmng_getcb_processtext);   
               lmf_getcb_processsave    : (f_getcb_processsave    : Tmng_getcb_processsave);   
               lmf_getcb_processseek    : (f_getcb_processseek    : Tmng_getcb_processseek);
               lmf_getcb_processneed    : (f_getcb_processneed    : Tmng_getcb_processneed);
               lmf_getcb_processmend    : (f_getcb_processmend    : Tmng_getcb_processmend);
               lmf_getcb_processunknown : (f_getcb_processunknown : Tmng_getcb_processunknown);
               lmf_getcb_processterm    : (f_getcb_processterm    : Tmng_getcb_processterm);
               lmf_getcb_getcanvasline  : (f_getcb_getcanvasline  : Tmng_getcb_getcanvasline); 
               lmf_getcb_getalphaline   : (f_getcb_getalphaline   : Tmng_getcb_getalphaline);  
               lmf_getcb_getbkgdline    : (f_getcb_getbkgdline    : Tmng_getcb_getbkgdline);   
               lmf_getcb_refresh        : (f_getcb_refresh        : Tmng_getcb_refresh);
               lmf_getcb_gettickcount   : (f_getcb_gettickcount   : Tmng_getcb_gettickcount);  
               lmf_getcb_settimer       : (f_getcb_settimer       : Tmng_getcb_settimer);      
               lmf_set_userdata         : (f_set_userdata         : Tmng_set_userdata);        
               lmf_set_canvasstyle      : (f_set_canvasstyle      : Tmng_set_canvasstyle);     
               lmf_set_bkgdstyle        : (f_set_bkgdstyle        : Tmng_set_bkgdstyle);
               lmf_set_bgcolor          : (f_set_bgcolor          : Tmng_set_bgcolor);
               lmf_set_usebkgd          : (f_set_usebkgd          : Tmng_set_usebkgd);         
               lmf_set_storechunks      : (f_set_storechunks      : Tmng_set_storechunks);     
               lmf_set_cacheplayback    : (f_set_cacheplayback    : Tmng_set_cacheplayback);
               lmf_set_viewgammaint     : (f_set_viewgammaint     : Tmng_set_viewgammaint);    
               lmf_set_displaygammaint  : (f_set_displaygammaint  : Tmng_set_displaygammaint); 
               lmf_set_dfltimggammaint  : (f_set_dfltimggammaint  : Tmng_set_dfltimggammaint); 
               lmf_set_srgb             : (f_set_srgb             : Tmng_set_srgb);            
               lmf_set_outputprofile    : (f_set_outputprofile    : Tmng_set_outputprofile);   
               lmf_set_outputprofile2   : (f_set_outputprofile2   : Tmng_set_outputprofile2);
               lmf_set_outputsrgb       : (f_set_outputsrgb       : Tmng_set_outputsrgb);      
               lmf_set_srgbprofile      : (f_set_srgbprofile      : Tmng_set_srgbprofile);     
               lmf_set_srgbprofile2     : (f_set_srgbprofile2     : Tmng_set_srgbprofile2);
               lmf_set_srgbimplicit     : (f_set_srgbimplicit     : Tmng_set_srgbimplicit);    
               lmf_set_maxcanvassize    : (f_set_maxcanvassize    : Tmng_set_maxcanvassize);   
               lmf_get_userdata         : (f_get_userdata         : Tmng_get_userdata);        
               lmf_get_sigtype          : (f_get_sigtype          : Tmng_get_sigtype);         
               lmf_get_imagetype        : (f_get_imagetype        : Tmng_get_imagetype);       
               lmf_get_imagewidth       : (f_get_imagewidth       : Tmng_get_imagewidth);      
               lmf_get_imageheight      : (f_get_imageheight      : Tmng_get_imageheight);     
               lmf_get_ticks            : (f_get_ticks            : Tmng_get_ticks);           
               lmf_get_framecount       : (f_get_framecount       : Tmng_get_framecount);
               lmf_get_layercount       : (f_get_layercount       : Tmng_get_layercount);      
               lmf_get_playtime         : (f_get_playtime         : Tmng_get_playtime);        
               lmf_get_simplicity       : (f_get_simplicity       : Tmng_get_simplicity);      
               lmf_get_bitdepth         : (f_get_bitdepth         : Tmng_get_bitdepth);        
               lmf_get_colortype        : (f_get_colortype        : Tmng_get_colortype);       
               lmf_get_compression      : (f_get_compression      : Tmng_get_compression);
               lmf_get_filter           : (f_get_filter           : Tmng_get_filter);
               lmf_get_interlace        : (f_get_interlace        : Tmng_get_interlace);       
               lmf_get_alphabitdepth    : (f_get_alphabitdepth    : Tmng_get_alphabitdepth);   
               lmf_get_alphacompression : (f_get_alphacompression : Tmng_get_alphacompression);
               lmf_get_alphafilter      : (f_get_alphafilter      : Tmng_get_alphafilter);
               lmf_get_alphainterlace   : (f_get_alphainterlace   : Tmng_get_alphainterlace);
               lmf_get_alphadepth       : (f_get_alphadepth       : Tmng_get_alphadepth);      
               lmf_get_bgcolor          : (f_get_bgcolor          : Tmng_get_bgcolor);         
               lmf_get_usebkgd          : (f_get_usebkgd          : Tmng_get_usebkgd);         
               lmf_get_viewgammaint     : (f_get_viewgammaint     : Tmng_get_viewgammaint);
               lmf_get_displaygammaint  : (f_get_displaygammaint  : Tmng_get_displaygammaint); 
               lmf_get_dfltimggammaint  : (f_get_dfltimggammaint  : Tmng_get_dfltimggammaint); 
               lmf_get_srgb             : (f_get_srgb             : Tmng_get_srgb);            
               lmf_get_maxcanvaswidth   : (f_get_maxcanvaswidth   : Tmng_get_maxcanvaswidth);  
               lmf_get_maxcanvasheight  : (f_get_maxcanvasheight  : Tmng_get_maxcanvasheight);
               lmf_get_starttime        : (f_get_starttime        : Tmng_get_starttime);
               lmf_get_runtime          : (f_get_runtime          : Tmng_get_runtime);         
               lmf_get_currentframe     : (f_get_currentframe     : Tmng_get_currentframe);    
               lmf_get_currentlayer     : (f_get_currentlayer     : Tmng_get_currentlayer);    
               lmf_get_currentplaytime  : (f_get_currentplaytime  : Tmng_get_currentplaytime); 
               lmf_status_error         : (f_status_error         : Tmng_status_error);        
               lmf_status_reading       : (f_status_reading       : Tmng_status_reading);      
               lmf_status_suspendbreak  : (f_status_suspendbreak  : Tmng_status_suspendbreak); 
               lmf_status_creating      : (f_status_creating      : Tmng_status_creating);     
               lmf_status_writing       : (f_status_writing       : Tmng_status_writing);
               lmf_status_displaying    : (f_status_displaying    : Tmng_status_displaying);   
               lmf_status_running       : (f_status_running       : Tmng_status_running);
               lmf_status_timerbreak    : (f_status_timerbreak    : Tmng_status_timerbreak);
               lmf_status_dynamic       : (f_status_dynamic       : Tmng_status_dynamic);
               lmf_putchunk_ihdr        : (f_putchunk_ihdr        : Tmng_putchunk_ihdr);
               lmf_putchunk_plte        : (f_putchunk_plte        : Tmng_putchunk_plte);
               lmf_putchunk_idat        : (f_putchunk_idat        : Tmng_putchunk_idat);
               lmf_putchunk_iend        : (f_putchunk_iend        : Tmng_putchunk_iend);
               lmf_putchunk_trns        : (f_putchunk_trns        : Tmng_putchunk_trns);
               lmf_putchunk_gama        : (f_putchunk_gama        : Tmng_putchunk_gama);
               lmf_putchunk_chrm        : (f_putchunk_chrm        : Tmng_putchunk_chrm);
               lmf_putchunk_srgb        : (f_putchunk_srgb        : Tmng_putchunk_srgb);
               lmf_putchunk_iccp        : (f_putchunk_iccp        : Tmng_putchunk_iccp);
               lmf_putchunk_text        : (f_putchunk_text        : Tmng_putchunk_text);
               lmf_putchunk_ztxt        : (f_putchunk_ztxt        : Tmng_putchunk_ztxt);
               lmf_putchunk_itxt        : (f_putchunk_itxt        : Tmng_putchunk_itxt);
               lmf_putchunk_bkgd        : (f_putchunk_bkgd        : Tmng_putchunk_bkgd);
               lmf_putchunk_phys        : (f_putchunk_phys        : Tmng_putchunk_phys);
               lmf_putchunk_sbit        : (f_putchunk_sbit        : Tmng_putchunk_sbit);
               lmf_putchunk_splt        : (f_putchunk_splt        : Tmng_putchunk_splt);
               lmf_putchunk_hist        : (f_putchunk_hist        : Tmng_putchunk_hist);
               lmf_putchunk_time        : (f_putchunk_time        : Tmng_putchunk_time);
               lmf_putchunk_jhdr        : (f_putchunk_jhdr        : Tmng_putchunk_jhdr);
               lmf_putchunk_jdat        : (f_putchunk_jdat        : Tmng_putchunk_jdat);
               lmf_putchunk_jsep        : (f_putchunk_jsep        : Tmng_putchunk_jsep);
             end;

  TMNGRec  = record
               sName : string;
               fPtr  : TMNGFunc;
             end;

{$IFDEF INCLUDE_ZLIB}
  TZFuncType = (zlf_unknown,
                zlf_deflateInit_, zlf_inflateInit_, zlf_deflateInit2_, zlf_inflateInit2_,
                zlf_zlibVersion, zlf_deflateInit, zlf_deflate, zlf_deflateEnd,
                zlf_inflateInit, zlf_inflate, zlf_inflateEnd,
                zlf_deflateInit2, zlf_deflateSetDictionary,
                zlf_deflateCopy, zlf_deflateReset, zlf_deflateParams,
                zlf_inflateInit2, zlf_inflateSetDictionary,
                zlf_inflateSync, zlf_inflateReset,
                zlf_compress, zlf_compress2, zlf_uncompress,
                zlf_adler32, zlf_crc32, zlf_zError,
                zlf_inflateSyncPoint, zlf_get_crc_table);

  TZFunc = record case TZFuncType of
             zlf_unknown              : (f_ptr                  : pointer);
             zlf_deflateInit_         : (f_deflateInit_         : TdeflateInit_);
             zlf_inflateInit_         : (f_inflateInit_         : TinflateInit_);
             zlf_deflateInit2_        : (f_deflateInit2_        : TdeflateInit2_);
             zlf_inflateInit2_        : (f_inflateInit2_        : TinflateInit2_);
             zlf_zlibVersion          : (f_zlibVersion          : TzlibVersion);
             zlf_deflateInit          : (f_deflateInit          : TdeflateInit);
             zlf_deflate              : (f_deflate              : Tdeflate);
             zlf_deflateEnd           : (f_deflateEnd           : TdeflateEnd);
             zlf_inflateInit          : (f_inflateInit          : TinflateInit);
             zlf_inflate              : (f_inflate              : Tinflate);
             zlf_inflateEnd           : (f_inflateEnd           : TinflateEnd);
             zlf_deflateInit2         : (f_deflateInit2         : TdeflateInit2);
             zlf_deflateSetDictionary : (f_deflateSetDictionary : TdeflateSetDictionary);
             zlf_deflateCopy          : (f_deflateCopy          : TdeflateCopy);
             zlf_deflateReset         : (f_deflateReset         : TdeflateReset);
             zlf_deflateParams        : (f_deflateParams        : TdeflateParams);
             zlf_inflateInit2         : (f_inflateInit2         : TinflateInit2);
             zlf_inflateSetDictionary : (f_inflateSetDictionary : TinflateSetDictionary);
             zlf_inflateSync          : (f_inflateSync          : TinflateSync);
             zlf_inflateReset         : (f_inflateReset         : TinflateReset);
             zlf_compress             : (f_compress             : Tcompress);
             zlf_compress2            : (f_compress2            : Tcompress2);
             zlf_uncompress           : (f_uncompress           : Tuncompress);
             zlf_adler32              : (f_adler32              : Tadler32);
             zlf_crc32                : (f_crc32                : Tcrc32);
             zlf_zError               : (f_zError               : TzError);
             zlf_inflateSyncPoint     : (f_inflateSyncPoint     : TinflateSyncPoint);
             zlf_get_crc_table        : (f_get_crc_table        : Tget_crc_table);
           end;

  TZRec  = record
             sName : string;
             fPtr  : TZFunc;
           end;

{$ENDIF} // INCLUDE_ZLIB

{****************************************************************************}

var
  hLibmng : THandle;
{$IFDEF LINUX}
  hLibz   : THandle;
{$ENDIF}
{****************************************************************************}
  iMNGUse : Integer = 0;

  aMNGFuncs: array[lmf_version_text..lmf_putchunk_jsep] of TMNGRec =
             ((sName: 'mng_version_text';         fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_version_so';           fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_version_dll';          fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_version_major';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_version_minor';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_version_release';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_version_beta';         fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_supports_func';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_initialize';           fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_reset';                fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_cleanup';              fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_read';                 fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_write';                fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_create';               fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_readdisplay';          fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_display';              fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_display_resume';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_display_freeze';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_display_reset';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_trapevent';            fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getlasterror';         fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_memalloc';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_memfree';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_openstream';     fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_closestream';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_readdata';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_writedata';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_errorproc';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_processheader';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_processtext';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_processsave';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_processseek';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_processneed';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_processmend';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_processunknown'; fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_processterm';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_getcanvasline';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_getalphaline';   fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_getbkgdline';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_refresh';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_gettickcount';   fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_setcb_settimer';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_memalloc';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_memfree';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_openstream';     fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_closestream';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_readdata';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_writedata';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_errorproc';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_processheader';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_processtext';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_processsave';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_processseek';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_processneed';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_processmend';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_processunknown'; fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_processterm';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_getcanvasline';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_getalphaline';   fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_getbkgdline';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_refresh';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_gettickcount';   fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_getcb_settimer';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_userdata';         fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_canvasstyle';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_bkgdstyle';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_bgcolor';          fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_usebkgd';          fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_storechunks';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_cacheplayback';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_viewgammaint';     fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_displaygammaint';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_dfltimggammaint';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_srgb';             fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_outputprofile';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_outputprofile2';   fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_outputsrgb';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_srgbprofile';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_srgbprofile2';     fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_srgbimplicit';     fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_set_maxcanvassize';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_userdata';         fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_sigtype';          fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_imagetype';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_imagewidth';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_imageheight';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_ticks';            fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_framecount';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_layercount';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_playtime';         fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_simplicity';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_bitdepth';         fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_colortype';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_compression';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_filter';           fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_interlace';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_alphabitdepth';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_alphacompression'; fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_alphafilter';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_alphainterlace';   fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_alphadepth';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_bgcolor';          fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_usebkgd';          fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_viewgammaint';     fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_displaygammaint';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_dfltimggammaint';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_srgb';             fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_maxcanvaswidth';   fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_maxcanvasheight';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_starttime';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_runtime';          fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_currentframe';     fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_currentlayer';     fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_get_currentplaytime';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_status_error';         fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_status_reading';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_status_suspendbreak';  fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_status_creating';      fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_status_writing';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_status_displaying';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_status_running';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_status_timerbreak';    fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_status_dynamic';       fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_ihdr';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_plte';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_idat';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_iend';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_trns';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_gama';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_chrm';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_srgb';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_iccp';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_text';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_ztxt';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_itxt';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_bkgd';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_phys';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_sbit';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_splt';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_hist';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_time';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_jhdr';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_jdat';        fPtr: (f_Ptr: nil)), // do not localize
              (sName: 'mng_putchunk_jsep';        fPtr: (f_Ptr: nil))); // do not localize

{$IFDEF INCLUDE_ZLIB}
  iZLIBUse : Integer = 0;

  aZFuncs: array[zlf_deflateInit_..zlf_get_crc_table] of  TZRec =
           ((sName: 'deflateInit_';         fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'inflateInit_';         fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'deflateInit2_';        fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'inflateInit2_';        fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'zlibVersion';          fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'deflateInit';          fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'deflate';              fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'deflateEnd';           fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'inflateInit';          fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'inflate';              fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'inflateEnd';           fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'deflateInit2';         fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'deflateSetDictionary'; fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'deflateCopy';          fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'deflateReset';         fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'deflateParams';        fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'inflateInit2';         fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'inflateSetDictionary'; fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'inflateSync';          fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'inflateReset';         fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'compress';             fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'compress2';            fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'uncompress';           fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'adler32';              fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'crc32';                fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'zError';               fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'inflateSyncPoint';     fPtr: (f_Ptr: nil)), // do not localize
            (sName: 'get_crc_table';        fPtr: (f_Ptr: nil))); // do not localize
{$ENDIF} // INCLUDE_ZLIB

{$ENDIF} // LATE_BINDING

{****************************************************************************}
{* LIBMNG implementation definitions                                        *}
{****************************************************************************}

{$IFNDEF LATE_BINDING}
function mng_version_text;         external mngdll;
function mng_version_so;           external mngdll;
function mng_version_dll;          external mngdll;
function mng_version_major;        external mngdll;
function mng_version_minor;        external mngdll;
function mng_version_release;      external mngdll;
function mng_version_beta;         external mngdll;

{****************************************************************************}

function mng_supports_func;        external mngdll;

{****************************************************************************}

function mng_initialize;           external mngdll;
function mng_reset;                external mngdll;
function mng_cleanup;              external mngdll;

function mng_read;                 external mngdll;
function mng_write;                external mngdll;
function mng_create;               external mngdll;

function mng_readdisplay;          external mngdll;
function mng_display;              external mngdll;
function mng_display_resume;       external mngdll;
function mng_display_freeze;       external mngdll;
function mng_display_reset;        external mngdll;

function mng_trapevent;            external mngdll;

function mng_getlasterror;         external mngdll;

{****************************************************************************}

function mng_setcb_memalloc;       external mngdll;
function mng_setcb_memfree;        external mngdll;

function mng_setcb_openstream;     external mngdll;
function mng_setcb_closestream;    external mngdll;

function mng_setcb_readdata;       external mngdll;

function mng_setcb_writedata;      external mngdll;

function mng_setcb_errorproc;      external mngdll;

function mng_setcb_processheader;  external mngdll;
function mng_setcb_processtext;    external mngdll;
function mng_setcb_processsave;    external mngdll;
function mng_setcb_processseek;    external mngdll;
function mng_setcb_processneed;    external mngdll;
function mng_setcb_processmend;    external mngdll;
function mng_setcb_processunknown; external mngdll;
function mng_setcb_processterm;    external mngdll;

function mng_setcb_getcanvasline;  external mngdll;
function mng_setcb_getalphaline;   external mngdll;
function mng_setcb_getbkgdline;    external mngdll;
function mng_setcb_refresh;        external mngdll;

function mng_setcb_gettickcount;   external mngdll;
function mng_setcb_settimer;       external mngdll;

{****************************************************************************}

function mng_getcb_memalloc;       external mngdll;
function mng_getcb_memfree;        external mngdll;

function mng_getcb_openstream;     external mngdll;
function mng_getcb_closestream;    external mngdll;

function mng_getcb_readdata;       external mngdll;

function mng_getcb_writedata;      external mngdll;

function mng_getcb_errorproc;      external mngdll;

function mng_getcb_processheader;  external mngdll;
function mng_getcb_processtext;    external mngdll;
function mng_getcb_processsave;    external mngdll;
function mng_getcb_processseek;    external mngdll;
function mng_getcb_processneed;    external mngdll;
function mng_getcb_processmend;    external mngdll;
function mng_getcb_processunknown; external mngdll;
function mng_getcb_processterm;    external mngdll;

function mng_getcb_getcanvasline;  external mngdll;
function mng_getcb_getalphaline;   external mngdll;
function mng_getcb_getbkgdline;    external mngdll;
function mng_getcb_refresh;        external mngdll;

function mng_getcb_gettickcount;   external mngdll;
function mng_getcb_settimer;       external mngdll;

{****************************************************************************}

function mng_set_userdata;         external mngdll;

function mng_set_canvasstyle;      external mngdll;
function mng_set_bkgdstyle;        external mngdll;

function mng_set_bgcolor;          external mngdll;
function mng_set_usebkgd;          external mngdll;

function mng_set_storechunks;      external mngdll;
function mng_set_cacheplayback;    external mngdll;

function mng_set_viewgammaint;     external mngdll;
function mng_set_displaygammaint;  external mngdll;
function mng_set_dfltimggammaint;  external mngdll;

function mng_set_srgb;             external mngdll;
function mng_set_outputprofile;    external mngdll;
function mng_set_outputprofile2;   external mngdll;
function mng_set_outputsrgb;       external mngdll;
function mng_set_srgbprofile;      external mngdll;
function mng_set_srgbprofile2;     external mngdll;
function mng_set_srgbimplicit;     external mngdll;

function mng_set_maxcanvassize;    external mngdll;

{****************************************************************************}

function mng_get_userdata;         external mngdll;

function mng_get_sigtype;          external mngdll;
function mng_get_imagetype;        external mngdll;
function mng_get_imagewidth;       external mngdll;
function mng_get_imageheight;      external mngdll;
function mng_get_ticks;            external mngdll;
function mng_get_framecount;       external mngdll;
function mng_get_layercount;       external mngdll;
function mng_get_playtime;         external mngdll;
function mng_get_simplicity;       external mngdll;

function mng_get_bitdepth;         external mngdll;
function mng_get_colortype;        external mngdll;
function mng_get_compression;      external mngdll;
function mng_get_filter;           external mngdll;
function mng_get_interlace;        external mngdll;
function mng_get_alphabitdepth;    external mngdll;
function mng_get_alphacompression; external mngdll;
function mng_get_alphafilter;      external mngdll;
function mng_get_alphainterlace;   external mngdll;

function mng_get_alphadepth;       external mngdll;

procedure mng_get_bgcolor;         external mngdll;
function mng_get_usebkgd;          external mngdll;

function mng_get_viewgammaint;     external mngdll;
function mng_get_displaygammaint;  external mngdll;
function mng_get_dfltimggammaint;  external mngdll;

function mng_get_srgb;             external mngdll;

function mng_get_maxcanvaswidth;   external mngdll;
function mng_get_maxcanvasheight;  external mngdll;

function mng_get_starttime;        external mngdll;
function mng_get_runtime;          external mngdll;
function mng_get_currentframe;     external mngdll;
function mng_get_currentlayer;     external mngdll;
function mng_get_currentplaytime;  external mngdll;

function mng_status_error;         external mngdll;
function mng_status_reading;       external mngdll;
function mng_status_suspendbreak;  external mngdll;

function mng_status_creating;      external mngdll;
function mng_status_writing;       external mngdll;
function mng_status_displaying;    external mngdll;
function mng_status_running;       external mngdll;
function mng_status_timerbreak;    external mngdll;
function mng_status_dynamic;       external mngdll;

{****************************************************************************}

function mng_putchunk_ihdr;        external mngdll;
function mng_putchunk_plte;        external mngdll;
function mng_putchunk_idat;        external mngdll;
function mng_putchunk_iend;        external mngdll;
function mng_putchunk_trns;        external mngdll;
function mng_putchunk_gama;        external mngdll;
function mng_putchunk_chrm;        external mngdll;
function mng_putchunk_srgb;        external mngdll;
function mng_putchunk_iccp;        external mngdll;
function mng_putchunk_text;        external mngdll;
function mng_putchunk_ztxt;        external mngdll;
function mng_putchunk_itxt;        external mngdll;
function mng_putchunk_bkgd;        external mngdll;
function mng_putchunk_phys;        external mngdll;
function mng_putchunk_sbit;        external mngdll;
function mng_putchunk_splt;        external mngdll;
function mng_putchunk_hist;        external mngdll;
function mng_putchunk_time;        external mngdll;

function mng_putchunk_jhdr;        external mngdll;
function mng_putchunk_jdat;        external mngdll;
function mng_putchunk_jsep;        external mngdll;


{$ELSE}        // IFNDEF LATE_BINDING


{****************************************************************************}
{ Do the Late Binding Thing instead }

procedure MNGFailed;
begin
  if (hLibmng <> 0) then
    raise ENGFuncUnknown.Create(SCFuncUnknown)
  else
    raise ENGDLLNotLoaded.Create(SCDLLNotLoaded);
end;

{****************************************************************************}
{$WARNINGS OFF}                        // prevent meaningless warnings here

function mng_version_text: mng_pchar;
begin
  if not assigned(aMNGFuncs[lmf_version_text].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_version_text].fPtr.f_version_text;
end;

function mng_version_so: mng_uint8;
begin
  if not assigned(aMNGFuncs[lmf_version_so].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_version_so].fPtr.f_version_so;
end;

function mng_version_dll: mng_uint8;
begin
  if not assigned(aMNGFuncs[lmf_version_dll].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_version_dll].fPtr.f_version_dll;
end;

function mng_version_major: mng_uint8;
begin
  if not assigned(aMNGFuncs[lmf_version_major].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_version_major].fPtr.f_version_major;
end;

function mng_version_minor: mng_uint8;
begin
  if not assigned(aMNGFuncs[lmf_version_minor].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_version_minor].fPtr.f_version_minor;
end;

function mng_version_release: mng_uint8;
begin
  if not assigned(aMNGFuncs[lmf_version_release].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_version_release].fPtr.f_version_release;
end;

function mng_version_beta: mng_bool;
begin
  if not assigned(aMNGFuncs[lmf_version_beta].fPtr.f_Ptr) then
    Result:= MNG_FALSE
  else
    Result:= aMNGFuncs[lmf_version_beta].fPtr.f_version_beta;
end;

{****************************************************************************}

function mng_supports_func;            { available since libmng-1.0.5 }
begin
  if not assigned(aMNGFuncs[lmf_supports_func].fPtr.f_Ptr) then
  begin
    Result   := MNG_FALSE;
    iMajor   := 0;
    iMinor   := 0;
    iRelease := 0;
  end
  else
  begin
    Result:= aMNGFuncs[lmf_supports_func].fPtr.f_supports_func(zFunction, iMajor,
                                                               iMinor, iRelease);
  end;
end;

{****************************************************************************}

function mng_initialize;
begin
  if not assigned(aMNGFuncs[lmf_initialize].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_initialize].fPtr.f_initialize(pUserdata, fMemalloc,
                                                         fMemfree, fTraceproc);
end;

function mng_reset;
begin
  if not assigned(aMNGFuncs[lmf_reset].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_reset].fPtr.f_reset(hHandle);
end;

function mng_cleanup;
begin
  if not assigned(aMNGFuncs[lmf_cleanup].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_cleanup].fPtr.f_cleanup(hHandle);
end;

function mng_read;
begin
  if not assigned(aMNGFuncs[lmf_read].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_read].fPtr.f_read(hHandle);
end;

function mng_write;
begin
  if not assigned(aMNGFuncs[lmf_write].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_write].fPtr.f_write(hHandle);
end;

function mng_create;
begin
  if not assigned(aMNGFuncs[lmf_create].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_create].fPtr.f_create(hHandle);
end;

function mng_readdisplay;
begin
  if not assigned(aMNGFuncs[lmf_readdisplay].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_readdisplay].fPtr.f_readdisplay(hHandle);
end;

function mng_display;
begin
  if not assigned(aMNGFuncs[lmf_display].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_display].fPtr.f_display(hHandle);
end;

function mng_display_resume;
begin
  if not assigned(aMNGFuncs[lmf_display_resume].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_display_resume].fPtr.f_display_resume(hHandle);
end;

function mng_display_freeze;
begin
  if not assigned(aMNGFuncs[lmf_display_freeze].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_display_freeze].fPtr.f_display_freeze(hHandle);
end;

function mng_display_reset;
begin
  if not assigned(aMNGFuncs[lmf_reset].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_display_reset].fPtr.f_reset(hHandle);
end;

function mng_trapevent;
begin
  if not assigned(aMNGFuncs[lmf_trapevent].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_trapevent].fPtr.f_trapevent(hHandle, iEventtype, iX, iY);
end;

function mng_getlasterror;
begin
  if not assigned(aMNGFuncs[lmf_getlasterror].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getlasterror].fPtr.f_getlasterror(hHandle, iSeverity,
                                                             iChunkname, iChunkseq,
                                                             iExtra1, iExtra2,
                                                             zErrortext);
end;

{****************************************************************************}

function mng_setcb_memalloc;
begin
  if not assigned(aMNGFuncs[lmf_setcb_memalloc].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_memalloc].fPtr.f_setcb_memalloc(hHandle, fProc);
end;

function mng_setcb_memfree;
begin
  if not assigned(aMNGFuncs[lmf_setcb_memfree].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_memfree].fPtr.f_setcb_memfree(hHandle, fProc);
end;

function mng_setcb_openstream;
begin
  if not assigned(aMNGFuncs[lmf_setcb_openstream].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_openstream].fPtr.f_setcb_openstream(hHandle, fProc);
end;

function mng_setcb_closestream;
begin
  if not assigned(aMNGFuncs[lmf_setcb_closestream].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_closestream].fPtr.f_setcb_closestream(hHandle, fProc);
end;

function mng_setcb_readdata;
begin
  if not assigned(aMNGFuncs[lmf_setcb_readdata].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_readdata].fPtr.f_setcb_readdata(hHandle, fProc);
end;

function mng_setcb_writedata;
begin
  if not assigned(aMNGFuncs[lmf_setcb_writedata].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_writedata].fPtr.f_setcb_writedata(hHandle, fProc);
end;

function mng_setcb_errorproc;
begin
  if not assigned(aMNGFuncs[lmf_setcb_errorproc].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_errorproc].fPtr.f_setcb_errorproc(hHandle, fProc);
end;

function mng_setcb_processheader;
begin
  if not assigned(aMNGFuncs[lmf_setcb_processheader].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_processheader].fPtr.f_setcb_processheader(hHandle, fProc);
end;

function mng_setcb_processtext;
begin
  if not assigned(aMNGFuncs[lmf_setcb_processtext].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_processtext].fPtr.f_setcb_processtext(hHandle, fProc);
end;

function mng_setcb_processsave;
begin
  if not assigned(aMNGFuncs[lmf_setcb_processsave].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_processsave].fPtr.f_setcb_processsave(hHandle, fProc);
end;

function mng_setcb_processseek;
begin
  if not assigned(aMNGFuncs[lmf_setcb_processseek].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_processseek].fPtr.f_setcb_processseek(hHandle, fProc);
end;

function mng_setcb_processmend;
begin
  if not assigned(aMNGFuncs[lmf_setcb_processmend].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_processmend].fPtr.f_setcb_processmend(hHandle, fProc);
end;

function mng_setcb_processneed;
begin
  if not assigned(aMNGFuncs[lmf_setcb_processneed].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_processneed].fPtr.f_setcb_processneed(hHandle, fProc);
end;

function mng_setcb_processunknown;
begin
  if not assigned(aMNGFuncs[lmf_setcb_processunknown].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_processunknown].fPtr.f_setcb_processunknown(hHandle, fProc);
end;

function mng_setcb_processterm;
begin
  if not assigned(aMNGFuncs[lmf_setcb_processterm].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_processterm].fPtr.f_setcb_processterm(hHandle, fProc);
end;

function mng_setcb_getcanvasline;
begin
  if not assigned(aMNGFuncs[lmf_setcb_getcanvasline].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_getcanvasline].fPtr.f_setcb_getcanvasline(hHandle, fProc);
end;

function mng_setcb_getalphaline;
begin
  if not assigned(aMNGFuncs[lmf_setcb_getalphaline].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_getalphaline].fPtr.f_setcb_getalphaline(hHandle, fProc);
end;

function mng_setcb_getbkgdline;
begin
  if not assigned(aMNGFuncs[lmf_setcb_getbkgdline].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_getbkgdline].fPtr.f_setcb_getbkgdline(hHandle, fProc);
end;

function mng_setcb_refresh;
begin
  if not assigned(aMNGFuncs[lmf_setcb_refresh].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_refresh].fPtr.f_setcb_refresh(hHandle, fProc);
end;

function mng_setcb_gettickcount;
begin
  if not assigned(aMNGFuncs[lmf_setcb_gettickcount].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_gettickcount].fPtr.f_setcb_gettickcount(hHandle, fProc);
end;

function mng_setcb_settimer;
begin
  if not assigned(aMNGFuncs[lmf_setcb_settimer].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_setcb_settimer].fPtr.f_setcb_settimer(hHandle, fProc);
end;

{****************************************************************************}

function mng_getcb_memalloc;
begin
  if not assigned(aMNGFuncs[lmf_getcb_memalloc].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_memalloc].fPtr.f_getcb_memalloc(hHandle);
end;

function mng_getcb_memfree;
begin
  if not assigned(aMNGFuncs[lmf_getcb_memfree].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_memfree].fPtr.f_getcb_memfree(hHandle);
end;

function mng_getcb_openstream;
begin
  if not assigned(aMNGFuncs[lmf_getcb_openstream].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_openstream].fPtr.f_getcb_openstream(hHandle);
end;

function mng_getcb_closestream;
begin
  if not assigned(aMNGFuncs[lmf_getcb_closestream].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_closestream].fPtr.f_getcb_closestream(hHandle);
end;

function mng_getcb_readdata;
begin
  if not assigned(aMNGFuncs[lmf_getcb_readdata].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_readdata].fPtr.f_getcb_readdata(hHandle);
end;

function mng_getcb_writedata;
begin
  if not assigned(aMNGFuncs[lmf_getcb_writedata].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_writedata].fPtr.f_getcb_writedata(hHandle);
end;

function mng_getcb_errorproc;
begin
  if not assigned(aMNGFuncs[lmf_getcb_errorproc].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_errorproc].fPtr.f_getcb_errorproc(hHandle);
end;

function mng_getcb_processheader;
begin
  if not assigned(aMNGFuncs[lmf_getcb_processheader].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_processheader].fPtr.f_getcb_processheader(hHandle);
end;

function mng_getcb_processtext;
begin
  if not assigned(aMNGFuncs[lmf_getcb_processtext].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_processtext].fPtr.f_getcb_processtext(hHandle);
end;

function mng_getcb_processsave;
begin
  if not assigned(aMNGFuncs[lmf_getcb_processsave].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_processsave].fPtr.f_getcb_processsave(hHandle);
end;

function mng_getcb_processseek;
begin
  if not assigned(aMNGFuncs[lmf_getcb_processseek].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_processseek].fPtr.f_getcb_processseek(hHandle);
end;

function mng_getcb_processmend;
begin
  if not assigned(aMNGFuncs[lmf_getcb_processmend].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_processmend].fPtr.f_getcb_processmend(hHandle);
end;

function mng_getcb_processneed;
begin
  if not assigned(aMNGFuncs[lmf_getcb_processneed].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_processneed].fPtr.f_getcb_processneed(hHandle);
end;

function mng_getcb_processunknown;
begin
  if not assigned(aMNGFuncs[lmf_getcb_processunknown].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_processunknown].fPtr.f_getcb_processunknown(hHandle);
end;

function mng_getcb_processterm;
begin
  if not assigned(aMNGFuncs[lmf_getcb_processterm].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_processterm].fPtr.f_getcb_processterm(hHandle);
end;

function mng_getcb_getcanvasline;
begin
  if not assigned(aMNGFuncs[lmf_getcb_getcanvasline].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_getcanvasline].fPtr.f_getcb_getcanvasline(hHandle);
end;

function mng_getcb_getalphaline;
begin
  if not assigned(aMNGFuncs[lmf_getcb_getalphaline].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_getalphaline].fPtr.f_getcb_getalphaline(hHandle);
end;

function mng_getcb_getbkgdline;
begin
  if not assigned(aMNGFuncs[lmf_getcb_getbkgdline].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_getbkgdline].fPtr.f_getcb_getbkgdline(hHandle);
end;

function mng_getcb_refresh;
begin
  if not assigned(aMNGFuncs[lmf_getcb_refresh].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_refresh].fPtr.f_getcb_refresh(hHandle);
end;

function mng_getcb_gettickcount;
begin
  if not assigned(aMNGFuncs[lmf_getcb_gettickcount].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_gettickcount].fPtr.f_getcb_gettickcount(hHandle);
end;

function mng_getcb_settimer;
begin
  if not assigned(aMNGFuncs[lmf_getcb_settimer].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_getcb_settimer].fPtr.f_getcb_settimer(hHandle);
end;

{****************************************************************************}

function mng_set_userdata;
begin
  if not assigned(aMNGFuncs[lmf_set_userdata].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_userdata].fPtr.f_set_userdata(hHandle, pUserdata);
end;

function mng_set_canvasstyle;
begin
  if not assigned(aMNGFuncs[lmf_set_canvasstyle].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_canvasstyle].fPtr.f_set_canvasstyle(hHandle, iStyle);
end;

function mng_set_bkgdstyle;
begin
  if not assigned(aMNGFuncs[lmf_set_bkgdstyle].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_bkgdstyle].fPtr.f_set_bkgdstyle(hHandle, iStyle);
end;

function mng_set_bgcolor;
begin
  if not assigned(aMNGFuncs[lmf_set_bgcolor].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_bgcolor].fPtr.f_set_bgcolor(hHandle, iRed, iGreen, iBlue);
end;

function mng_set_usebkgd;
begin
  if not assigned(aMNGFuncs[lmf_set_usebkgd].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_usebkgd].fPtr.f_set_usebkgd(hHandle, bUseBKGD);
end;

function mng_set_storechunks;
begin
  if not assigned(aMNGFuncs[lmf_set_storechunks].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_storechunks].fPtr.f_set_storechunks(hHandle, bStorechunks);
end;

function mng_set_cacheplayback;
begin
  if not assigned(aMNGFuncs[lmf_set_cacheplayback].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_cacheplayback].fPtr.f_set_cacheplayback(hHandle, bCacheplayback);
end;

function mng_set_viewgammaint;
begin
  if not assigned(aMNGFuncs[lmf_set_viewgammaint].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_viewgammaint].fPtr.f_set_viewgammaint(hHandle, iGamma);
end;

function mng_set_displaygammaint;
begin
  if not assigned(aMNGFuncs[lmf_set_displaygammaint].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_displaygammaint].fPtr.f_set_displaygammaint(hHandle, iGamma);
end;

function mng_set_dfltimggammaint;
begin
  if not assigned(aMNGFuncs[lmf_set_dfltimggammaint].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_dfltimggammaint].fPtr.f_set_dfltimggammaint(hHandle, iGamma);
end;

function mng_set_srgb;
begin
  if not assigned(aMNGFuncs[lmf_set_srgb].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_srgb].fPtr.f_set_srgb(hHandle, bIssRGB);
end;

function mng_set_outputprofile;
begin
  if not assigned(aMNGFuncs[lmf_set_outputprofile].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_outputprofile].fPtr.f_set_outputprofile(hHandle, zFilename);
end;

function mng_set_outputprofile2;
begin
  if not assigned(aMNGFuncs[lmf_set_outputprofile2].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_outputprofile2].fPtr.f_set_outputprofile2(hHandle, iProfilesize, pProfile);
end;

function mng_set_outputsrgb;
begin
  if not assigned(aMNGFuncs[lmf_set_outputsrgb].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_outputsrgb].fPtr.f_set_outputsrgb(hHandle);
end;

function mng_set_srgbprofile;
begin
  if not assigned(aMNGFuncs[lmf_set_srgbprofile].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_srgbprofile].fPtr.f_set_srgbprofile(hHandle, zFilename);
end;

function mng_set_srgbprofile2;
begin
  if not assigned(aMNGFuncs[lmf_set_srgbprofile2].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_srgbprofile2].fPtr.f_set_srgbprofile2(hHandle, iProfilesize, pProfile);
end;

function mng_set_srgbimplicit;
begin
  if not assigned(aMNGFuncs[lmf_set_srgbimplicit].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_srgbimplicit].fPtr.f_set_srgbimplicit(hHandle);
end;

function mng_set_maxcanvassize;
begin
  if not assigned(aMNGFuncs[lmf_set_maxcanvassize].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_set_maxcanvassize].fPtr.f_set_maxcanvassize(hHandle, iMaxwidth, iMaxheight);
end;

{****************************************************************************}

function mng_get_userdata;
begin
  if not assigned(aMNGFuncs[lmf_get_userdata].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_userdata].fPtr.f_get_userdata(hHandle);
end;

function mng_get_sigtype;
begin
  if not assigned(aMNGFuncs[lmf_get_sigtype].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_sigtype].fPtr.f_get_sigtype(hHandle);
end;

function mng_get_imagetype;
begin
  if not assigned(aMNGFuncs[lmf_get_imagetype].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_imagetype].fPtr.f_get_imagetype(hHandle);
end;

function mng_get_imagewidth;
begin
  if not assigned(aMNGFuncs[lmf_get_imagewidth].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_imagewidth].fPtr.f_get_imagewidth(hHandle);
end;

function mng_get_imageheight;
begin
  if not assigned(aMNGFuncs[lmf_get_imageheight].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_imageheight].fPtr.f_get_imageheight(hHandle);
end;

function mng_get_ticks;
begin
  if not assigned(aMNGFuncs[lmf_get_ticks].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_ticks].fPtr.f_get_ticks(hHandle);
end;

function mng_get_framecount;
begin
  if not assigned(aMNGFuncs[lmf_get_framecount].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_framecount].fPtr.f_get_framecount(hHandle);
end;

function mng_get_layercount;
begin
  if not assigned(aMNGFuncs[lmf_get_layercount].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_layercount].fPtr.f_get_layercount(hHandle);
end;

function mng_get_playtime;
begin
  if not assigned(aMNGFuncs[lmf_get_playtime].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_playtime].fPtr.f_get_playtime(hHandle);
end;

function mng_get_simplicity;
begin
  if not assigned(aMNGFuncs[lmf_get_simplicity].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_simplicity].fPtr.f_get_simplicity(hHandle);
end;

function mng_get_bitdepth;
begin
  if not assigned(aMNGFuncs[lmf_get_bitdepth].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_bitdepth].fPtr.f_get_bitdepth(hHandle);
end;

function mng_get_colortype;
begin
  if not assigned(aMNGFuncs[lmf_get_colortype].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_colortype].fPtr.f_get_colortype(hHandle);
end;

function mng_get_compression;
begin
  if not assigned(aMNGFuncs[lmf_get_compression].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_compression].fPtr.f_get_compression(hHandle);
end;

function mng_get_filter;
begin
  if not assigned(aMNGFuncs[lmf_get_filter].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_filter].fPtr.f_get_filter(hHandle);
end;

function mng_get_interlace;
begin
  if not assigned(aMNGFuncs[lmf_get_interlace].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_interlace].fPtr.f_get_interlace(hHandle);
end;

function mng_get_alphabitdepth;
begin
  if not assigned(aMNGFuncs[lmf_get_alphabitdepth].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_alphabitdepth].fPtr.f_get_alphabitdepth(hHandle);
end;

function mng_get_alphacompression;
begin
  if not assigned(aMNGFuncs[lmf_get_alphacompression].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_alphacompression].fPtr.f_get_alphacompression(hHandle);
end;

function mng_get_alphafilter;
begin
  if not assigned(aMNGFuncs[lmf_get_alphafilter].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_alphafilter].fPtr.f_get_alphafilter(hHandle);
end;

function mng_get_alphainterlace;
begin
  if not assigned(aMNGFuncs[lmf_get_alphainterlace].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_alphainterlace].fPtr.f_get_alphainterlace(hHandle);
end;

function mng_get_alphadepth;
begin
  if not assigned(aMNGFuncs[lmf_get_alphadepth].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_alphadepth].fPtr.f_get_alphadepth(hHandle);
end;

procedure mng_get_bgcolor;
begin
  if not assigned(aMNGFuncs[lmf_get_bgcolor].fPtr.f_Ptr) then
    MNGFailed
  else
    aMNGFuncs[lmf_get_bgcolor].fPtr.f_get_bgcolor(hHandle, iRed, iGreen, iBlue);
end;

function mng_get_usebkgd;
begin
  if not assigned(aMNGFuncs[lmf_get_usebkgd].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_usebkgd].fPtr.f_get_usebkgd(hHandle);
end;

function mng_get_viewgammaint;
begin
  if not assigned(aMNGFuncs[lmf_get_viewgammaint].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_viewgammaint].fPtr.f_get_viewgammaint(hHandle);
end;

function mng_get_displaygammaint;
begin
  if not assigned(aMNGFuncs[lmf_get_displaygammaint].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_displaygammaint].fPtr.f_get_displaygammaint(hHandle);
end;

function mng_get_dfltimggammaint;
begin
  if not assigned(aMNGFuncs[lmf_get_dfltimggammaint].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_dfltimggammaint].fPtr.f_get_dfltimggammaint(hHandle);
end;

function mng_get_srgb;
begin
  if not assigned(aMNGFuncs[lmf_get_srgb].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_srgb].fPtr.f_get_srgb(hHandle);
end;

function mng_get_maxcanvaswidth;
begin
  if not assigned(aMNGFuncs[lmf_get_maxcanvaswidth].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_maxcanvaswidth].fPtr.f_get_maxcanvaswidth(hHandle);
end;

function mng_get_maxcanvasheight;
begin
  if not assigned(aMNGFuncs[lmf_get_maxcanvasheight].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_maxcanvasheight].fPtr.f_get_maxcanvasheight(hHandle);
end;

function mng_get_starttime;
begin
  if not assigned(aMNGFuncs[lmf_get_starttime].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_starttime].fPtr.f_get_starttime(hHandle);
end;

function mng_get_runtime;
begin
  if not assigned(aMNGFuncs[lmf_get_runtime].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_runtime].fPtr.f_get_runtime(hHandle);
end;

function mng_get_currentframe;
begin
  if not assigned(aMNGFuncs[lmf_get_currentframe].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_currentframe].fPtr.f_get_currentframe(hHandle);
end;

function mng_get_currentlayer;
begin
  if not assigned(aMNGFuncs[lmf_get_currentlayer].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_currentlayer].fPtr.f_get_currentlayer(hHandle);
end;

function mng_get_currentplaytime;
begin
  if not assigned(aMNGFuncs[lmf_get_currentplaytime].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_get_currentplaytime].fPtr.f_get_currentplaytime(hHandle);
end;

function mng_status_error;
begin
  if not assigned(aMNGFuncs[lmf_status_error].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_status_error].fPtr.f_status_error(hHandle);
end;

function mng_status_reading;
begin
  if not assigned(aMNGFuncs[lmf_status_reading].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_status_reading].fPtr.f_status_reading(hHandle);
end;

function mng_status_suspendbreak;
begin
  if not assigned(aMNGFuncs[lmf_status_suspendbreak].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_status_suspendbreak].fPtr.f_status_suspendbreak(hHandle);
end;

function mng_status_creating;
begin
  if not assigned(aMNGFuncs[lmf_status_creating].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_status_creating].fPtr.f_status_creating(hHandle);
end;

function mng_status_writing;
begin
  if not assigned(aMNGFuncs[lmf_status_writing].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_status_writing].fPtr.f_status_writing(hHandle);
end;

function mng_status_displaying;
begin
  if not assigned(aMNGFuncs[lmf_status_displaying].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_status_displaying].fPtr.f_status_displaying(hHandle);
end;

function mng_status_running;
begin
  if not assigned(aMNGFuncs[lmf_status_running].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_status_running].fPtr.f_status_running(hHandle);
end;

function mng_status_timerbreak;
begin
  if not assigned(aMNGFuncs[lmf_status_timerbreak].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_status_timerbreak].fPtr.f_status_timerbreak(hHandle);
end;

function mng_status_dynamic;           { available since libmng-1.0.5 }
begin
  if not assigned(aMNGFuncs[lmf_status_dynamic].fPtr.f_Ptr) then
    Result:= MNG_FALSE
  else
    Result:= aMNGFuncs[lmf_status_dynamic].fPtr.f_status_dynamic(hHandle);
end;

{****************************************************************************}

function mng_putchunk_ihdr;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_ihdr].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_ihdr].fPtr.f_putchunk_ihdr(hHandle, iWidth, iHeight,
                                                               iBitdepth, iColortype,
                                                               iCompression, iFilter,
                                                               iInterlace);
end;

function mng_putchunk_plte;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_plte].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_plte].fPtr.f_putchunk_plte(hHandle, iCount, aPalette);
end;

function mng_putchunk_idat;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_idat].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_idat].fPtr.f_putchunk_idat(hHandle, iRawlen, pRawdata);
end;

function mng_putchunk_iend;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_iend].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_iend].fPtr.f_putchunk_iend(hHandle);
end;

function mng_putchunk_trns;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_trns].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_trns].fPtr.f_putchunk_trns(hHandle, bEmpty, bGlobal,
                                                               iType, iCount, aAlphas,
                                                               iGray, iRed, iGreen, iBlue,
                                                               iRawlen, aRawdata);
end;

function mng_putchunk_gama;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_gama].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_gama].fPtr.f_putchunk_gama(hHandle, bEmpty, iGamma);
end;

function mng_putchunk_chrm;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_chrm].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_chrm].fPtr.f_putchunk_chrm(hHandle, bEmpty,
                                                               iWhitepointx, iWhitepointy,
                                                               iRedx, iRedy,
                                                               iGreenx, iGreeny,
                                                               iBluex, iBluey);
end;

function mng_putchunk_srgb;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_srgb].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_srgb].fPtr.f_putchunk_srgb(hHandle, bEmpty, iRenderingintent);
end;

function mng_putchunk_iccp;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_iccp].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_iccp].fPtr.f_putchunk_iccp(hHandle, bEmpty,
                                                               iNamesize, zName,
                                                               iCompression,
                                                               iProfilesize, pProfile);
end;

function mng_putchunk_text;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_text].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_text].fPtr.f_putchunk_text(hHandle, iKeywordsize,
                                                               zKeyword, iTextsize, zText);
end;

function mng_putchunk_ztxt;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_ztxt].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_ztxt].fPtr.f_putchunk_ztxt(hHandle, iKeywordsize,
                                                               zKeyword, iCompression,
                                                               iTextsize, zText);
end;

function mng_putchunk_itxt;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_itxt].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_itxt].fPtr.f_putchunk_itxt(hHandle, iKeywordsize,
                                                               zKeyword, iCompressionflag,
                                                               iCompressionmethod,
                                                               iLanguagesize, zLanguage,
                                                               iTranslationsize, zTranslation,
                                                               iTextsize, zText);
end;

function mng_putchunk_bkgd;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_bkgd].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_bkgd].fPtr.f_putchunk_bkgd(hHandle, bEmpty,
                                                               iType, iIndex, iGray,
                                                               iRed, iGray, iBlue);
end;

function mng_putchunk_phys;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_phys].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_phys].fPtr.f_putchunk_phys(hHandle, bEmpty,
                                                               iSizex, iSizey, iUnit);
end;

function mng_putchunk_sbit;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_sbit].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_sbit].fPtr.f_putchunk_sbit(hHandle, bEmpty, iType, aBits);
end;

function mng_putchunk_splt;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_splt].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_splt].fPtr.f_putchunk_splt(hHandle, bEmpty, iNamesize, zName,
                                                               iSampledepth, iEntrycount, pEntries);
end;

function mng_putchunk_hist;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_hist].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_hist].fPtr.f_putchunk_hist(hHandle, iEntrycount, aEntries);
end;

function mng_putchunk_time;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_time].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_time].fPtr.f_putchunk_time(hHandle, iYear, iMonth,
                                                               iDay, iHour, iMinute, iSecond);
end;

function mng_putchunk_jhdr;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_jhdr].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_jhdr].fPtr.f_putchunk_jhdr(hHandle, iWidth, iHeight,
                                                               iColortype, iImagesampledepth,
                                                               iImagecompression, iImageinterlace,
                                                               iAlphasampledepth, iAlphacompression,
                                                               iAlphafilter, iAlphainterlace)
end;

function mng_putchunk_jdat;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_jdat].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_jdat].fPtr.f_putchunk_jdat(hHandle, iRawlen, pRawdata);
end;

function mng_putchunk_jsep;
begin
  if not assigned(aMNGFuncs[lmf_putchunk_jsep].fPtr.f_Ptr) then
    MNGFailed
  else
    Result:= aMNGFuncs[lmf_putchunk_jsep].fPtr.f_putchunk_jsep(hHandle);
end;

{$WARNINGS ON}                         // turn them back on

{$ENDIF} //IFNDEF LATE_BINDING


{****************************************************************************}
{* LIBMNG implementation definitions for ZLIB                               *}
{****************************************************************************}

{$IFDEF INCLUDE_ZLIB}

{$IFNDEF LATE_BINDING}
{****************************************************************************}

function deflateInit_  (strm        : z_streamp;
                        level       : integer;
                        version     : pchar;
                        stream_size : integer) : integer;
  {$IFDEF LINUX} cdecl; external zdll; {$ELSE} stdcall; external mngdll; {$ENDIF}

function inflateInit_  (strm        : z_streamp;
                        version     : pchar;
                        stream_size : integer) : integer;
  {$IFDEF LINUX} cdecl; external zdll; {$ELSE} stdcall; external mngdll; {$ENDIF}

function deflateInit2_ (strm        : z_streamp;
                        level       : integer;
                        method      : integer;
                        windowBits  : integer;
                        memLevel    : integer;
                        strategy    : integer;
                        version     : pchar;
                        stream_size : integer) : integer;
  {$IFDEF LINUX} cdecl; external zdll; {$ELSE} stdcall; external mngdll; {$ENDIF}

function inflateInit2_ (strm        : z_streamp;
                        windowBits  : integer;
                        version     : pchar;
                        stream_size : integer) : integer;
  {$IFDEF LINUX} cdecl; external zdll; {$ELSE} stdcall; external mngdll; {$ENDIF}

{****************************************************************************}

{$IFDEF LINUX}
function zlibVersion;          external zdll;
function deflate;              external zdll;
function deflateEnd;           external zdll;
function inflate;              external zdll;
function inflateEnd;           external zdll;
function deflateSetDictionary; external zdll;
function deflateCopy;          external zdll;
function deflateReset;         external zdll;
function deflateParams;        external zdll;
function inflateSetDictionary; external zdll;
function inflateSync;          external zdll;
function inflateReset;         external zdll;
function compress;             external zdll;
function compress2;            external zdll;
function uncompress;           external zdll;
function adler32;              external zdll;
function crc32;                external zdll;
function zError;               external zdll;
function inflateSyncPoint;     external zdll;
function get_crc_table;        external zdll;
{$ELSE}
function zlibVersion;          external mngdll;
function deflate;              external mngdll;
function deflateEnd;           external mngdll;
function inflate;              external mngdll;
function inflateEnd;           external mngdll;
function deflateSetDictionary; external mngdll;
function deflateCopy;          external mngdll;
function deflateReset;         external mngdll;
function deflateParams;        external mngdll;
function inflateSetDictionary; external mngdll;
function inflateSync;          external mngdll;
function inflateReset;         external mngdll;
function compress;             external mngdll;
function compress2;            external mngdll;
function uncompress;           external mngdll;
function adler32;              external mngdll;
function crc32;                external mngdll;
function zError;               external mngdll;
function inflateSyncPoint;     external mngdll;
function get_crc_table;        external mngdll;
{$ENDIF}

{****************************************************************************}

{$ELSE} // LATE_BINDING

{****************************************************************************}

procedure ZFailed;
begin
{$IFDEF LINUX}
  if (hLibz <> 0) then
{$ELSE}
  if (hLibmng <> 0) then
{$ENDIF}
    raise ENGFuncUnknown.Create(SCFuncUnknown)
  else
{$IFDEF LINUX}
    raise ENGDLLNotLoaded.Create(SCDLLNotLoaded2);
{$ELSE}
    raise ENGDLLNotLoaded.Create(SCDLLNotLoaded);
{$ENDIF}
end;

{****************************************************************************}
{$WARNINGS OFF}

function deflateInit_ (strm        : z_streamp;
                       level       : integer;
                       version     : pchar;
                       stream_size : integer) : integer;
begin
  if not assigned(aZFuncs[zlf_deflateInit_].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_deflateInit_].fPtr.f_deflateInit_(strm, level, version, stream_size);
end;

function inflateInit_ (strm        : z_streamp;
                       version     : pchar;
                       stream_size : integer) : integer;
begin
  if not assigned(aZFuncs[zlf_inflateInit_].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_inflateInit_].fPtr.f_inflateInit_(strm, version, stream_size);
end;

function deflateInit2_ (strm        : z_streamp;
                        level       : integer;
                        method      : integer;
                        windowBits  : integer;
                        memLevel    : integer;
                        strategy    : integer;
                        version     : pchar;
                        stream_size : integer) : integer;
begin
  if not assigned(aZFuncs[zlf_deflateInit2_].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_deflateInit2_].fPtr.f_deflateInit2_(strm, level, method, windowBits,
                                                             memLevel, strategy, version, stream_size);
end;

function inflateInit2_ (strm        : z_streamp;
                        windowBits  : integer;
                        version     : pchar;
                        stream_size : integer) : integer;
begin
  if not assigned(aZFuncs[zlf_inflateInit2_].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_inflateInit2_].fPtr.f_inflateInit2_(strm, windowBits, version, stream_size);
end;

{****************************************************************************}

function zlibVersion;
begin
  if not assigned(aZFuncs[zlf_zLibVersion].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_zLibVersion].fPtr.f_zLibVersion;
end;

function deflate;
begin
  if not assigned(aZFuncs[zlf_deflate].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_deflate].fPtr.f_deflate(strm, flush);
end;

function deflateEnd;
begin
  if not assigned(aZFuncs[zlf_deflateEnd].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_deflateEnd].fPtr.f_deflateEnd(strm);
end;

function inflate;
begin
  if not assigned(aZFuncs[zlf_inflate].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_inflate].fPtr.f_inflate(strm, flush);
end;

function inflateEnd;
begin
  if not assigned(aZFuncs[zlf_inflateEnd].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_inflateEnd].fPtr.f_inflateEnd(strm);
end;

function deflateSetDictionary;
begin
  if not assigned(aZFuncs[zlf_deflateSetDictionary].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_deflateSetDictionary].fPtr.f_deflateSetDictionary(strm, dictionary, dictLength);
end;

function deflateCopy;
begin
  if not assigned(aZFuncs[zlf_deflateCopy].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_deflateCopy].fPtr.f_deflateCopy(dest, source);
end;

function deflateReset;
begin
  if not assigned(aZFuncs[zlf_deflateReset].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_deflateReset].fPtr.f_deflateReset(strm);
end;

function deflateParams;
begin
  if not assigned(aZFuncs[zlf_deflateParams].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_deflateParams].fPtr.f_deflateParams(strm, level, strategy);
end;

function inflateSetDictionary;
begin
  if not assigned(aZFuncs[zlf_inflateSetDictionary].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_inflateSetDictionary].fPtr.f_inflateSetDictionary(strm, dictionary, dictLength);
end;

function inflateSync;
begin
  if not assigned(aZFuncs[zlf_inflateSync].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_inflateSync].fPtr.f_inflateSync(strm);
end;

function inflateReset;
begin
  if not assigned(aZFuncs[zlf_inflateReset].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_inflateReset].fPtr.f_inflateReset(strm);
end;

function compress;
begin
  if not assigned(aZFuncs[zlf_compress].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_compress].fPtr.f_compress(dest, destLen, source, sourceLen);
end;

function compress2;
begin
  if not assigned(aZFuncs[zlf_compress2].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_compress2].fPtr.f_compress2(dest, destLen, source, sourceLen, level);
end;

function uncompress;
begin
  if not assigned(aZFuncs[zlf_uncompress].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_uncompress].fPtr.f_uncompress(dest, destLen, source, sourceLen);
end;

function adler32;
begin
  if not assigned(aZFuncs[zlf_adler32].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_adler32].fPtr.f_adler32(adler, buf, len);
end;

function crc32;
begin
  if not assigned(aZFuncs[zlf_crc32].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_crc32].fPtr.f_crc32(crc, buf, len);
end;

function zError;
begin
  if not assigned(aZFuncs[zlf_zError].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_zError].fPtr.f_zError(err);
end;

function inflateSyncPoint;
begin
  if not assigned(aZFuncs[zlf_inflateSyncPoint].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_inflateSyncPoint].fPtr.f_inflateSyncPoint(strm);
end;

function get_crc_table;
begin
  if not assigned(aZFuncs[zlf_get_crc_table].fPtr.f_Ptr) then
    ZFailed
  else
    Result:= aZFuncs[zlf_get_crc_table].fPtr.f_get_crc_table;
end;

{$WARNINGS OFF}
{****************************************************************************}
{$ENDIF}  //ifndef LATE_BINDING

function deflateInit;
begin
  Result := deflateInit_(strm, level, ZLIB_VERSION, sizeof(z_stream));
end;

{****************************************************************************}

function inflateInit;
begin
  Result := inflateInit_(strm, ZLIB_VERSION, sizeof(z_stream));
end;

{****************************************************************************}

function deflateInit2;
begin
  Result := deflateInit2_(strm, level, method, windowBits, memLevel, strategy,
                          ZLIB_VERSION, sizeof(z_stream));
end;

{****************************************************************************}

function inflateInit2;
begin
  Result := inflateInit2_(strm, windowBits, ZLIB_VERSION, sizeof(z_stream));
end;

{****************************************************************************}

function InflateString(Input: string; var Output: string): integer;
var
  stream: z_stream;
  buflen: integer;
  bufinc: integer;
  nextpos: integer;
begin
  BeginUseZLib;

  try
    fillchar(stream, sizeof(stream), 0);

    buflen           := round(length(Input) * 1.5);
    bufinc           := round(length(Input) * 0.5);
    Output           := StringOfChar(#0, buflen);

    stream.next_in   := @Input[1];
    stream.avail_in  := length(Input);
    stream.next_out  := @Output[1];
    stream.avail_out := buflen;

    stream.zalloc    := nil;
    stream.zfree     := nil;
    stream.opaque    := nil;

    Result := inflateInit(@stream);

    if (Result <> Z_OK) then
      Exit;

    repeat
      Result := inflate(@stream, Z_SYNC_FLUSH);

      if Result = Z_OK then
      begin
        nextpos          := length(Output) + 1;
        Output           := Output + StringOfChar(#0, bufinc);
        stream.next_out  := @Output[nextpos];
        stream.avail_out := bufinc;
      end;

    until (Result <> Z_OK);

    if Result = Z_STREAM_END then
    begin
      Output := copy(Output, 1, stream.total_out);
      Result := inflateEnd(@stream);
    end
    else
    begin
      Output := '';                                        // do not localize
      inflateEnd(@stream);
    end;

  finally
    EndUseZLib;
  end;
end;

{***************************************************************************}

function InflateString2(Input: string; var Output: string;
  windowBits: integer): integer;
var
  stream: z_stream;
  buflen: integer;
  bufinc: integer;
  nextpos: integer;
begin
  BeginUseZLib;

  try
    fillchar(stream, sizeof(stream), 0);

    buflen           := round(length(Input) * 1.5);
    bufinc           := round(length(Input) * 0.5);
    Output           := StringOfChar(#0, buflen);

    stream.next_in   := @Input[1];
    stream.avail_in  := length(Input);
    stream.next_out  := @Output[1];
    stream.avail_out := buflen;

    stream.zalloc    := nil;
    stream.zfree     := nil;
    stream.opaque    := nil;

    Result := inflateInit2(@stream, windowBits);

    if (Result <> Z_OK) then
      Exit;

    repeat
      Result := inflate(@stream, Z_SYNC_FLUSH);

      if Result = Z_OK then
      begin
        nextpos          := length(Output) + 1;
        Output           := Output + StringOfChar(#0, bufinc);
        stream.next_out  := @Output[nextpos];
        stream.avail_out := bufinc;
      end;

    until (Result <> Z_OK);

    if Result = Z_STREAM_END then
    begin
      Output := copy(Output, 1, stream.total_out);
      Result := inflateEnd(@stream);
    end
    else
    begin
      Output := '';                                        // do not localize
      inflateEnd(@stream);
    end;

  finally
    EndUseZLib;
  end;
end;

{***************************************************************************}

function DeflateString(Input: string; var Output: string): integer;
var
  stream: z_stream;
  buflen: integer;
  bufinc: integer;
  nextpos: integer;
begin
  BeginUseZLib;

  try
    fillchar(stream, sizeof(stream), 0);

    buflen           := round(length(Input) * 1.1) + 12;
    bufinc           := round(length(Input) * 0.2) + 64;
    Output           := StringOfChar(#0, buflen);

    stream.next_in   := @Input[1];
    stream.avail_in  := length(Input);
    stream.next_out  := @Output[1];
    stream.avail_out := buflen;

    stream.zalloc    := nil;
    stream.zfree     := nil;
    stream.opaque    := nil;

    Result := deflateInit(@stream, Z_DEFAULT_COMPRESSION);

    if (Result <> Z_OK) then
      Exit;

    repeat
      Result := deflate(@stream, Z_FINISH);

      if Result = Z_OK then
      begin
        nextpos          := length(Output) + 1;
        Output           := Output + StringOfChar(#0, bufinc);
        stream.next_out  := @Output[nextpos];
        stream.avail_out := bufinc;
      end;

    until (Result <> Z_OK);

    if Result = Z_STREAM_END then
    begin
      Output := copy(Output, 1, stream.total_out);
      Result := deflateEnd(@stream);
    end
    else
    begin
      Output := '';                                        // do not localize
      deflateEnd(@stream);
    end;

  finally
    EndUseZLib;
  end;
end;

{***************************************************************************}

function DeflateString2 (Input: string; var Output: string;
  level: integer; method: integer; windowBits: integer;
  memLevel: integer; strategy: integer): integer;
var
  stream : z_stream;
  buflen: integer;
  bufinc: integer;
  nextpos: integer;
begin
  BeginUseZLib;

  try
    fillchar(stream, sizeof(stream), 0);

    buflen           := round(length(Input) * 1.1) + 12;
    bufinc           := round(length(Input) * 0.2) + 64;
    Output           := StringOfChar(#0, buflen);

    stream.next_in   := @Input[1];
    stream.avail_in  := length(Input);
    stream.next_out  := @Output[1];
    stream.avail_out := buflen;

    stream.zalloc    := nil;
    stream.zfree     := nil;
    stream.opaque    := nil;

    Result := deflateInit2(@stream, level, method, windowBits, memLevel, strategy);

    if (Result <> Z_OK) then
      Exit;

    repeat
      Result := deflate(@stream, Z_FINISH);

      if Result = Z_OK then
      begin
        nextpos          := length(Output) + 1;
        Output           := Output + StringOfChar(#0, bufinc);
        stream.next_out  := @Output[nextpos];
        stream.avail_out := bufinc;
      end;

    until (Result <> Z_OK);

    if Result = Z_STREAM_END then
    begin
      Output := copy(Output, 1, stream.total_out);
      Result := deflateEnd(@stream);
    end
    else
    begin
      Output := '';                                        // do not localize
      deflateEnd(@stream);
    end;

  finally
    EndUseZLib;
  end;
end;

{****************************************************************************}

{$ENDIF} // INCLUDE_ZLIB

{****************************************************************************}

{$IFDEF LATE_BINDING}

procedure BeginUseLibmng;
var iX : TMNGFuncType;
{$IFNDEF LINUX}
    iY : TZFuncType;
{$ENDIF}
begin
  inc(iMNGUse);

  if (hLibmng = 0) then
  begin
     hLibmng:= LoadLibrary(mngdll);
{$IFDEF LINUX}
     if (hLibmng = 0) then
{$ELSE}
     if (hLibmng < HINSTANCE_ERROR) then
{$ENDIF}
     begin
       hLibmng := 0;
       Exit;
     end;

     for iX := lmf_version_text to lmf_putchunk_jsep do
       aMNGFuncs[iX].fPtr.f_ptr := GetProcAddress(hLibmng, pchar(aMNGFuncs[iX].sName));

{$IFNDEF LINUX}
     for iY := zlf_deflateInit_ to zlf_get_crc_table do
       aZFuncs[iY].fPtr.f_ptr := GetProcAddress(hLibmng, pchar(aZFuncs[iY].sName));
{$ENDIF}

  end;
end;

procedure EndUseLibmng;
var iX : TMNGFuncType;
{$IFNDEF LINUX}
    iY : TZFuncType;
{$ENDIF}
begin
  if iMNGUse > 0 then
    dec(iMNGUse);

  if iMNGUse <= 0 then
  begin
{$IFNDEF LINUX}
     for iY := zlf_deflateInit_ to zlf_get_crc_table do
       aZFuncs[iY].fPtr.f_ptr := nil;
{$ENDIF}

     for iX := lmf_version_text to lmf_putchunk_jsep do
       aMNGFuncs[iX].fPtr.f_ptr := nil;

     if hLibmng <> 0 then
     begin
       FreeLibrary(hLibmng);
       hLibmng := 0;
     end;
  end;
end;

{$IFDEF INCLUDE_ZLIB}


{$IFDEF LINUX}

procedure BeginUseZLib;
var iX : TZFuncType;
begin
  inc(iZLIBUse);

  if (hLibz = 0) then
  begin
     hLibz:= LoadLibrary(zdll);
     if (hLibz = 0) then
       Exit;

     for iX := zlf_deflateInit_ to zlf_get_crc_table do
       aZFuncs[iX].fPtr.f_ptr := GetProcAddress(hLibz, pchar(aZFuncs[iX].sName));
  end;
end;

procedure EndUseZLib;
var iX : TZFuncType;
begin
  if iZLIBUse > 0 then
    dec(iZLIBUse);

  if iZLIBUse <= 0 then
  begin
     for iX := zlf_deflateInit_ to zlf_get_crc_table do
       aZFuncs[iX].fPtr.f_ptr := nil;

     if hLibz <> 0 then
     begin
       FreeLibrary(hLibz);
       hLibz := 0;
     end;
  end;
end;

{$ELSE}  // LINUX

procedure BeginUseZLib;
begin
  BeginUseLibmng;
end;

procedure EndUseZLib;
begin
  EndUseLibmng;
end;

{$ENDIF} // LINUX

{$ENDIF} // INCLUDE_ZLIB

{****************************************************************************}

Initialization
  hLibmng     := 0;
  iMNGUse     := 0;
{$IFDEF LINUX}
  hLibz		  := 0;
  iZLIBUse    := 0;
{$ENDIF}

{$ENDIF} // LATE_BINDING

{****************************************************************************}

end.

