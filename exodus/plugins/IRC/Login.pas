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
unit Login;

interface

uses
    Exodus_TLB,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, buttonFrame;

type
  TfrmStartSession = class(TForm)
    Label1: TLabel;
    txtServer: TEdit;
    Label2: TLabel;
    txtPort: TEdit;
    Label3: TLabel;
    txtNickname: TEdit;
    Label4: TLabel;
    txtAlt: TEdit;
    frameButtons1: TframeButtons;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStartSession: TfrmStartSession;

implementation

{$R *.dfm}

end.
