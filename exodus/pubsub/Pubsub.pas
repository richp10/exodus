unit Pubsub;

interface

uses ActiveX, Classes, ComObj, Exodus_TLB, Unicode, XMLTag;

type
  TPubsubListenerSet = class
  private
    _node: Widestring;
    _listeners: TInterfaceList;

    function _ListenerCount(): Integer;
  public
    constructor Create(node: Widestring; reg: Boolean = true);
    destructor Destroy(); override;

    procedure Notify(from, node: Widestring; items: OleVariant);
    procedure Add(listener: IExodusPubsubListener);
    procedure Remove(listener: IExodusPubsubListener);

    property Node: Widestring read _node;
    property Count: Integer read _ListenerCount;
  end;

  TExodusPubsubService = class(TAutoIntfObject, IExodusPubsubService)
  private
    _jid: Widestring;

  protected
    function Get_Jid(): Widestring; safecall;

  public
    constructor Create(jid: Widestring);
    destructor Destroy(); override;

    procedure publish(const node: Widestring; var items: OleVariant); safecall;
    procedure retrieve(const node: Widestring; const cb: IExodusPubsubListener); safecall;
  end;

  TExodusPubsubController = class(TAutoIntfObject, IExodusPubsubController)
  private
    _js: TObject;
    _msgCB: Integer;
    _sessionCB: Integer;
    _depCB: Integer;

    _subscribs: TWidestringList;
    _svcs: TWidestringList;

  protected
    procedure MessageCallback(event: string; tag: TXMLTag);
    procedure SessionCallback(event: string; tag: TXMLTag);

    function Get_PubsubListenerSet(node: Widestring; create: Boolean = false): TPubsubListenerSet;

    function Get_ServiceCount(): Integer; safecall;
    function Get_Services(idx: Integer): IExodusPubsubService; safecall;

    function Get_PepService(): IExodusPubsubService; safecall;

  public
    constructor Create(js: TObject);
    destructor Destroy(); override;

    procedure RegisterListener(const Node: WideString; const Callback: IExodusPubsubListener); safecall;
    procedure UnregisterListener(const Node: WideString; const Callback: IExodusPubsubListener); safecall;

    function ServiceFor(const jid: Widestring): IExodusPubsubService; safecall;
  end;

const
    XMLNS_PUBSUB: Widestring = 'http://jabber.org/protocol/pubsub';

implementation

uses ComServ, IQ, JabberID, Variants, Session, SysUtils, XMLParser,
    Entity, EntityCache, CapsCache;


function ParsePubsubItems(itemTags: TXMLTagList): OleVariant;
var
    items: Variant;
    idx, amt: Integer;
    xml: Widestring;
begin
    if (itemTags <> nil) then
        amt := itemTags.Count
    else
        amt := 0;
    items := VarArrayCreate([0, amt], varOleStr);
    for idx := 0 to amt - 1 do begin
        xml := itemTags[idx].XML;
        VarArrayPut(items, xml, idx);
    end;

    Result := items;
end;


type
  TPubsubItemsNotifier = class(TPubsubListenerSet)
  private
    _from: Widestring;
  public
    constructor Create(from: Widestring; node: Widestring; cb: IExodusPubsubListener);

    procedure NotifyAll(event: String; tag: TXMLTag);

    property From: Widestring read _from;
  end;

  TPubsubRetrievalListener = class(TAutoIntfObject, IExodusPubsubListener)
  private
    _nodeList: TPubsubListenerSet;
    _defList: TPubsubListenerSet;

  public
    constructor Create(nodeList, defList: TPubsubListenerSet);
    destructor Destroy(); override;

    procedure OnNotify(
            const publisher: WideString;
            const Node: WideString;
            var Items: OleVariant); safecall;
  end;

  TPubsubServiceWrapper = class
  private
    _svc: IExodusPubsubService;

  public
    constructor Create(svc: IExodusPubsubService);
    destructor Destroy(); override;

    property Service: IExodusPubsubService read _svc;
  end;

