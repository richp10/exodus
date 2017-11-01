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
unit COMRosterImages;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Classes, IdCoderMime, Exodus_TLB,
    Windows, Graphics, ComObj, ActiveX,  StdVcl;

type
  TExodusRosterImages = class(TAutoObject, IExodusRosterImages, IExodusRosterImages2)
  protected
    function AddImageBase64(const id, base64: WideString): Integer; safecall;
    function AddImageFilename(const id, filename: WideString): Integer;
      safecall;
    function AddImageResource(const ID, LibName, ResName: WideString): Integer;
      safecall;
    function Find(const id: WideString): Integer; safecall;
    procedure Remove(const id: WideString); safecall;
    function GetImageById(const Id: WideString): WideString; safecall;
    function GetImageByIndex(Idx: Integer): WideString; safecall;

  private
    _base64: TIdDecoderMime;
    _Encoder: TIdEncoderMime;
    _bmp: TBitmap;
    _mem: TMemoryStream;

  public
    constructor Create();
    destructor Destroy(); override;

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    RosterImages, ComServ, Variants, Types;

{---------------------------------------}
constructor TExodusRosterImages.Create();
begin
    _base64 := TIdDecoderMime.Create(nil);
    _Encoder := TIdEncoderMime.Create(nil);
    _bmp := TBitmap.Create();
    _mem := TMemoryStream.Create();
end;

{---------------------------------------}
destructor TExodusRosterImages.Destroy();
begin
    _base64.free();
    _Encoder.Free();
    _bmp.free();
    _mem.free();
end;

{---------------------------------------}
function TExodusRosterImages.AddImageBase64(const id,
  base64: WideString): Integer;
var
    idx: integer;
begin
    idx := RosterTreeImages.Find(id);
    if (idx >= 0) then begin
        Result := idx;
        exit;
    end;

    // decode data into a bitmap
    _mem.Clear();
    _mem.Position := 0;

    _base64.DecodeToStream(base64, _mem);
    _mem.Position := 0;

    _bmp.LoadFromStream(_mem);
    Result := RosterTreeImages.AddImage(id, _bmp);
end;

{---------------------------------------}
function TExodusRosterImages.AddImageFilename(const id,
  filename: WideString): Integer;
var
    idx: integer;
begin
    idx := RosterTreeImages.Find(id);
    if (idx >= 0) then begin
        Result := idx;
        exit;
    end;

    _bmp.LoadFromFile(filename);
    Result := RosterTreeImages.AddImage(id, _bmp);
end;

{---------------------------------------}
function TExodusRosterImages.AddImageResource(const ID, LibName,
  ResName: WideString): Integer;
var
    lname: string;
    ins: THandle;
    idx: integer;
begin
    idx := RosterTreeImages.Find(id);
    if (idx >= 0) then begin
        Result := idx;
        exit;
    end;

    lname := LibName;
    ins := LoadLibrary(PChar(lname));
    if (ins > 0) then begin
        _bmp.LoadFromResourceName(ins, ResName);
        Result := RosterTreeImages.AddImage(id, _bmp);
        FreeLibrary(ins);
    end;
end;

{---------------------------------------}
function TExodusRosterImages.Find(const id: WideString): Integer;
begin
    Result := RosterTreeImages.Find(id);
end;

{---------------------------------------}
procedure TExodusRosterImages.Remove(const id: WideString);
begin
    RosterTreeImages.RemoveImage(id);
end;

{---------------------------------------}
function TExodusRosterImages.GetImageById(const Id: WideString): WideString;
var
  Idx: Integer;
begin
   Result := '';
   Idx := RosterTreeImages.Find(Id);
   if (Idx = -1) then
      exit;
   Result := GetImageByIndex(Idx);
end;

{---------------------------------------}
function TExodusRosterImages.GetImageByIndex(Idx: Integer): WideString;
var
  Bitmap: TBitmap;
begin
   Result := '';
   //First, save bitmap to stream.
   Bitmap := TBitmap.Create();
    //RosterTreeImages.ImageList.GetBitmap(Idx, _bmp);
    RosterTreeImages.ImageList.GetBitmap(Idx, Bitmap);
   _mem.Clear();
   _mem.Position := 0;
   //_bmp.SaveToStream(_mem);
   Bitmap.SaveToStream(_mem);
   _mem.Position := 0;
   //Encode stream into binary string
   Result := _Encoder.Encode(_mem);
   Bitmap.Free();
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusRosterImages, Class_ExodusRosterImages,
    ciMultiInstance, tmApartment);


end.
