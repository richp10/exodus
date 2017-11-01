unit NGJPEG;

{****************************************************************************}
{*                                                                          *}
{*  for copyright and version information see header in NGImages.pas        *}
{*                                                                          *}
{****************************************************************************}
{*                                                                          *}
{*  Changelog:                            * reverse chronological order *   *}
{*                                                                          *}
{*  * 0.9.8 *                                                               *}
{*  2001/07/21 - GJU - Fixed late binding for JPEG                          *}
{*  2001/07/16 - SPR - Added late binding for JPEG                          *}
{*  2001/05/08 - SPR - Restructured for Maintainability                     *}
{*             - SPR - Seperated original NGImage.pas into multiple units   *}
{*                                                                          *}
{****************************************************************************}


{$INCLUDE NGDefs.inc}



interface



uses { Borland Standard Units }
     { NOTE:  Graphics MUST be AFTER the "Windows" unit, as BOTH define a
              Bitmap type, and only the Graphics One defines the required
              properties used in some of the methods }
     Classes, Windows, Graphics;


{****************************************************************************}
{* LIBMNG interface definitions for JPEG                                    *}
{****************************************************************************}
{*                                                                          *}
{*  Based in part on the works of the Independant JPEG Group (IJG)          *}
{*  copyright (C) 1991-1998 Thomas G. Lane                                  *}
{*  http://www.ijg.org                                                      *}
{*                                                                          *}
{*  The implementation of the TJPEGImage is based on sample code in the     *}
{*  JPEG unit provided with Borland Delphi.                                 *}
{*  Copyright (c) 1997 Borland International                                *}
{*  (only adapted to work with ijgsrc6b in libmng.dll)                      *}
{*                                                                          *}
{****************************************************************************}

resourcestring
  sChangeJPGSize = 'Cannot change the size of a JPEG image'; // do not localize
  sJPEGError = 'JPEG error #%d';                           // do not localize

{***************************************************************************}

type
  TJPEGQualityRange = 1..100;   // 100 = best quality, 25 = pretty awful
  TJPEGPerformance = (jpBestQuality, jpBestSpeed);
  TJPEGScale = (jsFullSize, jsHalf, jsQuarter, jsEighth);
  TJPEGPixelFormat = (jf24Bit, jf8Bit);

{***************************************************************************}

type
  { TJPEGData }

  TJPEGData = class(TSharedImage)
  private
    { Private declarations }
    FData: TCustomMemoryStream;
    FHeight: Integer;
    FWidth: Integer;
    FGrayscale: Boolean;
    FBuffer: Pointer;                  // added for JPEGLIB streaming support
    FSize: Integer;                    // size of buffer
  protected
    { Protected declarations }
    procedure FreeHandle; override;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    property PData: TCustomMemoryStream read FData;
  end;


  { TJPEGImage }

  TJPEGImage = class(TGraphic)
  private
    { Private declarations }
    FImage: TJPEGData;
    FBitmap: TBitmap;
    FScaledWidth: Integer;
    FScaledHeight: Integer;
    FTempPal: HPalette;
    FSmoothing: Boolean;
    FGrayScale: Boolean;
    FPixelFormat: TJPEGPixelFormat;
    FQuality: TJPEGQualityRange;
    FProgressiveDisplay: Boolean;
    FProgressiveEncoding: Boolean;
    FPerformance: TJPEGPerformance;
    FScale: TJPEGScale;
    FNeedRecalc: Boolean;

    procedure CalcOutputDimensions;
    function GetBitmap: TBitmap;
    function GetGrayscale: Boolean;
    procedure SetGrayscale(Value: Boolean);
    procedure SetPerformance(Value: TJPEGPerformance);
    procedure SetPixelFormat(Value: TJPEGPixelFormat);
    procedure SetScale(Value: TJPEGScale);
    procedure SetSmoothing(Value: Boolean);
  protected
    { Protected declarations }
    procedure AssignTo(Dest: TPersistent); override;
    procedure Changed(Sender: TObject); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    function Equals(Graphic: TGraphic): Boolean; override;
    procedure FreeBitmap;
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetPalette: HPALETTE; override;
    function GetWidth: Integer; override;
    procedure NewBitmap;
    procedure NewImage;
    procedure ReadData(Stream: TStream); override;
    procedure ReadStream(Size: Longint; Stream: TStream);
    procedure SetHeight(Value: Integer); override;
    procedure SetPalette(Value: HPalette); override;
    procedure SetWidth(Value: Integer); override;
    procedure WriteData(Stream: TStream); override;
  public
    { Public declarations }
    constructor Create; override;
    destructor Destroy; override;
    procedure Compress;
    procedure DIBNeeded;
    procedure JPEGNeeded;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;

    property Bitmap: TBitmap read GetBitmap;  // volatile
    property PData: TJPEGData read FImage;
    // Options affecting / reflecting compression and decompression behavior
    property Grayscale: Boolean read GetGrayscale write SetGrayscale;
    property ProgressiveEncoding: Boolean read FProgressiveEncoding write FProgressiveEncoding;

    // Compression options
    property CompressionQuality: TJPEGQualityRange read FQuality write FQuality;

    // Decompression options
    property PixelFormat: TJPEGPixelFormat read FPixelFormat write SetPixelFormat;
    property ProgressiveDisplay: Boolean read FProgressiveDisplay write FProgressiveDisplay;
    property Performance: TJPEGPerformance read FPerformance write SetPerformance;
    property Scale: TJPEGScale read FScale write SetScale;
    property Smoothing: Boolean read FSmoothing write SetSmoothing;
  end;

{***************************************************************************}

  { TJPEGDefaults }

  TJPEGDefaults = record
    CompressionQuality: TJPEGQualityRange;
    Grayscale: Boolean;
    Performance: TJPEGPerformance;
    PixelFormat: TJPEGPixelFormat;
    ProgressiveDisplay: Boolean;
    ProgressiveEncoding: Boolean;
    Scale: TJPEGScale;
    Smoothing: Boolean;
  end;

{***************************************************************************}

var   // Default settings for all new TJPEGImage instances
  JPEGDefaults: TJPEGDefaults = (
    CompressionQuality: 90;
    Grayscale: False;
    Performance: jpBestQuality;
    PixelFormat: jf24Bit;         // initialized to match video mode
    ProgressiveDisplay: False;
    ProgressiveEncoding: False;
    Scale: jsFullSize;
    Smoothing: True;
  );

{***************************************************************************}

{ The following types and external function declarations are used to
  call into functions of the Independent JPEG Group's (IJG) implementation // do not localize
  of the JPEG image compression/decompression public standard.  The IJG
  library's C source code is compiled into OBJ files and linked into // do not localize
  the Delphi application. Only types and functions needed by this unit
  are declared; all IJG internal structures are stubbed out with
  generic pointers to reduce internal source code congestion.

  IJG source code copyright (C) 1991-1996, Thomas G. Lane. }

{$Z4}  // Minimum enum size = dword

const
  JPEG_LIB_VERSION = 62;        { Version 6b }

  JPEG_RST0     = $D0;  { RST0 marker code }
  JPEG_EOI      = $D9;  { EOI marker code }
  JPEG_APP0     = $E0;  { APP0 marker code }
  JPEG_COM      = $FE;  { COM marker code }

  DCTSIZE             = 8;      { The basic DCT block is 8x8 samples }
  DCTSIZE2            = 64;     { DCTSIZE squared; # of elements in a block }
  NUM_QUANT_TBLS      = 4;      { Quantization tables are numbered 0..3 }
  NUM_HUFF_TBLS       = 4;      { Huffman tables are numbered 0..3 }
  NUM_ARITH_TBLS      = 16;     { Arith-coding tables are numbered 0..15 }
  MAX_COMPS_IN_SCAN   = 4;      { JPEG limit on # of components in one scan }
  MAX_SAMP_FACTOR     = 4;      { JPEG limit on sampling factors }
  C_MAX_BLOCKS_IN_MCU = 10;     { compressor's limit on blocks per MCU } // do not localize
  D_MAX_BLOCKS_IN_MCU = 10;     { decompressor's limit on blocks per MCU } // do not localize
  MAX_COMPONENTS = 10;          { maximum number of image components (color channels) }

  MAXJSAMPLE = 255;
  CENTERJSAMPLE = 128;

type
  JSAMPLE = byte;
  GETJSAMPLE = integer;
  JCOEF = word;
  JCOEF_PTR = ^JCOEF;
  UINT8 = byte;
  UINT16 = Word;
  UINT = Cardinal;
  INT16 = SmallInt;
  INT32 = Integer;
  INT32PTR = ^INT32;
  JDIMENSION = Cardinal;

  JOCTET = Byte;
  jTOctet = 0..(MaxInt div SizeOf(JOCTET))-1;
  JOCTET_FIELD = array[jTOctet] of JOCTET;
  JOCTET_FIELD_PTR = ^JOCTET_FIELD;
  JOCTETPTR = ^JOCTET;

  JSAMPLE_PTR = ^JSAMPLE;
  JSAMPROW_PTR = ^JSAMPROW;

  jTSample = 0..(MaxInt div SIZEOF(JSAMPLE))-1;
  JSAMPLE_ARRAY = Array[jTSample] of JSAMPLE;  {far}
  JSAMPROW = ^JSAMPLE_ARRAY;  { ptr to one image row of pixel samples. }

  jTRow = 0..(MaxInt div SIZEOF(JSAMPROW))-1;
  JSAMPROW_ARRAY = Array[jTRow] of JSAMPROW;
  JSAMPARRAY = ^JSAMPROW_ARRAY;  { ptr to some rows (a 2-D sample array) }

  jTArray = 0..(MaxInt div SIZEOF(JSAMPARRAY))-1;
  JSAMP_ARRAY = Array[jTArray] of JSAMPARRAY;
  JSAMPIMAGE = ^JSAMP_ARRAY;  { a 3-D sample array: top index is color }

const
  CSTATE_START        = 100;    { after create_compress }
  CSTATE_SCANNING     = 101;    { start_compress done, write_scanlines OK }
  CSTATE_RAW_OK       = 102;    { start_compress done, write_raw_data OK }
  CSTATE_WRCOEFS      = 103;    { jpeg_write_coefficients done }
  DSTATE_START        = 200;    { after create_decompress }
  DSTATE_INHEADER     = 201;    { reading header markers, no SOS yet }
  DSTATE_READY        = 202;    { found SOS, ready for start_decompress }
  DSTATE_PRELOAD      = 203;    { reading multiscan file in start_decompress}
  DSTATE_PRESCAN      = 204;    { performing dummy pass for 2-pass quant }
  DSTATE_SCANNING     = 205;    { start_decompress done, read_scanlines OK }
  DSTATE_RAW_OK       = 206;    { start_decompress done, read_raw_data OK }
  DSTATE_BUFIMAGE     = 207;    { expecting jpeg_start_output }
  DSTATE_BUFPOST      = 208;    { looking for SOS/EOI in jpeg_finish_output }
  DSTATE_RDCOEFS      = 209;    { reading file in jpeg_read_coefficients }
  DSTATE_STOPPING     = 210;    { looking for EOI in jpeg_finish_decompress }

{ Known color spaces. }

type
  J_COLOR_SPACE = (
  JCS_UNKNOWN,            { error/unspecified }
  JCS_GRAYSCALE,          { monochrome }
  JCS_RGB,                { red/green/blue }
  JCS_YCbCr,              { Y/Cb/Cr (also known as YUV) }
  JCS_CMYK,               { C/M/Y/K }
  JCS_YCCK                { Y/Cb/Cr/K }
                  );

{ DCT/IDCT algorithm options. }

type
  J_DCT_METHOD = (
	JDCT_ISLOW,		{ slow but accurate integer algorithm }
	JDCT_IFAST,		{ faster, less accurate integer method }
	JDCT_FLOAT		{ floating-point: accurate, fast on fast HW (Pentium)}
                 );

{ Dithering options for decompression. }

type
  J_DITHER_MODE = (
    JDITHER_NONE,               { no dithering }
    JDITHER_ORDERED,            { simple ordered dither }
    JDITHER_FS                  { Floyd-Steinberg error diffusion dither }
                  );

{ Error handler }

const
  JMSG_LENGTH_MAX  = 200;  { recommended size of format_message buffer }
  JMSG_STR_PARM_MAX = 80;

  JPOOL_PERMANENT = 0;  // lasts until master record is destroyed
  JPOOL_IMAGE	    = 1;	 // lasts until done with image/datastream

type
  jpeg_error_mgr_ptr = ^jpeg_error_mgr;
  jpeg_progress_mgr_ptr = ^jpeg_progress_mgr;

  j_common_ptr = ^jpeg_common_struct;
  j_compress_ptr = ^jpeg_compress_struct;
  j_decompress_ptr = ^jpeg_decompress_struct;

{ Routine signature for application-supplied marker processing methods.
  Need not pass marker code since it is stored in cinfo^.unread_marker. }

  jpeg_marker_parser_method = function(cinfo : j_decompress_ptr) : LongBool; stdcall;

{ Marker reading & parsing }
  jpeg_marker_reader_ptr = ^jpeg_marker_reader;
  jpeg_marker_reader = packed record
    reset_marker_reader : procedure(cinfo : j_decompress_ptr); stdcall;
    { Read markers until SOS or EOI.
      Returns same codes as are defined for jpeg_consume_input:
      JPEG_SUSPENDED, JPEG_REACHED_SOS, or JPEG_REACHED_EOI. }

    read_markers : function (cinfo : j_decompress_ptr) : Integer; stdcall;
    { Read a restart marker --- exported for use by entropy decoder only }
    read_restart_marker : jpeg_marker_parser_method;
    { Application-overridable marker processing methods }
//    process_COM : jpeg_marker_parser_method;
//    process_APPn : Array[0..16-1] of jpeg_marker_parser_method;

    { State of marker reader --- nominally internal, but applications
      supplying COM or APPn handlers might like to know the state. }

    saw_SOI : LongBool;            { found SOI? }
    saw_SOF : LongBool;            { found SOF? }
    next_restart_num : Integer;    { next restart number expected (0-7) }
    discarded_bytes : UINT;        { # of bytes skipped looking for a marker }
  end;

  {int8array = Array[0..8-1] of int;}
  int8array = Array[0..8-1] of Integer;

  jpeg_error_mgr = record
    { Error exit handler: does not return to caller }
    error_exit : procedure  (cinfo : j_common_ptr); stdcall;
    { Conditionally emit a trace or warning message }
    emit_message : procedure (cinfo : j_common_ptr; msg_level : Integer); stdcall;
    { Routine that actually outputs a trace or error message }
    output_message : procedure (cinfo : j_common_ptr); stdcall;
    { Format a message string for the most recent JPEG error or message }
    format_message : procedure  (cinfo : j_common_ptr; buffer: PChar); stdcall;
    { Reset error state variables at start of a new image }
    reset_error_mgr : procedure (cinfo : j_common_ptr); stdcall;

    { The message ID code and any parameters are saved here.
      A message can have one string parameter or up to 8 int parameters. }

    msg_code : Integer;

    msg_parm : record
      case byte of
      0:(i : int8array);
      1:(s : string[JMSG_STR_PARM_MAX]);
    end;
    trace_level : Integer;     { max msg_level that will be displayed }
    num_warnings : Integer;    { number of corrupt-data warnings }
    jpeg_message_table : Pointer; { Library errors }
    last_jpeg_message : Integer;    { Table contains strings 0..last_jpeg_message }
    { Second table can be added by application (see cjpeg/djpeg for example).
      It contains strings numbered first_addon_message..last_addon_message. }
    addon_message_table : Pointer; { Non-library errors }
    first_addon_message : Integer;	{ code for first string in addon table }
    last_addon_message : Integer;	{ code for last string in addon table }
  end;


{ Data destination object for compression }
  jpeg_destination_mgr_ptr = ^jpeg_destination_mgr;
  jpeg_destination_mgr = record
    next_output_byte : JOCTETptr;  { => next byte to write in buffer }
    free_in_buffer : Longint;    { # of byte spaces remaining in buffer }

    init_destination : procedure (cinfo : j_compress_ptr); stdcall;
    empty_output_buffer : function (cinfo : j_compress_ptr) : LongBool; stdcall;
    term_destination : procedure (cinfo : j_compress_ptr); stdcall;
  end;


{ Data source object for decompression }

  jpeg_source_mgr_ptr = ^jpeg_source_mgr;
  jpeg_source_mgr = record
    next_input_byte : JOCTETptr;      { => next byte to read from buffer }
    bytes_in_buffer : Longint;       { # of bytes remaining in buffer }

    init_source : procedure  (cinfo : j_decompress_ptr); stdcall;
    fill_input_buffer : function (cinfo : j_decompress_ptr) : LongBool; stdcall;
    skip_input_data : procedure (cinfo : j_decompress_ptr; num_bytes : Longint); stdcall;
    resync_to_restart : function (cinfo : j_decompress_ptr;
                                  desired : Integer) : LongBool; stdcall;
    term_source : procedure (cinfo : j_decompress_ptr); stdcall;
  end;

{ JPEG library memory manger routines }
  jpeg_memory_mgr_ptr = ^jpeg_memory_mgr;
  jpeg_memory_mgr = record
    { Method pointers }
    alloc_small : function (cinfo : j_common_ptr;
                            pool_id, sizeofobject: Integer): pointer; stdcall;
    alloc_large : function (cinfo : j_common_ptr;
                            pool_id, sizeofobject: Integer): pointer; stdcall;
    alloc_sarray : function (cinfo : j_common_ptr; pool_id : Integer;
                             samplesperrow : JDIMENSION;
                             numrows : JDIMENSION) : JSAMPARRAY; stdcall;
    alloc_barray : pointer;
    request_virt_sarray : pointer;
    request_virt_barray : pointer;
    realize_virt_arrays : pointer;
    access_virt_sarray : pointer;
    access_virt_barray : pointer;
    free_pool : pointer;
    self_destruct : pointer;
    max_memory_to_use : Longint;
    max_alloc_chunk : Longint;
  end;

    { Fields shared with jpeg_decompress_struct }
  jpeg_common_struct = packed record
    err : jpeg_error_mgr_ptr;        { Error handler module }
    mem : jpeg_memory_mgr_ptr;          { Memory manager module }
    progress : jpeg_progress_mgr_ptr;   { Progress monitor, or NIL if none }
    client_data : Pointer;            { Available for use by application }
    is_decompressor : LongBool;      { so common code can tell which is which }
    global_state : Integer;          { for checking call sequence validity }
  end;

{ Progress monitor object }

  jpeg_progress_mgr = record
    progress_monitor : procedure(const cinfo : jpeg_common_struct); stdcall;
    pass_counter : Integer;     { work units completed in this pass }
    pass_limit : Integer;       { total number of work units in this pass }
    completed_passes : Integer;	{ passes completed so far }
    total_passes : Integer;     { total number of passes expected }
    // extra Delphi info
    instance: TJPEGImage;       // ptr to current TJPEGImage object
    last_pass: Integer;
    last_pct: Integer;
    last_time: Integer;
    last_scanline: Integer;
  end;


{ Master record for a compression instance }

  jpeg_compress_struct = packed record
    common: jpeg_common_struct;

    dest : jpeg_destination_mgr_ptr; { Destination for compressed data }

  { Description of source image --- these fields must be filled in by
    outer application before starting compression.  in_color_space must
    be correct before you can even call jpeg_set_defaults(). }

    image_width : JDIMENSION;         { input image width }
    image_height : JDIMENSION;        { input image height }
    input_components : Integer;       { # of color components in input image }
    in_color_space : J_COLOR_SPACE;   { colorspace of input image }
    input_gamma : double;             { image gamma of input image }

    // Compression parameters
    data_precision : Integer;             { bits of precision in image data }
    num_components : Integer;             { # of color components in JPEG image }
    jpeg_color_space : J_COLOR_SPACE;     { colorspace of JPEG image }
    comp_info : Pointer;
    quant_tbl_ptrs: Array[0..NUM_QUANT_TBLS-1] of Pointer;
    dc_huff_tbl_ptrs : Array[0..NUM_HUFF_TBLS-1] of Pointer;
    ac_huff_tbl_ptrs : Array[0..NUM_HUFF_TBLS-1] of Pointer;
    arith_dc_L : Array[0..NUM_ARITH_TBLS-1] of UINT8; { L values for DC arith-coding tables }
    arith_dc_U : Array[0..NUM_ARITH_TBLS-1] of UINT8; { U values for DC arith-coding tables }
    arith_ac_K : Array[0..NUM_ARITH_TBLS-1] of UINT8; { Kx values for AC arith-coding tables }
    num_scans : Integer;		 { # of entries in scan_info array }
    scan_info : Pointer;     { script for multi-scan file, or NIL }
    raw_data_in : LongBool;        { TRUE=caller supplies downsampled data }
    arith_code : LongBool;         { TRUE=arithmetic coding, FALSE=Huffman }
    optimize_coding : LongBool;    { TRUE=optimize entropy encoding parms }
    CCIR601_sampling : LongBool;   { TRUE=first samples are cosited }
    smoothing_factor : Integer;       { 1..100, or 0 for no input smoothing }
    dct_method : J_DCT_METHOD;    { DCT algorithm selector }
    restart_interval : UINT;      { MCUs per restart, or 0 for no restart }
    restart_in_rows : Integer;        { if > 0, MCU rows per restart interval }

    { Parameters controlling emission of special markers. }
    write_JFIF_header : LongBool;  { should a JFIF marker be written? }
    JFIF_major_version : UINT8;  { What to write for the JFIF version number }
    JFIF_minor_version : UINT8;
    { These three values are not used by the JPEG code, merely copied }
    { into the JFIF APP0 marker.  density_unit can be 0 for unknown, }
    { 1 for dots/inch, or 2 for dots/cm.  Note that the pixel aspect }
    { ratio is defined by X_density/Y_density even when density_unit=0. }
    density_unit : UINT8;         { JFIF code for pixel size units }
    dummy1 : byte;
    X_density : UINT16;           { Horizontal pixel density }
    Y_density : UINT16;           { Vertical pixel density }
    write_Adobe_marker : LongBool; { should an Adobe marker be written? }

    { State variable: index of next scanline to be written to
      jpeg_write_scanlines().  Application may use this to control its
      processing loop, e.g., "while (next_scanline < image_height)". }

    next_scanline : JDIMENSION;   { 0 .. image_height-1  }

    { Remaining fields are known throughout compressor, but generally
      should not be touched by a surrounding application. }
    progressive_mode : LongBool;   { TRUE if scan script uses progressive mode }
    max_h_samp_factor : Integer;      { largest h_samp_factor }
    max_v_samp_factor : Integer;      { largest v_samp_factor }
    total_iMCU_rows : JDIMENSION; { # of iMCU rows to be input to coef ctlr }
    comps_in_scan : Integer;          { # of JPEG components in this scan }
    cur_comp_info : Array[0..MAX_COMPS_IN_SCAN-1] of Pointer;
    MCUs_per_row : JDIMENSION;    { # of MCUs across the image }
    MCU_rows_in_scan : JDIMENSION;{ # of MCU rows in the image }
    blocks_in_MCU : Integer;          { # of DCT blocks per MCU }
    MCU_membership : Array[0..C_MAX_BLOCKS_IN_MCU-1] of Integer;
    Ss, Se, Ah, Al : Integer;         { progressive JPEG parameters for scan }

    { Links to compression subobjects (methods and private variables of modules) }
    master : Pointer;
    main : Pointer;
    prep : Pointer;
    coef : Pointer;
    marker : Pointer;
    cconvert : Pointer;
    downsample : Pointer;
    fdct : Pointer;
    entropy : Pointer;
    script_space : Pointer; { workspace for jpeg_simple_progression }
    script_space_size : Integer;
  end;


{ Master record for a decompression instance }

  jpeg_decompress_struct = packed record
    common: jpeg_common_struct;

    { Source of compressed data }
    src : jpeg_source_mgr_ptr;

    { Basic description of image --- filled in by jpeg_read_header(). }
    { Application may inspect these values to decide how to process image. }

    image_width : JDIMENSION;      { nominal image width (from SOF marker) }
    image_height : JDIMENSION;     { nominal image height }
    num_components : Integer;          { # of color components in JPEG image }
    jpeg_color_space : J_COLOR_SPACE; { colorspace of JPEG image }

    { Decompression processing parameters }
    out_color_space : J_COLOR_SPACE; { colorspace for output }
    scale_num, scale_denom : uint ;  { fraction by which to scale image }
    output_gamma : double;           { image gamma wanted in output }
    buffered_image : LongBool;        { TRUE=multiple output passes }
    raw_data_out : LongBool;          { TRUE=downsampled data wanted }
    dct_method : J_DCT_METHOD;       { IDCT algorithm selector }
    do_fancy_upsampling : LongBool;   { TRUE=apply fancy upsampling }
    do_block_smoothing : LongBool;    { TRUE=apply interblock smoothing }
    quantize_colors : LongBool;       { TRUE=colormapped output wanted }
    { the following are ignored if not quantize_colors: }
    dither_mode : J_DITHER_MODE;     { type of color dithering to use }
    two_pass_quantize : LongBool;     { TRUE=use two-pass color quantization }
    desired_number_of_colors : Integer;  { max # colors to use in created colormap }
    { these are significant only in buffered-image mode: }
    enable_1pass_quant : LongBool;    { enable future use of 1-pass quantizer }
    enable_external_quant : LongBool; { enable future use of external colormap }
    enable_2pass_quant : LongBool;    { enable future use of 2-pass quantizer }

    { Description of actual output image that will be returned to application.
      These fields are computed by jpeg_start_decompress().
      You can also use jpeg_calc_output_dimensions() to determine these values
      in advance of calling jpeg_start_decompress(). }

    output_width : JDIMENSION;       { scaled image width }
    output_height: JDIMENSION;       { scaled image height }
    out_color_components : Integer;  { # of color components in out_color_space }
    output_components : Integer;     { # of color components returned }
    { output_components is 1 (a colormap index) when quantizing colors;
      otherwise it equals out_color_components. }

    rec_outbuf_height : Integer;     { min recommended height of scanline buffer }
    { If the buffer passed to jpeg_read_scanlines() is less than this many
      rows high, space and time will be wasted due to unnecessary data
      copying. Usually rec_outbuf_height will be 1 or 2, at most 4. }

    { When quantizing colors, the output colormap is described by these
      fields. The application can supply a colormap by setting colormap
      non-NIL before calling jpeg_start_decompress; otherwise a colormap
      is created during jpeg_start_decompress or jpeg_start_output. The map
      has out_color_components rows and actual_number_of_colors columns. }

    actual_number_of_colors : Integer;      { number of entries in use }
    colormap : JSAMPARRAY;              { The color map as a 2-D pixel array }

    { State variables: these variables indicate the progress of decompression.
      The application may examine these but must not modify them. }

    { Row index of next scanline to be read from jpeg_read_scanlines().
      Application may use this to control its processing loop, e.g.,
      "while (output_scanline < output_height)". }

    output_scanline : JDIMENSION; { 0 .. output_height-1  }

    { Current input scan number and number of iMCU rows completed in scan.
      These indicate the progress of the decompressor input side. }

    input_scan_number : Integer;      { Number of SOS markers seen so far }
    input_iMCU_row : JDIMENSION;  { Number of iMCU rows completed }

    { The "output scan number" is the notional scan being displayed by the
      output side.  The decompressor will not allow output scan/row number
      to get ahead of input scan/row, but it can fall arbitrarily far behind.}

    output_scan_number : Integer;     { Nominal scan number being displayed }
    output_iMCU_row : JDIMENSION;        { Number of iMCU rows read }

    coef_bits : Pointer;

    { Internal JPEG parameters --- the application usually need not look at
      these fields.  Note that the decompressor output side may not use
      any parameters that can change between scans. }

    { Quantization and Huffman tables are carried forward across input
      datastreams when processing abbreviated JPEG datastreams. }

    quant_tbl_ptrs : Array[0..NUM_QUANT_TBLS-1] of Pointer;
    dc_huff_tbl_ptrs : Array[0..NUM_HUFF_TBLS-1] of Pointer;
    ac_huff_tbl_ptrs : Array[0..NUM_HUFF_TBLS-1] of Pointer;

    { These parameters are never carried across datastreams, since they
      are given in SOF/SOS markers or defined to be reset by SOI. }
    data_precision : Integer;          { bits of precision in image data }
    comp_info : Pointer;
    progressive_mode : LongBool;    { TRUE if SOFn specifies progressive mode }
    arith_code : LongBool;          { TRUE=arithmetic coding, FALSE=Huffman }
    arith_dc_L : Array[0..NUM_ARITH_TBLS-1] of UINT8; { L values for DC arith-coding tables }
    arith_dc_U : Array[0..NUM_ARITH_TBLS-1] of UINT8; { U values for DC arith-coding tables }
    arith_ac_K : Array[0..NUM_ARITH_TBLS-1] of UINT8; { Kx values for AC arith-coding tables }

    restart_interval : UINT; { MCUs per restart interval, or 0 for no restart }

    { These fields record data obtained from optional markers recognized by
      the JPEG library. }
    saw_JFIF_marker : LongBool;  { TRUE iff a JFIF APP0 marker was found }
    { Data copied from JFIF marker: }
    JFIF_major_version : UINT8;	{ JFIF version number }
    JFIF_minor_version : UINT8;
    density_unit : UINT8;       { JFIF code for pixel size units }
    dummy1 : byte;
    X_density : UINT16;         { Horizontal pixel density }
    Y_density : UINT16;         { Vertical pixel density }
    saw_Adobe_marker : LongBool; { TRUE iff an Adobe APP14 marker was found }
    Adobe_transform : UINT8;    { Color transform code from Adobe marker }
    dummy2 : array [0 .. 2] of byte;

    CCIR601_sampling : LongBool; { TRUE=first samples are cosited }

    {  Aside from the specific data retained from APPn markers known to the
      library, the uninterpreted contents of any or all APPn and COM markers
      can be saved in a list for examination by the application. }
    marker_list : Pointer; { Head of list of saved markers }

    { Remaining fields are known throughout decompressor, but generally
      should not be touched by a surrounding application. }
    max_h_samp_factor : Integer;    { largest h_samp_factor }
    max_v_samp_factor : Integer;    { largest v_samp_factor }
    min_DCT_scaled_size : Integer;  { smallest DCT_scaled_size of any component }
    total_iMCU_rows : JDIMENSION; { # of iMCU rows in image }
    sample_range_limit : Pointer;   { table for fast range-limiting }

    { These fields are valid during any one scan.
      They describe the components and MCUs actually appearing in the scan.
      Note that the decompressor output side must not use these fields. }
    comps_in_scan : Integer;           { # of JPEG components in this scan }
    cur_comp_info : Array[0..MAX_COMPS_IN_SCAN-1] of Pointer;
    MCUs_per_row : JDIMENSION;     { # of MCUs across the image }
    MCU_rows_in_scan : JDIMENSION; { # of MCU rows in the image }
    blocks_in_MCU : Integer;    { # of DCT blocks per MCU }
    MCU_membership : Array[0..D_MAX_BLOCKS_IN_MCU-1] of Integer;
    Ss, Se, Ah, Al : Integer;          { progressive JPEG parameters for scan }

    { This field is shared between entropy decoder and marker parser.
      It is either zero or the code of a JPEG marker that has been
      read from the data source, but has not yet been processed. }
    unread_marker : Integer;

    { Links to decompression subobjects
      (methods, private variables of modules) }
    master : Pointer;
    main : Pointer;
    coef : Pointer;
    post : Pointer;
    inputctl : Pointer;
    marker : Pointer;
    entropy : Pointer;
    idct : Pointer;
    upsample : Pointer;
    cconvert : Pointer;
    cquantize : Pointer;
  end;

  { TJPEGContext }

  TJPEGContext = record
    err: jpeg_error_mgr;
    progress: jpeg_progress_mgr;
    FinalDCT: J_DCT_METHOD;
    FinalTwoPassQuant: Boolean;
    FinalDitherMode: J_DITHER_MODE;
    case byte of
      0: (common: jpeg_common_struct);
      1: (d: jpeg_decompress_struct);
      2: (c: jpeg_compress_struct);
  end;

{ Decompression startup: read start of JPEG datastream to see what's there // do not localize
   function jpeg_read_header (cinfo : j_decompress_ptr;
                              require_image : LongBool) : Integer;
  Return value is one of: }
const
  JPEG_SUSPENDED              = 0; { Suspended due to lack of input data }
  JPEG_HEADER_OK              = 1; { Found valid image datastream }
  JPEG_HEADER_TABLES_ONLY     = 2; { Found valid table-specs-only datastream }
{ If you pass require_image = TRUE (normal case), you need not check for
  a TABLES_ONLY return code; an abbreviated file will cause an error exit.
  JPEG_SUSPENDED is only possible if you use a data source module that can
  give a suspension return (the stdio source module doesn't). } // do not localize


{ function jpeg_consume_input (cinfo : j_decompress_ptr) : Integer;
  Return value is one of: }

  JPEG_REACHED_SOS            = 1; { Reached start of new scan }
  JPEG_REACHED_EOI            = 2; { Reached end of image }
  JPEG_ROW_COMPLETED          = 3; { Completed one iMCU row }
  JPEG_SCAN_COMPLETED         = 4; { Completed last iMCU row of a scan }

{***************************************************************************}
type
  Tjpeg_CreateDecompress = procedure (var cinfo : jpeg_decompress_struct;
    version : integer; structsize : integer); stdcall;
  Tjpeg_stdio_src = procedure (var cinfo: jpeg_decompress_struct;
    input_file: TStream); stdcall;
  Tjpeg_read_header = procedure (var cinfo: jpeg_decompress_struct;
    RequireImage: LongBool); stdcall;
  Tjpeg_calc_output_dimensions = procedure (var cinfo: jpeg_decompress_struct); stdcall;
  Tjpeg_start_decompress = function (var cinfo: jpeg_decompress_struct): Longbool; stdcall;
  Tjpeg_read_scanlines = function (var cinfo: jpeg_decompress_struct;
          scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; stdcall;
  Tjpeg_finish_decompress = function (var cinfo: jpeg_decompress_struct): Longbool; stdcall;
  Tjpeg_destroy_decompress = procedure (var cinfo : jpeg_decompress_struct); stdcall;
  Tjpeg_has_multiple_scans = function (var cinfo: jpeg_decompress_struct): Longbool; stdcall;
  Tjpeg_consume_input = function (var cinfo: jpeg_decompress_struct): Integer; stdcall;
  Tjpeg_start_output = function (var cinfo: jpeg_decompress_struct; scan_number: Integer): Longbool; stdcall;
  Tjpeg_finish_output = function (var cinfo: jpeg_decompress_struct): LongBool; stdcall;
  Tjpeg_destroy = procedure (var cinfo: jpeg_common_struct); stdcall;

  Tjpeg_CreateCompress = procedure (var cinfo : jpeg_compress_struct;
    version : integer; structsize : integer); stdcall;
  Tjpeg_stdio_dest = procedure (var cinfo: jpeg_compress_struct;
    output_file: TStream); stdcall;
  Tjpeg_set_defaults = procedure (var cinfo: jpeg_compress_struct); stdcall;
  Tjpeg_set_quality = procedure (var cinfo: jpeg_compress_struct; Quality: Integer;
    Baseline: Longbool); stdcall;
  Tjpeg_set_colorspace = procedure (var cinfo: jpeg_compress_struct;
    colorspace: J_COLOR_SPACE); stdcall;
  Tjpeg_simple_progression = procedure (var cinfo: jpeg_compress_struct); stdcall;
  Tjpeg_start_compress = procedure (var cinfo: jpeg_compress_struct;
    WriteAllTables: LongBool); stdcall;
  Tjpeg_write_scanlines = function (var cinfo: jpeg_compress_struct;
    scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; stdcall;
  Tjpeg_finish_compress = procedure (var cinfo: jpeg_compress_struct); stdcall;

  Tjpeg_resync_to_restart = function (cinfo : j_decompress_ptr; desired : Integer) : LongBool; stdcall;

{***************************************************************************

  TInitContext = procedure (var jc: TJPEGContext); stdcall;
  TReleaseContext = procedure (var jc: TJPEGContext); stdcall;

{***************************************************************************}

procedure jpeg_CreateDecompress (var cinfo : jpeg_decompress_struct;
  version : integer; structsize : integer); stdcall;
procedure jpeg_stdio_src(var cinfo: jpeg_decompress_struct;
  input_file: TStream); stdcall;
procedure jpeg_read_header(var cinfo: jpeg_decompress_struct;
  RequireImage: LongBool); stdcall;
procedure jpeg_calc_output_dimensions(var cinfo: jpeg_decompress_struct); stdcall;
function jpeg_start_decompress(var cinfo: jpeg_decompress_struct): Longbool; stdcall;
function jpeg_read_scanlines(var cinfo: jpeg_decompress_struct;
	scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; stdcall;
function jpeg_finish_decompress(var cinfo: jpeg_decompress_struct): Longbool; stdcall;
procedure jpeg_destroy_decompress (var cinfo : jpeg_decompress_struct); stdcall;
function jpeg_has_multiple_scans(var cinfo: jpeg_decompress_struct): Longbool; stdcall;
function jpeg_consume_input(var cinfo: jpeg_decompress_struct): Integer; stdcall;
function jpeg_start_output(var cinfo: jpeg_decompress_struct; scan_number: Integer): Longbool; stdcall;
function jpeg_finish_output(var cinfo: jpeg_decompress_struct): LongBool; stdcall;
procedure jpeg_destroy(var cinfo: jpeg_common_struct); stdcall;

procedure jpeg_CreateCompress (var cinfo : jpeg_compress_struct;
  version : integer; structsize : integer); stdcall;
procedure jpeg_stdio_dest(var cinfo: jpeg_compress_struct;
  output_file: TStream); stdcall;
procedure jpeg_set_defaults(var cinfo: jpeg_compress_struct); stdcall;
procedure jpeg_set_quality(var cinfo: jpeg_compress_struct; Quality: Integer;
  Baseline: Longbool); stdcall;
procedure jpeg_set_colorspace(var cinfo: jpeg_compress_struct;
  colorspace: J_COLOR_SPACE); stdcall;
procedure jpeg_simple_progression(var cinfo: jpeg_compress_struct); stdcall;
procedure jpeg_start_compress(var cinfo: jpeg_compress_struct;
  WriteAllTables: LongBool); stdcall;
function jpeg_write_scanlines(var cinfo: jpeg_compress_struct;
  scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; stdcall;
procedure jpeg_finish_compress(var cinfo: jpeg_compress_struct); stdcall;

function jpeg_resync_to_restart (cinfo : j_decompress_ptr; desired : Integer) : LongBool; stdcall;

{***************************************************************************}

procedure InitContext(var jc: TJPEGContext); stdcall;
procedure ReleaseContext(var jc: TJPEGContext); stdcall;

{****************************************************************************}
procedure InitDefaults;



implementation



uses { Own Units }
     NGConst, NGTypes,

     { Borland Standard Units }
     SysUtils;


{$IFDEF LATE_BINDING}
var
  hLibmng: THandle;
  _jpeg_CreateDecompress: Tjpeg_CreateDecompress;
  _jpeg_stdio_src: Tjpeg_stdio_src;
  _jpeg_read_header: Tjpeg_read_header;
  _jpeg_calc_output_dimensions: Tjpeg_calc_output_dimensions;
  _jpeg_start_decompress: Tjpeg_start_decompress;
  _jpeg_read_scanlines: Tjpeg_read_scanlines;
  _jpeg_finish_decompress: Tjpeg_finish_decompress;
  _jpeg_destroy_decompress: Tjpeg_destroy_decompress;
  _jpeg_has_multiple_scans: Tjpeg_has_multiple_scans;
  _jpeg_consume_input: Tjpeg_consume_input;
  _jpeg_start_output: Tjpeg_start_output;
  _jpeg_finish_output: Tjpeg_finish_output;
  _jpeg_destroy: Tjpeg_destroy;
  _jpeg_CreateCompress: Tjpeg_CreateCompress;
  _jpeg_stdio_dest: Tjpeg_stdio_dest;
  _jpeg_set_defaults: Tjpeg_set_defaults;
  _jpeg_set_quality: Tjpeg_set_quality;
  _jpeg_set_colorspace: Tjpeg_set_colorspace;
  _jpeg_simple_progression: Tjpeg_simple_progression;
  _jpeg_start_compress: Tjpeg_start_compress;
  _jpeg_write_scanlines: Tjpeg_write_scanlines;
  _jpeg_finish_compress: Tjpeg_finish_compress;
  _jpeg_resync_to_restart: Tjpeg_resync_to_restart;
{$ENDIF}


{****************************************************************************}
{* local funtions to interface with LIBMNGs JPEG code                       *}
{****************************************************************************}

{$IFNDEF LATE_BINDING}
procedure jpeg_CreateDecompress (var cinfo : jpeg_decompress_struct;
  version : integer; structsize : integer); stdcall; external mngdll;
procedure jpeg_stdio_src(var cinfo: jpeg_decompress_struct;
  input_file: TStream); stdcall; external mngdll;
procedure jpeg_read_header(var cinfo: jpeg_decompress_struct;
  RequireImage: LongBool); stdcall; external mngdll;
procedure jpeg_calc_output_dimensions(var cinfo: jpeg_decompress_struct); stdcall; external mngdll;
function jpeg_start_decompress(var cinfo: jpeg_decompress_struct): Longbool; stdcall; external mngdll;
function jpeg_read_scanlines(var cinfo: jpeg_decompress_struct;
	scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; stdcall; external mngdll;
function jpeg_finish_decompress(var cinfo: jpeg_decompress_struct): Longbool; stdcall; external mngdll;
procedure jpeg_destroy_decompress (var cinfo : jpeg_decompress_struct); stdcall; external mngdll;
function jpeg_has_multiple_scans(var cinfo: jpeg_decompress_struct): Longbool; stdcall; external mngdll;
function jpeg_consume_input(var cinfo: jpeg_decompress_struct): Integer; stdcall; external mngdll;
function jpeg_start_output(var cinfo: jpeg_decompress_struct; scan_number: Integer): Longbool; stdcall; external mngdll;
function jpeg_finish_output(var cinfo: jpeg_decompress_struct): LongBool; stdcall; external mngdll;
procedure jpeg_destroy(var cinfo: jpeg_common_struct); stdcall; external mngdll;

procedure jpeg_CreateCompress (var cinfo : jpeg_compress_struct;
  version : integer; structsize : integer); stdcall; external mngdll;
procedure jpeg_stdio_dest(var cinfo: jpeg_compress_struct;
  output_file: TStream); stdcall; external mngdll;
procedure jpeg_set_defaults(var cinfo: jpeg_compress_struct); stdcall; external mngdll;
procedure jpeg_set_quality(var cinfo: jpeg_compress_struct; Quality: Integer;
  Baseline: Longbool); stdcall; external mngdll;
procedure jpeg_set_colorspace(var cinfo: jpeg_compress_struct;
  colorspace: J_COLOR_SPACE); stdcall; external mngdll;
procedure jpeg_simple_progression(var cinfo: jpeg_compress_struct); stdcall; external mngdll;
procedure jpeg_start_compress(var cinfo: jpeg_compress_struct;
  WriteAllTables: LongBool); stdcall; external mngdll;
function jpeg_write_scanlines(var cinfo: jpeg_compress_struct;
  scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; stdcall; external mngdll;
procedure jpeg_finish_compress(var cinfo: jpeg_compress_struct); stdcall; external mngdll;

function jpeg_resync_to_restart (cinfo : j_decompress_ptr; desired : Integer) : LongBool; stdcall; external mngdll;
{$ELSE}

function CheckLIBMNGLoaded: Boolean;
begin
  if (hLibmng = 0) then begin
     hLibmng:= LoadLibrary(mngdll);
     if (hLibmng < HINSTANCE_ERROR) then begin
       hLibmng:= 0;
       Result:= False;
       Exit;
     end;

     (* TODO:  REMOVE
     @_EnumProcesses := GetProcAddress(hPSAPI, 'EnumProcesses'); // do not localize
     @_EnumProcessModules := GetProcAddress(hPSAPI, 'EnumProcessModules'); // do not localize
     {procedure}@_GetModuleBaseNameA := GetProcAddress(hPSAPI, 'GetModuleBaseNameA');*) // do not localize

     {****************************************************************************}
     {Functions without a preceeding marker.  Procedures prefixed with the following: }
     {procedure}
     {****************************************************************************}
     {procedure}@_jpeg_CreateDecompress:= GetProcAddress(hLibmng, 'jpeg_CreateDecompress'); // do not localize
     {procedure}@_jpeg_stdio_src:= GetProcAddress(hLibmng, 'jpeg_stdio_src'); // do not localize
     {procedure}@_jpeg_read_header:= GetProcAddress(hLibmng, 'jpeg_read_header'); // do not localize
     {procedure}@_jpeg_calc_output_dimensions:= GetProcAddress(hLibmng, 'jpeg_calc_output_dimensions'); // do not localize
     @_jpeg_start_decompress:= GetProcAddress(hLibmng, 'jpeg_start_decompress'); // do not localize
     @_jpeg_read_scanlines:= GetProcAddress(hLibmng, 'jpeg_read_scanlines'); // do not localize
     @_jpeg_finish_decompress:= GetProcAddress(hLibmng, 'jpeg_finish_decompress'); // do not localize
     {procedure}@_jpeg_destroy_decompress:= GetProcAddress(hLibmng, 'jpeg_destroy_decompress'); // do not localize
     @_jpeg_has_multiple_scans:= GetProcAddress(hLibmng, 'jpeg_has_multiple_scans'); // do not localize
     @_jpeg_consume_input:= GetProcAddress(hLibmng, 'jpeg_consume_input'); // do not localize
     @_jpeg_start_output:= GetProcAddress(hLibmng, 'jpeg_start_output'); // do not localize
     @_jpeg_finish_output:= GetProcAddress(hLibmng, 'jpeg_finish_output'); // do not localize
     {procedure}@_jpeg_destroy:= GetProcAddress(hLibmng, 'jpeg_destroy'); // do not localize
     {procedure}@_jpeg_CreateCompress:= GetProcAddress(hLibmng, 'jpeg_CreateCompress'); // do not localize
     {procedure}@_jpeg_stdio_dest:= GetProcAddress(hLibmng, 'jpeg_stdio_dest'); // do not localize
     {procedure}@_jpeg_set_defaults:= GetProcAddress(hLibmng, 'jpeg_set_defaults'); // do not localize
     {procedure}@_jpeg_set_quality:= GetProcAddress(hLibmng, 'jpeg_set_quality'); // do not localize
     {procedure}@_jpeg_set_colorspace:= GetProcAddress(hLibmng, 'jpeg_set_colorspace'); // do not localize
     {procedure}@_jpeg_simple_progression:= GetProcAddress(hLibmng, 'jpeg_simple_progression'); // do not localize
     {procedure}@_jpeg_start_compress:= GetProcAddress(hLibmng, 'jpeg_start_compress'); // do not localize
     {procedure}@_jpeg_write_scanlines:= GetProcAddress(hLibmng, 'jpeg_write_scanlines'); // do not localize
     {procedure}@_jpeg_finish_compress:= GetProcAddress(hLibmng, 'jpeg_finish_compress'); // do not localize
     @_jpeg_resync_to_restart:= GetProcAddress(hLibmng, 'jpeg_resync_to_restart'); // do not localize
  end;
  Result:= True;
end;

procedure jpeg_CreateDecompress (var cinfo : jpeg_decompress_struct;
  version : integer; structsize : integer); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_CreateDecompress(cinfo, version, structsize);
end;

procedure jpeg_stdio_src(var cinfo: jpeg_decompress_struct;
  input_file: TStream); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_stdio_src(cinfo, input_file);
end;

procedure jpeg_read_header(var cinfo: jpeg_decompress_struct;
  RequireImage: LongBool); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_read_header(cinfo, RequireImage);
end;

procedure jpeg_calc_output_dimensions(var cinfo: jpeg_decompress_struct); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_calc_output_dimensions(cinfo);
end;

function jpeg_start_decompress(var cinfo: jpeg_decompress_struct): Longbool; stdcall;
begin
  if CheckLIBMNGLoaded then
     Result:= _jpeg_start_decompress(cinfo)
  else Result:= MNG_FALSE;
end;

function jpeg_read_scanlines(var cinfo: jpeg_decompress_struct;
  scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; stdcall;
begin
  if CheckLIBMNGLoaded then
     Result:= _jpeg_read_scanlines(cinfo, scanlines, max_lines)
  else Result:= 0;
end;

function jpeg_finish_decompress(var cinfo: jpeg_decompress_struct): Longbool; stdcall;
begin
  if CheckLIBMNGLoaded then
     Result:= _jpeg_finish_decompress(cinfo)
  else Result:= MNG_FALSE;
end;

procedure jpeg_destroy_decompress (var cinfo : jpeg_decompress_struct); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_destroy_decompress(cinfo);
end;

function jpeg_has_multiple_scans(var cinfo: jpeg_decompress_struct): Longbool; stdcall;
begin
  if CheckLIBMNGLoaded then
     Result:= _jpeg_has_multiple_scans(cinfo)
  else Result:= MNG_FALSE;
end;

function jpeg_consume_input(var cinfo: jpeg_decompress_struct): Integer; stdcall;
begin
  if CheckLIBMNGLoaded then
     Result:= _jpeg_consume_input(cinfo)
  else Result:= -1;
end;

function jpeg_start_output(var cinfo: jpeg_decompress_struct; scan_number: Integer): Longbool; stdcall;
begin
  if CheckLIBMNGLoaded then
     Result:= _jpeg_start_output(cinfo, scan_number)
  else Result:= MNG_FALSE;
end;

function jpeg_finish_output(var cinfo: jpeg_decompress_struct): LongBool; stdcall;
begin
  if CheckLIBMNGLoaded then
     Result:= _jpeg_finish_decompress(cinfo)
  else Result:= MNG_FALSE;
end;

procedure jpeg_destroy(var cinfo: jpeg_common_struct); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_destroy(cinfo);
end;

procedure jpeg_CreateCompress (var cinfo : jpeg_compress_struct;
  version : integer; structsize : integer); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_CreateCompress(cinfo, version, structsize);
end;

procedure jpeg_stdio_dest(var cinfo: jpeg_compress_struct;
  output_file: TStream); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_stdio_dest(cinfo, output_file);
end;

procedure jpeg_set_defaults(var cinfo: jpeg_compress_struct); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_set_defaults(cinfo);
end;

procedure jpeg_set_quality(var cinfo: jpeg_compress_struct; Quality: Integer;
  Baseline: Longbool); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_set_quality(cinfo, Quality, Baseline);
end;

procedure jpeg_set_colorspace(var cinfo: jpeg_compress_struct;
  colorspace: J_COLOR_SPACE); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_set_colorspace(cinfo, colorspace);
end;

procedure jpeg_simple_progression(var cinfo: jpeg_compress_struct); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_simple_progression(cinfo);
end;

procedure jpeg_start_compress(var cinfo: jpeg_compress_struct;
  WriteAllTables: LongBool); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_start_compress(cinfo, WriteAllTables);
end;

function jpeg_write_scanlines(var cinfo: jpeg_compress_struct;
  scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; stdcall;
begin
  if CheckLIBMNGLoaded then
     Result:= _jpeg_write_scanlines(cinfo, scanlines, max_lines)
  else Result:= 0;
end;

procedure jpeg_finish_compress(var cinfo: jpeg_compress_struct); stdcall;
begin
  if CheckLIBMNGLoaded then
     _jpeg_finish_compress(cinfo);
end;

function jpeg_resync_to_restart (cinfo : j_decompress_ptr; desired : Integer) : LongBool; stdcall;
begin
  if CheckLIBMNGLoaded then
     Result:= _jpeg_resync_to_restart(cinfo, desired)
  else Result:= MNG_FALSE;
end;

{$ENDIF}

{****************************************************************************}

procedure SwapRedBlueScanline (Line : pointer; Width : Integer);
type
  pbytes3 = ^tbytes3;
  tbytes3 = array [0..2] of byte;
var
  ix : integer;
  bLine : pbytes3;
  bTemp : byte;
begin
  bLine := pbytes3(Line);
  for ix := 0 to pred(Width) do
  begin
    bTemp := bLine[0];
    bLine[0] := bLine[2];
    bLine[2] := bTemp;
    inc (bLine);
  end;
end;

{****************************************************************************}

procedure SwapRedBlue(Bitmap: TBitmap);
var
  ix, iHeight: Integer;
begin
  iHeight:= Bitmap.Height;
  for ix := 0 to pred(iHeight) do
    SwapRedBlueScanline(Bitmap.Scanline[ix], Bitmap.Width);
end;

{****************************************************************************}

type
  EJPEG = class(EInvalidGraphic);

{****************************************************************************}

procedure InvalidOperation(const Msg: string); near;
begin
  raise EInvalidGraphicOperation.Create(Msg);
end;

{****************************************************************************}

procedure JpegError(cinfo: j_common_ptr); stdcall;
begin
  raise EJPEG.CreateFmt(sJPEGError,[cinfo^.err^.msg_code]);
end;

{****************************************************************************}

procedure EmitMessage(cinfo: j_common_ptr; msg_level: Integer); stdcall;
begin
  //!!
end;

{****************************************************************************}

procedure OutputMessage(cinfo: j_common_ptr); stdcall;
begin
  //!!
end;

{****************************************************************************}

procedure FormatMessage(cinfo: j_common_ptr; buffer: PChar); stdcall;
begin
  //!!
end;

{****************************************************************************}

procedure ResetErrorMgr(cinfo: j_common_ptr); stdcall;
begin
  cinfo^.err^.num_warnings := 0;
  cinfo^.err^.msg_code := 0;
end;

{****************************************************************************}

procedure SrcInit(cinfo: j_decompress_ptr); stdcall;
var
  Data : TJPEGData;
begin
  Data := TJPEGData(cinfo^.common.client_data);

  cinfo^.src^.next_input_byte := Data.FData.Memory;
  cinfo^.src^.bytes_in_buffer := Data.FData.Size;
end;

{****************************************************************************}

function SrcFill(cinfo: j_decompress_ptr) : Longbool; stdcall;
begin
  Result := TRUE;
end;

{****************************************************************************}

procedure SrcSkip(cinfo: j_decompress_ptr; num_bytes: Longint); stdcall;
begin
  if num_bytes > 0 then
  begin
    if cinfo^.src^.bytes_in_buffer > num_bytes then
    begin
      dec(cinfo^.src^.bytes_in_buffer, num_bytes);
      inc(cinfo^.src^.next_input_byte, num_bytes);
    end;
  end;
end;

{****************************************************************************}

procedure SrcTerm(cinfo: j_decompress_ptr); stdcall;
begin
  { dummy routine to satisfy IJG-code }
end;

{****************************************************************************}

procedure DstInit(cinfo: j_compress_ptr); stdcall;
var
  Data : TJPEGData;
begin
  Data := TJPEGData(cinfo^.common.client_data);
  Data.FSize := 4000;

  GetMem(Data.FBuffer, Data.FSize);

  cinfo^.dest^.next_output_byte := Data.FBuffer;
  cinfo^.dest^.free_in_buffer := Data.FSize;
end;

{****************************************************************************}

function DstEmpty(cinfo: j_compress_ptr) : Longbool; stdcall;
var
  Data : TJPEGData;
begin
  Data := TJPEGData(cinfo^.common.client_data);

  Data.FData.Write(Data.FBuffer^, Data.FSize);

  cinfo^.dest^.next_output_byte := Data.FBuffer;
  cinfo^.dest^.free_in_buffer := Data.FSize;

  Result := TRUE;
end;

{****************************************************************************}

procedure DstTerm(cinfo: j_compress_ptr); stdcall;
var
  Data : TJPEGData;
begin
  Data := TJPEGData(cinfo^.common.client_data);

  if cinfo^.dest^.free_in_buffer < Data.FSize then
    Data.FData.Write(Data.FBuffer^, Data.FSize-cinfo^.dest^.free_in_buffer);

  cinfo^.dest^.next_output_byte := nil;
  cinfo^.dest^.free_in_buffer := 0;

  if Data.FSize > 0 then
    FreeMem(Data.FBuffer, Data.FSize);

  Data.FBuffer := nil;
  Data.FSize := 0;
end;

{****************************************************************************}
{ TJPEGData                                                                  }
{****************************************************************************}

constructor TJPEGData.Create;
begin
  inherited Create;
  FBuffer := nil;
  FSize := 0;
  BeginUseLibmng;
end;

{****************************************************************************}

destructor TJPEGData.Destroy;
begin
  FData.Free;
  EndUseLibmng;
  inherited Destroy;
end;

{****************************************************************************}

procedure TJPEGData.FreeHandle;
begin
end;

{****************************************************************************}
{ TJPEGImage                                                                 }
{****************************************************************************}

constructor TJPEGImage.Create;
begin
  inherited Create;

  NewImage;
  FQuality := JPEGDefaults.CompressionQuality;
  FGrayscale := JPEGDefaults.Grayscale;
  FPerformance := JPEGDefaults.Performance;
  FPixelFormat := JPEGDefaults.PixelFormat;
  FProgressiveDisplay := JPEGDefaults.ProgressiveDisplay;
  FProgressiveEncoding := JPEGDefaults.ProgressiveEncoding;
  FScale := JPEGDefaults.Scale;
  FSmoothing := JPEGDefaults.Smoothing;
end;

{****************************************************************************}

destructor TJPEGImage.Destroy;
begin
  if (FTempPal <> 0) then
     DeleteObject(FTempPal);
     
  FBitmap.Free;
  FImage.Release;

  inherited Destroy;
end;

{****************************************************************************}

procedure TJPEGImage.Assign(Source: TPersistent);
begin
  if (Source is TJPEGImage) then
  begin
    FImage.Release;
    FImage := TJPEGImage(Source).FImage;
    FImage.Reference;
    if (TJPEGImage(Source).FBitmap <> nil) then
    begin
      NewBitmap;
      FBitmap.Assign(TJPEGImage(Source).FBitmap);
    end;
  end
  else if (Source is TBitmap) then
  begin
    NewImage;
    NewBitmap;
    FBitmap.Assign(Source);
  end
  else
    inherited Assign(Source);
end;

{****************************************************************************}

procedure TJPEGImage.AssignTo(Dest: TPersistent);
begin
  if (Dest is TBitmap) then
    Dest.Assign(Bitmap)
  else
    inherited AssignTo(Dest);
end;

{****************************************************************************}

const
  jpeg_std_error: jpeg_error_mgr = (
    error_exit: JpegError;
    emit_message: EmitMessage;
    output_message: OutputMessage;
    format_message: FormatMessage;
    reset_error_mgr: ResetErrorMgr);

  jpeg_std_src: jpeg_source_mgr = (
    next_input_byte: nil;
    bytes_in_buffer: 0;
    init_source: SrcInit;
    fill_input_buffer: SrcFill;
    skip_input_data: SrcSkip;
    resync_to_restart: nil;
    term_source: SrcTerm);

  jpeg_std_dest: jpeg_destination_mgr = (
    next_output_byte: nil;
    free_in_buffer: 0;
    init_destination: DstInit;
    empty_output_buffer: DstEmpty;
    term_destination: DstTerm);

{****************************************************************************}

procedure ProgressCallback(const cinfo: jpeg_common_struct); stdcall;
var
  Ticks: Integer;
  R: TRect;
  temp: Integer;
begin
  if (cinfo.progress = nil) or (cinfo.progress^.instance = nil) then Exit;
  with cinfo.progress^ do
  begin
    Ticks := GetTickCount;
    if ((Ticks - last_time) < 500) then Exit;
    temp := last_time;
    last_time := Ticks;
    if temp = 0 then Exit;
    if cinfo.is_decompressor then
      with j_decompress_ptr(@cinfo)^ do
      begin
        R := Rect(0, last_scanline, output_width, output_scanline);
        if R.Bottom < last_scanline then
          R.Bottom := output_height;
      end
    else
      R := Rect(0,0,0,0);
    temp := Trunc(100.0*(completed_passes + (pass_counter/pass_limit))/total_passes);
    if temp = last_pct then Exit;
    last_pct := temp;
    if cinfo.is_decompressor then
      last_scanline := j_decompress_ptr(@cinfo)^.output_scanline;
    instance.Progress(instance, psRunning, temp, (R.Bottom - R.Top) >= 4, R, ''); // do not localize
  end;
end;

{****************************************************************************}

procedure InitContext(var jc: TJPEGContext); stdcall;
begin
  FillChar (jc, sizeof (jc), 0);
  jc.err        := jpeg_std_error;
  jc.common.err := @jc.err;
end;

{****************************************************************************}

procedure ReleaseContext(var jc: TJPEGContext); stdcall;
begin
  if jc.common.err = nil then
    exit;

  jpeg_destroy (jc.common);
  jc.common.err := nil;
end;

{****************************************************************************}

procedure InitDecompressor(Obj: TJPEGImage; var jc: TJPEGContext); stdcall;
begin
  FillChar(jc, sizeof(jc), 0);
  jc.err := jpeg_std_error;
  jc.common.err := @jc.err;

  jpeg_CreateDecompress(jc.d, JPEG_LIB_VERSION, sizeof(jpeg_decompress_struct));
  with Obj do
  try
    jc.progress.progress_monitor := @ProgressCallback;
    jc.progress.instance := Obj;
    jc.common.progress := @jc.progress;

    Obj.FImage.FData.Position := 0;
//    jpeg_stdio_src(jc.d, FImage.FData);
    jc.d.common.client_data := FImage;
    jc.d.src := @jpeg_std_src;
    jc.d.src.resync_to_restart := jpeg_resync_to_restart;
    jpeg_read_header(jc.d, TRUE);

    jc.d.scale_num := 1;
    jc.d.scale_denom := 1 shl Byte(FScale);
    jc.d.do_block_smoothing := FSmoothing;

    if FGrayscale then jc.d.out_color_space := JCS_GRAYSCALE;
    if (PixelFormat = jf8Bit) or (jc.d.out_color_space = JCS_GRAYSCALE) then
    begin
      jc.d.quantize_colors := True;
      jc.d.desired_number_of_colors := 236;
    end;

    if FPerformance = jpBestSpeed then
    begin
      jc.d.dct_method := JDCT_IFAST;
      jc.d.two_pass_quantize := False;
//      jc.d.do_fancy_upsampling := False;    !! AV inside jpeglib
      jc.d.dither_mode := JDITHER_ORDERED;
    end;

    jc.FinalDCT := jc.d.dct_method;
    jc.FinalTwoPassQuant := jc.d.two_pass_quantize;
    jc.FinalDitherMode := jc.d.dither_mode;
    if FProgressiveDisplay and jpeg_has_multiple_scans(jc.d) then
    begin  // save requested settings, reset for fastest on all but last scan
      jc.d.enable_2pass_quant := jc.d.two_pass_quantize;
      jc.d.dct_method := JDCT_IFAST;
      jc.d.two_pass_quantize := False;
      jc.d.dither_mode := JDITHER_ORDERED;
      jc.d.buffered_image := True;
    end;
  except
    ReleaseContext(jc);
    raise;
  end;
end;

{****************************************************************************}

procedure TJPEGImage.CalcOutputDimensions;
var
  jc: TJPEGContext;
begin
  if not FNeedRecalc then Exit;
  InitDecompressor(Self, jc);
  try
    jc.common.progress := nil;
    jpeg_calc_output_dimensions(jc.d);
    // read output dimensions
    FScaledWidth := jc.d.output_width;
    FScaledHeight := jc.d.output_height;
    FProgressiveEncoding := jpeg_has_multiple_scans(jc.d);
  finally
    ReleaseContext(jc);
  end;
end;

{****************************************************************************}

procedure TJPEGImage.Changed(Sender: TObject);
begin
  inherited Changed(Sender);
end;

{****************************************************************************}

procedure TJPEGImage.Compress;
var
  LinesWritten, LinesPerCall: Integer;
  SrcScanLine: Pointer;
  PtrInc: Integer;
  jc: TJPEGContext;
  Src: TBitmap;
begin
  FillChar(jc, sizeof(jc), 0);
  jc.err := jpeg_std_error;
  jc.common.err := @jc.err;

  jpeg_CreateCompress(jc.c, JPEG_LIB_VERSION, sizeof(jpeg_compress_struct));
  try
    try
      jc.progress.progress_monitor := @ProgressCallback;
      jc.progress.instance := Self;
      jc.common.progress := @jc.progress;

      if FImage.FData <> nil then NewImage;
      FImage.FData := TMemoryStream.Create;
      FImage.FData.Position := 0;
//      jpeg_stdio_dest(jc.c, FImage.FData);
      jc.c.common.client_data := FImage;
      jc.c.dest := @jpeg_std_dest;

      if (FBitmap = nil) or (FBitmap.Width = 0) or (FBitmap.Height = 0) then Exit;
      jc.c.image_width := FBitmap.Width;
      FImage.FWidth := FBitmap.Width;
      jc.c.image_height := FBitmap.Height;
      FImage.FHeight := FBitmap.Height;
      jc.c.input_components := 3;           // JPEG requires 24bit RGB input
      jc.c.in_color_space := JCS_RGB;

      Src := TBitmap.Create;
      try
        Src.Assign(FBitmap);
        Src.PixelFormat := pf24bit;
        SwapRedBlue(Src);

        jpeg_set_defaults(jc.c);
        jpeg_set_quality(jc.c, FQuality, True);

        if FGrayscale then
        begin
          FImage.FGrayscale := True;
          jpeg_set_colorspace(jc.c, JCS_GRAYSCALE);
        end;

        if ProgressiveEncoding then
          jpeg_simple_progression(jc.c);

        SrcScanline := Src.ScanLine[0];
        PtrInc := Integer(Src.ScanLine[1]) - Integer(SrcScanline);

          // if no dword padding required and source bitmap is top-down
        if (PtrInc > 0) and ((PtrInc and 3) = 0) then
          LinesPerCall := jc.c.image_height  // do whole bitmap in one call
        else
          LinesPerCall := 1;      // otherwise spoonfeed one row at a time

        Progress(Self, psStarting, 0, False, Rect(0,0,0,0), ''); // do not localize
        try
          jpeg_start_compress(jc.c, True);

          while (jc.c.next_scanline < jc.c.image_height) do
          begin
            LinesWritten := jpeg_write_scanlines(jc.c, @SrcScanline, LinesPerCall);
            Inc(Integer(SrcScanline), PtrInc * LinesWritten);
          end;

          jpeg_finish_compress(jc.c);
        finally
          if ExceptObject = nil then
            PtrInc := 100
          else
            PtrInc := 0;
          Progress(Self, psEnding, PtrInc, False, Rect(0,0,0,0), ''); // do not localize
        end;
      finally
        Src.Free;
      end;
    except
      on EAbort do    // OnProgress can raise EAbort to cancel image save
        NewImage;     // Throw away any partial jpg data
    end;
  finally
    ReleaseContext(jc);
  end;
end;

{****************************************************************************}

procedure TJPEGImage.DIBNeeded;
begin
  GetBitmap;
end;

{****************************************************************************}

procedure TJPEGImage.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
  ACanvas.StretchDraw(Rect, Bitmap);
end;

{****************************************************************************}

function TJPEGImage.Equals(Graphic: TGraphic): Boolean;
begin
  Result := ((Graphic is TJPEGImage) and
    (FImage = TJPEGImage(Graphic).FImage)); //!!
end;

{****************************************************************************}

procedure TJPEGImage.FreeBitmap;
begin
  FBitmap.Free;
  FBitmap := nil;
end;

{****************************************************************************}

function BuildPalette(const cinfo: jpeg_decompress_struct): HPalette; stdcall;
var
  Pal: TMaxLogPalette;
  I: Integer;
  C: Byte;
begin
  Pal.palVersion := $300;
  Pal.palNumEntries := cinfo.actual_number_of_colors;
  if cinfo.out_color_space = JCS_GRAYSCALE then
    for I := 0 to Pal.palNumEntries-1 do
    begin
      C := cinfo.colormap^[0]^[I];
      Pal.palPalEntry[I].peRed := C;
      Pal.palPalEntry[I].peGreen := C;
      Pal.palPalEntry[I].peBlue := C;
      Pal.palPalEntry[I].peFlags := 0;
    end
  else
    for I := 0 to Pal.palNumEntries-1 do
    begin
      Pal.palPalEntry[I].peRed := cinfo.colormap^[2]^[I];
      Pal.palPalEntry[I].peGreen := cinfo.colormap^[1]^[I];
      Pal.palPalEntry[I].peBlue := cinfo.colormap^[0]^[I];
      Pal.palPalEntry[I].peFlags := 0;
    end;
  Result := CreatePalette(PLogPalette(@Pal)^);
end;

{****************************************************************************}

procedure BuildColorMap(var cinfo: jpeg_decompress_struct; P: HPalette); stdcall;
var
  Pal: TMaxLogPalette;
  Count, I: Integer;
begin
  Count := GetPaletteEntries(P, 0, 256, Pal.palPalEntry);
  if Count = 0 then Exit;       // jpeg_destroy will free colormap
  cinfo.colormap := cinfo.common.mem.alloc_sarray(@cinfo.common, JPOOL_IMAGE, Count, 3);
  cinfo.actual_number_of_colors := Count;
  for I := 0 to Count-1 do
  begin
    Byte(cinfo.colormap^[2]^[I]) := Pal.palPalEntry[I].peRed;
    Byte(cinfo.colormap^[1]^[I]) := Pal.palPalEntry[I].peGreen;
    Byte(cinfo.colormap^[0]^[I]) := Pal.palPalEntry[I].peBlue;
  end;
end;

{****************************************************************************}

function TJPEGImage.GetBitmap: TBitmap;
var
  LinesPerCall, LinesRead: Integer;
  DestScanLine: Pointer;
  PtrInc: Integer;
  jc: TJPEGContext;
  GeneratePalette: Boolean;
begin
  Result := FBitmap;
  if Result <> nil then Exit;
  if (FBitmap = nil) then FBitmap := TBitmap.Create;
  Result := FBitmap;
  GeneratePalette := True;

  InitDecompressor(Self, jc);
  try
    try
      // Set the bitmap pixel format
      FBitmap.Handle := 0;
      if (PixelFormat = jf8Bit) or (jc.d.out_color_space = JCS_GRAYSCALE) then
        FBitmap.PixelFormat := pf8bit
      else
        FBitmap.PixelFormat := pf24bit;

      Progress(Self, psStarting, 0, False, Rect(0,0,0,0), ''); // do not localize
      try
        if (FTempPal <> 0) then
        begin
          if (FPixelFormat = jf8Bit) then
          begin                        // Generate DIB using assigned palette
            BuildColorMap(jc.d, FTempPal);
            FBitmap.Palette := CopyPalette(FTempPal);  // Keep FTempPal around
            GeneratePalette := False;
          end
          else
          begin
            DeleteObject(FTempPal);
            FTempPal := 0;
          end;
        end;

        jpeg_start_decompress(jc.d);

        // Set bitmap width and height
        with FBitmap do
        begin
          Handle := 0;
          Width := jc.d.output_width;
          Height := jc.d.output_height;
          DestScanline := ScanLine[0];
          PtrInc := Integer(ScanLine[1]) - Integer(DestScanline);
          if (PtrInc > 0) and ((PtrInc and 3) = 0) then
             // if no dword padding is required and output bitmap is top-down
            LinesPerCall := jc.d.rec_outbuf_height // read multiple rows per call
          else
            LinesPerCall := 1;            // otherwise read one row at a time
        end;

        if jc.d.buffered_image then
        begin  // decode progressive scans at low quality, high speed
          while jpeg_consume_input(jc.d) <> JPEG_REACHED_EOI do
          begin
            jpeg_start_output(jc.d, jc.d.input_scan_number);
            // extract color palette
            if (jc.common.progress^.completed_passes = 0) and (jc.d.colormap <> nil)
              and (FBitmap.PixelFormat = pf8bit) and GeneratePalette then
            begin
              FBitmap.Palette := BuildPalette(jc.d);
              PaletteModified := True;
            end;
            DestScanLine := FBitmap.ScanLine[0];
            while (jc.d.output_scanline < jc.d.output_height) do
            begin
              LinesRead := jpeg_read_scanlines(jc.d, @DestScanline, LinesPerCall);
              Inc(Integer(DestScanline), PtrInc * LinesRead);
            end;
            jpeg_finish_output(jc.d);
          end;
          // reset options for final pass at requested quality
          jc.d.dct_method := jc.FinalDCT;
          jc.d.dither_mode := jc.FinalDitherMode;
          if jc.FinalTwoPassQuant then
          begin
            jc.d.two_pass_quantize := True;
            jc.d.colormap := nil;
          end;
          jpeg_start_output(jc.d, jc.d.input_scan_number);
          DestScanLine := FBitmap.ScanLine[0];
        end;

        // build final color palette
        if (not jc.d.buffered_image or jc.FinalTwoPassQuant) and
          (jc.d.colormap <> nil) and GeneratePalette then
        begin
          FBitmap.Palette := BuildPalette(jc.d);
          PaletteModified := True;
          DestScanLine := FBitmap.ScanLine[0];
        end;
        // final image pass for progressive, first and only pass for baseline
        while (jc.d.output_scanline < jc.d.output_height) do
        begin
          LinesRead := jpeg_read_scanlines(jc.d, @DestScanline, LinesPerCall);
          Inc(Integer(DestScanline), PtrInc * LinesRead);
        end;

        if jc.d.buffered_image then jpeg_finish_output(jc.d);
        jpeg_finish_decompress(jc.d);

         if FBitmap.PixelFormat = pf24bit then
           SwapRedBlue(FBitmap);

      finally
        if ExceptObject = nil then
          PtrInc := 100
        else
          PtrInc := 0;
        Progress(Self, psEnding, PtrInc, PaletteModified, Rect(0,0,0,0), ''); // do not localize
        // Make sure new palette gets realized, in case OnProgress event didn't.
        if PaletteModified then
          Changed(Self);
      end;
    except
      on EAbort do ;   // OnProgress can raise EAbort to cancel image load
    end;
  finally
    ReleaseContext(jc);
  end;
end;

{****************************************************************************}

function TJPEGImage.GetEmpty: Boolean;
begin
  Result := (FImage.FData = nil) and FBitmap.Empty;
end;

{****************************************************************************}

function TJPEGImage.GetGrayscale: Boolean;
begin
  Result := FGrayscale or FImage.FGrayscale;
end;

{****************************************************************************}

function TJPEGImage.GetPalette: HPalette;
var
  DC: HDC;
begin
  Result := 0;
  if FBitmap <> nil then
    Result := FBitmap.Palette
  else if FTempPal <> 0 then
    Result := FTempPal
  else if FPixelFormat = jf24Bit then   // check for 8 bit screen
  begin
    DC := GetDC(0);
    if (GetDeviceCaps(DC, BITSPIXEL) * GetDeviceCaps(DC, PLANES)) <= 8 then
    begin
      FTempPal := CreateHalftonePalette(DC);
      Result := FTempPal;
    end;
    ReleaseDC(0, DC);
  end;
end;

{****************************************************************************}

function TJPEGImage.GetHeight: Integer;
begin
  if (FBitmap <> nil) then
    Result := FBitmap.Height
  else if (FScale = jsFullSize) then
    Result := FImage.FHeight
  else
  begin
    CalcOutputDimensions;
    Result := FScaledHeight;
  end;
end;

{****************************************************************************}

function TJPEGImage.GetWidth: Integer;
begin
  if (FBitmap <> nil) then
    Result := FBitmap.Width
  else if (FScale = jsFullSize) then
    Result := FImage.FWidth
  else
  begin
    CalcOutputDimensions;
    Result := FScaledWidth;
  end;
end;

{****************************************************************************}

procedure TJPEGImage.JPEGNeeded;
begin
  if (FImage.FData = nil) then
    Compress;
end;

{****************************************************************************}

procedure TJPEGImage.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPALETTE);
begin
  //!! check for jpeg clipboard data, mime type image/jpeg
  FBitmap.LoadFromClipboardFormat(AFormat, AData, APalette);
end;

{****************************************************************************}

procedure TJPEGImage.LoadFromStream(Stream: TStream);
begin
  ReadStream(Stream.Size - Stream.Position, Stream);
end;

{****************************************************************************}

procedure TJPEGImage.NewBitmap;
begin
  FBitmap.Free;
  FBitmap := TBitmap.Create;
end;

{****************************************************************************}

procedure TJPEGImage.NewImage;
begin
  if (FImage <> nil) then
     FImage.Release;

  FImage := TJPEGData.Create;
  FImage.Reference;
end;

{****************************************************************************}

procedure TJPEGImage.ReadData(Stream: TStream);
var
  Size: Longint;
begin
  Stream.Read(Size, SizeOf(Size));
  ReadStream(Size, Stream);
end;

{****************************************************************************}

procedure TJPEGImage.ReadStream(Size: Longint; Stream: TStream);
var
  jerr: jpeg_error_mgr;
  cinfo: jpeg_decompress_struct;
begin
  NewImage;
  with FImage do
  begin
    FData := TMemoryStream.Create;
    FData.Size := Size;
    Stream.ReadBuffer(FData.Memory^, Size);
    if (Size > 0) then
    begin
      jerr := jpeg_std_error;  // use local var for thread isolation
      cinfo.common.err := @jerr;
      jpeg_CreateDecompress(cinfo, JPEG_LIB_VERSION, sizeof(cinfo));
      try
        FData.Position := 0;
//        jpeg_stdio_src(cinfo, FData);
        cinfo.common.client_data := FImage;
        cinfo.src := @jpeg_std_src;
        cinfo.src.resync_to_restart := jpeg_resync_to_restart;
        jpeg_read_header(cinfo, TRUE);
        FWidth := cinfo.image_width;
        FHeight := cinfo.image_height;
        FGrayscale := cinfo.jpeg_color_space = JCS_GRAYSCALE;
        FProgressiveEncoding := jpeg_has_multiple_scans(cinfo);
      finally
        jpeg_destroy_decompress(cinfo);
      end;
    end;
  end;
  PaletteModified := True;
  Changed(Self);
end;

{****************************************************************************}

procedure TJPEGImage.SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
  var APalette: HPALETTE);
begin
//!!  check for jpeg clipboard format, mime type image/jpeg
  Bitmap.SaveToClipboardFormat(AFormat, AData, APalette);
end;

{****************************************************************************}

procedure TJPEGImage.SaveToStream(Stream: TStream);
begin
  JPEGNeeded;
  Stream.Write(FImage.FData.Memory^, FImage.FData.Size);
end;

{****************************************************************************}

procedure TJPEGImage.SetGrayscale(Value: Boolean);
begin
  if (FGrayscale <> Value) then
  begin
    FreeBitmap;
    FGrayscale := Value;
    PaletteModified := True;
    Changed(Self);
  end;
end;

{****************************************************************************}

procedure TJPEGImage.SetHeight(Value: Integer);
begin
  InvalidOperation(SChangeJPGSize);
end;

{****************************************************************************}

procedure TJPEGImage.SetPalette(Value: HPalette);
var
  SignalChange: Boolean;
begin
  if (Value <> FTempPal) then
  begin
    SignalChange := (FBitmap <> nil) and (Value <> FBitmap.Palette);
    if SignalChange then FreeBitmap;
    FTempPal := Value;
    if SignalChange then
    begin
      PaletteModified := True;
      Changed(Self);
    end;
  end;
end;

{****************************************************************************}

procedure TJPEGImage.SetPerformance(Value: TJPEGPerformance);
begin
  if (FPerformance <> Value) then
  begin
    FreeBitmap;
    FPerformance := Value;
    PaletteModified := True;
    Changed(Self);
  end;
end;

{****************************************************************************}

procedure TJPEGImage.SetPixelFormat(Value: TJPEGPixelFormat);
begin
  if (FPixelFormat <> Value) then
  begin
    FreeBitmap;
    FPixelFormat := Value;
    PaletteModified := True;
    Changed(Self);
  end;
end;

{****************************************************************************}

procedure TJPEGImage.SetScale(Value: TJPEGScale);
begin
  if (FScale <> Value) then
  begin
    FreeBitmap;
    FScale := Value;
    FNeedRecalc := True;
    Changed(Self);
  end;
end;

{****************************************************************************}

procedure TJPEGImage.SetSmoothing(Value: Boolean);
begin
  if (FSmoothing <> Value) then
  begin
    FreeBitmap;
    FSmoothing := Value;
    Changed(Self);
  end;
end;

{****************************************************************************}

procedure TJPEGImage.SetWidth(Value: Integer);
begin
  InvalidOperation(SChangeJPGSize);
end;

{****************************************************************************}

procedure TJPEGImage.WriteData(Stream: TStream);
var
  Size: Longint;
begin
  Size := 0;
  if Assigned(FImage.FData) then
     Size := FImage.FData.Size;

  Stream.Write(Size, Sizeof(Size));
  if (Size > 0) then
     Stream.Write(FImage.FData.Memory^, Size);
end;

{****************************************************************************}

procedure InitDefaults;
var
  DC: HDC;
begin
  DC := GetDC(0);
  if ((GetDeviceCaps(DC, BITSPIXEL) * GetDeviceCaps(DC, PLANES)) <= 8) then
    JPEGDefaults.PixelFormat := jf8Bit
  else
    JPEGDefaults.PixelFormat := jf24Bit;
  ReleaseDC(0, DC);
end;

{****************************************************************************}

{$IFDEF LATE_BINDING}
Initialization
  hLibmng:= 0;
  @_jpeg_CreateDecompress       := nil;
  @_jpeg_stdio_src              := nil;
  @_jpeg_read_header            := nil;
  @_jpeg_calc_output_dimensions := nil;
  @_jpeg_start_decompress       := nil;
  @_jpeg_read_scanlines         := nil;
  @_jpeg_finish_decompress      := nil;
  @_jpeg_destroy_decompress     := nil;
  @_jpeg_has_multiple_scans     := nil;
  @_jpeg_consume_input          := nil;
  @_jpeg_start_output           := nil;
  @_jpeg_finish_output          := nil;
  @_jpeg_destroy                := nil;
  @_jpeg_CreateCompress         := nil;
  @_jpeg_stdio_dest             := nil;
  @_jpeg_set_defaults           := nil;
  @_jpeg_set_quality            := nil;
  @_jpeg_set_colorspace         := nil;
  @_jpeg_simple_progression     := nil;
  @_jpeg_start_compress         := nil;
  @_jpeg_write_scanlines        := nil;
  @_jpeg_finish_compress        := nil;
  @_jpeg_resync_to_restart      := nil;
{$ENDIF}

{****************************************************************************}

end.
