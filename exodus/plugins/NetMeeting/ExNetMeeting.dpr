library ExNetMeeting;

uses
  ComServ,
  ExNetMeeting_TLB in 'ExNetMeeting_TLB.pas',
  NMPlugin in 'NMPlugin.pas' {ExNetmeetingPlugin: CoClass},
  Unicode in '..\..\..\jopl\Unicode.pas',
  XMLAttrib in '..\..\..\jopl\XMLAttrib.pas',
  XMLCData in '..\..\..\jopl\XMLCData.pas',
  XMLConstants in '..\..\..\jopl\XMLConstants.pas',
  XMLNode in '..\..\..\jopl\XMLNode.pas',
  XMLTag in '..\..\..\jopl\XMLTag.pas',
  XMLUtils in '..\..\..\jopl\XMLUtils.pas',
  LibXmlComps in '..\..\..\jopl\LibXmlComps.pas',
  LibXmlParser in '..\..\..\jopl\LibXmlParser.pas',
  SecHash in '..\..\..\jopl\SecHash.pas',
  XMLParser in '..\..\..\jopl\XMLParser.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
