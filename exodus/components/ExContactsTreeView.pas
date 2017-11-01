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


unit ExContactsTreeView;

interface

uses ExAllTreeView, Classes, Exodus_TLB;

type
   TExContactsTreeView = class(TExAllTreeView)

   protected
       function  FilterItem(Item: IExodusItem): Boolean; override;
       procedure SaveGroupsState(); override;
   public
        constructor Create(AOwner: TComponent; Session: TObject); override;
   end;


implementation

uses ActionMenus, COMExodusItem;

{---------------------------------------}
constructor TExContactsTreeView.Create(AOwner: TComponent; Session: TObject); override;
begin
    inherited Create(AOwner, Session);

    if (PopupMenu is TExActionPopupMenu) then with TExActionPopupMenu(PopupMenu) do begin
        Excludes.Add('{000-exodus.googlecode.com}-090-add-subgroup');
    end;

end;
{---------------------------------------}
function  TExContactsTreeView.FilterItem(Item: IExodusItem): Boolean;
begin
    if (Item.Type_= EI_TYPE_CONTACT) then
        Result := inherited FilterItem(Item)
    else
        Result := false;
end;

procedure TExContactsTreeView.SaveGroupsState();
begin

end;

end.





