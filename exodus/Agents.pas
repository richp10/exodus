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
unit Agents;


interface
uses
    XMLTag,
    JabberID,
    Signals,
    SysUtils, Classes;

type
    TAgentItem = class
    public
        name: string;
        jid: string;
        desc: string;
        service: string;
        search: boolean;
        reg: boolean;
        groupchat: boolean;
        transport: boolean;

        constructor Create;
        procedure parse(agent: TXMLTag);
end;

    TAgents = class(TStringList)
    private
        jid: string;
        procedure FetchCallback(event: string; tag: TXMLTag);
    public
        procedure Fetch(from: string);
        procedure ParseList(iq: TXMLTag);
        procedure Clear; override;

        function getAgent(i: integer): TAgentItem;
        function getFirstSearch: string;
        function getFirstGroupChat: string;
        function findService(svc: string): TAgentItem;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Session,
    IQ;

constructor TAgentItem.Create;
begin
    name := '';
    jid := '';
    desc := '';
    service := '';
    reg := false;
    groupchat := false;
    transport := false;
end;

{---------------------------------------}
procedure TAgentItem.parse(agent: TXMLTag);
begin
    {
    parse the agent tag
    <agent jid='users.jabber.org'>
        <name>Jabber User Directory</name>
        <service>jud</service>
        <search/>
        <register/>
    </agent><
    }

    name := agent.GetBasicText('name');
    jid := agent.GetAttribute('jid');
    desc := agent.GetBasicText('description');
    service := agent.GetBasicText('service');

    reg := (agent.GetFirstTag('register') <> nil);
    groupchat := (agent.GetFirstTag('groupchat') <> nil);
    transport := (agent.GetFirstTag('transport') <> nil);
    search := (agent.GetFirstTag('search') <> nil);
end;

{---------------------------------------}
procedure TAgents.ParseList(iq: TXMLTag);
var
    cur: TAgentItem;
    ag_list: TXMLTagList;
    i: integer;
begin
    // parse the entire list of agent items
    ag_list := iq.QueryXPTags('/iq/query/agent');
    for i := 0 to ag_list.Count - 1 do begin
        cur := TAgentItem.Create();
        cur.parse(ag_list[i]);
        self.AddObject(cur.jid, cur);
    end;
    MainSession.FireEvent('/session/agents', iq);
end;

{---------------------------------------}
procedure TAgents.Fetch(from: string);
var
    iq: TJabberIQ;
begin
    // fetch the agents list from this specific jid
    self.jid := from;
    iq := TJabberIQ.Create(MainSession, MainSession.generateID(), FetchCallback);
    iq.iqType := 'get';
    iq.Namespace := XMLNS_AGENTS;
    iq.toJid := from;
    iq.Send;
end;

{---------------------------------------}
procedure TAgents.FetchCallback(event: string; tag: TXMLTag);
begin
    // callback from the iq
    if event = 'xml' then
        ParseList(tag);
end;

{---------------------------------------}
procedure TAgents.Clear;
var
    a: TAgentItem;
    i: integer;
begin
    for i := Self.Count - 1 downto 0 do begin
        a := TAgentItem(Objects[i]);
        if (a <> nil) then a.Free;
    end;

    inherited Clear;
end;

{---------------------------------------}
function TAgents.getFirstSearch: string;
var
    i: integer;
    a: TAgentItem;
begin
    for i := 0 to Self.Count - 1 do begin
        a := TAgentItem(Self.Objects[i]);
        if a.search then begin
            Result := a.jid;
            exit;
        end;
    end;

    Result := '';
end;

{---------------------------------------}
function TAgents.getFirstGroupChat: string;
var
    i: integer;
    a: TAgentItem;
begin
    for i := 0 to Self.Count - 1 do begin
        a := TAgentItem(Self.Objects[i]);
        if a.groupchat then begin
            Result := a.jid;
            exit;
        end;
    end;

    Result := '';
end;

{---------------------------------------}
function TAgents.findService(svc: string): TAgentItem;
var
    i: integer;
    a: TAgentItem;
begin
    Result := nil;
    for i := 0 to Self.Count - 1 do begin
        a := TAgentItem(Self.Objects[i]);
        if (a.service = svc) then begin
            Result := a;
            exit;
        end;
    end;
end;

{---------------------------------------}
function TAgents.getAgent(i: integer): TAgentItem;
begin
    if (i >= 0) and (i < Self.Count) then
        Result := TAgentItem(Objects[i])
    else
        Result := nil;
end;



end.
