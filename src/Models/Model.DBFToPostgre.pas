unit Model.DBFToPostgre;

interface

uses
  System.Classes,

  Data.DB,

  FireDAC.DatS,
  FireDAC.DApt,
  FireDAC.Phys,
  FireDAC.Comp.UI,
  FireDAC.UI.Intf,
  FireDAC.Phys.PG,
  FireDAC.Stan.Def,
  FireDAC.Phys.ADS,
  FireDAC.Stan.Intf,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.Stan.ResStrs,
  FireDAC.Phys.PGDef,
  FireDAC.Phys.ADSDef,
  FireDAC.Comp.Client,
  FireDAC.Phys.SQLite,
  FireDAC.Stan.Option,
  FireDAC.Comp.DataSet,
  FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.StorageBin,

  Model.Callback,

  Repository.Migration.Manager;

type

  TDBFToPostgre = class(TInterfacedObject, IDBFToPostgre)
  private
    FADSConnection: TFDConnection;
    FPGConnection: TFDConnection;

    FDGUIxWaitCursorADS: TFDGUIxWaitCursor;
    FDGUIxWaitCursorPG: TFDGUIxWaitCursor;

    FDriverADS: TFDPhysADSDriverLink;
    FDriverPG: TFDPhysPgDriverLink;

    function RemoveRTFFormatting(const RTFText: string): string;

    function MapDBFTypeToPostgreSQLType(DBFFieldType: TFieldType): string;
    procedure CreatePostgreSQLTableFromDBF(DBFQuery: TFDQuery;
      const TableName: string);
    procedure TransferData(DBFQuery: TFDQuery;
      const TableName: string); overload;
    procedure TransferData(DBFQuery: TFDQuery; const TableName: string;
      ProgressCallback: TProgressCallback); overload;

  protected
    function MigrateTable(const DBFTableName, PGTableName: string)
      : IDBFToPostgre; overload;

    function MigrateTable(const DBFTableName, PGTableName: string;
      ProgressCallback: TProgressCallback): IDBFToPostgre; overload;

    constructor Create(ADSConnection, PGConnection: TFDConnection);
  public

    class function New(ADSConnection, PGConnection: TFDConnection)
      : IDBFToPostgre;
  end;

implementation

uses
  System.SysUtils,
  System.Variants, Vcl.ComCtrls, Vcl.Forms;

const
  _BLOCK_SIZE = 350;


function TDBFToPostgre.MapDBFTypeToPostgreSQLType(DBFFieldType
  : TFieldType): string;
begin
  case DBFFieldType of
    ftString, ftWideString:
      Result := 'VARCHAR';
    ftFixedChar, ftFixedWideChar:
      Result := 'CHAR';
    ftInteger, ftWord, ftSmallint:
      Result := 'INTEGER';
    ftLargeint:
      Result := 'BIGINT';
    ftFloat:
      Result := 'FLOAT';
    ftCurrency:
      Result := 'MONEY';
    ftBCD, ftFMTBcd:
      Result := 'NUMERIC';
    ftBoolean:
      Result := 'BOOLEAN';
    ftDate:
      Result := 'DATE';
    ftTime:
      Result := 'TIME';
    ftDateTime, ftTimeStamp:
      Result := 'TIMESTAMP';
    ftMemo, ftWideMemo:
      Result := 'TEXT';
    ftBlob, ftGraphic, ftParadoxOle, ftDBaseOle, ftTypedBinary:
      Result := 'BYTEA';
    ftGuid:
      Result := 'UUID';
    ftAutoInc:
      Result := 'SERIAL';
  else
    raise Exception.Create('Tipo de dado do DBF não suportado.');
  end;
end;

function TDBFToPostgre.MigrateTable(const DBFTableName, PGTableName: string;
  ProgressCallback: TProgressCallback): IDBFToPostgre;
var
  DBFQuery: TFDQuery;
begin
  Result := Self;
  FDriverADS.DefaultPath := ExtractFilePath(ParamStr(0));
  FDriverADS.ShowDeleted := False;

  FDriverADS.VendorLib := ExtractFilePath(ParamStr(0)) + 'ace64.dll';

  DBFQuery := TFDQuery.Create(FADSConnection);
  try
    DBFQuery.Connection := FADSConnection;
    DBFQuery.SQL.Text := Format('SELECT * FROM "%s"', [DBFTableName]);
    // Seleciona todos os dados da tabela DBF
    DBFQuery.Open;

    FPGConnection.StartTransaction;
    try
      CreatePostgreSQLTableFromDBF(DBFQuery, PGTableName);
      // Cria a tabela PostgreSQL com base na estrutura do DBF
      TransferData(DBFQuery, PGTableName, ProgressCallback);
      // Transfere os dados para a tabela PostgreSQL
      FPGConnection.Commit;
    except
      FPGConnection.Rollback;
      raise;
    end;
  finally
    DBFQuery.Free;
  end;
