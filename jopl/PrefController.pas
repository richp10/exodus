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
unit PrefController;


{$ifdef VER150}
    {$define INDY9}
{$endif}

interface
uses
    ExtCtrls,
    Unicode, XMLTag, XMLParser, Presence, IdHTTP, IdSocks, JabberID,

    {$ifdef Win32}
    Forms, Windows, Registry,

    {$ifdef Exodus}
    TntClasses,
    {$endif}

    {$else}
    // iniFiles,
    Math, QForms,
    {$endif}
    Classes, SysUtils, PrefFile;

const
    s10n_ask = 0; //Ask for all incoming requests
    s10n_auto_roster = 1; //Accept incoming requests from jids on roster
    s10n_auto_all = 2; //Auto accept all requests
    s10n_auto_deny_all = 3; //Auto deny all requests
    
    conn_normal = 0;
    conn_http = 1;

    http_proxy_none = 1;
    http_proxy_ie = 0;
    http_proxy_custom = 2;

    proxy_none = 0;
    proxy_socks4 = 1;
    proxy_socks4a = 2;
    proxy_socks5 = 3;
    proxy_http = 4;

    // Different consts for ssl int on profiles.
    ssl_tls = 0;
    ssl_only_tls = 1;
    ssl_port = 2;

    // bits for notify events
    notify_toast = 1;
    notify_event = 2;
    notify_flash = 4;
    notify_sound = 8;
    notify_tray  = 16;
    notify_front = 32;

    // roster visible levels
    show_offline = -1;
    show_dnd = 0; // Must be zero to match prefs option for cboVisible
    show_xa = 1;
    show_away = 2;
    show_available = 3;

    P_EXPANDED = 'expanded';
    P_SHOWONLINE = 'roster_only_online';
    P_SHOWUNSUB = 'roster_show_unsub';
    P_OFFLINEGROUP = 'roster_offline_group';
    P_TIMESTAMP = 'timestamp';
    P_AUTOUPDATE = 'auto_updates';
    P_SUB_AUTO = 's10n_auto_accept';
    P_SUB_AUTO_ADD = 's10n_auto_add';
    P_AUTO_COMPLETE_JIDS = 'brand_auto_complete_jids';

    P_FONT_NAME = 'font_name';
    P_FONT_SIZE = 'font_size';
    P_FONT_COLOR = 'font_color';
    P_FONT_BOLD = 'font_bold';
    P_FONT_ITALIC = 'font_italic';
    P_FONT_ULINE = 'font_underline';

    P_COLOR_BG     = 'color_bg';
    P_COLOR_ALT_BG = 'color_alt_bg';
    P_COLOR_ME     = 'color_me';
    P_COLOR_OTHER  = 'color_other';
    P_COLOR_TIME   = 'color_time';
    P_COLOR_ACTION = 'color_action';
    P_COLOR_SERVER = 'color_server';
    P_COLOR_PRIORITY = 'color_priority';
    P_COLOR_DATE   = 'color_date';
    P_COLOR_DATE_BG = 'color_date_bg';

    P_TAB_WIDTH    = 'event_width';
    P_ROSTER_WIDTH = 'roster_width';
    P_ROSTER_HEIGHT = 'roster_height';
    P_ACTIVITY_WINDOW_WIDTH = 'activity_window_width';
    P_ACTIVITY_WINDOW_TAB_WIDTH = 'activity_window_tab_width';
type
    TPrefMapValue = class
    private
        FValue : WideString;
    public
        Constructor Create(value : WideString);
        property Value : WideString read FValue;
    end;

    TPrefController = class;

    TJabberProfile = class
    private
        _password: Widestring;
        _jabberID: TJabberID;
        _profilePrefs: TXMLTag;

        function getPassword: Widestring;
        function getJid: Widestring;
        procedure setPassword(value: Widestring);


        function getUsername() : Widestring;
        procedure setUsername(username: Widestring);

        function getServer(): Widestring;
        procedure setServer(server: Widestring);

        function getResource(): Widestring;
        procedure setResource(res: Widestring);

    public
        Name: Widestring;
        Priority: integer;
        SavePasswd: boolean;
        ConnectionType: integer;
        temp: boolean;
        NewAccount: boolean;
        Avatar: Widestring;
        AvatarHash: Widestring;
        AvatarMime: Widestring;
        WinLogin: boolean;
        KerbAuth: boolean;
        SASLRealm: Widestring;
        x509Auth: boolean;

        // Socket connection
        Host: Widestring;
        Port: integer;

        // Places for SRV lookup results.
        ResolvedIP: Widestring;
        ResolvedPort: integer;

        // Connection info
        srv: boolean;
        ssl: integer;
        SSL_Cert: string;
        SocksType: integer;
        SocksHost: Widestring;
        SocksPort: integer;
        SocksAuth: boolean;
        SocksUsername: string;
        SocksPassword: string;

        // HTTP Connection
        URL: Widestring;
        Poll: integer;
        NumPollKeys: integer;

        constructor Create(prof_name: Widestring; prefs: TPrefController);
        destructor Destroy(); reintroduce;

        procedure Load(tag: TXMLTag);
        procedure Save(node: TXMLTag);
        function IsValid() : boolean;
        function getDisplayUsername(): Widestring;
        function getJabberID(): TJabberID;

        property password: Widestring read getPassword write setPassword;
        property Jid: Widestring read getJid;

        property Username: Widestring read getUsername write setUsername;
        property Server: Widestring read getServer write setServer;
        property Resource: Widestring read getResource write setResource;
        property ProfilePrefs: TXMLTag read _profilePrefs;

    end;

    TPrefKind = (pkClient, pkServer, pkDefault);

    TPrefController = class
    private
        _js: TObject;
        _pref_filename: Widestring;
        _pref_file: TPrefFile;
        _server_file: TPrefFile;

        _profiles: TWideStringList;
        _updating: boolean;

        procedure Save;
        procedure ServerPrefsCallback(event: String; tag: TXMLTag);

        function getDynamicDefault(pkey: Widestring): Widestring;
        function getProfilePrefsTag(profilename: Widestring): TXMLTag;
    public
        constructor Create(filename: Widestring);
        Destructor Destroy; override;

        // Bulk update
        procedure BeginUpdate();
        procedure EndUpdate();

        // getters
        procedure fillStringlist(pkey: Widestring; sl: TWideStrings; server_side: TPrefKind = pkClient); overload;
        function getString(pkey: Widestring; server_side: TPrefKind = pkClient): Widestring;
        function getInt(pkey: Widestring; server_side: TPrefKind = pkClient): integer;
        function getBool(pkey: Widestring; server_side: TPrefKind = pkClient): boolean;
        function getDateTime(pkey: Widestring; server_side: TPrefKind = pkClient): TDateTime;
        function getSetDateTime(pkey: Widestring; server_side: TPrefKind = pkClient): TDateTime;
        function getControl(pkey: Widestring): Widestring;
        function getPref(cname: Widestring): Widestring;
        function getStringlistCount(pkey: Widestring; server_side: TPrefKind = pkClient): Integer;
        function getStringlistValue(pkey: Widestring; index: Integer; server_side: TPrefKind = pkClient): Widestring;

        procedure fillStringlistInProfile(profilename: Widestring; pkey: Widestring; sl: TWideStrings; server_side: TPrefKind = pkClient); overload;
        function getStringInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): Widestring;
        function getIntInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): integer;
        function getBoolInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): boolean;
        function getDateTimeInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): TDateTime;
        function getSetDateTimeInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): TDateTime;
        function getStringlistCountInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): Integer;
        function getStringlistValueInProfile(profilename: Widestring; pkey: Widestring; index: Integer; server_side: TPrefKind = pkClient): Widestring;

        // setters
        procedure setString(pkey, pvalue: Widestring; server_side: TPrefKind = pkClient);
        procedure setInt(pkey: Widestring; pvalue: integer; server_side: TPrefKind = pkClient);
        procedure setBool(pkey: Widestring; pvalue: boolean; server_side: TPrefKind = pkClient);
        procedure setDateTime(pkey: Widestring; pvalue: TDateTime; server_side: TPrefKind = pkClient);
        procedure setStringlist(pkey: Widestring; pvalue: TWideStrings; server_side: TPrefKind = pkClient); overload;

        procedure AddStringlistValue(pkey, value: Widestring; server_side: TPrefKind = pkClient);
        procedure RemoveStringlistValue(pkey, value: Widestring; server_side: TPrefKind = pkClient);

        procedure setStringInProfile(profilename: Widestring; pkey, pvalue: Widestring; server_side: TPrefKind = pkClient);
        procedure setIntInProfile(profilename: Widestring; pkey: Widestring; pvalue: integer; server_side: TPrefKind = pkClient);
        procedure setBoolInProfile(profilename: Widestring; pkey: Widestring; pvalue: boolean; server_side: TPrefKind = pkClient);
        procedure setDateTimeInProfile(profilename: Widestring; pkey: Widestring; pvalue: TDateTime; server_side: TPrefKind = pkClient);
        procedure setStringlistInProfile(profilename: Widestring; pkey: Widestring; pvalue: TWideStrings; server_side: TPrefKind = pkClient); overload;

        procedure AddStringlistValueInProfile(profilename: Widestring; pkey, value: Widestring; server_side: TPrefKind = pkClient);
        procedure RemoveStringlistValueInProfile(profilename: Widestring; pkey, value: Widestring; server_side: TPrefKind = pkClient);
{$ifdef Exodus}
        procedure fillStringlist(pkey: Widestring; sl: TTntStrings; server_side: TPrefKind = pkClient); overload;
        procedure setStringlist(pkey: Widestring; pvalue: TTntStrings; server_side: TPrefKind = pkClient); overload;

        procedure fillStringlistInProfile(profilename: Widestring; pkey: Widestring; sl: TTntStrings; server_side: TPrefKind = pkClient); overload;
        procedure setStringlistInProfile(profilename: Widestring; pkey: Widestring; pvalue: TTntStrings; server_side: TPrefKind = pkClient); overload;
{$endif}
        {**
            Get/set the xml child of a pref.
        **}
        function getXMLPref(pkey : WideString; server_side: TPrefKind = pkClient) : TXMLTag;
        procedure setXMLPref(value : TXMLTag; server_side: TPrefKind = pkClient);

        function getXMLPrefInProfile(profilename: Widestring; pkey : WideString; server_side: TPrefKind = pkClient) : TXMLTag;
        procedure setXMLPrefInProfile(profilename: Widestring; value : TXMLTag; server_side: TPrefKind = pkClient);

        function getImage(pkey : WideString; image : TImage; imageList : WideString = ''; server_side: TPrefKind = pkClient) : boolean;
        procedure setImage(pkey : WideString; image : TImage; imageList : WideString = ''; server_side: TPrefKind = pkClient);

        // Custom presence getters
        function getAllPresence(): TWidestringList;
        function getPresence(pkey: Widestring): TJabberCustomPres;
        function getPresIndex(idx: integer): TJabberCustomPres;

        // Custom presence setters
        procedure setPresence(pvalue: TJabberCustomPres);
        procedure removePresence(pvalue: TJabberCustomPres);
        procedure removeAllPresence();
        procedure setupDefaultPresence();

        // Form position stuff
        procedure SavePosition(form: TForm); overload;
        procedure SavePosition(form: TForm; key: Widestring); overload;
        procedure CheckPositions(form: TForm; t, l, w, h: integer);
        procedure RestorePosition(form: TForm; RestoreSize: boolean = true); overload;
        function RestorePosition(form: TForm; key: Widestring; RestoreSize: boolean = true): boolean; overload;

        {
            Retrieves the given root tag.

            Checks the top level children of the <exodus> node for rootName and
            returns a <b>copy</b> of it. Returns nil if node could not be found.
            Only uses user pref file, branding and defaults are not accessable.
            Including server stuff for now, not sure about its access.

            @param rootName - node name for top level child of <exodus> tag.
            @param rootTag [out] the node or nil if it does not exist.
            @return true of node existed, else false.
        }
        function getRoot(rootName: WideString; var rootTag: TXMLTag; server_side: TPrefKind = pkClient): boolean;

        {
            Replaces the top level <exodus/> child with the given node.

            Sets the dirty flag on success. returns true if the child already
            exists (true replacement) and frees the current child, copies
            the new child into root.

            @param rootTag - child to replace
            @return
        }
        function setRoot(rootTag: TXMLTag; server_side: TPrefKind = pkClient): boolean;


        // HTTP Proxy stuff
        procedure setProxy(http: TIdHttp);
        procedure getHttpProxy(var host: string; var port: integer);

        // Profiles
        procedure LoadProfiles;
        procedure SaveProfiles;
        procedure RemoveProfile(p: TJabberProfile);
        function CreateProfile(name: Widestring): TJabberProfile;

        // Local Bookmark storage
        function LoadBookmarks(): TXMLTag;
        procedure SaveBookmarks(tag: TXMLTag);

        // Local Groups storage
        function LoadGroups(): TXMLTag;
        procedure SaveGroups(tag: TXMLTag);

        // Misc.
        procedure SetSession(js: TObject);
        procedure FetchServerPrefs();
        procedure SaveServerPrefs();
        function GetSoundFile(key: widestring): widestring;

