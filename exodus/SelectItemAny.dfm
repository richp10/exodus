inherited frmSelectItemAny: TfrmSelectItemAny
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlInput: TPanel
    inherited pnlSelect: TPanel
      Top = 26
      Height = 219
      ExplicitTop = 26
      ExplicitHeight = 219
    end
    inherited pnlEntry: TPanel
      Top = 248
      Height = 35
      ExplicitTop = 248
      ExplicitHeight = 35
      inherited lblJID: TTntLabel
        Height = 29
      end
      inherited txtJID: TTntEdit
        Height = 29
      end
    end
    object pnlAny: TTntPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 273
      Height = 17
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      object chkAny: TTntCheckBox
        Left = 0
        Top = 0
        Width = 273
        Height = 17
        Align = alTop
        Caption = 'Any'
        TabOrder = 0
        OnClick = chkAnyClick
      end
    end
  end
end
