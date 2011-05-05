<cfcomponent output="false">
	
	<cffunction name="init">
		<cfargument name="ApplicationSetting" required="true" />
		<cfset variables.ApplicationSetting = arguments.ApplicationSetting />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="onApplicationStart">
		<cfscript>
			//Do Something like create Singletons  	        
        </cfscript>

	</cffunction>
	
	<cffunction name="onRequestStart">
		<cfscript>
			//Validate Session like IsLoggedin      	        
        </cfscript>

	</cffunction>
	
	
</cfcomponent>
