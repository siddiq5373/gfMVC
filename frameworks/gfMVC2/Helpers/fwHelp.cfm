<cfscript>
// Additional View Helper Functions
function getFWController() {
	return Application[attributes.AppKey]['controller'];
}
function renderView(Name='', vc = '', overwrite = true, event='',eventArgs='') {
	var genratedView = '';
	param name="arguments.eventresult" default="#StructNew()#";
	
	if (NOT StructKeyExists(arguments,'viewName'))
		arguments.ViewName = arguments.Name;
	if (NOT StructKeyExists(arguments,'eventName'))
		arguments.eventName = arguments.event;
	
	StructDelete(arguments,'Name');
	StructDelete(arguments,'event');
	
	if( NOT StructKeyExists(arguments,'viewName') or trim(arguments.ViewName) EQ '' ) // Get the currentView
		arguments.ViewName = attributes.viewName;
	if( NOT StructKeyExists(arguments,'eventName') or trim(arguments.eventName) NEQ '' ) // run event
		arguments.eventresult[arguments.ViewName] = runEvent(eventName,false,eventArgs);
	else if ( StructKeyExists(attributes, 'vc') and IsStruct(attributes.vc) )
		arguments.eventresult = structCopy(attributes.vc);
	
	if (StructKeyExists(arguments,'vc') and isStruct(arguments.vc)) // Get additional vc
	{
		if (NOT structKeyExists(arguments.eventresult, arguments.ViewName))
			arguments.eventresult[arguments.ViewName] = {};
		structAppend(arguments.eventresult[arguments.ViewName], arguments.vc, arguments.overwrite);
	}
	
	arguments.requestObject = getRequestObject();//attributes.rc;
	arguments.sessionObject = arguments.requestObject.getSessionObject();//attributes.sessionObject;
	arguments.Controller = getFWController();
	//savecontent variable="genratedView"  {
		getFWController().getRenderer().renderView(argumentCollection:arguments);
	//}
	//return genratedView;
	//if (StructKeyExists(arguments,'vc'))
		//structDelete(arguments,'vc');
}
function runEvent(Name='', renderView = false, eventArgs = '' ) {
	arguments.requestObject = request[request.appKey]; //attributes.rc;
	arguments.sessionObject = arguments.requestObject.getSessionObject();// attributes.sessionObject;
	if (NOT StructKeyExists(arguments,'eventName'))
		arguments.eventName = arguments.Name;
	arguments.event = arguments.eventName;
	StructDelete(arguments,'Name');
	if (IsStruct(arguments.eventArgs)){;
		getRequestObject().setValue(arguments.event, StructCopy(arguments.eventArgs) );
	}
	structDelete(arguments,'eventArgs');
	if (arguments.renderView)
		arguments.renderViewOnly = arguments.renderView;
	else
		arguments.returnData = true;
	if (Not IsDefined('getFWController')){
		var controller = Application[attributes.AppKey]['controller'];
		return controller.dispatchEvent(argumentCollection:arguments);
	}
	return getFWController().dispatchEvent(argumentCollection:arguments);
}
function getAppKey() {
	if (NOT IsDefined(attributes.AppKey)){
		return Application.ApplicationName;
	}
	else 
		return attributes.AppKey;
}
function getAppName() {
	return getFWController().getAppName();
}
function getApplicationSetting() {
	getFWController().getConfig();
}
function getRequestObject() {
	return getFWController().getRequestObject();
}
function getSessionObject() {
	return getFWController().getSessionObject();
}
function getErrorInfo() {
	var oSession = getFWController().getSessionObject();
	var ErrorMessage = '';
	var ErrorInfo = {occured = false};
	
	if ( oSession.KeyExists('ErrorMessage') ) {
		ErrorMessage = duplicate(oSession.getErrorMessage());
		oSession.deleteErrorMessage();
	}
	if ( trim(ErrorMessage) NEQ ''){
		ErrorInfo.occured = true;
		ErrorInfo.Message = ErrorMessage;
	}
	
	return ErrorInfo;
}
function showEventInfo() {
	if (NOT StructKeyExists(request,'eventsFired'))
		request.eventsFired = ArrayNew(1);
	return request.eventsFired;
}
function getEventName() {
	var rc = getFWController().getRequestObject().getMemento();
	return rc.EVENT_IDENTIFIER;
}
function getLink(string eventName = 'index', string additionalInfo = '', string handler = '') {
	var rc = getFWController().getRequestObject().getMemento();
	
	var CurrentEventHandler = ListFirst(rc.CurrentEvent,rc.EVENT_SEPERATOR);
	
	if (trim( arguments.handler ) NEQ '')
		CurrentEventHandler = arguments.handler;
	if (ListLen(arguments.eventName,rc.EVENT_SEPERATOR) EQ 1){
		if ( trim(arguments.additionalInfo) EQ '') 
			arguments.eventName = CurrentEventHandler & rc.EVENT_SEPERATOR & arguments.eventName;
		else {
			arguments.eventName = arguments.handler & rc.EVENT_SEPERATOR & arguments.eventName;
		}
	}
	if (trim(arguments.additionalInfo) NEQ '')
		arguments.additionalInfo = '&'&arguments.additionalInfo;
		
	return '#CGI.SCRIPT_NAME#?#rc.EVENT_IDENTIFIER#=#arguments.eventName##trim(arguments.additionalInfo)#';
}
function getSEOLink(string additionalString = '', string AddtionalQStringSep = '?' ) {
	var uc = URL;
	var QUERYSTRING = '';
	var QUERYSTRING_Array = '';
	var SEOURLString = '';
	
	if ( StructKeyExists(uc,'$404') ) {
		uc.page = ListFirst(ListRest('/removeMe'&uc['$404'],'/'), arguments.AddtionalQStringSep );
		SEOURLString = uc.page;
		QUERYSTRING = ListRest(uc['$404'], arguments.AddtionalQStringSep) ;
		QUERYSTRING_Array = ListToArray(QUERYSTRING,"/");
		for (local.i=2;local.i lte ArrayLen(QUERYSTRING_Array);local.i=local.i+2){
			variableName = QUERYSTRING_Array[local.i-1];
			variableValue = QUERYSTRING_Array[local.i];
			
			URL[variableName] = variableValue;
		}
		URL.page = uc.page;
		
		additionalString =  REReplace(additionalString, "[&=]", "/", "ALL");
		//if (ArrayLen(QUERYSTRING_Array) EQ 0)
			additionalString = arguments.AddtionalQStringSep & additionalString;
		//else
		//	additionalString = '/' & additionalString;
	}
	
	return SEOURLString&additionalString;
}
function getPlugin(string name) { 
	var pluginFullPath = 'gfMVC.plugins.#arguments.name#';
     return getFWController().getObjectFactory().getObject(pluginFullPath);
}

