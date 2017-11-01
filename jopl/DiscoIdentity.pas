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
unit DiscoIdentity;

interface
uses
    Unicode, Classes, SysUtils, XMLTag;

type
TDiscoIdentity = class
private
    _lang: Widestring;
    _cat: WideString;
    _type: WideString;
    _name: WideString;
    _key: Widestring;

    function _getName(): WideString;

public
    constructor Create(category: WideString; DiscoType: WideString; Name: WideString; lang: Widestring = ''); overload;
    constructor Create(tag: TXMLTag); overload;

    property Key: Widestring read _key;
    property Category: WideString read _cat;
    property DiscoType: WideString read _type;
    property Language: Widestring read _lang;
    property Name: WideString read _getName;

    function AddTag(owner: TXMLTag): TXMLTag;
end;

implementation

constructor TDiscoIdentity.Create(category: WideString; DiscoType: WideString; Name: WideString; lang: Widestring);
begin
    _cat := Category;
    _type := DiscoType;
    _name := Name;
    _lang := lang;

    _key := _cat + '/' + _type + '/' + _lang + '/' + _name;
end;
constructor TDiscoIdentity.Create(tag: TXMLTag);
begin
    _cat := tag.GetAttribute('category');
    _type := tag.GetAttribute('type');
    _name := tag.getAttribute('name');
    _lang := tag.getAttribute('xml:lang');

    _key := _cat + '/' + _type + '/' + _lang + '/' + _name;
end;

function TDiscoIdentity._getName(): WideString;
begin
    if _name <> '' then begin
        Result := _name;
        exit;
    end;

    Result := _cat + '/' + _type;
end;

function TDiscoIdentity.AddTag(owner: TXMLTag): TXMLTag;
begin
    Result := owner.AddTag('identity');
    Result.setAttribute('category', _cat);
    Result.setAttribute('type', _type);
    if (_name <> '') then Result.setAttribute('name', _name);
    if (_lang <> '') then Result.setAttribute('xml:lang', _lang);
end;


end.
