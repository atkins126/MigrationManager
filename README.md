# Project Migration

## Descrição
Este projeto foi desenvolvido para realizar a migração de dados de um banco de dados **DBF (Advantage Database Server)** para um banco de dados **PostgreSQL**. Ele foi implementado em Delphi, utilizando a biblioteca **FireDAC** para gerenciar as conexões com os bancos de dados. A aplicação oferece uma interface gráfica simples e direta para configurar conexões e monitorar o progresso da migração.

## Estrutura do Projeto

O projeto foi estruturado de forma modular, separando responsabilidades em diferentes unidades para facilitar a manutenção e a extensão do código. Abaixo, detalhamos cada unidade do projeto e suas funcionalidades.

### 1. View.Main

**Descrição**: Unidade responsável pela interface gráfica da aplicação, permitindo que o usuário configure as conexões, selecione os arquivos, e visualize o progresso da migração.

**Principais Componentes**:
- `TPageMain`: Classe que representa o formulário principal.
- **Campos**:
  - `FMigration: IMigrationManager`: Instância do gerenciador de migração.
  - `FThread: TThread`: Thread para execução assíncrona do processo de migração.
  - `FStartTime: TDateTime`: Tempo de início para cálculo do tempo decorrido.

**Métodos**:
- `ApplyConfiguration`: Configura os valores padrão dos componentes visuais.
- `DatabaseConfiguration`: Configura as conexões para DBF e PostgreSQL com base nas entradas do usuário.
- `MigrateTable`: Executa a migração com ou sem um callback para exibir o progresso.
- `UpdateProgress`: Atualiza a barra de progresso e o status com os dados atuais do processo de migração.
- `GetElapsedTime`: Calcula o tempo decorrido desde o início da migração.
  
**Exemplo de Uso**:
No evento de clique do botão **Iniciar Migração**, a aplicação chama `DatabaseConfiguration` para configurar as conexões e depois executa `MigrateTable` para iniciar o processo. Se a caixa de seleção de status estiver marcada, o progresso será monitorado e exibido ao usuário.

```pascal
procedure TPageMain.btMigrationClick(Sender: TObject);
begin
  FMigration := TMigrationManager.New;
  DatabaseConfiguration;
  MigrateTable(UpdateProgress);
end;
```

### 2. Repository.Migration.Manager

**Descrição**: Define as interfaces que coordenam o processo de migração de dados, incluindo as conexões e o controle da transferência de dados entre os bancos de dados.

**Principais Interfaces**:
- `IMigrationManager`: Gerencia a migração de uma tabela de DBF para PostgreSQL.
- `IMigrator`: Realiza a migração de uma tabela específica.
- `IConnection`: Gerencia as conexões com os bancos de dados ADS e PostgreSQL.

**Métodos Importantes**:
- `IMigrationManager.Execute`: Executa o processo de migração de acordo com as configurações definidas.
- `IConnection.GetADSConnection`: Retorna uma instância configurada de conexão para o banco ADS.
- `IMigrator.Host`, `IMigrator.Database`, `IMigrator.Port`: Configurações de conexão detalhadas para o banco PostgreSQL.

**Exemplo de Uso**:
A interface `IMigrationManager` é utilizada na classe `TPageMain` para configurar e executar a migração. O código abaixo exemplifica como configurar a conexão:

```pascal
FMigration := TMigrationManager.New;
FMigration.Path('.\data\').Host('localhost').Database('MeuDB')
  .User('usuario').Password('senha').Port('5432')
  .ADSTableName('TabelaOrigem').PGTableName('TabelaDestino').Execute;
```

### 3. Model.Uteis.Connection

**Descrição**: Classe que gerencia a conexão com os bancos de dados, tanto o ADS quanto o PostgreSQL. 

**Classe**: `TConnection`

**Principais Métodos**:
- `Host`: Define o endereço do servidor do banco de dados.
- `Database`: Define o nome do banco de dados PostgreSQL.
- `GetADSConnection`: Retorna a instância configurada para a conexão com o ADS.
- `GetPGConnection`: Retorna a instância configurada para a conexão com o PostgreSQL.

**Exemplo de Uso**:
A configuração de uma conexão com PostgreSQL pode ser feita da seguinte maneira:

```pascal
var
  Connection: IConnection;
begin
  Connection := TConnection.New;
  Connection.Host('localhost').Database('MeuDB').User('postgres').Password('senha').Port(5432);
  PGConnection := Connection.GetPGConnection;
end;
```

### 4. Model.Uteis.Callback

**Descrição**: Fornece o tipo `TProgressCallback`, que permite monitorar o progresso da migração.

