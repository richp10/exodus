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
unit Keywords;
{
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

interface
  uses
    RegExpr;

  function CreateKeywordsExpr(force_show_error: boolean = false): RegExpr.TRegExpr;


implementation
  uses
    Unicode, SysUtils, Session,
    Windows, Dialogs, JabberUtils, Prefs;

  var
    ShowKeywordError: boolean = true;

  //Create TRegExpr based on Keyword Prefs
  //Returns nil when no user-defined keywords or on invalid keyword expression
  function CreateKeywordsExpr(force_show_error: boolean = false) : RegExpr.TRegExpr;
  const
    ERR_MSG_KEYWORDS : Widestring = 'One or more keyword expressions are invalid. Keyword notification will be disabled until your keyword preferences are corrected.';
  var
    kw_list : TWideStringList;
    expr : Widestring;
    regex_keywords : boolean;
    i : integer;
  begin
    if (force_show_error) then
        ShowKeywordError := true;

    Result := nil;
    kw_list := TWideStringList.Create();

    try
      MainSession.Prefs.fillStringlist('keywords', kw_list);

      if (kw_list.Count > 0) then begin
        //We have keywords to process

        //Treat keywords as regular expressions?
        regex_keywords := MainSession.Prefs.getBool('regex_keywords');

        //Build our keyword regular expression text
        expr := '(';

        for i := 0 to kw_list.Count - 1 do begin
          if (i <> 0) then expr := expr + '|';
          if (regex_keywords) then
            expr := expr + kw_list[i]
          else
            expr := expr + QuoteRegExprMetaChars(kw_list[i]);
        end;

        expr := expr + ')';

        //Initialize TRegExpr
        result := RegExpr.TRegExpr.Create();
        result.Expression := expr;
        result.Compile(); //Bad expressions in preferences will cause problems here
      end;
      ShowKeywordError := true;
    except
      FreeAndNil(result);
      if (ShowKeywordError) then begin
          MessageDlgW(ERR_MSG_KEYWORDS,mtError, [mbOK], 0);
          ShowKeywordError := false;
      end;
    end;

    FreeAndNil(kw_list);
  end;

end.
