unit Model.Migrator;

interface

uses
  System.SysUtils,
  Model.Uteis.Callback,
  Model.Uteis.Connection,
  Model.DBFToPostgre,
  Repository.Migration.Manager;

type
  TMigrator = class(TInterfacedObject, IMigrator)
  private
    FConnection: IConnection;
    FDBFToPostgre: IDBFToPostgre;

  protected
    function Host(const AValue: string): IMigrator;
    function Path(const AValue: string): IMigrator;
    function Database(const AValue: string): IMigrator;
    function User(const AValue: string): IMigrator;
    function Password(const AValue: string): IMigrator;
    function Port(const AValue: Integer): IMigrator; overload;
    function Port(const AValue: string): IMigrator; overload;
    function Callback(const AValue: TProgressCallback): IMigrator; overload;
    function ADSTableName(const AValue: string): IMigrator;
    function PGTableName(const AValue: string): IMigrator;

    function Execute: IMigrator; overload;

    constructor Create;
  public
    destructor Destroy; override;

    class function New: IMigrator;
  end;

implementation

{ TMigrator }
function TMigrator.ADSTableName(const AValue: string): IMigrator;
begin
  Result := Self;
  FDBFToPostgre.ADSTableName(AValue);
end;

function TMigrator.Callback(const AValue: TProgressCallback): IMigrator;
begin
  Result := Self;
  FDBFToPostgre.Callback(AValue);
end;

constructor TMigrator.Create;
begin
  FConnection := TConnection.New;
  FDBFToPostgre := TDBFToPostgre.New;
end;

function TMigrator.Database(const AValue: string): IMigrator;
begin
  Result := Self;
  FConnection.Database(AValue);
end;

destructor TMigrator.Destroy;
begin

  inherited;
end;

function TMigrator.Execute: IMigrator;
begin
  Result := Self;

  FDBFToPostgre.ADSConnection(FConnection.GetADSConnection)
    .PGConnection(FConnection.GetPGConnection).MigrateTable
end;

function TMigrator.Host(const AValue: string): IMigrator;
begin
  Result := Self;
  FConnection.Host(AValue);
end;

class function TMigrator.New: IMigrator;
begin
  Result := Self.Create;
end;

function TMigrator.Password(const AValue: string): IMigrator;
begin
  Result := Self;
  FConnection.Password(AValue);
end;

function TMigrator.Path(const AValue: string): IMigrator;
begin
  Result := Self;
  FConnection.Path(AValue);
end;

function TMigrator.PGTableName(const AValue: string): IMigrator;
begin
  Result := Self;
  FDBFToPostgre.PGTableName(AValue);
end;

function TMigrator.Port(const AValue: string): IMigrator;
begin
  Result := Self;
  try
    FConnection.Port(AValue.ToInt64);
  except
    on E: Exception do
      raise Exception.Create('Erro ao definir a port do Servidor: ' +
        E.Message);
  end;
end;

function TMigrator.Port(const AValue: Integer): IMigrator;
begin
  Result := Self;
  FConnection.Port(AValue);
end;

function TMigrator.User(const AValue: string): IMigrator;
begin
  Result := Self;
  FConnection.User(AValue);
end;

end.
