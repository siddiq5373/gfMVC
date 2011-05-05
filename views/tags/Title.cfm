<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfparam name="attributes.value" default="" />
		<cfif IsNull(attributes.value)>
			<cfset attributes.value = '' />
		</cfif>
		<cfoutput>
			<input type="text" maxlength="100" size="25" name="Title" id="Title" class="inputField required" value="#attributes.value#" />
		</cfoutput>
	</cfcase>
</cfswitch>