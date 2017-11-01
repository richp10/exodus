unit Exodus_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 8291 $
// File generated on 8/28/2008 4:05:37 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\source\MomentIM-trunk-foo\src\exodus\exodus\Exodus.tlb (1)
// LIBID: {37C1EF21-E4CD-4FF0-B6A5-3F0A649431C8}
// LCID: 0
// Helpfile: 
// HelpString: Exodus COM Plugin interfaces
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v2.0 MSXML, (C:\WINDOWS\system32\msxml.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, MSXML_TLB, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExodusMajorVersion = 1;
  ExodusMinorVersion = 0;

  LIBID_Exodus: TGUID = '{37C1EF21-E4CD-4FF0-B6A5-3F0A649431C8}';

  IID_IExodusController: TGUID = '{A764C2F3-F1C9-4DE6-95D7-5876C9D4E99C}';
  IID_IExodusController2: TGUID = '{885E0A1E-E3A7-4F63-BD4D-0015C921CB96}';
  IID_IExodusChat2: TGUID = '{51385483-0B0F-45A3-95C7-579A8DDF62DF}';
  IID_IExodusMenuListener: TGUID = '{2ABB30A9-94E3-4085-BED5-4561F62E36EF}';
  IID_IExodusChatPlugin: TGUID = '{E28E487A-7258-4B32-AD1C-F23A808F0460}';
  IID_IExodusRoster2: TGUID = '{A9C4F6FB-2ACA-4B09-A9F5-F3BDDD763AAF}';
  IID_IExodusPPDB: TGUID = '{284E49F2-2006-4E48-B0E0-233867A78E54}';
  IID_IExodusRosterItem: TGUID = '{BDD5493D-440F-4376-802B-070B5A4ABFF3}';
  IID_IExodusPresence: TGUID = '{FF4EFE7E-35AC-48B5-ACDB-6753C402F0DB}';
  IID_IExodusAuth: TGUID = '{BFE1905C-3620-4C9D-B0C2-27EB456EF73B}';
  IID_IExodusRosterGroup: TGUID = '{FA63024E-3453-4551-8CA0-AFB78B2066AD}';
  IID_IExodusRosterImages: TGUID = '{F4AAF511-D144-42E7-B108-8A196D4BD115}';
  IID_IExodusEntityCache: TGUID = '{6759BFE4-C72D-42E3-86A3-1F343E848933}';
  IID_IExodusEntity: TGUID = '{1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}';
  IID_IExodusControl: TGUID = '{0B992E91-DAD7-4CDC-9FD6-8007A63700E0}';
  IID_IExodusControlCheckBox: TGUID = '{896CCC11-8929-4FEC-BC95-C96E5027C1F6}';
  IID_IExodusControlComboBox: TGUID = '{16D21C8F-EF88-4E93-87C6-CD8F8C1EE7F7}';
  IID_IExodusControlEdit: TGUID = '{A7B8A353-FF1E-4933-9A01-BD7B0FDC6F02}';
  IID_IExodusControlFont: TGUID = '{D8297D0C-A316-4E9D-A89C-095CFAE51141}';
  IID_IExodusControlLabel: TGUID = '{F53704E6-83C2-4021-97A5-169BC58D9E03}';
  IID_IExodusControlListBox: TGUID = '{F34F969E-4BC2-4ADE-8648-A8F618FCC205}';
  IID_IExodusControlMenuItem: TGUID = '{EFBC071A-460A-4E1B-89EC-25B23460BA93}';
  IID_IExodusControlPanel: TGUID = '{BA37BB99-F039-49B7-AB56-819E87B0472F}';
  IID_IExodusControlPopupMenu: TGUID = '{F80CD345-A91C-40C8-89CD-AD5BE532B9C2}';
  IID_IExodusControlRadioButton: TGUID = '{87FAD954-03E1-4657-B58D-9947087EAAEC}';
  IID_IExodusControlRichEdit: TGUID = '{3997314D-4068-43E7-ACEB-150FF196069C}';
  IID_IExodusControlButton: TGUID = '{0D41733E-3505-46FB-B199-C6046E1C84C7}';
  IID_IExodusIQListener: TGUID = '{57DFE494-4509-4972-A93B-6C7E6A9D6A59}';
  IID_IExodusChat: TGUID = '{D2639B6C-A7BB-4CCC-BD73-8C1EB197F9D3}';
  IID_IExodusRoster: TGUID = '{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}';
  CLASS_ExodusPPDB: TGUID = '{9ED8C497-1121-4C9E-B586-C7DFDB35B581}';
  CLASS_ExodusRosterItem: TGUID = '{B39343ED-2E2D-4C91-AE4F-E0153BA347DA}';
  CLASS_ExodusPresence: TGUID = '{8B7DF610-B49C-4A90-9B98-CB0CB27D8827}';
  CLASS_ExodusRosterGroup: TGUID = '{05237BC3-3093-4541-941D-A38FAFB78D89}';
  IID_IExodusRosterImages2: TGUID = '{21FC4FF3-2699-4ABC-BF6D-AF42FB407C25}';
  CLASS_ExodusEntityCache: TGUID = '{B777EA4A-A2A4-4597-87E2-E1B9800BFDC2}';
  CLASS_ExodusEntity: TGUID = '{F7D97ED8-C6BA-470F-8D63-7A6D70894AB3}';
  IID_IExodusControlBitBtn: TGUID = '{2954B16B-64BA-4441-A476-918CCCCA9B46}';
  IID_IExodusControlMainMenu: TGUID = '{0C3AE024-51A4-453F-91CB-B0EEBA175AED}';
  IID_IExodusControlMemo: TGUID = '{62B921DE-13F1-4F63-BCA6-30EE3C66D454}';
  IID_IExodusControlPageControl: TGUID = '{AF41AC90-38C4-46FB-9A45-D7C26ECB2E1C}';
  IID_IExodusControlSpeedButton: TGUID = '{0706359E-DD10-4D98-862B-7417E5E79DE8}';
  IID_IExodusListener: TGUID = '{28132170-54E2-4BDD-A37D-BE115E68F044}';
  IID_IExodusToolbar: TGUID = '{7949D67E-E287-4643-90DA-E6FE7EDEFA97}';
  IID_IExodusToolbarButton2: TGUID = '{7F9C4FDB-8567-45DF-9E92-8FFB7FA28A34}';
  IID_IExodusToolbarController: TGUID = '{0EF5DFF4-B59B-4948-983B-3119F6A89E31}';
  IID_IExodusToolbarButton: TGUID = '{D4749AC4-6EBE-493B-844C-0455FF0A4A77}';
  IID_IExodusControlForm: TGUID = '{2F60EC05-634D-44B2-BECB-059169BA1459}';
  IID_IExodusLogger: TGUID = '{35542007-5701-4190-AB28-D25EB186CC19}';
  IID_IExodusLogMsg: TGUID = '{2E945876-C2E5-4A24-98B4-0E38BD65D431}';
  CLASS_ExodusLogMsg: TGUID = '{740743C0-7BEF-48E8-BD05-1470047F03CA}';
  IID_IExodusLogListener: TGUID = '{6D58A577-6BC4-4B1C-B5F8-759B94136B0A}';
  CLASS_ExodusLogListener: TGUID = '{98ED888A-0569-4E5B-8933-36EBF08812B4}';
  IID_IExodusPlugin: TGUID = '{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}';
  IID_IExodusBookmarkManager: TGUID = '{E40D85F3-9E0D-4368-89D0-C4298315CD30}';
  CLASS_ExodusBookmarkManager: TGUID = '{EEEE7D8D-0C7E-4DF1-B556-CFDAD2893123}';
  IID_IExodusToolbarControl: TGUID = '{B35EACB5-C3DC-473E-8C4C-EFA175DF4CAB}';
  CLASS_ExodusToolbarControl: TGUID = '{6AB0CC3F-2AF5-460B-B76C-1A4E807BA152}';
  IID_IExodusPlugin2: TGUID = '{7A57094D-B8DE-4EE8-82B4-B5412F5C2F14}';
  IID_IExodusMsgOutToolbar: TGUID = '{51F924C1-A27E-4396-8EF3-B5035D325CF7}';
  IID_IExodusDockToolbar: TGUID = '{F7427F75-8915-4AC2-823F-1C897BE9B9A6}';
  CLASS_ExodusMsgOutToolbar: TGUID = '{A13F6C20-8EA7-4477-B915-3C4AEECBB637}';
  CLASS_ExodusDockToolbar: TGUID = '{9CF91FC0-612D-4815-A715-B1F9E9BF54E8}';
  CLASS_ExodusChat: TGUID = '{C9FEB6AF-32BE-4B47-984C-9DA11B4DF7A6}';
  CLASS_ExodusToolbarButton: TGUID = '{D29EB98A-994F-4E67-A12F-652733E7E5DD}';
  CLASS_ExodusRoster: TGUID = '{027E1B53-59A9-4FA4-9610-AC6CA2561248}';
  IID_IExodusAXWindow: TGUID = '{8F2F3430-1E7E-4FA7-B65D-A25B48EFE880}';
  CLASS_ExodusAXWindow: TGUID = '{E11594EF-419A-498F-ACF3-D3382D22F048}';
  IID_IExodusItem: TGUID = '{44410CB8-2AD7-4D58-8067-2E795EB28E60}';
  IID_IExodusItemController: TGUID = '{7E8D248E-F7E3-4541-A72A-37E1E87C4C93}';
  CLASS_ExodusItem: TGUID = '{7F9132F5-838F-423C-A334-F28AA8E2E597}';
  CLASS_ExodusItemController: TGUID = '{5BA92396-E45E-4311-A4F9-B0154DB0445A}';
  IID_IExodusTabController: TGUID = '{9717635B-FC59-40A9-8282-1902D897BF09}';
  IID_IExodusTab: TGUID = '{F633716F-B315-4867-A1D0-6E177831FA27}';
  CLASS_ExodusTabController: TGUID = '{820EB166-9870-4D1A-B693-EC4F5A39E2BA}';
  CLASS_ExodusTab: TGUID = '{9FC3FE8B-4F0D-48A9-B38A-7D8507E6CBF0}';
  IID_IExodusDataStore: TGUID = '{20A21035-31DD-4F14-AF03-DB4B2DC26ACB}';
  IID_IExodusDataTable: TGUID = '{2BD06814-A066-4D2D-9236-FE33B9CB4759}';
  CLASS_ExodusDataStore: TGUID = '{D1FE5126-8833-43E3-BBDF-F684A158A3E3}';
  CLASS_ExodusDataTable: TGUID = '{A83961EB-6756-4719-B493-1CC664CC9F98}';
  IID_IExodusItemList: TGUID = '{8247F310-6DAB-4D81-BF91-8D53C7A028D1}';
  CLASS_ExodusItemList: TGUID = '{7B0DF61F-D7E0-4253-A846-8F29C7F5D5E8}';
  IID_IExodusHistorySearch: TGUID = '{719FB50D-8FD3-48DE-82A2-13E4668E7B71}';
  IID_IExodusHistoryResult: TGUID = '{DC665BA9-A59B-4038-A162-33AB2EFA961D}';
  IID_IExodusHistorySearchHandler: TGUID = '{EA467AEA-897D-4CBA-918E-CF274981C3C8}';
  IID_IExodusHistorySearchManager: TGUID = '{810CB0EC-25DA-443B-8F16-D3E710ED333B}';
  CLASS_ExodusHistorySearch: TGUID = '{58A2E35A-A42F-42AC-BAC1-83FCE2F27A32}';
  CLASS_ExodusHistoryResult: TGUID = '{37DC94DD-FDB8-4E9E-84E2-A37747F70713}';
  CLASS_ExodusHistorySearchManager: TGUID = '{3821A305-8C0D-47BE-AA5B-A5E62F9D4BD5}';
  CLASS_ExodusHistorySQLSearchHandler: TGUID = '{64EE21C2-6212-44D2-8FF1-F0FCC1FD5F67}';
  IID_IExodusAction: TGUID = '{30D5C4FE-F672-4240-B381-53D84C20FA04}';
  IID_IExodusTypedActions: TGUID = '{638D1155-7D20-4295-A461-86E27FF28A5E}';
  IID_IExodusActionMap: TGUID = '{B7C79472-A921-4357-84EB-A01902B18791}';
  IID_IExodusActionController: TGUID = '{4318FEF0-E766-4269-935E-417CE9925991}';
  CLASS_ExodusActionController: TGUID = '{0C473B97-BF10-4FEF-B20B-8C6724E3A395}';
  IID_IExodusItemSelection: TGUID = '{DB35AAD2-6E6B-4A3D-A12D-A73E383586B9}';
  IID_IExodusItemCallback: TGUID = '{74B2E5CA-F9AB-4FC6-8361-36652C7D57B2}';
  IID_IExodusAXWindowCallback: TGUID = '{87D6C026-3A1C-43CF-B153-BB6472A956AD}';
  CLASS_ExodusRosterImages: TGUID = '{F0EA9081-9352-496D-94BA-E96605166527}';
  IID_IExodusChatPlugin2: TGUID = '{B92A81A9-79B8-47F0-8A79-1CAC711089E5}';
  IID_IExodusChat3: TGUID = '{FD3F0F9F-0BD9-4087-B892-C8FE5E332E40}';
  IID_IExodusHoverListener: TGUID = '{71150EFD-FFF5-4114-A7AC-A9540453376A}';
  IID_IExodusHover: TGUID = '{4CF49CD8-4B9B-4648-A07C-280111E724DA}';
  CLASS_COMExodusHover: TGUID = '{9004F424-7233-404F-8AC7-59F29BC5EFFB}';
  IID_IExodusEventXML: TGUID = '{8FB96A63-DA5C-459A-9B28-A177A6406CBC}';
  CLASS_ExodusEventXML: TGUID = '{34677FDC-B4F5-4DD1-A3C6-B74856AF4CC5}';
  IID_IExodusPacketDispatcher: TGUID = '{96BB23C1-F6BC-4007-8CE6-83107C7D0B29}';
  IID_IExodusMenuListener2: TGUID = '{046DE4B3-E2B0-4B39-9A55-98541ABFC8FA}';
  IID_IExodusPacketControlListener: TGUID = '{1DDEA354-6FA2-43E1-AE81-8ABE167AB791}';
  IID_IExodusControlSite: TGUID = '{B976BDA3-5BCB-488F-AA45-2818F2FCEE1F}';
  CLASS_exodusController: TGUID = '{E89B1EBA-8CF8-4A00-B15D-18149A0FA830}';
  CLASS_MainToolBarImages: TGUID = '{EED39569-B9B7-4888-A591-2640F31B3BC0}';
  IID_IExodusMsg: TGUID = '{46DFB7CF-1431-4B99-9F07-A427D6F7EE77}';
  CLASS_ExodusMsg: TGUID = '{26EE3B49-A7E1-4B67-B63B-16F8BBE3B841}';
  CLASS_ExodusToolbar: TGUID = '{E12A4659-336B-4921-AC6A-771B1DCA5AF8}';
  CLASS_ExodusPacketDispatcher: TGUID = '{DB860D8B-51E5-479E-A8A0-648288C8D031}';
  IID_IExodusPubsubListener: TGUID = '{EF6AFD93-FBF8-409E-BF37-052608F55FCB}';
  IID_IExodusPubsubService: TGUID = '{542C6454-D12A-4DB2-B158-3DEBC1A9E017}';
  IID_IExodusPubsubController: TGUID = '{A4710E01-8CC8-4AC3-A49F-B702A4208D84}';
  IID_IExodusControllerRegistry: TGUID = '{E2AE307A-FFA5-4C68-B56D-FC6165924805}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum ChatParts
type
  ChatParts = TOleEnum;
const
  HWND_MsgInput = $00000000;
  Ptr_MsgInput = $00000001;
  HWND_MsgOutput = $00000002;
  Ptr_MsgOutput = $00000003;

// Constants for enum ActiveItem
type
  ActiveItem = TOleEnum;
const
  RosterItem = $00000000;
  Bookmark = $00000001;
  Group = $00000002;

// Constants for enum ExodusControlTypes
type
  ExodusControlTypes = TOleEnum;
const
  ExodusControlButton = $00000000;
  ExodusControlCheckBox = $00000001;
  ExodusControlComboBox = $00000002;
  ExodusControlEdit = $00000003;
  ExodusControlFont = $00000004;
  ExodusControlLabel = $00000005;
  ExodusControlListBox = $00000006;
  ExodusControlMenuItem = $00000007;
  ExodusControlPanel = $00000008;
  ExodusControlPopupMenu = $00000009;
  ExodusControlRadioButton = $0000000A;
  ExodusControlRichEdit = $0000000B;
  ExodusControlBitBtn = $0000000C;
  ExodusControlMainMenu = $0000000D;
  ExodusControlMemo = $0000000E;
  ExodusControlPageControl = $0000000F;
  ExodusControlSpeedButton = $00000010;
  ExodusControlForm = $00000011;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExodusController = interface;
  IExodusControllerDisp = dispinterface;
  IExodusController2 = interface;
  IExodusController2Disp = dispinterface;
  IExodusChat2 = interface;
  IExodusChat2Disp = dispinterface;
  IExodusMenuListener = interface;
  IExodusMenuListenerDisp = dispinterface;
  IExodusChatPlugin = interface;
  IExodusChatPluginDisp = dispinterface;
  IExodusRoster2 = interface;
  IExodusRoster2Disp = dispinterface;
  IExodusPPDB = interface;
  IExodusPPDBDisp = dispinterface;
  IExodusRosterItem = interface;
  IExodusRosterItemDisp = dispinterface;
  IExodusPresence = interface;
  IExodusPresenceDisp = dispinterface;
  IExodusAuth = interface;
  IExodusAuthDisp = dispinterface;
  IExodusRosterGroup = interface;
  IExodusRosterGroupDisp = dispinterface;
  IExodusRosterImages = interface;
  IExodusRosterImagesDisp = dispinterface;
  IExodusEntityCache = interface;
  IExodusEntityCacheDisp = dispinterface;
  IExodusEntity = interface;
  IExodusEntityDisp = dispinterface;
  IExodusControl = interface;
  IExodusControlDisp = dispinterface;
  IExodusControlCheckBox = interface;
  IExodusControlCheckBoxDisp = dispinterface;
  IExodusControlComboBox = interface;
  IExodusControlComboBoxDisp = dispinterface;
  IExodusControlEdit = interface;
  IExodusControlEditDisp = dispinterface;
  IExodusControlFont = interface;
  IExodusControlFontDisp = dispinterface;
  IExodusControlLabel = interface;
  IExodusControlLabelDisp = dispinterface;
  IExodusControlListBox = interface;
  IExodusControlListBoxDisp = dispinterface;
  IExodusControlMenuItem = interface;
  IExodusControlMenuItemDisp = dispinterface;
  IExodusControlPanel = interface;
  IExodusControlPanelDisp = dispinterface;
  IExodusControlPopupMenu = interface;
  IExodusControlPopupMenuDisp = dispinterface;
  IExodusControlRadioButton = interface;
  IExodusControlRadioButtonDisp = dispinterface;
  IExodusControlRichEdit = interface;
  IExodusControlRichEditDisp = dispinterface;
  IExodusControlButton = interface;
  IExodusControlButtonDisp = dispinterface;
  IExodusIQListener = interface;
  IExodusIQListenerDisp = dispinterface;
  IExodusChat = interface;
  IExodusChatDisp = dispinterface;
  IExodusRoster = interface;
  IExodusRosterDisp = dispinterface;
  IExodusRosterImages2 = interface;
  IExodusRosterImages2Disp = dispinterface;
  IExodusControlBitBtn = interface;
  IExodusControlBitBtnDisp = dispinterface;
  IExodusControlMainMenu = interface;
  IExodusControlMainMenuDisp = dispinterface;
  IExodusControlMemo = interface;
  IExodusControlMemoDisp = dispinterface;
  IExodusControlPageControl = interface;
  IExodusControlPageControlDisp = dispinterface;
  IExodusControlSpeedButton = interface;
  IExodusControlSpeedButtonDisp = dispinterface;
  IExodusListener = interface;
  IExodusListenerDisp = dispinterface;
  IExodusToolbar = interface;
  IExodusToolbarDisp = dispinterface;
  IExodusToolbarButton2 = interface;
  IExodusToolbarButton2Disp = dispinterface;
  IExodusToolbarController = interface;
  IExodusToolbarControllerDisp = dispinterface;
  IExodusToolbarButton = interface;
  IExodusToolbarButtonDisp = dispinterface;
  IExodusControlForm = interface;
  IExodusControlFormDisp = dispinterface;
  IExodusLogger = interface;
  IExodusLoggerDisp = dispinterface;
  IExodusLogMsg = interface;
  IExodusLogMsgDisp = dispinterface;
  IExodusLogListener = interface;
  IExodusLogListenerDisp = dispinterface;
  IExodusPlugin = interface;
  IExodusPluginDisp = dispinterface;
  IExodusBookmarkManager = interface;
  IExodusBookmarkManagerDisp = dispinterface;
  IExodusToolbarControl = interface;
  IExodusToolbarControlDisp = dispinterface;
  IExodusPlugin2 = interface;
  IExodusPlugin2Disp = dispinterface;
  IExodusMsgOutToolbar = interface;
  IExodusMsgOutToolbarDisp = dispinterface;
  IExodusDockToolbar = interface;
  IExodusDockToolbarDisp = dispinterface;
  IExodusAXWindow = interface;
  IExodusAXWindowDisp = dispinterface;
  IExodusItem = interface;
  IExodusItemDisp = dispinterface;
  IExodusItemController = interface;
  IExodusItemControllerDisp = dispinterface;
  IExodusTabController = interface;
  IExodusTabControllerDisp = dispinterface;
  IExodusTab = interface;
  IExodusTabDisp = dispinterface;
  IExodusDataStore = interface;
  IExodusDataStoreDisp = dispinterface;
  IExodusDataTable = interface;
  IExodusDataTableDisp = dispinterface;
  IExodusItemList = interface;
  IExodusItemListDisp = dispinterface;
  IExodusHistorySearch = interface;
  IExodusHistorySearchDisp = dispinterface;
  IExodusHistoryResult = interface;
  IExodusHistoryResultDisp = dispinterface;
  IExodusHistorySearchHandler = interface;
  IExodusHistorySearchHandlerDisp = dispinterface;
  IExodusHistorySearchManager = interface;
  IExodusHistorySearchManagerDisp = dispinterface;
  IExodusAction = interface;
  IExodusActionDisp = dispinterface;
  IExodusTypedActions = interface;
  IExodusTypedActionsDisp = dispinterface;
  IExodusActionMap = interface;
  IExodusActionMapDisp = dispinterface;
  IExodusActionController = interface;
  IExodusActionControllerDisp = dispinterface;
  IExodusItemSelection = interface;
  IExodusItemSelectionDisp = dispinterface;
  IExodusItemCallback = interface;
  IExodusItemCallbackDisp = dispinterface;
  IExodusAXWindowCallback = interface;
  IExodusAXWindowCallbackDisp = dispinterface;
  IExodusChatPlugin2 = interface;
  IExodusChatPlugin2Disp = dispinterface;
  IExodusChat3 = interface;
  IExodusChat3Disp = dispinterface;
  IExodusHoverListener = interface;
  IExodusHoverListenerDisp = dispinterface;
  IExodusHover = interface;
  IExodusHoverDisp = dispinterface;
  IExodusEventXML = interface;
  IExodusEventXMLDisp = dispinterface;
  IExodusPacketDispatcher = interface;
  IExodusPacketDispatcherDisp = dispinterface;
  IExodusMenuListener2 = interface;
  IExodusMenuListener2Disp = dispinterface;
  IExodusPacketControlListener = interface;
  IExodusPacketControlListenerDisp = dispinterface;
  IExodusControlSite = interface;
  IExodusControlSiteDisp = dispinterface;
  IExodusMsg = interface;
  IExodusMsgDisp = dispinterface;
  IExodusPubsubListener = interface;
  IExodusPubsubListenerDisp = dispinterface;
  IExodusPubsubService = interface;
  IExodusPubsubServiceDisp = dispinterface;
  IExodusPubsubController = interface;
  IExodusPubsubControllerDisp = dispinterface;
  IExodusControllerRegistry = interface;
  IExodusControllerRegistryDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExodusPPDB = IExodusPPDB;
  ExodusRosterItem = IExodusRosterItem;
  ExodusPresence = IExodusPresence;
  ExodusRosterGroup = IExodusRosterGroup;
  ExodusEntityCache = IExodusEntityCache;
  ExodusEntity = IExodusEntity;
  ExodusLogMsg = IExodusLogMsg;
  ExodusLogListener = IExodusLogListener;
  ExodusBookmarkManager = IExodusBookmarkManager;
  ExodusToolbarControl = IExodusToolbarControl;
  ExodusMsgOutToolbar = IExodusMsgOutToolbar;
  ExodusDockToolbar = IExodusDockToolbar;
  ExodusChat = IExodusChat;
  ExodusToolbarButton = IExodusToolbarButton;
  ExodusRoster = IExodusRoster;
  ExodusAXWindow = IExodusAXWindow;
  ExodusItem = IExodusItem;
  ExodusItemController = IExodusItemController;
  ExodusTabController = IExodusTabController;
  ExodusTab = IExodusTab;
  ExodusDataStore = IExodusDataStore;
  ExodusDataTable = IExodusDataTable;
  ExodusItemList = IExodusItemList;
  ExodusHistorySearch = IExodusHistorySearch;
  ExodusHistoryResult = IExodusHistoryResult;
  ExodusHistorySearchManager = IExodusHistorySearchManager;
  ExodusHistorySQLSearchHandler = IExodusHistorySearchHandler;
  ExodusActionController = IExodusActionController;
  ExodusRosterImages = IExodusRosterImages;
  COMExodusHover = IExodusHover;
  ExodusEventXML = IDispatch;
  exodusController = IExodusController;
  MainToolBarImages = IExodusRosterImages;
  ExodusMsg = IExodusMsg;
  ExodusToolbar = IExodusToolbar;
  ExodusPacketDispatcher = IExodusPacketDispatcher;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWideString1 = ^WideString; {*}
  PWordBool1 = ^WordBool; {*}
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// Interface: IExodusController
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A764C2F3-F1C9-4DE6-95D7-5876C9D4E99C}
// *********************************************************************//
  IExodusController = interface(IDispatch)
    ['{A764C2F3-F1C9-4DE6-95D7-5876C9D4E99C}']
    function Get_Connected: WordBool; safecall;
    function Get_Username: WideString; safecall;
    function Get_Server: WideString; safecall;
    function RegisterCallback(const xpath: WideString; const callback: IExodusPlugin): Integer; safecall;
    procedure UnRegisterCallback(ID: Integer); safecall;
    procedure Send(const XML: WideString); safecall;
    function IsRosterJID(const JID: WideString): WordBool; safecall;
    function IsSubscribed(const JID: WideString): WordBool; safecall;
    procedure ChangePresence(const Show: WideString; const Status: WideString; Priority: Integer); safecall;
    procedure StartChat(const JID: WideString; const Resource: WideString; 
                        const Nickname: WideString); safecall;
    procedure GetProfile(const JID: WideString); safecall;
    function CreateDockableWindow(const Caption: WideString): Integer; safecall;
    function AddPluginMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemovePluginMenu(const menuID: WideString); safecall;
    procedure MonitorImplicitRegJID(const JabberID: WideString; fullJID: WordBool); safecall;
    function GetAgentService(const Server: WideString; const service: WideString): WideString; safecall;
    function GenerateID: WideString; safecall;
    function IsBlocked(const JabberID: WideString): WordBool; safecall;
    procedure Block(const JabberID: WideString); safecall;
    procedure UnBlock(const JabberID: WideString); safecall;
    function Get_Resource: WideString; safecall;
    function Get_Port: Integer; safecall;
    function Get_Priority: Integer; safecall;
    function Get_PresenceStatus: WideString; safecall;
    function Get_PresenceShow: WideString; safecall;
    function Get_IsPaused: WordBool; safecall;
    function Get_IsInvisible: WordBool; safecall;
    procedure Connect; safecall;
    procedure Disconnect; safecall;
    function GetPrefAsString(const key: WideString): WideString; safecall;
    function GetPrefAsInt(const key: WideString): Integer; safecall;
    function GetPrefAsBool(const key: WideString): WordBool; safecall;
    procedure SetPrefAsString(const key: WideString; const value: WideString); safecall;
    procedure SetPrefAsInt(const key: WideString; value: Integer); safecall;
    procedure SetPrefAsBool(const key: WideString; value: WordBool); safecall;
    function FindChat(const JabberID: WideString; const Resource: WideString): Integer; safecall;
    procedure StartSearch(const searchJID: WideString); safecall;
    procedure StartRoom(const roomJID: WideString; const Nickname: WideString; 
                        const password: WideString; sendPresence: WordBool; 
                        defaultConfig: WordBool; useRegisteredNickname: WordBool); safecall;
    procedure StartInstantMsg(const JabberID: WideString); safecall;
    procedure StartBrowser(const browseJID: WideString); safecall;
    procedure ShowJoinRoom(const roomJID: WideString; const Nickname: WideString; 
                           const password: WideString); safecall;
    procedure ShowPrefs; safecall;
    procedure ShowCustomPresDialog; safecall;
    procedure ShowDebug; safecall;
    procedure ShowLogin; safecall;
    procedure ShowToast(const message: WideString; wndHandle: Integer; ImageIndex: Integer); safecall;
    procedure SetPresence(const Show: WideString; const Status: WideString; Priority: Integer); safecall;
    function Get_Roster: IExodusRoster; safecall;
    function Get_PPDB: IExodusPPDB; safecall;
    function RegisterDiscoItem(const JabberID: WideString; const Name: WideString): WideString; safecall;
    procedure RemoveDiscoItem(const ID: WideString); safecall;
    function RegisterPresenceXML(const XML: WideString): WideString; safecall;
    procedure RemovePresenceXML(const ID: WideString); safecall;
    procedure TrackWindowsMsg(message: Integer); safecall;
    function AddContactMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveContactMenu(const menuID: WideString); safecall;
    function GetActiveContact: WideString; safecall;
    function GetActiveGroup: WideString; safecall;
    function GetActiveContacts(Online: WordBool): OleVariant; safecall;
    function Get_LocalIP: WideString; safecall;
    procedure SetPluginAuth(const authAgent: IExodusAuth); safecall;
    procedure SetAuthenticated(authed: WordBool; const XML: WideString); safecall;
    procedure SetAuthJID(const Username: WideString; const host: WideString; 
                         const Resource: WideString); safecall;
    function AddMessageMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    function AddGroupMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveGroupMenu(const menuID: WideString); safecall;
    procedure RegisterWithService(const JabberID: WideString); safecall;
    procedure ShowAddContact(const JID: WideString); safecall;
    procedure RegisterCapExtension(const ext: WideString; const Feature: WideString); safecall;
    procedure UnregisterCapExtension(const ext: WideString); safecall;
    function Get_RosterImages: IExodusRosterImages; safecall;
    function Get_EntityCache: IExodusEntityCache; safecall;
    procedure Debug(const value: WideString); safecall;
    function TrackIQ(const XML: WideString; const listener: IExodusIQListener; timeout: Integer): WideString; safecall;
    procedure FireEvent(const event: WideString; const XML: WideString; const arg: WideString); safecall;
    function RegisterListener(const xpath: WideString; const listener: IExodusListener): Integer; safecall;
    function Get_Toolbar: IExodusToolbar; safecall;
    function Get_ContactLogger: IExodusLogger; safecall;
    procedure Set_ContactLogger(const value: IExodusLogger); safecall;
    function Get_RoomLogger: IExodusLogger; safecall;
    procedure Set_RoomLogger(const value: IExodusLogger); safecall;
    procedure AddStringlistValue(const key: WideString; const value: WideString); safecall;
    procedure RemoveMessageMenu(const menuID: WideString); safecall;
    function GetStringlistCount(const key: WideString): Integer; safecall;
    function GetStringlistValue(const key: WideString; index: Integer): WideString; safecall;
    procedure RemoveStringlistValue(const key: WideString; const value: WideString); safecall;
    function Get_BookmarkManager: IExodusBookmarkManager; safecall;
    property Connected: WordBool read Get_Connected;
    property Username: WideString read Get_Username;
    property Server: WideString read Get_Server;
    property Resource: WideString read Get_Resource;
    property Port: Integer read Get_Port;
    property Priority: Integer read Get_Priority;
    property PresenceStatus: WideString read Get_PresenceStatus;
    property PresenceShow: WideString read Get_PresenceShow;
    property IsPaused: WordBool read Get_IsPaused;
    property IsInvisible: WordBool read Get_IsInvisible;
    property Roster: IExodusRoster read Get_Roster;
    property PPDB: IExodusPPDB read Get_PPDB;
    property LocalIP: WideString read Get_LocalIP;
    property RosterImages: IExodusRosterImages read Get_RosterImages;
    property EntityCache: IExodusEntityCache read Get_EntityCache;
    property Toolbar: IExodusToolbar read Get_Toolbar;
    property ContactLogger: IExodusLogger read Get_ContactLogger write Set_ContactLogger;
    property RoomLogger: IExodusLogger read Get_RoomLogger write Set_RoomLogger;
    property BookmarkManager: IExodusBookmarkManager read Get_BookmarkManager;
  end;

