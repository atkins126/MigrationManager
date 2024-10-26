{***********************************************************************}
{                                                                       }
{                          Project Migration                            }
{                                                                       }
{ Unit: Model.Uteis.RTFHandle                                           }
{                                                                       }
{ Descrição:                                                            }
{   Implementa a classe TRTFHandler, que oferece métodos para manipular }
{   e remover formatação de textos em RTF (Rich Text Format).           }
{                                                                       }
{ Autor: Ricardo R. Pereira                                             }
{ Data: 26 de outubro de 2024                                           }
{                                                                       }
{ Copyright (C) 2024 Ricardo R. Pereira                                 }
{                                                                       }
{ Todos os direitos reservados.                                         }
{                                                                       }
{***********************************************************************}

unit Model.Uteis.RTFHandle;

interface

uses
  Repository.Migration.Manager;

type
  /// <summary>
  ///   Classe responsável por manipular textos em formato RTF,
  ///   incluindo a remoção de formatação.
  /// </summary>
  TRTFHandler = class(TInterfacedObject, IRTFHandler)
  private
    FRTFText: string;
  protected
    /// <summary>
    ///   Define o texto RTF a ser manipulado.
    /// </summary>
    /// <param name="AValue">
    ///   Texto em formato RTF a ser processado.
    /// </param>
    /// <returns>
    ///   Retorna a própria instância de <see cref="IRTFHandler"/>.
    /// </returns>
    function RTFText(const AValue: string): IRTFHandler;

    /// <summary>
    ///   Remove a formatação RTF do texto fornecido e retorna apenas o texto simples.
    /// </summary>
    /// <remarks>
    ///   Se o texto RTF não for informado, uma exceção do tipo <see cref="Exception"/>
    ///   será levantada.
    /// </remarks>
    /// <returns>
    ///   Retorna uma string com o texto sem a formatação RTF.
    /// </returns>
    function RemoveRTFFormatting: string;

    /// <summary>
    ///   Construtor da classe TRTFHandler. Inicializa a instância.
    /// </summary>
    Constructor Create;
  public
    /// <summary>
    ///   Destrutor da classe TRTFHandler. Libera os recursos alocados.
    /// </summary>
    Destructor Destroy; override;

    /// <summary>
    ///   Cria uma nova instância de <see cref="IRTFHandler"/>.
    /// </summary>
    /// <returns>
    ///   Retorna uma instância da interface <see cref="IRTFHandler"/>.
    /// </returns>
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
  // Inicialização da instância
end;

destructor TRTFHandler.Destroy;
begin
  // Liberação de recursos antes de destruir a instância
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

