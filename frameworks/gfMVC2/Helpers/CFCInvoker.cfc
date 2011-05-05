<cfcomponent output="false">
	<cffunction name="init" returntype="any" output="false" hint="invoke CFC">
		<cfreturn this />
	</cffunction>

	<cffunction name="invokeCFC" access="public" returntype="struct" hint="Process Meta data and Check Parent Exists View" output="false">
		<cfargument name="oHandler" type="any" required="true" />
		<cfargument name="eventMethod" type="string" required="true" />
		<cfargument name="oEvent" type="any" required="true" />
		<cfargument name="vc" type="any" required="false" default="#StructNew()#" />
		<cfset var eventResult = {} />
		<cfset var eventParams = {} />
		<cfset var LoadedFromPool = false />
		<cfset var ec = arguments.oEvent.getEventCollection() />
		<cfif arguments.oHandler.IsHandler()>
			<cfset eventParams.Event = arguments.oEvent />	
		<cfelseif arguments.oHandler.IsListener()>
			<cfset eventParams.Event = arguments.oEvent />
			<cfif StructKeyExists(arguments,'vc')>
				<cfset eventParams.vc = arguments.vc />
			<cfelse>
				<cfset eventParams.vc = {} />				
			</cfif>
		<cfelse>
			<cfset eventParams = ec />
		</cfif>
		<cfparam name="eventParams.vc" default="#StructNew()#" />
		<cfset var keyStruct = ec />

		<cfif 	(arguments.oHandler.getEventMeta()[ 'securedEvents' ]) OR 
				( IsStruct( arguments.oHandler.getEventMeta()[ arguments.eventMethod ]) and IsBoolean(arguments.oHandler.getEventMeta()[ arguments.eventMethod ] [ 'IsSecured' ]) and arguments.oHandler.getEventMeta()[ arguments.eventMethod ] [ 'IsSecured' ] ) >
			<!--- Add scope specific API  --->
			<cfif (NOT StructKeyExists(Request,'oEventPool') ) or arguments.oEvent.getValue('ClearApplicationCache')>
				<cfset Request.oEventPool = CreateObject('component','ObjectPool').init() />
			</cfif>
			<cfset var oEventPool = Request.oEventPool />
		<cfelse>
			<cfset var oEventPool = CacheGet('oEventPool') />
			<cfif IsNull( oEventPool ) or arguments.oEvent.getValue('ClearApplicationCache') >
				<cflock type="exclusive" name="eventPool" timeout="5">
					<cfset cachePut('oEventPool', CreateObject('component','ObjectPool').init(), 10, 10) />
					<cfset oEventPool = CacheGet('oEventPool') />
				</cflock>
			</cfif>
		</cfif>        	        

		<cfset var cacheKey = UCASE( arguments.oHandler.getEventMeta().Name &'.' & arguments.eventMethod & '-' & Hash(serializeJSON( keyStruct ) ) ) />

		<cflock name="#cacheKey#" type="exclusive" timeout="50">
			<cfif !IsNull(oEventPool) and oEventPool.exists( cacheKey ) and NOT arguments.oEvent.getValue('ClearEventCache')>
				<cfset eventResult = oEventPool.getObject( cacheKey ) />
				<cfset arguments.oEvent.addToEventCollection(eventResult.ec) />
				<cfset LoadedFromPool = true />
				<cfset ArrayAppend(request.eventsFired,'#(StructKeyExists(arguments,'publiserEvent')  ? arguments.publiserEvent : '' )# - #cacheKey# pooledEvent : #LoadedFromPool# -  #arguments.oHandler.getEventMeta().name#.#arguments.eventMethod#()') />

			<cfelse>
				<!---<cfset ArrayAppend(request.eventsFired,'before #arguments.oHandler.getEventMeta().name#.#arguments.eventMethod#()') />--->
				<cfset ArrayAppend(request.eventsFired,'#(StructKeyExists(arguments,'publiserEvent')  ? arguments.publiserEvent : '' )# - #cacheKey# pooledEvent : #LoadedFromPool# -  #arguments.oHandler.getEventMeta().name#.#arguments.eventMethod#()') />
				<cfinvoke component="#arguments.oHandler#" method="#arguments.eventMethod#" returnvariable="eventResult.vc" argumentcollection="#eventParams#" />
				<!---<cfset ArrayAppend(request.eventsFired,'after #arguments.oHandler.getEventMeta().name#.#arguments.eventMethod#()') />--->
				<cfif NOT StructKeyExists(eventResult,'vc')>
					<cfset eventResult.vc = {} />
				</cfif>
				<cfset eventResult.ec = arguments.oEvent.getEventCollection() />
				
				<cfset oEventPool.setObject( cacheKey, duplicate(eventResult)) />
			</cfif>
		</cflock>

		<cfif StructKeyExists(eventResult,'vc')>
			<cfreturn eventResult.vc />
		<cfelse>
			<cfreturn {} />
		</cfif>
	</cffunction>
</cfcomponent>