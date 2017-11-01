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
unit PrefFile;


interface
uses
    Unicode, XMLTag, Presence,

    {$ifdef Exodus}
    TntClasses,
    {$endif}

    Classes;

type
    TWritableState = (pwsUnknown, pwsWritable, pwsNotWritable);
    TPrefState = (psReadOnly, psReadWrite, psInvisible, psUnknown);

    TPrefFile = class
    private
        _root     : TXMLTag;
        _pref     : TXMLTag;
        _pres     : TXMLTag;
        _pos      : TXMLTag;
        _prof     : TXMLTag;
        _bms      : TXMLTag;
        _groups   : TXMLTag;
        _ws       : TXMLTag;

        _filename : Widestring;
        _ctrlHash : TWideStringList;
        _dirty    : boolean;
        _need_default_pres : boolean;
        _writable : TWritableState;

        procedure init();

    public
        constructor Create(filename: Widestring); overload;
        constructor CreateFromResource(const ResName: string);
        constructor Create(tag: TXMLTag); overload;

        Destructor Destroy; override;

        procedure save();

        {
            Does this file have the given preference?

            @param pkey the preference we are looking for
            @returns true if the given pref key exists
        }
        function hasPref(pkey: WideString): boolean;

        {
            Does this file have the given preference in a profile?

            @param profilename the profile to look into
            @param pkey the preference we are looking for
            @returns true if the given pref key exists
        }
        function hasPrefInProfile(profiletag: TXMLTag; pkey: WideString): boolean;

        // Generic get & sets
        function getString(pkey: Widestring): Widestring;
        function getState(pkey: Widestring): TPrefState;
        function getControl(pkey: Widestring): Widestring;
        function getPref(control: Widestring): Widestring;
        procedure setString(pkey: Widestring; val: Widestring);
        function getStringInProfile(profiletag: TXMLTag; pkey: Widestring): Widestring;
        procedure setStringInProfile(profiletag: TXMLTag; pkey: Widestring; val: Widestring);
{$ifdef Exodus}
        procedure setStringlist(pkey: Widestring; pvalue: TWideStrings);overload;
        procedure setStringlist(pkey: Widestring; pvalue: TTntStrings); overload;
        function fillStringlist(pkey: Widestring; sl: TWideStrings): boolean; overload;
        function fillStringlist(pkey: Widestring; sl: TTntStrings): boolean; overload;
        procedure setStringlistInProfile(profiletag: TXMLTag; pkey: Widestring; pvalue: TWideStrings);overload;
        procedure setStringlistInProfile(profiletag: TXMLTag; pkey: Widestring; pvalue: TTntStrings); overload;
        function fillStringlistInProfile(profiletag: TXMLTag; pkey: Widestring; sl: TWideStrings): boolean; overload;
        function fillStringlistInProfile(profiletag: TXMLTag; pkey: Widestring; sl: TTntStrings): boolean; overload;
{$else}
        function fillStringlist(pkey: Widestring; sl: TWideStrings): boolean;
        procedure setStringlist(pkey: Widestring; pvalue: TWideStrings);
        function fillStringlistInProfile(profiletag: TXMLTag; pkey: Widestring; sl: TWideStrings): boolean;
        procedure setStringlistInProfile(profiletag: TXMLTag; pkey: Widestring; pvalue: TWideStrings);
{$endif}
        {**
            Get/set the xml child of a pref.
        **}
        function getXMLPref(pkey : WideString) : TXMLTag;
        procedure setXMLPref(value : TXMLTag);
        function getXMLPrefInProfile(profiletag: TXMLTag; pkey : WideString) : TXMLTag;
        procedure setXMLPrefInProfile(profiletag: TXMLTag; value : TXMLTag);

        // Custom pres
        function findPresenceTag(pkey: Widestring): TXMLTag;
        function getAllPresence(): TWidestringList;
        function getPresence(pkey: Widestring): TJabberCustomPres;
        function getPresIndex(idx: integer): TJabberCustomPres;
        procedure setPresence(pvalue: TJabberCustomPres);
        procedure removePresence(pkey: Widestring);
        procedure removeAllPresence();

        // misc.
        //setDirty --> Tag returned will be modified by the caller. Tag returned
        //is a reference to the cache this file is keeping.
        function getPositionTag(pkey: WideString; setDirty: boolean = false): TXMLTag;

        {
            Retrieves the given root tag.

            Checks the top level children of the <exodus> node for rootName and
            returns a <b>copy</b> of it. Returns nil if node could not be found.

            @param rootName - node name for top level child of <exodus> tag.
            @param rootTag [out] the node or nil if it does not exist.
            @return true of node existed, else false.
        }
        function getRoot(rootName: WideString; var rootTag: TXMLTag): boolean;

        {
            Replaces the top level <exodus/> child with the given node.

            Sets the dirty flag on success. returns true if the child already
            exists (true replacement) and frees the current child and copies
            the new child into root.

            @param rootTag - child to replace
            @return
        }
        function setRoot(rootTag: TXMLTag): boolean;
        procedure clearProfiles();
        procedure SaveBookmarks(tag: TXMLTag);
        procedure SaveGroups(tag: TXMLTag);

        // read only props
        property Dirty : boolean read _dirty;
        property NeedDefaultPresence : boolean read _need_default_pres;
        property Profiles : TXMLTag read _prof;
        property Bookmarks : TXMLTag read _bms;
        property Groups : TXMLTag read _groups;