// *********************************************************************//
// DispIntf:  IExodusControllerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A764C2F3-F1C9-4DE6-95D7-5876C9D4E99C}
// *********************************************************************//
  IExodusControllerDisp = dispinterface
    ['{A764C2F3-F1C9-4DE6-95D7-5876C9D4E99C}']
    property Connected: WordBool readonly dispid 1;
    property Username: WideString readonly dispid 2;
    property Server: WideString readonly dispid 3;
    function RegisterCallback(const xpath: WideString; const callback: IExodusPlugin): Integer; dispid 4;
    procedure UnRegisterCallback(ID: Integer); dispid 5;
    procedure Send(const XML: WideString); dispid 6;
    function IsRosterJID(const JID: WideString): WordBool; dispid 7;
    function IsSubscribed(const JID: WideString): WordBool; dispid 8;
    procedure ChangePresence(const Show: WideString; const Status: WideString; Priority: Integer); dispid 11;
    procedure StartChat(const JID: WideString; const Resource: WideString; 
                        const Nickname: WideString); dispid 12;
    procedure GetProfile(const JID: WideString); dispid 13;
    function CreateDockableWindow(const Caption: WideString): Integer; dispid 16;
    function AddPluginMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 14;
    procedure RemovePluginMenu(const menuID: WideString); dispid 15;
    procedure MonitorImplicitRegJID(const JabberID: WideString; fullJID: WordBool); dispid 17;
    function GetAgentService(const Server: WideString; const service: WideString): WideString; dispid 19;
    function GenerateID: WideString; dispid 20;
    function IsBlocked(const JabberID: WideString): WordBool; dispid 21;
    procedure Block(const JabberID: WideString); dispid 22;
    procedure UnBlock(const JabberID: WideString); dispid 23;
    property Resource: WideString readonly dispid 24;
    property Port: Integer readonly dispid 25;
    property Priority: Integer readonly dispid 26;
    property PresenceStatus: WideString readonly dispid 28;
    property PresenceShow: WideString readonly dispid 29;
    property IsPaused: WordBool readonly dispid 30;
    property IsInvisible: WordBool readonly dispid 31;
    procedure Connect; dispid 32;
    procedure Disconnect; dispid 33;
    function GetPrefAsString(const key: WideString): WideString; dispid 34;
    function GetPrefAsInt(const key: WideString): Integer; dispid 35;
    function GetPrefAsBool(const key: WideString): WordBool; dispid 36;
    procedure SetPrefAsString(const key: WideString; const value: WideString); dispid 37;
    procedure SetPrefAsInt(const key: WideString; value: Integer); dispid 38;
    procedure SetPrefAsBool(const key: WideString; value: WordBool); dispid 39;
    function FindChat(const JabberID: WideString; const Resource: WideString): Integer; dispid 40;
    procedure StartSearch(const searchJID: WideString); dispid 41;
    procedure StartRoom(const roomJID: WideString; const Nickname: WideString; 
                        const password: WideString; sendPresence: WordBool; 
                        defaultConfig: WordBool; useRegisteredNickname: WordBool); dispid 42;
    procedure StartInstantMsg(const JabberID: WideString); dispid 43;
    procedure StartBrowser(const browseJID: WideString); dispid 44;
    procedure ShowJoinRoom(const roomJID: WideString; const Nickname: WideString; 
                           const password: WideString); dispid 45;
    procedure ShowPrefs; dispid 46;
    procedure ShowCustomPresDialog; dispid 47;
    procedure ShowDebug; dispid 48;
    procedure ShowLogin; dispid 49;
    procedure ShowToast(const message: WideString; wndHandle: Integer; ImageIndex: Integer); dispid 50;
    procedure SetPresence(const Show: WideString; const Status: WideString; Priority: Integer); dispid 51;
    property Roster: IExodusRoster readonly dispid 54;
    property PPDB: IExodusPPDB readonly dispid 55;
    function RegisterDiscoItem(const JabberID: WideString; const Name: WideString): WideString; dispid 10;
    procedure RemoveDiscoItem(const ID: WideString); dispid 53;
    function RegisterPresenceXML(const XML: WideString): WideString; dispid 57;
    procedure RemovePresenceXML(const ID: WideString); dispid 58;
    procedure TrackWindowsMsg(message: Integer); dispid 59;
    function AddContactMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 60;
    procedure RemoveContactMenu(const menuID: WideString); dispid 61;
    function GetActiveContact: WideString; dispid 62;
    function GetActiveGroup: WideString; dispid 63;
    function GetActiveContacts(Online: WordBool): OleVariant; dispid 65;
    property LocalIP: WideString readonly dispid 64;
    procedure SetPluginAuth(const authAgent: IExodusAuth); dispid 66;
    procedure SetAuthenticated(authed: WordBool; const XML: WideString); dispid 67;
    procedure SetAuthJID(const Username: WideString; const host: WideString; 
                         const Resource: WideString); dispid 68;
    function AddMessageMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 201;
    function AddGroupMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 202;
    procedure RemoveGroupMenu(const menuID: WideString); dispid 203;
    procedure RegisterWithService(const JabberID: WideString); dispid 204;
    procedure ShowAddContact(const JID: WideString); dispid 205;
    procedure RegisterCapExtension(const ext: WideString; const Feature: WideString); dispid 206;
    procedure UnregisterCapExtension(const ext: WideString); dispid 207;
    property RosterImages: IExodusRosterImages readonly dispid 208;
    property EntityCache: IExodusEntityCache readonly dispid 209;
    procedure Debug(const value: WideString); dispid 210;
    function TrackIQ(const XML: WideString; const listener: IExodusIQListener; timeout: Integer): WideString; dispid 211;
    procedure FireEvent(const event: WideString; const XML: WideString; const arg: WideString); dispid 212;
    function RegisterListener(const xpath: WideString; const listener: IExodusListener): Integer; dispid 213;
    property Toolbar: IExodusToolbar readonly dispid 214;
    property ContactLogger: IExodusLogger dispid 215;
    property RoomLogger: IExodusLogger dispid 216;
    procedure AddStringlistValue(const key: WideString; const value: WideString); dispid 217;
    procedure RemoveMessageMenu(const menuID: WideString); dispid 218;
    function GetStringlistCount(const key: WideString): Integer; dispid 219;
    function GetStringlistValue(const key: WideString; index: Integer): WideString; dispid 220;
    procedure RemoveStringlistValue(const key: WideString; const value: WideString); dispid 221;
    property BookmarkManager: IExodusBookmarkManager readonly dispid 222;
  end;

// *********************************************************************//
// Interface: IExodusController2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {885E0A1E-E3A7-4F63-BD4D-0015C921CB96}
// *********************************************************************//
  IExodusController2 = interface(IDispatch)
    ['{885E0A1E-E3A7-4F63-BD4D-0015C921CB96}']
    function Get_TabController: IExodusTabController; safecall;
    function Get_ItemController: IExodusItemController; safecall;
    function NewAXWindow(const ActiveX_GUID: WideString; const ActiveXWindow_Caption: WideString; 
                         BringToFront: WordBool): IExodusAXWindow; safecall;
    function Get_DataStore: IExodusDataStore; safecall;
    function Get_HistorySearchManager: IExodusHistorySearchManager; safecall;
    function Get_ActionController: IExodusActionController; safecall;
    function GetPrefAsXML(const key: WideString): WideString; safecall;
    procedure SetPrefAsXML(const XML: WideString); safecall;
    function SelectItem(const ItemType: WideString; const Title: WideString; 
                        IncludeAnyOption: WordBool; parentHWND: Integer): WideString; safecall;
    function SelectRoom(const Title: WideString; IncludeJoinedRoomList: WordBool; 
                        IncludeAnyOption: WordBool; parentHWND: Integer): WideString; safecall;
    procedure ShowToastWithEvent(const message: WideString; const event: WideString; 
                                 const eventXML: WideString; ImageIndex: Integer); safecall;
    function Get_MainToolBarImages: IExodusRosterImages; safecall;
    function Get_EnableFilesDragAndDrop: WordBool; safecall;
    procedure Set_EnableFilesDragAndDrop(value: WordBool); safecall;
    function Get_PacketDispatcher: IExodusPacketDispatcher; safecall;
    property TabController: IExodusTabController read Get_TabController;
    property ItemController: IExodusItemController read Get_ItemController;
    property DataStore: IExodusDataStore read Get_DataStore;
    property HistorySearchManager: IExodusHistorySearchManager read Get_HistorySearchManager;
    property ActionController: IExodusActionController read Get_ActionController;
    property MainToolBarImages: IExodusRosterImages read Get_MainToolBarImages;
    property EnableFilesDragAndDrop: WordBool read Get_EnableFilesDragAndDrop write Set_EnableFilesDragAndDrop;
    property PacketDispatcher: IExodusPacketDispatcher read Get_PacketDispatcher;
  end;

// *********************************************************************//
// DispIntf:  IExodusController2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {885E0A1E-E3A7-4F63-BD4D-0015C921CB96}
// *********************************************************************//
  IExodusController2Disp = dispinterface
    ['{885E0A1E-E3A7-4F63-BD4D-0015C921CB96}']
    property TabController: IExodusTabController readonly dispid 223;
    property ItemController: IExodusItemController readonly dispid 224;
    function NewAXWindow(const ActiveX_GUID: WideString; const ActiveXWindow_Caption: WideString; 
                         BringToFront: WordBool): IExodusAXWindow; dispid 225;
    property DataStore: IExodusDataStore readonly dispid 226;
    property HistorySearchManager: IExodusHistorySearchManager readonly dispid 227;
    property ActionController: IExodusActionController readonly dispid 228;
    function GetPrefAsXML(const key: WideString): WideString; dispid 229;
    procedure SetPrefAsXML(const XML: WideString); dispid 230;
    function SelectItem(const ItemType: WideString; const Title: WideString; 
                        IncludeAnyOption: WordBool; parentHWND: Integer): WideString; dispid 231;
    function SelectRoom(const Title: WideString; IncludeJoinedRoomList: WordBool; 
                        IncludeAnyOption: WordBool; parentHWND: Integer): WideString; dispid 232;
    procedure ShowToastWithEvent(const message: WideString; const event: WideString; 
                                 const eventXML: WideString; ImageIndex: Integer); dispid 233;
    property MainToolBarImages: IExodusRosterImages readonly dispid 234;
    property EnableFilesDragAndDrop: WordBool dispid 235;
    property PacketDispatcher: IExodusPacketDispatcher readonly dispid 236;
  end;

// *********************************************************************//
// Interface: IExodusChat2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {51385483-0B0F-45A3-95C7-579A8DDF62DF}
// *********************************************************************//
  IExodusChat2 = interface(IDispatch)
    ['{51385483-0B0F-45A3-95C7-579A8DDF62DF}']
    function Get_DockToolbar: IExodusDockToolbar; safecall;
    function Get_MsgOutToolbar: IExodusMsgOutToolbar; safecall;
    property DockToolbar: IExodusDockToolbar read Get_DockToolbar;
    property MsgOutToolbar: IExodusMsgOutToolbar read Get_MsgOutToolbar;
  end;

// *********************************************************************//
// DispIntf:  IExodusChat2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {51385483-0B0F-45A3-95C7-579A8DDF62DF}
// *********************************************************************//
  IExodusChat2Disp = dispinterface
    ['{51385483-0B0F-45A3-95C7-579A8DDF62DF}']
    property DockToolbar: IExodusDockToolbar readonly dispid 212;
    property MsgOutToolbar: IExodusMsgOutToolbar readonly dispid 223;
  end;

// *********************************************************************//
// Interface: IExodusMenuListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2ABB30A9-94E3-4085-BED5-4561F62E36EF}
// *********************************************************************//
  IExodusMenuListener = interface(IDispatch)
    ['{2ABB30A9-94E3-4085-BED5-4561F62E36EF}']
    procedure OnMenuItemClick(const menuID: WideString; const XML: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusMenuListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2ABB30A9-94E3-4085-BED5-4561F62E36EF}
// *********************************************************************//
  IExodusMenuListenerDisp = dispinterface
    ['{2ABB30A9-94E3-4085-BED5-4561F62E36EF}']
    procedure OnMenuItemClick(const menuID: WideString; const XML: WideString); dispid 255;
  end;

// *********************************************************************//
// Interface: IExodusChatPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E28E487A-7258-4B32-AD1C-F23A808F0460}
// *********************************************************************//
  IExodusChatPlugin = interface(IDispatch)
    ['{E28E487A-7258-4B32-AD1C-F23A808F0460}']
    function OnBeforeMessage(var Body: WideString): WordBool; safecall;
    function OnAfterMessage(var Body: WideString): WideString; safecall;
    procedure OnClose; safecall;
    procedure OnNewWindow(hwnd: Integer); safecall;
    function OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool; safecall;
    procedure OnAfterRecvMessage(var Body: WideString); safecall;
    function OnKeyUp(key: Integer; shiftState: Integer): WordBool; safecall;
    function OnKeyDown(key: Integer; shiftState: Integer): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusChatPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E28E487A-7258-4B32-AD1C-F23A808F0460}
// *********************************************************************//
  IExodusChatPluginDisp = dispinterface
    ['{E28E487A-7258-4B32-AD1C-F23A808F0460}']
    function OnBeforeMessage(var Body: WideString): WordBool; dispid 1;
    function OnAfterMessage(var Body: WideString): WideString; dispid 2;
    procedure OnClose; dispid 6;
    procedure OnNewWindow(hwnd: Integer); dispid 202;
    function OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool; dispid 203;
    procedure OnAfterRecvMessage(var Body: WideString); dispid 204;
    function OnKeyUp(key: Integer; shiftState: Integer): WordBool; dispid 301;
    function OnKeyDown(key: Integer; shiftState: Integer): WordBool; dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusRoster2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A9C4F6FB-2ACA-4B09-A9F5-F3BDDD763AAF}
// *********************************************************************//
  IExodusRoster2 = interface(IDispatch)
    ['{A9C4F6FB-2ACA-4B09-A9F5-F3BDDD763AAF}']
    procedure EnableContextMenuItem(const menuID: WideString; const itemID: WideString; 
                                    enable: WordBool); safecall;
    procedure ShowContextMenuItem(const menuID: WideString; const itemID: WideString; Show: WordBool); safecall;
    procedure SetContextMenuItemCaption(const menuID: WideString; const itemID: WideString; 
                                        const Caption: WideString); safecall;
    function GetContextMenuItemCaption(const menuID: WideString; const itemID: WideString): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusRoster2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A9C4F6FB-2ACA-4B09-A9F5-F3BDDD763AAF}
// *********************************************************************//
  IExodusRoster2Disp = dispinterface
    ['{A9C4F6FB-2ACA-4B09-A9F5-F3BDDD763AAF}']
    procedure EnableContextMenuItem(const menuID: WideString; const itemID: WideString; 
                                    enable: WordBool); dispid 213;
    procedure ShowContextMenuItem(const menuID: WideString; const itemID: WideString; Show: WordBool); dispid 214;
    procedure SetContextMenuItemCaption(const menuID: WideString; const itemID: WideString; 
                                        const Caption: WideString); dispid 215;
    function GetContextMenuItemCaption(const menuID: WideString; const itemID: WideString): WideString; dispid 216;
  end;

// *********************************************************************//
// Interface: IExodusPPDB
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {284E49F2-2006-4E48-B0E0-233867A78E54}
// *********************************************************************//
  IExodusPPDB = interface(IDispatch)
    ['{284E49F2-2006-4E48-B0E0-233867A78E54}']
    function Find(const JabberID: WideString; const Resource: WideString): IExodusPresence; safecall;
    function Next(const JabberID: WideString; const Resource: WideString): IExodusPresence; safecall;
    function Get_Count: Integer; safecall;
    function Get_LastPresence: IExodusPresence; safecall;
    property Count: Integer read Get_Count;
    property LastPresence: IExodusPresence read Get_LastPresence;
  end;

// *********************************************************************//
// DispIntf:  IExodusPPDBDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {284E49F2-2006-4E48-B0E0-233867A78E54}
// *********************************************************************//
  IExodusPPDBDisp = dispinterface
    ['{284E49F2-2006-4E48-B0E0-233867A78E54}']
    function Find(const JabberID: WideString; const Resource: WideString): IExodusPresence; dispid 1;
    function Next(const JabberID: WideString; const Resource: WideString): IExodusPresence; dispid 2;
    property Count: Integer readonly dispid 3;
    property LastPresence: IExodusPresence readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IExodusRosterItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BDD5493D-440F-4376-802B-070B5A4ABFF3}
// *********************************************************************//
  IExodusRosterItem = interface(IDispatch)
    ['{BDD5493D-440F-4376-802B-070B5A4ABFF3}']
    function Get_JabberID: WideString; safecall;
    function Get_Subscription: WideString; safecall;
    function Get_Ask: WideString; safecall;
    function Get_GroupCount: Integer; safecall;
    function Group(index: Integer): WideString; safecall;
    function XML: WideString; safecall;
    procedure Remove; safecall;
    procedure Update; safecall;
    function Get_Nickname: WideString; safecall;
    procedure Set_Nickname(const value: WideString); safecall;
    function Get_ContextMenuID: WideString; safecall;
    procedure Set_ContextMenuID(const value: WideString); safecall;
    function Get_Status: WideString; safecall;
    procedure Set_Status(const value: WideString); safecall;
    function Get_Tooltip: WideString; safecall;
    procedure Set_Tooltip(const value: WideString); safecall;
    function Get_Action: WideString; safecall;
    procedure Set_Action(const value: WideString); safecall;
    function Get_ImageIndex: Integer; safecall;
    procedure Set_ImageIndex(value: Integer); safecall;
    function Get_InlineEdit: WordBool; safecall;
    procedure Set_InlineEdit(value: WordBool); safecall;
    procedure FireChange; safecall;
    function Get_IsContact: WordBool; safecall;
    procedure Set_IsContact(value: WordBool); safecall;
    procedure AddGroup(const grp: WideString); safecall;
    procedure RemoveGroup(const grp: WideString); safecall;
    procedure SetCleanGroups; safecall;
    function Get_ImagePrefix: WideString; safecall;
    procedure Set_ImagePrefix(const value: WideString); safecall;
    function Get_IsNative: WordBool; safecall;
    procedure Set_IsNative(value: WordBool); safecall;
    function Get_CanOffline: WordBool; safecall;
    procedure Set_CanOffline(value: WordBool); safecall;
    property JabberID: WideString read Get_JabberID;
    property Subscription: WideString read Get_Subscription;
    property Ask: WideString read Get_Ask;
    property GroupCount: Integer read Get_GroupCount;
    property Nickname: WideString read Get_Nickname write Set_Nickname;
    property ContextMenuID: WideString read Get_ContextMenuID write Set_ContextMenuID;
    property Status: WideString read Get_Status write Set_Status;
    property Tooltip: WideString read Get_Tooltip write Set_Tooltip;
    property Action: WideString read Get_Action write Set_Action;
    property ImageIndex: Integer read Get_ImageIndex write Set_ImageIndex;
    property InlineEdit: WordBool read Get_InlineEdit write Set_InlineEdit;
    property IsContact: WordBool read Get_IsContact write Set_IsContact;
    property ImagePrefix: WideString read Get_ImagePrefix write Set_ImagePrefix;
    property IsNative: WordBool read Get_IsNative write Set_IsNative;
    property CanOffline: WordBool read Get_CanOffline write Set_CanOffline;
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BDD5493D-440F-4376-802B-070B5A4ABFF3}
// *********************************************************************//
  IExodusRosterItemDisp = dispinterface
    ['{BDD5493D-440F-4376-802B-070B5A4ABFF3}']
    property JabberID: WideString readonly dispid 1;
    property Subscription: WideString readonly dispid 2;
    property Ask: WideString readonly dispid 4;
    property GroupCount: Integer readonly dispid 5;
    function Group(index: Integer): WideString; dispid 6;
    function XML: WideString; dispid 7;
    procedure Remove; dispid 8;
    procedure Update; dispid 9;
    property Nickname: WideString dispid 10;
    property ContextMenuID: WideString dispid 201;
    property Status: WideString dispid 202;
    property Tooltip: WideString dispid 203;
    property Action: WideString dispid 204;
    property ImageIndex: Integer dispid 205;
    property InlineEdit: WordBool dispid 206;
    procedure FireChange; dispid 207;
    property IsContact: WordBool dispid 208;
    procedure AddGroup(const grp: WideString); dispid 210;
    procedure RemoveGroup(const grp: WideString); dispid 211;
    procedure SetCleanGroups; dispid 212;
    property ImagePrefix: WideString dispid 209;
    property IsNative: WordBool dispid 213;
    property CanOffline: WordBool dispid 214;
  end;

// *********************************************************************//
// Interface: IExodusPresence
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF4EFE7E-35AC-48B5-ACDB-6753C402F0DB}
// *********************************************************************//
  IExodusPresence = interface(IDispatch)
    ['{FF4EFE7E-35AC-48B5-ACDB-6753C402F0DB}']
    function Get_PresType: WideString; safecall;
    procedure Set_PresType(const value: WideString); safecall;
    function Get_Status: WideString; safecall;
    procedure Set_Status(const value: WideString); safecall;
    function Get_Show: WideString; safecall;
    procedure Set_Show(const value: WideString); safecall;
    function Get_Priority: Integer; safecall;
    procedure Set_Priority(value: Integer); safecall;
    function Get_ErrorString: WideString; safecall;
    procedure Set_ErrorString(const value: WideString); safecall;
    function XML: WideString; safecall;
    function IsSubscription: WordBool; safecall;
    function Get_ToJid: WideString; safecall;
    procedure Set_ToJid(const value: WideString); safecall;
    function Get_FromJid: WideString; safecall;
    procedure Set_FromJid(const value: WideString); safecall;
    property PresType: WideString read Get_PresType write Set_PresType;
    property Status: WideString read Get_Status write Set_Status;
    property Show: WideString read Get_Show write Set_Show;
    property Priority: Integer read Get_Priority write Set_Priority;
    property ErrorString: WideString read Get_ErrorString write Set_ErrorString;
    property ToJid: WideString read Get_ToJid write Set_ToJid;
    property FromJid: WideString read Get_FromJid write Set_FromJid;
  end;

// *********************************************************************//
// DispIntf:  IExodusPresenceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF4EFE7E-35AC-48B5-ACDB-6753C402F0DB}
// *********************************************************************//
  IExodusPresenceDisp = dispinterface
    ['{FF4EFE7E-35AC-48B5-ACDB-6753C402F0DB}']
    property PresType: WideString dispid 1;
    property Status: WideString dispid 2;
    property Show: WideString dispid 3;
    property Priority: Integer dispid 4;
    property ErrorString: WideString dispid 5;
    function XML: WideString; dispid 6;
    function IsSubscription: WordBool; dispid 7;
    property ToJid: WideString dispid 8;
    property FromJid: WideString dispid 9;
  end;

// *********************************************************************//
// Interface: IExodusAuth
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BFE1905C-3620-4C9D-B0C2-27EB456EF73B}
// *********************************************************************//
  IExodusAuth = interface(IDispatch)
    ['{BFE1905C-3620-4C9D-B0C2-27EB456EF73B}']
    procedure StartAuth; safecall;
    procedure CancelAuth; safecall;
    function StartRegistration: WordBool; safecall;
    procedure CancelRegistration; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusAuthDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BFE1905C-3620-4C9D-B0C2-27EB456EF73B}
// *********************************************************************//
  IExodusAuthDisp = dispinterface
    ['{BFE1905C-3620-4C9D-B0C2-27EB456EF73B}']
    procedure StartAuth; dispid 1;
    procedure CancelAuth; dispid 2;
    function StartRegistration: WordBool; dispid 3;
    procedure CancelRegistration; dispid 4;
  end;

// *********************************************************************//
// Interface: IExodusRosterGroup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FA63024E-3453-4551-8CA0-AFB78B2066AD}
// *********************************************************************//
  IExodusRosterGroup = interface(IDispatch)
    ['{FA63024E-3453-4551-8CA0-AFB78B2066AD}']
    function Get_Action: WideString; safecall;
    procedure Set_Action(const value: WideString); safecall;
    function Get_KeepEmpty: WordBool; safecall;
    procedure Set_KeepEmpty(value: WordBool); safecall;
    function Get_SortPriority: Integer; safecall;
    procedure Set_SortPriority(value: Integer); safecall;
    function Get_ShowPresence: WordBool; safecall;
    procedure Set_ShowPresence(value: WordBool); safecall;
    function Get_DragTarget: WordBool; safecall;
    procedure Set_DragTarget(value: WordBool); safecall;
    function Get_DragSource: WordBool; safecall;
    procedure Set_DragSource(value: WordBool); safecall;
    function Get_AutoExpand: WordBool; safecall;
    procedure Set_AutoExpand(value: WordBool); safecall;
    function GetText: WideString; safecall;
    procedure AddJid(const JID: WideString); safecall;
    procedure RemoveJid(const JID: WideString); safecall;
    function InGroup(const JID: WideString): WordBool; safecall;
    function IsEmpty: WordBool; safecall;
    function GetGroup(const group_name: WideString): IExodusRosterGroup; safecall;
    procedure AddGroup(const child: IExodusRosterGroup); safecall;
    procedure RemoveGroup(const child: IExodusRosterGroup); safecall;
    function GetRosterItems(Online: WordBool): OleVariant; safecall;
    function Get_NestLevel: Integer; safecall;
    function Get_Online: Integer; safecall;
    function Get_Total: Integer; safecall;
    function Get_FullName: WideString; safecall;
    function Get_Parent: IExodusRosterGroup; safecall;
    function Parts(index: Integer): WideString; safecall;
    procedure FireChange; safecall;
    property Action: WideString read Get_Action write Set_Action;
    property KeepEmpty: WordBool read Get_KeepEmpty write Set_KeepEmpty;
    property SortPriority: Integer read Get_SortPriority write Set_SortPriority;
    property ShowPresence: WordBool read Get_ShowPresence write Set_ShowPresence;
    property DragTarget: WordBool read Get_DragTarget write Set_DragTarget;
    property DragSource: WordBool read Get_DragSource write Set_DragSource;
    property AutoExpand: WordBool read Get_AutoExpand write Set_AutoExpand;
    property NestLevel: Integer read Get_NestLevel;
    property Online: Integer read Get_Online;
    property Total: Integer read Get_Total;
    property FullName: WideString read Get_FullName;
    property Parent: IExodusRosterGroup read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterGroupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FA63024E-3453-4551-8CA0-AFB78B2066AD}