//        function getXMLTag(name: Widestring): TXMLTag;

        property Profiles: TWideStringList read _profiles write _profiles;
        property Filename: WideString read _pref_filename;
end;
    {**
        Wrapper around application specific information like ID and caption
        This information is taken from the branding or default and is accessable
        immediately after loadtime.
    **}
    TApplicationInfo = class
    private
        cachedID      : String;
        cachedCaption : WideString;

        function GetID() : string;
        function GetCaption : WideString;
    public
        property ID : String read getID;
        property Caption : WideString read getCaption;
    end;

var
    s_brand_file: TPrefFile;
    s_default_file: TPrefFile;

const
    sIdleAway = 'Away as a result of idle.';
    sIdleXA = 'XA as a result of idle.';


function getPrefState(pkey: Widestring): TPrefState;
function getMyDocs: string;
function getUserDir: string;
function resourceName : Widestring;
{**
    Application ID. This is an ID that can be used for paths, filenames,
    window message ID, resources. It is NOT a caption.

    Will attempt to get the ID from branding or default prefs. Defaults to Exodus
    if not available. The ID may change in one specific state. If the ID
    is not available because the default and branding prefs have not
    yet been loaded, Exodus will be returned. This MAY happen if
    ID is used in an initialization section. After initialization,
    the ID may not be Exodus.
**}
function getAppInfo(): TApplicationInfo;

{$ifdef Win32}
function ReplaceEnvPaths(value: string): string;
{$endif}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef Win32}
    ComCtrls, Graphics, ShellAPI,
    {$else}
    QGraphics,
    {$endif}
    {$ifdef Exodus}
    GnuGetText,
//    ExUtils,
    {$endif}
    PrefGraphics, //graphics handling for prefs
    DisplayName,  //for our display name
    JabberConst, StrUtils, Stringprep,
    IdGlobal, IdCoder3To4, Session, IQ, XMLUtils, IdHTTPHeaderInfo, Types;


var
    task_rect: TRect;
    task_dir: integer;
    cachedAppInfo : TApplicationInfo; //App info once we can get defaults and branding
    s_Graphics: TPrefGraphic;

Constructor TPrefMapValue.Create(value : WideString);
begin
    FValue := value;
end;

{---------------------------------------}
function getPrefState(pkey: WideString): TPrefState;
begin
    Result :=  s_brand_file.getState(pkey);
    if (Result = psUnknown) then
        Result := s_default_file.getState(pkey);
    if (Result = psUnknown) then
        Result := psReadWrite;
end;

function lockedDown(prefs : TPrefFile; pkey : WideString) : boolean;
var
    t : TPrefState;
begin
    t := prefs.getState(pkey);
    result := (t = psReadOnly) or (t = psInvisible);
end;

function getBestFile(userFile : TPrefFile; pkey : WideString) : TPrefFile;
begin
    if (lockedDown(s_brand_file, pkey)) then
        Result := s_brand_file
    else if (lockedDown(s_default_file, pkey)) then
        Result := s_default_file
    else if (userFile.hasPref(pkey)) then
        Result := userFile
    else if (s_brand_file.hasPref(pkey)) then
        Result := s_brand_file
    else
        Result := s_default_file;
end;

function getDefaultFile(pkey : WideString) : TPrefFile;
begin
    if (s_brand_file.hasPref(pkey)) then
        Result := s_brand_file
    else
        Result := s_default_file;
end;

{---------------------------------------}
{** Attempt to get pref from branding prefs. If it is not there or
    is locked down, get the pref from defaults.
    \return The pref from branding if possible, or from defaults. returns
            an empty string if not present or available in either
**}
function getBrandingOrDefaultPref(pkey : WideString) : WideString;
var
    uf : TPrefFile;
begin
    uf := getBestFile(s_brand_file, pkey);
    Result := uf.getString(pKey);
end;

function TApplicationInfo.GetID() : String;
    function GetLongFileName(const FileName: string): string;
    var
        SHFileInfo: TSHFileInfo;
    begin
        if SHGetFileInfo(PChar(FileName),
                       0,
                       SHFileInfo,
                       SizeOf(SHFileInfo),
                       SHGFI_DISPLAYNAME) <> 0 then
        Result := string(SHFileInfo.szDisplayName)
        else
        Result := FileName;
    end;
var
    tstr : string;
    tstr2: string;
begin
    try
        if (cachedID = '') then
        begin
            //remove .exe

            tstr := ExtractFileName(GetLongFileName(Application.ExeName));

            // This is a poor way of doing this, but we don't want the file extension
            // If file extensions are hidden, then we leave this allone.
            // If they are showing then chop off .exe.  We check this by seeing if
            // last 4 characters are .exe or not.
            if (Length(tstr) > 4) then
                tstr2 := LowerCase(Rightstr(tstr, 4))
            else
                tstr2 := '';

            if (tstr2 = '.exe') then
                cachedID := Copy(tstr, 0, Length(tstr) - 4)
            else
                cachedID := Copy(tstr, 0, Length(tstr));
        end;
        Result := cachedID;
    Except
        cachedID := '';
        Result := 'Exodus';
    end;
end;

function TApplicationInfo.GetCaption() : WideString; begin
    try
        if (cachedCaption = '') then
        begin
            cachedCaption := getBrandingOrDefaultPref('brand_caption');
        end;
        Result := cachedCaption;
    Except
        cachedCaption := '';
        Result := 'Exodus';
    end;
end;

{$ifndef Exodus}
function _(inp: Widestring): Widestring;
begin
    Result := inp;
end;
{$endif}

