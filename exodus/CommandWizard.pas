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
unit CommandWizard;


interface

uses
    XMLTag, IQ, 
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Wizard, StdCtrls, TntStdCtrls, ComCtrls, ExtCtrls, TntExtCtrls,
  fXData, ExodusLabel;

type

  TCommandWizardState = (
    cwzJid, cwzSupport, cwzList,
    cwzSelect, cwzExecute, cwzSubmit, cwzResults);

  TfrmCommandWizard = class(TfrmWizard)
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    txtJid: TTntComboBox;
    tbsSelect: TTabSheet;
    TntLabel3: TTntLabel;
    TntLabel4: TTntLabel;
    txtCommand: TTntComboBox;
    tbsExecute: TTabSheet;
    tbsResults: TTabSheet;
    tbsWait: TTabSheet;
    lblWait: TTntLabel;
    xDataBox: TframeXData;
    btnFinish: TTntButton;
    lblNote: TExodusLabel;
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFinishClick(Sender: TObject);
  private
    { Private declarations }
    _session_id: Widestring;
    _entity_cb: integer;
    _iq: TJabberIQ;

    procedure fail(msg: Widestring);
    procedure Wait();
    procedure nextBack();
    procedure nextNoBack();
    procedure execCallback(event: string; tag: TXMLTag);
    procedure createIQSet();

  published
    procedure EntityCallback(event: string; tag: TXMLTag);
  public
    { Public declarations }
    jid: Widestring;
    state: TCommandWizardState;

    procedure RunState();
  end;


var
  frmCommandWizard: TfrmCommandWizard;

procedure StartCommandWizard(jid: Widestring);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    fResults, fGeneric, xdata, JabberUtils,
    GnuGetText, JabberConst, Session, Entity, EntityCache;

const CMD_TIMEOUT = 90;

{---------------------------------------}
procedure StartCommandWizard(jid: Widestring);
var
    f: TfrmCommandWizard;
begin
    Application.CreateForm(TfrmCommandWizard, f);
    jEntityCache.getByFeature(XMLNS_COMMANDS, f.txtJid.Items);

    if (jid = '') then begin
        f.jid := '';
        f.state := cwzJid;
        f.txtJid.Text := '';
    end
    else begin
        f.jid := jid;
        f.state := cwzSupport;
    end;

    f.Show();
    f.RunState();
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TfrmCommandWizard.btnNextClick(Sender: TObject);
begin
  inherited;
    // check our current state and do something
    case state of
    cwzJid: begin
        jid := txtJid.Text;
        state := cwzSupport;
        RunState();
        end;
    cwzSelect: begin
        state := cwzExecute;
        RunState();
        end;
    cwzExecute: begin
        state := cwzSubmit;
        RunState();
        end;
    cwzSubmit: begin
        RunState();
        end;
    cwzResults: begin
        // do nothing
        end;
    end;
end;

{---------------------------------------}
procedure TfrmCommandWizard.btnBackClick(Sender: TObject);
begin
    case state of
    cwzJid: begin
        exit;
        end;
    cwzSelect: begin
        state := cwzJid;
        RunState();
        end;
    cwzExecute: begin
        state := cwzSelect;
        RunState();
        end;
    cwzSubmit: begin
        // submit a "prev" action
        createIQSet();
        _iq.qTag.setAttribute('action', 'prev');
        _iq.Send();
        end;
    cwzResults: begin
        exit;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmCommandWizard.btnCancelClick(Sender: TObject);
var
    e: TJabberEntity;
    ciq, c: TXMLTag;
begin
    if ((state = cwzExecute) or (state = cwzSubmit)) then begin
        if ((Mainsession <> nil) and (MainSession.Active)) then begin
            ciq := TXMLTag.Create('iq');
            ciq.setAttribute('type', 'set');
            ciq.setAttribute('to', jid);
            c := ciq.AddTag('command');
            c.setAttribute('xmlns', XMLNS_COMMANDS);
            if (_session_id <> '') then
                c.setAttribute('sessionid', _session_id);

            // the entity stuff is cache'd
            e := TJabberEntity(txtCommand.Items.Objects[txtCommand.ItemIndex]);
            if (e.Node <> '') then
                c.setAttribute('node', e.Node);
            c.setAttribute('action', 'cancel');
            MainSession.SendTag(ciq);
        end;
    end;

    if (_iq <> nil) then
        _iq.Free();
    xDataBox.Clear();

    inherited;

    Self.Close();
