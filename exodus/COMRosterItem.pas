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
unit COMRosterItem;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ContactController, ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusRosterItem = class(TAutoObject, IExodusRosterItem)
  protected
    function Get_JabberID: WideString; safecall;
    procedure Set_JabberID(const Value: WideString); safecall;
    function Get_Subscription: WideString; safecall;
    procedure Set_Subscription(const Value: WideString); safecall;
    function Get_Ask: WideString; safecall;
    function Get_GroupCount: Integer; safecall;
    function Group(Index: Integer): WideString; safecall;
    function Get_Nickname: WideString; safecall;
    function Get_RawNickname: WideString; safecall;
    function XML: WideString; safecall;
    procedure Remove; safecall;
    procedure Set_Nickname(const Value: WideString); safecall;
    procedure Update; safecall;
    function Get_ContextMenuID: WideString; safecall;
    procedure Set_ContextMenuID(const Value: WideString); safecall;
    function Get_Action: WideString; safecall;
    function Get_ImageIndex: Integer; safecall;
    function Get_InlineEdit: WordBool; safecall;
    function Get_Status: WideString; safecall;
    function Get_Tooltip: WideString; safecall;
    procedure Set_Action(const Value: WideString); safecall;
    procedure Set_ImageIndex(Value: Integer); safecall;
    procedure Set_InlineEdit(Value: WordBool); safecall;
    procedure Set_Status(const Value: WideString); safecall;
    procedure Set_Tooltip(const Value: WideString); safecall;
    procedure fireChange; safecall;
    function Get_IsContact: WordBool; safecall;
    procedure Set_IsContact(Value: WordBool); safecall;
    procedure addGroup(const grp: WideString); safecall;
    procedure removeGroup(const grp: WideString); safecall;
    procedure setCleanGroups; safecall;
    function Get_ImagePrefix: WideString; safecall;
    procedure Set_ImagePrefix(const Value: WideString); safecall;
    function Get_CanOffline: WordBool; safecall;
    function Get_IsNative: WordBool; safecall;
    procedure Set_CanOffline(Value: WordBool); safecall;
    procedure Set_IsNative(Value: WordBool); safecall;
    { Protected declarations }
  private
    //_ritem: TJabberRosterItem;
    _item: IExodusItem;
    _menu_id: Widestring;

  public
    constructor Create(item: IExodusItem);
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    TntMenus, Menus, ExSession, COMRoster, Session, JabberID, ComServ, DisplayName, XMLTag;

{---------------------------------------}
constructor TExodusRosterItem.Create(item: IExodusItem);
begin
    // this is just a wrapper for the roster item
    _item := item;
    _menu_id := '';
end;

{---------------------------------------}
function TExodusRosterItem.Get_JabberID: WideString;
begin
    Result := _item.UID;
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_JabberID(const Value: WideString);
begin
    // XXX: remove Set_JabberID from the interface
    {
    if (_ritem.jid <> nil) then
        _ritem.jid.Free();

    _ritem.setJid(value);
    }
end;

{---------------------------------------}
function TExodusRosterItem.Get_Subscription: WideString;
begin
    Result := _item.value['Subscription'];
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_Subscription(const Value: WideString);
begin
    _item.value['Subscription'] := Value;
end;

{---------------------------------------}
function TExodusRosterItem.Get_Ask: WideString;
begin
    Result := _item.value['Ask'];
end;

{---------------------------------------}
function TExodusRosterItem.Get_GroupCount: Integer;
begin
    Result := _item.GroupCount;
end;

{---------------------------------------}
function TExodusRosterItem.Group(Index: Integer): WideString;
begin
    if (index >= 0) and (index < _item.GroupCount) then
        Result := _item.Group[index]
    else
        Result := '';
end;

{---------------------------------------}
function TExodusRosterItem.Get_Nickname: WideString;
begin
    Result := _item.Text;
end;

{---------------------------------------}
function TExodusRosterItem.Get_RawNickname: WideString;
begin
    Result := _item.value['Name'];
end;

{---------------------------------------}
function TExodusRosterItem.XML: WideString;
var
    tag: TXMLTag;
    val: Widestring;
    idx: Integer;
begin
    //Generate the following:
    //  <item jid='user@host' subscription='mode' ask='mode' name='nickname'>
    //      <group>Group 1</group>...
    //  </item>
    
    tag := TXMLTag.Create();
    tag.Name := 'item';
    tag.setAttribute('jid', _item.UID);
    
    val := _item.value['Name'];
    if (val <> '') then tag.setAttribute('name', val);
    val := _item.value['Subscription'];
    if (val <> '') then tag.setAttribute('subscription', val);
    val := _item.value['Ask'];
    if (val <> '') then tag.setAttribute('ask', val);

    for idx := 0 to _item.GroupCount - 1 do begin
        tag.AddBasicTag('group', _item.Group[idx]);
    end;
    
    Result := tag.XML;
    tag.Free();
