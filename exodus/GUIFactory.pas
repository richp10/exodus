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
unit GUIFactory;


interface
uses
    XMLTag, Unicode, Exodus_TLB,
    Forms, Classes, SysUtils;

type
    TGUIFactory = class
    private
        _js: TObject;
        _cb: integer;
        _icb: integer;
        _blockers: TWidestringlist;
    protected
        procedure SessionCallback(event: string; tag: TXMLTag);
        procedure SessionItemCallback(event: string; item: IExodusItem);
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetSession(js: TObject);
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    RosterImages, PrefController,
    Room,
    Dialogs, GnuGetText, AutoUpdateStatus, Controls,
    InvalidRoster, ChatWin, JabberUtils, ExUtils,  Subscribe, Notify, Jabber1,
    JabberID, Session, JabberMsg, windows, DisplayName,
    ChatController, Presence, Stateform, COMExodusItem;

const
    sPrefWriteError = 'There was an error attempting to save your options. Another process may be accessing your options file. Some options may be lost. ';
    sNotifyChat = 'Chat with ';
    sPriorityNotifyChat = 'Priority Chat with ';
    sCannotOffline = 'This contact cannot receive offline messages.';

{---------------------------------------}
constructor TGUIFactory.Create();
begin
    _blockers := TWideStringList.Create();
end;

{---------------------------------------}
destructor TGUIFactory.Destroy();
begin
    _blockers.Free();
end;

{---------------------------------------}
procedure TGUIFactory.setSession(js: TObject);
var
    s: TJabberSession;
begin
    _js := js;
    s := TJabberSession(js);
    _cb := s.RegisterCallback(SessionCallback, '/session');
    _icb := s.RegisterCallback(SessionItemCallback, '/session');

    _blockers.Clear();
    s.Prefs.fillStringlist('blockers', _blockers);
end;

procedure TGUIFactory.SessionItemCallback(event: string; item: IExodusItem);
begin
  if (event = '/session/gui/conference') then begin
        getDockManager().ShowDockManagerWindow(true, false);

        StartRoom(item.uid,
                  item.value['nick'],
                  item.value['password'],
                  true,
                  false,
                  (item.value['reg_nick'] = 'true'));
    end
end;

{---------------------------------------}
procedure TGUIFactory.SessionCallback(event: string; tag: TXMLTag);
var
//    r,
    i: integer;
    sjid: Widestring;
    tmp_jid: TJabberID;
    chat: TfrmChat;
    sub: TfrmSubscribe;
    item: IExodusItem;
    msg: TJabberMessage;
    p: TJabberPres;
 //   ri: TJabberRosterItem;
 //   ir: TfrmInvalidRoster;
 //JJF msgqueue refactor
    c: TChatController;
//    e: TJabberEvent;
    itemList: IExodusItemList;
begin
    // check for various events to start GUIS
{** TODO : Roster refactor
    if (event = '/session/gui/conference-props') then begin
        ShowBookmark(tag.GetAttribute('jid'), tag.GetAttribute('name'));
    end
    else if (event = '/session/gui/conference-props-rename') then begin
        ShowBookmark(tag.GetAttribute('jid'), tag.GetAttribute('name'), true);
    end
  else if (event = '/session/gui/conference') then begin
**}
  if (event = '/session/gui/conference') then begin
        getDockManager().ShowDockManagerWindow(true, false);

        StartRoom(tag.GetAttribute('jid'),
                  tag.GetBasicText('nick'),
                  tag.GetBasicText('password'),
                  true,
                  false,
                  (tag.GetAttribute('reg_nick') = 'true'));
    end
    else if (event = '/session/gui/contact') then begin
        // new outgoing message/chat window
        tmp_jid := TJabberID.Create(tag.getAttribute('jid'));
        getDockManager().ShowDockManagerWindow(true, false);
        StartChat(tmp_jid.jid, tmp_jid.resource, true);
        tmp_jid.Free();
    end
    else if (event = '/session/gui/chat') then begin
        // New Chat Window
        tmp_jid := TJabberID.Create(tag.getAttribute('from'));
        try
            //bail if blocked
            if (MainSession.IsBlocked(tmp_jid)) then exit;
            //show window but don't bring it to front. Let notifications do that
            chat := StartChat(tmp_jid.jid, tmp_jid.resource, true, '', false);
            if (chat <> nil) then begin
                msg := TJabberMessage.Create(tag);
                if ((msg.Priority = high) and
                   (MainSession.Prefs.getInt('notify_priority_chatactivity') > 0))  then
                    DoNotify(chat, 'notify_priority_chatactivity',  GetDisplayPriority(Msg.Priority) + ' ' + _(sPriorityNotifyChat) +
                             chat.DisplayName, RosterTreeImages.Find('contact'))
                else
                    DoNotify(chat, 'notify_newchat', _(sNotifyChat) +
                             chat.DisplayName, RosterTreeImages.Find('contact'));
                FreeAndNil(msg);
            end;
        finally
            tmp_jid.Free;
        end;

