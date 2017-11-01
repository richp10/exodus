object frmImport: TfrmImport
  Left = 290
  Top = 143
  Caption = 'ICQ Contact List Import'
  ClientHeight = 407
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    445
    407)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 56
    Width = 164
    Height = 13
    Caption = 'Select the ICQ Database to import:'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 327
    Height = 13
    Caption = 
      'Enter the jabber server which hosts the ICQ gateway you wish to ' +
      'use:'
  end
  object Label3: TLabel
    Left = 8
    Top = 176
    Width = 247
    Height = 13
    Caption = 'Select the contacts to import into your Jabber Contact List'
  end
  object ListView1: TListView
    Left = 8
    Top = 192
    Width = 428
    Height = 177
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
        Caption = 'Nickname'
        Width = 150
      end
      item
        Caption = 'Jabber ID'
        Width = 200
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
  object txtGateway: TEdit
    Left = 24
    Top = 24
    Width = 241
    Height = 21
    TabOrder = 1
  end
  object btnFileBrowse: TButton
    Left = 274
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 2
    OnClick = btnFileBrowseClick
  end
  object btnNext: TButton
    Left = 274
    Top = 374
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Next'
    TabOrder = 3
    OnClick = btnNextClick
  end
  object btnCancel: TButton
    Left = 352
    Top = 374
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object txtFilename: TComboBox
    Left = 24
    Top = 75
    Width = 241
    Height = 21
    ItemHeight = 0
    TabOrder = 5
    OnChange = txtFilenameChange
    OnClick = txtFilenameChange
  end
  object optFormat: TRadioGroup
    Left = 24
    Top = 104
    Width = 241
    Height = 35
    Caption = 'Data File Format'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'ICQ'
      'Miranda')
    TabOrder = 6
  end
  object ProgressBar1: TProgressBar
    Left = 24
    Top = 144
    Width = 241
    Height = 17
    Smooth = True
    TabOrder = 7
  end
  object OpenDialog1: TOpenDialog
    Filter = 'ICQ Data Files|*.dat|All Files|*.*'
    Left = 360
    Top = 72
  end
  object icqDB: TICQDb
    OnError = icqDBError
    OnParsingFinished = icqDBParsingFinished
    OnProgress = icqDBProgress
    OnContactFound = icqDBContactFound
    DbType = DB_ICQ
    Left = 360
    Top = 32
  end
end
