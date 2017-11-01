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
unit ChatWin;

interface

uses
    Avatar, Chat, ChatController, COMChatController, JabberID, XMLTag, IQ, Unicode, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, BaseChat, ExtCtrls, StdCtrls, Menus, ComCtrls, ExRichEdit, RichEdit2,
    RichEdit, TntStdCtrls, Buttons, TntMenus, FloatingImage, TntComCtrls, Exodus_TLB,
    DisplayName,
  ToolWin, ImgList, JabberMsg, AppEvnts,
  ExActions, ExActionCtrl, TntExtCtrls;

type
  {
    Action implementation to start chats with a given contact(s)
  }
  TStartChatAction = class(TExBaseAction)
  private
    constructor Create;
  public
    procedure execute(const items: IExodusItemList); override;
  end;

  TfrmChat = class(TfrmBaseChat)
    popContact: TTntPopupMenu;
    SaveDialog1: TSaveDialog;
    timBusy: TTimer;
    mnuWordwrap: TTntMenuItem;
    mnuReturns: TTntMenuItem;
    mnuOnTop: TTntMenuItem;
    N1: TTntMenuItem;
    mnuBlock: TTntMenuItem;
    mnuProperties: TTntMenuItem;
    popAddContact: TTntMenuItem;
    mnuSendFile: TTntMenuItem;
    N4: TTntMenuItem;
    popResources: TTntMenuItem;
    N5: TTntMenuItem;
    popClearHistory: TTntMenuItem;
    mnuHistory: TTntMenuItem;
    mnuSave: TTntMenuItem;
    PrintHistory1: TTntMenuItem;
    PrintDialog1: TPrintDialog;
    pnlJID: TPanel;
    lblNick: TTntLabel;
    Panel3: TPanel;
    Print1: TTntMenuItem;
    mnuViewHistory: TTntMenuItem;
    imgAvatar: TImage;
    
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure doHistory(Sender: TObject);
    procedure doProfile(Sender: TObject);
    procedure doAddToRoster(Sender: TObject);
    procedure lblJIDClick(Sender: TObject);
    procedure mnuReturnsClick(Sender: TObject);
    procedure mnuSendFileClick(Sender: TObject);
    procedure MsgOutChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuBlockClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure mnuOnTopClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
//    procedure btnCloseClick(Sender: TObject);
    procedure popClearHistoryClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuWordwrapClick(Sender: TObject);
//    procedure btnCloseMouseDown(Sender: TObject; Button: TMouseButton;
//      Shift: TShiftState; X, Y: Integer);
    procedure timBusyTimer(Sender: TObject);
    procedure popResourcesClick(Sender: TObject);
    procedure imgAvatarPaint(Sender: TObject);
    procedure imgAvatarClick(Sender: TObject);
    procedure PrintHistory1Click(Sender: TObject);
    procedure MsgOutKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MsgOutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MsgOutKeyPress(Sender: TObject; var Key: Char);
    procedure Print1Click(Sender: TObject);
    procedure MsgOutOnEnter(Sender: TObject);
    procedure mnuViewHistoryClick(Sender: TObject);
  private
    { Private declarations }
    jid: widestring;        // jid of the person we are talking to
    _jid: TJabberID;        // JID object of jid
    _pcallback: integer;    // Presence Callback
    _spcallback: integer;  // Self Presence Callback - for chats via a room
    _scallback: integer;    // Session callback
    _itemcallback: integer; // item callback
    _msg_out: boolean;
    _res_menus: TWidestringlist;

    // Stuff for composing events
    _flash_ticks: integer;

    _reply_id: string;
    _send_composing: boolean;
    _sent_composing: boolean;
    _warn_busyclose: boolean;

    _isRoom:  boolean;      // true if this is a muc chat - a chat via a room

    // the current contact's avatar
    _avatar: TAvatar;
    _unknown_avatar: TBitmap;

    // Stash away the status
    _status: Widestring;
    _show: Widestring;

    //received a message with an xhtml-im element. This allows us to implement
    //option JEP-71 requirement for xhmtl-im support discovery.
    _receivedXIMNode: boolean; //true if we have received a xhtml-im message
    _receivedMessage: boolean; //true if we have received at least one message
    _supportsXIM: boolean;     //true if caps advertises support

    _dnListener: TDisplayNameEventListener;

    //_dnLocked: boolean; //can the display name be changed? true if nick was passed
                        //into factory method
    _displayName: WideString;
    _insertTab: boolean; // Should a tab insert a tab?

    _anonymousChat: boolean; // Is this chat one started from an annonymous room.

    procedure SetupPrefs();
    procedure SetupMenus();
    procedure ChangePresImage(item: IExodusItem; show: widestring; status: widestring);
    procedure freeChatObject();
    function  _sendMsg(txt: Widestring; xml: Widestring = ''; priority: PriorityType = None): boolean;
    procedure _sendComposing(id: Widestring);
    function isToXIMEnabled(tag: TXMLTag): boolean; //is the to of this message xhtml-im enabled?
  protected
    btnViewHistory: TToolButton;
    {
        Get the window state associated with this window.

        Default implementation is to return a munged classname (all XML illgal
        characters escaped). Classes should override to change pref (for instance
        chat windows might save based on munged profile&jid).
    }
    function GetWindowStateKey() : WideString;override;

    procedure updateDisplayName();

    procedure updatePresenceImage();

    procedure OnPersistedMessage(msg: TXMLTag);override;
    function GetChatController(): TObject; override;
  public
    { Public declarations }
    chat_object: TChatController;
    com_controller: TExodusChat;

    procedure PlayQueue();
    procedure MessageEvent(tag: TXMLTag);
    procedure SendMessageEvent(tag: TXMLTag);
    procedure showMsg(tag: TXMLTag);
    procedure showPres(tag: TXMLTag);
    procedure handleMUCPresence(tag: TXMLTag);
    procedure SetupResources();
    procedure SendRawMessage(body, subject, xml: Widestring; fire_plugins: boolean; priority: PriorityType = None);

    procedure SendMsg; override;
    procedure  SetJID(cjid: widestring);
    //procedure AcceptFiles( var msg : TWMDropFiles ); message WM_DROPFILES;
    
    procedure OnDockedDragOver(Sender, Source: TObject; X, Y: Integer;
                               State: TDragState; var Accept: Boolean);override;
    procedure OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer);override;

   {
        Event fired when docking is complete.

        Docked property will be true, tabsheet will be assigned. This event
        is fired after all other docking events are complete.
    }
    procedure OnDocked();override;

    {
        Event fired when a float (undock) is complete.

        Docked property will be false, tabsheet will be nil. This event
        is fired after all other floating events are complete.
    }
    procedure OnFloat();override;

    function GetThread: Widestring;

    procedure pluginMenuClick(Sender: TObject); override;

    procedure PresCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure ItemCallback(event: string; item: IExodusItem);
    class procedure AutoOpenFactory(autoOpenInfo: TXMLTag); override;
    function GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;override;
    procedure OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
    
    property DisplayName: WideString read _displayName;
    property getJid: Widestring read jid;
    property anonymousChat: boolean read _anonymousChat write _anonymousChat;
  end;

var
  frmChat: TfrmChat;

//Find or create a chat controller/window for the jid/resource
//show_window = false -> window is not displayed, true->window displayed
//bring_to_front = true -> window brought to top of zorder and takes focus
function StartChat(sjid, resource: widestring;
                   show_window: boolean;
                   chat_nick: widestring='';
                   bring_to_front:boolean=true): TfrmChat;

procedure CloseAllChats;
procedure RegisterActions;

