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
unit DisplayName;

interface
uses
    RegExpr,
    Unicode,
    XMLTag,
    XMLVCard, XMLVCardCache,
    JabberID,
    COMExodusItem,
    Contnrs,
    Exodus_TLB;
const
    PREF_PROFILE_DN = 'displayname_profile_enabled';
    PREF_PROFILE_DN_MAP = 'displayname_profile_map';
    PROFILE_DN_MAP_START_DELIM = '{';
    PROFILE_DN_MAP_END_DELIM = '}';

    DISPLAYNAME_EVENT_UPDATE = '/session/displayname';
    DISPLAYNAME_EVENT_PROFILE = '/session/profiledisplayname';

    dntItemName: Widestring = 'itemname';
    dntDefault: Widestring = 'default';
    dntProfile: Widestring = 'profile';

type
    //JJF TODO add some kind of generic support for rooms (bookmark names), other items

    TDisplayNameChangeEvent = procedure(UID: Widestring; displayName: WideString) of object;
    TProfileResultEvent = procedure(BareJID: Widestring; profileName: WideString; FetchError: boolean) of object;


    {
        A helper class that fires an OnDisplayNameChange and ObProfileResult
        events when appropriate.

        If a UID is specified, only DN changes or profile requests to that UID
        will fire the event. If no UID is specified, all DN changes and profile
        request results will fire the event.

        Note UID instead of JID here. Trying to move to a generic mechanism...
        BareJids *must* be used for profile names, makes no sense otherwise
    }
    TDisplayNameEventListener = class
    private
        _DNCB: Integer;
        _ProfileResultCB: Integer;

        _OnDisplayNameChange: TDisplayNameChangeEvent;
        _OnDisplayNameUpdate: TDisplayNameChangeEvent;
        _OnProfileResult: TProfileResultEvent;

        _UID: WideString;
    protected
        procedure DNCallback(event: string; tag: TXMLTag);
        procedure ProfileResultCallBack(event: string; tag: TXMLTag);

        procedure FireOnDisplayNameChange(UID: Widestring; displayName: WideString);virtual;
        procedure FireOnDisplayNameUpdate(UID: Widestring; displayName: WideString);virtual;
        procedure FireOnProfileResult(BareJID: Widestring; ProfileName: WideString; FetchError: boolean);virtual;
    public
        Constructor Create(); virtual;
        Destructor Destroy(); override;

        //some class helper functions for getting displayname and profile display name
        class function GetDisplayName(uid: Widestring; out pendingNameChange: Boolean): WideString;overload;
        class function GetDisplayName(uid: Widestring): WideString;overload;
        class function GetProfileDisplayName(BareJID: TJabberID; out pendingNameChange: Boolean): WideString;
        class function ProfileEnabled(): Boolean;

        property OnDisplayNameChange: TDisplayNameChangeEvent read _OnDisplayNameChange write _OnDisplayNameChange;
        property OnDisplayNameUpdate: TDisplayNameChangeEvent read _OnDisplayNameUpdate write _OnDisplayNameUpdate;
        property OnProfileResult: TProfileResultEvent read _OnProfileResult write _OnProfileResult;

        property UID: WideString read _UID write _UID;
    end;

       {a helper class for profile prefs}
    TProfileParser = class
    private
        _regEx: TRegExpr;
        _parsedProfileMap: TWidestringList;
        _profileMapStr: Widestring;

    public
        Constructor Create();
        Destructor  Destroy();override;

        procedure setProfileParseMap(profileMap: Widestring);
        function parseProfile(profileTag: TXMLTag; var displayName: WideString): boolean;
        property ProfileMapString: WideString read _profileMapStr;
    end;

    TDisplayNameValue = class
    private
        _dnType: WideString;
        _dnValue: WideString;
    public
        Constructor Create(dnTYpe: WideString);
        property DNType: WideString read _dnType;
        property Value: WideString read _dnValue write _dnValue;
    end;

    {
        An entry in the display name cache.
    }
    TDisplayNameItem = class
    private
        _DisplayNames: TObjectList; //of TDisplayNameValue
        _CurrentDisplayName:WideString;
        _UID: WideString;

        function indexOf(DNType: Widestring): integer;
    protected
        function GetBestExistingDisplayName(): WideString; virtual;

        function GetDisplayNames(DNType: WideString): Widestring; virtual;
        procedure SetDisplayNames(DNType: WideString; value: widestring); virtual;
        function GetDisplayNamesCount(): Integer; virtual;

        procedure SetSupportedDisplayNameTypes(dntTypes: array of Widestring); virtual;
        function IsTypeSupported(DNType: WideString): boolean;
    public
        constructor create(UID: WideString); virtual;
        destructor  Destroy();override;

        function getDisplayName(out pendingNameChange: boolean; UseCacheOnly: boolean=false): WideString; virtual;

        procedure OnPrefChange();virtual;
        function UpdateDisplayName(Item: IExodusItem; InitialUpdate: boolean): boolean; virtual;

        property UID: Widestring read _UID;
        property CurrentDisplayName: Widestring read _CurrentDisplayName;

        property DisplayName[DNType: Widestring]: WideString read GetDisplayNames write SetDisplayNames;
        property DisplayNamesCount: integer read GetDisplayNamesCount;
    end;

    {
        A contact specific item.
    }
    TContactDisplayNameItem = class(TDisplayNameItem)
    private
        _VCard: TXMLVCard;
        _jid: TJabberID;

        //An item may make a vcard fetch as part of a GetDisplayName call, or
        //as a seperate use case (Roster wants to look up profile DN as part
        //of a rename for instance). In the first case we want to modify
        //the DN and push a change event as needed. In the second case we
        //want to cache the vcard and profile dn but not event.
        //In both cases we want to fire a Profile fetch result event.
        _fetchFailed: Boolean;
        _fetchPending: Boolean;
        _DNFetch: boolean;
        _StandAloneFetch: boolean;

        _profileParser: TProfileParser;
        _HasProfile: Boolean;
    protected
        function ParseVCard(out ProfileDisplayName: WideString): boolean;
        procedure SetVCard(vcard: TXMLVCard);
        function GetBestExistingDisplayName(): WideString; override;
        function FetchProfileDN(out pendingNameChange: boolean; UseCacheOnly: boolean=false): WideString;virtual;
    public
        constructor Create(jid: TJabberID; profileParser: TProfileParser); reintroduce; overload;
        destructor  Destroy();override;

        procedure VCardCallback(jid: Widestring; vcard: TXMLVCard);
        procedure OnVCardResult(vcard: TXMLVCard);

        function getProfileDisplayName(out pendingNameChange: boolean; UseCacheOnly: boolean=false): WideString;virtual;
        function getDisplayName(out pendingNameChange: boolean; UseCacheOnly: boolean=false): WideString; override;

        procedure OnPrefChange();override;

        property HasProfileDisplayName: boolean read _HasProfile;
    end;

    TDisplayNameCache = class
    private
        _dnCache:   TWideStringList;
        _sessionCB: Integer;
        _VCardResultCB: integer;

        _js:        TObject; //TjabberSession, use TObject to avoid circular ref issues
                             //DNCache is initialized in session object
        _profileParser: TProfileParser;
        _useProfileDN: boolean;
        _depResolver: TObject; //TSimpleDependancyHandler;

        function getOrAddDNItem(UID: Widestring): TDisplayNameItem; overload;
        function getOrAddDNItem(JID: TJabberID): TDisplayNameItem; overload;

    protected
        //list management
        function getDNItem(UID: WideString): TDisplayNameItem; overload;
         function getDNItem(JID: TJabberID): TDisplayNameItem; overload;

        procedure removeDNItem(dnItem: TDisplayNameItem);
        procedure addDNItem(dnItem: TDisplayNameItem);
        procedure clearDNCache();
        procedure OnDependancyReady(tag: TXMLTag);

    public
        Constructor create();
        Destructor Destroy(); override;

        function getDisplayName(jid: TJabberID; out pendingNameChange: boolean; UseCacheOnly: boolean=false): Widestring;overload;
        function getDisplayName(jid: TJabberID): Widestring;overload;
        function getDisplayName(uid: widestring): Widestring;overload;
        function getDisplayNameAndFullJID(jid: TJabberID): Widestring;
        function getDisplayNameAndBareJID(jid: TJabberID): Widestring;
        function getProfileDisplayName(jid: TJabberID; out pendingNameChange: boolean): WideString;

        function HasProfileDisplayName(UID: WideString): boolean;

        procedure setSession(js: TObject); //TObject to avoid circular reference

        procedure UpdateDisplayName(Item: IExodusItem);

        //callbacks
        procedure SessionCallback(event: string; tag: TXMLTag);
        procedure VCardResultCallBack(event: string; tag: TXMLTag);

        property ProfileParser: TProfileParser read _profileParser;
    end;

    {Singleton accessor}
    function getDisplayNameCache(): TDisplayNameCache;

