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
unit Room;

interface

uses
    Unicode, XMLTag, RegExpr, DropTarget,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, BaseChat, ComCtrls, StdCtrls, Menus, ExRichEdit, ExtCtrls,
    RichEdit2, TntStdCtrls, Buttons, TntComCtrls, Grids, TntGrids, TntMenus,
    JabberID, TntSysUtils, TntWideStrUtils, ToolWin, ImgList, JabberMsg,
    AppEvnts, IQ, Exodus_TLB, ExActions, TntExtCtrls;

type
  TMemberNode = TTntListItem;
  TRoomMember = class
  private
    _real_jid: TJabberID;

    function  getRealJID(): WideString;
    function  getRealDisplayJID(): WideString;
    procedure setRealJID(jid: WideString);

  public
    Nick: Widestring;
    jid: Widestring;
    Node: TMemberNode;
    status: Widestring;
    show: Widestring;
    blocked: boolean;
    role: WideString;
    affil: WideString;
    hideUnavailable: Boolean;
    destructor Destroy(); override;

    property real_jid: WideString read getRealJID write setRealJID;
  end;

  TfrmRoom = class(TfrmBaseChat)
    Panel6: TPanel;
    Splitter2: TSplitter;
    popRoom: TTntPopupMenu;
    popRoomRoster: TTntPopupMenu;
    lstRoster: TTntListView;
    dlgSave: TSaveDialog;
    N6: TTntMenuItem;
    popClose: TTntMenuItem;
    mnuOnTop: TTntMenuItem;
    mnuWordwrap: TTntMenuItem;
    N1: TTntMenuItem;
    popAdmin: TTntMenuItem;
    S1: TTntMenuItem;
    popNick: TTntMenuItem;
    popInvite: TTntMenuItem;
    popRegister: TTntMenuItem;
    popBookmark: TTntMenuItem;
    popClear: TTntMenuItem;
    popAdministrator: TTntMenuItem;
    popModerator: TTntMenuItem;
    popVoice: TTntMenuItem;
    popBan: TTntMenuItem;
    popKick: TTntMenuItem;
    N3: TTntMenuItem;
    popRosterSendJID: TTntMenuItem;
    popRosterChat: TTntMenuItem;
    popDestroy: TTntMenuItem;
    popConfigure: TTntMenuItem;
    N5: TTntMenuItem;
    popOwnerList: TTntMenuItem;
    popAdminList: TTntMenuItem;
    N4: TTntMenuItem;
    popModeratorList: TTntMenuItem;
    popMemberList: TTntMenuItem;
    popBanList: TTntMenuItem;
    popVoiceList: TTntMenuItem;
    popRosterSubscribe: TTntMenuItem;
    popRosterVCard: TTntMenuItem;
    N7: TTntMenuItem;
    popRosterBrowse: TTntMenuItem;
    popCopy: TTntMenuItem;
    popCopyAll: TTntMenuItem;
    N8: TTntMenuItem;
    Print1: TTntMenuItem;
    PrintDialog1: TPrintDialog;
    pnlSubj: TPanel;
    lblSubject: TTntLabel;
    SpeedButton1: TSpeedButton;
    popRoomProperties: TTntMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure MsgOutKeyPress(Sender: TObject; var Key: Char);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblSubjectURLClick(Sender: TObject);
    procedure popClearClick(Sender: TObject);
    procedure popNickClick(Sender: TObject);
    procedure popCloseClick(Sender: TObject);
    procedure popBookmarkClick(Sender: TObject);
    procedure popInviteClick(Sender: TObject);
    procedure mnuOnTopClick(Sender: TObject);
    procedure popRoomRosterPopup(Sender: TObject);
    procedure popShowHistoryClick(Sender: TObject);
    procedure popClearHistoryClick(Sender: TObject);
    procedure lstRosterDblClick(Sender: TObject);
    procedure lstRosterInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
    procedure popConfigureClick(Sender: TObject);
    procedure popKickClick(Sender: TObject);
    procedure popVoiceClick(Sender: TObject);
    procedure popVoiceListClick(Sender: TObject);
    procedure popDestroyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuWordwrapClick(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure popRosterSendJIDClick(Sender: TObject);
    procedure lstRosterData(Sender: TObject; Item: TListItem);
    procedure popRegisterClick(Sender: TObject);
    procedure sendStartPresence();
    procedure lstRosterKeyPress(Sender: TObject; var Key: Char);
    procedure lstRosterCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure popRosterSubscribeClick(Sender: TObject);
    procedure popRosterVCardClick(Sender: TObject);
    procedure popRosterBrowseClick(Sender: TObject);
    procedure popCopyClick(Sender: TObject);
    procedure popCopyAllClick(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure MsgOutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MsgOutKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnViewHistoryClick(Sender: TObject);
    procedure popRoomPropertiesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);

  private
    { Private declarations }
    jid: Widestring;            // jid of the conf. room
    _roster: TWideStringlist;   // roster for this room
    _isMUC: boolean;            // Is this room JEP-45
    _mcallback: integer;        // Message Callback
    _ecallback: integer;        // Error msg callback
    _pcallback: integer;        // Presence Callback
    _scallback: integer;        // Session callback
    _affilChangeCallback: Integer; //affiliation change
    _dcallback: integer;
    _keywords: TRegExpr;        // list of keywords to monitor for
    _hint_text: Widestring;     // Current hint for nickname
    _old_nick: WideString;      // Our own last nickname
    _passwd: WideString;        // Room password
    _disconTime: TDateTime;     // Date/Time that we last got disconnected, local TZ
    _default_config: boolean;   // auto-accept the default room configuration.
    _sent_initial_presence:boolean;//did we send presence on creation? (used for room presistence)
    _subject: WideString;
    _send_unavailable: boolean;
    _custom_pres: boolean;
    _pending_start: boolean;
    _pending_destroy: boolean;  // if user is destroying room
    _passwd_from_join_room: boolean; //was the password supplied by the Join Room DLG.
    _kick_iq: TJabberIQ;
    _voice_iq: TJabberIQ;
    _insertTab: boolean;        // Should tab or ctrl + I insert a tab?

    _my_membership_role: WideString; // My membership to the room.
    _my_affiliation: WideString; // My afiliation to the room.    

    // Stuff for nick completions
    _nick_prefix: Widestring;
    _nick_idx: integer;
    _nick_len: integer;
    _nick_start: integer;

    _notify: array[0..2] of integer;

    _session_callback: integer;
    _dropSupport: TExDropTarget;
    procedure _DragUpdate(Source: TExDropTarget; X, Y: Integer; var Action: TExDropActionType);
    procedure _DragExecute(Source: TExDropTarget; X, Y: Integer);
    procedure _DragEnd(Source: TExDropTarget);

    function  checkCommand(txt: Widestring): boolean;
    function _countPossibleNicks(tmps: Widestring): integer;
    function _selectNick(wsl: TWidestringlist): Widestring;

    procedure _sendPresence(ptype, msg: Widestring; fireClose: boolean=true);

    procedure SetJID(sjid: Widestring);
    procedure SetPassword(pass: WideString);
    procedure RenderMember(member: TRoomMember; tag: TXMLTag);
    procedure changeSubject(subj: Widestring);
    procedure configRoom(use_default: boolean = false);
    procedure AddMemberItems(tag: TXMLTag; reason: WideString = '';
        NewRole: WideString = ''; NewAffiliation: WideString = '');
    procedure showStatusCode(t: TXMLTag; r: TXMLTag = nil);
    procedure selectNicks(wsl: TWideStringList);

    function newRoomMessage(body: Widestring): TXMLTag;
    procedure changeNick(new_nick: WideString);
    procedure setupKeywords();
    procedure _EnableSubjectButton();
    function FindDuplicateRealJid(nick: Widestring; jid: Widestring): Integer;
    function GetRoomRosterHiddenCount(index: Integer): Integer;
    function GetRoomRosterVisibleCount(): Integer;
    procedure ToggleDuplicateMember(rm: TRoomMember;  tag: TXMLTag);
    procedure _checkForAdhoc();
    function _getSelectedMembers() : TXMLTag;
  protected
    btnViewHistory: TToolButton;
    {
        Get the window state associated with this window.

        Default implementation is to return a munged classname (all XML illgal
        characters escaped). Classes should override to change pref (for instance
        chat windows might save based on munged profile&jid).
    }
    function GetWindowStateKey() : WideString;override;
    function GetChatController(): TObject; override;
  published
    procedure MsgCallback(event: string; tag: TXMLTag);
    procedure PresCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);
    procedure ConfigCallback(event: string; Tag: TXMLTag);
    procedure EntityCallback(event: string; tag: TXMLTag);
    procedure autoConfigCallback(event: string; tag: TXMLTag);
    procedure roomuserCallback(event: string; tag: TXMLTag);
    procedure KickUserCB(event: string; tag: TXMLTag);
    procedure ChangeVoiceCB(event: string; tag: TXMLTag);

    class procedure AutoOpenFactory(autoOpenInfo: TXMLTag); override;
    function GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;override;

  public
    { Public declarations }
    mynick: Widestring;
    useRegisteredNick: boolean;
    COMController: TObject;

    procedure OnSessionCallback(event: string; tag: TXMLTag);
    procedure AffilChangeCallback(event: string; tag: TXMLTag);
    procedure SendMsg; override;
    procedure pluginMenuClick(Sender: TObject); override;
    procedure popupMenuClick(Sender: TObject);

    procedure ShowMsg(const tag: TXMLTag);
    procedure SendRawMessage(body, subject, xml: Widestring; fire_plugins: boolean; priority: PriorityType = None);

    function addRoomUser(jid, nick: Widestring; tag: TXMLTag = nil): TRoomMember;
    function findRoomUser(jid: widestring): TRoomMember;
    procedure removeRoomUser(jid: Widestring);
    function IsMemberBlocked(roomMemberJID: widestring): boolean;
    function GetNick(rjid: Widestring): Widestring;

    property HintText: Widestring read _hint_text;
    property getJid: WideString read jid;
    property isMUCRoom: boolean read _isMUC;
    property UseDefaultConfig: boolean read _default_config write _default_config;

    procedure OnDockedDragOver(Sender, Source: TObject; X, Y: Integer;
                               State: TDragState; var Accept: Boolean);override;
    procedure OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer);override;

    {
        Event fired when docking is complete.

        Docked property will be true, tabsheet will be assigned. This event
        is fired after all other docking events are complete.
    }
    procedure OnDocked();override;
    function GetRoomRosterOnlineCount(): Integer;
    {
        Event fired when a float (undock) is complete.

        Docked property will be false, tabsheet will be nil. This event
        is fired after all other floating events are complete.
    }
    procedure OnFloat();override;

    property MyAffiliation: WideString read _my_affiliation;   
    property MyRole: WideString read _my_membership_role;
    property Subject: Widestring read _subject;
  end;

  TJoinRoomAction = class(TExBaseAction)
  private
    constructor Create;

  public
    procedure execute(const items: IExodusItemList); override;
  end;

  TAutojoinAction = class(TExBaseAction)
  private
    _value: Widestring;

    constructor Create(flag: Boolean);

  public
    procedure execute(const items: IExodusItemList); override;
    property Value: Widestring read _value;
  end;

  TRoomPropertiesAction = class(TExBaseAction)
  private
    constructor Create;

  public
    procedure execute(const items: IExodusItemList); override;
  end;

var
  frmRoom: TfrmRoom;

  room_list: TWideStringList;

  xp_muc_presence: TXPLite;
  xp_muc_status: TXPLite;
  xp_muc_item: TXPLite;
  xp_muc_reason: TXPLite;
  xp_muc_destroy_reason: TXPLite;
  
const
    sRoom = '%s'; // Room';
    sNotifyKeyword = 'Keyword in ';
    sNotifyActivity = 'Activity in ';
    sPriorityNotifyActivity = 'Priority activity in ';
    sRoomSubjChange = '/me has changed the subject to: ';
    sRoomSubjPrompt = 'Change conference room subject';
    sRoomNewSubj = 'New subject';
    sRoomNewNick = 'New nickname';
    sRoomBMPrompt = 'Bookmark Conference Room';
    sRoomNewBookmark = 'Enter bookmark name:';
    sBlocked = 'Blocked';
    sBlock = 'Block';
    sUnblock = 'UnBlock';
    sUnknownFileType = 'Unknown file type';
    sReconnected = 'Reconnected.';
    sConnected = 'Connected.';


    sDestroyRoom = 'Destroy Conferene Room';
    sKickReason = 'Kick Reason';
    sBanReason = 'Ban Reason';
    sDestroyReason = 'Destroy Reason';
    sKickDefault = 'You have been kicked.';
    sBanDefault = 'You have been banned.';
    sDestroyDefault = 'The owner has destroyed the room.';

    sGrantVoice = 'You have been granted voice.';
    sRevokeVoice = 'Your voice has been revoked.';
    sNoVoice = 'You are not allowed to speak in this room.';
    sCurModerator = 'You are currently a moderator of this room.';

    sUserEnter = '%s has entered the room.';
    sUserLeave = '%s has left the room.';
    sNewRole = '%s has a new role of %s.';

    sRoomDestroyed = 'The conference room ''%s'' has been destroyed.';
    sReason = 'Reason:';
    sDestroyRoomConfirm = 'Do you really want to destroy the conference room? All users will be removed.';

    sStatus_100  = 'This conference room is not anonymous';
    sStatus_301  = '%s has been banned from this conference room. %s';
    sStatus_302  = 'This conference room has been destroyed.';
    sStatus_303  = '%s is now known as %s.';
    sStatus_307  = '%s has been kicked from this conference room. %s';
    sStatus_322  = '%s is not a member of this conference room and has therefore been removed from this conference room.';

    sStatus_401  = 'You supplied an invalid password to enter this room.';
    sStatus_403  = 'You are not allowed to enter this conference room because you are on the ban list.';
    sStatus_404  = 'The conference room is being created. Please try again later.';
    sStatus_404a = 'The conference room could not be entered. Please check your conference server and try again.';
    sStatus_405  = 'You are not allowed to create conference rooms.';
    sStatus_405a = 'You are not allowed to enter the conference room.';
    sStatus_407  = 'You are not on the member list for this conference room. Try and register?';
    sStatus_409  = 'Your nickname is already being used. Please select another one.';
    sStatus_413  = 'The conference room you were trying to enter is at maximum occupancy. Try again later.';
    sStatus_Unknown = 'The conference room could not be entered for an unknown reason. Please check the conference room name and server and try again.';

    sEditVoice     = 'Edit Voice List';
    sEditBan       = 'Edit Ban List';
    sEditMember    = 'Edit Member List';
    sEditAdmin     = 'Edit Admin List';
    sEditOwner     = 'Edit Owner List';
    sEditModerator = 'Edit Moderator List';

    sNoSubjectHint = 'Click the button to change the room subject.';
    sNoSubject     = 'No conference room subject';
    sMsgRosterItems = 'This message contains %d roster items.';

    sOppErrorNoPrivileges = 'Operation has failed due to lack of privileges (%s)';
    sOppErrorGeneral = 'Operation has failed (%s)';

