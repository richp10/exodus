inherited frmPrefEmoteDlg: TfrmPrefEmoteDlg
  Left = 263
  Top = 185
  Caption = 'Advanced Emoticon Settings'
  ClientHeight = 358
  ClientWidth = 365
  ParentFont = True
  OldCreateOrder = True
  OnCreate = TntFormCreate
  ExplicitWidth = 373
  ExplicitHeight = 392
  PixelsPerInch = 96
  TextHeight = 13
  object pageEmotes: TTntPageControl
    Left = 0
    Top = 0
    Width = 365
    Height = 326
    ActivePage = TntTabSheet2
    Align = alTop
    TabOrder = 0
    object TntTabSheet1: TTntTabSheet
      Caption = 'Emoticon Packages'
      object pnlCustomPresButtons: TPanel
        Left = 0
        Top = 264
        Width = 357
        Height = 34
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitTop = 267
        ExplicitWidth = 358
        object btnEmoteAdd: TTntButton
          Left = 4
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Add'
          TabOrder = 0
          OnClick = btnEmoteAddClick
        end
        object btnEmoteRemove: TTntButton
          Left = 84
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Remove'
          TabOrder = 1
          OnClick = btnEmoteRemoveClick
        end
        object btnEmoteClear: TTntButton
          Left = 164
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Clear'
          TabOrder = 2
          OnClick = btnEmoteClearClick
        end
        object btnEmoteDefault: TTntButton
          Left = 245
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Defaults'
          TabOrder = 3
          OnClick = btnEmoteDefaultClick
        end
      end
      object lstEmotes: TTntListBox
        Left = 0
        Top = 0
        Width = 357
        Height = 264
        Align = alClient
        ItemHeight = 16
        TabOrder = 1
      end
    end
    object TntTabSheet2: TTntTabSheet
      Caption = 'Custom Emoticons'
      object Panel2: TPanel
        Left = 0
        Top = 209
        Width = 357
        Height = 34
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object btnCustomEmoteAdd: TTntButton
          Left = 4
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Add ...'
          TabOrder = 0
          OnClick = btnCustomEmoteAddClick
        end
        object btnCustomEmoteRemove: TTntButton
          Left = 164
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Remove'
          Enabled = False
          TabOrder = 1
          OnClick = btnCustomEmoteRemoveClick
        end
        object btnCustomEmoteEdit: TTntButton
          Left = 84
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Edit ...'
          Enabled = False
          TabOrder = 2
          OnClick = btnCustomEmoteEditClick
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 243
        Width = 357
        Height = 55
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object TntLabel3: TTntLabel
          Left = 2
          Top = 8
          Width = 194
          Height = 13
          Caption = 'Filename of custom emoticon definitions:'
        end
        object txtCustomEmoteFilename: TTntEdit
          Left = 16
          Top = 22
          Width = 255
          Height = 21
          TabOrder = 0
        end
        object btnCustomEmoteBrowse: TTntButton
          Left = 280
          Top = 20
          Width = 75
          Height = 25
          Caption = 'Browse'
          TabOrder = 1
          OnClick = btnCustomEmoteBrowseClick
        end
      end
      object lstCustomEmotes: TTntListView
        Left = 0
        Top = 0
        Width = 357
        Height = 209
        Align = alClient
        Columns = <>
        IconOptions.AutoArrange = True
        LargeImages = imagesCustom
        MultiSelect = True
        ReadOnly = True
        ShowWorkAreas = True
        TabOrder = 2
        OnAdvancedCustomDrawItem = lstCustomEmotesAdvancedCustomDrawItem
        OnDblClick = btnCustomEmoteEditClick
        OnSelectItem = lstCustomEmotesSelectItem
      end
    end
  end
  object btnOK: TTntButton
    Left = 232
    Top = 331
    Width = 61
    Height = 20
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TTntButton
    Left = 297
    Top = 331
    Width = 61
    Height = 20
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object EmoteOpen: TOpenDialog
    Filter = 'Resource Files|*.dll|All Files|*.*'
    Left = 224
    Top = 34
  end
  object XMLDialog1: TOpenDialog
    Filter = 'XML Files|*.xml|All Files|*.*'
    Left = 256
    Top = 34
  end
  object imagesCustom: TImageList
    BlendColor = clWindow
    BkColor = 15857655
    Height = 32
    Width = 32
    Left = 288
    Top = 34
  end
end
