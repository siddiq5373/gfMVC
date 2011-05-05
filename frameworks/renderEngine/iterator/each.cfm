<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfscript>
			param name="attributes.value" default="Item";
			param name="attributes.in" default="";
			param name="attributes.start" default="1";
			param name="attributes.delimeter" default=",";
			param name="attributes.parseHTML" default="true";
			param name="attributes.processTemplate" default="false";
			param name="attributes.Helper" default="";
			param name="attributes.useTemplateTag" default="true";
			
			contentArray = [];
			parentTagList = getBaseTagList();
			parentTagName = ListGetAt(parentTagList,2);
			parentData = getBaseTagData(ListGetAt(parentTagList,2)); // Dynamically get the parent tag data

			/*
			if (StructKeyExists(attributes,'template')){
				param name="request.helpers" default="#StructNew()#";
				if (StructKeyExists()){
					
				}
			}*/
			/*
			if ( StructKeyExists(parentData,'Helper') ) {
				if (IsObject(parentData.Helper))
					request.oHelper = parentData.Helper;
				else	
					request.oHelper = new "wcms.#parentData.Helper#"();
			}
			else if (NOT StructKeyExists(request,'oHelper') ) {
				request.oHelper = new renderEngine.helper.fwHelper();
			}*/
			
			//if (NOT attributes.processTemplate){
				//writeDump(parentData);
				//exit "exittag";
			//}
			
			//writeDump(attributes.in);abort;
			
			
			if (StructKeyExists(parentData,'dynamicDataEvaluation')) {
				if (NOT structKeyExists(request, 'dynamicDataEvaluation') )
					request.dynamicDataEvaluation = {};
				StructAppend(request.dynamicDataEvaluation,parentData.dynamicDataEvaluation);
			}
			else if (NOT structKeyExists(request, 'dynamicDataEvaluation') and StructKeyExists(parentData,'Helper') and IsObject(parentData.helper)){
				request.dynamicDataEvaluation = parentData.Helper.getDynamicDataEvaluationType();
			}
			
			//writeDump(request.dynamicDataEvaluation);abort;
			//writeDump(attributes);abort;
			
			/*
			if (ListFindNoCase(parentTagList,'cfsiteMenu')) {
				parentData = getBaseTagData('cfsiteMenu'); //then access the data from the component
				attributes.in = parentData[parentData.dataCollectionName];
			}
			else if (ListFindNoCase(parentTagList,'cfleftMenu')) {
				parentData = getBaseTagData('cfleftMenu'); //then access the data from the component
				attributes.in = parentData[parentData.dataCollectionName];
			}*/
			
			//attributes.in = parentData[parentData.dataCollectionName];
			/*
			attributes.iterator = new Iterator( attributes.in );

			if (attributes.iterator.hasNext()) {
				iterateDataCollection(attributes); 
			}
			else
				exit "exittemplate";
			*/
		</cfscript>

	</cfcase>
	
	<cfcase value="end">
		
		<cfscript>
		
		
			repeatData = {};
			if (structKeyExists(thisTag,'Repeat')){
				for (i = 1; i LTE ArrayLen( thisTag.Repeat ); i = i + 1){
					repeatData.noOfTimes = thisTag.Repeat[i].noOfTimes;
					repeatData.Content = thisTag.Repeat[i].repeatContent;
				}
			}
			modifiedBodyContent = [];
			repeatModule = '';
			
			
        </cfscript>

		<cfif attributes.parseHTML>
			<cfset argumentStruct = request.dynamicDataEvaluation /> 
			<cfif StructKeyExists(attributes,'generatedContent')>
				<cfset thisTag.generatedContent = attributes.generatedContent />
			</cfif>
			<cfif NOT StructIsEmpty(repeatData)>
				<cfset argumentStruct.generatedContent = repeatData.Content /> 
				<cfset repeatData.repeatHTMLContent = new ParseHTML(argumentCollection:argumentStruct) />
				<!---<cfdump var="#repeatHTMLContent#"><cfabort>--->
			</cfif>
			
			<cfset attributes.repeatData = repeatData/> 
			<cfset argumentStruct.generatedContent = thisTag.generatedContent />
			<!---<cfdump var="#argumentStruct#"><cfabort>--->
			<cfset attributes.paredHTMLContent = new ParseHTML(argumentCollection:argumentStruct) />
			
			<!---<cfset parentData.repeatData = repeatData />
			<cfset caller.generatedContent = paredHTMLContent />--->
			<cfset thisTag.generatedContent =  '<Template />' />
			<cfassociate
				basetag="#parentTagName#"
				datacollection="eachData"
			/>
			<cfexit method="exittag" />
		<cfelse>
			<cfif structKeyExists(attributes,'repeatData')>
				<cfset repeatData = attributes.repeatData />
				<!---<cfdump var="#attributes.template#">--->
				<!---<cfdump var="#attributes#"><cfabort>--->
			<cfelse>
				<cfscript>
					fileText = fileRead(ExpandPath(attributes.template));
					if (FindNoCase('<RepeatBody NoOfTimes=', fileText) GT 0) {
						repeatData.Content = fileText;
						repeatDataAsXML = XmlParse(repeatData.Content);
						RepeatBodyNode = xmlSearch(repeatDataAsXML,'//RepeatBody');
						repeatData.NoOfTimes = RepeatBodyNode[1]['XmlAttributes']['NoOfTimes'];
						//writeDump(repeatData);abort;
					}
                </cfscript>
			</cfif>
		</cfif>

		<cfif NOT StructIsEmpty(repeatData)>
			<!---<cfset BodyContent = repeatData.Content />--->
			<!---<cfdump var="#repeatData.Content#">--->
			<!---<cfset BodyContent = thisTag.generatedContent />
			<cfset paredHTMLContent = new ParseHTML(generatedContent:repeatData.Content) />
	
			<cfset FileName = "#Hash(getBaseTagList())#repeatData.cfm" />
			<cfset templateFileName = "#Expandpath('/renderEngine/templates/')##FileName#" />
			<cffile action="write" file="#templateFileName#" output="#paredHTMLContent#" />--->

			<!---<cfscript>
			if (StructKeyExists(parentData, 'parentData')) {
				if ( StructKeyExists(parentData.parentData,'Helper') ) {
					if (IsObject(parentData.parentData.Helper))
						Helper = parentData.parentData.Helper;
					else	
						Helper = new "wcms.#parentData.parentData.Helper#"();
				}
			}
			</cfscript>--->

			<cfimport taglib="." prefix="tag" />
			<cfset Helper = attributes.Helper />
			<cfsavecontent variable="repeatModule">
				<cfinclude template="#attributes.template#" />
			</cfsavecontent>
			<cfset RepeatTempate = replaceNoCase(attributes.template,'.cfm','_repeat.cfm') />
			<cfloop from="1" to="#ArrayLen(attributes.in)#" index="i" step="#repeatData.noOfTimes#">
				<cfset repeatEnd = i+repeatData.noOfTimes-1 />
				<cfif repeatEnd GT ArrayLen(attributes.in)>
					<cfset repeatEnd =  ArrayLen(attributes.in) />
				</cfif>
				<cfif repeatEnd LTE ArrayLen(attributes.in)>
					<cfset attributes.rowData = [] />
					<cfloop from="#i#" to="#repeatEnd#" index="j">
						<cfif j LTE ArrayLen(attributes.in)>
							<cfset arrayAppend(attributes.rowData,attributes.in[j]) />
						</cfif>
					</cfloop>
					<cfset rowBody = "" />
					<cfsavecontent variable="rowBody">
						<!---<cfdump var="#attributes.rowData#">--->
						
						
						<!---<cfmodule name="#attributes.template#">--->
						<cfset Helper = attributes.Helper />
						<tag:iterator rowData="#attributes.rowData#" attributeCollection="#attributes#" uuid="#attributes.Helper.getUUID()#">
							<cfinclude template="#RepeatTempate#" />
						</tag:iterator>

						<!---</cfmodule>--->
					</cfsavecontent>
					<!---<cfdump var="#rowBody#">--->
					<cfset arrayAppend(modifiedBodyContent, REReplaceNoCase(repeatModule,'<RepeatBody NoOfTimes="#repeatData.NoOfTimes#" />',rowBody,'all')) />
					<!---<cfdump var="#BodyContent#"><cfabort>
					<cfdump var="#rowBody#"><cfabort>--->
					<!--- TODO : Change this to String builder or String buffer --->
					<!---<cfset modifiedBodyContent =  modifiedBodyContent & REReplaceNoCase(BodyContent,'<tag:RepeatBody>',rowBody,'all') />--->
					
				</cfif>
			</cfloop>

			<!---<cfset thisTag.generatedContent = REReplaceNoCase( ArrayToList(modifiedBodyContent,''),repeatModule,'','all') />--->
			<cfset thisTag.generatedContent = ArrayToList(modifiedBodyContent,'') />
			<cfexit method="exittag" />
			<!---<cfset thisTag.generatedContent = modifiedBodyContent />--->
		</cfif>
		
		<!---<cfset paredHTMLContent = new ParseHTML(generatedContent:thisTag.generatedContent) />
		<cfset thisTag.generatedContent = "" />
		<cfset thisTag.generatedContent = paredHTMLContent />

		<cfset FileName = "#Hash(getBaseTagList())#.cfm" />
		<cfset templateFileName = "#Expandpath('/renderEngine/templates/')##FileName#" />
		<cffile action="write" file="#templateFileName#" output="#paredHTMLContent#" />--->

		<cfset BodyTemplateContent = "" />
		<cfset bodyTemplateFile = replaceNoCase(attributes.template,'.cfm','_body.cfm') />
		<cfset Helper = attributes.Helper />
		<cfif FileExists( Expandpath(bodyTemplateFile) )>
			<cfsavecontent variable="BodyTemplateContent">
				<cfinclude template="#bodyTemplateFile#" />
			</cfsavecontent>
		</cfif>
		
		<cfimport taglib="." prefix="tag" />
		<cfsavecontent variable="processedContent">
			<cfif arraylen(attributes.in) GT 0>
				<!---<cfdump var="#attributes.in#"><cfabort>--->
				<tag:iterator attributeCollection="#attributes#" uuid="#attributes.Helper.getUUID()#">
					<cftry>
						<cfinclude template="#attributes.template#" />
                    <cfcatch type="Any" >
						<cfdump var="#cfcatch#"><cfabort>
						<cfthrow message="Unable to render page check the datacollection returned from the event dispatcher #getMetadata(Helper).FullName#" />
                    </cfcatch>
                    </cftry>
					<!---<cfinclude template="/renderEngine/templates/#FileName#" />--->
					<!---<cfoutput>#paredHTMLContent#</cfoutput>--->
				</tag:iterator>
			</cfif>
		</cfsavecontent>
		<!---<cfdump var="#processedContent#"><cfabort>--->
		<!---<cfif repeatModule NEQ ''>
			<cfset thisTag.generatedContent = REReplaceNoCase( thisTag.generatedContent,repeatModule,'','all') />
		</cfif>--->
		
		<cfif BodyTemplateContent NEQ ''>
			<cfset thisTag.generatedContent = REReplaceNoCase(BodyTemplateContent,'<Template />',processedContent,'all') />
		<cfelseif trim(BodyTemplateContent) EQ ''>
			<cfset thisTag.generatedContent = processedContent />
		</cfif>
		

		
		<!---<cfscript>
			arrayAppend(contentArray, thisTag.generatedContent);
			thisTag.generatedContent = '';

			if (attributes.iterator.hasNext()) {
            	iterateDataCollection(attributes);
				exit "loop";
			}
			
			WriteOutput(arrayToList(contentArray, ""));
		</cfscript>--->

	
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">