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
unit KerbAuth;


interface
uses
    IdAuthenticationSSPI, IdSSPI, SASLMech, 
    JabberAuth, IQ, Session, XMLTag, IdCoderMime, IdHashMessageDigest,
    Classes, SysUtils;

type
    TSSPIKerbClient = class;

    TKerbState = (kerb_auth, kerb_ssf, kerb_done, kerb_error);

    // ------------------------------------------------------------------------
    // This is our JabberAuth plugin for TJabberSession
    // ------------------------------------------------------------------------
    TKerbAuth = class(TSASLMech)
    private
        // the server SPN
        _state: TKerbState;
        _server_spn: Widestring;
        _kerb: TSSPIKerbClient;
    protected
        function getInitialResponse(mech: TXMLTag): Widestring; override;
    published
        procedure Challenge(event: string; tag: TXMLTag); override;
    public
        constructor Create(session: TJabberSession);
        destructor Destroy(); override;
    end;

    // ------------------------------------------------------------------------
    // This is stuff to interface with IdAuthenticationSSPI
    // ------------------------------------------------------------------------
    TSSPIKerbPackage = class(TCustomSSPIPackage)
    public
        constructor Create;
    end;

    TSSPIKerbClient = class
    private
        _pkg: TSSPIKerbPackage;
        _creds: TSSPIWinNTCredentials;
        _ctx: TSSPIClientConnectionContext;

    public
        constructor Create;
        destructor Destroy; override;

        procedure SetCredentials(aDomain, aUserName, aPassword: string); overload;
        procedure SetCredentials(); overload;

        function Initial(const aTargetName: string; var aToPeerToken: string): Boolean;
        function Update(const aFromPeerToken: string; var aToPeerToken: string): Boolean;
        function Unwrap(const Msg: string): Boolean;
        function Wrap(const Msg: string; var aToPeerToken: string): Boolean;

    end;

function KerbAuthFactory(session: TObject): TJabberAuth;

implementation

{ TKerbAuth }

uses
    Windows, IdException, JabberConst;

const
    SECQOP_WRAP_NO_ENCRYPT = $80000001;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function KerbAuthFactory(session: TObject): TJabberAuth;
begin
    Result := TKerbAuth.Create(TJabberSession(session));
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TKerbAuth.Create(session: TJabberSession);
begin
    inherited Create('GSSAPI', session);
    _state := kerb_auth;
    _kerb := TSSPIKerbClient.Create();
end;

{---------------------------------------}
destructor TKerbAuth.Destroy;
begin
    FreeAndNil(_kerb);
    inherited Destroy();
end;

{---------------------------------------}
function TKerbAuth.getInitialResponse(mech: TXMLTag): Widestring;
var
    realm: Widestring;
    tok: string;
begin
    _server_spn := mech.getAttribute('kerb:principal');

    // initialize our creds
    if (_session.Profile.WinLogin) then
        _kerb.SetCredentials()
    else begin
        realm := _session.Profile.SASLRealm;
        if (realm = '') then realm := _session.Server;        
        _kerb.SetCredentials(realm, _session.Username, _session.Password);
    end;


    // send out the packet letting server know we want GSSAPI
    if (not _kerb.Initial(_server_spn, tok)) then begin
        error();
        exit;
    end;

    // encode the ticket
    Result := _encoder.Encode(tok);
end;

{---------------------------------------}
procedure TKerbAuth.Challenge(event: string; tag: TXMLTag);
var
    ssf, data, tok, c: string;
    resp: TXMLTag;
begin
    // We got a challenge, decode it
    try
        c := _decoder.DecodeString(tag.Data);
    except
        on EIdException do begin
            CancelAuthentication();
            _session.SetAuthenticated(false, nil, false);
            exit;
        end;
    end;

    // send the challenge thru SSPI
    try
        if (_state = kerb_auth) then begin
            if (_kerb.Update(c, tok)) then begin
                data := _encoder.Encode(tok);
                resp := TXMLTag.Create('response');
                resp.setAttribute('xmlns', XMLNS_XMPP_SASL);
                resp.AddCData(data);
                _session.SendTag(resp);
            end
            else if (_kerb._ctx.Authenticated) then begin
                _state := kerb_ssf;
                resp := TXMLTag.Create('response');
                resp.setAttribute('xmlns', XMLNS_XMPP_SASL);
                _session.SendTag(resp);
            end;
        end
        else if (_state = kerb_ssf) then begin
            SetLength(ssf, 4);
            ssf[1] := Chr(1);
            ssf[2] := Chr(0);
            ssf[3] := Chr(0);
            ssf[4] := Chr(0);
            if (_kerb.Unwrap(c) and _kerb.Wrap(ssf, tok)) then begin
                data := _encoder.Encode(tok);
                resp := TXMLTag.Create('response');
                resp.setAttribute('xmlns', XMLNS_XMPP_SASL);
                resp.AddCData(data);
                _session.SendTag(resp);
            end
            else
                error(tag);
        end;
    except
        on ESSPIException do error(tag);
    end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TSSPIKerbPackage.Create;
