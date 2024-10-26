object PageMain: TPageMain
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = '...:::: Sample Migration ::::...'
  ClientHeight = 691
  ClientWidth = 750
  Color = 1907997
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 8355711
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 17
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 750
    Height = 691
    Align = alClient
    BevelOuter = bvNone
    Color = 1907997
    ParentBackground = False
    TabOrder = 0
    object pnlStatus: TPanel
      Left = 0
      Top = 70
      Width = 750
      Height = 526
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 4
      object lblStatus: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 744
        Height = 458
        Align = alClient
        Alignment = taCenter
        Caption = 'Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 69
        ExplicitHeight = 32
      end
      object pnlCloseStatus: TPanel
        Left = 0
        Top = 485
        Width = 750
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'CLOSE'
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12500670
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object btCloseStatus: TSpeedButton
          Left = 0
          Top = 0
          Width = 750
          Height = 41
          Cursor = crHandPoint
          Align = alClient
          Caption = 'CLOSE'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 12500670
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = btCloseStatusClick
          ExplicitTop = 7
          ExplicitWidth = 185
        end
      end
      object ProgressBar: TProgressBar
        Left = 0
        Top = 464
        Width = 750
        Height = 21
        Align = alBottom
        TabOrder = 1
      end
    end
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 750
      Height = 70
      Align = alTop
      BevelOuter = bvNone
      Color = 2236962
      ParentBackground = False
      TabOrder = 0
      object lblTitle: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 744
        Height = 64
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = 'MIGRATION SAMPLE '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12500670
        Font.Height = -21
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        Font.Quality = fqProof
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 216
        ExplicitHeight = 30
      end
    end
    object pnlFooter: TPanel
      Left = 0
      Top = 596
      Width = 750
      Height = 70
      Align = alBottom
      BevelOuter = bvNone
      Color = 2236962
      ParentBackground = False
      TabOrder = 1
      DesignSize = (
        750
        70)
      object pnlMigration: TPanel
        Left = 538
        Top = 16
        Width = 185
        Height = 41
        Anchors = [akTop, akRight, akBottom]
        BevelOuter = bvNone
        Caption = 'MIGRATION'
        Color = clBackground
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12500670
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object btMigration: TSpeedButton
          Left = 0
          Top = 0
          Width = 185
          Height = 41
          Cursor = crHandPoint
          Align = alClient
          Caption = 'MIGRATION'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 12500670
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = btMigrationClick
          ExplicitTop = 7
        end
      end
      object pnlClose: TPanel
        Left = 24
        Top = 16
        Width = 185
        Height = 41
        Anchors = [akLeft, akTop, akBottom]
        BevelOuter = bvNone
        Caption = 'CLOSE'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12500670
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object btClose: TSpeedButton
          Left = 0
          Top = 0
          Width = 185
          Height = 41
          Cursor = crHandPoint
          Align = alClient
          Caption = 'CLOSE'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 12500670
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = btCloseClick
          ExplicitTop = 7
        end
      end
    end
    object pnlBody: TPanel
      Left = 0
      Top = 70
      Width = 750
      Height = 526
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object lblDBF: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 35
        Width = 744
        Height = 50
        Alignment = taCenter
        AutoSize = False
        Caption = 'DBF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12500670
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = []
        Font.Quality = fqProof
        ParentFont = False
        Layout = tlCenter
      end
      object lblPostgreSQL: TLabel
        AlignWithMargins = True
        Left = 0
        Top = 250
        Width = 744
        Height = 50
        Alignment = taCenter
        AutoSize = False
        Caption = 'POSTGRESQL'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12500670
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = []
        Font.Quality = fqProof
        ParentFont = False
        Layout = tlCenter
      end
      object gbDBF: TGroupBox
        Left = 24
        Top = 91
        Width = 689
        Height = 129
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8355711
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          689
          129)
        object edtPathDBF: TLabeledEdit
          Left = 16
          Top = 32
          Width = 625
          Height = 25
          EditLabel.Width = 38
          EditLabel.Height = 17
          EditLabel.Caption = 'LOCAL'
          TabOrder = 0
          Text = ''
        end
        object pnlSearechPathDBF: TPanel
          Left = 640
          Top = 20
          Width = 40
          Height = 40
          Anchors = [akTop, akRight]
          BevelOuter = bvNone
          Caption = '...'
          Color = clBackground
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 12500670
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object btSearechPathDBF: TSpeedButton
            Left = 0
            Top = 0
            Width = 40
            Height = 40
            Cursor = crHandPoint
            Align = alClient
            Anchors = [akLeft, akRight, akBottom]
            Caption = '...'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 12500670
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitWidth = 27
          end
        end
        object edtTableNameDBF: TLabeledEdit
          Left = 16
          Top = 88
          Width = 657
          Height = 25
          EditLabel.Width = 34
          EditLabel.Height = 17
          EditLabel.Caption = 'TABLE'
          TabOrder = 2
          Text = ''
        end
      end
      object GroupBox1: TGroupBox
        Left = 24
        Top = 306
        Width = 689
        Height = 129
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8355711
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        object edtHostPostgre: TLabeledEdit
          Left = 16
          Top = 32
          Width = 217
          Height = 25
          EditLabel.Width = 33
          EditLabel.Height = 17
          EditLabel.Caption = 'HOST'
          TabOrder = 0
          Text = ''
        end
        object edtPortPostgre: TLabeledEdit
          Left = 239
          Top = 32
          Width = 217
          Height = 25
          EditLabel.Width = 31
          EditLabel.Height = 17
          EditLabel.Caption = 'PORT'
          NumbersOnly = True
          TabOrder = 1
          Text = ''
        end
        object edtDataBasePostgre: TLabeledEdit
          Left = 462
          Top = 32
          Width = 217
          Height = 25
          EditLabel.Width = 59
          EditLabel.Height = 17
          EditLabel.Caption = 'DATABASE'
          TabOrder = 2
          Text = ''
        end
        object edtUserPostgre: TLabeledEdit
          Left = 16
          Top = 88
          Width = 217
          Height = 25
          EditLabel.Width = 31
          EditLabel.Height = 17
          EditLabel.Caption = 'USER'
          TabOrder = 3
          Text = ''
        end
        object edtPassPostgre: TLabeledEdit
          Left = 239
          Top = 88
          Width = 217
          Height = 25
          EditLabel.Width = 28
          EditLabel.Height = 17
          EditLabel.Caption = 'PASS'
          PasswordChar = '*'
          TabOrder = 4
          Text = ''
        end
        object edtTableNamePostgre: TLabeledEdit
          Left = 462
          Top = 88
          Width = 217
          Height = 25
          EditLabel.Width = 34
          EditLabel.Height = 17
          EditLabel.Caption = 'TABLE'
          TabOrder = 5
          Text = ''
        end
      end
      object cbHideStatus: TCheckBox
        Left = 600
        Top = 441
        Width = 97
        Height = 17
        Caption = 'Hide Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
    object pnlAutor: TPanel
      Left = 0
      Top = 666
      Width = 750
      Height = 25
      Align = alBottom
      BevelOuter = bvNone
      Caption = #169' 2024 | Ricardo R. Pereia | All rights reserved.'
      Color = 986895
      ParentBackground = False
      TabOrder = 3
    end
  end
end
