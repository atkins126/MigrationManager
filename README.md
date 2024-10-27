# Migration Manager

## Introdução
Este projeto foi desenvolvido para facilitar a migração de dados de um banco de dados **DBF (Advantage Database Server)** para **PostgreSQL**, utilizando a linguagem **Delphi** e a biblioteca **FireDAC** para gerenciar as conexões e manipular os dados. A estrutura modular do código foi projetada para garantir flexibilidade e facilidade de manutenção.

## Estrutura das Classes e Interfaces

### 1. **`IMigrationManager`**

**Descrição**: Interface responsável por gerenciar todo o processo de migração, desde a configuração das conexões até a execução do processo de transferência de dados.

**Métodos Principais**:
- `Host(const AValue: string): IMigrationManager`: Define o host do banco de dados PostgreSQL.
- `Path(const AValue: string): IMigrationManager`: Define o caminho do arquivo `.dbf` de origem.
- `Database(const AValue: string): IMigrationManager`: Define o nome do banco de dados PostgreSQL.
- `User(const AValue: string): IMigrationManager`: Define o usuário para a conexão.
- `Password(const AValue: string): IMigrationManager`: Define a senha para a conexão.
- `Port(const AValue: Integer): IMigrationManager`: Define a porta de conexão.
- `ADSTableName(const AValue: string): IMigrationManager`: Define o nome da tabela de origem no DBF.
- `PGTableName(const AValue: string): IMigrationManager`: Define o nome da tabela de destino no PostgreSQL.
- `Execute: IMigrationManager`: Executa o processo de migração.

**Exemplo de Uso**:
```pascal
var
  Migration: IMigrationManager;
begin
  Migration := TMigrationManager.New;
  Migration.Host('localhost')
           .Path('C:\dados\clientes.dbf')
           .Database('MeuBanco')
           .User('postgres')
           .Password('senha')
           .Port(5432)
           .ADSTableName('ClientesDBF')
           .PGTableName('ClientesPostgreSQL')
           .Execute;
end;
```

### 2. **`IMigrator`**

**Descrição**: Interface que realiza a migração de uma tabela específica entre um banco de dados ADS e um banco PostgreSQL, sendo a responsável direta pelo processo de leitura, conversão e inserção dos registros.

**Métodos Principais**:
- `Host(const AValue: string): IMigrator`: Define o endereço do servidor PostgreSQL.
- `Path(const AValue: string): IMigrator`: Define o caminho do arquivo `.dbf`.
- `Database(const AValue: string): IMigrator`: Define o nome do banco de dados de destino.
- `ADSTableName(const AValue: string): IMigrator`: Define a tabela de origem no banco ADS.
- `PGTableName(const AValue: string): IMigrator`: Define a tabela de destino no PostgreSQL.
- `Execute: IMigrator`: Realiza a migração dos registros.

**Exemplo de Uso**:
```pascal
var
  Migrator: IMigrator;
begin
  Migrator := TMigrator.New;
  Migrator.Host('localhost')
          .Path('C:\dados\produtos.dbf')
          .Database('VendasDB')
          .ADSTableName('ProdutosDBF')
          .PGTableName('ProdutosPostgreSQL')
          .Execute;
end;
```

### 3. **`IConnection`**

**Descrição**: Interface que gerencia as conexões com os bancos de dados ADS e PostgreSQL, proporcionando métodos para definir e acessar as configurações de conexão.

**Métodos Principais**:
- `Host(const AValue: string): IConnection`: Define o host do servidor PostgreSQL.
- `Path(const AValue: string): IConnection`: Define o caminho do banco ADS.
- `Database(const AValue: string): IConnection`: Define o banco de dados de destino.
- `GetADSConnection: TFDConnection`: Retorna uma instância configurada de conexão para o banco ADS.
- `GetPGConnection: TFDConnection`: Retorna uma instância configurada de conexão para o banco PostgreSQL.

**Exemplo de Uso**:
```pascal
var
  Connection: IConnection;
  PGConn: TFDConnection;
begin
  Connection := TConnection.New;
  PGConn := Connection.Host('localhost')
                      .Database('FinanceiroDB')
                      .User('postgres')
                      .Password('12345')
                      .Port(5432)
                      .GetPGConnection;
end;
```

### 4. **`IDBFToPostgre`**

**Descrição**: Interface que realiza a migração dos dados de uma tabela DBF para uma tabela PostgreSQL, gerenciando a leitura dos registros, a criação da tabela de destino e a transferência dos dados.

**Métodos Principais**:
- `ADSConnection(const AValue: TFDConnection): IDBFToPostgre`: Define a conexão com o banco ADS.
- `PGConnection(const AValue: TFDConnection): IDBFToPostgre`: Define a conexão com o banco PostgreSQL.
- `MigrateTable: IDBFToPostgre`: Realiza a migração dos registros.

