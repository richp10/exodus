library ExImportAIM;

uses
  ComServ,
  AIMPlugin in 'AIMPlugin.pas' {AIMImportPlugin: CoClass},
  Importer in 'Importer.pas' {frmImport},
  Unicode in '..\..\..\jopl\Unicode.pas',
  XMLAttrib in '..\..\..\jopl\XMLAttrib.pas',
  XMLCData in '..\..\..\jopl\XMLCData.pas',
  XMLConstants in '..\..\..\jopl\XMLConstants.pas',
  XMLNode in '..\..\..\jopl\XMLNode.pas',
  XMLParser in '..\..\..\jopl\XMLParser.pas',
  XMLTag in '..\..\..\jopl\XMLTag.pas',
  XMLUtils in '..\..\..\jopl\XMLUtils.pas',
  LibXmlComps in '..\..\..\jopl\LibXmlComps.pas',
  LibXmlParser in '..\..\..\jopl\LibXmlParser.pas',
  SecHash in '..\..\..\jopl\SecHash.pas',
  ExImportAIM_TLB in 'ExImportAIM_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