{$ifdef Win32}
{---------------------------------------}
function getMyDocs: string;
var
    reg: TRegistry;
begin
    // Get the path to My Documents
    Result := '';

    try
    reg := TRegistry.Create;
    try //finally free
        with reg do begin
            RootKey := HKEY_CURRENT_USER;
            OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders');
            if ValueExists('Personal') then begin
                Result := ReadString('Personal') + '\';
                Result := ReplaceEnvPaths(Result);
            end;
        end;
    finally
        reg.Free();
    end;
    except
        Result := ExtractFilePath(Application.EXEName);
    end;

end;

{---------------------------------------}
{**
    Application ID. This is an ID that can be used for paths, filenames,
    window message ID, resources. It is NOT a caption.

    Will attempt to get the ID from branding or default prefs. Defaults to Exodus
    if not available. The ID may change in one specific state. If the ID
    is not available because the default and branding prefs have not
    yet been loaded, Exodus will be returned. This MAY happen if
    ID is used in an initialization section. After initialization,
    the ID may not be Exodus.
**}
function getAppInfo() : TApplicationInfo;
begin
    if (cachedAppInfo = nil) then begin
        cachedAppInfo := TApplicationInfo.create();
    end;
    Result := cachedAppInfo;
end;

{---------------------------------------}
function getUserDir: string;
var
    appdata: string;
    local_appdata: string;
    exe_path: string;
    reg: TRegistry;

    function testDir(dir: string; create: boolean): boolean;
    var
        dir_ok: boolean;
        f: TFileStream;
        fn: string;
    begin
        // first just check the file
        Result := false;
        fn := dir + getAppInfo().ID + '.xml';
        if (fileExists(fn)) then begin
            Result := true;
            exit;
        end;

        if (not Create) then exit;

        // check the directory
        dir_ok := DirectoryExists(dir);
        if (dir_ok = false) then begin
            dir_ok := CreateDir(dir);
        end;
        if (dir_ok = false) then exit;

        // try to create a new file
        try
            f := TFileStream.Create(dir + 'test.xml', fmCreate);
            f.Free();
            DeleteFile(dir + 'test.xml');
            Result := true;
        except
            // just eat these.
            on EFOpenError do exit;
        end;
    end;

begin
    try
        //get application name from either default or branding

        reg := TRegistry.Create;
        try //finally free
            with reg do begin
                RootKey := HKEY_CURRENT_USER;
                OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders');
                if ValueExists('AppData') then begin
                    appdata := ReadString('AppData') + '\' + getAppInfo().ID + '\';
                    appdata := ReplaceEnvPaths(appdata);
                end;

                if ValueExists('Local AppData') then begin
                    local_appdata := ReadString('Local AppData') + '\' + getAppInfo().ID + '\';
                    local_appdata := ReplaceEnvPaths(local_appdata);
                end;

                exe_path := ExtractFilePath(Application.EXEName);
            end;
        finally
            reg.Free();
        end;
    except
        exe_path := ExtractFilePath(Application.EXEName);
    end;

    // first try appdata,
    // then try local_appdata,
    // then use exe_path as a last resort
    Result := '';

    // these check for existing files
    if (testDir(appdata, false)) then Result := appdata
    else if (testDir(local_appdata, false)) then Result := local_appdata
    else if (testDir(exe_path, false)) then Result := exe_path;

    if (Result = '') then begin
        // these try to create a new file
        if (testDir(appData, true)) then Result := appData
        else if (testDir(local_appdata, true)) then Result := local_appdata
        else Result := exe_path;
    end;

end;

{---------------------------------------}
function ReplaceEnvPaths(value: string): string;
var
    tmps: String;
    tp: PChar;
begin
    // Replace all of the env. paths.. must use a fixed size buff
    getMem(tP,1024);
    ExpandEnvironmentStrings(PChar(value), tp, 1023);
    tmps := String(tp);
    FreeMem(tP);
    Result := tmps;
end;

{---------------------------------------}
procedure getDefaultPos;
var
    taskbar: HWND;
    mh, mw: integer;
begin
    //
    taskbar := FindWindow('Shell_TrayWnd', '');
    GetWindowRect(taskbar, task_rect);

    mh := Screen.DesktopHeight div 2;
    mw := Screen.DesktopWidth div 2;
    if ((task_rect.Left < mw) and (task_rect.Top < mh) and (task_rect.Right < mw)) then
        task_dir := 0
    else if ((task_rect.left > mw) and (task_rect.Top < mh)) then
        task_dir := 1
    else if (task_rect.top < mh) then
        task_dir := 2
    else
        task_dir := 3;
end;

function resourceName() : Widestring;
var
  computerName, brandingResource: Widestring;
  size: DWORD;
begin
  Result := '';
  //If resource is not empty in the branding file, will use it.
  if (MainSession <> nil) then
     if (MainSession.Prefs <> nil) then
        brandingResource := MainSession.Prefs.getString('brand_profile_resource');
        if (Trim(brandingResource) <> '') then begin
           Result := brandingResource;
           exit;
        end;

  //If branding file resource is empty, will use computer name.
  SetLength(computerName,  MAX_COMPUTERNAME_LENGTH+1);
  size := Length(computerName);
  if GetComputerNameW (PWideChar(computerName), size) then begin
     SetLength(computerName, size);
     Result := computerName;
  end;

end;

{$else}

procedure getUserDir(): string;
begin
    Result := '~/';
end;

procedure getMyDocs(): string;
begin
    Result := '~/';
end;

procedure getDefaultPos;
begin
    //
end;



{$endif}

{---------------------------------------}
constructor TPrefController.Create(filename: Widestring);
var
{$ifdef Exodus}
    reg  : TRegistry;
{$endif}
    p    : WideString;
    temptag: TXMLTag;
begin
    inherited Create();

    // If we used -c, we may just be using the current dir,
    // So get the current dir, and pre-pend it.
    _pref_filename := filename;
    p := ExtractFilePath(_pref_filename);
    if (p = '') then begin
        p := GetCurrentDir();
        _pref_filename := p + '\' + _pref_filename;
    end;

    _pref_file := TPrefFile.Create(_pref_filename);
    if (_pref_file.NeedDefaultPresence) then
        setupDefaultPresence();

    _server_file := nil;
    _profiles := TWideStringList.Create;
    _updating := false;

    getDefaultPos();

    temptag := getXMLPref('brand_images');
    s_Graphics.setBranded(temptag);
    temptag.Free();
    
    {$ifdef Exodus}
    // Write out the current prefs file..
    // this is so the un-installer can remove the prefs
    // when it does it's thing.

    // Note: Joe doesn't get all *his* prefs files removed.  Probably
    // only the one for the instance that started last.

    reg := TRegistry.Create();
    try
        reg.RootKey := HKEY_CURRENT_USER;
        reg.OpenKey('\Software\Jabber\' + getAppInfo().ID, true);
        reg.WriteString('prefs_file', _pref_filename);
        reg.CloseKey();
    finally
        reg.Free();
    end;
    {$endif}

end;

{---------------------------------------}
destructor TPrefController.Destroy;
var
    i: integer;
    p: TJabberProfile;
begin
    // Kill our cache'd nodes, etc.
    if (_pref_file <> nil) then
        _pref_file.Free();
    if (_server_file <> nil) then
        _server_file.Free();

    for i := _profiles.Count - 1 downto 0 do begin
        p := TJabberProfile(_profiles.Objects[i]);
        if (p <> nil) then
            p.Destroy;
        _profiles.Delete(i);
    end;

    _profiles.Free();

    inherited Destroy;

end;

{---------------------------------------}
procedure TPrefController.Save;
begin
    if (_updating) then exit;

    _pref_file.save();
    // TODO: save server prefs
end;

{---------------------------------------}
function TPrefController.getRoot(rootName: WideString; var rootTag: TXMLTag; server_side: TPrefKind = pkClient): boolean;
begin
    Result := _pref_file.getRoot(rootName, rootTag);
end;

{---------------------------------------}
function TPrefController.setRoot(rootTag: TXMLTag; server_side: TPrefKind = pkClient): boolean;
begin
    Result := _pref_file.setRoot(rootTag);
end;

{---------------------------------------}
function TPrefController.getString(pkey: Widestring; server_side: TPrefKind = pkClient): Widestring;
var
    uf: TPrefFile;
    uv: Widestring;
//    ds, bs: TPrefState;
begin
    Result := '';
    // TODO: what SHOULD we do if we get a server-side pref request, and we
    // haven't gotten any server prefs yet?
    if (server_side = pkDefault) then
        uf := getDefaultFile(pkey)
    else begin
        if ((server_side <> pkServer) or (_server_file = nil)) then
            uf := _pref_file
        else
            uf := _server_file;

        uf := getBestFile(uf, pkey);
    end;
    uv := uf.getString(pkey);
    if (uv <> '') then
        Result := uv
    else
        Result := getDynamicDefault(pkey);
end;

{---------------------------------------}
function TPrefController.getStringInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): Widestring;
var
    uf: TPrefFile;
    uv: Widestring;
    t: TXMLTag;
begin
    Result := '';
    // TODO: what SHOULD we do if we get a server-side pref request, and we
    // haven't gotten any server prefs yet?
    if (server_side = pkDefault) then
        uf := getDefaultFile(pkey)
    else begin
        if ((server_side <> pkServer) or (_server_file = nil)) then
            uf := _pref_file
        else
            uf := _server_file;

        uf := getBestFile(uf, pkey);
    end;

    t := getProfilePrefsTag(profilename);
    if (t <> nil) then begin
        uv := uf.getStringInProfile(t, pkey);
        if (uv <> '') then
            Result := uv
        else
            Result := getDynamicDefault(pkey);
    end;
