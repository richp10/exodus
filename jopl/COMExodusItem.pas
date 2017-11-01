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


unit COMExodusItem;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl, Unicode;

const
    EI_TYPE_CONTACT = 'contact';
    EI_TYPE_ROOM = 'room';
    EI_TYPE_GROUP = 'group';
    EI_TYPE_ALL = 'all';
type
  TExodusItem = class(TAutoObject, IExodusItem)
  {
     This class implements IExodusItem interface. IExodusItem interface abstracts
     properties and methods relevant to the items in the contact list.
     This class handles group management for the item and implements general
     "property" list to allow  functionality extensions for the plug-ins.
  }
  private
      _Ctrl: IExodusItemController;
      _Callback: IExodusItemCallback;
      _Uid: WideString;
      _Type: WideString;
      _Text: WideString;
      _ExtendedText: WideString;
      _Groups: TWideStringList;
      _ImageIndex: Integer;

      //Property list is implemented as name-value pair map.
      //We need to manage memory for the value strings ourselves.
      _Properties: TWideStringList;
      _Active: Boolean;
      _IsVisible: Boolean;

      _Updating: Boolean;
  protected
      function Get_IsVisible: WordBool; safecall;
      procedure Set_IsVisible(Value: WordBool); safecall;
      function Get_Value(const Name: WideString): WideString; safecall;
      procedure Set_Value(const Name, value: WideString); safecall;
      function BelongsToGroup(const Group: WideString): WordBool; safecall;
      function GroupsChanged(const Groups: WideString): WordBool; safecall;
      procedure Set_Property_(Index: Integer; const Value: WideString); safecall;
      function Get_Active: WordBool; safecall;
      function Get_ExtendedText: WideString; safecall;
      function Get_GroupCount: Integer; safecall;
      function Get_Group(Index: Integer): WideString; safecall;
      function Get_ImageIndex: Integer; safecall;
      function Get_Property_(Index: Integer): WideString; safecall;
      function Get_PropertyCount: Integer; safecall;
      function Get_Text: WideString; safecall;
      function Get_Type_: WideString; safecall;
      function Get_Uid: WideString; safecall;
      procedure AddProperty(const PropertyName, PropertyValue: WideString); safecall;
      procedure AddGroup(const group: WideString); safecall;
      procedure ClearGroups; safecall;
      procedure ClearProperties; safecall;
      procedure CopyGroup(const GroupTo: WideString); safecall;
      procedure MoveGroup(const GroupFrom, GroupTo: WideString); safecall;
      procedure RemoveGroup(const Group: WideString); safecall;
      procedure RemoveProperty(const Property_: WideString); safecall;
      procedure RenameGroup(const OldGroup, NewGroup: WideString); safecall;
      procedure Set_Active(Value: WordBool); safecall;
      procedure Set_ExtendedText(const Value: WideString); safecall;
      procedure Set_ImageIndex(Value: Integer); safecall;
      procedure Set_Text(const Value: WideString); safecall;
      procedure Set_Type_(const Value: WideString); safecall;
      procedure Set_Uid(const Value: WideString); safecall;
      function Get_PropertyName(Index: Integer): WideString; safecall;

      property IsUpdating: Boolean read _Updating write _Updating;

  public
      constructor Create(ctrl: IExodusItemController;
            Uid: WideString;
            ItemType: WideString;
            cb: IExodusItemCallback);
      destructor Destroy; override;

      property Callback: IExodusItemCallback read _Callback;

  end;

implementation

uses ComServ, Classes, COMExodusItemController;

{---------------------------------------}
constructor TExodusItem.Create(ctrl: IExodusItemController;
        Uid: WideString;
        ItemType: WideString;
        cb: IExodusItemCallback);
begin
    inherited Create();

    _Ctrl := ctrl;
    _Type := ItemType;
    _Uid := uid;
    _Callback := cb;
    _Groups := TWideStringList.Create();
    _Properties := TWideStringList.Create();
    _Groups.Duplicates := dupIgnore;
    _Properties.Duplicates := dupIgnore;
    _Active := false;
    _IsVisible := true;
    _Text := '';
    _ExtendedText := '';
