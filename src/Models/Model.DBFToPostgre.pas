unit Model.DBFToPostgre;

interface

uses
  Repository.Migration.Manager,
  FireDAC.Comp.Client,
  Model.Uteis.Callback;

type

  TDBFToPostgre = class(TInterfacedObject, IDBFToPostgre)
  private
    FADSConnection: TFDConnection;
    FPGConnection: TFDConnection;
    FADSTableName: string;
    FPGTableName: string;
    FCallback: TProgressCallback;

  protected
    function ADSConnection(const AValue: TFDConnection): IDBFToPostgre;
    function PGConnection(const AValue: TFDConnection): IDBFToPostgre;
    function ADSTableName(const AValue: string): IDBFToPostgre;
    function PGTableName(const AValue: string): IDBFToPostgre;
    function Callback(const AValue: TProgressCallback): IDBFToPostgre;

    function MigrateTable: IDBFToPostgre;

    constructor Create;
  public
    Destructor Destroy; override;

    class function New: IDBFToPostgre;
  end;

implementation

uses
  System.SysUtils,
  Model.Uteis.BuildTable,
  Model.Uteis.DataTransfer;

function TDBFToPostgre.MigrateTable: IDBFToPostgre;
var
  LQuery: TFDQuery;
begin
  Result := Self;

  LQuery := TFDQuery.Create(FADSConnection);
  try
    LQuery.Connection := FADSConnection;
    LQuery.SQL.Text := Format('SELECT * FROM "%s"', [FADSTableName]);

    LQuery.Open;

    FPGConnection.StartTransaction;
    try
      TBuildTable.New.Connection(FPGConnection).Query(LQuery)
        .TableName(FPGTableName).DBFToPostgreSQL;

      TDataTransfer.New.Connection(FPGConnection).Query(LQuery)
        .TableName(FPGTableName).Callback(FCallback).Execute;

      FPGConnection.Commit;
    except
      FPGConnection.Rollback;
      raise;
    end;
  finally
    LQuery.DisposeOf;
  end;
end;

function TDBFToPostgre.ADSConnection(const AValue: TFDConnection)
  : IDBFToPostgre;
begin
  Result := Self;
  FADSConnection := AValue;
end;

function TDBFToPostgre.ADSTableName(const AValue: string): IDBFToPostgre;
begin
  Result := Self;
  FADSTableName := AValue;
end;

function TDBFToPostgre.Callback(const AValue: TProgressCallback): IDBFToPostgre;
begin
  Result := Self;
  FCallback := AValue;
end;

constructor TDBFToPostgre.Create;
begin

end;

destructor TDBFToPostgre.Destroy;
begin

  inherited;
end;

class function TDBFToPostgre.New: IDBFToPostgre;
begin
  Result := Self.Create;
end;

function TDBFToPostgre.PGConnection(const AValue: TFDConnection): IDBFToPostgre;
begin
  Result := Self;
  FPGConnection := AValue;
end;

function TDBFToPostgre.PGTableName(const AValue: string): IDBFToPostgre;
begin
  Result := Self;
  FPGTableName := AValue;
end;

end.
