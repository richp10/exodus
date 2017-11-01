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
unit ExResponders;


interface
uses
    Responder, Session, Signals, 
    XMLTag, Unicode, JabberUtils, ExUtils, 
    Windows, Classes, SysUtils;

type
{$IFDEF DEPRICATED_PROTOCOL}
    TBrowseResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        Namespaces: TWidestringList;
        constructor Create(Session: TJabberSession); overload;
        destructor Destroy; override;
    end;

    TAvatarResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;    
{$ENDIF}

    TResponderFactory = procedure(tag: TXMLTag);

    TVersionResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TTimeResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TTimeResponderXep202 = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TLastResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TDiscoItem = class
        Name: Widestring;
        JID: Widestring;
    end;

    TDiscoItemsResponder = class(TJabberResponder)
    private
        _items: TWidestringList;
    published
        procedure iqCallback(event: string; tag:TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
        destructor Destroy; override;
        function addItem(Name, JabberID: Widestring): Widestring;
        procedure removeItem(id: Widestring);
    end;

    TDiscoInfoResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag:TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

    TFactoryResponder = class
    private
        _session: TJabberSession;
        _cb: integer;
        _factory: TResponderFactory;
    published
        procedure respCallback(event: string; tag: TXMLTag);
    public
        constructor Create(Session: TJabberSession; xpath: string; factory: TResponderFactory);
        destructor Destroy; override;
    end;

    TUnhandledResponder = class
    private
        _session: TJabberSession;
        _cbid: integer;
    published
        procedure callback(event: string; tag: TXMLTag);
    public
        constructor Create(Session: TJabberSession); overload;
    end;


    TConfirmationResponder = class(TJabberResponder)
    published
        procedure iqCallback(event: string; tag: TXMLTag); override;
    public
        constructor Create(Session: TJabberSession); overload;
    end;

procedure initResponders();
procedure cleanupResponders();

procedure ExHandleException(e_data: TWidestringlist; showdlg: boolean);

var
    Exodus_Disco_Items: TDiscoItemsResponder;
    Exodus_Disco_Info: TDiscoInfoResponder;
{$IFDEF DEPRICATED_PROTOCOL}
    Exodus_Browse: TBrowseResponder;
{$ENDIF}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef TRACE_EXCEPTIONS}
    IdException, JclDebug, JclHookExcept, TypInfo,
    {$endif}
    CapsCache, DisplayName,
    RosterRecv,
    Room,
    RosterImages, COMController, ExSession, GnuGetText,
    JabberConst, Invite, Dialogs, PrefController, Registry, Forms,
    XferManager, xData, XMLUtils, Jabber1, JabberID, Notify, InviteReceived;

const
    sNotifyAutoResponse = '%s query from: %s';
    sVersion = 'Version';
    sTime = 'Time';
    sLast = 'Last';
    sBrowse = 'Browse';
    sDisco = 'Disco';
    sExceptionMsg = 'An error has occurred.  An error log file will be saved to %s.';
    sConfirm = 'HTTP authentication';
    sConfirmationDialog = 'Accept authentication request from %s';

var
    _version: TVersionResponder;
    _time: TTimeResponder;
    _timeXep202: TTimeResponderXep202;
    _last: TLastResponder;
    _xdata: TFactoryResponder;
    _iqoob: TFactoryResponder;

    _receivedRoster: TFactoryResponder;
//    _affiliationChange: TFactoryResponder;

    _unhandled: TUnhandledResponder;
    _sistart: TFactoryResponder;
{$IFDEF DEPRICATED_PROTOCOL}
    _avatar: TAvatarResponder;
{$ENDIF}
    _confirmation: TConfirmationResponder;

{---------------------------------------}
function getNick(j: Widestring): Widestring;
var
    jid: TJabberID;
begin
    jid := TJabberID.Create(j);
    Result := DisplayName.getDisplayNameCache().getDisplayName(jid);
    jid.free();
end;