implementation
uses
    CapPresence, RosterImages, PrtRichEdit, RTFMsgList, BaseMsgList,
    CustomNotify, Debug, 
    JabberConst, ExSession, JabberUtils, ExUtils,  Presence, PrefController, Room,
    XferManager, RosterAdd, RiserWindow, Notify,
    Jabber1, Profile, MsgDisplay, GnuGetText,
    ContactController, Session, XMLUtils,
    ShellAPI, RosterForm, Emoticons,
    Entity, AvatarCache,
    XMLParser,
    RT_XIMConversion,
    EntityCache,
    IEMsgList,
    DebugManager,
    TypInfo, Dockable, ActiveX,
    HistorySearch, ActivityWindow,
    TntSysUtils;

const
    sReplying = ' is replying.';
    sChatActivity = 'Chat Activity: ';
    sPriorityChatActivity = 'Priority Chat Activity: ';
    sUserBlocked = 'This user is now blocked.';
    sIsNow = 'is now';
    sAvailable = 'available';
    sOffline = 'offline';
    sUnavailable = 'unavailable';
    sCloseBusy = 'This chat window is busy. Close anyway?';
    sChat = 'Chat';
    sAlreadySubscribed = 'You are already subscribed to this contact';
    sMsgLocalTime = 'Local Time: ';
    sCannotOffline = 'This contact cannot receive offline messages.';
    sCannotStartChatWithSelf = 'A chat cannot be started with self.';
    sCannotStartChatWithService = 'A chat cannot be started with a service or server';

{$R *.dfm}

procedure RegisterActions();
var
    actctrl: IExodusActionController;
    act: TStartChatAction;
begin
    act := TStartChatAction.Create;

    actctrl := GetActionController();
    actctrl.registerAction('contact', act as IExodusAction);
    actctrl.addEnableFilter('contact', '{000-exodus.googlecode.com}-000-start-chat', 'selection=single');
end;

function IsAllowedChat(JID: TJAbberID): boolean;
var
    selfJID: TJabberID;
begin
    selfJID := TJabberID.Create(MainSession.jid);
    Result := (selfJID.jid = JID.jid) and ((JID.resource = '') or
              (JID.resource = selfJID.resource));

end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
//Find or create a chat controller/window for the jid/resource
//show_window = false -> window is not displayed, true->window displayed
//bring_to_front = true -> window brought to top of zorder and takes focus
function StartChat(sjid, resource: widestring;
                   show_window: boolean;
                   chat_nick: widestring;
                   bring_to_front:boolean): TfrmChat;
var
    chat: TChatController;
    win: TfrmChat;
    cjid: widestring;
    new_chat: boolean;
    do_scroll: boolean;
    hist: string;
    tjid1, selfJID: TJabberID;
begin
    Result := nil;

    tjid1 := TJabberID.Create(sjid);
    selfJID := TJabberID.Create(MainSession.jid);
    try
        if ((tjid1.jid = selfJID.jid) and
            ((resource = '') or
             (resource = selfJID.resource))) then
        begin
            // We are trying to start a conversation with ourselves
            // or with our bare jid.  This causes an infinate loop
            // when sending/receving messages.
            // Don't allow - popup error message.
            MessageBoxW(0, pWideChar(_(sCannotStartChatWithSelf)), PWideChar(sjid), MB_OK);
            exit;
        end;
        if (tjid1.user = '') then
        begin
            //MessageBoxW(0, pWideChar(_(sCannotStartChatWithService)), PWideChar(sjid), MB_OK);
            exit; //chat with server not allowed
        end;
    finally
        tjid1.Free();
        selfJID.Free();
    end;

    try
        cjid := sjid;
        if resource <> '' then
            cjid := cjid + '/' + resource;

        // either show an existing chat or start one.
        //if we should use an existing chat for all messages, then we just want
        //to get the first one that matches barejid.
        if (MainSession.Prefs.getBool('multi_resource_chat')) then
            chat := MainSession.ChatList.FindChat(sjid, '', '')
        //a new chat for each new resourcfe found.
        else
            chat := MainSession.ChatList.FindChat(sjid, resource, '');

        // Create a new chat controller if we don't have one
        if chat = nil then
            chat := MainSession.ChatList.AddChat(sjid, resource, (FindRoom(sjid) <> nil))
        else begin
            //We need to do this for existing chat controllers to make sure
            //callbacks are re-registered if they
            //have been unregistered before due to blocking
            chat.SetJID(cjid);
        end;

        do_scroll := false;
        hist := '';

        // Create a window if we don't have one.
        if (chat.window <> nil) then begin
            Result := TfrmChat(chat.window);
            Result.ShowDefault(bring_to_front); //ignore showwindow param, bring window to front ??
            exit; //done
        end;

        new_chat := true;
        win := TfrmChat.Create(nil);
        chat.Window := win; //controller modifies its state on this
        win.chat_object := chat;

        win.com_controller := TExodusChat.Create();
        win.com_controller.setChatSession(chat);
        win.com_controller.ObjAddRef();

        hist := TrimRight(chat.getHistory());

        // Setup the properties of the window,
        // and hook it up to the chat controller.
        with TfrmChat(chat.window) do begin
            _displayName := chat_nick;
            _anonymousChat := chat.AnonymousChat;
            _isRoom := IsRoom(sjid);
            if (_isRoom) then begin
                popAddContact.Enabled := false;
                mnuProperties.Enabled    := false;
                popResources.Enabled  := false;
                mnuSendFile.Enabled   := false;
                mnuBlock.Enabled      := false;
            end
            else PersistUnreadMessages := true;

            if (MainSession.IsBlocked(sjid)) then
                mnuBlock.Caption := _('Unblock')
            else
                mnuBlock.Caption := _('Block');

            SetJID(cjid);
            SetupResources();

            //Assign incoming message event
            chat.OnMessage := MessageEvent;
            //Assign outgoing message event
            chat.OnSendMessage := SendMessageEvent;

            if (hist <> '') then begin
                MsgList.populate(hist);
                do_scroll := true;
            end;

            //get window ready for messages
            if (show_window) then
                ShowDefault(bring_to_front);

            Application.ProcessMessages();

            //finally, event new chat to plugins
            if (new_chat) then
                ExCOMController.fireNewChat(sjid, com_controller);

            PlayQueue();
            
            // scroll to the bottom..
            if (do_scroll) then
                _scrollBottom();

        end;



        Result := TfrmChat(chat.window);
    except
        on e: Exception do
        begin
            if (Pos('Out of system resources', e.Message) > 0) then
            begin
                MainSession.FireEvent('/session/close-all-windows', nil);
                MainSession.FireEvent('/session/error-out-of-system-resources', nil);
            end;

            Result := nil;
        end;
    end;
end;

{---------------------------------------}
procedure CloseAllChats;
var
    i: integer;
    c: TChatController;
    w: TfrmChat;
begin
    with MainSession.ChatList do
    begin
        for i := Count - 1 downto 0 do
        begin
            c := TChatController(Objects[i]);
            w := nil;
            if (c <> nil) then
                w := TfrmChat(c.Window);
            //free controller before closing window, prevents uneeded and
            //problematic packet listener updates (controller may free itself
            //before listeners are actually added/removed by dispatcher) 
            c.Free(); //removes self from chatlist

            if (w <> nil) then
            begin
                w._warn_busyclose := false; //don't warn on all close
                w.Close();
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmChat.FormCreate(Sender: TObject);
begin
    inherited;
    _pcallback := -1;
    _spcallback:= -1;
    _scallback := -1;
    _itemcallback := -1;
    _displayName := '';
    _dnListener := TDisplayNameEventListener.Create();
    _dnListener.OnDisplayNameChange := Self.OnDisplayNameChange;