end;

{---------------------------------------}
function TPrefController.getDynamicDefault(pkey: Widestring): Widestring;
begin
    result := ''; //unkown
    // set the defaults for the pref controller
    if pkey = 'away_status' then
        result := _(sIdleAway)
    else if pkey = 'xa_status' then
        result := _(sIdleXA)
    else if pkey = 'log_path' then
        result := getMyDocs() + getAppInfo().ID + '-Logs'
    else if pkey = 'xfer_path' then
        result := getMyDocs() + getAppInfo().ID + '-Downloads'
    else if pkey = 'spool_path' then
        result := getUserDir() + 'spool.xml'

    {$ifdef Win32}
    else if pkey = 'roster_font_name' then
        result := Screen.IconFont.Name
    else if pkey = 'roster_font_size' then
        result := IntToStr(Screen.IconFont.Size)
    else if pkey = 'roster_font_color' then
        result := IntToStr(Integer(Screen.IconFont.Color))
    {$else}
    else if pkey = 'roster_font_name' then
        result := Application.Font.Name
    else if pkey = 'roster_font_size' then
        result := IntToStr(Application.Font.Size)
    else if pkey = 'roster_font_color' then
        result := IntToStr(Integer(Application.Font.Color))
    {$endif}

end;

{---------------------------------------}
function TPrefController.getInt(pkey: Widestring; server_side: TPrefKind = pkClient): integer;begin
    // find int value
    Result := SafeInt(getString(pkey, server_side));
end;

{---------------------------------------}
function TPrefController.getIntInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): integer;begin
    // find int value
    Result := SafeInt(getStringInProfile(profilename, pkey, server_side));
end;

{---------------------------------------}
function TPrefController.getBool(pkey: Widestring; server_side: TPrefKind = pkClient): boolean;
begin
    Result := SafeBool(getString(pkey, server_side));
end;

{---------------------------------------}
function TPrefController.getBoolInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): boolean;
begin
    Result := SafeBool(getStringInProfile(profilename, pkey, server_side));
end;

{---------------------------------------}
function TPrefController.getDateTime(pkey: Widestring; server_side: TPrefKind = pkClient): TDateTime;
var
    f: TFormatSettings;
begin
    GetLocaleFormatSettings(LANG_NEUTRAL, f);
    Result := StrToDateTimeDef(getString(pkey, server_side), Now(), f);
end;

{---------------------------------------}
function TPrefController.getDateTimeInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): TDateTime;
var
    f: TFormatSettings;
begin
    GetLocaleFormatSettings(LANG_NEUTRAL, f);
    Result := StrToDateTimeDef(getStringInProfile(profilename, pkey, server_side), Now(), f);
end;

{---------------------------------------}
function TPrefController.getSetDateTime(pkey: Widestring; server_side: TPrefKind = pkClient): TDateTime;
var
    f: TFormatSettings;
    s: string;
    n: TDateTime;
begin
    GetLocaleFormatSettings(LANG_NEUTRAL, f);
    s := getString(pkey, server_side);
    n := Now();
    if (s = '') then begin
        Result := n;
        setString(pkey, DateTimeToStr(n, f), server_side);
    end else
        Result := StrToDateTimeDef(s, n, f);
end;

{---------------------------------------}
function TPrefController.getSetDateTimeInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): TDateTime;
var
    f: TFormatSettings;
    s: string;
    n: TDateTime;
begin
    GetLocaleFormatSettings(LANG_NEUTRAL, f);
    s := getStringInProfile(profilename, pkey, server_side);
    n := Now();
    if (s = '') then begin
        Result := n;
        setString(pkey, DateTimeToStr(n, f), server_side);
    end else
        Result := StrToDateTimeDef(s, n, f);
end;

{---------------------------------------}
procedure TPrefController.setBool(pkey: Widestring; pvalue: boolean; server_side: TPrefKind = pkClient);
begin
     if (pvalue) then
        setString(pkey, 'true', server_side)
     else
        setString(pkey, 'false', server_side);
end;

{---------------------------------------}
procedure TPrefController.setBoolInProfile(profilename: Widestring; pkey: Widestring; pvalue: boolean; server_side: TPrefKind = pkClient);
begin
     if (pvalue) then
        setStringInProfile(profilename, pkey, 'true', server_side)
     else
        setStringInProfile(profilename, pkey, 'false', server_side);
end;

{---------------------------------------}
procedure TPrefController.setDateTime(pkey: Widestring; pvalue: TDateTime; server_side: TPrefKind = pkClient);
var
    f: TFormatSettings;
begin
    // store in lang-independant way, so we know how to read in.
    GetLocaleFormatSettings(LANG_NEUTRAL, f);
    setString(pkey, DateTimeToStr(pvalue, f), server_side);
end;

{---------------------------------------}
procedure TPrefController.setDateTimeInProfile(profilename: Widestring; pkey: Widestring; pvalue: TDateTime; server_side: TPrefKind = pkClient);
var
    f: TFormatSettings;
begin
    // store in lang-independant way, so we know how to read in.
    GetLocaleFormatSettings(LANG_NEUTRAL, f);
    setStringInProfile(profilename, pkey, DateTimeToStr(pvalue, f), server_side);
end;

{---------------------------------------}
procedure TPrefController.setString(pkey, pvalue: Widestring; server_side: TPrefKind = pkClient);
var
    uf: TPrefFile;
begin
    // TODO: see getString()
    if ((server_side <> pkServer) or (_server_file = nil)) then
        uf := _pref_file
    else
        uf := _server_file;

    uf.setString(pkey, pvalue);
    Save();
end;

{---------------------------------------}
procedure TPrefController.setStringInProfile(profilename: Widestring; pkey, pvalue: Widestring; server_side: TPrefKind = pkClient);
var
    uf: TPrefFile;
    t: TXMLTag;
begin
    // TODO: see getString()
    if ((server_side <> pkServer) or (_server_file = nil)) then
        uf := _pref_file
    else
        uf := _server_file;

    t := getProfilePrefsTag(profilename);
    if (t <> nil) then begin
        uf.setStringInProfile(t, pkey, pvalue);
    end;
    SaveProfiles();
end;

{---------------------------------------}
procedure TPrefController.setInt(pkey: Widestring; pvalue: integer; server_side: TPrefKind = pkClient);
begin
    setString(pkey, IntToStr(pvalue), server_side);
end;

{---------------------------------------}
procedure TPrefController.setIntInProfile(profilename: Widestring; pkey: Widestring; pvalue: integer; server_side: TPrefKind = pkClient);
begin
    setStringInProfile(profilename, pkey, IntToStr(pvalue), server_side);
end;

{---------------------------------------}
function TPrefController.getStringlistCount(pkey: Widestring; server_side: TPrefKind = pkClient): Integer;
var
    ts: TWideStringList;
begin
    ts := TWideStringList.Create();
    try
        fillStringList(pkey, ts, server_side);
        Result := ts.Count;
    finally
        ts.Free();
    end;
end;

{---------------------------------------}
function TPrefController.getStringlistCountInProfile(profilename: Widestring; pkey: Widestring; server_side: TPrefKind = pkClient): Integer;
var
    ts: TWideStringList;
begin
    ts := TWideStringList.Create();
    try
        fillStringListInProfile(profilename, pkey, ts, server_side);
        Result := ts.Count;
    finally
        ts.Free();
    end;
end;

{---------------------------------------}
{
    Anytime the string list is modified in part, we need to make sure the user
    pref file has the latest version of the string list, no matter where we got it
    from. For instance, if the string list does not yet exist in the user pref file
    and we do a getStringListCount, *that* string list may have some from the
    branding file. Now we want to add to it so we need to make sure
    the user pref file has a copy of the one from the branding file.
    Utlimately this means we *must* deal with string lists as an atomic data
    structure, even when using methods that pull pieces out.
}
procedure TPrefController.AddStringlistValue(pkey, value: Widestring; server_side: TPrefKind = pkClient);
var
    ts: TWideStringList;
begin
    ts := TWideStringList.Create();
    try
        fillStringList(pkey, ts, server_side);
        //now modify the string list and save it to prefs
        if (ts.IndexOf(value) = -1) then
            ts.Add(value);
        setStringList(pkey, ts, server_side);
        Save();
    finally
        ts.Free();
    end;
end;

{---------------------------------------}
{
    Anytime the string list is modified in part, we need to make sure the user
    pref file has the latest version of the string list, no matter where we got it
    from. For instance, if the string list does not yet exist in the user pref file
    and we do a getStringListCount, *that* string list may have some from the
    branding file. Now we want to add to it so we need to make sure
    the user pref file has a copy of the one from the branding file.
    Utlimately this means we *must* deal with string lists as an atomic data
    structure, even when using methods that pull pieces out.
}
procedure TPrefController.AddStringlistValueInProfile(profilename: Widestring; pkey, value: Widestring; server_side: TPrefKind = pkClient);
var
    ts: TWideStringList;
begin
    ts := TWideStringList.Create();
    try
        fillStringListInProfile(profilename, pkey, ts, server_side);
        //now modify the string list and save it to prefs
        if (ts.IndexOf(value) = -1) then
            ts.Add(value);
        setStringListInProfile(profilename, pkey, ts, server_side);
        Save();
    finally
        ts.Free();
    end;
