<cfprocessingdirective suppresswhitespace="true">
<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfsilent>
			<cfinclude template="../helpers/fwHelp.cfm" />
			<cfif FileExists(ExpandPath('/#variables.AppName#/layouts/#attributes.layoutName#Help.cfm'))>
				<cfinclude template="/#attributes.AppName#/layouts/#attributes.layoutName#Help.cfm" />
			</cfif>
			<cfif FileExists(ExpandPath('/#variables.AppName#/layouts/#attributes.layoutName#Helper.cfm'))>
				<cfinclude template="/#attributes.AppName#/layouts/#attributes.layoutName#Helper.cfm" />
			</cfif>
		</cfsilent>
	</cfcase>

	<cfcase value="end">
		<cfsavecontent variable="LayoutGeneratedContent">
			<cfinclude template="/#attributes.AppName#/layouts/#attributes.layoutName#.cfm" />
		</cfsavecontent>
		
		<cfif FindNoCase('</body>',LayoutGeneratedContent)>
			<cfoutput>#ReplaceNoCase(LayoutGeneratedContent,'</body>','#renderJS('layout')#'&'#chr(13)#</body>')#</cfoutput>
		<cfelse>
			<cfoutput>
				#LayoutGeneratedContent#
				#renderJS('layout')#
			</cfoutput>
		</cfif>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">
</cfprocessingdirective>
