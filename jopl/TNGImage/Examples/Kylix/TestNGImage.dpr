program TestNGImage;

uses
  QForms,
  Main in 'Main.pas' {MainForm},
  NGConst in '../../Package/NGConst.pas',
  NGImages in '../../Package/NGImages.pas',
  NGTypes in '../../Package/NGTypes.pas',
  NGBitmap in '../../Package/NGBitmap.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
