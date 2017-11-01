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
unit Session;


{$ifdef VER150}
    {$define INDY9}
{$endif}

interface

uses
    PrefController,
    JabberAuth, Chat, ChatController,
    Presence, COMExodusItem,
    Signals, XMLStream, XMLTag, Unicode,
    Contnrs, Classes, SysUtils, JabberID, GnuGetText, idexception, 
    COMExodusItemController, ContactController, Exodus_TLB, RoomController,
    ExtCtrls;
type
    TJabberAuthType = (jatZeroK, jatDigest, jatPlainText, jatNoAuth);

    TJabberSession = class
    private
        _stream: TXMLStream;
        _register: boolean;
        _stream_id: WideString;
        _show: WideString;
        _status: WideString;
        _extensions: TWideStringList;
        _priority: integer;
        _invisible: boolean;
        _profile: TJabberProfile;
        _features: TXMLTag;
        _xmpp: boolean;
        _cur_server: Widestring;
        _tls_cb: integer;
        _ssl_on: boolean;
        _compression_cb: integer;
        _compression_err_cb: integer;
        _compression_on: boolean;
        _lang: WideString;
        _sent_stream: boolean;

        // Dispatcher
        _dispatcher: TSignalDispatcher;

        // main packet handling signals
        _filterSignal: TPacketSignal;
        _preSignal: TPacketSignal;
        _packetSignal: TPacketSignal;
        _postSignal: TPacketSignal;
        _sessionSignal: TBasicSignal;
        _unhandledSignal: TBasicSignal;

        // other signals
        _itemSignal: TItemSignal;
        _presSignal: TPresenceSignal;
        _dataSignal: TStringSignal;
        _winSignal: TPacketSignal;
        _chatSignal: TChatSignal;

        _depHandler: TObject; //TSessionDependancyHandler

        // other misc. flags
{** JJF msgqueue refactor
        _paused: boolean;
        _resuming: boolean;
        _pauseQueue: TQueue;
**}
        _id: longint;
        _cb_id: longint;
        _authd: boolean;
        _first_pres: boolean;
        _avails: TWidestringlist;
        _auth_agent: TJabberAuth;
        _no_auth: boolean;
        //_intfItemController: IExodusItemController;

        _sjid: TJabberID;   //differentiate between auth and session

        procedure StreamCallback(msg: string; tag: TXMLTag);

        procedure SetUsername(username: WideString);
        procedure SetPassword(password: WideString);
        procedure SetServer(server: WideString);
        procedure SetResource(resource: WideString);
        procedure SetPort(port: integer);

        function GetSessionJid(): TJabberID;
        procedure SetSessionJid(jid: TJabberID);

        procedure handleDisconnect();
        procedure manualBlastPresence(p: TXMLTag);
        procedure StartSession(tag: TXMLTag);
        procedure ResetStream();
        procedure StartTLS();
        procedure StartCompression(method: Widestring);

        function GetUsername(): WideString;
        function GetPassword(): WideString;
        function GetServer(): WideString;
        function GetResource(): WideString;
        function GetPort(): integer;
        function GetFullJid(): Widestring;
        function GetBareJid(): Widestring;
        function GetActive(): boolean;

        procedure doConnect();

        procedure DataEvent(send: boolean; data: Widestring);
        procedure SessionCallback(event: string; tag: TXMLTag);
        procedure BindCallback(event: string; tag: TXMLTag);
        procedure TLSCallback(event: string; tag: TXMLTag);
        procedure CompressionCallback(event: string; tag: TXMLTag);
        procedure CompressionErrorCallback(event: string; tag: TXMLTag);

        procedure OnAllDependanciesResolved(SessionTag : TXMLTag);
        procedure OnRosterRefreshTimer(Sender: TObject);
    public
        ppdb: TJabberPPDB;
        ItemController: IExodusItemController;
        roster: TContactController;
        rooms: TRoomController;
        //bookmarks: TBookmarkManager;
        ChatList: TJabberChatList;
        Prefs: TPrefController;
        dock_windows: boolean;
        Presence_XML: TWideStringlist;
        RosterRefreshTimer: TTimer;
        Constructor Create(ConfigFile: widestring);
        Destructor Destroy; override;

        procedure CreateAccount;
        procedure Connect;
        procedure Disconnect;

        // AuthAgent stuff
        procedure setAuthAgent(new_auth: TJabberAuth);
        {*
            Create an auth agaent from current profile information UNLESS
            already assigned. nop if already assigned.
        *}
        procedure checkAuthAgent();
        procedure setAuthdJID(user, host, res: Widestring);
        procedure setAuthenticated(ok: boolean; tag: TXMLTag; reset_stream: boolean);
        function  getAuthAgent: TJabberAuth;

        procedure setPresence(show, status: WideString; priority: integer);

        function RegisterCallback(callback: TPacketEvent; xplite: Widestring; pausable: boolean = false): integer; overload;
        function RegisterCallback(callback: TItemEvent; event: Widestring): integer; overload;
        function RegisterCallback(callback: TPresenceEvent): integer; overload;
        function RegisterCallback(callback: TDataStringEvent): integer; overload;
        function RegisterCallback(callback: TChatEvent): integer; overload;
        procedure UnRegisterCallback(index: integer);

        procedure FireEvent(event: string; tag: TXMLTag); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const p: TJabberPres); overload;
        procedure FireEvent(event: string; const item: IExodusItem); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const data: WideString); overload;
        procedure FireEvent(event: string; tag: TXMLTag; const controller: TChatController); overload;

        procedure SendTag(tag: TXMLTag);
        procedure ActivateProfile(i: integer);
        procedure ActivateDefaultProfile();
        
