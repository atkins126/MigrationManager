unit Model.Migrator;

interface

uses
  System.SysUtils,
  Model.Callback,
  Model.Connection,
  Model.DBFToPostgre;

type
  TMigrator = class
  private
    FConnection: TConnection;
    FDBFToPostgre: TDBFToPostgre;
  public
    constructor Create;
    destructor Destroy; override;

    function ConfigureConnections(const DBFPath, Host, Database, User,
      Password: string; Port: Integer): TMigrator;

    function ExecuteMigration(const DBFTableName, PGTableName: string)
      : TMigrator; overload;

    function ExecuteMigration(const DBFTableName, PGTableName: string;
      ProgressCallback: TProgressCallback): TMigrator; overload;

    class function New: TMigrator;
  end;

implementation

{ TMigrator }
constructor TMigrator.Create;
begin
  FConnection := TConnection.New;
end;

destructor TMigrator.Destroy;
begin
  FDBFToPostgre.DisposeOf;
  FConnection.DisposeOf;
  inherited;
end;

function TMigrator.ExecuteMigration(const DBFTableName, PGTableName: string;
  ProgressCallback: TProgressCallback): TMigrator;
begin
  Result := Self;

  if Assigned(FDBFToPostgre) then
    FDBFToPostgre.MigrateTable(DBFTableName, PGTableName, ProgressCallback)
  else
    raise Exception.Create
      ('Migrador não está configurado. Certifique-se de configurar as conexões primeiro.');

end;

function TMigrator.ConfigureConnections(const DBFPath, Host, Database, User,
  Password: string; Port: Integer): TMigrator;
begin
  Result := Self;

  FConnection.ConnectDBF(DBFPath);
  FConnection.ConnectPostgreSQL(Host, Database, User, Password, Port);

  FDBFToPostgre := TDBFToPostgre.New(FConnection.GetDBFConnection,
    FConnection.GetPGConnection);
end;

function TMigrator.ExecuteMigration(const DBFTableName, PGTableName: string)
  : TMigrator;

begin
  Result := Self;

  if Assigned(FDBFToPostgre) then
    FDBFToPostgre.MigrateTable(DBFTableName, PGTableName)
  else
    raise Exception.Create
      ('Migrador não está configurado. Certifique-se de configurar as conexões primeiro.');
end;

class function TMigrator.New: TMigrator;
begin
  Result := Self.Create;
end;

end.
