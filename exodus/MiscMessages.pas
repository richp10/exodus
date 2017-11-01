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
unit MiscMessages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntExtCtrls, ComCtrls, ToolWin, ExtCtrls, Menus, TntMenus,
  Dockable,
  XMLTag,
  Session,
  Contnrs,
  JabberMsg,
  JabberID,
  DisplayName,
  BaseMsgList;

type


  TfrmSimpleDisplay = class(TfrmDockable)
    pnlMsgDisplay: TTntPanel;
    mnuSimplePopup: TTntPopupMenu;
    mnuCopy: TTntMenuItem;
    mnuCopyAll: TTntMenuItem;
    mnuClear: TTntMenuItem;
    procedure mnuClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    _MsgList: TfBaseMsgList;
    _SessionListener : TSessionListener;

    _CloseOnDisconnect: boolean;
    _dnListener: TDisplayNameEventListener;
    _jid: TJabberID;
    _initialMsgQueue: TObjectList; //queue messages until ondock or onfloat called

    procedure RefreshMsgList();
  protected
    //override window state to persist/load messages
    procedure OnPersistedMessage(msg: TXMLTag);override;
    function GetWindowStateKey() : WideString;override;

    procedure OnAuthenticated();
    procedure OnDisconnected(ForcedDisconnect: boolean; Reason: WideString);

    function GetMsgList(): TfBaseMsgList;
  public
    Constructor Create(AOwner: TComponent);override;

    procedure InitializeJID(ijid: TJabberID = nil);virtual;
    procedure DisplayMessage(MsgTag: TXMLTag); virtual;
    procedure OnDisplayNameChange(bareJID: Widestring; displayName: WideString);virtual;

    procedure Update; override;

    procedure OnDocked(); override;
    procedure OnFloat(); override;

    function GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;override;

    property MsgList: TfBaseMsgList read GetMsgList;
    property JID: TJabberID read _jid;
    property DNListener: TDisplayNameEventListener read _dnListener;
    property CloseOnDisconnect: boolean read _CloseOnDIsconnect write _CloseOnDisconnect;
  end;

procedure SetSession(Session: TJabberSession);

implementation

{$R *.dfm}

uses
    debug,
    IDGlobal,
    Notify,
    XMLUtils,
    JabberConst,
    IEMsgList,
    RTFMsgList,
    ExUtils,
    RosterImages,
    Jabber1,
    TnTStdCtrls,
    FloatingImage,
    Room,
    Avatar,
    AvatarCache,
    ChatWin,
    SndBroadcastDlg,
    GnuGetText,
    Exodus_TLB;

const
    XMLNS_MULTICAST = 'http://jabber.org/protocol/address';

    COMMON_HEADLINE_UID: widestring = 'headline';
    COMMON_DECLINED_UID: widestring = 'invite-declined';
    COMMON_ERROR_UID: widestring = 'message-error';

    sDECLINE_DESC1 = 'Your invitation to ';
    sDECLINE_DESC2 = ' to join the room ';
    sDECLINE_DESC3 = ' was declined.';
    sNO_REASON = 'No reason given.';
    sREASON = 'Reason for declining: ';

{
  Decline packet via XEP-45
    <message
        from='darkcave@macbeth.shakespeare.lit'
        to='crone1@shakespeare.lit/desktop'>
        <x xmlns='http://jabber.org/protocol/muc#user'>
            <decline from='hecate@shakespeare.lit'>
                <reason>
                    Sorry, I'm too busy right now.
                </reason>
            </decline>
        </x>
    </message>
}

procedure Log(msg: widestring);
begin
//    Debug.DebugMessage(msg);
end;

type
    TSimpleDisplayMeta = class of TfrmSimpleDisplay;
    
    TSListItem = class
        _UID: Widestring;
        _Window: TfrmSimpleDisplay;
        _Object: TObject;

        Constructor Create(UID: widestring; window: TfrmSimpleDisplay; ObjRef: TObject);
        Destructor Destroy();override;
    end;

    TSimpleMessageHandler = class
    protected
        _callback: integer;
    public
        Constructor Create(); overload;virtual;
        Constructor Create(cbXPath: widestring); overload;virtual; 
        Destructor Destroy(); override;

        procedure MessageCallback(event: string; tag: TXMLTag);virtual;
    end;

    THeadlineHandler = class(TSimpleMessageHandler)
    public
        Constructor Create();override;
        procedure MessageCallback(event: string; tag: TXMLTag);override;
    end;

    TBroadcastHandler = class(TSimpleMessageHandler)
    private
        _NormalCB: integer;
        _EmptyCB: integer;
    public
        Constructor Create();override;
        Destructor Destroy(); override;

        procedure MessageCallback(event: string; tag: TXMLTag);override;
    end;

    TInviteDeclinedHandler = class(TSimpleMessageHandler)
    public
        Constructor Create();override;
        procedure MessageCallback(event: string; tag: TXMLTag);override;
    end;

    TErrorHandler = class(TSimpleMessageHandler)
    public
        Constructor Create();override;
        procedure MessageCallback(event: string; tag: TXMLTag);override;
    end;

var
    _Session: TJabberSession;

    _SimpleMessageWindows: TObjectList;
    _handlers: TObjectList;

