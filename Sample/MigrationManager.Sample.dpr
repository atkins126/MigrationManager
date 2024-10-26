program MigrationManager.Sample;

uses
  Vcl.Forms,
  View.Main in 'Views\View.Main.pas' {PageMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPageMain, PageMain);
  Application.Run;
end.
