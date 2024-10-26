unit Model.Uteis.BuildTable;

interface

uses
  Repository.Migration.Manager,
  Data.DB,
  FireDAC.Comp.Client;

type
  TBuildTable = class(TInterfacedObject, IBuildTable)
  private
    FQuery: TFDQuery;
    FTableName: string;
    FConnection: TFDConnection;
  protected
    function Connection(const AValue: TFDConnection): IBuildTable;
    function Query(const AValue: TFDQuery): IBuildTable;
    function TableName(const AValue: string): IBuildTable;
    function DBFToPostgreSQL: IBuildTable;

    Constructor Create;
  public
    Destructor Destroy; override;
    class function New: IBuildTable;
  end;

implementation

uses
  System.Classes,
  Model.Uteis.TypeMapper,
  System.SysUtils;

{ TBuildTable }

function TBuildTable.Connection(const AValue: TFDConnection): IBuildTable;
begin
  Result := Self;
  FConnection := AValue;
end;

constructor TBuildTable.Create;
begin

end;

function TBuildTable.DBFToPostgreSQL: IBuildTable;
var
  LSQL: TStringList;
  I: Integer;
  LFieldName: string;
  LFieldType: string;
begin
  if (not Assigned(FQuery)) or (FQuery = nil) then
    raise Exception.Create('A consulta (Query) não foi inicializada. ' +
      'Por favor, inicialize a consulta antes de prosseguir.');

  if FTableName.Trim.IsEmpty then
    raise Exception.Create('O nome da tabela não foi informado. ' +
      'Por favor, insira um nome de tabela válido antes de prosseguir.');

  if (not Assigned(FConnection)) or (FConnection = nil) then
    raise Exception.Create
      ('A conexão com o banco de dados não foi inicializada. ' +
      'Por favor, configure a conexão antes de prosseguir.');

  LSQL := TStringList.Create;
  try
    LSQL.Add('CREATE TABLE IF NOT EXISTS ' + FTableName + ' (');

    for I := 0 to Pred(FQuery.FieldCount) do
    begin
      LFieldName := FQuery.Fields[I].FieldName;
      LFieldType := TMapTypeMapper.New.FieldType(FQuery.Fields[I].DataType)
        .DBFToPostgreSQL;

      LSQL.Add(Format('"%s" %s', [LFieldName, LFieldType]));

      if I < Pred(FQuery.FieldCount) then
        LSQL[Pred(LSQL.Count)] := LSQL[Pred(LSQL.Count)] + ',';
    end;

    LSQL.Add(');');

    FConnection.ExecSQL(LSQL.Text);
  finally
    LSQL.Free;
  end;
end;

destructor TBuildTable.Destroy;
begin

  inherited;
end;

class function TBuildTable.New: IBuildTable;
begin
  Result := Self.Create;
end;

function TBuildTable.Query(const AValue: TFDQuery): IBuildTable;
begin
  Result := Self;
  FQuery := AValue;
end;

function TBuildTable.TableName(const AValue: string): IBuildTable;
begin
  Result := Self;
  FTableName := AValue;
end;

end.