procedure SetSession(Session: TJabberSession);
begin
    if (_Session <> nil) then
        _handlers.Clear();

    _Session := Session;

    if (_Session <> nil) then
    begin
        _handlers.Add(THeadlineHandler.create());
        _handlers.Add(TInviteDeclinedHandler.create());
        _handlers.Add(TBroadcastHandler.create());
        _handlers.Add(TErrorHandler.create());
    end;
end;

function CreateMessage(tag: TXMLTag): TJabberMessage;
var
    jid: TJabberID;
begin
    result := TJabberMessage.Create(tag);
    result.isMe := (tag.GetAttribute('from') = MainSession.JID);

    if (result.isMe) then
        jid := TJabberID.Create(MainSession.JID)
    else
        jid := TJabberID.Create(Result.FromJID);
    result.Nick := DisplayName.getDisplayNameCache().getDisplayName(jid.jid);
    jid.free();
end;

{*******************************************************************************
*********************** simple display list management *************************
*******************************************************************************}
function IndexOf(UID: Widestring): Integer;
begin
    for Result := 0 to _SimpleMessageWindows.count - 1 do
    begin
        if (TSListItem(_SimpleMessageWindows[Result])._UID = UID) then exit;
    end;
    Result := -1;
end;

function FindWindow(UID: Widestring): TfrmSimpleDisplay;
var
    i: integer;
begin
    i := IndexOf(UID);
    Result := nil;
    if (i <> -1) then
        Result := TfrmSimpleDisplay(TSListItem(_SimpleMessageWindows[i])._Window);
end;

function FindObject(UID: Widestring): TObject;
var
    i: integer;
begin
    i := IndexOf(UID);
    Result := nil;
    if (i <> -1) then
        Result := TSListItem(_SimpleMessageWindows[i])._Object;
end;

procedure AddWindow(UID: Widestring; SWindow: TfrmSimpleDisplay; ObjRef: TObject = nil);
begin
    if (IndexOf(UID) = -1) then
    begin
        _SimpleMessageWindows.Add(TSListItem.create(UID, SWindow, objRef));
    end
    else
    begin
        //UID collision. assert no collision?
    end;
end;

procedure RemoveWindow(UID: widestring);
var
    i: integer;
begin
    i := IndexOf(UID);
    if (i <> -1) then
        _SimpleMessageWindows.Delete(i);
end;

function OpenFactory(windowClass: TComponentClass; wtype: Widestring; jid: TJabberID = nil): TfrmSimpleDisplay;overload;
var
    tuid: widestring;
begin
    tuid := wtype;
    if (jid <> nil) then
        tuid := tuid + ':' + jid.jid;

    Result := FindWindow(tuid);

    if (Result = nil) then
    begin
        try
            Result := TfrmSimpleDisplay(windowClass.NewInstance);
            Result.create(nil);
        except
            Result := nil;
            exit;
        end;
        Result.UID := tuid;
        AddWindow(tuid, Result);
        if (jid <> nil) then
            Result.InitializeJID(jid);
            
        Result.ShowDefault(false);
    end;
end;

function OpenFactory(windowClass: TComponentClass; wtype: Widestring; jid: widestring): TfrmSimpleDisplay;overload;
var
    tjid: TJabberID;
begin
    if (jid = '') then
        Result := OpenFactory(windowClass, wtype, TJabberID(nil))
    else begin
        tjid := TJabberID.create(jid);
        Result := OpenFactory(windowClass, wtype, tjid);
        tjid.free();
    end;
end;

{*******************************************************************************
******************************** TSListItem ************************************
*******************************************************************************}
Constructor TSListItem.Create(UID: widestring; window: TfrmSimpleDisplay; ObjRef: TObject);
begin
    _UID := UID;
    _Window := window;
    _Object := objRef;
end;

Destructor TSListItem.Destroy();
begin
    if (Assigned(_Object)) then
        _Object.Free();
end;

{*******************************************************************************
************************* TSimpleMessageHandler ********************************
*******************************************************************************}
Constructor TSimpleMessageHandler.Create();
begin
    Create('');
end;

Constructor TSimpleMessageHandler.Create(cbXPath: widestring);
begin
    inherited Create();
    _callback := -1;
    if (cbXPath <> '') then
        _callback := _Session.RegisterCallback(MessageCallback, cbXPath)
end;

Destructor TSimpleMessageHandler.Destroy();
begin
    if (_callback <> -1) then    
        _Session.UnRegisterCallback(_callback);
    inherited;
end;

procedure TSimpleMessageHandler.MessageCallback(event: string; tag: TXMLTag);
begin
  //nop
end;

type
{*******************************************************************************
**************************** THeadlineDisplay **********************************
*******************************************************************************}
    THeadlineDisplay = class(TfrmSimpleDisplay)
    public
        class procedure AutoOpenFactory(autoOpenInfo: TXMLTag); override;
        procedure OnDisplayNameChange(bareJID: Widestring; displayName: WideString);override;
    end;
    
class procedure THeadlineDisplay.AutoOpenFactory(autoOpenInfo: TXMLTag);
begin
    OpenFactory(THeadlineDisplay, 'headline', autoOpenInfo.getAttribute('jid'));
end;

procedure THeadlineDisplay.OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
begin
    Caption := _('Headlines from ') + displayName;
    Hint := _('Headline Messages from ') + JID.getDisplayFull();
    inherited;
end;