// *********************************************************************//
  IExodusRosterGroupDisp = dispinterface
    ['{FA63024E-3453-4551-8CA0-AFB78B2066AD}']
    property Action: WideString dispid 201;
    property KeepEmpty: WordBool dispid 202;
    property SortPriority: Integer dispid 203;
    property ShowPresence: WordBool dispid 204;
    property DragTarget: WordBool dispid 205;
    property DragSource: WordBool dispid 206;
    property AutoExpand: WordBool dispid 207;
    function GetText: WideString; dispid 208;
    procedure AddJid(const JID: WideString); dispid 209;
    procedure RemoveJid(const JID: WideString); dispid 210;
    function InGroup(const JID: WideString): WordBool; dispid 211;
    function IsEmpty: WordBool; dispid 212;
    function GetGroup(const group_name: WideString): IExodusRosterGroup; dispid 213;
    procedure AddGroup(const child: IExodusRosterGroup); dispid 214;
    procedure RemoveGroup(const child: IExodusRosterGroup); dispid 215;
    function GetRosterItems(Online: WordBool): OleVariant; dispid 216;
    property NestLevel: Integer readonly dispid 217;
    property Online: Integer readonly dispid 218;
    property Total: Integer readonly dispid 219;
    property FullName: WideString readonly dispid 220;
    property Parent: IExodusRosterGroup readonly dispid 221;
    function Parts(index: Integer): WideString; dispid 222;
    procedure FireChange; dispid 223;
  end;

// *********************************************************************//
// Interface: IExodusRosterImages
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4AAF511-D144-42E7-B108-8A196D4BD115}
// *********************************************************************//
  IExodusRosterImages = interface(IDispatch)
    ['{F4AAF511-D144-42E7-B108-8A196D4BD115}']
    function AddImageFilename(const ID: WideString; const filename: WideString): Integer; safecall;
    function AddImageBase64(const ID: WideString; const base64: WideString): Integer; safecall;
    function AddImageResource(const ID: WideString; const libName: WideString; 
                              const resName: WideString): Integer; safecall;
    procedure Remove(const ID: WideString); safecall;
    function Find(const ID: WideString): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterImagesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4AAF511-D144-42E7-B108-8A196D4BD115}
// *********************************************************************//
  IExodusRosterImagesDisp = dispinterface
    ['{F4AAF511-D144-42E7-B108-8A196D4BD115}']
    function AddImageFilename(const ID: WideString; const filename: WideString): Integer; dispid 201;
    function AddImageBase64(const ID: WideString; const base64: WideString): Integer; dispid 202;
    function AddImageResource(const ID: WideString; const libName: WideString; 
                              const resName: WideString): Integer; dispid 203;
    procedure Remove(const ID: WideString); dispid 204;
    function Find(const ID: WideString): Integer; dispid 205;
  end;

// *********************************************************************//
// Interface: IExodusEntityCache
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6759BFE4-C72D-42E3-86A3-1F343E848933}
// *********************************************************************//
  IExodusEntityCache = interface(IDispatch)
    ['{6759BFE4-C72D-42E3-86A3-1F343E848933}']
    function GetByJid(const JID: WideString; const Node: WideString): IExodusEntity; safecall;
    function Fetch(const JID: WideString; const Node: WideString; items_limit: WordBool): IExodusEntity; safecall;
    function DiscoInfo(const JID: WideString; const Node: WideString; timeout: Integer): IExodusEntity; safecall;
    function DiscoItems(const JID: WideString; const Node: WideString; timeout: Integer): IExodusEntity; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusEntityCacheDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6759BFE4-C72D-42E3-86A3-1F343E848933}
// *********************************************************************//
  IExodusEntityCacheDisp = dispinterface
    ['{6759BFE4-C72D-42E3-86A3-1F343E848933}']
    function GetByJid(const JID: WideString; const Node: WideString): IExodusEntity; dispid 201;
    function Fetch(const JID: WideString; const Node: WideString; items_limit: WordBool): IExodusEntity; dispid 202;
    function DiscoInfo(const JID: WideString; const Node: WideString; timeout: Integer): IExodusEntity; dispid 203;
    function DiscoItems(const JID: WideString; const Node: WideString; timeout: Integer): IExodusEntity; dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusEntity
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}
// *********************************************************************//
  IExodusEntity = interface(IDispatch)
    ['{1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}']
    function HasFeature(const Feature: WideString): WordBool; safecall;
    function HasIdentity(const Category: WideString; const DiscoType: WideString): WordBool; safecall;
    function HasItems: WordBool; safecall;
    function HasInfo: WordBool; safecall;
    function Get_JID: WideString; safecall;
    function Get_Node: WideString; safecall;
    function Get_Category: WideString; safecall;
    function Get_DiscoType: WideString; safecall;
    function Get_Name: WideString; safecall;
    function Get_FeatureCount: Integer; safecall;
    function Get_Feature(index: Integer): WideString; safecall;
    function Get_ItemsCount: Integer; safecall;
    function Get_Item(index: Integer): IExodusEntity; safecall;
    property JID: WideString read Get_JID;
    property Node: WideString read Get_Node;
    property Category: WideString read Get_Category;
    property DiscoType: WideString read Get_DiscoType;
    property Name: WideString read Get_Name;
    property FeatureCount: Integer read Get_FeatureCount;
    property Feature[index: Integer]: WideString read Get_Feature;
    property ItemsCount: Integer read Get_ItemsCount;
    property Item[index: Integer]: IExodusEntity read Get_Item;
  end;

// *********************************************************************//
// DispIntf:  IExodusEntityDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}
// *********************************************************************//
  IExodusEntityDisp = dispinterface
    ['{1F8FF968-CB2A-480C-B8C2-1E34C493EC0F}']
    function HasFeature(const Feature: WideString): WordBool; dispid 201;
    function HasIdentity(const Category: WideString; const DiscoType: WideString): WordBool; dispid 202;
    function HasItems: WordBool; dispid 203;
    function HasInfo: WordBool; dispid 204;
    property JID: WideString readonly dispid 205;
    property Node: WideString readonly dispid 206;
    property Category: WideString readonly dispid 207;
    property DiscoType: WideString readonly dispid 208;
    property Name: WideString readonly dispid 209;
    property FeatureCount: Integer readonly dispid 210;
    property Feature[index: Integer]: WideString readonly dispid 211;
    property ItemsCount: Integer readonly dispid 212;
    property Item[index: Integer]: IExodusEntity readonly dispid 213;
  end;

// *********************************************************************//
// Interface: IExodusControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B992E91-DAD7-4CDC-9FD6-8007A63700E0}
// *********************************************************************//
  IExodusControl = interface(IDispatch)
    ['{0B992E91-DAD7-4CDC-9FD6-8007A63700E0}']
    function Get_ControlType: ExodusControlTypes; safecall;
    property ControlType: ExodusControlTypes read Get_ControlType;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B992E91-DAD7-4CDC-9FD6-8007A63700E0}
