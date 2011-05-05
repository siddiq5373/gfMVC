<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfparam name="Attributes.component" default="" />
		<cfparam name="Attributes.HelperPath" default="" />
		<cfparam name="Attributes.Name" default="" />
		<cfparam name="Attributes.Template" default="" />
		<cfscript>
			_HelperName = Attributes.component&'Helper';

			if (NOT StructKeyExists(Attributes,'oHelper') ) {
				if ( FileExists( ExpandPath('/renderEngineHelpers/#_HelperName#.cfc') ) ) {
					helper = CreateObject('renderEngineHelpers.#_HelperName#').init(argumentCollection:Attributes);
					Helper.dispatchRegisteredEvents(argumentCollection:Attributes);
				}
				else 
					helper = new renderEngine.helper.fwHelper();
			}
			else 
				helper = Attributes.oHelper;
			
			if (trim(Attributes.component) EQ '')
				Attributes.component = Helper.getUUID();
				
			Attributes.Name = '#Attributes.component##Attributes.Name#';
			if (trim(Attributes.Template) neq ''){
				request.oHelper = helper;
				Attributes.Template = '#Attributes.component##Attributes.Template#';	
			}
			processDataCollection = true;
			
			if ( StructKeyExists(Attributes,'type') and Attributes.type EQ 'detail' ) {
				processDataCollection = false;
				DataCollectionName = 'renderData';
				renderData = [ helper.getDataCollection() ] ;
			}

			//if (StructKeyExists(Attributes,'oHelper') ) {
			//	processDataCollection = true;
			//}
			//if ( NOT IsArray( helper.getDataCollection() ) ){
				//processDataCollection = false;
			//}
		</cfscript>
		
	</cfcase>
	
	<cfcase value="end">
		<cfimport taglib="/renderEngine/iterator" prefix="for" />
		<cfimport taglib="/renderEngine" prefix="" />
		<cfsavecontent variable="generatedContent">
		<render AttributeCollection="#Attributes#" oHelper="#helper#">			
			<for:each useTemplateTag="false">
				<cfoutput>#thisTag.generatedContent#</cfoutput>
			</for:each>
		</render>
		</cfsavecontent>
		<cfset thisTag.generatedContent = REReplaceNoCase(generatedContent,'<Template />','','all') />
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">