{*******************************************************************************
**************************** THeadlineHandler **********************************
*******************************************************************************}
Constructor THeadlineHandler.Create();
begin
    //Create('/packet/message[@type="headline"]');
    Create('/post/message[@type="headline"]');
end;

procedure THeadlineHandler.MessageCallback(event: string; tag: TXMLTag);
begin
    OpenFactory(THeadlineDisplay, 'headline', tag.getAttribute('from')).DisplayMessage(tag);
end;


{*******************************************************************************
*************************** TBroadcastHandler **********************************
*******************************************************************************}

type
{************************* TExJIDHyperlinkLabel ********************************
**
**  Little component to wrap the avatar/disp name hyperlink originally in chat
**
*******************************************************************************}
    TExJIDHyperlinkLabel = class(TTnTPanel)
    private
        _lblJID: TTntLabel;
        _imgAvatar: TImage;

        _ShowFullResourceHint: boolean;
        _ShowDisplayName: boolean;

        _jid: TJabberID;
        _dnListener: TDisplayNameEventListener;
        _displayFormat: widestring;
        
        _avatar: TAvatar;
        _UnknownAvatar: TBitmap;

        _ControlsInitialized: boolean;
    protected
        //creates top panel and caption label
        procedure CreateWindowHandle(const Params: TCreateParams); override;
    public
        Constructor Create(AOwner: TComponent);override;
        Destructor Destroy; Override;

        procedure SetJID(jid: TJabberID; DisplayFormat: Widestring = '');
        procedure OnDisplayNameChange(bareJID: Widestring; displayName: WideString);

        procedure imgAvatarPaint(Sender: TObject);
        procedure imgAvatarClick(Sender: TObject);

        procedure lblJIDCLick(Sender: TObject);
        property ShowFullResourceHint: boolean read _ShowFullResourceHint write _ShowFullResourceHint;
        property ShowDisplayName: boolean read _ShowDisplayName write _ShowDisplayName;
    end;

Constructor TExJIDHyperlinkLabel.Create(AOwner: TComponent);
begin
    _ControlsInitialized := true; //prevent control initialization during inherited
    inherited;

    _jid := nil;
    _ShowFullResourceHint := true;
    _ShowDisplayName := true;

    _dnListener := TDisplayNameEventListener.Create();
    _dnListener.OnDisplayNameChange := Self.OnDisplayNameChange;

    _imgAvatar := TImage.Create(Self);
    _imgAvatar.Parent := Self;
    _imgAvatar.Name := 'imgAvatar';
    _imgAvatar.OnClick := Self.imgAvatarClick;

    _lblJID := TTntLabel.Create(Self);
    _lblJID.Parent := Self;
    _lblJID.Name := 'lblJID';
    _lblJID.OnClick := Self.lblJIDCLick;

    Self.AlignWithMargins := True;
    Self.Margins.Left := 3;
    Self.Margins.Top := 0;
    Self.Margins.bottom := 0;
    Self.Margins.right := 0;

    _Avatar := nil;
    _UnknownAvatar := TBitmap.Create();

    Jabber1.frmExodus.bigImages.GetBitmap(0, _UnknownAvatar);
    _ControlsInitialized := false;
end;

Destructor TExJIDHyperlinkLabel.Destroy;
begin
    _UnknownAvatar.Free();
    _dnListener.Free();
    _jid.free();
    inherited;
end;

procedure TExJIDHyperlinkLabel.CreateWindowHandle(const Params: TCreateParams);
begin
    inherited;
    if (not _ControlsInitialized) then
    begin
        Self.caption := '';
        Self.BevelOuter := bvNone;
        Self.ParentFont := True;
        Self.ParentColor := True;
        Self.TabStop := False;
        Self.Visible := True;

        _imgAvatar.Align := alLeft;
        _imgAvatar.transparent := true;
        _imgAvatar.Visible := True;
        _imgAvatar.Width := 33;

        _lblJID.Left := 43;
        _lblJID.Top := (Self.Height div 2) - (_lblJID.Height div 2) - 3;
        _lblJID.ParentFont := True;
        _lblJID.ParentColor := True;
        _lblJID.Visible := True;
        _lblJID.AutoSize := true;
        _lblJID.ShowHint := true;
        _lblJID.ParentShowHint := false;
        _lblJID.Cursor := crHandPoint;
        
        AssignDefaultFont(_lblJID.Font); //make font match chats
        _lblJID.Font.Size := _lblJID.Font.Size + 1;
        _lblJID.Font.Color := RGBToColor(45, 135, 190);
        _lblJID.Font.style := _lblJID.Font.style + [fsBold];

        _ControlsInitialized := true;
    end;
end;

procedure TExJIDHyperlinkLabel.OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
var
    cap: widestring;
begin
    if (_ShowDisplayName) then
        cap := displayName
    else cap := _jid.getDisplayFull();

    if (_displayFormat <> '') then
        cap := WideFormat(_displayFormat, [cap]);
        
    _lblJID.Caption := cap;
    _lblJID.Hint := _jid.getDisplayFull();
end;

