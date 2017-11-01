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
unit InviteReceived;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Dockable, ComCtrls, ToolWin, ExtCtrls, StdCtrls, TntStdCtrls,
  ExForm,
  XMLTag,
  JabberID,
  Session,
  DisplayName,
  TntExtCtrls, ExBrandPanel, ExGroupBox;

type
  TfrmInviteReceived = class(TExForm)
    pnlHeader: TFlowPanel;
    lblInvitor: TTntLabel;
    lblFiller1: TTntLabel;
    lblRoom: TTntLabel;
    TntLabel1: TTntLabel;
    TntPanel4: TTntPanel;
    btnAccept: TTntButton;
    btnDecline: TTntButton;
    btnIgnore: TTntButton;
    ExGroupBox1: TExGroupBox;
    lblInviteMessage: TTntLabel;
    ExGroupBox2: TExGroupBox;
    txtReason: TTntEdit;
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnIgnoreClick(Sender: TObject);
    procedure btnDeclineClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure lblInvitorClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);

    procedure WMNCActivate(var msg: TMessage); message WM_NCACTIVATE;
  private
    _dnListener: TDisplayNameEventListener;
    _InvitePacket: TXMLTag;
    _FromJID: TJabberID;
    _RoomJID: TJabberID;
    
    procedure InitializeFromTag(InvitePacket: TXMLTag);
  published
    procedure OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
  end;

    procedure OnSessionStart(Session: TJabberSession);
    procedure OnSessionEnd();

implementation

{$R *.dfm}
uses
    GnuGetText,
    Room,
    Unicode,
    JabberConst,
    Notify,
    ExUtils,
    ChatWin,
    Contnrs,
    RosterImages;
const
    LEFT_OFFSET = 60;
    TOP_OFFSET = 60;

    sDEFAULT_DECLINE_REASON = 'Sorry, I am not interested in joining right now.';

type

    TFrmDecline = class(TExForm)

    end;



    TInvitePos = class
        _Left: integer;
        _Top: integer;
        _Frm: TForm;
    end;

    TWindowPosHelper = class
    private
        _TrackedWindows: TObjectList; //of TInvitePos
        _InitialPos: TPoint;
                
        function IndexOf(frm: TForm): integer;
    public
        Constructor Create();
        Destructor Destroy; override;

        function GetNextPos(frm: TForm): TPoint;
        procedure AddWindow(frm: TForm);
        procedure RemoveWindow(frm: TForm);
        procedure SetInitialPosition(p: TPoint);
    end;

    TInviteHandler = class
    private
        _Session: TJabberSession;   //current session
        _OpenReceivedList: TWideStringList; //list of open invites by room
        _ReceivedPosHelper: TWindowPosHelper;

        _SessionListener: TSessionListener;

        _InviteCB: Integer;
        _InviteNoTypeCB: integer;
        
        procedure OnDisconnected(ForcedDisconnect: boolean; Reason: WideString);

        procedure SetSession(JabberSession: TJabberSession);

        procedure ShowInviteReceived(InvitePacket: TXMLTag);
        
        procedure InviteCallback(event: string; InvitePacket: TXMLTag);

        procedure AddWindow(key: widestring; frm: TForm);
        procedure RemoveWindow(frm: TForm);
    public
        Constructor Create(JabberSession: TJabberSession);
        Destructor Destroy(); override;

        //invite form event handlers
        procedure OnFormClose(Sender: TObject; var Action: TCloseAction);
    end;


var
    _InviteHandler : TInviteHandler;

{Event fired indicating session object is created and ready}
procedure OnSessionStart(Session: TJabberSession);
begin
    if (_InviteHandler <> nil) then
    begin
        _InviteHandler.free();
        _InviteHandler := nil;
    end;
    if (Session <> nil) then
        _InviteHandler := TInviteHandler.create(Session);
end;

{Session object is being destroyed. Still valid for this call but not after}
procedure OnSessionEnd();
begin
    if (_InviteHandler <> nil) then
    begin
        _InviteHandler.free();
        _InviteHandler := nil;
    end;
end;


procedure TWindowPosHelper.SetInitialPosition(p: TPoint);
begin
    _InitialPos := p;
end;

