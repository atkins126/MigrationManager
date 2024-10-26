{***********************************************************************}
{                                                                       }
{                          Project Migration                            }
{                                                                       }
{ Unit: Model.Uteis.Callback                                            }
{                                                                       }
{ Descrição:                                                            }
{   Define o tipo TProgressCallback, que é um procedimento de callback  }
{   para monitoramento do progresso de operações em tabelas.            }
{                                                                       }
{ Autor: Ricardo R. Pereira                                             }
{ Data: 26 de outubro de 2024                                           }
{                                                                       }
{ Copyright (C) 2024 Ricardo R. Pereira                                 }
{                                                                       }
{ Todos os direitos reservados.                                         }
{                                                                       }
{***********************************************************************}

unit Model.Uteis.Callback;

interface

type
  /// <summary>
  ///   Representa um procedimento de callback para monitoramento do progresso
  ///   durante operações em uma tabela.
  /// </summary>
  /// <param name="TableName">
  ///   Nome da tabela na qual a operação está sendo realizada.
  /// </param>
  /// <param name="TotalRecords">
  ///   Número total de registros a serem processados.
  /// </param>
  /// <param name="CurrentRecord">
  ///   Número do registro atual sendo processado.
  /// </param>
  TProgressCallback = reference to procedure(const TableName: string;
    TotalRecords, CurrentRecord: Integer);

implementation

end.