implementation
uses
    SysUtils,
    Session;
var
    _DisplayNameCache: TDisplayNameCache;
    DNSession: TJabberSession;

const
    PROFILE_MAP_REGEX = '{[A-Za-z0-9]*}';

function getDisplayNameCache(): TDisplayNameCache;
begin
    Result := _DisplayNameCache;
end;

function useProfileDN(): boolean;
begin
    Result := DNSession.Prefs.getBool(PREF_PROFILE_DN);
end;

function getProfileDNMap(): WideString;
begin
    Result := DNSession.Prefs.getString(PREF_PROFILE_DN_MAP);
end;

function IsProfileEnabled(): Boolean;
begin
    Result := useProfileDN() and DNSession.Authenticated;
end;

procedure FireProfileFetchResultEvent(UID: Widestring; dn: widestring; ResultError: boolean);
var
    ResultTag: TXMLtag;
begin
    ResultTag := TXMLtag.Create('profiledn');
    ResultTag.setAttribute('jid', UID);
    if (ResultError) then
        ResultTag.setAttribute('resulterror', 'true')
    else
        ResultTag.setAttribute('resulterror', 'false');
    ResultTag.setAttribute('dn', dn);

    DNSession.FireEvent(DISPLAYNAME_EVENT_PROFILE, ResultTag);
    ResultTag.Free();