end;

const
    WINDOWSTATE = 'ws';            //ditto
    PREFFILE_NOT_WELL_FORMED = 'Failed to load file %s.  '#13#10'XML not well formed.';

implementation

uses
    PrefController, //map vlaue class
    Windows, SysUtils, XMLParser, Session,
    gnugettext;

const
    PRES    = 'presii';           // DO NOT LOCALIZE
    ROOT    = 'exodus';           // DO NOT LOCALIZE
    VER     = 'version';          // DO NOT LOCALIZE
    VER_NUM = '0.9';              // DO NOT LOCALIZE
    VALUE   = 'value';            // DO NOT LOCALIZE
    POS     = 'positions';        // DO NOT LOCALIZE
    PROF    = 'profiles';         // DO NOT LOCALIZE
    PREF    = 'prefs';            // DO NOT LOCALIZE
    BMS     = 'local-bookmarks';  // DO NOT LOCALIZE
    GRPS    = 'local-groups';     // DO NOT LOCALIZE
    STATES  = 'states';
    AUTO_OPEN = 'auto-open'; 

{---------------------------------------}
constructor TPrefFile.Create(tag: TXMLTag);
begin
    _filename := '';
    _root := TXMLTag.Create(tag);
    init();
end;

{---------------------------------------}
constructor TPrefFile.Create(filename: Widestring);
var
    parser: TXMLTagParser;
    s: widestring;
begin
    _filename := filename;
    parser := TXMLTagParser.Create;

    try
        if (fileExists(_filename)) then begin
            parser.ParseFile(_filename);
            if (parser.Count > 0) then begin
                _root := parser.popTag();
            end
            else begin
                s := Format(_(PREFFILE_NOT_WELL_FORMED), [_filename]);
                MessageBoxW(0, PWChar(s), PWChar(_('Failed to load file')), MB_OK or MB_ICONERROR);
            end;
        end
    except
    end;

    parser.Free();
    init();
end;

{---------------------------------------}
constructor TPrefFile.CreateFromResource(const ResName: string);
var
    parser: TXMLTagParser;
begin
    _filename := '';
    parser := TXMLTagParser.Create;

    try
        parser.ParseResource(resName);
        if (parser.Count > 0) then begin
            _root := parser.popTag();
        end
    except
    end;

    parser.Free();
    init();
end;

{---------------------------------------}
function TPrefFile.getRoot(rootName: WideString; var rootTag: TXMLTag): boolean;
begin
    if (rootName = '') then begin
        rootTag := TXMLTag.create(_root);
    end
    else begin
        rootTag := TXMLTag.create(_root.GetFirstTag(rootName));
    end;
    Result := (rootTag <> nil);
