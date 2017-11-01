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
unit ContactActions;

interface

uses Exodus_TLB, ExActions;

type
    TAddContactAction = class(TExBaseAction)
    private
        constructor Create;

    public
        procedure execute(const items: IExodusItemList); override;
        
    end;

    TSendContactsAction = class(TExBaseAction)
    private
        constructor Create;

    public
        procedure execute(const items: IExodusItemList); override;
        
    end;
    TBlockContactAction = class(TExBaseAction)
    private
        constructor Create;

    public
        procedure execute(const items: IExodusItemList); override;
        
    end;
    TUnblockContactAction = class(TExBaseAction)
    private
        constructor Create;

    public
        procedure execute(const items: IExodusItemList); override;
        
    end;
    TPropertiesContactAction = class(TExBaseAction)
    private
        constructor Create;

    public
        procedure execute(const items: IExodusItemList); override;
    end;

implementation

uses Classes, ExActionCtrl, ExUtils, gnugettext, JabberID, SelectItem,
    Session, RosterAdd, Profile;

procedure ToggleBlockState(item: IExodusItem; block: Boolean);
var
    jid: TJabberID;
    subitems: IExodusItemList;
    idx: Integer;
begin
    if (item.Type_ = 'group') then begin
        subitems := MainSession.ItemController.GetGroupItems(item.UID);
        for idx := 0 to subitems.Count - 1 do
            ToggleBlockState(subitems.Item[idx], block);
    end
    else if (item.Type_ = 'contact') then begin
        jid := TJabberID.Create(item.UID);
        if block then
            MainSession.Block(jid)
        else
            MainSession.UnBlock(jid);
        jid.Free();
    end;
end;

constructor TAddContactAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-000-add-contact');

    Set_Caption(_('Add Contact'));
    Set_Enabled(true);
end;
procedure TAddContactAction.execute(const items: IExodusItemList);
begin
    ShowAddContact();
end;

constructor TSendContactsAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-060-send-contacts');

    Set_Caption(_('Send contacts to...'));
    Set_Enabled(true);
end;

procedure TSendContactsAction.execute(const items: IExodusItemList);
var
    idx: Integer;
    item: IExodusItem;
    subjects: TList;
    target: Widestring;
begin

    target := SelectUIDByType('contact', _('Select Contacts Recipient'));
    if (target <> '') then begin
        subjects := TList.Create;

        for idx := 0 to items.Count - 1 do begin
            item := items.Item[idx];
            subjects.Add(Pointer(item));
        end;

        jabberSendRosterItems(target, subjects);
    end;
end;

{
}
constructor TBlockContactAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-080-block-contact');

    Set_Caption(_('Block'));
    Set_Enabled(true);
end;

procedure TBlockContactAction.execute(const items: IExodusItemList);
var
    idx: Integer;
begin
    for idx := 0 to items.Count - 1 do begin
        ToggleBlockState(items.Item[idx], true);
    end;
end;

{
}
constructor TUnblockContactAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-080-unblock-contact');

    Set_Caption(_('Unblock'));
    Set_Enabled(true);
end;

procedure TUnblockContactAction.execute(const items: IExodusItemList);
var
    idx: Integer;
begin
    for idx := 0 to items.Count - 1 do begin
        ToggleBlockState(items.Item[idx], false);
    end;
end;

{
}
constructor TPropertiesContactAction.Create;
begin
    inherited Create('{000-exodus.googlecode.com}-100-properties');

    Set_Caption(_('Properties...'));
    Set_Enabled(true);
end;

procedure TPropertiesContactAction.execute(const items: IExodusItemList);
var
    i: integer;
begin
    // 'selection=single' property should limit this to 1 contact in the list
    for i := 0 to items.Count - 1 do
    begin
        ShowProfile(items.Item[i].UID);
    end;
end;

{
}
procedure RegisterActions();
var
    actCtrl: IExodusActionController;
    act: IExodusAction;
begin
    actCtrl := GetActionController();

    //Setup add contact
    act := TAddContactAction.Create() as IExodusAction;
    actCtrl.registerAction('{create}', act);

    //Setup send contacts
    act := TSendContactsAction.Create() as IExodusAction;
    actCtrl.registerAction('contact', act);

    //Setup block contact
    act := TBlockContactAction.Create() as IExodusAction;
    actCtrl.registerAction('contact', act);
    
    actCtrl.registerAction('group', act);

    //Setup unblock contact
    act := TUnblockContactAction.Create() as IExodusAction;
    actCtrl.registerAction('contact', act);

    actCtrl.registerAction('group', act);

    //Setup contact properties
    act := TPropertiesContactAction.Create() as IExodusAction;
    actCtrl.registerAction('contact', act);
    actctrl.addEnableFilter('contact', act.Name, 'selection=single');
end;


initialization
    RegisterActions();

end.
