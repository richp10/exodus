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
unit AddressList;

{
    The purpose of this unit is to encapsulate JEP-33 Extended Stanza Addressing
    logic.  It can be added to other classes as needed in support of JEP-33.
    See JabberMsg.pas
    See http://www.jabber.org/jeps/jep-0033.html

    TODO: maybe add enumeration/type for type member for validation of values
}
interface
uses
    XmlTag,
    SysUtils,
    JabberConst,
    Classes;

const
    ADDRESS_TYPE_TO = 'to';
    ADDRESS_TYPE_CC = 'cc';
    ADDRESS_TYPE_BCC = 'bcc';
    ADDRESS_TYPE_REPLYTO = 'replyto';
    ADDRESS_TYPE_REPLYROOM = 'replyroom';
    ADDRESS_TYPE_NOREPLY = 'noreply';

    ADDRESS_REPLYTO_JID = '<REPLYTO>';
type

    TJabberAddressList = class(TStringList)
    private
        _tag      : TXMLTag;

    public
        constructor Create; overload;
        constructor Create(mTag: TXMLTag); overload;
        destructor Destroy; override;

        procedure AddAddress(jid: WideString; addrType: WideString = ADDRESS_TYPE_TO);
        function  GetTag(): TXMLTag;
    end;

    TJabberAddress = class
    private
        _toJID  : WideString; // jid attribute
        _uri    : WideString; // uri attribute
        _node   : WideString; // node attribute
        _desc   : WideString; // desc attribute
        _delivered: boolean;  // delivered attribute supplied by server
        _type   : WideString; // type attribute
        _tag      : TXMLTag;
    public
        constructor Create; overload;
        constructor Create(mTag: TXMLTag); overload;
        destructor Destroy; override;

        function GetTag(): TXMLTag;

        property ToJID: WideString read _toJID write _toJID;
        property URI: WideString read _uri write _uri;
        property Node: WideString read _node write _node;
        property Description: WideString read _desc write _desc;
        property AddrType: WideString read _type write _type;
        property WasDelivered: boolean read _delivered write _delivered;
    end;
implementation
{---------------------------------------}
constructor TJabberAddress.Create;
begin
    inherited;
    _toJID := '';
    _uri   := '';
    _node  := '';
    _desc  := '';
    _type  := '';
    _delivered := false;
    _tag   := nil;
end;

{---------------------------------------}
constructor TJabberAddress.Create(mTag: TXMLTag);
var
    tmps: WideString;
begin
        Create();

        _tag := TXMLTag.Create(mTag);

        Self.ToJID := _tag.GetAttribute('jid');
        Self.AddrType := _tag.GetAttribute('type');
        tmps := _tag.GetAttribute('delivered');
        if (AnsiSameText(tmps, 'true')) then
            Self.WasDelivered := true
        else
            Self.WasDelivered := false;

        Self.URI := _tag.GetAttribute('uri');
        Self.Node := _tag.GetAttribute('node');
        Self.Description := _tag.getAttribute('description');
end;

{---------------------------------------}
destructor TJabberAddress.Destroy;
begin
    if (_tag <> nil) then
        _tag.Free();

    inherited;
end;

{---------------------------------------
    Creates an XML representation of an address element.
    It asserts if JID and URI are both set or are both blank.
}
function TJabberAddress.GetTag(): TXMLTag;
begin
    if (_tag <> nil) then begin
        result := TXMLTag.Create(_tag);
        exit;
    end;

    // build a tag based on this
    Result := TXMLTag.Create('address');

    assert(not((ToJID <> '') and (URI <> '')));
    assert(not((ToJID = '') and (URI = '')));
    assert(AddrType <> '');

    // Add relevelant details
    with Result do begin
        setAttribute('type', Self.AddrType);

        // if JID no URI attribute & vise versa
        //little hack here, replyto does not require a JID, use the JID
        //placeholder <REPLYTO> iin place of a jid when adding address
        if (Self.ToJID <> '') and (Self.ToJID <> ADDRESS_REPLYTO_JID) then begin
            setAttribute('jid', Self.ToJID);
            if (Self.Node <> '') then
                setAttribute('node', Self.Node);
        end
        else if (Self.URI <> '') then
            setAttribute('uri', Self.URI);

        if (Self.Description <> '') then
            setAttribute('desc', Self.Description);
    end;
end;

{---------------------------------------}
constructor TJabberAddressList.Create;
begin
    inherited;
    _tag := nil;
end;

{---------------------------------------}
constructor TJabberAddressList.Create(mTag: TXMLTag);
var
    i: integer;
    t: TXMLTag;
    lst: TXMLTagList;
    addr: TJabberAddress;
begin
    // create an addresslist object based on the addresses tag
    Create();

    _tag := TXMLTag.Create(mTag);

    lst := _tag.ChildTags();
    for i:=0 to lst.Count-1 do begin
        t := lst.Tags[i];
        addr := TJabberAddress.Create(t);
        Self.AddObject(addr.ToJID, addr); // add object directly to list
     end;
     lst.Free();
end;

{---------------------------------------}
destructor TJabberAddressList.Destroy;
begin
    if (_tag <> nil) then
        _tag.Free();

    inherited;
end;

{---------------------------------------
    Use this method to add an address to the list.
    The address type defaults to 'to'
}
procedure TJabberAddressList.AddAddress(jid: WideString; addrType: WideString);
var
    addr: TJabberAddress;
begin
    addr := TJabberAddress.Create();
    addr.ToJID := jid;
    addr.AddrType := addrType;
    AddObject(jid, addr);   // add directly to string list since we have an object.
end;

{---------------------------------------
    This method will create an xml representation of an <addresses> tag.
    It will iterate over all Address objects added to this list to add
    their distinctiveness to our own. - bad star trek humor
}
function TJabberAddressList.GetTag(): TXMLTag;
var
    i: integer;
    addr: TJabberAddress;
begin
    if (_tag <> nil) then begin
        result := TXMLTag.Create(_tag);
        exit;
    end;

    // build a tag based on this
    Result := TXMLTag.Create('addresses');
    Result.SetAttribute('xmlns',XMLNS_ADDRESS);

    // add all address objects
    for i:=0 to Self.Count-1 do begin
        addr := TJabberAddress(Self.Objects[i]);
        Result.AddTag(addr.GetTag());
    end;
end;
end.
