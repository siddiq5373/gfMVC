<cfprocessingdirective suppresswhitespace="true">
<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfscript>
			param name='attributes.AppKey' default='#caller.appKey#';
			param name='attributes.Name' default='';
			param name='attributes.overwrite' default='true';
			param name='attributes.vc' default='';
			param name='attributes.event' default='';
			param name='attributes.eventArgs' default='';

			include "../helpers/fwHelp.cfm";
			
			viewParams = {};
			viewParams.overwrite =  trim(attributes.overwrite);
			if (StructKeyExists(attributes,'name')){
				viewParams.name =  trim(attributes.name);
				StructDelete(attributes,'name');
			}
			if (StructKeyExists(attributes,'vc') and ( IsStruct(attributes.vc)) or IsJson(attributes.vc) ){
				if (IsJson(attributes.vc)) 
					viewParams.vc =  deserializeJSON(attributes.vc);
				else
					viewParams.vc =  StructCopy(attributes.vc);
				StructDelete(attributes,'vc');
			}
			if (StructKeyExists(attributes,'event')){
				viewParams.event =  trim(attributes.event);
				StructDelete(attributes,'event');
				if (StructKeyExists(attributes,'eventArgs') and  IsStruct(attributes.eventArgs)) {
					viewParams.eventArgs =  trim(attributes.eventArgs);
				}
				StructDelete(attributes,'eventArgs');
			}
			
			if (viewParams.name EQ '')	{ // render CurrentView
				currentViewName = caller.attributes.ViewName;
				CurrentViewCollection = {};
				if (StructKeyExists(caller.attributes.vc, currentViewName) ){
					CurrentViewCollection = StructCopy(caller.attributes.vc[currentViewName]);
				}
				
				if (StructKeyExists(viewParams,'vc') and IsStruct(viewParams.vc)){
					StructAppend(CurrentViewCollection,viewParams.vc, viewParams.overwrite);	
				}
				renderView(name:currentViewName,vc:CurrentViewCollection );
			}
			else
				renderView(argumentCollection:viewParams);
			
			exit "exittag";  
        </cfscript>
	</cfcase>
</cfswitch>
</cfprocessingdirective>