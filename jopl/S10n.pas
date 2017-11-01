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
unit S10n;


interface

uses
    XMLTag, Session, Unicode, 
    SysUtils, Classes, JabberUtils;

type
    TSubController = class
    private
        _transports: TWideStringList;
        _session: longint;
        _sub: longint;
        _subd: longint;
        _unsub: longint;
        _unsubd: longint;
    published
        procedure SessionCallback(event: string; tag: TXMLTag);
    public
        Constructor Create;
        Destructor Destroy; override;

        procedure Subscribe(event: string; tag: TXMLTag);
        procedure Subscribed(event: string; tag: TXMLTag);
        procedure UnSubscribe(event: string; tag: TXMLTag);
        procedure UnSubscribed(event: string; tag: TXMLTag);
end;

var
    SubController: TSubController;

const
    sS10nDeny  = 'The contact %s did not grant your subscription request.'#13#10'This user may not exist.';
    sS10nUnsub = 'The contact %s has been removed from your contacts list at his/her request.';


procedure SendSubscribe(sjid: Widestring; Session: TJabberSession);
procedure SendSubscribed(sjid: Widestring; Session: TJabberSession);
procedure SendUnSubscribe(sjid: Widestring; Session: TJabberSession);
procedure SendUnSubscribed(sjid: Widestring; Session: TJabberSession);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    {$ifdef Win32}
    Dialogs,
    {$else}
    QDialogs,
    {$endif}
    Presence,
    JabberID,
    ContactController,
    DisplayName,
    PrefController,
    Exodus_TLB;

{---------------------------------------}
Constructor TSubController.Create;
begin
    inherited;
    
    _sub    := MainSession.RegisterCallback(Subscribe, '/packet/presence[@type="subscribe"]');
    _subd   := MainSession.RegisterCallback(Subscribed, '/packet/presence[@type="subscribed"]');
    _unsub  := MainSession.RegisterCallback(UnSubscribe, '/packet/presence[@type="unsubscribe"]');
    _unsubd := MainSession.RegisterCallback(UnSubscribed, '/packet/presence[@type="unsubscribed"]');
    _session := MainSession.RegisterCallback(SessionCallback, '/session');

    _transports := TWideStringList.Create();
end;

{---------------------------------------}
Destructor TSubController.Destroy;
begin
    MainSession.UnRegisterCallback(_sub);
    MainSession.UnRegisterCallback(_subd);
    MainSession.UnRegisterCallback(_unsub);
    MainSession.UnRegisterCallback(_unsubd);
    MainSession.UnRegisterCallback(_session);
    _transports.Free();
    inherited Destroy;
end;

{---------------------------------------}
procedure TSubController.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/transport') then
        _transports.Add(TJabberID.Create(tag.getAttribute('jid')).jid);
end;

type
    TAutoAddHandler = class(TDisplayNameEventListener)
        jid: TJabberID;
        procedure FireOnDisplayNameChange(bareJID: Widestring; displayName: WideString);override;
        procedure addToRoster(newJID: TJabberID);

        destructor Destroy();override;
    end;

destructor TAutoAddHandler.Destroy();
begin
    jid.Free();
    inherited;
end;

procedure TAutoAddHandler.fireOnDisplayNameChange(bareJID: Widestring; displayName: WideString);
begin
    if (jid.jid = bareJID) then begin
 { TODO : Roster refactor }
        MainSession.Roster.AddItem(jid.jid, displayName, MainSession.Prefs.getString('roster_default'), true);
        Self.Free();
    end;
end;

procedure TAutoAddHandler.addToRoster(newJID: TJabberID);
var
    changePending: boolean;
    dname: WideString;
begin
    jid := TJabberID.Create(newJID);//save jid for later dispname change event
    //newJID may already be in roster. Force a displayname lookup if needed
    if (Self.ProfileEnabled) then
        dName := Self.getProfileDisplayName(newJID, changePending)
    else
//TODO : DN add a mechanism to DN to force a profile DN lookup, regardless of roster name
        dname := getDisplayName(newJID.jid, changePending);

    if (not changePending) then begin
        //addnow, destroy ourself
        MainSession.Roster.AddItem(
                newjid.jid, dname,
                MainSession.Prefs.getString('roster_default'),
                true);
        Self.Free();
    end;
end;

{---------------------------------------}
procedure TSubController.Subscribe(event: string; tag: TXMLTag);
var
    j: TJabberID;
    incoming: integer;
    add_to_roster: boolean;
    prompt: boolean;
    subscr, ask: Widestring;
    item: IExodusItem;
begin
 { TODO : Roster refactor }
    // getting a s10n request
    j := TJabberID.Create(tag.GetAttribute('from'));

//    // deal w/ transports
    if (_transports.IndexOf(j.jid) >= 0) then
        SendSubscribed(j.full, MainSession)

    // deal w/ normal subscription requests
    else begin
        with MainSession do begin

        end;
        incoming := MainSession.Prefs.getInt(PrefController.P_SUB_AUTO);
        add_to_roster := MainSession.Prefs.getBool(PrefController.P_SUB_AUTO_ADD);

        item := MainSession.ItemController.GetItem(j.jid);
        prompt := false; // auto-accept all
        if (incoming = PrefController.s10n_ask) then // auto-accept from none
            prompt := true
        else if (incoming = PrefController.s10n_auto_roster) then begin // auto-accept from roster
            if (item = nil) then
                prompt := true
            else begin
                subscr := item.value['Subscription'];

                if (subscr <> 'to') and (subscr <> 'both') then
                  prompt := true;
            end;
        end
        else if (incoming = s10n_auto_deny_all) then begin // auto-deny all
            SendUnsubscribed(j.jid, MainSession);
            exit;
        end;