end;

{---------------------------------------}
procedure TfrmCommandWizard.createIQSet();
var
    e: TJabberEntity;
begin
    assert(_iq = nil);
    _iq := TJabberIQ.Create(MainSession, MainSession.generateID(),
        Self.execCallback, CMD_TIMEOUT);
    _iq.qTag.Name := 'command';
    _iq.Namespace := XMLNS_COMMANDS;

    e := TJabberEntity(txtCommand.Items.Objects[txtCommand.ItemIndex]);
    _iq.toJid := e.Jid.full;
    _iq.iqType := 'set';
    _iq.qTag.setAttribute('xmlns', XMLNS_COMMANDS);
    _iq.qTag.setAttribute('action', 'execute');
    _iq.qTag.setAttribute('node', e.Node);
    if (_session_id <> '') then
        _iq.qTag.setAttribute('sessionid', _session_id);
end;

{---------------------------------------}
procedure TfrmCommandWizard.Wait();
begin
    Tabs.ActivePage := tbsWait;
    lblWait.Caption := _('Please wait...');
    btnBack.Enabled := false;
    btnNext.Enabled := false;
    btnCancel.Enabled := true;
    btnFinish.Enabled := false;
end;

{---------------------------------------}
procedure TfrmCommandWizard.RunState();
var
    x: TXMLTag;
begin
    // run this state
    {
    cwzJid, cwzSupport, cwzList,
    cwzSelect, cwzExecute, cwzResults);
    }
    case state of
    cwzJid: begin
        Tabs.ActivePage := TabSheet1;
        nextNoBack();
        end;
    cwzSupport: begin
        wait();
        jEntityCache.discoInfo(jid, MainSession);
        end;
    cwzList: begin
        wait();
        jEntityCache.discoItems(jid, MainSession, XMLNS_COMMANDS);
        end;
    cwzSelect: begin
        Tabs.ActivePage := tbsSelect;
        nextBack();
        end;
    cwzExecute: begin
        createIQSet();
        wait();
        _iq.Send();
        end;
    cwzSubmit: begin
        // submit this x-data form.
        try
            createIQSet();
            x := xdataBox.submit();
        except
            on EXDataValidationError do begin
                _iq.Free();
                MessageDlgW(_('All required fields must be filled out.'),
                    mtError, [mbOK], 0);
                exit;
            end;
        end;
        wait();
        _iq.qTag.AddTag(x);
        _iq.Send();
        end;
    end;
end;

{---------------------------------------}
procedure TfrmCommandWizard.execCallback(event: string; tag: TXMLTag);
var
    msg: Widestring;
    x, c, n: TXMLTag;
begin
    _iq := nil;
    if (event <> 'xml') then begin
        fail(_('The jabber entity timed out trying to execute the command.'));
        exit;
    end;

    msg := '';
    c := tag.GetFirstTag('command');

    if (c = nil) then begin
        msg := _('The result of the command execute was mal-formed.') + ' ' + msg;
        fail(msg);
        exit;
    end;

    n := c.GetFirstTag('note');
    if (n <> nil) then
        msg := n.Data;

    if (tag.getAttribute('type') <> 'result') then begin
        msg := _('The execute query returned an error.') + ' ' + msg;
        fail(msg);
        exit;
    end;

    if (c.GetAttribute('status') = 'completed') then begin
        // we're done..
        state := cwzResults;
        x := c.QueryXPTag('/command/x[@xmlns="jabber:x:data"][@type="result"]');

        if ((n = nil) and (x = nil)) then begin
            lblNote.Visible := true;
            lblNote.Caption := _('Your command executed successfully.');
        end
        else if (n <> nil) then begin
            lblNote.Visible := true;
            lblNote.Caption := Uppercase(n.GetAttribute('type')) + ': ' + n.Data;
        end
        else if (x <> nil) then begin
            // process x-data results
            buildXDataResults(x, tbsResults);
        end;

        Tabs.ActivePage := tbsResults;
        btnBack.Enabled := false;
        btnNext.Enabled := false;
        btnFinish.Enabled := true;
        btnCancel.Enabled := false;
    end
    else begin
        // we're not done yet
        // Make sure xdataBox is empty.
        xDataBox.Clear();
        state := cwzSubmit;
        _session_id := c.GetAttribute('sessionid');
        x := c.QueryXPTag('/command/x[@xmlns="jabber:x:data"]');
        if (x = nil) then begin
            fail(_('This command returned an unknown form type.'));
            exit;
        end;
        xDataBox.Render(x);
        Tabs.ActivePage := tbsExecute;
        nextNoBack();

        btnNext.Enabled := true;
        btnCancel.Enabled := true;
        btnBack.Enabled := (c.QueryXPTag('/command/actions/prev') <> nil);
        btnFinish.Enabled := (c.QueryXPTag('/command/actions/complete') <> nil);
    end;