procedure TExJIDHyperlinkLabel.SetJID(jid: TJabberID; DisplayFormat: Widestring);
//var
//    a: TAvatar;
//    m: integer;
begin
    _displayFormat := DisplayFormat;
    _jid := TJabberID.create(jid);

    _dnListener.UID := _jid.jid;
    OnDisplayNameChange(_jid.jid, _dnListener.GetDisplayName(_jid.jid));

    // check for an avatar
    if (MainSession.Prefs.getBool('chat_avatars')) then begin
        _avatar := Avatars.Find(_jid.jid);
        if ((_avatar <> nil) and (_avatar.isValid())) then begin
            _avatar.PNGBackgroundColor := Self.Color;
            _imgAvatar.picture.assign(_avatar.Graphic);
        end
        else begin
            _imgAvatar.transparent := false;
            _imgAvatar.picture.assign(_unknownAvatar);
        end;
//
//            // Put some upper bounds on avatars in chat windows
//            m := a.Height;
//            if (m >= 0) then begin
//                _avatar := a;
//                if (m > 32) then begin
//                    m := 32;
//                    _imgAvatar.Width := Trunc((32 / _avatar.Height) * (_avatar.Width))
//                end
//                else
//                    _imgAvatar.Width := _avatar.Width;
//
//                Self.parent.ClientHeight := m + 1;
//            end;
//        end
    end
    else begin
        // No avatars are displayed
        _imgAvatar.Visible := false;
    end;
end;

procedure TExJIDHyperlinkLabel.imgAvatarPaint(Sender: TObject);
//var
//    r: TRect;
begin
//  inherited;
//    if (_avatar <> nil) then begin
//        try
//            if (_avatar.Height > _imgAvatar.Height) then begin
//                r.Top := 1;
//                r.Left := 1;
//                r.Bottom := _imgAvatar.Height;
//                r.Right := _imgAvatar.Width;
//                _avatar.Draw(_imgAvatar.Canvas, r);
//            end
//            else
//                _avatar.Draw(_imgAvatar.Canvas);
//            exit;
//        //JJF I keep getting npe here, probably bad avatar data from an
//        //earlier avatar cache implementation, but it happens regularly
//        //enough to trap and report.
//        Except
//            On E:Exception do
//            begin
//                Debug.DebugMessage('Exception attempting to draw avatar (' + e.Message + ')');
//                _avatar := nil; //try to avoid doing this again
//                                //note its just a ref to the cache
//            end;
//        end;
//    end;
//    //drops through if avatar could not be rendered
//    r.Top := 1;
//    r.Left := 1;
//    r.Bottom := 28;
//    r.Right := 28;
//    _imgAvatar.Canvas.StretchDraw(r, _UnknownAvatar);
end;

procedure TExJIDHyperlinkLabel.imgAvatarClick(Sender: TObject);
var
    r : TRect;
begin
    inherited;
    if (FloatingImage.FloatImage.Active) or (_avatar = nil) then exit;

    with FloatingImage.FloatImage do
    begin
        r := _imgAvatar.ClientRect;
        r.TopLeft := _imgAvatar.ClientOrigin;
        r.Right := r.Right + _imgAvatar.ClientOrigin.X;
        r.Bottom := r.Bottom + _imgAvatar.ClientOrigin.Y;
        ParentRect := r;
        Avatar := _avatar;
        Show();
    end;
end;

procedure TExJIDHyperlinkLabel.lblJIDCLick(Sender: TObject);
begin
    ChatWin.StartChat(_jid.jid, '', true, '', true);
end;

type
{************************* TfrmBroadcastDisplay ********************************
**
**  broadcast specific simple window. adds a "start a chat" button, jid label
**
*******************************************************************************}
    //a broadcast specific simple window. adds a "start a chat" button
    TfrmBroadcastDisplay = class(TfrmSimpleDisplay)
    private
        _pnlBottom: TTnTPanel;
        _btnChat: TTntButton;
        _lblJIDHyperlink: TExJIDHyperlinkLabel;

        procedure btnChatClick(Sender: TObject);
    public
        constructor Create(AOwner: TComponent);override;
        procedure DisplayMessage(MsgTag: TXMLTag); override;
        procedure InitializeJID(ijid: TJabberID); override;
        procedure OnDisplayNameChange(bareJID: Widestring; displayName: WideString);override;
        procedure OnDocked();override;
        procedure OnFloat();override;
        
        class procedure AutoOpenFactory(autoOpenInfo: TXMLTag); override;
    end;


constructor TfrmBroadcastDisplay.Create(AOwner: TComponent);
begin
log(Self.Classname + '.Create BEGIN');
    inherited;

    _pnlBottom := TTntPanel.Create(Self);
    _pnlBottom.Parent := Self;
    _pnlBottom.Name := 'pnlBottom';

    _btnChat := TTntButton.Create(_pnlBottom);
    _btnChat.Parent := _pnlBottom;
    _btnChat.Name := 'btnChat';
    
    pnlDockTop.ClientHeight := 28;

    _lblJIDHyperlink := TExJIDHyperlinkLabel.Create(Self.pnlDockTop);
    _lblJIDHyperlink.Parent := Self.pnlDockTop;
    _lblJIDHyperlink.Name := 'lblJIDHyperlink';

    _pnlBottom.Height := 34;
    _pnlBottom.Align := alBottom;
    _pnlBottom.caption := '';
    _pnlBottom.BevelOuter := bvNone;
    _pnlBottom.ParentFont := True;
    _pnlBottom.ParentColor := True;
    _pnlBottom.TabStop := False;
    _pnlBottom.Visible := True;

    _btnChat.Align := alLeft;
    _btnChat.Caption := _('&Start Chat');
    _btnChat.Width := 68;//Self.Canvas.TextWidth(_btnChat.Caption) + 18;
    _btnChat.AlignWithMargins := true;
    _btnChat.Margins.Bottom := 3;
    _btnChat.Margins.Top := 3;
    _btnChat.Margins.Left := 4;
    _btnChat.Margins.Right := 0;
    _btnChat.OnClick := Self.btnChatClick;

    _pnlBottom.ParentFont := True;
    _pnlBottom.TabStop := True;

    _lblJIDHyperlink.Align := alClient;
