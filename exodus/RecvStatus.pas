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
unit RecvStatus;



{$ifdef VER150}
    {$define INDY9}
{$endif}

interface

uses
    Presence, 
    Unicode, SyncObjs, XferManager, ShellApi, Contnrs, XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ComCtrls, TntStdCtrls, ExtCtrls, IdSocks,
    IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
    IdIOHandler, IdIOHandlerSocket, ExFrame;

const
    WM_RECV_DONE = WM_USER + 6001;
    WM_RECV_SICONN = WM_USER + 6010;
    WM_RECV_SIDISCONN = WM_USER + 6011;
    WM_RECV_NEXT = WM_USER + 6012;

type

    TFileRecvThread = class;

    TFileRecvState = (recv_invalid, recv_recv, recv_done,
        recv_si_offer, recv_si_wait, recv_si_stream, recv_si_cancel);

    TfRecvStatus = class(TExFrame)
        Panel3: TPanel;
        lblFile: TTntLabel;
        lblFrom: TTntLabel;
        Panel2: TPanel;
        lblStatus: TTntLabel;
        Bar1: TProgressBar;
        Panel1: TPanel;
        btnRecv: TButton;
        httpClient: TIdHTTP;
        tcpClient: TIdTCPClient;
        SaveDialog1: TSaveDialog;
        btnCancel: TButton;
        SocksHandler: TIdIOHandlerSocket;
        IdSocksInfo1: TIdSocksInfo;
        Bevel3: TBevel;
        Bevel2: TBevel;
        procedure btnRecvClick(Sender: TObject);
        procedure btnCancelClick(Sender: TObject);
    private
        { Private declarations }
        _thread: TFileRecvThread;
        _state: TFileRecvState;
        _filename: string;
        _pkg: TFileXferPkg;
        _sid: Widestring;
        _hosts: TQueue;
        _cur: integer;
        _pres: integer;
        _stream: TFileStream;
        _size: longint;

        procedure attemptSIConnection();
        procedure SendError(code, condition: string);

    protected
        procedure WMRecvDone(var msg: TMessage); message WM_RECV_DONE;
        procedure WMRecvConn(var msg: TMessage); message WM_RECV_SICONN;
        procedure WMRecvDisconn(var msg: TMessage); message WM_RECV_SIDISCONN;
        procedure WMRecvNext(var msg: TMessage); message WM_RECV_NEXT;

    published
       procedure BytestreamCallback(event: string; tag: TXMLTag);
       procedure PresCallback(event: string; tag: TXMLTag; pres: TJabberPres);

    public
        { Public declarations }
        procedure setup(pkg: TFileXferPkg);
        procedure Kill();
    end;

    TFileRecvThread = class(TThread)
    private
        _http: TIdHTTP;
        _client: TIdTCPClient;
        _stream: TFileStream;
        _filename: string;
        _form: TfRecvStatus;
        _pos_max: longint;
        _pos: longint;
        _new_txt: TWidestringlist;
        _lock: TCriticalSection;
        _url: string;
        _method: string;
        _size: longint;

        procedure Update();
        procedure setHttp(value: TIdHttp);
        procedure setClient(value: TIdTCPClient);

        procedure httpClientStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: String);
        procedure httpClientConnected(Sender: TObject);
        procedure httpClientDisconnected(Sender: TObject);
        procedure httpClientWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
        procedure httpClientWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
        procedure httpClientWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);

        procedure tcpClientConnected(Sender: TObject);
        procedure tcpClientDisconnected(Sender: TObject);
        procedure tcpClientStatus(ASender: TObject; const AStatus: TIdStatus;
            const AStatusText: String);

    protected
        procedure Execute; override;

    public
        constructor Create(); reintroduce;

        property http: TIdHttp read _http write setHttp;
        property stream: TFileStream read _stream write _stream;
        property filename: string read _filename write _filename;
        property form: TfRecvStatus read _form write _form;
        property url: String read _url write _url;
        property method: String read _method write _method;
        property client: TIdTCPClient read _client write setClient;
        property size: longint read _size write _size;
    end;

