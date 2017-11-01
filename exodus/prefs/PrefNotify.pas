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
unit PrefNotify;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PrefPanel, StdCtrls, CheckLst, TntStdCtrls, TntCheckLst,
  ExtCtrls, TntExtCtrls, ExGroupBox, TntForms, ExFrame, ExBrandPanel,
  Buttons, TntButtons, TntDialogs,
  Registry,
  Contnrs, ExCheckGroupBox;

type
    TNotifyInfo = class
    private
        _Key: widestring;
        _StrValue: WideString;

        _Caption: WideString;
        _IsReadOnly: boolean;
        _IsVisible: boolean;

        _soundFile: widestring;
        
        function GetStringValue(): widestring;
        function GetBoolValue(): Boolean;
        function GetIntValue(): Integer;
        function GetWriteable(): boolean;
        function GetSoundFile(): widestring;
        function GetSoundEnabled(): boolean;
        
        procedure SetStringValue(Str: widestring);
        procedure SetBoolValue(Bool: boolean);
        procedure SetIntValue(Int: Integer);
        procedure SetSoundFile(FName: widestring);
    public
        constructor Create(Caption: widestring; Key: widestring);overload;
        constructor Create(Src: TNotifyInfo);overload;
        destructor Destroy(); override;

        procedure SaveValue();
        property IntValue: Integer read GetIntValue write SetIntValue;
        property Value: WideString read GetStringValue write SetStringValue;
        property BoolValue: boolean read GetBoolValue write SetBoolValue;
        property IsVisible: boolean read _IsVisible;
        property IsReadOnly: boolean read _IsReadOnly;
        property IsWriteable: boolean read GetWriteable;
        property SoundFile: widestring read GetSoundFile write SetSoundFile;
        property IsGetSoundEnabled: boolean read GetSoundEnabled;
    end;

  TfrmPrefNotify = class(TfrmPrefPanel)
    pnlContainer: TExBrandPanel;
    pnlAlertSources: TExBrandPanel;
    chkNotify: TTntCheckListBox;
    lblNotifySources: TTntLabel;
    gbActions: TExGroupBox;
    chkFlash: TTntCheckBox;
    chkFront: TTntCheckBox;
    pnlSoundAction: TExBrandPanel;
    chkPlaySound: TTntCheckBox;
    txtSoundFile: TTntEdit;
    btnPlaySound: TTntBitBtn;
    btnBrowse: TTntButton;
    dlgOpenSoundFile: TTntOpenDialog;
    pnlSoundFile: TExBrandPanel;
    chkTrayNotify: TTntCheckBox;
    gbAdvancedPrefs: TExGroupBox;
    chkNotifyActive: TTntCheckBox;
    chkNotifyActiveWindow: TTntCheckBox;
    chkFlashInfinite: TTntCheckBox;
    chkFlashTabInfinite: TTntCheckBox;
    pnlToast: TExBrandPanel;
    chkToast: TTntCheckBox;
    btnToastSettings: TTntButton;
    pnlTop: TExBrandPanel;
    pnlSoundEnable: TExBrandPanel;
    imgSound: TImage;
    chkSound: TTntCheckBox;
    chkSuspendDND: TTntCheckBox;
    procedure txtSoundFileExit(Sender: TObject);
    procedure btnToastSettingsClick(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure btnPlaySoundClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkNotifyClick(Sender: TObject);
    procedure chkToastClick(Sender: TObject);
  private
    { Private declarations }
    _NoNotifyUpdate: boolean;
    _Loading: boolean;

    _NotifyList: TObjectList;

    _CanEnableToast: boolean;
    _CanEnableFlash: boolean;
    _CanEnableTray: boolean;
    _CanEnableSound: boolean;
    _CanEnableFront: boolean;

    _ToastAlpha: TNotifyInfo;
    _ToastAlphaValue: TNotifyInfo;
    _ToastDuration: TNotifyInfo;
  public
    { Public declarations }
    procedure LoadPrefs(); override;
    procedure SavePrefs(); override;
  end;

implementation
{$R *.dfm}
uses
    MMSystem,
    PrefFile,                                      
    XMLUtils,
    ToastSettings,
    GnuGetText, JabberUtils, ExUtils,  PrefController, Session, ShellAPI;

const
    sSoundChatactivity = 'Activity in a chat window';
    sSoundPriorityChatActivity = 'High priority activity in a chat window';
    sSoundInvite = 'Invitation to a conference room is received';
    sSoundKeyword = 'Keyword appears in a conference room';
    sSoundNewchat = 'New conversation is initiated';
    sSoundNormalmsg = 'Broadcast message is received';
    sSoundOffline = 'Contact goes offline';
    sSoundOnline = 'Contact comes online';
    sSoundRoomactivity = 'Activity in a conference room';
    sSoundPriorityRoomactivity = 'High priority activity in a conference room';
    sSoundS10n = 'Subscription request is received';
    sSoundOOB = 'File Transfers';
    sSoundAutoResponse = 'Auto response generated';

    sSoundSetup = 'Make sure to configure sounds in your Sounds Control Panel using the hotlink provided.';

const
    NUM_NOTIFIES = 13;


constructor TNotifyInfo.create(Caption: widestring; Key: widestring);
var
    s: TPrefState;
begin
    _Caption := Caption;
    _Key := key;
    _StrValue := MainSession.Prefs.getString(_Key);
    s := getPrefState(_Key);
    _IsReadOnly := (s = psReadOnly);
    _IsVisible := (s <> psInvisible);
    _soundFile := MainSession.Prefs.GetSoundFile(_Key);
end;

constructor TNotifyInfo.create(Src: TNotifyInfo);
begin
    inherited Create();;
    if (src <> nil) then begin
        _Caption := Src._Caption;
        _Key := Src._Key;
        _StrValue := Src._StrValue;
        _IsReadOnly := Src._IsReadOnly;
        _IsVisible := Src._IsVisible;
        _SoundFile := Src._soundFile;
    end
    else begin
        _Caption := '';
        _Key := '';
        _StrValue := '';
        _IsReadOnly := false;
        _IsVisible := true;
        _SoundFIle := '';
    end;
end;

destructor TNotifyInfo.Destroy();
begin
    inherited;
end;

function TNotifyInfo.GetStringValue(): widestring;
begin
    Result := _StrValue;
end;

function TNotifyInfo.GetBoolValue(): Boolean;
begin
    Result := SafeBool(_StrValue);
end;

function TNotifyInfo.GetIntValue(): Integer;
begin
    Result := SafeInt(_StrValue);
end;

function TNotifyInfo.GetWriteable(): boolean;
begin
    Result := IsVisible and not IsReadOnly;
end;

procedure TNotifyInfo.SetStringValue(Str: widestring);
begin
    if (_IsVisible and not _IsReadOnly) then
        _StrValue := Str;
end;

procedure TNotifyInfo.SetBoolValue(Bool: boolean);
begin
    if (bool) then
        SetStringValue('1')
    else
        SetStringValue('0');
end;

procedure TNotifyInfo.SetIntValue(Int: Integer);
begin
    try
        SetStringValue(IntToStr(Int));
    except
        SetStringValue('');
    end;
end;

procedure TNotifyInfo.SaveValue();
begin
    if (_IsVisible and not _IsReadOnly) then begin
        MainSession.Prefs.SetString(_Key, _StrValue);
        MainSession.Prefs.SetString(_Key + '_sound', _SoundFile);
    end;
end;

function TNotifyInfo.GetSoundFile(): widestring;
begin
    Result := _soundFile;
end;

procedure TNotifyInfo.SetSoundFile(FName: widestring);
begin
    _soundFile := FName;
end;

function TNotifyInfo.GetSoundEnabled(): boolean;
begin
    Result := ((IntValue and notify_sound) > 0);
end;

procedure loadNotificationPrefs(List: TObjectList);
var
    OOBNI: TNotifyInfo;
begin
    if (List = nil) then exit;
    List.Clear();

    List.add(TNotifyInfo.create(_(sSoundOnline), 'notify_online'));
    List.add(TNotifyInfo.create(_(sSoundOffline), 'notify_offline'));
    List.add(TNotifyInfo.create(_(sSoundNewchat), 'notify_newchat'));
    List.add(TNotifyInfo.create(_(sSoundNormalmsg), 'notify_normalmsg'));
    List.add(TNotifyInfo.create(_(sSoundS10n), 'notify_s10n'));
    List.add(TNotifyInfo.create(_(sSoundInvite), 'notify_invite'));
    if (getPrefState('keywords') <> psInvisible) then
    begin
        List.add(TNotifyInfo.create(_(sSoundKeyword), 'notify_keyword'));
    end;
    List.add(TNotifyInfo.create(_(sSoundChatactivity), 'notify_chatactivity'));
    List.add(TNotifyInfo.create(_(sSoundPriorityChatactivity), 'notify_priority_chatactivity'));
    List.add(TNotifyInfo.create(_(sSoundRoomactivity), 'notify_roomactivity'));
    List.add(TNotifyInfo.create(_(sSoundPriorityRoomactivity), 'notify_priority_roomactivity'));
    List.add(TNotifyInfo.create(_(sSoundAutoResponse), 'notify_autoresponse'));
    OOBNI := TNotifyInfo.create(_(sSoundOOB), 'notify_oob');
    //check oob branding as well
    OOBNI._IsVisible := (OOBNI._IsVisible and MainSession.Prefs.GetBool('brand_ft'));
    List.add(OOBNI);
end;

procedure TfrmPrefNotify.LoadPrefs();
var
    i: integer;
    OneNI: TNotifyInfo;
    s: TPrefState;
    FoundOne: boolean;
begin
    _Loading := true;

    _NotifyList := TObjectList.Create(true);
    LoadNotificationPrefs(_notifyList);
    chkNotify.Items.Clear();
    FoundOne := false;
    for i := 0 to _NotifyList.Count - 1 do
    begin
        OneNI := TNotifyInfo(_NotifyList[i]);
        if (OneNI._IsVisible) then
        begin
            FoundOne := true;
            chkNotify.AddItem(OneNI._Caption, oneNI);
            chkNotify.ItemEnabled[chkNotify.Count - 1] := not OneNI._IsReadOnly;
            chkNotify.Checked[chkNotify.Count - 1] := (OneNI.IntValue > 0);
        end;
    end;

    _ToastAlpha := TNotifyInfo.create('', 'toast_alpha');
    _ToastAlphaValue := TNotifyInfo.create('', 'toast_alpha_val');
    _ToastDuration := TNotifyInfo.create('', 'toast_duration');

    inherited;

    chkNotify.Visible := foundOne;
    lblNotifySources.Visible := foundOne;

    //visiblity and read status of sound has been set by parent...
    imgSound.Visible := chkSound.Visible;
    pnlSoundEnable.Visible := chkSound.Visible;
    //set visiblity and read status of actions
    s := GetPrefState('notify_type_toast');
    _CanEnableToast := (s <> psReadOnly);
    chkToast.Visible := (s <> psInvisible);
    btnToastSettings.Visible := chkToast.Visible;

    s := GetPrefState('notify_type_flash');
    _CanEnableFlash := (s <> psReadOnly);
    chkFlash.Visible := (s <> psInvisible);

    s := GetPrefState('notify_type_tray');
    _CanEnableTray := (s <> psReadOnly);
    chkTrayNotify.Visible := (s <> psInvisible);

    s := GetPrefState('notify_type_sound');
    _CanEnableSound := (s <> psReadOnly);
    chkPlaySound.Visible := (s <> psInvisible);
    txtSoundFile.Visible := chkPlaySound.Visible;
    btnPlaySound.Visible := chkPlaySound.Visible;
    btnBrowse.Visible := chkPlaySound.Visible;

    s := GetPrefState('notify_type_front');
    _CanEnableFront := (s <> psReadOnly);
    chkFront.Visible := (s <> psInvisible);

    chkToast.Checked := false;
    chkFlash.Checked := false;
    chkTrayNotify.Checked := false;
    chkFront.Checked := false;
    chkPlaySound.Checked := false;

    pnlToast.enabled := false;
    chkFlash.enabled := false;
    chkTrayNotify.enabled := false;
    chkFront.enabled := false;
    chkPlaySound.Enabled := false;

    if (chkNotify.Count > 0) then begin
        chkNotify.ItemIndex := 0;
        chkNotifyClick(Self);
    end;
    //allow panels to autohide...
    pnlContainer.checkAutoHide();

    _loading := false;
end;

procedure TfrmPrefNotify.SavePrefs();
var
    i: integer;
begin
    inherited;
    for i := 0 to _notifyList.Count - 1 do begin
        TNotifyInfo(_notifyList[i]).SaveValue();
    end;
    _ToastAlpha.SaveValue();
    _ToastAlphaValue.SaveValue();
    _ToastDuration.SaveValue();
end;

procedure TfrmPrefNotify.TntFormDestroy(Sender: TObject);
begin
    inherited;
    _NotifyList.Free();
    _ToastAlpha.Free();
    _ToastAlphaValue.Free();
    _ToastDuration.Free();
end;

procedure TfrmPrefNotify.txtSoundFileExit(Sender: TObject);
var
    OneNI: TNotifyInfo;
    i: integer;
begin
    inherited;
    i := chkNotify.ItemIndex;
    if (i = -1) then exit;
    
    OneNI := TNotifyInfo(chkNotify.Items.Objects[i]);
    oneNI.SoundFile := txtSoundFile.Text;
end;

procedure TfrmPrefNotify.FormCreate(Sender: TObject);
begin
    _NotifyList := TObjectList.Create();
    inherited; //will call loadprefs
end;

procedure TfrmPrefNotify.btnBrowseClick(Sender: TObject);
var
    tmps: string;
    oneNI: TNotifyInfo;
begin
    inherited;
    tmps := txtSoundFile.Text;
    dlgOpenSoundFile.FileName := tmps;

    if (dlgOpenSoundFile.Execute) then begin
        txtSoundFile.Text := dlgOpenSoundFile.FileName;
        if (chkNotify.ItemIndex = -1) then exit;

        OneNI := TNotifyInfo(chkNotify.Items.Objects[chkNotify.ItemIndex]);
        OneNI.SoundFile := txtSoundFile.Text;
    end;
end;

procedure TfrmPrefNotify.btnPlaySoundClick(Sender: TObject);
var
    tstr: string;
begin
    inherited;
    tstr := txtSoundFile.Text;
    PlaySound(pchar(tstr), 0,
                  SND_FILENAME or SND_ASYNC or SND_NOWAIT or SND_NODEFAULT);
end;

procedure TfrmPrefNotify.btnToastSettingsClick(Sender: TObject);
var
    dlg: TToastSettings;
begin
    inherited;
    dlg := TToastSettings.Create(Self);
    dlg.setPrefs(_toastAlpha, _toastAlphaValue, _toastDuration);
    dlg.ShowModal();
end;

procedure TfrmPrefNotify.chkNotifyClick(Sender: TObject);
var
    e: boolean;
    i: integer;
    OneNI: TNotifyInfo;
begin
    // Show this item's options in the optNotify box.
    i := chkNotify.ItemIndex;
    if (i = -1) then exit;

    OneNI := TNotifyInfo(chkNotify.Items.Objects[i]);

    _NoNotifyUpdate := true; //stop checkbox click processing

    e := chkNotify.Checked[i] and not OneNI._IsReadOnly;
    pnlToast.Enabled := e and _CanEnableToast;
    chkFlash.Enabled := e and _CanEnableFlash and (OneNI._Key <> 'notify_online') and (OneNI._Key <> 'notify_offline');
    chkTrayNotify.Enabled := e and _CanEnableTray and (OneNI._Key <> 'notify_online') and (OneNI._Key <> 'notify_offline');
    chkFront.Enabled := e and _CanEnableFront and (OneNI._Key <> 'notify_online') and (OneNI._Key <> 'notify_offline');
    chkPlaySound.Enabled := e and _CanEnableSound;

    if (not chkNotify.Checked[i]) then
        OneNI.IntValue := 0;

    chkToast.Checked := ((OneNI.IntValue and notify_toast) > 0);
    chkFlash.Checked := (((OneNI.IntValue and notify_flash) > 0) and (OneNI._Key <> 'notify_online') and (OneNI._Key <> 'notify_offline'));
    chkTrayNotify.Checked := (((OneNI.IntValue and notify_tray) > 0) and (OneNI._Key <> 'notify_online') and (OneNI._Key <> 'notify_offline'));
    chkFront.Checked := (((OneNI.IntValue and notify_front) > 0) and (OneNI._Key <> 'notify_online') and (OneNI._Key <> 'notify_offline'));
    chkPlaySound.Checked := ((OneNI.IntValue and notify_sound) > 0);

    pnlSoundFile.enabled := chkPlaySound.Checked;
    btnToastSettings.Enabled := chkToast.Checked and chkToast.Enabled;
    txtSoundFile.Text := OneNI.SoundFile;

    _NoNotifyUpdate := false;
end;

procedure TfrmPrefNotify.chkToastClick(Sender: TObject);
var
    i: integer;
    oneNI: TNotifyInfo;
begin
    // update the current notify selection
    if (_NoNotifyUpdate) or (chkNotify.ItemIndex = -1) then exit;

    i := chkNotify.ItemIndex;
    oneNI := TNotifyInfo(chkNotify.Items.Objects[i]);

    oneNI.IntValue := 0;
    if (chkToast.Checked) then
        oneNI.IntValue := notify_toast;
    if (chkFlash.Checked) then
        oneNI.IntValue := oneNI.IntValue + notify_flash;
    if (chkTrayNotify.Checked) then
        oneNI.IntValue := oneNI.IntValue + notify_tray;
    if (chkFront.Checked) then
        oneNI.IntValue := oneNI.IntValue + notify_front;
    if (chkPlaySound.Checked) then
        oneNI.IntValue := oneNI.IntValue + notify_sound;

    if (Sender = chkPlaySound) then
        pnlSoundFile.Enabled := chkPlaySound.Checked
    else if (Sender = chkToast) then
        btnToastSettings.Enabled := chkToast.checked and chkToast.enabled;
end;

end.
