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
unit Transports;


interface

uses
    XMLTag, IQ, 
    Session,
    Contnrs, SysUtils, classes;

type
    TTransportProxy = class
    private
        iq: TJabberIQ;
        jid: Widestring;
        action: Widestring;
        key: Widestring;
        procedure ShowError(msg: Widestring);
    published
        procedure RemoveGetCallback(event: string; tag: TXMLTag);
        procedure RemoveSetCallback(event: string; tag: TXMLTag);
    public
        destructor Destroy(); override;
        procedure UnRegister();
end;

procedure RemoveTransport(jid: WideString; Quiet: boolean = false);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    GnuGetText, JabberUtils, ExUtils,  JabberConst, Controls, Dialogs;
const
    sTransportRemove = 'Remove Registration?';
    sTransportTimeout = 'The transport could not be reached. Your request timed out.';
    sTransportError = 'There was an error processing your request.';
    sTransportNotReg = 'You are not registered with this transport.';
    sTransportSuccess = 'Your request was successful.';


{---------------------------------------}
procedure RemoveTransport(jid: Widestring; Quiet: boolean = false);
var
    proxy: TTransportProxy;
begin
    // Delete the registration
    if (Quiet = false) then begin
        if MessageDlgW(_(sTransportRemove), mtConfirmation, [mbYes, mbNo], 0) = mrNo then
            exit;
    end;

    proxy := TTransportProxy.Create();
    proxy.jid := jid;
    proxy.UnRegister();
end;

{---------------------------------------}
destructor TTransportProxy.Destroy();
begin
    if (iq <> nil) then
        iq.Free();
end;

{---------------------------------------}
procedure TTransportProxy.UnRegister();
begin
    action := 'remove';
    iq := TJabberIQ.Create(MainSession, MainSession.generateID(), RemoveSetCallback, 4);
    with iq do begin
        toJid := jid;
        iqType := 'set';
        Namespace := XMLNS_REGISTER;
        qTag.AddTag('remove');
        Send();
    end;
end;

{---------------------------------------}
procedure TTransportProxy.ShowError(msg: Widestring);
begin
    MessageDlgW(msg, mtError, [mbOK], 0);
end;

{---------------------------------------}
procedure TTransportProxy.RemoveGetCallback(event: string; tag: TXMLTag);
var
    user_tag, key_tag: TXMLTag;
    user: WideString;
begin
    iq := nil;
    if (event = 'timeout') then begin
        ShowError(_(sTransportTimeout));
        Self.Free();
        exit;
    end

    else if (tag.GetAttribute('type') = 'error') then begin
        ShowError(_(sTransportError));
        Self.Free();
        exit;
    end

    else if (action = 'remove') then begin
        key_tag := tag.QueryXPTag('/iq/query/key');
        user_tag := tag.QueryXPTag('/iq/query/username');

        if (user_tag <> nil) then
            user := user_tag.Data();

        if (key_tag <> nil) then
            key := key_tag.Data();

        if (user = '') then begin
            ShowError(_(sTransportNotReg));
            Self.Free();
            exit;
        end;

        iq := TJabberIQ.Create(MainSession, MainSession.generateID(), RemoveSetCallback, 4);
        with iq do begin
            toJid := jid;
            iqType := 'set';
            Namespace := XMLNS_REGISTER;
            AddTag('remove');
            if (key <> '') then
                AddBasicTag('key', key);
            AddBasicTag('username', user);
            Send();
        end;

    end;
end;

{---------------------------------------}
procedure TTransportProxy.RemoveSetCallback(event: string; tag: TXMLTag);
begin
    iq := nil;
    if (event = 'timeout') then begin
        ShowError(_(sTransportTimeout));
    end
    else if (tag.GetAttribute('type') = 'error') then begin
        ShowError(_(sTransportError));
    end
    else begin
        MessageDlgW(_(sTransportSuccess), mtInformation, [mbOK], 0);
    end;
    Self.Free();
end;


end.