//    _dnLocked := false;
    _insertTab := true;
    _windowType := 'chat';
    //make this window track new messages

    _reply_id := '';
    _msg_out := false;
    _jid := nil;
//    _destroying := false;
    _isRoom     := false;
    _res_menus := TWidestringlist.Create();
    _unknown_avatar := TBitmap.Create();
    frmExodus.bigImages.GetBitmap(0, _unknown_avatar);

    _receivedXIMNode := false;
    _receivedMessage := false;
    _supportsXIM := false;

    SetupPrefs();
    SetupMenus();

    _scallback := MainSession.RegisterCallback(SessionCallback, '/session');
    _itemcallback := MainSession.RegisterCallback(ItemCallback, '/item/update');

    // branding/menus
    with MainSession.Prefs do begin
        if ((getBool('brand_ft')) and
            (MainSession.Profile.ConnectionType = conn_normal)) then begin
            mnuSendFile.Enabled := true;
            //DragAcceptFiles( Handle, True );
        end
        else
            mnuSendFile.Visible := false;
        if ((not getBool('brand_print')) and
            (MainSession.Profile.ConnectionType = conn_normal)) then begin
            PrintHistory1.Visible := false;
            Print1.Visible := false;
        end
        else begin
            PrintHistory1.Visible := true;
            Print1.Visible := true;
        end;

        if (getBool('brand_allow_blocking_jids') = false) then begin
            mnuBlock.Visible := false;
        end;

        mnuViewHistory.Visible := (getBool('brand_history_search') and getBool('brand_log_chat_messages'));

        // Button Created here instead of in dfm because the inherited buttons mixed with
        // this button create ordering issues (this button wants to always be at the right
        // and we want it to the left).
        if (getBool('brand_history_search') and getBool('brand_log_groupchat_messages')) then begin
            btnViewHistory := TToolButton.Create(tbDockBar);
            btnViewHistory.ImageIndex := RosterImages.RosterTreeImages.Find(RI_VIEW_HISTORY_KEY);
            btnViewHistory.OnClick := mnuViewHistoryClick;
            btnViewHistory.Parent := tbDockBar;
            btnViewHistory.ShowHint := true;
            btnViewHistory.Hint := _('View History');
        end;
    end;

    MsgList.setDragOver(OnDockedDragOver);
    MsgList.setDragDrop(OnDragDrop);

end;

{---------------------------------------}
class procedure TfrmChat.AutoOpenFactory(autoOpenInfo: TXMLTag);
begin
    //don't bring these to front
    StartChat(autoOpenInfo.getAttribute('jid'), '', true, '', false);
end;

{---------------------------------------}
function TfrmChat.GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;
begin
    Result := nil;
    UseProfile := false;
    if (event = 'disconnected') then
    begin
        Result := TXMLtag.Create(Self.ClassName);
        Result.setattribute('jid', _jid.jid);
        if (UnreadMsgCount > 0) then
            Result.SetAttribute('auto-open-override', 'true');        
        useProfile := true;
    end;
end;

{---------------------------------------}
function TfrmChat.GetWindowStateKey() : WideString;
begin
    //todo jjf remove profile from this state key once prefs are profile aware
    Result := inherited GetWindowStateKey() + '-' +
              MungeXMLName(MainSession.Profile.Name) + '-' +
              MungeXMLName(Self._jid.jid);
end;

{---------------------------------------}
procedure TfrmChat.updateDisplayName();
begin
    //if this is a private chat from a room, display name shoudl be "room - nick"
    if (_isRoom) then
        _displayName := TJabberID.removeJEP106(_jid.user) + ' - ' + FindRoomNick(_jid.full)
    else
        _displayName := TDisplayNameEventListener.getDisplayName(_jid.jid);

    lblNick.Caption := Tnt_WideStringReplace(_displayName, '&', '&&', [rfReplaceAll, rfIgnoreCase]);
    Caption := _displayName;
    Hint := _jid.jid;
    MsgList.setTitle(_displayName);
end;

{---------------------------------------}
procedure TfrmChat.updatePresenceImage();
var
    Item: IExodusItem;
    p: TJabberPres;
    inRoster: boolean;
begin
    // setup the captions, etc..
    Item := MainSession.ItemController.GetItem(_jid.jid);
    p := MainSession.ppdb.FindPres(_jid.jid, _jid.resource);
    inRoster := Item <> nil;

    if (inRoster) and (p <> nil) then
        ChangePresImage(Item, p.show, p.status)
    else if (inRoster) then
        ChangePresImage(Item, 'offline', 'offline')
    else if (p <> nil) then
        ChangePresImage(nil, p.show, p.status)
    else
        ChangePresImage(nil, 'unknown', 'Unknown Presence')
end;

{---------------------------------------}
procedure TfrmChat.setupMenus();
begin
    mnuHistory.Visible := (ExCOMController.ContactLogger <> nil);
    popClearHistory.Visible := (ExCOMController.ContactLogger <> nil);
end;

{---------------------------------------}
procedure TfrmChat.SetupPrefs();
var
    sc: TShortcut;
begin
    AssignDefaultFont(Self.Font);

    lblNick.Font.Size := lblNick.Font.Size + 1;
    lblNick.Font.Style := lblNick.Font.Style + [fsBold];
    lblNick.Font.Color := RGBToColor(45, 135, 190);
    
    //AssignUnicodeURL(lblNick.Font, 12);

    // setup prefs
    _embed_returns := MainSession.Prefs.getBool('embed_returns');
    _wrap_input := MainSession.Prefs.getBool('wrap_input');
    _warn_busyclose := MainSession.Prefs.getBool('warn_closebusy');
    mnuReturns.Checked := _embed_returns;
    mnuWordwrap.Checked := _wrap_input;
    MsgOut.WantReturns := _embed_returns;
    MsgOut.WordWrap := _wrap_input;

    _esc := MainSession.Prefs.getBool('esc_close');
    sc := TextToShortcut(MainSession.Prefs.getString('close_hotkey'));
    ShortCutToKey(sc, _close_key, _close_shift);
//    _myNick := _dnListener.getDisplayName(MainSession.Profile.getJabberID);
end;

{---------------------------------------}
procedure TfrmChat.SetupResources();
var
    i: integer;
    p: TJabberPres;
    m: TMenuItem;
begin
    // resources not managed via chat window if this is a muc chat
    if (_isRoom) then Exit;

    // Make sure we have menu items for all resources
    p := MainSession.ppdb.FindPres(_jid.jid, '');
    while (p <> nil) do begin
        i := _res_menus.IndexOf(p.fromJid.Resource);
        if (i = -1) then begin
            m := TMenuItem.Create(popContact);
            m.Caption := p.fromJID.resource;
            m.OnClick := popResourcesClick;
            popResources.Add(m);
            _res_menus.AddObject(p.fromJid.resource, m);
        end;
        p := MainSession.ppdb.NextPres(p);
    end;

    // Make sure we purge old ones..
    for i := _res_menus.Count - 1 downto 0 do begin
        p := MainSession.ppdb.FindPres(_jid.jid, _res_menus[i]);
        if (p = nil) then begin
            TMenuItem(_res_menus.Objects[i]).Free();
            _res_menus.Delete(i);
        end;
    end;
end;


{---------------------------------------}
procedure TfrmChat.SetJID(cjid: widestring);
var
    Item: IExodusItem;
//    m: integer;
//    a: TAvatar;
    nickjid: Widestring;
    rm: TfrmRoom;
