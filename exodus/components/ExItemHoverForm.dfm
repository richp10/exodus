inherited ExItemHoverForm: TExItemHoverForm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Display Name'
  ClientHeight = 193
  ClientWidth = 260
  PopupMode = pmExplicit
  OnCreate = TntFormCreate
  OnDestroy = TntFormDestroy
  OnMouseEnter = TntFormMouseEnter
  OnMouseLeave = TntFormMouseLeave
  ExplicitWidth = 266
  ExplicitHeight = 219
  PixelsPerInch = 96
  TextHeight = 13
  object HoverHide: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = HoverHideTimer
    Left = 232
    Top = 216
  end
  object HoverReenter: TTimer
    Enabled = False
    Interval = 500
    OnTimer = HoverReenterTimer
    Left = 192
    Top = 216
  end
end
