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
unit COMExodusDataStore;

{$WARN SYMBOL_PLATFORM OFF}


interface

uses
    ComObj, ActiveX, Exodus_TLB,
    StdVcl, SQLiteTable3;

type
  TDataStoreErrors = (no_error,
                      unknown,
                      no_db,
                      no_sql_statement,
                      no_results_table,
                      failed_create_table,
                      no_filename,
                      sqlite_exception);

  TExodusDataStore = class(TAutoObject, IExodusDataStore)
  protected

  private
    // Variables
    _DBHandle: TSQLiteDatabase;
    _ErrorCode: TDataStoreErrors;
    _sqliteExceptionStr: widestring;

    // Methods
    function _OpenDBFile(filename: widestring): boolean;
    procedure _CloseDBFile();

  public
    // IExodusDataStore Interface
    function ExecSQL(const SQLStatement: WideString): WordBool; safecall;
    function GetTable(const SQLStatement: WideString; var ResultTable: IExodusDataTable): WordBool; safecall;
    function GetLastError: Integer; safecall;
    function GetErrorString(ErrorCode: Integer): WideString; safecall;


    constructor Create(filename: widestring);
    destructor Destroy();

    function CheckForTableExistence(tablename: widestring): boolean;

  end;

const
    sNO_DB = 'SQLite database not open';
    sNO_SQL_STATEMENT = 'Empty SQL statement supplied';
    sNO_ERROR = 'No error';
    sNO_RESULT_TABLE = 'No result table supplied';
    sFAILED_CREATE_TABLE = 'Failed to create SQLite result table';
    sNO_FILENAME = 'No filename supplied';
    sUNKNOWN = 'Unknown error';

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ,
    sysUtils,
    COMExodusDataTable,
    DebugManager;

{---------------------------------------}
constructor TExodusDataStore.Create(filename: widestring);
begin
    inherited Create;

    _ErrorCode := no_error;

    try
        _OpenDBFile(filename);
    except
        on e: ESqliteException do begin
            _ErrorCode := sqlite_exception;
            _sqliteExceptionStr := e.Message;
        end;
        else begin
            _ErrorCode := unknown;
        end;
    end;
end;

{---------------------------------------}
destructor TExodusDataStore.Destroy;
begin
    _CloseDBFile();

    inherited;
end;

{---------------------------------------}
function TExodusDataStore.ExecSQL(const SQLStatement: WideString): WordBool;
begin
    Result := false;
    if (_DBHandle = nil) then begin
        _ErrorCode := no_db;
        exit;
    end;
    if (SQLStatement = '') then begin
        _ErrorCode := no_sql_statement;
        exit;
    end;

    DebugMessage('DataStore ExecSQL statement:  ' + SQLStatement);

    try
        _DBHandle.ExecSQL(SQLStatement);
        _ErrorCode := no_error;
        Result := true;
    except
        on e: ESqliteException do begin
            _ErrorCode := sqlite_exception;
            _sqliteExceptionStr := e.Message;
        end;
        else begin
            _ErrorCode := unknown;
        end;
    end;
end;

{---------------------------------------}
function TExodusDataStore.GetTable(const SQLStatement: WideString; var ResultTable: IExodusDataTable): WordBool;
var
    sqlTable: TSQLiteTable;
begin
    Result := false;
    if (_DBHandle = nil) then begin
        _ErrorCode := no_db;
        exit;
    end;
    if (SQLStatement = '') then begin
        _ErrorCode := no_sql_statement;
        exit;
    end;
    if (ResultTable = nil) then begin
        _ErrorCode := no_results_table;
        exit;
    end;

    DebugMessage('DataStore GetTable statement:  ' + SQLStatement);

    try
        sqlTable := _DBHandle.GetTable(SQLStatement);

        if (sqlTable <> nil) then begin
            ExodusDataTableMap.AddTable(ResultTable.SQLTableID, sqlTable);
            _ErrorCode := no_error;
            Result := true;
        end
        else begin
            _ErrorCode := failed_create_table;
        end;
    except
        on e: ESqliteException do begin
            _ErrorCode := sqlite_exception;
            _sqliteExceptionStr := e.Message;
        end;
        else begin
            _ErrorCode := unknown;
        end;
    end;
end;

{---------------------------------------}
function TExodusDataStore._OpenDBFile(filename: widestring): boolean;
begin
    Result := false;
    if (filename = '') then begin
        _ErrorCode := no_filename;
        exit;
    end;

    if (_DBHandle <> nil) then begin
        _CloseDBFile();
    end;

    // Try to open/create the file as SQLite DB
    _DBHandle := TSQLiteDatabase.Create(filename); // Raises Exception on I/O error

    Result := true;
end;

{---------------------------------------}
function TExodusDataStore.CheckForTableExistence(tablename: widestring): boolean;
begin
    Result := false;
    if (_DBHandle = nil) then begin
        _ErrorCode := no_db;
        exit;
    end;

    Result := _DBHandle.TableExists(tablename);
end;

{---------------------------------------}
procedure TExodusDataStore._CloseDBFile();
begin
    if (_DBHandle = nil) then begin
        _ErrorCode := no_db;
        exit;
    end;

    _DBHandle.Free();
    _DBHandle := nil;
end;

{---------------------------------------}
function TExodusDataStore.GetLastError: Integer;
begin
    case _ErrorCode of
        no_error: Result := 0;
        unknown: Result := 1;
        no_db: Result := 2;
        no_sql_statement: Result := 3;
        no_results_table: Result := 4;
        failed_create_table: Result := 5;
        no_filename: Result := 6;
        sqlite_exception: Result := 7;
    end;
end;

{---------------------------------------}
function TExodusDataStore.GetErrorString(ErrorCode: Integer): WideString;
begin
    case ErrorCode of
        0: Result := sNO_ERROR;
        1: Result := sUNKNOWN;
        2: Result := sNO_DB;
        3: Result := sNO_SQL_STATEMENT;
        4: Result := sNO_RESULT_TABLE;
        5: Result := sFAILED_CREATE_TABLE;
        6: Result := sNO_FILENAME;
        7: Result := _sqliteExceptionStr;
        else Result := sUNKNOWN;
    end;
end;





initialization
  TAutoObjectFactory.Create(ComServer, TExodusDataStore, Class_ExodusDataStore,
    ciMultiInstance, tmApartment);

end.
