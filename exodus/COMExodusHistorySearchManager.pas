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
unit COMExodusHistorySearchManager;

{$WARN SYMBOL_PLATFORM OFF}


interface

uses
    ComObj,
    ActiveX,
    Exodus_TLB,
    StdVcl,
    Unicode,
    COMExodusHistoryResult;

type
  TSearchHandlerWrapper = class(TObject)
      private
        // Variables
        _Handler: IExodusHistorySearchHandler;
        _SearchTypeCache: TWidestringList;
        _cb_id: integer;

        // Methods

      protected
        // Variables

        // Methods

      public
        // Variables

        // Methods
        constructor Create();
        destructor Destroy(); override;

        // Properties
        property Handler: IExodusHistorySearchHandler read _Handler write _Handler;
        property SearchTypeCache: TWidestringList read _SearchTypeCache write _SearchTypeCache;
        property cb_id: integer read _cb_id write _cb_id;
  end;

  TSearchTracker = class (TObject)
      private
        // Variables
        _HandlerList: TWidestringList;
        _ResultObject: IExodusHistoryResult;
        _SearchObject: IExodusHistorySearch;

        // Methods

      protected
        // Variables

        // Methods

      public
        // Variables

        // Methods
        constructor Create();
        destructor Destroy(); override;

        // Properties
        property HandlerList: TWidestringList read _HandlerList write _HandlerList;
        property ResultObject: IExodusHistoryResult read _ResultObject write _ResultObject;
        property SearchObject: IExodusHistorySearch read _SearchObject write _SearchObject;
  end;

  TExodusHistorySearchManager = class(TAutoObject, IExodusHistorySearchManager)
      private
        // Variables
        _HandlerList: TWidestringList;
        _SearchTypes: TWidestringList;
        _CurrentSearches: TWidestringList;

        // Methods

      protected
        // Variables

        // Methods

      public
        // Variables

        // Methods
        constructor Create();
        destructor Destroy(); override;

        procedure CancelAllSearches();

        // IExodusHistorySearchManager Interface
        function Get_SearchTypeCount: Integer; safecall;
        function GetSearchType(index: Integer): WideString; safecall;
        function NewSearch(const SearchParams: IExodusHistorySearch; const SearchResult: IExodusHistoryResult): WordBool; safecall;
        function RegisterSearchHandler(const Handler: IExodusHistorySearchHandler): Integer; safecall;
        procedure CancelSearch(const SearchID: WideString); safecall;
        procedure UnRegisterSearchHandler(HandlerID: Integer); safecall;
        procedure HandlerResult(HandlerID: Integer; const SearchID: WideString; const LogMsg: IExodusMsg); safecall;

        // Properties
        property SearchTypeCount: Integer read Get_SearchTypeCount;
  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ,
    sysUtils,
    JabberID,
    COMLogMsg,
    Session,
    XMLTag;

var
    _hid: longint = 1;

{---------------------------------------}
constructor TSearchHandlerWrapper.Create();
begin
    inherited;

    _SearchTypeCache := TWidestringList.Create();
end;

{---------------------------------------}
destructor TSearchHandlerWrapper.Destroy();
begin
    _SearchTypeCache.Clear();
    _SearchTypeCache.Free();

    inherited;
end;

{---------------------------------------}
constructor TSearchTracker.Create();
begin
    inherited;

    _HandlerList := TWidestringList.Create();
end;

{---------------------------------------}
destructor TSearchTracker.Destroy();
begin
    if (_ResultObject <> nil) then begin
        _ResultObject.Processing := false;
    end;
    _ResultObject := nil;
    _SearchObject := nil;

    _HandlerList.Clear();
    _HandlerList.Free();

    inherited;
end;

{---------------------------------------}
constructor TExodusHistorySearchManager.Create();
begin
    inherited;

    _HandlerList := TWidestringList.Create();
    _SearchTypes := TWidestringList.Create();
    _CurrentSearches := TWidestringList.Create();
end;

{---------------------------------------}
destructor TExodusHistorySearchManager.Destroy();
begin
    _HandlerList.Clear();
    _SearchTypes.Clear();
    _CurrentSearches.Clear();

    _HandlerList.Free();
    _SearchTypes.Free();
    _CurrentSearches.Free();

    inherited;
end;

{---------------------------------------}
procedure TExodusHistorySearchManager.CancelAllSearches();
var
    i: integer;
begin
    for i := _CurrentSearches.Count -1 downto 0 do begin
        CancelSearch(_CurrentSearches[i]);
    end;
end;

{---------------------------------------}
function TExodusHistorySearchManager.Get_SearchTypeCount: Integer;
begin
    Result := _SearchTypes.Count;
end;

{---------------------------------------}
function TExodusHistorySearchManager.GetSearchType(index: Integer): WideString;
begin
    Result := '';
    if (index < 0) then exit;
    if (index >= _SearchTypes.Count) then exit;

    Result := _SearchTypes[index];
end;

{---------------------------------------}
function TExodusHistorySearchManager.NewSearch(const SearchParams: IExodusHistorySearch; const SearchResult: IExodusHistoryResult): WordBool;
var
    i: integer;
    j: integer;
    k: integer;
    hwrapper: TSearchHandlerWrapper;
    tracker: TSearchTracker;
    searchID: Widestring;
    tag: TXMLTag;
