<cfscript>
	local.fwSettings = ApplicationSetting.getfusedDBServiceSettings;
	local.ReInitInfo = local.fwSettings.getfusedDBServiceReinitSetting;
	local.ReCreateAll = true;
	local.IsValidPassword = false;
	
	if (local.ReInitInfo.Password != ''){
		if (URL.fwreinit == local.ReInitInfo.Password){
			local.IsValidPassword = true;
			local.ReCreateAll = true;
		}
	}
	else if (local.ReInitInfo.Password == '')
		local.IsValidPassword = true;
		
	switch(local.ReInitInfo.Type){
	case 'reinitAll':
		local.ReCreateAll = true;
   		break;
	case 'disable':
		local.ReInitConfig = false;
   		break;
	}
		
	local.oGetfusedORMBaseBean = createObject('getfusedDBService.base.Bean').init();
	local.ORMservice =  createObject('getfusedDBService.DBServiceLoader').init();
	local.ORMservice.setDataSource(ApplicationSetting.gfORM);
	local.ORMservice.setGetfusedORMBaseBean(local.oGetfusedORMBaseBean);
	
	if (local.ReCreateAll)
		local.ORMservice.initializeAllClass(ObjectHelperLocation:local.fwSettings.getfusedDBServiceObjectHelperLocation);
	
	ApplicationSetting.ORMService = local.ORMservice;
	

	Application.oCFCGatewayHelper = createObject('getfusedDBService.helpers.GatewayHelper').init();
	//Application.oGroovyUtil = createObject('java','com.getfused.groovy.util.QueryToArray');
	Application.oCFCServiceHelper = createObject('getfusedDBService.helpers.ServiceHelper').init();
	Application.oCFCMetaHelper = createObject('getfusedDBService.helpers.beanMetaHelper').init();
</cfscript>
