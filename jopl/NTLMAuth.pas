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
unit NTLMAuth;

interface
uses
    SASLMech, JabberAuth, IQ, Session, XMLTag, IdCoderMime, IdHashMessageDigest,
    Classes, SysUtils, IdAuthenticationSSPI;

type
    TNTLMAuth = class(TSASLMech)
    private
        _ntlm : TIndySSPINTLMClient;
    protected
        function getInitialResponse(mech: TXMLTag): Widestring; override;
    published
        procedure Challenge(event: string; tag: TXMLTag); override;
    public
        constructor Create(session: TJabberSession);
        destructor Destroy(); override;

    end;

function NTLMAuthFactory(session: TObject): TJabberAuth;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberConst, XMLUtils, IdException, IdHash, Random;

{---------------------------------------}
function NTLMAuthFactory(session: TObject): TJabberAuth;
begin
    Result := TNTLMAuth.Create(TJabberSession(session));
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TNTLMAuth.Create(session: TJabberSession);
begin
    inherited Create('NTLM', session);
    _ntlm := TIndySSPINTLMClient.Create();
end;

{---------------------------------------}
destructor TNTLMAuth.Destroy();
begin
    FreeAndNil(_ntlm);

    inherited Destroy();
end;

{---------------------------------------}
function TNTLMAuth.getInitialResponse(mech: TXMLTag): Widestring;
var
    tok: string;
begin
    _ntlm.SetCredentialsAsCurrentUser();
    tok := _ntlm.InitAndBuildType1Message();
    Result := _encoder.Encode(tok);
end;

{---------------------------------------}
procedure TNTLMAuth.Challenge(event: string; tag: TXMLTag);
var
    c: string;
    r: TXMLTag;
begin
    if (event <> 'xml') then begin
        _session.SetAuthenticated(false, nil, false);
        exit;
    end;

    c := _decoder.DecodeString(tag.Data);
    c := _ntlm.UpdateAndBuildType3Message(c);

    r := TXMLTag.Create('response');
    r.setAttribute('xmlns', XMLNS_XMPP_SASL);

    r.AddCData(_encoder.Encode(c));

    _session.SendTag(r);
end;

{---------------------------------------}
initialization
    RegisterJabberAuth('NTLM', NTLMAuthFactory);


end.
