unit ExIRCPlugin_TLB;

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
// File generated on 8/24/2006 1:42:04 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: ExIRCPlugin.tlb (1)
// LIBID: {467946CF-A73A-4084-B226-57C0FA897CBF}
// LCID: 0
// Helpfile: 
// HelpString: ExIRCPlugin Library
// DepndLst: 
//   (1) v1.0 Exodus, (C:\Projects\Devel\Clients\Hermes\bin\Exodus.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TIRCPlugin) : No Server registered for this CoClass
//   Error creating palette bitmap of (TIRCRoomPlugin) : No Server registered for this CoClass
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Exodus_TLB, Graphics, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExIRCPluginMajorVersion = 1;
  ExIRCPluginMinorVersion = 0;

  LIBID_ExIRCPlugin: TGUID = '{467946CF-A73A-4084-B226-57C0FA897CBF}';

  CLASS_IRCPlugin: TGUID = '{5B2D612D-7F76-4496-A6C6-6E7187D1F57F}';
  CLASS_IRCRoomPlugin: TGUID = '{1D9F8982-BCDC-49FF-95C9-B87BAE450977}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  IRCPlugin = IExodusPlugin;
  IRCRoomPlugin = IExodusChatPlugin;


// *********************************************************************//
// The Class CoIRCPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass IRCPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoIRCPlugin = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TIRCPlugin
// Help String      : IRCPlugin Object
// Default Interface: IExodusPlugin
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TIRCPluginProperties= class;
{$ENDIF}
  TIRCPlugin = class(TOleServer)
  private
    FIntf: IExodusPlugin;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TIRCPluginProperties;
    function GetServerProperties: TIRCPluginProperties;
{$ENDIF}
    function GetDefaultInterface: IExodusPlugin;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IExodusPlugin);
    procedure Disconnect; override;
    procedure Startup(const exodusController: IExodusController);
    procedure Shutdown;
    procedure Process(const xpath: WideString; const event: WideString; const XML: WideString);
    procedure NewChat(const JID: WideString; const chat: IExodusChat);
    procedure NewRoom(const JID: WideString; const room: IExodusChat);
    function NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                   const xTags: WideString): WideString;
    procedure Configure;
    procedure NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat);
    property DefaultInterface: IExodusPlugin read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TIRCPluginProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TIRCPlugin
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TIRCPluginProperties = class(TPersistent)
  private
    FServer:    TIRCPlugin;
    function    GetDefaultInterface: IExodusPlugin;
    constructor Create(AServer: TIRCPlugin);
  protected
  public
    property DefaultInterface: IExodusPlugin read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoIRCRoomPlugin provides a Create and CreateRemote method to          
// create instances of the default interface IExodusChatPlugin exposed by              
// the CoClass IRCRoomPlugin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoIRCRoomPlugin = class
    class function Create: IExodusChatPlugin;
    class function CreateRemote(const MachineName: string): IExodusChatPlugin;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TIRCRoomPlugin
// Help String      : IRCRoomPlugin Object
// Default Interface: IExodusChatPlugin
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TIRCRoomPluginProperties= class;
{$ENDIF}
  TIRCRoomPlugin = class(TOleServer)
  private
    FIntf: IExodusChatPlugin;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TIRCRoomPluginProperties;
    function GetServerProperties: TIRCRoomPluginProperties;
{$ENDIF}
    function GetDefaultInterface: IExodusChatPlugin;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IExodusChatPlugin);
    procedure Disconnect; override;
    function OnBeforeMessage(var Body: WideString): WordBool;
    function OnAfterMessage(var Body: WideString): WideString;
    procedure OnClose;
    procedure OnNewWindow(hwnd: Integer);
    function OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool;
    procedure OnAfterRecvMessage(var Body: WideString);
    function OnKeyUp(key: Integer; shiftState: Integer): WordBool;
    function OnKeyDown(key: Integer; shiftState: Integer): WordBool;
    property DefaultInterface: IExodusChatPlugin read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TIRCRoomPluginProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TIRCRoomPlugin
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TIRCRoomPluginProperties = class(TPersistent)
  private
    FServer:    TIRCRoomPlugin;
    function    GetDefaultInterface: IExodusChatPlugin;
    constructor Create(AServer: TIRCRoomPlugin);
  protected
  public
    property DefaultInterface: IExodusChatPlugin read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoIRCPlugin.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_IRCPlugin) as IExodusPlugin;
end;

class function CoIRCPlugin.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_IRCPlugin) as IExodusPlugin;
end;

procedure TIRCPlugin.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5B2D612D-7F76-4496-A6C6-6E7187D1F57F}';
    IntfIID:   '{6D6CCD11-2FAA-4CCB-92CA-CAB14A3BE234}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TIRCPlugin.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IExodusPlugin;
  end;
