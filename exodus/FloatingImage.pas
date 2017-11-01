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
unit FloatingImage;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Avatar, ExForm;

type
  TFloatImage = class(TExForm)
    Panel1: TPanel;
    paintAvatar: TPaintBox;
    Timer1: TTimer;
    procedure FormDeactivate(Sender: TObject);
    procedure paintAvatarPaint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    _pRect : TRect;
    _avatar : TAvatar;
    procedure SetParentRect(parentRect: TRect);
    procedure SetAvatar(avatar: TAvatar);
    procedure ResizeAvatar();
  public
    { Public declarations }
    property Avatar: TAvatar read _avatar write SetAvatar;
    property ParentRect: TRect read _pRect write SetParentRect;
  end;

var
  FloatImage: TFloatImage;

implementation

{$R *.dfm}

procedure TFloatImage.ResizeAvatar();
var
  r: TRect;
  m, w, h: integer;
begin
  if (_avatar = nil) then exit;
  if (_pRect.Right = 0) then exit;

  m := Screen.MonitorFromWindow(Self.Handle).MonitorNum;
  r := Screen.Monitors[m].WorkAreaRect;

  w := Abs(r.Right - r.Left);
  h := Abs(r.Bottom - r.Top);

  if _avatar.Height > h - 6 then
    self.Height := h
  else
    self.Height := _avatar.Height + 6;

  if _avatar.Width > w - 6 then
    self.Width := w
  else
    self.Width := _avatar.Width + 6;

  self.Top := _pRect.Bottom + 1;

  if _pRect.Left + self.Width < r.Right then
    self.Left := _pRect.Left
  else if _pRect.left - self.Width > r.Left then
    self.Left := _pRect.Right - self.Width
  else
    self.Left := r.Right;
end;

procedure TFloatImage.SetParentRect(parentRect: TRect);
begin
  _pRect := parentRect;
  ResizeAvatar();
end;

procedure TFloatImage.SetAvatar(avatar: TAvatar);
begin
  _avatar := avatar;
  ResizeAvatar();
end;

procedure TFloatImage.FormDeactivate(Sender: TObject);
begin
  Self.Close();
end;

procedure TFloatImage.paintAvatarPaint(Sender: TObject);
begin
  if (_avatar <> nil) then begin
    _avatar.Draw(paintAvatar.Canvas);
  end;
end;

procedure TFloatImage.FormActivate(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TFloatImage.Timer1Timer(Sender: TObject);
begin
  Self.Close();
end;

end.
