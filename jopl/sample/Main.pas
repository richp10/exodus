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
unit Main;

interface

uses
    Presence, XMLTag,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    txtServer: TEdit;
    Label2: TLabel;
    txtUsername: TEdit;
    Label3: TLabel;
    txtPassword: TEdit;
    Label4: TLabel;
    txtResource: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure DebugCallback(event: string; tag: TXMLTag; data: WideString);
    procedure SessionCallback(event: string; tag: TXMLTag);
//    procedure RosterCallback(event: string; tag: TXMLTag; roster_item: TJabberRosterItem);
    procedure PresenceCallback(event: string; tag: TXMLTag; p: TJabberPres);

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
    PrefController, StandardAuth, Session;

procedure TForm1.FormCreate(Sender: TObject);
var
    config_file: string;
    auth: TStandardAuth;
begin
    // Create some the main session and associated objects

    config_file := ExtractFilePath(Application.EXEName) + 'jopl-sample.xml';

    MainSession := TJabberSession.Create(config_file);
    auth := TStandardAuth.Create(MainSession);
    MainSession.setAuthAgent(auth);

    MainSession.Prefs.LoadProfiles();
    if (MainSession.Prefs.Profiles.Count = 0) then
        MainSession.Prefs.CreateProfile('Default Profile');

    MainSession.ActivateProfile(0);
    with MainSession.Profile do begin
        txtServer.Text := Server;
        txtUsername.Text := Username;
        txtPassword.Text := password;
        txtResource.Text := Resource;
    end;

    MainSession.RegisterCallback(DebugCallback);
    MainSession.RegisterCallback(SessionCallback, '/session');
    //MainSession.RegisterCallback(RosterCallback);
    MainSession.RegisterCallback(PresenceCallback);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    // Save the profile, and try to connect.
    with MainSession.Profile do begin
        Server := txtServer.Text;
        Username := txtUsername.Text;
        password := txtPassword.Text;
        Resource := txtResource.Text;
    end;
    MainSession.Prefs.SaveProfiles();

    Memo1.Lines.Clear();
    ListBox1.Items.Clear();
    MainSession.Connect();
end;

procedure TForm1.DebugCallback(event: string; tag: TXMLTag; data: WideString);
begin
    // we are getting something from the socket
    if (event = '/data/send') then
        Memo1.Lines.Add('SENT: ' + data)
    else
        Memo1.Lines.Add('RECV: ' + data);
end;

procedure TForm1.SessionCallback(event: string; tag: TXMLTag);
begin
    // We are getting some kind of session event
    if (event = '/session/authenticated') then begin
        // fetch the roster if we're auth'd
        MainSession.roster.Fetch();

        // make ourself available..
        MainSession.setPresence('', 'online', 0);
    end;
end;

//procedure TForm1.RosterCallback(event: string; tag: TXMLTag; roster_item: TJabberRosterItem);
//var
//    itm_index: integer;
//begin
//    // we are getting some kind of roster item
//    // store a reference to the roster item in the listbox's item
//    // this way, we can find them.
//
//    if (event = '/roster/start') then
//        Listbox1.Items.Clear
//    else if (event = '/roster/end') then exit
//    else if ((event = '/roster/item') and (roster_item <> nil)) then begin
//        itm_index := Listbox1.Items.IndexOfObject(roster_item);
//        if (itm_index = -1) then
//            itm_index := Listbox1.Items.AddObject('', roster_item);
//
//        if (roster_item.Nickname <> '') then
//            // if the roster item has a nickname, show it
//            Listbox1.Items[itm_index] := roster_item.Nickname
//        else
//            // otherwise, just show the JID.
//            Listbox1.Items[itm_index] := roster_item.jid.jid;
//    end;
//end;

procedure TForm1.PresenceCallback(event: string; tag: TXMLTag; p: TJabberPres);
//var
//    ritem: TJabberRosterItem;
//    idx: integer;
//    cap: string;
begin
      { TODO : Roster refactor }
//    // we want to ignore subscription packets
//    if (tag = nil) then exit;
//    if (p.isSubscription) then exit;
//
//    ritem := MainSession.Roster.Find(p.fromJID.jid);
//    if (ritem <> nil) then begin
//        idx := Listbox1.Items.IndexOfObject(ritem);
//        if (idx = -1) then exit;
//
//        if (ritem.Nickname <> '') then
//            // if the roster item has a nickname, show it
//            cap := ritem.Nickname
//        else
//            // otherwise, just show the JID.
//            cap := ritem.jid.jid;
//
//        if MainSession.ppdb.FindPres(p.fromJID.jid, '') = nil then
//            Listbox1.Items[idx] := cap
//        else
//            Listbox1.Items[idx] := '** ' + cap;
//        end;
end;

end.
