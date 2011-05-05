<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfparam name="request.DateFieldCount" default="1" />
		<cfparam name="attributes.value" default="" />
		<cfparam name="attributes.name" default="DateField#request.DateFieldCount#" />
		<cfset request.DateFieldCount = request.DateFieldCount + 1 />
		<cfif IsNull(attributes.value)>
			<cfset attributes.value = '' />
		</cfif>
		<cfoutput>
		<input type="text" maxlength="10" size="10" name="#attributes.name#" id="#attributes.name#" class="inputField required" value="#attributes.value#" />
		<script type="text/javascript" defer="defer"> jQuery(document).ready(function() { jQuery("###attributes.name#").datepicker(); }); function showresDate(){ jQuery("###attributes.name#").datepicker('show'); } </script>
		</cfoutput>
	</cfcase>
</cfswitch>