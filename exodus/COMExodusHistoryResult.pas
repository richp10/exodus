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
unit COMExodusHistoryResult;

{$WARN SYMBOL_PLATFORM OFF}


interface

uses
    ComObj,
    ActiveX,
    Exodus_TLB,
    StdVcl,
    Unicode,
    JabberMsg,
    XMLParser;

type
    TInternalResultCallback = procedure(msg: TJabberMessage) of object;

    TExodusHistoryResult = class(TAutoObject, IExodusHistoryResult)
        private
            // Variables
            _processing: boolean;
            _ResultList: TWidestringList;
            _parser: TXMLTagParser;

            // Methods

        protected
            // Variables

            // Methods

            // IExodusHistoryResult Interface
            function Get_ResultCount: Integer; safecall;
            function Get_Processing: WordBool; safecall;
    procedure OnResultItem(SearchHandlerID: Integer; const SearchID: WideString;
      const Item: IExodusMsg); safecall;
    function GetResult(index: Integer): IExodusMsg; safecall;
            procedure Set_Processing(Value: WordBool); safecall;
            property ResultCount: Integer read Get_ResultCount;
            property Processing: WordBool read Get_Processing write Set_Processing;
        public
            // Variables

            // Methods
            procedure Initialize(); override;
            destructor Destroy(); override;

            // Properties
    end;

    TExodusHistoryResultCallbackItem = class
        private
            // Variables

            // Methods
        protected
            // Variables

            // Methods
        public
            // Variables
            cb: TInternalResultCallback;
            ResultObj: TExodusHistoryResult;
            StoreResultWithCallbackSpecified: boolean;

            // Methods
    end;

    TExodusHistoryResultCallbackMap = class
        private
            // Variables
            _callbackmap: TWidestringList;

            // Methods
            function _FindCallback(ResultObj: TExodusHistoryResult): TExodusHistoryResultCallbackItem;
        protected
            // Variables

            // Methods
        public
            // Variables

            // Methods
            constructor Create();
            destructor Destroy(); override;

            procedure AddCallback(cb: TInternalResultCallback; ResultObj: TExodusHistoryResult; ShouldStoreResultWithCallback: boolean = true);
            function FireCallback(ResultObj: TExodusHistoryResult; msg: TJabberMessage): boolean;
            procedure DeleteCallback(ResultObj: TExodusHistoryResult);

            // Properties

    end;

var
    ExodusHistoryResultCallbackMap: TExodusHistoryResultCallbackMap;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ,
    sysUtils,
    ComExodusMsg,
    JabberUtils,
    XMLTag;

{---------------------------------------}
constructor TExodusHistoryResultCallbackMap.Create();
begin
    _callbackmap := TWidestringList.Create();
end;

{---------------------------------------}
destructor TExodusHistoryResultCallbackMap.Destroy();
var
    i: integer;
    tmp: TExodusHistoryResultCallbackItem;
begin
    for i := _callbackmap.Count - 1 downto 0 do begin
        tmp := TExodusHistoryResultCallbackItem(_callbackmap.Objects[i]);
        tmp.ResultObj := nil;
        tmp.Free();
        _callbackmap.Delete(i);
    end;
    _callbackmap.Free();
end;

{---------------------------------------}
procedure TExodusHistoryResultCallbackMap.AddCallback(cb: TInternalResultCallback; ResultObj: TExodusHistoryResult; ShouldStoreResultWithCallback: boolean);
var
    tmp: TExodusHistoryResultCallbackItem;
begin
    if (ResultObj = nil) then exit;

    DeleteCallback(ResultObj);

    tmp := TExodusHistoryResultCallbackItem.Create();
    tmp.cb := cb;
    tmp.ResultObj := ResultObj;
    tmp.StoreResultWithCallbackSpecified := ShouldStoreResultWithCallback;

    _callbackmap.AddObject('', tmp);
end;

{---------------------------------------}
function TExodusHistoryResultCallbackMap._FindCallback(ResultObj: TExodusHistoryResult): TExodusHistoryResultCallbackItem;
var
    i: integer;
    tmp: TExodusHistoryResultCallbackItem;
begin
    Result := nil;
    if (ResultObj = nil) then exit;

    for i := 0 to _callbackmap.Count - 1 do begin
        tmp := TExodusHistoryResultCallbackItem(_callbackmap.Objects[i]);
        if ((tmp <> nil) and
            (ResultObj = tmp.ResultObj)) then begin
            Result := tmp;
            break;
        end;
    end;
end;