function renderJS(){
	var JSHelperContent = '';
	var JSHelperPath = '';
	var currentViewName = '';
	var viewHelper = '';
	var viewName = '';
	var currentViewHelperIndex = 0;
	var JSHelpers = getRequestObject().getViewJSHelpers();	
	savecontent variable="JSHelperContent" {
		if ( StructKeyExists(attributes,'layoutName') ){ // Render All JS from Layout
			if ( FileExists( ExpandPath('/#variables.AppName#/layouts/#attributes.layoutName#JSHelper.cfm') ) ){
				writeoutput('<!-- #attributes.layoutName# js Helper --> #chr(13)#');
				include "/#attributes.AppName#/layouts/#attributes.layoutName#JSHelper.cfm";
				for (local.i = 1; ArrayLen(JSHelpers) >= local.i; local.i++){
					viewHelper = JSHelpers[local.i];
					for (viewName in viewHelper){
						JSHelperPath = viewHelper[ viewName ];
						if ( FileExists(ExpandPath('#JSHelperPath#')) ){
							writeoutput('<!-- viewName js Helper --> #chr(13)#');
							include "#JSHelperPath#";
							getRequestObject().removeViewJSHelpers(viewHelper);
						}
					}
				}
			}
		}
		else if ( StructKeyExists(attributes,'viewName') and StructKeyExists(variables,'jsHelperInfo') ) { // Render javascript from View itself
			currentViewHelperIndex = ArrayFind(JSHelpers, variables.jsHelperInfo);
			if (currentViewHelperIndex GT 0){
				viewHelper = JSHelpers[currentViewHelperIndex];
				for (viewName in viewHelper){
					JSHelperPath = viewHelper[ viewName ];
					if ( FileExists(ExpandPath('#JSHelperPath#')) ){
						writeoutput('<!-- viewName js Helper --> #chr(13)#');
						include "#JSHelperPath#";
						getRequestObject().removeViewJSHelpers(viewHelper);
					}
				}
			}
		}
	}
	return JSHelperContent;
}

StructAppend(variables,attributes);
if ( FileExists(ExpandPath('/#getAppName()#/views/helpers/ApplicationHelper.cfm')) )
	include "/#getAppName()#/views/helpers/ApplicationHelper.cfm";
</cfscript>
<!---<cffunction name="$renderJSContent">
	<cfset var JSHelperContent = '' />
	<cfset var JSHelperPath = '' />
	<cfset var currentViewName = '' />
	<cfset var viewHelper = '' />
	<cfset var viewName = '' />
	<cfsavecontent variable="JSHelperContent">
		<cfif StructKeyExists(attributes,'layoutName')>
			<cfif FileExists(ExpandPath('/#variables.AppName#/layouts/#attributes.layoutName#JSHelper.cfm'))>
			<cfoutput><!-- #attributes.layoutName# js Helper --> #chr(13)# </cfoutput>
				<cfinclude template="/#attributes.AppName#/layouts/#attributes.layoutName#JSHelper.cfm" />
			</cfif>
			<cfset JSHelpers = getRequestObject().getViewJSHelpers() />
			<cfloop array="#JSHelpers#" index="viewHelper">
				<cfloop collection="#viewHelper#" item="viewName">
					<cfset JSHelperPath = viewHelper[ viewName ] />
					<cfif FileExists(ExpandPath('#JSHelperPath#'))>
						<cfoutput><!-- #viewName# js Helper --> #chr(13)# </cfoutput>
						<cfinclude template="#JSHelperPath#" />
						<cfset getRequestObject().removeViewJSHelpers(viewHelper) />
					</cfif>
				</cfloop>
			</cfloop>
		<cfelseif StructKeyExists(attributes,'viewName') >

			<cfset currentViewName = attributes.viewName />
			<cfset JSHelpers = getRequestObject().getViewJSHelpers() />
			<cfset index = ArrayFind(JSHelpers, variables.jsHelperInfo) />
			<cfset viewHelper = JSHelpers[index] />
			<cfloop collection="#viewHelper#" item="viewName">
				<cfset JSHelperPath = viewHelper[ viewName ] />
				<cfif FileExists(ExpandPath('#JSHelperPath#'))>
					<cfoutput><!-- #viewName# js Helper --> #chr(13)# </cfoutput>
					<cfinclude template="#JSHelperPath#" />
					<cfset getRequestObject().removeViewJSHelpers(viewHelper) />
				</cfif>
			</cfloop>
		</cfif>
	</cfsavecontent>
	<cfreturn JSHelperContent />
</cffunction>--->