end;

{---------------------------------------}
function TPrefFile.setRoot(rootTag: TXMLTag): boolean;
var
    tt: TXMLTag;
begin
    tt := _root.GetFirstTag(rootTag.Name);
    Result := true;
    if (tt <> nil) then
        _root.RemoveTag(tt);
    _root.AddTag(TXMLTag.Create(rootTag));
    _dirty := true;
end;

{---------------------------------------}
procedure TPrefFile.init();
var
    t,t3,fs: TXMLTag;
    s, cs: TXMLTagList;
    i, j: integer;
    c: Widestring;
    sl: TWideStringList;

    function gettag(tagname: WideString): TXMLTag;overload;
    begin
        Result := _root.GetFirstTag(tagname);
        if (Result = nil) then
            Result := _root.AddTag(tagname);
    end;
begin
    _dirty := false;
    _need_default_pres := false;
    _ctrlHash := TWideStringList.Create();

    if (_root = nil) then begin
        // nothing there yet.
        _root := TXmlTag.Create(ROOT);
        _root.setAttribute(VER, VER_NUM);
    end;

    _pref   := gettag(PREF);
    _pres   := gettag(PRES);
    _pos    := gettag(POS);
    _prof   := gettag(PROF);
    _bms    := gettag(BMS);
    _groups := gettag(GRPS);
    _ws     := gettag(WINDOWSTATE);

    // If the format changes again, also check VER_NUM.
    if (_root.getAttribute(VER) = '') then begin
        _dirty := true;
        _root.Name := ROOT;
        _root.setAttribute(VER, VER_NUM);

        _need_default_pres := true;
        // old-style prefs.  convert to new style, so that save() will
        // do the right thing.
        s := _root.ChildTags();
        for i := 0 to s.count - 1 do begin
            t := s.Tags[i];
            if (t.Name = 'presence') then begin
                _pres.AddTag(TXMLTag.Create(t));
                _root.RemoveTag(t);
            end
            else if (t.Name = 'custom_pres') then begin // older 0.8.6.x dailies
                _need_default_pres := false;
                _root.RemoveTag(t);
            end
            else if (t.Name = 'profile') then begin
                _prof.AddTag(TXMLTag.Create(t));
                _root.RemoveTag(t);
            end
            else if (
                (t.Name <> PRES) and
                (t.Name <> POS) and
                (t.Name <> PROF) and
                (t.Name <> BMS) and
                (t.Name <> WINDOWSTATE) and
                (t.Name <> PREF)) then begin  // in case there was a custom_pres

                // if there are s's inside, leave them.  otherwise, pull
                // the cdata out into the value attrib
                fs := t.GetFirstTag('s');
                if ((fs = nil) and (t.Data <> '')) then begin
                    setString(t.Name, t.Data);
                    t.ClearCData();
                end
                else if (fs <> nil) then begin
                    // setStringList...
                    sl := TWideStringList.Create();
                    cs := t.QueryTags('s');
                    for j := 0 to cs.Count - 1 do
                        sl.Add(cs.Tags[j].Data);
                    cs.Free;
                    setStringlist(t.Name, sl);
                    sl.Free(); 
                end;
                _root.RemoveTag(t);
            end;
        end;
        s.Free();
        save();
    end;

    //walk prefs anbd create an index of associated controls
    s := _pref.ChildTags();
    for i := 0 to s.Count - 1 do begin
        t := s.Tags[i];

        c := t.GetAttribute('control');
        if (c <> '') then begin
            _ctrlHash.Add(c);
            _ctrlHash.Values[c] := t.Name;
        end;

        cs := t.QueryTags('control');
        for j := 0 to cs.Count - 1 do begin
            c := cs.Tags[j].GetAttribute('name');
            if (c <> '') then begin
                assert(_ctrlHash.IndexOf(c) = -1);
                _ctrlHash.Add(c);
                _ctrlHash.Values[c] := t.Name;
            end;
        end;
        cs.Free;
    end;
    //if _ws has no children, copy over pos entries
    if (_ws.ChildCount = 0) then begin
        t := _ws.AddTag('state');
        for i := 0 to _pos.ChildCount - 1 do begin
            t3 := t.AddTag(_pos.ChildTags[i].Name);
            t3 := t3.AddTag('pos');
            t3.setAttribute('h', _pos.ChildTags[i].GetAttribute('height'));
            t3.setAttribute('w', _pos.ChildTags[i].GetAttribute('width'));
            t3.setAttribute('t', _pos.ChildTags[i].GetAttribute('top'));
            t3.setAttribute('l', _pos.ChildTags[i].GetAttribute('left'));
        end;
        _dirty := true;
    end;
    
    s.Free();