begin
    setUID(cjid);

    _receivedXIMNode := false;
    _receivedMessage := false;
    _supportsXIM := false;

    jid := cjid;
    if (_jid <> nil) then _jid.Free();

    _jid := TJabberID.Create(cjid);

    //only listen for display name changes for this jid
    _DNListener.UID := _jid.jid;

    _avatar := nil;
    pnlDockTop.ClientHeight := 28;

    // check for an avatar
    if (MainSession.Prefs.getBool('chat_avatars')) then begin
        _avatar := Avatars.Find(_jid.jid);
        if ((_avatar <> nil) and (_avatar.isValid())) then begin
            _avatar.PNGBackgroundColor := pnlJID.Color;
            imgAvatar.picture.assign(_avatar.Graphic);
        end
        else begin
            imgAvatar.transparent := false;
            imgAvatar.picture.assign(_unknown_avatar);
        end;
//            // Put some upper bounds on avatars in chat windows
//            m := a.Height;
//            if (m >= 0) then begin
//                _avatar := a;
//                if (m > 32) then begin
//                    m := 32;
//                    imgAvatar.Width := Trunc((32 / _avatar.Height) * (_avatar.Width))
//                end
//                else
//                    imgAvatar.Width := _avatar.Width;
//                pnlDockTop.ClientHeight := m + 1;
//            end;

//        end;
        lblNick.left := imgAvatar.Left + imgAvatar.Width;
    end
    else begin
        // No avatars are displayed
        imgAvatar.Visible := false;
        lblNick.left := 3;
    end;

    // setup the callbacks if we don't have them already
    if (_pcallback = -1) then
        _pcallback := MainSession.RegisterCallback(PresCallback,
            '/packet/presence[@from="' + WideLowerCase(cjid) + '*"]');

    // if this chat is via a room - watch for my exit/entry msgs
    // to avoid causing messages of type error to be returned
    if (_isRoom and (_spcallback = -1)) then begin
        rm := FindRoom(_jid.jid);
        if (rm <> nil) then begin
            nickjid := WideLowerCase(rm.getJid + '/' + rm.mynick);
//            _mynick := rm.mynick;
            _spcallback := MainSession.RegisterCallback(PresCallback,
                '/packet/presence[@from="' + nickjid + '*"]');
        end;
    end;

    Item := MainSession.ItemController.GetItem(cjid);
    if (Item <> nil) then begin
        mnuSendFile.Enabled := (not _isRoom);
        //if (not item.IsNative) then
        //DragAcceptFiles(Handle, false);
    end;

    updateDisplayName();
    updatePresenceImage();

    // TODO: Can't send directed presence to people not in roster. Cope w/ TC??
    // because this causes havoc w/ TC rooms that we are in, or NOT in
    {
    if (do_pres) then begin
        dp := TCapPresence.Create();
        dp.Status := MainSession.Status;
        dp.Show := MainSession.Show;
        dp.Priority := MainSession.Priority;
        dp.setAttribute('to', _jid.full);
        MainSession.SendTag(dp);
    end;
    }

end;

procedure TfrmChat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    inherited;
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmChat.PlayQueue();
var
    t: TXMLTag;
begin
    // pull all of the msgs from the controller queue,
    // and feed them into this window
    if (chat_object = nil) then exit;
    while (chat_object.msg_queue.AtLeast(1)) do begin
        t := TXMLTag(chat_object.msg_queue.Pop());
        Self.MessageEvent(t);
    end;
end;

{---------------------------------------}
//Handle incoming messages
procedure TfrmChat.MessageEvent(tag: TXMLTag);
var
    xml, body: Widestring;
    msg_type, from_jid: WideString;
    etag, tagThread : TXMLTag;
begin
    // callback for messages
    // check for a jabber:x:event tag
    msg_type := tag.GetAttribute('type');
    from_jid := tag.getAttribute('from');

    if from_jid <> jid then begin
        chat_object.SetJID(from_jid);
        SetJID(from_jid);
    end;

    if (msg_type = 'error') then begin
        showMsg(tag);
        exit;
    end;

    // check for composing events
    etag := tag.QueryXPTag(XP_MSGXEVENT);
    if ((tag.GetFirstTag('body') = nil) and (etag <> nil) and (etag.GetFirstTag('composing') <> nil))then
    begin
        // we got a composing a message
        if (etag.GetBasicText('id') = chat_object.LastMsgId) then begin
            _flash_ticks := 0;
            MsgList.DisplayComposing('-- ' + DisplayName + _(' is replying --'));
            exit; //done
        end
        else MsgList.HideComposing(); //Got an empty id
    end;

    // process the msg
    etag := tag.QueryXPTag(XP_MSGCOMPOSING);
    _sent_composing := false;
    _send_composing := (etag <> nil);
    if (_send_composing) then
        _reply_id := tag.GetAttribute('id');

    // plugin
    xml := tag.xml();
    body := tag.GetBasicText('body');
    if (not com_controller.fireBeforeRecvMsg(body, xml)) then
        exit;

    // make sure we are visible..
//    if (not visible) then begin
//        outputdebugmsg('Chat is not visible but we received a message. Showing');
//        ShowDefault(false);
//    end;

    showMsg(tag);

    if GetThread() = '' then begin
        //Get thread from message
        tagThread := tag.GetFirstTag('thread');
        if tagThread <> nil then begin
            chat_object.setThreadID(tagThread.Data);
        end;
   end;
   //did this message have an xhtml-im node?
    _receivedMessage := true;
    _receivedXIMNode := (tag.QueryXPTag(XP_XHTMLIM) <> nil);

   com_controller.fireAfterRecvMsg(body);
end;

function getBestCapsEntity(jid: TJabberID): TJabberEntity;
var
    p: TJabberPres;
begin
    Result := jEntityCache.getByJid(jid.full, '');
    if (Result = nil) then begin
        //try it with the first entry in the ppdb
        p := MainSession.ppdb.FindPres(jid.jid, jid.resource);
        if (p <> nil) then
            Result := jEntityCache.getByJid(p.fromJid.full, '');
    end;
end;


{
    Check to see if to jid supports xhtml-im by checking the client cache
    if its in the cache
        if jid supports it return true
        if jid was supporting it but is not now, return false
        if we have received a message with an xhtml-im node, return true
        if we have never received a message from this to, return true
    if not in the cache
        if we have received a message with an xhtml-im node, return true
        if we have never received a message from this to, return true
    return false
}
function TfrmChat.isToXIMEnabled(tag: TXMLTag): boolean;
var
    e: TJabberEntity;
    toStr: WideString;
    toJID: TJabberID;
begin
    Result := false;
    if (MainSession.Prefs.getBool('richtext_enabled')) then begin
        Result := _receivedXIMNode or (not _receivedMessage);
        toStr := tag.GetAttribute('to');
        if (toStr = '') then exit;
        toJID := TJabberID.Create(toStr);
        e := getBestCapsEntity(toJID);
        FreeAndNil(toJID);
        if (e <> nil) then begin
            if (e.hasFeature(XMLNS_XHTMLIM)) then begin
                _supportsXIM := true;
                Result := true;
            end
            else if (_supportsXIM) then begin
                Result := false;
                _supportsXIM := false;
                _receivedXIMNode := false; //keep us from sending anythign else
            end;
        end
    end;
end;

function reparseTag(oldTag: TXMLTag): TXMLTag;
var
    _parser: TXMLTagParser;

begin
    Result := nil;
    _parser := TXMLTagParser.Create();
    _parser.Clear();
    _parser.ParseString(oldTag.XML, '');
    if (_parser.Count > 0) then
        Result := _parser.popTag();
    _parser.Free();
