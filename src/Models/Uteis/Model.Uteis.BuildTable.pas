{***********************************************************************}
{                          Project Migration                            }
{                                                                       }
{ Unit: Model.Uteis.BuildTable                                          }
{                                                                       }
{ Descrição:                                                            }
{   Implementa a classe TBuildTable, que gera a estrutura de tabelas    }
{   PostgreSQL com base em uma consulta DBF, realizando a conversão dos }
{   tipos de dados e criando a tabela no banco de dados.                }
{                                                                       }
{ Autor: Ricardo R. Pereira                                             }
{ Data: 26 de outubro de 2024                                           }
{                                                                       }
{ Copyright (C) 2024 Ricardo R. Pereira                                 }
{                                                                       }
{ Todos os direitos reservados.                                         }
{                                                                       }
{***********************************************************************}

unit Model.Uteis.BuildTable;

interface

uses
  Repository.Migration.Manager,
  Data.DB,
  FireDAC.Comp.Client;

type
  /// <summary>
  ///   Classe responsável por construir tabelas no banco de dados
  ///   PostgreSQL, com base na estrutura de campos de uma consulta DBF.
  /// </summary>
  TBuildTable = class(TInterfacedObject, IBuildTable)
  private
    FQuery: TFDQuery;
    FTableName: string;
    FConnection: TFDConnection;

  protected
    /// <summary>
    ///   Define a conexão com o banco de dados para criação das tabelas.
    /// </summary>
    /// <param name="AValue">
    ///   Instância de <see cref="TFDConnection"/> para o banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IBuildTable"/>.
    /// </returns>
    function Connection(const AValue: TFDConnection): IBuildTable;

    /// <summary>
    ///   Define a consulta que será utilizada como base para a criação da
    ///   tabela.
    /// </summary>
    /// <param name="AValue">
    ///   Instância de <see cref="TFDQuery"/> que contém a estrutura dos dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IBuildTable"/>.
    /// </returns>
    function Query(const AValue: TFDQuery): IBuildTable;

    /// <summary>
    ///   Define o nome da tabela a ser criada no banco de dados PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela de destino.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IBuildTable"/>.
    /// </returns>
    function TableName(const AValue: string): IBuildTable;

    /// <summary>
    ///   Realiza a conversão da estrutura da consulta DBF para uma tabela
    ///   compatível com PostgreSQL.
    /// </summary>
    /// <remarks>
    ///   Levanta exceções caso a consulta, o nome da tabela ou a conexão
    ///   não estejam devidamente configurados.
    /// </remarks>
    function DBFToPostgreSQL: IBuildTable;

    /// <summary>
    ///   Construtor da classe TBuildTable. Inicializa a instância.
    /// </summary>
    constructor Create;
  public
    /// <summary>
    ///   Destrutor da classe TBuildTable. Libera os recursos alocados.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   Cria uma nova instância de <see cref="IBuildTable"/>.
    /// </summary>
    /// <returns>
    ///   Retorna uma instância da interface <see cref="IBuildTable"/>.
    /// </returns>
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
  // Inicialização da instância
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

