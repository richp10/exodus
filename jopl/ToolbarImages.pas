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
unit ToolbarImages;

interface
uses
    Unicode,
    ExodusImageList;

type

    TContactToolbarImages = class(TExodusImageList)
    protected
        procedure createDefaultIDs();override;
    end;

const
    IMAGE_LIST_ID_CONTACT_TOOLBAR   : WideString = 'contact_toolbar';

{$IFDEF EXODUS}
    CTI_CONNECT_ENABLED_KEY     : Widestring = 'connect';
    CTI_CONNECT_ENABLED_INDEX   : Integer = 0;
    CTI_DISCONNECT_ENABLED_KEY  : Widestring = 'disconnect';
    CTI_DISCONNECT_ENABLED_INDEX: Integer = 1;
    CTI_ADDITEM_ENABLED_KEY     : Widestring = 'addcontact';
    CTI_ADDITEM_ENABLED_INDEX   : Integer = 2;
    CTI_JOINROOM_ENABLED_KEY    : Widestring = 'joinroom';
    CTI_JOINROOM_ENABLED_INDEX  : Integer = 3;
    CTI_SEARCH_ENABLED_KEY      : Widestring = 'search';
    CTI_SEARCH_ENABLED_INDEX    : Integer = 4;
    CTI_VIEW_EABLED_KEY         : Widestring = 'showonline';
    CTI_VIEW_ENABLED_INDEX      : Integer = 5;
    CTI_SENDFILE_ENABLED_KEY    : Widestring = 'folder_closed';
    CTI_SENDFILE_ENABLED_INDEX  : Integer = 6;
    CTI_OPTIONS_ENABLED_KEY     : Widestring = 'prefs';
    CTI_OPTIONS_ENABLED_INDEX   : Integer = 7;
    CTI_ACTIVITY_ENABLED_KEY    : Widestring = 'show_activity_window';
    CTI_ACTIVITY_ENABLED_INDEX  : Integer = 8;
{$ENDIF}
var
    MainbarImages : TContactToolbarImages;

implementation

procedure TContactToolbarImages.createDefaultIDs;
var
    ids: TWideStringList;
begin
{$IFDEF EXODUS}
    ids := TWideStringList.Create();
    ids.Insert(CTI_CONNECT_ENABLED_INDEX, CTI_CONNECT_ENABLED_KEY);
    ids.Insert(CTI_DISCONNECT_ENABLED_INDEX, CTI_DISCONNECT_ENABLED_KEY);
    ids.Insert(CTI_ADDITEM_ENABLED_INDEX, CTI_ADDITEM_ENABLED_KEY);
    ids.Insert(CTI_JOINROOM_ENABLED_INDEX, CTI_JOINROOM_ENABLED_KEY);
    ids.Insert(CTI_SEARCH_ENABLED_INDEX, CTI_SEARCH_ENABLED_KEY);
    ids.Insert(CTI_VIEW_ENABLED_INDEX, CTI_VIEW_EABLED_KEY);
    ids.Insert(CTI_SENDFILE_ENABLED_INDEX, CTI_SENDFILE_ENABLED_KEY);
    ids.Insert(CTI_OPTIONS_ENABLED_INDEX, CTI_OPTIONS_ENABLED_KEY);
    ids.Insert(CTI_ACTIVITY_ENABLED_INDEX, CTI_ACTIVITY_ENABLED_KEY);

    setDefaultIDs(ids);
{$ENDIF}
end;

initialization
    MainbarImages := TContactToolbarImages.Create(IMAGE_LIST_ID_CONTACT_TOOLBAR);

finalization
    MainbarImages.Free();

end.