function TWindowPosHelper.IndexOf(frm: TForm): integer;
begin
    for Result := 0 to _TrackedWindows.Count - 1 do
    begin
        if (TInvitePos(_TrackedWindows[Result])._Frm = frm) then
            exit;
    end;
    Result := -1;
end;

Constructor TWindowPosHelper.Create();
begin
    _TrackedWindows := TObjectList.create();
    _InitialPos.X := 0;
    _InitialPos.Y := 0;
end;

Destructor TWindowPosHelper.Destroy;
begin
    _TrackedWindows.free();
end;

function TWindowPosHelper.GetNextPos(frm: TForm): TPoint;
var
    oneTI: TInvitePos;
begin
    Result.X := -1;
    Result.Y := -1;
    if (_TrackedWindows.Count = 0) then
    begin
        Result := _InitialPos;//(frm.Monitor.Width div 2) - (frm.Width div 2);
        //Result.Y := (frm.Monitor.Height div 2) - (frm.Height div 2);
    end
    else begin
        oneTI := TInvitePos(_TrackedWindows[_TrackedWindows.Count - 1]);
        Result.X := oneTI._Left + LEFT_OFFSET;
        Result.Y := oneTI._Top + TOP_OFFSET;
    end;

    if (((Result.X + frm.Width) > frm.Monitor.Width) or
        ((Result.Y + frm.Height) > frm.Monitor.Height)) then
    begin
        Result.X := _InitialPos.X + LEFT_OFFSET;
        Result.Y := _InitialPos.Y;
    end;
end;

procedure TWindowPosHelper.AddWindow(frm: TForm);
var
    ti : TInvitePos;
    i: integer;
begin
    i := IndexOf(frm);
    if (i = -1) then begin
        ti := TInvitePos.Create();
        ti._Frm := frm;
        ti._Left := frm.Left;
        ti._Top := frm.Top;
        _TrackedWindows.Add(ti)
    end;
end;

procedure TWindowPosHelper.RemoveWindow(frm: TForm);
var
    i: integer;
begin
    i := IndexOf(frm);
    if (i <> -1) then
        _TrackedWindows.Delete(i);
end;

procedure TInviteHandler.OnDisconnected(ForcedDisconnect: boolean; Reason: WideString);
var
    i: Integer;
begin
    for i := _OpenReceivedList.Count - 1 downto 0 do
        TForm(_OpenReceivedList.Objects[i]).Close();
end;


