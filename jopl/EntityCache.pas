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
unit EntityCache;


interface
uses
    {$ifdef Exodus}
    TntClasses,
    {$endif}
    JabberID, Entity, Session, Unicode, Classes, SysUtils;

type
    TJabberEntityCache = class
    private
        _cache: TWidestringlist;

        function _getEntity(i: integer): TJabberEntity;

    public
        constructor Create();
        destructor Destroy(); override;

        procedure Clear();
        procedure Add(jid: Widestring; e: TJabberEntity);overload;
        procedure Add(jid: TJabberID; e: TJabberEntity);overload;
        procedure Remove(e: TJabberEntity);
        procedure RemoveJid(jid: Widestring; node: Widestring = '');
        procedure Delete(i: integer);

        function getByJid(jid: Widestring; node: Widestring = ''): TJabberEntity;
        function fetch(jid: Widestring; js: TJabberSession;
            items_limit: boolean = true; node: Widestring = ''): TJabberEntity;
        function discoInfo(jid: Widestring; js: TJabberSession;
            node: Widestring = ''; timeout: integer = -1): TJabberEntity;
        function discoItems(jid: Widestring; js: TJabberSession;
            node: Widestring = ''; timeout: integer = -1): TJabberEntity;

        function getFirstFeature(f: Widestring): TJabberEntity;
        function getFirstSearch(): Widestring;
        function getFirstGroupchat(): Widestring;

        {$ifdef Exodus}
        procedure getByFeature(f: Widestring; jid_list: TWidestringList); overload;
        procedure getByFeature(f: Widestring; jid_list: TTntStrings); overload;
        {$else}
        procedure getByFeature(f: Widestring; jid_list: TWidestringList);
        {$endif}

        {$ifdef Exodus}
        procedure getByIdentity(icat, itype: Widestring; jid_list: TTntStrings); overload;
        procedure getByIdentity(icat, itype: Widestring; jid_list: TWidestringlist); overload;
        {$else}
        procedure getByIdentity(icat, itype: Widestring; jid_list: TWidestringlist);
        {$endif}

        function toString(): widestring;

        function indexOf(e: TJabberEntity): integer;

        property Entities[index: integer]: TJabberEntity read _getEntity;
    end;

var
    jEntityCache: TJabberEntityCache;

function EntityJidCompare(Item1, Item2: Pointer): integer;
function EntityNameCompare(Item1, Item2: Pointer): integer;
function EntityCatCompare(Item1, Item2: Pointer): integer;
function EntityDomainCompare(Item1, Item2: Pointer): integer;

function EntityJidCompareRev(Item1, Item2: Pointer): integer;
function EntityNameCompareRev(Item1, Item2: Pointer): integer;
function EntityCatCompareRev(Item1, Item2: Pointer): integer;
function EntityDomainCompareRev(Item1, Item2: Pointer): integer;


implementation
uses
    XMLUtils;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function _entityCompare(cur_sort: integer; ascending: boolean; Item1, Item2: Pointer): integer;
var
    j1, j2: TJabberEntity;
    s1, s2, s3, s4: Widestring;
begin
    // compare 2 items..
    if (cur_sort = -1) then begin
        Result := 0;
        exit;
    end;

    j1 := TJabberEntity(Item1);
    j2 := TJabberEntity(Item2);
    s3 := '';
    s4 := '';

    case (cur_sort) of
    0: begin
        s1 := j1.name;
        s2 := j2.name;
        end;
    1: begin
        s1 := j1.jid.full;
        s2 := j2.jid.full;
        end;
    2: begin
        s1 := j1.catType;
        s2 := j2.catType;
        end;
    3: begin
        s1 := j1.jid.domain;
        s2 := j2.jid.domain;
        s3 := j1.jid.user;
        s4 := j2.jid.user;
        end
    else begin
        Result := 0;
        exit;
        end;
    end;

    if (ascending) then
        Result := AnsiCompareText(s1, s2)
    else
        Result := AnsiCompareText(s2, s1);

    if ((Result = 0) and (s3 <> '') and (s4 <> '')) then begin
        if (ascending) then
            Result := AnsiCompareText(s3, s4)
        else
            Result := AnsiCompareText(s4, s3);
    end;

end;


