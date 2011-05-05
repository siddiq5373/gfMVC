
<!--- FOO --->
<!--- Merge --->

<cfcomponent output="false" >	<!--- SecuredEvents="true" --->
	<cffunction name="init">
		
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="preEvent">
		<cfargument name="event" required="true" type="any" />
		<cfscript>
  	        // Check for session logged in or not
			var vc = {};
			var sc = arguments.event.getSessionCollection();
			var rc = arguments.event.getRequestCollection();
			var ec = arguments.event.getEventCollection();
			//writeDump(rc.id);abort;
			vc.message = 'from preEvent';
			
			return vc;
        </cfscript>
	</cffunction>
	
	<cffunction name="preIndex">
		<cfargument name="event" required="true" type="any" />
		<cfscript>
  	        // Check for session logged in or not
			var sc = arguments.event.getSessionCollection();
			var rc = arguments.event.getRequestCollection();
			var ec = arguments.event.getEventCollection();
			var vc = {};
			
			vc.message = 'from PreIndex';
			
			return vc;
        </cfscript>
	</cffunction>
	
	<cffunction name="parentIndex">
		<cfargument name="event" required="true" type="any" />
		<cfscript>
			var vc = StructNew();
			vc.MessageFromParent = ' From Parent';
			vc.view = 'foo.vwParentIndex';
			//writeDump(this.getEventMeta());abort;
			var sc = arguments.event.getSessionCollection();
			var rc = arguments.event.getRequestCollection();
			var ec = arguments.event.getEventCollection();
			ec.parentEvent = 'I am from Parent Event';
			
			return   vc;      	        
        </cfscript>

	</cffunction>
	
	<!--- Listener is not used just a concept --->
	<cffunction name="index" securedEvent="false" parent="foo.parentIndex" listeners="fooListener.HandlerIndexEvent,fooListener.renderHomPage" >
		<cfargument name="event" required="true" type="any" />
		<cfscript>
			var eventInfo = arguments.event.getCollection();
			var sessionObject = arguments.event.getSessionObject();
			var rc = arguments.event.getRequestCollection();
			//var oFooService = eventInfo.fooService;
			//var oFooGateway = eventInfo.fooGateway;
			//writeDump(getFunctionCalledName());abort;
			var ec = arguments.event.getEventCollection();
			ec.SupaCoo = 'availabe only for event';
			//writeDump(eventInfo);abort;
			//writeDump(ec);abort;
			var vc = StructNew();
			
			vc.dsnInfo = FooGateway.getDSN();
			vc.cooMessage = FooService.sayCoo();
			
			//vc.view = 'foo.vwIndex';
			//vc.layout = 'layout1';
		</cfscript>
		<!---<cfdump var="#vc#"><cfabort>--->
		<cfreturn vc />
	</cffunction>
	
	<cffunction name="postEvent">
		<cfargument name="event" required="true" type="any" />
		<cfscript>
			var sc = arguments.event.getSessionCollection();
			var rc = arguments.event.getRequestCollection();
			var ec = arguments.event.getEventCollection();
			//writeDump(rc.getMemento());
			//writeDump( arguments.event.getMemento());abort;
			var ec = arguments.event.getEventCollection();
			//writeDump(ec);abort;
  	        //Do something like create XML/JSON from the event result or stop execution
        </cfscript>
	</cffunction>
	
	<cffunction name="data" eventType="data" returnformat="JSON">
		<cfargument name="event" required="true" type="any" />
		<cfset var eventReturnStruct = StructNew() />
		<cfset var returnData = StructNew() />
		<cfscript>
			var sc = arguments.event.getSessionCollection();
			var rc = arguments.event.getRequestCollection();
			var ec = arguments.event.getEventCollection();        	        
        </cfscript>

		<cfset returnData.returnThisJSON = 'coo coo' />
		<cfset eventReturnStruct.data =  serializeJSON(returnData) />
		
		<cfreturn eventReturnStruct />
	</cffunction>
	
	<cffunction name="post" >
		<cfargument name="event" required="true" type="any" />
		<cfdump var="#FORM#">
		
	</cffunction>		

</cfcomponent>
