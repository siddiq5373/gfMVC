
component output="false" accessors="true"
{
	public function init( )
	{
		return paresHTML(argumentCollection : arguments);
	}
	
	public function paresHTML( ) {
		var HTMLContent = '';
		var dynamicCFVar = [];
		var propertiesArray = [];
		var i = 0;
		var conditionalPseudo = '';
		var simpleVar = '';
		var EvalPseudoFrom = '';
		var EvalPseudoTo = '';
		var updatedHTMLContent = '';
		var tagName = '';
		var objectName = 'item.';
		var dynamicDataEvalObjectName = 'request.';
		var dynamicDataEvalObjectType = 'Struct';
		var dynamicDataEvalCFCCall = '';
		var dynamicDataEvalCFCHelper = '';
		HTMLContent = arguments.generatedContent;
		if (StructKeyExists(arguments,'tag')) {
			tagName = arguments.tag;
			objectName = '';
		}
		if (StructKeyExists(arguments,'objectName')) {
			objectName = arguments.objectName&'.';
		}
		if (StructKeyExists(arguments,'dynamicDataEvalObjectName')) {
			dynamicDataEvalObjectName = arguments.dynamicDataEvalObjectName&'.';
		}
		if (StructKeyExists(arguments,'EvalObjectType')) {
			if (arguments.EvalObjectType EQ 'CFC' or arguments.EvalObjectType EQ 'Function'){
				local.objectStructName = Replace(objectName,'.','');
				dynamicDataEvalCFCCall = "(item:#local.objectStructName#)";
			}
			if (StructKeyExists(arguments,'EvalObjectHelper')) {
				dynamicDataEvalCFCHelper = arguments.EvalObjectHelper&'.';
			}
		}
		
		dynamicCFVar = propertiesArray = ReMatch("{[^{]+}",HTMLContent);
		
		for (i=1; i <= arraylen(dynamicCFVar); i++) {
			conditionalPseudo = ReMatch("[^?]+",dynamicCFVar[i]);
			if (ArrayLen(conditionalPseudo) EQ 1 ) {
				simpleVar = conditionalPseudo[1];
				dynamicCFVar[i] = '###objectName#'&rereplace(rereplace(simpleVar,'[{]','','all'),'[}]','##','all');
			}
			else {
				EvalPseudoFrom = ListFirst(dynamicCFVar[i],'?');
				if (dynamicDataEvalCFCCall EQ '')
					EvalPseudoTo = Replace(EvalPseudoFrom, '{', 'evaluate(#dynamicDataEvalObjectName#dynamicDataEvaluation.') & ')';
				else {
					EvalPseudoTo = EvalPseudoFrom & Replace(EvalPseudoFrom, '{', '#dynamicDataEvalCFCCall#');
					EvalPseudoTo =  ListFirst(EvalPseudoTo, ')')  & ')';
					EvalPseudoTo =  dynamicDataEvalCFCHelper & "#Replace(EvalPseudoTo, '{', '')#";
				}
				
				dynamicCFVar[i] = rereplaceNoCase(dynamicCFVar[i], EvalPseudoFrom, EvalPseudoTo);
				
				dynamicCFVar[i] = '##(' & rereplace(dynamicCFVar[i],'[{]','(','all');
				dynamicCFVar[i] =	rereplace(dynamicCFVar[i],'[}]','','all');
				if (Find(':', dynamicCFVar[i]) == 0)
					dynamicCFVar[i] = dynamicCFVar[i] & ':''''';
				dynamicCFVar[i] =	dynamicCFVar[i] & ')##';
				
				if (  Find( ')?)##', dynamicCFVar[i] ) GT 0){ // if no value specified then just call the helper function
					dynamicCFVar[i] = Replace(dynamicCFVar[i],')?)##', '))##');
				}
				
			}
		}
		updatedHTMLContent = HTMLContent;
		for (i=1; i <= arraylen(dynamicCFVar); i++) {
			updatedHTMLContent = ReplaceNoCase(updatedHTMLContent, propertiesArray[i], dynamicCFVar[i],'all');
		}
		updatedHTMLContent = '<cfoutput>#trim(updatedHTMLContent)#</cfoutput>';
		//writeDump(updatedHTMLContent);abort;
		return updatedHTMLContent;
	}
}