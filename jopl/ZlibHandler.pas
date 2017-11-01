{
    Copyright 2001-2008, Estate of Peter Millard
	
	This file is part of Exodus.
	
	Exodus is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.
	
	Exodus is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with Exodus; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit ZlibHandler;

interface
uses
  Classes,
  IdGlobal, IdSocks, IdIOHandlerSocket, IdSocketHandle, IdIOHandler, Zlib;

type
  TZlibIOHandler = class(TIdIOHandlerSocket)
  private
    _wrapped : TIdIOHandlerSocket;

    _inrec: TZStreamRec;
    _inbuf: array [Word] of Char;

    _outrec: TZStreamRec;
    _outbuf: array [Word] of Char;

  protected

    procedure SetSocksInfo(ASocks: TIdSocksInfo);
    function GetSocksInfo: TIdSocksInfo;
    function GetBinding: TIdSocketHandle;
    procedure SetNagle(ANagle: boolean);
    function GetNagle: boolean;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure Close; override;
    procedure ConnectClient(const AHost: string; const APort: Integer; const ABoundIP: string;
     const ABoundPort: Integer; const ABoundPortMin: Integer; const ABoundPortMax: Integer;
     const ATimeout: Integer = IdTimeoutDefault); override;
    function Connected: Boolean; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open; override;
    function Readable(AMSec: integer = IdTimeoutDefault): boolean; override;
    function Recv(var ABuf; ALen: integer): integer; override;
    function Send(var ABuf; ALen: integer): integer; override;
    //
    property Binding: TIdSocketHandle read GetBinding;
  published
    property SocksInfo: TIdSocksInfo read GetSocksInfo write SetSocksInfo;
    property UseNagle: boolean read GetNagle write SetNagle default True;
    property WrappedSocketHandler: TIdIOHandlerSocket read _wrapped write _wrapped;
  end;

implementation

uses
    GnuGetText;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function CCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise ECompressionError.Create(_('Compression Error')); //!!
end;

{---------------------------------------}
function DCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise EDecompressionError.Create(_('Decompression Error'));  //!!
end;

{---------------------------------------}
procedure TZlibIOHandler.SetSocksInfo(ASocks: TIdSocksInfo);
begin
    assert(Assigned(_wrapped));
    _wrapped.SocksInfo := ASocks;
end;

{---------------------------------------}
function TZlibIOHandler.GetSocksInfo: TIdSocksInfo;
begin
    assert(Assigned(_wrapped));
    result := _wrapped.SocksInfo;
end;

{---------------------------------------}
function TZlibIOHandler.GetBinding: TIdSocketHandle;
begin
    assert(Assigned(_wrapped));
    result := _wrapped.Binding;
end;


{---------------------------------------}
procedure TZlibIOHandler.SetNagle(ANagle: boolean);
begin
    assert(Assigned(_wrapped));
    _wrapped.UseNagle := ANagle;
end;

{---------------------------------------}
function TZlibIOHandler.GetNagle: boolean;
begin
    assert(Assigned(_wrapped));
    result := _wrapped.UseNagle;
end;

{---------------------------------------}
procedure TZlibIOHandler.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (Assigned(_wrapped)) then
    _wrapped := nil;

  inherited;
end;

{---------------------------------------}
procedure TZlibIOHandler.Close;
begin
    assert(Assigned(_wrapped));
    _wrapped.Close();
end;

{---------------------------------------}
procedure TZlibIOHandler.ConnectClient(const AHost: string; const APort: Integer; const ABoundIP: string;
     const ABoundPort: Integer; const ABoundPortMin: Integer; const ABoundPortMax: Integer;
     const ATimeout: Integer = IdTimeoutDefault);
begin
    assert(false, 'Don''t connect after chaining zlib');
end;

{---------------------------------------}
function TZlibIOHandler.Connected: Boolean;
begin
    result := _wrapped.Connected;
end;

{---------------------------------------}
constructor TZlibIOHandler.Create(AOwner: TComponent);
begin
    inherited;
    _outrec.next_out := _outbuf;
    _outrec.avail_out := sizeof(_outbuf);
    _outrec.zalloc := zlibAllocMem;
    _outrec.zfree := zlibFreeMem;

    // XXX: make level configurable
    CCheck(deflateInit_(_outrec, Z_DEFAULT_COMPRESSION, zlib_version, sizeof(_outrec)));

    _inrec.next_in := _inbuf;
    _inrec.avail_in := 0;
    _inrec.zalloc := zlibAllocMem;
    _inrec.zfree := zlibFreeMem;
    DCheck(inflateInit_(_inrec, zlib_version, sizeof(_inrec)));
end;

{---------------------------------------}
destructor TZlibIOHandler.Destroy;
begin
    _wrapped.Free();

    inherited;

end;

{---------------------------------------}
procedure TZlibIOHandler.Open;
begin
    assert(false, 'Don''t connect after chaining zlib');
end;

{---------------------------------------}
function TZlibIOHandler.Readable(AMSec: integer = IdTimeoutDefault): boolean;
begin
    result := _wrapped.Readable(AMSec);
end;

{---------------------------------------}
function TZlibIOHandler.Recv(var ABuf; ALen: integer): integer;
var
    ret: integer;
    count: integer;
begin
    _inrec.next_out := @ABuf;
    _inrec.avail_out := ALen;

    count := 0;
    while (_inrec.avail_out > 0) or (count = 0) do begin     // while we have space
        if _inrec.avail_in = 0 then begin
            _inrec.next_in := _inbuf;
            _inrec.avail_in := _wrapped.Recv(_inbuf, sizeof(_inbuf));
            if _inrec.avail_in = 0 then begin
                Result := 0; // closed?
                Exit;
            end;
        end;
        ret := inflate(_inrec, Z_SYNC_FLUSH);
        if ret = Z_STREAM_END then begin
            count := count + (ALen - _inrec.avail_out);
            inflateReset(_inrec);
            if count > 0 then
                break;
        end
        else if ret = Z_OK then begin
            count := count + (ALen - _inrec.avail_out);
            if _inrec.avail_in = 0 then
                break;
        end
        else
            DCheck(ret);
    end;
    Result := count;
end;

{---------------------------------------}
function TZlibIOHandler.Send(var ABuf; ALen: integer): integer;
begin
    _outrec.next_in := @ABuf;
    _outrec.avail_in := ALen;
    _outrec.next_out := _outbuf;
    _outrec.avail_out := sizeof(_outbuf);

    while (_outrec.avail_in > 0) do begin
        CCheck(deflate(_outrec, Z_NO_FLUSH));
        if _outrec.avail_out = 0 then begin
            // ran out of buffer space.  I don't think this can happen, actually.
            Result := _wrapped.Send(_outbuf, integer(_outrec.next_out) - integer(@_outbuf));
            _outrec.next_out := _outbuf;
            _outrec.avail_out := sizeof(_outbuf);
            exit;
        end;
    end;

    // we're to the end.
    // Flush.  (ring, ring)
    // Flush.  (ring, ring)  (c.f. 'All of Me')
    CCheck(deflate(_outrec, Z_SYNC_FLUSH));
    // XXX: Should do full send here.
    _wrapped.Send(_outbuf, integer(_outrec.next_out) - integer(@_outbuf));
    Result := ALen;
end;

end.
