component  namespace="Application" name="Application" output="false" {
		
	this.name = $getAppKey(); 
	this.ormenabled = true;
	this.datasource="gfMVCSampleDSN";

	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,30,0);
	this.setClientCookies = true;
	this.setDomainCookies = true;
	
	this.mappings['/gfMVC'] = '#$getAppRoot()#\frameworks\gfMVC2';
	this.mappings['/orm'] = '#$getAppRoot()#\frameworks\hibernate';
	this.mappings['/model'] = '#$getAppRoot()#\model\hibernate';
	this.mappings['/sampleApp'] = $getAppRoot();
	this.customtagpaths = $getAppRoot();

	this.ormsettings = {
		datasource = this.datasource,
		cfclocation = "/model",
		dbcreate="none",
		eventhandling= true,
		logsql="true",
		dialect='MicrosoftSQLServer',
		secondarycacheenabled = false,
		Cacheprovider = 'EHCache',
		savemapping = false,
		useDBForMapping = true,
		flushatrequestend = true,
		automanageSession = true // cf 9.0.1
	};

	this.mappings["/vfs"] = "ram:///";
	
	public boolean function onApplicationStart() output=false{
		var ApplicationKey = $getAppKey();
		var FrontEndControllerName = 'index.cfm';
		
		Application.AppMapName = 'sampleApp';
		Application[ApplicationKey]['controller'] = createObject('component','gfMVC.CF9controller').init(Application.AppMapName, ApplicationKey, FrontEndControllerName);
		
		//request.reinitDB = true;
		
		return true;
	}
	
	public boolean function onRequestStart(String targetPage){
		//ORMFlush();
		//ApplicationStop();abort;
		if (IsDefined('request.reinitDB')){
			ORMReload();//ApplicationStop();

		}
		if (StructKeyExists(URL, "reload")) {
			ORMReload();
			//ORMFlush();
			//ApplicationStop();
			location('index.cfm',false);
		}
		
		if(!isNull( url.rebuild )) {
			this.ormSettings.dbCreate = "drop create";
			ORMReload();
			ApplicationStop();
			location('index.cfm', false);
			return false;
		}

		//if( findNoCase(Application[$getAppKey()]['controller'].getFrontEndControllerName(),listLast(arguments.targetPage,"/")) ){
		if( Application[$getAppKey()]['controller'].getFrontEndControllerName() EQ listLast(arguments.targetPage,"/") ){
			request.reloadAll = Application[$getAppKey()]['controller'].needFrameWorkReinit();
			if ( request.reloadAll ){
				onApplicationStart();
			}
			
			Application[$getAppKey()]['controller'].processRequest();
		}
		request.oSession = Application[$getAppKey()]['controller'].getSessionObject(); // Used for FCK editor
		
		
		return true;
	}
	/*
	public function onRequest(targetPath){
		 Application[$getAppKey()]['controller'].processRequest();
	}*/
	
	public any function onCFCRequest (string cfcname, string method, struct args ) output="false" {
		
		var fwController =$getFrameworkController('/index.cfm');
		var oProxy = createObject(cfcname).init();
		if (NOT StructKeyExists(args,'params')){
			args.params = '';
		}
		var returnData =  oProxy.proxy(fwController, args.events, args.params);
		
		return returnData;
		
		//writeDump(returnData);abort;
		//writeDump(evaluate('#cfcname#()'));abort;
		//writeDump(request.fwController);abort;
		//writeDump('#Replace(cfcname,#.#method#(events:args)');abort;
		
	}

	public void function onSessionStart() output=false{
		
	}
	
	public void function onSessionEnd(struct sessionScope, struct appScope) output=false{
		
	}
	
	public void function onMissingMethod(String method,Struct args) {
		writeDump(arguments);abort;
	}


	/* Private Functions */
	private string function $getAppKey(){
		return hash(getCurrentTemplatePath());
	}
	private string function  $getAppRoot(){
		//return 'd:\www\gfMVC1\';
		return ReplaceNoCase( getDirectoryFromPath(getCurrentTemplatePath()), '\root\','' );
	}

	private any function $getFrameworkController(targetPage){

		if( findNoCase(Application[$getAppKey()]['controller'].getFrontEndControllerName(),listLast(arguments.targetPage,"/")) ){
			if ( Application[$getAppKey()]['controller'].needFrameWorkReinit() ){
				onApplicationStart();
			}
		}
		request.fwController = Application[$getAppKey()]['controller'];
		return Application[$getAppKey()]['controller'];
	}
}