implementation
uses
    XMLUtils, StrUtils, JabberID, PrefController,
    IQ, GnuGetText, Session, JabberConst, JabberUtils, ExUtils;

const
    sXferOverwrite = 'This file already exists. Overwrite?';
    sXferCreateDir = 'This directory does not exist. Create it?';
    sXferStreamError = 'There was an error trying to create the file.';
    sXferRecvError = 'There was an error receiving the file. (%d)';
    sXferDone = 'File transfer is done.';
    sXferConn = 'Got connection.';
    sXferHashError = 'The file transfer for %s completed, but the file appears to be corrupt.';

{$R *.dfm}

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TFileRecvThread.Create();
begin
    //
    inherited Create(true);

    _pos := 0;
    _form := nil;
    _new_txt := TWidestringlist.Create();
    _lock := TCriticalSection.Create();

end;

{---------------------------------------}
procedure TFileRecvThread.setHttp(value: TIdHttp);
begin
    _client := nil;
    _http := Value;
    with _http do begin
        OnConnected := Self.httpClientConnected;
        OnDisconnected := Self.httpClientDisconnected;
        OnWork := Self.httpClientWork;
        OnWorkBegin := Self.httpClientWorkBegin;
        OnWorkEnd := Self.httpClientWorkEnd;
        OnStatus := httpClientStatus;
    end;
end;

{---------------------------------------}
procedure TFileRecvThread.setClient(value: TIdTCPClient);
begin
    _http := nil;
    _client := value;
    with _client do begin
        OnConnected := Self.tcpClientConnected;
        OnDisconnected := Self.tcpClientDisconnected;
        onWork := Self.httpClientWork;
        onWorkBegin := Self.httpClientWorkBegin;
        onWorkEnd := Self.httpClientWorkEnd;
        onStatus := Self.tcpClientStatus;
    end;
end;

{---------------------------------------}
procedure TFileRecvThread.Execute();
var
    tmps: string;
//    i: integer;
begin
    try
        try
            if (_method = 'si') then begin
                try
                    _client.Connect();
                except
                    // We failed to connect.  Need to free the stream
                    // to unlock file.  Then need to remove file or
                    // it remains in the filesystem with 0 byte file.
                    FreeAndNil(_stream);
                    DeleteFile(_filename);
                    SendMessage(_form.Handle, WM_RECV_SIDISCONN, 0, 0);
                    exit;
                end;
                // This is BS, but we're getting a NULL in the first
                // byte of the stream, so just suck it off the socket,
                // and move on. *sigh* I have no idea where it's coming from.
                tmps := _client.ReadChar();
                //i := _client.ReadSmallInt();
                _client.ReadStream(_stream, -1, true);
            end
            else if (_method = 'get') then
                _http.Get(_url, _stream)
            else
                _http.Put(Self.url, _stream);
        finally
            FreeAndNil(_stream);
        end;
    except
    end;

    if (_http <> nil) then
        SendMessage(_form.Handle, WM_RECV_DONE, 0, _http.ResponseCode)
    else
        SendMessage(_form.Handle, WM_RECV_DONE, 0, 0);
end;

{---------------------------------------}
procedure TFileRecvThread.Update();
begin
    _lock.Acquire();

    if ((Self.Suspended) or (Self.Terminated)) then begin
        _lock.Release();
        if (_http <> nil) then
            _http.DisconnectSocket()
        else
            _client.DisconnectSocket();
        FreeAndNil(_stream);
        Self.Terminate();
    end;

    with _form do begin
        if (_pos_max > 0) then
            bar1.Max := _pos_max;
        bar1.Position := _pos;
        if (_new_txt.Count > 0) then begin
            lblStatus.Caption := _new_txt[_new_txt.Count - 1];
            _new_txt.Clear();
        end;
    end;

    _lock.Release();
