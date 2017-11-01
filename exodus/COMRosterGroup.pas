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
unit COMRosterGroup;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ContactController, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusRosterGroup = class(TAutoObject, IExodusRosterGroup)
  protected
    function Get_Action: WideString; safecall;
    function Get_AutoExpand: WordBool; safecall;
    function Get_DragSource: WordBool; safecall;
    function Get_DragTarget: WordBool; safecall;
    function Get_KeepEmpty: WordBool; safecall;
    function Get_ShowPresence: WordBool; safecall;
    function Get_SortPriority: Integer; safecall;
    function getText: WideString; safecall;
    procedure Set_Action(const Value: WideString); safecall;
    procedure Set_AutoExpand(Value: WordBool); safecall;
    procedure Set_DragSource(Value: WordBool); safecall;
    procedure Set_DragTarget(Value: WordBool); safecall;
    procedure Set_KeepEmpty(Value: WordBool); safecall;
    procedure Set_ShowPresence(Value: WordBool); safecall;
    procedure Set_SortPriority(Value: Integer); safecall;
    function inGroup(const jid: WideString): WordBool; safecall;
    function isEmpty: WordBool; safecall;
    procedure addJid(const jid: WideString); safecall;
    function getGroup(const group_name: WideString): IExodusRosterGroup;
      safecall;
    procedure removeJid(const jid: WideString); safecall;
    procedure addGroup(const child: IExodusRosterGroup); safecall;
    procedure removeGroup(const child: IExodusRosterGroup); safecall;
    function getRosterItems(Online: WordBool): OleVariant; safecall;
    function Get_FullName: WideString; safecall;
    function Get_NestLevel: Integer; safecall;
    function Get_Online: Integer; safecall;
    function Get_Parent: IExodusRosterGroup; safecall;
    function Get_Total: Integer; safecall;
    function Parts(Index: Integer): WideString; safecall;
    procedure fireChange; safecall;

  private
   _grp: IExodusItem;

  public
    constructor Create(grp: IExodusItem);

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    XMLTag, Variants, Classes, Session, JabberID, ComServ, COMExodusItem, GroupParser, Unicode;

{---------------------------------------}
constructor TExodusRosterGroup.Create(grp: IExodusItem);
begin
    // this is just a wrapper for the roster item
    _grp := grp;
end;

{---------------------------------------}
function TExodusRosterGroup.getText: WideString;
begin
  Result := _grp.Text;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_Action: WideString;
begin
    Result := '';
end;
{---------------------------------------}
procedure TExodusRosterGroup.Set_Action(const Value: WideString);
begin
    //not supported
end;

{---------------------------------------}
function TExodusRosterGroup.Get_AutoExpand: WordBool;
begin
   Result := false;
end;
{---------------------------------------}
procedure TExodusRosterGroup.Set_AutoExpand(Value: WordBool);
begin
   //not supported
end;


{---------------------------------------}
function TExodusRosterGroup.Get_DragSource: WordBool;
begin
   Result := true;
end;
{---------------------------------------}
procedure TExodusRosterGroup.Set_DragSource(Value: WordBool);
begin
  //not supported
end;

{---------------------------------------}
function TExodusRosterGroup.Get_DragTarget: WordBool;
begin
  Result := true;
end;
{---------------------------------------}
procedure TExodusRosterGroup.Set_DragTarget(Value: WordBool);
begin
  //not supported
end;

{---------------------------------------}
function TExodusRosterGroup.Get_KeepEmpty: WordBool;
begin
  Result := false;
end;
{---------------------------------------}
procedure TExodusRosterGroup.Set_KeepEmpty(Value: WordBool);
begin
   //not supported
end;

{---------------------------------------}
function TExodusRosterGroup.Get_ShowPresence: WordBool;
begin
  Result := false;
end;
{---------------------------------------}
procedure TExodusRosterGroup.Set_ShowPresence(Value: WordBool);
begin
   //not supported
end;

{---------------------------------------}
function TExodusRosterGroup.Get_SortPriority: Integer;
begin
  Result := 0;
end;
{---------------------------------------}
procedure TExodusRosterGroup.Set_SortPriority(Value: Integer);
begin
   //not supported
end;

{---------------------------------------}
function TExodusRosterGroup.inGroup(const jid: WideString): WordBool;
var
    item: IExodusItem;
begin
    item := MainSession.ItemController.GetItem(jid);
    Result := (item <> nil) and item.BelongsToGroup(_grp.UID);
end;

