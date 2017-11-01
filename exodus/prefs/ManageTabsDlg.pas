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
unit ManageTabsDlg;


interface

uses
    Unicode,
    Windows, Messages, SysUtils, Classes, Controls, Forms,
    Dialogs, PrefPanel, ComCtrls, TntComCtrls, TntStdCtrls,
    ExForm, StdCtrls;

type
  TfrmPrefTabs = class(TExForm)
    lstTabs: TTntListView;
    btnCancel: TTntButton;
    btnOK: TTntButton;
    procedure btnOKClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    
  private
     { Private declarations }
      procedure _LoadPrefs();
      procedure _SavePrefs();


  end;


procedure ShowManageTabsDlg(AOwner: TComponent);

implementation
{$R *.dfm}
uses
    ActiveX, COMController, ComObj, Exodus_TLB, Session, PrefController, RosterForm;

procedure ShowManageTabsDlg(AOwner: TComponent);
var
    td: TfrmPrefTabs;
begin
    td := TfrmPrefTabs.create(AOwner);
    td.ShowModal();
    td.Free();
end;

{---------------------------------------}
procedure TfrmPrefTabs.TntFormShow(Sender: TObject);
begin
  inherited;
  _LoadPrefs();
end;

procedure TfrmPrefTabs._LoadPrefs();
var
    i: Integer;
    Item: TTntListItem;
    TabsHidden: TWidestringlist;
begin
    TabsHidden := TWideStringList.Create();
    MainSession.Prefs.fillStringlist('tabs_hidden', TabsHidden);
    for i := 0 to GetRosterWindow().TabController.TabCount - 1 do
    begin
         //Main tab is always shown
         if (GetRosterWindow().TabController.Tab[i].Name = 'Main') then
             continue;

         Item := lstTabs.Items.Add();
         Item.Caption := GetRosterWindow().TabController.Tab[i].Name;
         Item.SubItems.Add(GetRosterWindow().TabController.Tab[i].Description);
         Item.Data := TObject(GetRosterWindow().TabController.Tab[i]);
         Item.Checked :=  (TabsHidden.IndexOf(GetRosterWindow().TabController.Tab[i].Name) = -1);

    end;
      
end;


{---------------------------------------}
procedure TfrmPrefTabs._SavePrefs();
var
    i: integer;
    Item: TTntListItem;
    TabsHidden: TWidestringlist;


begin
    // save all "checked" captions
    TabsHidden := TWidestringlist.Create();

    //All we need to do here is to build the list of hidden tabs
    for i := 0 to lstTabs.Items.Count - 1 do begin
        Item := lstTabs.Items[i];

        if (Item.Checked) then
        begin
           if (IExodusTab(Item.Data).Visible = false) then
               IExodusTab(Item.Data).Show;
        end
        else
        begin
           TabsHidden.Add(Item.Caption);
           IExodusTab(Item.Data).Hide;
        end;
    end;

    MainSession.Prefs.setStringlist('tabs_hidden', TabsHidden);
    TabsHidden.Free();

end;


procedure TfrmPrefTabs.btnOKClick(Sender: TObject);
begin
    inherited;
    _SavePrefs();
end;



end.