end;

{---------------------------------------}
function TPrefController.getStringlistValue(pkey: Widestring; index: Integer; server_side: TPrefKind = pkClient): Widestring;
var
    ts: TWideStringList;
begin
    ts := TWideStringList.Create();
    try
        fillStringList(pkey, ts, server_side);
        if (index < ts.Count) then
            Result := ts[index]
        else Result := '';
    finally
        ts.Free();
    end;
end;

{---------------------------------------}
function TPrefController.getStringlistValueInProfile(profilename: Widestring; pkey: Widestring; index: Integer; server_side: TPrefKind = pkClient): Widestring;
var
    ts: TWideStringList;
begin
    ts := TWideStringList.Create();
    try
        fillStringListInProfile(profilename, pkey, ts, server_side);
        if (index < ts.Count) then
            Result := ts[index]
        else Result := '';
    finally
        ts.Free();
    end;
end;

{---------------------------------------}
procedure TPrefController.RemoveStringlistValue(pkey, value: Widestring; server_side: TPrefKind = pkClient);
var
    ts: TWideStringList;
begin
    ts := TWideStringList.Create();
    try
        fillStringList(pkey, ts, server_side);
        //now modify the string list and save it to prefs
        if (ts.IndexOf(value) > -1) then
            ts.Delete(ts.IndexOf(value));
        setStringList(pkey, ts, server_side);
        Save();
    finally
        ts.Free();
    end;
end;

{---------------------------------------}
procedure TPrefController.RemoveStringlistValueInProfile(profilename, pkey, value: Widestring; server_side: TPrefKind = pkClient);
var
    ts: TWideStringList;
begin
    ts := TWideStringList.Create();
    try
        fillStringListInProfile(profilename, pkey, ts, server_side);
        //now modify the string list and save it to prefs
        if (ts.IndexOf(value) > -1) then
            ts.Delete(ts.IndexOf(value));
        setStringListInProfile(profilename, pkey, ts, server_side);
        Save();
    finally
        ts.Free();
    end;
end;

{---------------------------------------}
procedure TPrefController.fillStringlist(pkey: Widestring; sl: TWideStrings; server_side: TPrefKind = pkClient);
var
    uf: TPrefFile;
begin
    // TODO: what SHOULD we do if we get a server-side pref request, and we
    // haven't gotten any server prefs yet?
    if (server_side = pkDefault) then
        uf := getDefaultFile(pkey)
    else begin
        if ((server_side <> pkServer) or (_server_file = nil)) then
            uf := _pref_file
        else
            uf := _server_file;

        uf := getBestFile(uf, pKey);
    end;
    uf.fillStringlist(pkey, sl);
end;

{---------------------------------------}
procedure TPrefController.fillStringlistInProfile(profilename: Widestring; pkey: Widestring; sl: TWideStrings; server_side: TPrefKind = pkClient);
var
    uf: TPrefFile;
    t: TXMLTag;
begin
    // TODO: what SHOULD we do if we get a server-side pref request, and we
    // haven't gotten any server prefs yet?
    if (server_side = pkDefault) then
        uf := getDefaultFile(pkey)
    else begin
        if ((server_side <> pkServer) or (_server_file = nil)) then
            uf := _pref_file
        else
            uf := _server_file;

        uf := getBestFile(uf, pKey);
    end;

    t := getProfilePrefsTag(profilename);
    if (t <> nil) then
        uf.fillStringlistInProfile(t, pkey, sl);
end;

{---------------------------------------}
{$ifdef Exodus}
procedure WideToTnT(ins: TWideStrings; outs: TTntStrings);
var
    i : integer;
begin
    outs.Clear();
    for i := 0 to ins.Count -1 do begin
        outs.Add(ins[i])
    end;
end;

{---------------------------------------}
procedure TnTToWide(ins: TTntStrings; outs: TWideStrings);
var
    i : integer;
begin
    outs.Clear();
    for i := 0 to ins.Count -1 do begin
        outs.Add(ins[i])
    end;
end;

{---------------------------------------}
procedure TPrefController.fillStringlist(pkey: Widestring; sl: TTntStrings; server_side: TPrefKind = pkClient);
var
    tsl : TWideStringList;
begin
    tsl := TWideStringList.Create();
    try
        fillStringList(pkey, tsl, server_side);
        WideToTnT(tsl, sl);
    finally
        tsl.Free();
    end;
end;

{---------------------------------------}
procedure TPrefController.fillStringlistInProfile(profilename: Widestring; pkey: Widestring; sl: TTntStrings; server_side: TPrefKind = pkClient);
var
    tsl : TWideStringList;
begin
    tsl := TWideStringList.Create();
    try
        fillStringListInProfile(profilename, pkey, tsl, server_side);
        WideToTnT(tsl, sl);
    finally
        tsl.Free();
    end;
end;
{$endif}

{---------------------------------------}
procedure TPrefController.setStringlist(pkey: Widestring; pvalue: TWideStrings; server_side: TPrefKind = pkClient);
var
    uf: TPrefFile;
begin
    // TODO: see getString()
    if ((server_side <> pkServer) or (_server_file = nil)) then
        uf := _pref_file
    else
        uf := _server_file;

    uf.setStringList(pkey, pvalue);
    Save();
end;

{---------------------------------------}
procedure TPrefController.setStringlistInProfile(profilename: Widestring; pkey: Widestring; pvalue: TWideStrings; server_side: TPrefKind = pkClient);
var
    uf: TPrefFile;
    t: TXMLTag;
begin
    // TODO: see getString()
    if ((server_side <> pkServer) or (_server_file = nil)) then
        uf := _pref_file
    else
        uf := _server_file;

    t := getProfilePrefsTag(profilename);
    if (t <> nil) then
        uf.setStringListInProfile(t, pkey, pvalue);
    SaveProfiles();
end;

{---------------------------------------}
{$ifdef Exodus}
procedure TPrefController.setStringlist(pkey: Widestring; pvalue: TTntStrings; server_side: TPrefKind = pkClient);
var
    tsl : TWideStringList;
begin
    tsl := TWideStringList.Create();
    try
        TntToWide(pvalue,tsl);
        setStringList(pkey, tsl, server_side);
    finally
        tsl.Free();
    end;
end;

{---------------------------------------}
procedure TPrefController.setStringlistInProfile(profilename: Widestring; pkey: Widestring; pvalue: TTntStrings; server_side: TPrefKind = pkClient);
var
    tsl : TWideStringList;
begin
    tsl := TWideStringList.Create();
    try
        TntToWide(pvalue,tsl);
        setStringListInProfile(profilename, pkey, tsl, server_side);
    finally
        tsl.Free();
    end;
end;
{$endif}

{**
    Get/set the xml child of a pref.
**}
{---------------------------------------}
function TPrefController.getXMLPref(pkey : WideString; server_side: TPrefKind = pkClient) : TXMLTag;
var
    uf: TPrefFile;
begin
    // TODO: see getString()
    if (server_side = pkDefault) then
        uf := getDefaultFile(pkey)
    else begin
        if ((server_side <> pkServer) or (_server_file = nil)) then
            uf := _pref_file
        else
            uf := _server_file;

        uf := getBestFile(uf, pkey);
    end;
    result := uf.getXMLPref(pKey);
end;

function TPrefController.getXMLPrefInProfile(profilename: Widestring; pkey : WideString; server_side: TPrefKind = pkClient) : TXMLTag;
var
    uf: TPrefFile;
    t: TXMLTag;
begin
    // TODO: see getString()
    if (server_side = pkDefault) then
        uf := getDefaultFile(pkey)
    else begin
        if ((server_side <> pkServer) or (_server_file = nil)) then
            uf := _pref_file
        else
            uf := _server_file;

        uf := getBestFile(uf, pkey);
    end;

    Result := nil;
    t := getProfilePrefsTag(profilename);
    if (t <> nil) then
        result := uf.getXMLPrefInProfile(t, pKey);
end;

procedure TPrefController.setXMLPref(value: TXMLTag; server_side: TPrefKind = pkClient);
var
    uf: TPrefFile;
begin
    if ((server_side <> pkServer) or (_server_file = nil)) then
        uf := _pref_file
    else
        uf := _server_file;
    uf.setXMLPref(value);
    Save();
end;

procedure TPrefController.setXMLPrefInProfile(profilename: Widestring; value: TXMLTag; server_side: TPrefKind = pkClient);
var
    uf: TPrefFile;
    t: TXMLTag;
begin
    if ((server_side <> pkServer) or (_server_file = nil)) then
        uf := _pref_file
    else
        uf := _server_file;

    t := getProfilePrefsTag(profilename);
    if (t <> nil) then
        uf.setXMLPrefInProfile(t, value);
    Save();
end;

function TPrefController.getImage(pkey : WideString; image : TImage; imageList : WideString = ''; server_side: TPrefKind = pkClient) : boolean;
begin
    Result := s_Graphics.getImage(pkey, image, imagelist);
end;

procedure TPrefController.setImage(pkey : WideString; image : TImage; imageList : WideString = ''; server_side: TPrefKind = pkClient);
begin
    s_Graphics.setImage(pkey, image, imagelist);
end;

{---------------------------------------}
procedure TPrefController.removePresence(pvalue: TJabberCustomPres);
begin
    _pref_file.removePresence(pvalue.title);
end;

