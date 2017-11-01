inherited frameButtons: TframeButtons
  Width = 364
  Height = 24
  ExplicitWidth = 364
  ExplicitHeight = 24
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 364
    Height = 24
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 364
      Height = 5
      Align = alTop
      Shape = bsTopLine
    end
    object Panel1: TPanel
      Left = 204
      Top = 5
      Width = 160
      Height = 19
      Align = alRight
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object btnOK: TTntButton
        Left = 4
        Top = 0
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TTntButton
        Left = 82
        Top = 0
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
end