//
        if (prompt) then
            MainSession.FireEvent('/session/gui/subscribe', tag)
        else begin
            if (item <> nil) then begin
                subscr := item.value['Subscription'];
                ask := item.value['Ask'];
            end;

//            if ((ritem = nil) or (ritem.subscription = 'none') or
//                (ritem.subscription = '')) then begin
//
//                // if we didn't ask for this subscription,
//                // then we should subscribe back to them
//                // if add_to_roster
//                if (((ritem = nil) or (ritem.ask <> 'subscribe')) and add_to_roster) then
//                    TAutoAddHandler.Create().addToRoster(j);
//            end;
            if ((subscr = '') or (ask <> 'subscribe') and add_to_roster) then
                TAutoAddHandler.Create().addToRoster(j);
            SendSubscribed(j.jid, MainSession);

        end;
    end;
    j.Free;
end;

{---------------------------------------}
procedure TSubController.Subscribed(event: string; tag: TXMLTag);
begin
    { From RFC 3921 Section 8.2:  Upon receiving the presence stanza of type "subscribed",
    the user SHOULD acknowledge receipt of that subscription state notification
    through either "affirming" it by sending a presence stanza of type
    "subscribe" to the contact or "denying" it by sending a presence stanza
    of type "unsubscribe" to the contact; this step does not necessarily
    affect the subscription state, but instead lets the user's server
    know that it MUST no longer send notification of the subscription
    state change to the user }

    SendSubscribe(tag.getAttribute('from'), MainSession);

end;

{---------------------------------------}
procedure TSubController.UnSubscribe(event: string; tag: TXMLTag);
begin
    // someone is removing us
    { From RFC 3921 Section 8.2:  Upon receiving the presence stanza of type "unsubscribe",
    the user SHOULD acknowledge receipt of that subscription state notification
    through either "affirming" it by sending a presence stanza of type
    "unsubscribed" to the contact or "denying" it by sending a presence stanza
    of type "subscribed" to the contact; this step does not necessarily
    affect the subscription state, but instead lets the user's server
    know that it MUST no longer send notification of the subscription
    state change to the user }

    //TODO:  alert user??
    SendUnSubscribed(tag.getAttribute('from'), MainSession);
end;

{---------------------------------------}
procedure TSubController.UnSubscribed(event: string; tag: TXMLTag);
var
    from: TJabberID;
    item: IExodusItem;
//    ritem: TJabberRosterItem;
    tstr: WideString;
begin
    { Todo:  Move this UI code out of jopl.  Perhaps throw a
             /session/gui/unsubscribed event and do it in GUIFactory? }

    // getting a s10n denial or someone is revoking us
    from := TJabberID.Create(tag.getAttribute('from'));
    tstr := DisplayName.getDisplayNameCache().getDisplayName(from) + ' (' + from.getDisplayJID + ')';
    item := MainSession.ItemController.GetItem(from.jid);

    if (item <> nil) then begin
        if (item.value['Ask'] = 'subscribe') then begin
            // we are got denied by this person
            MessageDlgW(WideFormat(sS10nDeny, [tstr]), mtInformation, [mbOK], 0);
        end
        else begin
            MessageDlgW(WideFormat(sS10nUnsub, [tstr]), mtInformation, [mbOK], 0);
        end;
        MainSession.ItemController.RemoveItem(item.UID);
    end;

    { From RFC 3921 Section 8.2:  Upon receiving the presence stanza of type "unsubscribed",
    the user SHOULD acknowledge receipt of that subscription state notification
    through either "affirming" it by sending a presence stanza of type
    "unsubscribe" to the contact or "denying" it by sending a presence stanza
    of type "subscribe" to the contact; this step does not necessarily
    affect the subscription state, but instead lets the user's server
    know that it MUST no longer send notification of the subscription
    state change to the user }
    SendUnSubscribe(from.full, MainSession);

    from.Free();
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure SendSubscribe(sjid: Widestring; Session: TJabberSession);
var
    p: TJabberPres;
    j: TJabberID;
begin
    p := TJabberPres.Create;
    j := TJabberID.Create(sjid);
    p.toJID := j;
    p.PresType := 'subscribe';
    Session.SendTag(p);
end;

{---------------------------------------}
procedure SendSubscribed(sjid: Widestring; Session: TJabberSession);
var
    p: TJabberPres;
    j: TJabberID;
begin
    p := TJabberPres.Create;
    j := TJabberID.Create(sjid);
    p.toJID := j;
    p.PresType := 'subscribed';
    Session.SendTag(p);
end;

{---------------------------------------}
procedure SendUnSubscribe(sjid: Widestring; Session: TJabberSession);
var
    p: TJabberPres;
    j: TJabberID;
begin
    p := TJabberPres.Create;
    j := TJabberID.Create(sjid);
    p.toJID := j;
    p.PresType := 'unsubscribe';
    Session.SendTag(p);
end;

{---------------------------------------}
procedure SendUnSubscribed(sjid: Widestring; Session: TJabberSession);
var
    p: TJabberPres;
    j: TJabberID;
begin
    p := TJabberPres.Create;
    j := TJabberID.Create(sjid);
    p.toJID := j;
    p.PresType := 'unsubscribed';
    Session.SendTag(p);
end;

{---------------------------------------}


end.
