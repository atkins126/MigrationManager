{***********************************************************************}
{                          Project Migration                            }
{                                                                       }
{ Unit: Model.Migrator                                                  }
{                                                                       }
{ Descrição:                                                            }
{   Implementa a classe TMigrator, responsável por gerenciar o processo }
{   de migração de dados de um banco de dados ADS para PostgreSQL,      }
{   utilizando interfaces para facilitar a configuração e execução.     }
{                                                                       }
{ Autor: Ricardo R. Pereira                                             }
{ Data: 26 de outubro de 2024                                           }
{                                                                       }
{ Copyright (C) 2024 Ricardo R. Pereira                                 }
{                                                                       }
{ Todos os direitos reservados.                                         }
{                                                                       }
{***********************************************************************}

unit Model.Migrator;

interface

uses
  System.SysUtils,
  Model.Uteis.Callback,
  Model.Uteis.Connection,
  Model.DBFToPostgre,
  Repository.Migration.Manager;

type
  /// <summary>
  ///   Classe responsável por gerenciar a migração de dados de uma base
  ///   de dados ADS para PostgreSQL, oferecendo métodos para configurar
  ///   a conexão e executar a migração.
  /// </summary>
  TMigrator = class(TInterfacedObject, IMigrator)
  private
    FConnection: IConnection;
    FDBFToPostgre: IDBFToPostgre;

  protected
    /// <summary>
    ///   Define o endereço do servidor (host).
    /// </summary>
    /// <param name="AValue">
    ///   Endereço do servidor (host).
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function Host(const AValue: string): IMigrator;

    /// <summary>
    ///   Define o caminho para o banco de dados ADS.
    /// </summary>
    /// <param name="AValue">
    ///   Caminho do banco de dados ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function Path(const AValue: string): IMigrator;

    /// <summary>
    ///   Define o nome do banco de dados PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome do banco de dados PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function Database(const AValue: string): IMigrator;

    /// <summary>
    ///   Define o usuário para a conexão com o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Nome de usuário do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function User(const AValue: string): IMigrator;

    /// <summary>
    ///   Define a senha para a conexão com o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Senha do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function Password(const AValue: string): IMigrator;

    /// <summary>
    ///   Define a porta de conexão para o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Número da porta para a conexão.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function Port(const AValue: Integer): IMigrator; overload;

    /// <summary>
    ///   Define a porta de conexão para o banco de dados utilizando uma string.
    /// </summary>
    /// <param name="AValue">
    ///   Número da porta em formato string.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function Port(const AValue: string): IMigrator; overload;

    /// <summary>
    ///   Define um callback para monitorar o progresso da migração.
    /// </summary>
    /// <param name="AValue">
    ///   Função de callback do tipo <see cref="TProgressCallback"/>.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function Callback(const AValue: TProgressCallback): IMigrator; overload;

    /// <summary>
    ///   Define o nome da tabela de origem no banco ADS.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela no banco ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function ADSTableName(const AValue: string): IMigrator;

    /// <summary>
    ///   Define o nome da tabela de destino no banco PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela no banco PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function PGTableName(const AValue: string): IMigrator;

    /// <summary>
    ///   Executa o processo de migração de dados do banco ADS para PostgreSQL.
    /// </summary>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>.
    /// </returns>
    function Execute: IMigrator; overload;

    /// <summary>
    ///   Construtor da classe TMigrator. Inicializa as instâncias
    ///   necessárias para a migração.
    /// </summary>
    constructor Create;
  public
    /// <summary>
    ///   Destrutor da classe TMigrator. Libera os recursos alocados.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   Cria uma nova instância de <see cref="IMigrator"/>.
    /// </summary>
    /// <returns>
    ///   Retorna uma instância da interface <see cref="IMigrator"/>.
    /// </returns>
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
    .PGConnection(FConnection.GetPGConnection).MigrateTable;
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
      raise Exception.Create('Erro ao definir a porta do Servidor: ' +
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

