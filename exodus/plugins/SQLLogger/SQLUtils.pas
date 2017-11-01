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
    Dialogs;

function str2sql(str: string): string;
function sql2str(str: string): string;
function unquoteStr(str: string; qchar: string = #39): string;
function quoteStr(str: string; qchar: string = #39): string;
function SafeInt(str: Widestring): integer;
function MessageDlgW(const Msg: Widestring; DlgType: TMsgDlgType;Buttons: TMsgDlgButtons): Word;
function JabberToDateTime(datestr: Widestring): TDateTime;

implementation
uses
    Windows, Forms, Controls, SysUtils, Classes,
    IdGlobal;

    
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
    for i := Length(Result) - 1 downto 0 do begin
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

{
    Copied from XMLUtils to eliminate that dependancy
}
{---------------------------------------}
function JabberToDateTime(datestr: Widestring): TDateTime;
var
    rdate: TDateTime;
    ys, ms, ds, ts: Widestring;
    yw, mw, dw: Word;
begin
    // translate date from 20000110T19:54:00 to proper format..
    ys := Copy(Datestr, 1, 4);
    ms := Copy(Datestr, 5, 2);
    ds := Copy(Datestr, 7, 2);
    ts := Copy(Datestr, 10, 8);

    try
        yw := StrToInt(ys);
        mw := StrToInt(ms);
        dw := StrToInt(ds);

        if (TryEncodeDate(yw, mw, dw, rdate)) then begin
            rdate := rdate + StrToTime(ts);
            Result := rdate - TimeZoneBias();
        end
        else
            Result := Now();
    except
        Result := Now;
    end;
end;

{
    Copied from JabberUtils to remove the dependancy
}
{---------------------------------------}
function MessageDlgW(const Msg: Widestring; DlgType: TMsgDlgType;Buttons: TMsgDlgButtons): Word;
var
    flags: Word;
    res: integer;
    tstr : WideString;
begin
    flags := 0;
    case DlgType of
    mtWarning:          flags := flags + MB_ICONWARNING;
    mtError:            flags := flags + MB_ICONERROR;
    mtInformation:      flags := flags + MB_ICONINFORMATION;
    mtConfirmation:     flags := flags + MB_ICONQUESTION;
    end;

    {
    TMsgDlgBtn = (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore,
        mbAll, mbNoToAll, mbYesToAll, mbHelp);
    }
    if (Buttons = [mbYes, mbNo, mbCancel]) then
        flags := flags or MB_YESNOCANCEL
    else if (Buttons = [mbYes, mbNo]) then
        flags := flags or MB_YESNO
    else if (Buttons = [mbOK]) then
        flags := flags or MB_OK
    else if (Buttons = [mbOK, mbCancel]) then
        flags := flags or MB_OKCANCEL
    else
        flags := flags or MB_OK;

//commneted out to remove dependancy on prefcontroller
//    {$ifdef EXODUS}
//    res := MessageBoxW(Application.Handle, PWideChar(Msg), PWideChar(PrefController.getAppInfo.Caption),
//        flags);
//    {$else}
    tstr := Application.Title;
    res := MessageBoxW(Application.Handle, PWideChar(Msg), PWideChar(tstr), flags);
//    {$endif}

    case res of
    IDCANCEL: Result := mrCancel;
    IDNO: Result := mrNo;
    IDYES: Result := mrYes;
    else
        Result := mrOK;
    end;

end;


end.
