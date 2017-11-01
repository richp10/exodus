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
unit Chat;


interface

uses
    {$ifdef linux}
    QForms,
    {$else}
    Forms,
    {$endif}
    ChatController, XMLTag,
    JabberID,
    SysUtils, Classes, Unicode;

type
    TJabberChatList = class(TWideStringList)
    private
        _s: TObject;
        _chatCB: integer;
        _chateventCB: integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetSession(s: TObject);

        function FindChat(barejid, sresource: widestring; sthread: Widestring = ''): TChatController;overload;
        function FindChat(cjid: TJabberID; sthread: widestring = ''): TChatController;overload;
        
        function AddChat(sjid, sresource: Widestring; anonymousChat: boolean): TChatController; overload;

        procedure MsgCallback(event: string; tag: TXMLTag);
        procedure PostChatEventCallback(event: string; tag: TXMLTag);
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Presence,
    XMLUtils,
    JabberConst, PrefController, Session,
    Room;

{---------------------------------------}
constructor TJabberChatList.Create;
begin
    inherited;
    _s := nil;
    _chatCB := -1;
    _chateventCB := -1;
end;

{---------------------------------------}
destructor TJabberChatList.Destroy;
var
    i: integer;
    c: TChatController;
begin
    if (_chateventCB <> -1) then
        MainSession.UnRegisterCallback(_chatCB);
    if (_chateventCB <> -1) then
        MainSession.UnRegisterCallback(_chateventCB);

    for i := Count - 1 downto 0 do begin
        c := TChatController(Self.Objects[i]);
        Delete(i);
        c.Free();
    end;

    inherited;
end;

{---------------------------------------}
procedure TJabberChatList.SetSession(s: TObject);
begin
    _s := s;
    _chatCB := TJabberSession(s).RegisterCallback(MsgCallback,'/post/message[@type="chat"]/body');
    _chateventCB := TJabberSession(s).RegisterCallback(PostChatEventCallback,'/post/message/*[@xmlns="' + XMLNS_XEVENT + '"]');
end;

{---------------------------------------}
procedure TJabberChatList.MsgCallback(event: string; tag: TXMLTag);
var
    tmp_jid: TJabberID;
    c: TChatController;
    ttag: TXMLTag;
//    isEvent: boolean;
begin
    // check to see if we have a session already open for
    // this jid, if not, create one.
{** JJF msgqueue refactor
    fjid := tag.getAttribute('from');
    mtype := tag.getAttribute('type');

    mt := MainSession.Prefs.getInt('msg_treatment');

    // pgm 2/29/04 - we should never get these packets anymore...
    // throw out any x-data msgs we get.. the xdata handler will pick them up.
    //if (tag.QueryXPTag(XP_MSGXDATA) <> nil) then exit;
    isEvent := (tag.QueryXPTag(XP_MSGXEVENT) <> nil);
    // we are only interested in packets w/ a body tag
    if (not isEvent and (tag.GetFirstTag('body') = nil)) then exit;
**}
    //don't start a chat if we receive empty body (TT 63680)
    ttag := tag.QueryXPTag('/message/body');
    if (Length(WideTrim(ttag.Data)) = 0) then exit;

    tmp_jid := TJabberID.Create(tag.getAttribute('from'));
    try
        // in the blocker list?
        if (TJabberSession(_s).IsBlocked(tmp_jid)) then exit;

{** JJF msgqueue refactor
        if (not isEvent) and (mtype <> 'chat') then begin
            if ((mt = msg_existing_chat) and (idx1 = -1) and (idx2 = -1)) then
                exit
            else if (mt = msg_normal)then
                exit;
        end;
**}

        //really should be nil here,
        //other chat messages handled in /packet dispatcher
        if (FindChat(tmp_jid) = nil) then
        begin
            // Create a new chat controller, anon if msg from room
            c := Self.AddChat(tmp_jid.jid, tmp_jid.resource, (FindRoom(tmp_jid.jid) <> nil));
            c.MsgCallback(event, tag);
        end;
    finally
        tmp_jid.Free();
    end;
end;

procedure TJabberChatList.PostChatEventCallback(event: string; tag: TXMLTag);
var
    tmp_jid: TJabberID;
    etag: TXMLTag;
    m: TXMLTag;
begin
    //should be no open chat to handle this message. If one were open it
    //would have handled this in the /packet dispatcher.
    tmp_jid := TJabberID.Create(tag.getAttribute('from'));
    try
        // in the blocker list?
        if (TJabberSession(_s).IsBlocked(tmp_jid)) then exit;

        if (FindChat(tmp_jid) <> nil) then exit;
{** JJF msqueue refactor
        // Create a new chat controller
        c := Self.AddChat(tmp_jid.jid, tmp_jid.resource, FindRoom(tmp_jid.jid) <> nil);
        c.MsgCallback(event, tag);
**}

        etag := tag.QueryXPTag(XP_MSGXEVENT);
        //ack delivered
        if (etag.GetFirstTag('id') = nil) and
           (etag.GetFirstTag('delivered') <> nil) then
        begin
            m := generateEventMsg(tag, 'delivered');
            TJabberSession(_s).SendTag(m);//m freed by SendTag
        end;
    finally
        tmp_jid.Free();
    end;
end;

function TJabberChatList.FindChat(barejid, sresource, sthread: widestring): TChatController;
var
    tstr: widestring;
    tjid: TJabberID;
begin
    tstr := barejid;
    if sresource <> '' then
        tstr := tstr + '/' + sresource;

    tjid := TJabberID.create(tstr);
    Result := FindChat(tjid, sthread);
    tjid.free();
end;

{---------------------------------------
    barejid chat == chat listeneing for message from foo@bar
    resource chat == chat listening for message from foo@bar/resource

    resource is specified
        return matching resource chat
        return barejid chat if no matching resource chat exists
        return nil if no barejid chat exists

    no resource specified
        return barejid chat
        return resource chat for first matching online resource (priority sorted) if barejid chat doesn't exist
        return resource chat session that matches barejid if no online reosurces have a chat.
        return nil if no chats exist
}
function TJabberChatList.FindChat(cjid: TJabberID; sthread: widestring): TChatController;
var
    i: integer;
    chatIdx: integer;
    p: TJabberPres;
    jid: TJabberID;
begin
    if (cjid.resource <> '') then
    begin
        chatIdx := indexOf(cjid.Full);
        if (chatIdx = -1) then
            chatIdx := indexOf(cjid.jid);
    end
    else begin //no resource specified
        chatIdx := indexOf(cjid.jid);
        p := MainSession.ppdb.FindPres(cjid.jid, '');
        while (chatIdx = -1) and (p <> nil) do
        begin
            chatIdx := indexOf(p.fromJid.full);
            p := MainSession.ppdb.NextPres(p);
        end;
        i := 0;
        while (chatIdx = -1) and (i < Self.Count) do
        begin
            jid := TJabberID.Create(Self.Get(i));
            if (jid.jid = cjid.jid) then
                chatIdx := i;
            inc(i);
            jid.Free;
        end;
    end;

    Result := nil;
    if (chatIdx <> -1) then
        Result := TChatController(Objects[chatIdx]);
end;

{---------------------------------------}
function TJabberChatList.AddChat(sjid, sresource: Widestring; anonymousChat: boolean): TChatController;
begin
    //
    try
        Result := TChatController.Create(sjid, sresource, anonymousChat);
        if (sresource = '') then
            Self.AddObject(sjid, Result)
        else
            Self.AddObject(sjid + '/' + sresource, Result);
    except
    end;
end;
end.

