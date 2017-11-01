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
unit RosterImages;


interface
uses
    Unicode,
    ExodusImageList;

type

    TRosterImages = class(TExodusImageList)
    protected
        procedure createDefaultIDs();override;
    end;

const
    IMAGE_LIST_ID_ROSTER    : WideString = 'roster';

{$IFDEF EXODUS}
    RI_OFFLINE_KEY          : WideString = 'offline';
    RI_OFFLINE_INDEX        : Integer = 0;
    RI_AVAILABLE_KEY        : WideString = 'available';
    RI_AVAILABLE_INDEX      : Integer = 1;
    RI_AWAY_KEY             : WideString = 'away';
    RI_AWAY_INDEX           : Integer = 2;
    RI_DND_KEY              : WideString = 'dnd';
    RI_DND_INDEX            : Integer = 3;
    RI_CHAT_KEY             : WideString = 'chat';
    RI_CHAT_INDEX           : Integer = 4;
    RI_FULLFOLDER_KEY       : WideString = 'full_folder';
    RI_FULLFOLDER_INDEX     : Integer = 5;
    RI_UNKNOWN_KEY          : WideString = 'unknown';
    RI_UNKNOWN_INDEX        : Integer = 6;
    RI_MULTIPLE_KEY         : WideString = 'multiple';
    RI_MULTIPLE_INDEX       : Integer = 7;
    RI_CLOSEDFOLDER_KEY     : WideString = 'closed_folder';
    RI_CLOSEDFOLDER_INDEX   : Integer = 8;
    RI_OPENFOLDER_KEY       : WideString = 'open_folder';
    RI_OPENFOLDER_INDEX     : Integer = 9;
    RI_XA_KEY               : WideString = 'xa';
    RI_XA_INDEX             : Integer = 10;
    RI_HEADLINE_KEY         : WideString = 'headline';
    RI_HEADLINE_INDEX       : Integer = 11;
    RI_INFO_KEY             : WideString = 'info';
    RI_INFO_INDEX           : Integer = 12;
    RI_BOOK_KEY             : WideString = 'book';
    RI_BOOK_INDEX           : Integer = 13;
    RI_REPLY_KEY            : WideString = 'reply';
    RI_REPLY_INDEX          : Integer = 14;
    RI_NOTE_KEY             : WideString = 'note';
    RI_NOTE_INDEX           : Integer = 15;
    RI_KEYOLD_KEY           : WideString = 'key_old';
    RI_KEYOLD_INDEX        : Integer = 16;
    RI_FLOWCHART_KEY        : WideString = 'flowchart';
    RI_FLOWCHART_INDEX      : Integer = 17;
    RI_NEWSITEM_KEY         : WideString = 'newsitem';
    RI_NEWSITEM_INDEX       : Integer = 18;
    RI_IMAGE_KEY            : WideString = 'image';
    RI_IMAGE_INDEX          : Integer = 19;
    RI_CONTACT_KEY          : WideString = 'contact';
    RI_CONTACT_INDEX        : Integer = 20;
    RI_CONFERENCE_KEY       : WideString = 'conference';
    RI_CONFERENCE_INDEX     : Integer = 21;
    RI_SERVICE_KEY          : WideString = 'service';
    RI_SERVICE_INDEX        : Integer = 22;
    RI_NEWITEM_KEY          : WideString = 'newitem';
    RI_NEWITEM_INDEX        : Integer = 23;
    RI_KEY_KEY              : WideString = 'key';
    RI_KEY_INDEX            : Integer = 24;
    RI_FILTER_KEY           : WideString = 'filter';
    RI_FILTER_INDEX         : Integer = 25;
    RI_CONTACTFOLDER_KEY    : WideString = 'contact_folder';
    RI_CONTACTFOLDER_INDEX  : Integer = 26;
    RI_OPENGROUP_KEY        : WideString = 'open_group';
    RI_OPENGROUP_INDEX      : Integer = 27;
    RI_CLOSEDGROUP_KEY      : WideString = 'closed_group';
    RI_CLOSEDGROUP_INDEX    : Integer = 28;
    RI_RIGHT_KEY            : WideString = 'right';
    RI_RIGHT_INDEX          : Integer = 29;
    RI_LEFT_KEY             : WideString = 'left';
    RI_LEFT_INDEX           : Integer = 30;
    RI_WARN_KEY             : WideString = 'warn';
    RI_WARN_INDEX           : Integer = 31;
    RI_ERROR_KEY            : WideString = 'error';
    RI_ERROR_INDEX          : Integer = 32;
    RI_OFFLINEATTN_KEY      : WideString = 'offline_attn';
    RI_OFFLINEATTN_INDEX    : Integer = 33;
    RI_AVAILABLEATTN_KEY    : WideString = 'available_attn';
    RI_AVAILABLEATTN_INDEX  : Integer = 34;
    RI_AWAYATTN_KEY         : WideString = 'away_attn';
    RI_AWAYATTN_INDEX       : Integer = 35;
    RI_DNDATTN_KEY          : WideString = 'dnd_attn';
    RI_DNDATTN_INDEX        : Integer = 36;
    RI_CHATATTN_KEY         : WideString = 'chat_attn';
    RI_CHATATTN_INDEX       : Integer = 37;
    RI_XAATTN_KEY           : WideString = 'xa_attn';
    RI_XAATTN_INDEX         : Integer = 38;
    RI_ONLINEBLOCKED_KEY    : WideString = 'online_blocked';
    RI_ONLINEBLOCKED_INDEX  : Integer = 39;
    RI_DELETE_KEY           : WideString = 'delete';
    RI_DELETE_INDEX         : Integer = 40;
    RI_OFFLINEBLOCKED_KEY   : WideString = 'offline_blocked';
    RI_OFFLINEBLOCKED_INDEX : Integer = 41;
    RI_ATTN_KEY             : WideString = 'attn';
    RI_ATTN_INDEX           : Integer = 42;
    RI_APPIMAGE_KEY         : WideString = 'exodus';
    RI_APPIMAGE_INDEX       : Integer = 43;
    RI_AVAILNEG_KEY         : WideString = 'avail_neg';
    RI_AVAILNEG_INDEX       : Integer = 44;
    RI_AWAYNEG_KEY          : WideString = 'away_neg';
    RI_AWAYNEG_INDEX        : Integer = 45;
    RI_DNDNEG_KEY           : WideString = 'dnd_neg';
    RI_DNDNEG_INDEX         : Integer = 46;
    RI_CHATNEG_KEY          : WideString = 'chat_neg';
    RI_CHATNEG_INDEX        : Integer = 47;
    RI_XANEG_KEY            : WideString = 'xa_neg';
    RI_XANEG_INDEX          : Integer = 48;
    RI_NETWORK_KEY          : WideString = 'network';
    RI_NETWORK_INDEX        : Integer = 49;
    RI_NETWORKDIS_KEY       : WideString = 'network_disabled';
    RI_NETWORKDIS_INDEX     : Integer = 50;
    RI_ADDCONTACT_KEY       : WideString = 'addcontact';
    RI_ADDCONTACT_INDEX     : Integer = 51;
    RI_ADDCONTACTDIS_KEY    : WideString = 'addcontact_disabled';
    RI_ADDCONTACTDIS_INDEX  : Integer = 52;
    RI_DELCONTACT_KEY       : WideString = 'delcontact';
    RI_DELCONTACT_INDEX     : Integer = 53;
    RI_DELCONTACTDIS_KEY    : WideString = 'delcontact_disabled';
    RI_DELCONTACTDIS_INDEX  : Integer = 54;
    RI_SHOWONLINE_KEY       : WideString = 'showonline';
    RI_SHOWONLINE_INDEX     : Integer = 55;
    RI_SHOWONLINEDIS_KEY    : WideString = 'showonline_disabled';
    RI_SHOWONLINEDIS_INDEX  : Integer = 56;
    RI_RIGHTARROW_KEY       : WideString = 'right_arrow';
    RI_RIGHTARROW_INDEX     : Integer = 57;
    RI_LEFTARROW_KEY        : WideString = 'left_arrow';
    RI_LEFTARROW_INDEX      : Integer = 58;
    RI_JOINROOM_KEY         : WideString = 'joinroom';
    RI_JOINROOM_INDEX       : Integer = 59;
    RI_JOINROOMDIS_KEY      : WideString = 'joinroom_disabled';
    RI_JOINROOMDIS_INDEX    : Integer = 60;
    RI_EDIT_KEY             : WideString = 'edit';
    RI_EDIT_INDEX           : Integer = 61;
    RI_EDITDIS_KEY          : WideString = 'edit_disabled';
    RI_EDITDIS_INDEX        : Integer = 62;
    RI_TRASH_KEY            : WideString = 'trash';
    RI_TRASH_INDEX          : Integer = 63;
    RI_TRASHDIS_KEY         : WideString = 'trash_disabled';
    RI_TRASHDIS_INDEX       : Integer = 64;
    RI_SEARCH_KEY           : WideString = 'search';
    RI_SEARCH_INDEX         : Integer = 65;
    RI_SEARCHDIS_KEY        : WideString = 'search_disabled';
    RI_SEARCHDIS_INDEX      : Integer = 66;
    RI_BROWSER_KEY          : WideString = 'browser';
    RI_BROWSER_INDEX        : Integer = 67;
    RI_BROWSERDIS_KEY       : WideString = 'browser_disabled';
    RI_BROWSERDIS_INDEX     : Integer = 68;
    RI_PENDING_KEY          : WideString = 'pending';
    RI_PENDING_INDEX        : Integer = 69;
    RI_CHAT_TOOLBAR_BOLD_KEY        : WideString = 'chat_toolbar_bold';
    RI_CHAT_TOOLBAR_BOLD_INDEX      : Integer = 70;
    RI_CHAT_TOOLBAR_UNDERLINE_KEY   : WideString = 'chat_toolbar_underline';
    RI_CHAT_TOOLBAR_UNDERLINE_INDEX : Integer = 71;
    RI_CHAT_TOOLBAR_ITALICS_KEY     : WideString = 'chat_toolbar_italics';
    RI_CHAT_TOOLBAR_ITALICS_INDEX   : Integer = 72;
    RI_CHAT_TOOLBAR_CUT_KEY         : WideString = 'chat_toolbar_cut';
    RI_CHAT_TOOLBAR_CUT_INDEX       : Integer = 73;
    RI_CHAT_TOOLBAR_COPY_KEY        : WideString = 'chat_toolbar_copy';
    RI_CHAT_TOOLBAR_COPY_INDEX      : Integer = 74;
    RI_CHAT_TOOLBAR_PASTE_KEY       : WideString = 'chat_toolbar_paste';
    RI_CHAT_TOOLBAR_PASTE_INDEX     : Integer = 75;
    RI_CHAT_TOOLBAR_EMOTICONS_KEY   : WideString = 'chat_toolbar_emoticons';
    RI_CHAT_TOOLBAR_EMOTICONS_INDEX : Integer = 76;
    RI_CHAT_TOOLBAR_HOTKEYS_KEY     : WideString = 'chat_toolbar_hotkeys';
    RI_CHAT_TOOLBAR_HOTKEYS_INDEX   : Integer = 77;
    RI_PREFS_KEY            : WideString = 'prefs';
    RI_PREFS_INDEX          : Integer = 78;
    RI_DISCONNECT_KEY       : Widestring = 'disconnect';
    RI_DISCONNECT_INDEX     : Integer = 79;
    RI_CONNECT_KEY          : Widestring = 'connect';
    RI_CONNECT_INDEX        : Integer = 80;
    RI_DOCK_KEY             : WideString = 'dock';
    RI_DOCK_INDEX           : Integer = 81;
    RI_UNDOCK_KEY           : Widestring = 'undock';
    RI_UNDOCK_INDEX         : Integer = 82;
    RI_CLOSETAB_KEY         : Widestring = 'closetab';
    RI_CLOSETAB_INDEX       : Integer = 83;
    RI_CHATBAR_COLORS_KEY   : Widestring = 'chatbar_colors';
    RI_CHATBAR_COLORS_INDEX : Integer = 84;
    RI_OBSERVER_KEY         : Widestring = 'observer';
    RI_OBSERVER_INDEX       : Integer = 85;
    RI_ARROWDOWN_KEY        : Widestring = 'arrow_down';
    RI_ARROWDOWN_INDEX      : Integer = 86;
    RI_ARROWUP_KEY          : Widestring = 'arrow_up';
    RI_ARROWUP_INDEX        : Integer = 87;
    RI_SHOWAW_KEY           : Widestring = 'show_activity_window';
    RI_SHOWAW_INDEX         : Integer = 88;
    RI_SHOWROSTER_KEY       : Widestring = 'show_roster';
    RI_SHOWROSTER_INDEX     : Integer = 89;
    RI_TEMP_CONFERENCE_KEY  : WideString = 'temp_conference';
    RI_TEMP_CONFERENCE_INDEX: Integer = 90;
    RI_FOLDER_OPEN_KEY      : Widestring = 'folder_open';
    RI_FOLDER_OPEN_INDEX    : Integer = 91;
    RI_FOLDER_CLOSED_KEY    : Widestring = 'folder_closed';
    RI_FOLDER_CLOSED_INDEX  : Integer = 92;
    RI_CONTACTS_TAB_KEY     : Widestring = 'contacts_tab';
    RI_CONTACTS_TAB_INDEX   : Integer = 93;
    RI_ROOMS_TAB_KEY        : Widestring = 'rooms_tab';
    RI_ROOMS_TAB_INDEX      : Integer = 94;
    RI_MAIN_TAB_KEY         : Widestring = 'main_tab';
    RI_MAIN_TAB_INDEX       : Integer = 95;
    RI_VIEW_HISTORY_KEY     : Widestring = 'view_history';
    RI_VIEW_HISTORY_INDEX   : Integer = 96;
    RI_NOT_JOINED_KEY     : Widestring = 'not_joined_member';
    RI_NOT_JOINED_INDEX   : Integer = 97;