end;

procedure TIRCPlugin.ConnectTo(svrIntf: IExodusPlugin);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TIRCPlugin.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TIRCPlugin.GetDefaultInterface: IExodusPlugin;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TIRCPlugin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TIRCPluginProperties.Create(Self);
{$ENDIF}
end;

destructor TIRCPlugin.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TIRCPlugin.GetServerProperties: TIRCPluginProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TIRCPlugin.Startup(const exodusController: IExodusController);
begin
  DefaultInterface.Startup(exodusController);
end;

procedure TIRCPlugin.Shutdown;
begin
  DefaultInterface.Shutdown;
end;

procedure TIRCPlugin.Process(const xpath: WideString; const event: WideString; const XML: WideString);
begin
  DefaultInterface.Process(xpath, event, XML);
end;

procedure TIRCPlugin.NewChat(const JID: WideString; const chat: IExodusChat);
begin
  DefaultInterface.NewChat(JID, chat);
end;

procedure TIRCPlugin.NewRoom(const JID: WideString; const room: IExodusChat);
begin
  DefaultInterface.NewRoom(JID, room);
end;

function TIRCPlugin.NewIM(const JID: WideString; var Body: WideString; var Subject: WideString; 
                          const xTags: WideString): WideString;
begin
  Result := DefaultInterface.NewIM(JID, Body, Subject, xTags);
end;

procedure TIRCPlugin.Configure;
begin
  DefaultInterface.Configure;
end;

procedure TIRCPlugin.NewOutgoingIM(const JID: WideString; const instantMsg: IExodusChat);
begin
  DefaultInterface.NewOutgoingIM(JID, instantMsg);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TIRCPluginProperties.Create(AServer: TIRCPlugin);
begin
  inherited Create;
  FServer := AServer;
end;

function TIRCPluginProperties.GetDefaultInterface: IExodusPlugin;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoIRCRoomPlugin.Create: IExodusChatPlugin;
begin
  Result := CreateComObject(CLASS_IRCRoomPlugin) as IExodusChatPlugin;
end;

class function CoIRCRoomPlugin.CreateRemote(const MachineName: string): IExodusChatPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_IRCRoomPlugin) as IExodusChatPlugin;
end;

procedure TIRCRoomPlugin.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{1D9F8982-BCDC-49FF-95C9-B87BAE450977}';
    IntfIID:   '{E28E487A-7258-4B32-AD1C-F23A808F0460}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TIRCRoomPlugin.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IExodusChatPlugin;
  end;
end;

procedure TIRCRoomPlugin.ConnectTo(svrIntf: IExodusChatPlugin);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TIRCRoomPlugin.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TIRCRoomPlugin.GetDefaultInterface: IExodusChatPlugin;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TIRCRoomPlugin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TIRCRoomPluginProperties.Create(Self);
{$ENDIF}
end;

destructor TIRCRoomPlugin.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TIRCRoomPlugin.GetServerProperties: TIRCRoomPluginProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TIRCRoomPlugin.OnBeforeMessage(var Body: WideString): WordBool;
begin
  Result := DefaultInterface.OnBeforeMessage(Body);
end;

function TIRCRoomPlugin.OnAfterMessage(var Body: WideString): WideString;
begin
  Result := DefaultInterface.OnAfterMessage(Body);
end;

procedure TIRCRoomPlugin.OnClose;
begin
  DefaultInterface.OnClose;
end;

procedure TIRCRoomPlugin.OnNewWindow(hwnd: Integer);
begin
  DefaultInterface.OnNewWindow(hwnd);
end;

function TIRCRoomPlugin.OnBeforeRecvMessage(const Body: WideString; const XML: WideString): WordBool;
begin
  Result := DefaultInterface.OnBeforeRecvMessage(Body, XML);
end;

procedure TIRCRoomPlugin.OnAfterRecvMessage(var Body: WideString);
begin
  DefaultInterface.OnAfterRecvMessage(Body);
end;

function TIRCRoomPlugin.OnKeyUp(key: Integer; shiftState: Integer): WordBool;
begin
  Result := DefaultInterface.OnKeyUp(key, shiftState);
end;

function TIRCRoomPlugin.OnKeyDown(key: Integer; shiftState: Integer): WordBool;
begin
  Result := DefaultInterface.OnKeyDown(key, shiftState);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TIRCRoomPluginProperties.Create(AServer: TIRCRoomPlugin);
begin
  inherited Create;
  FServer := AServer;
end;

function TIRCRoomPluginProperties.GetDefaultInterface: IExodusChatPlugin;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TIRCPlugin, TIRCRoomPlugin]);
end;

end.
