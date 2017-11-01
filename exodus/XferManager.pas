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
unit XferManager;


{$ifdef VER150}
    {$define INDY9}
{$endif}

interface

uses
    Unicode, XMLTag, SyncObjs, ShellAPI,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Dockable, ExtCtrls, IdCustomHTTPServer, IdHTTPServer, IdSocks,
    IdTCPServer, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
    IdHTTP, IdServerIOHandler, IdServerIOHandlerSocket, StdCtrls,
    TntStdCtrls, Buttons, TntExtCtrls, TntDialogs, ComCtrls, ToolWin, ExFrame,
    ExActions, Exodus_TLB;

const
    WM_CLOSE_FRAME = WM_USER + 6005;
    WM_CLEANUP_FRAME = WM_USER + 6006;

type

  TFileXferMode = (send_auto, send_socks, send_proxy, send_oob, send_dav, send_si, recv_oob, recv_si);

  TFileXferPkg = class
    mode: TFileXferMode;
    recipDisplay: Widestring;
    pathname: Widestring;
    url: string;
    desc: Widestring;
    busy: boolean;
    oob_thread: TIdPeerThread;
    frame: TExFrame;
    size: longint;
    packet: TXMLTag;
    stream_host: Widestring;
    hash: string;

    procedure setRecip(r: Widestring);
    function  getRecip(): Widestring;

    private
        recipient: Widestring;

    published
    property recip: Widestring read getRecip write setRecip;
  end;

    THostPortPair = class
        host: string;
        Port: integer;
        jid: Widestring;
    end;

    TStreamPkg = class
        hash: string;
        stream: TFileStream;
        sid: Widestring;
        frame: TExFrame;
        conn: TIdTCPServerConnection;
        thread: TIdPeerThread;
    end;


  TfrmXferManager = class(TfrmDockable)
    httpServer: TIdHTTPServer;
    box: TScrollBox;
    tcpServer: TIdTCPServer;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    pnlCaption: TTntPanel;
    procedure FormCreate(Sender: TObject);
    procedure httpServerCommandGet(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure httpServerDisconnect(AThread: TIdPeerThread);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tcpServerConnect(AThread: TIdPeerThread);
    procedure tcpServerExecute(AThread: TIdPeerThread);
    procedure tcpServerDisconnect(AThread: TIdPeerThread);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OpenDialog1CanClose(Sender: TObject; var CanClose: Boolean);

  protected
    procedure WMCloseFrame(var msg: TMessage); message WM_CLOSE_FRAME;

  published
    procedure SessionCallback(event: string; tag: TXMLTag);

    procedure ClientWork(Sender: TObject;
        AWorkMode: TWorkMode; const AWorkCount: Integer);

  private
    { Private declarations }
    _pnl_list: TWidestringList;
    _current: integer;
    _cb: integer;
    _stream_list: TStringlist;
    _slock: TCriticalSection;

  public
    { Public declarations }
    procedure SendFile(pkg: TFileXferPkg);
    procedure RecvFile(pkg: TFileXferPkg);

    function getFrameIndex(frame: TExFrame): integer;
    procedure killFrame(frame: TExFrame);
    procedure ServeStream(spkg: TStreamPkg);
    procedure UnServeStream(hash: string);
  end;

  TPeerToPeerFTAction = class(TExBaseAction)
  private
    constructor Create;
  public
    procedure execute(const items: IExodusItemList); override;
  end;

var
  frmXferManager: TfrmXferManager;
  peerFTAction: TPeerToPeerFTAction;

function getXferManager(): TfrmXferManager;

procedure FileSend(tojid: string; fn: string = '');
procedure FileReceive(tag: TXMLTag);
procedure SIStart(tag: TXMLTag);
procedure RegisterActions();

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
uses
    RosterImages,
    DisplayName,
    JabberUtils, ExUtils,  Jabber1, JabberConst, JabberID, Presence, InputPassword,
    GnuGetText, XMLUtils, Notify, RecvStatus, SendStatus, Session,
    ExActionCtrl;

const
    sXferNewPort = 'Your new file transfer port will not take affect until all current trasfers are stopped. Stop existing transfers?';
    sXferRecv = '%s';
    sXferURL = 'File transfer URL: ';
    sXferDesc = 'File Description: ';
    sXferOnline = 'The Contact must be online before you can send a file.';
    sSend = 'Send';
    sOpen = 'Open';
    sClose = 'Close';
    sTo = 'To:     ';

    sXferSending = 'Sending file...';
    sXferRecvDisconnected = 'Receiver disconnected.';
    sXferTryingClose = 'Trying to close.';
    sXferDefaultDesc = 'Sending you a file.';

// privates
procedure StartFileSend(jid: Widestring; filename: Widestring); forward;
procedure StartFileReceive(from, url, desc: string); forward;

var
    xfer_lock: TCriticalSection;

{---------------------------------------}
procedure FileSend(tojid: string; fn: string = '');
var
    tmp_id: TJabberID;
    tmps: string;
    pri: TJabberPres;
    f: integer;
    jid: Widestring;
begin
    // Make sure the contact is online
    tmp_id := TJabberID.Create(tojid);
    if (tmp_id.resource = '') then begin
        pri := MainSession.ppdb.FindPres(tmp_id.jid, '');
        if (pri = nil) then begin
            MessageDlgW(_(sXferOnline), mtError, [mbOK], 0);
            exit;
        end;
        tmps := pri.fromJID.full;
    end
    else
        tmps := tojid;
    jid := tmps;

    if (fn <> '') then
        StartFileSend(jid, fn)
    else begin
        xfer_lock.Acquire();
        if not getXferManager().OpenDialog1.Execute then begin
            if (getXferManager().box.ControlCount = 0) then
                getXferManager().Close();
            xfer_lock.Release();
            exit;
        end;
        xfer_lock.Release();
        for f := 0 to getXferManager().OpenDialog1.Files.Count - 1 do
            StartFileSend(jid, getXferManager().OpenDialog1.Files[f]);
    end;
end;

{---------------------------------------}
procedure StartFileSend(jid: Widestring; filename: Widestring);
var
    url, ip: string;
    dp, p: integer;
    desc, dav_path: Widestring;
    pkg: TFileXferPkg;
begin
    // Create a wrapper and call sendFile();
    pkg := TFileXferPkg.Create();
    pkg.recip := jid;
    pkg.pathname := filename;
    pkg.desc := desc;

    // get xfer prefs, and spin up URL
    with MainSession.Prefs do begin
        if (getBool('xfer_webdav')) then begin
            dp := MainSession.Prefs.getInt('xfer_davport');
            ip := getString('xfer_davhost');
            dav_path := getString('xfer_davpath');
            if (dp > 0) then
                url := ip + ':' + IntToStr(dp) + dav_path + '/' + ExtractFilename(pkg.pathname)
            else
                url := ip + dav_path + '/' + ExtractFilename(pkg.pathname);
        end
        else begin
            ip := getString('xfer_ip');
            p := getInt('xfer_port');

            if (ip = '') then ip := MainSession.Stream.LocalIP;
            url := 'http://' + ip + ':' + IntToStr(p) + '/' + ExtractFileName(pkg.pathname);
        end;

        if (getBool('xfer_proxy')) then begin
            pkg.stream_host := getString('xfer_prefproxy');
        end
        else begin
            pkg.stream_host := '';
        end;
    end;

    // Get the description
    pkg.mode := send_auto;
    pkg.url := url;

    xfer_lock.Acquire();
    getXferManager().sendFile(pkg);
    xfer_lock.Release();
end;

{---------------------------------------}
procedure FileReceive(tag: TXMLTag);
var
    qTag, tmp_tag: TXMLTag;
    from, url, desc: string;
begin
    // Callback for receiving file transfers
    from := tag.GetAttribute('from');
    qTag := tag.getFirstTag('query');
    tmp_tag := qtag.GetFirstTag('url');
    url := tmp_tag.Data;

    // if this isn't an http:// url, then ignore.
    if (Pos('http:', url) <> 1) then exit;

    tmp_tag := qTag.GetFirstTag('desc');
    if (tmp_tag <> nil) then
        desc := tmp_tag.Data
    else
        desc := '';
    StartFileReceive(from, url, desc);
end;

{---------------------------------------}
procedure StartFileReceive(from, url, desc: string);
var
    pkg: TFileXferPkg;
    tmps: Widestring;
    tmp_jid: TJabberID;
begin
    tmp_jid := TJabberID.Create(from);

    pkg := TFileXferPkg.Create();
    pkg.mode := recv_oob;
    pkg.recip := from;
    pkg.url := url;
    pkg.pathname := ExtractFilename(URLToFileName(url));
    pkg.desc := desc;
    pkg.mode := recv_oob;
    tmps := WideFormat(_(sXferRecv), [pkg.recip]);
    tmp_jid.Free();
    xfer_lock.Acquire();
    getXferManager().RecvFile(pkg);
    xfer_lock.Release();
    DoNotify(getXferManager(), 'notify_oob', 'File from ' + tmps,
        RosterTreeImages.Find('service'));
end;

{---------------------------------------}
procedure SIStart(tag: TXMLTag);
var
    tmps, from: Widestring;
    v, f, fld, e, err, si: TXMLTag;
    pkg: TFileXferPkg;
    xp: Widestring;
    opts: TXMLTagList;
    invalid_profile, s5b: boolean;
    i: integer;
begin
    // we only want files.. not other streams
    // make sure it's a file, and they are offering socks5 bytestreams
    from := tag.GetAttribute('from');
    si := tag.GetFirstTag('si');
    f := tag.QueryXPTag('/iq/si/file[@xmlns="' + XMLNS_FTPROFILE + '"]');
    xp := '/iq/si/feature[@xmlns="' + XMLNS_FEATNEG + '"]/x[@xmlns="' + XMLNS_XDATA + '"]/field[@var="stream-method"]';
    fld := tag.QueryXPTag(xp);
    s5b := false;
    if (fld <> nil) then begin
        opts := fld.QueryTags('option');
        for i := 0 to opts.Count - 1 do begin
            v := opts[i].GetFirstTag('value');
            if (v <> nil) then begin
                s5b := (v.Data = XMLNS_BYTESTREAMS);
                if (s5b) then break;
            end;
        end;
    end;

    if (si.GetAttribute('profile') <> XMLNS_FTPROFILE) then
        invalid_profile := true
    else
        invalid_profile := false;

    if ((s5b = false) or (invalid_profile)) then begin

        e := TXMLTag.Create('iq');
        e.setAttribute('type', 'error');
        e.setAttribute('to', tag.GetAttribute('from'));
        e.setAttribute('id', tag.GetAttribute('id'));

        err := e.AddTag('error');
        err.setAttribute('code', '400');
        err.setAttribute('type', 'cancel');

        err.AddTagNS('bad-request', XMLNS_STREAMERR);

        if (invalid_profile) then
            err.AddTagNS('bad-profile', XMLNS_SI);
        if (s5b = false) then
            err.AddTagNS('no-valid-stream', XMLNS_SI);

        
        MainSession.SendTag(e);
        exit;
    end;

    pkg := TFileXferPkg.Create();
    pkg.mode := recv_si;
    pkg.recip := tag.getAttribute('from');
    pkg.pathname := f.GetAttribute('name');
    pkg.size := SafeInt(f.GetAttribute('size'));
    pkg.packet := TXMLTag.Create(tag);
    pkg.desc := '';
    pkg.hash := f.GetAttribute('hash');
    xfer_lock.Acquire();
    getXferManager().RecvFile(pkg);
    xfer_lock.Release();

    tmps := WideFormat(_(sXferRecv), [pkg.recipDisplay]);
    DoNotify(getXferManager(), 'notify_oob', 'File from ' + tmps,
        RosterTreeImages.Find('service'));
end;

{---------------------------------------}
function getXferManager(): TfrmXferManager;
begin
    xfer_lock.Acquire();

    if (frmXferManager = nil) then
        frmXferManager := TfrmXferManager.Create(Application);

    Result := frmXferManager;
    Result.ShowDefault();
    xfer_lock.Release();
end;

{---------------------------------------}
procedure TfrmXferManager.RecvFile(pkg: TFileXferPkg);
var
    f: Widestring;
    fRecv: TfRecvStatus;
begin
    f := ExtractFilename(pkg.pathname);
    pkg.busy := false;

    fRecv := TfRecvStatus.Create(Self);
    fRecv.Parent := Self.box;
    fRecv.Align := alTop;
    fRecv.Visible := true;
    fRecv.Name := 'recv' + IntToStr(box.ControlCount);
    pkg.frame := TExFrame(fRecv);

    _pnl_list.AddObject('RECV:' + pkg.pathname, pkg);

    fRecv.setup(pkg);
end;

{---------------------------------------}
procedure TfrmXferManager.SendFile(pkg: TFileXferPkg);
var
    f: Widestring;
    fSend: TfSendStatus;
begin
    // Create a new panel, and do the right thing.
    f := ExtractFilename(pkg.pathname);
    pkg.busy := false;
    _pnl_list.AddObject(f, pkg);

    fSend := TfSendStatus.Create(Self);
    fSend.Parent := Self.box;
    fSend.Align := alTop;
    fSend.Visible := true;
    fSend.Name := 'send_' + IntToStr(box.ControlCount);

    fSend.Setup(pkg);
    pkg.Frame := TExFrame(fSend);
    fSend.SendStart();
end;

{---------------------------------------}
procedure TfrmXferManager.FormCreate(Sender: TObject);
begin
  inherited;
    _pnl_list := TWidestringList.Create();
    _stream_list := TStringlist.Create();
    _slock := TCriticalSection.Create();

    // setup http server
    with httpServer do begin
        Active := false;
        AutoStartSession := true;
        DefaultPort := MainSession.Prefs.getInt('xfer_port');
        _current := 0;
    end;
    _cb := MainSession.RegisterCallback(SessionCallback, '/session');

    pnlCaption.Font.Color := clHighlightText;
    pnlCaption.Font.Size := 10;
    pnlCaption.Font.Style := [fsBold];
    Self.ImageIndex := -1;
    _windowType := 'xfer_manager';
end;

{---------------------------------------}
procedure TfrmXferManager.httpServerCommandGet(AThread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
    f: string;
    idx: integer;
    p: TFileXferPkg;
begin
  inherited;
    // send the file.
    f := ARequestInfo.Document;
    if (f[1] = '/') then Delete(f, 1, 1);
    idx := _pnl_list.IndexOf(f);

    if (idx < 0) then with AResponseInfo do begin
        ResponseNo := 404;
        CloseConnection := true;
    end
    else begin
        p := TFileXferPkg(_pnl_list.Objects[idx]);
        p.oob_thread := AThread;
        inc(_current);
        httpServer.ServeFile(AThread, AResponseInfo, p.pathname);
    end;
end;

{---------------------------------------}
procedure TfrmXferManager.SessionCallback(event: string; tag: TXMLTag);
var
    p: integer;
begin
    // check for new xfer prefs
    if (event = '/session/prefs') then begin
        p := MainSession.Prefs.getInt('xfer_port');
        if (p <> httpServer.DefaultPort) then begin

            // check to see if we should disconnect current xfers
            if ((httpServer.Active) or (_current > 0)) then
                if (MessageDlgW(_(sXferNewPort), mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
                    httpServer.Active := false;
                    _current := 0;
                end;

            // change it.
            httpServer.DefaultPort := p;
        end;
    end
end;

{---------------------------------------}
procedure TfrmXferManager.WMCloseFrame(var msg: TMessage);
var
    ps: TfSendStatus;
    pr: TfRecvStatus;

    idx: integer;
    p: TFileXferPkg;
begin
    // Close a specific frame.
    idx := msg.WParam;
    if (idx < 0) then exit;
    if (idx >= _pnl_list.Count) then exit;

    p := TFileXferPkg(_pnl_list.Objects[idx]);

    if (p.frame is TfSendStatus) then begin
        ps := TfSendStatus(p.frame);
        p.frame := nil;
        ps.Visible := false;
        FreeAndNil(ps);
    end
    else if (p.frame is TfRecvStatus) then begin
        pr := TfRecvStatus(p.frame);
        p.frame := nil;
        pr.Visible := false;
        FreeAndNil(pr);
    end;
    
    p.Free();
    _pnl_list.Delete(idx);

    if (box.ControlCount <= 0) then begin
        httpServer.Active := false;
        tcpServer.Active := false;
        Self.Close();
    end;
end;


{---------------------------------------}
procedure TfrmXferManager.httpServerDisconnect(AThread: TIdPeerThread);
var
    i: integer;
    p: TFileXferPkg;
begin
  inherited;
    // Find this thread and close the frame
    for i := 0 to _pnl_list.Count - 1  do begin
        p := TFileXferPkg(_pnl_list.Objects[i]);
        if (p.oob_thread = AThread) then begin
            PostMessage(Self.Handle, WM_CLOSE_FRAME, i, 0);
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmXferManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    inherited;
    httpServer.Active := false;
    tcpServer.Active := false;
    frmXferManager := nil;
    
    Action := caFree;
end;

{---------------------------------------}
function TfrmXferManager.getFrameIndex(frame: TExFrame): integer;
var
    i: integer;
    p: TFileXferPkg;
begin
    //
    Result := -1;
    for i := 0 to _pnl_list.Count - 1  do begin
        p := TFileXferPkg(_pnl_list.Objects[i]);
        if (p.frame = frame) then begin
            Result := i;
            exit;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmXferManager.killFrame(frame: TExFrame);
var
    i: integer;
begin
    i := getFrameIndex(frame);
    if (i = -1) then exit;
    PostMessage(Self.Handle, WM_CLOSE_FRAME, i, 0);
end;


{---------------------------------------}
procedure TfrmXferManager.tcpServerConnect(AThread: TIdPeerThread);
begin
  inherited;
    // someone connected to us..
    AThread.Connection.OnWork := Self.ClientWork;
end;

{---------------------------------------}
procedure TfrmXferManager.tcpServerExecute(AThread: TIdPeerThread);
var
    i, idx: integer;
    cmd, atype, ver, num_meths: char;
    meths: array[1..255] of char;
    auth_ok: boolean;
    dst_addr: PChar;
    dst_len: Cardinal;
    hash: String;
    spkg: TStreamPkg;
    buff: array[1..2] of char;
    resp_len: Cardinal;
    resp: PChar;
    hash_len: Byte;
begin
  inherited;
    // we need to do something
    ver := AThread.Connection.ReadChar;
    if (Ord(ver) <> $05) then begin
        // not socks5
        AThread.Connection.Disconnect();
        exit;
    end;

    num_meths := AThread.Connection.ReadChar;

    // check methods
    auth_ok := false;
    AThread.Connection.ReadBuffer(meths, Ord(num_meths));
    for i := 1 to Ord(num_meths) do begin
        if (Ord(meths[i]) = $00) then begin
            auth_ok := true;
            break;
        end;
    end;

    buff[1] := Chr($05);
    if (not auth_ok) then begin
        buff[2] := Chr($FF);
        AThread.Connection.WriteBuffer(buff, 2);
        AThread.Connection.Disconnect();
        exit;
    end
    else begin
        buff[2] := Chr($00);
        AThread.Connection.WriteBuffer(buff, 2);
    end;

    // get the command
    ver := AThread.Connection.ReadChar();
    if (Ord(ver) <> $05) then begin
        AThread.Connection.Disconnect();
        exit;
    end;

    cmd := AThread.Connection.ReadChar();
    if (Ord(cmd) <> $01) then begin
        AThread.Connection.Disconnect();
        exit;
    end;

    // Read the RSV byte
    AThread.Connection.ReadChar();

    atype := AThread.Connection.ReadChar();

    if (Ord(atype) = $01) then begin
        // ipv4 addr
        dst_addr := StrAlloc(4);
        FillChar(dst_addr^, 4, 0);
        AThread.Connection.ReadBuffer(dst_addr^, 4);
    end
    else if (Ord(atype) = $03) then begin
        // domain name
        dst_len := Ord(AThread.Connection.ReadChar());
        dst_addr := StrAlloc(dst_len + 1);
        FillChar(dst_addr^, dst_len + 1, 0);
        AThread.Connection.ReadBuffer(dst_addr^, dst_len);
    end
    else begin
        AThread.Connection.Disconnect();
        exit;
    end;

    // We don't care about this value, but we have to read it
    AThread.Connection.ReadSmallInt();

    hash := String(dst_addr);

    _slock.Acquire();
    idx := _stream_list.IndexOf(hash);
    if (idx = -1) then begin
        _slock.Release();
        AThread.Connection.Disconnect();
        exit;
    end;
    spkg := TStreamPkg(_stream_list.Objects[idx]);
    AThread.Connection.Tag := spkg.frame.Handle;
    _stream_list.Delete(idx);
    _slock.Release();
    PostMessage(spkg.frame.Handle, WM_SEND_STATUS, 1, 0);
    PostMessage(spkg.frame.Handle, WM_SEND_START, spkg.stream.Size, 0);

    // Reply back
    hash_len := Length(hash);

    // Note the 2 end bytes are for a port, which we memset to 0x00.
    resp_len := 1 + 1 + 1 + 1 + 1 + hash_len + 2;
    resp := StrAlloc(resp_len + 1);
    FillChar(resp^, resp_len + 1, 0);
    resp[0] := Chr($05);
    resp[1] := Chr($00);
    resp[2] := Chr($00);

    // address information
    resp[3] := Chr($03);
    resp[4] := Chr(Length(hash));
    StrPCopy(@resp[5], PChar(hash));
    AThread.Connection.WriteBuffer(resp^, resp_len, true);

    // Write the file.
    AThread.Connection.WriteStream(spkg.stream, true, false);
    FreeAndNil(spkg.stream);
    xfer_lock.Acquire();
    killFrame(spkg.frame);
    xfer_lock.Release();

    AThread.Connection.Disconnect();
end;


{---------------------------------------}
procedure TfrmXferManager.ServeStream(spkg: TStreamPkg);
begin
    _slock.Acquire();
    _stream_list.AddObject(spkg.hash, spkg);
    _slock.Release();
    if (not tcpServer.Active) then
        tcpServer.Active := true;
end;

{---------------------------------------}
procedure TfrmXferManager.UnServeStream(hash: string);
var
    i: integer;
begin
    _slock.Acquire();
    i := _stream_list.IndexOf(hash);
    if (i >= 0) then begin
        TStreamPkg(_stream_list.Objects[i]).Free();
        _stream_list.Delete(i);
    end;
    _slock.Release();

    if ((_stream_list.Count = 0) and (tcpServer.Active)) then
        tcpServer.Active := false;
end;

procedure TfrmXferManager.ClientWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
    // Update the progress meter
    PostMessage(TIdTCPServerConnection(Sender).Tag, WM_SEND_UPDATE,
        AWorkCount, 0);
end;

{---------------------------------------}
procedure TfrmXferManager.tcpServerDisconnect(AThread: TIdPeerThread);
begin
  inherited;
    // remove this connection from the list
end;

{---------------------------------------}
procedure TfrmXferManager.FormDestroy(Sender: TObject);
begin
  inherited;
    // unreg callback
    if ((_cb <> -1) and (MainSession <> nil)) then begin
        MainSession.UnRegisterCallback(_cb);
        _cb := -1;
    end;
end;

{---------------------------------------}
procedure TfrmXferManager.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
    o: TObject;
    i: integer;
begin
    // Kill each frame
    for i := 0 to box.ControlCount - 1 do begin
        o := TObject(box.Controls[i]);
        if (o is TfSendStatus) then
            TfSendStatus(o).kill()
        else if (o is TfRecvStatus) then
            TfRecvStatus(o).kill();
    end;

    // only close if there are no frames left.
    CanClose := (box.ControlCount = 0);
    if (CanClose) then
        inherited FormCloseQuery(Sender, CanClose);
end;

{---------------------------------------}
procedure TfrmXferManager.OpenDialog1CanClose(Sender: TObject;
  var CanClose: Boolean);
var
    ext: string;
begin
  inherited;
    if (OpenDialog1.Files.Count = 1) then begin
        // check .lnk files..
        ext := lowercase(ExtractFileExt(OpenDialog1.FileName));
        if (ext <> '.lnk') then exit;


    end;
end;

procedure TFileXferPkg.setRecip(r: Widestring);
var
    jid: TJabberID;
begin
    recipient := r;
    jid := TJabberID.Create(r);
    recipDisplay := DisplayName.getDisplayNameCache().getDisplayNameAndBareJID(jid);
    jid.Free();
end;
function  TFileXferPkg.getRecip(): Widestring;
begin
    Result := recipient;
end;


{
}
constructor TPeerToPeerFTAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-090-peerft');

    Set_Caption(_('Peer to Peer File Transfer...'));
    Set_Enabled(false);
end;

procedure TPeerToPeerFTAction.execute(const items: IExodusItemList);
var
    i: integer;
begin
    for i := 0 to items.Count - 1 do
    begin
        FileSend(items.Item[i].UID);
    end;
end;

procedure RegisterActions();
var
    actctrl: IExodusActionController;
    act: IExodusAction;
begin
    actctrl := GetActionController();
    act := peerFTAction as IExodusAction;

    actCtrl.registerAction('contact', act);
    actctrl.addEnableFilter('contact', act.Name, 'selection=single');
    actctrl.addEnableFilter('contact', act.Name, 'Network=xmpp');
    actctrl.addDisableFilter('contact', act.Name, 'show=offline');
end;



initialization
    xfer_lock := TCriticalSection.Create();
    frmXferManager := nil;

    peerFTAction := TPeerToPeerFTAction.Create();
    RegisterActions();

finalization
    FreeAndNil(xfer_lock);

end.