end;

{---------------------------------------}
procedure TfrmCommandWizard.FormCreate(Sender: TObject);
begin
  inherited;
    //
    _entity_cb := MainSession.RegisterCallback(Self.EntityCallback,
        '/session/entity');

    _session_id := '';
    TabSheet1.TabVisible := false;
    tbsSelect.TabVisible := false;
    tbsExecute.TabVisible := false;
    tbsResults.TabVisible := false;
    tbsWait.TabVisible := false;
    Tabs.ActivePage := TabSheet1;
    
end;

{---------------------------------------}
procedure TfrmCommandWizard.EntityCallback(event: string; tag: TXMLTag);
var
    tmps: Widestring;
    c, e: TJabberEntity;
    i: integer;
begin
    // we got some info for an entity.
    if (event = 'timeout') or (tag = nil) then begin
        // XXX: handle timeouts
        exit;
    end;

    tmps := tag.getAttribute('from');
    if (tmps <> jid) then exit;

    if ((event = '/session/entity/info') and
        (state = cwzSupport)) then begin
        e := jEntityCache.getByJid(tmps);
        if (not e.hasFeature(XMLNS_COMMANDS)) then begin
            fail(_('This jabber entity does not support remote commands.'));
            exit;
        end;
        state := cwzList;
        RunState();
    end
    else if ((event = '/session/entity/items') and
             (state = cwzList)) then begin
        // we got the list of commands back
        txtCommand.Items.Clear();
        e := jEntityCache.getByJid(jid, XMLNS_COMMANDS);
        for i := 0 to e.ItemCount - 1 do begin
            c := e.Items[i];
            txtCommand.Items.AddObject(c.Name, c);
        end;
        state := cwzSelect;
        RunState();
    end;
    
end;

{---------------------------------------}
procedure TfrmCommandWizard.fail(msg: Widestring);
begin
    lblWait.Caption := msg;
    btnBack.Enabled := false;
    btnNext.Enabled := false;
    btnCancel.Enabled := true;
    Tabs.ActivePage := tbsWait;
end;

{---------------------------------------}
procedure TfrmCommandWizard.nextBack();
begin
    btnBack.Enabled := true;
    btnNext.Enabled := true;
    btnCancel.Enabled := true;
    btnFinish.Enabled := false;
end;

{---------------------------------------}
procedure TfrmCommandWizard.nextNoBack();
begin
    btnBack.Enabled := false;
    btnNext.Enabled := true;
    btnCancel.Enabled := true;
    btnFInish.Enabled := false;
end;

{---------------------------------------}
procedure TfrmCommandWizard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
    if (MainSession <> nil) then
        MainSession.UnRegisterCallback(_entity_cb);
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmCommandWizard.btnFinishClick(Sender: TObject);
var
    x: TxMLTag;
begin
  inherited;
    // send iq-set action="completed"
    if (state = cwzResults) then begin
        Self.Close();
        exit;
    end
    else if (state = cwzSubmit) then begin
        // like submit, but finish it now
        try
            createIQSet();
            _iq.qTag.setAttribute('action', 'completed');
            x := xdataBox.submit();
        except
            on EXDataValidationError do begin
                _iq.Free();
                MessageDlgW(_('All required fields must be filled out.'),
                    mtError, [mbOK], 0);
                exit;
            end;
        end;
        wait();
        _iq.qTag.AddTag(x);
        _iq.Send();
    end;
end;

end.
