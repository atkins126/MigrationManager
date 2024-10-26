{***********************************************************************}
{                          Project Migration                            }
{                                                                       }
{ Unit: Model.DBFToPostgre                                              }
{                                                                       }
{ Descrição:                                                            }
{   Implementa a classe TDBFToPostgre, que realiza a migração de dados  }
{   de uma tabela DBF para uma tabela PostgreSQL, incluindo a criação   }
{   da estrutura e a transferência de registros.                        }
{                                                                       }
{ Autor: Ricardo R. Pereira                                             }
{ Data: 26 de outubro de 2024                                           }
{                                                                       }
{ Copyright (C) 2024 Ricardo R. Pereira                                 }
{                                                                       }
{ Todos os direitos reservados.                                         }
{                                                                       }
{***********************************************************************}

unit Model.DBFToPostgre;

interface

uses
  Repository.Migration.Manager,
  FireDAC.Comp.Client,
  Model.Uteis.Callback;

type
  /// <summary>
  ///   Classe responsável por migrar dados de uma tabela DBF para uma
  ///   tabela PostgreSQL, incluindo a criação da tabela no destino e a
  ///   transferência de registros.
  /// </summary>
  TDBFToPostgre = class(TInterfacedObject, IDBFToPostgre)
  private
    FADSConnection: TFDConnection;
    FPGConnection: TFDConnection;
    FADSTableName: string;
    FPGTableName: string;
    FCallback: TProgressCallback;

  protected
    /// <summary>
    ///   Define a conexão com o banco de dados ADS (Advantage Database Server).
    /// </summary>
    /// <param name="AValue">
    ///   Instância de <see cref="TFDConnection"/> para o banco ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDBFToPostgre"/>.
    /// </returns>
    function ADSConnection(const AValue: TFDConnection): IDBFToPostgre;

    /// <summary>
    ///   Define a conexão com o banco de dados PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Instância de <see cref="TFDConnection"/> para o PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDBFToPostgre"/>.
    /// </returns>
    function PGConnection(const AValue: TFDConnection): IDBFToPostgre;

    /// <summary>
    ///   Define o nome da tabela de origem no banco ADS.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela de origem no banco ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDBFToPostgre"/>.
    /// </returns>
    function ADSTableName(const AValue: string): IDBFToPostgre;

    /// <summary>
    ///   Define o nome da tabela de destino no banco PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela de destino no PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDBFToPostgre"/>.
    /// </returns>
    function PGTableName(const AValue: string): IDBFToPostgre;

    /// <summary>
    ///   Define um callback para monitorar o progresso da migração.
    /// </summary>
    /// <param name="AValue">
    ///   Função de callback do tipo <see cref="TProgressCallback"/>.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IDBFToPostgre"/>.
    /// </returns>
    function Callback(const AValue: TProgressCallback): IDBFToPostgre;

    /// <summary>
    ///   Realiza a migração dos dados de uma tabela DBF para uma tabela
    ///   PostgreSQL, incluindo a criação da estrutura e a inserção dos
    ///   registros.
    /// </summary>
    /// <remarks>
    ///   Levanta exceções caso a migração falhe, realizando o rollback
    ///   da transação para garantir a integridade dos dados.
    /// </remarks>
    function MigrateTable: IDBFToPostgre;

    /// <summary>
    ///   Construtor da classe TDBFToPostgre. Inicializa a instância.
    /// </summary>
    constructor Create;
  public
    /// <summary>
    ///   Destrutor da classe TDBFToPostgre. Libera os recursos alocados.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   Cria uma nova instância de <see cref="IDBFToPostgre"/>.
    /// </summary>
    /// <returns>
    ///   Retorna uma instância da interface <see cref="IDBFToPostgre"/>.
    /// </returns>
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
  // Inicialização da instância
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