{** JJF msgqueue refactor
        procedure Pause;
        procedure Play;
        procedure QueueEvent(event: string; tag: TXMLTag; Callback: TPacketEvent);
**}
        function generateID: WideString;
        function IsBlocked(jid : WideString): boolean;  overload;
        function IsBlocked(jid : TJabberID): boolean; overload;
        function getDisplayUsername(): widestring;

        procedure RefreshBlockers();
        procedure Block(jid : TJabberID);
        procedure UnBlock(jid : TJabberID);     

        procedure addAvailJid(jid: Widestring);
        procedure removeAvailJid(jid: Widestring);

        // Account information
        property Username: WideString read GetUsername write SetUsername;
        property Password: WideString read GetPassword write SetPassword;
        property Server: WideString read GetServer write SetServer;
        property Resource: WideString read GetResource write SetResource;
        property Jid: Widestring read GetFullJid;
        property BareJid: Widestring read GetBareJid;
        property Port: integer read GetPort write SetPort;
        property Profile: TJabberProfile read _profile;

        // Presence Info
        property Priority: integer read _priority write _priority;
        property Show: WideString read _show;
        property Status: WideString read _status;
        property SessionJid: TJabberID read GetSessionJid;

        // Stream stuff
        property Stream: TXMLStream read _stream;
        property StreamID: Widestring read _stream_id;
        property Dispatcher: TSignalDispatcher read _dispatcher;
{** JJF msgqueue refactor
        property IsPaused: boolean read _paused;
        property IsResuming: boolean read _resuming;
**}
        property Invisible: boolean read _invisible write _invisible;
        property Active: boolean read GetActive;
        property isXMPP: boolean read _xmpp;
        property xmppFeatures: TXMLTag read _features;
        property SSLEnabled: boolean read _ssl_on;
        property xmlLang: WideString read _lang;
        property CompressionEnabled: boolean read _compression_on;

        // Auth info
        property NoAuth: boolean read _no_auth write _no_auth;
        property AuthAgent: TJabberAuth read _auth_agent;
        property Authenticated: boolean read _authd;
    end;

    {------------------------ TSessionListener --------------------------------}
    TDisconnectEvent = procedure(ForcedDisconnect: boolean; Reason: WideString) of object;
    TAuthenticatedEvent = procedure () of object;

    TSessionListener = class
    private
        _OnAuthEvent: TAuthenticatedEvent;
        _OnDisconnectEvent: TDisconnectEvent;
        _Session: TJabberSession;

        _ReceivedError: WideString;
        _Authenticated: Boolean;

        _SessionCB: integer;
    protected
        procedure FireAuthenticated(); virtual;
        procedure FireDisconnected(); virtual;

        procedure SessionListenerCallback(event: string; tag: TXMLTag);
    public
        Constructor Create(OnAuthenticated: TAuthenticatedEvent; OnDisconnect: TDisconnectEvent; JabberSession: TJabberSession = nil);
        Destructor Destroy(); override;
    end;


    {------------------------ TDependancyHandler ------------------------------}
    { a helper class that tracks session/ready and fires an event when all
      given dependancies signal ready. Assumes /session/ready/session is
      one of the signals caught, so the original tag can be accessed. If not
      in the dependacy list, session is auto added }

const
    DEPMOD_LOGGED_IN    = 'logged-in';
    DEPMOD_VCARD_CACHE  = 'vcard-cache';
    DEPMOD_DISPLAYNAME  = 'displayname';
    DEPMOD_ROSTER       = 'roster';
    DEPMOD_BOOKMARKS    = 'bookmarks';
    DEPMOD_GROUPS       = 'groups';
    DEPMOD_UI           = 'ui';
    DEPMOD_CAPS_CACHE   = 'caps-cache';
    DEPMOD_ENTITY_CACHE = 'entity-cache';
type
    TModuleInfo = record
        module: widestring;
        ready: boolean;
    end;
    
    TDepModInfoArray = array of TModuleInfo;
    //TDependancyHandler owns sessiontag and will destroy it after OnREsolved is fired
    TAllResolvedEvent = procedure(tag: TXMLTag) of object;
    TResolvedEvent = procedure(module: widestring; tag: TXMLTag) of object;

    TAuthDependancyResolver = class
    private
        _dependancyCB: integer;
        _sessionDisconnectCB: integer;

        _dependancies: TDepModInfoArray;

        _OnAllResolved: TAllResolvedEvent;
        _onResolved: TResolvedEvent;

        _firedAllResolved: boolean;
    protected
        procedure DependancyCallback(event: string; tag: TXMLTag);virtual;
        procedure FireOnAllResolved(tag: TXMLTag = nil);virtual;
        procedure FireOnResolved(module: widestring; tag: TXMLTag = nil);virtual;
        function IndexOfModule(module: widestring): integer;
        function AllReady(): boolean;virtual;
        procedure ResetState(); virtual;
    public
        constructor create(); overload; virtual;
        constructor create(depmods: TDepModInfoArray);overload; virtual;
        constructor create(depmods: Array of TModuleInfo);overload; virtual;

        destructor Destroy(); override;

        class procedure SignalReady(Module: widestring; tag: TXMLTag = nil);

        property OnResolved: TResolvedEvent read _OnResolved write _OnResolved;
        property OnAllResolved: TAllResolvedEvent read _OnAllResolved write _OnAllResolved;
    end;

    TSimpleAuthResolver = class(TAuthDependancyResolver)
    public
        constructor create(OnResolved: TAllResolvedEvent; Module: widestring = DEPMOD_LOGGED_IN); reintroduce; overload; virtual;
    end;

var
    MainSession: TJabberSession;

implementation
uses
    {$ifdef Win32}
    Forms, Dialogs,
    {$else}
    QForms, QDialogs,
    {$endif}
    EntityCache, CapsCache,
    DisplayName, //display name cache
    PluginAuth,
    Profile,
    RoomProperties,
    StrUtils,
    XMLUtils, XMLSocketStream, XMLHttpStream, IdGlobal, IQ,
    JabberConst, CapPresence, XMLVCard, XMLVCardCache, Windows, JabberUtils,
    ExUtils;

const
    DEPMOD_READY_EVENT = '/dependancy/ready/';
    DEPMOD_LOGGED_IN_EVENT = DEPMOD_READY_EVENT + DEPMOD_LOGGED_IN;

    ALL_DEPENDANT_MODULES: array[0..8] of TModuleInfo  = (
                                                   (module:DEPMOD_LOGGED_IN; ready:false),
                                                   (module:DEPMOD_VCARD_CACHE; ready:false),
                                                   (module:DEPMOD_DISPLAYNAME; ready:false),
                                                   (module:DEPMOD_ROSTER; ready:false),
                                                   (module:DEPMOD_BOOKMARKS; ready:false),
                                                   (module:DEPMOD_GROUPS; ready:false),
                                                   (module:DEPMOD_UI; ready:false),
                                                   (module:DEPMOD_CAPS_CACHE; ready:false),
                                                   (module:DEPMOD_ENTITY_CACHE; ready:false)
                                                   );

type
    TSessionAuthResolver = class(TAuthDependancyResolver)
    private
        _sessionReadyTag: TXMLTag; //tag passed along with /dependancy/ready/session event
        _sessionEntityCB: integer;
    protected
        procedure DependancyCallback(event: string; tag: TXMLTag);override;
        procedure ResetState(); override;
    public
        constructor create(depmods: TDepModInfoArray);override;
    end;

{---------------------------------------}
Constructor TJabberSession.Create(ConfigFile: widestring);
var
    exe_FullPath: string;
    exe_FullPath_len: cardinal;
