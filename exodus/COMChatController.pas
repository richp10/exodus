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
unit COMChatController;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Exodus_TLB,
    Session, ChatController, Chat, Room,
    Unicode, XMLTag,
    Windows, Classes, ComObj, ActiveX, StdVcl;

{
    JJF I'm a little unsure what to do here for the IM/broadcast refactor. It
    will still be neccessary for plugins to have events fired when a brodcast
    (normal) message is received, but not sure this is the place to do it.

    All code changed prefereced with "JJF TODO msgqueue refactor"
}
type
  TExodusChat = class(TAutoObject, IExodusChat, IExodusChat2, IExodusChat3)
  protected
    function Get_jid: WideString; safecall;
    function AddContextMenu(const caption: WideString; const menuListener: IExodusMenuListener): WideString; safecall;
    function Get_MsgOutText: WideString; safecall;
    function UnRegisterPlugin(ID: Integer): WordBool; safecall;
    function RegisterPlugin(const Plugin: IExodusChatPlugin): Integer;
      safecall;
    function getMagicInt(Part: ChatParts): Integer; safecall;
    procedure RemoveContextMenu(const ID: WideString); safecall;
    procedure AddMsgOut(const Value: WideString); safecall;
    function AddMsgOutMenu(const caption: WideString; const menuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveMsgOutMenu(const MenuID: WideString); safecall;
    procedure SendMessage(var Body: WideString; var Subject: WideString; var XML: WideString); safecall;
    function Get_CurrentThreadID: WideString; safecall;
    procedure DisplayMessage(const Body, Subject, From: WideString); safecall;
    procedure AddRoomUser(const JID, Nickname: WideString); safecall;
    procedure RemoveRoomUser(const JID: WideString); safecall;
    function Get_CurrentNick: WideString; safecall;
    function GetControl(const Name: WideString): IExodusControl; safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    procedure ChatCallback(event: string; tag: TXMLTag; controller: TChatController);

    // IExodusChat2
    function Get_DockToolbar: IExodusDockToolbar; safecall;
    function Get_MsgOutToolbar: IExodusMsgOutToolbar; safecall;

    // IExodusChat3
    procedure Close; safecall;
    procedure BringToFront; safecall;
    procedure Dock; safecall;
    procedure Float; safecall;
    function  AddRosterMenu (const caption: WideString; const menuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveRosterMenu(const MenuID: WideString); safecall;

    { Protected declarations }

  public
    constructor Create();
    destructor Destroy(); override;

//JJF TODO msgqueue refactor    procedure setIM(im: TfrmMsgRecv);
    procedure setRoom(room: TfrmRoom);
    procedure setChatSession(chat_session: TChatController);
    function  fireMsgKeyUp(key: Word; shift: TShiftState): boolean;
    function  fireMsgKeyDown(key: Word; shift: TShiftState): boolean;
    function  fireMsgKeyPress(var key: Widestring; Part: ChatParts): boolean;
    function  fireBeforeMsg(var body: Widestring): boolean;
    function  fireAfterMsg(var body: WideString): Widestring;
    function  fireBeforeRecvMsg(body, xml: Widestring): boolean;
    procedure fireAfterRecvMsg(body: Widestring);
    procedure fireMenuClick(Sender: TObject; xml: WideString = '');
    procedure fireNewWindow(new_hwnd: HWND);
    procedure fireClose();
    procedure fireSentMessageXML(tag: TXMLTag);
    function  fireChatEvent(Event: Widestring; oleVar: OleVariant ): boolean;
    procedure fireMenuShow(xml: WideString = '');

  private
    //JJF TODO msgqueue refactor _im: TfrmMsgRecv;
    _room: TfrmRoom;
    _chat: TChatController;
    _plugs: TList;
    _menu_items: TWidestringlist;
    _nextid: longint;
    _ccbId: Integer;
  end;

  TChatPlugin = class
    com: IExodusChatPlugin;
end;


implementation

uses
    COMExControls, ChatWin, Controls, BaseMsgList, RTFMsgList, Forms,
    ComServ, Menus, SysUtils, Debug, BaseChat, Dockable;

{---------------------------------------}
constructor TExodusChat.Create();
begin
    inherited Create();
    _plugs := TList.Create();
    _menu_items := TWidestringlist.Create();
    _nextid := 0;
end;

{---------------------------------------}
destructor TExodusChat.Destroy();
var
    i: integer;
    p: TChatPlugin;
begin
    // free all of our plugin proxies
    DebugMessage('calling plugin OnClose event for ' + inttostr(_plugs.Count) + ' plugin');

    for i := _plugs.Count - 1 downto 0 do begin
        DebugMessage('calling plugin OnClose event, #' + inttostr(i));
        p :=TChatPlugin(_plugs[i]);
        try
            p.com.onClose();
        except
            On E:Exception do begin
                DebugMessage('Exception while processing plugin.onClose events in TExodusChat.Destroy (' + E.message + ')');
                continue;
            end;
        end;
        DebugMessage('done calling plugin OnClose event, #' + inttostr(i));
    end;

    // free all of our plugin menu items
    for i := 0 to _menu_items.Count - 1 do
        TMenuItem(_menu_items.Objects[i]).Free();
    _menu_items.Clear();
    _menu_items.Free();


    _plugs.Clear();
    _plugs.Free();

    inherited Destroy();
end;
{ JJF TODO msgqueue refactor
procedure TExodusChat.setIM(im: TfrmMsgRecv);
begin
    _im := im;
    _room := nil;
    _chat := nil;
end;
}
{---------------------------------------}
procedure TExodusChat.setChatSession(chat_session: TChatController);
begin
//JJF TODO msgqueue refactor    _im   := nil;
    _room := nil;
    _chat := chat_session;
end;

{---------------------------------------}
procedure TExodusChat.setRoom(room: TfrmRoom);
begin
//JJF TODO msgqueue refactor  _im   := nil;
  _chat := nil;
  _room := room;
end;

{---------------------------------------}
function TExodusChat.fireMsgKeyUp(key: Word; shift: TShiftState): boolean;
var
    i, s: integer;
begin
    Result := false;

    s := 0;
    if (ssShift in shift) then
        s := s or windows.MOD_SHIFT;

    if (ssAlt in shift) then
        s := s or windows.MOD_ALT;

    if (ssCtrl in shift) then
        s := s or windows.MOD_CONTROL;

    for i := 0 to _plugs.Count - 1 do begin
        try
            Result := TChatPlugin(_plugs[i]).com.OnKeyUp(key, s);
            if (Result = true) then exit;
        except
            DebugMessage('COM Exception in TExodusChat.fireMsgKeyUp');
        end;
    end;

end;

{---------------------------------------}
function TExodusChat.fireMsgKeyDown(key: Word; shift: TShiftState): boolean;
var
    i, s: integer;
begin
    Result := false;
    s := 0;
    if (ssShift in shift) then
        s := s or windows.MOD_SHIFT;

    if (ssAlt in shift) then
        s := s or windows.MOD_ALT;

    if (ssCtrl in shift) then
        s := s or windows.MOD_CONTROL;

    for i := 0 to _plugs.Count - 1 do begin
        try
            Result := TChatPlugin(_plugs[i]).com.OnKeyDown(key, s);
            if (Result = true) then exit;
        except
            DebugMessage('COM Exception in TExodusChat.fireMsgKeyDown');
        end;
    end;

end;

{---------------------------------------}
function  TExodusChat.fireMsgKeyPress(var Key: Widestring; Part: ChatParts): boolean;
var
    i: integer;
    chatplugin2: IExodusChatPlugin2;
begin
    Result := false;

    for i := 0 to _plugs.Count - 1 do begin
        try
            chatplugin2 := TChatPlugin(_plugs[i]).com as IExodusChatPlugin2;
            try
                if (chatplugin2 <> nil) then
                begin
                    Result := chatplugin2.OnKeyPress(Key, Part);
                    if (Result = true) then exit;
                end;
            except
                // Problem firing OnKeyPress event chat plugin
                DebugMessage('COM Exception in TExodusChat.fireMsgKeyPress');
            end;
        except
            DebugMessage('COM Exception in TExodusChat.fireMsgKeyPress');
        end;
    end;

end;

{---------------------------------------}
function TExodusChat.fireBeforeMsg(var body: Widestring): boolean;
var
    i: integer;
begin
    Result := true;
    for i := 0 to _plugs.Count - 1 do begin
        try
            Result := TChatPlugin(_plugs[i]).com.onBeforeMessage(body);
            if (Result = false) then exit;
        except
            DebugMessage('COM Exception in TExodusChat.fireBeforeMsg');
        end;
    end;
end;

{---------------------------------------}
function TExodusChat.fireAfterMsg(var body: WideString): Widestring;
var
    i: integer;
    buff: Widestring;
begin
    buff := '';
    for i := 0 to _plugs.Count - 1 do begin
        try
            buff := buff + TChatPlugin(_plugs[i]).com.onAfterMessage(body);
        except
            DebugMessage('COM Exception in TExodusChat.fireAfterMsg');
        end;
    end;

    Result := buff;
end;

{---------------------------------------}
procedure TExodusChat.fireSentMessageXML(tag: TXMLTag);
var
    i: integer;
    chatplugin2: IExodusChatPlugin2;
begin
    for i := 0 to _plugs.Count - 1 do begin
        try
            chatplugin2 := TChatPlugin(_plugs[i]).com as IExodusChatPlugin2;
            try
                if (chatplugin2 <> nil) then
                begin
                    chatplugin2.OnSentMessageXML(tag.xml());
                end;
            except
                // Problem sending XML msg to chat plugin
                DebugMessage('COM Exception in TExodusChat.fireSentMessageXML');
            end;
        except
            on e:Exception do
            begin
                // If e is a EIntfCastError, that is ok, just eat.
                if (not (e is EIntfCastError)) then
                begin
                    // Not a EIntfCastError so note exception.
                    DebugMessage('COM Exception in TExodusChat.fireSentMessageXML');
                end;
            end;
        end;
    end;
end;


{---------------------------------------}
function TExodusChat.fireChatEvent(Event: Widestring; oleVar: OleVariant ): boolean;
var
    i: integer;
    chatplugin2: IExodusChatPlugin2;
begin
    Result := false;
    for i := 0 to _plugs.Count - 1 do begin
        try
            chatplugin2 := TChatPlugin(_plugs[i]).com as IExodusChatPlugin2;
            try
                if (chatplugin2 <> nil) then
                begin
                    Result := chatplugin2.OnChatEvent(Event, oleVar);
                    if (Result) then break;
                end;
            except
                // Problem sending XML msg to chat plugin
                DebugMessage('COM Exception in TExodusChat.fireDragAndDrop');
            end;
        except
            // Not a IExodusChat2 plugin - eat error
        end;
    end;
end;

{---------------------------------------}
procedure TExodusChat.fireMenuShow(xml: WideString = '');
var
    i: integer;
    Listener : IExodusMenuListener2;
    Enabled: WordBool;
begin
    Enabled := true;

    for i := 0 to _menu_items.Count - 1 do
    begin
        Listener := nil;
        try
            //fire event on one menu listener2
            Listener := IUnknown(TMenuItem(_menu_items.Objects[i]).Tag) as IExodusMenuListener2;
        except
            DebugMessage('COM Exception in TExodusChat.fireMenuShow');
        end;
        if (Listener <> nil) then
        begin
               Listener.OnMenuItemShow(_menu_items[i], xml, Enabled);
               TMenuItem(_menu_items.Objects[i]).Enabled := Enabled;
               if (not Enabled) then
                   break;
        end;
    end;
end;

{---------------------------------------}
function TExodusChat.fireBeforeRecvMsg(body, xml: Widestring): boolean;
var
    i: integer;
begin
    Result := True;
    for i := 0 to _plugs.Count - 1 do begin
        try
            Result := TChatPlugin(_plugs[i]).com.OnBeforeRecvMessage(body, xml);
            if (Result = false) then exit;
        except
            DebugMessage('COM Exception in TExodusChat.fireBeforeRecvMsg');
        end;
    end;
end;

{---------------------------------------}
procedure TExodusChat.fireAfterRecvMsg(body: Widestring);
var
    i: integer;
begin
    for i := 0 to _plugs.Count - 1 do begin
        try
            TChatPlugin(_plugs[i]).com.OnAfterRecvMessage(body);
        except
            DebugMessage('COM Exception in TExodusChat.fireAfterRecvMsg');
        end;
    end;
end;

{---------------------------------------}
procedure TExodusChat.fireNewWindow(new_hwnd: HWND);
var
    i: integer;
begin
    for i := 0 to _plugs.Count - 1 do begin
        try
            TChatPlugin(_plugs[i]).com.OnNewWindow(new_hwnd);
        except
            DebugMessage('COM Exception in TExodusChat.fireNewWindow');
        end;
    end;
end;

{---------------------------------------}
procedure TExodusChat.fireClose();
var
    i: integer;
begin
    for i := _plugs.Count - 1 downto 0 do begin
        try
            TChatPlugin(_plugs[i]).com.onClose();
        except
            DebugMessage('COM Exception in TExodusChat.fireClose');
        end;
    end;
end;

{---------------------------------------}
procedure TExodusChat.fireMenuClick(Sender: TObject; xml: WideString = '');
var
    idx : Integer;
{$IFDEF OLD_MENU_EVENTS}
    i: integer;
{$ELSE}
    mListener : IExodusMenuListener;
{$ENDIF}
begin
    idx := _menu_items.IndexOfObject(Sender);
    if (idx >= 0) then begin
{$IFDEF OLD_MENU_EVENTS}
        for i := 0 to _plugs.Count - 1 do begin
            try
                TChatPlugin(_plugs[i]).com.onMenu(_menu_items[idx]);
            except
                DebugMessage('COM Exception in TExodusChat.fireMenuClick');
            end;
        end;
{$ELSE}
        //fire event on one menu listener
        mListener := IExodusMenuListener(TMenuItem(_menu_items.Objects[idx]).Tag);
        if (mListener <> nil) then
            mListener.OnMenuItemClick(_menu_items[idx], xml);
{$ENDIF}
    end;
end;

{---------------------------------------}
function TExodusChat.Get_jid: WideString;
begin
    Result := '';
    if (_chat <> nil) then Result := _chat.BareJID
//JJF TODO msgqueue refactor    else if (_im <> nil) then Result := _im.JID
    else if (_room <> nil) then Result := _room.getJid;
end;

{---------------------------------------}
function TExodusChat.AddContextMenu(const Caption: WideString; const menuListener: IExodusMenuListener): WideString;
var
    id: Widestring;
    mi: TMenuItem;
    idx: integer;
begin
    // add a new TMenuItem to the Plugins menu
    inc(_nextid);
    idx := _nextid;
    id := 'plugin_' + IntToStr(idx);

    if (_room <> nil) then begin
        mi := TMenuItem.Create(_room);
        mi.Name := id;
        mi.OnClick := _room.pluginMenuClick;
        mi.Caption := caption;
        mi.Tag := Integer(menuListener);
        _room.popRoom.Items.Add(mi);
    end
    else if (_chat <> nil) then begin
        mi := TMenuItem.Create(TfrmChat(_chat.window));
        mi.Name := id;
        mi.OnClick := TfrmChat(_chat.window).pluginMenuClick;
        mi.Caption := caption;
        mi.Tag := Integer(menuListener);
        TfrmChat(_chat.window).popContact.Items.Add(mi);
    end
    {JJF TODO msgqueue refactor
    else if (_im <> nil) then begin
        mi := TMenuItem.Create(_im);
        mi.Name := id;
        mi.OnClick := _im.pluginMenuClick;
        mi.Caption := caption;
        mi.Tag := Integer(menuListener);
        _im.popContact.Items.Add(mi);
    end
    }
    else
        exit;

    _menu_items.AddObject(id, mi);
    Result := id;
end;

{---------------------------------------}
function TExodusChat.AddMsgOutMenu(const Caption: WideString; const menuListener: IExodusMenuListener): WideString;
var
    id: Widestring;
    mi: TMenuItem;
begin
    // add a new TMenuItem to the Plugins menu
    id := 'plugin_' + IntToStr(_menu_items.Count);
    if (_room <> nil) then begin
        mi := TMenuItem.Create(_room);
        mi.Name := id;
        mi.OnClick := _room.pluginMenuClick;
        mi.Caption := caption;
        mi.Tag := Integer(menuListener);
        _room.popOut.Items.Add(mi);
    end
    else if (_chat <> nil) then begin
        mi := TMenuItem.Create(TfrmChat(_chat.window));
        mi.Name := id;
        mi.OnClick := TfrmChat(_chat.window).pluginMenuClick;
        mi.Caption := caption;
        mi.Tag := Integer(menuListener);
        TfrmChat(_chat.window).popOut.Items.Add(mi);
    end
    {JJF TODO msgqueue refactor
    else if (_im <> nil) then begin
        mi := TMenuItem.Create(_im);
        mi.Name := id;
        mi.OnClick := _im.pluginMenuClick;
        mi.Caption := caption;
        mi.Tag := Integer(menuListener);
        _im.popClipboard.Items.Add(mi);
    end
    }
    else
        exit;

    _menu_items.AddObject(id, mi);
    Result := id;
end;

{---------------------------------------}
procedure TExodusChat.RemoveContextMenu(const ID: WideString);
var
    idx: integer;
    mi: TMenuItem;
begin
    // remove this menu item.
    idx := _menu_items.indexOf(ID);
    if (idx < 0) then exit;
    mi := TMenuItem(_menu_items.Objects[idx]);
    _menu_items.Delete(idx);
    mi.Tag := 0;
    mi.Free();
end;

{---------------------------------------}
procedure TExodusChat.RemoveMsgOutMenu(const MenuID: WideString);
begin
    // remove this menu item.
    RemoveContextMenu(MenuID);
end;

{---------------------------------------}
function TExodusChat.Get_MsgOutText: WideString;
begin
    if (_chat <> nil) then
        Result := TfrmChat(_chat.window).MsgOut.Text
    else if (_room <> nil) then
        Result := _room.MsgOut.Text
{JJF TODO msgqueue refactor
    else if (_im <> nil) then
        Result := _im.MsgOut.Text;
}
end;

{---------------------------------------}
function TExodusChat.UnRegisterPlugin(ID: Integer): WordBool;
var
    cp: TChatPlugin;
begin
    if ((id >= 0) and (id < _plugs.count)) then begin
        cp := TChatPlugin(_plugs[id]);
        _plugs.Delete(id);
        cp.Free();
        Result := true;
    end
    else
        Result := false;

    if _plugs.Count = 0 then
        MainSession.UnregisterCallback(_ccbId);
end;

{---------------------------------------}
function TExodusChat.RegisterPlugin(
  const Plugin: IExodusChatPlugin): Integer;
var
    cp: TChatPlugin;
begin
    cp := TChatPlugin.Create;
    cp.com := Plugin;
    Result := _plugs.Add(cp);
    if _plugs.Count = 1 then
        _ccbId := MainSession.RegisterCallback(ChatCallback);

    if (_chat <> nil ) and (_chat.Window <> nil) then
        fireNewWindow(TForm(_chat.Window).Handle );

    if ( _room <> nil ) then
        fireNewWindow(_room.Handle);
end;

{---------------------------------------}
procedure TExodusChat.ChatCallback(event: string; tag: TXMLTag; controller: TChatController);
begin
    if controller <> _chat then
        exit;

    if event = '/chat/window' then begin
         fireNewWindow(StrToInt(tag.GetAttribute('handle')));
    end;
end;

{---------------------------------------}
function TExodusChat.getMagicInt(Part: ChatParts): Integer;
var
    p: Pointer;
begin
    Result := -1;
    case Part of
    HWND_MsgInput: begin
        if (_chat <> nil) then
            Result := TfrmChat(_chat.window).MsgOut.Handle
        else if (_room <> nil) then
            Result := _room.MsgOut.Handle
{JJF TODO msgqueue refactor
        else if (_im <> nil) then
            Result := _im.MsgOut.Handle
}
        else exit;
    end;
    HWND_MsgOutput: begin
        if (_chat <> nil) then
            Result := TfrmChat(_chat.window).MsgList.getHandle()
        else if (_room <> nil) then
            //Result := _room.MsgList.getHandle()
            if (_room.MsgList is TfRTFMsgList) then
               Result := TfRTFMsgList(_room.MsgList).MsgList.Handle
            else
               Result := -1
{JJF TODO msgqueue refactor
        else if (_im <> nil) then
            Result := _im.txtMsg.Handle
}
        else exit;
    end;
    Ptr_MsgInput: begin
        if (_chat <> nil) then begin
            p := @(TfrmChat(_chat.window).MsgOut);
            Result := integer(p);
        end
        else if (_room <> nil) then begin
            p := @(_room.MsgOut);
            Result := integer(p);
        end
{JJF TODO msgqueue refactor
        else if (_im <> nil) then begin
            p := @(_im.MsgOut);
            Result := integer(p);
        end;
}
    end;
    Ptr_MsgOutput: begin
        if (_chat <> nil) then begin
            // If we have an RTF msg list, use that
            if (TfrmChat(_chat.window).MsgList is TfRTFMsgList) then begin
                p := @(TfRTFMsgList(TfrmChat(_chat.window).MsgList).MsgList);
                Result := integer(p);
            end
            else
                Result := -1;
        end
        else if (_room <> nil) then begin
            if (_room.MsgList is TfRTFMsgList) then begin
                p := @(TfRTFMsgList(_room.MsgList).MsgList);
                Result := integer(p);
            end
            else
                Result := -1;
        end
{JJF TODO msgqueue refactor
        else if (_im <> nil) then begin
            p := @(_im.txtMsg);
            Result := integer(p);
        end;
}
    end;
    end;

end;

{---------------------------------------}
procedure TExodusChat.AddMsgOut(const Value: WideString);
begin
    // add something to the RichEdit control
    if (_chat <> nil) then
        TfrmChat(_chat.window).MsgOut.WideLines.Add(Value)
    else if (_room <> nil) then
        _room.MsgOut.WideLines.Add(Value)
{JJF TODO msgqueue refactor
    else if (_im <> nil) then
        _im.txtMsg.WideLines.Add(Value);
}        
end;

{---------------------------------------}
procedure TExodusChat.SendMessage(var Body: WideString; var Subject: WideString;
    var XML: WideString);
begin
    // spin up a message and send it..
    if (_chat <> nil) then
        TfrmChat(_chat.window).SendRawMessage(Body, Subject, XML, false)
    else if (_room <> nil) then
        _room.SendRawMessage(Body, Subject, XML, false);
end;

{---------------------------------------}
function TExodusChat.Get_CurrentThreadID: WideString;
begin
    //
    if (_chat <> nil) then
        Result := TfrmChat(_chat.window).GetThread()
    else
        Result := '';
end;

{---------------------------------------}
procedure TExodusChat.DisplayMessage(const Body, Subject,
  From: WideString);
var
    tag: TXMLTag;
begin
    tag := TXMLTag.Create('message');
    tag.setAttribute('from', from);
    if (Body <> '') then
        tag.AddBasicTag('body', Body);
    if (Subject <> '') then
        tag.AddBasicTag('subject', Subject);

    if (_chat <> nil) then
        TfrmChat(_chat.window).showMsg(tag)
    else if (_room <> nil) then
        _room.ShowMsg(tag);

    tag.Free();
end;

{---------------------------------------}
procedure TExodusChat.AddRoomUser(const JID, Nickname: WideString);
begin
    if (_room <> nil) then
        _room.addRoomUser(JID, Nickname);
end;

{---------------------------------------}
procedure TExodusChat.RemoveRoomUser(const JID: WideString);
begin
    if (_room <> nil) then
        _room.removeRoomUser(Jid);
end;

{---------------------------------------}
function TExodusChat.Get_CurrentNick: WideString;
begin
    if (_room <> nil) then
        Result := _room.myNick;
end;

function FindComponentNested(ARoot: TComponent; const AName: WideString): TComponent;
{Finding a component in an owner tree}
var
  i: Integer;
begin
  Result := ARoot.FindComponent(AName);
  if Result <> nil then exit;
  for i := 0 to ARoot.ComponentCount - 1 do  begin
    Result := FindComponentNested(ARoot.Components[i], AName);
    if Result <> nil then exit;
  end;
end;

{---------------------------------------}
function TExodusChat.GetControl(const Name: WideString): IExodusControl;
var
    c : TComponent;
begin
    try
        if (_chat <> nil) then
            c := TComponent(_chat.Window)
        else // JJF TODO msgqueue refactor if (_room <> nil) then
            c := _room;
{JJF TODO msgqueue refactor
        else //if (_im <> nil) then
            c := _im;
}            
        //see if the control we want is actually the form
        if SameText(c.Name, Name) then
            Result := getCOMControl(c)
        else
            result := getCOMControl(FindComponentNested(c, Name))
    except
        on EComponentError do
            Result := nil;
    end;
end;

{---------------------------------------}
function TExodusChat.Get_Caption: WideString;
begin
    if (_chat <> nil) then
        Result := TfrmChat(_chat.Window).Caption
    else if (_room <> nil) then
        Result := _room.Caption
    else
        Result := '';
end;

{---------------------------------------}
procedure TExodusChat.Set_Caption(const Value: WideString);
begin
    if (_chat <> nil) then
        TfrmChat(_chat.Window).Caption := Value
    else if (_room <> nil) then
        _room.Caption := Value;
end;

{---------------------------------------}
function TExodusChat.Get_DockToolbar: IExodusDockToolbar;
begin
    Result := nil;
    if (_chat <> nil) and (_chat.Window <> nil) then
        Result := TfrmDockable(_chat.Window).Dockbar
    else if (_room <> nil) then
        Result := _room.Dockbar;
end;

{---------------------------------------}
function TExodusChat.Get_MsgOutToolbar: IExodusMsgOutToolbar;
begin
    Result := nil;
    if (_chat <> nil) and (_chat.Window <> nil) then
        Result := TfrmChat(_chat.Window).MsgOutToolbar
    else if (_room <> nil) then
        Result := _room.MsgOutToolbar;
end;

{---------------------------------------}
procedure TExodusChat.Close;
begin
    if ((_chat <> nil) and (_chat.window <> nil))then
    begin
        TfrmChat(_chat.window).Close();
    end
    else if (_room <> nil) then
    begin
        _room.Close();
    end;
end;

{---------------------------------------}
procedure TExodusChat.BringToFront;
begin
    if ((_chat <> nil) and (_chat.window <> nil)) then
    begin
        TfrmChat(_chat.window).ShowDefault();
    end
    else if (_room <> nil) then
    begin
        _room.ShowDefault();
    end;
end;

{---------------------------------------}
procedure TExodusChat.Dock;
begin
    if ((_chat <> nil) and (_chat.window <> nil)) then
    begin
        if (not TfrmChat(_chat.window).Docked) then
        begin
            TfrmChat(_chat.window).DockForm();
        end;
    end
    else if (_room <> nil) then
    begin
        if (not _room.Docked) then
        begin
            _room.DockForm();
        end;
    end;
end;

{---------------------------------------}
procedure TExodusChat.Float;
begin
    if ((_chat <> nil) and (_chat.window <> nil)) then
    begin
        if (TfrmChat(_chat.window).Docked) then
        begin
            TfrmChat(_chat.window).FloatForm();
        end;
    end
    else if (_room <> nil) then
    begin
        if (_room.Docked) then
        begin
            _room.FloatForm();
        end;
    end;
end;

{---------------------------------------}
function  TExodusChat.AddRosterMenu (const caption: WideString; const menuListener: IExodusMenuListener): WideString; safecall;
var
    id: Widestring;
    mi: TMenuItem;
    idx: Integer;
begin
    // add a new TMenuItem to the Plugins menu
    inc(_nextid);
    idx := _nextid;

    id := 'plugin_' + IntToStr(idx);
    if (_room <> nil) then begin
        mi := TMenuItem.Create(_room);
        mi.Name := id;
        mi.OnClick := _room.popupMenuClick;
        mi.Caption := caption;
        mi.Tag := Integer(menuListener);
        _room.popRoomRoster.Items.Add(mi);
    end;
    _menu_items.AddObject(id, mi);
    Result := id;
end;


{---------------------------------------}
procedure TExodusChat.RemoveRosterMenu(const MenuID: WideString);
var
    idx: integer;
    mi: TMenuItem;
begin
    // remove this menu item.
    idx := _menu_items.indexOf(MenuID);
    if (idx < 0) then exit;
    mi := TMenuItem(_menu_items.Objects[idx]);
    _menu_items.Delete(idx);
    mi.Tag := 0;
    mi.Free();
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusChat, Class_ExodusChat,
    ciMultiInstance, tmApartment);

end.