end;

{---------------------------------------}
destructor TPrefFile.Destroy;
begin
    if _root <> nil then
        _root.Free();
    _ctrlHash.Free();
end;

{---------------------------------------}
procedure TPrefFile.save();
var
    fs: TStringList;
    fh: THandle;
    fns: String;
begin
    // Not sure how we could get a nil here, but it has happened, so protect against using nil
    if (_root = nil) then exit;
    
    if ((_filename = '') or (not _dirty)) then exit;

    if (_writable = pwsUnknown) then begin
        // Open the file using CreateFile, and check
        fns := _filename;
        fh := CreateFile(PChar(fns), GENERIC_WRITE, FILE_SHARE_READ, nil,
            OPEN_ALWAYS, 0, 0);
        if (fh <> INVALID_HANDLE_VALUE) then begin
            _writable := pwsWritable;
            CloseHandle(fh);
        end
        else
            _writable := pwsNotWritable;
    end;

    if (_writable = pwsNotWritable) then begin
        MainSession.FireEvent('/session/error/prefs-write', nil);
        exit;
    end;

    fs := TStringList.Create;
    fs.Text := UTF8Encode(_root.xml);

    try
        fs.SaveToFile(_filename);
        _dirty := false;
    except
        MainSession.FireEvent('/session/error/prefs-write', nil);
    end;

    fs.Free();
end;

{
    Does this file have the given preference?

    @param pkey the preference we are looking for
    @returns true if the given pref key exists
}
function TPrefFile.hasPref(pkey: WideString): boolean;
begin
    Result := (_pref.GetFirstTag(pkey) <> nil);
end;

{
    Does this file have the given preference in a profile?

    @param profiletag the profile prefs to look into
    @param pkey the preference we are looking for
    @returns true if the given pref key exists
}
function TPrefFile.hasPrefInProfile(profiletag: TXMLTag; pkey: WideString): boolean;
begin
    if (profileTag <> nil) then    
        Result := (profileTag.GetFirstTag(pkey) <> nil)
end;

{---------------------------------------}
function TPrefFile.getString(pkey: Widestring): Widestring;
var
    t: TXMLTag;
begin
    t := _pref.GetFirstTag(pkey);
    if (t = nil) then
        Result := ''
    else
        Result := t.GetAttribute(VALUE);
end;

{---------------------------------------}
function TPrefFile.getStringInProfile(profiletag: TXMLTag; pkey: Widestring): Widestring;
var
    t: TXMLTag;
begin
    if (profileTag <> nil) then begin
        t := profileTag.GetFirstTag(pkey);
        if (t = nil) then
            Result := ''
        else
            Result := t.GetAttribute(VALUE);
    end
    else
        Result := '';
end;

{---------------------------------------}
function TPrefFile.getState(pkey: Widestring): TPrefState;
var
    t: TXMLTag;
    s: Widestring;
begin
    t := _pref.GetFirstTag(pkey);
    if (t = nil) then begin
        Result := psUnknown;
        exit;
    end;

    s := t.GetAttribute('state');
    if (s = 'ro') then
        Result := psReadOnly
    else if (s = 'inv') then
        Result := psInvisible
    else if (s = 'rw') then
        Result := psReadWrite
    else
        Result := psUnknown;
