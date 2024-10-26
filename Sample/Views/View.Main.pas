unit View.Main;

interface

uses
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.Controls,
  Vcl.ComCtrls,

  System.Classes,

  Model.Uteis.Callback,
  Migration.Manager,
  Repository.Migration.Manager;

type
  TPageMain = class(TForm)
    pnlMain: TPanel;
    pnlTop: TPanel;
    pnlFooter: TPanel;
    pnlBody: TPanel;
    lblTitle: TLabel;
    btMigration: TSpeedButton;
    pnlMigration: TPanel;
    pnlClose: TPanel;
    btClose: TSpeedButton;
    gbDBF: TGroupBox;
    edtPathDBF: TLabeledEdit;
    pnlSearechPathDBF: TPanel;
    btSearechPathDBF: TSpeedButton;
    GroupBox1: TGroupBox;
    edtHostPostgre: TLabeledEdit;
    edtTableNameDBF: TLabeledEdit;
    edtPortPostgre: TLabeledEdit;
    edtDataBasePostgre: TLabeledEdit;
    edtUserPostgre: TLabeledEdit;
    edtPassPostgre: TLabeledEdit;
    edtTableNamePostgre: TLabeledEdit;
    lblDBF: TLabel;
    lblPostgreSQL: TLabel;
    pnlAutor: TPanel;
    lblStatus: TLabel;
    pnlStatus: TPanel;
    pnlCloseStatus: TPanel;
    btCloseStatus: TSpeedButton;
    ProgressBar: TProgressBar;
    cbHideStatus: TCheckBox;
    procedure btCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btMigrationClick(Sender: TObject);
    procedure btCloseStatusClick(Sender: TObject);
  private
    FMigration: IMigrationManager;
    FThread: TThread;
    FStartThread: Boolean;
    FStartTime: TDateTime;

    procedure UpdateProgress(const TableName: string;
      TotalRecords, CurrentRecord: Integer);

    function GetElapsedTime(const AStartTime: TDateTime): string;

    procedure TrataThread(Sender: TObject);

    procedure ApplyConfiguration;
    procedure DatabaseConfiguration;
    procedure MigrateTable; overload;
    procedure MigrateTable(Callback: TProgressCallback); overload;
  end;

var
  PageMain: TPageMain;

implementation

uses
  System.SysUtils,
  System.DateUtils;

{$R *.dfm}

procedure TPageMain.ApplyConfiguration;
begin
  ProgressBar.Visible := False;
  FStartThread := False;
  lblStatus.Caption := EmptyStr;
  pnlStatus.SendToBack;

  edtPathDBF.Text := '.\';
  edtTableNameDBF.Text := 'PRODUTO.DBF';

  edtHostPostgre.Text := 'localhost';
  edtPortPostgre.Text := '5432';
  edtDataBasePostgre.Text := 'EFPGDB';
  edtUserPostgre.Text := 'postgres';
  edtPassPostgre.Text := '1977kado';
  edtTableNamePostgre.Text := 'produto';
end;

procedure TPageMain.btCloseClick(Sender: TObject);
begin
  if FStartThread then
    FThread.Terminate;

  Application.Terminate;
end;

procedure TPageMain.btCloseStatusClick(Sender: TObject);
begin
  pnlStatus.SendToBack;
  pnlMigration.Visible := True;
end;

procedure TPageMain.btMigrationClick(Sender: TObject);
begin
  FMigration := TMigrationManager.New;

  DatabaseConfiguration;

  if cbHideStatus.Checked then
    MigrateTable
  else
    MigrateTable(UpdateProgress);

end;

procedure TPageMain.DatabaseConfiguration;
begin
  try
    try
      FMigration.Path(edtPathDBF.Text).Host(edtHostPostgre.Text)
        .Database(edtDataBasePostgre.Text).User(edtUserPostgre.Text)
        .Password(edtPassPostgre.Text).Port(edtPortPostgre.Text)
        .ADSTableName(edtTableNameDBF.Text)
        .PGTableName(edtTableNamePostgre.Text);

      lblStatus.Caption := 'Configuração concluída com sucesso!';
    except
      on E: Exception do
        lblStatus.Caption := 'Erro: ' + E.Message;
    end;

  finally
    pnlMigration.Visible := False;
    pnlStatus.BringToFront;
  end;
end;

procedure TPageMain.FormCreate(Sender: TObject);
begin
  ApplyConfiguration;
end;

function TPageMain.GetElapsedTime(const AStartTime: TDateTime): string;
var
  LMilliseconds, LHours, LMinutes, LSeconds: Integer;
begin
  LMilliseconds := MilliSecondsBetween(Now, AStartTime);
  LHours := LMilliseconds div (60 * 60 * 1000);
  LMilliseconds := LMilliseconds mod (60 * 60 * 1000);
  LMinutes := LMilliseconds div (60 * 1000);
  LMilliseconds := LMilliseconds mod (60 * 1000);
  LSeconds := LMilliseconds div 1000;
  LMilliseconds := LMilliseconds mod 1000;
  Result := Format('%0.2d:%0.2d:%0.2d.%0.3d', [LHours, LMinutes, LSeconds,
    LMilliseconds]);
end;

procedure TPageMain.MigrateTable(Callback: TProgressCallback);
begin
  pnlCloseStatus.Visible := False;
  lblStatus.Caption := 'Aguarde...';

  FStartTime := Now;

  FThread := TThread.CreateAnonymousThread(
    procedure
    begin
      FStartThread := True;
      FMigration.Callback(Callback).Execute;
    end);

  FThread.FreeOnTerminate := True;
  FThread.OnTerminate := TrataThread;
  FThread.Start;

end;

procedure TPageMain.TrataThread(Sender: TObject);
begin
  if Sender is TThread then
  begin
    TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        ProgressBar.Visible := False;
        pnlCloseStatus.Visible := True;
        FStartThread := False;

        if Assigned(TThread(Sender).FatalException) then
          lblStatus.Caption := 'Erro: ' + Exception(TThread(Sender)
            .FatalException).Message
        else if Assigned(FMigration) then
          lblStatus.Caption := FMigration.Status + sLineBreak +
            'Tempo de operação: ' + GetElapsedTime(FStartTime);
      end);
  end;
end;

procedure TPageMain.MigrateTable;
begin
  pnlCloseStatus.Visible := False;
  lblStatus.Caption := 'Aguarde...';
  FStartTime := Now;

  FThread := TThread.CreateAnonymousThread(
    procedure
    begin
      FStartThread := True;
      FMigration.Callback(Nil).Execute;
    end);

  FThread.FreeOnTerminate := True;
  FThread.OnTerminate := TrataThread;
  FThread.Start;
end;

procedure TPageMain.UpdateProgress(const TableName: string;
TotalRecords, CurrentRecord: Integer);
begin
  TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      lblStatus.Caption := Format('Migrando tabela: %s | Registro %d de %d',
        [TableName, CurrentRecord, TotalRecords]);

      ProgressBar.Visible := True;
      ProgressBar.Max := TotalRecords;
      ProgressBar.Position := CurrentRecord;

    end);

end;

end.
