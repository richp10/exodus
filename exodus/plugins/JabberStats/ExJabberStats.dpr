library ExJabberStats;

uses
  ComServ,
  StatsPlugin in 'StatsPlugin.pas' {StatsPlugin: CoClass},
  XMLUtils in '..\..\..\jopl\XMLUtils.pas',
  JabberID in '..\..\..\jopl\JabberID.pas',
  LibXmlParser in '..\..\..\jopl\LibXmlParser.pas',
  SecHash in '..\..\..\jopl\SecHash.pas',
  Unicode in '..\..\..\jopl\Unicode.pas',
  XMLAttrib in '..\..\..\jopl\XMLAttrib.pas',
  XMLCData in '..\..\..\jopl\XMLCData.pas',
  XMLConstants in '..\..\..\jopl\XMLConstants.pas',
  XMLNode in '..\..\..\jopl\XMLNode.pas',
  XMLParser in '..\..\..\jopl\XMLParser.pas',
  XMLTag in '..\..\..\jopl\XMLTag.pas',
  Config in 'Config.pas' {frmConfig},
  buttonFrame in '..\..\buttonFrame.pas' {frameButtons: TFrame},
  Stringprep in '..\..\..\jopl\Stringprep.pas',
  ExJabberStats_TLB in 'ExJabberStats_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
