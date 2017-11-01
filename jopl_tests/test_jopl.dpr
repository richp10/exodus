program test_jopl;

uses
  Forms,
  TestFramework,
  GUITestRunner,
  test_xmltag in 'test_xmltag.pas',
  JabberMsg in '..\jopl\JabberMsg.pas',
  LibXmlComps in '..\jopl\LibXmlComps.pas',
  LibXmlParser in '..\jopl\LibXmlParser.pas',
  Signals in '..\jopl\Signals.pas',
  XMLAttrib in '..\jopl\XMLAttrib.pas',
  XMLCData in '..\jopl\XMLCData.pas',
  XMLConstants in '..\jopl\XMLConstants.pas',
  XMLNode in '..\jopl\XMLNode.pas',
  XMLParser in '..\jopl\XMLParser.pas',
  XMLStream in '..\jopl\XMLStream.pas',
  XMLTag in '..\jopl\XMLTag.pas',
  XMLUtils in '..\jopl\XMLUtils.pas',
  XMLVCard in '..\jopl\XMLVCard.pas',
  JabberID in '..\jopl\JabberID.pas',
  sechash in '..\jopl\SecHash.pas',
  test_xmlparser in 'test_xmlparser.pas',
  test_dispatcher in 'test_dispatcher.pas',
  XMLSocketStream in '..\jopl\XMLSocketStream.pas',
  test_xmlstream in 'test_xmlstream.pas',
  PrefController in '..\jopl\PrefController.pas',
  Presence in '..\jopl\Presence.pas',
  Session in '..\jopl\Session.pas',
  Chat in '..\jopl\Chat.pas',
  ChatController in '..\jopl\ChatController.pas',
  Roster in '..\jopl\Roster.pas',
  IQ in '..\jopl\IQ.pas',
  XMLHttpStream in '..\jopl\XMLHttpStream.pas',
  S10n in '..\jopl\S10n.pas',
  Unicode in '..\jopl\Unicode.pas',
  test_widestringlist in 'test_widestringlist.pas',
  test_prep in 'test_prep.pas',
  stringprep in '..\jopl\stringprep.pas',
  RegExpr in '..\jopl\RegExpr.pas';

{$R *.res}

var
  MyForm: TGUITestRunner;

begin
  Application.Initialize;

  // Hack DUnit so that it automatically runs the tests

  Application.Title := 'DUnit';
  //Application.CreateForm(TGUITestRunner, MyForm);
  Application.CreateForm(TGUITestRunner, MyForm);
  with MyForm do begin
        Show();
        suite := registeredTests;
        //RunActionExecute(nil);
  end;

  Application.Run();

end.
