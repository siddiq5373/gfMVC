<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfparam name="Attributes.Name" default="" />
		<cfparam name="Attributes.Template" default="" />
		<cfparam name="Attributes.HelperPath" default="" />
		
		<!---<cfcache action="cache" useQueryString="true" timespan="#CreateTimeSpan(0,0,5,5)#" idletime="#CreateTimeSpan(0,0,5,5)#" directory="#ExpandPath('/renderEngine/cache')#">
		<cfhtmlhead text="<!-- cache created at #dateformat(Now())# and #TimeFormat(Now(),'hh:mm:ss')# and set to expire at #TimeFormat( dateadd('n',5,Now()),'hh:mm:ss')#  on #dateformat(Now())# --> " />--->
		
		<!---<cfscript>
			if (trim(Attributes.Name) NEQ '')
				_HelperName = Attributes.Name&'Helper';
			else
				_HelperName = Attributes.Template&'Helper';
			_HelperName = 'Layout'&_HelperName;
			
			if ( FileExists( ExpandPath('/renderEngineHelpers/#_HelperName#.cfc') ) ) {
				oLayoutHelper = CreateObject('renderEngineHelpers.#_HelperName#').init();
				oLayoutHelper.dispatchRegisteredEvents();
			}
			else 
				oLayoutHelper = new renderEngine.helper.fwHelper();
			
			LayoutHelperData = oLayoutHelper.getDataCollection();
			if ( IsStruct(LayoutHelperData) ){
				StructAppend(variables,LayoutHelperData);
			}
		</cfscript>--->
		<body>
		<!---<cfoutput>This date/time IS cached: #Now()#<br /></cfoutput>--->
	</cfcase>
	
	<cfcase value="end">
		<!--- Cache just a part of this page. --->
		<!---<cfcache action="cache" useQueryString="true" timespan="#CreateTimeSpan(0,0,0,30)#" idletime="#CreateTimeSpan(0,0,0,5)#" directory="#ExpandPath('/renderEngine/cache')#">
			#thisTAG.generatedContent#
		</cfcache>--->
		<!---<cfset thisTAG.generatedContent = '' />--->
		<!---
		<cfcache action="cache" timespan="#CreateTimeSpan(0,0,1,0)#" useQueryString="true">
			<cfoutput>This date/time IS cached: #Now()#<br /></cfoutput>
		</cfcache>--->
		<!---<cfscript>
			parsedHTMLContent = new renderEngine.Iterator.ParseHTML(generatedContent:thisTAG.generatedContent, tag='layoutBody');
			thisTAG.generatedContent = parsedHTMLContent;
        </cfscript>--->
		</body>
	</html>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">