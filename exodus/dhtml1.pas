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
unit dhtml1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, DHTMLEDLib_TLB, StdCtrls;

type
  TForm1 = class(TForm)
    html1: TDHTMLEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    count: longint;
    content: string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
    h, x: string;
    tags, last: OleVariant;
begin
    inc(count);
    x := x + '<div id="' + IntToStr(count) + '"><span style="color:red">&lt;foo&gt;</span>';
    x := x + 'this is some text here ' + IntToStr(count) + '</div>';
    html1.DOM.body.insertAdjacentHTML('beforeEnd', x);

    // fetch the last tag from the body children
    tags := html1.DOM.body.children;
    last := tags.Item(tags.length - 1);

    last.ScrollIntoView;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    h: string;
begin
    h := '<html>';
    h := h + '<body style="margin: 1px;"></body>';
    h := h + '</html>';
    html1.DocumentHTML := h;
end;

end.