log(Self.Classname + '.Create END');
end;

class procedure TfrmBroadcastDisplay.AutoOpenFactory(autoOpenInfo: TXMLTag);
begin
    OpenFactory(TfrmBroadcastDisplay, 'broadcast', autoOpenInfo.getAttribute('jid'));
end;

procedure TfrmBroadcastDisplay.OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
begin
log(Self.Classname + '.OnDisplayNameChange BEGIN');
    if (Self.docked) then
        Caption := _('Messages from ') + displayName
    else
        Caption := _('Broadcast Messages from ') + displayName;
    Hint := _('Broadcast Messages from ') + _jid.getDisplayFull();
    inherited;
log(Self.Classname + '.OnDisplayNameChange END');
end;

//Find or create a chat controller/window for the jid/resource
//show_window = false -> window is not displayed, true->window displayed
//bring_to_front = true -> window brought to top of zorder and takes focus
{function StartChat(sjid, resource: widestring;
                   show_window: boolean;
                   chat_nick: widestring='';
                   bring_to_front:boolean=true): TfrmChat;
}
procedure TfrmBroadcastDisplay.btnChatClick(Sender: TObject);
begin
    ChatWin.StartChat(_jid.jid, '', true, '', true);
end;

procedure TfrmBroadcastDisplay.InitializeJID(ijid: TJabberID);
begin
log(Self.Classname + '.InitializeJID BEGIN');
    inherited;
    Self.ImageIndex := RI_HEADLINE_INDEX;
    Self._lblJIDHyperlink.SetJID(JID, _('Broadcast Messages from %s'));
log(Self.Classname + '.InitializeJID END');
end;

procedure TfrmBroadcastDisplay.OnDocked();
begin
log(Self.Classname + '.OnDocked BEGIN');

    Caption := _('Messages from ') + DNListener.GetDisplayName(_jid.jid);
    inherited;
log(Self.Classname + '.OnDocked END');
end;

procedure TfrmBroadcastDisplay.OnFloat();
begin
log(Self.Classname + '.OnFloat BEGIN');

    Caption := _('Broadcast Messages from ') + DNListener.GetDisplayName(_jid.jid);
    inherited;
log(Self.Classname + '.OnFloat END');
end;

procedure TfrmBroadcastDisplay.DisplayMessage(MsgTag: TXMLTag);
var
    msg: TJabberMessage;
    sTag, mTag: TXMLTag;
    subjectNick: widestring;
begin
log('TfrmBroadcastDisplay.DisplayMessage BEGIN (' + MsgTag.XML + ')');
    if (_initialMsgQueue = nil) then
    begin
log('TfrmBroadcastDisplay.DisplayMessage displaying message');
    { build new tag, changing body for broadcast presentation}
        mTag := TXMLTag.create(MsgTag);
        sTag := mTag.GetFirstTag('subject');

        subjectNick := '';
        if (sTag <> nil) then begin
            subjectNick := sTag.Data;
            //remove it from msg, not a subject change!
            mTag.RemoveTag(sTag); //sTag freed by RemoveTag
        end;
        if (subjectNick = '') then
            subjectNick := _('No Subject');

        subjectNick := _('Subject: ') + subjectNick;

        msg := CreateMessage(mTag);
        mTag.Free();
        msg.Nick := subjectNick;

        MsgList.DisplayMsg(msg);

        updateMsgCount(MsgTag);
        updateLastActivity(msg.Time);

        msg.Free();
    end
    else inherited;
log('TfrmBroadcastDisplay.DisplayMessage END');
end;

Constructor TBroadcastHandler.Create();
begin
    inherited Create();
    _NormalCB := _Session.RegisterCallback(MessageCallback, '/packet/message[@type="normal"]/body');
    _EmptyCB := _Session.RegisterCallback(MessageCallback, '/packet/message[!type]/body');
end;

Destructor TBroadcastHandler.Destroy();
begin
    _Session.UnRegisterCallback(_NormalCB);
    _Session.UnRegisterCallback(_EmptyCB);
    inherited;
end;

//add <feature var='http://jabber.org/protocol/address'/> somewhere

{
    <message from='jtest1@jfuhrman.corp.jabber.com/Jabber Messenger' type='normal'>
        <thread>4BAE8F53-4D5B-4058-AAB1-B0D4DDC2B8B3</thread>
        <addresses xmlns='http://jabber.org/protocol/address'>
            <address jid='jtest2@jfuhrman.corp.jabber.com' type='to'/>
        </addresses>
        <body>bar</body>
        <html xmlns='http://jabber.org/protocol/xhtml-im'>
            <body xmlns='http://www.w3.org/1999/xhtml'>
                <span style='font-size:x-small;color:#000000;font-family:tahoma'>bar</span>
            </body>
        </html>
        <subject>foo</subject>
    </message>
}
procedure TBroadcastHandler.MessageCallback(event: string; tag: TXMLTag);
var
    DisplayWin: TfrmSimpleDisplay;
    sstr: WideString;

    dTag: TXMLTag;
    m: TJabberMessage;
    fromJID: TJabberID;
