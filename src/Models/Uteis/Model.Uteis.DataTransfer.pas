{***********************************************************************}
{                                                                       }
{                          Project Migration                            }
{                                                                       }
{ Unit: Model.Uteis.DataTransfer                                        }
{                                                                       }
{ Descrição:                                                            }
{   Implementa a classe TDataTransfer, que realiza a transferência de   }
{   dados entre consultas usando FireDAC e executa operações de inserção}
{   em lote com controle de progresso.                                  }
{                                                                       }
{ Autor: Ricardo R. Pereira                                             }
{ Data: 26 de outubro de 2024                                           }
{                                                                       }
{ Copyright (C) 2024 Ricardo R. Pereira                                 }
{                                                                       }
{ Todos os direitos reservados.                                         }
{                                                                       }
{***********************************************************************}

unit Model.Uteis.DataTransfer;

interface

uses
  Repository.Migration.Manager,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  Model.Uteis.Callback;

type
  /// <summary>
  ///   Classe responsável por gerenciar a transferência de dados entre
  ///   consultas usando FireDAC, com suporte a operações em lote e
  ///   callbacks de progresso.
  /// </summary>
  TDataTransfer = class(TInterfacedObject, IDataTransfer)
  private
    FConnection: TFDConnection;
    FQuery: TFDQuery;
    FQueryAux: TFDQuery;
    FTableName: string;
    FCallback: TProgressCallback;
    FBlockSize: Int64;

    /// <summary>
    ///   Prepara a instrução SQL de inserção com base nos campos da consulta.
    /// </summary>
    procedure PrepareInsertSQL;

    /// <summary>
    ///   Preenche os parâmetros da consulta auxiliar com os valores da
    ///   consulta principal.
    /// </summary>
    /// <param name="AIndex">
    ///   Índice do parâmetro a ser preenchido.
    /// </param>
    procedure FillParams(AIndex: Int64);

    /// <summary>
    ///   Executa a transferência de dados em lotes, utilizando os parâmetros
    ///   configurados e o callback de progresso.
    /// </summary>
    procedure ExecuteTransfer;
  protected
    /// <summary>
    ///   Define a conexão a ser utilizada na transferência de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Instância de <see cref="TFDConnection"/> para o banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDataTransfer"/>.
    /// </returns>
    function Connection(const AValue: TFDConnection): IDataTransfer;

    /// <summary>
    ///   Define a consulta a ser utilizada como fonte dos dados.
    /// </summary>
    /// <param name="AValue">
    ///   Instância de <see cref="TFDQuery"/> com os dados a serem transferidos.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDataTransfer"/>.
    /// </returns>
    function Query(const AValue: TFDQuery): IDataTransfer;

    /// <summary>
    ///   Define o nome da tabela de destino para a transferência de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela de destino.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDataTransfer"/>.
    /// </returns>
    function TableName(const AValue: string): IDataTransfer;

    /// <summary>
    ///   Define um callback para monitorar o progresso da transferência.
    /// </summary>
    /// <param name="AValue">
    ///   Função de callback do tipo <see cref="TProgressCallback"/>.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDataTransfer"/>.
    /// </returns>
    function Callback(const AValue: TProgressCallback): IDataTransfer;

    /// <summary>
    ///   Define o tamanho do bloco de registros a ser transferido em cada
    ///   operação de inserção em lote.
    /// </summary>
    /// <param name="AValue">
    ///   Tamanho do bloco (número de registros).
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDataTransfer"/>.
    /// </returns>
    function BlockSize(const AValue: Int64): IDataTransfer;

    /// <summary>
    ///   Executa a transferência de dados, utilizando as configurações fornecidas.
    /// </summary>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDataTransfer"/>.
    /// </returns>
    /// <remarks>
    ///   Levanta exceções caso as configurações estejam incompletas ou inválidas.
    /// </remarks>
    function Execute: IDataTransfer;

    /// <summary>
    ///   Construtor da classe TDataTransfer. Inicializa a instância e os
    ///   recursos necessários para a transferência de dados.
    /// </summary>
    Constructor Create;
  public
    /// <summary>
    ///   Destrutor da classe TDataTransfer. Libera os recursos alocados.
    /// </summary>
    Destructor Destroy; override;

    /// <summary>
    ///   Cria uma nova instância de <see cref="IDataTransfer"/>.
    /// </summary>
    /// <returns>
    ///   Retorna uma instância da interface <see cref="IDataTransfer"/>.
    /// </returns>
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