end;

{---------------------------------------}
procedure TExodusRosterItem.Remove;
begin
   MainSession.ItemController.RemoveItem(_item.UID);
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_Nickname(const Value: WideString);
begin
    if (Value <> _item.value['Name']) then begin
        _item.value['Name'] := Value;
        getDisplayNameCache().UpdateDisplayName(_item);
        MainSession.FireEvent('/item/update', _item);
    end;
end;

{---------------------------------------}
procedure TExodusRosterItem.Update;
begin
  //  _ritem.update();
end;

{---------------------------------------}
function TExodusRosterItem.Get_ContextMenuID: WideString;
begin
    Result := '';
end;

{---------------------------------------}
procedure TExodusRosterItem.Set_ContextMenuID(const Value: WideString);
begin
    //not supported
end;

{---------------------------------------}
function TExodusRosterItem.Get_Action: WideString;
begin
    Result := _item.value['defaultaction'];
end;
{---------------------------------------}
procedure TExodusRosterItem.Set_Action(const Value: WideString);
begin
    //not supported
end;

{---------------------------------------}
function TExodusRosterItem.Get_ImageIndex: Integer;
begin
    Result := _item.ImageIndex;
end;
{---------------------------------------}
procedure TExodusRosterItem.Set_ImageIndex(Value: Integer);
begin
    _item.ImageIndex := Value;
end;

{---------------------------------------}
function TExodusRosterItem.Get_InlineEdit: WordBool;
begin
    Result := false;
end;
{---------------------------------------}
procedure TExodusRosterItem.Set_InlineEdit(Value: WordBool);
begin
   //not supported
end;

{---------------------------------------}
function TExodusRosterItem.Get_Status: WideString;
begin
   Result := '';
end;
{---------------------------------------}
procedure TExodusRosterItem.Set_Status(const Value: WideString);
begin
   //???
end;

{---------------------------------------}
function TExodusRosterItem.Get_Tooltip: WideString;
begin
    Result := '';
end;
{---------------------------------------}
procedure TExodusRosterItem.Set_Tooltip(const Value: WideString);
begin
   //Not supported
end;

{---------------------------------------}
procedure TExodusRosterItem.fireChange;
begin
    MainSession.FireEvent('/item/update', _item);
end;

{---------------------------------------}
function TExodusRosterItem.Get_IsContact: WordBool;
begin
    Result := true;
end;
{---------------------------------------}
procedure TExodusRosterItem.Set_IsContact(Value: WordBool);
begin
   //Not supported
end;

{---------------------------------------}
procedure TExodusRosterItem.addGroup(const grp: WideString);
begin
    _item.AddGroup(grp);
end;
{---------------------------------------}
procedure TExodusRosterItem.removeGroup(const grp: WideString);
begin
    _item.RemoveGroup(grp);
end;

{---------------------------------------}
procedure TExodusRosterItem.setCleanGroups;
begin
    //_ritem.SetCleanGroups();
end;

{---------------------------------------}
function TExodusRosterItem.Get_ImagePrefix: WideString;
begin
  //  Result := _ritem.ImagePrefix;
  Result := _item.value['ImagePrefix'];
end;
{---------------------------------------}
procedure TExodusRosterItem.Set_ImagePrefix(const Value: WideString);
begin
    _item.value['ImagePrefix'];
end;

{---------------------------------------}
function TExodusRosterItem.Get_CanOffline: WordBool;
begin
   Result := (_item.value['msgoffline'] = 'true');
end;
{---------------------------------------}
procedure TExodusRosterItem.Set_CanOffline(Value: WordBool);
begin
    if Value then
        _item.value['msgoffline'] := ''
    else
        _item.value['msgoffline'] := 'true';
end;

{---------------------------------------}
function TExodusRosterItem.Get_IsNative: WordBool;
begin
    //Result := _ritem.IsNative;
    Result := (_item.value['Network'] = 'xmpp');
end;
{---------------------------------------}
procedure TExodusRosterItem.Set_IsNative(Value: WordBool);
var
    network: Widestring;
begin
    if Value then
        network := ''
    else
        network := 'xmpp';
        
    _item.value['Network'] := network;
end;

end.
