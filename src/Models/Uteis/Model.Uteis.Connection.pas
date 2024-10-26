{***********************************************************************}
{                          Project Migration                            }
{                                                                       }
{ Unit: Model.Uteis.Connection                                          }
{                                                                       }
{ Descrição:                                                            }
{   Implementa a classe TConnection, que gerencia conexões com os       }
{   bancos de dados ADS e PostgreSQL, utilizando FireDAC para           }
{   estabelecer e configurar as conexões.                               }
{                                                                       }
{ Autor: Ricardo R. Pereira                                             }
{ Data: 26 de outubro de 2024                                           }
{                                                                       }
{ Copyright (C) 2024 Ricardo R. Pereira                                 }
{                                                                       }
{ Todos os direitos reservados.                                         }
{                                                                       }
{***********************************************************************}

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
  /// <summary>
  ///   Classe responsável por gerenciar conexões com bancos de dados ADS
  ///   e PostgreSQL, incluindo configurações de conexão e manipulação
  ///   de parâmetros de conexão.
  /// </summary>
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

    /// <summary>
    ///   Configura a conexão com o banco de dados ADS (Advantage Database Server).
    /// </summary>
    procedure SetupADSConnection;

    /// <summary>
    ///   Configura a conexão com o banco de dados PostgreSQL.
    /// </summary>
    procedure SetupPGConnection;
  protected
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

    /// <summary>
    ///   Construtor da classe TConnection. Inicializa as conexões e os
    ///   componentes necessários para a conexão com os bancos de dados.
    /// </summary>
    constructor Create;

  public
    /// <summary>
    ///   Destrutor da classe TConnection. Libera os recursos alocados.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   Cria uma nova instância de <see cref="IConnection"/>.
    /// </summary>
    /// <returns>
    ///   Retorna uma instância da interface <see cref="IConnection"/>.
    /// </returns>
    class function New: IConnection;
  end;

implementation

{ TConnection }

constructor TConnection.Create;
begin
  inherited;

  FADSConnection := TFDConnection.Create(nil);
  FPGConnection := TFDConnection.Create(nil);
  FDGUIxWaitCursor := TFDGUIxWaitCursor.Create(nil);
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
{$IFDEF WIN32}
  FDriverADS.VendorLib := ExtractFilePath(ParamStr(0)) + 'ace32.dll';
{$ELSE}
  FDriverADS.VendorLib := ExtractFilePath(ParamStr(0)) + 'ace64.dll';
{$ENDIF}
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
      raise Exception.Create('Erro ao conectar ao ADS: ' + E.Message);
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