{---------------------------------------}
function TExodusRosterGroup.isEmpty: WordBool;
begin
   Result := MainSession.ItemController.GetGroupItems(_grp.UID).Count = 0;
end;

{---------------------------------------}
procedure TExodusRosterGroup.addJid(const jid: WideString);
var
    item: IExodusItem;
begin
    item := MainSession.ItemController.GetItem(jid);
    if (item <> nil) then begin
        item.AddGroup(_grp.UID);
    end;
end;

{---------------------------------------}
function TExodusRosterGroup.getGroup(
  const group_name: WideString): IExodusRosterGroup;
var
    item: IExodusItem;
//    go: TJabberGroup;
begin
    item := MainSession.ItemController.GetItem(group_name);
    if (item <> nil) and (item.Type_ = 'group') then
        Result := TExodusRosterGroup.Create(item)
    else
        Result := nil;
end;

{---------------------------------------}
procedure TExodusRosterGroup.removeJid(const jid: WideString);
var
    item: IExodusItem;
begin
    item := MainSession.ItemController.GetItem(jid);
    if (item <> nil) then begin
        item.RemoveGroup(_grp.UID);
    end;
end;

{---------------------------------------}
procedure TExodusRosterGroup.addGroup(const child: IExodusRosterGroup);
var
    ctrl: IExodusItemController;
    item: IExodusItem;
begin
    ctrl := MainSession.ItemController;
    item := ctrl.GetItem(child.FullName);
    if (item <> nil) and (item.Type_ = 'group') then begin
        ctrl.CopyItem(item.UID, _grp.UID);
    end;
end;

{---------------------------------------}
procedure TExodusRosterGroup.removeGroup(const child: IExodusRosterGroup);
var
    ctrl: IExodusItemController;
    item: IExodusItem;
begin
    ctrl := MainSession.ItemController;
    item := ctrl.GetItem(child.FullName);
    if (item <> nil) and (item.Type_ = 'group') then begin
        ctrl.RemoveItem(item.UID);
    end;
end;

{---------------------------------------}
function TExodusRosterGroup.getRosterItems(Online: WordBool): OleVariant;
var
    idx, pos: Integer;
    items: IExodusItemList;
    item: IExodusItem;
    va: Variant;
begin
    items := MainSession.ItemController.GetGroupItems(_grp.UID);
    va := VarArrayCreate([0, items.Count], varOleStr);
    pos := 0;
    for idx := 0 to items.Count - 1 do begin
        item := items.Item[idx];
        if (item.Type_ <> 'contact') then continue;
        if Online and not item.Active then continue;
        
        VarArrayPut(va, item.UID, pos);
        Inc(pos);
    end;

    Result := va;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_FullName: WideString;
begin
    Result := _grp.UID;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_NestLevel: Integer;
var
    parser: TGroupParser;
begin
    parser := TGroupParser.Create(MainSession);
    Result := parser.GetNestedGroups(_grp.UID).Count;
    parser.Free();
end;

{---------------------------------------}
function TExodusRosterGroup.Get_Online: Integer;
var
    ctrl: IExodusItemController;
    subitems: IExodusItemList;
    idx: Integer;
begin
    Result := 0;
    subitems := ctrl.GetGroupItems(_grp.UID);
    for idx := 0 to subitems.Count - 1 do begin
        if subitems.Item[idx].Active then Inc(Result);
    end;
end;

{---------------------------------------}
function TExodusRosterGroup.Get_Parent: IExodusRosterGroup;
var
    parser: TGroupParser;
    parent: Widestring;
    item: IExodusItem;
begin
    parser := TGroupParser.Create(MainSession);
    parent := parser.GetGroupParent(parent);
    parser.Free();

    if (parent <> '') then
        item := MainSession.ItemController.GetItem(parent)
    else
        item := nil;

    Result := Self.getGroup(parent);
end;

{---------------------------------------}
function TExodusRosterGroup.Get_Total: Integer;
begin
    Result := MainSession.ItemController.GetGroupItems(_grp.UID).Count;
end;

{---------------------------------------}
function TExodusRosterGroup.Parts(Index: Integer): WideString;
var
    parser: TGroupParser;
    divs: TWidestringList;
begin
    parser := TGroupParser.Create(MainSession);
    divs := parser.GetNestedGroups(_grp.UID);
    if (index >= 0) and (index < divs.Count) then
        Result := divs[index]
    else
        Result := '';
end;

{---------------------------------------}
procedure TExodusRosterGroup.fireChange;
begin
    MainSession.FireEvent('/item/update', _grp);
end;

end.