constructor TPubsubServiceWrapper.Create(svc: IExodusPubsubService);
begin
    _svc := svc;
end;
destructor TPubsubServiceWrapper.Destroy();
begin
    _svc := nil;
    
    inherited;
end;


constructor TExodusPubsubService.Create(jid: WideString);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusPubsubService);

    _jid := jid;
end;
destructor TExodusPubsubService.Destroy;
begin

    inherited;
end;

function TExodusPubsubService.Get_Jid(): Widestring;
begin
    Result := _jid;
end;

procedure TExodusPubsubService.retrieve(
        const node: WideString;
        const cb: IExodusPubsubListener);
var
    notifier: TPubsubItemsNotifier;
    iq: TJabberIQ;
    ps: TXMLTag;
begin
    if (node = '') then exit;
    if (cb = nil) then exit;

    notifier := TPubsubItemsNotifier.Create(Self.Get_Jid(), node, cb);
    iq := TJabberIQ.Create(
            MainSession,
            MainSession.generateID,
            notifier.NotifyAll);
    iq.RemoveTag(iq.qTag);
    ps := iq.AddTagNS('pubsub', XMLNS_PUBSUB);
    ps := ps.AddTag('items');
    ps.setAttribute('node', node);

    //TODO: remember IQ?
    iq.Send();
end;
procedure TExodusPubsubService.publish(
        const node: WideString;
        var items: OleVariant);
var
    iq: TJabberIQ;
    pub, item: TXMLTag;
    parser: TXMLTagParser;
    val: Widestring;
    idx: Integer;
begin
    iq := TJabberIQ.Create(MainSession, MainSession.generateID);
    iq.iqType := 'set';
    if (Get_Jid() <> '') then
        iq.toJid := Get_Jid();

    iq.RemoveTag(iq.qTag);
    iq.qTag := nil;
    pub := iq.AddTagNS('pubsub', XMLNS_PUBSUB);
    pub := pub.AddTag('publish');
    pub.setAttribute('node', node);

    parser := TXMLTagParser.Create();
    for idx := VarArrayLowBound(items, 1) to VarArrayHighBound(items, 1) do begin
        val := items[idx];

        parser.ParseString(val);
        if (parser.Count = 0) then continue;
        item := parser.popTag();
        pub.addInsertedXML(item.XML);
        item.Free();
        parser.Clear();
    end;

    iq.Send();
end;

constructor TPubsubListenerSet.Create(node: Widestring; reg: Boolean);
begin
    _node := node;
    _listeners := TInterfaceList.Create();

    if reg and (_node <> '') then
        jSelfCaps.AddFeature(_node + '+notify');
end;
destructor TPubsubListenerSet.Destroy;
begin
    if (_node <> '') then
        jSelfCaps.RemoveFeature(_node + '+notify');
    FreeAndNil(_listeners);

    inherited;
end;

function TPubsubListenerSet._ListenerCount(): Integer;
begin
    Result := _listeners.Count;
end;

procedure TPubsubListenerSet.Notify(from, node: Widestring; items: OleVariant);
var
    idx: Integer;
begin
    for idx := 0 to _listeners.Count - 1 do begin
        try
            IExodusPubsubListener(_listeners[idx]).OnNotify(from, node, items);
        except
            //TODO: loggit
        end;
    end;
end;
procedure TPubsubListenerSet.Add(listener: IExodusPubsubListener);
begin
    if _listeners.IndexOf(listener) = -1 then
        _listeners.Add(listener);
end;
procedure TPubsubListenerSet.Remove(listener: IExodusPubsubListener);
begin
    _listeners.Remove(listener);
end;


constructor TExodusPubsubController.Create(js: TObject);
var
    session: TJabberSession;
