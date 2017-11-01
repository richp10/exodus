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
unit test_xmltag;

interface

uses
    TestFramework, XMLTag, Classes;

type
    TXMLNodeTest = class(TTestCase)
    private
        tag: TXMLTag;
    protected
        procedure Setup; override;
        procedure TearDown; override;
    published
        procedure testBasicNode;
        procedure testAttributes;
        procedure testXPParse;
        procedure testXPMatch;
        procedure testXPQuery;
        procedure testXPQueryTags;
        procedure testXPQueryData;
    end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
implementation
uses
    LibXmlParser;

{---------------------------------------}
procedure TXMLNodeTest.Setup;
begin

    {
    <message id="1" type="chat" from="test@jabber.org">
      <body>body text</body>
      <subject>subject text</subject>
      <x xmlns="jabber:x:test">x1 tag</x>
      <x>x2 tag</x>
    </message>
    }

    inherited;
    tag := TXMLTag.Create('message');
    with tag do begin
        AddBasicTag('body', 'body text');
        AddBasicTag('subject', 'subject text');
        setAttribute('id', '1');
        setAttribute('type', 'chat');
        setAttribute('from', 'test@jabber.org');

        with AddTag('x') do begin
            AddCData('x1 tag');
            setAttribute('xmlns', 'jabber:x:test');
            end;

        AddBasicTag('x', 'x2 tag');
        end;
end;

{---------------------------------------}
procedure TXMLNodeTest.TearDown;
begin
    tag.Free;
    inherited;
end;

{---------------------------------------}
procedure TXMLNodeTest.testBasicNode;
var
    tt: TXMLTag;
    tl: TXMLTagList;
begin
    // Test some basic properties of the tag.
    CheckEquals('message', tag.Name, 'Tag Name check failed: ');
    CheckEquals(4, tag.ChildTags.Count, 'Number of Children check failed');
    CheckEquals('body text', tag.GetBasicText('body'), 'GetBasicText check failed.');
    CheckNotNull(tag.GetFirstTag('body'), 'GetFirstTag failed. Null Pointer to body tag');

    tt := tag.AddBasicTag('foo', 'first foo tag');
    CheckNotNull(tt, 'AddBasicTag call returned nil.');

    tag.AddBasicTag('foo', 'second foo tag');
    tl := tag.QueryTags('foo');
    CheckEquals(2, tl.Count, 'QueryTags returned incorrect # of tags.');
end;

{---------------------------------------}
procedure TXMLNodeTest.testAttributes;
begin
    // Test some attribute stuff
    Check(tag.GetAttribute('id') = '1', 'ID Attribute check failed');
    Check(tag.GetAttribute('from') = 'test@jabber.org', 'From attribute check failed');
end;

{---------------------------------------}
procedure TXMLNodeTest.testXPParse;
var
    xp: TXPLite;
    xm: TXPMatch;
    cp: TXPPredicate;
begin
    xp := TXPLite.Create();
    xp.Parse('/message/body[@from="test@jabber.org"]');

    CheckEquals(2, xp.XPMatchList.Count, 'XPLite parse failed. Wrong # of Match elements');

    xm := TXPMatch(xp.XPMatchList.Objects[1]);
    CheckEquals(1, xm.PredCount, 'XPLite, Wrong attrcount for the xpmatch.');
    cp := xm.getPredicate(0);
    CheckNotNull(cp, 'XPMatch.getAttribute returned Null.');
    CheckEquals('from', cp.Name, 'XPLite, Attribute has wrong name.');
    CheckEquals('test@jabber.org', cp.Value, 'XPLite, Attribute has wrong value.');
    xp.Free();

    xp := TXPLite.Create();
    xp.Parse('/message/body[@from="test@jabber.org"][!foo]');

    xm := TXPMatch(xp.XPMatchList.Objects[1]);
    CheckEquals(2, xm.PredCount, 'XPLite, Wrong attrcount for the xpmatch.');
    cp := xm.getPredicate(1);
    CheckEquals(integer(XPP_NOTEXISTS), integer(cp.op), 'Wrong operation for Not Exists');
    xp.Free();

end;

{---------------------------------------}
procedure TXMLNodeTest.testXPMatch;
var
    xp: TXPLite;
begin
    // test the XPLite object against our tag
    xp := TXPLite.Create();
    xp.Parse('/message/body');
    Check(xp.Compare(tag), 'XPLite.Compare failed');
    xp.Free();

    xp := TXPLite.Create();
    xp.Parse('/message[@id="1"][!foo]');
    Check(xp.Compare(tag), 'XPLite Compare failed');
    xp.Free();

end;

{---------------------------------------}
procedure TXMLNodeTest.testXPQuery;
begin
    // Test returning a single tag..
    CheckNotNull(tag.QueryXPTag('/message/x'), 'QueryXPTag failed for /message/x');
end;

{---------------------------------------}
procedure TXMLNodeTest.testXPQueryTags;
var
    tl: TXMLTagList;
begin
    // Test fetching a bunch of tags
    tl := tag.QueryXPTags('/message/x');
    CheckEquals(2, tl.Count, 'QueryXPTags check failed.');
end;

{---------------------------------------}
procedure TXMLNodeTest.testXPQueryData;
begin
    // Test fetching data for something..
    CheckEquals('jabber:x:test', tag.QueryXPData('/message/x@xmlns'), 'QueryXPData failed getting an attribute');
    CheckEquals('x1 tagx2 tag', tag.QueryXPData('/message/x'), 'QueryXPData failed getting CDATA');
end;

{---------------------------------------}
initialization
    TestFramework.RegisterTest(TXMLNodeTest.Suite);
end.
