unit Model.Connection;

interface

uses
  System.SysUtils,
  System.Classes,

  Data.DB,

  FireDAC.DatS,
  FireDAC.DApt,
  FireDAC.Phys,
  FireDAC.Comp.UI,
  FireDAC.UI.Intf,
  FireDAC.Phys.PG,
  FireDAC.Stan.Def,
  FireDAC.Phys.ADS,
  FireDAC.Stan.Intf,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.Stan.ResStrs,
  FireDAC.Phys.PGDef,
  FireDAC.Phys.ADSDef,
  FireDAC.Comp.Client,
  FireDAC.Phys.SQLite,
  FireDAC.Stan.Option,
  FireDAC.Comp.DataSet,
  FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.StorageBin;

type
  TConnection = class
  private
    FADSConnection: TFDConnection;
    FPGConnection: TFDConnection;

    procedure SetupADSConnection(const DBFPath: string);
    procedure SetupPGConnection(const Host, Database, User, Password: string;
      Port: Integer);
  protected
    constructor Create;

  public
    destructor Destroy; override;

    function ConnectDBF(const DBFPath: string): TConnection;
    function ConnectPostgreSQL(const Host, Database, User, Password: string;
      Port: Integer): TConnection;
    function GetDBFConnection: TFDConnection;
    function GetPGConnection: TFDConnection;

    class function New: TConnection;

  end;

implementation

{ TConnection }

constructor TConnection.Create;
begin
  inherited;

  FADSConnection := TFDConnection.Create(nil);
  FPGConnection := TFDConnection.Create(nil);
end;

destructor TConnection.Destroy;
begin
  FADSConnection.DisposeOf;
  FPGConnection.DisposeOf;
  inherited;
end;

procedure TConnection.SetupADSConnection(const DBFPath: string);
begin
  FADSConnection.Close;
  FADSConnection.LoginPrompt := False;
  FADSConnection.UpdateOptions.CountUpdatedRecords := False;
  FADSConnection.UpdateOptions.CheckUpdatable := False;
  FADSConnection.FetchOptions.Mode := TFDFetchMode.fmAll;

  FADSConnection.Params.Clear;
  FADSConnection.Params.DriverID := 'ADS';
  FADSConnection.Params.Database := DBFPath;

  FADSConnection.Params.Add('Pooled=False');
  FADSConnection.Params.Add('POOL_MaximumItens=100000');
  FADSConnection.Params.Add('Protocol=TCPIP');
  FADSConnection.Params.Add('ServerTypes=Local');
  FADSConnection.Params.Add('CharacterSet=Ansi');
  FADSConnection.Params.Add('TableType=CDX');
  FADSConnection.Params.Add('Locking=Compatible');
end;

procedure TConnection.SetupPGConnection(const Host, Database, User,
  Password: string; Port: Integer);
begin
  FPGConnection.Close;
  FPGConnection.Params.Clear;
  FPGConnection.Params.DriverID := 'PG';
  FPGConnection.Params.Database := Database;
  FPGConnection.Params.UserName := User;
  FPGConnection.Params.Password := Password;
  FPGConnection.Params.Add('Server=' + Host);
  FPGConnection.Params.Add('Port=' + Port.ToString);
end;

function TConnection.ConnectDBF(const DBFPath: string): TConnection;
begin
  Result := Self;

  SetupADSConnection(DBFPath);
  try
    FADSConnection.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao DBF: ' + E.Message);
  end;
end;

function TConnection.ConnectPostgreSQL(const Host, Database, User,
  Password: string; Port: Integer): TConnection;
begin
  Result := Self;

  SetupPGConnection(Host, Database, User, Password, Port);
  try
    FPGConnection.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao PostgreSQL: ' + E.Message);
  end;
end;

function TConnection.GetDBFConnection: TFDConnection;
begin
  Result := FADSConnection;
end;

function TConnection.GetPGConnection: TFDConnection;
begin
  Result := FPGConnection;
end;

class function TConnection.New: TConnection;
begin
  Result := Self.Create;
end;

end.