{---------------------------------------}
procedure initResponders();
begin
    assert(_version = nil);

    _version := TVersionResponder.Create(MainSession);
    _time := TTimeResponder.Create(MainSession);
    _timeXep202 := TTimeResponderXep202.Create(MainSession);
    _last := TLastResponder.Create(MainSession);
    _xdata := TFactoryResponder.Create(MainSession,
        '/pre/message/x[@xmlns="' + XMLNS_XDATA +'"]',
        showXData);
    _iqoob := TFactoryResponder.Create(MainSession,
        '/packet/iq[@type="set"]/query[@xmlns="' + XMLNS_IQOOB + '"]',
        FileReceive);

    _unhandled := TUnhandledResponder.Create(MainSession);
    _sistart := TFactoryResponder.Create(MainSession,
        '/packet/iq[@type="set"]/si[@xmlns="' + XMLNS_SI + '"]',
        SIStart);

    _receivedRoster := TFactoryResponder.Create(MainSession,
        '/packet/message/x[@xmlns="' + XMLNS_XROSTER + '"]',
        RosterRecv.ReceivedRoster);

{    _affiliationChange := TFactoryResponder.Create(MainSession,
        '/packet/message/x[@xmlns="' + XMLNS_MUCUSER + '"]/status[@code="101"]',
        Room.RoomAffiliationChange);
        }
    _confirmation := TConfirmationResponder.Create(MainSession);

    // Create some globally accessable responders.
{$IFDEF DEPRICATED_PROTOCOL}
    Exodus_Browse := TBrowseResponder.Create(MainSession);
    _avatar := TAvatarResponder.Create(MainSession);
{$ENDIF}

    Exodus_Disco_Items := TDiscoItemsResponder.Create(MainSession);
    Exodus_Disco_Info := TDiscoInfoResponder.Create(MainSession);

    // Register the dispatcher exception handler
    MainSession.Dispatcher.ExceptionHandler := ExHandleException;
end;

{---------------------------------------}
procedure ExHandleException(e_data: TWidestringlist; showdlg: boolean);
var
    s, i: integer;
    msg, ver, orig, fname, dir: String;
    excMessage : WideString;
    sig: TSignal;
    l: TSignalListener;
    {$ifdef TRACE_EXCEPTIONS}
    sl: TStringlist;
    {$endif}
begin


    // Put error logs in user dir, not on desktop anymore.
    dir := getUserDir();
   
    // Send the data to a file in dir
    orig := dir + '\Error log';
    fname := orig + '.txt';
    i := 1;
    while (FileExists(fname)) do begin
        fname := orig + '-' + IntToStr(i) + '.txt';
        i := i + 1;
    end;

    // Insert some more debugging info
    ver := '';
    WindowsVersion(ver);
    e_data.Insert(0, '---------------------------------------');
    e_data.Insert(0, 'Date, Time: ' + DateTimeToStr(Now()));
    e_data.Insert(0, PrefController.getAppInfo.ID + ' ver: ' + GetAppVersion());
    e_data.Insert(0, ver);

    // Dump current plugins
    e_data.Add('---------------------------------------');
    e_data.Add('Plug-ins:');
    for s := 0 to plugs.Count - 1 do begin
        e_data.Add(plugs[s]);
    end;
    e_data.Add('---------------------------------------');

    // Dump current dispatcher table:
    e_data.Add('Dispatcher Dump');
    with MainSession.Dispatcher do begin
        for s := 0 to Count - 1 do begin
            sig := TSignal(Objects[s]);
            e_data.Add('SIGNAL: ' + Strings[s] + ' of class: ' + sig.ClassName);
            e_data.Add('---------------------------------------');
            for i := 0 to sig.Count - 1 do begin
                l := TSignalListener(sig.Objects[i]);
                msg := 'LID: ' + IntToStr(l.cb_id) + ', ';
                msg := msg + sig.Strings[i] + ', ';
                msg := msg + l.classname + ', ';
                msg := msg + l.methodname;
                e_data.Add(msg);
            end;
        end;
    end;

    {$ifdef TRACE_EXCEPTIONS}
    e_data.Add('---------------------------------------');
    e_data.Add('Stack Trace:');
    e_data.Add('---------------------------------------');
    sl := TStringlist.Create();
    JclLastExceptStackListToStrings(sl, true, false, false);
    for i := 0 to sl.count - 1 do
        e_data.Add(sl[i]);
    sl.Free();
    e_data.Add('---------------------------------------');
    {$endif}

    // We got an exception during signal dispatching.
    //MessageDlgW(_(sExceptionMsg), mtError, [mbOK], 0);
    if (showdlg) then begin
        excMessage := WideFormat(_(sExceptionMsg), [fname]);
        MessageDlgW(excMessage, mtError, [mbOK], 0);
    end;
    e_data.SaveToFile(fname);
    e_data.Free();

    //Halt execution.
    Windows.ExitProcess(0);

