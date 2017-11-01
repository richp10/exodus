program jopl_sample;

{%File 'defaults.xml'}
{$R 'defaults.res' 'defaults.rc'}

uses
  Forms,
  Main in 'Main.pas' {Form1},
  XMLVCard in '..\XMLVCard.pas',
  Agents in '..\Agents.pas',
  Chat in '..\Chat.pas',
  ChatController in '..\ChatController.pas',
  IQ in '..\IQ.pas',
  JabberAuth in '..\JabberAuth.pas',
  JabberID in '..\JabberID.pas',
  JabberConst in '..\JabberConst.pas',
  JabberMsg in '..\JabberMsg.pas',
  Langs in '..\Langs.pas',
  LibXmlComps in '..\LibXmlComps.pas',
  LibXmlParser in '..\LibXmlParser.pas',
  MsgList in '..\MsgList.pas',
  MsgController in '..\MsgController.pas',
  PrefController in '..\PrefController.pas',
  Presence in '..\Presence.pas',
  Responder in '..\Responder.pas',
  Roster in '..\Roster.pas',
  S10n in '..\S10n.pas',
  SecHash in '..\SecHash.pas',
  Session in '..\Session.pas',
  Signals in '..\Signals.pas',
  Unicode in '..\Unicode.pas',
  XMLAttrib in '..\XMLAttrib.pas',
  XMLCData in '..\XMLCData.pas',
  XMLConstants in '..\XMLConstants.pas',
  XMLHttpStream in '..\XMLHttpStream.pas',
  XMLNode in '..\XMLNode.pas',
  XMLParser in '..\XMLParser.pas',
  XMLSocketStream in '..\XMLSocketStream.pas',
  XMLStream in '..\XMLStream.pas',
  XMLTag in '..\XMLTag.pas',
  XMLUtils in '..\XMLUtils.pas',
  StandardAuth in '..\StandardAuth.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
