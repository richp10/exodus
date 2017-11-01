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
unit Importer;


interface

uses
    Exodus_TLB,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ComCtrls;

type
  TfrmImport = class(TForm)
    Label1: TLabel;
    txtFilename: TEdit;
    ListView1: TListView;
    Label2: TLabel;
    txtGateway: TEdit;
    btnFileBrowse: TButton;
    Label3: TLabel;
    btnNext: TButton;
    btnCancel: TButton;
    OpenDialog1: TOpenDialog;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFileBrowseClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    _stage: integer;
    procedure validateGateway();
    procedure importFile();
    procedure addItems();
    function processName(name: string): string;
  public
    { Public declarations }
    _gjid: Widestring;
    exodus: IExodusController;
    procedure processAgents();
  end;

var
  frmImport: TfrmImport;

function getImportForm(controller: IExodusController; create: boolean): TfrmImport;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}

uses
    XMLUtils, StrUtils;

{---------------------------------------}
{---------------------------------------}
function getImportForm(controller: IExodusController; create: boolean): TfrmImport;
begin
    if (frmImport <> nil) then begin
        Result := frmImport;
        frmImport.Show();
        exit;
    end
    else if (create) then begin
        frmImport := TfrmImport.Create(nil);
        with frmImport do begin
            exodus := controller;
            txtGateway.Text := controller.Server;
        end;
        Result := frmImport;
        end
    else
        Result := nil;
end;

{---------------------------------------}
{---------------------------------------}
procedure TfrmImport.btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmImport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    frmImport := nil;
    Action := caFree;
end;

{---------------------------------------}
procedure TfrmImport.btnFileBrowseClick(Sender: TObject);
begin
    with OpenDialog1 do begin
        if (Execute) then begin
            txtFilename.Text := FileName;
        end;
    end;
end;

{---------------------------------------}
procedure TfrmImport.validateGateway();
begin
    // wait for the callback
    btnNext.Enabled := false;
    //exodus.getAgentList(txtGateway.Text);
end;

{---------------------------------------}
procedure TfrmImport.processAgents();
begin
    // make sure we have a AIM service
    btnNext.Enabled := true;
    _gjid := exodus.getAgentService(txtGateway.Text, 'aim');
    if (_gjid = '') then begin
        // not found!
        MessageDlg('The jabber server you entered does not have an AIM Gateway. Please select another server.',
            mtError, [mbOK], 0);
        _stage := 0;
        exit;
    end;
    MessageDlg('The AIM gateway has been found', mtInformation, [mbOK], 0);
    importFile();
end;

{---------------------------------------}
procedure TfrmImport.importFile();
var
    curi: string;
    jid, cur_grp, tmps, fn: String;
    itms, sl: TStringList;
    i, j, n: integer;
    li: TListItem;
begin
    // Import the list..
    fn := txtFilename.Text;
    if (FileExists(fn)) then begin
        sl := TStringlist.Create();
        sl.LoadFromFile(fn);
    end
    else begin
        MessageDlg('The file you specified does not exist.', mtError,
            [mbOK], 0);
        exit;
    end;

    if (sl.Count <= 0) then begin
        MessageDlg('The file you specified is empty.', mtError, [mbOK], 0);
        sl.Free();
        exit;
        end;

    // find the "list {" line...
    for i := 0 to sl.Count - 1 do begin
        if (AnsiContainsStr(sl[i], 'list {')) then begin
            // we hit the Buddy List.
            itms := TStringList.Create;
            j := i;
            repeat
                inc(j);
                if (j < sl.Count) then begin
                    tmps := Trim(sl[j]);
                    if (RightStr(tmps, 1) = '{') then begin
                        // new group
                        cur_grp := LeftStr(tmps, length(tmps) - 1);
                        repeat
                            inc(j);
                            if (j < sl.Count) then begin
                                tmps := Trim(sl[j]);
                                if (tmps <> '}') then begin
                                    li := ListView1.Items.Add();
                                    li.Caption := cur_grp;
                                    curi := processName(tmps);
                                    li.SubItems.Add(curi);
                                    jid := processName(curi) + '@' + _gjid;
                                    li.SubItems.Add(jid);
                                    li.Checked := true;
                                end;
                            end;
                        until ((tmps = '}') or (j >= sl.Count));
                        tmps := '';
                    end
                    else if (tmps <> '}') then begin
                        // this is a valid entry.
                        itms.Delimiter := ' ';
                        itms.DelimitedText := tmps;
                        if (itms.Count > 1) then begin
                            cur_grp := itms[0];
                            for n := 1 to itms.Count - 1 do begin
                                li := ListView1.Items.Add();
                                li.Caption := cur_grp;
                                curi := processName(itms[n]);
                                li.SubItems.Add(curi);
                                jid := processName(curi) + '@' + _gjid;
                                li.SubItems.Add(jid);
                                li.Checked := true;
                            end;
                        end;
                    end;
                end;
            until ((tmps = '}') or (j >= sl.Count));
            itms.Free();
            break;
        end;
    end;
    sl.Free();
    btnNext.Caption := 'Finish';
end;

{---------------------------------------}
function TfrmImport.processName(name: String): String;
var
    tmps: String;
    i: integer;
begin
    // xxx: do other validation here?
    tmps := TrimQuotes(name);
    i := Pos(' ', tmps);
    while (i > 0) do begin
        Delete(tmps, i, 1);
        i := Pos(' ', tmps);
    end;

    Result := tmps;
end;

{---------------------------------------}
procedure TfrmImport.addItems();
var
    li: TListItem;
    i: integer;
    r: IExodusRoster;
begin
    // Add each item to the roster.
    r := exodus.Roster;
    r._AddRef();
    for i := 0 to ListView1.Items.Count - 1 do begin
        li := ListView1.Items[i];

        // this sets up implicit registration for this transport.
        if (i = 0) then
            exodus.monitorImplicitRegJID(li.SubItems[1], false);
        r.Subscribe(li.SubItems[1], li.SubItems[0], li.Caption, true);
    end;
    r._Release();
end;

{---------------------------------------}
procedure TfrmImport.btnNextClick(Sender: TObject);
begin
    inc(_stage);
    if (_stage = 1) then
        validateGateway()
    else if (_stage = 2) then begin
        addItems();
        Self.Close();
    end;
end;

{---------------------------------------}
procedure TfrmImport.FormCreate(Sender: TObject);
begin
    _stage := 0;
end;

end.