const
    MUC_OWNER = 'owner';
    MUC_ADMIN = 'admin';
    MUC_MEMBER = 'member';
    MUC_OUTCAST = 'outcast';

    MUC_MOD = 'moderator';
    MUC_PART = 'participant';
    MUC_VISITOR = 'visitor';
    MUC_NONE = 'none';

    ROOM_TIMEOUT = 3;

    NOTIFY_ROOM_ACTIVITY = 0;
    NOTIFY_KEYWORD = 1;
    NOTIFY_PRIORITY_ROOM_ACTIVITY = 2;
    
function FindRoom(rjid: Widestring): TfrmRoom;
function StartRoom(rjid: Widestring; rnick: Widestring = '';
    Password: WideString = ''; send_presence: boolean = true;
    default_config: boolean = false; use_registered_nick: boolean = false;
    bring_to_front:boolean=true): TfrmRoom;
function IsRoom(rjid: Widestring): boolean;
function FindRoomNick(rjid: Widestring): Widestring;
procedure CloseAllRooms();

{---------------------------------------}
function ItemCompare(Item1, Item2: Pointer): integer;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Browser,
    CapPresence,
    ChatWin,
    CustomNotify,
    ExSession,
    ExActionCtrl,
    ExTreeView,
    JabberUtils,
    ExUtils,
    Entity,
    EntityCache,
    GnuGetText,
    InputPassword,
    Invite,
    Jabber1,
    JabberConst,
    JoinRoom,
    MsgDisplay,
    Notify,
    PrefController,
    Presence,
    Profile,
    PrtRichEdit,
    RTFMsgList,
    BaseMsgList,
    RegForm,
    RichEdit,
    RiserWindow,
    RoomAdminList,
    ContactController,
    RosterImages,
    RosterForm,
    Session,
    ShellAPI,
    Signals,
    StrUtils,
    xData,
    XMLNode,
    XMLUtils,
    IEMsgList,
    KeyWords,
    Dockable,
    ExodusDockManager,
    DockWindow,
    HistorySearch,
    BookmarkForm,
    DisplayName,
    COMChatController,
    RoomProperties;

{$R *.DFM}
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
function StartRoom(rjid: Widestring; rnick, Password: Widestring;
    send_presence, default_config, use_registered_nick: boolean;
    bring_to_front:boolean): TfrmRoom;
var
    f: TfrmRoom;
    tmp_jid: TJabberID;
    i : integer;
    n: Widestring;
begin
    Result := nil;

    try
        // Make sure we have TC..
        if (not MainSession.Prefs.getBool('brand_muc')) then exit;

        // Make sure activity window is showing.
        // This is a work around for a weird issue where
        // sometimes, if the activity window hasn't been shown
        // yet, then the room being joined will not be (no presence sent).
        // The EntityCallback never triggers.
        getDockManager().ShowDockManagerWindow(true, bring_to_front);

        // is there already a room window?
        i := room_list.IndexOf(rjid);
        if (i >= 0) then
            f := TfrmRoom(room_list.Objects[i])
        else begin
            // Find out nick..

            if (MainSession.Prefs.getBool('brand_prevent_change_nick') or (rnick = '')) then
                n := MainSession.Profile.getDisplayUsername()
            else
                n := rnick;

            // create a new room
            f := TfrmRoom.Create(Application);
            f.SetJID(rjid);

            if (MainSession.Prefs.getBool('brand_prevent_change_nick')) then
                f.useRegisteredNick := false
            else
                f.useRegisteredNick := use_registered_nick;

            f.MyNick := n;
            tmp_jid := TJabberID.Create(rjid);
            f.SetPassword(Password);
            f.UseDefaultConfig := default_config;

            if (send_presence) then
                f.sendStartPresence();
            //JJF todo add a displayname listener for dn changes
            f.Caption := DisplayName.getDisplayNameCache().getDisplayName(tmp_jid); //use display name if possible tmp_jid.userDisplay; //no display name here for room names
            f.Hint := TJabberID.removeJEP106(tmp_jid.jid);

            // setup prefs
            with f do begin
                lstRoster.Color := TColor(MainSession.Prefs.getInt('color_bg'));
                lstRoster.Font.Name := MainSession.Prefs.getString('roster_font_name');
                lstRoster.Font.Color := TColor(MainSession.Prefs.getInt('font_color'));
                lstRoster.Font.Size := MainSession.Prefs.getInt('roster_font_size');
                lstRoster.Font.Charset := MainSession.Prefs.getInt('roster_font_charset');
                if (lstRoster.Font.Charset = 0) then
                    lstRoster.Font.Charset := DEFAULT_CHARSET;
            end;

            // let the plugins know about the new room
            ExComController.fireNewRoom(tmp_jid.jid, TExodusChat(f.ComController));

            room_list.AddObject(rjid, f);
            tmp_jid.Free();
        end;

        f.ShowDefault(bring_to_front);

        Result := f;
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

class procedure TfrmRoom.AutoOpenFactory(autoOpenInfo: TXMLTag);
begin
    StartRoom(autoOpenInfo.getAttribute('j'), {jid}
              autoOpenInfo.getAttribute('n'), {nick}
              autoOpenInfo.getAttribute('p'), {password}
              true, //autoOpenInfo.GetAttribute('sp') = 't', {send presence on creation}
              autoOpenInfo.GetAttribute('dc') = 't', {use default config}
              autoOpenInfo.GetAttribute('rn') = 't', {use registered nickname}
              false); //don't bring these to front
end;

function TfrmRoom.GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;
var
    bm: IExodusItem;
begin
    //don't auto-open rooms we have bookmoarked for join on login
    //bm := MainSession.Bookmarks.FindBookmark(getJID);
    bm := Session.MainSession.ItemController.GetItem(getJID);
    //if no boookmark or bookmark will not auto open this room any, store auto open info
    //move this logic to the auto open factory?
    if ((event = 'disconnected') and ((bm = nil) or (bm.value['autojoin'] <> 'true'))) then begin
        //check to see if this room is bokmarked and join on startup
        Result := TXMLTag.Create(Self.classname);
        Result.setAttribute('j', getJID);
        Result.setAttribute('n', mynick);
        if (_passwd <> '') then
            Result.setAttribute('p', _passwd);
        if (_sent_initial_presence) then
            Result.setAttribute('sp', 't');
        Result.setAttribute('dc', 't'); //if config is needed, just open
        if (useRegisteredNick) then
            Result.setAttribute('rn', 't');
        useProfile := true;
    end
    else Result := inherited GetAutoOpenInfo(event, useProfile);
end;

function TfrmRoom.GetWindowStateKey() : WideString;
begin
    //todo jjf remove profile from this state key once prefs are profile aware
    Result := inherited GetWindowStateKey() + '-' +
              MungeXMLName(MainSession.Profile.Name) + '-' +
              MungeXMLName(Self.jid);
end;

function TfrmRoom.GetChatController(): TObject;
begin
    Result := ComController;
end;
{---------------------------------------}
procedure TfrmRoom.AffilChangeCallback(event: string; tag: TXMLTag);
begin
    ShowMsg(tag)
end;

{---------------------------------------}
procedure TfrmRoom.MsgCallback(event: string; tag: TXMLTag);
var
    body, xml: Widestring;
begin
    // plugin
    xml := tag.xml();
    body := tag.GetBasicText('body');
    if not (TExodusChat(ComController).fireBeforeRecvMsg(body, xml)) then
        exit;

    // We are getting a msg
    if (tag.getAttribute('type') = 'groupchat') then
        ShowMsg(tag)
    else if (tag.getAttribute('type') = 'error') then
        ShowMsg(tag);

    TExodusChat(ComController).fireAfterRecvMsg(body);
end;

{---------------------------------------}
procedure TfrmRoom.showMsg(const tag: TXMLTag);
var
    i : integer;
    Msg: TJabberMessage;
    emsg, from: Widestring;
    tmp_jid: TJabberID;
    server: boolean;
    rm: TRoomMember;
    etag: TXMLTag;
    e: TJabberEntity;
    skip_notification: Boolean;
    msgDelayTag: TXMLTag;
begin
    // display the body of the msg
    Msg := TJabberMessage.Create(tag);

    if (Msg.isXdata) then exit;
    if (Msg.Time < _disconTime) then exit;

    // Check to see if we need to increment the
    // unread msg count
    tmp_jid := TJabberID.Create(msg.FromJID);
    msgDelayTag := GetDelayTag(Msg.Tag);
    if ((msgDelayTag = nil) and
        (not Msg.IsMe) and
        (Msg.FromJID <> self.jid) and
        (not IsMemberBlocked(msg.FromJID)) and
        (tmp_jid.resource <> Self.mynick)) then begin
        // We don't want to update counts on delayed (history) msgs
        // or on msgs from "me"
        // or on msgs that are "system messages"
        // or on msgs that are from blocked members
        // or on msgs that are from my own nick
        updateMsgCount(Msg);
        updateLastActivity(Msg.Time);
    end;
    tmp_jid.Free();

    from := tag.GetAttribute('from');
    i := _roster.indexOf(from);

    if (i < 0) then begin
        // some kind of server msg..
        tmp_jid := TJabberID.Create(from);
        if (tmp_jid.resource <> '') then
            Msg.Nick := tmp_jid.resource
        else
            Msg.Nick := '';
        tmp_jid.Free();
        if (Msg.Nick = MyNick) then
            Msg.IsMe := true
        else
            Msg.IsMe := false;
        server := true;

        if (tag.getAttribute('type') = 'error') then begin
            etag := tag.GetFirstTag('error');
            if (etag <> nil) then begin
                emsg := etag.QueryXPData('/error/text[@xmlns="urn:ietf:params:xml:ns:xmpp-streams"]');
                if (emsg = '') then
                    emsg := etag.Data;
                if (emsg = '') and
                    ((etag.GetAttribute('code') = '403') or
                     (etag.GetAttribute('code') = '401')) and
                    (etag.GetAttribute('type') = 'auth') then
                    emsg := _('Not authorized.');
                if (emsg = '') then
                    emsg := _('Your message to the room bounced.');
                Msg.Body := _('ERROR: ') + emsg;
            end
            else
                Msg.Body := _('ERROR: ') + _('Your message to the room bounced.');
            DisplayMsg(Msg, MsgList);
            exit;
        end;
        
        // Room config update?
        etag := tag.GetFirstTag('x');
        if (etag <> nil) and
           (etag.GetAttribute('xmlns') = XMLNS_MUCUSER) then begin
            etag := etag.GetFirstTag('status');
            if (etag <> nil) and
               (etag.GetAttribute('code') = '104') then begin
                // We did get a room update notification.
                // Need to disco.
                e := jEntityCache.getByJid(Self.jid, '');
                // e can be null, not doing this check can cause crashes
                if ( e <> nil ) then
                    e.refresh(MainSession);
            end;
        end;

    end
    else begin
        rm := TRoomMember(_roster.Objects[i]);
        // if blocked ignore anything they say, even subject changes.
        if (rm.blocked) then
           exit;
        Msg.Nick := rm.Nick;
        Msg.IsMe := (Msg.Nick = MyNick);
        server := false;
    end;
{** JJF msgqueue refactor

    skip_notification := MainSession.Prefs.getBool('queue_not_avail') and
                         ((MainSession.Show = 'away') or
                          (MainSession.Show = 'xa') or
                          (MainSession.Show = 'dnd'));
**}
    skip_notification := false;                          
    if (skip_notification = false) then begin
      // this check is needed only to prevent extraneous regexing.
        if (not server)
{** JJF msgqueue refactor
        and (not MainSession.IsPaused)
**}
        then begin
            // check for keywords
            if ((_keywords <> nil) and (_keywords.Exec(Msg.Body))) then begin
                DoNotify(Self, _notify[NOTIFY_KEYWORD],
                         _(sNotifyKeyword) + Self.Caption + ': ' + _keywords.Match[1],
                         RosterTreeImages.Find('conference'), 'notify_keyword');
                Msg.highlight := true;
            end
            else if (not Msg.IsMe) and ((Msg.FromJID <> self.jid) or (Msg.Subject <> '')) and (msgDelayTag = nil) then
              if ((Msg.Priority = High) and (_notify[NOTIFY_PRIORITY_ROOM_ACTIVITY] > 0)) then
                DoNotify(Self, _notify[NOTIFY_PRIORITY_ROOM_ACTIVITY],
                         GetDisplayPriority(Msg.Priority) + ' ' + _(sPriorityNotifyActivity) + Self.Caption,
                         RosterTreeImages.Find('conference'), 'notify_priority_roomactivity')
              else
                DoNotify(Self, _notify[NOTIFY_ROOM_ACTIVITY],
                         _(sNotifyActivity) + Self.Caption,
                         RosterTreeImages.Find('conference'), 'notify_roomactivity');
        end;
    end;

    if (Msg.Subject <> '') then begin
        _subject := Msg.Subject;
        if (_subject = '') then begin
            if (SpeedButton1.Enabled = false) then
              lblSubject.Hint := ''
            else
              lblSubject.Hint := _(sNoSubjectHint);
            lblSubject.Caption := _(sNoSubject);
        end
        else begin
           if (SpeedButton1.Enabled = false) then
              lblSubject.Hint := ''
            else
              lblSubject.Hint := Tnt_WideStringReplace(_subject, '|', Chr(13),[rfReplaceAll, rfIgnoreCase]);
            lblSubject.Caption := Tnt_WideStringReplace(_subject, '&', '&&',[rfReplaceAll, rfIgnoreCase]);
            Msg.Body := _(sRoomSubjChange) + Msg.Subject;
            DisplayMsg(Msg, MsgList);
        end;
    end
    else if (Msg.Body <> '') then begin
        DisplayMsg(Msg, MsgList);

        // log if we have logs for TC turned on.
        Msg.isMe := False;
        LogMessage(Msg);

        if (GetActiveWindow = Self.Handle) and (MsgOut.Visible) and (MsgOut.Enabled) then begin
            try
                MsgOut.SetFocus();
            except
                // To handle Cannot focus exception
            end;
        end;
    end;


    Msg.Free();
