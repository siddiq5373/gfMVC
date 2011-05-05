<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfparam name="attributes.value" default="" />
		<cfparam name="attributes.name" default="ThumbImageFile" />
		<cfif IsNull(attributes.value)>
			<cfset attributes.value = '' />
		</cfif>
		<cfoutput>
			<input type="file" maxlength="100" size="25" name="#attributes.name#" id="#attributes.name#" class="inputField" value="" />
			<a href="##" onclick="jQuery('##showThumbImage').show(1000);" onmouseover="jQuery('##showThumbImage').show(1000);" onmouseout="jQuery('##showThumbImage').hide(1000);">View Image</a>
			<div id="showThumbImage" style='display:none;'>
				<img src="/assets/images/thumbImages/#attributes.value#" />
			</div>
			
		</cfoutput>
	</cfcase>
</cfswitch>