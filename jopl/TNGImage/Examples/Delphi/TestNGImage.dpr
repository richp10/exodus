program TestNGImage;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  NGTypes in '..\..\Package\NGTypes.pas',
  NGImages in '..\..\Package\NGImages.pas',
  NGJPEG in '..\..\Package\NGJPEG.pas',
  NGConst in '..\..\Package\NGConst.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
