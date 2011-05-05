<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfparam name="Attributes.NoOfTimes" default="3" />
		<cfscript>
			param name="attributes.value" default="Item";
			param name="request.repeatStart" default="1";
			param name="attributes.delimeter" default=",";
			
			attributes.in = [];
			parentTagList = getBaseTagList();     
			parentData = getBaseTagData(ListGetAt(parentTagList,2));
			
			if ( NOT StructKeyExists(parentData.attributes, 'in') ) {
				exit "exittemplate";
			}
			else
				attributes.Data = parentData.attributes.in;
        </cfscript>
		<!---<cfdump var="#parentData.attributes#"><cfabort>--->
		
	</cfcase>
	
	<cfcase value="end">
		<cfscript>
			Attributes.repeatContent = thisTag.GeneratedContent;
			thisTag.GeneratedContent = '<RepeatBody NoOfTimes="#Attributes.NoOfTimes#" />';        	        
        </cfscript>
		
		<!---
		<cfset paredHTMLContent = new ParseHTML(generatedContent:thisTag.generatedContent) />
		<cfset thisTag.generatedContent = "" />

		<cfset FileName = "#Hash(getBaseTagList())#.cfm" />
		<cfset templateFileName = "#Expandpath('/renderEngine/templates/')##FileName#" />
		<cffile action="write" file="#templateFileName#" output="#paredHTMLContent#" />
		<cfimport taglib="." prefix="tag" />
		
		<!---<cfdump var="#request.repeatStart#">--->
		
		<cfscript>
			request.repeatEnd = request.repeatStart + Attributes.NoOfTimes - 1; 
			attributes.in = [];   
        </cfscript>

		
		<cfloop from="#request.repeatStart#" to="#request.repeatEnd#" index="i">
			<!---<cfdump var="#attributes.Data[i]#">--->
			<!---<cfset attributes.in = attributes.Data[i] />--->
			<cfset arrayAppend(attributes.in,attributes.Data[i]) />
		</cfloop>
		<tag:iterator attributeCollection="#attributes#">
			<cfinclude template="/renderEngine/templates/#FileName#" />
		</tag:iterator>--->

		
		<cfassociate
			basetag="cf_each"
			datacollection="Repeat"
			/>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">