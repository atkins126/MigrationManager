unit Model.Uteis.TypeMapper;

interface

uses
  Repository.Migration.Manager,
  Data.DB,
  System.Generics.Collections;

type
  TMapTypeMapper = class(TInterfacedObject, IMapTypeMapper)
  private
    FFieldType: TFieldType;
    FTypeMap: TDictionary<TFieldType, string>;

    procedure InitializeTypeMap;
  protected
    function FieldType(AValue: TFieldType): IMapTypeMapper;
    function DBFToPostgreSQL: string;

    Constructor Create;
  public
    Destructor Destroy; override;
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
