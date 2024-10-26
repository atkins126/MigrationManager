unit Repository.Migration.Manager;

interface

uses
  Model.Callback,
  FireDAC.Comp.Client;
type
  IMigrationManager = interface
    ['{CC399A6F-2B4C-4ED0-92F2-DDC5F512B1B2}']

    function ConfigureMigration(const DBFPath, Host, Database, User,
      Password: string; Port: Integer): IMigrationManager;

    function ExecuteMigration(const DBFTableName, PGTableName: string)
      : IMigrationManager; overload;

    function ExecuteMigration(const DBFTableName, PGTableName: string;
      ProgressCallback: TProgressCallback): IMigrationManager; overload;

    function GetMigrationStatus: string;

  end;

  IMigrator = interface
    ['{9B9B9ACA-80B6-421D-A9EE-78C0A209BE92}']
    function ConfigureConnections(const DBFPath, Host, Database, User,
      Password: string; Port: Integer): IMigrator;

    function ExecuteMigration(const DBFTableName, PGTableName: string)
      : IMigrator; overload;

    function ExecuteMigration(const DBFTableName, PGTableName: string;
      ProgressCallback: TProgressCallback): IMigrator; overload;

  end;

  IConnection = interface
    ['{5F4108D5-6F17-48E3-B29B-DDCF35A78342}']
    function ConnectDBF(const DBFPath: string): IConnection;
    function ConnectPostgreSQL(const Host, Database, User, Password: string;
      Port: Integer): IConnection;
    function GetDBFConnection: TFDConnection;
    function GetPGConnection: TFDConnection;

  end;

  IDBFToPostgre = interface
    ['{64A60C89-FDBF-425C-A8A2-9D46C6F32056}']

    function MigrateTable(const DBFTableName, PGTableName: string)
      : IDBFToPostgre; overload;

    function MigrateTable(const DBFTableName, PGTableName: string;
      ProgressCallback: TProgressCallback): IDBFToPostgre; overload;

  end;
implementation

end.
