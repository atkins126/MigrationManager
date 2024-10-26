unit Migration.Manager;

interface

uses
  System.SysUtils,
  Model.Uteis.Callback,
  Model.Migrator,

  Repository.Migration.Manager;

type
  TMigrationManager = class(TInterfacedObject, IMigrationManager)
  private
    FMigrator: IMigrator;
  protected
    function Host(const AValue: string): IMigrationManager;
    function Path(const AValue: string): IMigrationManager;
    function Database(const AValue: string): IMigrationManager;
    function User(const AValue: string): IMigrationManager;
    function Password(const AValue: string): IMigrationManager;
    function Port(const AValue: Integer): IMigrationManager; overload;
    function Port(const AValue: string): IMigrationManager; overload;
    function Callback(const AValue: TProgressCallback): IMigrationManager; overload;
    function ADSTableName(const AValue: string): IMigrationManager;
    function PGTableName(const AValue: string): IMigrationManager;

    function Execute: IMigrationManager; overload;

    function Status: string;

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

function TMigrationManager.Database(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.Database(AValue);
end;

destructor TMigrationManager.Destroy;
begin
  inherited;
end;

function TMigrationManager.Execute: IMigrationManager;
begin
  Result := Self;
  try
    FMigrator.Execute;
  except
    on E: Exception do
      raise Exception.Create('Erro durante a execução da migração: ' +
        E.Message);
  end;
end;

function TMigrationManager.ADSTableName(
  const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.ADSTableName(AValue);
end;

function TMigrationManager.Callback(
  const AValue: TProgressCallback): IMigrationManager;
begin
  Result := Self;
  FMigrator.Callback(AValue);
end;

function TMigrationManager.Status: string;
begin
  Result := 'Migração concluída com sucesso!';
end;

function TMigrationManager.Host(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.Host(AValue);
end;

class function TMigrationManager.New: IMigrationManager;
begin
  Result := Self.Create;
end;

function TMigrationManager.Password(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.Password(AValue);
end;

function TMigrationManager.Path(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.Path(AValue);
end;

function TMigrationManager.PGTableName(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.PGTableName(AValue);
end;

function TMigrationManager.Port(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.Port(AValue);
end;

function TMigrationManager.Port(const AValue: Integer): IMigrationManager;
begin
  Result := Self;
  FMigrator.Port(AValue);
end;

function TMigrationManager.User(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.User(AValue);
end;

end.
