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
unit Import;


interface

uses
    XMLParser, Unicode, Exodus_TLB,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, buttonFrame, StdCtrls, CheckLst, TntCheckLst,
    TntComCtrls;

type
  TfrmImport = class(TForm)
    OpenDialog1: TOpenDialog;
    frameButtons1: TframeButtons;
    ListView1: TTntListView;
    SaveDialog1: TSaveDialog;
    procedure frameButtons1btnOKClick(Sender: TObject);
    procedure frameButtons1btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    _exodus: IExodusController;
  public
    { Public declarations }
    procedure ImportFile(exodus: IExodusController; filename: String);
  end;

var
  frmImport: TfrmImport;

implementation
{$R *.dfm}
uses
    XMLTag;

procedure TfrmImport.ImportFile(exodus: IExodusController; filename: string);
var
    parser: TXMLTagParser;
    sl: TWidestringlist;
    doc, grp: TXMLTag;
    items: TXMLTagList;
    i: integer;
    li: TTntListItem;
begin
    //
    _exodus := exodus;
    parser := TXMLTagParser.Create();
    sl := TWidestringlist.Create();
    sl.LoadFromFile(filename);
    doc := nil;
    items := nil;

    try
        parser.ParseString(sl.Text, '');
        if (parser.Count <= 0) then begin
            MessageDlg('Could not parse the xml roster file: ' + filename,
                mtError, [mbOK], 0);
            Self.Close();
            exit;
        end;

        doc := parser.popTag();

        items := doc.QueryTags('item');
        if (items.Count = 0) then begin
            MessageDlg('No items were found in this file.', mtError, [mbOK], 0);
            Self.Close();
            exit;
        end;

        for i := 0 to items.Count - 1 do begin
            grp := items[i].GetFirstTag('group');
            li := ListView1.Items.Add();
            li.Caption := items[i].GetAttribute('name');
            if (grp <> nil) then
                li.SubItems.Add(grp.Data)
            else
                li.SubItems.Add('');
            li.SubItems.Add(items[i].GetAttribute('jid'));
        end;

        Self.ShowModal();

        Self.Close();

    finally
        items.Free();
        doc.Free();
        sl.Free();
        parser.Free();
    end;
end;


procedure TfrmImport.frameButtons1btnOKClick(Sender: TObject);
var
    r: IExodusRoster;
    ri: IExodusRosterItem;

    i: integer;
    jid, grp, name: Widestring;
begin
    // Process
    if (MessageDlg('Send subscription requests to all of the selected contacts?',
        mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;

    r := _exodus.Roster;
    for i := 0 to ListView1.Items.Count - 1 do begin
        if (not ListView1.Items[i].Checked) then continue;
        name := ListView1.Items[i].Caption;
        grp := ListView1.Items[i].SubItems[0];
        jid := ListView1.Items[i].SubItems[1];
        ri := r.Find(jid);
        if (ri <> nil) then begin
            if ((ri.Subscription = 'to') or (ri.Subscription = 'both')) then
                continue;
        end;
        r.Subscribe(jid, name, grp, true);
    end;

end;

procedure TfrmImport.frameButtons1btnCancelClick(Sender: TObject);
begin
    Self.Close();
end;

procedure TfrmImport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

end.