end;

{---------------------------------------}
procedure cleanupResponders();
begin
    if (Exodus_Disco_Info = nil) then exit;

    FreeAndNil(Exodus_Disco_Info);
    FreeAndNil(Exodus_Disco_Items);
{$IFDEF DEPRICATED_PROTOCOL}
    FreeAndNil(Exodus_Browse);
{$ENDIF}
    FreeAndNil(_unhandled);
    FreeAndNil(_receivedRoster);
//    FreeAndNil(_affiliationChange);
    FreeAndNil(_iqoob);
    FreeAndNil(_xdata);
    FreeAndNil(_last);
    FreeAndNil(_time);
    FreeAndNil(_timeXep202);
    FreeAndNil(_version);
    FreeAndNil(_sistart);
end;

{---------------------------------------}
constructor TVersionResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_VERSION);
end;

{---------------------------------------}
procedure TVersionResponder.iqCallback(event: string; tag: TXMLTag);
var
    r: TXMLTag;
    app, win: string;
    f: TForm;
begin
    // respond w/ our version info
    {
    <iq from='rynok@jabber.com/Jabber Instant Messenger'
        to='pgmillard@jabber.org/workage'
        type='result'>
    <query xmlns='jabber:iq:version'>
        <name>Jabber Instant Messenger</name>
        <version>1.10.0.7</version>
        <os>NT 5.0</os>
    </query></iq>
    }
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;
    //direct notify at the message queue if showing, otherwise the main window
    f := nil;

    DoNotify(f, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sVersion),
                                          getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    win := '';
    WindowsVersion(win);
    app := GetAppVersion();

    r := TXMLTag.Create('iq');
    with r do begin
        setAttribute('id', tag.getAttribute('id'));
        setAttribute('type', 'result');
        setAttribute('to', tag.getAttribute('from'));
        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_VERSION);
            AddBasicTag('name', PrefController.getAppInfo.Caption);
            AddBasicTag('version', app);
            AddBasicTag('os', win);
        end;
    end;
    _session.sendTag(r);

end;

{---------------------------------------}
constructor TTimeResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_TIME);
end;

{---------------------------------------}
procedure TTimeResponder.iqCallback(event: string; tag: TXMLTag);
var
    r: TXMLTag;
    tzi: TTimeZoneInformation;
    utc: TDateTime;
    f: TForm;
begin
    // Respond to time queries
    {
    <iq from='smorris@jabber.com/Work' id='wj_4'
        to='pgmillard@jabber.org/workage'
        type='result'>
    <query xmlns='jabber:iq:time'>
        <utc>20011026T01:36:58</utc>
        <tz>Mountain Standard Time</tz>
        <display>10/25/2001 5:36:58 PM</display>
    </query></iq>
    }
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    f := nil;

    DoNotify(f, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sTime),
                                          getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    r := TXMLTag.Create('iq');

    utc := UTCNow();

    with r do begin
        setAttribute('to', tag.getAttribute('from'));
        setAttribute('id', tag.getAttribute('id'));
        setAttribute('type', 'result');

        with AddTag('query') do
        begin
            GetTimeZoneInformation(tzi);
            setAttribute('xmlns', XMLNS_TIME);
            AddBasicTag('utc', DateTimeToJabber(utc));
            AddBasicTag('tz', tzi.StandardName);
            AddBasicTag('display', DateTimeToStr(Now));
        end;
    end;

    _session.sendTag(r);
end;

{---------------------------------------}
constructor TTimeResponderXep202.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_TIME_202, 'time');
end;

{---------------------------------------}
procedure TTimeResponderXep202.iqCallback(event: string; tag: TXMLTag);
var
    r: TXMLTag;
    utc: TDateTime;
    f: TForm;
