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
unit RegForm;


interface

uses
    IQ, XMLTag, fLeftLabel,
    Presence, Entity, Windows,
    Messages, SysUtils, Variants,
    Classes, Graphics, Controls,
    Forms, Dialogs, DockWizard,
    ComCtrls, ExtCtrls, StdCtrls,
    TntStdCtrls, TntExtCtrls, ToolWin;

type
    RegFormStage = (rsWelcome, rsForm, rsXData, rsRegister, rsFinish, rsDone);

type
  TfrmRegister = class(TfrmDockWizard)
    Label1: TTntLabel;
    lblIns: TTntLabel;
    TabSheet2: TTabSheet;
    formBox: TScrollBox;
    Panel2: TPanel;
    btnDelete: TTntButton;
    TabSheet3: TTabSheet;
    Label2: TTntLabel;
    TabSheet4: TTabSheet;
    lblOK: TTntLabel;
    lblBad: TTntLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    cur_iq: TJabberIQ;
    cur_stage: RegFormStage;
    cur_key: Widestring;
    pres_cb: integer;
    fld_cnt: integer;
    function doField(fld: string): TfrmField;
  published
    procedure GetCallback(event: string; tag: TXMLTag);
    procedure doRegister();
    procedure RegCallback(event: string; tag: TXMLTag);
    procedure PresCallback(event: string; tag: TXMLTag; pres: TJabberPres);
    procedure RemoveCallback(event: string; tag: TXMLTag);
  public
    jid: Widestring;
    entity: TJabberEntity;
    procedure Start();
  end;

{---------------------------------------}
const
    reg_Username = 0;
    reg_Password = 1;
    reg_Nick = 2;
    reg_Email = 3;
    reg_First = 4;
    reg_Last = 5;
    reg_Next = 6;
    reg_Prev = 7;
    reg_Misc = 8;
    reg_URL = 9;

const
    sBtnFinish = 'Finish';
    sBtnCancel = 'Cancel';
    sServiceRegTitle = 'Jabber Service Registration';
    sServiceRegDetails = 'This wizard will guide you through registration with a jabber service.';
    sServiceRegError = 'The agent you are trying to register with returned an error.';
    sServiceRegTimeout = 'The agent you are trying to register with can not be reached.';
    sServiceRegRemoveError = 'There was an error trying to remove your registration.';
    sServiceRegRemoveOK = 'Your registration has been removed.';

var
  frmRegister: TfrmRegister;

procedure StartServiceReg(jid: Widestring);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
{$R *.DFM}
uses
    EntityCache, fGeneric,
    GnuGetText, Math, JabberConst,
    Transports, S10n, 
    Session, JabberUtils, ExUtils,
    Jabber1, Room, PrefController,
    RosterImages;

{---------------------------------------}
procedure StartServiceReg(jid: Widestring);
var
    regform: TfrmRegister;
begin
    regform := TfrmRegister.Create(Application);
    regform.jid := jid;
    regform.Start();
    
end;

{---------------------------------------}
procedure TfrmRegister.FormCreate(Sender: TObject);
begin
    inherited;
    TranslateComponent(Self);

    // Hide all the tabs and make the welcome tab visible
    TabSheet1.TabVisible := false;
    TabSheet2.TabVisible := false;
    TabSheet3.TabVisible := false;
    TabSheet4.TabVisible := false;

    lblWizardTitle.Caption := _(sServiceRegTitle);
    lblWizardDetails.Caption := _(sServiceRegDetails);
    MainSession.Prefs.setInt(P_TAB_WIDTH, Self.Width);
    MainSession.FireEvent('/session/prefs', nil);
    cur_stage := rsWelcome;
    Tabs.ActivePage := TabSheet1;
    cur_iq := nil;
    cur_key := '';
    pres_cb := -1;
    entity := nil;
    Image1.Picture.Icon.Handle := Application.Icon.Handle;

    Self.ImageIndex := RosterImages.RI_PREFS_INDEX;

    _windowType := 'registration';
