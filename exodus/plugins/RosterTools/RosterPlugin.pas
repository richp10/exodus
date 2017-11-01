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
unit RosterPlugin;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Exodus_TLB, Import,
    ComObj, ActiveX, ExRosterTools_TLB, StdVcl;

type
  TRosterPlugin = class(TAutoObject, IExodusPlugin, IExodusMenuListener)
  protected
    function onInstantMsg(const Body, Subject: WideString): WideString;
      safecall;
    procedure Configure; safecall;
    procedure NewChat(const jid: WideString; const Chat: IExodusChat);
      safecall;
    procedure NewRoom(const jid: WideString; const Room: IExodusChat);
      safecall;
    procedure Process(const xpath, event, xml: WideString); safecall;
    procedure Shutdown; safecall;
    procedure Startup(const ExodusController: IExodusController); safecall;
    function NewIM(const jid: WideString; var Body, Subject: WideString;
      const XTags: WideString): WideString; safecall;
    procedure NewOutgoingIM(const jid: WideString;
      const InstantMsg: IExodusChat); safecall;
        //IExodusMenuListener
    procedure OnMenuItemClick(const menuID : WideString; const xml : WideString); safecall;
  private
    _exodus: IExodusController;
    _import: Widestring;
    _export: Widestring;

  end;

implementation

uses ComServ, Unicode, XMLTag;

function TRosterPlugin.onInstantMsg(const Body,
  Subject: WideString): WideString;
begin

end;

procedure TRosterPlugin.Configure;
begin

end;

procedure TRosterPlugin.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

procedure TRosterPlugin.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

procedure TRosterPlugin.Process(const xpath, event, xml: WideString);
begin

end;

procedure TRosterPlugin.Shutdown;
begin
    _exodus.removePluginMenu(_import);
    _exodus.removePluginMenu(_export);
    _export := '';
    _import := '';
end;

procedure TRosterPlugin.Startup(const ExodusController: IExodusController);
begin
    _exodus := ExodusController;
    _export := _exodus.addPluginMenu('Export Jabber Roster...', Self);
    _import := _exodus.addPluginMenu('Import Jabber Roster...', Self);
end;

function TRosterPlugin.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

procedure TRosterPlugin.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin

end;

//IExodusMenuListener
procedure TRosterPlugin.OnMenuItemClick(const menuID : WideString; const xml : WideString);
var
    fImport: TfrmImport;
    sl: TWidestringlist;
    doc, item: TXMLTag;
    r: IExodusRoster;
    ri: IExodusRosterItem;
    i: integer;
    grp: Widestring;
begin
    if (menuID = _export) then begin
        fImport := TfrmImport.Create(nil);
        if (fImport.SaveDialog1.Execute()) then begin
            r := _exodus.Roster;
            doc := TXMLTag.Create('exodus-roster');
            for i := 0 to r.Count - 1 do begin
                ri := r.Item(i);
                item := doc.AddTag('item');
                item.setAttribute('jid', ri.JabberID);
                item.setAttribute('name', ri.nickname);
                grp := ri.Group(0);
                if (grp <> '') then
                    item.AddBasicTag('group', grp);
            end;

            sl := TWidestringlist.Create();
            sl.Add(doc.xml);
            sl.SaveToFile(fImport.SaveDialog1.Filename);
            sl.Free();
            fImport.Free();
        end;
    end
    else if (menuID = _import) then begin
        fImport := TfrmImport.Create(nil);
        if (not fImport.OpenDialog1.Execute()) then begin
            fImport.Free();
            exit;
        end;

        fImport.ImportFile(_exodus, fImport.OpenDialog1.FileName);
    end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRosterPlugin, Class_RosterPlugin,
    ciMultiInstance, tmApartment);


end.
