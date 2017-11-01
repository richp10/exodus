object frmImport: TfrmImport
  Left = 236
  Top = 143
  Caption = 'AIM Buddy List (TM) Import'
  ClientHeight = 311
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
    311)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 56
    Width = 248
    Height = 13
    Caption = 'Enter the filename of your saved Buddy List (TM) file:'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 328
    Height = 13
    Caption = 
      'Enter the jabber server which hosts the AIM gateway you wish to ' +
      'use:'
  end
  object Label3: TLabel
    Left = 8
    Top = 104
    Width = 247
    Height = 13
    Caption = 'Select the contacts to import into your Jabber Contact List'
  end
  object txtFilename: TEdit
    Left = 24
    Top = 72
    Width = 241
    Height = 21
    TabOrder = 0
  end
  object ListView1: TListView
    Left = 8
    Top = 120
    Width = 428
    Height = 153
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
        Caption = 'Group'
        Width = 100
      end
      item
        Caption = 'Nickname'
        Width = 100
      end
      item
        Caption = 'Jabber ID'
        Width = 200
      end>
    TabOrder = 1
    ViewStyle = vsReport
  end
  object txtGateway: TEdit
    Left = 24
    Top = 24
    Width = 241
    Height = 21
    TabOrder = 2
  end
  object btnFileBrowse: TButton
    Left = 274
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 3
    OnClick = btnFileBrowseClick
  end
  object btnNext: TButton
    Left = 274
    Top = 278
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Next'
    TabOrder = 4
    OnClick = btnNextClick
  end
  object btnCancel: TButton
    Left = 352
    Top = 278
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'AIM Buddy List|*.blt|All Files|*.*'
    Left = 360
    Top = 72
  end
end