end;

{---------------------------------------}
destructor TExodusItem.Destroy();
begin
   _Groups.Free;
   _Properties.Free;
   _Callback := nil;
   _Ctrl := nil;
   
   inherited;
end;

{---------------------------------------}
function TExodusItem.Get_Active: WordBool;
begin
    Result := _Active;
end;

{---------------------------------------}
function TExodusItem.Get_ExtendedText: WideString;
begin
   Result := _ExtendedText;
end;

{---------------------------------------}
function TExodusItem.Get_GroupCount: Integer;
begin
   Result := _Groups.Count;
end;

{---------------------------------------}
function TExodusItem.Get_Group(Index: Integer): WideString;
begin
   Result := _Groups[index];
end;

{---------------------------------------}
function TExodusItem.Get_ImageIndex: Integer;
begin
   Result := _ImageIndex;
end;

function TExodusItem.Get_Property_(Index: Integer): WideString;
begin
   Result := WideString(_Properties.Objects[Index]);
end;

{---------------------------------------}
function TExodusItem.Get_PropertyCount: Integer;
begin
   Result := _Properties.Count;
end;

{---------------------------------------}
function TExodusItem.Get_Text: WideString;
begin
   Result := _Text;
end;

{---------------------------------------}
function TExodusItem.Get_Type_: WideString;
begin
   Result := _Type;
end;

function TExodusItem.Get_Uid: WideString;
begin
   Result := _Uid;
end;

{---------------------------------------}
procedure TExodusItem.AddGroup(const Group: WideString);
begin
    if _Groups.IndexOf(Group) <> -1 then exit;
    
    _Ctrl.AddGroup(Group);
    _Groups.Add(Group);
    if (not IsUpdating) then _Callback.ItemGroupsChanged(Self);
end;

{---------------------------------------}
procedure TExodusItem.AddProperty(const PropertyName,
  PropertyValue: WideString);
var
   idx: integer;
   value: PWideChar;
begin
   Idx := _Properties.IndexOf(PropertyName);

   if (Idx = -1) then
   begin
      //Allocate memory for the value string.
      Value := StrNewW(PWideChar(PropertyValue));
      _Properties.AddObject(PropertyName, TObject(Value));
   end
   else begin
      Set_Property_(Idx, PropertyValue);
   end;
end;

{---------------------------------------}
procedure TExodusItem.ClearGroups;
begin
   _Groups.Clear;

   if not IsUpdating then _Callback.ItemGroupsChanged(Self);
end;

{---------------------------------------}
procedure TExodusItem.ClearProperties;
var
   value: PWideChar;
begin
    while (_Properties.Count > 0) do
    begin
         Value := PWideChar(_Properties.Objects[0]);
         //Free memory for allocated value string
         StrDisposeW(Value);
        _Properties.Delete(0);
    end;
end;

{---------------------------------------}
procedure TExodusItem.CopyGroup(const GroupTo: WideString);
begin
   AddGroup(GroupTo);
end;

{---------------------------------------}
procedure TExodusItem.MoveGroup(const GroupFrom, GroupTo: WideString);
begin
    IsUpdating := true;
    if (GroupFrom <> '') then
        RemoveGroup(GroupFrom)
    else
        ClearGroups();

    AddGroup(GroupTo);
    IsUpdating := false;

    _Callback.ItemGroupsChanged(Self);
end;

{---------------------------------------}
procedure TExodusItem.RemoveGroup(const Group: WideString);
var
    Idx: Integer;
begin
    Idx := _Groups.IndexOf(Group);
    if (Idx = -1) then exit;
    _Groups.Delete(Idx);

    if (not IsUpdating) then _Callback.ItemGroupsChanged(Self);
end;

{---------------------------------------}
procedure TExodusItem.RemoveProperty(const Property_: WideString);
var
    Idx: Integer;
    Value: PWideChar;