begin
    //
    inherited Create();

    MainSession := Self; //hack that insures opjects being create here can access
                         //the main session global variable. 
    _register := false;
    _id := 1;
    _cb_id := 1;
    _profile := nil;

    // Create the event dispatcher mechanism
    _dispatcher := TSignalDispatcher.Create;

    // Core packet signals
    _filterSignal := TPacketSignal.Create('/filter', '/pre');
    _preSignal := TPacketSignal.Create('/pre', '/packet');
    _packetSignal := TPacketSignal.Create('/packet', '/post');
    _postSignal := TPacketSignal.Create('/post', '/unhandled');
    _unhandledSignal := TBasicSignal.Create('/unhandled');
    _dispatcher.AddSignal(_filterSignal);
    _dispatcher.AddSignal(_preSignal);
    _dispatcher.AddSignal(_packetSignal);
    _dispatcher.AddSignal(_postSignal);
    _dispatcher.AddSignal(_unhandledSignal);

    // other signals
    _sessionSignal := TBasicSignal.Create('/session');
    _itemSignal := TItemSignal.Create('/roster');
    _presSignal := TPresenceSignal.Create('/presence');
    _dataSignal := TStringSignal.Create('/data');
    _winSignal := TPacketSignal.Create('/windows');
    _chatSignal := TChatSignal.Create('/chat');
    _dispatcher.AddSignal(_sessionSignal);
    _dispatcher.AddSignal(_itemSignal);
    _dispatcher.AddSignal(_presSignal);
    _dispatcher.AddSignal(_dataSignal);
    _dispatcher.AddSignal(_winSignal);
    _dispatcher.AddSignal(_chatSignal);
    //dependancy signal 
    _dispatcher.AddSignal(TBasicSignal.Create('/dependancy'));
    
{** JJF msgqueue refactor
    _pauseQueue := TQueue.Create();
**}

    //create a handler that will callback when a set of dependancies has been resolved
    //in this case all known dependancies
    _depHandler := TSessionAuthResolver.create(ALL_DEPENDANT_MODULES);
    TSessionAuthResolver(_depHandler).OnAllResolved := OnAllDependanciesResolved;
    
    _avails := TWidestringlist.Create();
    _features := nil;
    _xmpp := false;
    _ssl_on := false;
    _compression_on := false;
    _tls_cb := -1;
    _compression_cb := -1;
    _compression_err_cb := -1;

    // Create all the things which might register w/ the session
    jCapsCache.SetSession(Self);

    //display name cache
    DisplayName.getDisplayNameCache().setSession(Self);

    // Create the Presence Proxy Database (PPDB)
    ppdb := TJabberPPDB.Create;
    ppdb.SetSession(Self);

    // Create chat controllers
    ChatList := TJabberChatList.Create();
    ChatList.SetSession(Self);

    OnSessionStartProfile(Self);
    OnSessionStartRoomProperties(Self);
    // Create the preferences controller
    Prefs := TPrefController.Create(ConfigFile);
    Prefs.LoadProfiles;
    Prefs.SetSession(Self);
    SetLength(exe_FullPath, MAX_PATH+1);
    exe_FullPath_len := GetModuleFileName(0, PChar(exe_FullPath), MAX_PATH);
    exe_FullPath := LeftStr(exe_FullPath, exe_FullPath_len);
    Prefs.setString('exe_FullPath', exe_FullPath);
    exe_FullPath := Windows.GetCommandLine();
    Prefs.setString('exe_CommandLine', exe_FullPath);

    if (Prefs.getBool('always_lang')) then
        _lang := Prefs.getString('locale')
    else
        _lang := '';
    if (Prefs.getBool('branding_priority_notifications') = false) then
      Prefs.setBool('show_priority', false);

    // Create the Presence_XML list for stashing stuff in every pres packet
    Presence_XML := TWideStringlist.Create();

    _extensions := TWideStringList.Create();

    ItemController := TExodusItemController.create(Self);
    roster := TContactController.create(Self);
    rooms := TRoomController.create(Self);
    RosterRefreshTimer := TTimer.Create(nil);
    RosterRefreshTimer.Enabled := false;
    RosterRefreshTimer.Interval := 250;
    RosterRefreshTimer.OnTimer := OnRosterRefreshTimer;
end;

{---------------------------------------}
Destructor TJabberSession.Destroy;
begin
    // Clean up everything
    ClearStringListObjects(ppdb);
    ppdb.Clear();
    Prefs.Free();
    ppdb.Free();
    //itemController.Free();
    roster.Free();
    rooms.Free();
    _depHandler.free();
    //bookmarks.Free();
    ChatList.Free();
    ClearStringListObjects(_extensions);
    _extensions.Free();

    _avails.Free();

    if (_stream <> nil) then
        FreeAndNil(_stream);
    FreeAndNil(Presence_XML);

    OnSessionEndProfile();
    OnSessionEndRoomProperties();


    // Free the dispatcher... this should free the signals
    _dispatcher.Free;
    _dispatcher := nil; //keeps bad refs from calling back during their destruction
    RosterRefreshTimer.Free();
    inherited Destroy;
end;

{---------------------------------------}
procedure TJabberSession.SetUsername(username: WideString);
begin
    _profile.Username := username;
end;

{---------------------------------------}
function TJabberSession.GetUsername(): WideString;
begin
    if (_sjid <> nil) then
        result := _sjid.user
    else if (_profile <> nil) then
        result := _profile.Username
    else
        result := '';
end;

{---------------------------------------}
function TJabberSession.GetFullJid(): WideString;
begin
    if (_sjid <> nil) then
        result := _sjid.full
    else if (_profile <> nil) then
        result := _profile.Username + '@' + _profile.Server + '/' +
            _profile.Resource
    else
        result := '';
end;

{---------------------------------------}
function TJabberSession.GetBareJid(): Widestring;
begin
    if (_sjid <> nil) then
        Result := _sjid.jid
    else if (_profile <> nil) then
        Result := _profile.username + '@' + _profile.server
    else
        Result := '';
end;

{---------------------------------------}
procedure TJabberSession.SetPassword(password: WideString);
begin
    _profile.Password := Trim(password);
end;

{---------------------------------------}
function TJabberSession.GetPassword(): WideString;
begin
    if (_profile = nil) then
        result := ''
    else
        result := _profile.Password;
end;

{---------------------------------------}
procedure TJabberSession.SetServer(server: WideString);
begin
    _profile.Server := server;
end;

{---------------------------------------}
function TJabberSession.GetServer(): WideString;
begin
    if (_sjid <> nil) then
        result := _sjid.domain
    else if (_cur_server <> '') then
        result := _cur_server
    else if (_profile <> nil) then
        result := _profile.Server
    else
        result := '';
end;

{---------------------------------------}
procedure TJabberSession.SetResource(resource: WideString);
begin
    _profile.Resource := resource;
end;

{---------------------------------------}
function TJabberSession.GetResource(): WideString;
begin
    if (_sjid <> nil) then
        result := _sjid.resource
    else if (_profile <> nil) then
        result := _profile.Resource
    else
        result := '';
end;

{---------------------------------------}
function TJabberSession.GetSessionJid(): TJabberID;
begin
    if (_sjid <> nil) then
        Result := _sjid
    else
        Result := _profile.GetJabberID();
end;
{---------------------------------------}
procedure TJabberSession.SetSessionJid(jid: TJabberID);
begin
    if (_sjid <> nil) then
        _sjid.Free();
    _sjid := jid;
end;

