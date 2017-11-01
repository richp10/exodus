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
unit SelectItem;



interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, ComCtrls, ExForm,
  Forms, ExTreeView, Exodus_TLB, Dialogs, ExtCtrls, StdCtrls, TntStdCtrls,
  Menus, TntMenus, ExGradientPanel, Unicode, ExCustomSeparatorBar;

type
  TfrmSelectItem = class;

  TTypedTreeView = class(TExTreeView)
  private
    _online: Boolean;
    _itemTypes: TWideStringList;

    constructor Create(AOwner: TfrmSelectItem; Session: TObject);

    procedure SetShowOnline(flag: Boolean);
    procedure SetItemType(itemtype: Widestring);

    function GetItemTypes(index: integer): widestring;
    function GetItemType(): Widestring;
  protected
    procedure SaveGroupsState(); override;
    function FilterItem(item: IExodusItem): Boolean; override;

  public
    destructor Destroy; override;

    procedure DblClick; override;

    procedure SetItemTypes(value: TWidestringList);
    function IndexOfItemType(itype: widestring): integer;

    property ShowOnline: Boolean read _online write SetShowOnline;
    property ItemType: Widestring read GetItemType write SetItemType;
    property ItemTypes[index: integer]: WideString read GetItemTypes;
  end;

  TfrmSelectItem = class(TExForm)
    pnlInput: TPanel;
    pnlActions: TPanel;
    pnlSelect: TPanel;
    pnlEntry: TPanel;
    btnCancel: TTntButton;
    btnOK: TTntButton;
    txtJID: TTntEdit;
    lblJID: TTntLabel;
    popSelected: TTntPopupMenu;
    mnuShowOnline: TTntMenuItem;
    SeparatorBar: TExCustomSeparatorBar;
    
    procedure FormCreate(Sender: TObject);

    procedure ItemChanged(Sender: TObject; Node: TTreeNode);
    procedure mnuShowOnlineClick(Sender: TObject);
    procedure txtJIDChange(Sender: TObject);

  private
    _skipTextChange: boolean;
    _parenthWnd: HWND; //parent handle to use during creation, 0 (default) means use application
    function GetItemTypes(index: integer): widestring;
  protected
    _itemTypes: TWideStringList;

    _selectedItemType: Widestring;
    _selectedUID: Widestring;

    _itemView: TTypedTreeView;

    constructor Create(AOwner: TComponent; itemtype: Widestring; parentHwnd: HWND = 0);overload;
    constructor Create(AOwner: TComponent; itemtypes: TWidestringList; parentHwnd: HWND = 0);overload;
    procedure CreateParams(var Params: TCreateParams);override;
  public
    destructor Destroy; override;

    function IndexOfItemType(itype: widestring): integer;
    
    Property ItemTypes[index: integer]: widestring read GetItemTypes;
    Property SelectedItemType: Widestring read _selectedItemType;
    Property SelectedUID: Widestring read _selectedUID;

  end;

function SelectUIDByType(itemtype: Widestring; title: Widestring = ''; parentHwnd: HWND = 0): Widestring;
function SelectUIDByTypes(itemtypes: TWidestringList; var SelectedItemType :widestring; title: Widestring = ''; parentHwnd: HWND = 0): Widestring;

implementation

uses
    gnugettext,
    Session,
    JabberID,
    COMExodusItemWrapper,
    COMExodusItem;

{$R *.dfm}

function SelectUIDByType(itemtype: Widestring; title: Widestring; parentHwnd: HWND): Widestring;
var
    twsl: TWidestringList;
    ignore: widestring;
begin
    twsl := TWideStringList.create();
    twsl.add(itemType);
    Result := SelectUIDByTypes(twsl, ignore, title, parenthWnd);
    twsl.free();
end;

function SelectUIDByTypes(itemtypes: TWidestringList; var SelectedItemType :widestring; title: Widestring; parentHwnd: HWND): Widestring;
var
    selector: TfrmSelectItem;