begin
    assert(js is TJabberSession);

    inherited Create(ComServer.TypeLib, IID_IExodusPubsubController);

    session := TJabberSession(js);
    _js := js;
    _subscribs := TWidestringList.Create();
    _svcs := TWidestringList.Create();

    _msgCB := session.RegisterCallback(
            MessageCallback,
            '/packet/message[@type="headline"]/event[@xmlns="' + XMLNS_PUBSUB + '#event"]');
    _sessionCB := session.RegisterCallback(
            SessionCallback,
            '/session/disconnected');
    _depCB := session.RegisterCallback(
            SessionCallback,
            '/dependancy/ready');
end;
destructor TExodusPubsubController.Destroy;
var
    session: TJabberSession;
begin
    session := TJabberSession(_js);
    if (_msgCB <> -1) then
        session.UnRegisterCallback(_msgCB);
    _msgCB := -1;
    if (_sessionCB <> -1) then
        session.UnRegisterCallback(_sessionCB);
    _sessionCB := -1;
    if (_depCB <> -1) then
        session.UnRegisterCallback(_depCB);
    _depCB := -1;

    while (_svcs.Count > 0) do begin
        _svcs.Objects[0].Free();
        _svcs.Delete(0);
    end;
    FreeAndNil(_svcs);
    
    while (_subscribs.Count > 0) do begin
        _subscribs.Objects[0].Free();
        _subscribs.Delete(0);
    end;
    FreeAndNil(_subscribs);

    inherited;
end;

procedure TExodusPubsubController.SessionCallback(event: string; tag: TXMLTag);
var
    jid: Widestring;
    pubsubs: TWidestringList;
    svc: IExodusPubsubService;
begin
    if (event = ('/dependancy/ready/' + DEPMOD_ENTITY_CACHE)) then begin
        //check for PEP
        pubsubs := TWidestringList.Create();
        jid := TJabberSession(_js).SessionJid.jid;
        jEntityCache.getByIdentity('pubsub', 'pep', pubsubs);

        // There SHOULD only be 1 PEP entity - so assume there is only 1
        if (pubsubs.Count > 0) then
        begin
            //jid := TJabberSession(_js).SessionJid.jid;
            pubsubs.Delete(0);

            //svc := TExodusPubsubService.Create(jid) as IExodusPubsubService;
            svc := TExodusPubsubService.Create('') as IExodusPubsubService;
            _svcs.AddObject(jid, TPubsubServiceWrapper.Create(svc));
        end;

        //check for "stand-alone"
        jEntityCache.getByIdentity('pubsub', 'service', pubsubs);
        while (pubsubs.Count > 0) do begin
            jid := pubsubs[0];
            pubsubs.Delete(0);
            if not jEntityCache.getByJid(jid).hasFeature(XMLNS_PUBSUB) then continue;

            svc := TExodusPubsubService.Create(jid) as IExodusPubsubService;
            _svcs.AddObject(jid, TPubsubServiceWrapper.Create(svc));
        end;

        //TODO:  fire events?
    end
    else if (event = '/session/disconnected') then begin
        while (_svcs.Count > 0) do begin
            _svcs.Objects[0].Free();
            _svcs.Delete(0);
        end;
    end;
end;
procedure TExodusPubsubController.MessageCallback(event: string; tag: TXMLTag);
var
    from, node, xml: Widestring;
    evt: TXMLTag;
    idx: Integer;
    itemTags: TXMLTagList;
    items: Variant;
    nodeList, defList: TPubsubListenerSet;
    svc: IExodusPubsubService;
begin
    evt := tag.QueryXPTag('//event[@xmlns="' + XMLNS_PUBSUB + '#event"]/items');

    from := tag.GetAttribute('from');
    node := evt.GetAttribute('node');
    svc := ServiceFor(from);

    nodeList := Get_PubsubListenerSet(node);
    defList := Get_PubsubListenerSet('');
    if (nodeList = nil) and (defList = nil) then exit;

    items := ParsePubsubItems(evt.QueryTags('item'));
    //TODO:  if items.Count = 0, retrieve them!
    if (VarArrayHighBound(items, 1) > 0) then begin
        if (nodeList <> nil) then
            nodeList.Notify(from, node, items);
        if (defList <> nil) then
            defList.Notify(from, node, items);
    end
    else if (svc <> nil) then begin
        svc.retrieve(
                node,
                TPubsubRetrievalListener.Create(nodeList, defList) as IExodusPubsubListener);
    end;

    VarClear(items);
