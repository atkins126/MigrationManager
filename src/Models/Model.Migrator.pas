unit Model.Migrator;

interface

uses
  System.SysUtils,
  Model.Callback,
  Model.Connection,
  Model.DBFToPostgre,
  Repository.Migration.Manager;

type
  TMigrator = class(TInterfacedObject, IMigrator)
  private
    FConnection: IConnection;
    FDBFToPostgre: IDBFToPostgre;
  protected
    function ConfigureConnections(const DBFPath, Host, Database, User,
      Password: string; Port: Integer): IMigrator;

    function ExecuteMigration(const DBFTableName, PGTableName: string)
      : IMigrator; overload;

    function ExecuteMigration(const DBFTableName, PGTableName: string;
      ProgressCallback: TProgressCallback): IMigrator; overload;

    constructor Create;
  public
    destructor Destroy; override;

    class function New: IMigrator;
  end;

implementation

{ TMigrator }
constructor TMigrator.Create;
begin
  FConnection := TConnection.New;
end;

destructor TMigrator.Destroy;
begin

  inherited;
end;

function TMigrator.ExecuteMigration(const DBFTableName, PGTableName: string;
  ProgressCallback: TProgressCallback): IMigrator;
begin
  Result := Self;

  if Assigned(FDBFToPostgre) then
    FDBFToPostgre.MigrateTable(DBFTableName, PGTableName, ProgressCallback)
  else
    raise Exception.Create
      ('Migrador não está configurado. Certifique-se de configurar as conexões primeiro.');

end;

function TMigrator.ConfigureConnections(const DBFPath, Host, Database, User,
  Password: string; Port: Integer): IMigrator;
begin
  Result := Self;

  FConnection.ConnectDBF(DBFPath);
  FConnection.ConnectPostgreSQL(Host, Database, User, Password, Port);

  FDBFToPostgre := TDBFToPostgre.New(FConnection.GetDBFConnection,
    FConnection.GetPGConnection);
end;

function TMigrator.ExecuteMigration(const DBFTableName, PGTableName: string)
  : IMigrator;

begin
  Result := Self;

  if Assigned(FDBFToPostgre) then
    FDBFToPostgre.MigrateTable(DBFTableName, PGTableName)
  else
    raise Exception.Create
      ('Migrador não está configurado. Certifique-se de configurar as conexões primeiro.');
end;

class function TMigrator.New: IMigrator;
begin
  Result := Self.Create;
end;

end.
