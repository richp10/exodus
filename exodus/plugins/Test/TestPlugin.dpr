library TestPlugin;

uses
  ComServ,
  Tester in 'Tester.pas' {TesterPlugin: CoClass},
  TestPlugin_TLB in 'TestPlugin_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
