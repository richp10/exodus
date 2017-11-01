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
unit RosterAdd;


interface

uses
    Entity, EntityCache, JabberID, XMLTag,
    DisplayName,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, TntStdCtrls, TntForms, ExFrame, ExForm;

const
    P_BRAND_NETWORKS= 'brand_networks';

    NT_TRANSPORT    = 'transport';
    NT_IN_NETWORK   = 'in-network';

type
    TNetworkInfo = class
    public
        name: WideString;
        nType: WideString;
        transFeat: WideString;
        acName: WideString;
        acJID: TJabberID;
        constructor create(name, nType, tdata: WideString);overload;
        constructor create(prefStr: WideString);overload;
        destructor Destroy();override;

        procedure init(name, nType, tData: WideString);
        function isValidAutoComplete() : boolean;
        function isValid() : boolean;
        function isInNetwork() : boolean;
    end;

  TfrmAdd = class(TExForm)
    Label1: TTntLabel;
    txtJID: TTntEdit;
    Label2: TTntLabel;
    txtNickname: TTntEdit;
    Label3: TTntLabel;
    cboGroup: TTntComboBox;
    frameButtons1: TframeButtons;
    cboType: TTntComboBox;
    Label4: TTntLabel;
    lblGateway: TTntLabel;
    txtGateway: TTntEdit;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure lblAddGrpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure txtJIDExit(Sender: TObject);
    procedure cboTypeChange(Sender: TObject);
    procedure txtNicknameChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure txtJIDChange(Sender: TObject);
  private
    { Private declarations }
    cb: integer;
    gw_ent: TJabberEntity;
    gw, sjid, snick, sgrp: Widestring;
    addInfo : TNetworkInfo;
    dnListener: TDisplayNameEventListener;
    procedure doAdd;

    procedure setContact(contact: TJabberID = nil);
  published
    procedure EntityCallback(event: string; tag: TXMLTag);
    procedure OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
  public
    { Public declarations }
  end;


var
  frmAdd: TfrmAdd;

procedure ShowAddContact(contact: TJabberID = nil); overload;
procedure ShowAddContact(contact: Widestring); overload;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    InputPassword, ExSession, JabberUtils, ExUtils,  PrefController, 
    GnuGetText, Jabber1, Presence, Session, Unicode, COMExodusItem,
    Exodus_TLB;

const
    sNoDomain = 'The contact ID you entered does not follow the standard user@host convention. Do you want to continue?';
    sResourceSpec = 'Jabber Contact IDs do not typically include a resource. Are you sure you want to add this contact ID?';
    sNoGatewayFound = 'The gateway server you requested does not have a transport for this contact type.';
    sNotAddMyself = 'You can not add yourself to your roster.';

{$R *.DFM}
function autoComplete() : boolean;
begin
    Result := MainSession.Prefs.getBool(PrefController.P_AUTO_COMPLETE_JIDS);
end;

constructor TNetworkInfo.create(name, nType, tdata: WideString);
begin
    inherited create;
    init(name, nType, tData);
end;

constructor TNetworkInfo.create(prefStr: WideString);
var
    tstr, nameStr, typeStr, dataStr: WideString;
    delim: WideChar;
    nextDelim: integer;
begin
    inherited create;
    //parse pref, should be |name|type|data| tuples
    delim := prefStr[1];
    tstr := Copy(prefStr, 2, Length(prefStr));
    nextDelim := Pos(delim, tstr);
    nameStr := Copy(tstr, 1, nextDelim - 1);
    tstr := Copy(tstr, nextDelim + 1, Length(tstr));
    nextDelim := Pos(delim, tstr);
    typeStr := Copy(tstr, 1, nextDelim - 1);
    tstr := Copy(tstr, nextDelim + 1, Length(tstr));
    nextDelim := Pos(delim, tstr);
    dataStr := Copy(tstr, 1, nextDelim - 1);
    
    init(nameStr, typeStr, dataStr);