// *********************************************************************//
  IExodusControlDisp = dispinterface
    ['{0B992E91-DAD7-4CDC-9FD6-8007A63700E0}']
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlCheckBox
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {896CCC11-8929-4FEC-BC95-C96E5027C1F6}
// *********************************************************************//
  IExodusControlCheckBox = interface(IExodusControl)
    ['{896CCC11-8929-4FEC-BC95-C96E5027C1F6}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_AllowGrayed: Integer; safecall;
    procedure Set_AllowGrayed(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Checked: Integer; safecall;
    procedure Set_Checked(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_State: Integer; safecall;
    procedure Set_State(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property AllowGrayed: Integer read Get_AllowGrayed write Set_AllowGrayed;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Checked: Integer read Get_Checked write Set_Checked;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property State: Integer read Get_State write Set_State;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlCheckBoxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {896CCC11-8929-4FEC-BC95-C96E5027C1F6}
// *********************************************************************//
  IExodusControlCheckBoxDisp = dispinterface
    ['{896CCC11-8929-4FEC-BC95-C96E5027C1F6}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property TabStop: Integer dispid 12;
    property Alignment: Integer dispid 13;
    property AllowGrayed: Integer dispid 14;
    property BiDiMode: Integer dispid 15;
    property Caption: WideString dispid 16;
    property Checked: Integer dispid 17;
    property Color: Integer dispid 18;
    property Ctl3D: Integer dispid 19;
    property DragCursor: Integer dispid 20;
    property DragKind: Integer dispid 21;
    property DragMode: Integer dispid 22;
    property Enabled: Integer dispid 23;
    property Font: IExodusControlFont readonly dispid 24;
    property ParentBiDiMode: Integer dispid 25;
    property ParentColor: Integer dispid 26;
    property ParentCtl3D: Integer dispid 27;
    property ParentFont: Integer dispid 28;
    property ParentShowHint: Integer dispid 29;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 30;
    property ShowHint: Integer dispid 31;
    property State: Integer dispid 32;
    property TabOrder: Integer dispid 33;
    property Visible: Integer dispid 34;
    property WordWrap: Integer dispid 35;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlComboBox
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {16D21C8F-EF88-4E93-87C6-CD8F8C1EE7F7}
// *********************************************************************//
  IExodusControlComboBox = interface(IExodusControl)
    ['{16D21C8F-EF88-4E93-87C6-CD8F8C1EE7F7}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_AutoComplete: Integer; safecall;
    procedure Set_AutoComplete(value: Integer); safecall;
    function Get_AutoDropDown: Integer; safecall;
    procedure Set_AutoDropDown(value: Integer); safecall;
    function Get_AutoCloseUp: Integer; safecall;
    procedure Set_AutoCloseUp(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_CharCase: Integer; safecall;
    procedure Set_CharCase(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_DropDownCount: Integer; safecall;
    procedure Set_DropDownCount(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const value: WideString); safecall;
    function Get_ItemHeight: Integer; safecall;
    procedure Set_ItemHeight(value: Integer); safecall;
    function Get_ItemIndex: Integer; safecall;
    procedure Set_ItemIndex(value: Integer); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_Sorted: Integer; safecall;
    procedure Set_Sorted(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const value: WideString); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_Items(index: Integer): WideString; safecall;
    procedure Set_Items(index: Integer; const value: WideString); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property AutoComplete: Integer read Get_AutoComplete write Set_AutoComplete;
    property AutoDropDown: Integer read Get_AutoDropDown write Set_AutoDropDown;
    property AutoCloseUp: Integer read Get_AutoCloseUp write Set_AutoCloseUp;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelKind: Integer read Get_BevelKind write Set_BevelKind;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property Style: Integer read Get_Style write Set_Style;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property CharCase: Integer read Get_CharCase write Set_CharCase;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property DropDownCount: Integer read Get_DropDownCount write Set_DropDownCount;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ImeMode: Integer read Get_ImeMode write Set_ImeMode;
    property ImeName: WideString read Get_ImeName write Set_ImeName;
    property ItemHeight: Integer read Get_ItemHeight write Set_ItemHeight;
    property ItemIndex: Integer read Get_ItemIndex write Set_ItemIndex;
    property MaxLength: Integer read Get_MaxLength write Set_MaxLength;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property Sorted: Integer read Get_Sorted write Set_Sorted;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Text: WideString read Get_Text write Set_Text;
    property Visible: Integer read Get_Visible write Set_Visible;
    property Items[index: Integer]: WideString read Get_Items write Set_Items;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlComboBoxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {16D21C8F-EF88-4E93-87C6-CD8F8C1EE7F7}
// *********************************************************************//
  IExodusControlComboBoxDisp = dispinterface
    ['{16D21C8F-EF88-4E93-87C6-CD8F8C1EE7F7}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property AutoComplete: Integer dispid 12;
    property AutoDropDown: Integer dispid 13;
    property AutoCloseUp: Integer dispid 14;
    property BevelInner: Integer dispid 15;
    property BevelKind: Integer dispid 16;
    property BevelOuter: Integer dispid 17;
    property Style: Integer dispid 18;
    property BiDiMode: Integer dispid 19;
    property CharCase: Integer dispid 20;
    property Color: Integer dispid 21;
    property Ctl3D: Integer dispid 22;
    property DragCursor: Integer dispid 23;
    property DragKind: Integer dispid 24;
    property DragMode: Integer dispid 25;
    property DropDownCount: Integer dispid 26;
    property Enabled: Integer dispid 27;
    property Font: IExodusControlFont readonly dispid 28;
    property ImeMode: Integer dispid 29;
    property ImeName: WideString dispid 30;
    property ItemHeight: Integer dispid 31;
    property ItemIndex: Integer dispid 32;
    property MaxLength: Integer dispid 33;
    property ParentBiDiMode: Integer dispid 34;
    property ParentColor: Integer dispid 35;
    property ParentCtl3D: Integer dispid 36;
    property ParentFont: Integer dispid 37;
    property ParentShowHint: Integer dispid 38;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 39;
    property ShowHint: Integer dispid 40;
    property Sorted: Integer dispid 41;
    property TabOrder: Integer dispid 42;
    property TabStop: Integer dispid 43;
    property Text: WideString dispid 44;
    property Visible: Integer dispid 45;
    property Items[index: Integer]: WideString dispid 46;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlEdit
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A7B8A353-FF1E-4933-9A01-BD7B0FDC6F02}
// *********************************************************************//
  IExodusControlEdit = interface(IExodusControl)
    ['{A7B8A353-FF1E-4933-9A01-BD7B0FDC6F02}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_AutoSelect: Integer; safecall;
    procedure Set_AutoSelect(value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_CharCase: Integer; safecall;
    procedure Set_CharCase(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_HideSelection: Integer; safecall;
    procedure Set_HideSelection(value: Integer); safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const value: WideString); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(value: Integer); safecall;
    function Get_OEMConvert: Integer; safecall;
    procedure Set_OEMConvert(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PasswordChar: WideString; safecall;
    procedure Set_PasswordChar(const value: WideString); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ReadOnly: Integer; safecall;
    procedure Set_ReadOnly(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const value: WideString); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property AutoSelect: Integer read Get_AutoSelect write Set_AutoSelect;
    property AutoSize: Integer read Get_AutoSize write Set_AutoSize;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelKind: Integer read Get_BevelKind write Set_BevelKind;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property CharCase: Integer read Get_CharCase write Set_CharCase;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property HideSelection: Integer read Get_HideSelection write Set_HideSelection;
    property ImeMode: Integer read Get_ImeMode write Set_ImeMode;
    property ImeName: WideString read Get_ImeName write Set_ImeName;
    property MaxLength: Integer read Get_MaxLength write Set_MaxLength;
    property OEMConvert: Integer read Get_OEMConvert write Set_OEMConvert;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PasswordChar: WideString read Get_PasswordChar write Set_PasswordChar;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ReadOnly: Integer read Get_ReadOnly write Set_ReadOnly;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property Text: WideString read Get_Text write Set_Text;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlEditDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A7B8A353-FF1E-4933-9A01-BD7B0FDC6F02}
// *********************************************************************//
  IExodusControlEditDisp = dispinterface
    ['{A7B8A353-FF1E-4933-9A01-BD7B0FDC6F02}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property TabStop: Integer dispid 12;
    property AutoSelect: Integer dispid 13;
    property AutoSize: Integer dispid 14;
    property BevelInner: Integer dispid 15;
    property BevelKind: Integer dispid 16;
    property BevelOuter: Integer dispid 17;
    property BiDiMode: Integer dispid 18;
    property BorderStyle: Integer dispid 19;
    property CharCase: Integer dispid 20;
    property Color: Integer dispid 21;
    property Ctl3D: Integer dispid 22;
    property DragCursor: Integer dispid 23;
    property DragKind: Integer dispid 24;
    property DragMode: Integer dispid 25;
    property Enabled: Integer dispid 26;
    property Font: IExodusControlFont readonly dispid 27;
    property HideSelection: Integer dispid 28;
    property ImeMode: Integer dispid 29;
    property ImeName: WideString dispid 30;
    property MaxLength: Integer dispid 31;
    property OEMConvert: Integer dispid 32;
    property ParentBiDiMode: Integer dispid 33;
    property ParentColor: Integer dispid 34;
    property ParentCtl3D: Integer dispid 35;
    property ParentFont: Integer dispid 36;
    property ParentShowHint: Integer dispid 37;
    property PasswordChar: WideString dispid 38;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 39;
    property ReadOnly: Integer dispid 40;
    property ShowHint: Integer dispid 41;
    property TabOrder: Integer dispid 42;
    property Text: WideString dispid 43;
    property Visible: Integer dispid 44;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlFont
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D8297D0C-A316-4E9D-A89C-095CFAE51141}
// *********************************************************************//
  IExodusControlFont = interface(IExodusControl)
    ['{D8297D0C-A316-4E9D-A89C-095CFAE51141}']
    function Get_Charset: Integer; safecall;
    procedure Set_Charset(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Pitch: Integer; safecall;
    procedure Set_Pitch(value: Integer); safecall;
    function Get_Size: Integer; safecall;
    procedure Set_Size(value: Integer); safecall;
    property Charset: Integer read Get_Charset write Set_Charset;
    property Color: Integer read Get_Color write Set_Color;
    property Height: Integer read Get_Height write Set_Height;
    property Name: WideString read Get_Name write Set_Name;
    property Pitch: Integer read Get_Pitch write Set_Pitch;
    property Size: Integer read Get_Size write Set_Size;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlFontDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D8297D0C-A316-4E9D-A89C-095CFAE51141}
// *********************************************************************//
  IExodusControlFontDisp = dispinterface
    ['{D8297D0C-A316-4E9D-A89C-095CFAE51141}']
    property Charset: Integer dispid 1;
    property Color: Integer dispid 2;
    property Height: Integer dispid 3;
    property Name: WideString dispid 4;
    property Pitch: Integer dispid 5;
    property Size: Integer dispid 6;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlLabel
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F53704E6-83C2-4021-97A5-169BC58D9E03}
// *********************************************************************//
  IExodusControlLabel = interface(IExodusControl)
    ['{F53704E6-83C2-4021-97A5-169BC58D9E03}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowAccelChar: Integer; safecall;
    procedure Set_ShowAccelChar(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_Transparent: Integer; safecall;
    procedure Set_Transparent(value: Integer); safecall;
    function Get_Layout: Integer; safecall;
    procedure Set_Layout(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property Align: Integer read Get_Align write Set_Align;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property AutoSize: Integer read Get_AutoSize write Set_AutoSize;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Color: Integer read Get_Color write Set_Color;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowAccelChar: Integer read Get_ShowAccelChar write Set_ShowAccelChar;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property Transparent: Integer read Get_Transparent write Set_Transparent;
    property Layout: Integer read Get_Layout write Set_Layout;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlLabelDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F53704E6-83C2-4021-97A5-169BC58D9E03}
// *********************************************************************//
  IExodusControlLabelDisp = dispinterface
    ['{F53704E6-83C2-4021-97A5-169BC58D9E03}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property Align: Integer dispid 12;
    property Alignment: Integer dispid 13;
    property AutoSize: Integer dispid 14;
    property BiDiMode: Integer dispid 15;
    property Caption: WideString dispid 16;
    property Color: Integer dispid 17;
    property DragCursor: Integer dispid 18;
    property DragKind: Integer dispid 19;
    property DragMode: Integer dispid 20;
    property Enabled: Integer dispid 21;
    property Font: IExodusControlFont readonly dispid 22;
    property ParentBiDiMode: Integer dispid 23;
    property ParentColor: Integer dispid 24;
    property ParentFont: Integer dispid 25;
    property ParentShowHint: Integer dispid 26;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 27;
    property ShowAccelChar: Integer dispid 28;
    property ShowHint: Integer dispid 29;
    property Transparent: Integer dispid 30;
    property Layout: Integer dispid 31;
    property Visible: Integer dispid 32;
    property WordWrap: Integer dispid 33;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlListBox
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F34F969E-4BC2-4ADE-8648-A8F618FCC205}
// *********************************************************************//
  IExodusControlListBox = interface(IExodusControl)
    ['{F34F969E-4BC2-4ADE-8648-A8F618FCC205}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(value: Integer); safecall;
    function Get_AutoComplete: Integer; safecall;
    procedure Set_AutoComplete(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Columns: Integer; safecall;
    procedure Set_Columns(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_ExtendedSelect: Integer; safecall;
    procedure Set_ExtendedSelect(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const value: WideString); safecall;
    function Get_IntegralHeight: Integer; safecall;
    procedure Set_IntegralHeight(value: Integer); safecall;
    function Get_ItemHeight: Integer; safecall;
    procedure Set_ItemHeight(value: Integer); safecall;
    function Get_Items(index: Integer): WideString; safecall;
    procedure Set_Items(index: Integer; const value: WideString); safecall;
    function Get_MultiSelect: Integer; safecall;
    procedure Set_MultiSelect(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ScrollWidth: Integer; safecall;
    procedure Set_ScrollWidth(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_Sorted: Integer; safecall;
    procedure Set_Sorted(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabWidth: Integer; safecall;
    procedure Set_TabWidth(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Style: Integer read Get_Style write Set_Style;
    property AutoComplete: Integer read Get_AutoComplete write Set_AutoComplete;
    property Align: Integer read Get_Align write Set_Align;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelKind: Integer read Get_BevelKind write Set_BevelKind;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property Color: Integer read Get_Color write Set_Color;
    property Columns: Integer read Get_Columns write Set_Columns;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property ExtendedSelect: Integer read Get_ExtendedSelect write Set_ExtendedSelect;
    property Font: IExodusControlFont read Get_Font;
    property ImeMode: Integer read Get_ImeMode write Set_ImeMode;
    property ImeName: WideString read Get_ImeName write Set_ImeName;
    property IntegralHeight: Integer read Get_IntegralHeight write Set_IntegralHeight;
    property ItemHeight: Integer read Get_ItemHeight write Set_ItemHeight;
    property Items[index: Integer]: WideString read Get_Items write Set_Items;
    property MultiSelect: Integer read Get_MultiSelect write Set_MultiSelect;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ScrollWidth: Integer read Get_ScrollWidth write Set_ScrollWidth;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property Sorted: Integer read Get_Sorted write Set_Sorted;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabWidth: Integer read Get_TabWidth write Set_TabWidth;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlListBoxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F34F969E-4BC2-4ADE-8648-A8F618FCC205}
// *********************************************************************//
  IExodusControlListBoxDisp = dispinterface
    ['{F34F969E-4BC2-4ADE-8648-A8F618FCC205}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property TabStop: Integer dispid 12;
    property Style: Integer dispid 13;
    property AutoComplete: Integer dispid 14;
    property Align: Integer dispid 15;
    property BevelInner: Integer dispid 16;
    property BevelKind: Integer dispid 17;
    property BevelOuter: Integer dispid 18;
    property BiDiMode: Integer dispid 19;
    property BorderStyle: Integer dispid 20;
    property Color: Integer dispid 21;
    property Columns: Integer dispid 22;
    property Ctl3D: Integer dispid 23;
    property DragCursor: Integer dispid 24;
    property DragKind: Integer dispid 25;
    property DragMode: Integer dispid 26;
    property Enabled: Integer dispid 27;
    property ExtendedSelect: Integer dispid 28;
    property Font: IExodusControlFont readonly dispid 29;
    property ImeMode: Integer dispid 30;
    property ImeName: WideString dispid 31;
    property IntegralHeight: Integer dispid 32;
    property ItemHeight: Integer dispid 33;
    property Items[index: Integer]: WideString dispid 34;
    property MultiSelect: Integer dispid 35;
    property ParentBiDiMode: Integer dispid 36;
    property ParentColor: Integer dispid 37;
    property ParentCtl3D: Integer dispid 38;
    property ParentFont: Integer dispid 39;
    property ParentShowHint: Integer dispid 40;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 41;
    property ScrollWidth: Integer dispid 42;
    property ShowHint: Integer dispid 43;
    property Sorted: Integer dispid 44;
    property TabOrder: Integer dispid 45;
    property TabWidth: Integer dispid 46;
    property Visible: Integer dispid 47;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlMenuItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFBC071A-460A-4E1B-89EC-25B23460BA93}
// *********************************************************************//
  IExodusControlMenuItem = interface(IExodusControl)
    ['{EFBC071A-460A-4E1B-89EC-25B23460BA93}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_AutoCheck: Integer; safecall;
    procedure Set_AutoCheck(value: Integer); safecall;
    function Get_AutoHotkeys: Integer; safecall;
    procedure Set_AutoHotkeys(value: Integer); safecall;
    function Get_AutoLineReduction: Integer; safecall;
    procedure Set_AutoLineReduction(value: Integer); safecall;
    function Get_Break: Integer; safecall;
    procedure Set_Break(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Checked: Integer; safecall;
    procedure Set_Checked(value: Integer); safecall;
    function Get_Default: Integer; safecall;
    procedure Set_Default(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_GroupIndex: Integer; safecall;
    procedure Set_GroupIndex(value: Integer); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_ImageIndex: Integer; safecall;
    procedure Set_ImageIndex(value: Integer); safecall;
    function Get_RadioItem: Integer; safecall;
    procedure Set_RadioItem(value: Integer); safecall;
    function Get_ShortCut: Integer; safecall;
    procedure Set_ShortCut(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property AutoCheck: Integer read Get_AutoCheck write Set_AutoCheck;
    property AutoHotkeys: Integer read Get_AutoHotkeys write Set_AutoHotkeys;
    property AutoLineReduction: Integer read Get_AutoLineReduction write Set_AutoLineReduction;
    property Break: Integer read Get_Break write Set_Break;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Checked: Integer read Get_Checked write Set_Checked;
    property Default: Integer read Get_Default write Set_Default;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property GroupIndex: Integer read Get_GroupIndex write Set_GroupIndex;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property Hint: WideString read Get_Hint write Set_Hint;
    property ImageIndex: Integer read Get_ImageIndex write Set_ImageIndex;
    property RadioItem: Integer read Get_RadioItem write Set_RadioItem;
    property ShortCut: Integer read Get_ShortCut write Set_ShortCut;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlMenuItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFBC071A-460A-4E1B-89EC-25B23460BA93}
// *********************************************************************//
  IExodusControlMenuItemDisp = dispinterface
    ['{EFBC071A-460A-4E1B-89EC-25B23460BA93}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property AutoCheck: Integer dispid 3;
    property AutoHotkeys: Integer dispid 4;
    property AutoLineReduction: Integer dispid 5;
    property Break: Integer dispid 6;
    property Caption: WideString dispid 7;
    property Checked: Integer dispid 8;
    property Default: Integer dispid 9;
    property Enabled: Integer dispid 10;
    property GroupIndex: Integer dispid 11;
    property HelpContext: Integer dispid 12;
    property Hint: WideString dispid 13;
    property ImageIndex: Integer dispid 14;
    property RadioItem: Integer dispid 15;
    property ShortCut: Integer dispid 16;
    property Visible: Integer dispid 17;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlPanel
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA37BB99-F039-49B7-AB56-819E87B0472F}
// *********************************************************************//
  IExodusControlPanel = interface(IExodusControl)
    ['{BA37BB99-F039-49B7-AB56-819E87B0472F}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_BevelWidth: Integer; safecall;
    procedure Set_BevelWidth(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderWidth: Integer; safecall;
    procedure Set_BorderWidth(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_UseDockManager: Integer; safecall;
    procedure Set_UseDockManager(value: Integer); safecall;
    function Get_DockSite: Integer; safecall;
    procedure Set_DockSite(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_FullRepaint: Integer; safecall;
    procedure Set_FullRepaint(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_Locked: Integer; safecall;
    procedure Set_Locked(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentBackground: Integer; safecall;
    procedure Set_ParentBackground(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property Align: Integer read Get_Align write Set_Align;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property AutoSize: Integer read Get_AutoSize write Set_AutoSize;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property BevelWidth: Integer read Get_BevelWidth write Set_BevelWidth;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderWidth: Integer read Get_BorderWidth write Set_BorderWidth;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property UseDockManager: Integer read Get_UseDockManager write Set_UseDockManager;
    property DockSite: Integer read Get_DockSite write Set_DockSite;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property FullRepaint: Integer read Get_FullRepaint write Set_FullRepaint;
    property Font: IExodusControlFont read Get_Font;
    property Locked: Integer read Get_Locked write Set_Locked;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentBackground: Integer read Get_ParentBackground write Set_ParentBackground;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlPanelDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA37BB99-F039-49B7-AB56-819E87B0472F}
// *********************************************************************//
  IExodusControlPanelDisp = dispinterface
    ['{BA37BB99-F039-49B7-AB56-819E87B0472F}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property Align: Integer dispid 12;
    property Alignment: Integer dispid 13;
    property AutoSize: Integer dispid 14;
    property BevelInner: Integer dispid 15;
    property BevelOuter: Integer dispid 16;
    property BevelWidth: Integer dispid 17;
    property BiDiMode: Integer dispid 18;
    property BorderWidth: Integer dispid 19;
    property BorderStyle: Integer dispid 20;
    property Caption: WideString dispid 21;
    property Color: Integer dispid 22;
    property Ctl3D: Integer dispid 23;
    property UseDockManager: Integer dispid 24;
    property DockSite: Integer dispid 25;
    property DragCursor: Integer dispid 26;
    property DragKind: Integer dispid 27;
    property DragMode: Integer dispid 28;
    property Enabled: Integer dispid 29;
    property FullRepaint: Integer dispid 30;
    property Font: IExodusControlFont readonly dispid 31;
    property Locked: Integer dispid 32;
    property ParentBiDiMode: Integer dispid 33;
    property ParentBackground: Integer dispid 34;
    property ParentColor: Integer dispid 35;
    property ParentCtl3D: Integer dispid 36;
    property ParentFont: Integer dispid 37;
    property ParentShowHint: Integer dispid 38;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 39;
    property ShowHint: Integer dispid 40;
    property TabOrder: Integer dispid 41;
    property TabStop: Integer dispid 42;
    property Visible: Integer dispid 43;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlPopupMenu
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F80CD345-A91C-40C8-89CD-AD5BE532B9C2}
// *********************************************************************//
  IExodusControlPopupMenu = interface(IExodusControl)
    ['{F80CD345-A91C-40C8-89CD-AD5BE532B9C2}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_ItemsCount: Integer; safecall;
    function Get_Items(index: Integer): IExodusControlMenuItem; safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_AutoHotkeys: Integer; safecall;
    procedure Set_AutoHotkeys(value: Integer); safecall;
    function Get_AutoLineReduction: Integer; safecall;
    procedure Set_AutoLineReduction(value: Integer); safecall;
    function Get_AutoPopup: Integer; safecall;
    procedure Set_AutoPopup(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_OwnerDraw: Integer; safecall;
    procedure Set_OwnerDraw(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_TrackButton: Integer; safecall;
    procedure Set_TrackButton(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property ItemsCount: Integer read Get_ItemsCount;
    property Items[index: Integer]: IExodusControlMenuItem read Get_Items;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property AutoHotkeys: Integer read Get_AutoHotkeys write Set_AutoHotkeys;
    property AutoLineReduction: Integer read Get_AutoLineReduction write Set_AutoLineReduction;
    property AutoPopup: Integer read Get_AutoPopup write Set_AutoPopup;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property OwnerDraw: Integer read Get_OwnerDraw write Set_OwnerDraw;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property TrackButton: Integer read Get_TrackButton write Set_TrackButton;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlPopupMenuDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F80CD345-A91C-40C8-89CD-AD5BE532B9C2}
// *********************************************************************//
  IExodusControlPopupMenuDisp = dispinterface
    ['{F80CD345-A91C-40C8-89CD-AD5BE532B9C2}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property ItemsCount: Integer readonly dispid 3;
    property Items[index: Integer]: IExodusControlMenuItem readonly dispid 4;
    property Alignment: Integer dispid 5;
    property AutoHotkeys: Integer dispid 6;
    property AutoLineReduction: Integer dispid 7;
    property AutoPopup: Integer dispid 8;
    property BiDiMode: Integer dispid 9;
    property HelpContext: Integer dispid 10;
    property OwnerDraw: Integer dispid 11;
    property ParentBiDiMode: Integer dispid 12;
    property TrackButton: Integer dispid 13;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlRadioButton
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {87FAD954-03E1-4657-B58D-9947087EAAEC}
// *********************************************************************//
  IExodusControlRadioButton = interface(IExodusControl)
    ['{87FAD954-03E1-4657-B58D-9947087EAAEC}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Checked: Integer; safecall;
    procedure Set_Checked(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Checked: Integer read Get_Checked write Set_Checked;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlRadioButtonDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {87FAD954-03E1-4657-B58D-9947087EAAEC}
// *********************************************************************//
  IExodusControlRadioButtonDisp = dispinterface
    ['{87FAD954-03E1-4657-B58D-9947087EAAEC}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property Alignment: Integer dispid 12;
    property BiDiMode: Integer dispid 13;
    property Caption: WideString dispid 14;
    property Checked: Integer dispid 15;
    property Color: Integer dispid 16;
    property Ctl3D: Integer dispid 17;
    property DragCursor: Integer dispid 18;
    property DragKind: Integer dispid 19;
    property DragMode: Integer dispid 20;
    property Enabled: Integer dispid 21;
    property Font: IExodusControlFont readonly dispid 22;
    property ParentBiDiMode: Integer dispid 23;
    property ParentColor: Integer dispid 24;
    property ParentCtl3D: Integer dispid 25;
    property ParentFont: Integer dispid 26;
    property ParentShowHint: Integer dispid 27;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 28;
    property ShowHint: Integer dispid 29;
    property TabOrder: Integer dispid 30;
    property TabStop: Integer dispid 31;
    property Visible: Integer dispid 32;
    property WordWrap: Integer dispid 33;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlRichEdit
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3997314D-4068-43E7-ACEB-150FF196069C}
// *********************************************************************//
  IExodusControlRichEdit = interface(IExodusControl)
    ['{3997314D-4068-43E7-ACEB-150FF196069C}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(value: Integer); safecall;
    function Get_BevelWidth: Integer; safecall;
    procedure Set_BevelWidth(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_BorderWidth: Integer; safecall;
    procedure Set_BorderWidth(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_HideSelection: Integer; safecall;
    procedure Set_HideSelection(value: Integer); safecall;
    function Get_HideScrollBars: Integer; safecall;
    procedure Set_HideScrollBars(value: Integer); safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const value: WideString); safecall;
    function Get_LinesCount: Integer; safecall;
    function Get_Lines(index: Integer): WideString; safecall;
    procedure Set_Lines(index: Integer; const value: WideString); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PlainText: Integer; safecall;
    procedure Set_PlainText(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ReadOnly: Integer; safecall;
    procedure Set_ReadOnly(value: Integer); safecall;
    function Get_ScrollBars: Integer; safecall;
    procedure Set_ScrollBars(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WantTabs: Integer; safecall;
    procedure Set_WantTabs(value: Integer); safecall;
    function Get_WantReturns: Integer; safecall;
    procedure Set_WantReturns(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Align: Integer read Get_Align write Set_Align;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property BevelKind: Integer read Get_BevelKind write Set_BevelKind;
    property BevelWidth: Integer read Get_BevelWidth write Set_BevelWidth;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property BorderWidth: Integer read Get_BorderWidth write Set_BorderWidth;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property HideSelection: Integer read Get_HideSelection write Set_HideSelection;
    property HideScrollBars: Integer read Get_HideScrollBars write Set_HideScrollBars;
    property ImeMode: Integer read Get_ImeMode write Set_ImeMode;
    property ImeName: WideString read Get_ImeName write Set_ImeName;
    property LinesCount: Integer read Get_LinesCount;
    property Lines[index: Integer]: WideString read Get_Lines write Set_Lines;
    property MaxLength: Integer read Get_MaxLength write Set_MaxLength;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PlainText: Integer read Get_PlainText write Set_PlainText;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ReadOnly: Integer read Get_ReadOnly write Set_ReadOnly;
    property ScrollBars: Integer read Get_ScrollBars write Set_ScrollBars;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WantTabs: Integer read Get_WantTabs write Set_WantTabs;
    property WantReturns: Integer read Get_WantReturns write Set_WantReturns;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlRichEditDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3997314D-4068-43E7-ACEB-150FF196069C}
// *********************************************************************//
  IExodusControlRichEditDisp = dispinterface
    ['{3997314D-4068-43E7-ACEB-150FF196069C}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property TabStop: Integer dispid 12;
    property Align: Integer dispid 13;
    property Alignment: Integer dispid 14;
    property BevelInner: Integer dispid 15;
    property BevelOuter: Integer dispid 16;
    property BevelKind: Integer dispid 17;
    property BevelWidth: Integer dispid 18;
    property BiDiMode: Integer dispid 19;
    property BorderStyle: Integer dispid 20;
    property BorderWidth: Integer dispid 21;
    property Color: Integer dispid 22;
    property Ctl3D: Integer dispid 23;
    property DragCursor: Integer dispid 24;
    property DragKind: Integer dispid 25;
    property DragMode: Integer dispid 26;
    property Enabled: Integer dispid 27;
    property Font: IExodusControlFont readonly dispid 28;
    property HideSelection: Integer dispid 29;
    property HideScrollBars: Integer dispid 30;
    property ImeMode: Integer dispid 31;
    property ImeName: WideString dispid 32;
    property LinesCount: Integer readonly dispid 33;
    property Lines[index: Integer]: WideString dispid 34;
    property MaxLength: Integer dispid 35;
    property ParentBiDiMode: Integer dispid 36;
    property ParentColor: Integer dispid 37;
    property ParentCtl3D: Integer dispid 38;
    property ParentFont: Integer dispid 39;
    property ParentShowHint: Integer dispid 40;
    property PlainText: Integer dispid 41;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 42;
    property ReadOnly: Integer dispid 43;
    property ScrollBars: Integer dispid 44;
    property ShowHint: Integer dispid 45;
    property TabOrder: Integer dispid 46;
    property Visible: Integer dispid 47;
    property WantTabs: Integer dispid 48;
    property WantReturns: Integer dispid 49;
    property WordWrap: Integer dispid 50;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusControlButton
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0D41733E-3505-46FB-B199-C6046E1C84C7}
// *********************************************************************//
  IExodusControlButton = interface(IExodusControl)
    ['{0D41733E-3505-46FB-B199-C6046E1C84C7}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_Cancel: Integer; safecall;
    procedure Set_Cancel(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Default: Integer; safecall;
    procedure Set_Default(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ModalResult: Integer; safecall;
    procedure Set_ModalResult(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property Cancel: Integer read Get_Cancel write Set_Cancel;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Default: Integer read Get_Default write Set_Default;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ModalResult: Integer read Get_ModalResult write Set_ModalResult;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlButtonDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0D41733E-3505-46FB-B199-C6046E1C84C7}
// *********************************************************************//
  IExodusControlButtonDisp = dispinterface
    ['{0D41733E-3505-46FB-B199-C6046E1C84C7}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property BiDiMode: Integer dispid 12;
    property Cancel: Integer dispid 13;
    property Caption: WideString dispid 14;
    property Default: Integer dispid 15;
    property DragCursor: Integer dispid 16;
    property DragKind: Integer dispid 17;
    property DragMode: Integer dispid 18;
    property Enabled: Integer dispid 19;
    property Font: IExodusControlFont readonly dispid 20;
    property ModalResult: Integer dispid 21;
    property ParentBiDiMode: Integer dispid 22;
    property ParentFont: Integer dispid 23;
    property ParentShowHint: Integer dispid 24;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 25;
    property ShowHint: Integer dispid 26;
    property TabOrder: Integer dispid 27;
    property TabStop: Integer dispid 28;
    property Visible: Integer dispid 29;
    property WordWrap: Integer dispid 30;
    property ControlType: ExodusControlTypes readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusIQListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {57DFE494-4509-4972-A93B-6C7E6A9D6A59}
// *********************************************************************//
  IExodusIQListener = interface(IDispatch)
    ['{57DFE494-4509-4972-A93B-6C7E6A9D6A59}']
    procedure ProcessIQ(const handle: WideString; const XML: WideString); safecall;
    procedure TimeoutIQ(const handle: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusIQListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {57DFE494-4509-4972-A93B-6C7E6A9D6A59}
// *********************************************************************//
  IExodusIQListenerDisp = dispinterface
    ['{57DFE494-4509-4972-A93B-6C7E6A9D6A59}']
    procedure ProcessIQ(const handle: WideString; const XML: WideString); dispid 201;
    procedure TimeoutIQ(const handle: WideString); dispid 202;
  end;

// *********************************************************************//
// Interface: IExodusChat
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2639B6C-A7BB-4CCC-BD73-8C1EB197F9D3}
// *********************************************************************//
  IExodusChat = interface(IExodusChat2)
    ['{D2639B6C-A7BB-4CCC-BD73-8C1EB197F9D3}']
    function Get_JID: WideString; safecall;
    function AddContextMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    function Get_MsgOutText: WideString; safecall;
    function RegisterPlugin(const plugin: IExodusChatPlugin): Integer; safecall;
    function UnRegisterPlugin(ID: Integer): WordBool; safecall;
    function GetMagicInt(part: ChatParts): Integer; safecall;
    procedure RemoveContextMenu(const menuID: WideString); safecall;
    procedure AddMsgOut(const value: WideString); safecall;
    function AddMsgOutMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveMsgOutMenu(const menuID: WideString); safecall;
    procedure SendMessage(var Body: WideString; var Subject: WideString; var XML: WideString); safecall;
    function Get_CurrentThreadID: WideString; safecall;
    procedure DisplayMessage(const Body: WideString; const Subject: WideString; 
                             const from: WideString); safecall;
    procedure AddRoomUser(const JID: WideString; const Nickname: WideString); safecall;
    procedure RemoveRoomUser(const JID: WideString); safecall;
    function Get_CurrentNick: WideString; safecall;
    function GetControl(const Name: WideString): IExodusControl; safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    property JID: WideString read Get_JID;
    property MsgOutText: WideString read Get_MsgOutText;
    property CurrentThreadID: WideString read Get_CurrentThreadID;
    property CurrentNick: WideString read Get_CurrentNick;
    property Caption: WideString read Get_Caption write Set_Caption;
  end;

// *********************************************************************//
// DispIntf:  IExodusChatDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D2639B6C-A7BB-4CCC-BD73-8C1EB197F9D3}
// *********************************************************************//
  IExodusChatDisp = dispinterface
    ['{D2639B6C-A7BB-4CCC-BD73-8C1EB197F9D3}']
    property JID: WideString readonly dispid 1;
    function AddContextMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 2;
    property MsgOutText: WideString readonly dispid 4;
    function RegisterPlugin(const plugin: IExodusChatPlugin): Integer; dispid 3;
    function UnRegisterPlugin(ID: Integer): WordBool; dispid 5;
    function GetMagicInt(part: ChatParts): Integer; dispid 6;
    procedure RemoveContextMenu(const menuID: WideString); dispid 7;
    procedure AddMsgOut(const value: WideString); dispid 201;
    function AddMsgOutMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 202;
    procedure RemoveMsgOutMenu(const menuID: WideString); dispid 203;
    procedure SendMessage(var Body: WideString; var Subject: WideString; var XML: WideString); dispid 204;
    property CurrentThreadID: WideString readonly dispid 205;
    procedure DisplayMessage(const Body: WideString; const Subject: WideString; 
                             const from: WideString); dispid 206;
    procedure AddRoomUser(const JID: WideString; const Nickname: WideString); dispid 207;
    procedure RemoveRoomUser(const JID: WideString); dispid 208;
    property CurrentNick: WideString readonly dispid 209;
    function GetControl(const Name: WideString): IExodusControl; dispid 210;
    property Caption: WideString dispid 211;
    property DockToolbar: IExodusDockToolbar readonly dispid 212;
    property MsgOutToolbar: IExodusMsgOutToolbar readonly dispid 223;
  end;

// *********************************************************************//
// Interface: IExodusRoster
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}
// *********************************************************************//
  IExodusRoster = interface(IExodusRoster2)
    ['{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}']
    procedure Fetch; safecall;
    function Subscribe(const JabberID: WideString; const Nickname: WideString; 
                       const Group: WideString; Subscribe: WordBool): IExodusRosterItem; safecall;
    function Find(const JabberID: WideString): IExodusRosterItem; safecall;
    function Item(index: Integer): IExodusRosterItem; safecall;
    function Count: Integer; safecall;
    procedure RemoveItem(const Item: IExodusRosterItem); safecall;
    function AddGroup(const grp: WideString): IExodusRosterGroup; safecall;
    function GetGroup(const grp: WideString): IExodusRosterGroup; safecall;
    procedure RemoveGroup(const grp: IExodusRosterGroup); safecall;
    function Get_GroupsCount: Integer; safecall;
    function Groups(index: Integer): IExodusRosterGroup; safecall;
    function AddContextMenu(const ID: WideString): WordBool; safecall;
    procedure RemoveContextMenu(const ID: WideString); safecall;
    function AddContextMenuItem(const menuID: WideString; const Caption: WideString; 
                                const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveContextMenuItem(const menuID: WideString; const itemID: WideString); safecall;
    function AddItem(const JabberID: WideString): IExodusRosterItem; safecall;
    property GroupsCount: Integer read Get_GroupsCount;
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}
// *********************************************************************//
  IExodusRosterDisp = dispinterface
    ['{29B1C26F-2F13-47D8-91C4-A4A5AC43F4A9}']
    procedure Fetch; dispid 1;
    function Subscribe(const JabberID: WideString; const Nickname: WideString; 
                       const Group: WideString; Subscribe: WordBool): IExodusRosterItem; dispid 3;
    function Find(const JabberID: WideString): IExodusRosterItem; dispid 6;
    function Item(index: Integer): IExodusRosterItem; dispid 7;
    function Count: Integer; dispid 8;
    procedure RemoveItem(const Item: IExodusRosterItem); dispid 201;
    function AddGroup(const grp: WideString): IExodusRosterGroup; dispid 202;
    function GetGroup(const grp: WideString): IExodusRosterGroup; dispid 203;
    procedure RemoveGroup(const grp: IExodusRosterGroup); dispid 204;
    property GroupsCount: Integer readonly dispid 205;
    function Groups(index: Integer): IExodusRosterGroup; dispid 206;
    function AddContextMenu(const ID: WideString): WordBool; dispid 208;
    procedure RemoveContextMenu(const ID: WideString); dispid 209;
    function AddContextMenuItem(const menuID: WideString; const Caption: WideString; 
                                const MenuListener: IExodusMenuListener): WideString; dispid 210;
    procedure RemoveContextMenuItem(const menuID: WideString; const itemID: WideString); dispid 211;
    function AddItem(const JabberID: WideString): IExodusRosterItem; dispid 212;
    procedure EnableContextMenuItem(const menuID: WideString; const itemID: WideString; 
                                    enable: WordBool); dispid 213;
    procedure ShowContextMenuItem(const menuID: WideString; const itemID: WideString; Show: WordBool); dispid 214;
    procedure SetContextMenuItemCaption(const menuID: WideString; const itemID: WideString; 
                                        const Caption: WideString); dispid 215;
    function GetContextMenuItemCaption(const menuID: WideString; const itemID: WideString): WideString; dispid 216;
  end;

// *********************************************************************//
// Interface: IExodusRosterImages2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {21FC4FF3-2699-4ABC-BF6D-AF42FB407C25}
// *********************************************************************//
  IExodusRosterImages2 = interface(IDispatch)
    ['{21FC4FF3-2699-4ABC-BF6D-AF42FB407C25}']
    function GetImageById(const ID: WideString): WideString; safecall;
    function GetImageByIndex(index: Integer): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusRosterImages2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {21FC4FF3-2699-4ABC-BF6D-AF42FB407C25}
// *********************************************************************//
  IExodusRosterImages2Disp = dispinterface
    ['{21FC4FF3-2699-4ABC-BF6D-AF42FB407C25}']
    function GetImageById(const ID: WideString): WideString; dispid 206;
    function GetImageByIndex(index: Integer): WideString; dispid 207;
  end;

// *********************************************************************//
// Interface: IExodusControlBitBtn
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2954B16B-64BA-4441-A476-918CCCCA9B46}
// *********************************************************************//
  IExodusControlBitBtn = interface(IDispatch)
    ['{2954B16B-64BA-4441-A476-918CCCCA9B46}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_Cancel: Integer; safecall;
    procedure Set_Cancel(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Default: Integer; safecall;
    procedure Set_Default(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_ModalResult: Integer; safecall;
    procedure Set_ModalResult(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
    function Get_Kind: Integer; safecall;
    procedure Set_Kind(value: Integer); safecall;
    function Get_Layout: Integer; safecall;
    procedure Set_Layout(value: Integer); safecall;
    function Get_Margin: Integer; safecall;
    procedure Set_Margin(value: Integer); safecall;
    function Get_NumGlyphs: Integer; safecall;
    procedure Set_NumGlyphs(value: Integer); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(value: Integer); safecall;
    function Get_Spacing: Integer; safecall;
    procedure Set_Spacing(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property Cancel: Integer read Get_Cancel write Set_Cancel;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Default: Integer read Get_Default write Set_Default;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property ModalResult: Integer read Get_ModalResult write Set_ModalResult;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
    property Kind: Integer read Get_Kind write Set_Kind;
    property Layout: Integer read Get_Layout write Set_Layout;
    property Margin: Integer read Get_Margin write Set_Margin;
    property NumGlyphs: Integer read Get_NumGlyphs write Set_NumGlyphs;
    property Style: Integer read Get_Style write Set_Style;
    property Spacing: Integer read Get_Spacing write Set_Spacing;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlBitBtnDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2954B16B-64BA-4441-A476-918CCCCA9B46}
// *********************************************************************//
  IExodusControlBitBtnDisp = dispinterface
    ['{2954B16B-64BA-4441-A476-918CCCCA9B46}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property BiDiMode: Integer dispid 12;
    property Cancel: Integer dispid 13;
    property Caption: WideString dispid 14;
    property Default: Integer dispid 15;
    property DragCursor: Integer dispid 16;
    property DragKind: Integer dispid 17;
    property DragMode: Integer dispid 18;
    property Enabled: Integer dispid 19;
    property Font: IExodusControlFont readonly dispid 20;
    property ModalResult: Integer dispid 21;
    property ParentBiDiMode: Integer dispid 22;
    property ParentFont: Integer dispid 23;
    property ParentShowHint: Integer dispid 24;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 25;
    property ShowHint: Integer dispid 26;
    property TabOrder: Integer dispid 27;
    property TabStop: Integer dispid 28;
    property Visible: Integer dispid 29;
    property WordWrap: Integer dispid 30;
    property Kind: Integer dispid 31;
    property Layout: Integer dispid 32;
    property Margin: Integer dispid 33;
    property NumGlyphs: Integer dispid 34;
    property Style: Integer dispid 35;
    property Spacing: Integer dispid 36;
  end;

// *********************************************************************//
// Interface: IExodusControlMainMenu
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C3AE024-51A4-453F-91CB-B0EEBA175AED}
// *********************************************************************//
  IExodusControlMainMenu = interface(IDispatch)
    ['{0C3AE024-51A4-453F-91CB-B0EEBA175AED}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_ItemsCount: Integer; safecall;
    function Get_Items(index: Integer): IExodusControlMenuItem; safecall;
    function Get_AutoHotkeys: Integer; safecall;
    procedure Set_AutoHotkeys(value: Integer); safecall;
    function Get_AutoLineReduction: Integer; safecall;
    procedure Set_AutoLineReduction(value: Integer); safecall;
    function Get_AutoMerge: Integer; safecall;
    procedure Set_AutoMerge(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_OwnerDraw: Integer; safecall;
    procedure Set_OwnerDraw(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property ItemsCount: Integer read Get_ItemsCount;
    property Items[index: Integer]: IExodusControlMenuItem read Get_Items;
    property AutoHotkeys: Integer read Get_AutoHotkeys write Set_AutoHotkeys;
    property AutoLineReduction: Integer read Get_AutoLineReduction write Set_AutoLineReduction;
    property AutoMerge: Integer read Get_AutoMerge write Set_AutoMerge;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property OwnerDraw: Integer read Get_OwnerDraw write Set_OwnerDraw;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlMainMenuDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C3AE024-51A4-453F-91CB-B0EEBA175AED}
// *********************************************************************//
  IExodusControlMainMenuDisp = dispinterface
    ['{0C3AE024-51A4-453F-91CB-B0EEBA175AED}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property ItemsCount: Integer readonly dispid 3;
    property Items[index: Integer]: IExodusControlMenuItem readonly dispid 4;
    property AutoHotkeys: Integer dispid 5;
    property AutoLineReduction: Integer dispid 6;
    property AutoMerge: Integer dispid 7;
    property BiDiMode: Integer dispid 8;
    property OwnerDraw: Integer dispid 9;
    property ParentBiDiMode: Integer dispid 10;
  end;

// *********************************************************************//
// Interface: IExodusControlMemo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {62B921DE-13F1-4F63-BCA6-30EE3C66D454}
// *********************************************************************//
  IExodusControlMemo = interface(IDispatch)
    ['{62B921DE-13F1-4F63-BCA6-30EE3C66D454}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_Alignment: Integer; safecall;
    procedure Set_Alignment(value: Integer); safecall;
    function Get_BevelInner: Integer; safecall;
    procedure Set_BevelInner(value: Integer); safecall;
    function Get_BevelKind: Integer; safecall;
    procedure Set_BevelKind(value: Integer); safecall;
    function Get_BevelOuter: Integer; safecall;
    procedure Set_BevelOuter(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_HideSelection: Integer; safecall;
    procedure Set_HideSelection(value: Integer); safecall;
    function Get_ImeMode: Integer; safecall;
    procedure Set_ImeMode(value: Integer); safecall;
    function Get_ImeName: WideString; safecall;
    procedure Set_ImeName(const value: WideString); safecall;
    function Get_LinesCount: Integer; safecall;
    function Get_Lines(index: Integer): WideString; safecall;
    procedure Set_Lines(index: Integer; const value: WideString); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(value: Integer); safecall;
    function Get_OEMConvert: Integer; safecall;
    procedure Set_OEMConvert(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentColor: Integer; safecall;
    procedure Set_ParentColor(value: Integer); safecall;
    function Get_ParentCtl3D: Integer; safecall;
    procedure Set_ParentCtl3D(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ReadOnly: Integer; safecall;
    procedure Set_ReadOnly(value: Integer); safecall;
    function Get_ScrollBars: Integer; safecall;
    procedure Set_ScrollBars(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WantReturns: Integer; safecall;
    procedure Set_WantReturns(value: Integer); safecall;
    function Get_WantTabs: Integer; safecall;
    procedure Set_WantTabs(value: Integer); safecall;
    function Get_WordWrap: Integer; safecall;
    procedure Set_WordWrap(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property Align: Integer read Get_Align write Set_Align;
    property Alignment: Integer read Get_Alignment write Set_Alignment;
    property BevelInner: Integer read Get_BevelInner write Set_BevelInner;
    property BevelKind: Integer read Get_BevelKind write Set_BevelKind;
    property BevelOuter: Integer read Get_BevelOuter write Set_BevelOuter;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property Color: Integer read Get_Color write Set_Color;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property HideSelection: Integer read Get_HideSelection write Set_HideSelection;
    property ImeMode: Integer read Get_ImeMode write Set_ImeMode;
    property ImeName: WideString read Get_ImeName write Set_ImeName;
    property LinesCount: Integer read Get_LinesCount;
    property Lines[index: Integer]: WideString read Get_Lines write Set_Lines;
    property MaxLength: Integer read Get_MaxLength write Set_MaxLength;
    property OEMConvert: Integer read Get_OEMConvert write Set_OEMConvert;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentColor: Integer read Get_ParentColor write Set_ParentColor;
    property ParentCtl3D: Integer read Get_ParentCtl3D write Set_ParentCtl3D;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ReadOnly: Integer read Get_ReadOnly write Set_ReadOnly;
    property ScrollBars: Integer read Get_ScrollBars write Set_ScrollBars;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WantReturns: Integer read Get_WantReturns write Set_WantReturns;
    property WantTabs: Integer read Get_WantTabs write Set_WantTabs;
    property WordWrap: Integer read Get_WordWrap write Set_WordWrap;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlMemoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {62B921DE-13F1-4F63-BCA6-30EE3C66D454}
// *********************************************************************//
  IExodusControlMemoDisp = dispinterface
    ['{62B921DE-13F1-4F63-BCA6-30EE3C66D454}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property TabStop: Integer dispid 12;
    property Align: Integer dispid 13;
    property Alignment: Integer dispid 14;
    property BevelInner: Integer dispid 15;
    property BevelKind: Integer dispid 16;
    property BevelOuter: Integer dispid 17;
    property BiDiMode: Integer dispid 18;
    property BorderStyle: Integer dispid 19;
    property Color: Integer dispid 20;
    property Ctl3D: Integer dispid 21;
    property DragCursor: Integer dispid 22;
    property DragKind: Integer dispid 23;
    property DragMode: Integer dispid 24;
    property Enabled: Integer dispid 25;
    property Font: IExodusControlFont readonly dispid 26;
    property HideSelection: Integer dispid 27;
    property ImeMode: Integer dispid 28;
    property ImeName: WideString dispid 29;
    property LinesCount: Integer readonly dispid 30;
    property Lines[index: Integer]: WideString dispid 31;
    property MaxLength: Integer dispid 32;
    property OEMConvert: Integer dispid 33;
    property ParentBiDiMode: Integer dispid 34;
    property ParentColor: Integer dispid 35;
    property ParentCtl3D: Integer dispid 36;
    property ParentFont: Integer dispid 37;
    property ParentShowHint: Integer dispid 38;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 39;
    property ReadOnly: Integer dispid 40;
    property ScrollBars: Integer dispid 41;
    property ShowHint: Integer dispid 42;
    property TabOrder: Integer dispid 43;
    property Visible: Integer dispid 44;
    property WantReturns: Integer dispid 45;
    property WantTabs: Integer dispid 46;
    property WordWrap: Integer dispid 47;
  end;

// *********************************************************************//
// Interface: IExodusControlPageControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF41AC90-38C4-46FB-9A45-D7C26ECB2E1C}
// *********************************************************************//
  IExodusControlPageControl = interface(IDispatch)
    ['{AF41AC90-38C4-46FB-9A45-D7C26ECB2E1C}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_DockSite: Integer; safecall;
    procedure Set_DockSite(value: Integer); safecall;
    function Get_DragCursor: Integer; safecall;
    procedure Set_DragCursor(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_HotTrack: Integer; safecall;
    procedure Set_HotTrack(value: Integer); safecall;
    function Get_MultiLine: Integer; safecall;
    procedure Set_MultiLine(value: Integer); safecall;
    function Get_OwnerDraw: Integer; safecall;
    procedure Set_OwnerDraw(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_RaggedRight: Integer; safecall;
    procedure Set_RaggedRight(value: Integer); safecall;
    function Get_ScrollOpposite: Integer; safecall;
    procedure Set_ScrollOpposite(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(value: Integer); safecall;
    function Get_TabHeight: Integer; safecall;
    procedure Set_TabHeight(value: Integer); safecall;
    function Get_TabIndex: Integer; safecall;
    procedure Set_TabIndex(value: Integer); safecall;
    function Get_TabOrder: Integer; safecall;
    procedure Set_TabOrder(value: Integer); safecall;
    function Get_TabPosition: Integer; safecall;
    procedure Set_TabPosition(value: Integer); safecall;
    function Get_TabStop: Integer; safecall;
    procedure Set_TabStop(value: Integer); safecall;
    function Get_TabWidth: Integer; safecall;
    procedure Set_TabWidth(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property Align: Integer read Get_Align write Set_Align;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property DockSite: Integer read Get_DockSite write Set_DockSite;
    property DragCursor: Integer read Get_DragCursor write Set_DragCursor;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Font: IExodusControlFont read Get_Font;
    property HotTrack: Integer read Get_HotTrack write Set_HotTrack;
    property MultiLine: Integer read Get_MultiLine write Set_MultiLine;
    property OwnerDraw: Integer read Get_OwnerDraw write Set_OwnerDraw;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property RaggedRight: Integer read Get_RaggedRight write Set_RaggedRight;
    property ScrollOpposite: Integer read Get_ScrollOpposite write Set_ScrollOpposite;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property Style: Integer read Get_Style write Set_Style;
    property TabHeight: Integer read Get_TabHeight write Set_TabHeight;
    property TabIndex: Integer read Get_TabIndex write Set_TabIndex;
    property TabOrder: Integer read Get_TabOrder write Set_TabOrder;
    property TabPosition: Integer read Get_TabPosition write Set_TabPosition;
    property TabStop: Integer read Get_TabStop write Set_TabStop;
    property TabWidth: Integer read Get_TabWidth write Set_TabWidth;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlPageControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF41AC90-38C4-46FB-9A45-D7C26ECB2E1C}
// *********************************************************************//
  IExodusControlPageControlDisp = dispinterface
    ['{AF41AC90-38C4-46FB-9A45-D7C26ECB2E1C}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property Align: Integer dispid 12;
    property BiDiMode: Integer dispid 13;
    property DockSite: Integer dispid 14;
    property DragCursor: Integer dispid 15;
    property DragKind: Integer dispid 16;
    property DragMode: Integer dispid 17;
    property Enabled: Integer dispid 18;
    property Font: IExodusControlFont readonly dispid 19;
    property HotTrack: Integer dispid 20;
    property MultiLine: Integer dispid 21;
    property OwnerDraw: Integer dispid 22;
    property ParentBiDiMode: Integer dispid 23;
    property ParentFont: Integer dispid 24;
    property ParentShowHint: Integer dispid 25;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 26;
    property RaggedRight: Integer dispid 27;
    property ScrollOpposite: Integer dispid 28;
    property ShowHint: Integer dispid 29;
    property Style: Integer dispid 30;
    property TabHeight: Integer dispid 31;
    property TabIndex: Integer dispid 32;
    property TabOrder: Integer dispid 33;
    property TabPosition: Integer dispid 34;
    property TabStop: Integer dispid 35;
    property TabWidth: Integer dispid 36;
    property Visible: Integer dispid 37;
  end;

// *********************************************************************//
// Interface: IExodusControlSpeedButton
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0706359E-DD10-4D98-862B-7417E5E79DE8}
// *********************************************************************//
  IExodusControlSpeedButton = interface(IDispatch)
    ['{0706359E-DD10-4D98-862B-7417E5E79DE8}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_AllowAllUp: Integer; safecall;
    procedure Set_AllowAllUp(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_GroupIndex: Integer; safecall;
    procedure Set_GroupIndex(value: Integer); safecall;
    function Get_Down: Integer; safecall;
    procedure Set_Down(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_Flat: Integer; safecall;
    procedure Set_Flat(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_Layout: Integer; safecall;
    procedure Set_Layout(value: Integer); safecall;
    function Get_Margin: Integer; safecall;
    procedure Set_Margin(value: Integer); safecall;
    function Get_NumGlyphs: Integer; safecall;
    procedure Set_NumGlyphs(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_ParentShowHint: Integer; safecall;
    procedure Set_ParentShowHint(value: Integer); safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_Spacing: Integer; safecall;
    procedure Set_Spacing(value: Integer); safecall;
    function Get_Transparent: Integer; safecall;
    procedure Set_Transparent(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property AllowAllUp: Integer read Get_AllowAllUp write Set_AllowAllUp;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property GroupIndex: Integer read Get_GroupIndex write Set_GroupIndex;
    property Down: Integer read Get_Down write Set_Down;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property Flat: Integer read Get_Flat write Set_Flat;
    property Font: IExodusControlFont read Get_Font;
    property Layout: Integer read Get_Layout write Set_Layout;
    property Margin: Integer read Get_Margin write Set_Margin;
    property NumGlyphs: Integer read Get_NumGlyphs write Set_NumGlyphs;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property ParentShowHint: Integer read Get_ParentShowHint write Set_ParentShowHint;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property Spacing: Integer read Get_Spacing write Set_Spacing;
    property Transparent: Integer read Get_Transparent write Set_Transparent;
    property Visible: Integer read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlSpeedButtonDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0706359E-DD10-4D98-862B-7417E5E79DE8}
// *********************************************************************//
  IExodusControlSpeedButtonDisp = dispinterface
    ['{0706359E-DD10-4D98-862B-7417E5E79DE8}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property AllowAllUp: Integer dispid 12;
    property BiDiMode: Integer dispid 13;
    property GroupIndex: Integer dispid 14;
    property Down: Integer dispid 15;
    property Caption: WideString dispid 16;
    property Enabled: Integer dispid 17;
    property Flat: Integer dispid 18;
    property Font: IExodusControlFont readonly dispid 19;
    property Layout: Integer dispid 20;
    property Margin: Integer dispid 21;
    property NumGlyphs: Integer dispid 22;
    property ParentFont: Integer dispid 23;
    property ParentShowHint: Integer dispid 24;
    property ParentBiDiMode: Integer dispid 25;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 26;
    property ShowHint: Integer dispid 27;
    property Spacing: Integer dispid 28;
    property Transparent: Integer dispid 29;
    property Visible: Integer dispid 30;
  end;

// *********************************************************************//
// Interface: IExodusListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28132170-54E2-4BDD-A37D-BE115E68F044}
// *********************************************************************//
  IExodusListener = interface(IDispatch)
    ['{28132170-54E2-4BDD-A37D-BE115E68F044}']
    procedure ProcessEvent(const event: WideString; const XML: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28132170-54E2-4BDD-A37D-BE115E68F044}
// *********************************************************************//
  IExodusListenerDisp = dispinterface
    ['{28132170-54E2-4BDD-A37D-BE115E68F044}']
    procedure ProcessEvent(const event: WideString; const XML: WideString); dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusToolbar
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7949D67E-E287-4643-90DA-E6FE7EDEFA97}
// *********************************************************************//
  IExodusToolbar = interface(IDispatch)
    ['{7949D67E-E287-4643-90DA-E6FE7EDEFA97}']
    function Get_Count: Integer; safecall;
    function GetButton(index: Integer): IExodusToolbarButton; safecall;
    function AddButton(const ImageID: WideString): IExodusToolbarButton; safecall;
    function AddControl(const ID: WideString): IExodusToolbarControl; safecall;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IExodusToolbarDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7949D67E-E287-4643-90DA-E6FE7EDEFA97}
// *********************************************************************//
  IExodusToolbarDisp = dispinterface
    ['{7949D67E-E287-4643-90DA-E6FE7EDEFA97}']
    property Count: Integer readonly dispid 201;
    function GetButton(index: Integer): IExodusToolbarButton; dispid 202;
    function AddButton(const ImageID: WideString): IExodusToolbarButton; dispid 203;
    function AddControl(const ID: WideString): IExodusToolbarControl; dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusToolbarButton2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F9C4FDB-8567-45DF-9E92-8FFB7FA28A34}
// *********************************************************************//
  IExodusToolbarButton2 = interface(IDispatch)
    ['{7F9C4FDB-8567-45DF-9E92-8FFB7FA28A34}']
    function Get_Name: WideString; safecall;
    property Name: WideString read Get_Name;
  end;

// *********************************************************************//
// DispIntf:  IExodusToolbarButton2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F9C4FDB-8567-45DF-9E92-8FFB7FA28A34}
// *********************************************************************//
  IExodusToolbarButton2Disp = dispinterface
    ['{7F9C4FDB-8567-45DF-9E92-8FFB7FA28A34}']
    property Name: WideString readonly dispid 206;
  end;

// *********************************************************************//
// Interface: IExodusToolbarController
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0EF5DFF4-B59B-4948-983B-3119F6A89E31}
// *********************************************************************//
  IExodusToolbarController = interface(IDispatch)
    ['{0EF5DFF4-B59B-4948-983B-3119F6A89E31}']
    function AddButton(const ImageID: WideString): IExodusToolbarButton; safecall;
    procedure RemoveButton(const button: WideString); safecall;
    function GetButton(index: Integer): IExodusToolbarButton; safecall;
    function AddControl(const ID: WideString): IExodusToolbarControl; safecall;
    function Get_ImageList: IExodusRosterImages; safecall;
    function Get_Count: Integer; safecall;
    function Get_Name: WideString; safecall;
    function Get_ControlCount: Integer; safecall;
    function GetControl(const Name: WideString): IExodusToolbarControl; safecall;
    procedure RemoveControl(const Name: WideString); safecall;
    property ImageList: IExodusRosterImages read Get_ImageList;
    property Count: Integer read Get_Count;
    property Name: WideString read Get_Name;
    property ControlCount: Integer read Get_ControlCount;
  end;

// *********************************************************************//
// DispIntf:  IExodusToolbarControllerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0EF5DFF4-B59B-4948-983B-3119F6A89E31}
// *********************************************************************//
  IExodusToolbarControllerDisp = dispinterface
    ['{0EF5DFF4-B59B-4948-983B-3119F6A89E31}']
    function AddButton(const ImageID: WideString): IExodusToolbarButton; dispid 201;
    procedure RemoveButton(const button: WideString); dispid 202;
    function GetButton(index: Integer): IExodusToolbarButton; dispid 203;
    function AddControl(const ID: WideString): IExodusToolbarControl; dispid 204;
    property ImageList: IExodusRosterImages readonly dispid 209;
    property Count: Integer readonly dispid 205;
    property Name: WideString readonly dispid 207;
    property ControlCount: Integer readonly dispid 206;
    function GetControl(const Name: WideString): IExodusToolbarControl; dispid 208;
    procedure RemoveControl(const Name: WideString); dispid 210;
  end;

// *********************************************************************//
// Interface: IExodusToolbarButton
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D4749AC4-6EBE-493B-844C-0455FF0A4A77}
// *********************************************************************//
  IExodusToolbarButton = interface(IExodusToolbarButton2)
    ['{D4749AC4-6EBE-493B-844C-0455FF0A4A77}']
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(value: WordBool); safecall;
    function Get_Tooltip: WideString; safecall;
    procedure Set_Tooltip(const value: WideString); safecall;
    function Get_ImageID: WideString; safecall;
    procedure Set_ImageID(const value: WideString); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(value: WordBool); safecall;
    function Get_MenuListener: IExodusMenuListener; safecall;
    procedure Set_MenuListener(const value: IExodusMenuListener); safecall;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Tooltip: WideString read Get_Tooltip write Set_Tooltip;
    property ImageID: WideString read Get_ImageID write Set_ImageID;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property MenuListener: IExodusMenuListener read Get_MenuListener write Set_MenuListener;
  end;

// *********************************************************************//
// DispIntf:  IExodusToolbarButtonDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D4749AC4-6EBE-493B-844C-0455FF0A4A77}
// *********************************************************************//
  IExodusToolbarButtonDisp = dispinterface
    ['{D4749AC4-6EBE-493B-844C-0455FF0A4A77}']
    property Visible: WordBool dispid 201;
    property Tooltip: WideString dispid 202;
    property ImageID: WideString dispid 203;
    property Enabled: WordBool dispid 204;
    property MenuListener: IExodusMenuListener dispid 205;
    property Name: WideString readonly dispid 206;
  end;

// *********************************************************************//
// Interface: IExodusControlForm
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F60EC05-634D-44B2-BECB-059169BA1459}
// *********************************************************************//
  IExodusControlForm = interface(IDispatch)
    ['{2F60EC05-634D-44B2-BECB-059169BA1459}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Tag: Integer; safecall;
    procedure Set_Tag(value: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(value: Integer); safecall;
    function Get_Cursor: Integer; safecall;
    procedure Set_Cursor(value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const value: WideString); safecall;
    function Get_HelpType: Integer; safecall;
    procedure Set_HelpType(value: Integer); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const value: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(value: Integer); safecall;
    function Get_Align: Integer; safecall;
    procedure Set_Align(value: Integer); safecall;
    function Get_AlphaBlend: Integer; safecall;
    procedure Set_AlphaBlend(value: Integer); safecall;
    function Get_AlphaBlendValue: Integer; safecall;
    procedure Set_AlphaBlendValue(value: Integer); safecall;
    function Get_AutoScroll: Integer; safecall;
    procedure Set_AutoScroll(value: Integer); safecall;
    function Get_AutoSize: Integer; safecall;
    procedure Set_AutoSize(value: Integer); safecall;
    function Get_BiDiMode: Integer; safecall;
    procedure Set_BiDiMode(value: Integer); safecall;
    function Get_BorderStyle: Integer; safecall;
    procedure Set_BorderStyle(value: Integer); safecall;
    function Get_BorderWidth: Integer; safecall;
    procedure Set_BorderWidth(value: Integer); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_ClientHeight: Integer; safecall;
    procedure Set_ClientHeight(value: Integer); safecall;
    function Get_ClientWidth: Integer; safecall;
    procedure Set_ClientWidth(value: Integer); safecall;
    function Get_Color: Integer; safecall;
    procedure Set_Color(value: Integer); safecall;
    function Get_TransparentColor: Integer; safecall;
    procedure Set_TransparentColor(value: Integer); safecall;
    function Get_TransparentColorValue: Integer; safecall;
    procedure Set_TransparentColorValue(value: Integer); safecall;
    function Get_Ctl3D: Integer; safecall;
    procedure Set_Ctl3D(value: Integer); safecall;
    function Get_UseDockManager: Integer; safecall;
    procedure Set_UseDockManager(value: Integer); safecall;
    function Get_DefaultMonitor: Integer; safecall;
    procedure Set_DefaultMonitor(value: Integer); safecall;
    function Get_DockSite: Integer; safecall;
    procedure Set_DockSite(value: Integer); safecall;
    function Get_DragKind: Integer; safecall;
    procedure Set_DragKind(value: Integer); safecall;
    function Get_DragMode: Integer; safecall;
    procedure Set_DragMode(value: Integer); safecall;
    function Get_Enabled: Integer; safecall;
    procedure Set_Enabled(value: Integer); safecall;
    function Get_ParentFont: Integer; safecall;
    procedure Set_ParentFont(value: Integer); safecall;
    function Get_Font: IExodusControlFont; safecall;
    function Get_FormStyle: Integer; safecall;
    procedure Set_FormStyle(value: Integer); safecall;
    function Get_HelpFile: WideString; safecall;
    procedure Set_HelpFile(const value: WideString); safecall;
    function Get_KeyPreview: Integer; safecall;
    procedure Set_KeyPreview(value: Integer); safecall;
    function Get_Menu: IExodusControlMainMenu; safecall;
    function Get_OldCreateOrder: Integer; safecall;
    procedure Set_OldCreateOrder(value: Integer); safecall;
    function Get_ObjectMenuItemCount: Integer; safecall;
    function Get_ObjectMenuItem(index: Integer): IExodusControlMenuItem; safecall;
    function Get_ParentBiDiMode: Integer; safecall;
    procedure Set_ParentBiDiMode(value: Integer); safecall;
    function Get_PixelsPerInch: Integer; safecall;
    procedure Set_PixelsPerInch(value: Integer); safecall;
    function Get_PopupMenu: IExodusControlPopupMenu; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(value: Integer); safecall;
    function Get_PrintScale: Integer; safecall;
    procedure Set_PrintScale(value: Integer); safecall;
    function Get_Scaled: Integer; safecall;
    procedure Set_Scaled(value: Integer); safecall;
    function Get_ScreenSnap: Integer; safecall;
    procedure Set_ScreenSnap(value: Integer); safecall;
    function Get_ShowHint: Integer; safecall;
    procedure Set_ShowHint(value: Integer); safecall;
    function Get_SnapBuffer: Integer; safecall;
    procedure Set_SnapBuffer(value: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(value: Integer); safecall;
    function Get_WindowState: Integer; safecall;
    procedure Set_WindowState(value: Integer); safecall;
    function Get_WindowMenuCount: Integer; safecall;
    function Get_WindowMenu(index: Integer): IExodusControlMenuItem; safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Tag: Integer read Get_Tag write Set_Tag;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property Cursor: Integer read Get_Cursor write Set_Cursor;
    property Hint: WideString read Get_Hint write Set_Hint;
    property HelpType: Integer read Get_HelpType write Set_HelpType;
    property HelpKeyword: WideString read Get_HelpKeyword write Set_HelpKeyword;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property Align: Integer read Get_Align write Set_Align;
    property AlphaBlend: Integer read Get_AlphaBlend write Set_AlphaBlend;
    property AlphaBlendValue: Integer read Get_AlphaBlendValue write Set_AlphaBlendValue;
    property AutoScroll: Integer read Get_AutoScroll write Set_AutoScroll;
    property AutoSize: Integer read Get_AutoSize write Set_AutoSize;
    property BiDiMode: Integer read Get_BiDiMode write Set_BiDiMode;
    property BorderStyle: Integer read Get_BorderStyle write Set_BorderStyle;
    property BorderWidth: Integer read Get_BorderWidth write Set_BorderWidth;
    property Caption: WideString read Get_Caption write Set_Caption;
    property ClientHeight: Integer read Get_ClientHeight write Set_ClientHeight;
    property ClientWidth: Integer read Get_ClientWidth write Set_ClientWidth;
    property Color: Integer read Get_Color write Set_Color;
    property TransparentColor: Integer read Get_TransparentColor write Set_TransparentColor;
    property TransparentColorValue: Integer read Get_TransparentColorValue write Set_TransparentColorValue;
    property Ctl3D: Integer read Get_Ctl3D write Set_Ctl3D;
    property UseDockManager: Integer read Get_UseDockManager write Set_UseDockManager;
    property DefaultMonitor: Integer read Get_DefaultMonitor write Set_DefaultMonitor;
    property DockSite: Integer read Get_DockSite write Set_DockSite;
    property DragKind: Integer read Get_DragKind write Set_DragKind;
    property DragMode: Integer read Get_DragMode write Set_DragMode;
    property Enabled: Integer read Get_Enabled write Set_Enabled;
    property ParentFont: Integer read Get_ParentFont write Set_ParentFont;
    property Font: IExodusControlFont read Get_Font;
    property FormStyle: Integer read Get_FormStyle write Set_FormStyle;
    property HelpFile: WideString read Get_HelpFile write Set_HelpFile;
    property KeyPreview: Integer read Get_KeyPreview write Set_KeyPreview;
    property Menu: IExodusControlMainMenu read Get_Menu;
    property OldCreateOrder: Integer read Get_OldCreateOrder write Set_OldCreateOrder;
    property ObjectMenuItemCount: Integer read Get_ObjectMenuItemCount;
    property ObjectMenuItem[index: Integer]: IExodusControlMenuItem read Get_ObjectMenuItem;
    property ParentBiDiMode: Integer read Get_ParentBiDiMode write Set_ParentBiDiMode;
    property PixelsPerInch: Integer read Get_PixelsPerInch write Set_PixelsPerInch;
    property PopupMenu: IExodusControlPopupMenu read Get_PopupMenu;
    property Position: Integer read Get_Position write Set_Position;
    property PrintScale: Integer read Get_PrintScale write Set_PrintScale;
    property Scaled: Integer read Get_Scaled write Set_Scaled;
    property ScreenSnap: Integer read Get_ScreenSnap write Set_ScreenSnap;
    property ShowHint: Integer read Get_ShowHint write Set_ShowHint;
    property SnapBuffer: Integer read Get_SnapBuffer write Set_SnapBuffer;
    property Visible: Integer read Get_Visible write Set_Visible;
    property WindowState: Integer read Get_WindowState write Set_WindowState;
    property WindowMenuCount: Integer read Get_WindowMenuCount;
    property WindowMenu[index: Integer]: IExodusControlMenuItem read Get_WindowMenu;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlFormDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F60EC05-634D-44B2-BECB-059169BA1459}
// *********************************************************************//
  IExodusControlFormDisp = dispinterface
    ['{2F60EC05-634D-44B2-BECB-059169BA1459}']
    property Name: WideString dispid 1;
    property Tag: Integer dispid 2;
    property Left: Integer dispid 3;
    property Top: Integer dispid 4;
    property Width: Integer dispid 5;
    property Height: Integer dispid 6;
    property Cursor: Integer dispid 7;
    property Hint: WideString dispid 8;
    property HelpType: Integer dispid 9;
    property HelpKeyword: WideString dispid 10;
    property HelpContext: Integer dispid 11;
    property Align: Integer dispid 12;
    property AlphaBlend: Integer dispid 13;
    property AlphaBlendValue: Integer dispid 14;
    property AutoScroll: Integer dispid 15;
    property AutoSize: Integer dispid 16;
    property BiDiMode: Integer dispid 17;
    property BorderStyle: Integer dispid 18;
    property BorderWidth: Integer dispid 19;
    property Caption: WideString dispid 20;
    property ClientHeight: Integer dispid 21;
    property ClientWidth: Integer dispid 22;
    property Color: Integer dispid 23;
    property TransparentColor: Integer dispid 24;
    property TransparentColorValue: Integer dispid 25;
    property Ctl3D: Integer dispid 26;
    property UseDockManager: Integer dispid 27;
    property DefaultMonitor: Integer dispid 28;
    property DockSite: Integer dispid 29;
    property DragKind: Integer dispid 30;
    property DragMode: Integer dispid 31;
    property Enabled: Integer dispid 32;
    property ParentFont: Integer dispid 33;
    property Font: IExodusControlFont readonly dispid 34;
    property FormStyle: Integer dispid 35;
    property HelpFile: WideString dispid 36;
    property KeyPreview: Integer dispid 37;
    property Menu: IExodusControlMainMenu readonly dispid 38;
    property OldCreateOrder: Integer dispid 39;
    property ObjectMenuItemCount: Integer readonly dispid 40;
    property ObjectMenuItem[index: Integer]: IExodusControlMenuItem readonly dispid 41;
    property ParentBiDiMode: Integer dispid 42;
    property PixelsPerInch: Integer dispid 43;
    property PopupMenu: IExodusControlPopupMenu readonly dispid 44;
    property Position: Integer dispid 45;
    property PrintScale: Integer dispid 46;
    property Scaled: Integer dispid 47;
    property ScreenSnap: Integer dispid 48;
    property ShowHint: Integer dispid 49;
    property SnapBuffer: Integer dispid 50;
    property Visible: Integer dispid 51;
    property WindowState: Integer dispid 52;
    property WindowMenuCount: Integer readonly dispid 53;
    property WindowMenu[index: Integer]: IExodusControlMenuItem readonly dispid 54;
  end;

// *********************************************************************//
// Interface: IExodusLogger
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {35542007-5701-4190-AB28-D25EB186CC19}
// *********************************************************************//
  IExodusLogger = interface(IDispatch)
    ['{35542007-5701-4190-AB28-D25EB186CC19}']
    procedure LogMessage(const msg: IExodusLogMsg); safecall;
    procedure Show(const JID: WideString); safecall;
    procedure Clear(const JID: WideString); safecall;
    procedure Purge; safecall;
    procedure GetDays(const JID: WideString; month: Integer; year: Integer; 
                      const listener: IExodusLogListener); safecall;
    procedure GetMessages(const JID: WideString; chunkSize: Integer; day: Integer; month: Integer; 
                          year: Integer; Cancel: WordBool; const listener: IExodusLogListener); safecall;
    function Get_IsDateEnabled: WordBool; safecall;
    property IsDateEnabled: WordBool read Get_IsDateEnabled;
  end;

// *********************************************************************//
// DispIntf:  IExodusLoggerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {35542007-5701-4190-AB28-D25EB186CC19}
// *********************************************************************//
  IExodusLoggerDisp = dispinterface
    ['{35542007-5701-4190-AB28-D25EB186CC19}']
    procedure LogMessage(const msg: IExodusLogMsg); dispid 201;
    procedure Show(const JID: WideString); dispid 202;
    procedure Clear(const JID: WideString); dispid 203;
    procedure Purge; dispid 204;
    procedure GetDays(const JID: WideString; month: Integer; year: Integer; 
                      const listener: IExodusLogListener); dispid 205;
    procedure GetMessages(const JID: WideString; chunkSize: Integer; day: Integer; month: Integer; 
                          year: Integer; Cancel: WordBool; const listener: IExodusLogListener); dispid 206;
    property IsDateEnabled: WordBool readonly dispid 207;
  end;

// *********************************************************************//
// Interface: IExodusLogMsg
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2E945876-C2E5-4A24-98B4-0E38BD65D431}
// *********************************************************************//
  IExodusLogMsg = interface(IDispatch)
    ['{2E945876-C2E5-4A24-98B4-0E38BD65D431}']
    function Get_ToJid: WideString; safecall;
    function Get_FromJid: WideString; safecall;
    function Get_MsgType: WideString; safecall;
    function Get_ID: WideString; safecall;
    function Get_Nick: WideString; safecall;
    function Get_Body: WideString; safecall;
    function Get_Thread: WideString; safecall;
    function Get_Subject: WideString; safecall;
    function Get_Timestamp: WideString; safecall;
    function Get_Direction: WideString; safecall;
    function Get_XML: WideString; safecall;
    property ToJid: WideString read Get_ToJid;
    property FromJid: WideString read Get_FromJid;
    property MsgType: WideString read Get_MsgType;
    property ID: WideString read Get_ID;
    property Nick: WideString read Get_Nick;
    property Body: WideString read Get_Body;
    property Thread: WideString read Get_Thread;
    property Subject: WideString read Get_Subject;
    property Timestamp: WideString read Get_Timestamp;
    property Direction: WideString read Get_Direction;
    property XML: WideString read Get_XML;
  end;

// *********************************************************************//
// DispIntf:  IExodusLogMsgDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2E945876-C2E5-4A24-98B4-0E38BD65D431}
// *********************************************************************//
  IExodusLogMsgDisp = dispinterface
    ['{2E945876-C2E5-4A24-98B4-0E38BD65D431}']
    property ToJid: WideString readonly dispid 201;
    property FromJid: WideString readonly dispid 202;
    property MsgType: WideString readonly dispid 203;
    property ID: WideString readonly dispid 204;
    property Nick: WideString readonly dispid 205;
    property Body: WideString readonly dispid 206;
    property Thread: WideString readonly dispid 207;
    property Subject: WideString readonly dispid 208;
    property Timestamp: WideString readonly dispid 209;
    property Direction: WideString readonly dispid 210;
    property XML: WideString readonly dispid 211;
  end;

// *********************************************************************//
// Interface: IExodusLogListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6D58A577-6BC4-4B1C-B5F8-759B94136B0A}
// *********************************************************************//
  IExodusLogListener = interface(IDispatch)
    ['{6D58A577-6BC4-4B1C-B5F8-759B94136B0A}']
    procedure ProcessMessages(Count: Integer; messages: PSafeArray); safecall;
    procedure EndMessages(day: Integer; month: Integer; year: Integer); safecall;
    procedure Error(day: Integer; month: Integer; year: Integer); safecall;
    procedure ProcessDates(Count: Integer; dates: PSafeArray); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusLogListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6D58A577-6BC4-4B1C-B5F8-759B94136B0A}
// *********************************************************************//
  IExodusLogListenerDisp = dispinterface
    ['{6D58A577-6BC4-4B1C-B5F8-759B94136B0A}']
    procedure ProcessMessages(Count: Integer; messages: {??PSafeArray}OleVariant); dispid 201;
    procedure EndMessages(day: Integer; month: Integer; year: Integer); dispid 202;
    procedure Error(day: Integer; month: Integer; year: Integer); dispid 203;
    procedure ProcessDates(Count: Integer; dates: {??PSafeArray}OleVariant); dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}
// *********************************************************************//
  IExodusPlugin = interface(IDispatch)
    ['{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}']
    procedure Startup(const exodusController: IExodusController); safecall;
    procedure Shutdown; safecall;
    procedure Process(const xpath: WideString; const event: WideString; const XML: WideString); safecall;
    procedure NewChat(const JID: WideString; const chat: IExodusChat); safecall;
    procedure NewRoom(const JID: WideString; const room: IExodusChat); safecall;
    function NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                   const xTags: WideString): WideString; safecall;
    procedure Configure; safecall;
    procedure NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}
// *********************************************************************//
  IExodusPluginDisp = dispinterface
    ['{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}']
    procedure Startup(const exodusController: IExodusController); dispid 1;
    procedure Shutdown; dispid 2;
    procedure Process(const xpath: WideString; const event: WideString; const XML: WideString); dispid 3;
    procedure NewChat(const JID: WideString; const chat: IExodusChat); dispid 4;
    procedure NewRoom(const JID: WideString; const room: IExodusChat); dispid 5;
    function NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                   const xTags: WideString): WideString; dispid 8;
    procedure Configure; dispid 12;
    procedure NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat); dispid 203;
  end;

// *********************************************************************//
// Interface: IExodusBookmarkManager
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E40D85F3-9E0D-4368-89D0-C4298315CD30}
// *********************************************************************//
  IExodusBookmarkManager = interface(IDispatch)
    ['{E40D85F3-9E0D-4368-89D0-C4298315CD30}']
    procedure AddBookmark(const JabberID: WideString; const bmName: WideString; 
                          const Nickname: WideString; AutoJoin: WordBool; 
                          UseRegisteredNick: WordBool); safecall;
    procedure RemoveBookmark(const JabberID: WideString); safecall;
    function FindBookmark(const JabberID: WideString): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusBookmarkManagerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E40D85F3-9E0D-4368-89D0-C4298315CD30}
// *********************************************************************//
  IExodusBookmarkManagerDisp = dispinterface
    ['{E40D85F3-9E0D-4368-89D0-C4298315CD30}']
    procedure AddBookmark(const JabberID: WideString; const bmName: WideString; 
                          const Nickname: WideString; AutoJoin: WordBool; 
                          UseRegisteredNick: WordBool); dispid 201;
    procedure RemoveBookmark(const JabberID: WideString); dispid 202;
    function FindBookmark(const JabberID: WideString): WideString; dispid 203;
  end;

// *********************************************************************//
// Interface: IExodusToolbarControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B35EACB5-C3DC-473E-8C4C-EFA175DF4CAB}
// *********************************************************************//
  IExodusToolbarControl = interface(IDispatch)
    ['{B35EACB5-C3DC-473E-8C4C-EFA175DF4CAB}']
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(value: WordBool); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(value: WordBool); safecall;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
  end;

// *********************************************************************//
// DispIntf:  IExodusToolbarControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B35EACB5-C3DC-473E-8C4C-EFA175DF4CAB}
// *********************************************************************//
  IExodusToolbarControlDisp = dispinterface
    ['{B35EACB5-C3DC-473E-8C4C-EFA175DF4CAB}']
    property Visible: WordBool dispid 201;
    property Enabled: WordBool dispid 202;
  end;

// *********************************************************************//
// Interface: IExodusPlugin2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7A57094D-B8DE-4EE8-82B4-B5412F5C2F14}
// *********************************************************************//
  IExodusPlugin2 = interface(IExodusPlugin)
    ['{7A57094D-B8DE-4EE8-82B4-B5412F5C2F14}']
    procedure NewIncomingIM(const JID: WideString; const instantMsg: IExodusChat); safecall;
    function Get_Configurable: WordBool; safecall;
    property Configurable: WordBool read Get_Configurable;
  end;

// *********************************************************************//
// DispIntf:  IExodusPlugin2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7A57094D-B8DE-4EE8-82B4-B5412F5C2F14}
// *********************************************************************//
  IExodusPlugin2Disp = dispinterface
    ['{7A57094D-B8DE-4EE8-82B4-B5412F5C2F14}']
    procedure NewIncomingIM(const JID: WideString; const instantMsg: IExodusChat); dispid 301;
    property Configurable: WordBool readonly dispid 303;
    procedure Startup(const exodusController: IExodusController); dispid 1;
    procedure Shutdown; dispid 2;
    procedure Process(const xpath: WideString; const event: WideString; const XML: WideString); dispid 3;
    procedure NewChat(const JID: WideString; const chat: IExodusChat); dispid 4;
    procedure NewRoom(const JID: WideString; const room: IExodusChat); dispid 5;
    function NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                   const xTags: WideString): WideString; dispid 8;
    procedure Configure; dispid 12;
    procedure NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat); dispid 203;
  end;

// *********************************************************************//
// Interface: IExodusMsgOutToolbar
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {51F924C1-A27E-4396-8EF3-B5035D325CF7}
// *********************************************************************//
  IExodusMsgOutToolbar = interface(IDispatch)
    ['{51F924C1-A27E-4396-8EF3-B5035D325CF7}']
    function Get_Count: Integer; safecall;
    function GetButton(index: Integer): IExodusToolbarButton; safecall;
    function AddButton(const ImageID: WideString): IExodusToolbarButton; safecall;
    function AddControl(const ID: WideString): IExodusToolbarControl; safecall;
    procedure RemoveButton(const button: WideString); safecall;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IExodusMsgOutToolbarDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {51F924C1-A27E-4396-8EF3-B5035D325CF7}
// *********************************************************************//
  IExodusMsgOutToolbarDisp = dispinterface
    ['{51F924C1-A27E-4396-8EF3-B5035D325CF7}']
    property Count: Integer readonly dispid 201;
    function GetButton(index: Integer): IExodusToolbarButton; dispid 202;
    function AddButton(const ImageID: WideString): IExodusToolbarButton; dispid 203;
    function AddControl(const ID: WideString): IExodusToolbarControl; dispid 204;
    procedure RemoveButton(const button: WideString); dispid 205;
  end;

// *********************************************************************//
// Interface: IExodusDockToolbar
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F7427F75-8915-4AC2-823F-1C897BE9B9A6}
// *********************************************************************//
  IExodusDockToolbar = interface(IDispatch)
    ['{F7427F75-8915-4AC2-823F-1C897BE9B9A6}']
    function Get_Count: Integer; safecall;
    function GetButton(index: Integer): ExodusToolbarButton; safecall;
    function AddButton(const ImageID: WideString): ExodusToolbarButton; safecall;
    function AddControl(const ID: WideString): ExodusToolbarControl; safecall;
    procedure RemoveButton(const button: WideString); safecall;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IExodusDockToolbarDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F7427F75-8915-4AC2-823F-1C897BE9B9A6}
// *********************************************************************//
  IExodusDockToolbarDisp = dispinterface
    ['{F7427F75-8915-4AC2-823F-1C897BE9B9A6}']
    property Count: Integer readonly dispid 201;
    function GetButton(index: Integer): ExodusToolbarButton; dispid 202;
    function AddButton(const ImageID: WideString): ExodusToolbarButton; dispid 203;
    function AddControl(const ID: WideString): ExodusToolbarControl; dispid 204;
    procedure RemoveButton(const button: WideString); dispid 205;
  end;

// *********************************************************************//
// Interface: IExodusAXWindow
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8F2F3430-1E7E-4FA7-B65D-A25B48EFE880}
// *********************************************************************//
  IExodusAXWindow = interface(IDispatch)
    ['{8F2F3430-1E7E-4FA7-B65D-A25B48EFE880}']
    function Get_AXControl: IUnknown; safecall;
    procedure Close; safecall;
    procedure BringToFront; safecall;
    function Get_UnreadMsgCount: Integer; safecall;
    procedure Set_UnreadMsgCount(value: Integer); safecall;
    procedure Dock; safecall;
    procedure Float; safecall;
    function Get_LastActivityTime: TDateTime; safecall;
    procedure Set_LastActivityTime(value: TDateTime); safecall;
    function Get_PriorityFlag: WordBool; safecall;
    procedure Set_PriorityFlag(value: WordBool); safecall;
    function Get_WindowType: WideString; safecall;
    procedure Set_WindowType(const value: WideString); safecall;
    function Get_ImageIndex: Integer; safecall;
    procedure Set_ImageIndex(value: Integer); safecall;
    procedure RegisterCallback(const callback: IExodusAXWindowCallback); safecall;
    procedure UnRegisterCallback; safecall;
    procedure FlashWindow; safecall;
    function Get_DockToolbar: IExodusDockToolbar; safecall;
    function NewTitleBarActiveX(const ActiveX_GUID: WideString): IUnknown; safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_TabTooltip: WideString; safecall;
    procedure Set_TabTooltip(const value: WideString); safecall;
    property AXControl: IUnknown read Get_AXControl;
    property UnreadMsgCount: Integer read Get_UnreadMsgCount write Set_UnreadMsgCount;
    property LastActivityTime: TDateTime read Get_LastActivityTime write Set_LastActivityTime;
    property PriorityFlag: WordBool read Get_PriorityFlag write Set_PriorityFlag;
    property WindowType: WideString read Get_WindowType write Set_WindowType;
    property ImageIndex: Integer read Get_ImageIndex write Set_ImageIndex;
    property DockToolbar: IExodusDockToolbar read Get_DockToolbar;
    property Caption: WideString read Get_Caption write Set_Caption;
    property TabTooltip: WideString read Get_TabTooltip write Set_TabTooltip;
  end;

// *********************************************************************//
// DispIntf:  IExodusAXWindowDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8F2F3430-1E7E-4FA7-B65D-A25B48EFE880}
// *********************************************************************//
  IExodusAXWindowDisp = dispinterface
    ['{8F2F3430-1E7E-4FA7-B65D-A25B48EFE880}']
    property AXControl: IUnknown readonly dispid 201;
    procedure Close; dispid 202;
    procedure BringToFront; dispid 203;
    property UnreadMsgCount: Integer dispid 204;
    procedure Dock; dispid 205;
    procedure Float; dispid 206;
    property LastActivityTime: TDateTime dispid 207;
    property PriorityFlag: WordBool dispid 208;
    property WindowType: WideString dispid 209;
    property ImageIndex: Integer dispid 210;
    procedure RegisterCallback(const callback: IExodusAXWindowCallback); dispid 211;
    procedure UnRegisterCallback; dispid 212;
    procedure FlashWindow; dispid 213;
    property DockToolbar: IExodusDockToolbar readonly dispid 214;
    function NewTitleBarActiveX(const ActiveX_GUID: WideString): IUnknown; dispid 215;
    property Caption: WideString dispid 216;
    property TabTooltip: WideString dispid 217;
  end;

// *********************************************************************//
// Interface: IExodusItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {44410CB8-2AD7-4D58-8067-2E795EB28E60}
// *********************************************************************//
  IExodusItem = interface(IDispatch)
    ['{44410CB8-2AD7-4D58-8067-2E795EB28E60}']
    function Get_Text: WideString; safecall;
    procedure Set_Text(const value: WideString); safecall;
    function Get_Type_: WideString; safecall;
    function Get_ExtendedText: WideString; safecall;
    procedure Set_ExtendedText(const value: WideString); safecall;
    function Get_UID: WideString; safecall;
    procedure Set_UID(const value: WideString); safecall;
    function Get_Active: WordBool; safecall;
    procedure Set_Active(value: WordBool); safecall;
    function Get_ImageIndex: Integer; safecall;
    procedure Set_ImageIndex(value: Integer); safecall;
    function Get_GroupCount: Integer; safecall;
    function Get_Group(index: Integer): WideString; safecall;
    function Get_PropertyCount: Integer; safecall;
    procedure AddProperty(const propertyName: WideString; const propertyValue: WideString); safecall;
    procedure RemoveProperty(const Property_: WideString); safecall;
    procedure AddGroup(const Group: WideString); safecall;
    procedure RemoveGroup(const Group: WideString); safecall;
    procedure ClearProperties; safecall;
    procedure ClearGroups; safecall;
    procedure RenameGroup(const OldGroup: WideString; const NewGroup: WideString); safecall;
    procedure MoveGroup(const GroupFrom: WideString; const GroupTo: WideString); safecall;
    procedure CopyGroup(const GroupTo: WideString); safecall;
    function Get_Property_(index: Integer): WideString; safecall;
    procedure Set_Property_(index: Integer; const value: WideString); safecall;
    function GroupsChanged(const Groups: WideString): WordBool; safecall;
    function BelongsToGroup(const Group: WideString): WordBool; safecall;
    function Get_value(const Name: WideString): WideString; safecall;
    procedure Set_value(const Name: WideString; const value: WideString); safecall;
    function Get_IsVisible: WordBool; safecall;
    procedure Set_IsVisible(value: WordBool); safecall;
    function Get_propertyName(index: Integer): WideString; safecall;
    property Text: WideString read Get_Text write Set_Text;
    property Type_: WideString read Get_Type_;
    property ExtendedText: WideString read Get_ExtendedText write Set_ExtendedText;
    property UID: WideString read Get_UID write Set_UID;
    property Active: WordBool read Get_Active write Set_Active;
    property ImageIndex: Integer read Get_ImageIndex write Set_ImageIndex;
    property GroupCount: Integer read Get_GroupCount;
    property Group[index: Integer]: WideString read Get_Group;
    property PropertyCount: Integer read Get_PropertyCount;
    property Property_[index: Integer]: WideString read Get_Property_ write Set_Property_;
    property value[const Name: WideString]: WideString read Get_value write Set_value;
    property IsVisible: WordBool read Get_IsVisible write Set_IsVisible;
    property propertyName[index: Integer]: WideString read Get_propertyName;
  end;

// *********************************************************************//
// DispIntf:  IExodusItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {44410CB8-2AD7-4D58-8067-2E795EB28E60}
// *********************************************************************//
  IExodusItemDisp = dispinterface
    ['{44410CB8-2AD7-4D58-8067-2E795EB28E60}']
    property Text: WideString dispid 202;
    property Type_: WideString readonly dispid 203;
    property ExtendedText: WideString dispid 204;
    property UID: WideString dispid 201;
    property Active: WordBool dispid 205;
    property ImageIndex: Integer dispid 206;
    property GroupCount: Integer readonly dispid 207;
    property Group[index: Integer]: WideString readonly dispid 208;
    property PropertyCount: Integer readonly dispid 209;
    procedure AddProperty(const propertyName: WideString; const propertyValue: WideString); dispid 211;
    procedure RemoveProperty(const Property_: WideString); dispid 212;
    procedure AddGroup(const Group: WideString); dispid 213;
    procedure RemoveGroup(const Group: WideString); dispid 214;
    procedure ClearProperties; dispid 215;
    procedure ClearGroups; dispid 216;
    procedure RenameGroup(const OldGroup: WideString; const NewGroup: WideString); dispid 217;
    procedure MoveGroup(const GroupFrom: WideString; const GroupTo: WideString); dispid 218;
    procedure CopyGroup(const GroupTo: WideString); dispid 219;
    property Property_[index: Integer]: WideString dispid 222;
    function GroupsChanged(const Groups: WideString): WordBool; dispid 223;
    function BelongsToGroup(const Group: WideString): WordBool; dispid 224;
    property value[const Name: WideString]: WideString dispid 225;
    property IsVisible: WordBool dispid 226;
    property propertyName[index: Integer]: WideString readonly dispid 210;
  end;

// *********************************************************************//
// Interface: IExodusItemController
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7E8D248E-F7E3-4541-A72A-37E1E87C4C93}
// *********************************************************************//
  IExodusItemController = interface(IDispatch)
    ['{7E8D248E-F7E3-4541-A72A-37E1E87C4C93}']
    function Get_ItemsCount: Integer; safecall;
    function Get_GroupsCount: Integer; safecall;
    function Get_Item(index: Integer): IExodusItem; safecall;
    procedure RemoveItem(const UID: WideString); safecall;
    function AddItemByUid(const UID: WideString; const ItemType: WideString; 
                          const cb: IExodusItemCallback): IExodusItem; safecall;
    procedure CopyItem(const UID: WideString; const Group: WideString); safecall;
    procedure MoveItem(const UID: WideString; const GroupFrom: WideString; const GroupTo: WideString); safecall;
    procedure RemoveGroupMoveContent(const Group: WideString; const GroupTo: WideString); safecall;
    procedure RemoveItemFromGroup(const UID: WideString; const Group: WideString); safecall;
    function GetGroupItems(const Group: WideString): IExodusItemList; safecall;
    function GetItem(const UID: WideString): IExodusItem; safecall;
    procedure ClearItems; safecall;
    function SaveGroups: WordBool; safecall;
    function GetGroups: OleVariant; safecall;
    function Get_GroupExists(const Group: WideString): WordBool; safecall;
    function Get_GroupExpanded(const Group: WideString): WordBool; safecall;
    procedure Set_GroupExpanded(const Group: WideString; value: WordBool); safecall;
    function GetItemsByType(const Type_: WideString): IExodusItemList; safecall;
    function Get_GroupsLoaded: WordBool; safecall;
    function AddGroup(const grp: WideString): IExodusItem; safecall;
    function AddHover(const ItemType: WideString; const GUID: WideString): IExodusHover; safecall;
    procedure RemoveHover(const ItemType: WideString); safecall;
    function GetHoverByType(const ItemType: WideString): IExodusHover; safecall;
    property ItemsCount: Integer read Get_ItemsCount;
    property GroupsCount: Integer read Get_GroupsCount;
    property Item[index: Integer]: IExodusItem read Get_Item;
    property GroupExists[const Group: WideString]: WordBool read Get_GroupExists;
    property GroupExpanded[const Group: WideString]: WordBool read Get_GroupExpanded write Set_GroupExpanded;
    property GroupsLoaded: WordBool read Get_GroupsLoaded;
  end;

// *********************************************************************//
// DispIntf:  IExodusItemControllerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7E8D248E-F7E3-4541-A72A-37E1E87C4C93}
// *********************************************************************//
  IExodusItemControllerDisp = dispinterface
    ['{7E8D248E-F7E3-4541-A72A-37E1E87C4C93}']
    property ItemsCount: Integer readonly dispid 202;
    property GroupsCount: Integer readonly dispid 203;
    property Item[index: Integer]: IExodusItem readonly dispid 205;
    procedure RemoveItem(const UID: WideString); dispid 206;
    function AddItemByUid(const UID: WideString; const ItemType: WideString; 
                          const cb: IExodusItemCallback): IExodusItem; dispid 201;
    procedure CopyItem(const UID: WideString; const Group: WideString); dispid 207;
    procedure MoveItem(const UID: WideString; const GroupFrom: WideString; const GroupTo: WideString); dispid 208;
    procedure RemoveGroupMoveContent(const Group: WideString; const GroupTo: WideString); dispid 209;
    procedure RemoveItemFromGroup(const UID: WideString; const Group: WideString); dispid 210;
    function GetGroupItems(const Group: WideString): IExodusItemList; dispid 211;
    function GetItem(const UID: WideString): IExodusItem; dispid 214;
    procedure ClearItems; dispid 217;
    function SaveGroups: WordBool; dispid 218;
    function GetGroups: OleVariant; dispid 219;
    property GroupExists[const Group: WideString]: WordBool readonly dispid 220;
    property GroupExpanded[const Group: WideString]: WordBool dispid 222;
    function GetItemsByType(const Type_: WideString): IExodusItemList; dispid 215;
    property GroupsLoaded: WordBool readonly dispid 221;
    function AddGroup(const grp: WideString): IExodusItem; dispid 204;
    function AddHover(const ItemType: WideString; const GUID: WideString): IExodusHover; dispid 212;
    procedure RemoveHover(const ItemType: WideString); dispid 213;
    function GetHoverByType(const ItemType: WideString): IExodusHover; dispid 216;
  end;

// *********************************************************************//
// Interface: IExodusTabController
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9717635B-FC59-40A9-8282-1902D897BF09}
// *********************************************************************//
  IExodusTabController = interface(IDispatch)
    ['{9717635B-FC59-40A9-8282-1902D897BF09}']
    function Get_TabCount: Integer; safecall;
    function AddTab(const ActiveX_GUID: WideString; const Name: WideString; const Type_: WideString): IExodusTab; safecall;
    procedure RemoveTab(index: Integer); safecall;
    function Get_Tab(index: Integer): IExodusTab; safecall;
    procedure Clear; safecall;
    function GetTabByUID(const UID: WideString): IExodusTab; safecall;
    function GetTabIndexByUID(const UID: WideString): Integer; safecall;
    function Get_VisibleTabCount: Integer; safecall;
    function GetTabIndexByName(const Name: WideString): Integer; safecall;
    function Get_VisibleTab(index: Integer): IExodusTab; safecall;
    function Get_ActiveTab: Integer; safecall;
    procedure Set_ActiveTab(index: Integer); safecall;
    property TabCount: Integer read Get_TabCount;
    property Tab[index: Integer]: IExodusTab read Get_Tab;
    property VisibleTabCount: Integer read Get_VisibleTabCount;
    property VisibleTab[index: Integer]: IExodusTab read Get_VisibleTab;
    property ActiveTab: Integer read Get_ActiveTab write Set_ActiveTab;
  end;

// *********************************************************************//
// DispIntf:  IExodusTabControllerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9717635B-FC59-40A9-8282-1902D897BF09}
// *********************************************************************//
  IExodusTabControllerDisp = dispinterface
    ['{9717635B-FC59-40A9-8282-1902D897BF09}']
    property TabCount: Integer readonly dispid 201;
    function AddTab(const ActiveX_GUID: WideString; const Name: WideString; const Type_: WideString): IExodusTab; dispid 202;
    procedure RemoveTab(index: Integer); dispid 203;
    property Tab[index: Integer]: IExodusTab readonly dispid 205;
    procedure Clear; dispid 206;
    function GetTabByUID(const UID: WideString): IExodusTab; dispid 207;
    function GetTabIndexByUID(const UID: WideString): Integer; dispid 208;
    property VisibleTabCount: Integer readonly dispid 209;
    function GetTabIndexByName(const Name: WideString): Integer; dispid 210;
    property VisibleTab[index: Integer]: IExodusTab readonly dispid 211;
    property ActiveTab: Integer dispid 212;
  end;

// *********************************************************************//
// Interface: IExodusTab
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F633716F-B315-4867-A1D0-6E177831FA27}
// *********************************************************************//
  IExodusTab = interface(IDispatch)
    ['{F633716F-B315-4867-A1D0-6E177831FA27}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const value: WideString); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const value: WideString); safecall;
    function Get_ImageIndex: Integer; safecall;
    procedure Set_ImageIndex(value: Integer); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Show; safecall;
    procedure Hide; safecall;
    function Get_UID: WideString; safecall;
    function Get_Height: Integer; safecall;
    function Get_Width: Integer; safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(const value: WideString); safecall;
    function Get_AXControl: OleVariant; safecall;
    function Get_TabIndex: Integer; safecall;
    function Get_PageIndex: Integer; safecall;
    function GetSelectedItems: IExodusItemList; safecall;
    function GetTree: Integer; safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Caption: WideString read Get_Caption write Set_Caption;
    property ImageIndex: Integer read Get_ImageIndex write Set_ImageIndex;
    property Visible: WordBool read Get_Visible;
    property UID: WideString read Get_UID;
    property Height: Integer read Get_Height;
    property Width: Integer read Get_Width;
    property Description: WideString read Get_Description write Set_Description;
    property AXControl: OleVariant read Get_AXControl;
    property TabIndex: Integer read Get_TabIndex;
    property PageIndex: Integer read Get_PageIndex;
  end;

// *********************************************************************//
// DispIntf:  IExodusTabDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F633716F-B315-4867-A1D0-6E177831FA27}
// *********************************************************************//
  IExodusTabDisp = dispinterface
    ['{F633716F-B315-4867-A1D0-6E177831FA27}']
    property Name: WideString dispid 201;
    property Caption: WideString dispid 202;
    property ImageIndex: Integer dispid 203;
    property Visible: WordBool readonly dispid 204;
    procedure Show; dispid 205;
    procedure Hide; dispid 206;
    property UID: WideString readonly dispid 209;
    property Height: Integer readonly dispid 210;
    property Width: Integer readonly dispid 211;
    property Description: WideString dispid 212;
    property AXControl: OleVariant readonly dispid 208;
    property TabIndex: Integer readonly dispid 213;
    property PageIndex: Integer readonly dispid 214;
    function GetSelectedItems: IExodusItemList; dispid 207;
    function GetTree: Integer; dispid 215;
  end;

// *********************************************************************//
// Interface: IExodusDataStore
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {20A21035-31DD-4F14-AF03-DB4B2DC26ACB}
// *********************************************************************//
  IExodusDataStore = interface(IDispatch)
    ['{20A21035-31DD-4F14-AF03-DB4B2DC26ACB}']
    function ExecSQL(const SQLStatement: WideString): WordBool; safecall;
    function GetTable(const SQLStatement: WideString; var ResultTable: IExodusDataTable): WordBool; safecall;
    function GetLastError: Integer; safecall;
    function GetErrorString(ErrorCode: Integer): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusDataStoreDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {20A21035-31DD-4F14-AF03-DB4B2DC26ACB}
// *********************************************************************//
  IExodusDataStoreDisp = dispinterface
    ['{20A21035-31DD-4F14-AF03-DB4B2DC26ACB}']
    function ExecSQL(const SQLStatement: WideString): WordBool; dispid 201;
    function GetTable(const SQLStatement: WideString; var ResultTable: IExodusDataTable): WordBool; dispid 202;
    function GetLastError: Integer; dispid 203;
    function GetErrorString(ErrorCode: Integer): WideString; dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusDataTable
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2BD06814-A066-4D2D-9236-FE33B9CB4759}
// *********************************************************************//
  IExodusDataTable = interface(IDispatch)
    ['{2BD06814-A066-4D2D-9236-FE33B9CB4759}']
    function Get_CurrentRow: Integer; safecall;
    function Get_ColCount: Integer; safecall;
    function Get_RowCount: Integer; safecall;
    function Get_IsEndOfTable: WordBool; safecall;
    function Get_IsBeginOfTable: WordBool; safecall;
    function IsFieldNULL(Field: Integer): WordBool; safecall;
    function GetFieldByName(const Name: WideString): WideString; safecall;
    function GetCol(Column: Integer): WideString; safecall;
    function GetField(Field: Integer): WideString; safecall;
    function NextRow: WordBool; safecall;
    function PrevRow: WordBool; safecall;
    function FirstRow: WordBool; safecall;
    function LastRow: WordBool; safecall;
    function GetFieldAsInt(Field: Integer): Integer; safecall;
    function GetFieldAsString(Field: Integer): WideString; safecall;
    function GetFieldAsDouble(Field: Integer): Double; safecall;
    function GetFieldIndex(const Field: WideString): Integer; safecall;
    function Get_SQLTableID: WideString; safecall;
    function GetFieldAsBoolean(Field: Integer): WordBool; safecall;
    function GetLastError: Integer; safecall;
    function GetErrorString(ErrorCode: Integer): WideString; safecall;
    property CurrentRow: Integer read Get_CurrentRow;
    property ColCount: Integer read Get_ColCount;
    property RowCount: Integer read Get_RowCount;
    property IsEndOfTable: WordBool read Get_IsEndOfTable;
    property IsBeginOfTable: WordBool read Get_IsBeginOfTable;
    property SQLTableID: WideString read Get_SQLTableID;
  end;

// *********************************************************************//
// DispIntf:  IExodusDataTableDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2BD06814-A066-4D2D-9236-FE33B9CB4759}
// *********************************************************************//
  IExodusDataTableDisp = dispinterface
    ['{2BD06814-A066-4D2D-9236-FE33B9CB4759}']
    property CurrentRow: Integer readonly dispid 201;
    property ColCount: Integer readonly dispid 202;
    property RowCount: Integer readonly dispid 203;
    property IsEndOfTable: WordBool readonly dispid 204;
    property IsBeginOfTable: WordBool readonly dispid 205;
    function IsFieldNULL(Field: Integer): WordBool; dispid 206;
    function GetFieldByName(const Name: WideString): WideString; dispid 207;
    function GetCol(Column: Integer): WideString; dispid 208;
    function GetField(Field: Integer): WideString; dispid 209;
    function NextRow: WordBool; dispid 210;
    function PrevRow: WordBool; dispid 211;
    function FirstRow: WordBool; dispid 212;
    function LastRow: WordBool; dispid 213;
    function GetFieldAsInt(Field: Integer): Integer; dispid 214;
    function GetFieldAsString(Field: Integer): WideString; dispid 215;
    function GetFieldAsDouble(Field: Integer): Double; dispid 216;
    function GetFieldIndex(const Field: WideString): Integer; dispid 217;
    property SQLTableID: WideString readonly dispid 218;
    function GetFieldAsBoolean(Field: Integer): WordBool; dispid 219;
    function GetLastError: Integer; dispid 220;
    function GetErrorString(ErrorCode: Integer): WideString; dispid 221;
  end;

// *********************************************************************//
// Interface: IExodusItemList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8247F310-6DAB-4D81-BF91-8D53C7A028D1}
// *********************************************************************//
  IExodusItemList = interface(IDispatch)
    ['{8247F310-6DAB-4D81-BF91-8D53C7A028D1}']
    function Get_Count: Integer; safecall;
    function Get_Item(index: Integer): IExodusItem; safecall;
    procedure Set_Item(index: Integer; const value: IExodusItem); safecall;
    procedure Add(const value: IExodusItem); safecall;
    procedure Delete(index: Integer); safecall;
    function IndexOf(const Item: IExodusItem): Integer; safecall;
    procedure Remove(const Item: IExodusItem); safecall;
    procedure Clear; safecall;
    function IndexOfUid(const UID: WideString): Integer; safecall;
    function CountOfType(const ItemType: WideString): Integer; safecall;
    property Count: Integer read Get_Count;
    property Item[index: Integer]: IExodusItem read Get_Item write Set_Item;
  end;

// *********************************************************************//
// DispIntf:  IExodusItemListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8247F310-6DAB-4D81-BF91-8D53C7A028D1}
// *********************************************************************//
  IExodusItemListDisp = dispinterface
    ['{8247F310-6DAB-4D81-BF91-8D53C7A028D1}']
    property Count: Integer readonly dispid 201;
    property Item[index: Integer]: IExodusItem dispid 202;
    procedure Add(const value: IExodusItem); dispid 203;
    procedure Delete(index: Integer); dispid 204;
    function IndexOf(const Item: IExodusItem): Integer; dispid 205;
    procedure Remove(const Item: IExodusItem); dispid 206;
    procedure Clear; dispid 207;
    function IndexOfUid(const UID: WideString): Integer; dispid 208;
    function CountOfType(const ItemType: WideString): Integer; dispid 209;
  end;

// *********************************************************************//
// Interface: IExodusHistorySearch
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {719FB50D-8FD3-48DE-82A2-13E4668E7B71}
// *********************************************************************//
  IExodusHistorySearch = interface(IDispatch)
    ['{719FB50D-8FD3-48DE-82A2-13E4668E7B71}']
    function Get_minDate: TDateTime; safecall;
    procedure Set_minDate(value: TDateTime); safecall;
    function Get_maxDate: TDateTime; safecall;
    procedure Set_maxDate(value: TDateTime); safecall;
    procedure AddJid(const JID: WideString); safecall;
    function GetJID(index: Integer): WideString; safecall;
    procedure AddKeyword(const Keyword: WideString); safecall;
    function GetKeyword(index: Integer): WideString; safecall;
    function Get_ExactKeywordMatch: WordBool; safecall;
    procedure Set_ExactKeywordMatch(value: WordBool); safecall;
    procedure AddAllowedSearchType(const ID: WideString); safecall;
    function GetAllowedSearchType(index: Integer): WideString; safecall;
    function Get_KeywordCount: Integer; safecall;
    function Get_JIDCount: Integer; safecall;
    function Get_AllowedSearchTypeCount: Integer; safecall;
    function Get_SearchID: WideString; safecall;
    procedure AddMessageType(const messageType: WideString); safecall;
    function GetMessageType(index: Integer): WideString; safecall;
    function Get_MessageTypeCount: Integer; safecall;
    function GetJIDExclusiveHandlerID(const JID: WideString): Integer; safecall;
    procedure SetJIDExclusiveHandlerID(JIDindex: Integer; HandlerID: Integer); safecall;
    function Get_Priority: Integer; safecall;
    procedure Set_Priority(value: Integer); safecall;
    property minDate: TDateTime read Get_minDate write Set_minDate;
    property maxDate: TDateTime read Get_maxDate write Set_maxDate;
    property ExactKeywordMatch: WordBool read Get_ExactKeywordMatch write Set_ExactKeywordMatch;
    property KeywordCount: Integer read Get_KeywordCount;
    property JIDCount: Integer read Get_JIDCount;
    property AllowedSearchTypeCount: Integer read Get_AllowedSearchTypeCount;
    property SearchID: WideString read Get_SearchID;
    property MessageTypeCount: Integer read Get_MessageTypeCount;
    property Priority: Integer read Get_Priority write Set_Priority;
  end;

// *********************************************************************//
// DispIntf:  IExodusHistorySearchDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {719FB50D-8FD3-48DE-82A2-13E4668E7B71}
// *********************************************************************//
  IExodusHistorySearchDisp = dispinterface
    ['{719FB50D-8FD3-48DE-82A2-13E4668E7B71}']
    property minDate: TDateTime dispid 201;
    property maxDate: TDateTime dispid 202;
    procedure AddJid(const JID: WideString); dispid 203;
    function GetJID(index: Integer): WideString; dispid 204;
    procedure AddKeyword(const Keyword: WideString); dispid 206;
    function GetKeyword(index: Integer): WideString; dispid 207;
    property ExactKeywordMatch: WordBool dispid 209;
    procedure AddAllowedSearchType(const ID: WideString); dispid 210;
    function GetAllowedSearchType(index: Integer): WideString; dispid 211;
    property KeywordCount: Integer readonly dispid 212;
    property JIDCount: Integer readonly dispid 213;
    property AllowedSearchTypeCount: Integer readonly dispid 214;
    property SearchID: WideString readonly dispid 205;
    procedure AddMessageType(const messageType: WideString); dispid 208;
    function GetMessageType(index: Integer): WideString; dispid 215;
    property MessageTypeCount: Integer readonly dispid 216;
    function GetJIDExclusiveHandlerID(const JID: WideString): Integer; dispid 217;
    procedure SetJIDExclusiveHandlerID(JIDindex: Integer; HandlerID: Integer); dispid 218;
    property Priority: Integer dispid 219;
  end;

// *********************************************************************//
// Interface: IExodusHistoryResult
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DC665BA9-A59B-4038-A162-33AB2EFA961D}
// *********************************************************************//
  IExodusHistoryResult = interface(IDispatch)
    ['{DC665BA9-A59B-4038-A162-33AB2EFA961D}']
    function Get_ResultCount: Integer; safecall;
    function Get_Processing: WordBool; safecall;
    procedure OnResultItem(SearchHandlerID: Integer; const SearchID: WideString; 
                           const Item: IExodusMsg); safecall;
    function GetResult(index: Integer): IExodusMsg; safecall;
    procedure Set_Processing(value: WordBool); safecall;
    property ResultCount: Integer read Get_ResultCount;
    property Processing: WordBool read Get_Processing write Set_Processing;
  end;

// *********************************************************************//
// DispIntf:  IExodusHistoryResultDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DC665BA9-A59B-4038-A162-33AB2EFA961D}
// *********************************************************************//
  IExodusHistoryResultDisp = dispinterface
    ['{DC665BA9-A59B-4038-A162-33AB2EFA961D}']
    property ResultCount: Integer readonly dispid 201;
    property Processing: WordBool dispid 202;
    procedure OnResultItem(SearchHandlerID: Integer; const SearchID: WideString; 
                           const Item: IExodusMsg); dispid 203;
    function GetResult(index: Integer): IExodusMsg; dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusHistorySearchHandler
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EA467AEA-897D-4CBA-918E-CF274981C3C8}
// *********************************************************************//
  IExodusHistorySearchHandler = interface(IDispatch)
    ['{EA467AEA-897D-4CBA-918E-CF274981C3C8}']
    function NewSearch(const SearchParameters: IExodusHistorySearch): WordBool; safecall;
    procedure CancelSearch(const SearchID: WideString); safecall;
    function Get_SearchTypeCount: Integer; safecall;
    function GetSearchType(index: Integer): WideString; safecall;
    function Get_SearchHandlerLabel: WideString; safecall;
    property SearchTypeCount: Integer read Get_SearchTypeCount;
    property SearchHandlerLabel: WideString read Get_SearchHandlerLabel;
  end;

// *********************************************************************//
// DispIntf:  IExodusHistorySearchHandlerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EA467AEA-897D-4CBA-918E-CF274981C3C8}
// *********************************************************************//
  IExodusHistorySearchHandlerDisp = dispinterface
    ['{EA467AEA-897D-4CBA-918E-CF274981C3C8}']
    function NewSearch(const SearchParameters: IExodusHistorySearch): WordBool; dispid 201;
    procedure CancelSearch(const SearchID: WideString); dispid 202;
    property SearchTypeCount: Integer readonly dispid 203;
    function GetSearchType(index: Integer): WideString; dispid 204;
    property SearchHandlerLabel: WideString readonly dispid 205;
  end;

// *********************************************************************//
// Interface: IExodusHistorySearchManager
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {810CB0EC-25DA-443B-8F16-D3E710ED333B}
// *********************************************************************//
  IExodusHistorySearchManager = interface(IDispatch)
    ['{810CB0EC-25DA-443B-8F16-D3E710ED333B}']
    function NewSearch(const SearchParams: IExodusHistorySearch; 
                       const SearchResult: IExodusHistoryResult): WordBool; safecall;
    function RegisterSearchHandler(const Handler: IExodusHistorySearchHandler): Integer; safecall;
    procedure UnRegisterSearchHandler(HandlerID: Integer); safecall;
    procedure CancelSearch(const SearchID: WideString); safecall;
    function GetSearchType(index: Integer): WideString; safecall;
    function Get_SearchTypeCount: Integer; safecall;
    procedure HandlerResult(HandlerID: Integer; const SearchID: WideString; const msg: IExodusMsg); safecall;
    property SearchTypeCount: Integer read Get_SearchTypeCount;
  end;

// *********************************************************************//
// DispIntf:  IExodusHistorySearchManagerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {810CB0EC-25DA-443B-8F16-D3E710ED333B}
// *********************************************************************//
  IExodusHistorySearchManagerDisp = dispinterface
    ['{810CB0EC-25DA-443B-8F16-D3E710ED333B}']
    function NewSearch(const SearchParams: IExodusHistorySearch; 
                       const SearchResult: IExodusHistoryResult): WordBool; dispid 201;
    function RegisterSearchHandler(const Handler: IExodusHistorySearchHandler): Integer; dispid 202;
    procedure UnRegisterSearchHandler(HandlerID: Integer); dispid 203;
    procedure CancelSearch(const SearchID: WideString); dispid 204;
    function GetSearchType(index: Integer): WideString; dispid 205;
    property SearchTypeCount: Integer readonly dispid 206;
    procedure HandlerResult(HandlerID: Integer; const SearchID: WideString; const msg: IExodusMsg); dispid 207;
  end;

// *********************************************************************//
// Interface: IExodusAction
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {30D5C4FE-F672-4240-B381-53D84C20FA04}
// *********************************************************************//
  IExodusAction = interface(IDispatch)
    ['{30D5C4FE-F672-4240-B381-53D84C20FA04}']
    function Get_Name: WideString; safecall;
    function Get_Caption: WideString; safecall;
    function Get_ImageIndex: Integer; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_SubActionCount: Integer; safecall;
    function Get_SubAction(index: Integer): IExodusAction; safecall;
    procedure execute(const Items: IExodusItemList); safecall;
    property Name: WideString read Get_Name;
    property Caption: WideString read Get_Caption;
    property ImageIndex: Integer read Get_ImageIndex;
    property Enabled: WordBool read Get_Enabled;
    property SubActionCount: Integer read Get_SubActionCount;
    property SubAction[index: Integer]: IExodusAction read Get_SubAction;
  end;

// *********************************************************************//
// DispIntf:  IExodusActionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {30D5C4FE-F672-4240-B381-53D84C20FA04}
// *********************************************************************//
  IExodusActionDisp = dispinterface
    ['{30D5C4FE-F672-4240-B381-53D84C20FA04}']
    property Name: WideString readonly dispid 201;
    property Caption: WideString readonly dispid 202;
    property ImageIndex: Integer readonly dispid 203;
    property Enabled: WordBool readonly dispid 204;
    property SubActionCount: Integer readonly dispid 205;
    property SubAction[index: Integer]: IExodusAction readonly dispid 206;
    procedure execute(const Items: IExodusItemList); dispid 207;
  end;

// *********************************************************************//
// Interface: IExodusTypedActions
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {638D1155-7D20-4295-A461-86E27FF28A5E}
// *********************************************************************//
  IExodusTypedActions = interface(IDispatch)
    ['{638D1155-7D20-4295-A461-86E27FF28A5E}']
    function Get_ItemType: WideString; safecall;
    function Get_itemCount: Integer; safecall;
    function Get_Item(index: Integer): IExodusItem; safecall;
    function Get_ActionCount: Integer; safecall;
    function Get_Action(index: Integer): IExodusAction; safecall;
    function GetActionNamed(const Name: WideString): IExodusAction; safecall;
    procedure execute(const actname: WideString); safecall;
    property ItemType: WideString read Get_ItemType;
    property itemCount: Integer read Get_itemCount;
    property Item[index: Integer]: IExodusItem read Get_Item;
    property ActionCount: Integer read Get_ActionCount;
    property Action[index: Integer]: IExodusAction read Get_Action;
  end;

// *********************************************************************//
// DispIntf:  IExodusTypedActionsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {638D1155-7D20-4295-A461-86E27FF28A5E}
// *********************************************************************//
  IExodusTypedActionsDisp = dispinterface
    ['{638D1155-7D20-4295-A461-86E27FF28A5E}']
    property ItemType: WideString readonly dispid 201;
    property itemCount: Integer readonly dispid 202;
    property Item[index: Integer]: IExodusItem readonly dispid 203;
    property ActionCount: Integer readonly dispid 204;
    property Action[index: Integer]: IExodusAction readonly dispid 205;
    function GetActionNamed(const Name: WideString): IExodusAction; dispid 206;
    procedure execute(const actname: WideString); dispid 207;
  end;

// *********************************************************************//
// Interface: IExodusActionMap
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B7C79472-A921-4357-84EB-A01902B18791}
// *********************************************************************//
  IExodusActionMap = interface(IDispatch)
    ['{B7C79472-A921-4357-84EB-A01902B18791}']
    function Get_itemCount: Integer; safecall;
    function Get_Item(index: Integer): IExodusItem; safecall;
    function Get_TypedActionsCount: Integer; safecall;
    function Get_TypedActions(index: Integer): IExodusTypedActions; safecall;
    function GetActionsFor(const ItemType: WideString): IExodusTypedActions; safecall;
    function GetActionNamed(const actname: WideString): IExodusAction; safecall;
    property itemCount: Integer read Get_itemCount;
    property Item[index: Integer]: IExodusItem read Get_Item;
    property TypedActionsCount: Integer read Get_TypedActionsCount;
    property TypedActions[index: Integer]: IExodusTypedActions read Get_TypedActions;
  end;

// *********************************************************************//
// DispIntf:  IExodusActionMapDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B7C79472-A921-4357-84EB-A01902B18791}
// *********************************************************************//
  IExodusActionMapDisp = dispinterface
    ['{B7C79472-A921-4357-84EB-A01902B18791}']
    property itemCount: Integer readonly dispid 201;
    property Item[index: Integer]: IExodusItem readonly dispid 202;
    property TypedActionsCount: Integer readonly dispid 203;
    property TypedActions[index: Integer]: IExodusTypedActions readonly dispid 204;
    function GetActionsFor(const ItemType: WideString): IExodusTypedActions; dispid 205;
    function GetActionNamed(const actname: WideString): IExodusAction; dispid 206;
  end;

// *********************************************************************//
// Interface: IExodusActionController
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4318FEF0-E766-4269-935E-417CE9925991}
// *********************************************************************//
  IExodusActionController = interface(IDispatch)
    ['{4318FEF0-E766-4269-935E-417CE9925991}']
    procedure registerAction(const ItemType: WideString; const act: IExodusAction); safecall;
    procedure addEnableFilter(const ItemType: WideString; const actname: WideString; 
                              const filter: WideString); safecall;
    procedure addDisableFilter(const ItemType: WideString; const actname: WideString; 
                               const filter: WideString); safecall;
    function buildActions(const Items: IExodusItemList): IExodusActionMap; safecall;
    function actionsForType(const ItemType: WideString): IExodusTypedActions; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusActionControllerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4318FEF0-E766-4269-935E-417CE9925991}
// *********************************************************************//
  IExodusActionControllerDisp = dispinterface
    ['{4318FEF0-E766-4269-935E-417CE9925991}']
    procedure registerAction(const ItemType: WideString; const act: IExodusAction); dispid 201;
    procedure addEnableFilter(const ItemType: WideString; const actname: WideString; 
                              const filter: WideString); dispid 202;
    procedure addDisableFilter(const ItemType: WideString; const actname: WideString; 
                               const filter: WideString); dispid 203;
    function buildActions(const Items: IExodusItemList): IExodusActionMap; dispid 204;
    function actionsForType(const ItemType: WideString): IExodusTypedActions; dispid 205;
  end;

// *********************************************************************//
// Interface: IExodusItemSelection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DB35AAD2-6E6B-4A3D-A12D-A73E383586B9}
// *********************************************************************//
  IExodusItemSelection = interface(IDispatch)
    ['{DB35AAD2-6E6B-4A3D-A12D-A73E383586B9}']
    function GetSelectedItems: IExodusItemList; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusItemSelectionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DB35AAD2-6E6B-4A3D-A12D-A73E383586B9}
// *********************************************************************//
  IExodusItemSelectionDisp = dispinterface
    ['{DB35AAD2-6E6B-4A3D-A12D-A73E383586B9}']
    function GetSelectedItems: IExodusItemList; dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusItemCallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {74B2E5CA-F9AB-4FC6-8361-36652C7D57B2}
// *********************************************************************//
  IExodusItemCallback = interface(IDispatch)
    ['{74B2E5CA-F9AB-4FC6-8361-36652C7D57B2}']
    procedure ItemDeleted(const Item: IExodusItem); safecall;
    procedure ItemGroupsChanged(const Item: IExodusItem); safecall;
    procedure ItemUpdated(const Item: IExodusItem); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusItemCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {74B2E5CA-F9AB-4FC6-8361-36652C7D57B2}
// *********************************************************************//
  IExodusItemCallbackDisp = dispinterface
    ['{74B2E5CA-F9AB-4FC6-8361-36652C7D57B2}']
    procedure ItemDeleted(const Item: IExodusItem); dispid 201;
    procedure ItemGroupsChanged(const Item: IExodusItem); dispid 202;
    procedure ItemUpdated(const Item: IExodusItem); dispid 203;
  end;

// *********************************************************************//
// Interface: IExodusAXWindowCallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {87D6C026-3A1C-43CF-B153-BB6472A956AD}
// *********************************************************************//
  IExodusAXWindowCallback = interface(IDispatch)
    ['{87D6C026-3A1C-43CF-B153-BB6472A956AD}']
    procedure OnDocked; safecall;
    procedure OnClose; safecall;
    procedure OnFloat; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusAXWindowCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {87D6C026-3A1C-43CF-B153-BB6472A956AD}
// *********************************************************************//
  IExodusAXWindowCallbackDisp = dispinterface
    ['{87D6C026-3A1C-43CF-B153-BB6472A956AD}']
    procedure OnDocked; dispid 201;
    procedure OnClose; dispid 203;
    procedure OnFloat; dispid 206;
  end;

// *********************************************************************//
// Interface: IExodusChatPlugin2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B92A81A9-79B8-47F0-8A79-1CAC711089E5}
// *********************************************************************//
  IExodusChatPlugin2 = interface(IExodusChatPlugin)
    ['{B92A81A9-79B8-47F0-8A79-1CAC711089E5}']
    procedure OnSentMessageXML(const XML: WideString); safecall;
    function OnChatEvent(const event: WideString; value: OleVariant): WordBool; safecall;
    function OnKeyPress(var key: WideString; part: ChatParts): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusChatPlugin2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B92A81A9-79B8-47F0-8A79-1CAC711089E5}
// *********************************************************************//
  IExodusChatPlugin2Disp = dispinterface
    ['{B92A81A9-79B8-47F0-8A79-1CAC711089E5}']
    procedure OnSentMessageXML(const XML: WideString); dispid 302;
    function OnChatEvent(const event: WideString; value: OleVariant): WordBool; dispid 303;
    function OnKeyPress(var key: WideString; part: ChatParts): WordBool; dispid 304;
    function OnBeforeMessage(var Body: WideString): WordBool; dispid 1;
    function OnAfterMessage(var Body: WideString): WideString; dispid 2;
    procedure OnClose; dispid 6;
    procedure OnNewWindow(hwnd: Integer); dispid 202;
    function OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool; dispid 203;
    procedure OnAfterRecvMessage(var Body: WideString); dispid 204;
    function OnKeyUp(key: Integer; shiftState: Integer): WordBool; dispid 301;
    function OnKeyDown(key: Integer; shiftState: Integer): WordBool; dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusChat3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FD3F0F9F-0BD9-4087-B892-C8FE5E332E40}
// *********************************************************************//
  IExodusChat3 = interface(IDispatch)
    ['{FD3F0F9F-0BD9-4087-B892-C8FE5E332E40}']
    procedure Close; safecall;
    procedure BringToFront; safecall;
    procedure Dock; safecall;
    procedure Float; safecall;
    function AddRosterMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; safecall;
    procedure RemoveRosterMenu(const menuID: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusChat3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FD3F0F9F-0BD9-4087-B892-C8FE5E332E40}
// *********************************************************************//
  IExodusChat3Disp = dispinterface
    ['{FD3F0F9F-0BD9-4087-B892-C8FE5E332E40}']
    procedure Close; dispid 224;
    procedure BringToFront; dispid 225;
    procedure Dock; dispid 226;
    procedure Float; dispid 227;
    function AddRosterMenu(const Caption: WideString; const MenuListener: IExodusMenuListener): WideString; dispid 401;
    procedure RemoveRosterMenu(const menuID: WideString); dispid 402;
  end;

// *********************************************************************//
// Interface: IExodusHoverListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {71150EFD-FFF5-4114-A7AC-A9540453376A}
// *********************************************************************//
  IExodusHoverListener = interface(IDispatch)
    ['{71150EFD-FFF5-4114-A7AC-A9540453376A}']
    function OnShow(const Item: IExodusItem): WordBool; safecall;
    procedure OnHide(const Item: IExodusItem); safecall;
    function CanHideQuery: WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusHoverListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {71150EFD-FFF5-4114-A7AC-A9540453376A}
// *********************************************************************//
  IExodusHoverListenerDisp = dispinterface
    ['{71150EFD-FFF5-4114-A7AC-A9540453376A}']
    function OnShow(const Item: IExodusItem): WordBool; dispid 201;
    procedure OnHide(const Item: IExodusItem); dispid 202;
    function CanHideQuery: WordBool; dispid 203;
  end;

// *********************************************************************//
// Interface: IExodusHover
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4CF49CD8-4B9B-4648-A07C-280111E724DA}
// *********************************************************************//
  IExodusHover = interface(IDispatch)
    ['{4CF49CD8-4B9B-4648-A07C-280111E724DA}']
    function Get_listener: IExodusHoverListener; safecall;
    procedure Set_listener(const value: IExodusHoverListener); safecall;
    function Get_AXControl: IUnknown; safecall;
    procedure Show(const Item: IExodusItem); safecall;
    procedure Hide(const Item: IExodusItem); safecall;
    property listener: IExodusHoverListener read Get_listener write Set_listener;
    property AXControl: IUnknown read Get_AXControl;
  end;

// *********************************************************************//
// DispIntf:  IExodusHoverDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4CF49CD8-4B9B-4648-A07C-280111E724DA}
// *********************************************************************//
  IExodusHoverDisp = dispinterface
    ['{4CF49CD8-4B9B-4648-A07C-280111E724DA}']
    property listener: IExodusHoverListener dispid 201;
    property AXControl: IUnknown readonly dispid 202;
    procedure Show(const Item: IExodusItem); dispid 203;
    procedure Hide(const Item: IExodusItem); dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusEventXML
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8FB96A63-DA5C-459A-9B28-A177A6406CBC}
// *********************************************************************//
  IExodusEventXML = interface(IDispatch)
    ['{8FB96A63-DA5C-459A-9B28-A177A6406CBC}']
    function GetTag: Integer; safecall;
    procedure SetTag(XMLTagPointer: Integer); safecall;
    function GetString: WideString; safecall;
    procedure SetString(const XMLString: WideString); safecall;
    function GetDOM: IXMLDOMDocument; safecall;
    procedure SetDOM(const XMLDom: IXMLDOMDocument); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusEventXMLDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8FB96A63-DA5C-459A-9B28-A177A6406CBC}
// *********************************************************************//
  IExodusEventXMLDisp = dispinterface
    ['{8FB96A63-DA5C-459A-9B28-A177A6406CBC}']
    function GetTag: Integer; dispid 201;
    procedure SetTag(XMLTagPointer: Integer); dispid 202;
    function GetString: WideString; dispid 203;
    procedure SetString(const XMLString: WideString); dispid 204;
    function GetDOM: IXMLDOMDocument; dispid 205;
    procedure SetDOM(const XMLDom: IXMLDOMDocument); dispid 206;
  end;

// *********************************************************************//
// Interface: IExodusPacketDispatcher
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {96BB23C1-F6BC-4007-8CE6-83107C7D0B29}
// *********************************************************************//
  IExodusPacketDispatcher = interface(IDispatch)
    ['{96BB23C1-F6BC-4007-8CE6-83107C7D0B29}']
    procedure RegisterPacketControlListener(const xpath: WideString; 
                                            const listener: IExodusPacketControlListener); safecall;
    procedure UnregisterPacketControlListener(const xpath: WideString; 
                                              const listener: IExodusPacketControlListener); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusPacketDispatcherDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {96BB23C1-F6BC-4007-8CE6-83107C7D0B29}
// *********************************************************************//
  IExodusPacketDispatcherDisp = dispinterface
    ['{96BB23C1-F6BC-4007-8CE6-83107C7D0B29}']
    procedure RegisterPacketControlListener(const xpath: WideString; 
                                            const listener: IExodusPacketControlListener); dispid 201;
    procedure UnregisterPacketControlListener(const xpath: WideString; 
                                              const listener: IExodusPacketControlListener); dispid 202;
  end;

// *********************************************************************//
// Interface: IExodusMenuListener2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {046DE4B3-E2B0-4B39-9A55-98541ABFC8FA}
// *********************************************************************//
  IExodusMenuListener2 = interface(IDispatch)
    ['{046DE4B3-E2B0-4B39-9A55-98541ABFC8FA}']
    procedure OnMenuItemShow(const menuID: WideString; const XML: WideString; var enable: WordBool); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusMenuListener2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {046DE4B3-E2B0-4B39-9A55-98541ABFC8FA}
// *********************************************************************//
  IExodusMenuListener2Disp = dispinterface
    ['{046DE4B3-E2B0-4B39-9A55-98541ABFC8FA}']
    procedure OnMenuItemShow(const menuID: WideString; const XML: WideString; var enable: WordBool); dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusPacketControlListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1DDEA354-6FA2-43E1-AE81-8ABE167AB791}
// *********************************************************************//
  IExodusPacketControlListener = interface(IDispatch)
    ['{1DDEA354-6FA2-43E1-AE81-8ABE167AB791}']
    procedure OnPacketReceived(const xpath: WideString; const packet: IExodusEventXML; 
                               const modifiedPacket: IExodusEventXML; var allow: WordBool); safecall;
    procedure OnPacketSent(const xpath: WideString; const packet: IExodusEventXML; 
                           const modifiedPacket: IExodusEventXML; var allow: WordBool); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusPacketControlListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1DDEA354-6FA2-43E1-AE81-8ABE167AB791}
// *********************************************************************//
  IExodusPacketControlListenerDisp = dispinterface
    ['{1DDEA354-6FA2-43E1-AE81-8ABE167AB791}']
    procedure OnPacketReceived(const xpath: WideString; const packet: IExodusEventXML; 
                               const modifiedPacket: IExodusEventXML; var allow: WordBool); dispid 201;
    procedure OnPacketSent(const xpath: WideString; const packet: IExodusEventXML; 
                           const modifiedPacket: IExodusEventXML; var allow: WordBool); dispid 202;
  end;

// *********************************************************************//
// Interface: IExodusControlSite
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B976BDA3-5BCB-488F-AA45-2818F2FCEE1F}
// *********************************************************************//
  IExodusControlSite = interface(IDispatch)
    ['{B976BDA3-5BCB-488F-AA45-2818F2FCEE1F}']
    function Get_Control: IDispatch; safecall;
    function Get_ControlName: WideString; safecall;
    function Get_ControlGUID: WideString; safecall;
    function Get_AlignClient: WordBool; safecall;
    procedure Set_AlignClient(value: WordBool); safecall;
    property Control: IDispatch read Get_Control;
    property ControlName: WideString read Get_ControlName;
    property ControlGUID: WideString read Get_ControlGUID;
    property AlignClient: WordBool read Get_AlignClient write Set_AlignClient;
  end;

// *********************************************************************//
// DispIntf:  IExodusControlSiteDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B976BDA3-5BCB-488F-AA45-2818F2FCEE1F}
// *********************************************************************//
  IExodusControlSiteDisp = dispinterface
    ['{B976BDA3-5BCB-488F-AA45-2818F2FCEE1F}']
    property Control: IDispatch readonly dispid 201;
    property ControlName: WideString readonly dispid 202;
    property ControlGUID: WideString readonly dispid 203;
    property AlignClient: WordBool dispid 204;
  end;

// *********************************************************************//
// Interface: IExodusMsg
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {46DFB7CF-1431-4B99-9F07-A427D6F7EE77}
// *********************************************************************//
  IExodusMsg = interface(IDispatch)
    ['{46DFB7CF-1431-4B99-9F07-A427D6F7EE77}']
    procedure FillMsg(const ID: WideString; const Timestamp: WideString; const ToJid: WideString; 
                      const FromJid: WideString; Priority: Integer; const Nick: WideString; 
                      const Direction: WideString; const MsgType: WideString; 
                      const Thread: WideString; const Subject: WideString; const Body: WideString; 
                      const additionalXML: WideString; const RawMsgXML: WideString); safecall;
    function Get_ToJid: WideString; safecall;
    procedure Set_ToJid(const value: WideString); safecall;
    function Get_FromJid: WideString; safecall;
    procedure Set_FromJid(const value: WideString); safecall;
    function Get_MsgType: WideString; safecall;
    procedure Set_MsgType(const value: WideString); safecall;
    function Get_ID: WideString; safecall;
    procedure Set_ID(const value: WideString); safecall;
    function Get_Nick: WideString; safecall;
    procedure Set_Nick(const value: WideString); safecall;
    function Get_Body: WideString; safecall;
    procedure Set_Body(const value: WideString); safecall;
    function Get_Thread: WideString; safecall;
    procedure Set_Thread(const value: WideString); safecall;
    function Get_Subject: WideString; safecall;
    procedure Set_Subject(const value: WideString); safecall;
    function Get_Timestamp: WideString; safecall;
    procedure Set_Timestamp(const value: WideString); safecall;
    function Get_Direction: WideString; safecall;
    procedure Set_Direction(const value: WideString); safecall;
    function Get_additionalXML: WideString; safecall;
    procedure Set_additionalXML(const value: WideString); safecall;
    function Get_RawMsgXML: WideString; safecall;
    procedure Set_RawMsgXML(const value: WideString); safecall;
    function Get_Priority: Integer; safecall;
    procedure Set_Priority(value: Integer); safecall;
    property ToJid: WideString read Get_ToJid write Set_ToJid;
    property FromJid: WideString read Get_FromJid write Set_FromJid;
    property MsgType: WideString read Get_MsgType write Set_MsgType;
    property ID: WideString read Get_ID write Set_ID;
    property Nick: WideString read Get_Nick write Set_Nick;
    property Body: WideString read Get_Body write Set_Body;
    property Thread: WideString read Get_Thread write Set_Thread;
    property Subject: WideString read Get_Subject write Set_Subject;
    property Timestamp: WideString read Get_Timestamp write Set_Timestamp;
    property Direction: WideString read Get_Direction write Set_Direction;
    property additionalXML: WideString read Get_additionalXML write Set_additionalXML;
    property RawMsgXML: WideString read Get_RawMsgXML write Set_RawMsgXML;
    property Priority: Integer read Get_Priority write Set_Priority;
  end;

// *********************************************************************//
// DispIntf:  IExodusMsgDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {46DFB7CF-1431-4B99-9F07-A427D6F7EE77}
// *********************************************************************//
  IExodusMsgDisp = dispinterface
    ['{46DFB7CF-1431-4B99-9F07-A427D6F7EE77}']
    procedure FillMsg(const ID: WideString; const Timestamp: WideString; const ToJid: WideString; 
                      const FromJid: WideString; Priority: Integer; const Nick: WideString; 
                      const Direction: WideString; const MsgType: WideString; 
                      const Thread: WideString; const Subject: WideString; const Body: WideString; 
                      const additionalXML: WideString; const RawMsgXML: WideString); dispid 201;
    property ToJid: WideString dispid 202;
    property FromJid: WideString dispid 203;
    property MsgType: WideString dispid 204;
    property ID: WideString dispid 205;
    property Nick: WideString dispid 206;
    property Body: WideString dispid 207;
    property Thread: WideString dispid 208;
    property Subject: WideString dispid 209;
    property Timestamp: WideString dispid 210;
    property Direction: WideString dispid 211;
    property additionalXML: WideString dispid 212;
    property RawMsgXML: WideString dispid 213;
    property Priority: Integer dispid 214;
  end;

// *********************************************************************//
// Interface: IExodusPubsubListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF6AFD93-FBF8-409E-BF37-052608F55FCB}
// *********************************************************************//
  IExodusPubsubListener = interface(IDispatch)
    ['{EF6AFD93-FBF8-409E-BF37-052608F55FCB}']
    procedure OnNotify(const publisher: WideString; const Node: WideString; var Items: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusPubsubListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF6AFD93-FBF8-409E-BF37-052608F55FCB}
// *********************************************************************//
  IExodusPubsubListenerDisp = dispinterface
    ['{EF6AFD93-FBF8-409E-BF37-052608F55FCB}']
    procedure OnNotify(const publisher: WideString; const Node: WideString; var Items: OleVariant); dispid 201;
  end;

// *********************************************************************//
// Interface: IExodusPubsubService
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {542C6454-D12A-4DB2-B158-3DEBC1A9E017}
// *********************************************************************//
  IExodusPubsubService = interface(IDispatch)
    ['{542C6454-D12A-4DB2-B158-3DEBC1A9E017}']
    function Get_JID: WideString; safecall;
    procedure publish(const Node: WideString; var Items: OleVariant); safecall;
    procedure retrieve(const node: WideString; const cb: IExodusPubsubListener); safecall;
    property JID: WideString read Get_JID;
  end;

// *********************************************************************//
// DispIntf:  IExodusPubsubServiceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {542C6454-D12A-4DB2-B158-3DEBC1A9E017}
// *********************************************************************//
  IExodusPubsubServiceDisp = dispinterface
    ['{542C6454-D12A-4DB2-B158-3DEBC1A9E017}']
    property JID: WideString readonly dispid 201;
    procedure publish(const Node: WideString; var Items: OleVariant); dispid 202;
    procedure retrieve(const node: WideString; const cb: IExodusPubsubListener); dispid 203;
  end;

// *********************************************************************//
// Interface: IExodusPubsubController
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A4710E01-8CC8-4AC3-A49F-B702A4208D84}
// *********************************************************************//
  IExodusPubsubController = interface(IDispatch)
    ['{A4710E01-8CC8-4AC3-A49F-B702A4208D84}']
    function Get_ServiceCount: Integer; safecall;
    function Get_Services(index: Integer): IExodusPubsubService; safecall;
    function ServiceFor(const JID: WideString): IExodusPubsubService; safecall;
    function Get_PepService: IExodusPubsubService; safecall;
    procedure RegisterListener(const Node: WideString; const callback: IExodusPubsubListener); safecall;
    procedure UnregisterListener(const Node: WideString; const callback: IExodusPubsubListener); safecall;
    property ServiceCount: Integer read Get_ServiceCount;
    property Services[index: Integer]: IExodusPubsubService read Get_Services;
    property PepService: IExodusPubsubService read Get_PepService;
  end;

// *********************************************************************//
// DispIntf:  IExodusPubsubControllerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A4710E01-8CC8-4AC3-A49F-B702A4208D84}
// *********************************************************************//
  IExodusPubsubControllerDisp = dispinterface
    ['{A4710E01-8CC8-4AC3-A49F-B702A4208D84}']
    property ServiceCount: Integer readonly dispid 203;
    property Services[index: Integer]: IExodusPubsubService readonly dispid 204;
    function ServiceFor(const JID: WideString): IExodusPubsubService; dispid 205;
    property PepService: IExodusPubsubService readonly dispid 206;
    procedure RegisterListener(const Node: WideString; const callback: IExodusPubsubListener); dispid 201;
    procedure UnregisterListener(const Node: WideString; const callback: IExodusPubsubListener); dispid 202;
  end;

// *********************************************************************//
// Interface: IExodusControllerRegistry
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E2AE307A-FFA5-4C68-B56D-FC6165924805}
// *********************************************************************//
  IExodusControllerRegistry = interface(IDispatch)
    ['{E2AE307A-FFA5-4C68-B56D-FC6165924805}']
    procedure RegisterController(iid: TGUID; const instance: IUnknown); safecall;
    procedure UnregisterController(iid: TGUID; const instance: IUnknown); safecall;
    function GetController(iid: TGUID): IUnknown; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExodusControllerRegistryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E2AE307A-FFA5-4C68-B56D-FC6165924805}
// *********************************************************************//
  IExodusControllerRegistryDisp = dispinterface
    ['{E2AE307A-FFA5-4C68-B56D-FC6165924805}']
    procedure RegisterController(iid: {??TGUID}OleVariant; const instance: IUnknown); dispid 201;
    procedure UnregisterController(iid: {??TGUID}OleVariant; const instance: IUnknown); dispid 202;
    function GetController(iid: {??TGUID}OleVariant): IUnknown; dispid 203;
  end;

// *********************************************************************//
// The Class CoExodusPPDB provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPPDB exposed by              
// the CoClass ExodusPPDB. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusPPDB = class
    class function Create: IExodusPPDB;
    class function CreateRemote(const MachineName: string): IExodusPPDB;
  end;

// *********************************************************************//
// The Class CoExodusRosterItem provides a Create and CreateRemote method to          
// create instances of the default interface IExodusRosterItem exposed by              
// the CoClass ExodusRosterItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusRosterItem = class
    class function Create: IExodusRosterItem;
    class function CreateRemote(const MachineName: string): IExodusRosterItem;
  end;

// *********************************************************************//
// The Class CoExodusPresence provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPresence exposed by              
// the CoClass ExodusPresence. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusPresence = class
    class function Create: IExodusPresence;
    class function CreateRemote(const MachineName: string): IExodusPresence;
  end;

// *********************************************************************//
// The Class CoExodusRosterGroup provides a Create and CreateRemote method to          
// create instances of the default interface IExodusRosterGroup exposed by              
// the CoClass ExodusRosterGroup. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusRosterGroup = class
    class function Create: IExodusRosterGroup;
    class function CreateRemote(const MachineName: string): IExodusRosterGroup;
  end;

// *********************************************************************//
// The Class CoExodusEntityCache provides a Create and CreateRemote method to          
// create instances of the default interface IExodusEntityCache exposed by              
// the CoClass ExodusEntityCache. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusEntityCache = class
    class function Create: IExodusEntityCache;
    class function CreateRemote(const MachineName: string): IExodusEntityCache;
  end;

// *********************************************************************//
// The Class CoExodusEntity provides a Create and CreateRemote method to          
// create instances of the default interface IExodusEntity exposed by              
// the CoClass ExodusEntity. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusEntity = class
    class function Create: IExodusEntity;
    class function CreateRemote(const MachineName: string): IExodusEntity;
  end;

// *********************************************************************//
// The Class CoExodusLogMsg provides a Create and CreateRemote method to          
// create instances of the default interface IExodusLogMsg exposed by              
// the CoClass ExodusLogMsg. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusLogMsg = class
    class function Create: IExodusLogMsg;
    class function CreateRemote(const MachineName: string): IExodusLogMsg;
  end;

// *********************************************************************//
// The Class CoExodusLogListener provides a Create and CreateRemote method to          
// create instances of the default interface IExodusLogListener exposed by              
// the CoClass ExodusLogListener. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusLogListener = class
    class function Create: IExodusLogListener;
    class function CreateRemote(const MachineName: string): IExodusLogListener;
  end;

// *********************************************************************//
// The Class CoExodusBookmarkManager provides a Create and CreateRemote method to          
// create instances of the default interface IExodusBookmarkManager exposed by              
// the CoClass ExodusBookmarkManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusBookmarkManager = class
    class function Create: IExodusBookmarkManager;
    class function CreateRemote(const MachineName: string): IExodusBookmarkManager;
  end;

// *********************************************************************//
// The Class CoExodusToolbarControl provides a Create and CreateRemote method to          
// create instances of the default interface IExodusToolbarControl exposed by              
// the CoClass ExodusToolbarControl. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusToolbarControl = class
    class function Create: IExodusToolbarControl;
    class function CreateRemote(const MachineName: string): IExodusToolbarControl;
  end;

// *********************************************************************//
// The Class CoExodusMsgOutToolbar provides a Create and CreateRemote method to          
// create instances of the default interface IExodusMsgOutToolbar exposed by              
// the CoClass ExodusMsgOutToolbar. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusMsgOutToolbar = class
    class function Create: IExodusMsgOutToolbar;
    class function CreateRemote(const MachineName: string): IExodusMsgOutToolbar;
  end;

// *********************************************************************//
// The Class CoExodusDockToolbar provides a Create and CreateRemote method to          
// create instances of the default interface IExodusDockToolbar exposed by              
// the CoClass ExodusDockToolbar. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusDockToolbar = class
    class function Create: IExodusDockToolbar;
    class function CreateRemote(const MachineName: string): IExodusDockToolbar;
  end;

// *********************************************************************//
// The Class CoExodusChat provides a Create and CreateRemote method to          
// create instances of the default interface IExodusChat exposed by              
// the CoClass ExodusChat. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusChat = class
    class function Create: IExodusChat;
    class function CreateRemote(const MachineName: string): IExodusChat;
  end;

// *********************************************************************//
// The Class CoExodusToolbarButton provides a Create and CreateRemote method to          
// create instances of the default interface IExodusToolbarButton exposed by              
// the CoClass ExodusToolbarButton. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusToolbarButton = class
    class function Create: IExodusToolbarButton;
    class function CreateRemote(const MachineName: string): IExodusToolbarButton;
  end;

// *********************************************************************//
// The Class CoExodusRoster provides a Create and CreateRemote method to          
// create instances of the default interface IExodusRoster exposed by              
// the CoClass ExodusRoster. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusRoster = class
    class function Create: IExodusRoster;
    class function CreateRemote(const MachineName: string): IExodusRoster;
  end;

// *********************************************************************//
// The Class CoExodusAXWindow provides a Create and CreateRemote method to          
// create instances of the default interface IExodusAXWindow exposed by              
// the CoClass ExodusAXWindow. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusAXWindow = class
    class function Create: IExodusAXWindow;
    class function CreateRemote(const MachineName: string): IExodusAXWindow;
  end;

// *********************************************************************//
// The Class CoExodusItem provides a Create and CreateRemote method to          
// create instances of the default interface IExodusItem exposed by              
// the CoClass ExodusItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusItem = class
    class function Create: IExodusItem;
    class function CreateRemote(const MachineName: string): IExodusItem;
  end;

// *********************************************************************//
// The Class CoExodusItemController provides a Create and CreateRemote method to          
// create instances of the default interface IExodusItemController exposed by              
// the CoClass ExodusItemController. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusItemController = class
    class function Create: IExodusItemController;
    class function CreateRemote(const MachineName: string): IExodusItemController;
  end;

// *********************************************************************//
// The Class CoExodusTabController provides a Create and CreateRemote method to          
// create instances of the default interface IExodusTabController exposed by              
// the CoClass ExodusTabController. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusTabController = class
    class function Create: IExodusTabController;
    class function CreateRemote(const MachineName: string): IExodusTabController;
  end;

// *********************************************************************//
// The Class CoExodusTab provides a Create and CreateRemote method to          
// create instances of the default interface IExodusTab exposed by              
// the CoClass ExodusTab. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusTab = class
    class function Create: IExodusTab;
    class function CreateRemote(const MachineName: string): IExodusTab;
  end;

// *********************************************************************//
// The Class CoExodusDataStore provides a Create and CreateRemote method to          
// create instances of the default interface IExodusDataStore exposed by              
// the CoClass ExodusDataStore. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusDataStore = class
    class function Create: IExodusDataStore;
    class function CreateRemote(const MachineName: string): IExodusDataStore;
  end;

// *********************************************************************//
// The Class CoExodusDataTable provides a Create and CreateRemote method to          
// create instances of the default interface IExodusDataTable exposed by              
// the CoClass ExodusDataTable. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusDataTable = class
    class function Create: IExodusDataTable;
    class function CreateRemote(const MachineName: string): IExodusDataTable;
  end;

// *********************************************************************//
// The Class CoExodusItemList provides a Create and CreateRemote method to          
// create instances of the default interface IExodusItemList exposed by              
// the CoClass ExodusItemList. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusItemList = class
    class function Create: IExodusItemList;
    class function CreateRemote(const MachineName: string): IExodusItemList;
  end;

// *********************************************************************//
// The Class CoExodusHistorySearch provides a Create and CreateRemote method to          
// create instances of the default interface IExodusHistorySearch exposed by              
// the CoClass ExodusHistorySearch. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusHistorySearch = class
    class function Create: IExodusHistorySearch;
    class function CreateRemote(const MachineName: string): IExodusHistorySearch;
  end;

// *********************************************************************//
// The Class CoExodusHistoryResult provides a Create and CreateRemote method to          
// create instances of the default interface IExodusHistoryResult exposed by              
// the CoClass ExodusHistoryResult. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusHistoryResult = class
    class function Create: IExodusHistoryResult;
    class function CreateRemote(const MachineName: string): IExodusHistoryResult;
  end;

// *********************************************************************//
// The Class CoExodusHistorySearchManager provides a Create and CreateRemote method to          
// create instances of the default interface IExodusHistorySearchManager exposed by              
// the CoClass ExodusHistorySearchManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusHistorySearchManager = class
    class function Create: IExodusHistorySearchManager;
    class function CreateRemote(const MachineName: string): IExodusHistorySearchManager;
  end;

// *********************************************************************//
// The Class CoExodusHistorySQLSearchHandler provides a Create and CreateRemote method to          
// create instances of the default interface IExodusHistorySearchHandler exposed by              
// the CoClass ExodusHistorySQLSearchHandler. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusHistorySQLSearchHandler = class
    class function Create: IExodusHistorySearchHandler;
    class function CreateRemote(const MachineName: string): IExodusHistorySearchHandler;
  end;

// *********************************************************************//
// The Class CoExodusActionController provides a Create and CreateRemote method to          
// create instances of the default interface IExodusActionController exposed by              
// the CoClass ExodusActionController. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusActionController = class
    class function Create: IExodusActionController;
    class function CreateRemote(const MachineName: string): IExodusActionController;
  end;

// *********************************************************************//
// The Class CoExodusRosterImages provides a Create and CreateRemote method to          
// create instances of the default interface IExodusRosterImages exposed by              
// the CoClass ExodusRosterImages. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusRosterImages = class
    class function Create: IExodusRosterImages;
    class function CreateRemote(const MachineName: string): IExodusRosterImages;
  end;

// *********************************************************************//
// The Class CoCOMExodusHover provides a Create and CreateRemote method to          
// create instances of the default interface IExodusHover exposed by              
// the CoClass COMExodusHover. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCOMExodusHover = class
    class function Create: IExodusHover;
    class function CreateRemote(const MachineName: string): IExodusHover;
  end;

// *********************************************************************//
// The Class CoExodusEventXML provides a Create and CreateRemote method to          
// create instances of the default interface IDispatch exposed by              
// the CoClass ExodusEventXML. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusEventXML = class
    class function Create: IDispatch;
    class function CreateRemote(const MachineName: string): IDispatch;
  end;

// *********************************************************************//
// The Class CoexodusController provides a Create and CreateRemote method to          
// create instances of the default interface IExodusController exposed by              
// the CoClass exodusController. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoexodusController = class
    class function Create: IExodusController;
    class function CreateRemote(const MachineName: string): IExodusController;
  end;

// *********************************************************************//
// The Class CoMainToolBarImages provides a Create and CreateRemote method to          
// create instances of the default interface IExodusRosterImages exposed by              
// the CoClass MainToolBarImages. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMainToolBarImages = class
    class function Create: IExodusRosterImages;
    class function CreateRemote(const MachineName: string): IExodusRosterImages;
  end;

// *********************************************************************//
// The Class CoExodusMsg provides a Create and CreateRemote method to          
// create instances of the default interface IExodusMsg exposed by              
// the CoClass ExodusMsg. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusMsg = class
    class function Create: IExodusMsg;
    class function CreateRemote(const MachineName: string): IExodusMsg;
  end;

// *********************************************************************//
// The Class CoExodusToolbar provides a Create and CreateRemote method to          
// create instances of the default interface IExodusToolbar exposed by              
// the CoClass ExodusToolbar. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusToolbar = class
    class function Create: IExodusToolbar;
    class function CreateRemote(const MachineName: string): IExodusToolbar;
  end;

// *********************************************************************//
// The Class CoExodusPacketDispatcher provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPacketDispatcher exposed by              
// the CoClass ExodusPacketDispatcher. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExodusPacketDispatcher = class
    class function Create: IExodusPacketDispatcher;
    class function CreateRemote(const MachineName: string): IExodusPacketDispatcher;
  end;

implementation

uses ComObj;

class function CoExodusPPDB.Create: IExodusPPDB;
begin
  Result := CreateComObject(CLASS_ExodusPPDB) as IExodusPPDB;
end;

class function CoExodusPPDB.CreateRemote(const MachineName: string): IExodusPPDB;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusPPDB) as IExodusPPDB;
end;

class function CoExodusRosterItem.Create: IExodusRosterItem;
begin
  Result := CreateComObject(CLASS_ExodusRosterItem) as IExodusRosterItem;
end;

class function CoExodusRosterItem.CreateRemote(const MachineName: string): IExodusRosterItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusRosterItem) as IExodusRosterItem;
end;

class function CoExodusPresence.Create: IExodusPresence;
begin
  Result := CreateComObject(CLASS_ExodusPresence) as IExodusPresence;
end;

class function CoExodusPresence.CreateRemote(const MachineName: string): IExodusPresence;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusPresence) as IExodusPresence;
end;

class function CoExodusRosterGroup.Create: IExodusRosterGroup;
begin
  Result := CreateComObject(CLASS_ExodusRosterGroup) as IExodusRosterGroup;
end;

class function CoExodusRosterGroup.CreateRemote(const MachineName: string): IExodusRosterGroup;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusRosterGroup) as IExodusRosterGroup;
end;

class function CoExodusEntityCache.Create: IExodusEntityCache;
begin
  Result := CreateComObject(CLASS_ExodusEntityCache) as IExodusEntityCache;
end;

class function CoExodusEntityCache.CreateRemote(const MachineName: string): IExodusEntityCache;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusEntityCache) as IExodusEntityCache;
end;

class function CoExodusEntity.Create: IExodusEntity;
begin
  Result := CreateComObject(CLASS_ExodusEntity) as IExodusEntity;
end;

class function CoExodusEntity.CreateRemote(const MachineName: string): IExodusEntity;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusEntity) as IExodusEntity;
end;

class function CoExodusLogMsg.Create: IExodusLogMsg;
begin
  Result := CreateComObject(CLASS_ExodusLogMsg) as IExodusLogMsg;
end;

class function CoExodusLogMsg.CreateRemote(const MachineName: string): IExodusLogMsg;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusLogMsg) as IExodusLogMsg;
end;

class function CoExodusLogListener.Create: IExodusLogListener;
begin
  Result := CreateComObject(CLASS_ExodusLogListener) as IExodusLogListener;
end;

class function CoExodusLogListener.CreateRemote(const MachineName: string): IExodusLogListener;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusLogListener) as IExodusLogListener;
end;

class function CoExodusBookmarkManager.Create: IExodusBookmarkManager;
begin
  Result := CreateComObject(CLASS_ExodusBookmarkManager) as IExodusBookmarkManager;
end;

class function CoExodusBookmarkManager.CreateRemote(const MachineName: string): IExodusBookmarkManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusBookmarkManager) as IExodusBookmarkManager;
end;

class function CoExodusToolbarControl.Create: IExodusToolbarControl;
begin
  Result := CreateComObject(CLASS_ExodusToolbarControl) as IExodusToolbarControl;
end;

class function CoExodusToolbarControl.CreateRemote(const MachineName: string): IExodusToolbarControl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusToolbarControl) as IExodusToolbarControl;
end;

class function CoExodusMsgOutToolbar.Create: IExodusMsgOutToolbar;
begin
  Result := CreateComObject(CLASS_ExodusMsgOutToolbar) as IExodusMsgOutToolbar;
end;

class function CoExodusMsgOutToolbar.CreateRemote(const MachineName: string): IExodusMsgOutToolbar;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusMsgOutToolbar) as IExodusMsgOutToolbar;
end;

class function CoExodusDockToolbar.Create: IExodusDockToolbar;
begin
  Result := CreateComObject(CLASS_ExodusDockToolbar) as IExodusDockToolbar;
end;

class function CoExodusDockToolbar.CreateRemote(const MachineName: string): IExodusDockToolbar;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusDockToolbar) as IExodusDockToolbar;
end;

class function CoExodusChat.Create: IExodusChat;
begin
  Result := CreateComObject(CLASS_ExodusChat) as IExodusChat;
end;

class function CoExodusChat.CreateRemote(const MachineName: string): IExodusChat;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusChat) as IExodusChat;
end;

class function CoExodusToolbarButton.Create: IExodusToolbarButton;
begin
  Result := CreateComObject(CLASS_ExodusToolbarButton) as IExodusToolbarButton;
end;

class function CoExodusToolbarButton.CreateRemote(const MachineName: string): IExodusToolbarButton;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusToolbarButton) as IExodusToolbarButton;
end;

class function CoExodusRoster.Create: IExodusRoster;
begin
  Result := CreateComObject(CLASS_ExodusRoster) as IExodusRoster;
end;

class function CoExodusRoster.CreateRemote(const MachineName: string): IExodusRoster;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusRoster) as IExodusRoster;
end;

class function CoExodusAXWindow.Create: IExodusAXWindow;
begin
  Result := CreateComObject(CLASS_ExodusAXWindow) as IExodusAXWindow;
end;

class function CoExodusAXWindow.CreateRemote(const MachineName: string): IExodusAXWindow;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusAXWindow) as IExodusAXWindow;
end;

class function CoExodusItem.Create: IExodusItem;
begin
  Result := CreateComObject(CLASS_ExodusItem) as IExodusItem;
end;

class function CoExodusItem.CreateRemote(const MachineName: string): IExodusItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusItem) as IExodusItem;
end;

class function CoExodusItemController.Create: IExodusItemController;
begin
  Result := CreateComObject(CLASS_ExodusItemController) as IExodusItemController;
end;

class function CoExodusItemController.CreateRemote(const MachineName: string): IExodusItemController;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusItemController) as IExodusItemController;
end;

class function CoExodusTabController.Create: IExodusTabController;
begin
  Result := CreateComObject(CLASS_ExodusTabController) as IExodusTabController;
end;

class function CoExodusTabController.CreateRemote(const MachineName: string): IExodusTabController;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusTabController) as IExodusTabController;
end;

class function CoExodusTab.Create: IExodusTab;
begin
  Result := CreateComObject(CLASS_ExodusTab) as IExodusTab;
end;

class function CoExodusTab.CreateRemote(const MachineName: string): IExodusTab;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusTab) as IExodusTab;
end;

class function CoExodusDataStore.Create: IExodusDataStore;
begin
  Result := CreateComObject(CLASS_ExodusDataStore) as IExodusDataStore;
end;

class function CoExodusDataStore.CreateRemote(const MachineName: string): IExodusDataStore;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusDataStore) as IExodusDataStore;
end;

class function CoExodusDataTable.Create: IExodusDataTable;
begin
  Result := CreateComObject(CLASS_ExodusDataTable) as IExodusDataTable;
end;

class function CoExodusDataTable.CreateRemote(const MachineName: string): IExodusDataTable;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusDataTable) as IExodusDataTable;
end;

class function CoExodusItemList.Create: IExodusItemList;
begin
  Result := CreateComObject(CLASS_ExodusItemList) as IExodusItemList;
end;

class function CoExodusItemList.CreateRemote(const MachineName: string): IExodusItemList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusItemList) as IExodusItemList;
end;

class function CoExodusHistorySearch.Create: IExodusHistorySearch;
begin
  Result := CreateComObject(CLASS_ExodusHistorySearch) as IExodusHistorySearch;
end;

class function CoExodusHistorySearch.CreateRemote(const MachineName: string): IExodusHistorySearch;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusHistorySearch) as IExodusHistorySearch;
end;

