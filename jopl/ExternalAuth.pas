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
unit ExternalAuth;


interface
uses
    SASLMech, JabberAuth, IQ, Session, XMLTag, IdCoderMime, IdHashMessageDigest,
    Classes, SysUtils;

type
    // ------------------------------------------------------------------------
    // This is our JabberAuth plugin for TJabberSession
    // ------------------------------------------------------------------------
    TExternalAuth = class(TSASLMech)
    protected
        function getInitialResponse(mech: TXMLTag): Widestring; override;
    published
        procedure Challenge(event: string; tag: TXMLTag); override;
    public
        constructor Create(session: TJabberSession);
        destructor Destroy(); override;
    end;

implementation
uses
    JabberConst;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function ExternalAuthFactory(session: TObject): TJabberAuth;
begin
    Result := TExternalAuth.Create(TJabberSession(session));
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TExternalAuth.Create(session: TJabberSession);
begin
    inherited Create('EXTERNAL', session);
end;

{---------------------------------------}
destructor TExternalAuth.Destroy;
begin
    inherited Destroy();
end;

{---------------------------------------}
function TExternalAuth.getInitialResponse(mech: TXMLTag): Widestring;
begin
    Result := '';

    if ((_session.Profile.SSL_Cert = '') or (not _session.SSLEnabled)) then
        Raise ESASLMechException.Create('External Auth requires a peer cert and SSL.');
end;

{---------------------------------------}
procedure TExternalAuth.Challenge(event: string; tag: TXMLTag);
begin
    //
end;

initialization
    RegisterJabberAuth('EXTERNAL', ExternalAuthFactory);

end.