end;

{---------------------------------------}
//Handle outgoing messages
procedure TfrmChat.SendMessageEvent(tag: TXMLTag);
var
  send_allowed: boolean;
  body: Widestring;
  xml: Widestring;
  ttag: TXMLTag;
  newTag: TXMLTag;
begin
  send_allowed := true;
  body := tag.GetBasicText('body');

  if (GetDelayTag(tag) = nil) then begin
    //If not a delayed message (previously sent), send and then display

    if (com_controller <> nil) then //Do plugin before message logic
    begin
      send_allowed := com_controller.fireBeforeMsg(body);
    end;

    if (send_allowed) then begin
      xml := '';
      if (com_controller <> nil) then //Do plugin after message logic
      begin
        xml := com_controller.fireAfterMsg(body);
      end;

      if (xml <> '') then
        tag.addInsertedXml(xml);

      //plaugins have had their shot, make a new message tag from the old,
      //so extra xml will actually exist as tags.
      newTag := reparseTag(tag);
      showMsg(newTag);

      //remove xhtml-im elements if needed now that the message has been shown.
      ttag := newTag.QueryXPTag(XP_XHTMLIM);
      if (ttag <> nil) then begin
        if (isToXIMEnabled(newTag)) then
            newTag.AddTag(CleanXIMTag(tTag, false, true)); //clean any proprietary styles before sending
        newTag.RemoveTag(ttag);
      end;
      MainSession.SendTag(TXMLTag.create(newTag));
      if (com_controller <> nil) then
      begin
          com_controller.fireSentMessageXML(newTag);
      end;
      newTag.Free();
    end;
  end
  else begin
    // This is a delayed message.
    // It was already sent, but not displayed because we were paused.
    // This is a rare situation, but possible.
    showMsg(tag);
  end;

end;

{---------------------------------------}
procedure TfrmChat.showMsg(tag: TXMLTag);
var
    m, etag: TXMLTag;
    subj_msg, msg: TJabberMessage;
    emsg, err: Widestring;
begin
    // display the body of the msg
    if (_warn_busyclose) then begin
        timBusy.Enabled := false;
        timBusy.Enabled := true;
    end;

    Msg := chat_object.CreateMessage(tag); //Create, assign nickname & directionality
    
    if (tag.getAttribute('type') = 'error') then begin
        etag := tag.GetFirstTag('error');
        if (etag <> nil) then begin
            err := _('Your last message was returned with an error.');
            emsg := etag.QueryXPData('/error/text[@xmlns="urn:ietf:params:xml:ns:xmpp-streams"]');
            if (emsg = '') then emsg := etag.Data;
            err := err + emsg;
            err := err + '(' + _('Error Code: ') + etag.GetAttribute('code') + ')';

            Msg.Body := _('ERROR: ') + err;
        end
        else
            Msg.Body := _('ERROR: ') + _('Your last message was returned with an error.');
        DisplayMsg(Msg, MsgList);
        Msg.Free();
        exit;
    end;

    MsgList.HideComposing();

    // Check to see if we need to increment the
    // unread msg count
    if ((not msg.isMe) and
        (msg.Body <> '')) then begin
        updateMsgCount(msg);
        updateLastActivity(msg.Time);
    end;

    // only display + notify if we have something to display :)
    if (Msg.Subject <> '') then begin
        subj_msg := TJabberMessage.Create(tag);
        subj_msg.Body := 'The subject has been changed to: ' + subj_msg.Subject;
        subj_msg.Subject := '';
        subj_msg.Nick := '';
        DisplayMsg(subj_msg, MsgList);
        subj_msg.Free();
    end;

    if (Msg.Body <> '') then begin
        //Notify
        if (not Msg.isMe) then
        begin
            if (Msg.Priority = High) then
                DoNotify(Self, 'notify_priority_chatactivity',
                        GetDisplayPriority(Msg.Priority) + ' ' + _(sPriorityChatActivity) + DisplayName,
                        RosterTreeImages.Find('contact'))
            else
                DoNotify(Self, 'notify_chatactivity',
                    _(sChatActivity) + DisplayName,
                      RosterTreeImages.Find('contact'));
        end;
        if (Msg.isMe = false ) and ( _isRoom ) then
          Msg.Nick := DisplayName;

        //Render
        DisplayMsg(Msg, MsgList);

        // log if we want..
        LogMessage(Msg);

        // check for displayed events
        etag := tag.QueryXPTag(XP_MSGXEVENT);
        if ((etag <> nil) and (etag.GetFirstTag('id') = nil)) then begin
            if (etag.GetFirstTag('displayed') <> nil) then begin
                // send back a displayed event
                m := generateEventMsg(tag, 'displayed');
                MainSession.SendTag(m);
            end;
        end;
    end;

    Msg.Free();
end;

{---------------------------------------}
procedure TfrmChat.SendRawMessage(body, subject, xml: Widestring;
    fire_plugins: boolean; priority: PriorityType);
begin
    // send the msg
    // XXX: PGM: is this your trim?  What should we do with messages that
    // start with $#D, etc.?
    chat_object.SendMsg(Trim(body),subject,xml,true, priority);
end;

{---------------------------------------}
function TfrmChat._sendMsg(txt: Widestring; xml: Widestring; priority: PriorityType): boolean;
begin
      sendRawMessage(txt,'',xml,true, priority);
      result := true;
end;

{---------------------------------------}
procedure TfrmChat.SendMsg;
var
    txt: Widestring;
    xhtml: TXMLTag;
    xml: Widestring;
    priority: PriorityType;
    Item: IExodusItem;
begin
    Item := MainSession.ItemController.Getitem(_jid.jid);
    if (Item <> nil) then begin
{** JJF msgqueue refactor TODO run this through the action map
        if (not Item.Active) then begin
            MsgOut.Clear;
            MessageBoxW(WindowHandle, pWideChar(_(sCannotOffline)), PWideChar(_jid.jid), MB_OK);
            exit;
        end;
**}
    end;

    // Get the text from the UI
    // and send the actual message out
    txt := getInputText(MsgOut);
    if (txt = '/clear') then begin
      Clear1Click(self);
      ClearMsgOut();
      exit;
    end;
    xml := '';

    xhtml := getInputXHTML(MsgOut);
    if (xhtml <> nil) then
        xml := xhtml.XML;
    FreeAndNil(xhtml);

    if (MainSession.Prefs.getBool('show_priority')) then
       priority := PriorityType(GetEnumValue(TypeInfo(PriorityType), cmbPriority.Text))
    else
       priority := None;

    if (_sendMsg(txt, xml, priority)) then begin
        _sent_composing := false;
        inherited;
    end;
end;

{---------------------------------------}
procedure TfrmChat.MsgOutKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = 0) then exit;
    if (com_controller = nil) then exit;

    // dispatch key-presses to Plugins
    com_controller.fireMsgKeyDown(Key, Shift);

    // Ctrl+I is a tab, but we don't want a tab.
    if ((Shift = [ssCtrl]) and
        (chr(Key) = 'I')) then begin
        _insertTab := false;
    end;

    inherited;
end;
{---------------------------------------}
 procedure TfrmChat.MsgOutKeyPress(Sender: TObject; var Key: Char);
var
   UpdateKey: WideString;
   Part: ChatParts;