class function CoExodusHistoryResult.Create: IExodusHistoryResult;
begin
  Result := CreateComObject(CLASS_ExodusHistoryResult) as IExodusHistoryResult;
end;

class function CoExodusHistoryResult.CreateRemote(const MachineName: string): IExodusHistoryResult;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusHistoryResult) as IExodusHistoryResult;
end;

class function CoExodusHistorySearchManager.Create: IExodusHistorySearchManager;
begin
  Result := CreateComObject(CLASS_ExodusHistorySearchManager) as IExodusHistorySearchManager;
end;

class function CoExodusHistorySearchManager.CreateRemote(const MachineName: string): IExodusHistorySearchManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusHistorySearchManager) as IExodusHistorySearchManager;
end;

class function CoExodusHistorySQLSearchHandler.Create: IExodusHistorySearchHandler;
begin
  Result := CreateComObject(CLASS_ExodusHistorySQLSearchHandler) as IExodusHistorySearchHandler;
end;

class function CoExodusHistorySQLSearchHandler.CreateRemote(const MachineName: string): IExodusHistorySearchHandler;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusHistorySQLSearchHandler) as IExodusHistorySearchHandler;
end;

class function CoExodusActionController.Create: IExodusActionController;
begin
  Result := CreateComObject(CLASS_ExodusActionController) as IExodusActionController;
