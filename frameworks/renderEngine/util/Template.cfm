<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfscript>
		function liteCompression(compressText){
			compressedText = REReplace(compressText, "[#chr(10)##chr(13)##chr(9)#]{2,}",chr(13),"ALL");
			compressedText = REReplace(compressText, "[#Chr(13)##Chr(10)#]","","ALL");
			//compressedText = REReplace(trim(compressedText), "[[:space:]]{2,}[#Chr(13)##Chr(10)#]{2,}", "", "ALL");
			//compressedText = REReplace(trim(compressedText), "#Chr(13)#", "", "ALL");
			return compressText;
		}        	        
        </cfscript>

		<cfparam name="Attributes.Action" default="None" />
		<cfparam name="Attributes.Name" default="" />
		<cfparam name="Attributes.templateCode" default="" />
		<cfparam name="Attributes.templateInfo" default="" />

		<cfset parentTagList = getBaseTagList() />
		<cfset parentTagName = ListGetAt(parentTagList,2) />
		<!---<cfdump var="#parentTagList#"><cfabort>--->
		<cfif trim(Attributes.Name) NEQ ''>
			<cfif parentTagName EQ 'CF_PROCESSTEMPLATE'>
				<cfset FileName = "#Hash(getBaseTagList())#_#Attributes.Name#.cfm" />
			<cfelse>
				<cfset FileName = "#Hash(getBaseTagList())#_#parentTagName#_#Attributes.Name#.cfm" />
			</cfif>
		<cfelse>
			<cfset FileName = "#Hash(getBaseTagList())#.cfm" />
		</cfif>
		<cfset Attributes.TemplateName = '/renderEngine/templates/#FileName#' />
		<cfset templateFileName = Expandpath(Attributes.TemplateName) />
		
		<cfif Attributes.Action EQ "save" and trim(Attributes.templateCode) NEQ ''>
			<cffile action="write" file="#templateFileName#" output="#trim(liteCompression(Attributes.templateCode))#" />
			<cfif trim(Attributes.templateInfo) EQ ''>
				<cfassociate basetag="#parentTagName#" datacollection="templateInfo" />
			<cfelse>
				<cfset caller[Attributes.templateInfo] = Attributes.TemplateName />
			</cfif>
		<cfelseif Attributes.Action EQ "exists">
			<cfif FileExists(templateFileName)>
				<cfif trim(Attributes.templateInfo) EQ ''>
					<cfassociate basetag="#parentTagName#" datacollection="templateInfo" />
				<cfelse>
					<cfset caller[Attributes.templateInfo] = Attributes.TemplateName />
				</cfif>
			</cfif>
		</cfif>
		<cfexit method="exittag" />
	</cfcase>
	
	<cfcase value="end">
		
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">