end;

{---------------------------------------}
procedure TFileRecvThread.httpClientStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
    _lock.Acquire();
    _new_txt.Add(AStatusText);
    _lock.Release();
    Synchronize(Update);
end;

{---------------------------------------}
procedure TFileRecvThread.httpClientConnected(Sender: TObject);
begin
    _lock.Acquire();
    _new_txt.Add(_(sXferConn));
    _lock.Release();
    Synchronize(Update);
end;

{---------------------------------------}
procedure TFileRecvThread.httpClientDisconnected(Sender: TObject);
begin
    // NB: For Indy9, it fires disconnected before it actually
    // connects. So if we drop the stream here, our GETs
    // never work since the response stream gets freed.
    {$ifndef INDY9}
    if (_stream <> nil) then
        FreeAndNil(_stream);
    {$endif}
end;


{---------------------------------------}
procedure TFileRecvThread.httpClientWorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
    _lock.Acquire();
    _new_txt.Add(_(sXferDone));
    _lock.Release();
    Synchronize(Update);
end;

{---------------------------------------}
procedure TFileRecvThread.httpClientWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
    // Update the progress meter
    _pos := AWorkCount;
    Synchronize(Update);
end;

{---------------------------------------}
procedure TFileRecvThread.httpClientWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
    if (AWorkCountMax > 0) then
        _pos_max := AWorkCountMax;
    _pos := 0;
    Synchronize(Update);
end;

{---------------------------------------}
procedure TFileRecvThread.tcpClientConnected(Sender: TObject);
begin
    // we connected, let our form know
    SendMessage(_form.Handle, WM_RECV_SICONN, 0, 0);
end;

{---------------------------------------}
procedure TFileRecvThread.tcpClientDisconnected(Sender: TObject);
begin
    // we NOT connected, let our form know
    //SendMessage(_form.Handle, WM_RECV_SIDISCONN, 0, 0);
end;

{---------------------------------------}
procedure TFileRecvThread.tcpClientStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
    _lock.Acquire();
    _new_txt.Add(AStatusText);
    _lock.Release();
    Synchronize(Update);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfRecvStatus.kill();
begin
    if (_pres <> -1) then
        MainSession.UnRegisterCallback(_pres);
    if (_cur <> -1) then
        MainSession.UnRegisterCallback(_cur);
    getXferManager().killFrame(TExFrame(Self));
end;

{---------------------------------------}
procedure TfRecvStatus.BytestreamCallback(event: string; tag: TXMLTag);
var
    i: integer;
    hosts: TXMLTagList;
    p: THostPortPair;
    pi: integer;
    file_path: string;
    fStream: TFileStream;
    tmp_jid, tmp_host: Widestring;
