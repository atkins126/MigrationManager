unit Migration.Manager;

interface

uses
  System.SysUtils,
  Model.Callback,
  Model.Migrator;

type
  TMigrationManager = class
  private
    FMigrator: TMigrator;
  public
    constructor Create;
    destructor Destroy; override;

    function ConfigureMigration(const DBFPath, Host, Database, User,
      Password: string; Port: Integer): TMigrationManager;

    function ExecuteMigration(const DBFTableName, PGTableName: string)
      : TMigrationManager; overload;

    function ExecuteMigration(const DBFTableName, PGTableName: string;
      ProgressCallback: TProgressCallback): TMigrationManager; overload;

    function GetMigrationStatus: string;

    class function New: TMigrationManager;
  end;

implementation

{ TMigrationManager }

constructor TMigrationManager.Create;
begin
  inherited;
  FMigrator := TMigrator.New;
end;

destructor TMigrationManager.Destroy;
begin
  FMigrator.Free;
  inherited;
end;

function TMigrationManager.ExecuteMigration(const DBFTableName,
  PGTableName: string; ProgressCallback: TProgressCallback): TMigrationManager;
begin
  Result := Self;
  try
    FMigrator.ExecuteMigration(DBFTableName, PGTableName, ProgressCallback);
  except
    on E: Exception do
      raise Exception.Create('Erro durante a execução da migração: ' +
        E.Message);
  end;
end;

function TMigrationManager.ConfigureMigration(const DBFPath, Host, Database,
  User, Password: string; Port: Integer): TMigrationManager;
begin
  Result := Self;
  try
    FMigrator.ConfigureConnections(DBFPath, Host, Database, User,
      Password, Port);
  except
    on E: Exception do
      raise Exception.Create('Erro na configuração da migração: ' + E.Message);
  end;
end;

function TMigrationManager.ExecuteMigration(const DBFTableName,
  PGTableName: string): TMigrationManager;
begin
  Result := Self;
  try
    FMigrator.ExecuteMigration(DBFTableName, PGTableName);
  except
    on E: Exception do
      raise Exception.Create('Erro durante a execução da migração: ' +
        E.Message);
  end;
end;

function TMigrationManager.GetMigrationStatus: string;
begin
  Result := 'Migração concluída com sucesso!';
end;

class function TMigrationManager.New: TMigrationManager;
begin
  Result := Self.Create;
end;

end.