begin
    fromJID := TJabberID.Create(tag.getAttribute('from'));
    if (MainSession.IsBlocked(fromJID)) then exit;
    
    //if from a room, bail
    if (Room.FindRoom(fromJID.jid) <> nil) then exit;

    dTag := TXMLTag.create(tag);

    {
    //set a DT stamp if it doesn't exist
    if (GetDelayTag(dtag) = nil) then
    begin
        // Add XEP-0091 style delay tag
        with dTag.AddTag('x') do begin
            setAttribute('xmlns', 'jabber:x:delay');
            setAttribute('stamp', DateTimeToJabber(UTCNow()));
        end;
    end;
    }
    DisplayWin := OpenFactory(TfrmBroadcastDisplay, 'broadcast', fromJID);
    DisplayWin.DisplayMessage(dTag);

    //event the notification
    sstr := DisplayName.getDisplayNameCache().getDisplayName(fromJID);
    Notify.DoNotify(DisplayWin, 'notify_normalmsg', _('Broadcast message from ') + sstr, RI_HEADLINE_INDEX);
    dTag.free();
    fromJID.free();

    //modify original msg tag before we log it to look more like a room's broadcast messages
    FormatBroadcastTagForLogging(tag, dtag);
    m := CreateMessage(dtag);
    ExUtils.LogMessage(m);
    m.free();
    dtag.free();
end;

type
{*******************************************************************************
***************************** TErrorDisplay ************************************
*******************************************************************************}
    TInviteDeclinedDisplay = class(TfrmSimpleDisplay)
    public
        Constructor Create(AOwner: TComponent); override;
        class procedure AutoOpenFactory(autoOpenInfo: TXMLTag); override;
    end;

class procedure TInviteDeclinedDisplay.AutoOpenFactory(autoOpenInfo: TXMLTag);
begin
    OpenFactory(TInviteDeclinedDisplay, 'invite-declined', nil);
end;

Constructor TInviteDeclinedDisplay.Create(AOwner: TComponent);
begin
    inherited;
    Caption := _('Declined Invitations');
    ImageIndex := RI_DELETE_INDEX;
    Hint := _('Declined room invitations');
end;

{*******************************************************************************
************************* TInviteDeclinedHandler *******************************
*******************************************************************************}

Constructor TInviteDeclinedHandler.Create();
begin
    Create('/packet/message/x[@xmlns="' + XMLNS_MUCUSER + '"]/decline');
end;

{
  Decline packet via XEP-45
    <message
        from='darkcave@macbeth.shakespeare.lit'
        to='crone1@shakespeare.lit/desktop'>
        <x xmlns='http://jabber.org/protocol/muc#user'>
            <decline from='hecate@shakespeare.lit'>
                <reason>
                    Sorry, I'm too busy right now.
                </reason>
            </decline>
        </x>
    </message>
}

{
    <message from='jfuhrman@corp.jabber.com/Jabber Messenger'>

        <body>Joe Fuhrman has declined your invitation to "foo bar".
 Reason: you go to hell</body>

        <html xmlns='http://jabber.org/protocol/xhtml-im'>
            <body xmlns='http://www.w3.org/1999/xhtml'>
                <span>
                    <span style='font-size:x-small;color:#000000;font-family:tahoma'>Joe Fuhrman has declined your invitation to "foo bar".  <br/> Reason: you go to hell</span>
                </span>
            </body>
        </html>
    </message>
}
procedure TInviteDeclinedHandler.MessageCallback(event: string; tag: TXMLTag);
var
    newMsg: TXMLTag;
    ttag: TXMLTag;
    udn : widestring;
    rdn: widestring;
    dr: widestring;
    xhtml: TXMLTag;
    tjid: TJabberID;