**Exemplo de Uso**:
```pascal
var
  DBFToPostgre: IDBFToPostgre;
begin
  DBFToPostgre := TDBFToPostgre.New;
  DBFToPostgre.ADSConnection(ADSConnection)
              .PGConnection(PGConnection)
              .ADSTableName('Clientes')
              .PGTableName('ClientesPostgreSQL')
              .MigrateTable;
end;
```

### 5. **`IRTFHandler`**

**Descrição**: Interface para manipulação de textos em formato RTF, convertendo-os para texto simples antes de armazená-los em uma tabela PostgreSQL.

**Métodos Principais**:
- `RTFText(const AValue: string): IRTFHandler`: Define o texto em formato RTF.
- `RemoveRTFFormatting: string`: Remove a formatação e retorna apenas o texto simples.

**Exemplo de Uso**:
```pascal
var
  RTFHandler: IRTFHandler;
  TextoSemFormatacao: string;
begin
  RTFHandler := TRTFHandler.New;
  TextoSemFormatacao := RTFHandler.RTFText('{\rtf1\ansi ...}').RemoveRTFFormatting;
end;
```

### 6. **`IMapTypeMapper`**

**Descrição**: Interface que mapeia os tipos de campos entre o banco de dados DBF e o PostgreSQL, garantindo que cada tipo de dado seja convertido corretamente durante a migração.

**Métodos Principais**:
- `FieldType(AValue: TFieldType): IMapTypeMapper`: Define o tipo de campo a ser convertido.
- `DBFToPostgreSQL: string`: Retorna o tipo correspondente em PostgreSQL.

**Exemplo de Uso**:
```pascal
var
  TypeMapper: IMapTypeMapper;
  PostgreSQLType: string;
begin
  TypeMapper := TMapTypeMapper.New;
  PostgreSQLType := TypeMapper.FieldType(ftString).DBFToPostgreSQL; // Exemplo: 'VARCHAR'
end;
```

### 7. **`IBuildTable`**

**Descrição**: Interface responsável pela construção de tabelas no PostgreSQL com base na estrutura de uma tabela DBF, utilizando o mapeamento de tipos para garantir compatibilidade entre as estruturas.

**Métodos Principais**:
- `Connection(const AValue: TFDConnection): IBuildTable`: Define a conexão com o PostgreSQL.
- `Query(const AValue: TFDQuery): IBuildTable`: Define a consulta que contém a estrutura da tabela DBF.
- `DBFToPostgreSQL: IBuildTable`: Cria a tabela PostgreSQL com base na estrutura da consulta DBF.

**Exemplo de Uso**:
```pascal
var
  TableBuilder: IBuildTable;
begin
  TableBuilder := TBuildTable.New;
  TableBuilder.Connection(PGConnection)
               .Query(DBFQuery)
               .TableName('ClientesPostgreSQL')
               .DBFToPostgreSQL;
end;
```

### 8. **`IDataTransfer`**

**Descrição**: Interface que realiza a transferência dos registros de uma consulta DBF para uma tabela PostgreSQL, gerenciando o processo de inserção em lote para otimizar a transferência.

**Métodos Principais**:
- `Connection(const AValue: TFDConnection): IDataTransfer`: Define a conexão com o PostgreSQL.
- `Query(const AValue: TFDQuery): IDataTransfer`: Define a consulta que será utilizada como origem dos dados.
- `TableName(const AValue: string): IDataTransfer`: Define o nome da tabela de destino.
- `BlockSize(const AValue: Int64): IDataTransfer`: Define o número de registros por lote.
- `Execute: IDataTransfer`: Realiza a transferência de registros.

**Exemplo de Uso**:
```pascal
var
  DataTransfer: IDataTransfer;
begin
  DataTransfer := TDataTransfer.New;
  DataTransfer.Connection(PGConnection)
               .Query(DBFQuery)
               .TableName('ClientesPostgreSQL')
               .BlockSize(100)
               .Execute;
end;
```

## Considerações Finais

Este projeto é ideal para desenvol

vedores que precisam realizar migrações de dados de bancos **DBF** para **PostgreSQL** de forma automatizada e segura. A separação de responsabilidades em diferentes classes e interfaces facilita a manutenção e a extensibilidade do código, tornando-o um bom ponto de partida para projetos de migração de dados em Delphi.

Cada interface foi projetada para ser intuitiva e fácil de integrar em diferentes cenários, permitindo que o desenvolvedor tenha controle total sobre o processo de migração, desde a configuração das conexões até a transferência dos dados.
