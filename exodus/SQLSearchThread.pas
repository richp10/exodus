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
unit SQLSearchThread;


interface

uses
    Classes,
    COMExodusDataStore,
    COMExodusDataTable,
    Exodus_TLB,
    JabberMsg,
    Unicode;

type
    TSQLThreadResult = procedure(SearchID: widestring; msg: TJabberMessage) of object;
    TSQLSearchThread = class(TThread)
        private
            // Variables
            _DataStore: TExodusDataStore;
            _SQLStatement: Widestring;
            _msg: TJabberMessage;
            _SearchID: Widestring;
            _callback: TSQLThreadResult;
            _callbackSet: boolean;
            _table: IExodusDataTable;
            _keywordList: TWidestringList;
            _exactKeywordMatch: boolean;

            // Methods
            procedure _ProcessResultTable();
            procedure _OnResult();
            procedure _GetTable();

        protected
            // Variables

            // Methods
        public
            // Variables

            // Methods
            constructor Create();

            procedure Execute; override;
            procedure SetCallback(callback: TSQLThreadResult);
            procedure SetTable(table: IExodusDataTable);
            procedure AddKeyword(keyword: Widestring);

            // Properties
            property DataStore: TExodusDataStore write _DataStore;
            property SQLStatement: Widestring write _SQLStatement;
            property msg: TJabberMessage read _msg;
            property SearchID: Widestring read _SearchID write _SearchID;
            property ExactKeywordMatch: boolean read _exactKeywordMatch write _exactKeywordMatch;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    sysUtils,
    XMLTag,
    XMLParser,
    XMLUtils,
    ComObj;


{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure SQLSearchThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TSQLSearchThread }

{---------------------------------------}
constructor TSQLSearchThread.Create();
begin
    inherited Create(true);
    _DataStore := nil;
    _SQLStatement := '';
    _msg := nil;
    _callback := nil;
    _callbackSet := false;
    Self.FreeOnTerminate := true;
    _keywordList := TWidestringList.Create();
    _exactKeywordMatch := false;
end;

{---------------------------------------}
procedure TSQLSearchThread.Execute;
begin
    // NOTE: Object frees on terminate from this thread
    if (_DataStore = nil) then exit;
    if (_SQLStatement = '') then exit;

    if (_table <> nil) then begin
        Synchronize(Self._GetTable);
        _ProcessResultTable();
    end;

    _table := nil;
    _DataStore := nil;

    _keywordList.Free();
end;

{---------------------------------------}
procedure TSQLSearchThread._ProcessResultTable();
const
    msgid_col = 0;
    user_jid_col = 1;
    jid_col = 2;
    datetime_col = 3;
    thread_col = 4;
    subject_col = 5;
    nick_col = 6;
    body_col = 7;
    type_col = 8;
    outbound_col = 9;
    priority_col = 10;
    xml_col = 11;
var
    tag: TXMLTag;
    i,j: integer;
    tmp: widestring;
    parser: TXMLTagParser;
    keywordpos: integer;
begin
    if (_table = nil) then exit;

    try
        parser := TXMLTagParser.Create();

        _table.FirstRow();
        for i := 0 to _table.RowCount - 1 do begin
            if (Self.Terminated) then begin
                break;
            end
            else begin
                tmp := _table.GetField(xml_col);
                if (_table.GetLastError() = 0) then begin
                    if (tmp <> '') then begin
                        // if we have the tag stored, try and recreate
                        // jabber message using stored tag
                        tmp := XML_UnEscapeChars(UTF8Decode(tmp));
                        parser.ParseString(tmp, '');
                        tag := parser.popTag();
                        _msg := TJabberMessage.Create(tag);

                        // Override the TJabberMessage timestamp
                        // as it puts a Now() timestamp on when it
                        // doesn't find the MSGDELAY tag.  As we
                        // are pulling the original XML, it probably
                        // didn't have this tag when we stored it.
                        _msg.Time := _table.GetFieldAsDouble(datetime_col);

                        // Set the nick if it exists in the db.
                        if (_msg.Nick = '') then begin
                            _msg.Nick := UTF8Decode(_table.GetField(nick_col));
                        end;

                        // Set the "isMe" because this cannot be determined by just the tag
                        if (UpperCase(_table.GetField(outbound_col)) = 'TRUE') then begin
                            _msg.isMe := true;
                        end;

                        tag.Free();
                    end
                    else begin
                        // No tag stored
                        _msg := TJabberMessage.Create();

                        if (UpperCase(_table.GetField(outbound_col)) = 'TRUE') then begin
                            _msg.ToJID := UTF8Decode(_table.GetField(jid_col));
                            _msg.FromJID := UTF8Decode(_table.GetField(user_jid_col));
                            if (_msg.FromJID <> '') then begin
                                _msg.isMe := true;
                            end;
                        end
                        else begin
                            _msg.ToJID := UTF8Decode(_table.GetField(user_jid_col));
                            _msg.FromJID := UTF8Decode( _table.GetField(jid_col));
                        end;
                        _msg.Subject := UTF8Decode(_table.GetField(subject_col));
                        _msg.Thread := UTF8Decode(_table.GetField(thread_col));
                        _msg.Body := UTF8Decode(_table.GetField(body_col));
                        _msg.MsgType := UTF8Decode(_table.GetField(type_col));
                        _msg.Nick := UTF8Decode(_table.GetField(nick_col));
                        _msg.Time := _table.GetFieldAsDouble(datetime_col);
                        //_msg.XML := table.GetField(xml_col); // The xml part of a JabberMsg is not the xml that was parsed to create the object.
                        case _table.GetFieldAsInt(priority_col) of
                            0: _msg.Priority := high;
                            1: _msg.Priority := medium;
                            2: _msg.Priority := low;
                            else begin
                                _msg.Priority := none;
                            end;
                        end;
                    end;

                    if ((_exactKeywordMatch) and
                        (_keywordList.Count > 0)) then begin
                        for j := 0 to _keywordList.Count - 1 do begin
                            keywordpos := Pos(_keywordList[j], _msg.Body);
                            if (keywordpos > 0) then begin
                                // This keyword was found in case sensitve search,
                                // we are good to send it on.
                                Synchronize(Self._OnResult);  // blocks here
                                break;
                            end;
                        end;
                    end
                    else begin
                        Synchronize(Self._OnResult);  // blocks here
                    end;
                    _msg.Free();
                    _msg := nil;
                end;

                if (i < _table.RowCount - 1) then begin
                    _table.NextRow();
                end;
            end;
        end;

        Synchronize(Self._OnResult); // Send nil as end of result set.

        parser.Free();
    except
    end;    
end;

{---------------------------------------}
procedure TSQLSearchThread._OnResult();
begin
    if (not _callbackSet) then exit;

    _callback(_SearchID, _msg);
end;

{---------------------------------------}
procedure TSQLSearchThread.SetCallback(callback: TSQLThreadResult);
begin
    _callbackSet := true;
    _callback := callback;
end;

{---------------------------------------}
procedure TSQLSearchThread.SetTable(table: IExodusDataTable);
begin
    if (table = nil) then exit;

    _table := table;
end;

{---------------------------------------}
procedure TSQLSearchThread.AddKeyword(keyword: Widestring);
begin
    if (Trim(keyword) = '') then exit; // Don't allow empty strings

    _keywordList.Add(keyword);
end;

{---------------------------------------}
procedure TSQLSearchThread._GetTable();
begin
    _DataStore.GetTable(_SQLStatement, _table);
end;


end.

