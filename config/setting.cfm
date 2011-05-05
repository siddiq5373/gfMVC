<!--- 
ApplicationSetting is a structure which will be available from Event Handler and the View
 --->
<cfscript>
	ApplicationSetting.HANDLER_REINIT_PARAM = 'reinit:true'; //URLVarName:Password to reinit only the current event handler the rest of the events called from the object factory
	ApplicationSetting.FRAMEWORK_REINIT_PARAM = 'reinitAll:true'; //URLVarName:Password
	ApplicationSetting.EVENT_IDENTIFIER = 'ac';
	//ApplicationSetting.EVENT_SEPERATOR = '-';
	// If really need it and used muliple DSN then create datasource bean; for CF9 don't have to specify datasource name on the CFQuery tag it would read it from Applcation.cfc
	//Just use it fake the framework for right now
	ApplicationSetting.Datasource.DSN = 'gfMVCSampleDSN';
	ApplicationSetting.Datasource.DB = 'gfMVCSampleDB';
	
	ApplicationSetting.loginEvent = 'admin.index';
	
	ApplicationSetting.AdminEventsTemplatePath = '/getin';
	ApplicationSetting.defaultAdminEvent = 'admin.index';
	
	ApplicationSetting.defaultEvent = 'site.index';
	
	ApplicationSetting.Adapters = [
									'hibernate'
									];
	
</cfscript>