{---------------------------------------}
procedure TJabberSession.SetPort(port: integer);
begin
    _profile.Port := port;
end;

{---------------------------------------}
function TJabberSession.GetPort(): integer;
begin
    if (_profile = nil) then
        result := 0
    else
        result := _profile.Port;
end;

{---------------------------------------}
procedure TJabberSession.CreateAccount;
begin
    _register := true;
    if (not _auth_agent.StartRegistration()) then begin
        // this auth mechanism doesn't support registration
        _register := false;
        Self.FireEvent('/session/gui/reg-not-supported', nil);
    end;
end;

{---------------------------------------}
procedure TJabberSession.Connect;
begin
    DoConnect();
end;

{---------------------------------------}
procedure TJabberSession.DoConnect;
begin
    assert(_stream = nil);
    _sent_stream := false;
    if (_profile = nil) then
        raise Exception.Create('Invalid profile')
    else if (_stream <> nil) then
        raise Exception.Create('Session is already connected');

    checkAuthAgent(); //see if we have an auth agent already, or create one from profile info
            
    case _profile.ConnectionType of
    conn_normal:
        _stream := TXMLSocketStream.Create('stream:stream');
    conn_http:
        _stream := TXMLHttpStream.Create('stream:stream');
    else
        // don't I18N
        raise Exception.Create('Invalid connection type');
    end;
    //fire a stream ready event, so anything that wants to add listeners can
    _dispatcher.DispatchSignal('/session/stream/ready', nil);

    // Register our session to get XML Tags
    _stream.RegisterStreamCallback(Self.StreamCallback);
    _stream.OnData := DataEvent;
    _stream.Connect(_profile);

    _ssl_on := (_profile.ssl = ssl_port);
end;

{---------------------------------------}
procedure TJabberSession.Disconnect;
begin
    // Save the server side prefs and kill our connection.
    if (_stream = nil) then exit;

    if (Self.Stream.Active) then begin
        if (_authd) then begin
            Prefs.SaveServerPrefs();
            _dispatcher.DispatchSignal('/session/disconnecting', nil);
            _stream.Send('<presence type="unavailable"/>');
        end;

        // disconnect the stream
        _stream.Disconnect;
    end
    else
        Self.handleDisconnect();

    _authd := false;
    _register := false;
end;

{---------------------------------------}
procedure TJabberSession.SendTag(tag: TXMLTag);
    procedure _RemoveTrackingTag();
    var
        track: TXMLTag;
    begin
        if (tag.Name <> 'message') then exit;

        track := tag.QueryXPTag(XP_MSG_TRACK);
        if (track = nil) then exit;
        
        tag.RemoveTag(track);
    end;
begin
    // Send this tag out to the socket
    if (_stream <> nil) then begin
        _RemoveTrackingTag();
        if (_lang <> '') then
            tag.setAttribute('xml:lang', _lang);

        _stream.SendTag(tag);
    end
    else begin
        tag.Free;
    end;
end;

{---------------------------------------}
procedure TJabberSession.DataEvent(send: boolean; data: Widestring);
begin
    if (send) then
        // we are sending data
        _dataSignal.Invoke('/data/send', nil, data)
    else begin
        // getting data from the socket
        if (Pos('<stream:error>', data) > 0) then
            _dispatcher.DispatchSignal('/session/error/stream', nil);
        _dataSignal.Invoke('/data/recv', nil, data);
    end;
end;

{---------------------------------------}
procedure TJabberSession.handleDisconnect();
begin
    if ((not _authd) and (_register)) then
        _auth_agent.CancelRegistration();
    if ((not _authd) and (_auth_agent <> nil)) then
        _auth_agent.CancelAuthentication();

    // Do this before we invalidate our state
    _dispatcher.DispatchSignal('/session/disconnected', nil);

    // Clear the roster, ppdb and fire the callbacks
    _first_pres := false;
    _authd := false;
    _cur_server := '';
    _ssl_on := false;
    _compression_on := false;

{** JJF msgqueue refactor
    if (_paused) then
        Self.Play();
**}
    FreeAndNil(_features);
    FreeAndNil(_sjid);

    ppdb.Clear;
    ItemController.ClearItems;
    //roster.Clear;
    ppdb.Clear;

    FreeAndNil(_stream);

    // clear the entity cache
    jEntityCache.Clear();
    jCapsCache.Clear();
end;

{---------------------------------------}
procedure TJabberSession.StreamCallback(msg: string; tag: TXMLTag);
var
    biq: TJabberIQ;
    methods: TXMLTagList;
    i: integer;
begin
    // Something is happening... our stream says so.
    if ((msg = 'connected') and (_sent_stream = false)) then begin
        // we are connected... send auth stuff.
        _stream.SendStreamHeader(Server, Prefs.getString('locale'));
        _sent_stream := true;
    end

    else if msg = 'ssl-error' then
        // Throw a dialog box up..
        _dispatcher.DispatchSignal('/session/error/ssl', tag)

    else if msg = 'disconnected' then
        // We're not connected anymore
        Self.Disconnect()

    else if msg = 'commtimeout' then
        // Communications timed out (woops).
        _dispatcher.DispatchSignal('/session/commtimeout', nil)

    else if msg = 'commerror' then
        // Some kind of socket error
        _dispatcher.DispatchSignal('/session/commerror', nil)

    else if msg = 'xml' then begin
        // We got a stanza. Whoop.
        // Let's always fire debug events

        if (tag.Name = 'stream:stream') then begin
            // we got connected
            _stream_id := tag.getAttribute('id');
            _xmpp := (tag.GetAttribute('version') = '1.0');

            // Stash away our current server.
            _cur_server := tag.getAttribute('from');
            _dispatcher.DispatchSignal('/session/connected', nil);

            if (_no_auth) then
                // do nothing
            else if (((_register) or (_profile.NewAccount)) and (_xmpp = false)) then begin
                _xmpp := false;
                CreateAccount()
            end
            else if (not _xmpp) then
                _auth_agent.StartAuthentication();
        end
        else if (tag.Name = 'stream:error') then begin
            // we got a stream error
            FireEvent('/session/error/stream', tag);
        end

        else if ((_xmpp) and (tag.Name = 'stream:features')) then begin
            // cache stream features..
            FreeAndNil(_features);
            _features := TXMLTag.Create(tag);

            if (_authd) and (not _no_auth) then begin
                // We are already auth'd, lets bind to our resource
                biq := TJabberIQ.Create(Self, generateID(), BindCallback, AUTH_TIMEOUT);
                biq.Namespace := 'urn:ietf:params:xml:ns:xmpp-bind';
                biq.qTag.Name := 'bind';
                biq.qTag.AddBasicTag('resource', Self.Resource);
                biq.iqType := 'set';
                biq.Send();
            end
            else begin
                // We aren't authd yet, check for StartTLS
                if (not _ssl_on) then begin
                    if (_features.GetFirstTag('starttls') <> nil) then begin
                        if (_stream.isSSLCapable()) then begin
                            StartTLS();
                            exit;
                        end;
                    end;
                    if (_profile.ssl = ssl_only_tls) then begin
                        Self.FireEvent('/session/error/tls', nil);
                        exit;
                    end;
                end;
                
                // now see if we can do compression
                {$ifdef INDY9}
                if (not _compression_on)  then begin
                    methods := _features.QueryXPTags('/stream:features/compression[@xmlns="http://jabber.org/features/compress"]/method');
                    for i := 0 to methods.Count - 1 do begin
                        if methods.Tags[i].Data = 'zlib' then begin
                            StartCompression('zlib');
                            FreeAndNil(methods);
                            exit;
                        end
                    end;
                    // doesn't support zlib
                    Self.FireEvent('/session/error/compression', nil);
                    FreeAndNil(methods);
                end;
                {$endif}

                // Otherwise, either try to register, or auth
                if (_no_auth) then
                    // do nothing
                else if ((_register) or (_profile.NewAccount)) then begin

                    if (_features.QueryXPTag('/stream:features/register[@xmlns="http://jabber.org/features/iq-register"]') = nil) then begin
                        // this server doesn't support inband reg.
                        FireEvent('/session/gui/no-inband-reg', nil);
                        exit;
                    end;

                    CreateAccount();
                end
                else if (not _no_auth) then
                    _auth_agent.StartAuthentication();
            end;
        end

        else begin
            _dispatcher.DispatchSignal('/filter', tag);
        end;
    end;

