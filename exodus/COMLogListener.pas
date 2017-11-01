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
unit COMLogListener;


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Exodus_TLB, StdVcl;

type
  TExodusLogListener = class(TAutoObject, IExodusLogListener)
  protected
    procedure EndMessages(Day, Month, Year: Integer); safecall;
    procedure Error(Day, Month, Year: Integer); safecall;
    procedure ProcessMessages(Count: Integer; Messages: PSafeArray); safecall;
    procedure ProcessDates(Count: Integer; Dates: PSafeArray); safecall;

  end;

implementation

uses ComServ;

procedure TExodusLogListener.EndMessages(Day, Month, Year: Integer);
begin

end;

procedure TExodusLogListener.Error(Day, Month, Year: Integer);
begin

end;

procedure TExodusLogListener.ProcessMessages(Count: Integer;
  Messages: PSafeArray);
begin

end;

procedure TExodusLogListener.ProcessDates(Count: Integer;
  Dates: PSafeArray);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TExodusLogListener, Class_ExodusLogListener,
    ciMultiInstance, tmApartment);
end.