end;

{---------------------------------------}
procedure TfrmRoom.SendRawMessage(body, subject, xml: Widestring; fire_plugins: boolean; priority: PriorityType);
var
    add_xml: Widestring;
    msg: TJabberMessage;
    mtag: TXMLTag;
    temptag: TXMLTag;
begin
    //
    msg := TJabberMessage.Create(jid, 'groupchat', body, Subject, priority);
    msg.nick := MyNick;
    msg.isMe := true;
    msg.ID := MainSession.generateID();

    // additional plugin madness


    if (fire_plugins) then begin
        add_xml := TExodusChat(ComController).fireAfterMsg(body);
        msg.Body := body;
    end;
    mtag := msg.GetTag;

    if (add_xml <> '') then
      mtag.addInsertedXML(add_xml);

    if (xml <> '') then
        mtag.AddInsertedXML(xml);

    temptag := TXMLTag.Create(mtag);
    MainSession.SendTag(mtag); // Tag gets "cleared"
    if (comcontroller <> nil) then
    begin
        TExodusChat(ComController).fireSentMessageXML(temptag);
    end;
    temptag.Free();

    msg.Free();
end;

{---------------------------------------}
procedure TfrmRoom.SendMsg;
var
    allowed: boolean;
    txt: Widestring;
    xhtml: TXMLTag;
    xml: Widestring;
    priority: PriorityType;
//    e: TJabberEntity;
begin
    // Send the actual message out
    txt := getInputText(MsgOut);

    // plugin madness
    if (ComController <> nil) then
      allowed := TExodusChat(ComController).fireBeforeMsg(txt)
    else
      allowed := true;

    if ((allowed = false) or (txt = '')) then exit;

    if (txt[1] = '/') then begin
        if (checkCommand(txt)) then
            exit;
    end;

    xml := '';

 
    
//make sure room supports xhtml-im before sending     
    if (mainSession.Prefs.getBool('richtext_enabled')) then begin
//        e := jEntityCache.getByJid(Self.jid, '');
//        if ((e <> nil) and e.hasFeature(JabberConst.XMLNS_XHTMLIM)) then begin
            xhtml := getInputXHTML(MsgOut);
            if (xhtml <> nil) then
                xml := xhtml.XML;
            FreeAndNil(xhtml);
//        end;
    end;

    if (MainSession.Prefs.getBool('show_priority')) then
       priority := PriorityType(GetValuePriority(cmbPriority.Text))
    else
       priority := none;

    SendRawMessage(txt, '', xml, true, priority);

    inherited;
end;

{---------------------------------------}
function TfrmRoom._countPossibleNicks(tmps: Widestring): integer;
var
    m: TRoomMember;
    r, i: integer;
begin
    r := 0;
    for i := 0 to _roster.Count - 1 do begin
        m := TRoomMember(_roster.Objects[i]);
        if (Pos(tmps, m.Nick) = 0) then inc(r);
    end;
    Result := r;
end;

{---------------------------------------}
function TfrmRoom._selectNick(wsl: TWidestringlist): Widestring;
var
    nick, tmps, last: Widestring;
    r: integer;
begin
    // icky, since nicks can have spaces... just look until we find one.
    nick := '';
    tmps := '';
    last := '';
    repeat
        if (tmps <> '') then tmps := tmps + ' ';
        tmps := tmps + wsl[0];
        wsl.Delete(0);
        r := _countPossibleNicks(tmps);
        if (r = 1) then
            // we have just a single match
            nick := tmps
        else if (r > 1) then
            // we have more than one possible
            last := tmps
        else if (last <> '') and (r = 0) then
            // the last one matched many, but this one matches none...
            // just use the last
            nick := tmps;
    until (nick <> '') or (wsl.Count = 0);

    Result := nick;
end;

{---------------------------------------}
procedure TfrmRoom._sendPresence(ptype, msg: Widestring; fireClose: boolean);

var
    p: TJabberPres;
begin
    p := TCapPresence.Create();
    p.toJID := TJabberID.Create(jid + '/' + mynick);

    if (ptype = 'unavailable') then
        p.PresType := ptype
    else
        p.Show := ptype;

    p.Status := msg;

    MainSession.SendTag(p);

    if (ptype = 'unavailable') then begin
        _send_unavailable := false;
        TExodusChat(ComController).fireClose();
        if (fireClose) then
            Self.Close();
    end;
end;

{---------------------------------------}
function TfrmRoom.checkCommand(txt: Widestring): boolean;
var
    tmps, nick, cmd: Widestring;
    rest: Widestring;
    wsl: TWideStringList;
    m: TJabberMessage;
    i, c: integer;
    j: TJabberID;
    s: TXMLTag;
