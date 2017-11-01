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
unit COMExodusPacketDispatcher;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    Signals, Unicode, XMLTag, XMLStream,
    ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusPacketDispatcher = class(TAutoObject, IExodusPacketDispatcher)
  private
    _listenersByXPath: TWidestringList;
    _streamreadyCB: integer;
  protected
    procedure PacketControlCallback(direction: TPacketDirection;
                                    const inPacket: TXMLTag;
                                    var outPacket: TXMLTag;
                                    var allow: WordBool);

    procedure SessionListenerCallback(event: string; tag: TXMLTag);
  public
    Destructor Destroy(); override;

    procedure RegisterPacketControlListener(const xpath: WideString;
      const listener: IExodusPacketControlListener); safecall;
    procedure UnregisterPacketControlListener(const xpath: WideString;
      const listener: IExodusPacketControlListener); safecall;

    procedure Initialize();override;
  end;

implementation

uses Session, Classes, SysUtils, ComServ;

type
    TPacketListener = class
    private
        _xp: TXPLite;
        _xpStr: widestring;
        _listeners: TInterfaceList;
        _listUpdated: boolean;
        _currentList: TInterfaceList;
        
        function GetListeners(): TInterfaceList;
    public
        constructor Create(xpStr: widestring);
        destructor Destroy(); override;

        function IsMatch(tag: TXMLtag): boolean;

        procedure AddListener(listener: IExodusPacketControlListener);
        procedure RemoveListener(listener: IExodusPacketControlListener);

        property Listeners: TInterfaceList read GetListeners;
    end;

constructor TPacketListener.Create(xpStr: widestring);
begin
    _xp := TXPLite.Create;
    _xpStr := Trim(xpStr);
    _xp.Parse(xpStr);

    _listeners := TInterfaceList.create();
    _currentList := TInterfaceList.create();
    _listUpdated := false;
end;

destructor TPacketListener.Destroy();
begin
    _xp.free();
    _listeners.Free();
    _currentList.Free();
end;

function TPacketListener.GetListeners(): TInterfaceList;
var
    i: integer;
begin
    //update current list if needed
    if (_listUpdated) then
    begin
        _currentList.Clear();
        for i := 0 to _listeners.Count - 1 do
            _currentList.Add(_listeners[i]);
        _listUpdated := false;
    end;
    Result := _currentList;
end;

function TPacketListener.IsMatch(tag: TXMLtag): boolean;
begin
    Result :=  (_listeners.count > 0) and ((_xpStr = '<ALL>') or _xp.Compare(tag));
end;

procedure TPacketListener.AddListener(listener: IExodusPacketControlListener);
begin
    _listeners.Add(listener);
    _listUpdated := true;
end;

procedure TPacketListener.RemoveListener(listener: IExodusPacketControlListener);
begin
    _listeners.remove(listener);
    _listUpdated := true;
end;

Destructor TExodusPacketDispatcher.Destroy();
begin
    _listenersByXPath.free(); //free objects at some poitn
end;

procedure TExodusPacketDispatcher.Initialize();
begin
    inherited;
    _listenersByXPath := TWidestringlist.create();

    _streamreadyCB := Session.MainSession.RegisterCallback(SessionListenerCallback, '/session/stream/ready');
end;

procedure TExodusPacketDispatcher.SessionListenerCallback(event: string; tag: TXMLTag);
begin
    if (event = '/session/stream/ready') then
        Session.MainSession.Stream.RegisterPacketControlCallback(PacketControlCallback)
end;

procedure TExodusPacketDispatcher.RegisterPacketControlListener(
  const xpath: WideString; const listener: IExodusPacketControlListener);
var
    idx : integer;
    tpl: TPacketListener;
    s: widestring;
begin
    s := xpath;
    if (s = '') then s := '<ALL>';

    idx := _listenersByXPath.IndexOf(s);
    if (idx <> -1) then
        tpl := TPacketListener(_listenersByXPath.objects[idx])
    else begin
        tpl := TPacketListener.Create(s);
        _listenersByXPath.AddObject(s, tpl);
    end;
    tpl.AddListener(listener);
end;

procedure TExodusPacketDispatcher.UnregisterPacketControlListener(
  const xpath: WideString; const listener: IExodusPacketControlListener);
var
    idx : integer;
    tpl: TPacketListener;
    s: widestring;
begin
    s := xpath;
    if (s = '') then s := '<ALL>';

    idx := _listenersByXPath.IndexOf(s);
    if (idx <> -1) then
    begin
        tpl := TPacketListener(_listenersByXPath.objects[idx]);
        tpl.RemoveListener(listener);
    end;
end;

procedure TExodusPacketDispatcher.PacketControlCallback(direction: TPacketDirection;
                                                        const inPacket: TXMLTag;
                                                        var outPacket: TXMLTag;
                                                        var allow: WordBool);
var
    i, j: integer;
    inXML, modXML : IExodusEventXML;
    l: TPacketListener;
    ListenerList: TInterfaceList;
    setMod: boolean;
    xpath: widestring;
begin
    outPacket := nil;
    Allow := true;
    setMod := false;

    inXML := CoExodusEventXML.Create() as IExodusEventXML;
    inXML.SetTag(Integer(inPacket)); //copies packet, inXML owns its copy

    modXML := CoExodusEventXML.Create() as IExodusEventXML;

    try
        //walk xpath list and fire listeners until not allowed or done
        for i := 0 to _listenersByXPath.Count - 1 do
        begin
            l :=  TPacketListener(_listenersByXPath.Objects[i]);
            xpath := l._xpStr;
            if (xpath = '<ALL>') then
                xpath := '';
            if l.IsMatch(TXMLtag(Pointer(inXML.GetTag()))) then
            begin
                ListenerList := TPacketListener(_listenersByXPath.Objects[i]).Listeners;
                for j := 0 to ListenerList.Count - 1 do
                begin
                    if (direction = pdInbound) then
                        IExodusPacketControlListener(ListenerList[j]).OnPacketReceived(xpath, InXML, modXML, allow)
                    else
                        IExodusPacketControlListener(ListenerList[j]).OnPacketSent(xpath, inXML, modXML, allow);

                    if (not allow) then exit;

                    if (modXML.GetTag <> 0) then
                    begin
                        setMod := true;
                        inXML.SetTag(modXML.GetTag);  //set makes a copy
                        modXML.SetTag(0); //nil
                        //check to see if changed tag still matches xpath
                        if (not l.IsMatch(TXMLtag(Pointer(inXML.GetTag())))) then break;
                    end;
                end;
            end;
        end;

        if (setMod) then
            outPacket := TXMLtag.create(TXMLtag(Pointer(inXML.GetTag())));
    finally
        inXML := nil;
        modXML := nil;
    end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusPacketDispatcher, Class_ExodusPacketDispatcher,
    ciMultiInstance, tmApartment);
end.
