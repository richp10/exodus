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
unit LoggerPlugin;



{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ComObj, ActiveX, Graphics, StdVcl,
    Exodus_TLB,
    ExHTMLLogger_TLB;

function DelDir(dir: string): Boolean;

type
  THTMLLogger = class(TAutoObject, IExodusLogger, IExodusPlugin2)
  protected
    function Get_Configurable: WordBool; safecall;
    procedure NewIncomingIM(const JID: WideString; const instantMsg: IExodusChat);
      safecall;
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
    function Get_isDateEnabled: WordBool; safecall;
    procedure Clear(const jid: WideString); safecall;
    procedure GetDays(const jid: WideString; Month, Year: Integer;
      const Listener: IExodusLogListener); safecall;
    procedure GetMessages(const jid: WideString; ChunkSize, Day, Month,
      Year: Integer; Cancel: WordBool; const Listener: IExodusLogListener);
      safecall;
    procedure LogMessage(const Msg: IExodusLogMsg); safecall;
    procedure Purge; safecall;
    procedure Show(const jid: WideString); safecall;


  private
    _exodus: IExodusController;

    // callbacks
    _path: Widestring;
    _roster: boolean;
    _rooms: boolean;
    _timestamp: boolean;
    _format: Widestring;
    _bg: TColor;
    _me: TColor;
    _other: TColor;
    _font_name: Widestring;
    _font_size: Widestring;

    function _getMsgHTML(Msg: IExodusLogMsg): string;
    procedure _logMessage(log: IExodusLogMsg);
    procedure _showLog(jid: Widestring);
    procedure _clearLog(jid: Widestring);
    function SetupFrameSet(dir:string; base_fn, munged_name: Widestring): boolean;

  public
    procedure purgeLogs();
    property ExodusController: IExodusController read _exodus;

  end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    Controls, ShellAPI, Dialogs,
    SysUtils, Classes, ComServ,
    StrUtils,Windows,

    HtmlPrefs,
    HtmlUtils,
    IdGlobal,
    JabberID;

const
    sNoHistory = 'There is no history file for this contact.';
    sBadLogDir = 'The log directory you specified is invalid. Configure the HTML Logging plug-in correctly.';
    sHistoryDeleted = 'History deleted.';
    sHistoryError = 'Could not delete history file(s).';
    sHistoryNone = 'No history file for this user.';
    sConfirmClearLog = 'Do you really want to clear the log for %s?' + #13#10 + 'Once cleared these logs are not recoverable.';
    sConfirmClearAllLogs = 'Are you sure you want to delete all of your message and room logs?';
    sFilesDeleted = 'HTML log files deleted.';
    sCouldNotFindFile = 'Could not open log file: ';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}

