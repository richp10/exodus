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
unit SASLMech;

interface
uses
    JabberAuth, IQ, Session, XMLTag, IdCoderMime, IdHashMessageDigest,
    Classes, SysUtils, IdAuthenticationSSPI;

type

    ESASLMechException = class(Exception);

    TSASLMech = class(TJabberAuth)
    protected
        _mech: Widestring;
        _session: TJabberSession;

        // Lets get us some useful objects
        _decoder: TIdDecoderMime;
        _encoder: TIdEncoderMime;

        // Callbacks
        _ccb: integer;
        _fail: integer;
        _resp: integer;

        procedure error(tag: TXMLTag = nil);
        function getInitialResponse(mech: TXMLTag): Widestring; virtual; abstract;

    published
        procedure Challenge(event: string; tag: TXMLTag); virtual; abstract;
        procedure FailCallback(event: string; xml: TXMLTag);
        procedure SuccessCallback(event: string; xml: TXMLTag);

    public
        constructor Create(mech: Widestring; session: TJabberSession);
        destructor Destroy(); override;

        // TJabberAuth
        procedure StartAuthentication(); override;
        procedure CancelAuthentication(); override;

        function StartRegistration(): boolean; override;
        procedure CancelRegistration(); override;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    JabberConst, XMLUtils, IdException, IdHash, Random;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TSASLMech.Create(mech: Widestring; session: TJabberSession);
begin
    _session := session;
    _decoder := TIdDecoderMime.Create(nil);
    _encoder := TIdEncoderMime.Create(nil);
    _ccb := -1;
    _fail := -1;
    _resp := -1;
    _mech := mech;
end;

{---------------------------------------}
destructor TSASLMech.Destroy();
begin
    FreeAndNil(_decoder);
    FreeAndNil(_encoder);

    inherited Destroy;
end;

{---------------------------------------}
procedure TSASLMech.error(tag: TXMLTag);
begin
    _session.setAuthenticated(false, nil, false);
    CancelAuthentication();
end;

{---------------------------------------}
procedure TSASLMech.StartAuthentication();
var
    i: integer;
    mechs: TXMLTagList;
    m, f: TXMLTag;
    init, cur_mech: Widestring;
begin
    CancelAuthentication();

    if (not _session.isXMPP) then begin
        // if we're not XMPP, bail
        error();
        exit;
    end;

    f := _session.xmppFeatures;
    mechs := f.QueryXPTags('/stream:features/mechanisms/mechanism');
    if (mechs = nil) then begin
        // if we have no mechs, bail
        error();
        exit;
    end;

    // look for the specified mech
    for i := 0 to mechs.Count - 1 do begin
        cur_mech := mechs[i].Data;
        if (cur_mech = _mech) then begin
            try
                init := getInitialResponse(mechs[i]);
                mechs.Free();

                // Register for callbacks
                _ccb := _session.RegisterCallback(Challenge, '/packet/challenge');
                _fail := _session.RegisterCallback(FailCallback, '/packet/failure');
                _resp := _session.RegisterCallback(SuccessCallback, '/packet/success');

                // Send auth element
                m := TXMLTag.Create('auth');
                m.setAttribute('xmlns', XMLNS_XMPP_SASL);
                m.setAttribute('mechanism', _mech);
                if (init <> '') then
                    m.AddCData(init);
                _session.SendTag(m);
                exit;
            except
                // fallthrough and error
            end;
        end;
    end;

    mechs.Free();

    // if we get here, we didn't find the correct mech, bail
    error();
end;

{---------------------------------------}
procedure TSASLMech.CancelAuthentication();
begin
    // Make sure to remove callbacks
    if (_session <> nil) then begin
        if (_ccb <> -1) then _session.UnRegisterCallback(_ccb);
        if (_fail <> -1) then _session.UnRegisterCallback(_fail);
        if (_resp <> -1) then _session.UnRegisterCallback(_resp);
    end;
    _ccb := -1;
    _fail := -1;
    _resp := -1;
end;

{---------------------------------------}
function TSASLMech.StartRegistration(): boolean;
begin
    Result := false;
end;

{---------------------------------------}
procedure TSASLMech.CancelRegistration();
begin
    // NOOP for SASL Mechs
end;

{---------------------------------------}
procedure TSASLMech.FailCallback(event: string; xml: TXMLTag);
begin
    error(xml);
end;

{---------------------------------------}
procedure TSASLMech.SuccessCallback(event: string; xml: TXMLTag);
begin
    CancelAuthentication();
    _session.SetAuthenticated(true, xml, true);
end;

end.
