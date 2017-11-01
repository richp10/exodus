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
unit XMLVCard;


interface
uses
    Avatar, XMLTag,
    SysUtils, Classes;

type
    TXMLVCardAddress = class
    public
        work: boolean;
        home: boolean;

        Street: WideString;
        ExtAdr: WideString;
        Locality: WideString;
        Region: WideString;
        PCode: WideString;
        Country: WideString;

        procedure Parse(tag: TXMLTag);
        procedure fillTag(tag: TXMLTag);
end;

    TXMLVCardTel = class
    public
        work: boolean;
        home: boolean;
        voice: boolean;
        fax: boolean;
        pager: boolean;
        cell: boolean;
        number: WideString;

        procedure Parse(tag: TXMLTag);
        procedure fillTag(tag: TXMLTag);
end;

    TXMLVCard = class
    public
        GivenName: WideString;
        FamilyName: WideString;
        MiddleName: WideString;
        nick: WideString;
        email: WideString;
        bday: WideString;
        url: WideString;
        role: WideString;
        desc: WideString;

        OrgName: WideString;
        OrgUnit: WideString;
        OrgTitle: WideString;

        Home: TXMLVCardAddress;
        Work: TXMLVCardAddress;

        HomePhone: TXMLVCardTel;
        HomeFax: TXMLVCardTel;
        HomePager: TXMLVCardTel;
        HomeCell: TXMLVCardTel;
        WorkPhone: TXMLVCardTel;
        WorkFax: TXMLVCardTel;
        WorkPager: TXMLVCardTel;
        WorkCell: TXMLVCardTel;

        Picture: TAvatar;

        TimeStamp: TDateTime;

        constructor Create;
        destructor Destroy; override;

        function Parse(tag: TXMLTag): Boolean; virtual;
        procedure fillTag(tag: TXMLTag; incPicture: Boolean = true); virtual;
end;


implementation

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TXMLVCardAddress.Parse(tag: TXMLTag);
var
    element: TXMLTag;
begin
    // parse a <ADR> tag
    work := false;
    home := false;
    Street := '';
    ExtAdr := '';
    Locality := '';
    Region := '';
    PCode := '';
    Country := '';

    if (tag.GetFirstTag('WORK') <> nil) then
        work := true
    else
        home := true;

    element := tag.GetFirstTag('STREET');
    if element <> nil then Street := element.Data;
    element := tag.GetFirstTag('EXTADD');
    if element <> nil then ExtAdr := element.Data;
    element := tag.GetFirstTag('LOCALITY');
    if element <> nil then Locality := element.Data;
    element := tag.GetFirstTag('REGION');
    if element <> nil then Region := element.Data;
    element := tag.GetFirstTag('PCODE');
    if element <> nil then PCode := element.Data;
    element := tag.GetFirstTag('COUNTRY');
    if element <> nil then
        Country := element.Data
    else begin
        element := tag.GetFirstTag('CNTRY');
        if (element <> nil) then
            Country := element.Data
        else begin
            element := tag.GetFirstTag('CTRY');
            if (element <> nil) then Country := element.Data;
        end;
    end;

end;

{---------------------------------------}
procedure TXMLVCardAddress.fillTag(tag: TXMLTag);
begin
    //
    tag.Name := 'ADR';
    tag.AddBasicTag('STREET', Street);
    tag.AddBasictag('EXTADD', ExtAdr);
    tag.AddBasicTag('LOCALITY', Locality);
    tag.AddBasicTag('REGION', Region);
    tag.AddBasicTag('PCODE', PCode);
    tag.AddBasicTag('COUNTRY', Country);

    if work then tag.AddTag('WORK');
    if home then tag.AddTag('HOME');
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
procedure TXMLVCardTel.Parse(tag: TXMLTag);
var
    n: TXMLTag;
begin
    // parse a <TEL> tag
    work := false;
    home := false;
    fax := false;
    voice := false;
    pager := false;
    cell := false;
    number := '';

    if tag.GetFirstTag('WORK') <> nil then
        work := true
    else
        home := true;

    if tag.GetFirstTag('VOICE') <> nil then
        voice := true
    else if tag.GetFirstTag('FAX') <> nil then
        fax := true
    else
        pager := true ;


    n := tag.GetFirstTag('NUMBER');
    if (n = nil) then begin
        n := tag.GetFirstTag('NUM');
        if (n = nil) then
            number := tag.Data
        else
            number := n.Data
    end
    else
        number := n.Data;
