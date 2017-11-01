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
unit TopStatusFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TntStdCtrls;

type
  TExodusStatusFrame = class(TFrame)
    imgHeader: TImage;
    bvlBottom: TBevel;
    lblTitle: TTntLabel;
    lblStatus: TTntLabel;
    procedure imgHeaderEndDock(Sender, Target: TObject; X, Y: Integer);
  private
    procedure setTitle(title : WideString);
    function getTitle() : WideString;
    procedure setStatus(status : WideString);
    function getStatus() : WideString;
  published
    property Title : WideString read getTitle write setTitle;
    property Status : WideString read getStatus write setStatus;
  end;

  procedure Register;
{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation

{$R *.dfm}
{component registration}
{---------------------------------------}
procedure Register;
begin
  RegisterComponents('Exodus Components', [TExodusStatusFrame]);
end;

{getters and setters for general frame props}
{---------------------------------------}
procedure TExodusStatusFrame.setTitle(title :WideString);
begin
    lblTitle.Caption := title;
end;

{---------------------------------------}
function TExodusStatusFrame.getTitle;
begin
    result := lblTitle.Caption;
end;

procedure TExodusStatusFrame.imgHeaderEndDock(Sender, Target: TObject; X, Y: Integer);
begin
    inherited;
end;

{---------------------------------------}
procedure TExodusStatusFrame.setStatus(status :WideString);
begin
    lblStatus.Caption := status;
end;

{---------------------------------------}
function TExodusStatusFrame.getStatus;
begin
    result := lblStatus.Caption;
end;

end.
