inherited ManageBlockDlg: TManageBlockDlg
  BorderStyle = bsDialog
  Caption = 'Manage Blocked Contacts'
  ClientHeight = 358
  ClientWidth = 519
  OnCreate = TntFormCreate
  ExplicitWidth = 525
  ExplicitHeight = 390
  PixelsPerInch = 96
  TextHeight = 13
  object ExBrandPanel1: TExBrandPanel
    Left = 0
    Top = 0
    Width = 519
    Height = 319
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    AutoHide = False
    object lblBlockIns: TTntLabel
      AlignWithMargins = True
      Left = 3
      Top = 9
      Width = 513
      Height = 26
      Margins.Top = 9
      Align = alTop
      Caption = 
        'Enter in the Jabber Addresses (JIDs) of the contacts you wish to' +
        ' block. All messages from these contacts will be blocked.'
      WordWrap = True
      ExplicitLeft = 2
      ExplicitTop = 7
      ExplicitWidth = 508
    end
    object memBlocks: TTntMemo
      AlignWithMargins = True
      Left = 3
      Top = 41
      Width = 513
      Height = 275
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object btnOK: TTntButton
    Left = 358
    Top = 323
    Width = 73
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TTntButton
    Left = 436
    Top = 323
    Width = 73
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
