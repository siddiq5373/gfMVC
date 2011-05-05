<cfcomponent name="Form post Event"
			 hint="Form post Event"
			 output="false">
	
	<cffunction name="init">
		<cfargument name="ApplicationSetting" required="true" />
		<cfset variables.ApplicationSetting = arguments.ApplicationSetting />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="post">
		<cfargument name="event" required="true" type="any" />
		
		<cfdump var="#FORM#">
	
	</cffunction>		

</cfcomponent>