function DelDir(dir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom  := PChar(dir + #0);
  end;
  Result := (0 = ShFileOperation(fos));
end;

{---------------------------------------}
procedure THTMLLogger.Startup(const ExodusController: IExodusController);
begin
    _exodus := ExodusController;

    // get some configs
    _path := _exodus.getPrefAsString('log_path');
    _roster := _exodus.getPrefAsBool('log_roster');
    _rooms := _exodus.getPrefAsBool('log_rooms');

    _timestamp := _exodus.getPrefAsBool('timestamp');
    _format := _exodus.getPrefAsString('timestamp_format');
    _bg := TColor(_exodus.getPrefAsInt('color_bg'));
    _me := TColor(_exodus.getPrefAsInt('color_me'));
    _other := TColor(_exodus.getPrefAsInt('color_other'));
    _font_name := _exodus.getPrefAsString('font_name');
    _font_size := _exodus.getPrefAsString('font_size');

    // Set us up as the contact logger
    _exodus.ContactLogger := Self as IExodusLogger;
end;

{---------------------------------------}
procedure THTMLLogger.Shutdown;
begin
    //_exodus.ContactLogger := nil;
end;

{---------------------------------------}
function THTMLLogger._getMsgHTML(Msg: IExodusLogMsg): string;
var
    html, txt: Widestring;
    ret, color, time, bg, font: string;
    cr_pos: integer;
    mtime: TDateTime;
begin
    // replace CR's w/ <br> tags
    txt := HTML_EscapeChars(Msg.Body, false, true);
    repeat
        cr_pos := Pos(#13#10, txt);
        if cr_pos > 0 then begin
            Delete(txt, cr_pos, 2);
            Insert('<br />', txt, cr_pos);
        end;
    until (cr_pos <= 0);

    // Get our window bg color in there
    bg := 'background-color: ' + ColorToHTML(_bg) + ';';

    //font-family: Arial Black; font-size: 10pt
    font := 'font-family: ' + _font_name + '; ' +
            'font-size: ' + _font_size + 'pt;';

    // this is the output buffer
    html := '';

    // Make sure we do something with the subject..
    if (Msg.Subject <> '') then begin
        html := html + '<div style="' + bg + font + '">' + Msg.Nick +
            ' set the subject to: ' + Msg.Subject + '</div>'#13#10;
    end;

    // timestamp if we're supposed to..
    if (_timestamp) then begin
        mtime := JabberToDateTime(Msg.Timestamp);
        time := '<span style="color: gray;">[' +
                FormatDateTime(_format, mtime) +
                ']</span>';
    end
    else
        time := '';


    if (MidStr(Msg.Body, 1, 3) = '/me') then begin
        html := html + '<div style="' + bg + font + '">' + time +
                '<span style="color: purple;">* ' + Msg.Nick + ' ' + txt + '</span></div>';
    end
    else begin
        if (Msg.Direction = 'out') then
            color := ColorToHTML(_me)
        else
            color := ColorToHTML(_other);

        if (Msg.Nick <> '') then
            html := html + '<div style="' + bg + font + '">' +
                time + '<span style="color: ' + color + ';">&lt;' +
                Msg.Nick + '&gt;</span> ' + txt + '</div>'
        else
            html := html + '<div style="' + bg + font + '">' +
                time + '<span style="color: green;">' +
                txt + '</span></div>';
    end;

    ret := UTF8Encode(html);
    Result := ret;
end;


{---------------------------------------}
function THTMLLogger.NewIM(const jid: WideString; var Body,
  Subject: WideString; const XTags: WideString): WideString;
begin

end;

{---------------------------------------}
procedure THTMLLogger.Configure;
var
    p: TfrmHtmlPrefs;
begin
    p := TfrmHtmlPrefs.Create(nil);
    p.Logger := Self;
    p.txtLogPath.Text := _path;
    p.chkLogRooms.Checked := _rooms;
    p.chkLogRoster.Checked := _roster;

    if (p.ShowModal() = mrOK) then begin
        _path := p.txtLogPath.Text;
        _rooms := p.chkLogRooms.Checked;
        _roster := p.chkLogRoster.Checked;

        _exodus.setPrefAsString('log_path', _path);
        _exodus.setPrefAsBool('log_rooms', _rooms);
        _exodus.setPrefAsBool('log_roster', _roster);
    end;

    p.Free();    
end;

{---------------------------------------}
procedure THTMLLogger.NewChat(const jid: WideString;
  const Chat: IExodusChat);
begin

end;

{---------------------------------------}
procedure THTMLLogger.NewOutgoingIM(const jid: WideString;
  const InstantMsg: IExodusChat);
begin

end;

{---------------------------------------}
procedure THTMLLogger.NewRoom(const jid: WideString;
  const Room: IExodusChat);
begin

end;

{---------------------------------------}
procedure THTMLLogger.Process(const xpath, event, xml: WideString);
begin

end;

{---------------------------------------}
procedure THTMLLogger._logMessage(log: IExodusLogMsg);
var
    buff: string;
    dir: Widestring;
    fn: Widestring;
    base_fn: Widestring;
    date_fn: Widestring;
    xml_fn: Widestring;
    header: boolean;
    rjid, j: TJabberID;
    ndate: TDateTime;
    fs: TFileStream;
    ritem: IExodusRosterItem;
    tempstring: string;
    jdatetime: TDateTime;
begin
    // check the roster for the rjid, and bail if we aren't logging non-roster folk
    if (_roster) and (log.Direction = 'in') then begin
        rjid := TJabberID.Create(log.FromJid);
        ritem := _exodus.Roster.find(rjid.jid);
        rjid.Free();
        if (ritem = nil) then exit;
    end;

    // prepare to log
    dir := _path;
    jdatetime := JabberToDateTime(log.Timestamp);

    if (log.Direction = 'out') then
        j := TJabberID.Create(log.ToJid)
    else
        j := TJabberID.Create(log.FromJid);

    if (Copy(dir, length(fn), 1) <> '\') then
        dir := dir + '\';

    if (not DirectoryExists(dir)) then begin
        // mkdir
        if CreateDir(dir) = false then begin
            MessageDlg(sBadLogDir, mtError, [mbOK], 0);
            exit;
        end;
    end;

    base_fn := dir + MungeName(j.jid) + '\' + MungeName(j.jid) ; // directory and jid

    // Add framset file
    if (not SetupFrameSet(dir, base_fn, MungeName(j.jid))) then
        exit; // will have already seen an error message

    // Add to today's XML log
    try
        xml_fn := base_fn;
        xml_fn := xml_fn + '_';
        DateTimeToString(tempstring, 'yyyymmdd', jDateTime);
        xml_fn := xml_fn + tempstring; // date
        xml_fn := xml_fn + '.xml'; // file extension
        if (FileExists(xml_fn)) then begin
            fs := TFileStream.Create(xml_fn, fmOpenReadWrite, fmShareDenyNone);
            fs.Seek(0, soFromEnd);
            buff := log.XML + #13#10;
            fs.Write(Pointer(buff)^, Length(buff));
            fs.Free();
        end
        else begin
            fs := TFileStream.Create(xml_fn, fmCreate, fmShareDenyNone);

            // put some UTF-8 header fu in here
            buff := '<!-- Note: this file is not well formed XML as there is no root element -->' + #13#10;
            buff := buff + log.XML + #13#10;
            fs.Write(Pointer(buff)^, Length(buff));
            fs.Free();
        end;
    except
        on e: Exception do Begin
            MessageDlg(sCouldNotFindFile + xml_fn, mtError, [mbOK], 0);
            exit;
        end;
    end;

    // Add to today's date_log
    try
        date_fn := base_fn + '_dates.html';
        if (FileExists(date_fn)) then begin
            // Open stream
            fs := TFileStream.Create(date_fn, fmOpenReadWrite, fmShareDenyNone);

            // See if this date is already in the file
            SetLength(buff, fs.Size);
            fs.Read(Pointer(buff)^, fs.Size);
            DateTimeToString(tempstring, 'yyyy"/"mm"/"dd', jdatetime);
            if (Pos(tempstring, buff) = 0) then begin
                // Date not in file yet
                fs.Seek(0, soFromEnd);
                DateTimeToString(tempstring, 'yyyymmdd', jDateTime);
                tempstring := MungeName(j.jid) + '_' + tempstring + '.html';
                buff := '<a target="log_frame" href="' + tempstring + '">';
                DateTimeToString(tempstring, 'yyyy"/"mm"/"dd', jDateTime);
                buff := buff + tempstring + '</a><br/>';
                fs.Write(Pointer(buff)^, Length(buff));
            end;
            fs.Free();
        end;
    except
        on e: Exception do begin
            MessageDlg(sCouldNotFindFile + date_fn, mtError, [mbOK], 0);
            exit;
        end;
    end;

    // add to today's log
    try
        // Munge the filename
        fn := base_fn; // directory and jid
        fn := fn + '_';
        DateTimeToString(tempstring, 'yyyymmdd', jDateTime);
        fn := fn + tempstring; // date
        fn := fn + '.html'; // file extension

        // Find/create and add to today's log
        if (FileExists(fn)) then begin
            fs := TFileStream.Create(fn, fmOpenReadWrite, fmShareDenyNone);
            ndate := FileDateToDateTime(FileGetDate(fs.Handle));
            header := (abs(Now - nDate) > 0.04);
            fs.Seek(0, soFromEnd);
        end
        else begin
            fs := TFileStream.Create(fn, fmCreate, fmShareDenyNone);

            // put some UTF-8 header fu in here
            buff := '<html><head>';
            buff := buff + '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
            buff := buff + '</head>';
            fs.Write(Pointer(buff)^, Length(buff));

            // Make sure to put a new conversation header
            header := true;
        end;

        if (header) then begin
            buff := '<p><font size=+1><b>New Conversation at: ' +
                DateTimeToStr(jDateTime) + '</b></font><br />';
            fs.Write(Pointer(buff)^, Length(buff));
        end;

        buff := _getMsgHTML(log);
        fs.Write(Pointer(buff)^, Length(buff));
        fs.Free();
    except
        on e: Exception do begin
            MessageDlg(sCouldNotFindFile + fn, mtError, [mbOK], 0);
            exit;
        end;
    end;

    j.Free();
end;

{---------------------------------------}
function THTMLLogger.SetupFrameSet(dir: string; base_fn, munged_name: WideString ):boolean;
var
    fs: TFileStream;
    buff: string;
    frameset_fn: Widestring;
    dates_fn: Widestring;
    oldlogexists: boolean;
    basedir: string;
begin
    Result := false;
    frameset_fn := dir + munged_name + '.html';
    dates_fn := base_fn + '_dates.html';
    basedir := dir + munged_name + '\';
    oldlogexists := false;

    // Frameset
    try
        if (FileExists(frameset_fn)) then begin
            // File does exist, see if it is old or new log
            // - THIS IS A TOTAL HACK! to get around old logs
            fs := TFileStream.Create(frameset_fn, fmOpenReadWrite, fmShareDenyNone);
            SetLength(buff, 1024); // we should know within first 1K bytes if this is old or new
            fs.Read(Pointer(buff)^, 1024);
            fs.Free();
            if (Pos('name="log_frame"/></frameset>', buff) = 0) then begin
                // didn't find this so, must be old log file (HACK)
                if ( not RenameFile(frameset_fn, dir + munged_name + '_old.html')) then begin
                    MessageDlg('Could not rename old log file: ' + frameset_fn, mtError, [mbOK], 0);
                    exit;
                end;
                oldlogexists := true;
            end;
        end;

        if (not FileExists(frameset_fn)) then begin
            // Frameset for this JID doesn't exist so we need to create one.
            CreateDirectory(PAnsiChar(basedir), nil);
            fs := TFileStream.Create(frameset_fn, fmCreate, fmShareDenyNone);

            // put some UTF-8 header fu in here
            buff := '<html><head>';
            buff := buff + '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
            buff := buff + '</head>';
            fs.Write(Pointer(buff)^, Length(buff));
            buff := '<frameset cols="20%,*"><frame src="';
            buff := buff + munged_name + '\' + munged_name + '_dates.html' + '" name="date_frame"/><frame src="';
            buff := buff + '" name="log_frame"/></frameset></html>';
            fs.Write(Pointer(buff)^, Length(buff));
            fs.Free();
        end;
    except
        on e: Exception do begin
            MessageDlg(sCouldNotFindFile + frameset_fn, mtError, [mbOK], 0);
            exit;
        end;
    end;

    // Dates
    try
        if (not FileExists(dates_fn)) then begin
            // Frameset for this JID doesn't exist so we need to create one.
            fs := TFileStream.Create(dates_fn, fmCreate, fmShareDenyNone);

            // put some UTF-8 header fu in here
            buff := '<html><head>';
            buff := buff + '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
            buff := buff + '</head>';
            fs.Write(Pointer(buff)^, Length(buff));
            buff := '<body>';
            if (oldlogexists) then begin
                buff := buff + '<a target="log_frame" href="' + '../' + munged_name + '_old.html">Old Logs</a><br/>';
            end;
            fs.Write(Pointer(buff)^, Length(buff));
            fs.Free();
        end;
    except
        on e: Exception do begin
            MessageDlg(sCouldNotFindFile + dates_fn, mtError, [mbOK], 0);
            exit;
        end;
    end;

    Result := true;
end;

{---------------------------------------}
procedure THTMLLogger._showLog(jid: Widestring);
var
    fn: string;
begin
    // Show the log, or ask the user to turn on logging
    fn := _path + '\' + MungeName(jid) + '.html';
    if (not FileExists(fn)) then begin
        MessageDlgW('There is no history for this contact.', mtError, [mbOK]);
        exit;
    end;

    ShellExecute(0, 'open', PChar(fn), '', '', SW_NORMAL);
end;

{---------------------------------------}
procedure THTMLLogger._clearLog(jid: Widestring);
var
    fn: string;
    dn: string;
begin
    if (MessageDlgW(WideFormat(sConfirmClearLog, [jid]),
        mtConfirmation, [mbOK,mbCancel]) = mrCancel) then
        exit;

    fn := _path;
    if (Copy(fn, length(fn), 1) <> '\') then
        fn := fn + '\';

    // Munge the filename
    fn := fn + MungeName(jid);
    dn := fn;
    fn := fn + '.html';
    if FileExists(fn) then begin
        if (DeleteFile(PChar(fn))) then begin
            // work on dir now
            if (DirectoryExists(dn)) then begin
                if (DelDir(dn)) then begin
                    MessageDlgW(sHistoryDeleted, mtInformation, [mbOK]);
                end
                else
                    MessageDlgW(sHistoryError, mtError, [mbCancel]);
            end
            else
                MessageDlgW(sHistoryDeleted, mtInformation, [mbOK]);
        end
        else
            MessageDlgW(sHistoryError, mtError, [mbCancel]);
    end
    else
        MessageDlgW(sHistoryNone, mtWarning, [mbOK,mbCancel]);
end;

{---------------------------------------}
procedure THTMLLogger.purgeLogs();
var
    fn: string;
begin
    if (MessageDlgW(sConfirmClearAllLogs,
        mtConfirmation, [mbOK,mbCancel]) = mrCancel) then exit;

    fn := _path;
    if (AnsiRightStr(fn, 1) = '\') then
        fn := AnsiLeftStr(fn, Length(fn) - 1);

    // Probably easiest to just delete directory and then recreate
    if (DelDir(fn)) then begin
        CreateDirectory(PAnsiChar(fn), nil);
        MessageDlgW(sFilesDeleted, mtInformation, [mbOK]);
    end
    else
        MessageDlgW(sHistoryError, mtError, [mbCancel]);
end;


{---------------------------------------}
{---------------------------------------}
{            IExodusLogger              }
{---------------------------------------}
{---------------------------------------}
function THTMLLogger.Get_isDateEnabled: WordBool;
begin
    Result := false;
end;

procedure THTMLLogger.Clear(const jid: WideString);
begin
    _clearLog(jid);
end;

procedure THTMLLogger.GetDays(const jid: WideString; Month, Year: Integer;
  const Listener: IExodusLogListener);
begin
    // NOT IMPL
end;

procedure THTMLLogger.GetMessages(const jid: WideString; ChunkSize, Day,
  Month, Year: Integer; Cancel: WordBool;
  const Listener: IExodusLogListener);
begin
    // NOT IMPL
end;

procedure THTMLLogger.LogMessage(const Msg: IExodusLogMsg);
begin
    _logMessage(Msg);
end;

procedure THTMLLogger.Purge;
begin
    purgeLogs();
end;

procedure THTMLLogger.Show(const jid: WideString);
begin
    _showLog(jid);
end;


procedure THTMLLogger.NewIncomingIM(const JID: WideString;
  const instantMsg: IExodusChat);
begin

end;

function THTMLLogger.Get_Configurable: WordBool;
begin
  Result := true;
end;

initialization
  TAutoObjectFactory.Create(ComServer, THTMLLogger, Class_HTMLLogger,
    ciMultiInstance, tmApartment);
end.
