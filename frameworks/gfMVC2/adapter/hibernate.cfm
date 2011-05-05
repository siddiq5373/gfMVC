<cflock scope="Application" type="readonly" timeout="30">
<cfscript>
	ApplicationSetting.hibernateSettings = {};
	ApplicationSetting.hibernateSettings.oDAO = new orm.DAO( logQueries : true, Development : true );
</cfscript>
</cflock>