end;

constructor TDBFToPostgre.Create(ADSConnection, PGConnection: TFDConnection);
begin
  FADSConnection := ADSConnection;
  FPGConnection := PGConnection;

  FDGUIxWaitCursorPG := TFDGUIxWaitCursor.Create(FPGConnection);
  FDGUIxWaitCursorADS := TFDGUIxWaitCursor.Create(FADSConnection);

  FDGUIxWaitCursorADS.Provider := 'Console'; // Define o provedor do cursor
  FDGUIxWaitCursorPG.Provider := 'Console'; // Define o provedor do cursor

  FDriverADS := TFDPhysADSDriverLink.Create(FADSConnection);
  FDriverPG := TFDPhysPgDriverLink.Create(FADSConnection);

end;

procedure TDBFToPostgre.CreatePostgreSQLTableFromDBF(DBFQuery: TFDQuery;
  const TableName: string);
var
  LSQL: TStringList;
  I: Integer;
  LFieldName: string;
  LFieldType: string;
begin
  LSQL := TStringList.Create;
  try
    LSQL.Add('CREATE TABLE ' + TableName + ' (');
    for I := 0 to DBFQuery.FieldCount - 1 do
    begin
      LFieldName := DBFQuery.Fields[I].FieldName;
      LFieldType := MapDBFTypeToPostgreSQLType(DBFQuery.Fields[I].DataType);
      LSQL.Add(Format('"%s" %s', [LFieldName, LFieldType]));
      if I < DBFQuery.FieldCount - 1 then
        LSQL[LSQL.Count - 1] := LSQL[LSQL.Count - 1] + ',';
    end;
    LSQL.Add(');');

    FPGConnection.ExecSQL(LSQL.Text);
  finally
    LSQL.Free;
  end;
end;

procedure TDBFToPostgre.TransferData(DBFQuery: TFDQuery;
  const TableName: string);
var
  LSQL: TFDQuery;
  I, J: Integer;
  ParamName: string;
  FieldValue: Variant;