end;

{---------------------------------------}
procedure TJabberSession.BindCallback(event: string; tag: TXMLTag);
var
    iq: TJabberIQ;
    j: WideString;
begin
    // Callback for our xmpp-bind request
    if ((event <> 'xml') or (tag.getAttribute('type') <> 'result')) then begin
        _dispatcher.DispatchSignal('/session/error/auth', tag);
        exit;
    end
    else begin
        j := tag.QueryXPData('/iq/bind[@xmlns="urn:ietf:params:xml:ns:xmpp-bind"]/jid');
        if (j <> '') then begin
            SetSessionJID(TJabberID.Create(j));
        end;

        iq := TJabberIQ.Create(Self, generateID(), SessionCallback, AUTH_TIMEOUT);
        iq.Namespace := 'urn:ietf:params:xml:ns:xmpp-session';
        iq.qTag.Name := 'session';
        iq.iqType := 'set';
        iq.Send();
    end;
end;

{---------------------------------------}
procedure TJabberSession.SessionCallback(event: string; tag: TXMLTag);
begin
    Prefs.setString('temp-pw', ''); //clear temp password
    // callback for our xmpp-session-start
    if ((event <> 'xml') or (tag.getAttribute('type') <> 'result')) then begin
        _dispatcher.DispatchSignal('/session/error/auth', tag);
        exit;
    end
    else _dispatcher.DispatchSignal(DEPMOD_LOGGED_IN_EVENT, tag);
end;

{---------------------------------------}
{
    Just about everything that initializes at auth catches this event. Many
    listeners have dependacies on entity cache, roster, bookmarks and private
    storeage fetch. To address these dependancies new "ready" events will
    be fired instead of authenticated. Once rosrter, enitify cahche etc. have
    signaled ready,  /session/authneticated will be fired. This logic is
    controlled in jabber1.pas
}
procedure TJabberSession.StartSession(tag: TXMLTag);
begin
    // We have an active session
    _first_pres := true;
     Prefs.FetchServerPrefs(); //server prefs will just fire a /session/prefs on success
    _authd := true;
    _dispatcher.DispatchSignal('/session/authenticated', tag);
end;

{---------------------------------------}
{** JJF msgqueue refactor

procedure TJabberSession.Pause();
begin
    // pause the session
    _paused := true;
end;
**}
{---------------------------------------}
{** JJF msgqueue refactor
procedure TJabberSession.Play();
var
    q: TQueuedEvent;
    sig: TSignalEvent;
begin
    // playback the stuff in the queue
    _resuming := true;
    _paused := false;

    // WOAH! Make sure things are played back or cleared when we get disconnected.
    while (_pauseQueue.Count > 0) do begin
        q := TQueuedEvent(_pauseQueue.pop);
        sig := TSignalEvent(q.callback);
        sig(q.event, q.tag);
        q.Free;
    end;
    _resuming := false;
end;
**}
{---------------------------------------}
{** JJF msgqueue refactor

procedure TJabberSession.QueueEvent(event: string; tag: TXMLTag; Callback: TPacketEvent);
var
    q: TQueuedEvent;
begin
    // Queue an event to a specific Callback
    q := TQueuedEvent.Create();
    q.callback := TMethod(Callback);
    q.event := event;

    // make sure we make a dup of tag since it's going to go away after
    // it makes the rounds thru the dispatcher.
    q.tag := TXMLTag.Create(tag);
    _pauseQueue.Push(q);
end;
**}
{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TPacketEvent; xplite: Widestring; pausable: boolean = false): integer;
var
    p, i: integer;
    l: TSignalListener;
    pk: TPacketListener;
    sig: TBasicSignal;
    tok1: Widestring;
begin
    // add this callback to the packet signal
    Result := -1;
    p := Pos('/', Copy(xplite, 2, length(xplite) - 1));
    if p > 0 then
        tok1 := Copy(xplite, 1, p)
    else
        tok1 := xplite;

    // Find the correct signal to register with
    i := _dispatcher.IndexOf(tok1);
    if (tok1 = '/filter') then begin
        pk := _filterSignal.addListener(xplite, callback);
        result := pk.cb_id;
    end
    else if (tok1 = '/pre') then begin
        pk := _preSignal.addListener(xplite, callback);
        result := pk.cb_id;
    end
    else if tok1 = '/packet' then begin
        pk := _packetSignal.addListener(xplite, callback);
        result := pk.cb_id;
    end
    else if (tok1 = '/post') then begin
        pk := _postSignal.addListener(xplite, callback);
        result := pk.cb_id;
    end
    else if i >= 0 then begin
        sig := TBasicSignal(_dispatcher.Objects[i]);
        l := sig.addListener(xplite, callback);
        result := l.cb_id;
    end;
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TItemEvent; event: Widestring): integer;
var
    l: TItemListener;
begin
    // add a callback to the item signal
    l := _itemSignal.addListener(event, callback);
    Result := l.cb_id;
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TPresenceEvent): integer;
var
    l: TPresenceListener;
begin
    // add a callback to the presence signal
    l := _presSignal.addListener(callback);
    Result := l.cb_id;
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TDataStringEvent): integer;
var
    sl: TStringListener;
begin
    // add a callback to the data signal
    sl := _dataSignal.addListener(callback);
    Result := sl.cb_id;
end;

{---------------------------------------}
function TJabberSession.RegisterCallback(callback: TChatEvent): integer;
var
    sl: TChatListener;
begin
    // add a callback to the data signal
    sl := _chatSignal.addListener(callback);
    Result := sl.cb_id;