end;

{---------------------------------------}
procedure TfrmRegister.Start();
begin
    // start the whole process off
    btnBack.Enabled := false;
    btnNext.Enabled := false;
    btnCancel.Enabled := true;
    entity := jEntityCache.getByJid(Self.jid);    
    Self.ShowDefault();
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), GetCallback, 30);
    with cur_iq do begin
        toJid := self.jid;
        iqType := 'get';
        Namespace := XMLNS_REGISTER;
        Send();
    end;
end;

{---------------------------------------}
procedure TfrmRegister.GetCallback(event: string; tag: TXMLTag);
var
    i: integer;
    m: integer;
    x, f, ag_tag: TXMLTag;
    flds: TXMLTagList;
    cur_fld: TfrmField;
    frm: TframeGeneric;
    c: TControl;
    ftype: WideString;
begin
    // we got back a response to the iq-get, on the register namespace
    cur_iq := nil;
    if (event = 'xml') then begin
        if (tag.GetAttribute('type') = 'error') then begin
            // error packet
            MessageDlgW(_(sServiceRegError), mtError, [mbOK], 0);
            Self.Close();
            exit;
        end
        else begin
            // normal result
            AssignDefaultFont(TabSheet2.Font);
            btnDelete.Enabled := false;
            ag_tag := tag.QueryXPTag('/iq/query');

            if (ag_tag = nil) then begin
                // this is bad.. we didn't get back a query?
                MessageDlgW(_(sServiceRegError), mtError, [mbOK], 0);
                Self.Close();
                exit;
            end;

            // always check for registered
            if (ag_tag.GetFirstTag('registered') <> nil) then
                btnDelete.Enabled := true;

            // check for x-data form
            x := tag.QueryXPTag('/iq/query/x[@xmlns="' + XMLNS_XDATA + '"]');
            if (x <> nil) then begin
                m := 0;
                f := x.GetFirstTag('instructions');
                if (f <> nil) then
                    lblIns.Caption := f.Data();

                f := x.GetFirstTag('title');
                if (f <> nil) then
                    Self.Caption := f.Data();

                ftype := x.GetAttribute('type');
                flds := x.QueryTags('field');
                for i := flds.count - 1 downto 0 do begin
                    frm := TframeGeneric.Create(Self);
                    frm.FormType := ftype;
                    frm.Name := 'xDataFrame' + IntToStr(i);
                    frm.Parent := formBox;
                    frm.Visible := true;
                    frm.render(flds[i]);
                    frm.Align := alTop;
                    frm.TabOrder := 0;
                    m := max(m, frm.getLabelWidth());
                end;
                flds.Free();

                for i := 0 to Self.formBox.ControlCount - 1 do begin
                    c := Self.formBox.Controls[i];
                    if (c is TframeGeneric) then begin
                        TframeGeneric(c).setLabelWidth(m + 20);
                        TframeGeneric(c).Repaint();
                    end;
                end;
                cur_stage := rsXData;
            end

            else begin
                // Normal non-xdata reg form
                flds := ag_tag.ChildTags();
                fld_cnt := 0;
                for i := 0 to flds.count - 1 do begin
                    f := flds[i];
                    if (f.Name = 'instructions') then
                        lblIns.Caption := f.Data

                    else if (f.Name = 'key') then
                        cur_key := f.Data

                    else if ((f.Name = 'x') and (f.GetAttribute('xmlns') = XMLNS_XDATA)) then
                        // ignore x-data fields here

                    else if (f.Name = 'registered') then begin
                        // ignore registered elements
                        btnDelete.Enabled := true;
                        end

                    else begin
                        cur_fld := doField(f.Name);
                        if (f.Data <> '') then
                            cur_fld.txtData.Text := f.Data;
                    end;
                end;
                flds.Free();
                cur_stage := rsForm;
            end;

            btnCancel.Default := false;
            btnNext.Enabled := true;
            btnNext.Default := true;
        end;
    end
    else begin
        // timeout on entity query
        MessageDlgW(_(sServiceRegTimeout), mtError, [mbOK], 0);
        Self.Close();
        exit;
    end;
