inherited frmCommandWizard: TfrmCommandWizard
  Left = 238
  Top = 139
  Height = 294
  BorderStyle = bsSizeable
  Caption = 'frmCommandWizard'
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited TntPanel1: TTntPanel
    Top = 219
    inherited Panel3: TPanel
      Left = 72
      Width = 338
      inherited btnBack: TTntButton
        OnClick = btnBackClick
      end
      inherited btnNext: TTntButton
        OnClick = btnNextClick
      end
      inherited btnCancel: TTntButton
        Left = 255
        OnClick = btnCancelClick
      end
      object btnFinish: TTntButton
        Left = 165
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Finish'
        Enabled = False
        TabOrder = 3
        OnClick = btnFinishClick
      end
    end
  end
  inherited Panel1: TPanel
    inherited lblWizardTitle: TTntLabel
      Width = 140
      Caption = 'Jabber Command Wizard'
    end
    inherited lblWizardDetails: TTntLabel
      Caption = ''
    end
  end
  inherited Tabs: TPageControl
    Height = 159
    ActivePage = tbsResults
    inherited TabSheet1: TTabSheet
      object TntLabel1: TTntLabel
        Left = 0
        Top = 0
        Width = 402
        Height = 13
        Align = alTop
        Caption = 'Select or enter the jabber id of the entity to execute.'
      end
      object TntLabel2: TTntLabel
        Left = 8
        Top = 40
        Width = 49
        Height = 13
        Caption = 'Jabber ID:'
      end
      object txtJid: TTntComboBox
        Left = 104
        Top = 37
        Width = 233
        Height = 21
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object tbsSelect: TTabSheet
      Caption = 'tbsSelect'
      ImageIndex = 1
      object TntLabel3: TTntLabel
        Left = 0
        Top = 0
        Width = 192
        Height = 13
        Align = alTop
        Caption = 'Select the specific command to execute.'
      end
      object TntLabel4: TTntLabel
        Left = 8
        Top = 40
        Width = 50
        Height = 13
        Caption = 'Command:'
      end
      object txtCommand: TTntComboBox
        Left = 104
        Top = 37
        Width = 233
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
      end
    end
    object tbsExecute: TTabSheet
      Caption = 'tbsExecute'
      ImageIndex = 2
      inline xDataBox: TframeXData
        Left = 0
        Top = 0
        Width = 402
        Height = 132
        Align = alClient
        TabOrder = 0
        inherited Panel1: TPanel
          Width = 402
          inherited ScrollBox1: TScrollBox
            Width = 392
          end
        end
      end
    end
    object tbsResults: TTabSheet
      Caption = 'tbsResults'
      ImageIndex = 3
      object lblNote: TExodusLabel
        Left = 0
        Top = 0
        Width = 402
        Height = 30
        Align = alTop
        Visible = False
      end
    end
    object tbsWait: TTabSheet
      Caption = 'tbsWait'
      ImageIndex = 4
      object lblWait: TTntLabel
        Left = 0
        Top = 0
        Width = 63
        Height = 13
        Align = alTop
        Caption = 'Please wait...'
      end
    end
  end
end