end;

{---------------------------------------}
procedure TXMLVCardTel.fillTag(tag: TXMLTag);
begin
    //
    if work then tag.AddTag('WORK');
    if home then tag.AddTag('HOME');
    if voice then
        tag.AddTag('VOICE')
    else if fax then
        tag.AddTag('FAX')
    else
        tag.AddTag('PAGER');

    tag.AddBasicTag('NUMBER', number);
end;

{---------------------------------------}
{---------------------------------------}
{---------------------------------------}
constructor TXMLVCard.Create;
begin
    inherited;

    timestamp := Now();

    GivenName := '';
    FamilyName := '';
    MiddleName := '';
    nick := '';
    email := '';
    bday := '';
    url := '';
    role := '';
    OrgName := '';
    OrgUnit := '';
    OrgTitle := '';
    Desc := '';

    Home := TXMLVCardAddress.Create();
    Work := TXMLVCardAddress.Create();

    HomePhone := TXMLVCardTel.Create();
    with HomePhone do begin
        home := true; work := false; voice := true; fax := false; pager := false; cell := false;
    end;
    HomeFax := TXMLVCardTel.Create();
    with HomeFax do begin
        home := true; work := false; voice := false; fax := true; pager := false; cell := false;
    end;
    HomePager := TXMLVCardTel.Create();
    with HomePager do begin
        home := true; work := false; voice := false; fax := false; pager := true; cell := false;
    end;
    HomeCell := TXMLVCardTel.Create();
    with HomeCell do begin
        home := true; work := false; voice := false; fax := false; pager := false; cell := true;
    end;
    WorkPhone := TXMLVCardTel.Create();
    with WorkPhone do begin
        home := false; work := true; voice := true; fax := false; pager := false; cell := false;
    end;
    WorkFax := TXMLVCardTel.Create();
    with WorkFax do begin
        home := false; work := true; voice := false; fax := true;  pager := false; cell := false;
    end;
    WorkPager := TXMLVCardTel.Create();
    with WorkPager do begin
        home := false; work := true; voice := false; fax := false;  pager := true; cell := false;
    end;
    WorkCell := TXMLVCardTel.Create();
    with WorkCell do begin
        home := false; work := true; voice := false; fax := false;  pager := false; cell := true;
    end;
end;

{---------------------------------------}
destructor TXMLVCard.Destroy;
begin
    Home.Free;
    Work.Free;

    HomePhone.Free;
    HomeFax.Free;
    HomePager.Free;
    HomeCell.Free;
    WorkPhone.Free;
    WorkFax.Free;
    WorkPager.Free;
    WorkCell.Free;
    
    inherited destroy;
end;

{---------------------------------------}
function TXMLVCard.Parse(tag: TXMLTag): Boolean;
var
    vtag, t1, t2: TXMLTag;
    a: TXMLVCardAddress;
    t: TXMLVCardTel;
    tags: TXMLTagList;
    i: integer;