end;

{---------------------------------------}
procedure TJabberSession.FireEvent(event: string; tag: TXMLTag);
begin
    // dispatch some basic signal
    _dispatcher.DispatchSignal(event, tag);
end;

{---------------------------------------}
procedure TJabberSession.FireEvent(event: string; tag: TXMLTag; const p: TJabberPres);
begin
    // dispatch a presence signal directly
    _presSignal.Invoke(event, tag, p);
end;

{---------------------------------------}
//procedure TJabberSession.FireEvent(event: string; tag: TXMLTag; const ritem: IExodusItem);
procedure TJabberSession.FireEvent(event: string; const item: IExodusItem);
begin
    // dispatch a roster event directly
    _itemSignal.Invoke(event, item);
end;

{---------------------------------------}
procedure TJabberSession.FireEvent(event: string; tag: TXMLTag; const data: WideString);
begin
    // dispatch a data event directly
    _dataSignal.Invoke(event, tag, data);
end;

{---------------------------------------}
procedure TJabberSession.FireEvent(event: string; tag: TXMLTag; const controller: TChatController);
begin
    // dispatch a data event directly
    _chatSignal.Invoke(event, tag, controller);
end;

{---------------------------------------}
procedure TJabberSession.UnRegisterCallback(index: integer);
begin
    // Unregister a callback
    if (index >= 0) and (_dispatcher <> nil) then
        _dispatcher.DeleteListener(index);
end;

{---------------------------------------}
function TJabberSession.generateID: WideString;
begin
    Result := 'jcl_' + IntToStr(_id);
    _id := _id + 1;
end;

{---------------------------------------}
procedure TJabberSession.ActivateProfile(i: integer);
begin
    Assert((i >= 0) and (i < Prefs.Profiles.Count));

    // make this profile the active one..
    _profile := TJabberProfile(Prefs.Profiles.Objects[i]);
    _priority := _profile.Priority;
end;

{---------------------------------------}
procedure TJabberSession.ActivateDefaultProfile();
var
 prof_index: Integer;
begin
//    _profile := DefaultProfile
   prof_index := Prefs.getInt('profile_active');
   if ((prof_index < 0) or (prof_index >= Prefs.Profiles.Count)) then
        prof_index := 0;
   _profile := TJabberProfile(Prefs.Profiles.Objects[prof_index]);
end;

{---------------------------------------}
procedure TJabberSession.setPresence(show, status: WideString; priority: integer);
var
    p: TJabberPres;
    i: integer;
    x: TXMLTag;
begin
    _show := show;
    _status := status;
    _priority := priority;

    if (Self.Active) then begin
        p := TCapPresence.Create();
        p.Show := show;
        p.Status := status;
        if (priority = -1) then priority := 0;
        p.Priority := priority;

        if (Self.Profile.AvatarHash <> '') then begin
            x := p.AddTag('x');
            x.setAttribute('xmlns', 'vcard-temp:x:update');
            x.AddBasicTag('photo', Self.Profile.AvatarHash);
        end;


        // allow plugins to add stuff, by trapping this event
        MainSession.FireEvent('/session/before_presence', p);
        //do stuff by adding to Presence_XML
        for i := 0 to Presence_XML.Count - 1 do
            p.addInsertedXML(Presence_XML[i]);

        // for invisible, only send to those people we've
        // directed presence to.
        if ((self.Invisible) and (Self.Active) and (not _first_pres)) then begin
            manualBlastPresence(p);
        end
        else begin
            if (_invisible) then
                p.setAttribute('type', 'invisible');
            SendTag(p);
            if (_first_pres) then _first_pres := false;
        end;

        // if we are going away or xa, save the prefs
        if ((show = 'away') or (show = 'xa')) then
            Prefs.SaveServerPrefs();

        MainSession.FireEvent('/session/presence', nil);
{** JJF msgqueue refactor
        if (_paused) then begin
            // If the session is paused, and we're changing back
            // to available, or chat, then make sure we play the session
            if ((_show <> 'away') and (_show <> 'xa') and (_show <> 'dnd')) then
                Self.Play();
        end;
**}        
    end;
end;
{---------------------------------------}
procedure TJabberSession.manualBlastPresence(p: TXMLTag);
var
    i: integer;
    xml: Widestring;
begin
    for i := 0 to _avails.Count - 1 do begin
        p.setAttribute('to', _avails[i]);
        xml := p.xml();
        _stream.Send(xml);
    end;
    p.Free();
end;

{---------------------------------------}
procedure TJabberSession.addAvailJid(jid: Widestring);
begin
    if (_avails.IndexOf(jid) < 0) then
        _avails.Add(jid);
end;

{---------------------------------------}
procedure TJabberSession.removeAvailJid(jid: Widestring);
var
    idx: integer;
begin
    idx := _avails.IndexOf(jid);
    if (idx >= 0) then
        _avails.Delete(idx);
end;

{---------------------------------------}
function TJabberSession.IsBlocked(jid : WideString): boolean;
var
    tmp_jid:  TJabberID;
begin
    tmp_jid := TJabberID.Create(jid);
    result := IsBlocked(tmp_jid);
    tmp_jid.Free();
end;

{---------------------------------------}
function TJabberSession.IsBlocked(jid : TJabberID): boolean;
var
    r1: IExodusItem;
    blockers: TWideStringList;
begin
    blockers := TWideStringList.Create();
    Prefs.fillStringlist('blockers', blockers);
    if (blockers.IndexOf(jid.jid) < 0) then
        result := false
    else
        result := true;
    blockers.Free();

    if ((not result) and (Prefs.getBool('block_nonroster'))) then begin
        // block this jid if they are not in my roster
         r1 := ItemController.getItem(jid.jid);
         if (r1 = nil) then
             result := true;
    end;
end;

{---------------------------------------}
procedure TJabberSession.UnBlock(jid : TJabberID);
var
    i,j: integer;
    blockers: TWideStringList;
    block : TXMLTag;
    c: TChatController;
begin
    blockers := TWideStringList.Create();
    Prefs.fillStringlist('blockers', blockers);
    i := blockers.IndexOf(jid.jid);
    if (i >= 0) then begin
        blockers.Delete(i);
        Prefs.setStringlist('blockers', blockers);
    end;
    blockers.Free();
    block := TXMLTag.Create('unblock');
    block.setAttribute('jid', jid.jid);
    MainSession.FireEvent('/session/unblock', block);
    //Disable all open chat windows
    with MainSession.ChatList do begin
       for j := Count - 1 downto 0 do begin
           c := TChatController(Objects[j]);
           if (c <> nil) then
             if (c.BareJID = jid.jid) then
                c.SetJid(c.BareJID);
       end;
    end;
    block.Free();
end;

{---------------------------------------}
procedure TJabberSession.RefreshBlockers();
var
    j: Integer;
    c: TChatController;
    block: TXMLTag;
