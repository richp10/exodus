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
unit RemoveContact;


interface

uses
    Unicode, 
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    buttonFrame, StdCtrls, ExtCtrls, TntStdCtrls, ExForm, TntForms, ExFrame;

type
  TfrmRemove = class(TExForm)
    frameButtons1: TframeButtons;
    optMove: TTntRadioButton;
    optRemove: TTntRadioButton;
    chkRemove1: TTntCheckBox;
    chkRemove2: TTntCheckBox;
    lblJid: TEdit;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure optRemoveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RosterItemRemove(temp_jid: WideString);
  private
    { Private declarations }
    jid: Widestring;
    jidList: TWideStringList;
    sel_grp: Widestring;
  public
    { Public declarations }
  end;

var
  frmRemove: TfrmRemove;

const
    sRemoveGrpLabel = 'Delete this contact from the %s group.';

procedure RemoveRosterItem(sjid: Widestring; grp: Widestring = '');
procedure RemoveRosterItems(items: TWideStringList; grp: WideString = '');
procedure QuietRemoveRosterItem(sjid: Widestring);

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    DisplayName,
    GnuGetText, JabberUtils, ExUtils,  JabberConst, S10n, ContactController, Session, XMLTag, JabberID;
{$R *.DFM}

{---------------------------------------}
procedure RemoveRosterItem(sjid: Widestring; grp: Widestring = '');
var
    f: TfrmRemove;
    //ritem: TJabberRosterItem;
    itemJID: TJabberID;
begin
    f := TfrmRemove.Create(Application);
    with f do begin
        itemJID := TJabberID.Create(sjid);
        lblJID.Text := DisplayName.getDisplayNameCache().getDisplayNameAndBareJID(itemJID);
        sel_grp := grp;
        jid := sjid;
        optMove.Caption := WideFormat(_(sRemoveGrpLabel), [grp]);
{ TODO : Roster refactor }
        //ritem := MainSession.Roster.Find(sjid);
        //optMove.Enabled := ((ritem <> nil) and (ritem.GroupCount > 1));
        itemJID.Free();
        Show;
    end;
end;

{---------------------------------------}
procedure RemoveRosterItems(items: TWideStringList; grp: WideString);
var
    f: TfrmRemove;
    itemJID: TJabberID;
    i: Integer;
begin
    f := TfrmRemove.Create(Application);

    with f do begin
        lblJID.Text := '';
        for i := 0 to items.Count - 1 do begin
         itemJID := TJabberID.Create(items[i]);
         lblJID.Text := lblJID.Text + DisplayName.getDisplayNameCache().getDisplayNameAndBareJID(itemJID) + ' ';
         itemJID.Free();
        end;
        sel_grp := grp;
        jidList := TWideStringList.Create();
        jidList := items;
        optMove.Caption := WideFormat(_(sRemoveGrpLabel), [grp]);
        optMove.Enabled := true;
        Show;
    end;
end;

{---------------------------------------}
procedure QuietRemoveRosterItem(sjid: Widestring);
var
    iq: TXMLTag;
begin
    // just send an iq-remove
    iq := TXMLTag.Create('iq');
    with iq do begin
        setAttribute('type', 'set');
        setAttribute('id', MainSession.generateID);
        with AddTag('query') do begin
            setAttribute('xmlns', XMLNS_ROSTER);
            with AddTag('item') do begin
                setAttribute('jid', sjid);
                setAttribute('subscription', 'remove');
            end;
        end;
    end;
    MainSession.SendTag(iq);
end;

{---------------------------------------}
procedure TfrmRemove.frameButtons1btnOKClick(Sender: TObject);
var
 i: integer;
begin
    if (jidList <> nil) then begin
      for i := 0 to jidList.Count - 1 do begin
        RosterItemRemove(jidList[i]);
      end;
    end
    else
      RosterItemRemove(jid);

    Self.Close;
end;

procedure TfrmRemove.RosterItemRemove(temp_jid: WideString);
//var
//    ritem: TJabberRosterItem;
begin
{ TODO : Roster refactor }
//    // Handle removing from a single grp
//    ritem := MainSession.roster.Find(temp_jid);
//    assert(ritem <> nil);
//
//    if (optMove.Checked) then begin
//        if ((ritem <> nil) and (ritem.IsInGroup(sel_grp))) then begin
//            ritem.DelGroup(sel_grp);
//            ritem.update();
//        end;
//    end
//
//    // Really remove or unsub
//    else if ((chkRemove1.Checked) and (chkRemove2.Checked)) then begin
//        // send a subscription='remove'
//        ritem.Remove();
//    end
//    else if chkRemove1.Checked then begin
//        // send an unsubscribe
//        SendUnSubscribe(ritem.Jid.full, MainSession);
//    end
//    else if chkRemove2.Checked then begin
//        // send an unsubscribed
//        SendUnSubscribed(ritem.jid.full, MainSession);
//    end;
end;

{---------------------------------------}
procedure TfrmRemove.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{---------------------------------------}
procedure TfrmRemove.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmRemove.optRemoveClick(Sender: TObject);
begin
    chkRemove1.Enabled := optRemove.Checked;
    chkRemove2.Enabled := optRemove.Checked;
end;

{---------------------------------------}
procedure TfrmRemove.FormCreate(Sender: TObject);
begin
    AssignUnicodeFont(Self);
    TranslateComponent(Self);
end;

end.
