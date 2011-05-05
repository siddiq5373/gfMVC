<cfsetting enablecfoutputonly="true">
<cfimport taglib="." prefix="file" />
<cfif trim(Attributes.Template) NEQ ''>
	<file:Template action="exists" name="#Attributes.Template#" />
	<cfscript>
		if (StructKeyExists(thisTAG,'templateInfo')){
			include thisTAG.templateInfo[1]['TemplateName'];
		}        
    </cfscript>
</cfif>

<file:Template action="save" name="#Attributes.Name#" templateCode="#thisTAG.generatedContent#" />
<cfscript>
	thisTAG.generatedContent = '';
	if (StructKeyExists(thisTAG,'templateInfo')){
		include thisTAG.templateInfo[1]['TemplateName'];
	}
</cfscript>
<cfsetting enablecfoutputonly="false">