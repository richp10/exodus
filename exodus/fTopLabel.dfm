inherited frameTopLabel: TframeTopLabel
  Width = 151
  Height = 41
  OnResize = FrameResize
  ExplicitWidth = 151
  ExplicitHeight = 41
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 151
    Height = 41
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    ParentColor = True
    TabOrder = 0
    object lbl: TTntLabel
      Left = 3
      Top = 3
      Width = 145
      Height = 13
      Align = alTop
      Caption = 'lbl'
      ExplicitWidth = 10
    end
    object txtData: TTntEdit
      Left = 2
      Top = 18
      Width = 145
      Height = 21
      TabOrder = 0
    end
  end
end
