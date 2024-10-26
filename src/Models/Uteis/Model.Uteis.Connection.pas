unit Model.Uteis.Connection;

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
  FireDAC.Stan.StorageBin,

  Repository.Migration.Manager;

type
  TConnection = class(TInterfacedObject, IConnection)
  private
    FADSConnection: TFDConnection;
    FPGConnection: TFDConnection;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDriverADS: TFDPhysADSDriverLink;
    FDriverPG: TFDPhysPgDriverLink;
    FHost: string;
    FPath: string;
    FDatabase: string;
    FUser: string;
    FPassword: string;
    FPort: string;

    procedure SetupADSConnection;
    procedure SetupPGConnection;
  protected

    function Host(const AValue: string): IConnection;
    function Path(const AValue: string): IConnection;
    function Database(const AValue: string): IConnection;
    function User(const AValue: string): IConnection;
    function Password(const AValue: string): IConnection;
    function Port(const AValue: Integer): IConnection;

    function GetADSConnection: TFDConnection;
    function GetPGConnection: TFDConnection;

    constructor Create;

  public
    destructor Destroy; override;

    class function New: IConnection;

  end;

implementation

{ TConnection }

constructor TConnection.Create;
begin
  inherited;

  FADSConnection := TFDConnection.Create(nil);
  FPGConnection := TFDConnection.Create(nil);
  FDGUIxWaitCursor := TFDGUIxWaitCursor.Create(Nil);
  FDGUIxWaitCursor.Provider := 'Console';
  FDriverADS := TFDPhysADSDriverLink.Create(FADSConnection);
  FDriverPG := TFDPhysPgDriverLink.Create(FADSConnection);

end;

function TConnection.Database(const AValue: string): IConnection;
begin
  Result := Self;
  FDatabase := AValue;
end;

destructor TConnection.Destroy;
begin
  FDGUIxWaitCursor.DisposeOf;
  FADSConnection.DisposeOf;
  FPGConnection.DisposeOf;
  inherited;
end;

procedure TConnection.SetupADSConnection;
begin
  if FPath.Trim.IsEmpty then
    raise Exception.Create('O caminho do arquivo não foi informado. ' +
      'Por favor, insira um caminho válido antes de prosseguir.');

  FADSConnection.Close;
  FADSConnection.LoginPrompt := False;
  FADSConnection.UpdateOptions.CountUpdatedRecords := False;
  FADSConnection.UpdateOptions.CheckUpdatable := False;
  FADSConnection.FetchOptions.Mode := TFDFetchMode.fmAll;

  FADSConnection.Params.Clear;
  FADSConnection.Params.DriverID := 'ADS';
  FADSConnection.Params.Database := FPath;

  FADSConnection.Params.Add('Pooled=False');
  FADSConnection.Params.Add('POOL_MaximumItens=100000');
  FADSConnection.Params.Add('Protocol=TCPIP');
  FADSConnection.Params.Add('ServerTypes=Local');
  FADSConnection.Params.Add('CharacterSet=Ansi');
  FADSConnection.Params.Add('TableType=CDX');
  FADSConnection.Params.Add('Locking=Compatible');

  FDriverADS.DefaultPath := ExtractFilePath(ParamStr(0));
  FDriverADS.VendorLib := ExtractFilePath(ParamStr(0)) + 'ace64.dll';
  FDriverADS.ShowDeleted := False;

end;

procedure TConnection.SetupPGConnection;
begin
  if FDatabase.Trim.IsEmpty then
    raise Exception.Create('O nome do banco de dados não foi informado. ' +
      'Por favor, insira o nome do banco de dados antes de prosseguir.');

  if FUser.Trim.IsEmpty then
    raise Exception.Create('O nome de usuário não foi informado. ' +
      'Por favor, insira o nome de usuário antes de prosseguir.');

  if FPassword.Trim.IsEmpty then
    raise Exception.Create('A senha do banco de dados não foi informada. ' +
      'Por favor, insira a senha antes de prosseguir.');

  if FHost.Trim.IsEmpty then
    raise Exception.Create('O endereço do servidor (host) não foi informado. ' +
      'Por favor, insira o endereço do servidor antes de prosseguir.');

  if FPort.Trim.IsEmpty then
    raise Exception.Create('A porta de conexão não foi informada. ' +
      'Por favor, insira a porta antes de prosseguir.');

  FPGConnection.Close;
  FPGConnection.Params.Clear;
  FPGConnection.Params.DriverID := 'PG';
  FPGConnection.Params.Database := FDatabase;
  FPGConnection.Params.UserName := FUser;
  FPGConnection.Params.Password := FPassword;
  FPGConnection.Params.Add('Server=' + FHost);
  FPGConnection.Params.Add('Port=' + FPort);
end;

function TConnection.User(const AValue: string): IConnection;
begin
  Result := Self;
  FUser := AValue;
end;

function TConnection.GetADSConnection: TFDConnection;
begin
  try
    SetupADSConnection;
    FADSConnection.Connected := True;
    Result := FADSConnection;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao PostgreSQL: ' + E.Message);
  end;
end;

function TConnection.GetPGConnection: TFDConnection;
begin
  try
    SetupPGConnection;
    FPGConnection.Connected := True;
    Result := FPGConnection;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao PostgreSQL: ' + E.Message);
  end;
end;

function TConnection.Host(const AValue: string): IConnection;
begin
  Result := Self;
  FHost := AValue;
end;

class function TConnection.New: IConnection;
begin
  Result := Self.Create;
end;

function TConnection.Password(const AValue: string): IConnection;
begin
  Result := Self;
  FPassword := AValue;
end;

function TConnection.Path(const AValue: string): IConnection;
begin
  Result := Self;
  FPath := AValue;
end;

function TConnection.Port(const AValue: Integer): IConnection;
begin
  Result := Self;
  FPort := AValue.ToString;
end;

end.