end;

procedure FireChangeEvent(UID: WideString; dn: widestring; update: Boolean = false);
var
    changeTag: TXMLtag;
begin
    changeTag := TXMLtag.Create('dispname');
    changeTag.setAttribute('uid', UID);
    changeTag.setAttribute('dn', dn);
    if update then changeTag.setAttribute('update', 'true');
    
    DNSession.FireEvent(DISPLAYNAME_EVENT_UPDATE, changeTag);
    changeTag.Free();
end;

{-------------------------------------------------------------------------------
 ---------------------------- TMyNickHandler -----------------------------------
 ------------------------------------------------------------------------------}
{ a helper class to set our nickname from profile}
type
    TMyNickHandler = class(TDisplayNameEventListener)
    private
        _fired: Boolean;
        
    public
        procedure FireOnDisplayNameChange(UID: Widestring; displayName: WideString); override;
        procedure FireOnProfileResult(BareJID: Widestring; ProfileName: WideString; FetchError: boolean);override;
        procedure GetMyNickFromProfile();
        procedure UpdateRosterName(dname: WideString);
        Constructor Create(MyItem: TDisplayNameItem); Reintroduce; overload;
        Destructor Destroy(); override;
    end;

Constructor TMyNickHandler.Create(MyItem: TDisplayNameItem);
begin
    inherited Create();
    UID := myItem.UID;
end;

Destructor TMyNickHandler.Destroy();
begin
    inherited;
end;

procedure TMyNickHandler.FireOnDisplayNameChange(UID: WideString; displayName: WideString);
begin
    FireOnProfileResult(UID, displayName, false);
end;
procedure TMyNickHandler.fireOnProfileResult(BareJID: Widestring; ProfileName: WideString; FetchError: boolean);
begin
    if _fired then exit;
    
    _fired := true;
    if (not FetchError) then
        UpdateRosterName(ProfileName);
    Self.Free();
end;

procedure TMyNickHandler.getMyNickFromProfile();
var
    changePending: boolean;
    dname: WideString;
    jid: TJabberID;
begin
    jid := TJabberID.Create(UID);
    dName := Self.getProfileDisplayName(jid, changePending);

    if (not changePending) then begin
        fireOnProfileResult(UID, dName, false);
    end;
    jid.Free();
end;

procedure TMyNickHandler.UpdateRosterName(dname: WideString);
var
    myself: TDisplayNameItem;
begin
    myself := getDisplayNameCache().getDNItem(UID);
    if (myself.DisplayName[dntItemName] <> dname) then
    begin
        DNSession.Prefs.setString('default_nick', dName);
        myself.DisplayName[dntItemName] := dname;
        FireChangeEvent(UID, dname);
    end;
end;

{-------------------------------------------------------------------------------
 ------------------------ TDisplayNameEventListener ----------------------------
 ------------------------------------------------------------------------------}
Constructor TDisplayNameEventListener.Create();
begin
    _DNCB := -1;
    _OnDisplayNameChange := nil;
    _OnProfileResult := nil;
    _UID := '';
    _DNCB := DNSession.RegisterCallback(DNCallback, DISPLAYNAME_EVENT_UPDATE);
    _ProfileResultCB := DNSession.RegisterCallback(ProfileResultCallback, DISPLAYNAME_EVENT_PROFILE);
end;

Destructor TDisplayNameEventListener.Destroy();
begin
    if (DNSession <> nil) then
    begin
        DNSession.UnRegisterCallback(_DNCB);
        DNSession.UnRegisterCallback(_ProfileResultCB);
    end;
    inherited;
end;

procedure TDisplayNameEventListener.fireOnDisplayNameChange(UID: Widestring;
                                                            DisplayName: WideString);
begin
    if (assigned(_OnDisplayNameChange)) then
        _OnDisplayNameChange(UID, DisplayName);
end;
procedure TDisplayNameEventListener.fireOnDisplayNameUpdate(UID: Widestring;
                                                            DisplayName: WideString);
begin
    if (assigned(_OnDisplayNameUpdate)) then
        _OnDisplayNameUpdate(UID, DisplayName);
