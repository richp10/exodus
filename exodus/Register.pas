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
unit Register;


interface
uses
    XMLTag,
    SysUtils, Classes;

type

    TRegController = class;

    TRegProxy = class
    private
        _jid: Widestring;
        _cb: integer;
        _full: boolean;
    published
        procedure Callback(event: string; tag: TXMLTag);
    public
        constructor Create(jid: WideString; reg_full: boolean);
        destructor Destroy; override;
end;

    TRegController = class
    private
        _s: TObject;
        _cb: integer;
        _monitors: TList;
    published
        procedure callback(event: string; tag: TXMLTag);
    public
        constructor create();
        destructor Destroy(); override;

        procedure SetSession(s: TObject);
        procedure MonitorJid(jid: WideString; reg_full: boolean = true);
        procedure RemoveProxy(rp: TRegProxy);
end;

implementation
uses
    ExSession, JabberID, Jabber1, Forms, RegForm, Session;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TRegController.Create();
begin
    inherited;

    _monitors := TList.Create();
end;

{---------------------------------------}
destructor TRegController.Destroy();
begin
    _monitors.Free();

    inherited;
end;

{---------------------------------------}
procedure TRegController.SetSession(s: TObject);
var
    js: TJabberSession;
begin
    // Create a new registration object
    _s := s;
    js := TJabberSession(_s);
    _cb := js.RegisterCallback(Callback, '/session/register');
end;

{---------------------------------------}
procedure TRegController.Callback(event: string; tag: TXMLTag);
begin
    // Create a new registration form and kick the process off
    if ((event = '/session/register') and (tag <> nil)) then begin
        StartServiceReg(tag.getAttribute('jid'));
    end;
end;

{---------------------------------------}
procedure TRegController.MonitorJid(jid: WideString; reg_full: boolean = true);
var
    rp: TRegProxy;
begin
    // monitor this JID for pres-error type 407
    // when we get one, fire off a register event
    assert(jid <> '');
    rp := TRegProxy.Create(jid, reg_full);
    _monitors.Add(rp);
end;

{---------------------------------------}
procedure TRegController.RemoveProxy(rp: TRegProxy);
var
    i: integer;
begin
    i := _monitors.IndexOf(rp);
    if (i >= 0) then
        _monitors.Delete(i);
    rp.Free();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TRegProxy.Create(jid: WideString; reg_full: boolean);
begin
    _jid := jid;
    _full := reg_full;
    _cb := MainSession.RegisterCallback(Self.Callback,
        '/packet/presence[@type="error"][@from="' + jid + '"/error[@code="407"]');
end;

{---------------------------------------}
procedure TRegProxy.Callback(event: string; tag:TXMLTag);
var
    tmp_jid: TJabberID;
begin
    // Create a registration wizard..
    if (_full) then
        StartServiceReg(_jid)
    else begin
        tmp_jid := TJabberID.Create(_jid);
        StartServiceReg(tmp_jid.domain);
        tmp_jid.Free();
    end;
    ExRegController.RemoveProxy(Self);
end;

{---------------------------------------}
destructor TRegProxy.Destroy();
begin
    if (_cb <> -1) then begin
        MainSession.UnRegisterCallback(_cb);
        _cb := -1;
    end;
end;

end.