begin
    if (Key = #0) then exit;
    if (com_controller = nil) then exit;
    if (Sender = MsgOut) then
        Part := HWND_MsgInput
    else
        Part := HWND_MsgOutput;
    UpdateKey := WideChar(Key);
    com_controller.fireMsgKeyPress(UpdateKey, Part);
    Key := Chr(Ord(PWideChar(UpdateKey)^));
    if (Key = #0) then exit;
    
    if ((Key = #9) and
        (not _insertTab)) then begin
        Key := #0;
        _insertTab := true;
    end;

    inherited;
end;
{---------------------------------------}
procedure TfrmChat.MsgOutKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = 0) then exit;
    if (com_controller = nil) then exit;

    // dispatch key-presses to Plugins
    com_controller.fireMsgKeyUp(Key, Shift);
    inherited;

end;

procedure TfrmChat.MsgOutOnEnter(Sender: TObject);
begin
  inherited;

end;

{---------------------------------------}
procedure TfrmChat.SessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/disconnected') then begin
        //JJF chats closed at disconnect, no longer need this hander
        // post a msg to the window and disable the text input box.
{**
        MsgOut.Visible := false;
        try
            MsgList.SetFocus();
        except
            // To handle Cannot focus exception
        end;
        MsgList.DisplayPresence('', _('You have been disconnected.'), '', 0);
        Self.ImageIndex := RosterImages.RI_OFFLINE_INDEX;
**}
    end
    else if (event = '/session/presence') then begin
        if (not MsgOut.Visible) then begin
            MsgOut.Visible := true;
            try
                MsgOut.SetFocus();
            except
                // To handle Cannot focus exception
            end;
            MsgList.DisplayPresence('', _('Reconnected'), '', 0);
            updatePresenceImage();
        end;
    end
    else if (event = '/session/block') then begin
        // if this jid just got blocked, just close the window.
        if (_jid.jid = tag.GetAttribute('jid')) then begin
            PostMessage(Handle, WM_CLOSE, 0, 0);
        end;
    end;
end;
{---------------------------------------}
procedure TfrmChat.ItemCallback(event: string; item: IExodusItem);
begin
    if (event = '/item/update') and (item.UID = _jid.jid) then begin
        if MainSession.IsBlocked(Self._jid.jid) then
            mnuBlock.Caption := _('Unblock')
        else
            mnuBlock.Caption := _('Block');

        updatePresenceImage();
    end;
end;

{---------------------------------------}
procedure TfrmChat.PresCallback(event: string; tag: TXMLTag);
begin
    // display some presence packet
    if (event = 'xml') then begin
        handleMUCPresence(tag); // only matters if chatting via a room (_isRoom = true)
        showPres(tag);
        SetupResources();
    end;
end;

{---------------------------------------}
procedure TfrmChat.ChangePresImage(Item: IExodusItem; show: WideString; status: WideString);
var
    nickHint: Widestring;
    newPresIdx: integer;
begin
    // Change the bulb
    if (Item = nil) then begin
        // TODO: get image prefix from prefs
        if (show = _('offline')) then
            newPresIdx := RosterTreeImages.Find('offline')
        else if (show = _('unknown')) then
            newPresIdx := RosterTreeImages.Find('unknown')
        else if (show = _('away')) then
            newPresIdx := RosterTreeImages.Find('away')
        else if (show = _('xa')) then
            newPresIdx := RosterTreeImages.Find('xa')
        else if (show = _('dnd')) then
            newPresIdx := RosterTreeImages.Find('dnd')
        else if (show = _('chat')) then
            newPresIdx := RosterTreeImages.Find('chat')
        else
            newPresIdx := RosterTreeImages.Find('available')
    end
    else begin
        // Always use the image from the roster item
        newPresIdx := Item.ImageIndex;
    end;

    nickHint := show;
    if ((status <> '') and
        (status <> show)) then begin
        if (nickHint = '') then begin
            nickHint := _(sAvailable);
        end;

        nickHint := nickHint + ', ' + status;
    end;
    nickHint := nickHint + ' <' + _jid.getDisplayFull() + '>';
    lblNick.Hint := nickHint;

    Self.ImageIndex := newPresIdx;
end;

{---------------------------------------}
procedure TfrmChat.handleMucPresence(tag: TXMLTag);
var
    ptype: widestring;
    idx: integer;
begin
    if (not _isRoom) then Exit;

    ptype :=  tag.GetAttribute('type');
    if (AnsiSameText(sUnavailable, ptype)) then begin
        msgOut.Enabled := false;

        // One of the parties is unavailable due to change nick or room exit
        // ... so make chat invalid.
        if (MainSession <> nil) then begin
            if (_pcallback <> -1) then begin
                MainSession.UnRegisterCallback(_pcallback);
                _pcallback := -1;
            end;

            if (_spcallback <> -1) then begin
                MainSession.UnRegisterCallback(_spcallback);
                _spcallback := -1;
            end;
        end;

        idx := MainSession.ChatList.IndexOfObject(chat_object);
        if (idx >= 0) then
            MainSession.ChatList.Delete(idx);

        // keep ChatController from getting new msgs
        if (chat_object <> nil) then begin
            chat_object.DisableChat();
        end;

        if (com_controller <> nil) then begin
            com_controller.setChatSession(nil);
            com_controller.Free();
            com_controller := nil;
        end;

        // modify presnece image - right not make everyone offline
        ChangePresImage(nil, 'offline', 'offline')
    end
end;


{---------------------------------------}
procedure TfrmChat.showPres(tag: TXMLTag);
var
    txt: WideString;
    status, show, User, ts  : String;
    p: TJabberPres;
    j: TJabberID;
    Item: IExodusItem;
    dt: TDateTime;
    showtxt: Widestring;
begin
    // Get the user
    user := tag.GetAttribute('from');

    // make sure the user is still connected
    j := TJabberID.Create(jid);
    Item := MainSession.ItemController.Getitem(j.jid);

    // Get the pres for this resource
    p := MainSession.ppdb.FindPres(j.jid, j.resource);
    if (p = nil) then begin
        msglist.HideComposing(); // Make sure is replying message is cleared
        show := _(sOffline);
        status := _(sOffline);
    end
    else begin
        show := tag.GetBasicText('show');
        status := tag.GetBasicText('status');
    end;
    //process if show or status has changed. Ignore things like caps updates
    j.Free();
    if ((_show <> show) or (_status <> status)) then begin
        ChangePresImage(Item, show, status);
        _show := show;
        _status := status;

        if (MainSession.Prefs.getBool('timestamp')) then begin
            dt := Now;
            ts := FormatDateTime(MainSession.Prefs.getString('timestamp_format'), dt);
        end
        else begin
            ts := '';
        end;

        showtxt := show;
        if (showtxt = '') then begin
            showtxt := _(sAvailable);
        end;

        txt := _displayName +
               ' ' +
               _(sIsNow) +
               ' ' +
               showtxt;

        if ((LowerCase(status) <> LowerCase(showtxt)) and
            (status <> '')) then begin
            txt := txt +
                   ' (' +
                   status +
                   ')';
        end;

        txt := txt + '.';
        MsgList.DisplayPresence(_displayName, txt, ts, dt);
    end;
end;

{---------------------------------------}
procedure TfrmChat.doHistory(Sender: TObject);
begin
  inherited;
    ShowLog(_jid.jid);
end;

{---------------------------------------}
procedure TfrmChat.doProfile(Sender: TObject);
begin
  inherited;
    ShowProfile(_jid.jid);
end;

{---------------------------------------}
procedure TfrmChat.doAddToRoster(Sender: TObject);
var
    Item: IExodusItem;
begin
  inherited;
    // check to see if we're already subscribed...
    Item := MainSession.ItemController.GetItem(_jid.jid);
    if ((Item <> nil) and ((Item.Value['Subscription'] = 'both') or (Item.Value['Subscription'] = 'to'))) then begin
        MessageDlgW(_(sAlreadySubscribed), mtInformation,
            [mbOK], 0);
        exit;
    end
    else begin
        ShowAddContact(TJabberID.Create(_jid.full));
    end;

end;

{---------------------------------------}
procedure TfrmChat.lblJIDClick(Sender: TObject);
var
    cp: TPoint;
    p: TJabberPres;
    inRoster: boolean;
    Item: IExodusItem;
begin
  inherited;
    GetCursorPos(cp);
    p := MainSession.ppdb.FindPres(_jid.jid, _jid.resource);
    Item := MainSession.ItemController.GetItem(_jid.jid);
    inRoster := (Item <> nil);

    //if (inRoster) and (p <> nil) and (ritem.IsNative) then begin
    if (inRoster) and (p <> nil) then begin
        mnuSendFile.Enabled := true;
        //DragAcceptFiles(Handle, true);
    end
    else begin
        mnuSendFile.Enabled := false;
        //DragAcceptFiles(Handle, false);
    end;

    popContact.popup(cp.x, cp.y);
end;

{---------------------------------------}
procedure TfrmChat.mnuReturnsClick(Sender: TObject);
begin
  inherited;
    mnuReturns.Checked := not mnuReturns.Checked;
    MsgOut.WantReturns := mnuReturns.Checked;
    _embed_returns := mnuReturns.Checked;
    MainSession.Prefs.setBool('embed_returns', _embed_returns);
end;

{---------------------------------------}
procedure TfrmChat.mnuWordwrapClick(Sender: TObject);
begin
    inherited;
    mnuWordwrap.Checked := not mnuWordWrap.Checked;
    _wrap_input := mnuWordwrap.Checked;
    MsgOut.WordWrap := _wrap_input;
    MainSession.Prefs.setBool('wrap_input', _wrap_input);
end;

{---------------------------------------}
procedure TfrmChat.mnuViewHistoryClick(Sender: TObject);
begin
    inherited;
    StartShowHistoryWithJID(_jid.jid, false);
end;

{---------------------------------------}
procedure TfrmChat.mnuSendFileClick(Sender: TObject);
begin
  inherited;
    FileSend(_jid.full);
end;

{---------------------------------------}
procedure TfrmChat._sendComposing(id: Widestring);
var
    c: TXMLTag;
begin
    c := TXMLTag.Create('message');
    with c do begin
        setAttribute('to', jid);
        setAttribute('type', 'chat');
        with AddTag('x') do begin
            setAttribute('xmlns', XMLNS_XEVENT);
            AddTag('composing');
            if (id <> '') then
                AddBasicTag('id', id)
            else
                AddTag('id');
        end;
    end;

    if (MainSession.Active) then
        MainSession.SendTag(c);
end;

{---------------------------------------}
procedure TfrmChat.MsgOutChange(Sender: TObject);
begin
  inherited;
    if ((_sent_composing) and (MsgOut.Text = '')) then begin
        // send cancel event
        _sendComposing('');
        _sent_composing := false;
        _send_composing := true;
    end
    else if ((_send_composing) and
            (MsgOut.Text <> ''))then begin
        _sendComposing(_reply_id);
        _sent_composing := true;
        _send_composing := false;
    end;
end;

{---------------------------------------}
//procedure TfrmChat.AcceptFiles( var msg : TWMDropFiles );
//const
//    cnMaxFileNameLen = 255;
//var
//    i,
//    nCount     : integer;
//    acFileName : array [0..cnMaxFileNameLen] of char;
//    Item: IExodusItem;
//begin
////    Item := MainSession.roster.Find(jid);
//    Item := MainSession.ItemController.GetItem(jid);
//
//    if ((Item <> nil) and (Item.Value['Native'] = 'true')) then
//    begin
//        // find out how many files we're accepting
//        if (MainSession.Prefs.getBool('brand_ft') = false) then exit;
//
//        nCount := DragQueryFile( msg.Drop, $FFFFFFFF, acFileName, cnMaxFileNameLen );
//
//        // query Windows one at a time for the file name
//        for i := 0 to nCount-1 do begin
//            DragQueryFile( msg.Drop, i, acFileName, cnMaxFileNameLen );
//            // do your thing with the acFileName
//            FileSend(_jid.full, acFileName);
//        end;
//
//        // let Windows know that you're done
//        DragFinish( msg.Drop );
//    end;
//end;

{---------------------------------------}
procedure TfrmChat.freeChatObject();
begin
    if (chat_object = nil) then exit;
    // Setting window to nil will call dec the ref count,
    // so don't call release.
    //chat_object.window := nil;
    chat_object := nil;
end;

{---------------------------------------}
procedure TfrmChat.FormDestroy(Sender: TObject);
begin
    _dnListener.Free();
    // Unregister the callbacks + stuff
    if (MainSession <> nil) then begin
        if (_pcallback <> -1) then
            MainSession.UnRegisterCallback(_pcallback);
        if(_spcallback <> -1) then
            MainSession.UnRegisterCallback(_spcallback);
        if (_scallback <> -1) then
            MainSession.UnRegisterCallback(_scallback);
        if (_itemcallback <> -1) then
            MainSession.UnRegisterCallback(_itemcallback);

        _pcallback      := -1;
        _spcallback     := -1;
        _scallback      := -1;
        _itemcallback   := -1;
    end;
    //chat controller will free itself appropriately
//    if (chat_object <> nil) then
//        freeChatObject();

    if (com_controller <> nil) then
    begin
        com_controller.Free();
        com_controller := nil;
    end;

    if (_jid <> nil) then
        FreeAndNil(_jid);

    if (Assigned(_res_menus)) then
    begin
        _res_menus.Clear();
        _res_menus.Free();
    end;

    //DragAcceptFiles(Handle, false);
    inherited;
end;

{---------------------------------------}
procedure TfrmChat.mnuBlockClick(Sender: TObject);
begin
     if (MainSession.IsBlocked(_jid.jid)) then
         MainSession.UnBlock(_jid)
     else
         MainSession.Block(_jid);

end;

{---------------------------------------}
procedure TfrmChat.mnuSaveClick(Sender: TObject);
begin
  inherited;
    // save the conversation to file
    case _msglist_type of
        RTF_MSGLIST  : SaveDialog1.Filter := 'RTF (*.rtf)|*.rtf|Text (*.txt)|*.txt';
        HTML_MSGLIST : SaveDialog1.Filter := 'HTML (*.htm)|*.htm';
    end;

    if SaveDialog1.Execute then begin
        MsgList.Save(SaveDialog1.Filename);
    end;
end;

{---------------------------------------}
procedure TfrmChat.mnuOnTopClick(Sender: TObject);
begin
  inherited;
    mnuOnTop.Checked := not mnuOnTop.Checked;

    if (mnuOnTop.Checked) then
        Self.FormStyle := fsStayOnTop
    else
        Self.FormStyle := fsNormal;
end;

{---------------------------------------}
procedure TfrmChat.FormResize(Sender: TObject);
begin
    inherited
end;

{---------------------------------------
procedure TfrmChat.btnCloseClick(Sender: TObject);
begin
    Self.Close();
end;
}
{---------------------------------------}
procedure TfrmChat.popClearHistoryClick(Sender: TObject);
begin
    inherited;
    ClearLog(Self._jid.jid)
end;

{---------------------------------------}
procedure TfrmChat.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
    s: String;
    cc: TChatController;
begin
    if ((_warn_busyclose) and
        (((timBusy.Enabled) or (MsgList.isComposing())) and msgOut.Enabled)) then begin
        if MessageDlgW(_(sCloseBusy), mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
            CanClose := false;
            exit;
        end;
    end;
    // Cancel our composing event
    if (_sent_composing) then
        _sendComposing('');
    //controller could already be gone by this point
    //(freed by /session/disconnected for example). Get ref from list, controller
    //destruction will remove it from the list.
    cc := MainSession.ChatList.FindChat(_jid.jid, _jid.resource, '');
    if (cc <> nil) then
    begin
        //if this user is blocked but we started a chat, block him again
        if (MainSession.IsBlocked(_jid.jid)) then
            cc.DisableChat;

        s := MsgList.getHistory();
        cc.SetHistory(s);

        cc.window := nil; //unassign listenrs, starts mem timer for destruction
    end
    else
        if (com_controller <> nil) then
            com_controller.setChatSession(nil);
        

    inherited;
end;

{---------------------------------------
procedure TfrmChat.btnCloseMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    _destroying := (ssCtrl in Shift);
end;
}

{---------------------------------------}
procedure TfrmChat.timBusyTimer(Sender: TObject);
begin
  inherited;
    timBusy.Enabled := false;
end;

{---------------------------------------}
procedure TfrmChat.pluginMenuClick(Sender: TObject);
begin
    if (com_controller <> nil) then
        com_controller.fireMenuClick(Sender);
end;

{---------------------------------------}
procedure TfrmChat.popResourcesClick(Sender: TObject);
begin
  inherited;
    // set the message to this resource.
    SetJid(_jid.jid + '/' + TMenuItem(Sender).Caption);
end;

{---------------------------------------}
procedure TfrmChat.imgAvatarPaint(Sender: TObject);
//var
//    r: TRect;
begin
//  inherited;
//    if (_avatar <> nil) then begin
//        try
//            if (_avatar.Height > imgAvatar.Height) then begin
//                r.Top := 1;
//                r.Left := 1;
//                r.Bottom := imgAvatar.Height;
//                r.Right := imgAvatar.Width;
//
//                _avatar.Draw(imgAvatar.Canvas, r);
//            end
//            else
//                _avatar.Draw(imgAvatar.Canvas);
//            exit;
//        except
//            //corrupt avatars could cause an invalid pointer here,
//            //make like we don't have an avatar
//            on E:Exception do
//            begin
//                DebugManager.DebugMessage('Exception attempting to draw avatar for chat: ' + GetUID() + ' (' + E.message + ')');
//                _avatar := nil;  //unknown drawn below
//            end;
//        end;
//    end;
//    r.Top := 1;
//    r.Left := 1;
//    r.Bottom := imgAvatar.Height;
//    r.Right := imgAvatar.Width;
//    imgAvatar.picture.Assign(_unknown_avatar);
end;

{---------------------------------------}
procedure TfrmChat.imgAvatarClick(Sender: TObject);
var
  r : TRect;
begin
  inherited;
  if (FloatingImage.FloatImage.Active) then exit;
  if (_avatar = nil) then exit;

  with FloatingImage.FloatImage do
  begin
    r := imgAvatar.ClientRect;
    r.TopLeft := imgAvatar.ClientOrigin;
    r.Right := r.Right + imgAvatar.ClientOrigin.X;
    r.Bottom := r.Bottom + imgAvatar.ClientOrigin.Y;
    ParentRect := r;
    Avatar := _avatar;
    Show();
  end;
end;

{---------------------------------------}
procedure TfrmChat.Print1Click(Sender: TObject);
begin
 PrintHistory1Click(Sender);
end;

procedure TfrmChat.PrintHistory1Click(Sender: TObject);
var
    cap: Widestring;
    ml: TfBaseMsgList;
    msglist: TfRTFMsgList;
    htmlmsglist: TfIEMsgList;
begin
  inherited;
    ml := getMsgList();

    if (ml is TfRTFMsgList) then begin
        msglist := TfRTFMsgList(ml);
        with PrintDialog1 do begin
            if (not Execute) then exit;

            cap := _('Room Transcript: %s');
            cap := WideFormat(cap, [Self.Caption]);

            PrintRichEdit(cap, TRichEdit(msglist.MsgList), Copies, PrintRange);
        end;
    end
    else if (ml is TfIEMsgList) then begin
        htmlmsglist := TfIEMsgList(ml);
        htmlmsglist.print(true);
    end;
end;

{---------------------------------------}
//Get thread from controller
function TFrmChat.GetThread(): Widestring;
begin
  result := '';

  if (chat_object <> nil) then
    result := chat_object.getThreadID();
end;

procedure TfrmChat.OnDockedDragOver(Sender, Source: TObject; X, Y: Integer;
                                    State: TDragState; var Accept: Boolean);

begin
    inherited;
    Accept := (Source = frmRoster.RosterTree);
end;

procedure TfrmChat.OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer);
//var
// sel_contacts: TList;
begin
    inherited;
//    if (Source = frmRoster.RosterTree) then begin
        // send roster items to this contact.
    { TODO : Roster refactor }
        //sel_contacts := frmRoster.RosterTree.getSelectedContacts(false);
{
        if (sel_contacts.count > 0) then
            jabberSendRosterItems(TfrmChat(Self).getJid, sel_contacts)
        else
            MessageDlgW(_(sNoContactsSel), mtError, [mbOK], 0);
        sel_contacts.Free();
}
//    end;
end;

{
    Event fired when docking is complete.

    Docked property will be true, tabsheet will be assigned. This event
    is fired after all other docking events are complete.
}
procedure TfrmChat.OnDocked();
begin
    inherited;
    mnuOnTop.Enabled := false;
    //DragAcceptFiles(Handle, GetActivityWindow().FilesDragAndDrop);
    // scroll the MsgView to the bottom.
    _scrollBottom();
    Self.Refresh();

    if (com_controller <> nil) then
        com_controller.fireNewWindow(Self.Handle);
end;

{
    Event fired when a float (undock) is complete.

    Docked property will be false, tabsheet will be nil. This event
    is fired after all other floating events are complete.
}
procedure TfrmChat.OnFloat();
begin
    inherited;
    mnuOnTop.Enabled := true;
    //DragAcceptFiles(Handle, GetActivityWindow().FilesDragAndDrop);
    _scrollBottom();
    Self.Refresh();

    if (com_controller <> nil) then
        com_controller.fireNewWindow(Self.Handle);
end;

procedure TfrmChat.OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
begin
    //our display name has changed, refresh title, labels
    updateDisplayName();
end;

procedure TfrmChat.OnPersistedMessage(msg: TXMLTag);
var
    m: TJabberMessage;
begin
    inherited;
    //Create, assign nickname & directionality
    m := chat_object.CreateMessage(msg);
    
    updateMsgCount(m);
    updateLastActivity(m.Time);

    //Render
    DisplayMsg(m, MsgList);
    m.free();
end;

function TfrmChat.GetChatController(): TObject;
begin
    Result := com_controller;
end;

{
    TStartChatAction implementation
}
constructor TStartChatAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-000-start-chat');

    Caption := _('Start Chat');
    Enabled := true;
end;
procedure TStartChatAction.execute(const items: IExodusItemList);
var
    idx: Integer;
    item: IExodusItem;
begin
    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];

        if item.Type_ = 'contact' then StartChat(item.UID, '', true);
    end;

    //Let's just make sure we clean up...
    item := nil;
end;

initialization
    Classes.RegisterClass(TfrmChat);

    //should we register the "start chat" action here?
    RegisterActions();
end.
