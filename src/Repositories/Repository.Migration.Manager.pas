{***********************************************************************}
{                          Project Migration                            }
{                                                                       }
{ Unit: Repository.Migration.Manager                                    }
{                                                                       }
{ Descrição:                                                            }
{   Define interfaces para gerenciar o processo de migração de dados    }
{   de um banco de dados ADS para PostgreSQL, incluindo conexão,        }
{   mapeamento de tipos, manipulação de RTF e transferência de dados.   }
{                                                                       }
{ Autor: Ricardo R. Pereira                                             }
{ Data: 26 de outubro de 2024                                           }
{                                                                       }
{ Copyright (C) 2024 Ricardo R. Pereira                                 }
{                                                                       }
{ Todos os direitos reservados.                                         }
{                                                                       }
{***********************************************************************}

unit Repository.Migration.Manager;

interface

uses
  Model.Uteis.Callback,
  FireDAC.Comp.Client,
  Data.DB;

type
  /// <summary>
  ///   Interface que gerencia o processo completo de migração de dados
  ///   de um banco de dados ADS para PostgreSQL. Fornece métodos para
  ///   configurar as conexões, definir tabelas de origem e destino, e
  ///   executar a migração.
  /// </summary>
  IMigrationManager = interface
    ['{CC399A6F-2B4C-4ED0-92F2-DDC5F512B1B2}']

    /// <summary>
    ///   Define o endereço do servidor (host).
    /// </summary>
    /// <param name="AValue">
    ///   Endereço do servidor (host).
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Host(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define o caminho para o banco de dados ADS.
    /// </summary>
    /// <param name="AValue">
    ///   Caminho do banco de dados ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Path(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define o nome do banco de dados PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome do banco de dados PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Database(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define o usuário para a conexão com o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Nome de usuário do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function User(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define a senha para a conexão com o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Senha do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Password(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define a porta de conexão para o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Número da porta para a conexão.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Port(const AValue: Integer): IMigrationManager; overload;

    /// <summary>
    ///   Define a porta de conexão para o banco de dados utilizando uma string.
    /// </summary>
    /// <param name="AValue">
    ///   Número da porta em formato string.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Port(const AValue: string): IMigrationManager; overload;

    /// <summary>
    ///   Define um callback para monitorar o progresso da migração.
    /// </summary>
    /// <param name="AValue">
    ///   Função de callback do tipo <see cref="TProgressCallback"/> que
    ///   será chamada durante o processo de migração para indicar progresso.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Callback(const AValue: TProgressCallback): IMigrationManager; overload;

    /// <summary>
    ///   Define o nome da tabela de origem no banco ADS.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela no banco ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function ADSTableName(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Define o nome da tabela de destino no banco PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela no banco PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function PGTableName(const AValue: string): IMigrationManager;

    /// <summary>
    ///   Executa o processo de migração de dados entre os bancos.
    /// </summary>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrationManager"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    /// <remarks>
    ///   Este método realiza a migração de dados do banco ADS para o PostgreSQL,
    ///   utilizando as configurações definidas previamente.
    /// </remarks>
    function Execute: IMigrationManager; overload;

    /// <summary>
    ///   Retorna o status da migração, indicando se foi concluída com sucesso.
    /// </summary>
    /// <returns>
    ///   Uma string indicando o status da migração.
    /// </returns>
    function Status: string;
  end;

  /// <summary>
  ///   Interface que realiza a migração de dados de uma tabela do banco
  ///   de dados ADS para uma tabela no banco de dados PostgreSQL.
  ///   Responsável por configurar a origem e destino, e por executar
  ///   o processo de migração.
  /// </summary>
  IMigrator = interface
    ['{9B9B9ACA-80B6-421D-A9EE-78C0A209BE92}']

    /// <summary>
    ///   Define o endereço do servidor (host).
    /// </summary>
    /// <param name="AValue">
    ///   Endereço do servidor (host).
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Host(const AValue: string): IMigrator;

    /// <summary>
    ///   Define o caminho para o banco de dados ADS.
    /// </summary>
    /// <param name="AValue">
    ///   Caminho do banco de dados ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Path(const AValue: string): IMigrator;

    /// <summary>
    ///   Define o nome do banco de dados PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome do banco de dados PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Database(const AValue: string): IMigrator;

    /// <summary>
    ///   Define o usuário para a conexão com o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Nome de usuário do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function User(const AValue: string): IMigrator;

    /// <summary>
    ///   Define a senha para a conexão com o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Senha do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Password(const AValue: string): IMigrator;

    /// <summary>
    ///   Define a porta de conexão para o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Número da porta para a conexão.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Port(const AValue: Integer): IMigrator; overload;

    /// <summary>
    ///   Define a porta de conexão para o banco de dados utilizando uma string.
    /// </summary>
    /// <param name="AValue">
    ///   Número da porta em formato string.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Port(const AValue: string): IMigrator; overload;

    /// <summary>
    ///   Define um callback para monitorar o progresso da migração.
    /// </summary>
    /// <param name="AValue">
    ///   Função de callback do tipo <see cref="TProgressCallback"/> que
    ///   será chamada durante o processo de migração para indicar progresso.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function Callback(const AValue: TProgressCallback): IMigrator; overload;

    /// <summary>
    ///   Define o nome da tabela de origem no banco ADS.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela no banco ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function ADSTableName(const AValue: string): IMigrator;

    /// <summary>
    ///   Define o nome da tabela de destino no banco PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome da tabela no banco PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    function PGTableName(const AValue: string): IMigrator;

    /// <summary>
    ///   Executa o processo de migração de dados entre os bancos.
    /// </summary>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMigrator"/>
    ///   para permitir encadeamento de chamadas.
    /// </returns>
    /// <remarks>
    ///   Este método realiza a migração de dados do banco ADS para o PostgreSQL,
    ///   utilizando as configurações definidas previamente.
    /// </remarks>
    function Execute: IMigrator; overload;
  end;

  /// <summary>
  ///   Interface para gerenciar a conexão com os bancos de dados ADS
  ///   e PostgreSQL, fornecendo métodos para configurar os parâmetros
  ///   de conexão e acessar as instâncias de conexão configuradas.
  /// </summary>
  IConnection = interface
    ['{5F4108D5-6F17-48E3-B29B-DDCF35A78342}']

    /// <summary>
    ///   Define o host do banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Endereço do servidor (host) do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IConnection"/>.
    /// </returns>
    function Host(const AValue: string): IConnection;

    /// <summary>
    ///   Define o caminho para o banco de dados ADS.
    /// </summary>
    /// <param name="AValue">
    ///   Caminho do arquivo do banco de dados ADS.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IConnection"/>.
    /// </returns>
    function Path(const AValue: string): IConnection;

    /// <summary>
    ///   Define o nome do banco de dados PostgreSQL.
    /// </summary>
    /// <param name="AValue">
    ///   Nome do banco de dados PostgreSQL.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IConnection"/>.
    /// </returns>
    function Database(const AValue: string): IConnection;

    /// <summary>
    ///   Define o usuário para a conexão com o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Nome de usuário do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IConnection"/>.
    /// </returns>
    function User(const AValue: string): IConnection;

    /// <summary>
    ///   Define a senha para a conexão com o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Senha do banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IConnection"/>.
    /// </returns>
    function Password(const AValue: string): IConnection;

    /// <summary>
    ///   Define a porta de conexão para o banco de dados.
    /// </summary>
    /// <param name="AValue">
    ///   Número da porta para a conexão com o banco de dados.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IConnection"/>.
    /// </returns>
    function Port(const AValue: Integer): IConnection;

    /// <summary>
    ///   Obtém a instância configurada da conexão ADS.
    /// </summary>
    /// <returns>
    ///   Retorna a instância de <see cref="TFDConnection"/> configurada para ADS.
    /// </returns>
    function GetADSConnection: TFDConnection;

    /// <summary>
    ///   Obtém a instância configurada da conexão PostgreSQL.
    /// </summary>
    /// <returns>
    ///   Retorna a instância de <see cref="TFDConnection"/> configurada para PostgreSQL.
    /// </returns>
    function GetPGConnection: TFDConnection;
  end;

  /// <summary>
  ///   Interface responsável por migrar uma tabela de um banco de dados
  ///   ADS para uma tabela correspondente no PostgreSQL, incluindo a
  ///   criação da tabela de destino e a transferência dos dados.
  /// </summary>
  IDBFToPostgre = interface
    ['{64A60C89-FDBF-425C-A8A2-9D46C6F32056}']

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
  end;

  /// <summary>
  ///   Interface para manipulação de textos em formato RTF (Rich Text
  ///   Format), permitindo remover a formatação RTF e retornar o texto
  ///   simples.
  /// </summary>
  IRTFHandler = interface
    ['{1B33645D-85F8-4CCF-AA5F-8869135B43A1}']

    /// <summary>
    ///   Define o texto RTF a ser manipulado.
    /// </summary>
    /// <param name="AValue">
    ///   Texto em formato RTF a ser processado.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IRTFHandler"/>.
    /// </returns>
    function RTFText(const AValue: string): IRTFHandler;

    /// <summary>
    ///   Remove a formatação RTF do texto fornecido e retorna apenas o texto simples.
    /// </summary>
    /// <remarks>
    ///   Se o texto RTF não for informado, uma exceção do tipo <see cref="Exception"/>
    ///   será levantada.
    /// </remarks>
    /// <returns>
    ///   Retorna uma string com o texto sem a formatação RTF.
    /// </returns>
    function RemoveRTFFormatting: string;
  end;

  /// <summary>
  ///   Interface que mapeia tipos de campos de um banco de dados DBF
  ///   para os tipos correspondentes no PostgreSQL, permitindo a
  ///   conversão adequada durante a migração.
  /// </summary>
  IMapTypeMapper = interface
    ['{21E8907D-8B04-48A3-8F65-074F0C8187F0}']

    /// <summary>
    ///   Define o tipo de campo que será convertido.
    /// </summary>
    /// <param name="AValue">
    ///   Tipo de campo do banco de dados DBF.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IMapTypeMapper"/>.
    /// </returns>
    function FieldType(AValue: TFieldType): IMapTypeMapper;

    /// <summary>
    ///   Converte o tipo de campo definido para o tipo correspondente em
    ///   PostgreSQL.
    /// </summary>
    /// <remarks>
    ///   Se o tipo de campo não estiver definido ou não for suportado,
    ///   uma exceção será lançada.
    /// </remarks>
    /// <returns>
    ///   Retorna uma string representando o tipo de dado equivalente no
    ///   PostgreSQL.
    /// </returns>
    function DBFToPostgreSQL: string;
  end;

  /// <summary>
  ///   Interface para construção de tabelas no PostgreSQL com base na
  ///   estrutura de uma consulta DBF, realizando a criação da tabela
  ///   no banco de destino.
  /// </summary>
  IBuildTable = interface
    ['{ED6B2BA0-8847-4FC9-A10B-DB5D7E2A6DFA}']

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
  end;

  /// <summary>
  ///   Interface responsável pela transferência de dados de uma
  ///   consulta DBF para uma tabela PostgreSQL, incluindo métodos para
  ///   configurar a conexão, a consulta de origem, a tabela de destino
  ///   e o controle do tamanho dos blocos de transferência.
  /// </summary>
  IDataTransfer = interface
    ['{76716D26-B557-4312-BD68-47AF678697EC}']

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
  end;

implementation

end.

