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
unit test_xmlparser;

interface
uses
    TestFramework, XMLParser, Classes;

type
    TXMLParserTest = class(TTestCase)
    private
        parser: TXMLTagParser;
    protected
        procedure Setup; override;
        procedure TearDown; override;
    published
        procedure testUnicode;
        procedure testFileParse;
        procedure testStringParser;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    XMLTag, LibXmlParser;

{---------------------------------------}
procedure TXMLParserTest.Setup;
begin
    //
    parser := TXMLTagParser.Create();
end;

{---------------------------------------}
procedure TXMLParserTest.TearDown;
begin
    //
    parser.Free;
end;

{---------------------------------------}

procedure TXMLParserTest.testFileParse;
var
    t, f: TXMLTag;
begin
    //
    parser.ParseFile('jabber.xml');
    CheckEquals(1, parser.Count, 'Wrong fragment count');

    f := parser.popTag();
    CheckEquals('jabber', f.Name, 'Fragement parent has the wrong name');
    CheckEquals(9, f.ChildTags.Count, 'Wrong child count for the frag parent');
    CheckEquals(4, f.QueryTags('service').Count, 'Wrong # of service tags');
    t := f.GetFirstTag('service');
    CheckNotNull(f, 'GetFirstTag(service) returned null');
    CheckEquals('sessions', t.GetAttribute('id'), 'First session tag has wrong id attr');

    t := f.QueryXPTag('/jabber/service/jsm/filter/max_size');
    CheckNotNull(t, 'Deep QueryXPTag failed. Returned null.');
    CheckEquals('100', f.QueryXPData('/jabber/service/jsm/filter/max_size'),
        'Failed getting deep tag cdata');
end;

{---------------------------------------}
procedure TXMLParserTest.testStringParser;
var
    xml: String;
    f: TXMLTag;
begin
    //
    xml := '<foo xmlns="jabber:client"><bar>bar1</bar><bar>bar2</bar></foo>';
    parser.ParseString(xml, '');

    CheckEquals(1, parser.Count, 'Wrong fragment count');
    f := parser.popTag();

    CheckEquals('foo', f.Name, 'Fragment parent has the wrong name');
end;

{---------------------------------------}
procedure TXMLParserTest.testUnicode;
var
    t, f: TXMLTag;
    c: TXMLTagList;
begin
    parser.ParseFile('unicode.xml');
    CheckEquals(1, parser.Count, 'Wrong fragment count');

    f := parser.popTag();
    CheckEquals('xml', f.Name, 'Tag has the wrong name');

    c := f.ChildTags();
    CheckEquals(2, c.Count, 'Wrong number of child tags');

    t := c[1];
    CheckEquals(3, Length(t.name), 'Wrong length of unicode tag name');
    CheckEquals('wierd', t.getAttribute('attribute'), 'Wrong attribute on unicode tag');

    // Check our Unicode values.
    CheckEquals($5B80, Ord(t.name[1]), 'Wrong first unicode char');
    CheckEquals($5B50, Ord(t.name[2]), 'Wrong second unicode char');
    CheckEquals($5B87, Ord(t.name[3]), 'Wrong second unicode char');


    c.Free();
    f.Free();
end;


{---------------------------------------}
initialization
    TestFramework.RegisterTest(TXMLParserTest.Suite);

end.
