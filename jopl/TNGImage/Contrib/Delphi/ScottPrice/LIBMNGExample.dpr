program LIBMNGExample;

uses
  Forms,
  uExFrm in 'uExFrm.pas' {fmLIBMNGExample};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmLIBMNGExample, fmLIBMNGExample);
  Application.Run;
end.