end;

procedure TDisplayNameEventListener.fireOnProfileResult(BareJID: Widestring;
                                                        ProfileName: WideString;
                                                        FetchError: boolean);
begin
    if (assigned(_OnProfileResult)) then
        _OnProfileResult(BareJID, ProfileName, FetchError);
end;

procedure TDisplayNameEventListener.ProfileResultCallback(event: string; tag: TXMLTag);
var
    eUID: WideString;
begin
    eUID := tag.GetAttribute('jid');

    if (_UID = '') or (_UID = eUID) then
    begin
        fireOnProfileResult(eUID, tag.GetAttribute('dn'), (tag.GetAttribute('resulterror') = 'true'));
    end;
end;

procedure TDisplayNameEventListener.DNCallback(event: string; tag: TXMLTag);
var
    eUID: WideString;
    update: Widestring;
    dn: Widestring;
begin
    eUID := tag.GetAttribute('uid');
    if (_UID = '') or (_UID = eUID) then
    begin
        update := tag.GetAttribute('update');
        dn := tag.GetAttribute('dn');
        if (update = 'true') then
            FireOnDisplayNameUpdate(eUID, dn);
        FireOnDisplayNameChange(eUID, dn);
    end;
end;

class function TDisplayNameEventListener.getDisplayName(uid: Widestring; out PendingNameChange: Boolean): WideString;
var
    tJID: TJabberID;
begin
    tJID := TJabberID.Create(uid);
    Result := GetDisplayNameCache().getDisplayName(tJID, PendingNameChange);
    tJID.free();
end;

class function TDisplayNameEventListener.getDisplayName(uid: Widestring): WideString;
var
    ignore: boolean;
begin
    Result := GetDisplayName(uid, ignore);
end;

class function TDisplayNameEventListener.getProfileDisplayName(BareJID: TJabberID; out pendingNameChange: Boolean): WideString;
begin
    REsult := GetDisplayNameCache().getProfileDisplayName(BareJID, PendingNameChange);
end;

class function TDisplayNameEventListener.ProfileEnabled(): Boolean;
begin
    Result := IsProfileEnabled();
end;


{-------------------------------------------------------------------------------
 --------------------------- TProfileParser ------------------------------------
 ------------------------------------------------------------------------------}
Constructor TProfileParser.Create();
begin
    _parsedProfileMap := TWidestringList.Create();
    _profileMapStr := '';
    _regEx := TRegExpr.Create();
    _regEx.Expression := PROFILE_MAP_REGEX;
    _regEx.Compile();
end;

Destructor  TProfileParser.Destroy();
begin
    _parsedProfileMap.Free();
    _regEx.Free();
end;

procedure TProfileParser.setProfileParseMap(profileMap: Widestring);
begin
    _profileMapStr := profileMap;
end;

function TProfileParser.parseProfile(profileTag: TXMLTag; var displayName: WideString): boolean;
var
    strPos: integer;
    tstr: WideString;
    key: WideString;
    tags: TXMLTagList;
    foundAll: boolean;
begin
    strPos := 1;
    foundAll := true;
    if (_regEx.Exec(_profileMapStr)) then begin
        repeat
            displayName := displayName + Copy(_profileMapStr, strPos, _regEx.MatchPos[0] - strPos);
            tstr := _regEx.Match[0];
            key := WideUpperCase(Copy(tstr, 2, Length(tstr) - 2)); //strip {}
            tags := profileTag.QueryRecursiveTags(key, true);
            if ((tags.Count > 0) and (Trim(tags[0].Data) <> '')) then
                displayName := displayName + tags[0].data
            else begin
                displayName := displayName + tstr;
                foundAll := false;
            end;
            tags.Free();
            strPos := _regEx.MatchPos[0] + _regEx.MatchLen[0];
        until (not _regEx.ExecNext);
    end
    else displayName := _profileMapStr;
    Result := foundAll;
end;


{-------------------------------------------------------------------------------
 -------------------------- TDisplayNameItem -----------------------------------
 ------------------------------------------------------------------------------}
Constructor TDisplayNameValue.Create(dnType: WideString);
begin
    _dnType := dnType;
    _dnValue := '';
end;

constructor TDisplayNameItem.create(UID: WideString);
var
    sType: array[0..1] of WideString;
begin
    inherited create();
    _UID := UID;
    _DisplayNames := TObjectList.Create(true);
    sType[0] := dntDefault;
    sType[1] := dntItemName;
    SetSupportedDisplayNameTypes(sType);

    DisplayName[dntDefault] := _UID;
    _currentDisplayName := DisplayName[dntDefault];
end;

destructor  TDisplayNameItem.Destroy();
begin
    _DisplayNames.Free(); //frees TDisplayName Value objects
    inherited;
end;

