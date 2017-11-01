{
    Copyright 2001-2008, Estate of Peter Millard
	
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
unit TesterIQCallback;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Exodus_TLB, ComObj, ActiveX, TestPlugin_TLB, StdVcl;

type
  TTesterIQCallback = class(TAutoObject, IExodusIQListener)
  protected
    procedure ProcessIQ(const Handle, xml: WideString); safecall;
    procedure TimeoutIQ(const Handle: WideString); safecall;

  end;

implementation

uses Dialogs, ComServ;

procedure TTesterIQCallback.ProcessIQ(const Handle, xml: WideString);
begin
    ShowMessage('IQTracker Result: ' + xml);
end;

procedure TTesterIQCallback.TimeoutIQ(const Handle: WideString);
begin
    ShowMessage('IQTracker Timeout!');
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTesterIQCallback, Class_TesterIQCallback,
    ciMultiInstance, tmApartment);
end.