begin
    result := false;
    
    vtag := tag.GetFirstTag('vcard');
    if (vtag = nil) then
        vtag := tag.GetFirstTag('VCARD');
    if (vtag = nil) then
        vtag := tag.GetFirstTag('vCard');
    if (vtag = nil) then
        vtag := tag.GetFirstTag('query');
    if vtag = nil then exit;

    if (vtag.ChildCount = 0) then exit;

    // Parse the name
    t1 := vtag.GetFirstTag('N');
    if t1 <> nil then begin
        t2 := t1.GetFirstTag('GIVEN');
        if t2 <> nil then GivenName := t2.Data;
        t2 := t1.GetFirstTag('FAMILY');
        if t2 <> nil then FamilyName := t2.Data;
        t2 := t1.GetFirstTag('MIDDLE');
        if t2 <> nil then MiddleName := t2.Data;
    end;

    // Get Nick
    t1 := vtag.GetFirstTag('NICKNAME');
    if t1 <> nil then nick := t1.Data;

    // get primary email addy
    t1 := vtag.GetFirstTag('EMAIL');
    if t1 <> nil then Email := t1.Data;

    // get picture
    t1 := vtag.GetFirstTag('PHOTO');
    if (t1 <> nil) then begin
        if (Picture <> nil) then FreeAndNil(Picture);
        Picture := TAvatar.Create();
        Picture.parse(t1);
    end;

    // get personal info
    t1 := vtag.GetFirstTag('URL');
    if t1 <> nil then url := t1.Data;
    t1 := vtag.GetFirstTag('ROLE');
    if t1 <> nil then role := t1.Data;
    t1 := vtag.GetFirstTag('BDAY');
    if t1 <> nil then bday := t1.Data;
    t1 := vtag.GetFirstTag('TITLE');
    if t1 <> nil then OrgTitle := t1.Data;

    t1 := vtag.GetFirstTag('ORG');
    if t1 <> nil then begin
        t2 := t1.GetFirstTag('ORGNAME');
        if t2 <> nil then OrgName := t2.Data;
        t2 := t1.GetFirstTag('ORGUNIT');
        if t2 <> nil then OrgUnit := t2.Data;
        t2 := t1.GetFirstTag('DESC');
        if (t2 <> nil) then Desc := t2.Data;
    end;

    tags := vtag.QueryTags('ADR');
    for i := 0 to tags.Count - 1 do begin
        a := TXMLVCardAddress.Create();
        a.parse(tags[i]);

        if a.work then
            work.parse(tags[i])
        else
            home.parse(tags[i]);
        a.Free();
    end;
    tags.Free();

    tags := vtag.QueryTags('TEL');
    for i := 0 to tags.Count - 1 do begin
        t := TXMLVCardTel.Create();
        t.parse(tags[i]);

        if (t.work) then begin
            if t.fax then
                WorkFax.parse(tags[i])
            else if t.pager then
                WorkPager.parse(tags[i])
            else
                WorkPhone.Parse(tags[i]);
        end
        else begin
            if t.fax then
                HomeFax.Parse(tags[i])
            else if t.pager then
                HomePager.Parse(tags[i])
            else
                HomePhone.Parse(tags[i]);
        end;
        t.Free();
    end;
    tags.Free();

    t1 := vtag.GetFirstTag('HOMECELL');
    if t1 <> nil then HomeCell.number := t1.Data;
    
    t1 := vtag.GetFirstTag('WORKCELL');
    if t1 <> nil then WorkCell.number := t1.Data;

    Result := true;
end;

{---------------------------------------}
procedure TXMLVCard.fillTag(tag: TXMLTag; incPicture: Boolean);
var
    e, vtag, t1, t2: TXMLTag;
begin
    //
    vtag := tag.AddTag('vCard');
    vtag.setAttribute('xmlns', 'vcard-temp');

    t1 := vtag.AddTag('N');
    t1.AddBasicTag('GIVEN', GivenName);
    t1.AddBasicTag('FAMILY', FamilyName);
    t1.AddBasicTag('MIDDLE', MiddleName);

    vtag.AddBasicTag('NICKNAME', nick);

    e := vtag.AddBasicTag('EMAIL', email);
    e.AddTag('INTERNET');
    e.AddTag('PREF');

    vtag.AddBasicTag('URL', url);
    vtag.AddBasicTag('ROLE', role);
    vtag.AddBasicTag('BDAY', bday);
    vtag.AddBasicTag('TITLE', OrgTitle);

    t1 := vtag.AddTag('ORG');
    t1.AddBasicTag('ORGNAME', OrgName);
    t1.AddBasicTag('ORGUNIT', OrgUnit);
    t1.AddBasicTag('DESC', Desc);

    t1 := vtag.AddTag('ADR');
    Home.fillTag(t1);
    t1 := vtag.AddTag('ADR');
    Work.fillTag(t1);

    t1 := vtag.AddTag('TEL');
    HomePhone.fillTag(t1);
    t1 := vtag.AddTag('TEL');
    HomeFax.fillTag(t1);
    t1 := vtag.AddTag('TEL');
    HomePager.fillTag(t1);
    t1 := vtag.AddTag('TEL');
    WorkPhone.fillTag(t1);
    t1 := vtag.AddTag('TEL');
    WorkFax.fillTag(t1);
    t1 := vtag.AddTag('TEL');
    WorkPager.fillTag(t1);
    vtag.AddBasicTag('WORKCELL', WorkCell.number);
    vtag.AddBasicTag('HOMECELL', HomeCell.number);
    
    // Serialize the photo
    if (incPicture and (Picture <> nil) and (Picture.Valid)) then begin
        t1 := vtag.AddTag('PHOTO');
        t2 := t1.AddTag('TYPE');
        t2.AddCData(Picture.MimeType);

        t2 := t1.AddTag('BINVAL');
        t2.AddCData(Picture.Data)
    end;

end;

{---------------------------------------}

end.
