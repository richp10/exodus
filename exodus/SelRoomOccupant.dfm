inherited frmSelRoomOccupant: TfrmSelRoomOccupant
  Left = 344
  Top = 310
  Caption = 'Select Occupant'
  ClientHeight = 287
  ClientWidth = 219
  DefaultMonitor = dmDesktop
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inline frameButtons1: TframeButtons
    Left = 0
    Top = 254
    Width = 219
    Height = 33
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
    ExplicitTop = 254
    ExplicitWidth = 219
    ExplicitHeight = 33
    inherited Panel2: TPanel
      Width = 219
      Height = 33
      ExplicitWidth = 219
      ExplicitHeight = 33
      inherited Bevel1: TBevel
        Width = 219
        ExplicitWidth = 219
      end
      inherited Panel1: TPanel
        Left = 59
        Height = 28
        ExplicitLeft = 59
        ExplicitHeight = 28
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 223
    Width = 219
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    DesignSize = (
      219
      31)
    object Label1: TTntLabel
      Left = 19
      Top = 7
      Width = 23
      Height = 13
      Caption = 'Nick:'
    end
    object txtJID: TTntEdit
      Left = 63
      Top = 4
      Width = 150
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
  end
  object lstRoster: TTntListView
    Left = 0
    Top = 0
    Width = 219
    Height = 223
    Align = alClient
    Columns = <
      item
        Caption = 'foo'
      end>
    IconOptions.Arrangement = iaLeft
    IconOptions.WrapText = False
    OwnerData = True
    OwnerDraw = True
    ReadOnly = True
    ParentShowHint = False
    ShowColumnHeaders = False
    ShowWorkAreas = True
    ShowHint = True
    SmallImages = frmExodus.ImageList1
    SortType = stText
    TabOrder = 2
    ViewStyle = vsReport
    OnChange = lstRosterChange
    OnCustomDrawItem = lstRosterCustomDrawItem
    OnData = lstRosterData
    OnDblClick = lstRosterDblClick
    OnResize = lstRosterResize
  end
end
