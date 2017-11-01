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
unit icqUtils;
{
    This code was taken from sample code which
    comes with the ICQClient component (Licensed as freeware)
    from:
    (C) Alex Demchenko(alex@ritlabs.com)
    See http://www.cobans.net for updates & more info.

    It was modified for the Exodus project (http://exodus.jabberstudio.org)
    for more generic operation.
}


interface
uses
    Windows, Classes;

const
    icqFormat_Unknown = 0;
    icqFormat_ICQ = 1;
    icqFormat_Miranda = 2;

// Forward declares
function findICQDatabases(): TStringList;

// private functions
function GetDualIcqFiles(DbPath: String; var FList: TStringList): Boolean;
function GetMirandaFiles(var FList: TStringList): Boolean;

implementation
uses
    Registry, SysUtils, Dialogs;

{-----------------------------------------}
{-----------------------------------------}
{-----------------------------------------}
function findICQDatabases(): TStringList;
var
    RegKeyHandle: HKEY;
    StrBuffer: array[0..2047] of Char;
    DataType, BufSize: Integer;
    DbPaths: TStringList;
    i, n: Word;
    l: TStringList;
    tmps: string;

    procedure QueryReg(Where: HKEY);
    begin
        if (RegOpenKey(Where, PChar('SOFTWARE\Mirabilis\ICQ\DefaultPrefs'),
        RegKeyHandle) = ERROR_SUCCESS) then begin
            if RegQueryValueEx(RegKeyHandle, PChar('99b Database'), nil,
            @DataType, PByte(@StrBuffer), @BufSize) = ERROR_SUCCESS then
                DbPaths.Add(Copy(StrBuffer, 0, BufSize));
            if RegQueryValueEx(RegKeyHandle, PChar('2000a Database'), nil,
            @DataType, PByte(@StrBuffer), @BufSize) = ERROR_SUCCESS then
                DbPaths.Add(Copy(StrBuffer, 0, BufSize));
            if RegQueryValueEx(RegKeyHandle, PChar('2000b Database'), nil,
            @DataType, PByte(@StrBuffer), @BufSize) = ERROR_SUCCESS then
                DbPaths.Add(Copy(StrBuffer, 0, BufSize));
            if RegQueryValueEx(RegKeyHandle, PChar('2001a Database'), nil,
            @DataType, PByte(@StrBuffer), @BufSize) = ERROR_SUCCESS then
                DbPaths.Add(Copy(StrBuffer, 0, BufSize));
            if RegQueryValueEx(RegKeyHandle, PChar('2002a Database'), nil,
            @DataType, PByte(@StrBuffer), @BufSize) = ERROR_SUCCESS then
                DbPaths.Add(Copy(StrBuffer, 0, BufSize));
            if RegQueryValueEx(RegKeyHandle, PChar('2003a Database'), nil,
            @DataType, PByte(@StrBuffer), @BufSize) = ERROR_SUCCESS then
                DbPaths.Add(Copy(StrBuffer, 0, BufSize));
        end;
        RegCloseKey(RegKeyHandle);
    end;

begin
    // Return a list of all ICQ Database files
    Result := TStringList.Create();
    DbPaths := TStringList.Create;

    {Find Miranda-icq database files.}
    if GetMirandaFiles(DbPaths) then begin
        for i := 0 to DbPaths.Count - 1 do begin
            Result.AddObject(DBPaths[i], TObject(icqFormat_Miranda));
        end;
    end;
    DbPaths.Clear;

    {Find ICQ database files.}
    QueryReg(HKEY_LOCAL_MACHINE);
    QueryReg(HKEY_CURRENT_USER);
    if DbPaths.Count > 0 then begin
        for i := 0 to DbPaths.Count - 1 do begin
            l := TStringList.Create;
            GetDualIcqFiles(DbPaths.Strings[i],  l);
            if l.Count > 0 then begin
                for n := 0 to l.Count - 1 do begin
                    tmps := DBPaths.Strings[i] + '\' + l.Strings[n];
                    Result.AddObject(tmps, TObject(icqFormat_ICQ));
                end;
            end;
            l.Free;
        end;
    end;
    DbPaths.Free;

    if (Result.Count < 1) then begin
        Result.Free();
        Result := nil;
    end;
end;

{-----------------------------------------}
{-----------------------------------------}
{-----------------------------------------}
function GetDualIcqFiles(DbPath: String; var FList: TStringList): Boolean;
var
    fd: TWin32FindData;
    hs: THandle;
    FNames: TStringList;
    S: String;
    n: LongWord;
begin
    FList.Clear;
    FNames := TStringList.Create;

    // Find all the .dat files in the paths given
    fd.dwFileAttributes := FILE_ATTRIBUTE_NORMAL;
    hs := FindFirstFile(PChar(DbPath + '\*.*'), fd);
    if hs <> INVALID_HANDLE_VALUE then begin
        repeat
            if AnsiLowerCase(Copy(fd.cFileName,
            LastDelimiter('.', fd.cFileName) + 1,
            Length(fd.cFileName) - LastDelimiter('.', fd.cFileName))) = 'dat' then
                FNames.Add(fd.cFileName)

            else if AnsiLowerCase(Copy(fd.cFileName,
            LastDelimiter('.', fd.cFileName) + 1,
            Length(fd.cFileName) - LastDelimiter('.', fd.cFileName))) = 'idx' then
                FNames.Add(fd.cFileName);

        until not FindNextFile(hs, fd);
        Windows.FindClose(hs);
    end;

    if FNames.Count > 0 then begin
        for n := 0 to FNames.Count - 1 do begin
            if AnsiLowerCase(Copy(FNames.Strings[n],
            LastDelimiter('.', FNames.Strings[n]) + 1,
            Length(FNames.Strings[n]) - LastDelimiter('.', FNames.Strings[n]))) = 'dat' then begin
                S := Copy(FNames.Strings[n], 0, LastDelimiter('.', FNames.Strings[n]) - 1);
                if FNames.IndexOf(S + '.idx') <> -1 then
                    FList.Add(S);
            end;
        end;
    end;

    FNames.Free;
    Result := FList.Count > 0;
end;

{-----------------------------------------}
{-----------------------------------------}
{-----------------------------------------}
function GetMirandaFiles(var FList: TStringList): Boolean;
var
    fd: TWin32FindData;
    hs: THandle;
    Path: String;
    RegKeyHandle: HKEY;
    StrBuffer: array[0..2048] of Char;
    DataType, BufSize: Integer;
begin
    Path := ''; Result := False;
    DataType := REG_SZ; BufSize := SizeOf(StrBuffer) - 1;
    if (RegOpenKey(HKEY_LOCAL_MACHINE, PChar('SOFTWARE\Miranda'), RegKeyHandle) = ERROR_SUCCESS) and
    (RegQueryValueEx(RegKeyHandle, PChar('Install_Dir'), nil, @DataType, PByte(@StrBuffer), @BufSize) = ERROR_SUCCESS) then
       Path := StrBuffer;

    RegCloseKey(RegKeyHandle);

    {Exit if there is no install_dir found}
    if Path = '' then Exit;

    fd.dwFileAttributes := FILE_ATTRIBUTE_NORMAL;
    hs := FindFirstFile(PChar(Path + '\*.*'), fd);
    if hs <> INVALID_HANDLE_VALUE then begin
        repeat
            if AnsiLowerCase(Copy(fd.cFileName,
            LastDelimiter('.', fd.cFileName) + 1,
            Length(fd.cFileName) - LastDelimiter('.', fd.cFileName))) = 'dat' then begin
                FList.Add(Path + '\' + Copy(fd.cFileName, 0, LastDelimiter('.', fd.cFileName) - 1));
                Result := True;
            end;
        until not FindNextFile(hs, fd);
        Windows.FindClose(hs);
    end;
end;


end.

