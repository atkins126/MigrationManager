{***********************************************************************}
{                          Project Migration                            }
{                                                                       }
{ Unit: Migration.Manager                                               }
{                                                                       }
{ Descrição:                                                            }
{   Implementa a classe TMigrationManager, que gerencia o processo de   }
{   migração de dados utilizando a interface IMigrator, fornecendo uma  }
{   interface simples para configurar e executar a migração.            }
{                                                                       }
{ Autor: Ricardo R. Pereira                                             }
{ Data: 26 de outubro de 2024                                           }
{                                                                       }
{ Copyright (C) 2024 Ricardo R. Pereira                                 }
{                                                                       }
{ Todos os direitos reservados.                                         }
{                                                                       }
{***********************************************************************}

unit Migration.Manager;

interface

uses
  System.SysUtils,
  Model.Uteis.Callback,
  Model.Migrator,
  Repository.Migration.Manager;

type
  /// <summary>
  ///   Classe responsável por gerenciar o processo de migração de dados,
  ///   utilizando a interface IMigrator para realizar a migração de uma
  ///   maneira simplificada.
  /// </summary>
  TMigrationManager = class(TInterfacedObject, IMigrationManager)
  private
    FMigrator: IMigrator;

  protected
    /// <summary>
    ///   Define o endereço do servidor (host).
    /// </summary>
    /// <param name="AValue">
    ///   Endereço do servidor (host).
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function Host(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define o caminho para o banco de dados ADS.
    /// </summary>
    /// <param name="AValue">
    ///   Caminho do banco de dados ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function Path(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define o nome do banco de dados PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome do banco de dados PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function Database(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define o usuário para a conexão com o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Nome de usuário do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function User(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define a senha para a conexão com o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Senha do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function Password(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define a porta de conexão para o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Número da porta para a conexão.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function Port(const AValue: Integer): IMigrationManager; overload;

    /// <summary>
    ///   Define a porta de conexão para o banco de dados utilizando uma string.
    /// </summary>
    /// <param name="AValue">
    ///   Número da porta em formato string.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function Port(const AValue: string): IMigrationManager; overload;

    /// <summary>
    ///   Define um callback para monitorar o progresso da migração.
    /// </summary>
    /// <param name="AValue">
    ///   Função de callback do tipo <see cref="TProgressCallback"/>.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function Callback(const AValue: TProgressCallback): IMigrationManager; overload;

    /// <summary>
    ///   Define o nome da tabela de origem no banco ADS.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela no banco ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function ADSTableName(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define o nome da tabela de destino no banco PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela no banco PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function PGTableName(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Executa o processo de migração de dados.
    /// </summary>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>.
    /// </returns>
    function Execute: IMigrationManager; overload;

    /// <summary>
    ///   Retorna o status da migração.
    /// </summary>
    /// <returns>
    ///   Uma string indicando o status da migração.
    /// </returns>
    function Status: string;

    /// <summary>
    ///   Construtor da classe TMigrationManager. Inicializa a instância.
    /// </summary>
    constructor Create;
  public
    /// <summary>
    ///   Destrutor da classe TMigrationManager. Libera os recursos alocados.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   Cria uma nova instância de <see cref="IMigrationManager"/>.
    /// </summary>
    /// <returns>
    ///   Retorna uma instância da interface <see cref="IMigrationManager"/>.
    /// </returns>
    class function New: IMigrationManager;
  end;

implementation

{ TMigrationManager }

constructor TMigrationManager.Create;
begin
  inherited;
  FMigrator := TMigrator.New;
end;

function TMigrationManager.Database(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.Database(AValue);
end;

destructor TMigrationManager.Destroy;
begin
  inherited;
end;

function TMigrationManager.Execute: IMigrationManager;
begin
  Result := Self;
  try
    FMigrator.Execute;
  except
    on E: Exception do
      raise Exception.Create('Erro durante a execução da migração: ' +
        E.Message);
  end;
end;

function TMigrationManager.ADSTableName(
  const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.ADSTableName(AValue);
end;

function TMigrationManager.Callback(
  const AValue: TProgressCallback): IMigrationManager;
begin
  Result := Self;
  FMigrator.Callback(AValue);
end;

function TMigrationManager.Status: string;
begin
  Result := 'Migração concluída com sucesso!';
end;

function TMigrationManager.Host(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.Host(AValue);
end;

class function TMigrationManager.New: IMigrationManager;
begin
  Result := Self.Create;
end;

function TMigrationManager.Password(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.Password(AValue);
end;

function TMigrationManager.Path(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.Path(AValue);
end;

function TMigrationManager.PGTableName(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.PGTableName(AValue);
end;

function TMigrationManager.Port(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.Port(AValue);
end;

function TMigrationManager.Port(const AValue: Integer): IMigrationManager;
begin
  Result := Self;
  FMigrator.Port(AValue);
end;

function TMigrationManager.User(const AValue: string): IMigrationManager;
begin
  Result := Self;
  FMigrator.User(AValue);
end;

end.

