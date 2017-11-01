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
unit GroupParser;



interface

uses RegExpr, Unicode;

type
   TGroupParser = class
   private
       _GroupSeparator: WideString;
       _Session: TObject;
   public
       constructor Create(Session: TObject);
       function GetNestedGroups(Group: WideString): TWideStringList;
       function GetGroupName(Group: WideString): WideString;
       function GetGroupParent(Group: WideString): WideString;
       function ParseGroupName(Group: WideString): TWideStringList;
       function BuildNestedGroupList(Groups: TWideStringList): TWideStringList;

       property Separator: Widestring read _GroupSeparator;
   end;

implementation

uses
    Session,
    StrUtils,
    SysUtils;

{---------------------------------------}
constructor TGroupParser.Create(Session: TObject);
begin
   _Session := Session;

   _GroupSeparator := TJabberSession(_Session).Prefs.getString('group_separator');
end;

{---------------------------------------}
function TGroupParser.GetNestedGroups(Group: WideString): TWideStringList;
var
    Groups: TWideStringList;
begin
    Groups := ParseGroupName(Group);
    Result := BuildNestedGroupList(Groups);
    Groups.Free;
end;

{---------------------------------------}
//This function will use regular expression to parse group strings in
//format a/b/c or /a/b/c or /a/b/c/  and will return node with the name
//matching the passed string in the above format.
function TGroupParser.ParseGroupName(Group: WideString): TWideStringList;
var
    sep: Widestring;
    sepoffset: integer;
    temp, temp2: widestring;
begin
    Result := TWideStringList.Create();

    sep := TJabberSession(_Session).Prefs.getString('group_separator');

    temp := Trim(Group);
    if (TJabberSession(_Session).Prefs.getBool('nested_groups') and
        TJabberSession(_Session).prefs.getBool('branding_nested_subgroup') and
        (sep <> '')) then
    begin
        sepoffset := Pos(sep, temp);
        while (sepoffset > 0) do
        begin
            if (sepoffset = 1) then
            begin
                // sep should never be at the start.
                // usually indicates a double sep which we will silently eat.
                temp := Trim(MidStr(temp, 2, Length(temp)));
            end
            else begin
                temp2 := Trim(LeftStr(temp, sepoffset - 1));
                if (temp2 <> '') then
                begin
                    Result.Add(temp2);
                end;
                temp := Trim(MidStr(temp, sepoffset + 1, Length(temp)));
            end;

            sepoffset := Pos(sep, temp);
        end;
    end;
    if (temp <> '') then
    begin
        Result.Add(temp);
    end;
end;

{---------------------------------------}
//Builds the list of all nested subgroups for the group
//Takes list in the format 'a','b','c' and builds '/a','/a/b','/a/b/c'
function TGroupParser.BuildNestedGroupList(Groups: TWideStringList): TWideStringList;
var
    i: Integer;
    GroupName: WideString;
begin
   Result := TWideStringList.Create();
   GroupName := '';
   for i := 0 to Groups.Count - 1 do
   begin
       if (i <> 0) then
         GroupName :=  GroupName + _GroupSeparator;
       GroupName := GroupName + Groups[i];
       Result.Add(GroupName);
   end;
end;

{---------------------------------------}
//Returns groups name based on UID
//For uid "/a/b/c" name would be "c"
function TGroupParser.GetGroupName(Group: WideString): WideString;
var
    Groups: TWideStringList;
begin
    Groups := ParseGroupName(Group);
    Result := Groups[Groups.Count -1];
    Groups.Free();
end;

{---------------------------------------}
//Returns groups name based on UID
//For uid "/a/b/c" name would be "c"
function TGroupParser.GetGroupParent(Group: WideString): WideString;
var
    Groups, GroupList: TWideStringList;
begin
    Result := '';
    Groups := ParseGroupName(Group);
    Groups.Delete(Groups.Count -1 );
    GroupList := BuildNestedGroupList(Groups);
    if (GroupList.Count > 0) then
       Result := GroupList[GroupList.Count - 1];

    Groups.Free();
    GroupList.Free();
end;
end.