function TDisplayNameItem.GetBestExistingDisplayName(): WideString;
begin
    Result := DisplayName[dntItemName];
    if (Result = '') then
        Result := DisplayName[dntDefault];
end;

function TDisplayNameItem.indexOf(DNType: Widestring): integer;
begin
    for Result := 0 to _DisplayNames.Count - 1 do
        if (TDisplayNameValue(_DisplayNames[Result]).DNType = DNType) then
            exit;
    Result := -1;
end;

function TDisplayNameItem.GetDisplayNames(DNType: WideString): Widestring;
var
    i: integer;
begin
    i := IndexOf(DNType);
    if (i <> -1) then
        Result := TDisplayNameValue(_DisplayNames[i]).Value
    else
        Result := ''; //failed, no value
end;

procedure TDisplayNameItem.SetDisplayNames(DNType: WideString; value: widestring);
var
    i: integer;
begin
    i := IndexOf(DNType);
    if (i <> -1) then
        TDisplayNameValue(_DisplayNames[i]).Value := value;
    //ignore if not in list
end;

function TDisplayNameItem.GetDisplayNamesCount(): Integer;
begin
    Result := _DisplayNames.Count;
end;

procedure TDisplayNameItem.SetSupportedDisplayNameTypes(dntTypes: array of Widestring);
var
    i: integer;
begin
    _DisplayNames.Clear();
    for i := 0 to Length(dntTypes) - 1 do
        _DisplayNames.Add(TDisplayNameValue.Create(dntTypes[i]));
end;

function TDisplayNameItem.IsTypeSupported(DNType: WideString): boolean;
begin
    Result := IndexOf(DNType) <> -1;
end;

function TDisplayNameItem.getDisplayName(out pendingNameChange: boolean; UseCacheOnly: boolean): WideString;
begin
    pendingnameChange := false;
    Result := GetBestExistingDisplayName();
    _currentDisplayName := Result;
end;


procedure TDisplayNameItem.OnPrefChange();
begin
    //doesn;t handle prefs
end;

Function TDisplayNameItem.UpdateDisplayName(Item: IExodusItem; InitialUpdate: boolean): Boolean;
var
    FoundName: WideString;
begin
    Result := false;
    if (Item = nil) then exit;

    FoundName := Item.value['Name'];
    if (FoundName <> '') and (FoundName <>  DisplayName[dntItemName]) then
    begin
        DisplayName[dntItemName] := FoundName;
        if (not InitialUpdate) then begin
            _CurrentDisplayName := DisplayName[dntItemName];
            FireChangeEvent(UID, _CurrentDisplayName, true);
        end;
        Result := true;
    end;
end;

{-------------------------------------------------------------------------------
 ----------------------- TContactDisplayNameCache ------------------------------
 ------------------------------------------------------------------------------}
constructor TContactDisplayNameItem.create(jid: TJabberID; profileParser: TProfileParser);
var
    sTYpes: Array[0..2] of WideString;
begin
    _jid := TJabberID.Create(jid);

    inherited create(_jid.jid); //UID is bare JID

    sTypes[0] := dntDefault;
    sTypes[1] := dntItemName;
    sTypes[2] := dntProfile;
    Self.SetSupportedDisplayNameTypes(sTypes);

    if (_jid.user <> '') then
        DisplayName[dntDefault] := _jid.removeJEP106(_jid.user);
    //if service or server or something, default will be set to uid (jid) by parent class

    _DNFetch := false;
    _StandAloneFetch := false;

    _fetchFailed := false;

    _profileParser := profileParser;

    _currentDisplayName := ''; //start off blank to force refresh events
end;

destructor TContactDisplayNameItem.Destroy();
begin
    _jid.Free();
    inherited;
end;

function TContactDisplayNameItem.GetBestExistingDisplayName(): WideString;
begin
    Result := DisplayName[dntItemName];
    if ((Result = '') and IsProfileEnabled()) then
        Result := DisplayName[dntProfile];
    if (Result = '') then
        Result := DisplayName[dntDefault];
end;

procedure TContactDisplayNameItem.SetVCard(vcard: TXMLVCard);
begin
    _vCard := vcard;
end;

function TContactDisplayNameItem.ParseVCard(out ProfileDisplayName: WideString): boolean;
var
    tag: TXMLTag;
begin
    Result := false;
    if (_vCard <> nil) then begin
        tag := TXMLTag.Create();
        _vCard.fillTag(tag);

        Result := _profileParser.parseProfile(tag.GetFirstTag('vCard'), ProfileDisplayName) and
                (ProfileDisplayName <> '');

        tag.Free();
    end;
end;

procedure TContactDisplayNameItem.VCardCallback(jid: Widestring; vcard: TXMLVCard);
var
    tstr: Widestring;