end;

{---------------------------------------}
function TPrefFile.getControl(pkey: Widestring): Widestring;
var
    t: TXMLTag;
begin
    t := _pref.GetFirstTag(pkey);
    if (t = nil) then begin
        Result := '';
        exit;
    end;

    Result := t.GetAttribute('control');
end;

{---------------------------------------}
function TPrefFile.getPref(control: Widestring): Widestring;
begin
    Result := _ctrlHash.Values[control];
end;

{---------------------------------------}
procedure TPrefFile.setString(pkey: Widestring; val: Widestring);
var
    t: TXMLTag;
begin
    _dirty := true;

    t := _pref.GetFirstTag(pkey);
    if ((t = nil) and (val <> '')) then
        t := _pref.AddTag(pkey);

    if (val <> '') then
        t.setAttribute(VALUE, val)
    else if (t <> nil) then
        _pref.removeTag(t);
end;

{---------------------------------------}
procedure TPrefFile.setStringInProfile(profiletag: TXMLTag; pkey: Widestring; val: Widestring);
var
    t: TXMLTag;
begin
    _dirty := true;

    if (profileTag <> nil) then begin
        t := profileTag.GetFirstTag(pkey);
        if ((t = nil) and (val <> '')) then
            t := profileTag.AddTag(pkey);

        if (val <> '') then
            t.setAttribute(VALUE, val)
        else if (t <> nil) then
            profileTag.removeTag(t);
    end;
end;

{---------------------------------------}
function TPrefFile.fillStringlist(pkey: Widestring; sl: TWideStrings): boolean;
var
    t: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl.Clear();
    Result := false;

    t := _pref.GetFirstTag(pkey);
    if (t = nil) then exit;

    s := t.QueryTags('s');
    for i := 0 to s.Count - 1 do
        sl.Add(s.Tags[i].Data);
    s.Free;

    Result := true;
end;

{---------------------------------------}
function TPrefFile.fillStringlistInProfile(profiletag: TXMLTag; pkey: Widestring; sl: TWideStrings): boolean;
var
    t: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl.Clear();
    Result := false;

    if (profileTag <> nil) then begin
        t := profileTag.GetFirstTag(pkey);
        if (t = nil) then exit;

        s := t.QueryTags('s');
        for i := 0 to s.Count - 1 do
            sl.Add(s.Tags[i].Data);
        s.Free;

        Result := true;
    end
    else
        Result := false;
end;

{---------------------------------------}
procedure TPrefFile.setStringlist(pkey: Widestring; pvalue: TWideStrings);
var
    i: integer;
    t: TXMLTag;
    s: TXMLTagList;
begin
    _dirty := true;

    // setup the stringlist in it's own parent..
    // with multiple <s> tags for each value.
    t := _pref.GetFirstTag(pkey);
    if (t = nil) then
        t := _pref.AddTag(pkey);

    // clear out the old
    s := t.QueryTags('s');
    for i := 0 to s.Count - 1 do
        t.removeTag(s[i]);
    s.free();

    // plug in all the values
    for i := 0 to pvalue.Count - 1 do begin
        if (pvalue[i] <> '') then
            t.AddBasicTag('s', pvalue[i]);
    end;
end;

{---------------------------------------}
procedure TPrefFile.setStringlistInProfile(profiletag: TXMLTag; pkey: Widestring; pvalue: TWideStrings);
var
    i: integer;
    t: TXMLTag;
    s: TXMLTagList;
begin
    _dirty := true;

    if (profileTag <> nil) then begin
        // setup the stringlist in it's own parent..
        // with multiple <s> tags for each value.
        t := profileTag.GetFirstTag(pkey);
        if (t = nil) then
            t := profileTag.AddTag(pkey);

        // clear out the old
        s := t.QueryTags('s');
        for i := 0 to s.Count - 1 do
            t.removeTag(s[i]);
        s.free();

        // plug in all the values
        for i := 0 to pvalue.Count - 1 do begin
            if (pvalue[i] <> '') then
                t.AddBasicTag('s', pvalue[i]);
        end;
    end;
