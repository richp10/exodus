unit NGBitmap;

{****************************************************************************}
{*                                                                          *}
{*  for copyright and version information see header in NGImages.pas        *}
{*                                                                          *}
{****************************************************************************}
{*                                                                          *}
{*  Changelog:                            * reverse chronological order *   *}
{*                                                                          *}
{*  * 1.0.1  *                                                              *}
{*  2001/10/23 - GJU - Adapted to work with Kylix                           *}
{*                                                                          *}
{****************************************************************************}
{*                                                                          *}
{*  This unit is copied for 99.9% from QGraphics with only 1 objective:     *}
{*  - to obtain public access to the FImage property of a TBitmap           *}
{*                                                                          *}
{****************************************************************************}


{$INCLUDE NGDefs.inc}

interface

uses Types, Classes, SysUtils, Qt, QTypes, QGraphics, QControls;

type
  TNGBMP = class;

  TNGCanvas = class(TCanvas)
  end;

  TNGBitmapCanvas = class(TNGCanvas)
  private
    FBitmap: TNGBMP;
  protected
    procedure BeginPainting; override;
    procedure CreateHandle; override;
  public
    constructor Create(Bitmap: TNGBMP);
  end;

  TNGBMP = class(TGraphic)
  private
    FImage: QImageH;
    FPixmap: QPixmapH;
    FCanvas: TNGCanvas;
    FStream: TStream;
    FHeight: Integer;
    FWidth: Integer;
    FPixelFormat: TPixelFormat;
    FFormat: string;
    FTransparentColor: TColor;
    FTransparentMode: TTransparentMode;
    procedure Changing(Sender: TObject);
    function GetCanvas: TNGCanvas;
    function GetImage: QImageH;
    function GetHandle: QPixmapH;
    function GetMonochrome: Boolean;
    procedure ResizeImage(NewWidth, NewHeight: Integer);
    procedure SetMonochrome(const Value: Boolean);
    procedure SetHandle(const Value: QPixmapH);
    function GetTransparentColor: TColor;
    procedure SetTransparentColor(const Value: TColor);
    procedure SetTransparentMode(const Value: TTransparentMode);
    function TransparentColorStored: Boolean;
    function GetScanLine(Row: Integer): Pointer;
    function GetPixelFormat: TPixelFormat;
    procedure SetPixelFormat(const Value: TPixelFormat);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetTransparent: Boolean; override;
    function GetWidth: Integer; override;
    procedure ImageNeeded;
    procedure HandleNeeded;
    procedure ReadData(Stream: TStream); override;
    procedure SetHeight(Value: Integer); override;
    procedure SetTransparent(Value: Boolean); override;
    procedure SetWidth(Value: Integer); override;
    procedure TiledDraw(ACanvas: TCanvas; const Rect: TRect); override;
    procedure WriteData(Stream: TStream); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    class function AssignsTo(Dest: TGraphicClass): Boolean; override;
    function ColorTable: Pointer;
    procedure Dormant;
    procedure FreeImage;
    procedure FreePixmap;
    function ReleasePixmap: QPixmapH;
    procedure LoadFromMimeSource(MimeSource: TMimeSource); override;
    procedure SaveToMimeSource(MimeSource: TClxMimeSource); override;
    procedure LoadFromResourceName(Instance: Cardinal; const ResName: string);
    procedure LoadFromResourceID(Instance: Cardinal; ResID: Integer);
    procedure LoadFromStream(Stream: TStream); override;
    procedure Mask(TransparentColor: TColor);
    procedure SaveToStream(Stream: TStream); override;
    property Canvas: TNGCanvas read GetCanvas;
    property Format: string read FFormat write FFormat;
    property Image: QImageH read GetImage;
    property Handle: QPixmapH read GetHandle write SetHandle;
    property Monochrome: Boolean read GetMonochrome write SetMonochrome;
    property PixelFormat: TPixelFormat read GetPixelFormat write SetPixelFormat;
    property ScanLine[Row: Integer]: Pointer read GetScanLine;
    property TransparentColor: TColor read GetTransparentColor
      write SetTransparentColor stored TransparentColorStored;
    property TransparentMode: TTransparentMode read FTransparentMode
      write SetTransparentMode default tmAuto;
  end;

implementation

type
  EInvalidGraphic = class(Exception);
  EInvalidGraphicOperation = class(Exception);