end;


destructor TNetworkInfo.destroy();
begin
    if (acJID <> nil) then
        acJID.Free();
end;

procedure TNetworkInfo.init(name, nType, tData: WideString);
begin
    Self.name := name;
    Self.nType := nType;
    if (NT_TRANSPORT = Self.nType) then begin
        Self.transFeat := tData;
    end
    else begin
        Self.acName := tdata;
        Self.acJID := nil;
        if (Length(Self.acName) > 0) then begin
            //construct jid of auto completion domain name. First assume escaped
            acJID := TJabberID.create(acName, true);
            if (not acJID.isValid) then begin
                //try with not escaped
                acJID.Free();
                acJID := TJabberID.create(acName, false);
                //null if not valid
                if (not acJID.isValid) then begin
                    acJId.Free();
                    acJID := nil;
                end;
            end;
        end;
    end;
end;

function TNetworkInfo.isValidAutoComplete() : boolean;
begin
    result := ((acJID <> nil) and acJID.isValid);
end;

function TNetworkInfo.isValid() : boolean;
begin
    result := (Length(name) > 0) and (Length(nType) > 0);
end;

function TNetworkInfo.isInNetwork() : boolean;
begin
    Result := (nType = NT_IN_NETWORK); 
end;

{---------------------------------------}
procedure ShowAddContact(contact: TJabberID);
var
    f: TfrmAdd;
begin
    f := TfrmAdd.Create(Application);
    f.setContact(contact);
    contact.Free();
    f.Show;
    f.BringToFront();
end;

{---------------------------------------}
procedure ShowAddContact(contact: Widestring);
var
    j: TJabberID;
begin
    j := TJabberID.Create(contact);
    ShowAddContact(j);
end;

procedure TfrmAdd.setContact(contact: TJabberID);
var
    pendingNameChange: boolean;
begin
    if (contact <> nil) then begin
        txtJid.Text := contact.GetDisplayJID();
        dnListener.UID := contact.jid; //listen for updates to this jid only
        txtNickname.Text := TDisplayNameEventListener.getDisplayName(contact.jid, pendingNameChange);
        if (pendingNameChange) then
            txtNickname.Font.Style := txtNickname.Font.Style + [fsUnderline]
        else
            txtNickname.Font.Style := txtNickname.Font.Style - [fsUnderline]
    end
    else begin
        txtJid.Text := '';
        txtNickname.Text := '';
    end;
end;

{---------------------------------------}
procedure TfrmAdd.frameButtons1btnOKClick(Sender: TObject);
var
    tmp_jid: TJabberID;
    tmp_xml: TXMLTag;