{$ENDIF}

function GetPresenceImage(Show: Widestring; Prefix:WideString): integer;

var
    RosterTreeImages: TRosterImages;

implementation

procedure TRosterImages.createDefaultIDs();
var
    _ids : TWidestringList;
begin
{$IFDEF EXODUS}
    _ids := TWideStringList.Create();
    _ids.Insert(RI_OFFLINE_INDEX, RI_OFFLINE_KEY);
    _ids.Insert(RI_AVAILABLE_INDEX, RI_AVAILABLE_KEY);
    _ids.Insert(RI_AWAY_INDEX, RI_AWAY_KEY);
    _ids.Insert(RI_DND_INDEX, RI_DND_KEY);
    _ids.Insert(RI_CHAT_INDEX, RI_CHAT_KEY);
    _ids.Insert(RI_FULLFOLDER_INDEX, RI_FULLFOLDER_KEY);
    _ids.Insert(RI_UNKNOWN_INDEX, RI_UNKNOWN_KEY);
    _ids.Insert(RI_MULTIPLE_INDEX, RI_MULTIPLE_KEY);
    _ids.Insert(RI_CLOSEDFOLDER_INDEX, RI_CLOSEDFOLDER_KEY);
    _ids.Insert(RI_OPENFOLDER_INDEX, RI_OPENFOLDER_KEY);
    _ids.Insert(RI_XA_INDEX, RI_XA_KEY);
    _ids.Insert(RI_HEADLINE_INDEX, RI_HEADLINE_KEY);
    _ids.Insert(RI_INFO_INDEX, RI_INFO_KEY);
    _ids.Insert(RI_BOOK_INDEX, RI_BOOK_KEY);
    _ids.Insert(RI_REPLY_INDEX, RI_REPLY_KEY);
    _ids.Insert(RI_NOTE_INDEX, RI_NOTE_KEY);
    _ids.Insert(RI_KEYOLD_INDEX, RI_KEYOLD_KEY);
    _ids.Insert(RI_FLOWCHART_INDEX, RI_FLOWCHART_KEY);
    _ids.Insert(RI_NEWSITEM_INDEX, RI_NEWSITEM_KEY);
    _ids.Insert(RI_IMAGE_INDEX, RI_IMAGE_KEY);
    _ids.Insert(RI_CONTACT_INDEX, RI_CONTACT_KEY);
    _ids.Insert(RI_CONFERENCE_INDEX, RI_CONFERENCE_KEY);
    _ids.Insert(RI_SERVICE_INDEX, RI_SERVICE_KEY);
    _ids.Insert(RI_NEWITEM_INDEX, RI_NEWITEM_KEY);
    _ids.Insert(RI_KEY_INDEX, RI_KEY_KEY);
    _ids.Insert(RI_FILTER_INDEX, RI_FILTER_KEY);
    _ids.Insert(RI_CONTACTFOLDER_INDEX, RI_CONTACTFOLDER_KEY);
    _ids.Insert(RI_OPENGROUP_INDEX, RI_OPENGROUP_KEY);
    _ids.Insert(RI_CLOSEDGROUP_INDEX, RI_CLOSEDGROUP_KEY);
    _ids.Insert(RI_RIGHT_INDEX, RI_RIGHT_KEY);
    _ids.Insert(RI_LEFT_INDEX, RI_LEFT_KEY);
    _ids.Insert(RI_WARN_INDEX, RI_WARN_KEY);
    _ids.Insert(RI_ERROR_INDEX, RI_ERROR_KEY);
    _ids.Insert(RI_OFFLINEATTN_INDEX, RI_OFFLINEATTN_KEY);
    _ids.Insert(RI_AVAILABLEATTN_INDEX, RI_AVAILABLEATTN_KEY);
    _ids.Insert(RI_AWAYATTN_INDEX, RI_AWAYATTN_KEY);
    _ids.Insert(RI_DNDATTN_INDEX, RI_DNDATTN_KEY);
    _ids.Insert(RI_CHATATTN_INDEX, RI_CHATATTN_KEY);
    _ids.Insert(RI_XAATTN_INDEX, RI_XAATTN_KEY);
    _ids.Insert(RI_ONLINEBLOCKED_INDEX, RI_ONLINEBLOCKED_KEY);
    _ids.Insert(RI_DELETE_INDEX, RI_DELETE_KEY);
    _ids.Insert(RI_OFFLINEBLOCKED_INDEX, RI_OFFLINEBLOCKED_KEY);
    _ids.Insert(RI_ATTN_INDEX, RI_ATTN_KEY);
    _ids.Insert(RI_APPIMAGE_INDEX, RI_APPIMAGE_KEY);
    _ids.Insert(RI_AVAILNEG_INDEX, RI_AVAILNEG_KEY);
    _ids.Insert(RI_AWAYNEG_INDEX, RI_AWAYNEG_KEY);
    _ids.Insert(RI_DNDNEG_INDEX, RI_DNDNEG_KEY);
    _ids.Insert(RI_CHATNEG_INDEX, RI_CHATNEG_KEY);
    _ids.Insert(RI_XANEG_INDEX, RI_XANEG_KEY);
    _ids.Insert(RI_NETWORK_INDEX, RI_NETWORK_KEY);
    _ids.Insert(RI_NETWORKDIS_INDEX, RI_NETWORKDIS_KEY);
    _ids.Insert(RI_ADDCONTACT_INDEX, RI_ADDCONTACT_KEY);
    _ids.Insert(RI_ADDCONTACTDIS_INDEX, RI_ADDCONTACTDIS_KEY);
    _ids.Insert(RI_DELCONTACT_INDEX, RI_DELCONTACT_KEY);
    _ids.Insert(RI_DELCONTACTDIS_INDEX, RI_DELCONTACTDIS_KEY);
    _ids.Insert(RI_SHOWONLINE_INDEX, RI_SHOWONLINE_KEY);
    _ids.Insert(RI_SHOWONLINEDIS_INDEX, RI_SHOWONLINEDIS_KEY);
    _ids.Insert(RI_RIGHTARROW_INDEX, RI_RIGHTARROW_KEY);
    _ids.Insert(RI_LEFTARROW_INDEX, RI_LEFTARROW_KEY);
    _ids.Insert(RI_JOINROOM_INDEX, RI_JOINROOM_KEY);
    _ids.Insert(RI_JOINROOMDIS_INDEX, RI_JOINROOMDIS_KEY);
    _ids.Insert(RI_EDIT_INDEX, RI_EDIT_KEY);
    _ids.Insert(RI_EDITDIS_INDEX, RI_EDITDIS_KEY);
    _ids.Insert(RI_TRASH_INDEX, RI_TRASH_KEY);
    _ids.Insert(RI_TRASHDIS_INDEX, RI_TRASHDIS_KEY);
    _ids.Insert(RI_SEARCH_INDEX, RI_SEARCH_KEY);
    _ids.Insert(RI_SEARCHDIS_INDEX, RI_SEARCHDIS_KEY);
    _ids.Insert(RI_BROWSER_INDEX, RI_BROWSER_KEY);
    _ids.Insert(RI_BROWSERDIS_INDEX, RI_BROWSERDIS_KEY);
    _ids.Insert(RI_PENDING_INDEX, RI_PENDING_KEY);
    _ids.Insert(RI_CHAT_TOOLBAR_BOLD_INDEX, RI_CHAT_TOOLBAR_BOLD_KEY);
    _ids.Insert(RI_CHAT_TOOLBAR_UNDERLINE_INDEX, RI_CHAT_TOOLBAR_UNDERLINE_KEY);
    _ids.Insert(RI_CHAT_TOOLBAR_ITALICS_INDEX, RI_CHAT_TOOLBAR_ITALICS_KEY);
    _ids.Insert(RI_CHAT_TOOLBAR_CUT_INDEX, RI_CHAT_TOOLBAR_CUT_KEY);
    _ids.Insert(RI_CHAT_TOOLBAR_COPY_INDEX, RI_CHAT_TOOLBAR_COPY_KEY);
    _ids.Insert(RI_CHAT_TOOLBAR_PASTE_INDEX, RI_CHAT_TOOLBAR_PASTE_KEY);
    _ids.Insert(RI_CHAT_TOOLBAR_EMOTICONS_INDEX,RI_CHAT_TOOLBAR_EMOTICONS_KEY);
    _ids.Insert(RI_CHAT_TOOLBAR_HOTKEYS_INDEX, RI_CHAT_TOOLBAR_HOTKEYS_KEY);
    _ids.Insert(RI_PREFS_INDEX, RI_PREFS_KEY);
    _ids.Insert(RI_DISCONNECT_INDEX, RI_DISCONNECT_KEY);
    _ids.Insert(RI_CONNECT_INDEX, RI_CONNECT_KEY);
    _ids.Insert(RI_DOCK_INDEX, RI_DOCK_KEY);
    _ids.Insert(RI_UNDOCK_INDEX, RI_UNDOCK_KEY);
    _ids.Insert(RI_CLOSETAB_INDEX, RI_CLOSETAB_KEY);
    _ids.Insert(RI_CHATBAR_COLORS_INDEX, RI_CHATBAR_COLORS_KEY);
    _ids.Insert(RI_OBSERVER_INDEX, RI_OBSERVER_KEY);
    _ids.Insert(RI_ARROWDOWN_INDEX, RI_ARROWDOWN_KEY);
    _ids.Insert(RI_ARROWUP_INDEX, RI_ARROWUP_KEY);
    _ids.Insert(RI_SHOWAW_INDEX, RI_SHOWAW_KEY);
    _ids.Insert(RI_SHOWROSTER_INDEX, RI_SHOWROSTER_KEY);
    _ids.Insert(RI_TEMP_CONFERENCE_INDEX, RI_TEMP_CONFERENCE_KEY);
    _ids.Insert(RI_FOLDER_OPEN_INDEX, RI_FOLDER_OPEN_KEY);
    _ids.Insert(RI_FOLDER_CLOSED_INDEX, RI_FOLDER_CLOSED_KEY);    
    _ids.Insert(RI_CONTACTS_TAB_INDEX, RI_CONTACTS_TAB_KEY);
    _ids.Insert(RI_ROOMS_TAB_INDEX, RI_ROOMS_TAB_KEY);
    _ids.Insert(RI_MAIN_TAB_INDEX, RI_MAIN_TAB_KEY);
    _ids.Insert(RI_VIEW_HISTORY_INDEX, RI_VIEW_HISTORY_KEY);
    _ids.Insert(RI_NOT_JOINED_INDEX, RI_NOT_JOINED_KEY);
    setDefaultIDs(_ids);
{$ENDIF}
end;

