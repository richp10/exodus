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
unit COMExodusDataTable;

{$WARN SYMBOL_PLATFORM OFF}


interface

uses
    ComObj, ActiveX, Exodus_TLB,
    StdVcl, SQLiteTable3, sysUtils,
    Unicode;

type
  TDataTableMapErrors = (no_error,
                         unknown,
                         no_table_data,
                         sqlite_exception);

  TExodusDataTableMap = class
  private
    // Variables
    _tablemap: TWidestringList;

    // Methods
    function _FindTable(tableID: widestring): integer;
  protected
    // Variables

    // Methods
  public
    // Variables

    // Methods
    constructor Create();
    destructor Destroy(); override;

    procedure AddTable(tableID: widestring; table: TSQLiteTable);
    function FindTable(tableID: widestring): TSQLiteTable;
    procedure RemoveTable(tableID: widestring);

    // Properties
  end;

  TExodusDataTable = class(TAutoObject, IExodusDataTable)
  private
    // Variables
    _tableID: widestring;
    _ErrorCode: TDataTableMapErrors;
    _sqliteExceptionStr: widestring;

    // Methdods
    function _GetTable(): TSQLiteTable;

    // Properties
    property _table: TSQLiteTable read _GetTable;

  protected
    // Variables

    // Methdods

  public
    // Variables

    // Methdods
    procedure Initialize(); override;
    destructor Destroy(); override;

    // IExodusDataTable Interface
    function Get_CurrentRow: Integer; safecall;
    function Get_ColCount: Integer; safecall;
    function Get_RowCount: Integer; safecall;
    function Get_IsEndOfTable: WordBool; safecall;
    function Get_IsBeginOfTable: WordBool; safecall;
    function IsFieldNULL(Field: Integer): WordBool; safecall;
    function GetFieldByName(const Name: WideString): WideString; safecall;
    function GetCol(Column: Integer): WideString; safecall;
    function GetField(Field: Integer): WideString; safecall;
    function NextRow: WordBool; safecall;
    function PrevRow: WordBool; safecall;
    function FirstRow: WordBool; safecall;
    function LastRow: WordBool; safecall;
    function GetFieldAsInt(Field: Integer): Integer; safecall;
    function GetFieldAsString(Field: Integer): WideString; safecall;
    function GetFieldAsDouble(Field: Integer): Double; safecall;
    function GetFieldIndex(const Field: WideString): Integer; safecall;
    function Get_SQLTableID: WideString; safecall;
    function GetFieldAsBoolean(Field: Integer): WordBool; safecall;
    function GetLastError: Integer; safecall;
    property CurrentRow: Integer read Get_CurrentRow;
    property ColCount: Integer read Get_ColCount;
    property RowCount: Integer read Get_RowCount;
    property IsEndOfTable: WordBool read Get_IsEndOfTable;
    property IsBeginOfTable: WordBool read Get_IsBeginOfTable;
    property SQLTableID: WideString read Get_SQLTableID;
    function GetErrorString(ErrorCode: Integer): WideString; safecall;

    // Properties

  end;

const
    sNO_TABLE_DATA = 'No table data';
    sNO_ERROR = 'No error';
    sUNKNOWN = 'Unknown error';

var
    ExodusDataTableMap: TExodusDataTableMap;