begin
    // check for various / commands
    result := false;

    wsl := TWideStringList.Create();
    Split(txt, wsl);
    if (wsl.Count = 0) then begin
        wsl.Destroy();
        exit;
    end;
    cmd := wsl[0];
    if (cmd = '') or (cmd[1] <> '/') then begin
        wsl.Destroy();
        exit;
    end;

    wsl.Delete(0);
    c := pos(cmd, txt) + length(cmd) + 1;
    rest := copy(txt, c, length(txt) - c + 1);

    if (cmd = '/clear') then begin
        msgList.Clear();
        Result := true;
    end
    else if (cmd = '/config') then begin
        configRoom();
        Result := true;
    end
    else if (cmd = '/help') then begin
        m := TJabberMessage.Create(self.jid, 'groupchat',
        '/ commands: '#13#10 +
        '/clear'#13#10 +
        '/config'#13#10 +
        '/subject <subject>'#13#10 +
        '/invite <jid>'#13#10 +
        '/block <nick>'#13#10 +
        '/ignore <nick>'#13#10 +
        '/kick <nick>'#13#10 +
        '/ban <nick>'#13#10 +
        '/nick <nick>'#13#10 +
        '/chat <nick>'#13#10 +
        '/query <nick>'#13#10 +
        '/msg <nick>'#13#10 +
        '/join <room@server/nick>'#13#10 +
        '/leave <msg>'#13#10 +
        '/part <msg>'#13#10 +
        '/partall <msg>'#13#10 +
        '/voice <nick>'#13#10 +
        '/away <msg>'#13#10 +
        '/xa <msg>'#13#10 +
        '/dnd <msg>'#13#10, '');
        DisplayMsg(m, MsgList);
        m.Destroy();
        Result := true;
    end
    else if (cmd = '/nick') then begin
        // change nickname
        if (rest = '') then exit;
        if (not MainSession.Prefs.getBool('brand_prevent_change_nick')) then
            changeNick(rest);
        Result := true;
    end
    else if ((cmd = '/chat') or (cmd = '/query')) then begin
        // chat with this user
        nick := _selectNick(wsl);
        if (nick = '') then exit;
        StartChat(self.jid, nick, true, nick);
        Result := true;
    end
    else if (cmd = '/msg') then begin
        // send a msg to this person:
        // /msg foo this is the actual msg to send.
        nick := _selectNick(wsl);
        if ((nick = '') or (wsl.Count = 0)) then exit;

        tmps := '';
        for i := 0 to wsl.count - 1 do
            tmps := tmps + wsl[i] + ' ';

        nick := self.jid + '/' + nick;
        m := TJabberMessage.Create(nick, 'normal', tmps,
            _('Groupchat private message'));
        // XXX: do we want to do plugin stuff for priv msgs?
        MainSession.SendTag(m.GetTag);
        m.Free();
        Result := true;
    end
    else if (cmd = '/subject') then begin
        // set subject
        changeSubject(rest);
        Result := true;
    end
    else if (cmd = '/invite') then begin
        ShowInvite(Self.jid, wsl);
        Result := true;
    end
    else if (cmd = '/kick') then begin
        selectNicks(wsl);
        popKickClick(popKick);
        Result := true;
    end
    else if (cmd = '/ban') then begin
        selectNicks(wsl);
        popKickClick(popBan);
        Result := true;
    end
    else if (cmd = '/voice') then begin
        selectNicks(wsl);
        popVoiceClick(nil);
        Result := true;
    end
    else if ((cmd = '/block') or (cmd = '/ignore')) then begin
        selectNicks(wsl);
        Result := true;
    end
    else if ((cmd = '/part') or (cmd = '/leave')) then begin
        tmps := '';
        for i := 0 to wsl.count - 1 do
            tmps := tmps + wsl[i] + ' ';
        _sendPresence('unavailable', tmps);
        Result := true;
    end
    else if (cmd = '/join') then begin
        // join a new room
        tmps := wsl[0];
        j := TJabberID.Create(tmps);
        if (j.resource = '') then
            nick := mynick
        else
            nick := j.Resource;

        // If they specified no room, show the GUI, otherwise, just join
        if (j.user = '') then
            StartJoinRoom(j, nick, '')
        else
            StartRoom(j.jid, j.resource);
        j.Free();
        Result := true;
    end
    else if (cmd = '/partall') then begin
        // close all rooms??
        tmps := '';
        for i := 0 to wsl.count - 1 do
            tmps := tmps + wsl[i] + ' ';
        s := TXMLTag.Create('partall');
        s.AddCData(tmps);
        MainSession.FireEvent('/session/close-rooms', s);
        s.Free();
        Result := true;
    end
    else if ((cmd = '/away') or (cmd = '/xa') or (cmd = '/dnd')) then begin
        tmps := '';
        for i := 0 to wsl.count - 1 do
            tmps := tmps + wsl[i] + ' ';

        tmps := Trim(tmps);
        if (tmps = '') then begin
            // we are no longer custom away
            _custom_pres := false;
            _sendPresence(MainSession.Show, MainSession.Status);
        end
        else begin
            // set a custom away msg
            _custom_pres := true;
            if (cmd = '/away') then
                _sendPresence('away', tmps)
            else if (cmd = '/xa') then
                _sendPresence('xa', tmps)
            else if (cmd = '/dnd') then
                _sendPresence('dnd', tmps);
        end;
        Result := true;
    end
    else if (cmd = '/me') then begin
        Result := false;
    end
    else begin
        m := TJabberMessage.Create(self.jid, 'groupchat', 'Unknown / command: "' +
                    cmd +'"'#13#10 + 'Try /help', '');
        DisplayMsg(m, MsgList);
        m.Destroy();
        Result := true;
    end;

    wsl.Destroy();
    if (Result) then
    begin
        ClearMsgOut();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.SessionCallback(event: string; tag: TXMLTag);
var
    tmps: Widestring;
    jid1, jid2: TJabberID;
    i: integer;
    member: TRoomMember;
begin
    // session callback...look for our own presence changes
    if (event = '/session/disconnected') then begin
        // post a msg to the window and disable the text input box.
        MsgOut.Visible := false;
        MsgList.DisplayPresence('', _('You have been disconnected.'), '', 0);

        MainSession.UnRegisterCallback(_mcallback);
        MainSession.UnRegisterCallback(_ecallback);
        MainSession.UnRegisterCallback(_pcallback);
        MainSession.UnRegisterCallback(_dcallback);
        MainSession.UnRegisterCallback(_affilChangeCallback);
        _mcallback := -1;
        _ecallback := -1;
        _pcallback := -1;
        _dcallback := -1;
        _affilChangeCallback := -1;

        _roster.Clear();
        lstRoster.Items.Count := 0;
        lstRoster.Invalidate();

        _disconTime := Now();
    end
    else if (event = '/session/presence') then begin
        // We changed our own presence, send it to the room
        if (MainSession.Invisible) then exit;
        if (_custom_pres) then exit;

        // previously disconnected
        if ((_mcallback = -1) or
            (_pending_start)) then begin
            MsgOut.Visible := true;
            if (_pending_start) then
                MsgList.DisplayPresence('', sConnected, '', 0)
            else
                MsgList.DisplayPresence('', sReconnected, '', 0);
            SetJID(Self.jid);             // re-register callbacks
            sendStartPresence();
        end else begin
            _sendPresence(MainSession.Show, MainSession.Status);
        end;
    end
    else if (event = '/session/close-rooms') then begin
        // close this room.
        if (tag <> nil) then tmps := tag.Data() else tmps := '';
        _sendPresence('unavailable', tmps);
    end
    else if (event = '/session/prefs') then begin
        setupKeywords();
    end
    else if ((event = '/session/block') or
             (event = '/session/unblock')) then
    begin
        jid1 := TJabberID.Create(tag.GetAttribute('jid'));
        if (jid1 <> nil) then
        begin
            for i := 0 to _roster.Count - 1 do
            begin
                member := TRoomMember(_roster.Objects[i]);
                if (member <> nil) then
                begin
                    jid2 := TJabberID.Create(member.real_jid);
                    if ((jid2 <> nil) and
                        (jid1.jid = jid2.jid)) then
                    begin
                        member.blocked := (event = '/session/block');
                        jid2.Free();
                        lstRoster.Invalidate();
                        break;
                    end;
                    jid2.Free();
                end;
            end;
        end;
        jid1.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.roomuserCallback(event: string; tag: TXMLTag);
var
    q, ident: TXMLTag;
    tempnick: Widestring;
begin
    // we got back a response to our roomuser_item request.
    // we need to process it and then send start presence to room.
    if ((event <> 'timeout') and
        (tag <> nil)) then begin
        useRegisteredNick := false;
        if (tag.GetAttribute('type') = 'result') then begin
            q := tag.GetFirstTag('query');
            ident := q.GetFirstTag('identity');
            // It is possible to get back a blank nick which is bad.
            tempnick := ident.GetAttribute('name');
            if (Length(tempnick) > 0) then
                MyNick := tempnick;
        end;
        sendStartPresence();
    end;
end;

{---------------------------------------}
function TfrmRoom.newRoomMessage(body: Widestring): TXMLTag;
begin
    Result := TXMLTag.Create('message');
    Result.setAttribute('from', jid);
    Result.setAttribute('type', 'groupchat');
    Result.AddBasicTag('body', body);
end;

{---------------------------------------}
procedure TfrmRoom.presCallback(event: string; tag: TXMLTag);
var
    emsg, ptype, from: Widestring;
    tmp_jid, from_jid: TJabberID;
    from_base: Widestring;
    i: integer;
    member: TRoomMember;
    mtag, t, itag, xtag, etag, drtag: TXMLTag;
    ecode, scode, tmp1, tmp2, reason: Widestring;
    e: TJabberEntity;
begin
    // We are getting presence
    from := tag.getAttribute('from');
    ptype := tag.getAttribute('type');
    i := _roster.indexOf(from);
    if (from <> '') then begin
        from_jid := TJabberID.Create(from);
        from_base := from_jid.jid;
    end
    else
        from_jid := nil;

    // check for MUC presence
    xtag := tag.QueryXPTag(xp_muc_presence);
    if ((xtag <> nil) and (not _isMUC)) then
        _isMUC := true;

    if ((ptype = 'error') and ((from = jid) or (from = jid + '/' + MyNick))) then begin
        // check for various presence errors
        etag := tag.GetFirstTag('error');
        if (etag <> nil) then begin
            ecode := etag.GetAttribute('code');
            if (ecode = '409') then begin
                MessageDlgW(_(sStatus_409), mtError, [mbOK], 0, from_base);
                if (_old_nick = '') then begin
                    Self.Close();
                    exit;
                end
                else
                    myNick := _old_nick;
            end
            else if (ecode = '401') then begin
                e := jEntityCache.getByJid(Self.jid, '');
                if ((e <> nil) and
                    ((e.hasFeature('muc_passwordprotected') or
                     e.hasFeature('muc_password') or
                     e.hasFeature('muc-passwordprotected')) or
                     e.hasFeature('muc-password'))) then begin
                    if (_passwd = '') then begin
                        // this room needs a passwd, and they didn't give us one..
                        if (InputQueryW(e.Jid.jid, _('Room Password'), _passwd, true) = false) then begin
                            // Cancel selected, just close
                            Self.Close;
                        end
                        else begin
                            // Try new password.
                            _passwd_from_join_room := false;
                            sendStartPresence();
                        end;
                        exit;
                    end
                    else begin
                        // 401 error IS due to bad password so show password error
                        MessageDlgW(_(sStatus_401), mtError, [mbOK], 0, from_base);
                        if (_passwd_from_join_room) then begin
                            Self.Close();
                            tmp_jid := TJabberID.Create(from);
                            StartJoinRoom(tmp_jid, MyNick, '');
                            tmp_jid.Free();
                        end
                        else begin
                            if (InputQueryW(e.Jid.jid, _('Room Password'), _passwd, true) = false) then begin
                                // Cancel selected, just close
                                Self.Close;
                            end
                            else begin
                                // Try new password.
                                sendStartPresence();
                            end;
                        end;
                        exit;
                    end;
                end;
                // 401 is NOT due to password, just exit
                exit;
            end
            else if (ecode = '404') then begin
                if (etag.QueryXPTag('/error/item-not-found') <> nil) then
                  MessageDlgW(_(sStatus_404), mtError, [mbOK], 0, from_base)
                else if (etag.QueryXPTag('/error/remote-server-not-found') <> nil) then
                  MessageDlgW(_(sStatus_404a), mtError, [mbOK], 0, from_base);

                Self.Close();
                exit;
            end
            else if (ecode = '405') then begin
                MessageDlgW(_(sStatus_405a), mtError, [mbOK], 0, from_base);
                Self.Close();
                exit;
            end
            else if (ecode = '407') then begin
                e := jEntityCache.getByJid(Self.jid, '');
                //If can't join, first check if we are allowed to regiter
                if  (e <> nil) then begin
                  if (e.hasFeature('muc-members-openreg') or e.hasFeature('muc-openreg')) then begin
                    if (MessageDlgW(_(sStatus_407), mtConfirmation, [mbYes, mbNo], 0, from_base) = mrYes) then begin
                      t := TXMLTag.Create('register');
                      t.setAttribute('jid', Self.jid);
                      MainSession.FireEvent('/session/register', t);
                      t.Free();
                    end;
                  end
                  else
                    //If can't register, can't enter
                    MessageDlgW(_(sStatus_405a), mtError, [mbOK], 0, from_base)
                  end;
                Self.Close();
                exit;
            end
            else if (ecode = '403') then begin
                emsg := etag.QueryXPData('/error/text[@xmlns="urn:ietf:params:xml:ns:xmpp-streams"]');
                if (emsg = '') then
                    emsg := etag.Data();
                if (emsg = '') then
                    emsg := _(sStatus_403);
                MessageDlgW(emsg, mtError, [mbOK], 0, from_base);
                Self.Close();
                exit;
            end
            else if (ecode = '413') then begin
                //Note:  This is the JINC code for max-occupants
                MessageDlgW(_(sStatus_413), mtError, [mbOK], 0, from_base);
                Self.Close();
                exit;
            end
        end;

        MessageDlgW(_(sStatus_Unknown), mtError, [mbOK], 0, from_base);
        Self.Close();
        exit;
    end

    else if ptype = 'unavailable' then begin
        t := tag.QueryXPTag(xp_muc_status);
        if ((from = jid) or (from = jid + '/' + MyNick)) then begin
            if (t <> nil) then
                ShowStatusCode(t, tag.QueryXPTag(xp_muc_reason))
            else if (_pending_destroy) then begin
                // Show destroy reason
                tmp_jid := TJabberID.Create(from);
                //don't use display name here for room name
                reason := WideFormat(_(sRoomDestroyed), [tmp_jid.userDisplay]);
                drtag := tag.QueryXPTag(xp_muc_destroy_reason);
                if ((drtag <> nil) and (drtag.Data <> '')) then begin
                    reason := reason + ''#13#10 + _(sReason) + ' ' + drtag.Data;
                end;

                MessageDlgW(reason, mtInformation, [mbOK], 0,
                            TJabberID.removeJEP106(from_base));
                tmp_jid.Free();
                _pending_destroy := false;
            end;
            Self.Close();
            exit;
        end
        else if (i >= 0) then begin
            member := TRoomMember(_roster.Objects[i]);

            if (t <> nil) then begin
                scode := t.GetAttribute('code');
                if (scode = '303') then begin
                    // this user has changed their nick..
                    itag := tag.QueryXPTag(xp_muc_item);
                    if (itag <> nil) then begin
                        tmp1 := member.Nick;
                        tmp2 := itag.GetAttribute('nick');
                        mtag := newRoomMessage(WideFormat(_(sStatus_303),
                            [tmp1, tmp2]));
                        ShowMsg(mtag);
                    end;

                    // update their room jid and nick
                    // doing this to avoid causing second enter message
                    tmp1 := jid + '/' + tmp2;
                    member.Nick := tmp2;
                    member.jid := tmp1;
                    _roster.Delete(i);
                    _roster.AddObject(member.jid, member);
                    _roster.Sort;
                end
                else if ((scode = '301') or (scode = '307')) then begin
                    itag := tag.QueryXPTag(xp_muc_reason);
                    if (itag <> nil) then tmp1 := itag.Data else tmp1 := '';
                    if (scode = '301') then tmp2 := _(sStatus_301)
                    else if (scode = '307') then tmp2 := _(sStatus_307)
                    else if (scode = '322') then tmp2 := _(sStatus_322);

                    mtag := newRoomMessage(WideFormat(tmp2, [member.Nick, tmp1]));
                    ShowMsg(mtag);
                end;
            end
            else if ((member.role <> '') and (MainSession.Prefs.getBool('room_joins'))) then begin
                mtag := newRoomMessage(WideFormat(_(sUserLeave), [member.Nick]));
                ShowMsg(mtag);
            end;

            if (xtag <> nil) then begin
                 t := xtag.GetFirstTag('item');
                 if (t <> nil) then begin
                      member.role := t.GetAttribute('role');
                      member.affil := t.GetAttribute('affiliation');
                      ToggleDuplicateMember(member, tag);
                      //If no affiliation exists for the nick, remove it.
                      if (member.affil = 'none') then
                          removeRoomUser(from)
                      else begin
                          //member or higher, went offline, render new presence status
                          RenderMember(member, tag);
                          lstRoster.Items.Count := GetRoomRosterVisibleCount();
                          lstRoster.Invalidate();
                      end;
                 end;
            end;
        end
        else begin
           // Add unavailable members or higher to the roster
           itag := tag.QueryXPTag(xp_muc_item);
           if (itag <> nil) then begin
              if (itag.GetAttribute('affiliation') <> 'none') then begin
                  tmp_jid := TJabberID.Create(from);
                  AddRoomUser(from, tmp_jid.resource, tag);
              end;
           end;
        end;
    end
    else begin
        // SOME KIND OF AVAIL
        tmp_jid := TJabberID.Create(from);

        if (i < 0) then begin
            // this is a new member
            member := AddRoomUser(from, tmp_jid.resource, tag);

            // show new user message
            if (xtag <> nil) then begin
                _isMUC := true;

                if (MainSession.Prefs.getBool('room_joins')) then begin
                    mtag := newRoomMessage(WideFormat(_(sUserEnter), [member.nick]));
                    showMsg(mtag);
                end;

                t := xtag.GetFirstTag('status');
                if ((t <> nil) and (t.getAttribute('code') = '201')) then begin
                    // we are the owner... config the room
                    _isMUC := true;
                    configRoom(_default_config);
                end;
            end;
        end
        else begin
            member := TRoomMember(_roster.Objects[i]);

            tmp1 := '';
            itag := tag.QueryXPTag(xp_muc_item);
            if (itag <> nil) then begin
                _isMUC := true;
                tmp1 := itag.getAttribute('role');
            end;

            if (MainSession.Prefs.getBool('room_joins')) then begin
                mtag := newRoomMessage(WideFormat(_(sUserEnter), [member.nick]));
                showMsg(mtag);
            end;

            mtag := nil;
            if ((tmp1 <> '') and (member.nick = myNick)) then begin
                // someone maybe changed my role
                if ((member.role = MUC_VISITOR) and (tmp1 = MUC_PART)) then
                    mtag := newRoomMessage(_(sGrantVoice))
                else if ((member.role = MUC_PART) and (tmp1 = MUC_VISITOR)) then
                    mtag := newRoomMessage(_(sRevokeVoice))
                else if (member.role <> tmp1) then
                    mtag := newRoomMessage(WideFormat(_(sNewRole), [member.nick, tmp1]));
                if (mtag <> nil) then showMsg(mtag);
            end;
        end;

        // get extended stuff for MUC, and update the member struct
        if (xtag <> nil) then begin
            _isMUC := true;
            t := xtag.GetFirstTag('item');
            if (t <> nil) then begin
                member.role := t.GetAttribute('role');
                member.real_jid := t.GetAttribute('jid');
                member.affil := t.GetAttribute('affiliation');
            end;
        end;

        // for all protocols, our nick is our resource
        member.nick := tmp_jid.resource;
        tmp_jid.Free();

        // check for role=none to fixup bugs in some mu-c servers.
        if (member.role = 'none') then begin
            if (i >= 0) then
              RemoveRoomUser(from);
            exit;
        end;

        if (member.Nick = myNick) then begin
            if (i < 0) then begin
                // this is the first time I've joined the room
                 mtag := nil;
                try
                    if (member.Nick = myNick) then begin
                        if (member.Role = MUC_VISITOR) then
                            mtag := newRoomMessage(_(sNoVoice))
                        else if (member.Role = MUC_MOD) then
                            mtag := newRoomMessage(_(sCurModerator));
                        if (mtag <> nil) then showMsg(mtag);
                    end;
                finally
                    mtag.Free();
                end;
            end;

            //hold onto my role
            _my_membership_role := member.role;
            _my_affiliation := member.affil;
            // check to see what my role is
            _send_unavailable := true;

            // These are owner-only things..
            popConfigure.Enabled := (member.Affil = MUC_OWNER);
            popDestroy.Enabled := popConfigure.Enabled;
            popAdminList.Enabled := popConfigure.Enabled;
            popAdministrator.Enabled := popConfigure.Enabled;
            popOwnerList.Enabled := popConfigure.Enabled;

            // Moderator stuff
            popAdmin.Enabled := (member.Role = MUC_MOD) or popConfigure.Enabled;
            popKick.Enabled := popAdmin.Enabled;
            popBan.Enabled := popAdmin.Enabled;
            popVoice.Enabled := popAdmin.Enabled;

            // Admin stuff
            popModerator.Enabled := (member.affil = MUC_ADMIN) or popConfigure.Enabled;

            // Voice stuff
            MsgOut.ReadOnly := (member.role = MUC_VISITOR);
            if (MsgOut.Readonly) then
            begin
                ClearMsgOut();
            end;
            
            // Who can change subject
            _EnableSubjectButton();

            // Am I the owner, thus no registration option
            popRegister.Enabled := (member.affil <> MUC_OWNER);

            // Make sure we have the correct icon showing (adhoc/persistent)
            _checkForAdhoc();
        end;
        RenderMember(member, tag);
    end;

    from_jid.Free();

end;

{---------------------------------------}
function TfrmRoom.addRoomUser(jid, nick: Widestring; tag: TXMLTag = nil): TRoomMember;
var
    member: TRoomMember;
    itag: TXMLTag;
begin
    //
    member := TRoomMember.Create;
    member.JID := jid;
    member.Nick := nick;
    member.hideUnavailable := false;
    if (tag <> nil) then begin
        itag := tag.QueryXPTag(xp_muc_item);
        if (itag <> nil) then begin
            member.role := itag.GetAttribute('role');
            member.affil := itag.GetAttribute('affiliation');
            member.real_jid := itag.GetAttribute('jid');
        end;
    end;
    _roster.AddObject(jid, member);
    _roster.Sort;
    ToggleDuplicateMember(member, tag);

    RenderMember(member, tag);
    lstRoster.Items.Count := GetRoomRosterVisibleCount();
    lstRoster.Invalidate();

    Result := member;
end;

{---------------------------------------}
function TfrmRoom.findRoomUser(jid: widestring): TRoomMember;
var
    i: integer;
begin
    Result := nil;
    if (Trim(jid) = '') then exit;

    i := _roster.IndexOf(jid);

    if (i >= 0) then
    begin
        Result := TRoomMember(_roster.Objects[i]);
    end;
end;

{---------------------------------------}
procedure TfrmRoom.removeRoomUser(jid: Widestring);
var
    i: integer;
begin
    //
    i := _roster.IndexOf(jid);
    if (i = -1) then exit;

    _roster.Delete(i);
    _roster.Sort;
    if (i >= 0) then begin
        lstRoster.Items.Count := GetRoomRosterVisibleCount();
        lstRoster.Invalidate();
    end;
end;

{---------------------------------------}
function TfrmRoom.IsMemberBlocked(roomMemberJID: widestring): boolean;
var
    i: integer;
    member: TRoomMember;
begin
    Result := false;
    if (Trim(jid) = '') then exit;

    i := _roster.IndexOf(roomMemberJID);
    if (i >= 0) then
    begin
        member := TRoomMember(_roster.Objects[i]);
        if (member <> nil) then
        begin
            Result := member.blocked;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.showStatusCode(t: TXMLTag; r: TXMLTag);
var
    msg, fmt, reason: WideString;
    scode: WideString;
begin
    scode := t.getAttribute('code');
    if (r <> nil) then reason := r.Data else reason := '';

    fmt := '';

    if (scode = '301') then fmt := _(sStatus_301)
    else if (scode = '302') then fmt := _(sStatus_302)
    else if (scode = '303') then fmt := _(sStatus_303)
    else if (scode = '307') then fmt := _(sStatus_307)
    else if (scode = '322') then fmt := _(sStatus_322)
    else if (scode = '403') then msg := _(sStatus_403)
    else if (scode = '405') then msg := _(sStatus_405)
    else if (scode = '407') then msg := _(sStatus_407)
    else if (scode = '409') then msg := _(sStatus_409);

    if (fmt <> '') then
        msg := WideFormat(fmt, [MyNick, reason]);

    if (msg <> '') then
        MessageDlgW(msg, mtInformation, [mbOK], 0);
end;

{---------------------------------------}
procedure TfrmRoom.configRoom(use_default: boolean);
var
    cb: TPacketEvent;
    iq: TJabberIQ;
    x: TXMLTag;
begin
    if (use_default) then
        cb := autoConfigCallback
    else
        cb := configCallback;

    iq := TJabberIQ.Create(MainSession, MainSession.generateID(), cb, 10);
    with iq do begin
        toJid := Self.jid;
        Namespace := XMLNS_MUCOWNER;
        iqType := 'get';
    end;

    if (use_default) then begin
        iq.iqType := 'set';
        x := iq.qTag.AddTag('x');
        x.setAttribute('xmlns', 'jabber:x:data');
        x.setAttribute('type', 'submit');
    end;
    iq.Send();

end;

{---------------------------------------}
procedure TfrmRoom.autoConfigCallback(event: string; tag: TXMLTag);
begin
    if ((event <> 'xml') or (tag.getAttribute('type') <> 'result')) then begin
        MessageDlgW(_('There was an error using the default room configuration. Configuring it manually.'),
            mtError, [mbOK], 0);
        configRoom();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.configCallback(event: string; Tag: TXMLTag);
var
    iq: TJabberIQ;
    x: TXMLTag;
    roomCaption: widestring;
    roomJID: TJabberID;
begin
    // We are configuring the room
    if ((event = 'xml') and (tag.GetAttribute('type') = 'result')) then begin
        roomJID := TJabberID.Create(jid);
        roomCaption := roomJID.userDisplay + _(' Configuration');
        if (ShowXDataEx(tag, roomCaption) = false) then begin
            // there are no fields... submit a blank form.
            iq := TJabberIQ.Create(MainSession, MainSession.generateID());
            iq.toJid := Self.Jid;
            iq.Namespace := XMLNS_MUCOWNER;
            iq.iqType := 'set';
            x := iq.qTag.AddTag('x');
            x.setAttribute('xmlns', 'jabber:x:data');
            x.setAttribute('type', 'submit');
            iq.Send();
        end;
        roomJID.Free;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.RenderMember(member: TRoomMember; tag: TXMLTag);
var
    i: integer;
    p: TJabberPres;
    jid: TJabberID;
begin
    // show the member
    if member = nil then exit;

    if tag = nil then
        member.show := ''

    else begin
        p := TJabberPres.Create(tag);
        p.parse();

        // If in non-anon room, see if member is blocked on roster.
        // If so, block in room.
        if (member.real_jid <> '') then
        begin
            jid := TJabberID.Create(member.real_jid);
            if (jid <> nil) then
            begin
                member.blocked := MainSession.IsBlocked(jid);
            end;
            jid.Free();
        end;

        if (member.show = _(sBlocked)) then
           member.blocked := true
        else begin
            member.show := p.Show;
        end;
        if (tag.getAttribute('type') = 'unavailable') then
           member.show := 'offline';

        member.status := p.Status;
        p.Free();
    end;

    if (member.show = '') then
        member.show := 'Available';

    i := _roster.IndexOf(member.jid);
    if (i >= 0) then
        lstRoster.UpdateItems(i, i);

end;

{---------------------------------------}
procedure TfrmRoom.FormCreate(Sender: TObject);
var
    e: TExodusChat;
begin
    inherited;

    // Create
    _kick_iq := nil;
    _voice_iq := nil;
    _mcallback := -1;
    _ecallback := -1;
    _pcallback := -1;
    _scallback := -1;
    _dcallback := -1;
    _affilChangeCallback := -1;
    _roster := TWideStringList.Create;
    _roster.CaseSensitive := true;
    _isMUC := false;
    _nick_prefix := '';
    _nick_idx := 0;
    _nick_start := 0;
    _hint_text := '';
    _old_nick := '';
    _disconTime := 0;
    _keywords := nil;
    _send_unavailable := false;
    _custom_pres := false;
    _pending_start := false;
    _pending_destroy := false;
    _passwd_from_join_room := true;
    _insertTab := true;

    ImageIndex := RosterImages.RI_TEMP_CONFERENCE_INDEX;

    _notify[NOTIFY_ROOM_ACTIVITY] := MainSession.Prefs.getInt('notify_roomactivity');
    _notify[NOTIFY_KEYWORD] := MainSession.Prefs.getInt('notify_keyword');
    _notify[NOTIFY_PRIORITY_ROOM_ACTIVITY] := MainSession.Prefs.getInt('notify_priority_roomactivity');

    AssignUnicodeFont(lblSubject.Font, 8);
    lblSubject.Hint := _(sNoSubjectHint);
    lblSubject.Caption := _(sNoSubject);
    _subject := '';

    if (_notify[NOTIFY_KEYWORD] <> 0) then
        setupKeywords();

    MyNick := '';

    _wrap_input := MainSession.Prefs.getBool('wrap_input');
    MsgOut.WordWrap := _wrap_input;
    mnuWordwrap.Checked := _wrap_input;

    e := TExodusChat.Create();
    e.setRoom(Self);
    e.ObjAddRef();
    COMController := e;

    // Setup MsgList;
    MsgList.setContextMenu(popRoom);
    MsgList.setDragOver(OnDockedDragOver);
    MsgList.setDragDrop(OnDockedDragDrop);

    with MainSession.Prefs do begin
        if (getBool('brand_prevent_change_nick')) then
            popNick.Enabled := False;

        if (not getBool('brand_print')) then begin
            Print1.Visible := false;
        end
        else begin
            Print1.Visible := true;
        end;

        // Button Created here instead of in dfm because the inherited buttons mixed with
        // this button create ordering issues (this button wants to always be at the right
        // and we want it to the left).
        if (getBool('brand_history_search') and getBool('brand_log_groupchat_messages')) then begin
            btnViewHistory := TToolButton.Create(tbDockBar);
            btnViewHistory.ImageIndex := RosterImages.RosterTreeImages.Find(RI_VIEW_HISTORY_KEY);
            btnViewHistory.OnClick := btnViewHistoryClick;
            btnViewHistory.Parent := tbDockBar;
            btnViewHistory.ShowHint := true;
            btnViewHistory.Hint := _('View History');
        end;

        popRosterBrowse.Visible := getBool('brand_browser');
    end;




    _session_callback := MainSession.RegisterCallback(OnSessionCallback, '/session/prefs');
    _windowType := 'adhoc_room';

end;

{---------------------------------------}
procedure TfrmRoom.setupKeywords();
begin
    _keywords.Free;
    _keywords := Keywords.CreateKeywordsExpr();
end;

{---------------------------------------}
procedure TfrmRoom.SetJID(sjid: Widestring);
var
    j: TJabberID;
    Item: IExodusItem;
begin
    // setup our callbacks
    if (_mcallback = -1) then begin
        _mcallback := MainSession.RegisterCallback(MsgCallback, '/packet/message[@type="groupchat"][@from="' + sjid + '*"]');
        _ecallback := MainSession.RegisterCallback(MsgCallback, '/packet/message[@type="error"][@from="' + sjid + '"]');
        _pcallback := MainSession.RegisterCallback(PresCallback, '/packet/presence[@from="' + sjid + '*"]');
        _dcallback := MainSession.RegisterCallback(EntityCallback, '/session/entity/info');
        _affilChangeCallback := MainSession.RegisterCallback(AffilChangeCallback, '/packet/message[@from="' + sjid + '"]/x[@xmlns="' + XMLNS_MUCUSER + '"]/status[@code="101"]');
        if (_scallback = -1) then
            _scallback := MainSession.RegisterCallback(SessionCallback, '/session');
    end;
    Self.jid := sjid;

    j := TJabberID.Create(sjid);
    setUID(j.getDisplayFull());
    MsgList.setTitle(j.removeJEP106(j.user));
    Item := MainSession.ItemController.GetItem(jid);
    if (Item <> nil) then
    begin
        Item.Active := true;
        MainSession.FireEvent('/item/update', Item)
    end;
    j.Free();
end;

{---------------------------------------}
procedure TfrmRoom.SetPassword(pass: Widestring);
begin
    _passwd := pass;
end;

{---------------------------------------}
procedure TfrmRoom.MsgOutKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = 0) then exit;
    TExodusChat(ComController).fireMsgKeyUp(Key, Shift);
    inherited;
end;
{---------------------------------------}
procedure TfrmRoom.MsgOutKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    tmps: Widestring;
    prefix: Widestring;
    i: integer;
    found, exloop: boolean;
    nick: Widestring;
    curselstart: integer;
begin
    if (Key = 0) then exit;
    TExodusChat(ComController).fireMsgKeyDown(Key, Shift);

    // Send the msg if they hit return

    if (chr(Key) = #09) then begin
        // do tab completion
        curselstart := -1;
        tmps := MsgOut.Lines.Text;
        if _nick_prefix = '' then begin
            // grab the new prefix..
            prefix := '';
            for i := length(tmps) downto 1 do
                if tmps[i] = ' ' then begin
                    _nick_start := i;
                    MsgOut.SelStart := i;
                    prefix := Copy(tmps, i+1, length(tmps) - i);
                    MsgOut.SelLength := Length(prefix);
                    break;
                end;

            if prefix = '' then begin
                _nick_start := 0;
                prefix := tmps;
                curselstart := MsgOut.SelStart;
                MsgOut.SelStart := 0;
                MsgOut.SelLength := Length(prefix);
            end;

            prefix := Trim(WideLowerCase(prefix));
            _nick_prefix := prefix;
            _nick_idx := 0;
        end
        else begin
            with MsgOut do begin
                SelStart := _nick_start;
                SelLength := _nick_len;
                WideSelText := '';
            end;
        end;

        found := false;
        exloop := false;
        repeat
            // for i := _nick_idx to lstRoster.Items.Count - 1 do begin
            for i := _nick_idx to _roster.Count - 1 do begin
                nick := TRoomMember(_roster.Objects[i]).Nick;
                if nick[1] = '@' then nick := Copy(nick, 2, length(nick) - 1);
                if nick[1] = '+' then nick := Copy(nick, 2, length(nick) - 1);

                if WideTextPos(_nick_prefix, WideLowercase(nick)) = 1 then with MsgOut do begin
                    _nick_idx := i + 1;
                    if _nick_start <= 0 then
                        WideSelText := nick + ': '
                    else
                        WideSelText := nick + ' ';
                    SelStart := Length(Lines.text) + 1;
                    _nick_len := SelStart - _nick_start;
                    SelLength := 0;
                    exloop := true;
                    found := true;
                    _insertTab := false;
                    break;
                end;
            end;

            if (not found) and (_nick_idx = 0) then
                exloop := true
            else if (not found) then
                _nick_idx := 0;
        until (found) or (exloop);

        if not found then begin
            if (curselstart >= 0) then begin
                MsgOut.SelStart := curselstart;
                MsgOut.SelLength := 0;
            end
            else
                MsgOut.WideSelText := _nick_prefix;

            _nick_prefix := '';
            _nick_idx := 0;
        end
        else
            Key := 0;
    end
    else begin
        _nick_prefix := '';
        _nick_idx := 0;
    end;

    // Ctrl+I is a tab, but we don't want a tab.
    if ((Shift = [ssCtrl]) and
        (chr(Key) = 'I')) then begin
        _insertTab := false;
    end;

    inherited;
end;
{---------------------------------------}
procedure TfrmRoom.MsgOutKeyPress(Sender: TObject; var Key: Char);
var
   UpdateKey: WideString;
   Part: ChatParts;
begin
    if (TExodusChat(ComController) = nil) then exit;
    if (Sender = MsgOut) then
        Part := HWND_MsgInput
     else
        Part := HWND_MsgOutput;
    UpdateKey := WideChar(Key);
    TExodusChat(ComController).fireMsgKeyPress(UpdateKey, Part);
    Key := Chr(Ord(PWideChar(UpdateKey)^));
    if (Key = #0) then exit;
    inherited;
    if (Key = #0) then exit;

    if ((Key = #9) and
        (not _insertTab)) then begin
        Key := #0;
        _insertTab := true;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.btnCloseClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmRoom.btnViewHistoryClick(Sender: TObject);
begin
    inherited;

    StartShowHistoryWithJID(jid, true);
end;

{---------------------------------------}
procedure TfrmRoom.FormClose(Sender: TObject; var Action: TCloseAction);
var
    Item: IExodusItem;
begin
    inherited;
    Action := caFree;
    Item := MainSession.ItemController.GetItem(jid);
    if (Item <> nil) then
    begin
        Item.Active := false;
        MainSession.FireEvent('/item/update', Item)
    end;
end;

{---------------------------------------}
procedure TfrmRoom.changeSubject(subj: Widestring);
var
    msg: TJabberMessage;
begin
    // send the msg out
    msg := TJabberMessage.Create(jid, 'groupchat',
                                 _(sRoomSubjChange) + subj, subj);
    MainSession.SendTag(msg.GetTag);
    msg.Free;
end;

{---------------------------------------}
procedure TfrmRoom.lblSubjectURLClick(Sender: TObject);
var
    o, s: WideString;
begin
    // Change the subject
    s := _subject;
    o := s;
    if InputQueryW(_(sRoomSubjPrompt), _(sRoomNewSubj), s) then begin
        if (o <> s) then changeSubject(s);
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popClearClick(Sender: TObject);
begin
  inherited;
    MsgList.Clear();
end;

{---------------------------------------}
procedure TfrmRoom.changeNick(new_nick: WideString);
var
    p: TJabberPres;
    i: integer;
    rm: TRoomMember;
begin
    // check room roster for this nick already
    for i := 0 to _roster.Count - 1 do begin
        rm := TRoomMember(_roster.Objects[i]);
        if (WideLowerCase(rm.Nick) = WideLowerCase(new_nick)) then begin
            // they match
            MessageDlgW(_(sStatus_409), mtError, [mbOK], 0);
            exit;
        end;
    end;

    // go ahead and change it
    myNick := new_nick;
    p := TCapPresence.Create;
    p.toJID := TJabberID.Create(jid + '/' + myNick);
    MainSession.SendTag(p);
end;

{---------------------------------------}
procedure TfrmRoom.popNickClick(Sender: TObject);
var
    new_nick: WideString;
begin
  inherited;
    new_nick := myNick;
    if (InputQueryW(_(sRoomNewNick), _(sRoomNewNick), new_nick)) then begin
        if (new_nick = myNick) then exit;
        changeNick(new_nick);
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popCloseClick(Sender: TObject);
begin
  inherited;
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRoom.popBookmarkClick(Sender: TObject);
var
    bm_name: WideString;
    tmp_jid: TJabberID;
    groups: TWideStringList;
begin
  inherited;
    // bookmark this room..
    tmp_jid := TJabberID.Create(Self.jid);
    bm_name := tmp_jid.userDisplay;
    groups := TWideStringList.Create();
    if (ShowAddBookmark(bm_name, groups)) then
    begin
        MainSession.rooms.AddRoom(Self.jid, bm_name, myNick, false, false, groups);
        Self.Caption := bm_name;
        Self.updateDocked();
    end;
    groups.Free();
end;

{---------------------------------------}
procedure TfrmRoom.popInviteClick(Sender: TObject);
begin
  inherited;
    ShowInvite(Self.jid, TWideStringList(nil));
end;

{---------------------------------------}
function TfrmRoom.GetNick(rjid: Widestring): Widestring;
var
    i: integer;
begin
    // Get a nick based on the NickJID
    i := _roster.indexOf(rjid);
    if (i >= 0) then
        Result := TRoomMember(_roster.Objects[i]).Nick
    else
        Result := '';
end;

{---------------------------------------}
function IsRoom(rjid: Widestring): boolean;
begin
    result := (room_list.IndexOf(rjid) >= 0);
end;

{---------------------------------------}
procedure CloseAllRooms();
begin
    MainSession.FireEvent('/session/close-rooms', nil);
end;

{---------------------------------------}
function FindRoom(rjid: Widestring): TfrmRoom;
var
    idx: integer;
begin
    // finds a room form given a jid.
    idx := room_list.IndexOf(rjid);
    if (idx >= 0) then
        Result := TfrmRoom(room_list.Objects[idx])
    else
        Result := nil;
end;

{---------------------------------------}
function FindRoomNick(rjid: Widestring): Widestring;
var
    i: integer;
    room: TfrmRoom;
    tmp_jid: TJabberID;
begin
    // find the proper nick
    Result := '';

    tmp_jid := TJabberID.Create(rjid);
    i := room_list.IndexOf(tmp_jid.jid);
    tmp_jid.Free();
    if (i < 0) then exit;

    room := TfrmRoom(room_list.Objects[i]);
    Result := room.GetNick(rjid);
end;

{---------------------------------------}
procedure TfrmRoom.mnuOnTopClick(Sender: TObject);
begin
  inherited;
    mnuOnTop.Checked := not mnuOnTop.Checked;

    if (mnuOnTop.Checked) then
        Self.FormStyle := fsStayOnTop
    else
        Self.FormStyle := fsNormal;
end;

{---------------------------------------}
procedure TfrmRoom.popRoomPropertiesClick(Sender: TObject);
begin
    inherited;
    ShowRoomProperties(jid);
end;

procedure TfrmRoom.popRoomRosterPopup(Sender: TObject);
var
    e: boolean;
    rm: TRoomMember;
    JidsTag: TXMLTag;
begin
    e := (lstRoster.Selected <> nil);

    popRosterChat.Enabled := e;
    popRosterSendJID.Enabled := e;

    popRosterSubscribe.Enabled := false;
    popRosterVCard.Enabled := false;
    popRosterBrowse.Enabled := false;
    popKick.Enabled := false;
    popBan.Enabled := false;
    popVoice.Enabled := false;
    popModerator.Enabled := false;
    popAdministrator.Enabled := false;
    
    if (not e) then exit;

    rm := TRoomMember(lstRoster.Items[lstRoster.Selected.Index].Data);
    if (rm <> nil) then begin
        if (rm.real_jid <> '') then begin
            popRosterSubscribe.Enabled := true;
            popRosterVCard.Enabled := true;
            popRosterBrowse.Enabled := true;
        end;

        // If we have clicked on our own Nick, dis-allow various menu options.
        if (rm.Nick = myNick) then begin
            popRosterChat.Enabled := false;
            popRosterSendJID.Enabled := false;
            popRosterSubscribe.Enabled := false;
            popRosterVCard.Enabled := false;
            popRosterBrowse.Enabled := false;
            popKick.Enabled := false;
            popBan.Enabled := false;
            popVoice.Enabled := false;
            popModerator.Enabled := false;
            popAdministrator.Enabled := false;
        end
        else begin
            popAdministrator.Enabled := popConfigure.Enabled;
            popModerator.Enabled := (_my_membership_role = MUC_MOD) or popConfigure.Enabled;
            popKick.Enabled := popModerator.Enabled;
            popBan.Enabled := popModerator.Enabled;
            popVoice.Enabled := popModerator.Enabled;
        end;
    end;
    JidsTag := _getSelectedMembers();
    TExodusChat(COMController).fireMenuShow(JidsTag.xml);
    JidsTag.Free;
    inherited;
end;

{---------------------------------------}
procedure TfrmRoom.popShowHistoryClick(Sender: TObject);
begin
    inherited;
    ShowRoomLog(Self.jid);
end;

{---------------------------------------}
procedure TfrmRoom.popClearHistoryClick(Sender: TObject);
begin
    inherited;
    ClearRoomLog(Self.jid);
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterDblClick(Sender: TObject);
var
    rm: TRoomMember;
    tmp_jid: TJabberID;
begin
  inherited;
    // start chat w/ room participant
    // Chat w/ this person..
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(lstRoster.Items[lstRoster.Selected.Index].Data);
    if (rm = nil) or (WideLowerCase(rm.Nick) = WideLowerCase(mynick)) then exit;
    
    tmp_jid := TJabberID.Create(rm.jid);
    if (Length(rm._real_jid.jid()) = 0) then
        StartChat(tmp_jid.jid, tmp_jid.resource, true, rm.Nick)
    else
        StartChat(rm._real_jid.jid(), rm._real_jid.resource, true);
    tmp_jid.Free();
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
var
    tmps: Widestring;
    m: TRoomMember;
begin
  inherited;
    m := TRoomMember(Item.Data);
    if (m = nil) then
        InfoTip := ''
    else begin
        // pgm: Away (At lunch)
        tmps := m.Nick + ': ';
        tmps := tmps + m.show;
        if ((m.status <> '') and (m.status <> m.show)) then
            tmps := tmps + ' (' + m.status + ')';

        if (_isMUC) then begin
            if ((m.role <> '') or (m.affil <> '')) then begin
                tmps := tmps + ''#13#10 + _('Role: ');
                if (m.role = MUC_VISITOR) then
                    tmps := tmps + 'observer'
                else
                    tmps := tmps + m.role;
                tmps := tmps + ''#13#10 + _('Affiliation: ') + m.affil;
            end;
            if (m.real_jid <> '') then
                tmps := tmps + ''#13#10 + '<' + m.getRealDisplayJID() + '>';
        end;
        InfoTip := tmps;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popConfigureClick(Sender: TObject);
begin
  inherited;
    configRoom(false);
end;

{---------------------------------------}
procedure TfrmRoom.popKickClick(Sender: TObject);
var
    reason: WideString;
    q: TXMLTag;
begin
  inherited;
    // Kick the selected participant
    if (lstRoster.SelCount = 0) then exit;

    if (Sender = popKick) then begin
        reason := _(sKickDefault);
        if (not InputQueryW(_(sKickReason), _(sKickReason), reason)) then exit;
    end
    else if (Sender = popBan) then begin
        reason := _(sBanDefault);
        if (not InputQueryW(_(sBanReason), _(sBanReason), reason)) then exit;
    end;


    q := TXMLTag.Create('query');

    if (Sender = popKick) then
        AddMemberItems(q, reason, MUC_NONE)
    else if (Sender = popBan) then
        AddMemberItems(q, reason, '', MUC_OUTCAST)
    else if (Sender = popModerator) then
        AddMemberItems(q, '', MUC_MOD, '')
    else if (Sender = popAdministrator) then
        AddMemberItems(q, '', '', MUC_ADMIN);

    if (_kick_iq <> nil) then
        _kick_iq.Free;
    _kick_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), q, KickUserCB);
    _kick_iq.toJid := jid;
    _kick_iq.Namespace := XMLNS_MUCADMIN;
    _kick_iq.iqType := 'set';
    _kick_iq.Send();
    q.Free();
end;

{---------------------------------------}
procedure TfrmRoom.KickUserCB(event: string; tag: TXMLTag);
var
    tmp_tag: TXMLTag;
begin
    if ((tag <> nil) and
        (tag.GetAttribute('type') = 'error')) then begin
        tmp_tag := tag.GetFirstTag('error');
        if (tmp_tag <> nil) then begin
            if ((tmp_tag.GetAttribute('code') = '405') or (tmp_tag.GetAttribute('code') = '403')) then
                MessageDlgW(WideFormat(_(sOppErrorNoPrivileges), [tmp_tag.GetAttribute('code')]), mtError, [mbOK], 0)
            else
                MessageDlgW(WideFormat(_(sOppErrorGeneral), [tmp_tag.GetAttribute('code')]), mtError, [mbOK], 0);
        end;
    end;
    _kick_iq := nil;
end;

{---------------------------------------}
procedure TfrmRoom.AddMemberItems(tag: TXMLTag; reason: WideString = '';
    NewRole: WideString = ''; NewAffiliation: WideString = '');
var
    i: integer;
    rm: TRoomMember;
begin
    for i := 0 to lstRoster.Items.Count - 1 do begin
        if lstRoster.Items[i].Selected then begin
            with tag.AddTag('item') do begin
                rm := TRoomMember(lstRoster.Items[i].Data);
                setAttribute('nick', rm.Nick);
                if (NewRole <> '') then
                    setAttribute('role', NewRole);
                if (Reason <> '') then
                    AddBasicTag('reason', reason);
                if (NewAffiliation <> '') then
                    setAttribute('affiliation', NewAffiliation);
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popVoiceClick(Sender: TObject);
var
    q: TXMLTag;
    i: integer;
    cur_member: TRoomMember;
    new_role: WideString;
begin
  inherited;
    // Toggle Voice
    if (lstRoster.SelCount = 0) then exit;

    q := TXmlTag.Create('query');

    // Iterate over all selected items, and toggle
    // voice by changing roles
    for i := 0 to lstRoster.Items.Count - 1 do begin
        if (lstRoster.Items[i].Selected) then begin
            cur_member := TRoomMember(lstRoster.Items[i].Data);
            new_role := '';
            if (cur_member.role = MUC_PART) then
                new_role := MUC_VISITOR
            else if (cur_member.role = MUC_VISITOR) then
                new_role := MUC_PART;

            if (new_role <> '') then begin
                with q.AddTag('item') do begin
                    setAttribute('nick', cur_member.Nick);
                    setAttribute('role', new_role);
                end;
            end;
        end;
    end;

    if (_voice_iq <> nil) then
        _voice_iq.Free;
    _voice_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), q, ChangeVoiceCB);
    _voice_iq.toJid := jid;
    _voice_iq.Namespace := XMLNS_MUCADMIN;
    _voice_iq.iqType := 'set';
    _voice_iq.Send();
    q.Free();
end;

{---------------------------------------}
procedure TfrmRoom.ChangeVoiceCB(event: string; tag: TXMLTag);
var
    tmp_tag: TXMLTag;
begin
    if ((tag <> nil) and
        (tag.GetAttribute('type') = 'error')) then begin
        tmp_tag := tag.GetFirstTag('error');
        if (tmp_tag <> nil) then begin
            if ((tmp_tag.GetAttribute('code') = '405') or (tmp_tag.GetAttribute('code') = '403')) then
                MessageDlgW(WideFormat(_(sOppErrorNoPrivileges), [tmp_tag.GetAttribute('code')]), mtError, [mbOK], 0)
            else
                MessageDlgW(WideFormat(_(sOppErrorGeneral), [tmp_tag.GetAttribute('code')]), mtError, [mbOK], 0);
        end;
    end;
    _voice_iq := nil;
end;

{---------------------------------------}
procedure TfrmRoom.popVoiceListClick(Sender: TObject);
begin
  inherited;
    // edit a list
    if (Sender = popVoiceList) then
        ShowRoomAdminList(self, self.jid, MUC_PART, '', _(sEditVoice), _roster)
    else if (Sender = popBanList) then
        ShowRoomAdminList(self, self.jid, '', MUC_OUTCAST, _(sEditBan), _roster)
    else if (Sender = popMemberList) then
        ShowRoomAdminList(self, self.jid, '', MUC_MEMBER, _(sEditMember), _roster)
    else if (Sender = popModeratorList) then
        ShowRoomAdminList(self, self.jid, MUC_MOD, '', _(sEditModerator), _roster)
    else if (Sender = popAdminList) then
        ShowRoomAdminList(self, self.jid, '', MUC_ADMIN, _(sEditAdmin), _roster)
    else if (Sender = popOwnerList) then
        ShowRoomAdminList(self, self.jid, '', MUC_OWNER, _(sEditOwner), _roster);
end;

{---------------------------------------}
procedure TfrmRoom.popDestroyClick(Sender: TObject);
var
    reason: WideString;
    iq, q, d: TXMLTag;
begin
  inherited;
    // Destroy Room
    if (MessageDlgW(_(sDestroyRoomConfirm), mtConfirmation, [mbYes,mbNo], 0) = mrNo) then
        exit;
    reason := _(sDestroyDefault);
    if InputQueryW(_(sDestroyRoom), _(sDestroyReason), reason) = false then exit;

    iq := TXMLTag.Create('iq');
    iq.setAttribute('type', 'set');
    iq.setAttribute('id', MainSession.generateID());
    iq.setAttribute('to', jid);
    q := iq.AddTag('query');
    q.setAttribute('xmlns', XMLNS_MUCOWNER);
    d := q.AddTag('destroy');
    // TODO: alt-jid goes onto <destroy jid="newroom@server">
    d.AddBasicTag('reason', reason);
    _pending_destroy := true;
    MainSession.SendTag(iq);
end;

{---------------------------------------}
procedure TfrmRoom.selectNicks(wsl: TWideStringList);
var
    i, c: integer;
begin
    // Unselect every nick or random nicks can be caught in the results
    for i := 0 to lstRoster.Items.Count - 1 do
        lstRoster.Items[i].Selected := false;

    // Lookup the selected nicks and "select" them
    for i := 0 to wsl.Count - 1 do begin
        c := _roster.indexOf(Self.jid + '/' + wsl[i]);
        if (c >=0) then
            lstRoster.Items[c].Selected := true;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.FormDestroy(Sender: TObject);
var
    i: integer;
begin
    // Unregister callbacks and send unavail pres.
    if (MainSession <> nil) then begin
        MainSession.UnRegisterCallback(_mcallback);
        MainSession.UnRegisterCallback(_affilChangeCallback);
        MainSession.UnRegisterCallback(_ecallback);
        MainSession.UnRegisterCallback(_pcallback);
        MainSession.UnRegisterCallback(_scallback);
        MainSession.UnRegisterCallback(_dcallback);
        MainSession.UnRegisterCallback(_session_callback);

        if (MainSession.Invisible) then
            MainSession.removeAvailJid(jid);
    end;

    if ((MainSession <> nil) and (MainSession.Active) and (_send_unavailable)) then begin
        _sendPresence('unavailable', '', false);
    end;

    _keywords.Free;
    ClearStringListObjects(_roster);
    _roster.Free();

    i := room_list.IndexOf(jid);
    if (i >= 0) then
        room_list.Delete(i);


    _kick_iq.Free;
    _voice_iq.Free;
    
    inherited;
end;

procedure TfrmRoom.FormResize(Sender: TObject);
begin
  inherited;

end;

{---------------------------------------}
procedure TfrmRoom.mnuWordwrapClick(Sender: TObject);
begin
    inherited;
    mnuWordwrap.Checked := not mnuWordWrap.Checked;
    _wrap_input := mnuWordwrap.Checked;
    MsgOut.WordWrap := _wrap_input;
    MainSession.Prefs.setBool('wrap_input', _wrap_input);
end;

{---------------------------------------}
procedure TfrmRoom.S1Click(Sender: TObject);
var
    fn: widestring;
    filetype: integer;
begin
    dlgSave.FileName := MungeFileName(self.jid);

    case _msglist_type of
        RTF_MSGLIST  : dlgSave.Filter := 'RTF (*.rtf)|*.rtf|Text (*.txt)|*.txt'; // RTF
        HTML_MSGLIST : dlgSave.Filter := 'HTML (*.htm)|*.htm'; // HTML
    end;

    if (not dlgSave.Execute()) then exit;
    fn := dlgSave.FileName;
    filetype := dlgSave.FilterIndex;

    case _msglist_type of
        RTF_MSGLIST  :
            begin
                if (filetype = 1) then begin
                    // .rtf file
                    if (LowerCase(RightStr(fn, 3)) <> '.rtf') then
                        fn := fn + '.rtf';
                end
                else if (filetype = 2) then begin
                    // .txt file
                    if (LowerCase(RightStr(fn, 3)) <> '.txt') then
                        fn := fn + '.txt';
                end;
            end;
        HTML_MSGLIST :
            begin
                // .htm file
                if (LowerCase(RightStr(fn, 3)) <> '.htm') then
                    fn := fn + '.htm';
            end;
    end;
    MsgList.Save(fn);
end;

{---------------------------------------}
procedure TfrmRoom.pluginMenuClick(Sender: TObject);
begin
    TExodusChat(COMController).fireMenuClick(Sender, '');
end;

{---------------------------------------}
function TfrmRoom._getSelectedMembers() : TXMLTag;
var
    rm: TRoomMember;
    Item: TListItem;
begin
    Result := nil;
    if (lstRoster.SelCount < 1) then exit;
    Result := TXMLTag.Create('jids');

    Item := lstRoster.Selected;
    while (Item <> nil) do
    begin
        rm := TRoomMember(Item.Data);
        Result.AddBasicTag('jid', rm.real_jid);
        Item := lstRoster.GetNextItem(Item, sdAll, [isSelected]);
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popupMenuClick(Sender: TObject);
var
   JidsTag: TXMLTag;
begin
    JidsTag := _getSelectedMembers();
    TExodusChat(COMController).fireMenuClick(Sender, JidsTag.xml);
    JidsTag.Free();
end;
{---------------------------------------}
procedure TfrmRoom.popRosterSendJIDClick(Sender: TObject);
var
    rm: TRoomMember;
    b: WideString;
    msg, x, item: TXMLTag;
begin

  inherited;
    // Send my JID to this user
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(lstRoster.Items[lstRoster.Selected.Index].Data);
    if (rm <> nil) then begin
        msg := TXMLTag.Create('message');
        msg.setAttribute('id', MainSession.generateID());
        msg.setAttribute('to', rm.jid);
        b := WideFormat(_(sMsgRosterItems), [1]);
        b := b + Chr(13) + Chr(10) + MainSession.getDisplayUsername + ': ' + MainSession.BareJid;
        x := msg.AddTag('x');
        x.setAttribute('xmlns', XMLNS_XROSTER);
        item := x.AddTag('item');
        item.setAttribute('jid', MainSession.BareJid);
        item.setAttribute('name', MainSession.getDisplayUsername);
        jabberSendMsg(rm.jid, msg, x, b, '');
    end;
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterData(Sender: TObject; Item: TListItem);
var
    rm: TRoomMember;
    hiddenMembersCount, idx: Integer;
begin
  inherited;
    // get the data for this person..
    hiddenMembersCount := GetRoomRosterHiddenCount(Item.Index);
    idx := Item.Index + hiddenMembersCount;
    if ((idx < 0) or (idx > _roster.Count - 1)) then
        exit;
        
    rm := TRoomMember(_roster.Objects[idx]);

    TTntListItem(Item).Caption := rm.Nick;
    Item.Data := rm;

    if (rm.blocked) then item.ImageIndex := RosterTreeImages.Find('online_blocked')
    else if rm.show = 'away' then Item.ImageIndex := RosterTreeImages.Find('away')
    else if rm.show = 'xa' then Item.ImageIndex := RosterTreeImages.Find('xa')
    else if rm.show = 'dnd' then Item.ImageIndex := RosterTreeImages.Find('dnd')
    else if rm.show = 'chat' then Item.ImageIndex := RosterTreeImages.Find('chat')
    else if rm.show = 'offline' then Item.ImageIndex := RosterTreeImages.Find(RI_NOT_JOINED_KEY)
    else Item.ImageIndex := RosterTreeImages.Find('available');

end;

{---------------------------------------}
function ItemCompare(Item1, Item2: Pointer): integer;
var
    m1, m2: TRoomMember;
    s1, s2: Widestring;
begin
    // compare 2 items..
    m1 := TRoomMember(Item1);
    m2 := TRoomMember(Item2);

    s1 := m1.Nick;
    s2 := m2.Nick;

    Result := AnsiCompareText(s1,s2);
end;

{---------------------------------------}
procedure TfrmRoom.popRegisterClick(Sender: TObject);
begin
  inherited;
    StartServiceReg(jid);
end;

{---------------------------------------}
procedure TfrmRoom.EntityCallback(event: string; tag: TXMLTag);
begin
    _checkForAdhoc();

    if (_pending_start = false) then begin
        // Not starting so we don't want to send start presence.
        // We probably have new disco info (like change of room config).
        // Process that info

        // Who can change subject?
        _EnableSubjectButton();
        exit;
    end;
        
    if (tag = nil) then begin
        // just try anyways
        sendStartPresence();
        exit;
    end;

    if (tag.getAttribute('from') = Self.jid) then begin
        // we got info from our room...
        sendStartPresence();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.sendStartPresence();
var
    e: TJabberEntity;
    p : TJabberPres;
    iq: TJabberIQ;
    cb: TPacketEvent;
begin
    e := jEntityCache.getByJid(Self.jid, '');
    if ((e = nil) or (not e.hasInfo)) then begin
        // try to disco#info this room
        _pending_start := true;
        jEntityCache.discoInfo(self.jid, MainSession, '', ROOM_TIMEOUT);
        exit;
    end
    else if ((useRegisteredNick) and
             (e.hasFeature('muc_membersonly') or
             e.hasFeature('muc-members-only'))) then begin
        cb := Self.roomuserCallback;
        iq := TJabberIQ.Create(MainSession, MainSession.generateID(), cb, 10);
        with iq do begin
            toJid := jid;
            iqType := 'get';
            Namespace := XMLNS_DISCOINFO;
            qTag.setAttribute('node', 'x-roomuser-item');
        end;
        iq.Send();
        exit;
    end;

    _pending_start := false;
    p := TCapPresence.Create;
    p.toJID := TJabberID.Create(self.jid + '/' + self.mynick);
    with p.AddTag('x') do begin
        setAttribute('xmlns', XMLNS_MUC);
        if (self._passwd <> '') then
            AddBasicTag('password', _passwd);
    end;

    if (MainSession.Invisible) then
        MainSession.addAvailJid(self.jid);

    p.Show := MainSession.Show;
    p.Status := MainSession.Status;

    MainSession.SendTag(p);
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
    // If typing starts on the MsgList, then bump it to the outgoing
    // text box.
    if (not Self.Visible) then exit;
    if (Ord(key) < 32) then exit;

    if (MsgOut.Visible) and (MsgOut.Enabled) and (not MsgOut.ReadOnly) then begin
        try
            MsgOut.SetFocus();
            MsgOut.WideSelText := Key;
        except
            // To handle Cannot focus exception
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.lstRosterCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
    rm: TRoomMember;
    xRect: TRect;
    nRect: TRect;
    main_color: TColor;
    moderator, visitor: boolean;
    c1: Widestring;
begin
  inherited;
    // Bold if they are a moderator.. gray if no voice
    DefaultDraw := true;
    if (not _isMUC) then exit;

    rm := TRoomMember(Item.Data);
    moderator := (rm.role = 'moderator');
    visitor := (rm.role = 'visitor');

    with lstRoster.Canvas do begin
        TextFlags := ETO_OPAQUE;
        xRect := Item.DisplayRect(drLabel);
        nRect := Item.DisplayRect(drBounds);

        // draw the selection box, or just the bg color
        if (cdsSelected in State) then begin
            Font.Color := clHighlightText;
            Brush.Color := clHighlight;
            FillRect(xRect);
        end
        else begin
            if (visitor) then
                Font.Color := clGrayText
            else
                Font.Color := lstRoster.Font.Color;
            Brush.Color := lstRoster.Color;
            Brush.Style := bsSolid;
            FillRect(xRect);
        end;

        // Bold moderators
        if (moderator) then
            Font.Style := [fsBold]
        else
            Font.Style := [];

        // draw the image
        frmExodus.ImageList1.Draw(lstRoster.Canvas,
            nRect.Left, nRect.Top, Item.ImageIndex);

        // draw the text
        if (cdsSelected in State) then begin
            main_color := clHighlightText;
            //stat_color := main_color;
        end
        else begin
            main_color := lstRoster.Canvas.Font.Color;
            //stat_color := clGrayText;
        end;

        c1 := rm.Nick;
        if (CanvasTextWidthW(lstRoster.Canvas, c1) > (xRect.Right - xRect.Left)) then begin
            // XXX: somehow truncate the nick
        end;

        SetTextColor(lstRoster.Canvas.Handle, ColorToRGB(main_color));
        CanvasTextOutW(lstRoster.Canvas, xRect.Left + 1,
            xRect.Top + 1, c1);

        if (cdsSelected in State) then
            // Draw the focus box.
            lstRoster.Canvas.DrawFocusRect(xRect);

        // make sure the control doesn't redraw this.
        DefaultDraw := false;
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popRosterSubscribeClick(Sender: TObject);
var
    j: TJabberID;
    rm: TRoomMember;
    dgrp: Widestring;
begin
    inherited;

    // subscribe to this person
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(lstRoster.Items[lstRoster.Selected.Index].Data);
    if ((rm <> nil) and (rm.real_jid <> '')) then begin
        j := TJabberID.Create(rm.real_jid);
        dgrp := MainSession.Prefs.getString('roster_default');
        MainSession.roster.AddItem(j.jid, rm.nick, dgrp, true);
        j.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popRosterVCardClick(Sender: TObject);
var
    j: TJabberID;
    rm: TRoomMember;
begin
  inherited;
    // lookup the vcard.
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(lstRoster.Items[lstRoster.Selected.Index].Data);
    if ((rm <> nil) and (rm.real_jid <> '')) then begin
        j := TJabberID.Create(rm.real_jid);
        ShowProfile(j.jid);
        j.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popRosterBrowseClick(Sender: TObject);
var
    j: TJabberID;
    rm: TRoomMember;
begin
  inherited;
    if (lstRoster.Selected = nil) then exit;

    rm := TRoomMember(lstRoster.Items[lstRoster.Selected.Index].Data);
    if ((rm <> nil) and (rm.real_jid <> '')) then begin
        j := TJabberID.Create(rm.real_jid);
        ShowBrowser(j.jid);
        j.Free();
    end;
end;

{---------------------------------------}
procedure TfrmRoom.popCopyClick(Sender: TObject);
begin
  inherited;
    MsgList.Copy();
end;

{---------------------------------------}
procedure TfrmRoom.popCopyAllClick(Sender: TObject);
begin
  inherited;
    MsgList.CopyAll();
end;

{---------------------------------------}
procedure TfrmRoom.Print1Click(Sender: TObject);
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

procedure TfrmRoom._DragUpdate(Source: TExDropTarget; X: Integer; Y: Integer; var Action: TExDropActionType);
var
    itemCtrl: IExodusItemController;
    jids: TWidestringList;

    procedure BuildInviteList(items: IExodusItemList);
    var
        item: IExodusItem;
        idx: Integer;
    begin
        if (items = nil) or (items.Count = 0) then exit;

        for idx := 0 to items.Count - 1 do begin
            item := items.Item[idx];
            if (item.Type_ = 'group') then
                BuildInviteList(itemCtrl.GetGroupItems(item.UID))
            else if (item.Type_ = 'contact') then
                 jids.Add(item.UID);
        end;
    end;
begin
    itemCtrl := MainSession.ItemController;
    jids := TWidestringList(Source.Data);
    if (jids = nil) then begin
        jids := TWidestringList.Create();
        BuildInviteList(Source.DragItems);
        Source.Data := jids;
    end;

    if (jids.Count <> 0) then
        Action := datMove
    else
        Action := datNone;
end;
procedure TfrmRoom._DragEnd(Source: TExDropTarget);
var
    jids: TWidestringList;
begin
    jids := TWidestringList(Source.Data);
    jids.Free();
end;
procedure TfrmRoom._DragExecute(Source: TExDropTarget; X: Integer; Y: Integer);
var
    jids: TWidestringList;
begin
    jids := TWidestringList(Source.Data);
    if (jids <> nil) and (jids.Count <> 0) then
        ShowInvite(Self.jid, jids);
end;

procedure TfrmRoom.OnDockedDragOver(Sender, Source: TObject; X, Y: Integer;
                               State: TDragState; var Accept: Boolean);
begin
    case State of
        dsDragLeave: begin
            Self.DragCursor := crDrag;
            exit;
        end;
        dsDragEnter: begin
            _dropSupport.Free();
            _dropSupport := OpenDropTarget(Source, _DragUpdate, _DragExecute, _DragEnd);
        end;
    end;

    Accept := (_dropSupport <> nil) and _dropSupport.Update(X, Y);
end;

procedure TfrmRoom.OnDockedDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
    inherited;

    // drag drop
    if (_dropSupport <> nil) then _dropSupport.Execute(X, Y);
end;

{
    Event fired when docking is complete.

    Docked property will be true, tabsheet will be assigned. This event
    is fired after all other docking events are complete.
}
procedure TfrmRoom.OnDocked();
begin
    inherited;
    mnuOnTop.Enabled := false;
    _scrollBottom();
    Self.Refresh();
    TExodusChat(ComController).fireNewWindow(Self.Handle);
end;

{
    Event fired when a float (undock) is complete.

    Docked property will be false, tabsheet will be nil. This event
    is fired after all other floating events are complete.
}
procedure TfrmRoom.OnFloat();
begin
    inherited;
    mnuOnTop.Enabled := true;
    _scrollBottom();
    Self.Refresh();
    TExodusChat(ComController).fireNewWindow(Self.Handle);
end;

function TRoomMember.getRealJID(): WideString;
begin
    Result := '';
    if (_real_jid <> nil) then
    begin
        Result := _real_jid.full();
    end;
end;

function TRoomMember.getRealDisplayJID(): WideString;
begin
    Result := '';
    if (_real_jid <> nil) then
    begin
        Result := _real_jid.getDisplayFull();
    end;
end;

procedure TRoomMember.setRealJID(jid: WideString);
begin
    if (_real_jid <> nil) then
      _real_jid.Free();

    _real_jid := TJabberID.Create(jid);
end;

{---------------------------------------}
procedure TfrmRoom._EnableSubjectButton();
var
    e: TJabberEntity;
    enable: boolean;
begin
    // This code enables or disables the change subject button
    // based on what the disco info tells us about premissions
    // to change subject.
    // If no disco info is available, enable and let
    // error codes take care of preventing changing of subject.
    enable := true;
    e := jEntityCache.getByJid(Self.jid, '');
    if (e = nil) then exit;

    if (_my_membership_role = MUC_OWNER) or
       (_my_membership_role = MUC_ADMIN) then
            enable := true //always
    else if (e.hasFeature('muc-subj-moderator')) or
            (e.hasFeature('muc-subj-participant')) then
        begin
            // we have a specification as to who can change
            if (e.hasFeature('muc-subj-moderator')) and
               (_my_membership_role = MUC_MOD) then
                enable := true
            else if (e.hasFeature('muc-subj-participant')) and
                    ( (_my_membership_role = MUC_MOD) or
                      (_my_membership_role = MUC_MEMBER) or
                      (_my_membership_role = MUC_PART) ) then
                enable := true
            else
                enable := false;
        end;

    SpeedButton1.Enabled := enable;
    if (enable) then
        SpeedButton1.Hint := _('Edit Subject')
    else begin
        SpeedButton1.Hint := '';
        lblSubject.Hint := '';
    end;
end;


destructor TRoomMember.Destroy();
begin
    inherited Destroy();
    if (_real_jid <> nil) then
      _real_jid.Free();
end;

{---------------------------------------}
//This function matches room member by real jid (different nicks) and returns
//positive index if it fins one.
function TfrmRoom.FindDuplicateRealJid(nick: Widestring; jid: Widestring): Integer;
var
    i: integer;
    tmp1, tmp2: TJabberID;
    realjid, tmpjid: WideString;
begin
     Result := -1;
     if (jid = '') then exit;
     tmp1 := TJabberID.Create(jid);
     tmpjid := tmp1.jid;
     for i := 0 to _roster.Count - 1 do begin
          tmp2 := TJabberID.Create(TRoomMember(_roster.Objects[i]).real_jid);
          realjid := tmp2.jid;
          if (realjid = tmpjid) then begin
              if (TRoomMember(_roster.Objects[i]).Nick = nick) then
                 continue
              else begin
                 Result := i;
                 break;
              end;
          end;
     end;
     tmp1.Free();
end;
{---------------------------------------}
//This function returns hidden member count
//found before given index.
function TfrmRoom.GetRoomRosterHiddenCount(index: Integer): Integer;
var
   i, max: integer;
begin
    Result := 0;
    max := index;
    if (index > _roster.Count - 1) then
        max := _roster.Count - 1;
    
    for i := 0 to max do begin
        if (TRoomMember(_roster.Objects[i]).hideUnavailable) then
            Inc(Result);
    end;
end;
{---------------------------------------}
//This function returns total number of visible members.
function TfrmRoom.GetRoomRosterVisibleCount(): Integer;
var
   i: integer;
begin
    Result := 0;
    for i := 0 to _roster.Count - 1 do begin
        if (not TRoomMember(_roster.Objects[i]).hideUnavailable) then
            Inc(Result);
    end;
end;

{---------------------------------------}
//This function returns total number of visible members.
function TfrmRoom.GetRoomRosterOnlineCount(): Integer;
var
   i: integer;
begin
    Result := 0;
    for i := 0 to _roster.Count - 1 do begin
        if (TRoomMember(_roster.Objects[i]).show <> 'offline') then
            Inc(Result);
    end;
end;

{---------------------------------------}
//This function toggles visibility of the duplicate member entry (by real jid).
//Duplicate occurance happen when registred members use non-registred nicks
//to enter the room.
//When temp nick enters, registred nick needs to be hidden.
//When temp nick leaves, registred nick needs to be shown.
//When registred nick enteres after temp nick, we need to check for the
//presence of temp nick for the given real jid.
procedure TfrmRoom.ToggleDuplicateMember(rm: TRoomMember; tag: TXMLTag);
var
  i: Integer;
begin
   //First check if there is another nick for real jid
   i := FindDuplicateRealJid(rm.nick, rm.real_jid);
   if (i < 0) then
       exit;

   //Temp nick for the member or higher went offline,
   //we need to make registered nick visible
   if (rm.role = 'none') then begin
       TRoomMember(_roster.Objects[i]).hideUnavailable := false;
       rm.hideUnavailable := true;
   end
   else begin
       TRoomMember(_roster.Objects[i]).hideUnavailable := true;
       rm.hideUnavailable := false;
   end;

end;

procedure TfrmRoom.OnSessionCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/prefs') then begin
        lstRoster.Color := TColor(MainSession.Prefs.getInt('color_bg'));
    end;
end;

procedure TfrmRoom._checkForAdhoc();
var
    e: TJabberEntity;
begin
    e := jEntityCache.getByJid(self.jid);
    if (e <> nil) then begin
        if ((e.hasFeature('muc_persistent')) or
            (e.hasFeature('persistent'))) then begin
            // This is a Persistent room
            Self.ImageIndex := RosterImages.RI_CONFERENCE_INDEX;
            _windowType := 'perm_room';
        end
        else begin
            // This is a temp room
            Self.ImageIndex := RosterImages.RI_TEMP_CONFERENCE_INDEX;
            _windowType := 'adhoc_room';
        end;
    end;
end;


constructor TJoinRoomAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-000-join-room');

    Set_Caption(_('Join'));
    Set_Enabled(true);
end;

procedure TJoinRoomAction.execute(const items: IExodusItemList);
var
    idx: Integer;
    item: IExodusItem;
    nick, pass: Widestring;
    useReg: Boolean;
begin
    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];

        nick := item.value['nick'];
        pass := item.value['password'];

        if (item.value['reg_nick'] = 'true') then
            useReg := true
        else
            useReg := false;

        StartRoom(item.UID, nick, pass, true, false, useReg);
    end;
