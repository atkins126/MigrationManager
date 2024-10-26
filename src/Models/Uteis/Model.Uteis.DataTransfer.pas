unit Model.Uteis.DataTransfer;

interface

uses
  Repository.Migration.Manager,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,

  Model.Uteis.Callback;

type
  TDataTransfer = class(TInterfacedObject, IDataTransfer)
  private
    FConnection: TFDConnection;
    FQuery: TFDQuery;
    FQueryAux: TFDQuery;
    FTableName: string;
    FCallback: TProgressCallback;
    FBlockSize: Int64;

    procedure PrepareInsertSQL;
    procedure FillParams(AIndex: Int64);
    procedure ExecuteTransfer;
  protected

    function Connection(const AValue: TFDConnection): IDataTransfer;
    function Query(const AValue: TFDQuery): IDataTransfer;
    function TableName(const AValue: string): IDataTransfer;
    function Callback(const AValue: TProgressCallback): IDataTransfer;
    function BlockSize(const AValue: Int64): IDataTransfer;

    function Execute: IDataTransfer;

    Constructor Create;
  public
    Destructor Destroy; override;
    class function New: IDataTransfer;
  end;

implementation

uses
  System.SysUtils,
  System.Variants,
  System.Classes,

  Data.DB,

  Model.Uteis.RTFHandle;

{ TDataTransfer }

function TDataTransfer.BlockSize(const AValue: Int64): IDataTransfer;
begin
  Result := Self;
  FBlockSize := AValue;
end;

function TDataTransfer.Callback(const AValue: TProgressCallback): IDataTransfer;
begin
  Result := Self;
  FCallback := AValue;
end;

function TDataTransfer.Connection(const AValue: TFDConnection): IDataTransfer;
begin
  Result := Self;
  FConnection := AValue;
  FQueryAux.Connection := FConnection;
end;

constructor TDataTransfer.Create;
begin
  FQueryAux := TFDQuery.Create(nil);
  FBlockSize := 350;
end;

destructor TDataTransfer.Destroy;
begin
  FQueryAux.DisposeOf;
  inherited;
end;

function TDataTransfer.Execute: IDataTransfer;
begin
  if (not Assigned(FQuery)) or (FQuery = nil) then
    raise Exception.Create('A consulta (Query) não foi inicializada. ' +
      'Por favor, inicialize a consulta antes de prosseguir.');

  if (not Assigned(FQueryAux)) or (FQueryAux = nil) then
    raise Exception.Create('A consulta AUXILIAR (Query) não foi inicializada. ' +
      'Por favor, inicialize a consulta antes de prosseguir.');

  if FTableName.Trim.IsEmpty then
    raise Exception.Create('O nome da tabela não foi informado. ' +
      'Por favor, insira um nome de tabela válido antes de prosseguir.');

  if (not Assigned(FConnection)) or (FConnection = nil) then
    raise Exception.Create
      ('A conexão com o banco de dados não foi inicializada. ' +
      'Por favor, configure a conexão antes de prosseguir.');

  PrepareInsertSQL;
  ExecuteTransfer;
end;

procedure TDataTransfer.ExecuteTransfer;
var
  I: Int64;
  LTotalRecords: Int64;
  LCurrentRecord: Int64;
begin
  LCurrentRecord := 0;
  LTotalRecords := 0;

  if Assigned(FCallback) then
    LTotalRecords := FQuery.RecordCount;

  FQuery.First;

  while not FQuery.Eof do
  begin
    FQueryAux.Params.ArraySize := FBlockSize;
    I := 0;

    while (not FQuery.Eof) and (I < FBlockSize) do
    begin
      FillParams(I);
      Inc(I);

      if Assigned(FCallback) then
      begin
        Inc(LCurrentRecord);
        FCallback(FTableName, LTotalRecords, LCurrentRecord);
      end;

      FQuery.Next;
    end;

    FQueryAux.Execute(I, 0);
  end;
end;

procedure TDataTransfer.FillParams(AIndex: Int64);
var
  I: Integer;
  LFieldValue: Variant;
begin
  for I := 0 to FQuery.FieldCount - 1 do
  begin
    FQueryAux.Params[I].DataType := FQuery.Fields[I].DataType;
    LFieldValue := FQuery.Fields[I].Value;

    if not VarIsStr(LFieldValue) then
    begin
      FQueryAux.Params[I].Values[AIndex] := LFieldValue;
      Continue;
    end;

    LFieldValue := StringReplace(LFieldValue, #0, '', [rfReplaceAll]);

    if not(FQuery.Fields[I].DataType in [ftMemo, ftWideMemo, ftBlob]) then
    begin
      FQueryAux.Params[I].Values[AIndex] := UTF8Encode(LFieldValue);
      Continue
    end;

    if not(Pos('{\rtf', LFieldValue) > 0) then
    begin
      FQueryAux.Params[I].Values[AIndex] := UTF8Encode(LFieldValue);
      Continue
    end;

    LFieldValue := TRTFHandler.New.RTFText(LFieldValue).RemoveRTFFormatting;

    FQueryAux.Params[I].Values[AIndex] := LFieldValue;
  end;
end;

class function TDataTransfer.New: IDataTransfer;
begin
  Result := Self.Create;
end;

procedure TDataTransfer.PrepareInsertSQL;
var
  I: Integer;
  LParamName: string;
begin
  FQueryAux.SQL.Clear;
  FQueryAux.SQL.Text := 'INSERT INTO ' + FTableName + ' VALUES (';

  for I := 0 to Pred(FQuery.FieldCount) do
  begin
    LParamName := FQuery.Fields[I].FieldName;

    FQueryAux.SQL.Add(':' + LParamName);

    if I < Pred(FQuery.FieldCount) then
      FQueryAux.SQL.Add(',');
  end;

  FQueryAux.SQL.Add(');');
end;

function TDataTransfer.Query(const AValue: TFDQuery): IDataTransfer;
begin
  Result := Self;
  FQuery := AValue;
end;

function TDataTransfer.TableName(const AValue: string): IDataTransfer;
begin
  Result := Self;
  FTableName := AValue;
end;

end.