function GetPresenceImage(Show: Widestring; Prefix:WideString): integer;
begin
    if (Show = 'offline') then
        Result := RosterTreeImages.Find(Prefix + 'offline')
    else if (Show = 'away') then
        Result := RosterTreeImages.Find(Prefix + 'away')
    else if (Show = 'xa') then
        Result := RosterTreeImages.Find(Prefix + 'xa')
    else if (Show = 'dnd') then
        Result := RosterTreeImages.Find(Prefix + 'dnd')
    else if (Show = 'chat') then
        Result := RosterTreeImages.Find(Prefix + 'chat')
    else if (Show = 'pending') then
        Result := RosterTreeImages.Find(Prefix + 'pending')
    else if (Show = 'online_blocked') then
        Result := RosterTreeImages.Find(Prefix + 'online_blocked')
    else if (Show = 'offline_blocked') then
        Result := RosterTreeImages.Find(Prefix + 'offline_blocked')
    else if (Show = 'observer') then
        Result := RosterTreeImages.Find(Prefix + 'observer')
    else
        Result := RosterTreeImages.Find(Prefix + 'available');
end;

initialization
    RosterTreeImages := TRosterImages.Create(IMAGE_LIST_ID_ROSTER);

finalization
    RosterTreeImages.Free();
end.