begin
    // Respond to time queries
    {
    <iq from='smorris@jabber.com/Work' id='wj_4'
        to='pgmillard@jabber.org/workage'
        type='result'>
    <time xmlns='urn:xmpp:time'>
        <utc>20011026T01:36:58Z</utc>
        <tzo>-6:00</tzo>
    </query></iq>
    }
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    f := nil;

    DoNotify(f, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sTime),
                                          getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    r := TXMLTag.Create('iq');

    utc := UTCNow();

    with r do begin
        setAttribute('to', tag.getAttribute('from'));
        setAttribute('id', tag.getAttribute('id'));
        setAttribute('type', 'result');

        with AddTag('time') do
        begin
            setAttribute('xmlns', XMLNS_TIME_202);
            AddBasicTag('utc', DateTimeToXEP82DateTime(utc, true));
            AddBasicTag('tzo', GetTimeZoneOffset());
        end;
    end;

    _session.sendTag(r);
end;

{---------------------------------------}
constructor TLastResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_LAST);
end;

{---------------------------------------}
procedure TLastResponder.iqCallback(event: string; tag: TXMLTag);
var
    idle: dword;
    r: TXMLTag;
    f: TForm;
begin
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    f := nil;
    DoNotify(f, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sLast),
                                          getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    // Respond to last queries
    r := TXMLTag.Create('iq');
    with r do begin
        setAttribute('to', tag.getAttribute('from'));
        setAttribute('id', tag.getAttribute('id'));
        setAttribute('type', 'result');

        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_LAST);
            idle := (GetTickCount() - frmExodus.getLastTick()) div 1000;
            setAttribute('seconds', IntToStr(idle));
        end;
    end;

    _session.sendTag(r);
end;

{---------------------------------------}
constructor TConfirmationResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, 'http://jabber.org/protocol/http-auth', 'confirm');
end;

{---------------------------------------}
procedure TConfirmationResponder.iqCallback(event: string; tag: TXMLTag);
var
    x, r: TXMLTag;
    url: WideString;
    f: TForm;
begin
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    f := nil;

    DoNotify(f, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sLast),
                getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    url := tag.QueryXPData('/iq/confirm@url');
    if MessageBoxW(0, PWideChar(WideFormat(_(sConfirmationDialog), [url])),
               PWideChar(_(sConfirm)),
               MB_ICONQUESTION or MB_OKCANCEL) = IDCANCEL then begin
        r := TXMLTag.Create('iq');
        r.setAttribute('to', tag.getAttribute('from'));
        r.setAttribute('id', tag.getAttribute('id'));
        r.setAttribute('type', 'error');
        x := r.AddTag('error');
        x.setAttribute('code', '401');
        x.setAttribute('type', 'auth');
        x.AddTag('not-authorized').setAttribute('xmlns', 'urn:ietf:params:xml:xmpp-stanzas');
        _session.SendTag(r);
    end
    else begin
        // return iq/result
        r := TXMLTag.Create('iq');
        r.setAttribute('to', tag.getAttribute('from'));
        r.setAttribute('id', tag.getAttribute('id'));
        r.setAttribute('type', 'result');
        _session.SendTag(r);
    end;

end;

{---------------------------------------}
constructor TDiscoItemsResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_DISCOITEMS);

    _items := TWidestringList.Create();
end;

{---------------------------------------}
destructor TDiscoItemsResponder.Destroy();
var
    i: integer;
begin
    for i := 0 to _items.Count - 1 do
        _items.Objects[i].Free();
    _items.Free();
    inherited;
end;

{---------------------------------------}
function TDiscoItemsResponder.addItem(Name, JabberID: Widestring): Widestring;
var
    di: TDiscoItem;
begin
    Result := IntToStr(_items.Count);
    di := TDiscoitem.Create();
    di.Name := Name;
    di.JID := JabberID;
    _items.AddObject(Result, di);
end;

{---------------------------------------}
procedure TDiscoItemsResponder.removeItem(id: Widestring);
var
    idx: integer;
begin
    idx := _items.IndexOf(ID);
    if ((idx >= 0) and (idx < _items.Count)) then begin
        _items.Objects[idx].Free();
        _items.Delete(idx);
    end;
end;

{---------------------------------------}
procedure TDiscoItemsResponder.iqCallback(event: string; tag:TXMLTag);
var
    di: TDiscoItem;
    i: integer;
    n, r, q: TXMLTag;
    f: TForm;
