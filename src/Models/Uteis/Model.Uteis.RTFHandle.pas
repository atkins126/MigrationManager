unit Model.Uteis.RTFHandle;

interface

uses
  Repository.Migration.Manager;

type
  TRTFHandler = class(TInterfacedObject, IRTFHandler)
  private
    FRTFText: string;
  protected
    function RTFText(const AValue: string): IRTFHandler;
    function RemoveRTFFormatting: string;

    Constructor Create;
  public
    Destructor Destroy; override;
    class function New: IRTFHandler;
  end;

implementation

uses
  System.Classes,
  Vcl.ComCtrls,
  Vcl.Forms,
  System.SysUtils;

{ TRTFHandler }

constructor TRTFHandler.Create;
begin

end;

destructor TRTFHandler.Destroy;
begin

  inherited;
end;

class function TRTFHandler.New: IRTFHandler;
begin
  Result := Self.Create;
end;

function TRTFHandler.RemoveRTFFormatting: string;
var
  RtfStream: TStringStream;
  RichEdit: TRichEdit;
  Form: TForm;
begin
  if FRTFText.Trim.IsEmpty then
    raise Exception.Create('O texto RTF não foi informado. ' +
      'Por favor, insira um texto RTF válido antes de prosseguir.');

  RtfStream := TStringStream.Create(FRTFText, TEncoding.UTF8);
  Form := TForm.Create(nil);
  RichEdit := TRichEdit.Create(nil);
  try
    Form.Visible := False;
    RichEdit.Visible := False;
    RichEdit.Parent := Form;
    RichEdit.Clear;
    RtfStream.Position := 0;
    RichEdit.Lines.LoadFromStream(RtfStream);
    Result := TrimRight(RichEdit.Text);
  finally
    Form.DisposeOf;
    RtfStream.Free;
  end;
end;

function TRTFHandler.RTFText(const AValue: string): IRTFHandler;
begin
  Result := Self;
  FRTFText := AValue;
end;

end.
