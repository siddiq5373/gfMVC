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
			processDataCollection = true;
		</cfscript>

	</cfcase>
	
	<cfcase value="end">
		<cfif processDataCollection>
			<cfimport taglib="/renderEngine/util" prefix="file" />
			<file:processTemplate AdditionalContent="#thisTAG.generatedContent#" />
			<cfset thisTAG.generatedContent = "" />
			
		<cfelse>
			
			<cfimport taglib="/renderEngine/iterator" prefix="for" />			
			<cfimport taglib="/renderEngine/util" prefix="file" />
			<for:each>
				<cfoutput>#thisTAG.generatedContent#</cfoutput>
			</for:each>
			
			<file:processTemplate AdditionalContent="#thisTAG.generatedContent#" AttributeCollection="#Attributes#"  />
			<cfset thisTAG.generatedContent = "" />
			<!---<cf_render AttributeCollection="#Attributes#" oHelper="#helper#">
				<for:each>
					<cfoutput>#this.generatedContent#</cfoutput>
				</for:each>
			</cf_render>
			<cfset this.generatedContent = '' />--->
		</cfif>
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">