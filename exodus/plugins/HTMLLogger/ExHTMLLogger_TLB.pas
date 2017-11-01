unit ExHTMLLogger_TLB;

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
// File generated on 1/12/2007 1:30:02 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\source\exodus\exodus\plugins\HTMLLogger\ExHTMLLogger.tlb (1)
// LIBID: {4F0D5848-3AA1-4BCF-9116-870104CA12DD}
// LCID: 0
// Helpfile: 
// HelpString: ExHTMLLogger Library
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
  ExHTMLLoggerMajorVersion = 1;
  ExHTMLLoggerMinorVersion = 0;

  LIBID_ExHTMLLogger: TGUID = '{4F0D5848-3AA1-4BCF-9116-870104CA12DD}';

  CLASS_HTMLLogger: TGUID = '{BA304092-987A-42C3-A4CC-40D196BE1A4F}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  HTMLLogger = IExodusLogger;


// *********************************************************************//
// The Class CoHTMLLogger provides a Create and CreateRemote method to          
// create instances of the default interface IExodusLogger exposed by              
// the CoClass HTMLLogger. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoHTMLLogger = class
    class function Create: IExodusLogger;
    class function CreateRemote(const MachineName: string): IExodusLogger;
  end;

implementation

uses ComObj;

class function CoHTMLLogger.Create: IExodusLogger;
begin
  Result := CreateComObject(CLASS_HTMLLogger) as IExodusLogger;
end;

class function CoHTMLLogger.CreateRemote(const MachineName: string): IExodusLogger;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HTMLLogger) as IExodusLogger;
end;

end.
