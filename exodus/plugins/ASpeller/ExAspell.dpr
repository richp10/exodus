library ExASpell;

uses
  ComServ,
  ExASpell_TLB in 'ExASpell_TLB.pas',
  SpellPlugin in 'SpellPlugin.pas' {SpellPlugin: CoClass},
  ChatSpeller in 'ChatSpeller.pas' {ChatSpeller: CoClass},
  AspellHeadersDyn in 'AspellHeadersDyn.pas',
  Unicode in '..\..\..\jopl\Unicode.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
