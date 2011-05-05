<cfcomponent output="false">
	<cfimport prefix="tag" taglib="." />
	<cffunction name="init" returntype="any" output="false" hint="render pages">
		<cfargument name="appName" type="string" required="false" />
		<cfargument name="appKey" type="string" required="false" />
		<cfset variables.appName = arguments.appName />
		<cfset variables.appKey = arguments.appKey />
		<cfreturn this />
	</cffunction>
	<cffunction name="renderData" access="public" returntype="void" hint="Render Data like JSON/XML/Text a Request" output="true" >
		<cfargument name="data" type="any" required="false" default="" />
		<cfoutput>#arguments.data#</cfoutput>
	</cffunction>
	<cffunction name="renderLayoutAndView" access="public" returntype="void" hint="Render the layout and View" output="true" >
		<cfargument name="layoutname" type="any" required="false" />
		<cfargument name="eventresult" type="any" required="false" default="#StructNew()#" />
		<cfargument name="viewName" type="string" required="true"  />
		<cfargument name="currentEvent" type="string" required="true"  />
		<cfargument name="RequestObject" type="any" required="true"  />
		<cfargument name="SessionObject" type="any" required="true"  />
		<cfoutput>
			<cfset $renderLayout(argumentCollection:arguments) />
		</cfoutput>
	</cffunction>
	<cffunction name="$renderLayout" access="public" returntype="void" hint="Render View" output="true" >
		<cfargument name="layoutName" type="string" required="true"  />
		<cfargument name="eventResult" type="any" required="false" default="#StructNew()#" />
		<cfargument name="RequestObject" type="any" required="false" default="#StructNew()#" />
		<cfargument name="SessionObject" type="any" required="false" default="#StructNew()#" />
		<cfscript>
			var attrCollection = StructNew();
			arguments.layoutName = ReReplace(arguments.layoutName,'[.]','/','all');
			attrCollection.viewName = arguments.viewName;
			attrCollection.layoutName = arguments.layoutName;
			attrCollection.AppName = variables.AppName;
			attrCollection.rc = arguments.RequestObject.getRequestCollection();
			attrCollection.vc = arguments.eventresult;
			attrCollection.sc = arguments.RequestObject.getSessionCollection();
			attrCollection.AppKey = variables.AppKey;
		</cfscript>
		<tag:RenderLayout attributeCollection="#attrCollection#" />
	</cffunction>	
	<cffunction name="renderView" access="public" returntype="void" hint="Render View" output="true" >
		<cfargument name="viewName" type="string" required="true"  />
		<cfargument name="eventResult" type="any" required="false" default="#StructNew()#" />
		<cfargument name="RequestObject" type="any" required="false" default="#StructNew()#" />
		<cfargument name="SessionObject" type="any" required="false" default="#StructNew()#" />
		<cfargument name="controller" type="any" required="false" />
		<cfscript>
			var attrCollection = StructNew();
			var viewEventResult = StructNew();
			attrCollection.vc = StructNew();
			if (NOT StructKeyExists(arguments.eventresult,arguments.viewName))
				arguments.eventresult[arguments.viewName] =  StructNew();
			if ( StructKeyExists(arguments,'event') and trim(arguments.event) NEQ '' ){
				viewEventResult = arguments.controller.$runEvent(event:arguments.event,returnData:true);
				StructAppend(arguments.eventresult[arguments.viewName], viewEventResult, true );
			}
			attrCollection.vc = arguments.eventresult[arguments.viewName];
			arguments.viewName = ReReplace(arguments.viewName,'[.]','/','all');
			attrCollection.viewName = arguments.viewName;
			attrCollection.AppName = variables.AppName;
			attrCollection.rc = arguments.RequestObject.getRequestCollection();
			attrCollection.sc = arguments.RequestObject.getSessionCollection();
			attrCollection.AppKey = variables.AppKey;
		</cfscript>
		<tag:_RenderView attributeCollection="#attrCollection#" />
	</cffunction>
</cfcomponent>