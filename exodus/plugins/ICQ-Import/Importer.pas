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
    Exodus_TLB, ICQWorks,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ComCtrls, ICQDb, ExtCtrls;

type
  TfrmImport = class(TForm)
    Label1: TLabel;
    ListView1: TListView;
    Label2: TLabel;
    txtGateway: TEdit;
    btnFileBrowse: TButton;
    Label3: TLabel;
    btnNext: TButton;
    btnCancel: TButton;
    OpenDialog1: TOpenDialog;
    icqDB: TICQDb;
    txtFilename: TComboBox;
    optFormat: TRadioGroup;
    ProgressBar1: TProgressBar;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFileBrowseClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure icqDBContactFound(Sender: TObject; UIN: Cardinal; NickName,
      FirstName, LastName, Email: String; Age, Gender: Byte;
      LastUpdate: String; LastUpdateStamp: Cardinal);
    procedure icqDBParsingFinished(Sender: TObject);
    procedure txtFilenameChange(Sender: TObject);
    procedure icqDBError(Sender: TObject; Reason: Word);
    procedure icqDBProgress(Sender: TObject; Progress: Byte);
  private
    { Private declarations }
    _formats: Array of Integer;
    _stage: integer;
    procedure validateGateway();
    procedure importFile();
    procedure addItems();

  public
    { Public declarations }
    _gjid: Widestring;
    exodus: IExodusController;
    procedure processAgents();
  end;

var
  frmImport: TfrmImport;

function getImportForm(controller: IExodusController; create: boolean): TfrmImport;

{-----------------------------------------}
{-----------------------------------------}
{-----------------------------------------}
implementation

{$R *.dfm}

uses
    icqUtils, StrUtils;

{-----------------------------------------}
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

{-----------------------------------------}
procedure TfrmImport.btnCancelClick(Sender: TObject);
begin
    Self.Close;
end;

{-----------------------------------------}
procedure TfrmImport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    frmImport := nil;
    Action := caFree;
end;

{-----------------------------------------}
procedure TfrmImport.btnFileBrowseClick(Sender: TObject);
begin
    with OpenDialog1 do begin
        if (Execute) then begin
            txtFilename.Text := FileName;
        end;
    end;
end;

{-----------------------------------------}
procedure TfrmImport.validateGateway();
begin
    // wait for the callback
    btnNext.Enabled := false;
    exodus.getAgentList(txtGateway.Text);
end;

{-----------------------------------------}
procedure TfrmImport.processAgents();
begin
    // make sure we have a ICQ service
    btnNext.Enabled := true;
    _gjid := exodus.getAgentService(txtGateway.Text, 'aim');
    if (_gjid = '') then begin
        // not found!
        MessageDlg('The jabber server you entered does not have an ICQ Gateway. Please select another server.',
            mtError, [mbOK], 0);
        _stage := 0;
        exit;
    end;
    importFile();
end;

{-----------------------------------------}
procedure TfrmImport.importFile();
var
    f: integer;
    tmps, fn: String;
begin
    // Import the list..
    tmps := txtFilename.Text;
    fn := ChangeFileExt(tmps, '');

    // Use the icqDB Component
    f := optFormat.ItemIndex;
    if (f = 0) then begin
        icqDB.DbType := DB_ICQ;
        icqDB.DatFile := fn + '.dat';
        icqDB.IdxFile := fn + '.idx';
    end
    else if (f = 1) then begin
        icqDB.DBType := DB_MIRANDA;
        icqDB.DatFile := fn + '.dat';
    end;

    if (not FileExists(icqDB.DatFile)) then begin
        MessageDlg('The DAT file you specified does not exist.',
            mtError, [mbOK], 0);
        exit;
    end;

    btnNext.Enabled := false;
    icqDB.StartParsing();
end;

{-----------------------------------------}
procedure TfrmImport.addItems();
var
    li: TListItem;
    i: integer;
    r: IExodusRoster;
begin
    // Add each item to the roster.
    r := exodus.roster;
    r._AddRef();
    for i := 0 to ListView1.Items.Count - 1 do begin
        li := ListView1.Items[i];
        if (li.Checked) then begin
            // this sets up implicit registration for this transport.
            if (i = 0) then
                exodus.monitorImplicitRegJID(li.SubItems[0], false);
            r.Subscribe(li.SubItems[0], li.Caption, 'ICQ Contacts', true);
        end;
    end;
    r._Release();
end;

{-----------------------------------------}
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

{-----------------------------------------}
procedure TfrmImport.FormCreate(Sender: TObject);
var
    dbs: TStringlist;
    f, i: integer;
begin
    _stage := 0;
    dbs := findICQDatabases();

    txtFilename.Items.Clear();
    if (dbs <> nil) then begin
        setLength(_formats, dbs.count);
        for i := 0 to dbs.count - 1 do begin
            f := integer(dbs.Objects[i]);
            txtFilename.Items.Add(dbs[i]);
            _formats[i] := f;
        end;

        if (txtFilename.Items.Count > 0) then begin
            txtFilename.ItemIndex := 0;
            txtFilenameChange(Self);
        end;
    end;
    
end;

{-----------------------------------------}
procedure TfrmImport.icqDBContactFound(Sender: TObject; UIN: Cardinal;
  NickName, FirstName, LastName, Email: String; Age, Gender: Byte;
  LastUpdate: String; LastUpdateStamp: Cardinal);
var
    li: TListItem;
    jid: Widestring;
begin
    // Add the UIN to the Listview
    li := ListView1.Items.Add();
    li.Caption := NickName;
    jid := IntToStr(UIN) + '@' + _gjid;
    li.SubItems.Add(jid);
    li.Checked := true;
end;

{-----------------------------------------}
procedure TfrmImport.icqDBParsingFinished(Sender: TObject);
begin
    btnNext.Enabled := true;
end;

{-----------------------------------------}
procedure TfrmImport.txtFilenameChange(Sender: TObject);
begin
    if txtFilename.ItemIndex < 0 then begin
        if (not optFormat.Enabled) then
            optFormat.Enabled := true;
        exit;
    end

    else begin
        // pull the format out.
        optFormat.ItemIndex := _formats[txtFilename.ItemIndex] - 1;
        optFormat.Enabled := false;
    end;
end;

{-----------------------------------------}
procedure TfrmImport.icqDBError(Sender: TObject; Reason: Word);
begin
    // bah, error
    MessageDlg('An import error occurred: ' + DbErrorToStr(Reason), mtError, [mbOK], 0);
    _stage := 0;
    btnNext.Enabled := true;
end;

{-----------------------------------------}
procedure TfrmImport.icqDBProgress(Sender: TObject; Progress: Byte);
begin
    // show progress
    ProgressBar1.Position := Progress;
end;

end.