{---------------------------------------}
procedure TPrefController.removeAllPresence();
begin
    _pref_file.removeAllPresence();
end;

{---------------------------------------}
function TPrefController.getAllPresence(): TWidestringlist;
begin
    Result := _pref_file.getAllPresence();
end;

{---------------------------------------}
function TPrefController.getPresence(pkey: Widestring): TJabberCustomPres;
begin
    // get some custom pres from the list
    Result := _pref_file.getPresence(pkey);
end;

{---------------------------------------}
function TPrefController.getPresIndex(idx: integer): TJabberCustomPres;
begin
    Result := _pref_file.getPresIndex(idx);
end;

{---------------------------------------}
procedure TPrefController.setPresence(pvalue: TJabberCustomPres);
begin
    _pref_file.setPresence(pvalue);
    Save();
end;

{---------------------------------------}
function TPrefController.getControl(pkey: Widestring): Widestring;
begin
    // get the primary control for this pref
    Result := s_default_file.getControl(pkey);
end;

{---------------------------------------}
function TPrefController.getPref(cname: Widestring): Widestring;
begin
    // get the preference for this control name.. always from default.
    Result := s_default_file.getPref(cname);
end;

{---------------------------------------
function TPrefController.getXMLTag(name: Widestring): TXMLTag;
begin
    // find a specific tag in _pref_node and return
    Result := _pref_node.GetFirstTag(name);
end;
}


//Form state
{---------------------------------------}
procedure TPrefController.SavePosition(form: TForm);
var
    fkey: Widestring;
begin
    fkey := MungeXMLName(form.ClassName);
    SavePosition(form, fkey);
end;

{---------------------------------------}
procedure TPrefController.SavePosition(form: TForm; key: Widestring);
var
    f: TXMLTag;
begin
    // save the positions for this form
    f := _pref_file.getPositionTag(key, true);

    f.setAttribute('top', IntToStr(Form.top));
    f.setAttribute('left', IntToStr(Form.left));
    f.setAttribute('width', IntToStr(Form.width));
    f.setAttribute('height', IntToStr(Form.height));

    _pref_file.Save();
end;

{---------------------------------------}
procedure TPrefController.CheckPositions(form: TForm; t, l, w, h: integer);
{var
    ok: boolean;
    dtop, tmp: TRect;
    mon: TMonitor;
    cp: TPoint;
    vwidth, vht, i: integer;
}    
begin
//    tmp := Bounds(l, t, w, h);

    // Netmeeting hack
    if (Assigned(Application.MainForm)) then
        Application.MainForm.Monitor;

    Form.SetBounds(l, t, w, h);
    Form.MakeFullyVisible();
{ JJF MakeFullyVisible should do the job much better.
    // For multiple monitors, make a desktop rect that spans all monitors
    vwidth := 0;
    vht := 0;
    for i := 0 to Screen.MonitorCount - 1 do begin
        mon := Screen.Monitors[i];
        vwidth := vwidth + Abs(mon.BoundsRect.Right - mon.BoundsRect.Left);
        vht := vht + Abs(mon.BoundsRect.Bottom - mon.BoundsRect.Top);
    end;

    dtop := Bounds(0, 0, vwidth, vht);

    // Make it slightly bigger to acccomodate PtInRect
    dtop.Bottom := dtop.Bottom + 1;
    dtop.Right := dtop.Right + 1;

    ok := PtInRect(dtop, tmp.TopLeft) and
          PtInRect(dtop, tmp.BottomRight);

    if (ok = false) then begin
        // center it on the default monitor
        mon := Screen.MonitorFromWindow(form.Handle, mdNearest);
        dtop := mon.WorkAreaRect;

        cp := CenterPoint(dtop);
        l := cp.x - (w div 2);
        t := cp.y - (h div 2);
        tmp := Bounds(l, t, w, h);
    end;

    l := tmp.left;
    t := tmp.top;
    w := Abs(tmp.Right - tmp.Left);
    h := Abs(tmp.Bottom - tmp.Top);
    Form.SetBounds(l, t, w, h);
    }
end;

{---------------------------------------}
function TPrefController.RestorePosition(form: TForm; key: Widestring; RestoreSize: boolean): boolean;
var
    f: TXMLTag;
    t,l,w,h: integer;
begin
    f := _pref_file.getPositionTag(key);
    if (f <> nil) then begin
        t := SafeInt(f.getAttribute('top'));
        l := SafeInt(f.getAttribute('left'));
        if (RestoreSize) then begin
            w := SafeInt(f.getAttribute('width'));
            h := SafeInt(f.getAttribute('height'));
        end
        else begin
            w := form.Width;
            h := form.Height;
        end;
    end
    else begin
        Result := false;
        exit;
    end;

    checkPositions(form, t,l,w,h);
    Result := true;
end;

{---------------------------------------}
procedure TPrefController.RestorePosition(form: TForm; RestoreSize: boolean);
var
    f: TXMLTag;
    fkey: Widestring;
    t,l,w,h: integer;
begin
    // set the bounds based on the position info
    fkey := MungeXMLName(form.Classname);

    f := _pref_file.getPositionTag(fkey);
    if (f <> nil) then begin
        t := SafeInt(f.getAttribute('top'));
        l := SafeInt(f.getAttribute('left'));
        if (RestoreSize) then begin
            w := SafeInt(f.getAttribute('width'));
            h := SafeInt(f.getAttribute('height'));
        end
        else begin
            w := form.Width;
            h := form.Height;
        end;
    end
    else begin
        t := form.Top;
        l := form.Left;
        w := form.Width;
        h := form.Height;
    end;

    checkPositions(form, t, l, w, h);
end;

{---------------------------------------}
procedure TPrefController.getHttpProxy(var host: string; var port: integer);
var
    {$ifdef Win32}
    reg: TRegistry;
    {$endif}
    sl: TStringList;
    i: integer;
begin
    host := '';
    port := 0;
    
    if (getInt('http_proxy_approach') = http_proxy_ie) then begin
        // get IE settings from registry

        // todo: figure out some way of doing this XP??
        {$ifdef Win32}
        reg := TRegistry.Create();
        sl := TStringList.Create();
        try
            reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings', false);
            if (reg.ValueExists('ProxyEnable') and (reg.ReadInteger('ProxyEnable') <> 0)) then begin
                // ProxyServer can be server:port or
                // ftp=host:port;http=host:port;https=host:port
                sl.Delimiter := ';';
                sl.DelimitedText := reg.ReadString('ProxyServer');
                if (sl.Count = 0) then
                    // uh...
                    raise Exception.Create('Invalid IE proxy server configuration')
                else if (sl.Count = 1) then begin
                    // host:port
                    sl.Delimiter := ':';
                    sl.DelimitedText := sl[0];
                    host := sl[0];
                    port := SafeInt(sl[1]);
                end
                else begin
                    // ftp=host:port;http=host:port;https=host:port
                    // where the order is indeterminate,
                    // and there may be more protocols, like gopher

                    // TODO: use http or https proxy setting correctly, based
                    // on the URL we're hitting.  I can't imagine an actual
                    // deployment that would set these differently, but there
                    // must be a use case, or it wouldn't have been in IE.
                    // Right?
                    for i := 0 to sl.Count - 1 do begin
                        if (pos('http=', sl[i]) = 1) then begin
                            sl.Delimiter := '=';
                            sl.DelimitedText := sl[i];
                            sl.Delimiter := ':';
                            sl.DelimitedText := sl[1];
                            host := sl[0];
                            port := SafeInt(sl[1]);
                            break;
                        end;
                    end;
                end;
            end;
        finally
            sl.Free();
            reg.Free();
        end;
        {$endif}
    end
    else if (getInt('http_proxy_approach') = http_proxy_custom) then begin
        host := getString('http_proxy_host');
        port := getInt('http_proxy_port');
    end;
end;

{---------------------------------------}
procedure TPrefController.setProxy(http: TIdHttp);
var
    host: string;
    port: integer;
begin
    getHttpProxy(host, port);

    if host = '' then exit;
    
    {$ifdef INDY9}
    with http.ProxyParams do begin
    {$else}
    with http.Request do begin
    {$endif}
        ProxyServer := host;
        ProxyPort := port;
        if (getBool('http_proxy_auth')) then begin
            BasicAuthentication := true;
            ProxyUsername := getString('http_proxy_user');
            ProxyPassword := getString('http_proxy_password');
        end;
    end;
end;


{---------------------------------------}
function TPrefController.CreateProfile(name: Widestring): TJabberProfile;
begin
    Result := TJabberProfile.Create(name, self);
    Result.KerbAuth  := MainSession.Prefs.getBool('brand_profile_kerberos');
    Result.SASLRealm :=  MainSession.Prefs.getString('brand_profile_realm');
    Result.x509Auth := MainSession.Prefs.getBool('brand_profile_x509auth');
    _profiles.AddObject(name, Result);
end;

{---------------------------------------}
procedure TPrefController.RemoveProfile(p: TJabberProfile);
var
    i: integer;
begin
    i := _profiles.indexOfObject(p);
    p.Free;
    if (i >= 0) then
        _profiles.Delete(i);
end;

{---------------------------------------}
procedure TPrefController.LoadProfiles;
var
    ptags: TXMLTagList;
    i, pcount: integer;
    cur_profile: TJabberProfile;