end;

{---------------------------------------}
function TfrmRegister.doField(fld: string): TfrmField;
var
    frm: TfrmField;
begin
    // create a new panel and input area for a field
    frm := TfrmField.Create(formBox);
    with frm do begin
        Parent := formBox;
        fld_cnt := fld_cnt + 1;
        Name := 'fld_' + fld + IntToStr(fld_cnt);
        lblPrompt.Caption := fld;
        if Lowercase(fld) = 'password' then
            txtData.PasswordChar := '*';
        Align := alTop;
        Visible := true;
        field := fld;
        AssignDefaultFont(txtData.Font);
        AssignDefaultFont(lblPrompt.Font);
        Height := txtData.Height + 3;
    end;
    Result := frm;
end;

{---------------------------------------}
procedure TfrmRegister.doRegister();
var
    i: integer;
    frm: TfrmField;
    frmx: TframeGeneric;
    fx, xdata, t: TXMLTag;
    n,v: Widestring;
begin
    // send the iq-set
    // get pres packets
    pres_cb := MainSession.RegisterCallback(PresCallback);
    cur_iq := TJabberIQ.Create(MainSession, MainSession.generateID(), RegCallback, 30);
    cur_iq.iqType := 'set';
    cur_iq.toJID := self.jid;
    cur_iq.Namespace := XMLNS_REGISTER;

    xdata := nil;

    for i := 0 to formBox.ControlCount - 1 do begin
        if (formBox.Controls[i] is TfrmField) then begin
            // non x-data field
            frm := TfrmField(formBox.Controls[i]);
            with frm do begin
                n := lblPrompt.Caption;
                v := txtData.Text;

                if ((lowercase(n) = 'password') and (Trim(v) = '')) then begin
                    // don't add a password element in..
                end
                else
                    cur_iq.qTag.AddBasicTag(n, v);
            end;
        end
        else if (formBox.Controls[i] is TframeGeneric) then begin
            // this is an x-data field
            frmx := TframeGeneric(formBox.Controls[i]);
            if (xdata = nil) then begin
                xdata := cur_iq.qTag.AddTag('x');
                xdata.setAttribute('xmlns', XMLNS_XDATA);
                xdata.setAttribute('type', 'submit');
            end;

            fx := frmx.getXML();
            if (fx <> nil) then xdata.AddTag(fx);
        end;
    end;

    if (cur_key <> '') then
        cur_iq.qTag.AddBasicTag('key', cur_key);

    cur_stage := rsRegister;

    t := TXMLTag.Create('transport');
    t.setAttribute('jid', cur_iq.toJid);
    if (entity <> nil) then
        t.setAttribute('name', entity.name);
    MainSession.FireEvent('/session/transport', t);
    t.Free;

    cur_iq.Send();
end;

{---------------------------------------}
procedure TfrmRegister.PresCallback(event: string; tag: TXMLTag; pres: TJabberPres);
var
//    i: integer;
//    ritem: TJabberRosterItem;
    tmps: Widestring;
begin
    // getting some pres packet
    if (event <> 'xml') then begin
        // something bad happened
    end
    else if (pres.fromJID.jid = self.jid) then begin
        MainSession.UnRegisterCallback(pres_cb);
        pres_cb := -1;
        if (pres.PresType = 'error') then begin
            // some kind of error
        end
        else if (pres.PresType = 'unavailable') then begin
            // bad registration
        end
        else if (pres.isSubscription) then begin
            // this is the service subscribing to us..
            // The s10n.pas handler will catch this, but we want to put a
            // better name on the roster item, and add it to the Transports grp.
            if (entity <> nil) then
                tmps := entity.name;
            if (tmps = '') then
                tmps := pres.fromJid.domain;
    { TODO : Roster refactor }
