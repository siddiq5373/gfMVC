<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfscript>
			param name="attributes.value" default="";
			param name="attributes.name" default="HTMLText";
			if ( IsNull(attributes.value) )
				attributes.value = '';
			
			fckEditor = createObject("component", "fckeditor.fckeditor");
		 	fckEditor.instanceName="#attributes.name#";
		 	fckEditor.basePath="/getin/fckeditor/";
		 	fckEditor.value= attributes.value;
		 	fckEditor.width="100%";
		 	fckEditor.height="400";
		 	fckEditor.toolbarSet="Cms";
			
		 	// ... additional parameters ...
		 	fckEditor.create(); // create instance now.
		 </cfscript>
	</cfcase>
</cfswitch>