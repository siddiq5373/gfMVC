<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfscript>
			param name="attributes.value" default="Item";
			param name="attributes.in" default="";
			param name="attributes.start" default="1";
			param name="attributes.delimeter" default=",";
			param name="attributes.NoOfTimesToRepeat" default="1";
			
			if (StructKeyExists(attributes,'rowData'))
				attributes.in = attributes.rowData;

			contentArray = [];
			
			//writeDump(attributes.SELECTEDMENU);abort;
			//parentTagList = getBaseTagList();
			//parentData = getBaseTagData(ListGetAt(parentTagList,2)); // Dynamically get the parent tag data
			
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
			attributes.iterator = new Iterator( attributes.in );

			if (attributes.iterator.hasNext()) {
				iterateDataCollection(attributes); 
			}
			else
				exit "exittemplate";
		</cfscript>
	</cfcase>
	
	<cfcase value="end">
		<cfscript>
			arrayAppend(contentArray, thisTag.generatedContent);
			thisTag.generatedContent = '';
			
			//for (i=1; attributes.start <= attributes.NoOfTimesToRepeat; i++) {
				attributes.start++;
				if (attributes.iterator.hasNext()) {
	            	iterateDataCollection(attributes);
					exit "loop";
				}
			//}
			WriteOutput(arrayToList(contentArray, ""));
		</cfscript>
	</cfcase>
</cfswitch>

<cffunction name="iterateDataCollection" access="private" output="false" returntype="void">
	<cfargument name="attributes" required="true" type="struct" />   
	<cfscript>
	if (NOT structKeyExists(request, attributes.uuid) ){
		request[attributes.uuid] = { iterator = { CurrentIndex =  attributes.iterator.getCurrentIndex()}};
	}
	
	if (structKeyExists(attributes, "value") ){
		request[attributes.uuid].iterator.CurrentIndex = attributes.iterator.getCurrentIndex();
		request.dynamicDataEvaluation.AltColor = ' ( (attributes.iterator.getCurrentIndex() MOD 2 EQ 0)?true:false ) ';
		caller[attributes.value]  = attributes.iterator.next();
	}    
    </cfscript>
</cffunction>
<cfsetting enablecfoutputonly="false">