{ Invite packet via XEP-45:
    <message
        from='darkcave@macbeth.shakespeare.lit'
        to='hecate@shakespeare.lit'>
      <x xmlns='http://jabber.org/protocol/muc#user'>
        <invite from='crone1@shakespeare.lit/desktop'>
          <reason>
            Hey Hecate, this is the place for all good witches!
          </reason>
        </invite>
        <password>cauldronburn</password>
      </x>
    </message>

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

procedure TInviteHandler.SetSession(JabberSession: TJabberSession);
begin
    //reassigning session, remove any existing listeners
    if (_Session <> nil) then
    begin
        if (_InviteCB <> -1) then
        begin
            _Session.UnRegisterCallback(_InviteCB);
            _InviteCB := -1;
        end;
        if (_InviteNoTypeCB <> -1) then
        begin
            _Session.UnRegisterCallback(_InviteNoTypeCB);
            _InviteNoTypeCB := -1;
        end;
        _SessionListener.Free();
    end;

    _Session := JabberSession;

    if (_Session <> nil)  then
    begin
        _InviteCB := _Session.RegisterCallback(InviteCallback,
                                               '/packet/message[@type="normal"]/x[@xmlns="' + XMLNS_MUCUSER + '"]/invite');
        _InviteNoTypeCB := _Session.RegisterCallback(InviteCallback,
                                               '/packet/message[!type]/x[@xmlns="' + XMLNS_MUCUSER + '"]/invite');
        _SessionListener := TSessionListener.create(nil, OnDisconnected, _Session);
    end;
end;

Constructor TInviteHandler.Create(JabberSession: TJabberSession);
begin
    _InviteCB := -1;
    _InviteNoTypeCB := -1;
    _sessionListener := nil;
        
    _OpenReceivedList := TWideStringList.Create();

    _ReceivedPosHelper := nil;

    SetSession(JabberSession);
end;


Destructor TInviteHandler.Destroy();
begin
    _OpenReceivedList.Free();
    _ReceivedPosHelper.Free();
    SetSession(nil); 
end;

procedure JoinRoom(InvitePacket: TXMLTag);
var
    pw: WideString; //password if it exists
    RoomName: WideString;
    ttag: TXMLTag;
begin
    RoomName := InvitePacket.getAttribute('from');
    //password
    ttag := InvitePacket.QueryXPTag('/message/x[@xmlns="' + XMLNS_MUCUSER + '"]');
    pw := ttag.GetBasicText('password');
    //jid, nick, pw, presence, default config, registered nick, bring to front
    StartRoom(RoomName, '', pw, True, False, True, True);
end;


procedure TInviteHandler.InviteCallback(event: string; InvitePacket: TXMLTag);
var
    ttag: TXMLtag;
    tjid: TJabberID;
begin
    ttag := InvitePacket.QueryXPTag('/message/x[@xmlns="' + XMLNS_MUCUSER + '"]/invite');
    //make sure this is contact is not blocked
    tjid := TJabberID.create(ttag.GetAttribute('from'));
    if (not _Session.IsBlocked(tjid.jid)) then
    begin
        if (_Session.prefs.getBool('auto_join_on_invite')) then
            JoinRoom(InvitePacket)
        else
            ShowInviteReceived(InvitePacket);
    end;
    tjid.free();
end;

procedure TInviteHandler.ShowInviteReceived(InvitePacket: TXMLTag);
var
    from: widestring;
    frm: TfrmInviteReceived;
    p: TPoint;
begin

    from := InvitePacket.getAttribute('from');
    //only one invite per room should be shown
    if (_OpenReceivedList.IndexOf(from) = -1) then begin
        frm := TfrmInviteReceived.Create(Application);
         if (_ReceivedPosHelper = nil) then
        begin
            _ReceivedPosHelper := TWindowPosHelper.create();
            p.X := (frm.Monitor.Width div 2) - (frm.Width div 2);
            p.Y := (frm.Monitor.Height div 2) - (frm.Height div 2);
            _ReceivedPosHelper.SetInitialPosition(p);
        end;
        p := _ReceivedPosHelper.GetNextPos(frm);
        frm.Left := p.X;
        frm.Top := P.Y;
        frm.OnClose := Self.OnFormClose;
        AddWindow(from, frm);
    end
    else
        frm := TfrmInviteReceived(_OpenReceivedList.Objects[_OpenReceivedList.IndexOf(from)]);
    frm.InitializeFromTag(InvitePacket);
    frm.Show();

    Notify.DoNotify(Application.Mainform, 'notify_invite', 'You have received an invitation to join ' + frm.lblRoom.Caption, RI_CONFERENCE_INDEX);
end;

procedure TInviteHandler.OnFormClose(Sender: TObject; var Action: TCloseAction);
begin
    if (Sender is TForm) then
        RemoveWindow(TForm(Sender));
    inherited;
end;

procedure TInviteHandler.AddWindow(key: widestring; frm: TForm);
begin
    _OpenReceivedList.AddObject(key, frm);
    _ReceivedPosHelper.AddWindow(frm);
end;

procedure TInviteHandler.RemoveWindow(frm: TForm);
var
    i: integer;
begin
    _ReceivedPosHelper.RemoveWindow(frm);
    i := _OpenReceivedList.IndexOfObject(frm);
    if (i <> -1) then
        _OpenReceivedList.Delete(i);
end;

procedure TfrmInviteReceived.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    inherited;
    Action := caFree;
end;

procedure TfrmInviteReceived.TntFormCreate(Sender: TObject);
begin
    inherited;
    _dnListener := TDisplayNameEventListener.Create(); 
    _dnListener.OnDisplayNameChange := Self.OnDisplayNameChange;
    _FromJID := nil;
    _InvitePacket := nil;
    _RoomJID := nil;
    URLLabel(Self.lblInvitor);
end;

procedure TfrmInviteReceived.TntFormDestroy(Sender: TObject);
begin
    inherited;
    _DNListener.Free();
    if (_InvitePacket <> nil) then
        _InvitePacket.Free();
    if (_FromJID <> nil) then
        _FromJID.free();
    if (_RoomJID <> nil) then
        _RoomJID.free();
end;

procedure TfrmInviteReceived.WMNCActivate(var msg: TMessage);
begin
    if (Msg.WParamLo <> WA_INACTIVE) then
        StopFlash(Application.MainForm);
    inherited;
end;

procedure TfrmInviteReceived.TntFormShow(Sender: TObject);
begin
    inherited;
    //force some alignment
    Self.lblInviteMessage.AutoSize := false;
    Self.lblInviteMessage.AutoSize := true;
    Self.ExGroupBox1.AutoSize := false;
    Self.ExGroupBox1.AutoSize := true;
    Self.AutoSize := false;
    Self.AutoSize := true;
end;

procedure TfrmInviteReceived.btnAcceptClick(Sender: TObject);
begin
    JoinRoom(_InvitePacket);
    inherited;
    Close();
end;

{ decline packet via XEP-45
<message
    from='hecate@shakespeare.lit/broom'
    to='darkcave@macbeth.shakespeare.lit'>
  <x xmlns='http://jabber.org/protocol/muc#user'>
    <decline to='crone1@shakespeare.lit'>
      <reason>
        Sorry, I'm too busy right now.
      </reason>
    </decline>
  </x>
</message>
}

procedure TfrmInviteReceived.btnDeclineClick(Sender: TObject);
var
    mTag: TXmlTag;
    tTag: TXMLTag;
    reason: Widestring;
begin
    inherited;
    // send back a decline message.
    mTag := TXmlTag.Create('message');
    mTag.setAttribute('to', _RoomJID.jid);
    tTag := mTag.AddTag('x');
    tTag.setAttribute('xmlns', XMLNS_MUCUSER);
    tTag := tTag.AddTag('decline');
    tTag.setAttribute('to', _FromJID.jid);
    reason := Self.txtReason.Text;
    if (reason = '') then
        reason := sDEFAULT_DECLINE_REASON;
    tTag.AddBasicTag('reason', reason);

    MainSession.SendTag(mTag); //frees mTag

    Close();
end;

procedure TfrmInviteReceived.btnIgnoreClick(Sender: TObject);
begin
    inherited;
    Close();
end;

procedure TfrmInviteReceived.OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
begin
    Self.lblInvitor.Caption := DisplayName;
    //force some alignment
    Self.lblInviteMessage.AutoSize := false;
    Self.lblInviteMessage.AutoSize := true;
    Self.ExGroupBox1.AutoSize := false;
    Self.ExGroupBox1.AutoSize := true;
    Self.AutoSize := false;
    Self.AutoSize := true;
end;

procedure TfrmInviteReceived.InitializeFromTag(InvitePacket: TXMLTag);
var
    tJID: TJabberID;
    inviteMessage: widestring;
    itag: TXMLTag;
begin
    Self.AutoSize := false;
    //if already in the room ignore invite
    itag := InvitePacket.QueryXPTag('/message/x[@xmlns="' + XMLNS_MUCUSER + '"]/invite');

    if (_invitePacket <> nil) then
        _InvitePacket.Free(); //in case we received a second invite to this room
    if (_FromJID <> nil) then
        _FromJID.free();

    _InvitePacket := TXMLTag.Create(InvitePacket); //copy for later use

    //various labels
    _RoomJID := TJabberID.Create(InvitePacket.getAttribute('from'));
    Self.lblRoom.Caption := DisplayName.getDisplayNameCache.getDisplayName(_RoomJID);
    Self.lblRoom.Hint := _RoomJID.getDisplayJID();
    Self.lblRoom.font.Style := Self.lblRoom.font.Style + [fsBold];

    tJID := TJabberID.Create(itag.GetAttribute('from'));
    _FromJID := TJabberID.Create(tJID.jid); //bare JID
    Self.lblInvitor.Hint := tJID.getDisplayFull();
    _dnListener.UID := tJID.jid; //listen for DN changes from this JID only
    tJID.free();

    inviteMessage := itag.GetBasicText('reason');
    if (InviteMessage <> '') then
        Self.lblInviteMessage.Caption := InviteMessage;
    Self.lblInvitor.Caption := DisplayName.getDisplayNameCache.getDisplayName(_FromJID);
end;

procedure TfrmInviteReceived.lblInvitorClick(Sender: TObject);
begin
    inherited;
    StartChat(_FromJID.jid, '', true);
end;

initialization
    _InviteHandler := nil;

end.





