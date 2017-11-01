inherited BookMarkForm: TBookMarkForm
  Caption = 'Bookmark Conference Room'
  ClientHeight = 156
  ClientWidth = 345
  DefaultMonitor = dmMainForm
  Position = poMainFormCenter
  OnCreate = TntFormCreate
  ExplicitWidth = 353
  ExplicitHeight = 196
  PixelsPerInch = 120
  TextHeight = 16
  object NameLabel: TTntLabel
    Left = 8
    Top = 8
    Width = 131
    Height = 16
    Caption = 'Enter bookmark name:'
    Layout = tlCenter
  end
  object GroupLabel: TTntLabel
    Left = 10
    Top = 58
    Width = 73
    Height = 16
    Caption = 'Enter Group:'
  end
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 117
    Width = 345
    Height = 39
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TabStop = True
    ExplicitTop = 117
    ExplicitWidth = 345
    ExplicitHeight = 39
    inherited Panel2: TPanel
      Width = 345
      Height = 39
      ExplicitWidth = 345
      ExplicitHeight = 39
      inherited Bevel1: TBevel
        Width = 345
        Height = 6
        ExplicitWidth = 329
        ExplicitHeight = 6
      end
      inherited Panel1: TPanel
        Left = 148
        Top = 6
        Width = 197
        Height = 33
        ExplicitLeft = 148
        ExplicitTop = 6
        ExplicitWidth = 197
        ExplicitHeight = 33
        inherited btnOK: TTntButton
          Left = 5
          Width = 92
          Height = 31
          Enabled = False
          ExplicitLeft = 5
          ExplicitWidth = 92
          ExplicitHeight = 31
        end
        inherited btnCancel: TTntButton
          Left = 101
          Width = 92
          Height = 31
          ExplicitLeft = 101
          ExplicitWidth = 92
          ExplicitHeight = 31
        end
      end
    end
  end
  object txtName: TTntEdit
    Left = 8
    Top = 32
    Width = 329
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    OnChange = txtNameChange
  end
  object cboGroup: TTntComboBox
    Left = 8
    Top = 82
    Width = 329
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 16
    Sorted = True
    TabOrder = 2
    OnChange = cboGroupChange
  end
end