begin
    _profiles.Clear;

    ptags := _pref_file.Profiles.QueryTags('profile');
    pcount := ptags.Count;

    for i := 0 to pcount - 1 do begin
        cur_profile := TJabberProfile.Create('', self);
        cur_profile.Load(ptags[i]);
        _profiles.AddObject(cur_profile.name, cur_profile);
    end;

    ptags.Free;
end;

{---------------------------------------}
procedure TPrefController.SaveProfiles;
var
    ptag: TXMLTag;
    i: integer;
    cur_profile: TJabberProfile;
    prof_node: TXMLTag;
begin
    prof_node := _pref_file.Profiles;

    _pref_file.ClearProfiles();

    for i := 0 to _profiles.Count - 1 do begin
        cur_profile := TJabberProfile(_profiles.Objects[i]);
        // don't save temp profiles.
        if (not cur_profile.temp) then begin
            ptag := prof_node.AddTag('profile');
            cur_profile.Save(ptag);
        end;
    end;

    Save();
end;

{---------------------------------------}
function TPrefController.LoadBookmarks(): TXMLTag;
begin
    Result := _pref_file.Bookmarks;
end;

{---------------------------------------}
function TPrefController.LoadGroups(): TXMLTag;
begin
    Result := _pref_file.Groups;
end;

{---------------------------------------}
procedure TPrefController.SaveBookmarks(tag: TXMLTag);
begin
    _pref_file.SaveBookmarks(tag);
end;

{---------------------------------------}
procedure TPrefController.SaveGroups(tag: TXMLTag);
begin
    _pref_file.SaveGroups(tag);
end;

{---------------------------------------}
procedure TPrefController.SetSession(js: TObject);
begin
    // Save the session pointer;
    _js := js;
end;

{---------------------------------------}
procedure TPrefController.FetchServerPrefs();
var
    iq: TJabberIQ;
    js: TJabberSession;
begin
    // Fetch the server stored prefs
    js := TJabberSession(_js);
    iq := TJabberIQ.Create(js, js.generateID(), ServerprefsCallback, 60);
    with iq do begin
        iqType := 'get';
        toJID := '';
        Namespace := XMLNS_PRIVATE;
        with qtag.AddTag('storage') do
            setAttribute('xmlns', XMLNS_PREFS);
        Send();
    end;
end;

{---------------------------------------}
procedure TPrefController.SaveServerPrefs();
{var
    js: TJabberSession;
    stag, iq: TXMLTag;
    }
begin
 // TODO: figure out server prefs

{
    // Save the prefs to the server
    if (_server_node = nil) then exit;
    if (_js = nil) then exit;
    js := TJabberSession(_js);
    if (not js.Active) then exit;
    if (not _server_dirty) then exit;

    iq := TXMLTag.Create('iq');
    with iq do begin
        setAttribute('type', 'set');
        setAttribute('id', js.generateID());
        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_PRIVATE);
            stag := AddTag('storage');
            stag.AssignTag(_server_node);
            stag.setAttribute('xmlns', XMLNS_PREFS);
        end;
    end;
    js.SendTag(iq);
    _server_dirty := false;
    }
end;

{---------------------------------------}
procedure TPrefController.ServerPrefsCallback(event: String; tag: TXMLTag);
var
    node : TXMLTag;
begin
    // Cache the prefs node
    if (tag = nil) then exit;
    node := tag.QueryXPTag('/iq/query/storage');
    _server_file := TPrefFile.Create(node);
    TJabberSession(_js).FireEvent('/session/server_prefs', node);
end;

{---------------------------------------}
procedure TPrefController.BeginUpdate();
begin
    _updating := true;
end;

{---------------------------------------}
procedure TPrefController.EndUpdate();
begin
    _updating := false;
    Save();
end;

{---------------------------------------}
procedure TPrefController.setupDefaultPresence();
var
    cp: TJabberCustomPres;
begin
    // recreate the canned presence stuff.
    _pref_file.removeAllPresence();

    {
    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Available');
        title := Status;
        Show := '';
        hotkey := 'Ctrl + O';
    end;
    _pref_file.setPresence(cp);
    }

    {
    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Free for Chat');
        Show := 'chat';
        title := Status;
        hotkey := '';
    end;
    _pref_file.setPresence(cp);
    }

    {
    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Away');
        Show := 'away';
        title := Status;
        hotkey := 'Ctrl + A';
    end;
    _pref_file.setPresence(cp);
    }

    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Lunch');
        Show := 'away';
        title := Status;
        hotkey := 'Ctrl + L';
    end;
    _pref_file.setPresence(cp);

    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Meeting');
        Show := 'away';
        title := Status;
        hotkey := 'Ctrl + M';
    end;
    _pref_file.setPresence(cp);

    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Bank');
        Show := 'away';
        title := Status;
        hotkey := '';
    end;
    _pref_file.setPresence(cp);

    {
    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Extended Away');
        Show := 'xa';
        title := Status;
        hotkey := '';
    end;
    _pref_file.setPresence(cp);
    }

    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Gone Home');
        Show := 'xa';
        title := Status;
        hotkey := '';
    end;
    _pref_file.setPresence(cp);

    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Gone to Work');
        Show := 'xa';
        title := Status;
        hotkey := '';
    end;
    _pref_file.setPresence(cp);

    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Sleeping');
        Show := 'xa';
        title := Status;
        hotkey := '';
    end;
    _pref_file.setPresence(cp);

    {
    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Do Not disturb');
        Show := 'dnd';
        title := Status;
        hotkey := '';
    end;
    _pref_file.setPresence(cp);
    }

    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Busy');
        Show := 'dnd';
        title := Status;
        hotkey := '';
    end;
    _pref_file.setPresence(cp);

    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Working');
        Show := 'dnd';
        title := Status;
        hotkey := '';
    end;
    _pref_file.setPresence(cp);

    cp := TJabberCustomPres.Create();
    with cp do begin
        Status := _('Mad');
        Show := 'dnd';
        title := Status;
        hotkey := '';
    end;
    _pref_file.setPresence(cp);

    _pref_file.save();
end;

{---------------------------------------}
function TPrefController.getProfilePrefsTag(profilename: Widestring): TXMLTag;
var
    i: integer;
begin
    Result := nil;
    i := _profiles.IndexOf(profilename);
    if (i >= 0) then begin
        Result := TJabberProfile(_profiles.Objects[i]).ProfilePrefs;
    end;
end;

function TPrefController.GetSoundFile(key: widestring): widestring;
var
    uf: TPrefFile;
    Reg: TRegistry;
    regKey: widestring;
begin
    //check prefs file first, if not there try regigistry
    uf := getBestFile(_pref_file, key + '_sound');
    Result := uf.getString(key + '_sound');
    if (Result = '') then begin
        regKey := 'AppEvents\Schemes\Apps\'+getString('brand_caption')+'\exodus_'+key;

        Reg := TRegistry.Create();
        try
            if (Reg.OpenKey(RegKey, false)) then begin
                Result := Reg.ReadString('');
                if (Result <> '') then begin
                    //if we found it here, write it to the pefs file and delete reg key
                    SetString(key + '_sound', Result);
                    Reg.DeleteKey(RegKey);
                end;
            end;
        finally
            Reg.Free();
        end;
    end;

end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TJabberProfile.Create(prof_name : Widestring; prefs: TPrefController);
begin
    inherited Create;

    Name       := prof_name;

    with prefs do begin
        password   := getString('brand_profile_password');
        _jabberID := TJabberID.create(getString('brand_profile_username'),
                                      getString('brand_profile_server'),
                                      resourceName);
        Priority   := getInt('brand_profile_priority');
        SavePasswd := getBool('brand_profile_save_password');
        WinLogin   := getBool('brand_profile_winlogin');
        KerbAuth   := getBool('brand_profile_kerbauth');
        x509Auth   := getBool('brand_profile_x509auth');
        SASLRealm  := getString('brand_profile_saslrealm');
        ConnectionType := getInt('brand_profile_conn_type');
        temp       := false;

        // Socket connection
        Host          := getString('brand_profile_host');
        Port          := getInt('brand_profile_port');
        srv           := getBool('brand_profile_srv');
        ssl           := getInt('brand_profile_ssl');
        SocksType     := getInt('brand_profile_socks_type');
        SocksHost     := getString('brand_profile_socks_host');
        SocksPort     := getInt('brand_profile_socks_port');
        SocksAuth     := getBool('brand_profile_socks_auth');
        SocksUsername := getString('brand_profile_socks_user');
        SocksPassword := getString('brand_profile_socks_password');

        // HTTP Connection
        URL           := getString('brand_profile_http_url');
        Poll          := getInt('brand_profile_http_poll');
        NumPollKeys   := getInt('brand_profile_num_poll_keys');

        // Profile Prefs
        _profilePrefs := TXMLTag.Create('prefs');
    end;

end;

destructor TJabberProfile.Destroy();
begin
    try
        _jabberID.Free();
        _profilePrefs.Free();
    except
    end;
end;

{---------------------------------------}
function TJabberProfile.getPassword: Widestring;
begin
    // accessor for password
    result := _password;
end;

{---------------------------------------}
function TJabberProfile.getJid: Widestring;
begin
    if (WinLogin) then
        Result := _jabberID.domain + '/' + _jabberID.resource
    else
        Result := _jabberID.full;
end;

{---------------------------------------}
procedure TJabberProfile.setPassword(value: Widestring);
begin
    // accessor for password
    _password := Trim(value);
end;

{---------------------------------------}
procedure TJabberProfile.Load(tag: TXMLTag);
var
    tmps, tmps1: Widestring;
    t, ptag: TXMLTag;
