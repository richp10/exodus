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
unit DebugManager;


interface

uses
	Classes,
    Unicode,
    XMLTag,
    SysUtils;

type
	IDebugLogger = interface (IInterface)
        procedure DebugStatement(msg: Widestring; dt: TDateTime);
        procedure DataSent(xml: TXMLTag; data: Widestring; dt: TDateTime);
        procedure DataRecv(xml: TXMLTag; data: Widestring; dt: TDateTime);
	end;
  	
  	TDebugManager = class
  	private
  		// Variables
        _dbglist: TWidestringList;
  		
  		// Methods

  	protected
  		// Variables
        _dataCB: integer;

  		// Methods
        function _getInterface(obj: TObject): IDebugLogger;

  	public
  		// Variables

  		// Methods
        procedure DataCallback(event: string; tag: TXMLTag; data: Widestring);
        procedure AddDebugger(debuggerName: widestring; debugger: TObject);
        procedure RemoveDebugger(debuggerName: widestring);
        procedure DebugStatement(msg: Widestring);

  		// Constructor/Destructor
		constructor Create();
        destructor Destroy(); Override;
  	end;

procedure DebugMessage(txt: Widestring);

{$IFDEF EXODUS}
const
    sfAddr: integer = 1;
    sfUnit: integer = 2;
    sfProc: integer = 4;
    sfLine: integer = 8;
    sfAll: integer = 15;

procedure DebugMessageEx(msg: widestring; id: widestring = '');
procedure DebugStackTrace(caption: Widestring);
{$ENDIF}

procedure StartDBGManager();
procedure StopDBGManager();

var
    dbgManager: TDebugManager;

implementation

uses
{$IFDEF EXODUS}
    debug,
    JclDebug,
{$ENDIF}
    Session,
    DebugLogger;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TDebugManager.Create();
begin
	inherited;

    _dbglist := TWideStringList.Create();
    _dataCB := MainSession.RegisterCallback(DataCallback);
end;

{---------------------------------------}
destructor TDebugManager.Destroy();
begin
    MainSession.UnRegisterCallback(_dataCB);
    _dbglist.Clear();
    _dbglist.Free();
end;

{---------------------------------------}
procedure TDebugManager.DataCallback(event: string; tag: TXMLTag; data: Widestring);
var
    i: integer;
    debugger: IDebugLogger;
begin
    for i := 0 to _dbglist.Count - 1 do begin
        debugger := _getInterface(_dbglist.Objects[i]);
        if (debugger <> nil) then begin
            if (event = '/data/debug') then begin
                if (Trim(data) <> '') then
                    debugger.DebugStatement(data, Now());
            end
            else if (event = '/data/send') then begin
                debugger.DataSent(tag, data, Now());
            end
            else if (event = '/data/recv') then begin
                debugger.DataRecv(tag, data, Now());
            end;
        end;
    end;
end;

{---------------------------------------}
procedure TDebugManager.AddDebugger(debuggerName: widestring; debugger: TObject);
var
    temp: IDebugLogger;
begin
    _dbglist.AddObject(debuggerName, debugger);
    temp := _getInterface(debugger);
    temp._AddRef;
end;

{---------------------------------------}
procedure TDebugManager.RemoveDebugger(debuggerName: Widestring);
var
    index: integer;
begin
    index := _dbglist.IndexOf(debuggerName);
    if (index >= 0) then begin
        _dbglist.Delete(index);
    end;
end;

{---------------------------------------}
procedure TDebugManager.DebugStatement(msg: Widestring);
var
    i: integer;
    debugger: IDebugLogger;
begin
    if (Trim(msg) = '') then exit;
    
    for i := 0 to _dbglist.Count - 1 do begin
        debugger := _getInterface(_dbglist.Objects[i]);
        if (debugger <> nil) then begin
            debugger.DebugStatement(msg, Now());
        end;
    end;
end;

{---------------------------------------}
function TDebugManager._getInterface(obj: TObject): IDebugLogger;
begin
    Result := nil;

    if (obj is TDebugLogFile) then
        Result := TDebugLogFile(obj)
{$IFDEF EXODUS}
    else if (obj is TfrmDebug) then
        Result := TfrmDebug(obj);
{$ENDIF}
end;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure DebugMessage(txt: Widestring);
begin
    if (dbgManager = nil) then exit;

    dbgManager.DebugStatement(txt);
end;

{$IFDEF EXODUS}
{---------------------------------------}
function StackFrameToString(level: integer; showFlags: integer = 15): widestring;
var
  locInfo: TJclLocationInfo;
  procAddr: Pointer;
  unitname, paddr, proc, line: string;
begin
    Result := '';
    procAddr := Caller(level);
    if ((procAddr <> nil) and GetLocationInfo(procAddr, locInfo))then
    begin
        unitName := locinfo.UnitName;
        paddr := IntToHex(Integer(locInfo.Address), 8);
        proc := locinfo.ProcedureName;
        line := IntToStr(locInfo.LineNumber);

        //remove unit from proc if it's there...
        if (Pos(unitName + '.', locinfo.ProcedureName) = 1) then
            proc := Copy(proc, Length(unitName) + 2, Length(proc));

        if ((showFlags and sfAddr) <> 0) then
            Result := '[' + paddr + '] ';

        if ((showFlags and sfUnit) <> 0) then
            Result := Result + unitName + '.';

        if ((showFlags and sfProc) <> 0) then
            Result := Result + proc + ' ';

        if ((showFlags and sfLine) <> 0) then
            Result := Result + 'Line ' + line;
    end;
end;

{---------------------------------------}
function GetStackTrace(startFrame: integer = 3): widestring;
var
    currFrame: Integer;
    oneFrame: widestring;
begin
    Result := '';
    currFrame := startFrame; //start 3 deep to skip unwanted frames
    oneFrame := StackFrameToString(currFrame, sfAll);
    while (oneFrame <> '') do
    begin
        Result := Result + oneFrame + #13#10;
        inc(currFrame);
        oneFrame := StackFrameToString(currFrame, sfAll);
    end;
end;

{---------------------------------------}
procedure DebugStackTrace(caption: Widestring);
var
    wsl: TWidestringlist;
begin
    if (dbgManager = nil) then exit;

    wsl := TWideStringList.create();
    wsl.Add('Stack Trace for: ' + caption);
    wsl.Add('---------------------------------------');
    wsl.Add(GetStackTrace());
    wsl.Add('---------------------------------------');
    dbgManager.DebugStatement(wsl.Text);
    wsl.free();
end;

{---------------------------------------}
procedure DebugMessageEx(msg: widestring; id: widestring);
var
    tstr: widestring;
begin
    if (dbgManager = nil) then exit;

    tstr := ' ';
    if (id <> '') then
        tstr := tstr + '(' + id + ') ';//note space
    tstr := tstr + msg;

    //0->stackframetostring, 1-> DebugMessageEx 2-> caller
    debugMessage(StackFrameToString(2, sfUnit or sfProc) + tstr);
end;
{$ENDIF}

{---------------------------------------}
procedure StartDBGManager();
begin
    if (dbgManager = nil) then
        dbgManager := TDebugManager.Create();
end;

{---------------------------------------}
procedure StopDBGManager();
begin
    dbgManager.Free();
    dbgManager := nil;
end;

end.
