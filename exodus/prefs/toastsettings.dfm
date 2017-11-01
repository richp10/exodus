inherited ToastSettings: TToastSettings
  BorderStyle = bsDialog
  Caption = 'Desktop Alert Settings'
  ClientHeight = 193
  ClientWidth = 340
  ParentFont = True
  ExplicitWidth = 346
  ExplicitHeight = 231
  PixelsPerInch = 120
  TextHeight = 16
  object chkToastAlpha: TTntCheckBox
    AlignWithMargins = True
    Left = 3
    Top = 9
    Width = 334
    Height = 21
    Margins.Top = 9
    Align = alTop
    Caption = '&Use alpha blending for desktop alerts'
    TabOrder = 0
    OnClick = chkToastAlphaClick
  end
  object pnlAlphaSlider: TExBrandPanel
    AlignWithMargins = True
    Left = 3
    Top = 36
    Width = 334
    Height = 59
    Align = alTop
    AutoSize = True
    TabOrder = 1
    TabStop = True
    AutoHide = True
    object lblSliderTitle: TTntLabel
      Left = 3
      Top = 0
      Width = 158
      Height = 16
      Caption = 'Desktop alert &transparency:'
      FocusControl = trkToastAlpha
    end
    object lblLess: TTntLabel
      Left = 3
      Top = 43
      Width = 99
      Height = 16
      Caption = 'More transparent'
    end
    object lblMore: TTntLabel
      Left = 254
      Top = 43
      Width = 75
      Height = 16
      Caption = 'More opaque'
    end
    object trkToastAlpha: TTrackBar
      Left = 0
      Top = 22
      Width = 329
      Height = 24
      Enabled = False
      Max = 255
      Min = 100
      PageSize = 15
      Frequency = 15
      Position = 255
      TabOrder = 0
      ThumbLength = 15
      TickStyle = tsNone
    end
  end
  object pnlToastDuration: TExBrandPanel
    AlignWithMargins = True
    Left = 3
    Top = 104
    Width = 334
    Height = 46
    Margins.Top = 6
    Align = alTop
    AutoSize = True
    TabOrder = 2
    TabStop = True
    AutoHide = True
    object lblToastDuration: TTntLabel
      Left = 3
      Top = 0
      Width = 131
      Height = 16
      Caption = '&Desktop alert duration:'
      FocusControl = txtToastDuration
    end
    object lblSeconds: TTntLabel
      Left = 86
      Top = 22
      Width = 48
      Height = 16
      Caption = 'Seconds'
    end
    object txtToastDuration: TExNumericEdit
      Left = 5
      Top = 22
      Width = 75
      Height = 31
      BevelOuter = bvNone
      Enabled = False
      ParentColor = True
      TabOrder = 0
      Text = '15'
      Min = 1
      Max = 15
      DesignSize = (
        75
        31)
    end
  end
  object btnOK: TTntButton
    Left = 176
    Top = 160
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TTntButton
    AlignWithMargins = True
    Left = 257
    Top = 160
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
