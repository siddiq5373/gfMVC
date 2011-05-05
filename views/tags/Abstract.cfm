<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfparam name="attributes.value" default="" />
		<cfparam name="attributes.name" default="Abstract" />
		<cfif IsNull(attributes.value)>
			<cfset attributes.value = '' />
		</cfif>
		<cfoutput>
			<textarea name="#attributes.name#" id="#attributes.name#" rows="4" cols="70" class="inputField required" maxlength="255">#attributes.value#</textarea>
		</cfoutput>
	</cfcase>
</cfswitch>