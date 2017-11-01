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
unit Tester;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    XMLParser,
    ComObj, ActiveX, Exodus_TLB, TestPlugin_TLB, StdVcl;

type
  TTesterPlugin = class(TAutoObject, IExodusPlugin, IExodusMenuListener)
  protected
    function NewIM(const jid: WideString; var Body, Subject: WideString;
      const XTags: WideString): WideString; safecall;
    procedure Configure; safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewOutgoingIM(const jid: WideString;
      const InstantMsg: IExodusChat); safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;
    //IExodusMenuListener
    procedure OnMenuItemClick(const menuID : WideString; const xml : WideString); safecall;
  private
    _exodus: IExodusController;
    _session: integer;
    _roster: integer;
//    _menu_id: Widestring;
//    _menu1: Widestring;
//    _menu2: Widestring;
    _parser: TXMLTagParser;

  end;

implementation

uses
    XMLTag, Graphics, Dialogs, ComServ;

function TTesterPlugin.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

procedure TTesterPlugin.Configure;
begin

end;

procedure TTesterPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
var
    c: IExodusControl;
    p: IExodusControlPanel;
begin
    c := Chat.GetControl('pnlMsglist');
    if ((c <> nil) and (c.ControlType = ExodusControlPanel)) then begin
        p := (c as IExodusControlPanel);
        p.BorderWidth := 5;
        p.Color := clRed;
    end;
end;

procedure TTesterPlugin.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin

end;

procedure TTesterPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

procedure TTesterPlugin.Process(const xpath, event, xml: WideString);
var
    j: Widestring;
    grp: IExodusRosterGroup;
    ri: IExodusRosterItem;
    tag: TXMLTag;
begin

    if (event = '/session/authenticated') then begin
        // create a new roster item
        grp := _exodus.Roster.addGroup('System Help');
        grp.SortPriority := 50;
        grp.DragTarget := false;
        grp.DragSource := false;
        grp.KeepEmpty := false;
        grp.ShowPresence := false;
        grp.AutoExpand := true;

        ri := _exodus.Roster.AddItem('admin@jabber.org');
        ri.addGroup('System Help');
        ri.ContextMenuID := 'Tester_menu1';
        ri.InlineEdit := false;
        ri.IsContact := false;
        ri.setCleanGroups();
        ri.fireChange();
    end
    else if (event = '/roster/item') then begin
        _parser.ParseString(xml, '');
        if (_parser.Count > 0) then begin
            tag := _parser.popTag();
            j := tag.getAttribute('jid');
            (*
            if (j = 'bubba1@dustpuppy.corp.jabber.com') then begin
                ri := _exodus.Roster.Find(j);
                if (ri.ImagePrefix <> 'aim_') then begin
                    ri.ImagePrefix := 'aim_';
                    ri.fireChange();
                end;
            end;
            *)
        end
    end
    else if (event = '/session/gui/test1') then begin
        MessageDlg('event handler inside plugin', mtInformation, [mbOK], 0);
    end;

end;

procedure TTesterPlugin.Shutdown;
begin

end;

procedure TTesterPlugin.Startup(const ExodusController: IExodusController);
(*
var
    bmp: TBitmap;
*)
begin
    _parser := TXMLTagParser.Create();

    _exodus := ExodusController;
    _session := _exodus.RegisterCallback('/session', Self);
    _roster := _exodus.RegisterCallback('/roster/item', Self);
{
    _exodus.Roster.AddContextMenu('Tester_menu1');

    _menu_id := _exodus.Roster.addContextMenuItem('Tester_menu1', 'Foobar',
        '/session/gui/test1', Self);

    _menu1 := _exodus.addPluginMenu('Test TrackIQ', Self);
    _menu2 := _exodus.addPluginMenu('Test FireEvent', Self);
}
    (*
    bmp := TBitamp.Create();
    bmp.LoadFromFile();
    *)

    (*
    _exodus.RosterImages.AddImageFilename('aim_available', 'd:\src\exodus\exodus\plugins\test\online.bmp');
    _exodus.RosterImages.AddImageFilename('aim_chat', 'd:\src\exodus\exodus\plugins\test\online.bmp');
    _exodus.RosterImages.AddImageFilename('aim_away', 'd:\src\exodus\exodus\plugins\test\online.bmp');
    _exodus.RosterImages.AddImageFilename('aim_xa', 'd:\src\exodus\exodus\plugins\test\online.bmp');
    _exodus.RosterImages.AddImageFilename('aim_dnd', 'd:\src\exodus\exodus\plugins\test\online.bmp');
    _exodus.RosterImages.AddImageFilename('aim_offline', 'd:\src\exodus\exodus\plugins\test\offline.bmp');
    *)
end;

//IExodusMenuListener
//JJF 8/25/06 We lost the type lib for TTesterIQCallback somewhere, commenting
//out for right now to get good compiles
procedure TTesterPlugin.OnMenuItemClick(const menuID : WideString; const xml : WideString);
{var

    cb: TTesterIQCallback;
    iqid, txml: Widestring;
    jid: string;
}
begin
{
    if (menuID = _menu1) then begin
        // test TrackIQ()
        jid := 'pgmillard@jabber.org';
        if (InputQuery('vCard lookup', 'Enter JID', jid)) then begin
            txml := '<iq type="get" to="' + jid + '"><vCard xmlns="vcard-temp"/></iq>';
            cb := TTesterIQCallback.Create();
            iqid := _exodus.TrackIQ(txml, cb, 60);
        end;
    end
    else if (menuID = _menu2) then begin
        // test FireEvent()
        _exodus.FireEvent('/data/debug', '', 'Some debug message');
    end;
    }
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTesterPlugin, Class_TesterPlugin,
    ciMultiInstance, tmApartment);
end.
