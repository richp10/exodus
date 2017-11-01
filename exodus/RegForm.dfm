inherited frmRegister: TfrmRegister
  Left = 246
  Top = 361
  Caption = 'Service Registration'
  OldCreateOrder = True
  PixelsPerInch = 120
  TextHeight = 16
  inherited TntPanel1: TTntPanel
    inherited btnBack: TTntButton
      OnClick = btnPrevClick
    end
    inherited btnNext: TTntButton
      OnClick = btnNextClick
    end
    inherited btnCancel: TTntButton
      OnClick = btnCancelClick
    end
  end
  inherited Tabs: TPageControl
    ActivePage = TabSheet2
    inherited TabSheet1: TTabSheet
      object Label1: TTntLabel
        Left = 0
        Top = 0
        Width = 600
        Height = 111
        Align = alTop
        AutoSize = False
        Caption = 
          'This wizard will register you with a service or Agent. Use the N' +
          'ext button to advance through the steps. Use Cancel anytime to c' +
          'ancel this registration.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitWidth = 598
      end
      object lblIns: TTntLabel
        Left = 0
        Top = 111
        Width = 600
        Height = 222
        Align = alClient
        AutoSize = False
        Caption = 'Waiting for agent instructions.....'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitWidth = 598
        ExplicitHeight = 250
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object formBox: TScrollBox
        Left = 0
        Top = 0
        Width = 600
        Height = 293
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 0
        Top = 293
        Width = 600
        Height = 40
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        DesignSize = (
          600
          40)
        object btnDelete: TTntButton
          Left = 400
          Top = 6
          Width = 198
          Height = 31
          Anchors = [akRight, akBottom]
          Caption = 'Delete My Registration'
          TabOrder = 0
          OnClick = btnDeleteClick
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      object Label2: TTntLabel
        Left = 0
        Top = 0
        Width = 600
        Height = 111
        Align = alTop
        AutoSize = False
        Caption = 'Please wait, Sending your registration to the service....'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitWidth = 598
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      object lblOK: TTntLabel
        Left = 0
        Top = 0
        Width = 600
        Height = 111
        Align = alTop
        AutoSize = False
        Caption = 
          'Your registration to this service has been completed successfull' +
          'y. Press the '#39'Finish'#39' button to finish.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
        ExplicitWidth = 598
      end
      object lblBad: TTntLabel
        Left = 0
        Top = 111
        Width = 600
        Height = 111
        Align = alTop
        AutoSize = False
        Caption = 
          'Your registration to this service has failed! Press '#39'Back'#39' to go' +
          ' back and verify that all of the parameters have been filled in ' +
          'correctly. Press '#39'Cancel'#39' to close this wizard.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
        ExplicitWidth = 598
      end
    end
  end
  inherited pnlDock: TTntPanel
    inherited pnlDockTopContainer: TTntPanel
      inherited tbDockBar: TToolBar
        Left = 558
      end
      inherited pnlDockTop: TTntPanel
        Width = 554
        inherited Panel1: TPanel
          Width = 552
          inherited lblWizardTitle: TTntLabel
            Width = 523
            Anchors = [akLeft, akTop, akRight]
          end
          inherited lblWizardDetails: TTntLabel
            Width = 804
            Anchors = [akLeft, akTop, akRight]
          end
          inherited Image1: TImage
            Left = 502
            Picture.Data = {00}
          end
        end
        inherited pnlBevel: TTntPanel
          Width = 552
          inherited Bevel2: TBevel
            Width = 552
          end
        end
      end
    end
  end
end
