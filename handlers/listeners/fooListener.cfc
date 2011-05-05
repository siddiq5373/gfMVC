<cfcomponent output="false" hint="View Specific Events">
	
	<cffunction name="init">
		<cfargument name="ApplicationSetting" required="true" />
		<cfset variables.ApplicationSetting = arguments.ApplicationSetting />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="HandlerIndexEvent" eventType="data" returnformat="JSON">
		<cfargument name="Event" required="false" />
		<cfargument name="vc" required="false" />
		<cfscript>
        	var sc = arguments.event.getSessionCollection();
			var rc = arguments.event.getRequestCollection();
			var ec = arguments.event.getEventCollection();       
        </cfscript>

		<!---<cfdump var="#arguments#" label="HandlerIndexEvent"><cfabort>--->
		<cfset var eventReturnStruct = vc />
		<cfset var returnData = StructNew() />
		<cfparam name="request.count" default="0" />
		<cfset request.count = request.count + 1/>
		<cfset returnData.returnThisJSON = 'coo coo #request.count#' />
		<cfset eventReturnStruct.data1 =  serializeJSON(returnData) />

		<cfreturn eventReturnStruct />
	</cffunction>
	
	
	<cffunction name="renderHomPage" eventType="data" returnformat="JSON">
		<cfargument name="Event" required="false" />
		<cfargument name="vc" required="false" />
		<cfscript>
        	var sc = arguments.event.getSessionCollection();
			var rc = arguments.event.getRequestCollection();
			var ec = arguments.event.getEventCollection();       
        </cfscript>
		<cfset var eventReturnStruct = vc />
		
		<cfset var returnData = StructNew() />
		
		<cfset returnData.returnThisJSON = 'coo coo' />
		<cfset eventReturnStruct.data2 =  serializeJSON(returnData) />
		<!---<cfscript>
			eventReturnStruct.view = 'foo.vwIndex';
			eventReturnStruct.layout = 'layout1';        	        
			eventReturnStruct.from = 'I am at renderHomPage Listener';        	        
        </cfscript>--->

		<cfreturn eventReturnStruct />
	</cffunction>
	
	<cffunction name="setLayoutandView" eventType="data" returnformat="JSON">
		<cfargument name="Event" required="false" />
		<cfargument name="vc" required="false" />
		<cftry>
		<cfscript>
        	var sc = arguments.event.getSessionCollection();
			var rc = arguments.event.getRequestCollection();
			var ec = arguments.event.getEventCollection();       
        </cfscript>	        
        <cfcatch type="Any" >
        	<cfdump var="#arguments.event.getMemento()#"><cfabort>
        </cfcatch>
        </cftry>
		
		<cfset var eventReturnStruct = vc />
		
		<cfset var returnData = StructNew() />
		
		<cfset returnData.returnThisJSON = 'coo coo' />
		<cfset eventReturnStruct.data2 =  serializeJSON(returnData) />
		<cfscript>
			eventReturnStruct.view = 'foo.vwIndex';
			eventReturnStruct.layout = 'layout1';        	        
			eventReturnStruct.from = 'I am at setLayoutandView Listener #ec.SupaCoo# ';        	        
        </cfscript>

		<cfreturn eventReturnStruct />
	</cffunction>
	
</cfcomponent>