end;

constructor TAutojoinAction.Create(flag: Boolean);
var
    rname: Widestring;
    cap: Widestring;
begin
    if flag then begin
        _value := 'true';
        rname := 'join-on-startup';
        cap := _('Join on Startup');
    end else begin
        _value := 'false';
        rname := 'unjoin-on-startup';
        cap := _('Don''t join on startup');
    end;

    inherited Create('{000-exodus.googlecode.com}-010-' + rname);

    Set_Caption(cap);
    Set_Enabled(true);
end;

procedure TAutojoinAction.execute(const items: IExodusItemList);
var
    idx: Integer;
    item: IExodusItem;
begin
    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];

        item.value['autojoin'] := _value;
    end;

    MainSession.rooms.SaveRooms();
end;

constructor TRoomPropertiesAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-100-properties');

    Set_Caption(_('Properties...'));
    Set_Enabled(true);
end;

procedure TRoomPropertiesAction.execute(const items: IExodusItemList);
var
    i: integer;
begin
    // 'selection=single' property should limit this to 1 contact in the list
    for i := 0 to items.Count - 1 do
    begin
        ShowRoomProperties(items.Item[i].UID);
    end;
end;


procedure RegisterActions();
var
    actCtrl: IExodusActionController;
    act: IExodusAction;