begin
    Result := '';
    SelectedItemType := '';
    selector := TfrmSelectItem.Create(nil, itemtypes, parenthWnd);
    if (title <> '') then
        selector.Caption := title;

    if (selector.ShowModal = mrOk) then
    begin
        Result := selector.SelectedUID;
        SelectedItemType := selector.SelectedItemType;
    end;
    
    selector.Free;
end;

constructor TTypedTreeView.Create(AOwner: TfrmSelectItem; Session: TObject);
begin
    inherited Create(AOwner, Session);
    _itemTypes := TWideStringList.create();
end;

destructor TTypedTreeView.Destroy;
begin
    _itemTypes.free();
    inherited;
end;

function TTypedTreeView.IndexOfItemType(itype: widestring): integer;
begin
    Result := _itemTypes.IndexOf(itype);
end;

procedure TTypedTreeView.SetShowOnline(flag: Boolean);
begin
    if (flag <> _online) then
    begin
        _online := flag;

        if not (csLoading in ComponentState) and (Parent <> nil) then
            Refresh();
    end;
end;

function TTypedTreeView.GetItemType(): Widestring;
begin
    Result := ItemTypes[0];
end;

procedure TTypedTreeView.SetItemType(itemtype: WideString);
var
    twsl: TWideStringList;
begin
    if (Self.ItemType <> itemtype) then
    begin
        twsl := TWideStringList.create();
        twsl.Add(itemtype);
        SetItemTypes(twsl);
        twsl.Free();
    end;
end;

function TTypedTreeView.GetItemTypes(index: integer): widestring;
begin
    Result := '';
    if (index >= 0) and (index < _itemTypes.count) then
        Result := _itemTypes[index];
end;

procedure TTypedTreeView.SetItemTypes(value: TWidestringList);
var
    i: integer;
    refresh: boolean;
begin
    refresh := value.Count <> _itemTypes.count;
    i := 0;
    while (not refresh and (i < _itemTypes.Count)) do
    begin
        refresh := _itemTypes[i] <> value[i];
        inc(i);
    end;

    if (refresh) then
    begin
        _itemTypes.Clear();
        for i := 0 to value.Count - 1 do
        begin
            _itemTypes.Add(value[i]);
        end;

        if (not (csLoading in ComponentState)) and (Parent <> nil) then
        begin
            Self.Refresh();
        end;
    end;
end;

procedure TTypedTreeView.SaveGroupsState;
begin
    //DO NOTHING!
end;
function TTypedTreeView.FilterItem(item: IExodusItem): Boolean;
begin
    Result := Item.IsVisible or (not ShowOnline);
    if Result then
        Result := (ItemType = '') or (item.Type_ = 'group') or (IndexOfItemType(item.Type_) <> -1);
end;

procedure TTypedTreeView.DblClick;
begin
    if (Selected = nil) or (TExodusItemWrapper(Selected.Data).ExodusItem.Type_ = EI_TYPE_GROUP) then
    begin
        inherited;
        exit;
    end;

    with TfrmSelectItem(Owner) do
    begin
        ItemChanged(Self, Selected);
        ModalResult := mrOk;
        Hide;
    end;

end;


constructor TfrmSelectItem.Create(AOwner: TComponent; itemtypes: TWidestringList; parentHwnd: HWND);
var
    i: integer;
begin
    _parenthWnd := parenthWnd;
    inherited Create(AOwner);
    _itemTypes := TWideStringList.create();
    for i := 0 to itemtypes.Count - 1 do
        _itemTypes.Add(itemTypes[i]);
    _selectedItemType := '';
    _selectedUID := '';
    _skipTextChange := false;
end;

{
}
constructor TfrmSelectItem.Create(AOwner: TComponent; itemtype: Widestring; parentHwnd: HWND);
var
    twsl: TWidestringList;
begin
    twsl := TWideStringList.create();
    twsl.add(itemType);
    Create(AOwner, twsl, parentHwnd);
    twsl.free();
end;

destructor TfrmSelectItem.Destroy;
begin
    _itemView.Free;
    _itemView := nil;
    _itemTypes.free();
    inherited;
end;