begin
    // return an empty result set.
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    r := TXMLTag.Create('iq');
    with r do begin
        setAttribute('to', tag.getAttribute('from'));
        setAttribute('id', tag.GetAttribute('id'));
        setAttribute('type', 'result');
        q := AddTag('query');
        q.setAttribute('xmlns', XMLNS_DISCOITEMS);

        for i := 0 to _items.Count - 1 do begin
            di := TDiscoItem(_items.Objects[i]);
            n := q.AddTag('entity');
            n.setAttribute('name', di.Name);
            n.setAttribute('jid', di.JID);
        end;
    end;
    
    f := nil;
    DoNotify(f, 'notify_autoresponse',
        WideFormat(_(sNotifyAutoResponse), [_(sDisco),
            getNick(tag.getAttribute('from'))]),
        RosterTreeImages.Find('info'));

    _session.SendTag(r);
end;

{---------------------------------------}
constructor TDiscoInfoResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_DISCOINFO);
end;
{---------------------------------------}
procedure TDiscoInfoResponder.iqCallback(event: string; tag:TXMLTag);

    procedure addFeature(qtag: TXMLTag; stype: WideString);
    begin
        with qtag.AddTag('feature') do
            setAttribute('var', stype);
    end;

var
    r, q: TXMLTag;
    node: WideString;
    error: boolean;
    f: TForm;
begin
    // return info results
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    q := tag.GetFirstTag('query');
    if (q = nil) then exit;

    error := false;

    // The disco node should either not be present: "give me all of your features"
    // Be URI#version: "give me the base features for this version" or
    // Be URI#ext: "give me the features for this extension"
    // other nodes, from plugins for example, MUST register their own callback
    node := q.GetAttribute('node');
    if (node <> '') then begin
        error := (node <> jSelfCaps.Node);
    end;

    r := TXMLTag.Create('iq');
    r.setAttribute('to', tag.getAttribute('from'));
    r.setAttribute('id', tag.GetAttribute('id'));
    q := r.AddTag('query');
    q.setAttribute('xmlns', XMLNS_DISCOINFO);
    if (node <> '') then
        q.setAttribute('node', node);

    if (error) then begin
        r.setAttribute('type', 'error');
        with r.AddTag('error') do begin
            setAttribute('code', '404');
            setAttribute('type', 'cancel');
            AddTagNS('item-not-found', XMLNS_STREAMERR);
        end;
        _session.SendTag(r);
        exit;
    end;

    r.setAttribute('type', 'result');

    if (node = '') then begin
        with q.AddTag('identity') do begin
            setAttribute('category', 'user');
            setAttribute('type', 'client');
            setAttribute('name', _session.Username);
        end;
    end;
    jSelfCaps.AddToDisco(q);

    f := nil;
    DoNotify(f, 'notify_autoresponse',
        WideFormat(_(sNotifyAutoResponse), [_(sDisco),
            getNick(tag.getAttribute('from'))]),
        RosterTreeImages.Find('info'));

    _session.SendTag(r);
end;

{---------------------------------------}
constructor TFactoryResponder.Create(Session: TJabberSession; xpath: string; factory: TResponderFactory);
begin
    _factory := factory;
    _session := Session;
    _cb := _session.RegisterCallback(respCallback, xpath);
end;

{---------------------------------------}
destructor TFactoryResponder.Destroy();
begin
    _session.UnRegisterCallback(_cb);
end;

{---------------------------------------}
procedure TFactoryResponder.respCallback(event: string; tag: TXMLTag);
begin
    _factory(tag);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TUnhandledResponder.Create(Session: TJabberSession);
begin
    //
    _session := Session;
    _cbid := _session.RegisterCallback(self.Callback, '/unhandled');
end;

{---------------------------------------}
procedure TUnhandledResponder.callback(event: string; tag: TXMLTag);
var
    t, f: Widestring;
    b, e: TXMLTag;
begin
    t := tag.GetAttribute('type');
    if ((tag.Name = 'iq') and ((t = 'get') or (t = 'set'))) then begin
        b := TXMLTag.Create(tag);
        f := b.GetAttribute('from');
        b.setAttribute('from', b.getAttribute('to'));
        b.setAttribute('to', f);
        b.setAttribute('type', 'error');
        e := b.AddBasicTag('error', 'Not Implemented');
        e.setAttribute('code', '501');
        _session.SendTag(b);
    end
end;

