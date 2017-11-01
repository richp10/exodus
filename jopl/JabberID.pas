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
unit JabberID;


interface

uses
    SysUtils, StrUtils, Classes, TntSysUtils;

type
    TJabberID = class
    private
        _raw: widestring;
        _userDisplay: widestring;
        _user: widestring;
        _domain: widestring;
        _resource: widestring;
        _valid: boolean;

    public
        constructor Create(jid: widestring; isEscaped: boolean = true); overload;
        constructor Create(user: widestring; domain: widestring; resource: widestring); overload;
        constructor Create(user: widestring; domain: widestring; resource: widestring; userDisplay: widestring); overload;
        constructor Create(jid: TJabberID); overload;

        function jid: widestring;
        function full: widestring;
        function compare(sjid: widestring; resource: boolean): boolean;
class   function applyJEP106(unescapedUser: widestring): widestring;
class   function removeJEP106(escapedUser: widestring): widestring;

        function getDisplayFull: widestring;
        function getDisplayJID: widestring;

        procedure ParseJID(jid: widestring; isEscaped: boolean = true);

        property user: widestring read _user;
        property userDisplay: widestring read _userDisplay;
        property domain: widestring read _domain;
        property resource: widestring read _resource;

        property isValid: boolean read _valid;
end;
function lastIndexOf(const s :widestring; const substr: widestring): integer;
function isValidJID(jid: Widestring; isEscaped: boolean = false): boolean;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Stringprep;