end;

function TExodusPubsubController.Get_ServiceCount(): Integer;
begin
    Result := _svcs.Count;
end;
function TExodusPubsubController.Get_Services(idx: Integer): IExodusPubsubService;
begin
    if (idx < 0) or (idx >= _svcs.Count) then
        result := nil
    else
        Result := TPubsubServiceWrapper(_svcs.Objects[idx]).Service;
end;
function TExodusPubsubController.ServiceFor(const jid: WideString): IExodusPubsubService;
begin
    Result := Get_Services(_svcs.IndexOf(jid));
end;

function TExodusPubsubController.Get_PepService(): IExodusPubsubService;
var
    session: TJabberSession;
    jid: Widestring;
begin
    session := TJabberSession(_js);
    Result := nil;

    if (session.Active) then begin
        jid := session.SessionJid.jid;
        Result := ServiceFor(jid);
    end;
end;
function TExodusPubsubController.Get_PubsubListenerSet(node: WideString; create: Boolean): TPubsubListenerSet;
var
    idx: Integer;
begin
    idx := _subscribs.IndexOf(node);
    if (idx <> -1) then
        result := TPubsubListenerSet(_subscribs.Objects[idx])
    else if not create then
         Result := nil
    else begin
        result := TPubsubListenerSet.Create(node);
        _subscribs.AddObject(node, result);
    end;
end;

procedure TExodusPubsubController.RegisterListener(
        const Node: WideString;
        const Callback: IExodusPubsubListener);
var
    registered: TPubsubListenerSet;
begin
    if (Callback = nil) then exit;
    registered := Get_PubsubListenerSet(node, true);
    registered.Add(Callback);
end;
procedure TExodusPubsubController.UnregisterListener(
        const Node: Widestring;
        const Callback: IExodusPubsubListener);
var
    idx: Integer;
    registered: TPubsubListenerSet;
begin
    if (Callback = nil) then exit;

    idx := _subscribs.IndexOf(node);
    if (idx = -1) then exit;
    
    registered := TPubsubListenerSet(_subscribs.Objects[idx]);
    registered.Remove(Callback);
    if (registered.Count = 0) then begin
        _subscribs.Delete(idx);
        registered.Free();
    end;
end;

constructor TPubsubItemsNotifier.Create(
        from: Widestring;
        node: Widestring;
        cb: IExodusPubsubListener);
begin
    inherited Create(node, false);
    Self.Add(cb);

    _from := from;
end;

procedure TPubsubItemsNotifier.NotifyAll(event: string; tag: TXMLTag);
var
    tags: TXMLTagList;
    items: OleVariant;
begin
    if (tag <> nil) then
        tags :=tag.QueryXPTags('//pubsub[@xmlns="' + XMLNS_PUBSUB+ '"]/items/item')
    else
        tags := nil;

    items := ParsePubsubItems(tags);
    Self.Notify(From, Node, items);
    VarClear(items);

    Self.Free();
end;

constructor TPubsubRetrievalListener.Create(nodeList, defList: TPubsubListenerSet);
begin
    inherited Create(ComServer.TypeLib, IID_IExodusPubsubListener);

    _nodeList := nodeList;
    _defList := defList;
end;
destructor TPubsubRetrievalListener.Destroy;
begin
    inherited;
end;

procedure TPubsubRetrievalListener.OnNotify(
        const publisher: WideString;
        const Node: WideString;
        var Items: OleVariant);
begin
    if (_nodeList <> nil) then
        _nodeList.Notify(publisher, node, items);
    if (_defList <> nil) then
        _defList.Notify(publisher, node, items);
end;

end.
