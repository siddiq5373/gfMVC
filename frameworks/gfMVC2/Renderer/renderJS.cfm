<cfprocessingdirective suppresswhitespace="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
	<cfsilent>
		<cfscript>
			param name='attributes.AppKey' default='#caller.appKey#';
			attributes.ViewName = caller.attributes.ViewName;
			if (StructKeyExists(caller,'jsHelperInfo') ){
				jsHelperInfo = caller.jsHelperInfo;
				//writeoutput(caller.renderJS());
			}
			include "../helpers/fwHelp.cfm";
			//exit "exittag";  
        </cfscript>
	</cfsilent>
	</cfcase>
	<cfcase value="end">
		<cfoutput>#caller.renderJS()#</cfoutput>
	</cfcase>
</cfswitch>
</cfprocessingdirective>