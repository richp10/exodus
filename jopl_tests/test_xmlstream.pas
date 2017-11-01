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
unit test_xmlstream;

interface
uses
    TestFramework, XMLTag, XMLStream, XMLParser, Classes;

type
    TXMLStreamTest = class(TTestCase)
    private
        // stream: TXMLStream;
    protected
        procedure Setup; override;
        procedure TearDown; override;
    published
        procedure StreamCallback(event: string; tag: TXMLTag);
        procedure PushSingleTag;
        procedure PushMultipleTags;
    end;

implementation

procedure TXMLStreamTest.Setup;
begin
    //
end;

procedure TXMLStreamTest.TearDown;
begin
    //
end;

procedure TXMLStreamTest.StreamCallback(event: string; tag: TXMLTag);
begin
    //
end;

procedure TXMLStreamTest.PushSingleTag;
begin
    //
end;

procedure TXMLStreamTest.PushMultipleTags;
begin
    //
end;

end.
