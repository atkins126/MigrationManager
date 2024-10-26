unit Repository.Migration.Manager;

interface

uses
  Model.Uteis.Callback,
  FireDAC.Comp.Client,
  Data.DB;

type
  IMigrationManager = interface
    ['{CC399A6F-2B4C-4ED0-92F2-DDC5F512B1B2}']

    function Host(const AValue: string): IMigrationManager;
    function Path(const AValue: string): IMigrationManager;
    function Database(const AValue: string): IMigrationManager;
    function User(const AValue: string): IMigrationManager;
    function Password(const AValue: string): IMigrationManager;
    function Port(const AValue: Integer): IMigrationManager; overload;
    function Port(const AValue: string): IMigrationManager; overload;
    function Callback(const AValue: TProgressCallback): IMigrationManager; overload;
    function ADSTableName(const AValue: string): IMigrationManager;
    function PGTableName(const AValue: string): IMigrationManager;

    function Execute: IMigrationManager; overload;

    function Status: string;

  end;

  IMigrator = interface
    ['{9B9B9ACA-80B6-421D-A9EE-78C0A209BE92}']
    function Host(const AValue: string): IMigrator;
    function Path(const AValue: string): IMigrator;
    function Database(const AValue: string): IMigrator;
    function User(const AValue: string): IMigrator;
    function Password(const AValue: string): IMigrator;
    function Port(const AValue: Integer): IMigrator; overload;
    function Port(const AValue: string): IMigrator; overload;
    function Callback(const AValue: TProgressCallback): IMigrator; overload;
    function ADSTableName(const AValue: string): IMigrator;
    function PGTableName(const AValue: string): IMigrator;

    function Execute: IMigrator; overload;

  end;

  IConnection = interface
    ['{5F4108D5-6F17-48E3-B29B-DDCF35A78342}']
    function Host(const AValue: string): IConnection;
    function Path(const AValue: string): IConnection;
    function Database(const AValue: string): IConnection;
    function User(const AValue: string): IConnection;
    function Password(const AValue: string): IConnection;
    function Port (const AValue: Integer): IConnection;

    function GetADSConnection: TFDConnection;
    function GetPGConnection: TFDConnection;
  end;

  IDBFToPostgre = interface
    ['{64A60C89-FDBF-425C-A8A2-9D46C6F32056}']

    function ADSConnection (const AValue: TFDConnection) : IDBFToPostgre;
    function PGConnection (const AValue:TFDConnection) : IDBFToPostgre;
    function ADSTableName (const AValue:string) : IDBFToPostgre;
    function PGTableName(const AValue:string) : IDBFToPostgre;
    function Callback(const AValue:TProgressCallback) : IDBFToPostgre;

    function MigrateTable: IDBFToPostgre;
  end;

  IRTFHandler = interface
    ['{1B33645D-85F8-4CCF-AA5F-8869135B43A1}']
    function RTFText(const AValue: string): IRTFHandler;
    function RemoveRTFFormatting: string;
  end;

  IMapTypeMapper = interface
    ['{21E8907D-8B04-48A3-8F65-074F0C8187F0}']
    function FieldType(AValue: TFieldType): IMapTypeMapper;
    function DBFToPostgreSQL: string;

  end;

  IBuildTable = interface
    ['{ED6B2BA0-8847-4FC9-A10B-DB5D7E2A6DFA}']
    function Connection(const AValue: TFDConnection): IBuildTable;
    function Query(const AValue: TFDQuery): IBuildTable;
    function TableName(const AValue: string): IBuildTable;
    function DBFToPostgreSQL: IBuildTable;
  end;

  IDataTransfer = interface
    ['{76716D26-B557-4312-BD68-47AF678697EC}']
    function Connection(const AValue: TFDConnection): IDataTransfer;
    function Query(const AValue: TFDQuery): IDataTransfer;
    function TableName(const AValue: string): IDataTransfer;
    function Callback(const AValue: TProgressCallback): IDataTransfer;
    function BlockSize(const AValue: Int64): IDataTransfer;

    function Execute: IDataTransfer;
  end;

implementation

end.