{---------------------------------------}
function TExodusHistoryResultCallbackMap.FireCallback(ResultObj: TExodusHistoryResult; msg: TJabberMessage): boolean;
var
    tmp: TExodusHistoryResultCallbackItem;
begin
    Result := true;
    if (ResultObj = nil) then exit;

    tmp := _FindCallback(ResultObj);
    if (tmp <> nil) then begin
        try
            tmp.cb(msg);
            Result := tmp.StoreResultWithCallbackSpecified;
        except
        end;
    end;
end;

{---------------------------------------}
procedure TExodusHistoryResultCallbackMap.DeleteCallback(ResultObj: TExodusHistoryResult);
var
    i: integer;
    tmp: TExodusHistoryResultCallbackItem;
begin
    if (ResultObj = nil) then exit;

    for i := 0 to _callbackmap.Count - 1 do begin
        tmp := TExodusHistoryResultCallbackItem(_callbackmap.Objects[i]);
        if ((tmp <> nil) and
            (ResultObj = tmp.ResultObj)) then begin
            tmp.Free();
            _callbackmap.Delete(i);
            break;
        end;
    end;
end;


{---------------------------------------}
procedure TExodusHistoryResult.Initialize();
begin
    inherited;

    _ResultList := TWidestringList.Create();
    _processing := false;

    _parser := TXMLTagParser.Create();
end;

{---------------------------------------}
destructor TExodusHistoryResult.Destroy();
var
    i: integer;
    msg: TJabberMessage;
begin
    for i := _ResultList.Count - 1 downto 0 do begin
        msg := TJabberMessage(_ResultList.Objects[i]);
        msg.Free();
        _ResultList.Delete(i);
    end;

    _ResultList.Free();

    _parser.Free();

    inherited;
end;

{---------------------------------------}
function TExodusHistoryResult.Get_Processing: WordBool;
begin
    Result := _processing;
end;

{---------------------------------------}
function TExodusHistoryResult.Get_ResultCount: Integer;
begin
    Result := _ResultList.Count;
end;

{---------------------------------------}
function TExodusHistoryResult.GetResult(index: Integer): IExodusMsg;
begin
    Result := nil;
    if (index < 0) then exit;
    if (index >= _ResultList.Count) then exit;

    Result := TExodusMsg.Create(TJabberMessage(_ResultList.Objects[index]));
end;

{---------------------------------------}
procedure TExodusHistoryResult.OnResultItem(SearchHandlerID: Integer;
  const SearchID: WideString; const Item: IExodusMsg);
var
    msg: TJabberMessage;
    ShouldSaveMsg: boolean;
    tag: TXMLTag;
begin
    if (Item = nil) then begin
        // Got a nil so that is the signal to end processing.
        _processing := false;

        // Special hack for internal use of the result object.
        // On an externally created Result object, this should
        // just not do anything.
        ExodusHistoryResultCallbackMap.FireCallback(Self, nil);
    end
    else begin
        if (item.RawMsgXML <> '') then begin
            _parser.ParseString(Item.RawMsgXML);
            tag := _parser.popTag();
            msg := TJabberMessage.Create(tag);
            tag.Free();
        end
        else begin
            msg := TJabberMessage.Create();
            msg.ToJID := Item.ToJid;
            msg.FromJID := Item.FromJid;
            msg.Subject := Item.Subject;
            msg.Thread := Item.Thread;
            msg.Body := Item.Body;
            msg.MsgType := Item.MsgType;
            msg.ID := item.ID;
        end;

        msg.Nick := Item.Nick;
        msg.Time := JabberToDateTime(Item.Timestamp);
        if (Item.Direction = LOG_MESSAGE_DIRECTION_OUT) then begin
            msg.isMe := true;
        end
        else begin
            msg.isMe := false;
        end;

        // Special hack for internal use of the result object.
        // On an externally created Result object, this should
        // just not do anything.
        ShouldSaveMsg := ExodusHistoryResultCallbackMap.FireCallback(Self, msg);
        if (ShouldSaveMsg) then begin
            _ResultList.AddObject('', msg);
        end
        else begin
            msg.Free(); 
        end;
    end;
end;

{---------------------------------------}
procedure TExodusHistoryResult.Set_Processing(Value: WordBool);
begin
    _processing := value;
end;


initialization
    TAutoObjectFactory.Create(ComServer, TExodusHistoryResult, Class_ExodusHistoryResult,
                              ciMultiInstance, tmApartment);

    ExodusHistoryResultCallbackMap := TExodusHistoryResultCallbackMap.Create();

finalization
    ExodusHistoryResultCallbackMap.Free();

end.
