library ExHTMLLogger;

uses
  ComServ,
  ExHTMLLogger_TLB in 'ExHTMLLogger_TLB.pas',
  LoggerPlugin in 'LoggerPlugin.pas' {HTMLLogger: CoClass},
  HtmlPrefs in 'HtmlPrefs.pas' {frmHtmlPrefs},
  HtmlUtils in 'HtmlUtils.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
