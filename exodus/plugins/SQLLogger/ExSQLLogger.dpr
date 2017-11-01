library ExSQLLogger;

uses
  ComServ,
  ExSQLLogger_TLB in 'ExSQLLogger_TLB.pas',
  SQLPlugin in 'SQLPlugin.pas' {SQLLogger: CoClass},
  SQLiteTable in 'SQLiteTable.pas',
  SQLite in 'SQLite.pas',
  Viewer in 'Viewer.pas' {frmView},
  SQLUtils in 'SQLUtils.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
