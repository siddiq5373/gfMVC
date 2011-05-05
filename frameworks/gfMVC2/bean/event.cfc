component extends="baseBean" accessors="false" hint="Event Bean" serializable="true"  {
	//request.eventCollection = {};	
	public any function init(config, objectFactory, storageKey) { 
		variables.oFactory = arguments.objectFactory;
		variables.oConfig = arguments.config; 	
		variables.storageKey = arguments.storageKey; 	
		variables.viewJSHelpers = [];
		variables.viewCollection = {};
        return this; 
    }
	public any function getConfig() { 
        return variables.oConfig;
    }
	public any function getObjectFactory() { 
        return variables.oFactory; 
    }
	public any function getRequestCollection() { 
		return getRequestObject().getMemento(); 

    }
	public any function getSessionCollection() { 
		return getSessionObject().getMemento(); 
    }
	public any function getRequestObject() { 
		return this; //request[ variables.storageKey ];
    }
	public any function getSessionObject() { 
		return session[ variables.storageKey ];
    }
	public any function getFormCollection() { 
        return getEventCollection(); 
    }
	public any function getURLCollection() { 
        return getEventCollection(); 
    }
	public any function getPlugin(string name) { 
		var pluginFullPath = 'gfMVC.plugins.#arguments.name#';
        return getObjectFactory().getObject(pluginFullPath);
    }
	public boolean function IsGFAjaxRequest(){
		var reqIfo = getHTTPRequestData();
		if ( structKeyExists(reqIfo.headers,"X-Requested-With") and reqIfo.headers["X-Requested-With"] eq "XMLHttpRequest")
			return true;
		else
			return false;	
	}
	public void function createViewCollection(string currentEvent){
		variables.viewCollection [ getValue('currentEvent') ] = {};
		createEventCollection( currentEvent );
	}
	public void function createEventCollection(){
		request[ variables.storageKey ] ['eventCollection'] = {};
	}
	public any function getViewCollection(){
		return variables.viewCollection [ getValue('currentEvent') ];
	}
	public any function getEventCollection(){
		var currentEventCollection = request[ variables.storageKey ] ['eventCollection'];

		if ( KeyExists('runEvent') ){
			var reqEventName = getValue('runEvent');
			lock name="#getValue('ID')#" timeout="2" throwontimeout="false" {
				if ( KeyExists( reqEventName ) ){
					var updatedCollection = duplicate(currentEventCollection);
					StructAppend( updatedCollection,  getValue( reqEventName ) );
					return updatedCollection;
					
				}
			}
		}
		return currentEventCollection;
	}
	public void function addToViewCollection(any vc){
		StructAppend( variables.viewCollection [ getValue('currentEvent') ], vc, true);
	}
	public void function addToJSHelpers(string viewName, string helperPath){
		ArrayAppend(variables.viewJSHelpers, { "#viewName#" = helperPath });
	}
	public array function getViewJSHelpers(){
		return variables.viewJSHelpers;
	}
	public void function removeViewJSHelpers(helperObject){
		arrayDelete(variables.viewJSHelpers,helperObject);
	}
	public void function addToEventCollection(any ec){
		StructAppend( getEventCollection(), arguments.ec, true);
	}
	// Need Event Pooling 
	public void function addToEventPoolCollection(any eventName){
		param name="variables.EventPoolCollection" default="#ArrayNew(1)#";
		ArrayAppend(variables.EventPoolCollection,eventName);
	}
	
	public any function getORMModel(string ClassName) {
		
		var key = 'getfusedDBService.#arguments.ClassName#';

        if (NOT getObjectFactory().exists(key) ){
			var oORMService = new getfusedDBService.base.Service();
			oORMService.setDatasource( new cms3Lite.model.base.DataSource( argumentCollection:getConfig().getValue('gfORM') ) );
			oORMService.setClassName( arguments.ClassName );
			
			oORMService.postProcessBeanFactory();
			
			getObjectFactory().setObject(oORMService, key );
			
		}
		 var cachedObject = getObjectFactory().getObject( key );
		return cachedObject;
    }
	
}