begin
    //dummy up a message to be displayed
    //<<USER>> has declined your invitation to <<ROOM>>. /n Reason: whatever
    ttag := tag.QueryXPTag('//decline');
    tjid := TJabberID.create(ttag.GetAttribute('from'));
    udn := DisplayName.getDisplayNameCache.getDisplayName(tjid);
    tjid.free();
    tjid := TJabberID.create(tag.GetAttribute('from'));
    rdn := DisplayName.getDisplayNameCache.getDisplayName(tjid.jid);
    tjid.free();
    dr := ttag.GetBasicText('reason');
    if (dr = '') then
        dr := sNO_REASON;

    //<message from="room"><body> foo </body><x
    newMsg := TXMLTag.create('message');
    newMsg.setAttribute('from', tag.GetAttribute('from'));
    newMsg.setAttribute('type', 'normal');
    newMsg.AddBasicTag('body', _(sDECLINE_DESC1 )+ udn + _(sDECLINE_DESC2) + rdn + #13#10 + _(sREASON) + dr);
    ttag := newMsg.AddTag('html');
    ttag.setAttribute('xmlns', XMLNS_XHTMLIM);
    xhtml := ttag.AddTag('body');
    xhtml.setAttribute('xmlns', XMLNS_XHTML);
    
    xhtml := xhtml.AddTag('span');
    xhtml.AddBasicTag('span', _(sDECLINE_DESC1));
    xhtml.AddBasicTag('span', udn).SetAttribute('style','font-weight:bold');
    xhtml.AddBasicTag('span', _(sDECLINE_DESC2));
    xhtml.AddBasicTag('span', rdn).SetAttribute('style','font-weight:bold');
    xhtml.AddBasicTag('span', _(sDECLINE_DESC3));
    xhtml.AddTag('br');
    xhtml.AddBasicTag('span', _(sREASON) + dr);

    OpenFactory(TInviteDeclinedDisplay, 'invite-declined', nil).DisplayMessage(newMsg);
    newMsg.Free();
end;

type
{*******************************************************************************
***************************** TErrorDisplay ************************************
*******************************************************************************}
    TErrorDisplay = class(TfrmSimpleDisplay)
    public
        Constructor Create(AOwner: TComponent); override;
        class procedure AutoOpenFactory(autoOpenInfo: TXMLTag); override;
    end;

class procedure TErrorDisplay.AutoOpenFactory(autoOpenInfo: TXMLTag);
begin
    OpenFactory(TErrorDisplay, 'message-errors', nil);
end;

Constructor TErrorDisplay.Create(AOwner: TComponent);
begin
    inherited;
    Caption := _('Undeliverable');
    ImageIndex := RI_ERROR_INDEX;
    Hint := _('Messages returned because they could not be properly delivered');
end;

{*******************************************************************************
****************************** TErrorHandler ***********************************
*******************************************************************************}
Constructor TErrorHandler.Create();
begin
    Create('/post/message[@type="error"]');
end;

procedure TErrorHandler.MessageCallback(event: string; tag: TXMLTag);
begin
    OpenFactory(TErrorDisplay, 'message-errors', nil).DisplayMessage(tag);
end;


{*******************************************************************************
*************************** TfrmSimpleDisplay **********************************
*******************************************************************************}
Constructor TfrmSimpleDisplay.Create(AOwner: TComponent);
begin
log('TfrmSimpleDisplay(' + Self.Classname + ').create BEGIN');

    _dnListener := nil;
    _jid := nil;
    _initialMsgQueue := TObjectList.create();
    _MsgList := nil;
    
    inherited;

    _SessionListener := TSessionListener.create(OnAuthenticated, OnDisconnected);
    CloseOnDisconnect := true;
    PersistUnreadMessages := True;
    Self.UnreadMsgCount := 0;
log('TfrmSimpleDisplay(' + Self.Classname + ').create END');
end;

function TfrmSimpleDisplay.GetAutoOpenInfo(event: Widestring; var useProfile: boolean): TXMLTag;
begin
    Result := nil;
    if (event = 'disconnected') and (PersistUnreadMessages) and (self.UnreadMsgCount > 0) then
    begin
        Result := TXMLtag.Create(Self.ClassName);
        Result.setattribute('uid', UID);
        Result.setAttribute('type', _windowType);
        if (_jid <> nil) then
            Result.setattribute('jid', JID.jid);
        Result.setAttribute('auto-open-override', 'true');
        useProfile := true;
    end;
end;

procedure TfrmSimpleDisplay.RefreshMsgList();
var
    i: integer;
    hist: WideString;
    tq: TObjectList;
begin
log('TfrmSimpleDisplay(' + Self.Classname + ').RefreshMsgList BEGIN');

    inherited;
    if (_MsgList <> nil) then
    begin
log('TfrmSimpleDisplay(' + Self.Classname + ').RefreshMsgList MsgList exists');
        if (_initialMsgQueue = nil) then
        begin
            hist := _msgList.getHistory();
log('TfrmSimpleDisplay(' + Self.Classname + ').RefreshMsgList initialMsgQueue = nil, current MsgList history: ' + hist);
        end;
        try
            _MsgList.Free();
        except
            On E:Exception do
                Debug.DebugMessage('TfrmSimpleDisplay(' + Self.Classname + ').RefreshMsgList Exception trying to free existing MsgList: ' + E.Message);
        end;
    end;
log('TfrmSimpleDisplay(' + Self.Classname + ').RefreshMsgList creating new msglist');
    try
        _MsgList := BaseMsgList.MsgListFactory(Self, pnlMsgDisplay);
    except
        On E:Exception do
            Debug.DebugMessage('TfrmSimpleDisplay(' + Self.Classname + ').RefreshMsgList Exception trying to create MsgList: ' + E.Message);
    end;
    _MsgList.setContextMenu(mnuSimplePopup);
    _MsgList.setDragOver(OnDockedDragOver);
    _MsgList.setDragDrop(OnDragDrop);
log('TfrmSimpleDisplay(' + Self.Classname + ').RefreshMsgList clearing msglist');

    _MsgList.Clear();

    //browser doesn't like to be reparented. recreate and repopluate
    if (_initialMsgQueue <> nil) then
    begin
log('TfrmSimpleDisplay(' + Self.Classname + ').RefreshMsgList populating msglist with messages in initialMsgQueue');
        tq := _initialMsgQueue;
        _initialMsgQueue := nil;
        for i := 0 to tq.Count - 1 do
        begin
            Self.DisplayMessage(TXMLTag(tq[i]));
        end;
        tq.Free();
    end
    else begin
log('TfrmSimpleDisplay(' + Self.Classname + ').RefreshMsgList populating msglist with previous history');
        _msgList.populate(hist);
    end;
log('TfrmSimpleDisplay(' + Self.Classname + ').RefreshMsgList END');
end;

procedure TfrmSimpleDisplay.OnPersistedMessage(msg: TXMLTag);
begin
log('TfrmSimpleDisplay(' + Self.Classname + ').OnPersistedMessage BEGIN');
    inherited;
    Self.DisplayMessage(msg);
log('TfrmSimpleDisplay(' + Self.Classname + ').OnPersistedMessage BEGIN');
end;

function TfrmSimpleDisplay.GetWindowStateKey() : WideString;
begin
    Result := inherited GetWindowStateKey() + '-' + XMLUtils.MungeXMLName(Self.UID);
end;

function TfrmSimpleDisplay.GetMsgList(): TfBaseMsgList;
begin
    Result := _MsgList;
end;

procedure TfrmSimpleDisplay.mnuClick(Sender: TObject);
begin
    inherited;
    if (Sender = mnuCopy) then
        MsgList.Copy()
    else if (Sender = mnuCopyAll) then
        MsgList.CopyAll()
    else if (Sender = mnuClear) then
        MsgList.Clear();
end;

procedure TfrmSimpleDisplay.InitializeJID(ijid: TJabberID = nil);
begin
log('TfrmSimpleDisplay(' + Self.Classname + ').InitializeJID BEGIN');

    if (ijid <> nil) then
    begin
        _jid := TJabberID.create(ijid);
        _dnListener := TDisplayNameEventListener.Create();
        _dnListener.OnDisplayNameChange := Self.OnDisplayNameChange;
        _dnListener.UID := _jid.jid;
        OnDisplayNameChange(_jid.jid, _dnListener.GetDisplayName(_jid.jid));
    end;
log('TfrmSimpleDisplay(' + Self.Classname + ').InitializeJID END');
end;

procedure TfrmSimpleDisplay.DisplayMessage(MsgTag: TXMLTag);
var
    msg: TJabberMessage;
begin
log('TfrmSimpleDisplay.DisplayMessage BEGIN (' + MsgTag.XML + ')');
    if (_initialMsgQueue <> nil) then
    begin
log('TfrmSimpleDisplay.DisplayMessage adding message to _initialMsgQueue');

        _initialMsgQueue.Add(TXMLTag.Create(MsgTag)) //copy of tag, list will free
    end
    else begin
log('TfrmSimpleDisplay.DisplayMessage displaying message');

        msg := CreateMessage(MsgTag);

        MsgList.DisplayMsg(msg);

        updateMsgCount(MsgTag);
        updateLastActivity(msg.Time);

        msg.Free();
    end;
log('TfrmSimpleDisplay.DisplayMessage END');
end;

procedure TfrmSimpleDisplay.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    inherited;
    Action := caFree;
end;

procedure TfrmSimpleDisplay.FormDestroy(Sender: TObject);
begin
log('TfrmSimpleDisplay(' + Self.Classname + ').FormDestroy BEGIN');

    //remove ourself from simplewindow list
    RemoveWindow(Self.UID);

    _SessionListener.Free();
    if (_jid <> nil) then
    begin
        _jid.free();
        _dnListener.free();
    end;
    inherited;
log('TfrmSimpleDisplay(' + Self.Classname + ').FormDestroy END');
end;

procedure TfrmSimpleDisplay.OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
begin
log('TfrmSimpleDisplay(' + Self.Classname + ').OnDisplayNameChange BEGIN');
    UpdateDocked();
log('TfrmSimpleDisplay(' + Self.Classname + ').OnDisplayNameChange END');
end;

procedure TfrmSimpleDisplay.Update;
begin
    inherited;
    updateDocked();
end;

procedure TfrmSimpleDisplay.OnDocked();
begin
log('TfrmSimpleDisplay(' + Self.Classname + ').OnDocked BEGIN');

    inherited;
    //browser doesn't like to be reparented. recreate and repopluate

    RefreshMsgList();
log('TfrmSimpleDisplay(' + Self.Classname + ').OnDocked END');
end;

procedure TfrmSimpleDisplay.OnFloat();
begin
log('TfrmSimpleDisplay(' + Self.Classname + ').OnFloat BEGIN');
    inherited;
    //browser doesn't like to be reparented. recreate and repopluate
    RefreshMsgList();
log('TfrmSimpleDisplay(' + Self.Classname + ').OnFloat END');
end;

procedure TfrmSimpleDisplay.OnAuthenticated();
begin
    //nop
end;

procedure TfrmSimpleDisplay.OnDisconnected(ForcedDisconnect: boolean; Reason: WideString);
begin
    if (CloseOnDisconnect) then
        Self.Close();
end;

initialization
    Classes.RegisterClass(TfrmBroadcastDisplay);
    Classes.RegisterClass(THeadlineDisplay);
    Classes.RegisterClass(TErrorDisplay);
    Classes.RegisterClass(TInviteDeclinedDisplay);
    
    _SimpleMessageWindows := TObjectList.create(false);
    _handlers := TObjectList.create(true);
    
finalization
    _SimpleMessageWindows.Free();
    _handlers.Free();
end.
