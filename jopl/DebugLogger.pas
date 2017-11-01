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
unit DebugLogger;


interface
uses
    XMLTag, DebugManager;
type

    TDebugLogFile = class (TInterfacedObject, IDebugLogger)
    private
        _filename : Widestring;
        _logfile  : TextFile;
        _isLogging : Boolean;
        procedure Init();
        procedure RotateLog();
        procedure output(data: widestring; dt: TDateTime);

    public
        constructor Create(filename: Widestring);
        destructor  Destroy(); override;

        // IDebugLogger
        procedure DebugStatement(msg: Widestring; dt: TDateTime);
        procedure DataSent(xml: TXMLTag; data: Widestring; dt: TDateTime);
        procedure DataRecv(xml: TXMLTag; data: Widestring; dt: TDateTime);
    end;

var
    debugLogFile : TDebugLogFile;

procedure StartDebugLogger(filename: Widestring);
procedure StopDebugLogger();

implementation
uses
    WideStrUtils,
    XMLParser,
    SysUtils, Session;
const
    MAX_BACKUPS = 5;
{---------------------------------------}
constructor TDebugLogFile.Create(filename: Widestring);
begin
    _filename := filename;
    Init();
end;

{---------------------------------------}
procedure TDebugLogFile.Init();
var
    time: String;
begin
    
    if (FileExists(_filename)) then begin
        RotateLog();
    end;
        
    try
        AssignFile(_logfile, _filename);
        try
            Rewrite(_logfile);
        except
            on e: EInOutError do begin
                DateTimeToString(time, 'hhmmss', Now());
                _filename := _filename + '.' + time;
                try
                    // Attempt rename of log file with timestamp
                    AssignFile(_logfile, _filename);
                    Rewrite(_logfile);
                except
                    // Attempt failed, no file logging
                    _isLogging := false;
                    exit;
                end;
            end
            else begin
                // Some other IO error.  
                _isLogging := false;
                exit;
            end;
        end;
    except
        _isLogging := false;
        exit;
    end;

    _isLogging := true;

    dbgManager.AddDebugger('dbgfile', Self);

end;
{---------------------------------------}
destructor TDebugLogFile.Destroy();
begin
    if (_isLogging) then begin
        dbgManager.RemoveDebugger('dbgfile');
        CloseFile(_logfile);
    end;
end;
{---------------------------------------}
procedure TDebugLogFile.RotateLog();
var
    i        : Integer;
    backfile : Widestring;
begin
    //Loop through log files and rotate backups
    for i := MAX_BACKUPS - 1 downto 0 do begin
        backfile := _filename;
        if (i > 0) then begin
            backfile := backfile + '.' + IntToStr(i);
            if (FileExists(backfile)) then begin
                DeleteFile(ChangeFileExt(backfile, '.' + IntToStr(i + 1)));
                RenameFile(backfile, ChangeFileExt(backfile, '.' + IntToStr(i + 1)));
            end;
        end
        else begin
            DeleteFile(backfile + '.1');
            RenameFile(backfile, backfile + '.1');
        end;
    end;
end;

function getObfuscatedData(event : String; tag : TXMLTag; data : WideString) : WideString;
const
    PASSWORD_NAME : WideString = 'password'; //don't localize
    PASSWORD_TAG  : string = '<password>';
var
    ptag        : TXMLTag;
    ctags       : TXMLTagList;
    xmlParser   : TXMLTagParser;
begin
    Result := data;
    if (((event = '/data/send') or (event = '/data/recv')) and
        (data <> '') and (AnsiPos(PASSWORD_TAG, data) <> 0)) then begin
        //attempt ot build xml tag from data, so we can manipluate it...
        xmlParser := TXMLTagParser.Create();
        try
            xmlParser.ParseString(data, '');
            ptag := xmlParser.popTag;
            //get pass element
            ctags := ptag.QueryRecursiveTags(PASSWORD_NAME, true);
            if ((ctags.Count > 0) and (ctags[0].Data <> ''))then begin
                ctags[0].ClearCData();
                ctags[0].AddCData('*******');
            end;
            Result := ptag.XML;
            ptag.Free();
        finally
            xmlParser.Free();
        end;
    end;
end;

{---------------------------------------}
procedure TDebugLogFile.DebugStatement(msg: Widestring; dt: TDateTime);
begin
    output(msg, dt);
end;

{---------------------------------------}
procedure TDebugLogFile.DataSent(xml: TXMLTag; data: Widestring; dt: TDateTime);
var
    tstr: Widestring;
begin
    tstr := getObfuscatedData('/data/send', xml, data);
    output('SENT: ' + tstr, dt);
end;

{---------------------------------------}
procedure TDebugLogFile.DataRecv(xml: TXMLTag; data: Widestring; dt: TDateTime);
var
    tstr: Widestring;
begin
    tstr := getObfuscatedData('/data/recv', xml, data);
    output('RECV: ' + tstr, dt);
end;

procedure TDebugLogFile.output(data: widestring; dt: TDateTime);
var
    time: string;
begin
    DateTimeToString(time, 'yyyy-mm-dd hh:mm:ss.zzz', Now());
    data := '[' + time + ']  ' + data + ''#13#10;
    try
    	WRITE(_logfile, data);
    except	
	end;
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure StartDebugLogger(filename: Widestring);
begin
    if (debugLogFile = nil) then
        debugLogFile := TDebugLogFile.Create(filename);
end;

{---------------------------------------}
procedure StopDebugLogger();
begin
    if (debugLogFile <> nil) then begin
        debugLogFile._Release;
        debugLogFile := nil;
    end;
end;

end.