//            MainSession.roster.AddItem(pres.fromJID.full, tmps,
//                MainSession.Prefs.getString('roster_transport_grp'), false);
        end
        else begin
{ TODO : Roster refactor }        
            // ok registration, check all pendings and re-subscribe to them
//            with MainSession do begin
//                for i := 0 to roster.Count - 1 do begin
//                    ritem := TJabberRosterItem(Roster.Objects[i]);
//                    if ((ritem <> nil) and
//                        (ritem.ask = 'subscribe') and
//                        (ritem.jid.domain = self.jid)) then begin
//                        SendSubscribe(ritem.jid.jid, MainSession);
//                    end;
//                end;
//            end;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmRegister.RegCallback(event: string; tag: TXMLTag);
begin
    // We are getting a result from our iq-set
    cur_iq := nil;
    Tabs.ActivePage := TabSheet4;
    if ((event = 'xml') and (tag.getAttribute('type') = 'result')) then begin
        // normal result
        lblOK.Visible := true;
        lblBad.Visible := false;
        btnBack.Enabled := false;
        btnNext.Caption := _(sBtnFinish);
        btnNext.Enabled := true;
        btnNext.Default := true;
        btnCancel.Enabled := false;
    end
    else begin
        // some kind of error
        lblOK.Visible := false;
        lblBad.Visible := true;
        btnBack.Enabled := true;
        btnNext.Enabled := false;
        btnCancel.Enabled := true;
    end;
    cur_stage := rsFinish;
end;

{---------------------------------------}
procedure TfrmRegister.btnNextClick(Sender: TObject);
begin
    // goto the next tab
    if (Tabs.ActivePage = TabSheet1) then begin
        Tabs.ActivePage := TabSheet2;
        btnBack.Enabled := true;
        end

    else if (Tabs.ActivePage = TabSheet2) then begin
        // do the actual registration
        Tabs.ActivePage := TabSheet3;
        doRegister();
        btnNext.Enabled := false;
        btnBack.Enabled := false;
    end

    else if (tabs.ActivePage = TabSheet4) then begin
        if (Self.entity <> nil) then
          if (Self.entity.Category = 'conference') then
            StartRoom(Self.jid, '', '', True, False, True);
        Self.Close();    
    end;
end;

{---------------------------------------}
procedure TfrmRegister.btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRegister.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    if (cur_iq <> nil) then
        cur_iq.Free;

    if ((pres_cb <> -1) and (MainSession <> nil)) then
        MainSession.UnRegisterCallback(pres_cb);

    Action := caFree;
end;

procedure TfrmRegister.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;

end;

{---------------------------------------}
procedure TfrmRegister.RemoveCallback(event: string; tag: TXMLTag);
begin
    if (event = 'timeout') then begin
        MessageDlgW(_(sServiceRegTimeout), mtError, [mbOK], 0);
    end
    else begin
        if (tag.getAttribute('type') = 'error') then begin
            MessageDlgW(_(sServiceRegRemoveError), mtError,
                [mbOK], 0);
        end
        else begin
            MessageDlgW(_(sServiceRegRemoveOK), mtInformation, [mbOK], 0);
        end;
    end;
    self.close();
    exit;
end;

{---------------------------------------}
procedure TfrmRegister.btnDeleteClick(Sender: TObject);
begin
    RemoveTransport(jid);
    Self.Close();
end;

{---------------------------------------}
procedure TfrmRegister.btnPrevClick(Sender: TObject);
begin
    // previous page
    if (Tabs.ActivePage = TabSheet4) then
        Tabs.ActivePage := TabSheet2
    else if (Tabs.ActivePage = TabSheet2) then
        Tabs.ActivePage := TabSheet1;

    btnNext.Enabled := true;
    btnBack.Enabled := (Tabs.ActivePage <> TabSheet1);
end;

end.
