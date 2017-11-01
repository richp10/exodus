inherited frmJud: TfrmJud
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = 'Jabber Search'
  ClientHeight = 512
  ClientWidth = 693
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  ExplicitWidth = 701
  ExplicitHeight = 552
  PixelsPerInch = 120
  TextHeight = 16
  inherited TntPanel1: TTntPanel
    Top = 461
    Width = 693
    ExplicitTop = 461
    ExplicitWidth = 693
    inherited Bevel1: TBevel
      Width = 693
      ExplicitWidth = 693
    end
    inherited Panel3: TPanel
      Left = 376
      Height = 45
      ExplicitLeft = 376
      ExplicitHeight = 45
      inherited btnBack: TTntButton
        Anchors = [akTop, akRight]
        Cancel = True
        OnClick = btnBackClick
      end
      inherited btnNext: TTntButton
        Anchors = [akTop, akRight]
        Default = True
        OnClick = btnNextClick
      end
      inherited btnCancel: TTntButton
        Anchors = [akTop, akRight]
        OnClick = btnCancelClick
      end
    end
  end
  inherited Panel1: TPanel
    Width = 693
    ExplicitWidth = 693
    inherited Bevel2: TBevel
      Width = 693
      ExplicitWidth = 693
    end
    inherited lblWizardTitle: TTntLabel
      Width = 155
      Caption = 'Jabber Search Wizard'
      ExplicitWidth = 155
    end
    inherited lblWizardDetails: TTntLabel
      Caption = ''
    end
    inherited Image1: TImage
      Left = 642
      ExplicitLeft = 642
    end
  end
  inherited Tabs: TPageControl
    Width = 693
    Height = 387
    ActivePage = TabSheet4
    ExplicitWidth = 693
    ExplicitHeight = 387
    inherited TabSheet1: TTabSheet
      OnEnter = TabSheet1Enter
      ExplicitLeft = 4
      ExplicitTop = 30
      ExplicitWidth = 685
      ExplicitHeight = 353
      object lblSelect: TTntLabel
        Left = 0
        Top = 0
        Width = 685
        Height = 16
        Align = alTop
        Caption = 'Select the user database for the search agent to use:'
        WordWrap = True
        ExplicitWidth = 306
      end
      object cboJID: TTntComboBox
        Left = 20
        Top = 41
        Width = 286
        Height = 24
        ItemHeight = 16
        Sorted = True
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object lblWait: TTntLabel
        Left = 0
        Top = 0
        Width = 685
        Height = 16
        Align = alTop
        Caption = 'Please wait. Contacting search agent:'
        WordWrap = True
        ExplicitWidth = 216
      end
      object aniWait: TAnimate
        Left = 0
        Top = 16
        Width = 685
        Height = 50
        Align = alTop
        CommonAVI = aviFindFolder
        StopFrame = 29
      end
    end
    object TabFields: TTabSheet
      Caption = 'TabFields'
      ImageIndex = 2
      object lblInstructions: TTntLabel
        Left = 0
        Top = 0
        Width = 685
        Height = 16
        Align = alTop
        Caption = 'Fill in the search criteria to find contacts on.'
        WordWrap = True
        ExplicitWidth = 251
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      object Panel2: TPanel
        Left = 0
        Top = 280
        Width = 685
        Height = 73
        Align = alBottom
        BevelOuter = bvNone
        BorderWidth = 2
        ParentColor = True
        TabOrder = 0
        DesignSize = (
          685
          73)
        object Label3: TTntLabel
          Left = 2
          Top = 2
          Width = 156
          Height = 16
          Caption = 'Add Contacts to this group:'
        end
        object lblCount: TTntLabel
          Left = 397
          Top = 2
          Width = 79
          Height = 16
          Alignment = taRightJustify
          Caption = 'N items found'
        end
        object lblGroup: TTntLabel
          Left = 9
          Top = 32
          Width = 4
          Height = 16
        end
        object btnContacts: TButton
          Left = 385
          Top = 24
          Width = 93
          Height = 31
          Anchors = [akTop, akRight]
          Caption = 'Add'
          TabOrder = 0
          OnClick = popAddClick
        end
        object btnChat: TButton
          Left = 487
          Top = 24
          Width = 93
          Height = 31
          Anchors = [akTop, akRight]
          Caption = 'Chat'
          TabOrder = 1
          OnClick = OnChatClick
        end
        object btnBroadcastMsg: TButton
          Left = 590
          Top = 24
          Width = 93
          Height = 31
          Anchors = [akTop, akRight]
          Caption = 'Broadcast'
          TabOrder = 2
          OnClick = btnBroadcastMsgClick
        end
      end
      object lstContacts: TTntListView
        Left = 0
        Top = 0
        Width = 685
        Height = 280
        Align = alClient
        Columns = <
          item
            Width = 62
          end
          item
            Width = 62
          end
          item
            Width = 62
          end>
        HideSelection = False
        MultiSelect = True
        OwnerData = True
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupMenu1
        TabOrder = 1
        ViewStyle = vsReport
        OnColumnClick = lstContactsColumnClick
        OnContextPopup = lstContactsContextPopup
        OnData = lstContactsData
        OnMouseUp = lstContactsMouseUp
      end
    end
    object TabXData: TTabSheet
      Caption = 'TabXData'
      ImageIndex = 4
      inline xdataBox: TframeXData
        Left = 0
        Top = 0
        Width = 685
        Height = 353
        Align = alClient
        Color = 13681583
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        ExplicitWidth = 685
        ExplicitHeight = 353
        inherited Panel1: TPanel
          Width = 685
          Height = 353
          ExplicitWidth = 685
          ExplicitHeight = 353
          inherited ScrollBox1: TScrollBox
            Width = 675
            Height = 343
            ExplicitWidth = 675
            ExplicitHeight = 343
          end
        end
      end
    end
  end
  object PopupMenu1: TTntPopupMenu
    Left = 296
    Top = 16
    object popAdd: TTntMenuItem
      Caption = 'Add Contact'
      OnClick = popAddClick
    end
    object popProfile: TTntMenuItem
      Caption = 'View Profile'
      OnClick = popProfileClick
    end
    object N1: TTntMenuItem
      Caption = '-'
    end
    object popChat: TTntMenuItem
      Caption = 'Start Chat'
      OnClick = popChatClick
    end
  end
end
