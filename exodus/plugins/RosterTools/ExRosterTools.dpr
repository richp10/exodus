library ExRosterTools;

uses
  ComServ,
  RosterPlugin in 'RosterPlugin.pas' {RosterPlugin: CoClass},
  Import in 'Import.pas' {frmImport},
  buttonFrame in '..\..\buttonFrame.pas' {frameButtons: TFrame},
  XMLUtils in '..\..\..\jopl\XMLUtils.pas',
  LibXmlParser in '..\..\..\jopl\LibXmlParser.pas',
  SecHash in '..\..\..\jopl\SecHash.pas',
  Unicode in '..\..\..\jopl\Unicode.pas',
  XMLAttrib in '..\..\..\jopl\XMLAttrib.pas',
  XMLCData in '..\..\..\jopl\XMLCData.pas',
  XMLConstants in '..\..\..\jopl\XMLConstants.pas',
  XMLNode in '..\..\..\jopl\XMLNode.pas',
  XMLParser in '..\..\..\jopl\XMLParser.pas',
  XMLTag in '..\..\..\jopl\XMLTag.pas',
  ExRosterTools_TLB in 'ExRosterTools_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
