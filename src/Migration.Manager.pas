unit Migration.Manager;

interface

uses
  System.SysUtils,
  Model.Callback,
  Model.Migrator,

  Repository.Migration.Manager;

type
  TMigrationManager = class(TInterfacedObject, IMigrationManager)
  private
    FMigrator: IMigrator;
  protected
    function ConfigureMigration(const DBFPath, Host, Database, User,
      Password: string; Port: Integer): IMigrationManager;

    function ExecuteMigration(const DBFTableName, PGTableName: string)
      : IMigrationManager; overload;

    function ExecuteMigration(const DBFTableName, PGTableName: string;
      ProgressCallback: TProgressCallback): IMigrationManager; overload;

    function GetMigrationStatus: string;

    constructor Create;
  public
    destructor Destroy; override;


    class function New: IMigrationManager;
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
  inherited;
end;

function TMigrationManager.ExecuteMigration(const DBFTableName,
  PGTableName: string; ProgressCallback: TProgressCallback): IMigrationManager;
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
  User, Password: string; Port: Integer): IMigrationManager;
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
  PGTableName: string): IMigrationManager;
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

class function TMigrationManager.New: IMigrationManager;
begin
  Result := Self.Create;
end;

end.
