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
unit SQLLogger;


interface

uses
    COMExodusDataStore,
    JabberMsg;

type
    TSQLLogger = class(TObject{, IExodusSearchHandler})
        private
            // Variables
            _LoggingEnabled: boolean;
            _LogChats: boolean;
            _LogRooms: boolean;
            _LogNormal: boolean;

            // Methods
            procedure _CreateLoggerTable();

            // IExodusSearchHandler Interface

        protected
            // Variables

            // Methods

        public
            // Variables

            // Methods
            constructor Create();

            procedure LogMsg(msg: TJabberMessage);
            procedure DeleteLogEntries(jid: widestring; datestart, dateend: TDateTime);

            // Properties
    end;

const
    MESSAGES_TABLE = 'messages';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ExSession,
    JabberID,
    sysUtils,
    XMLUtils,
    SQLUtils,
    IdGlobal,
    Session,
    JabberConst,
    XMLTag;

{---------------------------------------}
constructor TSQLLogger.Create;
begin
    if (DataStore = nil) then exit;

    _LoggingEnabled := MainSession.Prefs.getBool('brand_history_search');
    _LogChats := MainSession.Prefs.getBool('brand_log_chat_messages');
    _LogRooms := MainSession.Prefs.getBool('brand_log_groupchat_messages');
    _LogNormal := MainSession.Prefs.getBool('brand_log_normal_messages');

    if (_LoggingEnabled) then begin
        _CreateLoggerTable();
    end;
end;

{---------------------------------------}
procedure TSQLLogger._CreateLoggerTable();
var
    sql: string;
begin
    // No need to create if it already exists
    if (DataStore.CheckForTableExistence(MESSAGES_TABLE)) then exit;

    // Create the table..
    sql := 'CREATE TABLE ' +  MESSAGES_TABLE + ' (';
    sql := sql + 'msgid INTEGER PRIMARY KEY AUTOINCREMENT, '; // Auto increment
    sql := sql + 'user_jid TEXT, '; // My JID
    sql := sql + 'jid TEXT, '; // Other JID
    sql := sql + 'datetime FLOAT, ';
    sql := sql + 'thread TEXT, ';
    sql := sql + 'subject TEXT, ';
    sql := sql + 'nick TEXT, ';
    sql := sql + 'body TEXT, ';
    sql := sql + 'type TEXT, ';
    sql := sql + 'outbound BOOLEAN, ';
    sql := sql + 'priority INTEGER, ';
    sql := sql + 'xml TEXT);';

    try
        DataStore.ExecSQL(sql);
        DataStore.ExecSQL('CREATE INDEX ' + MESSAGES_TABLE + '_idx1 on ' + MESSAGES_TABLE + '(jid);');
        DataStore.ExecSQL('CREATE INDEX ' + MESSAGES_TABLE + '_idx2 on ' + MESSAGES_TABLE + '(jid, datetime);');
        DataStore.ExecSQL('CREATE INDEX ' + MESSAGES_TABLE + '_idx3 on ' + MESSAGES_TABLE + '(jid, datetime, thread);');
    except
    end;
end;

{---------------------------------------}
procedure TSQLLogger.LogMsg(msg: TJabberMessage);
var
    sql: string;
    cmd: string;

    fromjid: TJabberID;
    tojid: TJabberID;
    outb: boolean;
    ts: TDatetime;
    user_jid: string;
    jid: string;
    thread: string;
    subject: string;
    nick: string;
    body: string;
    mtype: string;
    outstr: string;
    xml: string;
    priority: integer;
    msgDelayTag: TXMLTag;
begin
    if (DataStore = nil) then exit;

    // Branding checks
    if (not _LoggingEnabled) then exit;    
    if ((not _LogChats) and
        (msg.MsgType = 'chat')) then exit;
    if ((not _LogRooms) and
        (msg.MsgType = 'groupchat')) then exit;
    if ((not _LogNormal) and
        ((msg.MsgType = '') or
         (msg.MsgType = 'normal'))) then exit;

    // if room, don't log "old" messages
    if (msg.MsgType = 'groupchat') then begin
        msgDelayTag := GetDelayTag(Msg.Tag);
        if (msgDelayTag <> nil) then begin
            // This is an old message, so we shouldn't log
            exit;
        end;
    end;

    // Pull out the data and prep the SQL statment to insert into SQLite
    outb := (msg.isMe);

    fromjid := TJabberID.Create(msg.FromJID);
    tojid := TJabberID.Create(msg.ToJID);

    if (outb) then begin
        jid := str2sql(UTF8Encode(tojid.jid));
        user_jid := str2sql(UTF8Encode(fromjid.jid));
        outstr := 'TRUE';
    end
    else begin
        jid := str2sql(UTF8Encode(fromjid.jid));
        user_jid := str2sql(UTF8Encode(tojid.jid));
        outstr := 'FALSE';
    end;

    thread := str2sql(UTF8Encode(msg.Thread));
    mtype := str2sql(UTF8Encode(msg.MsgType));
    if (mtype = '') then begin
        mtype := 'normal';
    end;

    subject := str2sql(UTF8Encode(msg.Subject));
    nick := str2sql(UTF8Encode(msg.nick));
    body := str2sql(UTF8Encode(msg.Body));
    xml := str2sql(UTF8Encode(XML_EscapeChars(msg.Tag.XML)));

    case (msg.Priority) of
        high: priority := 0;
        medium: priority := 1;
        low: priority := 2;
        else priority := 3;
    end;

    ts := msg.Time + TimeZoneBias(); // Store as UTC

    cmd := 'INSERT INTO ' +
           MESSAGES_TABLE + ' ' +
           '(user_jid, jid, datetime, thread, subject, nick, body, type, outbound, priority, xml) ' +
           'VALUES (''%s'', ''%s'', %8.6f, ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', ''%s'', %d, ''%s'');';

    sql := Format(cmd, [user_jid, jid, ts, thread, subject, nick, body, mtype, outstr, priority, xml]);

    try
        // Insert the message as a new record.
        DataStore.ExecSQL(sql);
    except
    end;

    fromjid.Free();
    tojid.Free();
end;

{---------------------------------------}
procedure TSQLLogger.DeleteLogEntries(jid: widestring; datestart, dateend: TDateTime);
var
    sql: widestring;
    tag: TXMLTag;
begin
    if (DataStore = nil) then exit;

    try
        // Delete From part
        sql := 'DELETE FROM ' +
               MESSAGES_TABLE;

        // WHERE Part

        // jid
        sql := sql +
               ' WHERE ';
        if (jid <> '') then begin
            sql := sql +
                   'jid="' +
                   jid +
                   '" AND ';
        end;

        // dates
        sql := sql + 'datetime >= %8.6f AND  datetime <=  %8.6f;';

        // Change dates for Time zone as they are stored in DB as UTC
        datestart := datestart + TimeZoneBias();
        dateend := dateend + TimeZoneBias();

        sql := Format(sql, [datestart, dateend]);

        DataStore.ExecSQL(sql);

        // Shoot out event notifying anyone who wants to know that the history has been
        // removed.
        tag := TXMLTag.Create('history_delete');
        tag.AddBasicTag('jid', jid);
        tag.AddBasicTag('startdatetime', DateTimeToXEP82DateTime(datestart, true));
        tag.AddBasicTag('enddatetime', DateTimeToXEP82DateTime(dateend, true));
        MainSession.FireEvent('/session/history/delete', tag);
        tag.Free();
    except
    end;
end;





end.
