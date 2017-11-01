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
unit JabberUtils;

interface
uses
    Unicode,
    {$ifdef EXODUS}
    PrefController,
    {$endif}
    XMLTag,
    Dialogs,
    Graphics,
    Classes,
    SysUtils;

function jabberIQResult(orig: TXMLTag): TXMLTag;
function jabberIQError(orig: TXMLTag): TXMLTag;
function JabberToDateTime(datestr: string): TDateTime;
function XEP82DateTimeToDateTime(datestr: Widestring): TDateTime;
function DateTimeToJabber(dt: TDateTime): string;
function DateTimeToXEP82Date(dt: TDateTime): Widestring;
function DateTimeToXEP82DateTime(dt: TDateTime; dtIsUTC: boolean = false): Widestring;
function DateTimeToXEP82Time(dt: TDateTime; dtIsUTC: boolean = false): Widestring;
function GetTimeZoneOffset(): Widestring;
function UTCNow(): TDateTime;
function ColorToHTML(Color: TColor): string;
function MessageDlgW(const Msg: Widestring; DlgType: TMsgDlgType;
    Buttons: TMsgDlgButtons; HelpCtx: Longint; Caption: Widestring = ''): Word;
function percentDecode(encoded: string; escape: boolean = false): Widestring;

procedure split(value: WideString; list: TWideStringList; seps : WideString = ' '#9#10#13);
procedure WordSplit(value: WideString; list: TWideStringList);

function UnicodePosNoCase(const substr: widestring; const str: widestring): integer;

implementation
uses
    {$ifdef EXODUS}
    GnuGetText,
    {$endif}
    Controls,
    Types,
    Forms,
    Windows,
    IdGlobal, // IdGlobal provides TimeZoneBias() for us
    StrUtils,
    DateUtils,
    stringprep;

{---------------------------------------}
function jabberIQResult(orig: TXMLTag): TXMLTag;
begin
    //
    Result := TXMLTag.Create('iq');
    Result.setAttribute('to', orig.getAttribute('from'));
    Result.setAttribute('id', orig.getAttribute('id'));
    Result.setAttribute('type', 'result');
end;

{---------------------------------------}
function jabberIQError(orig: TXMLTag): TXMLTag;
begin
    //
    Result := jabberIQResult(orig);
    Result.setAttribute('type', 'error');
end;

{---------------------------------------}
function JabberToDateTime(datestr: string): TDateTime;
var
    rdate: TDateTime;
    ys, ms, ds, ts: string;
    yw, mw, dw: Word;
begin
    // Converts assumed UTC time to local.
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
            Result := rdate - TimeZoneBias(); // Convert to local time
        end
        else
            Result := Now();
    except
        Result := Now;
    end;
end;

{---------------------------------------}
function XEP82DateTimeToDateTime(datestr: Widestring): TDateTime;
var
    rdate: TDateTime;
    ys, ms, ds, ts: Widestring;
    yw, mw, dw: Word;
    tzd: Widestring;
    tzd_hs: Widestring;
    tzd_ms: Widestring;
    tzd_hw: word;
    tzd_mw: word;
begin
    // Converts UTC or TZD time to Local Time
    // translate date from 2008-06-11T10:10:23.102Z (2008-06-11T10:10:23.102-06:00) or to properformat
    Result := Now();

    datestr := Trim(datestr);
    if (Length(datestr) = 0) then exit;

    ys := Copy(datestr, 1, 4);
    ms := Copy(datestr, 6, 2);
    ds := Copy(datestr, 9, 2);
    ts := Copy(datestr, 12, 8);

    if (RightStr(datestr, 1) = 'Z') then
    begin
        // Is UTC
        try
            yw := StrToInt(ys);
            mw := StrToInt(ms);
            dw := StrToInt(ds);

            if (TryEncodeDate(yw, mw, dw, rdate)) then begin
                rdate := rdate + StrToTime(ts);
                Result := rdate - TimeZoneBias(); // Convert to local time
            end
            else
                Result := Now();
        except
            Result := Now;
        end;
    end
    else begin
        // Is not UTC so convert to UTC
        tzd := Copy(datestr, Length(datestr) - 5, 6);
        tzd_hs := Copy(tzd, 2, 2);
        tzd_ms := Copy(tzd, 5, 2);

        try
            yw := StrToInt(ys);
            mw := StrToInt(ms);
            dw := StrToInt(ds);
            tzd_hw := StrToInt(tzd_hs);
            tzd_mw := StrToInt(tzd_ms);

            if (TryEncodeDate(yw, mw, dw, rdate)) then
            begin
                rdate := rdate + StrToTime(ts);
                // modify time for TZD offset.
                if (LeftStr(tzd, 1) = '+') then
                begin
                    // Time is greater then UTC so subtract time
                    rdate := IncHour(rdate, (-1 * tzd_hw));
                    rdate := IncMinute(rdate, (-1 * tzd_mw));
                end
                else begin
                    // Time is less then UTC so add time
                    rdate := IncHour(rdate, tzd_hw);
                    rdate := IncMinute(rdate, tzd_mw);
                end;

                // Now that we have UTC, change ot local
                Result := rdate - TimeZoneBias();
            end
            else begin
                Result := Now();
            end;
        except
            Result := Now();
        end;
    end;

end;

{---------------------------------------}
function DateTimeToJabber(dt: TDateTime): string;
begin
    // Format the current date/time into "Jabber" format
    Result := FormatDateTime('yyyymmdd', dt);
    Result := Result + 'T';
    Result := Result + FormatDateTime('hh:nn:ss', dt);
end;

{---------------------------------------}
function DateTimeToXEP82Date(dt: TDateTime): Widestring;
begin
    Result := FormatDateTime('yyyy-mm-dd', dt);
end;

{---------------------------------------}
function DateTimeToXEP82DateTime(dt: TDateTime; dtIsUTC: boolean): Widestring;
begin
    Result := DateTimeToXEP82Date(dt);
    Result := Result + 'T';
    Result := Result + DateTimeToXEP82Time(dt, dtIsUTC);
end;

{---------------------------------------}
function DateTimeToXEP82Time(dt: TDateTime; dtIsUTC: boolean): Widestring;
begin
    // Convert Time
    Result := FormatDateTime('hh:mm:ss.zzz', dt);

    // Add on Offset info
    if (dtIsUTC) then
    begin
        Result := Result + 'Z';
    end
    else begin
        Result := Result + GetTimeZoneOffset();
    end;
end;

{---------------------------------------}
function GetTimeZoneOffset(): Widestring;
var
    UTCoffset: integer;
    UTCoffsetHours, UTCoffsetMinutes: integer;
    TZI: TTimeZoneInformation;
begin
    Result := '';

    // Compute Timezone offset from GMT
    case GetTimeZoneInformation(TZI) of
        TIME_ZONE_ID_STANDARD: UTCOffset := (TZI.Bias + TZI.StandardBias);
        TIME_ZONE_ID_DAYLIGHT: UTCOffset := (TZI.Bias + TZI.DaylightBias);
        TIME_ZONE_ID_UNKNOWN: UTCOffset := TZI.Bias;
    else
        UTCOffset := 0;
    end;
    UTCoffsetHours := UTCoffset div 60; //TZI.Bias in minutes
    UTCoffsetMinutes := UTCoffset mod 60; //TZI.Bias in minutes

    if (UTCoffsetHours <= 0) then
    begin
        Result := Result + '+'
    end
    else begin
        Result := Result + '-';
    end;
    Result := Result + Format('%.2d:%.2d',[abs(UTCoffsetHours), abs(UTCOffsetMinutes)]);
end;

{---------------------------------------}
function ColorToHTML( Color: TColor): string;
var
    rgb: longint;
begin
    rgb := ColorToRGB(Color);
    result := Format( '#%.2x%.2x%.2x', [ GetRValue(rgb),
                GetGValue(rgb), GetBValue(rgb)]);
end;

{---------------------------------------}
procedure split(value: WideString; list: TWideStringList; seps : WideString = ' '#9#10#13);
var
    i, l : integer;
    tmps : WideString;
begin
    tmps := Trim(value);
    l := 1;
    while l <= length(tmps) do begin
        // search for the first non-space
        while ((l <= length(tmps)) and (pos(tmps[l], seps) > 0)) do
            inc(l);

        if l > length(tmps) then exit;
        i := l;

        // search for the first space
        while (i <= length(tmps)) and (pos(tmps[i], seps) <=0) do
            inc(i);

        list.Add(Copy(tmps, l, i - l));
        l := i + 1;

    end;
end;

{---------------------------------------}
procedure WordSplit(value: WideString; list: TWideStringList);
var
    i, l : integer;
    tmps : WideString;
begin
    tmps := Trim(value);
    l := 1;
    while l <= length(tmps) do begin
        // search for the first non-space
        while (
            (l <= length(tmps)) and
            (UnicodeIsSeparator(Ord(tmps[l]))) and
            (UnicodeIsWhiteSpace(Ord(tmps[l])))) do
            inc(l);

        if l > length(tmps) then exit;
        i := l;

        // search for the first space
        while (i <= length(tmps)) and
            (not UnicodeIsSeparator(Ord(tmps[i]))) and
            (not UnicodeIsWhiteSpace(Ord(tmps[i]))) do
            inc(i);

        list.Add(Copy(tmps, l, i - l));
        l := i + 1;

    end;
end;

{---------------------------------------}
function UTCNow(): TDateTime;
begin
    Result := Now + TimeZoneBias();
end;

{---------------------------------------}
function MessageDlgW(const Msg: Widestring; DlgType: TMsgDlgType;
    Buttons: TMsgDlgButtons; HelpCtx: Longint; Caption: Widestring): Word;
var
    flags: Word;
    res: integer;
    {$ifdef EXODUS}
    tempstring: widestring;
    {$endif}
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

    {$ifdef EXODUS}
    tempstring := PrefController.getAppInfo.Caption;
    if (Caption <> '') then
        tempstring := tempstring + ' - ' + Caption;
    res := MessageBoxW(Application.Handle, PWideChar(Msg), PWideChar(tempstring),
        flags);
    {$else}
    res := MessageBoxW(Application.Handle, PWideChar(Msg), PWideChar(Caption),
        flags);
    {$endif}

    case res of
    IDCANCEL: Result := mrCancel;
    IDNO: Result := mrNo;
    IDYES: Result := mrYes;
    else
        Result := mrOK;
    end;

end;

{---------------------------------------}
function percentDecode(encoded: string; escape: boolean): Widestring;
const
    // each hex digit, -1 for non-hex
    Convert: array['0'..'f'] of SmallInt =
        ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1,
         -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,
         -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
         -1,10,11,12,13,14,15);
var
    tmp: UTF8String;
    i: integer;
    len: integer;
begin
    tmp := '';
    i := 1;
    len := Length(encoded);
    while i <= len do begin
        if (encoded[i] = '%') then begin
            if i + 2 > len then break;
            if not (encoded[i+1] in ['0'..'f']) or not (encoded[i+2] in ['0'..'f']) then break;

            tmp := tmp + Char((Convert[encoded[i+1]] shl 4) + Convert[encoded[i + 2]]);
            inc(i, 2);
        end
        else
            if escape then begin
                if encoded[i] = '&' then
                    tmp := tmp + '#26;'
                else if encoded[i] = '/' then
                    tmp := tmp + '#2f;'
                else
                    tmp := tmp + encoded[i];
            end
            else
                tmp := tmp + encoded[i];

        inc(i);
    end;
    result := UTF8Decode(tmp);
end;

function UnicodePosNoCase(const substr: widestring; const str: widestring): integer;
var
    substrprep: widestring;
    mainstrprep: widestring;
begin
    substrprep := jabber_nameprep_variablelen(substr);
    mainstrprep := jabber_nameprep_variablelen(str);

    Result := Pos(substrprep, mainstrprep);
end;

end.