begin
    // Add the new roster item..
    sjid := txtJID.Text;
    snick := txtNickname.Text;
    sgrp := cboGroup.Text;
    addInfo := TNetworkInfo(cboType.Items.Objects[cboType.ItemIndex]);

    tmp_xml := TXMLTag.Create('roster_add');
    tmp_xml.AddBasicTag('name', addInfo.name);
    tmp_xml.AddBasicTag('network_type', addInfo.nType);
    tmp_xml.AddBasicTag('transport_features', addInfo.transFeat);
    tmp_xml.AddBasicTag('auto_complete_data', addInfo.acName);
    tmp_xml.AddBasicTag('jid', sjid);
    tmp_xml.AddBasicTag('nick', snick);
    tmp_xml.AddBasicTag('group', sgrp);

    if (addInfo.isInNetwork()) then begin
        tmp_jid := TJabberID.Create(sjid, false);
        MainSession.UnBlock(tmp_jid); // Make sure we aren't blocking the contact we wish to add.
        sjid := tmp_jid.jid;
        if (WideLowercase(sjid) = WideLowercase(MainSession.Profile.getJabberID().jid())) then begin
            MessageDlgW(_(sNotAddMyself), mtError, [mbOK], 0);
            tmp_xml.Free();
            exit;
        end;

        if (tmp_jid.user = '') then
            if MessageDlgW(_(sNoDomain), mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
        if (tmp_jid.resource <> '') then
            if MessageDlgW(_(sResourceSpec), mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
{ TODO : Roster refactor }
        //MainSession.FireEvent('/roster/add/in-network/' + addInfo.name, IExodusItem(nil));
        doAdd();
        tmp_jid.Free();
    end
    else begin
        // Adding a gateway'd user
        gw := txtGateway.Text;
        gw_ent := jEntityCache.getByJid(gw);
        if (gw_ent = nil) then begin
            cb := MainSession.RegisterCallback(EntityCallback, '/session/entity/items');
            gw_ent := jEntityCache.fetch(gw, MainSession);
            self.Hide();
        end
        else begin
 { TODO : Roster refactor }       
        //    MainSession.FireEvent('/roster/add/gateway/' + addInfo.name, nil);
            doAdd();
        end;
    end;

    tmp_xml.Free();
end;

{---------------------------------------}
procedure TfrmAdd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmAdd.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmAdd.lblAddGrpClick(Sender: TObject);
//var
//    go: TJabberGroup;
begin
    // Add a new group to the list...
 { TODO : Roster refactor }   
//    go := promptNewGroup();
//    if (go <> nil) then
//        MainSession.Roster.AssignGroups(cboGroup.Items);
end;

{---------------------------------------}
procedure TfrmAdd.FormCreate(Sender: TObject);
var
    i, nNetworks: Integer;
    tinfo : TNetworkInfo;

    procedure populateGroups();
    var
        idx: Integer;
        items: IExodusItemList;
    begin
        items := MainSession.ItemController.GetItemsByType('group');
        for idx := 0 to items.Count - 1 do begin
            cboGroup.Items.Add(items.Item[idx].UID);
        end;
    end;
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);

    populateGroups();
    cboGroup.Text := MainSession.Prefs.getString('roster_default');

    dnListener := TDisplayNameEventListener.Create();
    dnListener.OnDisplayNameChange := Self.OnDisplayNameChange;
    
    txtGateway.Text := MainSession.Server;
    //walk prefs list of networks
    tInfo := TNetworkInfo.create(_('Jabber'), NT_IN_NETWORK, MainSession.Profile.getJabberID().domain);
    cboType.AddItem(tInfo.name, tInfo);
    nNetworks := MainSession.Prefs.getStringlistCount(P_BRAND_NETWORKS);
    for i := 0 to (nNetworks -1) do begin
        tInfo := TNetworkInfo.create(MainSession.Prefs.getStringlistValue(P_BRAND_NETWORKS, i));
        if (tInfo.isValid()) then begin
            cboType.AddItem(_(tInfo.name), tInfo);        
        end;
    end;
    cboType.ItemIndex := 0;
end;

procedure TfrmAdd.FormDestroy(Sender: TObject);
begin
    dnListener.Free();
end;

{---------------------------------------}
procedure TfrmAdd.txtJIDChange(Sender: TObject);
begin
    if (Length(Trim(txtJid.Text)) > 0) then
        Self.frameButtons1.btnOK.Enabled := true
    else
        Self.frameButtons1.btnOK.Enabled := false;
end;

procedure TfrmAdd.txtJIDExit(Sender: TObject);
var
    tmp_id, ti2: TJabberID;
    tinfo : TNetworkInfo;
    pendingNameChange: boolean;
begin
    if (txtJID.Text = '') then exit;
    tmp_id := TJabberID.Create(txtJID.Text, false); //assume unescaped
    //autocomplete
    tinfo := TNetworkInfo(cboType.Items.Objects[cboType.ItemIndex]);
    if (not tmp_id.isValid or (tmp_id.user = '')) then begin //need to fixup JID?
    //JID doesn't seem to handle username@ correctly. That should be an escapeable
        if (autoComplete() and tinfo.isValidAutoComplete()) then begin
            //if its not valid, we could have an unparsable username (like user@)
            if (not tmp_id.isValid) then
                ti2 := TJabberID.Create(tmp_id.jid + '@' + tinfo.acJID.domain, false)
            else //jid parsed to a domain. Assume the user meant this to be a node
                ti2 := TJabberID.Create(tmp_id.domain, tinfo.acJID.domain, tmp_id.resource);
            txtJid.Text := ti2.getDisplayJID();
            tmp_id.Free();
            tmp_id := ti2;
        end
        else begin
            if (not tmp_id.isValid) then //if its not valid, we could have an unparsable username (like user@)
                ti2 := TJabberID.Create(tmp_id.jid + '@foo', false)
            else //jid parsed to a domain. Assume the user meant this to be a node
                ti2 := TJabberID.Create(tmp_id.domain, 'foo', tmp_id.resource);
            tmp_id.Free();
            tmp_id := ti2;
        end;
    end;

    // add the nickname if it's not there.
    if (txtNickname.Text = '') then begin
        dnListener.UID := tmp_id.jid; //listen for changes to this jid only
        txtNickname.Text := TDisplayNameEventListener.getDisplayName(tmp_id.jid, pendingNameChange);
        if (pendingNameChange) then
            txtNickname.Font.Style := txtNickname.Font.Style + [fsUnderline]
        else
            txtNickname.Font.Style := txtNickname.Font.Style - [fsUnderline]
    end;

    tmp_id.Free();
end;

procedure TfrmAdd.txtNicknameChange(Sender: TObject);
begin
    txtNickname.Font.Style := txtNickname.Font.Style - [fsUnderline];
end;

{---------------------------------------}
procedure TfrmAdd.cboTypeChange(Sender: TObject);
var
    tinfo : TNetworkInfo;
begin
    tinfo := TNetworkInfo(cboType.Items.Objects[cboType.ItemIndex]);
    lblGateway.Enabled := not tInfo.isInNetwork();
    txtGateway.Enabled := not tInfo.isInNetwork();
end;

{---------------------------------------}
procedure TfrmAdd.doAdd;
var
    a: TJabberEntity;
    j: Widestring;
    i: integer;
begin
    // check to see if there is an agent for this type
    // of contact type
    if (AddInfo.isInNetwork()) then begin
         MainSession.roster.AddItem(sjid, snick, sgrp, true);
        Self.Close;
    end
    else begin
        a := gw_ent.getItemByFeature(WideLowercase(AddInfo.transFeat));
        if (a <> nil) then begin
            // we have this type of svc..
            j := '';
            for i := 1 to length(sjid) do begin
                if (sjid[i] = '@') then
                    j := j + '%'
                else
                    j := j + sjid[i];
            end;
            sjid := j + '@' + a.jid.full;
            ExRegController.MonitorJid(sjid, false);
              { TODO : Roster refactor }
            MainSession.Roster.AddItem(sjid, snick, sgrp, true);
            Self.Close;
        end
        else begin
            // we don't have this svc..
            MessageDlgW(_(sNoGatewayFound), mtError, [mbOK], 0);
            Self.Show();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmAdd.EntityCallback(event: string; tag: TXMLTag);
begin
    // we are getting some kind of entity info
    if ((event = '/session/entity/items') and
        (tag.GetAttribute('from') = gw)) then begin
        MainSession.UnRegisterCallback(cb);
        doAdd();
    end;
end;

procedure TfrmAdd.OnDisplayNameChange(bareJID: Widestring; displayName: WideString);
var
    selAll: boolean;
begin
    //woot
    if (fsUnderline in txtNickname.Font.Style) then begin
        selAll := txtNickname.SelLength = Length(txtNickname.Text);
        txtNickname.Font.Style := txtNickname.Font.Style - [fsUnderline];
        txtNickname.Text := displayName;
        if (selAll) then
            txtNickname.SelectAll();
    end;
end;


end.

