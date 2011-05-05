component accessors="true" displayname="gfMVC Controller" serializable="true" output="false" hint="gfMVC Controller" {
	property name="AppName" type="string";
	property name="AppKey" type="string";
	property name="FrontEndControllerName" type="string";
	property name="handlerReinitParam" type="string";
	property name="fwReinitParam" type="string";
	property name="config" type="any";
	property name="RequestID" type="any";
	property name="sessionObject" type="any";
	property name="requestObject" type="any";
	property name="cfcInvoker" type="any";
	property name="renderer" type="any";
	property name="ObjectFactory" type="any";
	property name="EventMetaInfo" type="any";
	property name="EventMetaParser" type="any";
	
	public CF9Controller function init(string AppName, string AppKey, string FrontEndControllerName = 'index.cfm', string HandlerReinitParam = 'reinit:true', string fwReinitParam = 'reinitAll:true'){
		var configBean = new Bean.baseBean();
		var configSetting = {};
		setCfcInvoker(new helpers.CFCInvoker());
		setAppName(arguments.AppName);
		setAppKey( Hash(arguments.AppKey,'SHA-256') );
		setFrontEndControllerName(arguments.FrontEndControllerName);
		setHandlerReinitParam(arguments.HandlerReinitParam);
		setFWReinitParam(arguments.fwReinitParam);
		
		variables.HANDLER_REINIT_PARAM = ListToArray(arguments.handlerReinitParam,':');
		variables.FRAMEWORK_REINIT_PARAM = ListToArray(arguments.fwReinitParam,':');
		
		configSetting = $loadApplicationSetting();
		configBean.setMemento( configSetting );
		setConfig( configBean );
		
		setObjectFactory( new factory.objectFactory() );
		setEventMetaInfo( new Bean.baseBean() );
		setEventMetaParser( new util.EventMetaParser() );
		setRenderer( new renderer.renderer( arguments.AppName, arguments.AppKey, this ) );
		
		return this;
	}
	public boolean function needFrameWorkReinit(){
		return $needReinit( 'FRAMEWORK_REINIT_PARAM' );
	}
	public void function processRequest(){
		var currentEvent = getConfig().getValue('defaultEvent');
		var ec = {};
		var oEvent = '';
		request.appKey = getAppKey();
		param name="request.eventsFired" default="#ArrayNew(1)#";
		/*
		if (NOT StructKeyExists(URL,variables.EVENT_IDENTIFIER) and NOT StructKeyExists(FORM,variables.EVENT_IDENTIFIER) )
			currentEvent = getConfig().getValue('defaultEvent');
		else if (StructKeyExists(FORM,variables.EVENT_IDENTIFIER))
			currentEvent = FORM[variables.EVENT_IDENTIFIER];
		else if (StructKeyExists(URL,variables.EVENT_IDENTIFIER))
			currentEvent = URL[variables.EVENT_IDENTIFIER];
		*/
		
		
		lock scope="request" timeout="5" type="exclusive" {
			var ID = CREATEUUID();	
			if (NOT structKeyExists(request, 'fwRequestID') ){
				request.fwRequestID = {};
				setRequestID( request.fwRequestID );
			}
			request[request.appKey] = createObject ('bean.event').init( getConfig(), getObjectFactory(), request.appKey );
			oEvent = request[request.appKey];
			oEvent.setValue('ID', ID);

			oEvent.setValue('eventsFired', [] );
			oEvent.setValue('viewHelp', {} );
			oEvent.setValue('EVENT_IDENTIFIER', variables.EVENT_IDENTIFIER );
			oEvent.setValue('HANDLER_REINIT_PARAM', variables.HANDLER_REINIT_PARAM );
			oEvent.setValue('FRAMEWORK_REINIT_PARAM', variables.FRAMEWORK_REINIT_PARAM );
			oEvent.setValue('EVENT_SEPERATOR', variables.EVENT_SEPERATOR );
			oEvent.setValue('AppKey', request.appKey );
			
			oEvent.setValue('HandlerReinitRequest', $needHandlerReinit() );
			oEvent.setValue('sessionObject',$createSessionObject( request.appKey ));
			oEvent.setValue('ClearApplicationCache',needFrameWorkReinit());
			oEvent.setValue('ClearEventCache', $needHandlerReinit());
			oEvent.setValue('renderData', false);
			oEvent.setValue('renderView', true);
			oEvent.createEventCollection();
			oEvent.addToEventCollection( StructCopy(URL) );
			oEvent.addToEventCollection( StructCopy(FORM) );
			
			ec = oEvent.getEventCollection();
			if (StructKeyExists(ec,variables.EVENT_IDENTIFIER))
				currentEvent = ec[variables.EVENT_IDENTIFIER];
			//Correct Event Name			
			oEvent.setValue('CurrentEvent', $getCurrentEvent(currentEvent) );
			setRequestObject( request[request.appKey] );
		}
		$runEvent( event: currentEvent);
	}
	public any function processEvent(){
		savecontent variable="local.eventResult" {
			processRequest();
		}
		return local.eventResult;
	}
	public any function dispatchEvent(string event, string parent = '', any listeners = '', boolean securedEvent = false, boolean returnData = true){
		arguments.AdditionalEventInfo =	{event=arguments.event, securedEvent=false, parent=arguments.parent, listeners=arguments.listeners};
		return $runEvent(argumentCollection:arguments);
	} 

	public any function $runEvent( string event, any oEvent = '', any params = '', any sessionObject = '', any requestObject = '', boolean IsParentEvent = false, boolean IsListenerEvent = false, boolean returnData = false, boolean renderViewOnly = false, struct AdditionalEventInfo = StructNew() ){
		var i = 0;
		
		arguments.event = $getCurrentEvent(arguments.event);
		local.oEvent = getRequestObject();
		local.oEvent.setValue('runEvent',arguments.event);
		local.eventResult = {};
		local.oEventMetaInfo = getEventMetaInfo();
		local.oEventMetaParser = getEventMetaParser();
		local.currentHandlerName = $getCurrentHandler(arguments.event);
		local.eventMethod = $getCurrentEventMethod(arguments.event);
		local.viewName = $getCurrentView(arguments.event);

		// Get Current Event Handler, Method and Default View Name
		// TODO: cache the info so that no need to check next request
		// Need Cache - Starts or kind of application pooling
		if ( NOT $needHandlerReinit() and NOT needFrameWorkReinit() and local.oEventMetaInfo.KeyExists(arguments.event) ){
			StructAppend(local, local.oEventMetaInfo.getValue( arguments.event ) );
		}
		else {
			lock scope="Application" timeout="50" type="exclusive" {
				local.availableEventObjectsInfo = $getRequiredObjectsInfo(local.currentHandlerName);
				local.availableEventObjects = $loadObjectsFromFactory ( local.availableEventObjectsInfo );
			}
			for (local.key in local.availableEventObjects){
				local.oHandler = local.availableEventObjects[ local.key ];
				local.HandlerMetaInfo = local.oHandler.getEventMeta();
				
				if ( StructKeyExists(local.HandlerMetaInfo, local.eventMethod) ){
					break;	
				}
				else{
					StructDelete(local,'oHandler');
					StructDelete(local,'HandlerMetaInfo');
				}
			}
			
			var eventCacheInfo = {};
			eventCacheInfo.availableEventObjectsInfo = local.availableEventObjectsInfo;
			eventCacheInfo.availableEventObjects = local.availableEventObjects;
			if ( IsDefined('local.oHandler') ) {
				eventCacheInfo.oHandler = local.oHandler;
				eventCacheInfo.HandlerMetaInfo = local.HandlerMetaInfo;
			}
			local.oEventMetaInfo.setValue( arguments.event, eventCacheInfo);
		}
		// Need Cache - Ends

		if (!IsNull(local.HandlerMetaInfo)) {
			// Load Runtime Event Listeners if exists
			var runtimeRequestKey = '#Hash(local.currentHandlerName&local.eventMethod)#currentRuntimeEventConfig';
			lock name="#runtimeRequestKey#" timeout="10" type="exclusive" {
				if (NOT StructKeyExists( getRequestID(), runtimeRequestKey) ) {
					local.HandlerMetaInfo = oEventMetaParser.getAddtionalMetaInfo(getAppName(), local.HandlerMetaInfo, local.currentHandlerName, local.eventMethod, StructCopy(arguments.AdditionalEventInfo) );
					arguments.AdditionalEventInfo = {};
					getRequestID()[ runtimeRequestKey ] = local.HandlerMetaInfo;
				}
				else
					local.HandlerMetaInfo = getRequestID()[ runtimeRequestKey ];
			}

			//Check to see if event called event requires login
			switch(StructKeyExists(local.HandlerMetaInfo, local.eventMethod) and local.HandlerMetaInfo[local.eventMethod].IsSecured and NOT getSessionObject().getValue('IsLoggedIn') ) 	{
        	case true :
				if (StructKeyExists(getConfig().getMemento(),'LoginEvent')) {
					$runEvent(event:getConfig().getValue('LoginEvent') );
					local.processRendering = false;
				}
				break;
			case false : // Event Call- Starts
				local.processRendering = true;
				
				//lock scope="request" timeout="60" type="exclusive" { 
				
				//call standard Gateway
				if (StructKeyExists(local.availableEventObjects,'gatewayCache')) {
					if (NOT local.oHandler.exists( '#local.currentHandlerName#Gateway' ) ){
						local.oHandler.setValue( '#local.currentHandlerName#Gateway',local.availableEventObjects[ 'GatewayCache' ]);
					}
				}
				/* Inject Gateways */
				if (StructKeyExists(local.HandlerMetaInfo,'injectGateways')) {
					for (i=1; i LTE arraylen(local.HandlerMetaInfo.injectGateways); i = i + 1){
						local.GatewayName = "#local.HandlerMetaInfo.injectGateways[i]#Gateway";
						if (NOT local.oHandler.exists( local.GatewayName ) ){
							local.oHandler.setValue(local.GatewayName, $getGateway(getAppName(), local.HandlerMetaInfo.injectGateways[i]) );	
						}
					}
				}
				//call standard Service
				if (StructKeyExists(local.availableEventObjects,'serviceCache')) {
					if (NOT local.oHandler.exists( '#local.currentHandlerName#Service' ) ){
						local.oHandler.setValue( '#local.currentHandlerName#Service', local.availableEventObjects[ 'serviceCache' ]);
					}
				}
				/* Inject Services */
				if (StructKeyExists(local.HandlerMetaInfo,'injectServices')) {
					for (i=1; i LTE arraylen(local.HandlerMetaInfo.injectServices); i = i + 1){
						local.ServiceName = "#local.HandlerMetaInfo.injectServices[i]#Service";
						if (NOT local.oHandler.exists( local.ServiceName ) ){
							local.ohandler.setvalue( local.ServiceName, $getService(getAppName(), local.HandlerMetaInfo.injectServices[i] ) );	
						}
					}
				}
				//call parent Event if exists - call the same function again
				if (StructKeyExists(local.HandlerMetaInfo[ local.eventMethod ] ,'Parent')){
					local.ec = $runEvent(event: local.HandlerMetaInfo[ local.eventMethod ][ 'Parent' ], oEvent:local.oEvent, IsParentEvent : true);
					StructAppend(local.eventResult, local.ec , true);
				}
				
				//lock scope="request"  timeout="60" type="exclusive" {
					//Call preEvent
					if (StructKeyExists(local.HandlerMetaInfo ,'preEvent') && local.HandlerMetaInfo[ 'preEvent' ] ){
						local.preEventvc = getCFCInvoker().invokeCFC(oHandler:local.oHandler, eventMethod:'preEvent', oEvent:local.oEvent);
						StructAppend(local.eventResult, local.preEventvc , true);
					}
					//call pre{CurrentEvent}
					if (StructKeyExists(local.HandlerMetaInfo ,'pre#local.eventMethod#')){
						local[ 'pre#local.eventMethod#' ] = getCFCInvoker().invokeCFC(oHandler:local.oHandler, eventMethod: 'pre#local.eventMethod#', oEvent:local.oEvent);
						StructAppend(local.eventResult, local[ 'pre#local.eventMethod#' ]  , true);
					}
					// construct arguments for the event
					local.eventArgs = { oHandler=local.oHandler, eventMethod=local.eventMethod, oEvent=local.oEvent };
					if ( arguments.IsListenerEvent and StructKeyExists(arguments,'vc')){
						local.eventArgs.vc = arguments.vc;
						if ( StructKeyExists(arguments,'publiserEvent') ) {
							local.eventArgs.publiserEvent = arguments.publiserEvent;
							StructDelete(arguments, 'publiserEvent');
						}
					
					}
					// call the requested event
					local.currentEventResult = getCFCInvoker().invokeCFC( argumentCollection:local.eventArgs ); // CurrentEvent
					StructAppend(local.eventResult, local.currentEventResult , true);
					
					//call post{CurrentEvent} if exists
					if (StructKeyExists(local.HandlerMetaInfo ,'post#local.eventMethod#')){
						local[ 'post#local.eventMethod#' ] = getCFCInvoker().invokeCFC(oHandler:local.oHandler, eventMethod: 'post#local.eventMethod#', oEvent:local.oEvent);
						StructAppend(local.eventResult, local[ 'post#local.eventMethod#' ] , true);
					}
					//Call postEvent if exists
					if (StructKeyExists(local.HandlerMetaInfo ,'postEvent')  && local.HandlerMetaInfo[ 'postEvent' ] ){
						local.postEventvc = getCFCInvoker().invokeCFC(oHandler:local.oHandler, eventMethod:'postEvent', oEvent:local.oEvent);
						StructAppend(local.eventResult, local.postEventvc , true);
					}
				
					//call standard listener if exists
					if (StructKeyExists(local.availableEventObjects,'listenerCache')) {
						local.oListener = local.availableEventObjects['listenerCache'];
						if ( ( (IsListenerEvent and arguments.event EQ '#local.currentHandlerName#.#local.eventMethod#') ? false : true ) and StructKeyExists( local.oListener.getEventMeta(), local.eventMethod) ){
							local.listenerResult = getCFCInvoker().invokeCFC(oHandler:local.oListener, eventMethod: local.eventMethod, vc:local.eventResult, publiserEvent: 'Standard '&arguments.event, oEvent:local.oEvent, IsListenerEvent : true);
							StructAppend(local.eventResult, local.listenerResult , true);
						}
					}
					//Notify Other Listeners
					if (StructKeyExists(local.HandlerMetaInfo[ local.eventMethod ],'Listeners')){
						/*local.CurrentEventListeners = local.HandlerMetaInfo[ eventMethod ].Listeners;
						local.lhs = createObject('java', 'java.util.LinkedHashSet').init(local.CurrentEventListeners);
						local.CurrentEventListeners.clear();
						local.CurrentEventListeners.addAll( local.lhs );
						local.HandlerMetaInfo[ eventMethod ].Listeners = local.CurrentEventListeners;*/
						//writeDump(arraylen(local.HandlerMetaInfo[ eventMethod ].Listeners));
						//lock name="#Hash(arguments.event)#Listeners" timeout="60" type="exclusive" { 
						lock name="EventListeners-#local.eventMethod#-#local.oEvent.getValue('ID')#" timeout="60" type="exclusive" { 
							for (i=1; i LTE arraylen(local.HandlerMetaInfo[ eventMethod ].Listeners); i = i + 1){
								local.listenerResult = $runEvent(Event:local.HandlerMetaInfo[ local.eventMethod ].Listeners[i], vc:local.eventResult, oEvent:local.oEvent, publiserEvent: arguments.event,  IsListenerEvent : true);
								StructAppend(local.eventResult, local.listenerResult , true);
							}
						}
				}
				//}
				//}
				if ( local.oEvent.KeyExists(arguments.event) ){
					eventArguments.requestObject.delete(arguments.event);
                }
			}// Event Call- Ends
		}
		else
			local.processRendering = true;
		
		if (arguments.IsListenerEvent or arguments.IsParentEvent or arguments.returnData){	
			return local.eventResult;
		}
		
		// renderer layot and view 
		if ( local.processRendering ){
			
			if (local.oEvent.getValue('renderData') ){
				try{
                	getRenderer().renderData( local.eventResult );
                }
                catch(Any e){
					throw(message='Return Data has to be serialized to XML/Json/PlainText');
                }
			}
			else if ( local.oEvent.getValue('renderView') ){
				//writeDump(local.oEvent.getEventCollection());abort;
				//writeDump(local.eventResult);abort;
				if ( StructKeyExists(local.eventResult,'view') )
					local.viewName = reReplace(trim(local.eventResult.view),"[\/]",".");
				
				if ( StructKeyExists(local.eventResult,'layout') )
					local.layoutname = reReplace(trim(local.eventResult.layout),"[\/]",".");
				
				if (trim(local.viewName) NEQ '' and FindNoCase('Action', local.eventMethod) EQ 0){
					lock type="exclusive" scope="request" timeout="10" {
						local.currentEventVC[local.viewName] = local.eventResult;
					}
					param name="local.layoutname" default="default";
					if ( arguments.renderViewOnly )
						getRenderer().renderView(layoutname: '', viewName:local.viewName, eventresult:local.currentEventVC, currentEvent:arguments.event, requestObject: getRequestObject(), sessionObject:getSessionObject());
					else
						getRenderer().renderLayoutAndView(layoutname: local.layoutname, viewName:local.viewName, eventresult:local.currentEventVC, currentEvent:arguments.event, requestObject: getRequestObject(), sessionObject:getSessionObject());
					
				}
			}
		}
			
	}
	// Private functions
	private any function $getCurrentEvent(event){
		if (variables.EVENT_SEPERATOR NEQ '.')
			arguments.event = ReReplace(arguments.event,variables.EVENT_SEPERATOR,".");
		var HandlerName = ReReplace(arguments.event,"\.[^.]*$","");
		var eventMethod = ListLast(arguments.event, '.');
		if (HandlerName EQ eventMethod){
			eventMethod = 'index';
			arguments.event = '#HandlerName#.#eventMethod#';
		}
		return arguments.event;
	}
	private any function $getCurrentHandler(eventName){
		return ListFirst(arguments.eventName,'.');
	}
	private any function $getCurrentEventMethod(eventName){
		return ListRest(arguments.eventName,'.');
	}
	private any function $getCurrentView(eventName){
		return '#$getCurrentHandler(eventName)#.vw#$getCurrentEventMethod(eventName)#';
	}
	private any function $getService(AppName, requestedServiceName){
		var reqServiceName = arguments.requestedServiceName;
		var serviceName = '#arguments.AppName#.model.services.#reqServiceName#';
		var oFactory = getObjectFactory();

		if ( oFactory.exists( serviceName ) )
			return oFactory.getObject( serviceName );

		if ( $cfcIOCheck( serviceName ) ){
			return $loadObjectsFromFactory( { service = serviceName } )['service'];
		}
		return;
	}
	private any function $getGateway( requestedGatewayName ){
		var reqGatewayName = arguments.requestedGatewayName;
		var gatewayName = '#variables.AppName#.model.gateway.#reqGatewayName#';
		var oFactory = getObjectFactory();

		if ( oFactory.exists( gatewayName ) ) {
			return oFactory.getObject( gatewayName );
		}
		if ( $cfcIOCheck( gatewayName ) ){
			return $loadObjectsFromFactory( { gateway=gatewayName })[ 'gateway' ];
		}
		
		return;
	}
	private any function $getRequiredObjectsInfo(HandlerName){
		local.availableObjects = {};
		
		// create required objects Full Path
		local.handlerClassName = '#getAppName()#.handlers.events.#arguments.HandlerName#';
		local.serviceClassName = '#getAppName()#.model.services.#arguments.HandlerName#';
		local.gatwayClassName = '#getAppName()#.model.gateway.#arguments.HandlerName#';
		local.listenerClassName = '#getAppName()#.handlers.listeners.#arguments.HandlerName#';

		// if handler cfc Exists 
		if ( $cfcIOCheck(local.handlerClassName) ){
			local.availableObjects[ 'handlerClassName' ] = local.handlerClassName ;
		}
		// if handler cfc Exists 
		if ( $cfcIOCheck(local.serviceClassName) ){
			local.availableObjects[ 'serviceClassName' ] = local.serviceClassName ;
		}
		// if handler cfc Exists 
		if ( $cfcIOCheck(local.gatwayClassName) ){
			local.availableObjects[ 'gatewayClassName' ] = local.gatwayClassName ;
		}
		// if handler cfc Exists 
		if ( $cfcIOCheck(local.listenerClassName) ){
			local.availableObjects[ 'listenerClassName' ] = local.listenerClassName ;
		}
		return local.availableObjects;
		
	}
	
	private boolean function $cfcIOCheck(cfcFullPath){
		return FileExists( ExpandPath('/#ReReplace(cfcFullPath,'[.]','/','all')#.cfc')  ) ;
	}
	
	private any function $loadObjectsFromFactory(ObjectNames){
		var oName = '';
		var AvailableObjects = {};
		var oFactory = getObjectFactory();
		
		for (oName in ObjectNames){
			var o = {};
			try
            {
				if ( oFactory.exists( ObjectNames[ oName ] ) ){
					o.Instance = oFactory.getObject(  ObjectNames[ oName ]);
				}
				else {
					lock name="#Hash(ObjectNames[ oName ])#" timeout="10" type="exclusive" {
						local.initParams = {ApplicationSetting=getConfig()};
						if (FindNoCase('.gateway.',ObjectNames[ oName ]))
							local.initParams = {DataSource=getConfig().getValue('DataSource')};
							
						o.Instance = oFactory.getObject(  ObjectNames[ oName ], local.initParams );
						o.MetaInfo = getEventMetaParser().getAvailableEventMeta( ObjectNames[ oName ] );
						
						$injectUDFs(o.Instance, o.MetaInfo); // Inject Framework specific function and a generic getter and setter
						// if ( oName EQ 'handlerClassName')
						//else //TODO: create one specific to the service and gateway
							//o.MetaInfo = getComponentMetaData( ObjectNames[ oName ] );
						
					}
	            }
            }
            catch(Any e)
            {
				writeDump(e);
				writeDump(arguments);
				abort;
            }
			AvailableObjects[ ReplaceNoCase(oName,'ClassName', 'Cache') ] = o.Instance;
		}
	
		return AvailableObjects;
	} 
	private any function $injectUDFs(cfcInstance, cfcEventMeta){
		include 'mixins/gfMVCFunctions.cfm';
	}
	private struct function $loadApplicationSetting(){
		var ApplicationSetting = {};
		var configBean = getConfig();
		var i = 0;
		//TODO: add CFC check and load data
		include "/#getAppName()#/config/setting.cfm";
		
		if (StructKeyExists(ApplicationSetting,'EVENT_IDENTIFIER'))
			variables.EVENT_IDENTIFIER = ApplicationSetting.EVENT_IDENTIFIER;
		else
			variables.EVENT_IDENTIFIER = 'event';
		if (StructKeyExists(ApplicationSetting,'EVENT_SEPERATOR'))
			variables.EVENT_SEPERATOR = ApplicationSetting.EVENT_SEPERATOR;
		else
			variables.EVENT_SEPERATOR = '.';
			
		if (StructKeyExists(ApplicationSetting,'HANDLER_REINIT_PARAM'))
			variables.HANDLER_REINIT_PARAM = ListToArray(ApplicationSetting.HANDLER_REINIT_PARAM,':');
		if (StructKeyExists(ApplicationSetting,'FRAMEWORK_REINIT_PARAM'))
			variables.FRAMEWORK_REINIT_PARAM = ListToArray(ApplicationSetting.FRAMEWORK_REINIT_PARAM,':');
		
		if (StructKeyExists(ApplicationSetting,'Adapters') and IsArray(ApplicationSetting.Adapters)){
			for (i=1; i LTE arraylen(ApplicationSetting.Adapters); i = i + 1){
				include "/gfMVC/adapter/#ApplicationSetting.Adapters[i]#.cfm";
			}
		}
		return ApplicationSetting; //getFunctionCalledName
	}
	private boolean function $needHandlerReinit(){
		return $needReinit( 'HANDLER_REINIT_PARAM' );
	}
	private boolean function $needReinit(string key ){
		var ReinitRequested = false;
		if (StructKeyExists(FORM, variables[arguments.key][1] )){
			ReinitRequested = true;
			ReinitPassword = FORM [ variables[arguments.key][1] ];
		}
		else if (StructKeyExists(URL, variables[arguments.key][1])){
			ReinitRequested = true;
			ReinitPassword = URL [ variables[arguments.key][1] ];
		}
		if (ReinitRequested and variables[arguments.key][2] EQ ReinitPassword)
			return true;
		else
			return false;
	}
	
	private any function $createSessionObject(appSessionKey){ // create session facade plugin
		//var appKey = Hash(getAppKey() & session.urltoken);
		var appKey = arguments.appSessionKey;
		lock scope="session" timeout="10" type="exclusive" {
			if (NOT structKeyExists(session, appKey ) ) {
				session[appKey] = new Bean.baseBean();
			}
			var sessionBean = session[appKey];
			if (NOT sessionBean.KeyExists('IsLoggedIn') ){
				sessionBean.setValue('IsLoggedIn',false);
			}
		}
		setSessionObject( session[ appKey ] );
		return getSessionObject();
	}
}