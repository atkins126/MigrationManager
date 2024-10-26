{***********************************************************************}
{                                                                       }
{                          Project Migration                            }
{                                                                       }
{ Unit: Model.Uteis.TypeMapper                                          }
{                                                                       }
{ Descrição:                                                            }
{   Implementa a classe TMapTypeMapper, que realiza a conversão de      }
{   tipos de dados DBF para tipos de dados PostgreSQL, utilizando um    }
{   mapeamento interno para cada tipo de campo.                         }
{                                                                       }
{ Autor: Ricardo R. Pereira                                             }
{ Data: 26 de outubro de 2024                                           }
{                                                                       }
{ Copyright (C) 2024 Ricardo R. Pereira                                 }
{                                                                       }
{ Todos os direitos reservados.                                         }
{                                                                       }
{***********************************************************************}

unit Model.Uteis.TypeMapper;

interface

uses
  Repository.Migration.Manager,
  Data.DB,
  System.Generics.Collections;

type
  /// <summary>
  ///   Classe responsável por mapear tipos de dados de DBF para tipos de
  ///   dados compatíveis com PostgreSQL.
  /// </summary>
  TMapTypeMapper = class(TInterfacedObject, IMapTypeMapper)
  private
    FFieldType: TFieldType;
    FTypeMap: TDictionary<TFieldType, string>;

    /// <summary>
    ///   Inicializa o dicionário com os mapeamentos de tipos de dados entre DBF
    ///   e PostgreSQL.
    /// </summary>
    procedure InitializeTypeMap;
  protected
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

    /// <summary>
    ///   Construtor da classe TMapTypeMapper. Inicializa a instância e os
    ///   mapeamentos de tipos de dados.
    /// </summary>
    Constructor Create;
  public
    /// <summary>
    ///   Destrutor da classe TMapTypeMapper. Libera os recursos alocados.
    /// </summary>
    Destructor Destroy; override;

    /// <summary>
    ///   Cria uma nova instância de <see cref="IMapTypeMapper"/>.
    /// </summary>
    /// <returns>
    ///   Retorna uma instância da interface <see cref="IMapTypeMapper"/>.
    /// </returns>
    class function New: IMapTypeMapper;
  end;

implementation

uses
  System.SysUtils;

{ TMapTypeMapper }

constructor TMapTypeMapper.Create;
begin
  FTypeMap := TDictionary<TFieldType, string>.Create;
  InitializeTypeMap;
end;

function TMapTypeMapper.DBFToPostgreSQL: string;
begin
  if FFieldType = ftUnknown then
    raise Exception.Create('O tipo de campo não foi definido. ' +
      'Por favor, configure um tipo de campo válido antes de prosseguir.');

  if not FTypeMap.TryGetValue(FFieldType, Result) then
    raise Exception.CreateFmt('Tipo de dado do DBF não suportado: %d',
      [Ord(FFieldType)]);
end;

destructor TMapTypeMapper.Destroy;
begin
  FTypeMap.DisposeOf;
  inherited;
end;

function TMapTypeMapper.FieldType(AValue: TFieldType): IMapTypeMapper;
begin
  Result := Self;
  FFieldType := AValue;
end;

procedure TMapTypeMapper.InitializeTypeMap;
begin
  FTypeMap.Add(ftString, 'VARCHAR');
  FTypeMap.Add(ftWideString, 'VARCHAR');
  FTypeMap.Add(ftFixedChar, 'CHAR');
  FTypeMap.Add(ftFixedWideChar, 'CHAR');
  FTypeMap.Add(ftInteger, 'INTEGER');
  FTypeMap.Add(ftWord, 'INTEGER');
  FTypeMap.Add(ftSmallint, 'INTEGER');
  FTypeMap.Add(ftLargeint, 'BIGINT');
  FTypeMap.Add(ftFloat, 'FLOAT');
  FTypeMap.Add(ftCurrency, 'MONEY');
  FTypeMap.Add(ftBCD, 'NUMERIC');
  FTypeMap.Add(ftFMTBcd, 'NUMERIC');
  FTypeMap.Add(ftBoolean, 'BOOLEAN');
  FTypeMap.Add(ftDate, 'DATE');
  FTypeMap.Add(ftTime, 'TIME');
  FTypeMap.Add(ftDateTime, 'TIMESTAMP');
  FTypeMap.Add(ftTimeStamp, 'TIMESTAMP');
  FTypeMap.Add(ftMemo, 'TEXT');
  FTypeMap.Add(ftWideMemo, 'TEXT');
  FTypeMap.Add(ftBlob, 'BYTEA');
  FTypeMap.Add(ftGraphic, 'BYTEA');
  FTypeMap.Add(ftParadoxOle, 'BYTEA');
  FTypeMap.Add(ftDBaseOle, 'BYTEA');
  FTypeMap.Add(ftTypedBinary, 'BYTEA');
  FTypeMap.Add(ftGuid, 'UUID');
  FTypeMap.Add(ftAutoInc, 'SERIAL');
end;

class function TMapTypeMapper.New: IMapTypeMapper;
begin
  Result := Self.Create;
end;

end.

