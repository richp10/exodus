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
unit Random;


interface

uses Classes, SysUtils, Windows;

type
  TRandom = Class
  private
    { Private declarations }
    _context : Integer;
    _dll : THandle;

    procedure GenRandom(bufLen : integer; var buffer:String);

  public
    { Public declarations }
    constructor Create();
    destructor Terminate;

    procedure CreateRand(size: integer; var Output: String);
  end;

implementation

Const CryptMethod : Integer = 1;

Const CRYPT_KEYSET : integer = $0;
Const CRYPT_NEWKEYSET : integer = $8;

type
    TCryptAcquireContext = function(var hProv:Integer; Container, Provider: Pchar; ProvType, Flags: integer): integer stdcall;
    TCryptGenRandom = function(hProv: integer; dwLen: integer; pbBuffer: string): integer stdcall;
    TCryptReleaseContext = function(Prov: integer; Flags: integer): integer stdcall;

constructor TRandom.Create;
var
    CryptAcquireContext: TCryptAcquireContext;
    lRet: integer;
begin
    inherited;
    _context := 0;
    _dll := LoadLibrary('advapi32.dll');
    if _dll = 0 then
        raise Exception.Create('Unable to open advapi32.dll');

    @CryptAcquireContext := GetProcaddress(_dll,'CryptAcquireContextA');
    if (@CryptAcquireContext <> nil) then begin

        lRet := CryptAcquireContext(_context, nil, nil, CryptMethod, CRYPT_KEYSET);
        if (lRet = 0) then
            _context := 0;
    end;

    // fall back on randomize?
    if (_context = 0) then
        Randomize();
end;

procedure TRandom.GenRandom(bufLen : integer; var buffer:String);
var
    CryptGenRandom: TCryptGenRandom;
    i: integer;
begin
    if ((_dll = 0) or (_context = 0)) then begin
        for i := 0 to bufLen do begin
            buffer[i] := chr(system.random(256));
        end;
        exit;
    end;

    @CryptGenRandom := GetProcaddress(_dll, 'CryptGenRandom');
    if @CryptGenRandom <> nil then
        CryptGenRandom(_context, BufLen, Buffer);
end;


procedure TRandom.CreateRand(size: integer; var Output: String);
var
    RndBuffer : String;
begin
    RndBuffer :=StringOfChar(chr(0),size);
    GenRandom(size, RndBuffer);
    SetLength(RndBuffer,size);
    Output := RndBuffer;
end;

destructor TRandom.Terminate;
var
    CryptReleaseContext : TCryptReleaseContext;
begin
    if (_context <> 0) then begin
        @CryptReleaseContext := GetProcaddress(_dll,'CryptReleaseContext');
        if @CryptReleaseContext <> nil then
            CryptReleaseContext(_context, 0);
    end;

    if (_dll <> 0) then
        FreeLibrary(_dll);
    inherited;
end;

end.
