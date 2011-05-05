<cfprocessingdirective suppresswhitespace="true">
<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfsilent>
		<cfinclude template="../helpers/fwHelp.cfm" />
		<cfif FileExists(ExpandPath('/#variables.AppName#/views/#attributes.viewName#Help.cfm'))>
			<cfinclude template="/#attributes.AppName#/views/#attributes.viewName#Help.cfm" />
		</cfif>
		<cfif FileExists(ExpandPath('/#variables.AppName#/views/#attributes.viewName#Helper.cfm'))>
			<cfinclude template="/#attributes.AppName#/views/#attributes.viewName#Helper.cfm" />
		</cfif>
		<cfif FileExists(ExpandPath('/#variables.AppName#/views/#attributes.viewName#JSHelper.cfm'))>
			<cfset variables.jsHelperInfo = {"#attributes.viewName#" = "/#variables.AppName#/views/#attributes.viewName#JSHelper.cfm"} />
			<cfset getRequestObject().addToJSHelpers(attributes.viewName, "/#variables.AppName#/views/#attributes.viewName#JSHelper.cfm") />
		</cfif>
		</cfsilent>
	</cfcase>

	<cfcase value="end">
		<cfinclude template="/#attributes.AppName#/views/#attributes.viewName#.cfm" />
		<cfif getRequestObject().IsGFAjaxRequest()>
			<cfoutput>#renderJS()#</cfoutput>
		</cfif>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">
</cfprocessingdirective>