end;

{$ifdef Exodus}
{---------------------------------------}
function TPrefFile.fillStringlist(pkey: Widestring; sl: TTntStrings): boolean;
var
    t: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl.Clear();
    Result := false;

    t := _pref.GetFirstTag(pkey);
    if (t = nil) then exit;

    s := t.QueryTags('s');
    for i := 0 to s.Count - 1 do
        sl.Add(s.Tags[i].Data);
    s.Free;

    Result := true;
end;

{---------------------------------------}
function TPrefFile.fillStringlistInProfile(profiletag: TXMLTag; pkey: Widestring; sl: TTntStrings): boolean;
var
    t: TXMLTag;
    s: TXMLTagList;
    i: integer;
begin
    sl.Clear();
    Result := false;

    if (profileTag <> nil) then begin
        t := profileTag.GetFirstTag(pkey);
        if (t = nil) then exit;

        s := t.QueryTags('s');
        for i := 0 to s.Count - 1 do
            sl.Add(s.Tags[i].Data);
        s.Free;

        Result := true;
    end
    else
        Result := false;
end;

{---------------------------------------}
procedure TPrefFile.setStringlist(pkey: Widestring; pvalue: TTntStrings);
var
    i: integer;
    t: TXMLTag;
    s: TXMLTagList;
begin
    _dirty := true;

    // setup the stringlist in it's own parent..
    // with multiple <s> tags for each value.
    t := _pref.GetFirstTag(pkey);
    if (t = nil) then
        t := _pref.AddTag(pkey);

    // clear out the old
    s := t.QueryTags('s');
    for i := 0 to s.Count - 1 do
        t.removeTag(s[i]);
    s.free();

    // plug in all the values
    for i := 0 to pvalue.Count - 1 do begin
        if (pvalue[i] <> '') then
            t.AddBasicTag('s', pvalue[i]);
    end;
end;

{---------------------------------------}
procedure TPrefFile.setStringlistInProfile(profiletag: TXMLTag; pkey: Widestring; pvalue: TTntStrings);
var
    i: integer;
    t: TXMLTag;
    s: TXMLTagList;
begin
    _dirty := true;

    if (profileTag <> nil) then begin
        // setup the stringlist in it's own parent..
        // with multiple <s> tags for each value.
        t := _prof.GetFirstTag(pkey);
        if (t = nil) then
            t := profileTag.AddTag(pkey);

        // clear out the old
        s := t.QueryTags('s');
        for i := 0 to s.Count - 1 do
            t.removeTag(s[i]);
        s.free();

        // plug in all the values
        for i := 0 to pvalue.Count - 1 do begin
            if (pvalue[i] <> '') then
                t.AddBasicTag('s', pvalue[i]);
        end;
    end;
end;
{$endif}

{---------------------------------------}
function TPrefFile.findPresenceTag(pkey: Widestring): TXMLTag;
begin
    // get some custom pres from the list
    Result := _pres.QueryXPTag('/presii/presence[@name="' + pkey + '"]');
end;

{---------------------------------------}
procedure TPrefFile.removePresence(pkey: Widestring);
var
    tag: TXMLTag;
begin
    _dirty := true;

    // remove this specific presence
    tag := _pres.QueryXPTag('/presii/presence[@name="' + pkey + '"]');

    if (tag <> nil) then
        _pres.RemoveTag(tag);
end;

{---------------------------------------}
procedure TPrefFile.removeAllPresence();
begin
    _pres.ClearTags();
end;

{---------------------------------------}
function TPrefFile.getAllPresence(): TWidestringlist;
var
    i: integer;
    ptags: TXMLTagList;
    cp: TJabberCustompres;
begin
    Result := TWidestringlist.Create();
    ptags := _pres.QueryTags('presence');

    for i := 0 to ptags.Count - 1 do begin
        cp := TJabberCustompres.Create();
        cp.Parse(ptags[i]);
        Result.AddObject(cp.title, cp);
    end;

    //Result.Sort();
    ptags.Free();
