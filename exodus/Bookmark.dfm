inherited frmBookmark: TfrmBookmark
  Left = 275
  Top = 185
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Bookmark Properties'
  ClientHeight = 203
  ClientWidth = 338
  DefaultMonitor = dmDesktop
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TTntLabel
    Left = 8
    Top = 8
    Width = 90
    Height = 13
    Caption = 'Type of Bookmark:'
  end
  object Label2: TTntLabel
    Left = 8
    Top = 37
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label3: TTntLabel
    Left = 8
    Top = 66
    Width = 49
    Height = 13
    Caption = 'Jabber ID:'
  end
  object Label4: TTntLabel
    Left = 8
    Top = 95
    Width = 140
    Height = 13
    Caption = 'Conference Room Nickname:'
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 169
    Width = 338
    Height = 34
    Align = alBottom
    TabOrder = 0
    TabStop = True
    ExplicitTop = 169
    ExplicitWidth = 338
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 338
      Height = 34
      ExplicitWidth = 338
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 338
        ExplicitWidth = 338
      end
      inherited Panel1: TPanel
        Left = 178
        Height = 29
        ExplicitLeft = 178
        ExplicitHeight = 29
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object cboType: TTntComboBox
    Left = 145
    Top = 5
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'Conference Room')
  end
  object txtName: TTntEdit
    Left = 145
    Top = 33
    Width = 145
    Height = 21
    TabOrder = 2
  end
  object txtJID: TTntEdit
    Left = 145
    Top = 62
    Width = 145
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object txtNick: TTntEdit
    Left = 145
    Top = 91
    Width = 145
    Height = 21
    TabOrder = 4
  end
  object chkAutoJoin: TTntCheckBox
    Left = 145
    Top = 143
    Width = 97
    Height = 17
    Caption = 'Join on login'
    TabOrder = 6
  end
  object chkRegisteredNick: TTntCheckBox
    Left = 145
    Top = 120
    Width = 168
    Height = 17
    Caption = 'Use registered nickname.'
    TabOrder = 5
  end
end
