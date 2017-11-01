program Exodus;

{
    Copyright 2002, Peter Millard

    This file is part of Exodus.

    Exodus is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Exodus is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Exodus; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

{$R 'version.res' 'version.rc'}
{$R 'iehtml.res' 'iehtml.rc'}
{$R 'priority_images.res' 'priority_images.rc'}

{$ifdef VER150}
    {$define INDY9}
{$endif}
{$ifdef VER180}
    {$define INDY9}
{$endif}

uses
  Forms,
  Controls,
  Windows,
  About in 'About.pas' {frmAbout},
  AutoUpdate in '..\jopl\AutoUpdate.pas',
  AutoUpdateStatus in 'AutoUpdateStatus.pas' {frmAutoUpdateStatus},
  BaseChat in 'BaseChat.pas' {frmBaseChat},
  Browser in 'Browser.pas' {frmBrowse},
  Chat in '..\jopl\Chat.pas',
  ChatController in '..\jopl\ChatController.pas',
  ChatWin in 'ChatWin.pas' {frmChat},
  COMChatController in 'COMChatController.pas' {ExodusChatController: CoClass},
  COMController in 'COMController.pas' {ExodusController: CoClass},
  COMPPDB in 'COMPPDB.pas' {ExodusPPDB: CoClass},
  COMPresence in 'COMPresence.pas' {ExodusPresence: CoClass},
  COMRoster in 'COMRoster.pas' {ExodusRoster: CoClass},
  COMRosterItem in 'COMRosterItem.pas' {ExodusRosterItem: CoClass},
  ConnDetails in 'ConnDetails.pas' {frmConnDetails},
  CustomNotify in 'CustomNotify.pas' {frmCustomNotify},
  CustomPres in 'CustomPres.pas' {frmCustomPres},
  Debug in 'Debug.pas' {frmDebug},
  Dockable in 'Dockable.pas' {frmDockable},
  DropTarget in 'DropTarget.pas' {ExDropTarget: CoClass},
  Emoticons in 'Emoticons.pas' {frmEmoticons},
  ExResponders in 'ExResponders.pas',
  ExUtils in 'ExUtils.pas',
  fGeneric in 'fGeneric.pas' {frameGeneric: TFrame},
  fLeftLabel in 'fLeftLabel.pas' {frmField: TFrame},
  fListbox in 'fListbox.pas' {frameListbox: TFrame},
  fRosterTree in 'fRosterTree.pas' {frameTreeRoster: TFrame},
  fService in 'fService.pas' {frameObjectActions: TFrame},
  fTopLabel in 'fTopLabel.pas' {frameTopLabel: TFrame},
  getOpt in 'getOpt.pas',
  GrpRemove in 'GrpRemove.pas' {frmGrpRemove},
  GUIFactory in 'GUIFactory.pas',
  InputPassword in 'InputPassword.pas' {frmInputPass},
  InvalidRoster in 'InvalidRoster.pas' {frmInvalidRoster},
  invite in 'invite.pas' {frmInvite},
  IQ in '..\jopl\IQ.pas',
  Jabber1 in 'Jabber1.pas' {frmExodus},
  JabberAuth in '..\jopl\JabberAuth.pas',
  JabberConst in '..\jopl\JabberConst.pas',
  JabberID in '..\jopl\JabberID.pas',
  JabberMsg in '..\jopl\JabberMsg.pas',
  Langs in '..\jopl\Langs.pas',
  LibXmlComps in '..\jopl\LibXmlComps.pas',
  LibXmlParser in '..\jopl\LibXmlParser.pas',
  MsgController in '..\jopl\MsgController.pas',
  MsgDisplay in 'MsgDisplay.pas',
  Notify in 'Notify.pas',
  Password in 'Password.pas' {frmPassword},
  PathSelector in 'PathSelector.pas' {frmPathSelector},
  PluginAuth in 'PluginAuth.pas',
  PrefAway in 'prefs\PrefAway.pas' {frmPrefAway},
  PrefController in '..\jopl\PrefController.pas',
  PrefMsg in 'prefs\PrefMsg.pas' {frmPrefMsg},
  PrefNotify in 'prefs\PrefNotify.pas' {frmPrefNotify},
  PrefPanel in 'prefs\PrefPanel.pas' {frmPrefPanel},
  ManagePluginsDlg in 'prefs\ManagePluginsDlg.pas' {frmPrefPlugins},
  PrefPresence in 'prefs\PrefPresence.pas' {frmPrefPresence},
  Prefs in 'Prefs.pas' {frmPrefs},
  PrefSystem in 'prefs\PrefSystem.pas' {frmPrefSystem},
  Presence in '..\jopl\Presence.pas',
  Profile in 'Profile.pas' {frmProfile},
  RoomProperties in 'RoomProperties.pas' {frmRoomProperties},
  RegExpr in '..\jopl\RegExpr.pas',
  Register in 'Register.pas',
  RemoveContact in 'RemoveContact.pas' {frmRemove},
  Responder in '..\jopl\Responder.pas',
  RiserWindow in 'RiserWindow.pas' {frmRiser},
  Room in 'Room.pas' {frmRoom},
  RoomAdminList in 'RoomAdminList.pas' {frmRoomAdminList},
  RosterAdd in 'RosterAdd.pas' {frmAdd},
  RosterRecv in 'RosterRecv.pas' {frmRosterRecv},
  S10n in '..\jopl\S10n.pas',
  SecHash in '..\jopl\SecHash.pas',
  Session in '..\jopl\Session.pas',
  Signals in '..\jopl\Signals.pas',
  StandardAuth in '..\jopl\StandardAuth.pas',
  subscribe in 'subscribe.pas' {frmSubscribe},
  Transports in 'Transports.pas',
  Unicode in '..\jopl\Unicode.pas',
  vcard in 'vcard.pas' {frmVCard},
  XMLAttrib in '..\jopl\XMLAttrib.pas',
  XMLCData in '..\jopl\XMLCData.pas',
  XMLConstants in '..\jopl\XMLConstants.pas',
  XMLHttpStream in '..\jopl\XMLHttpStream.pas',
  XMLNode in '..\jopl\XMLNode.pas',
  XMLParser in '..\jopl\XMLParser.pas',
  XMLSocketStream in '..\jopl\XMLSocketStream.pas',
  XMLStream in '..\jopl\XMLStream.pas',
  XMLTag in '..\jopl\XMLTag.pas',
  XMLUtils in '..\jopl\XMLUtils.pas',
  XMLVCard in '..\jopl\XMLVCard.pas',
  gnugettext in 'gnugettext.pas',
  PrefTransfer in 'prefs\PrefTransfer.pas' {frmPrefTransfer},
  buttonFrame in 'buttonFrame.pas' {frameButtons: TFrame},
  ExSession in 'ExSession.pas',
  WebGet in 'WebGet.pas' {frmWebDownload},
  HttpProxyIOHandler in '..\jopl\HttpProxyIOHandler.pas',
  Wizard in 'Wizard.pas' {frmWizard},
  LocalUtils in 'LocalUtils.pas',
  SendStatus in 'SendStatus.pas' {fSendStatus: TFrame},
  XferManager in 'XferManager.pas' {frmXferManager},
  RecvStatus in 'RecvStatus.pas' {fRecvStatus: TFrame},
  GrpManagement in 'GrpManagement.pas' {frmGrpManagement},
  CapPresence in '..\jopl\CapPresence.pas',
  Jud in 'Jud.pas' {frmJud},
  DockWizard in 'DockWizard.pas' {frmDockWizard},
  SSLWarn in 'SSLWarn.pas' {frmSSLWarn},
  DNSUtils in '..\jopl\DNSUtils.pas',
  Entity in '..\jopl\Entity.pas',
  EntityCache in '..\jopl\EntityCache.pas',
  SASLAuth in '..\jopl\SASLAuth.pas',
  ExGettextUtils in 'ExGettextUtils.pas',
  JoinRoom in 'JoinRoom.pas',
  PrefFile in '..\jopl\PrefFile.pas',
  RegForm in 'RegForm.pas' {frmRegister},
  ExTracer in 'ExTracer.pas' {frmException},
  BaseMsgList in 'BaseMsgList.pas' {fBaseMsgList: TFrame},
  RTFMsgList in 'RTFMsgList.pas' {fRTFMsgList: TFrame},
  Emote in 'Emote.pas',
  GIFImage in 'GIFImage.pas',
  PrefEmoteDlg in 'prefs\PrefEmoteDlg.pas' {frmPrefEmoteDlg},
  EmoteProps in 'EmoteProps.pas' {frmEmoteProps},
  JabberUtils in '..\jopl\JabberUtils.pas',
  DockContainer in 'DockContainer.pas' {frmDockContainer},
  Random in '..\jopl\Random.pas',
  stringprep in '..\jopl\stringprep.pas',
  CommandWizard in 'CommandWizard.pas' {frmCommandWizard},
  fResults in 'fResults.pas' {frameResults: TFrame},
  Avatar in '..\jopl\Avatar.pas',
  FloatingImage in 'FloatingImage.pas' {FloatImage},
  xdata in 'xdata.pas' {frmXData},
  fXData in 'fXData.pas' {frameXData: TFrame},
  NewUser in 'NewUser.pas' {frmNewUser},
  DiscoIdentity in '..\jopl\DiscoIdentity.pas',
  fProfile in 'fProfile.pas' {frameProfile: TFrame},
  ZlibHandler in '..\jopl\ZlibHandler.pas',
  RosterImages in '..\jopl\RosterImages.pas',
  ToolbarImages in '..\jopl\ToolbarImages.pas',
  COMRosterGroup in 'COMRosterGroup.pas' {ExodusRosterGroup: CoClass},
  COMRosterImages in 'COMRosterImages.pas' {ExodusRosterImages: CoClass},
  CapsCache in '..\jopl\CapsCache.pas',
  COMEntityCache in 'COMEntityCache.pas' {ExodusEntityCache: CoClass},
  COMEntity in 'COMEntity.pas' {ExodusEntity: CoClass},
  PrtRichEdit in 'PrtRichEdit.pas',
  IdAuthenticationSSPI in '..\jopl\IdAuthenticationSSPI.pas',
  IdSSPI in '..\jopl\IdSSPI.pas',
  COMExRichEdit in 'COMGuis\COMExRichEdit.pas',
  COMExButton in 'COMGuis\COMExButton.pas',
  COMExCheckBox in 'COMGuis\COMExCheckBox.pas',
  COMExComboBox in 'COMGuis\COMExComboBox.pas',
  COMExEdit in 'COMGuis\COMExEdit.pas',
  COMExFont in 'COMGuis\COMExFont.pas',
  COMExLabel in 'COMGuis\COMExLabel.pas',
  COMExListBox in 'COMGuis\COMExListBox.pas',
  COMExMenuItem in 'COMGuis\COMExMenuItem.pas',
  COMExPanel in 'COMGuis\COMExPanel.pas',
  COMExPopupMenu in 'COMGuis\COMExPopupMenu.pas',
  COMExRadioButton in 'COMGuis\COMExRadioButton.pas',
  COMExControls in 'COMGuis\COMExControls.pas',
  Exodus_TLB in 'Exodus_TLB.pas',
  COMExSpeedButton in 'COMGuis\COMExSpeedButton.pas',
  COMExBitBtn in 'COMGuis\COMExBitBtn.pas',
  COMExMainMenu in 'COMGuis\COMExMainMenu.pas',
  COMExMemo in 'COMGuis\COMExMemo.pas',
  COMExPageControl in 'COMGuis\COMExPageControl.pas',
  COMToolbar in 'COMToolbar.pas' {ExodusToolbar: CoClass},
  COMToolbarButton in 'COMToolbarButton.pas' {ExodusToolbarButton: CoClass},
  COMExForm in 'COMGuis\COMExForm.pas',
  COMLogMsg in 'COMLogMsg.pas' {ExodusLogMsg: CoClass},
  COMExodusMsg in 'COMExodusMsg.pas' {ExodusMsg: CoClass},
  COMLogListener in 'COMLogListener.pas' {ExodusLogListener: CoClass},
  KerbAuth in '..\jopl\KerbAuth.pas',
  NTLMAuth in '..\jopl\NTLMAuth.pas',
  SASLMech in '..\jopl\SASLMech.pas',
  ExternalAuth in '..\jopl\ExternalAuth.pas',
  DebugLogger in '..\jopl\DebugLogger.pas',
  ExodusImageList in '..\jopl\ExodusImageList.pas',
  PrefGraphics in '..\jopl\PrefGraphics.pas',
  AddressList in '..\jopl\AddressList.pas',
  Keywords in 'Keywords.pas',
  COMBookmarkManager in 'COMBookmarkManager.pas',
  StateForm in 'StateForm.pas' {frmState: TTntForm},
  PrefHotkeys in 'prefs\PrefHotkeys.pas' {frmPrefHotkeys},
  ModifyHotkeys in 'ModifyHotkeys.pas' {frmModifyHotkeys},
  RT_XIMConversion in 'RT_XIMConversion.pas',
  ToolbarColorSelect in 'ToolbarColorSelect.pas' {frmToolbarColorSelect},
  DisplayName in '..\jopl\DisplayName.pas',
  BrowseForFolderU in 'BrowseForFolderU.pas',
  SelRoomOccupant in 'SelRoomOccupant.pas' {frmSelRoomOccupant},
  COMDockToolbar in 'COMDockToolbar.pas',
  COMMsgOutToolbar in 'COMMsgOutToolbar.pas',
  idSSLSchannel in 'idSSLSchannel.pas',
  DebugManager in '..\jopl\DebugManager.pas',
  VistaAltFixUnit in 'VistaAltFixUnit.pas',
  ExFrame in 'components\base\ExFrame.pas' {baseFrame},
  ExForm in 'components\base\ExForm.pas' {baseForm},
  ActivityWindow in 'ActivityWindow.pas' {frmActivityWindow},
  DockWindow in 'DockWindow.pas' {frmDockWindow},
  ExodusDockManager in 'ExodusDockManager.pas',
  AWItem in 'AWItem.pas' {fAWItem: TTntFrame},
  PrefDisplay in 'prefs\PrefDisplay.pas' {frmPrefDisplay},
  toastsettings in 'prefs\toastsettings.pas',
  ManageBlockDlg in 'prefs\ManageBlockDlg.pas' {Form1},
  ManageKeywordsDlg in 'prefs\ManageKeywordsDlg.pas' {Form2},
  IEMsgList in 'IEMsgList.pas' {fIEMsgList: TFrame},
  MSHTMLEvents in 'MSHTMLEvents.pas',
  PrefRoster in 'prefs\PrefRoster.pas' {frmPrefRoster: TTntForm},
  ActiveXDockable in 'ActiveXDockable.pas' {frmActiveXDockable},
  COMAXWindow in 'COMAXWindow.pas',
  LoginWindow in 'LoginWindow.pas' {frmLoginWindow: TTntForm},
  COMExodusItem in '..\jopl\COMExodusItem.pas',
  COMExodusItemController in '..\jopl\COMExodusItemController.pas',
  COMExodusTabWrapper in 'COMExodusTabWrapper.pas',
  ContactController in '..\jopl\ContactController.pas',
  RosterForm in 'RosterForm.pas' {Form3},
  InviteReceived in 'InviteReceived.pas' {frmInviteReceived: TTntForm},
  IdDNSResolver in '..\jopl\IdDNSResolver.pas',
  COMExodusTabController in 'COMExodusTabController.pas' {ExodusTabController: CoClass},
  COMExodusTab in 'COMExodusTab.pas' {ExodusTab: CoClass},
  ExTreeView in 'components\ExTreeView.pas',
  COMExodusItemWrapper in '..\jopl\COMExodusItemWrapper.pas' {/ExTreeView in 'components\ExTreeView.pas';
},
  RoomController in '..\jopl\RoomController.pas',
  IEMsgListUIHandler in 'IEMsgListUIHandler.pas',
  ExActions in '..\jopl\actions\ExActions.pas',
  ExActionCtrl in '..\jopl\actions\ExActionCtrl.pas',
  ExActionMap in '..\jopl\actions\ExActionMap.pas',
  COMExodusItemList in '..\jopl\COMExodusItemList.pas' {ExodusItemList: CoClass},
  SQLiteTable3 in 'SQLiteTable3.pas',
  SQLite3 in 'SQLite3.pas',
  COMExodusDataStore in 'COMExodusDataStore.pas',
  COMExodusDataTable in 'COMExodusDataTable.pas',
  SQLLogger in 'SQLLogger.pas',
  ManageTabsDlg in 'prefs\ManageTabsDlg.pas' {frmPrefTabs: TTntForm},
  SQLSearchHandler in 'SQLSearchHandler.pas',
  SQLSearchThread in 'SQLSearchThread.pas',
  SQLUtils in '..\jopl\SQLUtils.pas',
  HistorySearch in 'HistorySearch.pas' {HistorySearchDlg},
  SelectItem in 'SelectItem.pas' {frmSelectItem},
  ContactActions in 'ContactActions.pas',
  FrmUtils in '..\jopl\FrmUtils.pas',
  SelectItemAny in 'SelectItemAny.pas' {frmSelectItemAny: TTntForm},
  COMExodusHistorySearchManager in 'COMExodusHistorySearchManager.pas',
  COMExodusHistoryResult in 'COMExodusHistoryResult.pas',
  COMExodusHistorySearch in 'COMExodusHistorySearch.pas',
  GroupParser in '..\jopl\GroupParser.pas',
  GroupActions in 'GroupActions.pas',
  MiscMessages in 'MiscMessages.pas' {frmSimpleDisplay: TTntForm},
  SelectItemRoom in 'SelectItemRoom.pas' {frmSelectItemRoom: TTntForm},
  SelectItemAnyRoom in 'SelectItemAnyRoom.pas' {frmSelectItemAnyRoom: TTntForm},
  ExAllTreeView in 'components\ExAllTreeView.pas',
  CommonActions in 'CommonActions.pas',
  ExContactHoverFrame in 'components\ExContactHoverFrame.pas' {ExContactHoverFrame: TTntFrame},
  ExItemHoverForm in 'components\ExItemHoverForm.pas' {ExItemHoverForm: TTntForm},
  ExRoomHoverFrame in 'components\ExRoomHoverFrame.pas' {ExRoomHoverFrame: TTntFrame},
  SndBroadcastDlg in 'SndBroadcastDlg.pas' {dlgSndBroadcast},
  BookmarkForm in 'BookmarkForm.pas',
  FontConsts in '..\jopl\FontConsts.pas',
  COMMainToolBarImages in 'COMMainToolBarImages.pas',
  COMExodusHover in 'COMExodusHover.pas' {COMExodusHover: CoClass},
  ExHoverFrame in 'components\ExHoverFrame.pas' {Frame1: TFrame},
  COMExEventData in 'COMExEventData.pas' {ExodusEventXML: CoClass},
  COMExodusPacketDispatcher in 'COMExodusPacketDispatcher.pas',
  XMLVCardCache in '..\jopl\XMLVCardCache.pas',
  AvatarCache in '..\jopl\AvatarCache.pas',
  ExVcardCache in 'ExVcardCache.pas',
  Pubsub in 'pubsub\Pubsub.pas',
  NTDLLFixup in '..\jopl\NTDLLFixup.pas',
  PNGWrapper in '..\jopl\PNGWrapper.pas',
  NGImages in '..\jopl\TNGImage\Package\NGImages.pas';

{$R *.TLB}

{$R *.RES}

{$R manifest.res}
{$R xtra.res}
{$R xml.res}

var
    continue: boolean;


    begin

  // Sometimes OLE registration fails if the user don't
  // have sufficient privs.. Just silently eat these.
  try
    Application.Initialize;
  except
  end;

{$IFDEF VER185}
  Application.MainFormOnTaskbar := True;
{$ENDIF}
  Application.Title := '';
  Application.ShowMainForm := false;

  {$ifdef LEAKCHECK}
  // MemChk();
  {$endif}

  // Main startup stuff
  continue := SetupSession();
  if (not continue) then exit;

  Application.CreateForm(TfrmExodus, frmExodus);
  Application.CreateForm(TFloatImage, FloatImage);
  Application.OnHelp := frmExodus.DisableHelp;
  frmExodus.Startup();
  Application.Run;

end.