end;

class function CoExodusActionController.CreateRemote(const MachineName: string): IExodusActionController;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusActionController) as IExodusActionController;
end;

class function CoExodusRosterImages.Create: IExodusRosterImages;
begin
  Result := CreateComObject(CLASS_ExodusRosterImages) as IExodusRosterImages;
end;

class function CoExodusRosterImages.CreateRemote(const MachineName: string): IExodusRosterImages;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusRosterImages) as IExodusRosterImages;
end;

class function CoCOMExodusHover.Create: IExodusHover;
begin
  Result := CreateComObject(CLASS_COMExodusHover) as IExodusHover;
end;

class function CoCOMExodusHover.CreateRemote(const MachineName: string): IExodusHover;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_COMExodusHover) as IExodusHover;
end;

class function CoExodusEventXML.Create: IDispatch;
begin
  Result := CreateComObject(CLASS_ExodusEventXML) as IDispatch;
end;

class function CoExodusEventXML.CreateRemote(const MachineName: string): IDispatch;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusEventXML) as IDispatch;
end;

class function CoexodusController.Create: IExodusController;
begin
  Result := CreateComObject(CLASS_exodusController) as IExodusController;
end;

class function CoexodusController.CreateRemote(const MachineName: string): IExodusController;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_exodusController) as IExodusController;
end;