begin
    block := TXMLTag.Create('block');
    //Iterate through all controllers
    with MainSession.ChatList do begin
       for j := Count - 1 downto 0 do begin
           c := TChatController(Objects[j]);
           block.setAttribute('jid', c.BareJID);
           if (c <> nil) then begin
             if (IsBlocked(c.BareJID)) then begin
                //If blocked, chat window will be closed and will
                //disable controller for this jid
                MainSession.FireEvent('/session/block', block);
             end
             else begin
                //Enable controller just in case window is not open
                c.SetJid(c.BareJID);
                //MainSession.FireEvent('/session/unblock', block);
             end;
           end;
       end;
    end;
    block.Free();
end;


procedure TJabberSession.Block(jid : TJabberID);
var
    blockers: TWideStringList;
    block: TXMLTag;
begin
    blockers := TWideStringList.Create();
    Prefs.fillStringlist('blockers', blockers);
    if (blockers.IndexOf(jid.jid) < 0) then begin
        blockers.Add(jid.jid);
        Prefs.setStringlist('blockers', blockers);
    end;
    blockers.Free();
    block := TXMLTag.Create('block');
    block.setAttribute('jid', jid.jid);
    MainSession.FireEvent('/session/block', block);
    block.Free();
end;

{---------------------------------------}
function TJabberSession.GetActive(): boolean;
begin
    Result := (_stream <> nil);
end;

{---------------------------------------}
procedure TJabberSession.setAuthAgent(new_auth: TJabberAuth);
begin
    if (assigned(_auth_agent)) then
        FreeAndNil(_auth_agent);
    _auth_agent := new_auth;
end;

{*
    Create an auth agaent from current profile information UNLESS
    already assigned. nop if already assigned.
*}
procedure TJabberSession.checkAuthAgent();
var
    auth: TJabberAuth;
begin
    assert(_profile <> nil); //should not try to set authagent until profile is set
    assert(_stream = nil); //should not try to change authagent once connected
    //if the current auth agent has a plugin associated, use it regardless of
    //what the profile specifies...
    
    if (_auth_agent = nil) or (not _auth_agent.InheritsFrom(TExPluginAuth)) then begin
        // Create the AuthAgent
        if (profile.SSL_Cert <> '')  then
            auth := CreateJabberAuth('EXTERNAL', Self)
        else if (_profile.KerbAuth) then
            auth := CreateJabberAuth('GSSAPI', Self)
        else
            auth := CreateJabberAuth('XMPP', Self);

        if (auth = nil) then
            raise Exception.Create('No appropriate Auth Agent found.');

        // set this auth agent as our current one
        setAuthAgent(auth);
    end;
end;

{---------------------------------------}
function TJabberSession.getAuthAgent: TJabberAuth;
begin
    Result := _auth_agent;
end;

{---------------------------------------}
procedure TJabberSession.setAuthdJID(user, host, res: Widestring);
begin
    _profile.Username := user;
    _profile.Server := host;
    _profile.Resource := res;
end;

{---------------------------------------}
procedure TJabberSession.setAuthenticated(ok: boolean; tag: TXMLTag; reset_stream: boolean);
var
    jid: TJabberID;
begin
    // our auth-agent is all set\
    //remove temp password from prefs
    _authd := ok;
    Prefs.setString('temp-pw', '');
    if (ok) then begin
        jid := TJabberID.Create(
                _profile.Username,
                _profile.Server,
                _profile.Resource);
        SetSessionJid(jid);
        _profile.NewAccount := false;
        _register := false;

        if (reset_stream) then
            ResetStream()
        else
            //fire session/ready/session, see TDepMod
            _dispatcher.DispatchSignal(DEPMOD_LOGGED_IN_EVENT, tag);
    end
    else begin
        _dispatcher.DispatchSignal('/session/error/auth', tag);
    end;
end;

{---------------------------------------}
procedure TJabberSession.ResetStream();
begin
    // send a new stream:stream...
    _stream.ResetParser();
    _stream.SendStreamHeader(Server, Prefs.getString('locale'));
end;

{---------------------------------------}
procedure TJabberSession.StartTLS();
var
    s: TXMLTag;
begin
    _tls_cb := Self.RegisterCallback(TLSCallback,
        '/packet/proceed[@xmlns="urn:ietf:params:xml:ns:xmpp-tls"]');

    s := TXMLTag.Create('starttls');
    s.setAttribute('xmlns', 'urn:ietf:params:xml:ns:xmpp-tls');
    Self.SendTag(s);
end;


{---------------------------------------}
procedure TJabberSession.TLSCallback(event: string; tag: TXMLTag);
begin
    Self.UnRegisterCallback(_tls_cb);
    _tls_cb := -1;

    if (event <> 'xml') then begin
        Self.FireEvent('/session/error/tls', nil);
        exit;
    end;

    try
        _stream.EnableSSL();
        ResetStream();
        _ssl_on := true;
    except
        Self.FireEvent('/session/error/tls', nil);
        _ssl_on := false;
    end;

end;

{---------------------------------------}
procedure TJabberSession.StartCompression(method: WideString);
var
    s: TXMLTag;
begin
    _compression_cb := Self.RegisterCallback(CompressionCallback,
        '/packet/compressed[@xmlns="http://jabber.org/protocol/compress"]');
    _compression_err_cb := Self.RegisterCallback(CompressionErrorCallback,
        '/packet/failure[@xmlns="http://jabber.org/protocol/compress"]');
    s := TXMLTag.Create('compress');
    s.setAttribute('xmlns', 'http://jabber.org/protocol/compress');
    s.AddBasicTag('method', method);
    Self.SendTag(s);
end;

{---------------------------------------}
procedure TJabberSession.CompressionCallback(event: string; tag: TXMLTag);
begin
    Self.UnRegisterCallback(_compression_cb);
    _compression_cb := -1;

    if (event <> 'xml') then begin
        Self.FireEvent('/session/error/compression', nil);
        exit;
    end;

    try
        _stream.EnableCompression();
        ResetStream();
        _compression_on := true;
    except
        Self.FireEvent('/session/error/compression', nil);
        _ssl_on := false;
    end;

end;

{---------------------------------------}
procedure TJabberSession.CompressionErrorCallback(event: string; tag: TXMLTag);
begin
    Self.UnRegisterCallback(_compression_err_cb);
    _compression_err_cb := -1;

    Self.FireEvent('/session/error/compression', tag);
end;

function TJabberSession.getDisplayUsername(): widestring;
begin
    Result := DisplayName.getDisplayNameCache().getDisplayName(Profile.getJabberID);
end;

procedure TJabberSession.OnAllDependanciesResolved(SessionTag : TXMLTag);
begin
    StartSession(SessionTag);
end;

{---------------------------------------}
procedure TJabberSession.OnRosterRefreshTimer(Sender: TObject);
var
    Item: IExodusItem;
begin
    RosterRefreshTimer.Enabled := false;
    FireEvent('/data/item/group/restore', nil, '');
    FireEvent('/item/end', Item);
    OutputDebugMsg('OnPresenceTimer fired');