const
  SDelphiBitmap = 'image/delphi.bitmap';
  
resourcestring
  SScanLine = 'Scan line index out of range';
  SUnknownImageFormat = 'Image format not recognized';
  SInvalidColorDepth = 'Color depth must be 1, 8 or 32 bpp';
  SUnableToWrite = 'Unable to write bitmap';
  SInvalidCanvasState = 'Invalid canvas state request';

procedure InvalidOperation(Str: PResStringRec);
begin
  raise EInvalidGraphicOperation.CreateRes(Str);
end;

class function TNGBMP.AssignsTo(Dest: TGraphicClass): Boolean;
begin
  Result := inherited AssignsTo(Dest);// or Dest.InheritsFrom(TIcon);
end;

procedure TNGBMP.AssignTo(Dest: TPersistent);
begin
    inherited AssignTo(Dest);
end;

procedure TNGBMP.Assign(Source: TPersistent);
begin
  if (Source = nil) or (Source is TNGBMP) then
  begin
    FreeImage;
    FreePixmap;
    if Source <> nil then
    begin
      if (TNGBMP(Source).FImage = nil) and (TNGBMP(Source).FPixmap = nil) then
      begin
        FHeight := TNGBMP(Source).FHeight;
        FWidth := TNGBMP(Source).FWidth;
      end else
      begin
        if TNGBMP(Source).FImage <> nil then
          FImage := QImage_create(TNGBMP(Source).FImage);
        if TNGBMP(Source).FPixmap <> nil then
          FPixmap := QPixmap_create(TNGBMP(Source).FPixmap);
      end;
    end;
    Changed(Self);
  end
  else
    inherited Assign(Source);
end;

function TNGBMP.ColorTable: Pointer;
begin
  Result := nil;
  ImageNeeded;
  if FImage <> nil then
    Result := QImage_colorTable(FImage);
end;

constructor TNGBMP.Create;
begin
  inherited Create;
  FFormat := 'BMP';
  FTransparentColor := clDefault;
  FTransparentMode := tmAuto;
  FPixelFormat := pf32bit;
end;

destructor TNGBMP.Destroy;
begin
  FreeImage;
  FreePixmap;
  inherited Destroy;
end;

procedure TNGBMP.Changing(Sender: TObject);
begin
  HandleNeeded;
  FreeImage;
end;

procedure TNGBMP.Dormant;
begin
  ImageNeeded;
  FreePixmap;
end;