{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

uses
    ComServ;


{---------------------------------------}
constructor TExodusDataTableMap.Create();
begin
    _tablemap := TWidestringList.Create();
end;

{---------------------------------------}
destructor TExodusDataTableMap.Destroy();
var
    i: integer;
    table: TSQLiteTable;
begin
    for i := _tablemap.Count - 1 downto 0 do begin
        table := TSQLiteTable(_tablemap.Objects[i]);
        if (table <> nil) then begin
            table.Free();
        end;
        _tablemap.Delete(i);
    end;
    _tablemap.Free();
end;

{---------------------------------------}
procedure TExodusDataTableMap.AddTable(tableID: WideString; table: TSQLiteTable);
begin
    if (tableID = '') then exit;
    if (table = nil) then exit;

    RemoveTable(tableID);

    _tablemap.AddObject(tableID, table);
end;

{---------------------------------------}
function TExodusDataTableMap._FindTable(tableID: widestring): integer;
var
    i: integer;
begin
    Result := -1;
    if (tableID = '') then exit;

    if (_tablemap.Find(tableID, i)) then begin
        Result := i;
    end;
end;

{---------------------------------------}
function TExodusDataTableMap.FindTable(tableID: widestring): TSQLiteTable;
var
    i: integer;
begin
    Result := nil;
    if (tableID = '') then exit;

    i := _FindTable(tableID);

    if (i >= 0) then begin
        Result := TSQLiteTable(_tablemap.Objects[i]);
    end;
end;

{---------------------------------------}
procedure TExodusDataTableMap.RemoveTable(tableID: widestring);
var
    i: integer;
begin
    if (tableID = '') then exit;

    i := _FindTable(tableID);
    if (i >= 0) then begin
        try
            TSQLiteTable(_tablemap.Objects[i]).Free();
            _tablemap.Delete(i);
        except
        end;
    end;
end;

{---------------------------------------}
procedure TExodusDataTable.Initialize();
begin
    inherited;
    _sqliteExceptionStr := '';
    _ErrorCode := no_error;
    _tableID := DateTimeToStr(Now());
end;

{---------------------------------------}
destructor TExodusDataTable.Destroy;
begin
    ExodusDataTableMap.RemoveTable(_tableID);

    inherited;
end;

{---------------------------------------}
function TExodusDataTable._GetTable(): TSQLiteTable;
begin
    Result := ExodusDataTableMap.FindTable(_tableID);
end;

{---------------------------------------}
function TExodusDataTable.Get_ColCount: Integer;
begin
    Result := -1;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.ColCount;
        _ErrorCode := no_error;
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
function TExodusDataTable.Get_CurrentRow: Integer;
begin
    Result := -1;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.Row;
        _ErrorCode := no_error;
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
function TExodusDataTable.Get_IsBeginOfTable: WordBool;
begin
    Result := false;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.BOF;
        _ErrorCode := no_error;
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
function TExodusDataTable.Get_IsEndOfTable: WordBool;
begin
    Result := false;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.EOF;
        _ErrorCode := no_error;
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
function TExodusDataTable.Get_RowCount: Integer;
begin
    Result := -1;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.RowCount;
        _ErrorCode := no_error;
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
function TExodusDataTable.GetCol(Column: Integer): WideString;
begin
    Result := '';
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.Columns[Column];
        _ErrorCode := no_error;
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
function TExodusDataTable.GetField(Field: Integer): WideString;
begin
    Result := '';
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.Fields[Field];
        _ErrorCode := no_error;
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
function TExodusDataTable.GetFieldAsDouble(Field: Integer): Double;
begin
    Result := -1;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.FieldAsDouble(Field);
        _ErrorCode := no_error;
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
function TExodusDataTable.GetFieldAsInt(Field: Integer): Integer;
begin
    Result := -1;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.FieldAsInteger(Field);
        _ErrorCode := no_error;
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
function TExodusDataTable.GetFieldAsString(Field: Integer): WideString;
begin
    Result := '';
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.FieldAsString(Field);
        _ErrorCode := no_error;
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
function TExodusDataTable.GetFieldByName(const Name: WideString): WideString;
begin
    Result := '';
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.FieldByName[Name];
        _ErrorCode := no_error;
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
function TExodusDataTable.IsFieldNULL(Field: Integer): WordBool;
begin
    Result := false;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.FieldIsNull(Field);
        _ErrorCode := no_error;
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
function TExodusDataTable.FirstRow: WordBool;
begin
    Result := false;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.MoveFirst;
        _ErrorCode := no_error;
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
function TExodusDataTable.LastRow: WordBool;
begin
    Result := false;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.MoveLast;
        _ErrorCode := no_error;
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
function TExodusDataTable.NextRow: WordBool;
begin
    Result := false;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.Next;
        _ErrorCode := no_error;
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
function TExodusDataTable.PrevRow: WordBool;
begin
    Result := false;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.Previous;
        _ErrorCode := no_error;
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
function TExodusDataTable.GetFieldIndex(const Field: WideString): Integer;
begin
    Result := -1;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.FieldIndex[Field];
        _ErrorCode := no_error;
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
function TExodusDataTable.Get_SQLTableID: WideString;
begin
    Result := _tableID;
end;


{---------------------------------------}
function TExodusDataTable.GetFieldAsBoolean(Field: Integer): WordBool;
begin
    Result := false;
    if (_table = nil) then begin
        _ErrorCode := no_table_data;
        exit;
    end;

    try
        Result := _table.FieldAsBoolean(Field);
        _ErrorCode := no_error;
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
function TExodusDataTable.GetLastError: Integer;
begin
    case _ErrorCode of
        no_error: Result := 0;
        unknown: Result := 1;
        no_table_data: Result := 2;
        sqlite_exception: Result := 3;
    end;
end;

{---------------------------------------}
function TExodusDataTable.GetErrorString(ErrorCode: Integer): WideString;
begin
    case ErrorCode of
        0: Result := sNO_ERROR;
        1: Result := sUNKNOWN;
        2: Result := sNO_TABLE_DATA;
        3: Result := _sqliteExceptionStr;
        else Result := sUNKNOWN;
    end;
end;




initialization
    TAutoObjectFactory.Create(ComServer, TExodusDataTable, Class_ExodusDataTable,
                              ciMultiInstance, tmApartment);

    ExodusDataTableMap := TExodusDataTableMap.Create();

finalization
    ExodusDataTableMap.Free();

end.