begin
    inherited Create(MICROSOFT_KERBEROS_NAME);
end;

{---------------------------------------}
constructor TSSPIKerbClient.Create();
begin
    inherited Create;

    _pkg := TSSPIKerbPackage.Create();
    _creds := TSSPIWinNTCredentials.Create(_pkg);
    _ctx := TSSPIClientConnectionContext.Create(_creds);
    _ctx.RequestedFlags := ISC_REQ_MUTUAL_AUTH or ISC_REQ_ALLOCATE_MEMORY;
    _ctx.NetworkRep := true;
end;

{---------------------------------------}
destructor TSSPIKerbClient.Destroy();
begin
    FreeAndNil(_ctx);
    FreeAndNil(_creds);
    FreeAndNil(_pkg);
end;

{---------------------------------------}
procedure TSSPIKerbClient.SetCredentials(aDomain, aUserName, aPassword: string);
begin
    _creds.Acquire(scuOutBound, aDomain, aUserName, aPassword);
end;

{---------------------------------------}
procedure TSSPIKerbClient.SetCredentials();
begin
    _creds.Acquire(scuOutBound);
end;

{---------------------------------------}
function TSSPIKerbClient.Initial(const aTargetName: string; var aToPeerToken: string): Boolean;
begin
    Result := _ctx.GenerateInitialChalenge(aTargetName, aToPeerToken);
end;

{---------------------------------------}
function TSSPIKerbClient.Update(const aFromPeerToken: string; var aToPeerToken: string): Boolean;
begin
    Result := _ctx.UpdateAndGenerateReply(aFromPeerToken, aToPeerToken);
end;

{---------------------------------------}
function TSSPIKerbClient.Unwrap(const Msg: string): Boolean;
var
    buffs: Array[0..1] of SecBuffer;
    buffDesc: SecBufferDesc;
    g: TSSPIInterface;
    r: SECURITY_STATUS;
    qop: ULONG;
begin
    Result := false;
    g := getSSPIInterface();
    if (g = nil) then exit;

    // this is for encrypted data
    buffs[0].BufferType := SECBUFFER_STREAM;
    buffs[0].cbBuffer := Length(Msg);
    buffs[0].pvBuffer := @(Msg[1]);

    // this is for decrypted data
    buffs[1].BufferType := SECBUFFER_DATA;
    buffs[1].cbBuffer := 0;
    buffs[1].pvBuffer := nil;

    buffDesc.ulVersion := SECBUFFER_VERSION;
    buffDesc.cBuffers := 2;
    buffDesc.pBuffers := @(buffs[0]);

    r := g.FunctionTable.DecryptMessage(_ctx.Handle, @buffDesc, 0, @qop);
    Result := (r = SEC_E_OK);
end;

{---------------------------------------}
function TSSPIKerbClient.Wrap(const Msg: string; var aToPeerToken: string): Boolean;
var
    sizes: SecPkgContext_Sizes;
    buffs: Array[0..2] of SecBuffer;
    buffDesc: SecBufferDesc;
    r: SECURITY_STATUS;
    g: TSSPIInterface;
    b0, b1, b2: string;
begin
    Result := false;
    g := getSSPIInterface();
    if (g = nil) then exit;

    g.FunctionTable.QueryContextAttributesA(_ctx.Handle, SECPKG_ATTR_SIZES, @sizes);

    buffs[0].BufferType := SECBUFFER_TOKEN;
    buffs[0].cbBuffer := sizes.cbSecurityTrailer;
    buffs[0].pvBuffer := AllocMem(sizes.cbSecurityTrailer);

    buffs[1].BufferType := SECBUFFER_DATA;
    buffs[1].cbBuffer := Length(Msg);
    buffs[1].pvBuffer := @(Msg[1]);

    buffs[2].BufferType := SECBUFFER_PADDING;
    buffs[2].cbBuffer := sizes.cbBlockSize;
    buffs[2].pvBuffer := AllocMem(sizes.cbBlockSize);

    buffDesc.ulVersion := SECBUFFER_VERSION;
    buffDesc.cBuffers := 3;
    buffDesc.pBuffers := @(buffs[0]);

    r := g.FunctionTable.EncryptMessage(_ctx.Handle, SECQOP_WRAP_NO_ENCRYPT, @buffDesc, 0);
    if (r = SEC_E_OK) then begin
        SetString(b0, PChar(buffs[0].pvBuffer), buffs[0].cbBuffer);
        SetString(b1, PChar(buffs[1].pvBuffer), buffs[1].cbBuffer);
        SetString(b2, PChar(buffs[2].pvBuffer), buffs[2].cbBuffer);
        aToPeerToken := '';
        aToPeerToken := ConCat(b0, b1);
        aToPeerToken := ConCat(aToPeerToken, b2);
        Result := true;
    end;

    FreeMem(buffs[0].pvBuffer);
    FreeMem(buffs[2].pvBuffer);

end;


initialization
    RegisterJabberAuth('GSSAPI', KerbAuthFactory);

end.