begin
    _fetchPending := false;
    _fetchFailed := (vcard = nil);
    SetVCard(vcard);

    if (ParseVCard(tstr)) then begin
        DisplayName[dntProfile] := tstr;
        //fire change event if
        //not using roster, profile DN is enabled and name actually changed
        if ((DisplayName[dntItemName] = '') and
            IsProfileEnabled() and
            (tstr <> CurrentDisplayName)) then
        begin
            _CurrentDisplayName := tstr;
            FireChangeEvent(UID, tstr);
        end;
    end
    else begin
        _fetchFailed := true; //failed to parse, same as actual fetch failing
        DisplayName[dntProfile] := '';

        //fire failed result event if stand alone fetch
        if (_standAloneFetch) then
            FireProfileFetchResultEvent(UID, '', true);

        //if this fetch was part of DN lookup, fire change event with current DN
        //something might be waiting on the "pendingResults" flag.
        if (_DNFetch) then
            FireChangeEvent(UID, _CurrentDisplayName);

        _DNFetch := false;
        _StandAloneFetch := false;

        //an edge case not covered. We had a good profile name that was the DN,
        //but somehow this lookup failed. Should probably update the DN, but
        //I can't think why this fetch would ever fail, so it would be paranoid.
    end;
end;

procedure TContactDisplayNameItem.OnVCardResult(vcard: TXMLVCard);
var
    tstr: Widestring;
    goodParse: boolean;
begin
    if _fetchPending then exit; //pending fetches will update later
    _FetchFailed := false;      //only got here if a vcard was fetched

    SetVCard(vcard);

    goodParse := ParseVCard(tstr);
    if (goodParse) then
    begin
        DisplayName[dntProfile] := tstr;
        //fire change event if
        //not using roster, profile DN is enabled and name actually changed
        if ((DisplayName[dntItemName] = '') and
            IsProfileEnabled() and
            (tstr <> CurrentDisplayName)) then
        begin
            _CurrentDisplayName := tstr;
            FireChangeEvent(UID, tstr);
        end;
    end
    else begin
        _FetchFailed := true; //couldn't prase vcard 
        DisplayName[dntProfile] := '';
        //if this fetch was part of DN lookup, fire change event with current DN
        //something might be waiting on the "pendingResults" flag.
        if (_DNFetch) then
            FireChangeEvent(UID, _CurrentDisplayName);

        //TODO : need to handle pref changes. I think the following is not valid in that case

        //an edge case not covered. We had a good profile name that was the DN,
        //but somehow this lookup failed. Should probably update the DN, but
        //I can't think why this would ever fail, so it would be paranoid.
    end;

    //if profile has been stand alone requested, fire result event
    if (_StandAloneFetch) then
        FireProfileFetchResultEvent(UID, DisplayName[dntProfile], not goodParse);

    _StandAloneFetch := false;
    _DNFetch := false;
end;

function TContactDisplayNameItem.FetchProfileDN(out pendingNameChange: boolean; UseCacheOnly: boolean=false): WideString;
begin
    Result := DisplayName[dntProfile];

    if (Result = '') then begin //no current profile name
        Result := DisplayName[dntItemName];

        if (Result = '') then
            Result := DisplayName[dntDefault];

        if (not _fetchFailed) and (not _fetchPending) and (not UseCacheOnly) then
        begin
            _fetchPending := true;
            GetVCardCache().find(_jid.jid, VCardCallback);
        end;

        if (not _fetchPending) and (not UseCacheOnly) then begin
            //Once more (but cache only), because the callback might have hit synchronously
            Result := FetchProfileDN(pendingNameChange, true);
        end;
    end;

    _currentDisplayName := Result;
    pendingNameChange := _fetchPending;
end;

function TContactDisplayNameItem.getDisplayName(out pendingNameChange: boolean; UseCacheOnly: boolean): WideString;
begin
    pendingnameChange := false;
    Result := DisplayName[dntItemName];
    if (Result = '') then
    begin
        if (IsProfileEnabled()) then
        begin
            Result := FetchProfileDN(pendingNameChange, UseCacheOnly);
            //fetch would be part of a DN lookup
            _DNFetch :=  pendingNameChange; //
        end
        else Result := DisplayName[dntDefault];
    end;
end;

function TContactDisplayNameItem.getProfileDisplayName(out pendingNameChange: boolean; UseCacheOnly: boolean): WideString;
begin
    //if we don't have a profile DN and we failed a fetch, return current DN
    //and fire fetch result event
    if ((DisplayName[dntProfile] = '') and _FetchFailed) then
        FireProfileFetchResultEvent(UID, CurrentDisplayName, true)
    else
    begin
        Result := FetchProfileDN(pendingNameChange, UseCacheOnly);
        //fetch would be part of a Stand Alone lookup
        _StandAloneFetch :=  pendingNameChange;
        //if not pending, fire success event
        if (not pendingNameChange) then        
            FireProfileFetchResultEvent(UID, CurrentDisplayName, false);
    end;