end;
{*******************************************************************************
**************************** TSessionListener **********************************
*******************************************************************************}
procedure TSessionListener.FireAuthenticated();
begin
    if (Assigned(_OnAuthEvent)) then
        _OnAuthEvent();
end;

procedure TSessionListener.FireDisconnected();
begin
    if (Assigned(_OnDisconnectEvent)) then
        _OnDisconnectEvent((_ReceivedError <> ''), _ReceivedError);
end;

procedure TSessionListener.SessionListenerCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/authenticated') then
    begin
        _Authenticated := true;
        _ReceivedError := '';
        FireAuthenticated();
    end
    else if ((event = '/session/disconnected') and _Authenticated) then
    begin
        FireDisconnected();
        _Authenticated := false;
    end
    else if (event = '/session/commerror') then
    begin
        _ReceivedError := 'Comm Error';
    end
end;

Constructor TSessionListener.Create(OnAuthenticated: TAuthenticatedEvent; OnDisconnect: TDisconnectEvent; JabberSession: TJabberSession = nil);
begin
    _Authenticated := false;
    _ReceivedError := '';
    _SessionCB := -1;
    _OnAuthEvent := OnAuthenticated;
    _OnDisconnectEvent := OnDisconnect;
    _Session := JabberSession;
    if (_Session = nil) then
        _Session := MainSession;

    _SessionCB := _Session.RegisterCallback(SessionListenerCallback, '/session');
    _Authenticated := _Session.Authenticated;
end;

Destructor TSessionListener.Destroy();
begin
    if (_SessionCB <> -1) then        begin
        _Session.UnRegisterCallback(_SessionCB);
        _SessionCB := -1;
    end;
    _session := nil;
end;

{------------------------ TDependancyHandler ------------------------------}
function ArrayToTArray(ina: array of TModuleInfo): TDepModInfoArray;
var
    i: integer;
begin
    SetLength(Result, Length(ina));
    for i := 0 to Length(ina) - 1 do
        Result[i] := ina[i];
end;

function TAuthDependancyResolver.indexOfModule(module: widestring): integer;
begin
    for Result := 0 to Length(_dependancies) - 1 do
        if (_dependancies[Result].module = module) then exit;
    Result := -1;
end;

function TAuthDependancyResolver.AllReady(): boolean;
var
    i: integer;
begin
    Result := false;
    for i := 0 to Length(_dependancies) - 1 do
        if (not _dependancies[i].ready) then exit;

    Result := true;
end;

procedure TAuthDependancyResolver.DependancyCallback(event: string; tag: TXMLTag);

var
    idx: integer;
    depmod: string;
begin
    if (StartsText(DEPMOD_READY_EVENT, event)) then
    begin
        depmod := RightStr(event, Length(event) - Length(DEPMOD_READY_EVENT));
        idx := indexOfModule(depmod);
        if (idx <> -1) and (not _dependancies[idx].ready) then
        begin
            _dependancies[idx].ready := true;
            fireOnResolved(depmod, Tag);

            if (AllReady()) then
                FireOnAllResolved();
        end;
    end
    else if (event = '/session/disconnected') then
        ResetState();
end;

procedure TAuthDependancyResolver.ResetState();
var
    i: integer;
begin
    for i := 0 to Length(_dependancies) - 1 do
        _dependancies[i].ready := false;
    _firedAllResolved := false;
end;

procedure TAuthDependancyResolver.FireOnAllResolved(tag: TXMLTag);
begin
    if ((not _firedAllResolved) and Assigned(_OnAllResolved)) then
        _OnAllResolved(tag);
    _firedAllResolved := true; //assign even if _OnAllResolved is not 
end;

procedure TAuthDependancyResolver.FireOnResolved(module: widestring; tag: TXMLTag);
begin
    if (Assigned(_onResolved)) then
        _OnResolved(module, tag);
end;

constructor TAuthDependancyResolver.create();
begin
    Assert(MainSession <> nil); //created before Mainsession assigned perhaps?
    _dependancyCB := MainSession.RegisterCallback(DependancyCallback, DEPMOD_READY_EVENT);
    _sessionDisconnectCB := MainSession.RegisterCallback(DependancyCallback, '/session/disconnected');
    _firedAllResolved := false;
end;

constructor TAuthDependancyResolver.create(depmods: Array of TModuleInfo);
begin
    Create(ArrayToTArray(depmods));
end;

constructor TAuthDependancyResolver.create(depmods: TDepModInfoArray);
var
    i: integer;
begin
    create();
    
    SetLength(_dependancies, Length(depmods));
    for i := 0 to Length(depmods) - 1 do
        _dependancies[i] := depmods[i];
end;

destructor TAuthDependancyResolver.Destroy();
begin
    if (MainSession <> nil) then
    begin
        MainSession.UnRegisterCallback(_dependancyCB);
        MainSession.UnRegisterCallback(_sessionDisconnectCB);
    end;
    inherited;
end;

class procedure TAuthDependancyResolver.SignalReady(Module: widestring; tag: TXMLTag);
begin
    Assert(MainSession <> nil);
    MainSession.FireEvent(DEPMOD_READY_EVENT + Module, tag);
end;

constructor TSimpleAuthResolver.create(OnResolved: TAllResolvedEvent; Module: widestring);

var
    ta: TDepModInfoArray;
    tm: TModuleInfo;
begin
    SetLength(ta, 1);
    tm.module := Module;
    tm.ready := false;
    ta[0] := tm;
    inherited create(ta);
    Self.OnAllResolved := OnResolved;
end;

{---------------------- TSessionDependancyHandler -----------------------------}
constructor TSessionAuthResolver.create(depmods: TDepModInfoArray);
begin
    inherited;
    _sessionEntityCB := -1;
    _sessionReadyTag := nil;
end;

procedure TSessionAuthResolver.DependancyCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/entity/items') and (tag.GetAttribute('from') = MainSession.Server) then
    begin
        MainSession.UnRegisterCallback(_sessionEntityCB);
        _sessionEntityCB := -1;
        TAuthDependancyResolver.SignalReady(DEPMOD_ENTITY_CACHE, nil);
    end
    else begin
        if (event = DEPMOD_LOGGED_IN_EVENT) then
        begin
            _sessionReadyTag := TXMLTag.create(Tag); //copy

            //kick off server disco walk
            _sessionEntityCB := MainSession.RegisterCallback(DependancyCallback, '/session/entity/items');
            jEntityCache.fetch(MainSession.Server, MainSession);
        end;
        inherited;
    end;
end;

procedure TSessionAuthResolver.ResetState();
begin
    if (_sessionReadyTag <> nil) then
        _sessionReadyTag.Free();
    _sessionReadyTag := nil;

    if (_sessionEntityCB <> -1) then
        MainSession.UnRegisterCallback(_sessionEntityCB);
    _sessionEntityCB := -1;
    inherited;
end;

end.




