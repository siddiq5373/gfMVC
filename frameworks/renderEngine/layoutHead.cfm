<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfparam name="Attributes.Name" default="" />
		<cfparam name="Attributes.Template" default="" />
		<cfparam name="Attributes.HelperPath" default="" />
		<cfscript>
			if (trim(Attributes.Name) NEQ '')
				_HelperName = Attributes.Name&'Helper';
			else
				_HelperName = Attributes.Template&'Helper';
			_HelperName = 'Layout'&_HelperName;
			
			if ( FileExists( ExpandPath('/renderEngineHelpers/#_HelperName#.cfc') ) ) {
				oLayoutHelper = CreateObject('renderEngineHelpers.#_HelperName#').init(argumentCollection:Attributes);
				oLayoutHelper.dispatchRegisteredEvents(argumentCollection:Attributes);
			}
			else 
				oLayoutHelper = new renderEngine.helper.fwHelper();
			
			LayoutHelperData = oLayoutHelper.getDataCollection();
			if ( IsStruct(LayoutHelperData) ){
				StructAppend(variables,LayoutHelperData);
			}
			createTemplate = false;
			if (request.reloadAll)
				createTemplate = true;
		</cfscript>

		<cfimport taglib="util" prefix="file" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<!---<cfcache action="cache" useQueryString="true" timespan="#CreateTimeSpan(0,0,5,5)#" idletime="#CreateTimeSpan(0,0,5,5)#" directory="#ExpandPath('/renderEngine/cache')#">
		<cfoutput><!-- cache created at #dateformat(Now())# and #TimeFormat(Now(),'hh:mm:ss')# and set to expire at #TimeFormat( dateadd('n',5,Now()),'hh:mm:ss')#  on #dateformat(Now())# --></cfoutput>--->
	</cfcase>
	
	<cfcase value="end">
		<cfset includeTemplates = [] />
		<cfset includeContent = [] />

		<!--- Check if the template exists --->
		<cfif NOT createTemplate and (trim(Attributes.Template) NEQ '' or Attributes.Name NEQ '')>
			<cfif trim(Attributes.Name) NEQ ''>
				<file:Template action="exists" name="#Attributes.Name#" />
			<cfelseif trim(Attributes.Template) NEQ ''>
				<file:Template action="exists" name="#Attributes.Template#" />
			</cfif>
			<cfscript>
				if (StructKeyExists(thisTAG,'templateInfo'))
					ArrayAppend(includeTemplates,thisTAG.templateInfo[1]['TemplateName']);
				else
					createTemplate = true;
		    </cfscript>
		</cfif>
		<cfset createTemplate = true />
		<!--- Check if needs to create a new template --->
		<cfif createTemplate and thisTAG.generatedContent NEQ '' and trim(Attributes.Name) NEQ ''>
			<cfscript>
   				parsedHTMLContent = new renderEngine.Iterator.ParseHTML(generatedContent:thisTAG.generatedContent, tag='layoutHead');
				thisTAG.generatedContent = parsedHTMLContent;
        	</cfscript>
			
			<file:Template action="save" name="#Attributes.Name#" templateCode="#thisTAG.generatedContent#" />
		</cfif>

		<cfscript>
			thisTAG.generatedContent = '';
			if (StructKeyExists(thisTAG,'templateInfo')){
				include thisTAG.templateInfo[1]['TemplateName'];
			}
			if (Attributes.Name EQ ''){
				// Copy the generated Content to Local Var so can be included at the end
				ArrayAppend(includeContent,thisTAG.generatedContent);
				thisTAG.generatedContent = '';
			}
		       
        </cfscript>
		<cfloop array="#includeTemplates#" index="TemplateName">
			<cfinclude template="#TemplateName#" />
		</cfloop>
		<cfoutput>#ReReplaceNoCase(ReReplaceNoCase(ArrayToList(includeContent),'<cfoutput>','','all'),'</cfoutput>','','all')#</cfoutput>
</head>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">