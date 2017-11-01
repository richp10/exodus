inherited frmInvite: TfrmInvite
  Left = 400
  Top = 181
  Caption = 'Invite to Conference'
  ClientHeight = 268
  ClientWidth = 323
  DefaultMonitor = dmDesktop
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 331
  ExplicitHeight = 302
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 234
    Width = 323
    Height = 34
    Align = alBottom
    Color = 13681583
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    TabStop = True
    ExplicitTop = 234
    ExplicitWidth = 323
    ExplicitHeight = 34
    inherited Panel2: TPanel
      Width = 323
      Height = 34
      ExplicitWidth = 323
      ExplicitHeight = 34
      inherited Bevel1: TBevel
        Width = 323
        ExplicitWidth = 323
      end
      inherited Panel1: TPanel
        Left = 159
        Width = 164
        Height = 29
        ExplicitLeft = 159
        ExplicitWidth = 164
        ExplicitHeight = 29
        inherited btnOK: TTntButton
          Enabled = False
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 323
    Height = 234
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    ParentColor = True
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 3
      Top = 122
      Width = 317
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object lstJIDS: TTntListView
      Left = 3
      Top = 125
      Width = 253
      Height = 106
      Align = alClient
      Columns = <
        item
          Caption = 'Nickname'
          Width = 90
        end
        item
          Caption = 'Jabber ID'
          Width = 150
        end>
      MultiSelect = True
      RowSelect = True
      SortType = stBoth
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = lstJIDSChange
      OnDeletion = lstJIDSDeletion
      OnDragDrop = lstJIDSDragDrop
      OnDragOver = lstJIDSDragOver
    end
    object Panel1: TPanel
      Left = 256
      Top = 125
      Width = 64
      Height = 106
      Align = alRight
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object btnRemove: TTntButton
        Left = 4
        Top = 34
        Width = 60
        Height = 25
        Caption = 'Remove'
        TabOrder = 0
        OnClick = btnRemoveClick
      end
      object btnAdd: TTntButton
        Left = 4
        Top = 6
        Width = 60
        Height = 25
        Caption = 'Add'
        TabOrder = 1
        OnClick = btnAddClick
      end
    end
    object Panel2: TPanel
      Left = 3
      Top = 3
      Width = 317
      Height = 119
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      object Label2: TTntLabel
        Left = 0
        Top = 44
        Width = 317
        Height = 13
        Align = alTop
        Caption = 'Reason:'
        ExplicitWidth = 40
      end
      object Label1: TTntLabel
        Left = 0
        Top = 0
        Width = 317
        Height = 13
        Align = alTop
        Caption = 'Invite the following contacts to:'
        ExplicitWidth = 153
      end
      object memReason: TTntMemo
        Left = 0
        Top = 57
        Width = 317
        Height = 62
        Align = alClient
        Lines.Strings = (
          'Please join us in this conference room.')
        TabOrder = 0
      end
      object pnl1: TPanel
        Left = 0
        Top = 13
        Width = 317
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object cboRoom: TTntComboBox
          Left = 3
          Top = 4
          Width = 214
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
          OnChange = cboRoomChange
        end
      end
    end
  end
end