{** JJF msgqueue refactor
        end;
**}
    end
    //this cannot be called now, windows are always created therefore
    else if (event = '/session/gui/update-chat') then begin
        tmp_jid := TJabberID.Create(tag.getAttribute('from'));
        c := MainSession.ChatList.FindChat(tmp_jid.jid, tmp_jid.resource, '');
        chat := nil;
        if (c <> nil) then
            chat := TfrmChat(c.Window);
        if (chat = nil) then
        begin
            chat := StartChat(tmp_jid.jid, tmp_jid.resource, true, '', false);
            if (chat <> nil) then
                DoNotify(chat, 'notify_newchat', _(sNotifyChat) + chat.DisplayName,
                         RosterTreeImages.Find('contact'));
        end;

    tmp_jid.Free;
    end
    else if (event = '/session/gui/no-inband-reg') then begin
        if (MainSession.Prefs.getBool('brand_show_in_band_registration_warning')) then begin
            if (MessageDlgW(_('This server does not advertise support for in-band registration. Try to register a new account anyway?'),
                mtError, [mbYes, mbNo], 0) = mrYes) then
                MainSession.CreateAccount()
            else
                MainSession.FireEvent('/session/error/reg', nil);
        end
        else
            MainSession.CreateAccount();
    end

    else if (event = '/session/gui/reg-not-supported') then begin
        MessageDlgW(_('Your authentication mechanism does not support registration.'),
            mtError, [mbOK], 0);
    end

    else if (event = '/session/error/presence') then begin
        // Presence errors
{** TODO : Roster refactor
** move to simplemessagedisplay?
        ri := MainSession.Roster.Find(tag.GetAttribute('from'));
        if ((ri <> nil) and
        MainSession.Prefs.getBool('roster_pres_errors')) then begin
            ir := getInvalidRoster();
            ir.AddPacket(tag);
        end;
**}
    end

    else if (event = '/session/error/prefs-write') then begin
        MessageDlgW(_(sPrefWriteError), mtError, [mbOK], 0);
    end

    else if (event = '/session/block') then begin
        _blockers.Add(tag.getAttribute('jid'));
    end

    else if (event = '/session/unblock') then begin
        i := _blockers.IndexOf(tag.getAttribute('jid'));
        if (i >= 0) then _blockers.Delete(i);
    end

    else if (event = '/session/gui/autoupdate') then begin
        ShowAutoUpdateStatus(tag.GetAttribute('url'));
    end

    else if (event = '/session/gui/subscribe') then begin
        // Subscription window
        sjid := tag.getAttribute('from');
        tmp_jid := TJabberID.Create(sjid);
        sjid := tmp_jid.getDisplayJID();

        item := MainSession.ItemController.GetItem(sjid);
        if (item <> nil) then begin
            if ((item.value['Subscription'] = 'from') or (item.value['Subscription'] = 'both')) then
                exit;
        end;

        // block list?
        // Don't use MainSession.IsBlocked since it also
        // blocks people not on my roster. Just check our sync'd blocker list.
        if (_blockers.IndexOf(tmp_jid.jid) >= 0) then begin
            // This contact is on our block list.
            // So, we will auto-deny the subscription request.
            p := TJabberPres.Create;
            p.toJID := TJabberID.Create(tmp_jid.jid);
            p.PresType := 'unsubscribed';

            MainSession.SendTag(p);
        end
        else begin
            sub := TfrmSubscribe.Create(Application);
            sub.setup(tmp_jid, item, tag);
        end;
        tmp_jid.Free();
    end
    else if (event = '/session/authenticated') then
    begin
        //fire off autocreate

        //re-load authed desktop
        TAutoOpenEventManager.onAutoOpenEvent('authed');

        //autojoin rooms
        itemList := MainSession.ItemController.GetItemsByType(EI_TYPE_ROOM);
        for i := 0 to itemList.Count - 1 do
        begin
            if (itemList.Item[i].value['autojoin'] = 'true') then
                //yay for single threaded, this is essentially a long function call lol
                mainSession.FireEvent('/session/gui/conference', itemList.Item[i]);
        end;
    end
    else if (event = '/session/prefs') then
    begin
        _blockers.Clear();
        TJabberSession(_js).Prefs.fillStringlist('blockers', _blockers);
    end;
end;


end.
