object frmImport: TfrmImport
  Left = 231
  Top = 165
  BorderWidth = 4
  Caption = 'Import Jabber Contact List'
  ClientHeight = 287
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 257
    Width = 401
    Height = 30
    Align = alBottom
    TabOrder = 0
    TabStop = True
    ExplicitTop = 257
    ExplicitWidth = 401
    ExplicitHeight = 30
    inherited Panel2: TPanel
      Width = 401
      Height = 30
      ExplicitWidth = 401
      ExplicitHeight = 30
      inherited Bevel1: TBevel
        Width = 401
        ExplicitWidth = 401
      end
      inherited Panel1: TPanel
        Left = 241
        Height = 25
        ExplicitLeft = 241
        ExplicitHeight = 25
        inherited btnOK: TTntButton
          Caption = 'Import'
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          Caption = 'Close'
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object ListView1: TTntListView
    Left = 0
    Top = 0
    Width = 401
    Height = 257
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Nickname'
        Width = 100
      end
      item
        Caption = 'Group'
        Width = 85
      end
      item
        Caption = 'Jabber ID'
        Width = 120
      end>
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
  end
  object OpenDialog1: TOpenDialog
    Filter = 'XML Files|*.xml|All Files|*.*'
    Left = 8
    Top = 264
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'Contact List Files|*.xml|All Files|*.*'
    Left = 40
    Top = 264
  end
end