begin
    actCtrl := GetActionController();

    //setup join action
    act := TJoinRoomAction.Create() as IExodusAction;
    actCtrl.registerAction('room', act);

    //setup autojoin action
    act := TAutojoinAction.Create(true) as IExodusAction;
    actCtrl.registerAction('room', act);
    actCtrl.addDisableFilter('room', act.Name, 'autojoin=true');

    act := TAutojoinAction.Create(false) as IExodusAction;
    actCtrl.registerAction('room', act);
    actCtrl.addEnableFilter('room', act.Name, 'autojoin=true');

    //setup room properties action
    act := TRoomPropertiesAction.Create() as IExodusAction;
    actCtrl.registerAction('room', act);
    actCtrl.addEnableFilter('room', act.Name, 'selection=single');
end;

initialization
    // list for all of the current rooms
    room_list := TWideStringlist.Create();

    // pre-compile some xpath's
    xp_muc_presence := TXPLite.Create('/presence/x[@xmlns="' + XMLNS_MUCUSER + '"]');
    xp_muc_status := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/status');
    xp_muc_item := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/item');
    xp_muc_reason := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/item/reason');
    xp_muc_destroy_reason := TXPLite.Create('//x[@xmlns="' + XMLNS_MUCUSER + '"]/destroy/reason');

    Classes.RegisterClass(TfrmRoom); //auto-open RTII

    RegisterActions();

finalization
    xp_muc_reason.Free();
    xp_muc_item.Free();
    xp_muc_status.Free();
    xp_muc_presence.Free();
    xp_muc_destroy_reason.Free();
    
    room_list.Free();

end.
