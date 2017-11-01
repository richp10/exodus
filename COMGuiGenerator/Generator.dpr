program Generator;

uses
  Forms,
  Generate in 'Generate.pas' {frmGen};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGen, frmGen);
  Application.Run;
end.