{---------------------------------------}
{$IFDEF DEPRICATED_PROTOCOL}
constructor TAvatarResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, 'jabber:iq:avatar');
end;

{---------------------------------------}
procedure TAvatarResponder.iqCallback(event: string; tag: TXMLTag);
var
    x, r: TXMLTag;
    f: TForm;
begin
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    if (_session.Profile.Avatar = '') then begin
        r := TXMLTag.Create('iq');
        r.setAttribute('to', tag.getAttribute('from'));
        r.setAttribute('id', tag.getAttribute('id'));
        r.setAttribute('type', 'error');
        x := r.AddTag('error');
        x.setAttribute('code', '404');
        x.setAttribute('type', 'cancel');
        x.AddTag('item-not-found');
        _session.SendTag(r);
    end
    else begin
        f := nil;

        DoNotify(f, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sLast),
                getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

        // Respond to last queries
        r := TXMLTag.Create('iq');
        with r do begin
            setAttribute('to', tag.getAttribute('from'));
            setAttribute('id', tag.getAttribute('id'));
            setAttribute('type', 'result');

            with AddTag('query') do begin
                setAttribute('xmlns', 'jabber:iq:avatar');
                x := AddTag('data');
                x.setAttribute('mimetype', _session.Profile.AvatarMime);
                x.AddCData(_session.Profile.Avatar);
            end;
        end;
        _session.sendTag(r);
    end;
end;
{$ENDIF}

{---------------------------------------}
{$IFDEF DEPRICATED_PROTOCOL}
constructor TBrowseResponder.Create(Session: TJabberSession);
begin
    inherited Create(Session, XMLNS_BROWSE);
    Namespaces := TWidestringlist.Create();
end;

{---------------------------------------}
destructor TBrowseResponder.Destroy();
begin
    Namespaces.Free();
    inherited;
end;

{---------------------------------------}
procedure TBrowseResponder.iqCallback(event: string; tag: TXMLTag);
var
    i: integer;
    r: TXMLTag;
    f: TForm;
begin
    if (_session.IsBlocked(tag.getAttribute('from'))) then exit;

    f := nil;
    DoNotify(f, 'notify_autoresponse',
             WideFormat(_(sNotifyAutoResponse), [_(sBrowse),
                                          getNick(tag.getAttribute('from'))]),
             RosterTreeImages.Find('info'));

    r := TXMLTag.Create('iq');
    with r do begin
        setAttribute('to', tag.getAttribute('from'));
        setAttribute('id', tag.GetAttribute('id'));
        setAttribute('type', 'result');

        with AddTag('user') do begin
            setAttribute('xmlns', XMLNS_BROWSE);
            setAttribute('type', 'client');
            setAttribute('jid', _session.Profile.getJabberID.full());
            setAttribute('name', _session.Username);

            AddBasicTag('ns', XMLNS_AGENTS);

            AddBasicTag('ns', XMLNS_IQOOB);
            AddBasicTag('ns', XMLNS_BROWSE);
            AddBasicTag('ns', XMLNS_TIME);
            AddBasicTag('ns', XMLNS_VERSION);
            AddBasicTag('ns', XMLNS_LAST);
            AddBasicTag('ns', XMLNS_DISCOITEMS);
            AddBasicTag('ns', XMLNS_DISCOINFO);

            AddBasicTag('ns', XMLNS_BM);
            AddBasicTag('ns', XMLNS_XDATA);
            AddBasicTag('ns', XMLNS_XCONFERENCE);
            AddBasicTag('ns', XMLNS_XEVENT);

            AddBasicTag('ns', XMLNS_MUC);
            AddBasicTag('ns', XMLNS_MUCUSER);
            AddBasicTag('ns', XMLNS_MUCOWNER);

            for i := 0 to Namespaces.Count - 1 do
                AddBasicTag('ns', Namespaces[i]);
        end;
    end;
    _session.SendTag(r);
end;
{$ENDIF}

initialization
{$IFDEF DEPRICATED_PROTOCOL}
    Exodus_Browse := nil;
{$ENDIF}
    Exodus_Disco_Items := nil;
    Exodus_Disco_Info := nil;

    _version := nil;
    _time := nil;
    _timeXep202 := nil;
    _last := nil;
    _xdata := nil;
    _iqoob := nil;
end.
