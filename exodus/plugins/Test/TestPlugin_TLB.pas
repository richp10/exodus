unit TestPlugin_TLB;

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

// PASTLWTR : 1.2
// File generated on 11/17/2006 1:47:54 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\source\exodus\exodus\plugins\Test\TestPlugin.tlb (1)
// LIBID: {78FCE930-6D97-4E80-A634-59897D6E8BB2}
// LCID: 0
// Helpfile: 
// HelpString: TestPlugin Library
// DepndLst: 
//   (1) v1.0 Exodus, (C:\Program Files\Jabber Inc\Hermes\Hermes.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Exodus_TLB, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  TestPluginMajorVersion = 1;
  TestPluginMinorVersion = 0;

  LIBID_TestPlugin: TGUID = '{78FCE930-6D97-4E80-A634-59897D6E8BB2}';

  IID_ITesterPlugin: TGUID = '{AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}';
  CLASS_TesterPlugin: TGUID = '{DE6D1148-AC93-412F-AF4B-F26C24136D2C}';
  IID_IChatPlugin: TGUID = '{BFA20B37-18C9-4B90-9BD3-B59F856AC625}';
  CLASS_ChatPlugin: TGUID = '{B8EAE0B0-F374-4A7D-9285-52A5389DB3B4}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITesterPlugin = interface;
  ITesterPluginDisp = dispinterface;
  IChatPlugin = interface;
  IChatPluginDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TesterPlugin = IExodusPlugin;
  ChatPlugin = IChatPlugin;


// *********************************************************************//
// Interface: ITesterPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}
// *********************************************************************//
  ITesterPlugin = interface(IExodusPlugin)
    ['{AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}']
  end;

// *********************************************************************//
// DispIntf:  ITesterPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}
// *********************************************************************//
  ITesterPluginDisp = dispinterface
    ['{AE5CDE9B-CFD3-4BE9-9855-C1A1BD52A089}']
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
// Interface: IChatPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BFA20B37-18C9-4B90-9BD3-B59F856AC625}
// *********************************************************************//
  IChatPlugin = interface(IExodusChatPlugin)
    ['{BFA20B37-18C9-4B90-9BD3-B59F856AC625}']
  end;

// *********************************************************************//
// DispIntf:  IChatPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BFA20B37-18C9-4B90-9BD3-B59F856AC625}
// *********************************************************************//
  IChatPluginDisp = dispinterface
    ['{BFA20B37-18C9-4B90-9BD3-B59F856AC625}']
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
// The Class CoTesterPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass TesterPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTesterPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

// *********************************************************************//
// The Class CoChatPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IChatPlugin exposed by              
// the CoClass ChatPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoChatPlugin = class
    class function Create: IChatPlugin;
    class function CreateRemote(const MachineName: string): IChatPlugin;
  end;

implementation

uses ComObj;

class function CoTesterPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_TesterPlugin) as IExodusPlugin;
end;

class function CoTesterPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TesterPlugin) as IExodusPlugin;
end;

class function CoChatPlugin.Create: IChatPlugin;
begin
  Result := CreateComObject(CLASS_ChatPlugin) as IChatPlugin;
end;

class function CoChatPlugin.CreateRemote(const MachineName: string): IChatPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ChatPlugin) as IChatPlugin;
end;

end.
