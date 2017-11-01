inherited frameResults: TframeResults
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  TabStop = True
  object lstResults: TTntListView
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    Columns = <
      item
      end
      item
      end
      item
      end>
    HideSelection = False
    MultiSelect = True
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnData = lstResultsData
  end
end