**Tipo**: 
- `TProgressCallback`: Tipo referência que aceita uma função para ser chamada durante o processo de migração.

**Exemplo de Uso**:
O callback é passado para o método `MigrateTable` para atualizar a interface gráfica durante o processo de migração:

```pascal
procedure TPageMain.UpdateProgress(const TableName: string; TotalRecords, CurrentRecord: Integer);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      lblStatus.Caption := Format('Migrando: %s | Registro %d de %d', [TableName, CurrentRecord, TotalRecords]);
      ProgressBar.Max := TotalRecords;
      ProgressBar.Position := CurrentRecord;
    end);
end;
```

### 5. Model.Uteis.RTFHandle

**Descrição**: Manipula textos em formato RTF, convertendo-os em texto simples para inserção no banco PostgreSQL.

**Classe**: `TRTFHandler`

**Principais Métodos**:
- `RTFText`: Define o texto RTF a ser processado.
- `RemoveRTFFormatting`: Remove a formatação RTF e retorna apenas o texto simples.

**Exemplo de Uso**:
Um exemplo de como remover a formatação RTF antes de salvar o texto em uma tabela PostgreSQL:

```pascal
var
  RTFHandler: IRTFHandler;
  TextoSimples: string;
begin
  RTFHandler := TRTFHandler.New;
  TextoSimples := RTFHandler.RTFText('{\rtf1\ansi...}').RemoveRTFFormatting;
end;
```

### 6. Model.Uteis.TypeMapper

**Descrição**: Mapeia tipos de dados entre o DBF e o PostgreSQL, garantindo que os tipos de campos sejam convertidos corretamente durante a migração.

**Classe**: `TMapTypeMapper`

**Principais Métodos**:
- `FieldType`: Define o tipo de campo do DBF.
- `DBFToPostgreSQL`: Retorna o tipo de campo correspondente para PostgreSQL.

**Exemplo de Uso**:
Durante a criação de uma tabela PostgreSQL com base em uma tabela DBF, o mapeamento de tipos é utilizado para converter os campos corretamente:

```pascal
var
  TypeMapper: IMapTypeMapper;
  PostgreSQLType: string;
begin
  TypeMapper := TMapTypeMapper.New;
  PostgreSQLType := TypeMapper.FieldType(ftString).DBFToPostgreSQL;
end;
```

### 7. Model.Uteis.DataTransfer

**Descrição**: Classe responsável pela transferência de dados de uma tabela DBF para uma tabela PostgreSQL, incluindo a inserção dos registros.

**Classe**: `TDataTransfer`

**Principais Métodos**:
- `Connection`: Define a conexão para transferência dos dados.
- `Query`: Define a consulta de origem (DBF).
- `Execute`: Executa a transferência de dados para a tabela PostgreSQL.

**Exemplo de Uso**:
A transferência de dados de uma tabela DBF para uma tabela PostgreSQL é feita da seguinte forma:

```pascal
var
  DataTransfer: IDataTransfer;
begin
  DataTransfer := TDataTransfer.New;
  DataTransfer.Connection(PGConnection).Query(DBFQuery).TableName('TabelaDestino').Execute;
end;
```

### 8. Model.Uteis.BuildTable

**Descrição**: Classe que cria a estrutura da tabela PostgreSQL com base na estrutura da tabela DBF, utilizando o mapeamento de tipos.

**Classe**: `TBuildTable`

**Principais Métodos**:
- `Connection`: Define a conexão com o banco de dados PostgreSQL.
- `Query`: Define a consulta que contém a estrutura dos dados DBF.
- `DBFToPostgreSQL`: Cria a tabela PostgreSQL correspondente.

**Exemplo de Uso**:
Criar uma tabela em PostgreSQL com base na estrutura de uma consulta DBF:

```pascal
var
  TableBuilder: IBuildTable;
begin
  TableBuilder := TBuildTable.New;
  TableBuilder.Connection(PGConnection).Query(DBFQuery).TableName('TabelaDestino').DBFToPostgreSQL;
end;
```

## Contribuições

Contribuições são sempre bem-vindas! Siga os passos abaixo para contribuir com o projeto:

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## Contato

- **Autor**: Ricardo R. Pereira
```

### Conclusão
Este `README.md` foi elaborado para oferecer uma visão detalhada de cada parte do projeto, explicando as unidades, classes, interfaces e métodos, além de fornecer exemplos práticos de uso. A linguagem técnica e os exemplos visam ajudar outros desenvolvedores a compreenderem como cada componente pode ser integrado no contexto do projeto. Se precisar de ajustes ou mais informações, é só me avisar!