end;


procedure TContactDisplayNameItem.OnPrefChange();
var
    ignore: boolean;
    dname: widestring;
begin
    //clear profile and get display name again. this will force a refresh
    //where needed.
    DisplayName[dntProfile] := '';
    //may have a cached vcard, all we need to do is reparse
    if (ParsevCard(dname)) then
        DisplayName[dntProfile] := dname;        
        
    GetDisplayName(ignore);
end;

{-------------------------------------------------------------------------------
 -------------------------- TDisplayNameCache ----------------------------------
 ------------------------------------------------------------------------------}
Constructor TDisplayNameCache.create();
begin
    inherited;
    _dnCache := TWideStringList.Create();
    _js := nil;
    _sessioncb := -1;
    _VCardResultCB := -1;
    _profileParser := TProfileParser.Create();
end;

Destructor TDisplayNameCache.Destroy();
begin
    setSession(nil);
    _dnCache.Free();
    _profileParser.Free();
    inherited;
end;

function TDisplayNameCache.getOrAddDNItem(UID: Widestring): TDisplayNameItem;
begin
    Result := getDNItem(UID);
    if (Result = nil) then
    begin
        Result := TDisplayNameItem.create(UID);
        addDNItem(Result);
    end;
end;

function TDisplayNameCache.getOrAddDNItem(JID: TJabberID): TDisplayNameItem;
begin
    if (JID.user = '') then
        Result := getOrAddDNItem(JID.jid) //if service, just treat like a non jid
    else begin
        Result := getDNItem(JID.jid);
        if (Result = nil) then
        begin
            Result := TContactDisplayNameItem.create(jid, _profileParser);
            addDNItem(Result);
        end;
    end;
end;

procedure TDisplayNameCache.setSession(js: TObject);
begin
    if (_js <> nil) then
    begin
        if (_sessionCB <> -1) then
            TJabberSession(_js).UnRegisterCallback(_sessionCB);
        _sessionCB := -1;

        if (_VCardResultCB <> -1) then
            TJabberSession(_js).UnRegisterCallback(_VCardResultCB);
        _VCardResultCB := -1;
        _depResolver.Free();
    end;

    clearDNCache();

    _js := js;
    DNSession := TJabberSession(js);
    if (_js <> nil) then
    begin
        _depResolver := TSimpleAuthResolver.create(OnDependancyReady, DEPMOD_LOGGED_IN);
        _sessioncb := TJabberSession(_js).RegisterCallback(SessionCallback, '/session');
    end;
end;

{
    Roster name trumps all.

    If we receive a roster item update set the corresponding items displayname
    to the new roster name. Don't fire a change event if adding to the
    cache (pass cache state alnog to item)
}
procedure TDisplayNameCache.UpdateDisplayName(Item: IExodusItem);
var
    dnItem: TDisplayNameItem;
    jid: TJabberID;
    InCache: boolean;
begin
    if (Item = nil) then exit; //probably paranoid
    InCache := (GetDNItem(Item.Uid) <> nil);
    if (Item.Type_ = EI_TYPE_CONTACT) then
    begin
        jid := TJabberID.create(Item.Uid);
        dnItem := getOrAddDNItem(jid);
        jid.Free();
    end
    else dnItem := getOrAddDNItem(Item.UID);

    dnItem.UpdateDisplayName(Item, not InCache);
end;

procedure TDisplayNameCache.OnDependancyReady(tag: TXMLTag);
var
    dnItem: TDisplayNameItem;
    tstr: WideString;
    locked: boolean;
begin
    _useProfileDN := useProfileDN(); //initial profile state, used to check pref changes
    //add our jid to the cache
    dnItem := getOrAddDNItem(DNSession.SessionJid);

    _profileParser.setProfileParseMap(getProfileDNMap());
    //at this point our nick is our node.
    tstr := DNSession.Prefs.getString('default_nick');
    locked := DNSession.Prefs.getBool('brand_prevent_change_nick');

    //if nick name is not locked and we have a default nick, make the roster dn name that nickname
    if ((not locked) and (tstr <> '')) then begin
        dnItem.DisplayName[dntItemName] := tstr;
        FireChangeEvent(dnItem.UID, tstr);
    end
    else if (locked or (tstr = '')) then begin
        //if nick name is "locked down" or no default nick is supplied, pull our nick from vcard.
        TMyNickHandler.Create(dnItem).GetMyNickFromProfile();
    end;

    //fire a displayname ready event
    TAuthDependancyResolver.SignalReady(DEPMOD_DISPLAYNAME);
end;

procedure TDisplayNameCache.SessionCallback(event: string; tag: TXMLTag);
var
    tstr: WideString;
    prefChanged : boolean;
    i: integer;