{------------------------------------------------------------------------------}
procedure TfrmSelectItem.CreateParams(var Params: TCreateParams);
begin
    // Make each window appear on the task bar.
    inherited CreateParams(Params);
    if (_parenthWnd <> 0) then
        Params.WndParent := _parenthWnd;
end;

procedure TfrmSelectItem.FormCreate(Sender: TObject);
var
    i: integer;
begin
    inherited;
    if (_itemTypes.Count = 1) then
        Self.Caption := Self.Caption + ' ' + _selectedItemType
    else begin
        Self.Caption := Self.Caption + '[';
        for i := 0 to _itemTypes.Count - 1 do
        begin
            if (i <> 0) then
                Self.Caption := Self.Caption + ',';
            Self.Caption := Self.Caption + _itemTypes[i];
        end;
        Self.Caption := Self.Caption + ']';
    end;
    Self.Caption := _(Self.Caption);

    _itemView := TTypedTreeView.Create(Self, MainSession);

    _itemView.SetItemTypes(_itemTypes);
    
    _itemView.Parent := pnlSelect;
    _itemView.MultiSelect := false;
    _itemView.Align := alClient;
    _itemView.AlignWithMargins := false;
    _itemView.OnChange := ItemChanged;
    _itemView.PopupMenu := popSelected;
    _itemView.BorderStyle := bsSingle;
    with MainSession.Prefs do
    begin
        _itemView.Font.Name := getString('roster_font_name');
        _itemView.Font.Size := getInt('roster_font_size');
        _itemView.Font.Color := TColor(getInt('roster_font_color'));
        _itemView.Font.Charset := getInt('roster_font_charset');
        _itemView.ShowOnline := getBool('roster_only_online');
    end;
    mnuShowOnline.Checked := _itemView.ShowOnline;

    _itemView.Refresh;
end;

function TfrmSelectItem.IndexOfItemType(itype: widestring): integer;
begin
    Result := _itemTypes.IndexOf(itype);
end;

function TfrmSelectItem.GetItemTypes(index: integer): widestring;
begin
    Result := '';
    if (index >= 0) and (index < _itemTypes.count) then
        Result := _itemTypes[index];
end;

procedure TfrmSelectItem.ItemChanged(Sender: TObject; Node: TTreeNode);
var
    item: IExodusItem;
    valid: Boolean;
begin
    Item := _itemView.GetNodeItem(Node);
    valid := (Item <> nil) and (IndexOfItemType(Item.Type_) <> -1);
    if not valid then
    begin
        _selectedUID := '';
        _selectedItemType := '';
        txtJID.text := '';
    end
    else begin
        _selectedUID := item.UID;
        _selectedItemType := item.Type_;
        _skipTextChange := true; //skip as we assign selected stuff here
        txtJID.text := TJabberID.removeJEP106(item.UID);
        _skipTextChange := false;
    end;

    btnOK.Enabled := valid;
end;

procedure TfrmSelectItem.mnuShowOnlineClick(Sender: TObject);
begin
    mnuShowOnline.Checked := not mnuShowOnline.Checked;
    _itemView.ShowOnline := mnuShowOnline.Checked;
end;

function GetValidJID(instr: widestring; out outJID: TJabberID): boolean;
var
    tjid: TJabberID;
begin
    tjid := TJabberID.Create(instr, true); //assume its escaped to start
    outJID := nil;
    //first see if jid is valid without having to escape
    if (tjid.isValid) then
        outJID := tjid
    else begin
        tjid.free();
        tjid := TJabberID.create(instr, false); //escape and see if it works
        if (tjid.isValid) then
            outJID := tjid
        else
            tjid.free();
    end;
    Result := (outJID <> nil);
end;

procedure TfrmSelectItem.txtJIDChange(Sender: TObject);
var
    tjid: TJabberID;
begin
    inherited;
    if (_skipTextChange) then exit;
    //only fires if user has modified the item UID somehow
    if (GetValidJID(txtJID.Text, tjid)) then
    begin
        _selectedUID := tjid.full;
        tjid.free();
        _selectedItemType := '';
        btnOK.Enabled := true;
    end
    else
        btnOK.Enabled := false;
end;

end.