begin
  LSQL := TFDQuery.Create(nil);
  try
    LSQL.Connection := FPGConnection;
    LSQL.SQL.Text := 'INSERT INTO ' + TableName + ' VALUES (';
    for I := 0 to DBFQuery.FieldCount - 1 do
    begin
      ParamName := DBFQuery.Fields[I].FieldName;
      LSQL.SQL.Add(':' + ParamName);
      if I < DBFQuery.FieldCount - 1 then
        LSQL.SQL.Add(',');
    end;
    LSQL.SQL.Add(');');

    DBFQuery.First;
    while not DBFQuery.Eof do
    begin
      LSQL.Params.ArraySize := _BLOCK_SIZE; // Define o tamanho do bloco
      J := 0;
      // Preenche os parâmetros do bloco
      while (not DBFQuery.Eof) and (J < _BLOCK_SIZE) do
      begin
        for I := 0 to DBFQuery.FieldCount - 1 do
        begin
          LSQL.Params[I].DataType := DBFQuery.Fields[I].DataType;
          // Tratamento de caracteres nulos e conversão para UTF-8
          FieldValue := DBFQuery.Fields[I].Value;
          if VarIsStr(FieldValue) then
          begin
            FieldValue := StringReplace(FieldValue, #0, '', [rfReplaceAll]); // Remove caracteres nulos

            if DBFQuery.Fields[I].DataType in [ftMemo, ftWideMemo, ftBlob] then
            begin
              if Pos('{\rtf', FieldValue) > 0 then
                FieldValue := RemoveRTFFormatting(FieldValue);
            end
            else
              FieldValue := UTF8Encode(FieldValue); // Converte para UTF-8
          end;
          LSQL.Params[I].Values[J] := FieldValue;
        end;
        Inc(J);

        DBFQuery.Next;
      end;
      // Executa o lote do bloco
      LSQL.Execute(J, 0);
    end;
  finally
    LSQL.Free;
  end;
end;


procedure TDBFToPostgre.TransferData(DBFQuery: TFDQuery;
  const TableName: string; ProgressCallback: TProgressCallback);
var
  LSQL: TFDQuery;
  I, J, TotalRecords, CurrentRecord: Integer;
  ParamName: string;
  FieldValue: Variant;
begin
  LSQL := TFDQuery.Create(nil);
  try
    LSQL.Connection := FPGConnection;
    LSQL.SQL.Text := 'INSERT INTO ' + TableName + ' VALUES (';
    for I := 0 to DBFQuery.FieldCount - 1 do
    begin
      ParamName := DBFQuery.Fields[I].FieldName;
      LSQL.SQL.Add(':' + ParamName);
      if I < DBFQuery.FieldCount - 1 then
        LSQL.SQL.Add(',');
    end;
    LSQL.SQL.Add(');');
    TotalRecords := DBFQuery.RecordCount;
    CurrentRecord := 0;
    DBFQuery.First;
    while not DBFQuery.Eof do
    begin
      LSQL.Params.ArraySize := _BLOCK_SIZE; // Define o tamanho do bloco
      J := 0;
      // Preenche os parâmetros do bloco
      while (not DBFQuery.Eof) and (J < _BLOCK_SIZE) do
      begin
        for I := 0 to DBFQuery.FieldCount - 1 do
        begin
          LSQL.Params[I].DataType := DBFQuery.Fields[I].DataType;
          // Tratamento de caracteres nulos e conversão para UTF-8
          FieldValue := DBFQuery.Fields[I].Value;
          if VarIsStr(FieldValue) then
          begin
            FieldValue := StringReplace(FieldValue, #0, '', [rfReplaceAll]); // Remove caracteres nulos
            if DBFQuery.Fields[I].DataType in [ftMemo, ftWideMemo, ftBlob] then
            begin
              if Pos('{\rtf', FieldValue) > 0 then
                FieldValue := RemoveRTFFormatting(FieldValue);
            end
            else
              FieldValue := UTF8Encode(FieldValue); // Converte para UTF-8
          end;
          LSQL.Params[I].Values[J] := FieldValue;
        end;
        Inc(J);
        Inc(CurrentRecord);
        // Atualiza o progresso na View
        if Assigned(ProgressCallback) then
          ProgressCallback(TableName, TotalRecords, CurrentRecord);
        DBFQuery.Next;
      end;
      // Executa o lote do bloco
      LSQL.Execute(J, 0);
    end;
  finally
    LSQL.Free;
  end;
end;

function TDBFToPostgre.MigrateTable(const DBFTableName, PGTableName: string)
  : IDBFToPostgre;
var
  DBFQuery: TFDQuery;
begin
  Result := Self;
  FDriverADS.DefaultPath := ExtractFilePath(ParamStr(0));
  FDriverADS.ShowDeleted := False;

{$IFDEF WIN32}
  FDriverADS.VendorLib := ExtractFilePath(ParamStr(0)) + 'ace32.dll';
{$ELSE}
  FDriverADS.VendorLib := ExtractFilePath(ParamStr(0)) + 'ace64.dll';
{$ENDIF}

  DBFQuery := TFDQuery.Create(FADSConnection);
  try
    DBFQuery.Connection := FADSConnection;
    DBFQuery.SQL.Text := Format('SELECT * FROM "%s"', [DBFTableName]);
    // Seleciona todos os dados da tabela DBF
    DBFQuery.Open;

    FPGConnection.StartTransaction;
    try
      CreatePostgreSQLTableFromDBF(DBFQuery, PGTableName);
      // Cria a tabela PostgreSQL com base na estrutura do DBF
      TransferData(DBFQuery, PGTableName);
      // Transfere os dados para a tabela PostgreSQL
      FPGConnection.Commit;
    except
      FPGConnection.Rollback;
      raise;
    end;
  finally
    DBFQuery.Free;
  end;
end;

class function TDBFToPostgre.New(ADSConnection, PGConnection: TFDConnection)
  : IDBFToPostgre;
begin
  Result := Self.Create(ADSConnection, PGConnection);
end;


function TDBFToPostgre.RemoveRTFFormatting(const RTFText: string): string;
var
  RtfStream: TStringStream;
  RichEdit: TRichEdit;
  Form: TForm;
begin
  RtfStream := TStringStream.Create(RTFText, TEncoding.UTF8);
  Form := TForm.Create(nil);
  RichEdit := TRichEdit.Create(nil);
  try
    Form.Visible := False;
    RichEdit.Visible := False;
    RichEdit.Parent := Form;
    RichEdit.Clear;
    RtfStream.Position := 0;
    RichEdit.Lines.LoadFromStream(RtfStream);
    Result := TrimRight(RichEdit.Text);
  finally
    Form.DisposeOf;
    RtfStream.Free;
  end;
end;


end.
