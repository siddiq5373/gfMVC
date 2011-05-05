<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfscript>
			param name="Attributes.AdditionalContent" default="";
			param name="request.reloadAll" default="false";
			
			includeTemplates = [];
			includeContent = [];
			
			parentTagList = getBaseTagList();
			parentTagName = ListGetAt(parentTagList,2);
			//writeDump(parentTagName);abort;
			_thisTAG = getBaseTagData(parentTagName);  
			parentData = _thisTAG;
			//thisTAG = StructCopy(_thisTAG);
			StructAppend(thisTAG,_thisTAG);
			StructAppend(Attributes,_thisTAG.Attributes);
			createTemplate = false;
			if (trim(Attributes.Name) NEQ '' and trim(Attributes.template) EQ ''){
				Attributes.Name = "#parentTagName#_#Attributes.Name#";
				//Attributes.template = "#parentTagName#_#Attributes.template#";
				Attributes.template = Attributes.Name;
				createTemplate = false;
			}
			else if (trim(Attributes.template) NEQ '')
				Attributes.template = "#parentTagName#_#Attributes.template#";
			
			if (request.reloadAll)
				createTemplate = true;
        </cfscript>
		<cfimport taglib="." prefix="file" />
		
		<cfif NOT createTemplate and (trim(Attributes.Template) NEQ '' or Attributes.Name NEQ '')>
			<cfif trim(Attributes.Name) NEQ '' and trim(ListLast(Attributes.Template,'_')) EQ ''>
				<file:Template action="exists" name="#Attributes.Name#" />
			<cfelseif trim(Attributes.Template) NEQ ''>
				<file:Template action="exists" name="#Attributes.Template#" />
			</cfif>
			<!---<file:Template action="exists" name="#Attributes.Template#" />--->
			<cfscript>
				if (StructKeyExists(thisTAG,'templateInfo')){
					
					ArrayAppend(includeTemplates,thisTAG.templateInfo[1]['TemplateName']);
					//helperKey = Hash(thisTAG.templateInfo[1]['TemplateName']);
					//param name="request.helpers" default="#StructNew()#";
					//request.helpers[helperKey] = _thisTAG.helper;

					if ( trim(Attributes.AdditionalContent) NEQ '' and trim(Attributes.AdditionalContent) EQ '<Template />') {
						Attributes.AdditionalContent = new renderEngine.iterator.ParseHTML(generatedContent:Attributes.AdditionalContent, tag=parentTagName);
						ArrayAppend(includeContent, Attributes.AdditionalContent);
					}
				}
				else
					createTemplate = true;
		    </cfscript>

			<cfset eachTagDataCollection = parentData />
		</cfif>
		
		<cfif createTemplate>
			
			<cfif StructKeyExists(parentData['thisTag'],'eachData')>
				<cfset eachTagDataCollection = parentData['thisTag']['eachData'][1] />

				<cfset _thisTAG.generatedContent = "" />
				
				<cfif trim(eachTagDataCollection.paredHTMLContent) NEQ '' and trim(Attributes.Name) NEQ ''>

					<cfif StructKeyExists(eachTagDataCollection,'RepeatData')>
						<cfif StructKeyExists(eachTagDataCollection.RepeatData,'RepeatHTMLContent')>

							<file:Template action="save" name="#Attributes.Name#_Repeat" templateInfo="repeatBodyTemplate" templateCode="#eachTagDataCollection.RepeatData.RepeatHTMLContent#" />
				
						</cfif>
					</cfif>
					<cfif trim(Attributes.AdditionalContent) NEQ '' and trim(Attributes.AdditionalContent) NEQ '<Template />'>
						<file:Template action="save" name="#Attributes.Name#_Body" templateInfo="BodyTemplate" templateCode="#trim(Attributes.AdditionalContent)#" />
					</cfif>
					
					<file:Template action="save" name="#Attributes.Name#" templateCode="#eachTagDataCollection.paredHTMLContent#" />
		
					<cfscript>
						if (StructKeyExists(thisTAG,'templateInfo')){
							ArrayAppend(includeTemplates,thisTAG.templateInfo[1]['TemplateName']);
						}
				    </cfscript>
				</cfif>
			</cfif>	
		</cfif> 
		
		<cfimport taglib="../iterator" prefix="for" />
		<cfif StructKeyExists(attributes,'in')>
			<cfif IsArray(attributes.in)>
				<cfset attributes.in = [ attributes.in ] />
			</cfif> 
		<cfelseif StructKeyExists(_thisTAG,'DataCollectionName')>
			<cfset attributes.in = _thisTAG[_thisTag.DataCollectionName] />
		<cfelseif StructKeyExists(_thisTAG,'Helper')>
			<cfset attributes.in = _thisTAG['Helper'].getDataCollection() />
		</cfif>

		<!---
		<cfset dynamicFunction = getMetaData(attributes.in) />
		<cfif IsStruct(dynamicFunction)>
			<cfif (StructKeyExists(dynamicFunction,'name') and StructKeyExists(dynamicFunction,'parameters'))>
				<cfset helper = parentData.helper />
				<!--- It is a function call --->
				<cfset attributes.in = evaluate("parentData.#_thisTag.DataCollectionname#()") />
			</cfif>		
		</cfif>
		--->
		
		
		<cfset parentGeneratedContent = ListToArray(ReReplaceNoCase(Attributes.AdditionalContent,'<Template />','�'),'�') /> <!--- alt+| --->

		<cfloop array="#includeTemplates#" index="TemplateName">
			<for:each in="#attributes.in#" attributeCollection="#eachTagDataCollection#" processTemplate="true" parseHTML="false" template="#TemplateName#" Helper="#_thisTAG['Helper']#"></for:each>
		</cfloop>

		<cfif arraylen(includeContent)>
			<cfoutput>#ReReplaceNoCase(ReReplaceNoCase(ArrayToList(includeContent),'<cfoutput>','','all'),'</cfoutput>','','all')#</cfoutput>
		</cfif>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">		
