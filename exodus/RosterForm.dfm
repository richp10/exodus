inherited RosterForm: TRosterForm
  BorderStyle = bsNone
  Caption = ''
  ClientHeight = 290
  ClientWidth = 422
  Color = clBtnFace
  ParentFont = False
  ShowHint = True
  OnClose = TntFormClose
  ExplicitWidth = 422
  ExplicitHeight = 290
  PixelsPerInch = 120
  TextHeight = 16
  object _PageControl: TTntPageControl
    Left = 0
    Top = 0
    Width = 422
    Height = 290
    Align = alClient
    OwnerDraw = True
    ParentShowHint = False
    RaggedRight = True
    ShowHint = True
    TabHeight = 26
    TabOrder = 0
    TabPosition = tpBottom
    TabWidth = 26
    OnDrawTab = _PageControlDrawTab
  end
  object ApplicationEvents: TApplicationEvents
    OnShowHint = ApplicationEventsShowHint
    Left = 344
    Top = 240
  end
end