{
    \brief Determines if the given string is a valid JID.

    This method determines if the supplied string is a valid JID.  The optional
    parameter indicates if the user portion has already been escaped. The
    default value of the optional parameter is false to match the assumptions
    made by the Create(widestring) method (assumes it's invalid by default).

    A false return value may indicate JEP106 escaping needs to be applied.

    \param jid The string representing the JID to check.
    \param isEscaped Defaulted to false - use true if JEP106 escaping has been applied.
    \return True if is a valid JID, False if invalid.
}
function isValidJID(jid: Widestring; isEscaped: boolean = false): boolean;
var
    curlen, part, i, p1, p2: integer;
    c: Cardinal;
    valid_char: boolean;
    tmps: widestring;
begin
    Result := false;

    tmps := jid;

    if (isEscaped) then begin
        // If escaped 1st / and @ are the resource and node separators
        p1 := WideTextPos('@', jid);
        p2 := WideTextPos('/', jid);
    end
    else begin
        // If not escaped then 1st / after last @ is the separator
        p1 := lastIndexOf(jid, '@');
        p2 := lastIndexOf(jid, '/');
    end;

    if (p1 >= 0) then part := 0 else part := 1;

    curlen := 0;
    for i := 1 to Length(jid) do begin
        c := Ord(jid[i]);
        valid_char := false;
        if ((i = p1) and (part = 0)) then begin
            part := 1;
            curlen := 0;
        end
        else if ((i = p2) and (p2 > p1) and (part < 2)) then begin
            part := 2;
            curlen := 0;
        end
        else begin
            inc(curlen);
            case part of
            0: begin
                if (isEscaped = true) then begin
                    // user or domain
                    case c of
                    $21, $23..$25, $28..$2E,
                    $30..$39, $3B, $3D, $3F,
                    $41..$7E, $80..$D7FF,
                    $E000..$FFFD, $10000..$10FFFF: valid_char := true;
                    end;
                end
                else begin
                    case c of
                    $20..$7E, $80..$D7FF,
                    $E000..$FFFD, $10000..$10FFFF: valid_char := true;
                    end;
                end;
                if (not valid_char) then exit;
                if (curlen > 256) then exit;
            end;
            1: begin
                // domain
                case c of
                $2D, $2E, $30..$39, $5F, $41..$5A, $61..$7A: valid_char := true;
                end;
                if (not valid_char) then exit;
                if (curlen > 256) then exit;
            end;
            2: begin
                // resource
                case c of
                $20..$D7FF, $E000..$FFFD,
                $10000..$10FFFF: valid_char := true;
                end;

                if (not valid_char) then exit;
                if (curlen > 256) then exit;
            end;
        end;

        end;
    end;
    Result := true;
end;

{---------------------------------------}
constructor TJabberID.Create(jid: widestring; isEscaped: boolean = true);
begin
    // parse the jid
    // user@domain/resource
    inherited Create();

    _raw := jid;
    _user := '';
    _userDisplay := '';
    _domain := '';
    _resource := '';

    if (_raw <> '') then ParseJID(_raw, isEscaped);
end;

constructor TJabberID.Create(user: widestring; domain: widestring; resource: widestring);
begin
    inherited Create();

    _raw := '';
    _user := user;
    _userDisplay := removeJEP106(user);
    _domain := domain;
    _resource := resource;
end;

constructor TJabberID.Create(user: widestring; domain: widestring; resource: widestring; userDisplay: widestring);
begin
    inherited Create();

    _raw := '';
    _user := user;
    _userDisplay := userDisplay;
    _domain := domain;
    _resource := resource;
end;

constructor TJabberID.Create(jid: TJabberID);
begin
    inherited Create();

    _raw := jid._raw;
    _user := jid._user;
    _userDisplay := jid._userDisplay;
    _domain := jid._domain;
    _resource := jid._resource;
end;

{---------------------------------------}
procedure TJabberID.ParseJID(jid: widestring; isEscaped: boolean = true);
var
    tmps: WideString;
    p1, p2: integer;
    pnode, pname, pres: Widestring;
begin
    _user := '';
    _userDisplay := '';
    _domain := '';
    _resource := '';
    _raw := jid;

    if (isEscaped) then begin
        // If escaped 1st / and @ are the resource and node separators
        p1 := WideTextPos('@', _raw);
        p2 := WideTextPos('/', _raw);
    end
    else begin
        // If not escaped then 1st / after last @ is the separator
        p1 := lastIndexOf(_raw, '@');
        p2 := lastIndexOf(_raw, '/');
    end;

    tmps := _raw;
    if ((p2 > 0) and (p2>p1)) then begin
        // pull off the resource..
        _resource := Copy(tmps, p2 + 1, length(tmps) - p2 + 1);
        tmps := Copy(tmps, 1, p2 - 1);
    end;

    if p1 > 0 then begin
        _domain := Copy(tmps, p1 + 1, length(tmps) - p1 + 1);
        _user := Copy(tmps, 1, p1 - 1);
    end
    else
        _domain := tmps;

    // apply JEP-106 to user portion & save display value
    if (not isEscaped) then begin
        _userDisplay := _user;
        _user := applyJEP106(_user);
    end
    else begin
        _userDisplay := removeJEP106(_user);
    end;


    // prep all parts to normalize
    if (_user <> '') then begin
        pnode := xmpp_nodeprep(_user);
        if (pnode = '') then begin
            _valid := false;
            exit;
        end;
        _user := pnode;
    end;

    pname := xmpp_nameprep(_domain);
    if (pname = '') then begin
        _valid := false;
        exit;
    end;
    _domain := pname;

    if (_resource <> '') then begin
        pres := xmpp_resourceprep(_resource);
        if (pres = '') then begin
            _valid := false;
            exit;
        end;
        _resource := pres;
    end;

    _valid := true;
end;

{---------------------------------------}
class function TJabberID.applyJEP106(unescapedUser: widestring): widestring;
var
    escapedUser: widestring;
    options       : TReplaceFlags;

    function replaceEscape(input: Widestring): Widestring;
    var
        test, replace: Widestring;
        idx: Integer;
    begin
        Result := '';
        while (input <> '') do begin
            idx := Pos('\', input);

            if (idx = 0) then break;
            replace := '\';
            test := Tnt_WideUpperCase(Copy(input, idx, 3));
            if      (test = '\20') or
                    (test = '\22') or
                    (test = '\26') or
                    (test = '\27') or
                    (test = '\2F') or
                    (test = '\3A') or
                    (test = '\3C') or
                    (test = '\3E') or
                    (test = '\40') or
                    (test = '\5C') then begin
                replace := '\5C'
            end;

            Result := Result + Copy(input, 1, idx - 1) + replace;
            input := Copy(input, idx + 1, Length(input));
        end;

        Result := Result + input;
    end;
begin
   options := [rfReplaceAll, rfIgnoreCase];
   //Treat '\' special:  only escape if followed by a valid escape pair
   escapedUser := replaceEscape(unescapedUser);
   escapedUser := Tnt_WideStringReplace(escapedUser, ' ', '\20', options);
   escapedUser := Tnt_WideStringReplace(escapedUser, '"', '\22', options);
   escapedUser := Tnt_WideStringReplace(escapedUser, '&', '\26', options);
   escapedUser := Tnt_WideStringReplace(escapedUser, '''', '\27', options);
   escapedUser := Tnt_WideStringReplace(escapedUser, '/', '\2F', options);
   escapedUser := Tnt_WideStringReplace(escapedUser, ':', '\3A', options);
   escapedUser := Tnt_WideStringReplace(escapedUser, '<', '\3C', options);
   escapedUser := Tnt_WideStringReplace(escapedUser, '>', '\3E', options);
   escapedUser := Tnt_WideStringReplace(escapedUser, '@', '\40', options);

   Result := escapedUser;
end;

{---------------------------------------}
class function TJabberID.removeJEP106(escapedUser: widestring): widestring;
var
    unescapedUser: widestring;
    options       : TReplaceFlags;
begin
   options := [rfReplaceAll, rfIgnoreCase];
   unescapedUser := Tnt_WideStringReplace(escapedUser, '\20', ' ', options);
   unescapedUser := Tnt_WideStringReplace(unescapedUser, '\22', '"', options);
   unescapedUser := Tnt_WideStringReplace(unescapedUser, '\26', '&', options);
   unescapedUser := Tnt_WideStringReplace(unescapedUser, '\27', '''', options);
   unescapedUser := Tnt_WideStringReplace(unescapedUser, '\2F', '/', options);
   unescapedUser := Tnt_WideStringReplace(unescapedUser, '\3A', ':', options);
   unescapedUser := Tnt_WideStringReplace(unescapedUser, '\3C', '<', options);
   unescapedUser := Tnt_WideStringReplace(unescapedUser, '\3E', '>', options);
   unescapedUser := Tnt_WideStringReplace(unescapedUser, '\40', '@', options);
   unescapedUser := Tnt_WideStringReplace(unescapedUser, '\5C', '\', options);
   Result := unescapedUser;
end;

{---------------------------------------}
function TJabberID.getDisplayJID: widestring;
begin
    // return the _user@_domain
    if _userDisplay <> '' then
        Result := _userDisplay + '@' + _domain
    else
        Result := _domain;
end;

{---------------------------------------}
function TJabberID.getDisplayFull: widestring;
begin
    // return the _user@_domain
    if _userDisplay <> '' then
        Result := _userDisplay + '@' + _domain
    else
        Result := jid;
    if (_resource <> '') then
        result := Result + '/' + _resource;
end;

{---------------------------------------}
function TJabberID.jid: widestring;
begin
    // return the _user@_domain
    if _user <> '' then
        Result := _user + '@' + _domain
    else
        Result := _domain;
end;

{---------------------------------------}
function TJabberID.Full: widestring;
begin
    if _resource <> '' then
        Result := jid + '/' + _resource
    else
        Result := jid;
end;

{---------------------------------------}
function TJabberID.compare(sjid: widestring; resource: boolean): boolean;
begin
    // compare the 2 jids for equality
    Result := false;
end;
{
    \brief This method searches s for the last occurance of substr.

    This method searches s for the last occurance of substr.

    \param s The string to search.
    \param substr The substring to find in given string.
    \return The index of the last occurance of substr (0 if not found).
}
function lastIndexOf(const s :widestring; const substr: widestring): integer;
var
  idx, tmp: integer;
  tmps: widestring;
begin
    Result := 0;
    idx    := 0;
    tmp    := 0;
    tmps   := s;

    if (length(s) = 0) then
      exit;

    repeat
        idx  := idx + tmp;
        tmps := Copy(tmps, tmp+1, length(tmps)- tmp + 1);
        tmp  := Pos(substr,tmps);
    until tmp = 0;
    Result := idx;
end;

end.

