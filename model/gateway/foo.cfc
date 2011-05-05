<cfcomponent output="false">
	<cffunction name="init">
		<cfargument name="Datasource" required="false" type="struct" default="#StructNew()#" />
		<cfscript>
			StructAppend(variables,arguments.Datasource);
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="getDSN">
		<cfset var qResult = '' />
		
		<!---<cfstoredproc datasource="#variables.dsn#" procedure="#variables.db#.dbo.usp_get_locations_for_display">
			
			<cfprocresult name="qResult" resultset="1">
		</cfstoredproc>--->
		
		<cfreturn variables.DSN & ':' & variables.DB />
	</cffunction>
	
</cfcomponent>