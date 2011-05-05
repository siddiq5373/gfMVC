<cfcomponent displayname="Proxy" output="false">
	
	<cffunction name="init" access="remote" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="proxy" access="remote" output="false" returnformat="json">
		<cfargument name="controller" required="true" type="any">
		<cfargument name="events" required="true" type="any">
		<cfargument name="additionalParams" required="true" type="any">
		
		<cfset var response = {}>
		<cfset var eventArgs = {}>
		<cfset var event = {}>
		<cfset var reqIfo = '' />
		<cfset var eventResponse = "">
		<cfset var eventInfo = DeserializeJSON(arguments.events) />
		<cfset var eventAjaxListener = {} />

		<cfset response['display'] = {} />
		<!--- We will assume that this was successful if this code executed and returned a response struct --->
		<cfset response['success'] = true>
		<cfset response['listeners'] = []>
		<cfset StructClear(FORM) />
		<cfif isJSON(arguments.additionalParams)>
			<cfset StructAppend(FORM, DeserializeJSON(arguments.additionalParams) ) />
		</cfif>
		<!---<cfdump var="#arguments#">
		<cfdump var="#isJSON(arguments.additionalParams)#">
		<cfdump var="#FORM#"><cfabort>--->
		<cftry>
		<cfloop array="#eventInfo#" index="event">
			<cfset StructAppend(FORM,event.data) />
			<cfset FORM.ac =  event.Name />
			<cfset eventAjaxListener = {} />
			<cfset eventAjaxListener['handler'] = listFirst(event.Name,'.') />
			<cfset eventAjaxListener['listener'] = listLast(event.Name,'.')&"Response" />

			<cfif StructKeyExists(event,'listeners')>
				<cfset eventAjaxListener.listener = event.listeners />
			</cfif>

			<cfset reqIfo = getHTTPRequestData()>
			<cfif structKeyExists(reqIfo.headers,"X-Requested-With") and reqIfo.headers["X-Requested-With"] eq "XMLHttpRequest">
				<cfset FORM.GFAjaxRequest =  true />
			</cfif>

			<cfinvoke component="#arguments.controller#" method="processEvent" returnvariable="eventResponse" argumentcollection="#eventArgs#" />
			<cfif isJSON(eventResponse)>
				<cfset response['data'][event.data.context] = eventResponse />
			<cfelse>
				<cfset response['display'][event.data.context] = eventResponse />
			</cfif>
			<cfset ArrayAppend(response['listeners'], eventAjaxListener) />
			
		</cfloop>
		<cfcatch>
			<cfdump var="#cfcatch#"><cfabort>
			<!---<cfdump var="#FORM#">
			<cfdump var="#cfcatch#"><cfabort>--->
			<cfset response['success'] = false>
		</cfcatch>
		</cftry>
		<!--- deserialize args into a struct --->
		
		
		<!---<cftry>
			<cfinvoke component="#arguments.controller#" method="ProcessEvent" returnvariable="eventResponse" argumentcollection="#eventArgs#" />
			<cfset StructAppend(response, myResponse, true)>
			<cfcatch>

				<!--- something went wrong, we need to return a success false to our js handler --->
				<cfset response['success'] = false>
			</cfcatch>
		</cftry>--->
		
		<cfset response['events'] = arguments.events />

		<!---<cfdump var="#response#">
		<cfabort>--->
		<cfreturn response>
	</cffunction>
	
</cfcomponent>