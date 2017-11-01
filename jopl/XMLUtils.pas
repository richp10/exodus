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
unit XMLUtils;


interface
uses
    Unicode, XMLTag, Classes, SysUtils;

function XML_EscapeChars(txt: Widestring): Widestring;
function XML_UnEscapeChars(txt: Widestring): Widestring;

function HTML_EscapeChars(txt: Widestring; DoAPOS: boolean; DoQUOT: boolean): Widestring;
function URL_EscapeChars(txt: Widestring): Widestring;

function TrimQuotes(instring: Widestring): Widestring;
function RightChar(instring: Widestring; nchar: word): Widestring;
function LeftChar(instring: Widestring; nchar: word): Widestring;
function SToInt(inp: Widestring): integer;
function NameMatch(s1, s2: Widestring): boolean;
function Sha1Hash(fkey: Widestring): Widestring;
function MD5File(filename: Widestring): string; overload;
function MD5File(stream: TStream): string; overload;
function EncodeString(value: Widestring): Widestring;
function DecodeString(value: Widestring): Widestring;
function MungeFileName(str: Widestring): Widestring;
function MungeXMLName(str: Widestring): Widestring;
function SafeInt(str: Widestring): integer;
function SafeBool(str: Widestring): boolean;
function SafeBoolStr(value: boolean) : Widestring;

function JabberToDateTime(datestr: Widestring): TDateTime;
function XEP82DateTimeToDateTime(datestr: Widestring): TDateTime;
function DateTimeToJabber(dt: TDateTime): Widestring;
function DateTimeToXEP82Date(dt: TDateTime): Widestring;
function DateTimeToXEP82DateTime(dt: TDateTime; dtIsUTC: boolean = false): Widestring;
function DateTimeToXEP82Time(dt: TDateTime; dtIsUTC: boolean = false): Widestring;
function GetTimeZoneOffset(): Widestring;
function UTCNow(): TDateTime;
//returns a reference to a delay tag found in tag, or nil if none exists
function GetDelayTag(tag: TXMLTag): TXMLTag;

function GetAppVersion: string;

procedure ClearListObjects(l: TList);
procedure ClearStringListObjects(sl: TStringList); overload;
procedure ClearStringListObjects(sl: TWideStringList); overload;

function XPLiteEscape(value: widestring): widestring;
function generateEventMsg(tag: TXMLTag; event: widestring): TXMLTag;

procedure parseNameValues(list: TStringlist; str: Widestring);

function StringToXMLTag(input: widestring): TXMLTag;

function ErrorText(tag :TXMLTag): Widestring;

{$ifdef VER150}
    {$define INDY9}
{$endif}


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef Win32}
    Forms, Windows,
    {$else}
    QForms,
    {$endif}

    IdGlobal,
    {$ifdef INDY9}
    IdHashMessageDigest, IdHash, IdCoderMime,
    {$else}
    IdCoder3To4,
    {$endif}
    SecHash,
    JabberConst,
    XMLParser,
    StrUtils,
    DateUtils;
function XPLiteEscape(value: widestring): widestring;
var
    r: WideString;
    c: PWideChar;
    d: PWideChar;
    e: PWideChar;
    i: integer;
begin
    // Escape " to ""
    i := 0;
    c := @value[1];
    repeat
        c := StrScanW(c, WideChar(Chr(34)));
        if (c <> nil) then begin
            inc(i);
            inc(c);
        end;
    until (c = nil);

    // alloc enough
    SetLength(r, Length(value) + i);
    d := @value[1];
    e := @value[Length(value)];
    c := StrScanW(d, WideChar(Chr(34)));
    i := 1;
    while (c <> nil) do begin
        StrLCopyW(@r[i], d, c - d + 1);
        i := i + c - d + 1;
        r[i] := '"';
        inc(i);
        if (c <> e) then begin
            d := c + 1;
            c := StrScanW(d, WideChar(Chr(34)));
            end
        else begin
            d := nil;
            break;
            end;
    end;

    if (d <> nil) then
        StrLCopyW(@r[i], d, e - d + 1);
    Result := r;
