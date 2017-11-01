unit ExWordSpeller_TLB;

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
// File generated on 4/2/2003 11:18:17 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\src\exodus\exodus\plugins\MSWordSpeller\ExWordSpeller.tlb (1)
// LIBID: {ADD14710-280B-4B21-8AA5-DC33EC6B1C4B}
// LCID: 0
// Helpfile: 
// HelpString: Spell check using the MS Word spell checker
// DepndLst: 
//   (1) v1.0 ExodusCOM, (D:\src\exodus\exodus\Exodus.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, ExodusCOM_TLB, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExWordSpellerMajorVersion = 1;
  ExWordSpellerMinorVersion = 0;

  LIBID_ExWordSpeller: TGUID = '{ADD14710-280B-4B21-8AA5-DC33EC6B1C4B}';

  CLASS_WordSpeller: TGUID = '{DD794B33-096B-4B73-93F1-AD85F372B395}';
  CLASS_ChatSpeller: TGUID = '{F3A13654-7BF1-4FE2-99BC-3ECB5B5E7B15}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  WordSpeller = IExodusPlugin;
  ChatSpeller = IExodusChatPlugin;


// *********************************************************************//
// The Class CoWordSpeller provides a Create and CreateRemote method to          
// create instances of the default interface IExodusPlugin exposed by              
// the CoClass WordSpeller. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoWordSpeller = class
    class function Create: IExodusPlugin;
    class function CreateRemote(const MachineName: string): IExodusPlugin;
  end;

// *********************************************************************//
// The Class CoChatSpeller provides a Create and CreateRemote method to          
// create instances of the default interface IExodusChatPlugin exposed by              
// the CoClass ChatSpeller. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoChatSpeller = class
    class function Create: IExodusChatPlugin;
    class function CreateRemote(const MachineName: string): IExodusChatPlugin;
  end;

implementation

uses ComObj;

class function CoWordSpeller.Create: IExodusPlugin;
begin
  Result := CreateComObject(CLASS_WordSpeller) as IExodusPlugin;
end;

class function CoWordSpeller.CreateRemote(const MachineName: string): IExodusPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WordSpeller) as IExodusPlugin;
end;

class function CoChatSpeller.Create: IExodusChatPlugin;
begin
  Result := CreateComObject(CLASS_ChatSpeller) as IExodusChatPlugin;
end;

class function CoChatSpeller.CreateRemote(const MachineName: string): IExodusChatPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ChatSpeller) as IExodusChatPlugin;
end;

end.
