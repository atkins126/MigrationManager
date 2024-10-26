program MigrationManager;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Migration.Manager in 'src\Migration.Manager.pas',
  Model.Callback in 'src\Model\Model.Callback.pas',
  Model.Connection in 'src\Model\Model.Connection.pas',
  Model.DBFToPostgre in 'src\Model\Model.DBFToPostgre.pas',
  Model.Migrator in 'src\Model\Model.Migrator.pas';

begin

end.