// Just call _entityCompare
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function EntityJidCompare(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(1, true, Item1, Item2);
end;
function EntityNameCompare(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(0, true, Item1, Item2);
end;
function EntityCatCompare(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(2, true, Item1, Item2);
end;
function EntityJidCompareRev(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(1, false, Item1, Item2);
end;
function EntityNameCompareRev(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(0, false, Item1, Item2);
end;
function EntityCatCompareRev(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(2, false, Item1, Item2);
end;
function EntityDomainCompare(Item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(3, true, Item1, Item2);
end;
function EntityDomainCompareRev(item1, Item2: Pointer): integer;
begin
    Result := _entityCompare(3, false, Item1, Item2);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberEntityCache.Create();
begin
    _cache := TWidestringlist.Create();
    _cache.CaseSensitive := true;
    _cache.Duplicates := dupAccept;
    _cache.Sorted := true;
end;

{---------------------------------------}
destructor TJabberEntityCache.Destroy();
begin
    Clear();
    _cache.Free();
end;

{---------------------------------------}
procedure TJabberEntityCache.Clear();
var
    tmpl: TList;
    i: integer;
    ce: TJabberEntity;
begin
    // always remove to first entry until they are all gone.
    tmpl := TList.Create();
    for i := 0 to _cache.Count - 1 do begin
        ce := TJabberEntity(_cache.Objects[i]);
        if ((ce <> nil) and (ce.Parent = nil)) then
            tmpl.Add(ce);
    end;
    for i := 0 to tmpl.Count - 1 do begin
        ce := TJabberEntity(tmpl.Items[i]);
        ce.Free();
    end;
    tmpl.Free();
end;

{---------------------------------------}
procedure TJabberEntityCache.Add(jid: Widestring; e: TJabberEntity);
begin
    _cache.AddObject(TJabberID.applyJEP106(jid), e);
end;

{---------------------------------------}
procedure TJabberEntityCache.Add(jid: TJabberID; e: TJabberEntity);
begin
    _cache.AddObject(jid.full, e);
end;

{---------------------------------------}
procedure TJabberEntityCache.Remove(e: TJabberEntity);
begin
    Delete(indexOf(e));
end;

{---------------------------------------}
procedure TJabberEntityCache.RemoveJid(jid, node: Widestring);
var
    i: integer;
    cur: TJabberEntity;
begin
    i := _cache.indexOf(TJabberID.applyJEP106(jid));

    if (i >= 0) then begin
        repeat
            cur := TJabberEntity(_cache.Objects[i]);
            if (cur.jid.full <> jid) then
                cur := nil
            else if (cur.Node = node) then
                break;
            inc(i);
        until ((cur = nil) or (i >= _cache.Count));
        if (cur = nil) or (i >= _cache.Count) then exit;
        Delete(i);
    end;
end;

{---------------------------------------}
procedure TJabberEntityCache.Delete(i: integer);
begin
    if ((i >= 0) and (i < _cache.Count)) then
        _cache.Delete(i);
end;

{---------------------------------------}
function TJabberEntityCache.indexOf(e: TJabberEntity): integer;
begin
    Result := _cache.IndexOfObject(e);
end;

{---------------------------------------}
function TJabberEntityCache._getEntity(i: integer): TJabberEntity;
begin
    if (i < _cache.Count) then
        Result := TJabberEntity(_cache.Objects[i])
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberEntityCache.getByJid(jid: Widestring; node: Widestring): TJabberEntity;
var
    cur: TJabberEntity;
    i: integer;
begin
    i := _cache.IndexOf(TJabberID.applyJEP106(jid));
    if (i >= 0) then begin
        Result := nil;
        cur := TJabberEntity(_cache.Objects[i]);
        while ((Result = nil) and (cur <> nil)) do begin
            if ((node = cur.Node) and (cur.Jid.full = jid)) then begin
                // we found a match
                Result := cur;
                break;
            end
            else if (cur.jid.full <> jid) then
                // we found the next jid, so no match
                break;
            inc(i);
            if (i >= _cache.Count) then break;
            cur := TJabberEntity(_cache.Objects[i]);
        end;
    end
    else
        Result := nil;
end;

{---------------------------------------}
function TJabberEntityCache.fetch(jid: Widestring; js: TJabberSession;
    items_limit: boolean; node: Widestring): TJabberEntity;
var
    tjid: TJabberID;
begin
    Result := getByJid(jid, node);
    if (Result <> nil) then
        Result.Free();

    tjid := TJabberID.Create(jid);
    Result := TJabberEntity.Create(tjid, node);
    tjid.Free();
    _cache.AddObject(Result.Jid.full, Result);

    Result.discoWalk(js, items_limit);
end;

{---------------------------------------}
function TJabberEntityCache.discoItems(jid: Widestring; js: TJabberSession;
    node: Widestring = ''; timeout: integer = -1): TJabberEntity;
begin
    Result := getByJid(jid, node);
    if (Result <> nil) then begin
        Result.fallbackProtocols := false;
        Result.getItems(js);
        exit;
    end;

    Result := TJabberEntity.Create(TJabberID.Create(jid), node);
    Result.fallbackProtocols := false;
    _cache.AddObject(Result.Jid.full, Result);
    if (timeout <> -1) then
        Result.timeout := timeout;
    Result.getItems(js);
end;

{---------------------------------------}
function TJabberEntityCache.discoInfo(jid: Widestring; js: TJabberSession;
    node: Widestring = ''; timeout: integer = -1): TJabberEntity;
var
    e: TJabberEntity;
    tjid: TJabberID;
begin
    e := getByJid(jid, node);
    if (e <> nil) then begin
        Result := e;
        e.fallbackProtocols := false;
        e.getInfo(js);
        exit;
    end;

    tjid := TJabberID.Create(jid);
    e := TJabberEntity.Create(tjid, node);
    tjid.Free();
    e.fallbackProtocols := false;
    _cache.AddObject(TJabberID.applyJEP106(jid), e);
    if (timeout <> -1) then
        e.timeout := timeout;
    e.getInfo(js);
    Result := e;
end;

{---------------------------------------}
function TJabberEntityCache.getFirstFeature(f: Widestring): TJabberEntity;
var
    c: TJabberEntity;
    i: integer;
begin
    Result := nil;
    for i := 0 to _cache.Count - 1 do begin
        c := TJabberEntity(_cache.Objects[i]);
       // if (c.hasFeature(f)) then begin
         if (c.hasFeature(f)) AND (length(c.Category)>0) AND (Integer(c.Parent)>0) then begin
            Result := c;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TJabberEntityCache.getFirstSearch(): Widestring;
var
    e: TJabberEntity;
begin
    e := getFirstFeature(FEAT_SEARCH);
    if (e <> nil) then
        Result := e.jid.full
    else
        Result := '';
end;

{---------------------------------------}
function TJabberEntityCache.getFirstGroupchat(): Widestring;
var
    e: TJabberEntity;
begin
    e := getFirstFeature(FEAT_GROUPCHAT);
    if (e <> nil) then
        Result := e.jid.full
    else
        Result := '';
end;

{---------------------------------------}
procedure TJabberEntityCache.getByFeature(f: Widestring; jid_list: TWidestringList);
var
    i: integer;
    e: TJabberEntity;
begin
    for i := 0 to _cache.Count -1  do begin
        e := TJabberEntity(_cache.Objects[i]);
        if (e.hasFeature(f)) AND (length(e.Category)>0) AND (Integer(e.Parent)>0) then begin
            if (jid_list.indexOf(e.jid.full) = -1) then
                jid_list.Add(e.jid.full);
        end;
    end;
end;

{$ifdef Exodus}
{---------------------------------------}
procedure TJabberEntityCache.getByIdentity(icat, itype: WideString; jid_list: TTntStrings);
var
    i: integer;
    e: TJabberEntity;
begin
    for i := 0 to _cache.Count - 1 do begin
        e := TJabberEntity(_cache.Objects[i]);
        if e.hasIdentity(icat, itype) then
            jid_list.Add(e.jid.full);
    end;
end;
{$endif}
{---------------------------------------}
procedure TJabberEntityCache.getByIdentity(icat, itype: Widestring; jid_list: TWidestringlist);
var
    i: integer;
    e: TJabberEntity;
begin
    for i := 0 to _cache.Count - 1 do begin
        e := TJabberEntity(_cache.Objects[i]);
        if e.hasIdentity(icat, itype) then
            jid_list.Add(e.jid.full);
    end;
end;

{$ifdef Exodus}
procedure TJabberEntityCache.getByFeature(f: Widestring; jid_list: TTntStrings);
var
    i: integer;
    e: TJabberEntity;
begin
    for i := 0 to _cache.Count -1  do begin
        e := TJabberEntity(_cache.Objects[i]);
        if (e.hasFeature(f)) AND (length(e.Category)>0) AND (Integer(e.Parent)>0) then begin
            if (jid_list.IndexOf(e.jid.full) = -1) then
                jid_list.Add(e.jid.full);
        end;
    end;
end;
{$endif}

function TJabberEntityCache.toString(): widestring;
var
    c: integer;
begin
    Result := 'Entity Cache.' + #13#10 + 'Entity Count: ' + intToStr(_cache.Count) + #13#10 + '  Entities:' + #13#10;
    for c := 0 to _cache.Count - 1 do begin
        Result := Result + #13#10 + '***** Entity#' + IntToStr(c) + ' *****' + #13#10 + TJabberEntity(_cache.Objects[c]).toString();
    end;
end;

initialization
    jEntityCache := TJabberEntityCache.Create();

finalization
    jEntityCache.Free();


end.