begin
    Result := false;
    tracker := nil;

    SearchID := SearchParams.SearchID;
    for j := 0 to _HandlerList.Count - 1 do begin
        hwrapper := TSearchHandlerWrapper(_HandlerList.Objects[j]);
        for i := 0 to SearchParams.AllowedSearchTypeCount - 1 do begin
            if (hwrapper.SearchTypeCache.Find(LowerCase(SearchParams.GetAllowedSearchType(i)), k)) then begin
                if(hwrapper.Handler.NewSearch(SearchParams)) then begin
                    if (tracker = nil) then begin
                        tracker := TSearchTracker.Create();
                    end;
                    tracker.HandlerList.Add(_HandlerList[j]);
                    Result := true;
                    break;
                end;
            end;
        end;
    end;

    if (Result) then begin
        tracker.ResultObject := SearchResult;
        tracker.SearchObject := SearchParams;
        tracker.ResultObject.Processing := true;
        _CurrentSearches.AddObject(SearchID, tracker);
        tag := TXMLTag.Create('SearchID', SearchID);
        MainSession.FireEvent('/session/history/search/execute', tag);
        tag.Free();
    end;
end;

{---------------------------------------}
function TExodusHistorySearchManager.RegisterSearchHandler(const Handler: IExodusHistorySearchHandler): Integer;
var
    hwrapper: TSearchHandlerWrapper;
    i: Integer;
    j: integer;
    tmp: Widestring;
    searchtypeexists: boolean;
begin
    Result := _hid;

    hwrapper := TSearchHandlerWrapper.Create();
    hwrapper.Handler := Handler;
    hwrapper.cb_id := _hid;

    for i := 0 to Handler.SearchTypeCount - 1 do begin
        tmp := LowerCase(Handler.GetSearchType(i));
        hwrapper.SearchTypeCache.Add(tmp);
        searchtypeexists := false;
        for j := 0 to _SearchTypes.Count - 1 do begin
            if (tmp = _SearchTypes[j]) then begin
                searchtypeexists := true;
                break;
            end;
        end;
        if (not searchtypeexists) then begin
            _SearchTypes.Add(tmp);
        end;
    end;

    _HandlerList.AddObject(IntToStr(_hid), hwrapper);
    Inc(_hid);
end;

{---------------------------------------}
procedure TExodusHistorySearchManager.CancelSearch(const SearchID: WideString);
var
    i: integer;
    j: integer;
    k: integer;
    tracker: TSearchTracker;
    hwrapper: TSearchHandlerWrapper;
    tag: TXMLTag;
begin
    if (_CurrentSearches.Find(SearchID, i)) then begin
        tracker := TSearchTracker(_CurrentSearches.Objects[i]);
        for j := tracker.HandlerList.Count - 1 downto 0 do begin
            if (_HandlerList.Find(tracker.HandlerList[j], k)) then begin
                hwrapper := TSearchHandlerWrapper(_HandlerList.Objects[k]);
                hwrapper.Handler.CancelSearch(SearchID);
            end;
        end;

        tag := TXMLTag.Create('SearchID', SearchID);
        MainSession.FireEvent('/session/history/search/cancel', tag);
        tag.Free();
    end;
end;

{---------------------------------------}
procedure TExodusHistorySearchManager.UnRegisterSearchHandler(HandlerID: Integer);
var
    i: integer;
    hwrapper: TSearchHandlerWrapper;
begin
    if (_HandlerList.Find(IntToStr(HandlerID), i)) then begin
        hwrapper := TSearchHandlerWrapper(_HandlerList.Objects[i]);
        if (hwrapper.cb_id = HandlerID) then begin
            _HandlerList.Delete(i);
        end;
        hwrapper.Free();
    end;
end;

{---------------------------------------}
procedure TExodusHistorySearchManager.HandlerResult(HandlerID: Integer; const SearchID: WideString; const LogMsg: IExodusMsg);
var
    i: integer;
    j: integer;
    tracker: TSearchTracker;
    JIDExclusiveID: integer;
    jid: TJabberID;
    tag: TXMLTag;
begin
    if (SearchID = '') then exit;

    if (_CurrentSearches.Find(SearchID, i)) then begin
        // Found the Search
        tracker := TSearchTracker(_CurrentSearches.Objects[i]);
        if (tracker <> nil) then begin
            if ((LogMsg = nil) and
                (tracker.HandlerList.Find(IntToStr(HandlerID), j))) then begin
                // Found the Handler and LogMsg is nil - so we can remove handler from search list
                tracker.HandlerList.Delete(j);
            end
            else if (LogMsg <> nil) then begin
                // Valid search result
                if (LogMsg.Direction = LOG_MESSAGE_DIRECTION_OUT) then begin
                    jid := TJabberID.Create(LogMsg.ToJid);
                end
                else begin
                    jid := TJabberID.Create(LogMsg.FromJid);
                end;
                JIDExclusiveID := tracker.SearchObject.GetJIDExclusiveHandlerID(jid.jid);
                if (((JIDExclusiveID < 0) or
                     (JIDExclusiveID = HandlerID)) and
                    (tracker.ResultObject <> nil)) then begin
                    tracker.ResultObject.OnResultItem(HandlerID, SearchID, LogMsg);
                end;
                jid.Free();
            end;

            if (tracker.HandlerList.Count = 0) then begin
                // No more handlers outstanding so end search
                if (tracker.ResultObject <> nil) then begin
                    tracker.ResultObject.OnResultItem(HandlerID, SearchID, nil);
                end;
                tracker.Free();
                _CurrentSearches.Delete(i);

                tag := TXMLTag.Create('SearchID', SearchID);
                MainSession.FireEvent('/session/history/search/complete', tag);
                tag.Free();
            end;
        end;
    end;
end;




initialization
  TAutoObjectFactory.Create(ComServer, TExodusHistorySearchManager, Class_ExodusHistorySearchManager,
    ciMultiInstance, tmApartment);

end.