begin
    //
    MainSession.UnRegisterCallback(_cur);
    _cur := -1;

    if (event = 'timeout') then begin
        lblStatus.Caption := _('Receive request timed out.');
        btnCancel.Caption := _('Close');
        btnRecv.Enabled := false;
        btnCancel.Enabled := true;
        _state := recv_si_cancel;
        exit;
    end;

    FreeAndNil(_pkg.packet);
    _pkg.packet := TXMLTag.Create(tag);

    // check to see if they cancel'd before
    if (_state = recv_si_cancel) then begin
        SendError('406', 'not-acceptable');
        kill();
        exit;
    end;

    // compile a list of hosts to try, and start at the beginning.
    while (_hosts.Count > 0) do begin
        p := THostPortPair(_hosts.Pop());
        p.Free();
    end;

    hosts := tag.QueryXPTags('/iq/query/streamhost');

    if (hosts.Count = 0) then begin
        MessageDlgW(_('No acceptable stream hosts were sent. Have the sender check their settings.'),
            mtError, [mbOK], 0);
        SendError('406', 'not-acceptable');
        kill();
        exit;
    end;

    for i := 0 to hosts.Count - 1 do begin
        tmp_host := hosts[i].getAttribute('host');
        tmp_jid := hosts[i].getAttribute('jid');
        pi := SafeInt(hosts[i].getAttribute('port'));
        // todo: support zero-conf ID's
        if ((pi > 0) and (tmp_host <> '') and (tmp_jid <> '')) then begin
            p := THostPortPair.Create();
            p.host := tmp_host;
            p.jid := tmp_jid;
            p.port := pi;
            _hosts.Push(p);
        end;
    end;

    while (true) do begin
        // use the save as dialog
        SaveDialog1.Filename := _filename;
        if (not SaveDialog1.Execute) then begin
            SendError('406', 'not-acceptable');
            kill();
            exit;
        end;
        _filename := SaveDialog1.filename;

        if FileExists(_filename) then begin
            if MessageDlgW(_(sXferOverwrite),
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
                DeleteFile(_filename);
                break;
            end;
        end
        else begin
            file_path := ExtractFilePath(_filename);
            if (not DirectoryExists(file_path)) then begin
                if MessageDlgW(_(sXferCreateDir), mtConfirmation,
                    [mbYes, mbNo], 0) = mrYes then begin
                    CreateDir(file_path);
                    break;
                end;
            end
            else begin
                break;
            end;
        end;
    end;

    // Create a stream, and get the file into it.
    try
        fstream := TFileStream.Create(_filename, fmCreate);
    except
        on EStreamError do begin
            MessageDlgW(_(sXferStreamError), mtError, [mbOK], 0);
            exit;
        end;
    end;

    _stream := fStream;
    //_stream.Seek(0, soFromBeginning);

    attemptSIConnection();
end;

{---------------------------------------}
procedure TfRecvStatus.attemptSIConnection();
var
    tmps, hash_key: Widestring;
    p: THostPortPair;
    j1, j2: TJabberID;
begin
    // ok, try and connect to the first host/port
    p := THostPortPair(_hosts.Peek());
    SocksHandler.SocksInfo.Authentication := saNoAuthentication;
    SocksHandler.SocksInfo.Version := svSocks5;
    SocksHandler.SocksInfo.Host := p.host;
    SocksHandler.SocksInfo.Port := p.Port;

    j1 := TJabberID.Create(_pkg.recip);
    j2 := TJabberID.Create(MainSession.Jid);
    hash_key := _sid + j1.full + j2.full;
    tmps := Sha1Hash(hash_key);
    j1.Free();
    j2.Free();

    tcpClient.IOHandler := SocksHandler;
    tcpClient.Host := tmps;
    tcpClient.Port := 0;

    _thread := TFileRecvThread.Create();
    _thread.url := '';
    _thread.form := Self;
    _thread.client := tcpClient;
    _thread.stream := _stream;
    _thread.filename := _filename;
    _thread.method := 'si';
    _thread.size := _size;
    _thread.Resume();
end;

{---------------------------------------}
procedure TfRecvStatus.btnRecvClick(Sender: TObject);
var
    fp: Widestring;
    file_path: String;
    fStream: TFileStream;
    p, t, x: TXMLTag;
begin
    if _state = recv_done then begin
        // Open the file.
        ShellExecute(Application.Handle, 'open', PChar(_filename), '', '', SW_NORMAL);
    end;

    if (_pkg.mode = recv_si) then begin
        if (_state = recv_si_offer) then begin
            // send SI accept
            assert(_pkg.packet <> nil);
            lblStatus.Caption := _('Negotiating with sender...');
            p := _pkg.packet;
            _sid := p.QueryXPData('/iq/si@id');
            _filename := ExtractFilename(p.QueryXPData('/iq/si/file@name'));
            _size := SafeInt(p.QueryXPData('/iq/si/file@size'));
            fp := MainSession.Prefs.getString('xfer_path');
            if (AnsiEndsText('\', fp)) then
                _filename := fp + _filename
            else
                _filename := fp + '\' + _filename;

            t := jabberIQResult(p);
            x := t.AddTagNS('si', XMLNS_SI);
            x.setAttribute('id', _sid);
            x := x.AddTagNS('feature', XMLNS_FEATNEG);
            x := x.AddTagNS('x', XMLNS_XDATA);
            x.setAttribute('type', 'submit');
            x := x.AddTag('field');
            x.setAttribute('var', 'stream-method');
            x.AddBasicTag('value', XMLNS_BYTESTREAMS);
            _state := recv_si_wait;
            _cur := MainSession.RegisterCallback(
                Self.BytestreamCallback,
                '/packet/iq[@type="set"]/query[@xmlns="' + XMLNS_BYTESTREAMS + '"]');
            MainSession.SendTag(t);
            btnRecv.Enabled := false;
        end;
    end

    else if (_pkg.mode = recv_oob) then begin
        if (_state = recv_recv) then begin
            // receive mode
            _filename := URLToFilename(_pkg.url);

            while (true) do begin
                // use the save as dialog
                SaveDialog1.Filename := _filename;
                if (not SaveDialog1.Execute) then exit;
                _filename := SaveDialog1.filename;

                if FileExists(_filename) then begin
                    if MessageDlgW(_(sXferOverwrite),
                        mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
                        DeleteFile(_filename);
                        break;
                    end;
                end
                else begin
                    file_path := ExtractFilePath(_filename);
                    if (not DirectoryExists(file_path)) then begin
                        if MessageDlgW(_(sXferCreateDir), mtConfirmation,
                            [mbYes, mbNo], 0) = mrYes then begin
                            CreateDir(file_path);
                            break;
                        end;
                    end
                    else begin
                        break;
                    end;
                end;
            end;

            // Create a stream, and get the file into it.
            try
                fstream := TFileStream.Create(_filename, fmCreate);
            except
                on EStreamError do begin
                    MessageDlgW(_(sXferStreamError), mtError, [mbOK], 0);
                    exit;
                end;
            end;

            _thread := TFileRecvThread.Create();
            _thread.url := _pkg.url;
            _thread.form := Self;
            _thread.http := httpClient;
            _thread.stream := fstream;
            _thread.method := 'get';
            _thread.Resume();
        end;
    end;
end;

{---------------------------------------}
procedure TfRecvStatus.setup(pkg: TFileXferPkg);
begin
    _pkg := pkg;
    if (_pkg.mode = recv_oob) then
        _state := recv_recv
    else
        _state := recv_si_offer;
    _hosts := TQueue.Create();
    _cur := -1;
    _pres := -1;
    bar1.Max := pkg.size;
    lblFrom.Caption := pkg.recipDisplay;
    lblFile.Caption := ExtractFilename(pkg.pathname);
    lblStatus.Caption := '';
    _pres := MainSession.RegisterCallback(PresCallback);
end;

{---------------------------------------}
procedure TfRecvStatus.WMRecvDone(var msg: TMessage);
var
    tmps: Widestring;
    hex: String;
begin
    // our thread completed.
    if (_pkg.Mode = recv_si) then begin
        if (_state = recv_si_stream) then begin
            btnRecv.Enabled := true;
            btnRecv.Caption := _('Open');
            btnCancel.Caption := _('Close');
            _state := recv_done;
            _thread := nil;
            bar1.Position := bar1.Max;

            // Create a new read-only stream so we can hash it.
            if (_pkg.hash <> '') then begin
                hex := MD5File(_filename);
                if (hex <> _pkg.hash) then begin
                    tmps := WideFormat(_(sXferHashError), [_pkg.pathname]);
                    MessageDlgW(tmps, mtError, [mbOK], 0);
                end;
            end;
        end;
    end
    else if (_state = recv_recv) then begin
        if ((msg.LParam >= 200) and
            (msg.LParam < 300)) then begin
            btnRecv.Enabled := true;
            btnRecv.Caption := _('Open');
            btnCancel.Caption := _('Close');
            _state := recv_done;
        end
        else begin
            tmps := WideFormat(_(sXferRecvError), [msg.LParam]);
            MessageDlgW(tmps, mtError, [mbOK], 0);
            DeleteFile(_filename);
        end;
    end;
    MainSession.UnRegisterCallback(_pres);
    _pres := -1;
end;

{---------------------------------------}
procedure TfRecvStatus.WMRecvConn(var msg: TMessage);
var
    p: THostPortPair;
    x, r: TXMLTag;
begin
    // We connected to one of the stream hosts listed. Sweet.
    r := jabberIQResult(_pkg.packet);
    p := THostPortPair(_hosts.Pop());

    x := r.AddTagNS('query', XMLNS_BYTESTREAMS);
    x.setAttribute('sid', _sid);
    x := x.AddTag('streamhost-used');
    x.setAttribute('jid', p.jid);
    _state := recv_si_stream;
    MainSession.SendTag(r);

    p.Free();

end;

{---------------------------------------}
procedure TfRecvStatus.WMRecvDisconn(var msg: TMessage);
begin
    // We couldn't connect to this host,
    // pick the next one.
    PostMessage(Self.Handle, WM_RECV_NEXT, 0, 0);
end;

{---------------------------------------}
procedure TfRecvStatus.SendError(code, condition: string);
var
    c,r,x: TXMLTag;
begin
    assert(_pkg.packet <> nil);
    r := jabberIQError(_pkg.packet);
    r.setAttribute('type', 'error');
    x := r.AddTag('error');
    x.setAttribute('code', '404');
    x.setAttribute('type', 'cancel');
    c := x.AddTag('condition');
    c.setAttribute('xmlns', 'urn:ietf:params:xml:ns:xmpp-stanzas');
    c.AddTag('item-not-found');
    MainSession.SendTag(r);
end;

{---------------------------------------}
procedure TfRecvStatus.WMRecvNext(var msg: TMessage);
var
    p: THostPortPair;
begin
    // pop the failed stream host from the stack
    p := THostPortPair(_hosts.Pop());
    p.Free();

    if (_hosts.Count = 0) then begin
        // we ran out of streamhosts to try. bummer :(
        MessageDlgW(PrefController.getAppInfo.ID + _(' was unable to connect to any file transfer proxies or the sender.'),
            mtError, [mbOK], 0);

        // send error back to sender.
        SendError('404', 'item-not-found');
        kill();
        exit;
    end
    else
        attemptSIConnection();
end;

{---------------------------------------}
procedure TfRecvStatus.btnCancelClick(Sender: TObject);
begin
    // cancel, or close
    if (_pkg.mode = recv_si) then begin
        if (_cur <> -1) then begin
            MainSession.UnRegisterCallback(_cur);
        end;

        case _state of
        recv_si_offer: begin
            // just refuse the SI, and close panel
            SendError('406', 'not-acceptable');
            kill();
            end;
        recv_si_wait, recv_si_cancel, recv_si_stream, recv_done: begin
            // kill the socket and close panel.
            try
                if (_thread <> nil) then
                    _thread.Terminate();
            except

            end;
            kill();
            end;
        end;
    end
    else
        kill();
end;

{---------------------------------------}
procedure TfRecvStatus.presCallback(event: string; tag: TXMLTag; pres: TJabberPres);
begin
    // the sender went offline
    if ((pres.PresType = 'unavailable') and (pres.fromJid.full = _pkg.recip)) then begin
        MainSession.UnRegisterCallback(_pres);
        _pres := -1;
        MessageDlgW(WideFormat(_('The sender of a file transfer (%s) went offline.'),
            [_pkg.recipDisplay]), mtError, [mbOK], 0);
        _state := recv_si_cancel;
        getXferManager().killFrame(TExFrame(Self));
    end;
end;

end.
