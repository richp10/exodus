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
unit GroupActions;

interface

uses Exodus_TLB, ExActions;

type TAddGroupAction = class(TExBaseAction)
private
    constructor Create(id, caption: Widestring);
public
    destructor Destroy(); override;

    procedure execute(const items: IExodusItemList); override;
end;

implementation

uses ComServ, gnugettext, ExActionCtrl, ExUtils;

constructor TAddGroupAction.Create(id: Widestring; caption: Widestring);
begin
    inherited Create(id);

    set_Caption(caption);
    set_Enabled(true);
end;
destructor TAddGroupAction.Destroy;
begin
    inherited;
end;

procedure TAddGroupAction.execute(const items: IExodusItemList);
var
    base: Widestring;
begin
    if (items.Count = 1) then begin
        base := items.Item[0].UID;
    end;

    promptNewGroup(base);
end;

procedure RegisterActions();
var
    actCtrl: IExodusActionController;
    act: IExodusAction;
begin
    actCtrl := GetActionController();

    act := TAddGroupAction.Create(
            '{000-exodus.googlecode.com}-090-add-group',
            _('New Group'));
    actCtrl.registerAction('{create}', act);

    act := TAddGroupAction.Create(
            '{000-exodus.googlecode.com}-090-add-subgroup',
            _('Create nested group'));
    actCtrl.registerAction('group', act);
    actCtrl.addEnableFilter('group', act.Name, 'selection=single');
end;

initialization;
    RegisterActions();

end.
