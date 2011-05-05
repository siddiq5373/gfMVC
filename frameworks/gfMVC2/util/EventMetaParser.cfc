component accessors="true" displayname="Event Meta Parser" serializable="true" output="false" hint="Event Meta Parser" {
	property name="metaHelper" type="any";
	public any function init(){

		setMetaHelper( new beanMetaHelper() );
		return this;
	}
	
	public any function getAddtionalMetaInfo(string AppName, any currentEventHandlerInfo, string currentEventHandler, string currentEventMethod, any runtimeEventInfo = StructNew()){
		var additionalEventInfo = '';
		var EventConfig = [];
		var eventInfo = {};
		var currentEvent = '#arguments.currentEventHandler#.#arguments.currentEventMethod#';
		var currentEventInfo = {};
		var updatedEventInfo = arguments.currentEventHandlerInfo;
		var newEventInfo = {};
		var i = 0;
		var j = 0;
		var k = 0;
		var duplicatListener = false;
		var nativeEventInfoExists = true;
		var configExistsForThisEvent = false;
		var basicEventMeta = $getbasicEventMeta();
		if (NOT StructKeyExists(arguments.currentEventHandlerInfo, arguments.currentEventMethod) ){
			nativeEventInfoExists = false;
			newEventInfo[arguments.currentEventMethod] = StructNew();
			currentEventInfo = newEventInfo[arguments.currentEventMethod];
			currentEventInfo['listeners'] = ArrayNew(1);
			currentEventInfo['parent'] = '';
			currentEventInfo['IsSecured'] = false;
		}
		else {
			newEventInfo[arguments.currentEventMethod] = StructNew();
			StructAppend( newEventInfo[arguments.currentEventMethod],  duplicate(arguments.currentEventHandlerInfo[arguments.currentEventMethod]) );
			currentEventInfo = newEventInfo[arguments.currentEventMethod];
			if (NOT StructKeyExists(currentEventInfo, 'listeners') ){
				currentEventInfo['listeners'] = ArrayNew(1);
			}
			if (NOT StructKeyExists(currentEventInfo, 'parent') ){
				currentEventInfo['parent'] = '';
			}
			if (NOT StructKeyExists(currentEventInfo, 'IsSecured') ){
				currentEventInfo['IsSecured'] = false;
			}
		}
		if ( FileExists( ExpandPath('/#arguments.AppName#/config/eventConfig.cfm') ) ) 
			include "/#arguments.AppName#/config/eventConfig.cfm";
		
		if (StructKeyExists(arguments,'runtimeEventInfo')){
			if ( IsStruct(arguments.runtimeEventInfo) and NOT structIsEmpty(arguments.runtimeEventInfo) ){
				lock scope="request" type="readonly" timeout="10" {
					ArrayAppend(EventConfig, duplicate(arguments.runtimeEventInfo) );
				}
			}
		}
		for (i = 1; i LTE ArrayLen(EventConfig); i = i + 1) {
			if (EventConfig[i]['event'] EQ currentEvent){
				//writeDump(EventConfig);abort;
				if (StructKeyExists(EventConfig[i],'parent')){
					if (NOT StructKeyExists(currentEventInfo,'parent') or currentEventInfo['parent'] EQ '')
						currentEventInfo['parent'] = EventConfig[i]['parent'];
				}
				if (StructKeyExists(EventConfig[i],'listeners')){
				
					if (IsArray(EventConfig[i]['listeners']))
						additionalEventInfo = EventConfig[i]['listeners'];
					else
						additionalEventInfo = ListToArray(EventConfig[i]['listeners']);
					
					if (StructKeyExists(currentEventInfo,'listeners') ){
						duplicatListener = false;
						
						
						for (j = 1; j LTE ArrayLen(additionalEventInfo); j = j + 1) {
							
							for (k = 1; k LTE ArrayLen(currentEventInfo['listeners']); k = k + 1) {
								if (currentEventInfo['listeners'][k] EQ additionalEventInfo[j]){
									duplicatListener = true;
									break;
								}
								else 
									duplicatListener = false;
							}
							if (NOT duplicatListener)
								ArrayAppend(currentEventInfo['listeners'],additionalEventInfo[j]);
						}
					}
				}
				if (StructKeyExists(EventConfig[i],'securedEvent'))
					currentEventInfo[arguments.currentEventMethod]['IsSecured'] = EventConfig[i]['securedEvent'];
				
				if (StructKeyExists(EventConfig[i],'additionalMeta')){
					var additionalMeta = EventConfig[i]['additionalMeta'];
					for (metaAttr in additionalMeta){
						if (arrayFindNoCase(basicEventMeta,metaAttr) EQ 0){
							eventInfoToCache[arguments.currentEventMethod][metaAttr] = additionalMeta[metaAttr];
		    			}
					}
				}
			}
		}
		if (currentEventInfo['parent'] EQ '')
			StructDelete(currentEventInfo,'parent');
		if ( arraylen(currentEventInfo['listeners']) EQ 0)
			StructDelete(currentEventInfo,'listeners');

		StructAppend(updatedEventInfo[arguments.currentEventMethod], currentEventInfo, true);
		return updatedEventInfo;
	}
	
	private array function $getbasicEventMeta(){
		var basicEventMeta = ['securedEvent', 'Parent', 'Listeners', 'injectGateways', 'injectServices', 'parameters', 'name', 'returntype', 'access', 'gfMVC:Cache'];
		return basicEventMeta;
	}

	public struct function getAvailableEventMeta(any eventHandler, string eventName = ''){
		var _eventObject = arguments.eventHandler;
		var _eventName = arguments.eventName;
		var eventObjectInfo = duplicate(getComponentMetaData(_eventObject));
		var i = 0;
		var metaAttr = 0;
		var eventInfo = {};
		var eventInfoToCache = {};
		var securedEvents = $CheckSecuredEvent(eventObjectInfo);
		var excludeEvents = 'preEvent,postEvent';
		var injectGateways = 'removeMe';
		var injectServices = 'removeMe';
		var basicEventMeta = $getbasicEventMeta();
		
		eventObjectInfo.functions = getMetaHelper().getAllFunctions( eventObjectInfo );
		
		eventInfoToCache[ 'name' ] = _eventObject;
		eventInfoToCache['preEvent'] = $CheckPrePostEvents(eventObjectInfo.functions, 'preEvent');
		eventInfoToCache['postEvent'] = $CheckPrePostEvents(eventObjectInfo.functions, 'postEvent');
		eventInfoToCache.Gateways =[];
		eventInfoToCache.Services = [];
		if ( structKeyExists(eventObjectInfo,'injectGateways') ) {
			if (eventObjectInfo.injectGateways NEQ '')
				injectGateways = injectGateways & ',' & eventObjectInfo.injectGateways;
		}
		if ( structKeyExists(eventObjectInfo,'injectServices') ) {
			if (eventObjectInfo.injectServices NEQ '')
				injectServices = injectServices & ',' &eventObjectInfo.injectServices;
		}

		//for (i=1; i LTE arraylen(eventObjectInfo.functions); i = i + 1){
		for (functionName in eventObjectInfo.functions) {
			//eventInfo = eventObjectInfo.functions[i];
			eventInfo = eventObjectInfo.functions[ functionName ];
			if (ListFindNoCase(excludeEvents,eventInfo.name) EQ 0) {
				eventInfoToCache[eventInfo.name]['hasPreEvent'] = $CheckPrePostEvents(eventObjectInfo.functions, 'pre#eventInfo.name#');
				eventInfoToCache[eventInfo.name]['hasPostEvent'] = $CheckPrePostEvents(eventObjectInfo.functions, 'post#eventInfo.name#');
			
				if (NOT securedEvents and StructKeyExists(eventInfo,'securedEvent')) 
					eventInfoToCache[eventInfo.name]['IsSecured'] = eventInfo['securedEvent']; 
				else
					eventInfoToCache[eventInfo.name]['IsSecured'] = securedEvents; 
				
				if (StructKeyExists(eventInfo,'Parent'))
					eventInfoToCache[eventInfo.name]['Parent'] = eventInfo['Parent']; 
				if (StructKeyExists(eventInfo,'Listeners'))
					eventInfoToCache[eventInfo.name]['Listeners'] = ListToArray(eventInfo['Listeners']);
				
				if ( structKeyExists(eventInfo,'injectGateways') ) {
					if (eventInfo.injectGateways NEQ '')
						injectGateways = injectGateways&','&eventInfo.injectGateways;
				}
				if ( structKeyExists(eventInfo,'injectServices') ) {
					if (eventInfo.injectServices NEQ '')
						injectServices = injectServices&','&eventInfo.injectServices;
				}
				if ( structKeyExists(eventInfo,'gfMVC:Cache') ) {
					eventInfo.Cache = eventInfo['gfMVC:Cache'];
				}
				for (metaAttr in eventInfo){
					if (arrayFindNoCase(basicEventMeta,metaAttr) EQ 0){
						eventInfoToCache[eventInfo.name][metaAttr] = eventInfo[metaAttr];
	    			}
				}
			}				                	
		}
		injectGateways = listRest(injectGateways);
		injectServices = listRest(injectServices);
		if (injectServices NEQ ''){
			eventInfoToCache.injectServices = listToArray(injectServices);
		}
		if (injectGateways NEQ ''){
			eventInfoToCache.injectGateways = listToArray(injectGateways);
		}
		
		if ( structKeyExists(eventObjectInfo,'gfMVC:Cache') ) {
			eventInfoToCache.Cache = eventObjectInfo['gfMVC:Cache'];
		}
		eventInfoToCache.securedEvents = securedEvents;
		
		return eventInfoToCache;
	}
	private boolean function $CheckPrePostEvents(any eventObjectInfo, string eventName){
		var i = 1;
		var eventInfo = '';
		
		return StructKeyExists(arguments.eventObjectInfo, arguments.eventName);
		/*
		for (i=1; i LTE arraylen(arguments.eventObjectInfo); i = i + 1){
			eventInfo = arguments.eventObjectInfo[i];
			if (eventInfo.name EQ arguments.eventName)
				return true;
		}
		return false;*/
	}
	private boolean function $CheckSecuredEvent(eventInfo){
		var eventObjectInfo = arguments.eventInfo;
		var securedEvents = false;
		if (StructKeyExists(eventObjectInfo,'securedEvents'))
			securedEvents = eventObjectInfo['securedEvents'];
		return securedEvents;
	}
}