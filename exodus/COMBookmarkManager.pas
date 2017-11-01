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
unit COMBookmarkManager;


interface

uses
  COMObj,ActiveX, Exodus_TLB, StdVcl, SysUtils;

type
  TExodusBookmarkManager = class(TAutoObject, IExodusBookmarkManager)
  protected
    function FindBookmark(const JabberID: WideString): WideString; safecall;
    procedure AddBookmark(const JabberID, bmName, Nickname: WideString; AutoJoin,
      UseRegisteredNick: WordBool); safecall;
    procedure RemoveBookmark(const JabberID: WideString); safecall;
    private

    public
      constructor Create();
  end;

implementation
uses
  ComServ, XMLTag, Session;

{-----------------------------------------------}
constructor TExodusBookmarkManager.Create();
begin
end;

{----------------------------------------------}
procedure TExodusBookmarkManager.AddBookmark(const JabberID, bmName,
  Nickname: WideString; AutoJoin, UseRegisteredNick: WordBool);
begin
    MainSession.rooms.AddRoom(JabberID, bmName, Nickname, AutoJoin, UseRegisteredNick, nil);
end;

{-----------------------------------------------}
procedure TExodusBookmarkManager.RemoveBookmark(const JabberID: WideString);
begin
    MainSession.rooms.RemoveRoom(JabberID);
end;

{------------------------------------------------}
function TExodusBookmarkManager.FindBookmark(const JabberID: WideString): WideString;
var
    item: IExodusItem;
    bmTag: TXMLTag;
    prop: Widestring;
    idx: Integer;
begin
    item := MainSession.ItemController.GetItem(JabberID);
    Result := '';
    if (item <> nil) and (item.Type_ = 'room') then begin
        bmTag := TXMLTag.Create('conference');
        bmTag.setAttribute('jid', item.UID);

        prop := item.value['name'];
        if (prop <> '') then bmTag.setAttribute('name', prop);
        
        prop := item.value['autojoin'];
        if (prop <> '') then bmTag.setAttribute('autojoin', prop);

        prop := item.value['reg_nick'];
        if (prop <> '') then bmTag.setAttribute('reg_nick', prop);

        prop := item.value['nick'];
        if (prop <> '') then bmTag.AddBasicTag('nick', prop);

        prop := item.value['password'];
        if (prop <> '') then bmtag.AddBasicTag('password', prop);
        
        for idx := 0 to item.GroupCount - 1 do begin
            with bmTag.AddTagNS('group', 'http://jabber.com/protocols') do begin
                AddCData(item.Group[idx]);
            end;
        end;
    end;
end;

{-------------------------------------}

initialization
  TAutoObjectFactory.Create(ComServer, TExodusBookmarkManager, CLASS_ExodusBookmarkManager,
    ciMultiInstance, tmApartment);

end.
