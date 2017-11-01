inherited frmSelectItem: TfrmSelectItem
  Caption = 'Select'
  ClientHeight = 320
  ClientWidth = 279
  ParentFont = False
  OnCreate = FormCreate
  ExplicitWidth = 287
  ExplicitHeight = 354
  PixelsPerInch = 96
  TextHeight = 13
  object pnlInput: TPanel
    Left = 0
    Top = 0
    Width = 279
    Height = 283
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object pnlSelect: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 273
      Height = 248
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
    end
    object pnlEntry: TPanel
      Left = 0
      Top = 254
      Width = 279
      Height = 29
      Align = alBottom
      AutoSize = True
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object lblJID: TTntLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 47
        Height = 23
        Align = alLeft
        Caption = 'Jabber ID'
        FocusControl = txtJID
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object txtJID: TTntEdit
        AlignWithMargins = True
        Left = 56
        Top = 3
        Width = 220
        Height = 23
        Align = alClient
        TabOrder = 0
        OnChange = txtJIDChange
        ExplicitHeight = 21
      end
    end
  end
  object pnlActions: TPanel
    Left = 0
    Top = 283
    Width = 279
    Height = 37
    Align = alBottom
    AutoSize = True
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    ExplicitTop = 213
    DesignSize = (
      279
      37)
    object SeparatorBar: TExCustomSeparatorBar
      Left = 0
      Top = 0
      Width = 279
      Height = 2
      Align = alTop
      CustomSeparatorBarProperites.Color1 = clBtnShadow
      CustomSeparatorBarProperites.Color2 = clBtnHighlight
      CustomSeparatorBarProperites.horizontal = True
      ExplicitTop = 2
    end
    object btnCancel: TTntButton
      AlignWithMargins = True
      Left = 208
      Top = 6
      Width = 68
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TTntButton
      AlignWithMargins = True
      Left = 134
      Top = 6
      Width = 68
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 1
    end
  end
  object popSelected: TTntPopupMenu
    Left = 56
    Top = 88
    object mnuShowOnline: TTntMenuItem
      Caption = 'Show Online Only'
      OnClick = mnuShowOnlineClick
    end
  end
end