begin
    Idx := _Properties.IndexOf(Property_);
    if (Idx = -1) then exit;
    //Retrieve old value and release the memory
    Value := PWideChar(_Properties.Objects[Idx]);
    _Properties.Delete(Idx);
    StrDisposeW(Value);

end;

{---------------------------------------}
procedure TExodusItem.RenameGroup(const OldGroup, NewGroup: WideString);
begin
    MoveGroup(OldGroup, NewGroup);
end;

{---------------------------------------}
procedure TExodusItem.Set_Active(Value: WordBool);
begin
    _Active := Value;
end;

{---------------------------------------}
procedure TExodusItem.Set_ExtendedText(const Value: WideString);
begin
    _ExtendedText := Value;
end;

{---------------------------------------}
procedure TExodusItem.Set_ImageIndex(Value: Integer);
begin
    _ImageIndex := Value;
end;

{---------------------------------------}
procedure TExodusItem.Set_Text(const Value: WideString);
begin
    _Text := Value;
end;

{---------------------------------------}
procedure TExodusItem.Set_Type_(const Value: WideString);
begin
   _Type := Value;
end;

{---------------------------------------}
procedure TExodusItem.Set_Uid(const Value: WideString);
begin
   _Uid := Value;
end;

{---------------------------------------}
procedure TExodusItem.Set_Property_(Index: Integer; const value: WideString);
var
   OldValue, NewValue: PWideChar;
begin
   //Retrieve old value
   OldValue := PWideChar(_Properties.Objects[index]);
   //Allocate memory and copy content of the passed wide string
   NewValue := StrNewW(PWideChar(Value));
   //Assign new string to the property
   _Properties.Objects[Index] := TObject(NewValue);
   //Free memory that is no longer used.
   StrDisposeW(OldValue);
end;

{---------------------------------------}
function TExodusItem.GroupsChanged(const Groups: WideString): WordBool;
var
   GroupList: TWideStringList;
begin
   GroupList := TWideStringList.Create();
   GroupList.SetText(PWideChar(Groups));
   if (GroupList.Equals(_Groups)) then
       Result := false
   else
       Result := true;
   GroupList.Free();
end;

{---------------------------------------}
function TExodusItem.BelongsToGroup(const Group: WideString): WordBool;
var
    i: Integer;
begin
    Result := false;
    for i := 0 to _Groups.Count - 1 do
    begin
        if (_Groups[i] = Group) then
        begin
            Result := true;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TExodusItem.Get_Value(const Name: WideString): WideString;
var
   Idx: Integer;
begin
   Idx := _Properties.IndexOf(Name);
   if (Idx <> -1) then
       Result := PWideChar(_Properties.Objects[Idx])
   else
       Result := '';

end;

{---------------------------------------}
procedure TExodusItem.Set_Value(const Name, value: WideString);
var
   Idx: Integer;
   OldValue, NewValue: PWideChar;
begin
    Idx := _Properties.IndexOf(Name);
    if (Idx = -1) then begin
        //Add the property value
        AddProperty(Name, value);
    end
    else begin
        //Retrieve old value
        OldValue := PWideChar(_Properties.Objects[idx]);
        //Allocate memory and copy content of the passed wide string
        NewValue := StrNewW(PWideChar(Value));
        //Assign new string to the property
        _Properties.Objects[Idx] := TObject(NewValue);
        //Free memory that is no longer used.
        StrDisposeW(OldValue);
    end;
end;

{---------------------------------------}
function TExodusItem.Get_IsVisible: WordBool;
begin
    Result := _IsVisible;
end;

procedure TExodusItem.Set_IsVisible(Value: WordBool);
begin
    _IsVisible := Value;
end;

function TExodusItem.Get_PropertyName(Index: Integer): WideString;
begin
    Result := _Properties[Index];
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusItem, Class_ExodusItem,
    ciMultiInstance, tmApartment);
end.