end;

{---------------------------------------}
function TPrefFile.getPresence(pkey: Widestring): TJabberCustomPres;
var
    p: TXMLTag;
begin
    // get some custom pres from the list
    Result := nil;
    p := Self.findPresenceTag(pkey);
    if (p <> nil) then begin
        Result := TJabberCustomPres.Create();
        Result.Parse(p);
    end;
end;

{---------------------------------------}
function TPrefFile.getPresIndex(idx: integer): TJabberCustomPres;
var
    ptags: TXMLTagList;
begin
    Result := nil;
    ptags := _pres.QueryTags('presence');
    if ((idx >= 0) and (idx < ptags.Count)) then
        Result := getPresence(ptags[idx].GetAttribute('name'));
    ptags.Free();
end;

{---------------------------------------}
procedure TPrefFile.setPresence(pvalue: TJabberCustomPres);
var
    p: TXMLTag;
begin
    _dirty := true;

    // set some custom pres into the list
    p := Self.findPresenceTag(pvalue.title);
    if (p = nil) then
        p := _pres.AddTag('presence');
    pvalue.FillTag(p);
end;

{---------------------------------------}
function TPrefFile.getPositionTag(pkey: WideString; setDirty: boolean = false): TXMLTag;
begin
    if (setDirty) then
        _dirty := true;

    Result := _pos.getFirstTag(pkey);

    // ew.  look over there. -->
    if ((Result = nil) and setDirty) then
        Result := _pos.AddTag(pkey);
end;

{---------------------------------------}
procedure TPrefFile.ClearProfiles();
begin
    _dirty := true;
    _prof.ClearTags();
end;

{---------------------------------------}
procedure TPrefFile.SaveBookmarks(tag: TXMLTag);
var
    blist: TXMLTagList;
    i: integer;
begin
    _dirty := true;
    _bms.ClearTags();
    blist := tag.ChildTags();
    for i := 0 to blist.count - 1 do begin
        _bms.AddTag(TXMLTag.Create(blist[i]));
    end;
    Save();
end;

{---------------------------------------}
procedure TPrefFile.SaveGroups(tag: TXMLTag);
var
    glist: TXMLTagList;
    i: integer;
begin
    _dirty := true;
    _groups.ClearTags();
    glist := tag.ChildTags();
    for i := 0 to glist.count - 1 do begin
        _groups.AddTag(TXMLTag.Create(glist[i]));
    end;
    Save();
end;

{**
    Get/set the xml child of a pref.
**}
function TPrefFile.getXMLPref(pkey : WideString) : TXMLTag;
var
    t: TXMLTag;
begin
    t := _pref.GetFirstTag(pkey);
    if (t = nil) then
        Result := nil
    else
        Result := TXMLTag.Create(t);
end;

function TPrefFile.getXMLPrefInProfile(profiletag: TXMLTag; pkey : WideString) : TXMLTag;
var
    t: TXMLTag;
begin
    if (profileTag <> nil) then begin
        t := profileTag.GetFirstTag(pkey);
        if (t = nil) then
            Result := nil
        else
            Result := TXMLTag.Create(t);
    end
    else
        Result := nil;
end;

procedure TPrefFile.setXMLPref(value : TXMLTag);
var
    t: TXMLTag;
begin
    t := _pref.GetFirstTag(value.Name);
    if (t <> nil) then
        _pref.removeTag(t);
    _pref.addTag(TXMLTag.Create(value));
    _dirty := true;
end;

procedure TPrefFile.setXMLPrefInProfile(profiletag: TXMLTag; value : TXMLTag);
var
    t: TXMLTag;
begin
    if (profileTag <> nil) then begin
        t := profileTag.GetFirstTag(value.Name);
        if (t <> nil) then
            profileTag.removeTag(t);
        profileTag.addTag(TXMLTag.Create(value));
        _dirty := true;
    end;
end;

end.
