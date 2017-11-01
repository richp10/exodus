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
unit SQLUtils;


interface

uses
    Unicode,
    Classes,
    SysUtils;

    function SafeInt(str: Widestring): integer;
    function str2sql(str: string): string;
    function sql2str(str: string): string;
    function unquoteStr(str: string; qchar: string = #39): string;
    function quoteStr(str: string; qchar: string = #39): string;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation


{---------------------------------------}
function SafeInt(str: Widestring): integer;
begin
    // Null safe string to int function
    Result := StrToIntDef(str, 0);
end;


{---------------------------------------}
function str2sql(str: string): string;
var
    i: integer;
begin
    Result := sql2str(str);
    for i := Length(Result) downto 1 do begin
        if (Result[i] = #39) then
            Insert(#39, Result, i);
    end;
    //Result := QuoteStr(Result);
end;

{---------------------------------------}
function sql2str(str: string): string;
const
    dblq: string = #39#39;
var
    p: integer;
begin
    Result := str;
    p := Pos(dblq, Result);
    while (p > 0) do begin
        Delete(Result, p, 1);
        p := pos(dblq, Result);
    end;
    Result := unquoteStr(Result);
end;

{---------------------------------------}
function unquoteStr(str: string; qchar: string): string;
begin
    Result := str;
    if (Length(Result) > 1) then begin
        if (Result[1] = qchar) then
            Delete(Result, 1, 1);
        if (Result[Length(Result)] = qchar) then
            Delete(Result, Length(Result), 1);
    end;
end;

{---------------------------------------}
function quoteStr(str: string; qchar: string): string;
begin
    Result := ConCat(qchar, str, qchar);
end;




end.
