<cfscript>
	error = getErrorInfo();	
</cfscript>
<cfif error.Occured>
	<ul id="messageBox" class="message error no-margin">
		<li><cfoutput>#error.message#</cfoutput></li>
	</ul>
</cfif>