begin
    if (event = '/session/disconnected') then
        //clear cache on disconnect
        clearDNCache()
    else if (event = '/session/prefs') then begin
        //if we've had a pref change for profile, update accordingly...
        tstr := getProfileDNMap();
        prefChanged := (ProfileParser.ProfileMapString <>  tstr);
        if  (prefChanged) then
            ProfileParser.setProfileParseMap(tstr);

        prefChanged := prefChanged or (_UseProfileDN <> UseProfileDN());
        if (prefChanged) then
        begin
            //walk cache and refresh items based on new prefs
            for i := 0 to _dnCache.Count - 1 do
            begin
                TDisplayNameItem(_dnCache.Objects[i]).OnPrefChange();
            end;
        end;

        { JJF not updating for now, not sure what to do here
        todo: check prefs and fire session/displayname event for each actual change
        for idx := 0 to _dnCache.Count - 1 do begin
            TDisplayNameItem(_dnCache.Objects[idx]).OnPrefChange();
        end;
        }
    end
    else if (event = '/session/vcard/update') then begin
        VCardResultCallback(event, tag);
    end;
end;

procedure TDisplayNameCache.VCardResultCallback(event: string; tag: TXMLTag);
var
    JID: TJabberID;
    DNI: TDisplayNameItem;
    vcard: TXMLVCard;
begin

    JID := TJabberID.Create(tag.GetAttribute('from'));
    DNI := getOrAddDNItem(JID);
    
    vcard := GetVCardCache().VCards[JID.jid];
    TContactDisplayNameItem(DNI).VCardCallback(JID.jid, vcard);

    JID.Free();
end;

function TDisplayNameCache.getDNItem(jid: TJabberID): TDisplayNameItem;
begin
    Result := GetDNItem(jid.jid);
end;

function TDisplayNameCache.getDNItem(UID: WideString): TDisplayNameItem;
var
    i: Integer;
begin
    i := _dnCache.IndexOf(UID);
    if (i <> -1) then
        Result := TDisplayNameItem(_dnCache.Objects[i])
    else
        Result := nil;
end;

procedure TDisplayNameCache.removeDNItem(dnItem: TDisplayNameItem);
var
    i: integer;
begin
    i := _dnCache.IndexOf(dnItem.UID);
    if (i <> -1) then begin
        _dnCache.Objects[i].Free();
        _dnCache.Delete(i);
    end;
end;

procedure TDisplayNameCache.addDNItem(dnItem: TDisplayNameItem);
begin
    if (_dnCache.IndexOf(dnItem.UID) = -1) then
        _dnCache.AddObject(dnItem.UID, dnItem)
end;

procedure TDisplayNameCache.clearDNCache();
var
    i : integer;
begin
    for i := _dnCache.Count - 1 downto 0 do begin
        _dnCache.Objects[i].Free();
    end;
    _dnCache.Clear();
end;

function TDisplayNameCache.getDisplayName(jid: TJabberID; out pendingNameChange: boolean; UseCacheOnly: boolean): Widestring;
begin
    Result := getOrAddDNItem(jid).getDisplayName(pendingNameChange, UseCacheOnly);
end;

function TDisplayNameCache.getDisplayNameAndFullJID(jid: TJabberID): Widestring;
var
    ignored: boolean;
begin
    Result := getOrAddDNItem(jid).getDisplayName(ignored, true);
    Result := Result + ' <' + jid.GetDisplayFull() + '>';
end;

function TDisplayNameCache.getDisplayNameAndBareJID(jid: TJabberID): Widestring;
var
    ignored: boolean;
begin
    Result := getOrAddDNItem(jid).getDisplayName(ignored, true);
    Result := Result + ' <' + jid.getDisplayJID() + '>';
end;

function TDisplayNameCache.getDisplayName(jid: TJabberID): Widestring;
var
    ignored: boolean;
begin
    Result := getDisplayName(jid, ignored);
end;

function TDisplayNameCache.getDisplayName(uid: widestring): Widestring;
var
    ignored: boolean;    
begin
    Result := GetOrAddDNItem(uid).getDisplayName(ignored);
end;

function TDisplayNameCache.getProfileDisplayName(jid: TJabberID; out pendingNameChange: boolean): WideString;
begin
    Result := TContactDisplayNameItem(getOrAddDNItem(jid)).getProfileDisplayName(pendingNameChange);
end;

function TDisplayNameCache.HasProfileDisplayName(UID: WideString): boolean;
var
    DNItem: TDisplayNameItem;
begin
    DNItem := GetDNItem(UID);
    Result := (DNItem <> nil) and
              (DNItem is TContactDisplayNameItem) and
              TContactDisplayNameItem(DNItem).HasProfileDisplayName;
end;

initialization
    _DisplayNameCache := TDisplayNameCache.create();

finalization
    _DisplayNameCache.Free();
    _DisplayNameCache := nil;    
end.