procedure TNGBMP.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  NewMatrix: QWMatrixH;
begin
  TNGCanvas(ACanvas).RequiredState([csHandleValid]);
  HandleNeeded;
  if (Rect.Right - Rect.Left <> Width) or
    (Rect.Bottom - Rect.Top <> Height) then
  begin
    // Image must be scaled
    QPainter_saveWorldMatrix(ACanvas.Handle);
    try
      NewMatrix:= QWMatrix_create( (Rect.Right - Rect.Left) / Width ,
        0, 0, (Rect.Bottom - Rect.Top) / Height, Rect.Left, Rect.Top );
      try
        QPainter_setWorldMatrix(ACanvas.Handle, NewMatrix, True);
        QPainter_drawPixmap(ACanvas.Handle, 0, 0, FPixmap, 0, 0, Width, Height);
      finally
        QWMatrix_destroy(NewMatrix);
      end;
    finally
      QPainter_restoreWorldMatrix(ACanvas.Handle);
    end;
  end
  else
    QPainter_drawPixmap(ACanvas.Handle, Rect.Left, Rect.Top, FPixmap, 0, 0,
      Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
end;

procedure TNGBMP.FreeImage;
begin
  if FImage <> nil then
  begin
    QImage_destroy(FImage);
    FImage := nil;
    FreeAndNil(FStream);
  end;
end;

procedure TNGBMP.FreePixmap;
begin
  if FPixmap <> nil then
  begin
    QPixmap_destroy(FPixmap);
    FPixmap := nil;
  end;
end;

function TNGBMP.GetCanvas: TNGCanvas;
begin
  if FCanvas = nil then
  begin
    FCanvas := TNGBitmapCanvas.Create(Self);
    FCanvas.OnChanging := Changing;
    FCanvas.OnChange := Changed;
  end;
  Result := FCanvas;
end;

function TNGBMP.GetEmpty: Boolean;
begin
  Result := ((FPixmap = nil) or QPixmap_isNull(FPixmap)) and (FImage = nil);
end;

function TNGBMP.GetImage: QImageH;
begin
  ImageNeeded;
  Result := FImage;
end;

function TNGBMP.GetHandle: QPixmapH;
begin
  HandleNeeded;
  Result := FPixmap;
end;

function TNGBMP.GetHeight: Integer;
begin
  if FPixmap <> nil then
    Result := QPixmap_height(FPixmap)
  else if FImage <> nil then
    Result := QImage_height(FImage)
  else
    Result := FHeight;
end;

function TNGBMP.GetMonochrome: Boolean;
begin
  if FPixmap <> nil then
    Result := QPixmap_isQBitmap(FPixmap)
  else if FImage <> nil then
    Result := PixelFormat = pf1bit
  else
    Result := False;
end;

function TNGBMP.GetPixelFormat: TPixelFormat;
var
  Depth: Integer;
begin
  ImageNeeded;
  if FImage <> nil then
  begin
    Depth := QImage_depth(FImage);
    case Depth of
      1: Result := pf1bit;
      8: Result := pf8bit;
      16: Result := pf16bit;
      32: Result := pf32bit;
    else
      Result := pfCustom;
    end;
  end
  else
    Result := FPixelFormat;
end;

const
  PixelFormatMap: array[pf1bit..pf32bit] of Integer = (1, 8, 16, 32);

procedure TNGBMP.SetPixelFormat(const Value: TPixelFormat);
var
  NewImage: QImageH;
  Format: TPixelFormat;
begin
  Format := GetPixelFormat;
  if Value = Format then Exit;
  FPixelFormat := Value;
  ImageNeeded;
  HandleNeeded;
  if FImage <> nil then
  begin
    NewImage := QImage_create;
    QImage_convertDepth(FImage, NewImage, PixelFormatMap[Value]);
    QImage_destroy(FImage);
    FImage := NewImage;
    QPixmap_convertFromImage(FPixmap, FImage, QPixmapColorMode(QPixmapColorMode_Auto));
    Changed(Self);
  end;
end;

function TNGBMP.GetScanLine(Row: Integer): Pointer;
begin
  if (Row < 0) or (Row > Height) then
    InvalidOperation(@SScanLine);
  ImageNeeded;
  FreePixmap;
  if FImage <> nil then
    Result := QImage_scanLine(FImage, Row)
  else Result := nil;
end;


function TNGBMP.GetWidth: Integer;
begin
  if FPixmap <> nil then
    Result := QPixmap_width(FPixmap)
  else if FImage <> nil then
    Result := QImage_width(FImage)
  else
    Result := FWidth;
end;

procedure TNGBMP.HandleNeeded;
begin
  if FPixmap = nil then
    if FImage <> nil then
    begin
      FPixmap := QPixmap_create;
      QPixmap_convertFromImage(FPixmap, FImage, QPixmapColorMode(QPixmapColorMode_Auto));
    end
    else
    begin
      FPixmap := QPixmap_create(FWidth, FHeight, -1, QPixmapOptimization_DefaultOptim);
      if (FWidth > 0) and (FHeight > 0) then
        Canvas.FillRect(Rect(0, 0, FWidth, FHeight));
    end;
end;

procedure TNGBMP.ImageNeeded;
begin
  if FImage = nil then
    if FPixmap <> nil then
    begin
      FImage := QImage_create;
      QPixmap_convertToImage(FPixmap, FImage);
    end
    else if (FWidth > 0) and (FHeight > 0) then
      FImage := QImage_create(FWidth, FHeight, PixelFormatMap[FPixelFormat], 0,
        QImageEndian_IgnoreEndian);
end;

procedure TNGBMP.LoadFromStream(Stream: TStream);
var
  IO: QImageIOH;
  Device: QIODeviceH;
  P, S: Int64;
begin
  FreeImage;
  FreePixmap;
  if Stream.Size - Stream.Position > 0 then
  begin
    P := Stream.Position;
    Device := IODeviceFromStream(Stream);
    Format := QImageIO_imageFormat(Device);
    IO := QImageIO_create(Device, PChar(Format));
    try
      if not QImageIO_read(IO) then InvalidOperation(@SUnknownImageFormat);
      FImage := QImage_create(QImageIO_image(IO));
//      if FTransparent then Mask(FTransparentColor);
    finally
      QImageIO_destroy(IO);
    end;
    if ExactBitmaps and (P <> Stream.Position) then
    begin
      // Preserve the exact bytes we read.
      S := Stream.Position - P;
      FStream := TMemoryStream.Create;
      Stream.Position := P;
      FStream.CopyFrom(Stream, S);
      Assert(Stream.Position = P + S);
    end;
  end;
  Changed(Self);
end;

type
  TColorTable = array[0..MaxInt div SizeOf(QRgb)-1] of QRgb;
  PColorTable = ^TColorTable;
  TIntArray = array[0..MaxInt div SizeOf(QRgb)-1] of Integer;
  PIntArray = ^TIntArray;

procedure TNGBMP.Mask(TransparentColor: TColor);
var
  MaskImage: QImageH;
  MaskBitmap: QBitmapH;
  X, Y: Integer;
  C, TC: QRgb;
  Black,
  White: QRgb;
  SLImage32: PIntArray;
  SLImage,
  SLMask: PByteArray;
  ColorTable: PColorTable;
  LittleEndian: Boolean;
begin
  ImageNeeded;
  if FImage = nil then Exit; // Not enough information to create one.
  Black := $FF000000;
  White := $FFFFFFFF;
  MaskImage := QImage_create(Width, Height, 8, 2, QImageEndian_IgnoreEndian);
  try
    if TransparentColor = clDefault then
      QImage_pixel(FImage, @TC, 0, Height - 1)
    else
      QColor_rgb(QColor(TransparentColor), @TC);
    QImage_setColor(MaskImage, 0, @QRgb(Black));
    QImage_setColor(MaskImage, 1, @QRgb(White));
    case PixelFormat of
      pf1bit:
        begin
          ColorTable := PColorTable(QImage_colorTable(FImage));
          LittleEndian := QImage_bitOrder(FImage) = QImageEndian_LittleEndian;
          if LittleEndian then
          begin
            for Y := 0 to Height - 1 do
            begin
              SLImage := PByteArray(QImage_scanLine(FImage, Y));
              SLMask := PByteArray(QImage_scanLine(MaskImage, Y));
              for X := 0 to Width - 1 do
              begin
                C := ColorTable[(SLImage[x div 8] and (1 shl (x and 7))) shr (x mod 8)];
                SLMask[x] := Ord(C = TC);
              end;
            end;
          end
          else
          begin
            for Y := 0 to Height - 1 do
            begin
              SLImage := PByteArray(QImage_scanLine(FImage, Y));
              SLMask := PByteArray(QImage_scanLine(MaskImage, Y));
              for X := 0 to Width - 1 do
              begin
                C := ColorTable[(SLImage[x div 8] and (1 shl (7 - x and 7))) shr (7 - (x mod 8))];
                SLMask[x] := Ord(C = TC);
              end;
            end;
          end;
        end;
      pf8bit: //pf16bit??
        begin
          ColorTable := PColorTable(QImage_colorTable(FImage));
          for Y := 0 to Height - 1 do
          begin
            SLImage := PByteArray(QImage_scanLine(FImage, Y));
            SLMask := PByteArray(QImage_scanLine(MaskImage, Y));
            for X := 0 to Width - 1 do
            begin
              C := ColorTable[SLImage[x]];
              SLMask[x] := Ord(C = TC);
            end;
          end;
        end;
      pf32bit:
        begin
          for Y := 0 to Height - 1 do
          begin
            SLImage32 := PIntArray(QImage_scanLine(FImage, Y));
            SLMask := PByteArray(QImage_scanLine(MaskImage, Y));
            for X := 0 to Width - 1 do
            begin
              C := QRgb(SLImage32[x]);
              SLMask[x] := Ord(C = TC);
            end;
          end;
        end;
    else
      InvalidOperation(@SInvalidColorDepth);
    end;
    MaskBitmap := QBitmap_create(Width, Height, True, QPixmapOptimization_NoOptim);
    try
      QPixmap_convertFromImage(MaskBitmap, MaskImage, QPixmapColorMode_Mono);
      QPixmap_setMask(Handle, MaskBitmap);
    finally
      QBitmap_destroy(MaskBitmap);
    end;
  finally
    QImage_destroy(MaskImage);
  end;
end;

procedure TNGBMP.LoadFromResourceName(Instance: Cardinal; const ResName: string);
var
  Stream: TCustomMemoryStream;
  TmpStream: TMemoryStream;
  Header: TBitmapFileHeader;
  BmpHeader: TBitmapInfoHeader;
begin
  Stream := TResourceStream.Create(Instance, ResName, RT_BITMAP);
  try
    TmpStream := TMemoryStream.Create;
    try
      // Reads bitmap header
      Stream.ReadBuffer(BmpHeader, sizeof(BmpHeader));
      Stream.Seek(0, soBeginning);

      // Builds file header
      FillChar(Header, SizeOf(Header), 0);
      Header.bfType := $4D42;
      Header.bfSize := Stream.Size;
      Header.bfReserved1 := 0;
      Header.bfReserved2 := 0;

      if BmpHeader.biBitCount > 8 then
        Header.bfOffBits := sizeof(Header) + sizeof(BmpHeader)
      else
        if BmpHeader.biClrUsed = 0 then
          Header.bfOffBits := sizeof(Header) + sizeof(BmpHeader) + (1 shl BmpHeader.biBitCount) * 4
        else
          Header.bfOffBits := sizeof(Header) + sizeof(BmpHeader) + BmpHeader.biClrUsed * 4;

      // Concatenates both in TmpStream
      TmpStream.WriteBuffer(Header, SizeOf(Header));
      TmpStream.CopyFrom(Stream, Stream.Size);
      TmpStream.Position := 0;
      LoadFromStream(TmpStream);
    finally
      TmpStream.Free;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TNGBMP.LoadFromResourceID(Instance: Cardinal; ResID: Integer);
var
  Stream: TCustomMemoryStream;
begin
  Stream := TResourceStream.CreateFromID(Instance, ResID, RT_BITMAP);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TNGBMP.ReadData(Stream: TStream);
var
  Dummy: Integer;
begin
  //for VCL stream compatibility
  Stream.Read(Dummy, SizeOf(Dummy));
  LoadFromStream(Stream);
end;

procedure TNGBMP.ResizeImage(NewWidth, NewHeight: Integer);
var
  NewImage: QImageH;
begin
  ImageNeeded;
  FreePixmap;
  NewImage := QImage_create;
  QImage_copy(FImage, NewImage, 0, 0, NewWidth, NewHeight, 0);
  QImage_destroy(FImage);
  FImage := NewImage;
end;

procedure TNGBMP.SaveToStream(Stream: TStream);
var
  IO: QImageIOH;
begin
  if FStream <> nil then
  begin
    // If we have an exact image use that.
    FStream.Position := 0;
    Stream.CopyFrom(FStream, FStream.Size);
  end
  else
  begin
    // Otherwise ask the QImage to write out its contents.
    ImageNeeded;
    if FImage = nil then Exit; // Nothing to write
    IO := QImageIO_create(IODeviceFromStream(Stream), nil);
    try
      ImageNeeded;
      QImageIO_setImage(IO, FImage);
      QImageIO_setFormat(IO, PChar(Format));
      if not QImageIO_write(IO) then InvalidOperation(@SUnableToWrite);
    finally
      QImageIO_destroy(IO);
    end;
  end;
end;

procedure TNGBMP.SetHandle(const Value: QPixmapH);
begin
  if FPixmap <> Value then
  begin
    FreeImage;
    FreePixmap;
    FPixmap := Value;
    FHeight := GetHeight;
    FWidth := GetWidth;
  end;
end;

procedure TNGBMP.SetHeight(Value: Integer);
begin
  if Value <> Height then
  begin
    if (FPixmap <> nil) or (FImage <> nil) then
      ResizeImage(Width, Value)
    else
      FHeight := Value;
  end;
end;

procedure TNGBMP.SetMonochrome(const Value: Boolean);
const
  Depth: array[Boolean] of Integer = (32, 1);
var
  NewImg: QImageH;
begin
  if Value <> GetMonochrome then
  begin
    HandleNeeded;
    ImageNeeded;
    if FImage = nil then
      FPixelFormat := pf1bit
    else
    begin
      NewImg := QImage_create;
      try
        QImage_convertDepth(FImage, NewImg, Depth[Value]);
        QPixmap_convertFromImage(FPixmap, NewImg, Integer(ImageConversionFlags_AutoColor));
      finally
        QImage_destroy(NewImg);
      end;
    end;
    Changed(Self);
  end;
end;

procedure TNGBMP.SetWidth(Value: Integer);
begin
  if Value <> Width then
  begin
    if (FPixmap <> nil) or (FImage <> nil) then
      ResizeImage(Value, Height)
    else
      FWidth := Value;
  end;
end;

procedure TNGBMP.WriteData(Stream: TStream);
var
  StartPos, Size: Integer;
begin
  StartPos := Stream.Position;
  Stream.Write(StartPos, SizeOf(StartPos));
  SaveToStream(Stream);
  Size := Stream.Position - StartPos;
  Stream.Position := StartPos;
  Stream.Write(Size, SizeOf(Size));
  Stream.Position := StartPos + Size;
end;

function TNGBMP.GetTransparentColor: TColor;
var
  TempColor: QColorH;
begin
  if FTransparentColor = clDefault then
  begin
    if Monochrome then
      Result := clWhite
    else begin
      ImageNeeded;
      QImage_pixel(FImage, @Result, 0, Height - 1);
      TempColor := QColor_create;
      try
        QColor_setRgb(TempColor, QRgbH(@Result));
        Result := QColorColor(TempColor);
      finally
        QColor_destroy(TempColor);
      end;
    end;
  end
  else
    Result := FTransparentColor;
end;

procedure TNGBMP.SetTransparentColor(const Value: TColor);
begin
  if Value <> FTransparentColor then
  begin
    if Value = clDefault then
      FTransparentMode := tmAuto else
      FTransparentMode := tmFixed;
    FTransparentColor := Value;
//    FTransparent := True;
    if not Empty then
    begin
      Mask(Value);
      Changed(Self);
    end;
  end;
end;

procedure TNGBMP.SetTransparentMode(const Value: TTransparentMode);
begin
  if Value <> FTransparentMode then
    case Value of
      tmAuto: SetTransparentColor(clDefault);
      tmFixed: SetTransparentColor(GetTransparentColor);
    end;
end;

function TNGBMP.TransparentColorStored: Boolean;
begin
  Result := FTransparentMode = tmFixed;
end;

procedure TNGBMP.SetTransparent(Value: Boolean);
//var
//  NullBitmap: QBitmapH;
begin
{  if Value <> FTransparent then
  begin
    inherited SetTransparent(Value);
    if FTransparent and not Empty then
      Mask(FTransparentColor)
    else begin
      NullBitmap := QBitmap_create;
      try
        QPixmap_setMask(Handle, NullBitmap);
      finally
        QBitmap_destroy(NullBitmap);
      end;
    end;
  end; }
end;

function TNGBMP.GetTransparent: Boolean;
begin
//  Result := FTransparent;
  Result := false;
end;

procedure TNGBMP.TiledDraw(ACanvas: TCanvas; const Rect: TRect);
begin
  QPainter_drawTiledPixmap(ACanvas.Handle, Rect.Left, Rect.Top, Rect.Right -
    Rect.Left, Rect.Bottom - Rect.Top, Handle, 0, 0);
end;

procedure TNGBMP.LoadFromMimeSource(MimeSource: TMimeSource);
var
  Stream: TStream;
begin
  if MimeSource.Provides(SDelphiBitmap) then
  begin
    Stream := TMemoryStream.Create;
    try
      MimeSource.SaveToStream(SDelphiBitmap, Stream);
      Stream.Position := 0;
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TNGBMP.SaveToMimeSource(MimeSource: TClxMimeSource);
var
  Stream: TStream;
begin
  Stream := TMemoryStream.Create;
  try
    SaveToStream(Stream);
    Stream.Position := 0;
    MimeSource.LoadFromStream(Stream, SDelphiBitmap);
  finally
    Stream.Free;
  end;
end;

function TNGBMP.ReleasePixmap: QPixmapH;
begin
  FreeImage;
  Result := FPixmap;
  FPixmap := nil;
  FHeight := 0;
  FWidth := 0;
end;

{ TBitmapCanvas }

procedure TNGBitmapCanvas.BeginPainting;
begin
  if not QPainter_isActive(Handle) then
    if not QPainter_begin(Handle, FBitmap.Handle) then
      InvalidOperation(@SInvalidCanvasState);
end;

constructor TNGBitmapCanvas.Create(Bitmap: TNGBMP);
begin
  inherited Create;
  FBitmap := Bitmap;
end;

procedure TNGBitmapCanvas.CreateHandle;
begin
  Handle := QPainter_create;
end;

end.