begin
    // Read this profile from the registry
    Name := tag.getAttribute('name');

    tmps := tag.GetBasicText('server');
    if (tmps = '') then tmps := 'jabber.org';

    tmps1 := tag.GetBasicText('resource');
    if (tmps1 = '') then tmps1 := 'Exodus';

    _jabberID.Free();
    _jabberID := TJabberID.create(tag.GetBasicText('username'), tmps, tmps1);
    SASLRealm := tag.GetBasicText('saslrealm');

    // check for this flag this way, so that if the tag
    // doesn't exist, it'll default to true.
    ptag := tag.GetFirstTag('save_passwd');
    if (ptag <> nil) then
        SavePasswd := SafeBool(tag.GetBasicText('save_passwd'))
    else
        SavePasswd := true;

    ptag := tag.GetFirstTag('new_acct');
    if (ptag <> nil) then
        NewAccount := SafeBool(tag.GetBasicText('new_acct'))
    else
        NewAccount := false;

    ptag := tag.GetFirstTag('winlogin');
    if (ptag <> nil) then
        WinLogin := SafeBool(tag.GetBasicText('winlogin'))
    else
        WinLogin := false;

    ptag := tag.GetFirstTag('kerblogin');
    if (ptag <> nil) then
        KerbAuth := SafeBool(tag.GetBasicText('kerblogin'))
    else
        KerbAuth := false;

    ptag := tag.GetFirstTag('x509login');
    if (ptag <> nil) then
        x509Auth := SafeBool(Tag.GetBasicText('x509login'))
    else
        x509Auth := false;

    ptag := tag.GetFirstTag('password');
    if (ptag.GetAttribute('encoded') = 'yes') then
        Password := DecodeString(ptag.Data)
    else
        Password := ptag.Data;

    ptag := tag.GetFirstTag('avatar');
    if (ptag <> nil) then begin
        AvatarHash := ptag.GetAttribute('hash');
        AvatarMime := ptag.getAttribute('mime-type');
        Avatar := ptag.Data;
    end;

    Priority := SafeInt(tag.GetBasicText('priority'));
    ConnectionType := SafeInt(tag.GetBasicText('connection_type'));

    // Socket connection
    Host := tag.GetBasicText('host');
    Port := StrToIntDef(tag.GetBasicText('port'), 5222);
    srv := SafeBool(tag.GetBasicText('srv'));

    // This is for backwards compatibility
    tmps := Lowercase(tag.GetBasicText('ssl'));
    if (tmps = 'true') then
        ssl := ssl_port
    else if (tmps = 'false') then
        ssl := ssl_tls
    else
        ssl := StrToIntDef(tmps, 0);

    // backwards compat check for SRV...
    // if they have 5222 and no host, then turn on SRV
    if ((not srv) and (Port = 5222) and (host = '')) then
        srv := true;

    if ((not srv) and (Port = 5223) and (ssl = ssl_port) and (host = '')) then
        srv := true;

    ssl_cert := tag.GetBasicText('ssl_cert');
    SocksType := StrToIntDef(tag.GetBasicText('socks_type'), 0);
    SocksHost := tag.GetBasicText('socks_host');
    SocksPort := StrToIntDef(tag.GetBasicText('socks_port'), 0);
    SocksAuth := SafeBool(tag.GetBasicText('socks_auth'));
    SocksUsername := tag.GetBasicText('socks_username');
    SocksPassword := tag.GetBasicText('socks_password');

    // HTTP Connection
    URL := tag.GetBasicText('url');
    Poll := StrToIntDef(tag.GetBasicText('poll'), 10);
    NumPollKeys := StrToIntDef(tag.GetBasicText('num_poll_keys'), 256);

    // Profile Prefs
    t := tag.GetFirstTag('prefs');
    if (t <> nil) then begin
        _profilePrefs.Free();
        _profilePrefs := TXMLTag.Create(t);
    end;


    if (Name = '') then Name := 'Untitled Profile';
    if (Server = '') then Server := 'jabber.org';
    if (Resource = '') then Resource := getAppInfo().ID;
end;

{---------------------------------------}
procedure TJabberProfile.Save(node: TXMLTag);
var
    x, ptag: TXMLTag;
begin
    if (temp) then exit;

    node.ClearTags();
    node.setAttribute('name', Name);
    node.AddBasicTag('username', _jabberID.user);
    node.AddBasicTag('saslrealm', SASLRealm);
    node.AddBasicTag('server', _jabberID.domain);
    node.AddBasicTag('save_passwd', SafeBoolStr(SavePasswd));
    node.AddBasicTag('new_acct', SafeBoolStr(NewAccount));
    node.AddBasicTag('winlogin', SafeBoolStr(WinLogin));
    node.AddBasicTag('kerblogin', SafeBoolStr(KerbAuth));
    node.AddBasicTag('x509login', SafeBoolStr(x509Auth));

    ptag := node.AddTag('password');
    if (SavePasswd) then begin
        ptag.setAttribute('encoded', 'yes');
        ptag.AddCData(EncodeString(Password));
    end;

    node.AddBasicTag('resource', _jabberID.resource);
    node.AddBasicTag('priority', IntToStr(Priority));
    node.AddBasicTag('connection_type', IntToStr(ConnectionType));

    // Socket connection
    node.AddBasicTag('host', Host);
    node.AddBasicTag('port', IntToStr(Port));
    node.AddBasicTag('srv', SafeBoolStr(srv));
    node.AddBasicTag('ssl', IntToStr(ssl));
    node.AddBasicTag('socks_type', IntToStr(SocksType));
    node.AddBasicTag('socks_host', SocksHost);
    node.AddBasicTag('socks_port', IntToStr(SocksPort));
    node.AddBasicTag('socks_auth', SafeBoolStr(SocksAuth));
    node.AddBasicTag('socks_username', SocksUsername);
    node.AddBasicTag('socks_password', SocksPassword);
    node.AddBasicTag('ssl_cert', SSL_Cert);

    // HTTP Connection
    node.AddBasicTag('url', URL);
    node.AddBasicTag('poll', FloatToStr(Poll));
    node.AddBasicTag('num_poll_keys', IntToStr(NumPollKeys));

    // Profile Prefs
    if (_profilePrefs <> nil) then
        node.AddTag(TXMLTag.Create(_profilePrefs)); // Copy TXMLTag

    // Avatar
    if (Avatar <> '') then begin
        x := node.AddBasicTag('avatar', Avatar);
        x.setAttribute('hash', AvatarHash);
        x.setAttribute('mime-type', AvatarMime);
    end;

end;

{---------------------------------------}
function TJabberProfile.IsValid() : boolean;
begin
    if (Name = '') then result := false
    else if (_jabberID.user = '') then result := false
    else if (_jabberID.domain = '') then result := false
    else if (Password = '') then result := false
    else if (_jabberID.resource = '') then result := false
    else if (Port = 0) then result := false
    else result := true;
end;
{---------------------------------------}
function TJabberProfile.getUsername() : Widestring;
begin
    Result := '';
    if (_jabberID <> nil) then
      Result := _jabberID.user;
end;
{---------------------------------------}
procedure TJabberProfile.setUsername(username: Widestring);
var
    domain, res: widestring;
begin
    domain := _jabberID.domain;
    res := _jabberID.resource;
    _jabberID.free();
    _jabberID := TJabberID.Create(username, domain, res);
end;
{---------------------------------------}
function TJabberProfile.getServer(): Widestring;
begin
    Result := '';
    if (_jabberID <> nil) then
      Result := _jabberID.domain;
end;
{---------------------------------------}
procedure TJabberProfile.setServer(server: Widestring);
var
    username, res: widestring;
begin
    username := _jabberID.user;
    res := _jabberID.resource;
    _jabberID.free();
    _jabberID := TJabberID.Create(username, server, res);
end;
{---------------------------------------}
function TJabberProfile.getResource(): Widestring;
begin
    Result := '';
    if (_jabberID <> nil) then
      Result := _jabberID.resource;
end;
{---------------------------------------}
procedure TJabberProfile.setResource(res: Widestring);
var
    username, server: widestring;
begin
    username := _jabberID.user;
    server   := _jabberID.domain;
    _jabberID.Free();
    _jabberID := TJabberID.Create(username, server, res);
end;

{---------------------------------------}
function TJabberProfile.getDisplayUsername(): Widestring;
begin
    Result := '';
    if (_jabberID <> nil) then
        Result := DisplayName.getDisplayNameCache().getDisplayName(_jabberID);
end;

{---------------------------------------}
function TJabberProfile.getJabberID(): TJabberID;
begin
    if (MainSession <> nil) and (MainSession.Active) and (MainSession.SessionJid <> nil) then
        Result := MainSession.SessionJid
    else
        Result := _jabberID;
end;


initialization
{$IFDEF DEFAULTS_FROM_FILE}
    s_default_file := TPrefFile.Create(ExtractFilePath(Application.EXEName) + 'defaults.xml');
{$ELSE}
    s_default_file := TPrefFile.CreateFromResource('defaults');
{$ENDIF}
    s_brand_file := TPrefFile.Create(ExtractFilePath(Application.EXEName) + 'branding.xml');
    cachedAppInfo := TApplicationInfo.create();
    s_Graphics := TPrefGraphic.Create();

finalization
    s_default_file.Free();
    s_brand_file.Free();
    cachedAppInfo.Free();
    s_Graphics.Free();
end.