class function CoMainToolBarImages.Create: IExodusRosterImages;
begin
  Result := CreateComObject(CLASS_MainToolBarImages) as IExodusRosterImages;
end;

class function CoMainToolBarImages.CreateRemote(const MachineName: string): IExodusRosterImages;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MainToolBarImages) as IExodusRosterImages;
end;

class function CoExodusMsg.Create: IExodusMsg;
begin
  Result := CreateComObject(CLASS_ExodusMsg) as IExodusMsg;
end;

class function CoExodusMsg.CreateRemote(const MachineName: string): IExodusMsg;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusMsg) as IExodusMsg;
end;

class function CoExodusToolbar.Create: IExodusToolbar;
begin
  Result := CreateComObject(CLASS_ExodusToolbar) as IExodusToolbar;
end;

class function CoExodusToolbar.CreateRemote(const MachineName: string): IExodusToolbar;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusToolbar) as IExodusToolbar;
end;

class function CoExodusPacketDispatcher.Create: IExodusPacketDispatcher;
begin
  Result := CreateComObject(CLASS_ExodusPacketDispatcher) as IExodusPacketDispatcher;
end;

class function CoExodusPacketDispatcher.CreateRemote(const MachineName: string): IExodusPacketDispatcher;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExodusPacketDispatcher) as IExodusPacketDispatcher;
end;

end.
