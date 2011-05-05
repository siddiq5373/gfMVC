<cfcomponent output="false">
	
	<cffunction name="init" output="false">
		<!---<cfargument name="ApplicationSetting" required="true" />
		<cfargument name="DataSource" required="true" />
		<cfargument name="modelPath" required="true" />--->
		
		<cfscript>
			//variables.oGateway = createObject("component","#arguments.modelPath#.gateway.Foo").init(arguments.DataSource);
			return this;       	        
        </cfscript>
	</cffunction>
	
	<cffunction name="getListing" output="false">
		<cfscript>
			return variables.oGateway.getNewListing();
		</cfscript>
	</cffunction>
</cfcomponent>