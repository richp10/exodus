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
unit SQLSearchHandler;


interface

uses
    ComObj,
    ActiveX,
    Exodus_TLB,
    StdVcl,
    Unicode,
    JabberMsg,
    XMLTag;

type
    TSQLSearchHandler = class(TAutoObject, IExodusHistorySearchHandler)
        private
            // Variables
            _SearchTypes: TWidestringList;
            _CurrentSearches: TWidestringList;
            _handlerID: integer;
            _sessionCB: integer;

            // Methods
            function GenerateSQLSearchString(SearchParameters: IExodusHistorySearch): Widestring;

        protected
            // Variables

            // Methods

        public
            // Variables

            // Methods
            constructor Create();
            destructor Destroy(); override;

            procedure OnResult(SearchID: widestring; msg: TJabberMessage);
            procedure SessionCallback(event: string; tag:TXMLTag);

            // IExodusHistorySearchHandler inteface
            function NewSearch(const SearchParameters: IExodusHistorySearch): WordBool; safecall;
            procedure CancelSearch(const SearchID: WideString); safecall;
            function Get_SearchTypeCount: Integer; safecall;
            function GetSearchType(index: Integer): WideString; safecall;
            function Get_SearchHandlerLabel: WideString; safecall;

            // Properties
    end;

const
    SQLSEARCH_CHAT = 'chat history';
    SQLSEARCH_ROOM = 'groupchat history';

    sSearchHandlerLabel = 'Internal message logger';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ExSession,
    ComServ,
    sysUtils,
    SQLLogger,
    COMExodusMsg,
    SQLSearchThread,
    SQLUtils,
    IdGlobal,
    Debug,
    Session;

{---------------------------------------}
constructor TSQLSearchHandler.Create();
begin
    _SearchTypes := TWidestringList.Create();
    _SearchTypes.Add(SQLSEARCH_CHAT);
    _SearchTypes.Add(SQLSEARCH_ROOM);

    _CurrentSearches := TWidestringList.Create();

    _handlerID := HistorySearchManager.RegisterSearchHandler(Self);
    _sessionCB := MainSession.RegisterCallback(SessionCallback,'/session/history/search');
end;

{---------------------------------------}
destructor TSQLSearchHandler.Destroy();
var
    i: integer;
    thread: TSQLSearchThread;
begin
    HistorySearchManager.UnRegisterSearchHandler(_handlerID);

    _SearchTypes.Clear();
    for i := _CurrentSearches.Count - 1 downto 0 do begin
        thread := TSQLSearchThread(_CurrentSearches.Objects[i]);
        try
            thread.Terminate();
        except
        end;

        _CurrentSearches.Delete(i);
    end;

    _SearchTypes.Free();
    _CurrentSearches.Free();

    MainSession.UnRegisterCallback(_sessionCB);

    inherited;
end;

{---------------------------------------}
function TSQLSearchHandler.NewSearch(const SearchParameters: IExodusHistorySearch): WordBool;
var
    searchThread: TSQLSearchThread;
    i: integer;
begin
    searchThread := TSQLSearchThread.Create();
    searchThread.SearchID := SearchParameters.SearchID;
    searchThread.DataStore := DataStore;
    searchThread.SQLStatement := GenerateSQLSearchString(SearchParameters);
    searchThread.ExactKeywordMatch := SearchParameters.ExactKeywordMatch;
    if (SearchParameters.ExactKeywordMatch) then begin
        for i := 0 to SearchParameters.KeywordCount - 1 do begin
            searchThread.AddKeyword(SearchParameters.GetKeyword(i));
        end;
    end;
    searchThread.SetCallback(Self.OnResult);
    searchThread.SetTable(CreateCOMObject(CLASS_ExodusDataTable) as IExodusDataTable);

    _CurrentSearches.AddObject(searchThread.SearchID, SearchThread);

    Result := true; // Always want to participate in search
end;

{---------------------------------------}
procedure TSQLSearchHandler.CancelSearch(const SearchID: WideString);
var
    i: integer;
    thread: TSQLSearchThread;
begin
    i := _CurrentSearches.IndexOf(SearchID);
    if (i >= 0) then begin
        try
            thread := TSQLSearchThread(_CurrentSearches.Objects[i]);
            thread.Terminate();
        except
        end;
    end;
end;

{---------------------------------------}
function TSQLSearchHandler.Get_SearchTypeCount: Integer;
begin
    Result := _SearchTypes.Count;
end;

{---------------------------------------}
function TSQLSearchHandler.GetSearchType(index: Integer): WideString;
begin
    Result := '';
    if (index < 0) then exit;
    if (index >= _SearchTypes.Count) then exit;

    Result := _SearchTypes[index];
end;

{---------------------------------------}
function TSQLSearchHandler.Get_SearchHandlerLabel: WideString;
begin
    Result := sSearchHandlerLabel;
