library ExIRCPlugin;

uses
  ComServ,
  ExIRCPlugin_TLB in 'ExIRCPlugin_TLB.pas',
  IRCPlugin in 'IRCPlugin.pas' {IRCPlugin: CoClass},
  Login in 'Login.pas' {frmStartSession},
  buttonFrame in '..\..\buttonFrame.pas' {frameButtons: TFrame},
  IRCSession in 'IRCSession.pas' {frmIRC},
  JabberID in '..\..\..\jopl\JabberID.pas',
  RoomPlugin in 'RoomPlugin.pas' {IRCRoomPlugin: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