end;

{---------------------------------------}
function HTML_EscapeChars(txt: Widestring; DoAPOS: boolean; DoQUOT: boolean): Widestring;
var
    tmps: Widestring;
    i: integer;
begin
    // escape special chars .. not &apos; --> only XML

    // Joe, Can we optimize this w/ regex please??
    // No.  Regexes don't do well where the replacement has to be different
    // based on the input.  Any regex would be N times slower than this.
    tmps := '';
    for i := 1 to length(txt) do begin
        if txt[i] = '&' then tmps := tmps + '&amp;'
        else if (txt[i] = Chr(39)) and (DoAPOS) then tmps := tmps + '&apos;'
        else if (txt[i] = '"') and (doQUOT) then tmps := tmps + '&quot;'
        else if txt[i] = '<' then tmps := tmps + '&lt;'
        else if txt[i] = '>' then tmps := tmps + '&gt;'
        else tmps := tmps + txt[i];
    end;
    Result := tmps;
end;

{---------------------------------------}
function URL_EscapeChars(txt: Widestring): Widestring;
var
    utxt : String;
    tmps : String;
    i : integer;
const
    az : set of char = ['a'..'z', 'A'..'Z', '0'..'9', '-', '_', '/', ':', '\', '.', '?', '@', '=', '&', '+'];
begin
    utxt := UTF8Encode(txt);
    for i := 1 to length(utxt) do begin
        if (utxt[i] in az) then
            tmps := tmps + utxt[i]
        else
            tmps := tmps + '%' + format('%02x', [ord(utxt[i])]);
    end;
    result := tmps;
end;

{---------------------------------------}
function XML_EscapeChars(txt: Widestring): Widestring;
begin
    // escape the special chars.
    Result := HTML_EscapeChars(txt, true, true);
end;

{---------------------------------------}
function XML_UnescapeChars(txt: Widestring): Widestring;
var
    tok, tmps: Widestring;
    a, i: integer;
begin
    // un-escape the special chars.
    tmps := '';
    i := 1;
    while i <= length(txt) do begin
        // amp
        if txt[i] = '&' then begin
            a := i;
            repeat
                inc(i);
            until (txt[i] = ';') or (i >= length(txt));
            tok := Copy(txt, a+1, i-a-1);
            if tok = 'amp' then tmps := tmps + '&';
            if tok = 'quot' then tmps := tmps + '"';
            if tok = 'apos' then tmps := tmps + Chr(39);
            if tok = 'lt' then tmps := tmps + '<';
            if tok = 'gt' then tmps := tmps + '>';
            inc(i);
        end
        else begin
            // normal char
            tmps := tmps + txt[i];
            inc(i);
        end;
    end;
    Result := tmps;
end;

{---------------------------------------}
function TrimQuotes(instring: Widestring): Widestring;
var
	tmps: Widestring;
begin
	{strip off first and last " or ' characters}
    tmps := Trim(instring);
    if Leftchar(tmps, 1) = '"' then
    	tmps := RightChar(tmps, length(tmps) - 1);
    if RightChar(tmps, 1) = '"' then
    	tmps := LeftChar(tmps, Length(tmps) - 1);
    if Leftchar(tmps, 1) = Chr(39) then
    	tmps := RightChar(tmps, length(tmps) - 1);
    if RightChar(tmps, 1) = Chr(39) then
    	tmps := LeftChar(tmps, Length(tmps) - 1);

    Result := tmps;
end;

{---------------------------------------}
function RightChar(instring: Widestring; nchar: word): Widestring;
var
	tmps: Widestring;
begin
	{returns the rightmost n characters of a string}
    tmps := Copy(instring, length(instring) - nchar + 1, nchar);
    Result := tmps;
end;

{---------------------------------------}
function LeftChar(instring: Widestring; nchar: word): Widestring;
var
	tmps: Widestring;
begin
	{returns the leftmost n characters of a string}
    tmps := Copy(instring, 1, nchar);
    Result := tmps;
end;

{---------------------------------------}
function SToInt(inp: Widestring): integer;
var
	tmpi: integer;
begin
    // exception safe version of StrToInt
	try
    	tmpi := StrToInt(Trim(inp));
    except on EConvertError do
    	tmpi := 0;
end;
    Result := tmpi;
end;

{---------------------------------------}
function NameMatch(s1, s2: Widestring): boolean;
begin
    Result := (StrCompW(PWideChar(s1), PWideChar(s2)) = 0);
end;

{---------------------------------------}
function Sha1Hash(fkey: Widestring): Widestring;
var
    hasher: TSecHash;
    h: TIntDigest;
    i: integer;
    s: Widestring;
begin
    // Do a SHA1 hash using the sechash.pas unit
    hasher := TSecHash.Create(nil);
    h := hasher.ComputeString(UTF8Encode(fkey));
    s := '';
    for i := 0 to 4 do
        s := s + IntToHex(h[i], 8);
    s := Lowercase(s);
    hasher.Free;
    Result := s;
end;

{$ifdef INDY9}
function MD5File(filename: Widestring): string;
var
    fstream: TFileStream;
begin
    try
        fstream := TFileStream.Create(filename, fmOpenRead or fmShareDenyNone);
        Result := MD5File(fstream);
        fStream.Free();
    except
        Result := '';
    end;
end;

function MD5File(stream: TStream): string;
var
    md: TIdHashMessageDigest5;
    Digest: T4x4LongWordRecord;
    S: String;
    pos: int64;
begin
    md := TIdHashMessageDigest5.Create();
    pos := stream.Position;
    stream.Seek(0, soFromBeginning);
    Digest := md.HashValue(stream);
    S := md.AsHex(Digest);
    Result := Lowercase(S);
    stream.Position := pos;
    md.Free();
end;

{$else}
// TODO: Do we need a version of md5file for < INDY9??
function MD5File(filename: Widestring): string;
begin
    Result := '';
end;

function MD5File(stream: TStream): string;
begin
    Result := '';
end;
{$endif}


{---------------------------------------}
function EncodeString(value: Widestring): Widestring;
var
    tmps: String;
    {$ifdef INDY9}
    e: TIdEncoderMIME;
    {$else}
    e: TIdBase64Encoder;
    {$endif}
begin
    // do base64 encode
    {$ifdef INDY9}
    e := TIdEncoderMime.Create(nil);
    tmps := e.Encode(value);
    {$else}
    e := TIdBase64Encoder.Create(nil);
    e.CodeString(value);
    tmps := e.CompletedInput();
    Fetch(tmps, ';');
    {$endif}
    e.Free();
    Result := tmps;
end;

{---------------------------------------}
function DecodeString(value: Widestring): Widestring;
var
    tmps: string;
    {$ifdef INDY9}
    d: TIdDecoderMime;
    {$else}
    d: TIdBase64Decoder;
    {$endif}
begin
    // do base64 decode
    {$ifdef INDY9}
    d := TIdDecoderMime.Create(nil);
    tmps := d.DecodeString(value);
    {$else}
    d := TIdBase64Decoder.Create(nil);
    d.CodeString(value);
    tmps := d.CompletedInput();
    Fetch(tmps, ';');
    {$endif}
    d.Free();
    Result := tmps;
end;

{---------------------------------------}
function MungeFileName(str: Widestring): Widestring;
var
    i: integer;
    c, fn: Widestring;
begin
    // Munge some string into a filename
    // Removes all chars which aren't allowed
    fn := '';
    for i := 0 to Length(str) - 1 do begin
        c := str[i + 1];
        if ( (c='@') or
             (c=':') or
             (c='|') or
             (c='<') or
             (c='>') or
             (c='\') or
             (c='/') or
             (c='*') or
             (c=' ') or
             (c=',')) then
            fn := fn + '_'
        else if (c > Chr(122)) then
            fn := fn + '_'
        else
            fn := fn + c;
    end;
    Result := fn;
end;

{---------------------------------------}
{ This function will take a string and translate it into a valid XML element name.
  NOTE: It does NOT make 100% sure that the name is valid XML as it doesn't
        check to see that the first char is a letter or - nor does it check
        to make sure the first 3 chars are not XML or some variation.  It only
        makes sure the chars are: a-z, A-Z, 0-9, -, _, .   All other chars
        are changed to _.  }
function MungeXMLName(str: Widestring): Widestring;
var
    i: integer;
    name: Widestring;
    c: Widechar;
const
    validchars : set of char = ['a'..'z', 'A'..'Z', '0'..'9', '-', '_', '.'];
begin
    // Munge some string into a filename
    // Removes all chars which aren't allowed
    name := '';
    for i := 0 to Length(str) - 1 do begin
        c := str[i + 1];
        if (c in validchars) then
        begin
            name := name + c;
        end
        else begin
            name := name + '_';
        end;
    end;
    Result := name;
end;

{---------------------------------------}
function SafeInt(str: Widestring): integer;
begin
    // Null safe string to int function
    Result := StrToIntDef(str, 0);
end;

{---------------------------------------}
function SafeBool(str: Widestring): boolean;
var
    l: Widestring;
begin
    l := trim(WideLowerCase(str));
    Result := ((l = 'yes') or (l = 'true') or (l = 'ok') or (l = '-1') or (l = '1'))
end;

{---------------------------------------}
function SafeBoolStr(value: boolean) : Widestring;
begin
    if value then
        Result := 'true'
    else
        Result := 'false';
end;

{---------------------------------------}
procedure ClearListObjects(l: TList);
var
    i: integer;
begin
    for i := 0 to l.Count - 1 do begin
        if (l[i] <> nil) then begin
            TObject(l[i]).Free();
            l[i] := nil;
        end;
    end;
end;

{---------------------------------------}
procedure ClearStringListObjects(sl: TStringList); overload;
var
    i: integer;
    o: TObject;
begin
    //
    for i := 0 to sl.Count - 1 do begin
        if (sl.Objects[i] <> nil) then begin
            o := TObject(sl.Objects[i]);
            o.Free();
            sl.Objects[i] := nil;
        end;
    end;
end;

{---------------------------------------}
procedure ClearStringListObjects(sl: TWideStringList); overload;
var
    i: integer;
    o: TObject;
begin
    //
    for i := 0 to sl.Count - 1 do begin
        if (sl.Objects[i] <> nil) then begin
            o := TObject(sl.Objects[i]);
            o.Free();
            sl.Objects[i] := nil;
        end;
    end;
end;


{---------------------------------------}
function JabberToDateTime(datestr: Widestring): TDateTime;
var
    rdate: TDateTime;
    ys, ms, ds, ts: Widestring;
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
function DateTimeToJabber(dt: TDateTime): Widestring;
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
function UTCNow(): TDateTime;
begin
    Result := Now + TimeZoneBias();
end;

{---------------------------------------}
function generateEventMsg(tag: TXMLTag; event: widestring): TXMLTag;
var
    m, e: TXMLTag;
begin
    m := TXMLTag.Create('message');
    m.setAttribute('to', tag.getAttribute('from'));
    m.setAttribute('from', tag.getAttribute('to'));
    e := m.AddTag('x');
    e.setAttribute('xmlns', 'jabber:x:event');
    e.AddBasicTag('id', tag.getAttribute('id'));
    e.AddTag(event);
    Result := m;
end;

{---------------------------------------}
procedure parseNameValues(list: TStringlist; str: Widestring);
var
    i: integer;
    q: boolean;
    n,v: Widestring;
    ns, vs: integer;
begin
    // Parse a list of:
    // foo="bar",thud="baz"
    // 12345678901234567890

    // foo=bar,
    // 12345678

    // ns = 1
    // vs = 5
    // i = 9
    ns := 1;
    vs := 1;
    q := false;
    for i := 0 to Length(str) - 1 do begin
        if (not q) then begin
            if (str[i] = ',') then begin
                // end of name-value pair
                if (v = '') then
                    v := Copy(str, vs, i - vs);
                list.Add(n);
                list.Values[n] := v;
                ns := i + 1;
                n := '';
                v := '';
            end
            else if (str[i] = '"') then begin
                // if we are quoting... start here
                q := true;
                vs := i + 1;
            end
            else if (str[i] = '=') then begin
                // end of name, start of value
                n := Copy(str, ns, i - ns);
                vs := i + 1;
            end;
        end
        else if (str[i] = '"') then begin
            v := Copy(str, vs, i - vs);
            q := false;
        end;
    end;
end;

{---------------------------------------}
function StringToXMLTag(input: widestring): TXMLTag;
var
    parser: TXMLTagParser;
begin
    Result := nil;
    if (input = '') then exit;

    parser := nil;
    try
        try
            // Input MUST be valid XML
            parser := TXMLTagParser.Create;
            parser.ParseString(input, '');
            Result := parser.popTag();
        except

        end;
    finally
        parser.Free();
    end;
end;

{---------------------------------------}
{$ifdef Win32}
function GetAppVersion: string;
const
    InfoNum = 10;
    InfoStr : array [1..InfoNum] of String =
        ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName',
        'LegalCopyright', 'LegalTradeMarks', 'OriginalFilename',
        'ProductName', 'ProductVersion', 'Comments');
var
    S: string;
    n: dword;
    Len: UINT;
    i: Integer;
    Buf: PChar;
    Value: PChar;
    keyList: TStringList;
    valList: TStringList;
begin

    Result := '';

    KeyList := TStringlist.create;
    ValList := TStringlist.create;

    S := Application.ExeName;
    n := GetFileVersionInfoSize(PChar(S),n);
    if n > 0 then begin
        Buf := AllocMem(n);
        GetFileVersionInfo(PChar(S),0,n,Buf);
        if VerQueryValue(Buf,PChar('StringFileInfo\040904B0\'+ InfoStr[3]),Pointer(Value),Len) then
            Result := Value;
        for i:=1 to InfoNum do begin
            if VerQueryValue(Buf,PChar('StringFileInfo\040904B0\'+ InfoStr[i]),Pointer(Value),Len) then begin
                KeyList.Add(InfoStr[i]);
                ValList.Add(Value);
            end;
        end;
        FreeMem(Buf,n);
    end
    else
        Result := '';

    keylist.Free;
    vallist.Free;
end;

{$else}
function GetAppVersion: string;
begin
    result := '1.0';
end;
{$endif}

function ErrorText(tag: TXMLTag): Widestring;
var
    child: TXMLTag;
    ns: Widestring;
begin
    Result := '';
    child := tag.GetFirstTag('text');
    if (child <> nil) then begin
        ns := child.Namespace();

        if (ns = 'urn:ietf:params:xml:ns:xmpp-streams') then
            Result := child.Data
        else if (ns = 'urn:ietf:params:xml:ns:xmpp-streams') then
            Result := child.Data;
    end;

    if Result = '' then
        Result := tag.Data;
end;

//returns a reference to a delay tag found in tag, or nil if none exists
function GetDelayTag(tag: TXMLTag): TXMLTag;
begin
    Result := tag.QueryXPTag(XP_MSGDELAY_203);
    if (Result = nil) then
        Result := tag.QueryXPTag(XP_MSGDELAY);
end;


end.
