inherited frameTreeRoster: TframeTreeRoster
  Width = 172
  Height = 272
  ExplicitWidth = 172
  ExplicitHeight = 272
  object treeRoster: TTreeView
    Left = 0
    Top = 0
    Width = 172
    Height = 272
    Cursor = crArrow
    Hint = 'Contact List Hint'
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    DragMode = dmAutomatic
    HideSelection = False
    Indent = 19
    MultiSelect = True
    MultiSelectStyle = [msControlSelect, msShiftSelect, msVisibleOnly]
    ReadOnly = True
    ShowButtons = False
    ShowLines = False
    ShowRoot = False
    SortType = stText
    TabOrder = 0
    OnCollapsed = treeRosterCollapsed
    OnCustomDrawItem = treeRosterCustomDrawItem
    OnExpanded = treeRosterExpanded
    OnMouseDown = treeRosterMouseDown
  end
end
