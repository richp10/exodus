library ExImportICQ;

uses
  ComServ,
  ICQPlugin in 'ICQPlugin.pas' {ICQImportPlugin: CoClass},
  Importer in 'Importer.pas' {frmImport},
  icqUtils in 'icqUtils.pas',
  LibXmlParser in '..\..\..\jopl\LibXmlParser.pas',
  Unicode in '..\..\..\jopl\Unicode.pas',
  XMLAttrib in '..\..\..\jopl\XMLAttrib.pas',
  XMLCData in '..\..\..\jopl\XMLCData.pas',
  XMLConstants in '..\..\..\jopl\XMLConstants.pas',
  XMLNode in '..\..\..\jopl\XMLNode.pas',
  XMLParser in '..\..\..\jopl\XMLParser.pas',
  XMLTag in '..\..\..\jopl\XMLTag.pas',
  XMLUtils in '..\..\..\jopl\XMLUtils.pas',
  LibXmlComps in '..\..\..\jopl\LibXmlComps.pas',
  SecHash in '..\..\..\jopl\SecHash.pas',
  ExImportICQ_TLB in 'ExImportICQ_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
