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
unit COMExMainMenu;



{-----------------------------------------------------------------------------}
{-----------------------------------------------------------------------------}
{ This is autogenerated code using the COMGuiGenerator. DO NOT MODIFY BY HAND }
{-----------------------------------------------------------------------------}
{-----------------------------------------------------------------------------}


{$WARN SYMBOL_PLATFORM OFF}

interface
uses
    ActiveX,Classes,COMExMenuItem,ComObj,Controls,Exodus_TLB,Forms,Menus,StdCtrls,StdVcl,TntMenus;

type
    TExControlMainMenu = class(TAutoObject, IExodusControl, IExodusControlMainMenu)
    public
        constructor Create(control: TTntMainMenu);

    private
        _control: TTntMainMenu;

    protected
        function Get_ControlType: ExodusControlTypes; safecall;
        function Get_Name: Widestring; safecall;
        procedure Set_Name(const Value: Widestring); safecall;
        function Get_Tag: Integer; safecall;
        procedure Set_Tag(Value: Integer); safecall;
        function Get_ItemsCount: integer; safecall;
        function Get_Items(Index: integer): IExodusControlMenuItem; safecall;
        function Get_AutoHotkeys: Integer; safecall;
        procedure Set_AutoHotkeys(Value: Integer); safecall;
        function Get_AutoLineReduction: Integer; safecall;
        procedure Set_AutoLineReduction(Value: Integer); safecall;
        function Get_AutoMerge: Integer; safecall;
        procedure Set_AutoMerge(Value: Integer); safecall;
        function Get_BiDiMode: Integer; safecall;
        procedure Set_BiDiMode(Value: Integer); safecall;
        function Get_OwnerDraw: Integer; safecall;
        procedure Set_OwnerDraw(Value: Integer); safecall;
        function Get_ParentBiDiMode: Integer; safecall;
        procedure Set_ParentBiDiMode(Value: Integer); safecall;
    end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation


constructor TExControlMainMenu.Create(control: TTntMainMenu);
begin
     _control := control; 
end;

function TExControlMainMenu.Get_ControlType: ExodusControlTypes;
begin
    Result := ExodusControlMainMenu;
end;

function TExControlMainMenu.Get_Name: Widestring;
begin
      Result := _control.Name;
end;

procedure TExControlMainMenu.Set_Name(const Value: Widestring);
begin
      _control.Name := Value;
end;

function TExControlMainMenu.Get_Tag: Integer;
begin
      Result := _control.Tag;
end;

procedure TExControlMainMenu.Set_Tag(Value: Integer);
begin
      _control.Tag := Value;
end;

function TExControlMainMenu.Get_ItemsCount: integer;
begin
    Result := _control.Items.Count;
end;

function TExControlMainMenu.Get_Items(Index: integer): IExodusControlMenuItem;
begin
   if ((Index >= 0) and (Index < _control.Items.Count)) then
      Result := TExControlMenuItem.Create(TTntMenuItem(_control.Items[Index])) as IExodusControlMenuItem
   else 
      Result := nil;
end;

function TExControlMainMenu.Get_AutoHotkeys: Integer;
begin
    if (_control.AutoHotkeys = maAutomatic) then Result := 0;
    if (_control.AutoHotkeys = maManual) then Result := 1;
end;

procedure TExControlMainMenu.Set_AutoHotkeys(Value: Integer);
begin
   if (Value = 0) then _control.AutoHotkeys := maAutomatic;
   if (Value = 1) then _control.AutoHotkeys := maManual;
end;

function TExControlMainMenu.Get_AutoLineReduction: Integer;
begin
    if (_control.AutoLineReduction = maAutomatic) then Result := 0;
    if (_control.AutoLineReduction = maManual) then Result := 1;
end;

procedure TExControlMainMenu.Set_AutoLineReduction(Value: Integer);
begin
   if (Value = 0) then _control.AutoLineReduction := maAutomatic;
   if (Value = 1) then _control.AutoLineReduction := maManual;
end;

function TExControlMainMenu.Get_AutoMerge: Integer;
begin
    if (_control.AutoMerge = False) then Result := 0;
    if (_control.AutoMerge = True) then Result := 1;
end;

procedure TExControlMainMenu.Set_AutoMerge(Value: Integer);
begin
   if (Value = 0) then _control.AutoMerge := False;
   if (Value = 1) then _control.AutoMerge := True;
end;

function TExControlMainMenu.Get_BiDiMode: Integer;
begin
    if (_control.BiDiMode = bdLeftToRight) then Result := 0;
    if (_control.BiDiMode = bdRightToLeft) then Result := 1;
    if (_control.BiDiMode = bdRightToLeftNoAlign) then Result := 2;
    if (_control.BiDiMode = bdRightToLeftReadingOnly) then Result := 3;
end;

procedure TExControlMainMenu.Set_BiDiMode(Value: Integer);
begin
   if (Value = 0) then _control.BiDiMode := bdLeftToRight;
   if (Value = 1) then _control.BiDiMode := bdRightToLeft;
   if (Value = 2) then _control.BiDiMode := bdRightToLeftNoAlign;
   if (Value = 3) then _control.BiDiMode := bdRightToLeftReadingOnly;
end;

function TExControlMainMenu.Get_OwnerDraw: Integer;
begin
    if (_control.OwnerDraw = False) then Result := 0;
    if (_control.OwnerDraw = True) then Result := 1;
end;

procedure TExControlMainMenu.Set_OwnerDraw(Value: Integer);
begin
   if (Value = 0) then _control.OwnerDraw := False;
   if (Value = 1) then _control.OwnerDraw := True;
end;

function TExControlMainMenu.Get_ParentBiDiMode: Integer;
begin
    if (_control.ParentBiDiMode = False) then Result := 0;
    if (_control.ParentBiDiMode = True) then Result := 1;
end;

procedure TExControlMainMenu.Set_ParentBiDiMode(Value: Integer);
begin
   if (Value = 0) then _control.ParentBiDiMode := False;
   if (Value = 1) then _control.ParentBiDiMode := True;
end;




end.
