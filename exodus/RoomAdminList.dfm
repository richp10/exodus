inherited frmRoomAdminList: TfrmRoomAdminList
  Left = 209
  Top = 156
  BorderWidth = 3
  Caption = 'Conference Room List Modifier'
  ClientHeight = 221
  ClientWidth = 380
  DefaultMonitor = dmDesktop
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 394
  ExplicitHeight = 261
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 191
    Width = 380
    Height = 30
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
    ExplicitTop = 191
    ExplicitWidth = 380
    ExplicitHeight = 30
    inherited Panel2: TPanel
      Width = 380
      Height = 30
      ExplicitWidth = 380
      ExplicitHeight = 30
      inherited Bevel1: TBevel
        Width = 380
        ExplicitWidth = 380
      end
      inherited Panel1: TPanel
        Left = 220
        Height = 25
        ExplicitLeft = 220
        ExplicitHeight = 25
        inherited btnOK: TTntButton
          OnClick = frameButtons1btnOKClick
        end
        inherited btnCancel: TTntButton
          OnClick = frameButtons1btnCancelClick
        end
      end
    end
  end
  object lstItems: TTntListView
    Left = 0
    Top = 0
    Width = 299
    Height = 191
    Align = alClient
    Columns = <
      item
        Caption = 'Nick'
        Width = 100
      end
      item
        Caption = 'Jabber ID'
        Width = 180
      end>
    DragMode = dmAutomatic
    HideSelection = False
    MultiSelect = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnEdited = lstItemsEdited
    OnDragDrop = lstItemsDragDrop
    OnDragOver = lstItemsDragOver
  end
  object Panel2: TPanel
    Left = 299
    Top = 0
    Width = 81
    Height = 191
    Align = alRight
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object btnRemove: TTntButton
      Left = 6
      Top = 34
      Width = 75
      Height = 25
      Caption = 'Remove'
      TabOrder = 0
      OnClick = btnRemoveClick
    end
    object TntButton1: TTntButton
      Left = 6
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 1
      OnClick = btnAddClick
    end
  end
end
