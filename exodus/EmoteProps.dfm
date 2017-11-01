inherited frmEmoteProps: TfrmEmoteProps
  Left = 255
  Top = 535
  BorderStyle = bsDialog
  Caption = 'Emoticon Properties'
  ClientHeight = 147
  ClientWidth = 339
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TntLabel1: TTntLabel
    Left = 8
    Top = 8
    Width = 92
    Height = 13
    Caption = 'Emoticon Filename:'
  end
  object TntLabel2: TTntLabel
    Left = 8
    Top = 56
    Width = 111
    Height = 13
    Caption = 'Emoticon text to match:'
  end
  object txtFilename: TTntEdit
    Left = 24
    Top = 24
    Width = 225
    Height = 21
    TabOrder = 0
  end
  object btnBrowse: TTntButton
    Left = 256
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 1
    OnClick = btnBrowseClick
  end
  object txtText: TTntEdit
    Left = 24
    Top = 72
    Width = 225
    Height = 21
    TabOrder = 2
  end
  object btnOK: TTntButton
    Left = 176
    Top = 112
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TTntButton
    Left = 256
    Top = 112
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object OpenDialog1: TOpenPictureDialog
    Filter = 'Image Files|*.bmp;*.gif|All Files|*.*'
    Left = 256
    Top = 56
  end
end