end;

{---------------------------------------}
function TSQLSearchHandler.GenerateSQLSearchString(SearchParameters: IExodusHistorySearch): Widestring;
var
    i: integer;
begin
    // SELECT part
    Result := 'SELECT * ';

    // FROM part
    Result := Result +
              'FROM ' +
              MESSAGES_TABLE;

    // WHERE part
    // Add Timezonebias to keep everything UTC
    Result := Result + Format(' WHERE datetime >= %8.6f  AND datetime <= %8.6f', [SearchParameters.minDate + TimeZoneBias(), SearchParameters.maxDate + TimeZoneBias()]);

    if (SearchParameters.JIDCount > 0) then begin
        Result := Result +
                  ' AND (';
        if (SearchParameters.MessageTypeCount > 0) then begin
            Result := Result + '(';
        end;
        for i := 0 to SearchParameters.JIDCount - 1 do begin
            Result := Result +
                      'jid="' +
                      str2sql(UTF8Encode(SearchParameters.GetJID(i))) +
                      '"';
            if (i < (SearchParameters.JIDCount - 1)) then begin
                Result := Result +
                          ' OR ';
            end;
        end;
        Result := Result +
                  ')';
    end;

    if (SearchParameters.MessageTypeCount > 0) then begin
        if (SearchParameters.JIDCount > 0) then begin
            Result := Result +
                      ' OR (';
        end
        else begin
            Result := Result +
                      ' AND (';
        end;
        for i := 0 to SearchParameters.MessageTypeCount - 1 do begin
            Result := Result +
                      'type="' +
                      str2sql(UTF8Encode(SearchParameters.GetMessageType(i))) +
                      '"';
            if (i < (SearchParameters.MessageTypeCount - 1)) then begin
                Result := Result +
                          ' OR ';
            end;
        end;
        Result := Result +
                  ')';
        if (SearchParameters.JIDCount > 0) then begin
            Result := Result + ')';
        end;
    end;

    if (SearchParameters.KeywordCount > 0) then begin
        Result := Result +
                  ' AND (';
        for i := 0 to SearchParameters.KeywordCount - 1 do begin
            Result := Result +
                      'body LIKE ''';

            Result := Result + '%';
            Result := Result +
                      str2sql(UTF8Encode(SearchParameters.GetKeyword(i)));
            Result := Result + '%';

            Result := Result +
                      '''';

            if (i < (SearchParameters.KeywordCount -1)) then begin
                Result := Result +
                          ' OR ';
            end;
        end;
        Result := Result +
                  ')';
    end;

    if (SearchParameters.Priority = 0) then begin
        Result := Result + 'AND priority=0'; // high only
    end
    else if (SearchParameters.Priority = 1) then begin
        Result := Result + 'AND (priority=0 OR priority=1)'; // High or Normal
    end
    else if (SearchParameters.Priority = 2) then begin
        Result := Result + 'AND (priority=0 OR priority=1 OR priority=2)'; // High or Normal or Low but NOT None
    end;
    // Else everything - so no need to add SQL restriction.



    // GROUP BY part

    // ORDER BY part
    Result := Result +
              ' ORDER BY ' +
              'datetime';

    // End of SQL Statement
    Result := Result +
             ';';
end;

{---------------------------------------}
procedure TSQLSearchHandler.OnResult(SearchID: widestring; msg: TJabberMessage);
var
    i: integer;
    m: TExodusMsg;
begin
    if (SearchID = '') then exit;

    if (msg = nil) then begin
        // End of result set
        HistorySearchManager.HandlerResult(_handlerID, SearchID, nil);
        i := _CurrentSearches.IndexOf(SearchID);
        if (i >= 0) then begin
            // Remove search from search queue.
            // Do NOT free the thread object here.  It will self
            // delete.  If we try to clean it up, we deadlock.
            // Deleteing the search from the list will remove any reference
            // to it, so we will not try to access a deleted object.
            _CurrentSearches.Delete(i);
        end;
    end
    else begin
        // Send the result set on to the Search Manager
        m := TExodusMsg.Create(msg);
        HistorySearchManager.HandlerResult(_handlerID, SearchID, m);
        m.Free();
    end;
end;

{---------------------------------------}
procedure TSQLSearchHandler.SessionCallback(event: string; tag:TXMLTag);
var
    searchID: widestring;
    thread: TSQLSearchThread;
    i: integer;
begin
    if (event = '/session/history/search/execute') then begin
        searchID := tag.Data;
        i := _CurrentSearches.IndexOf(searchID);
        if (i >= 0) then begin
            try
                thread := TSQLSearchThread(_CurrentSearches.Objects[i]);
                thread.Resume();
            except
            end;
        end;                    
    end;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TSQLSearchHandler, Class_ExodusHistorySQLSearchHandler,
    ciMultiInstance, tmApartment);


end.
