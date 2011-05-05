<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfparam name="attributes.pageSize" default="10" />
		<cfparam name="attributes.class" default="" />
		<cfparam name="attributes.link" default="" />
		<cfparam name="url.start" default="1">
		<cfset pageSize = attributes.pageSize>
		<cfset total = ormExecuteQuery("select count(id) from #attributes.class#", true) />
		<cfif total LTE attributes.pageSize>
			<cfexit method="exittag" />
		</cfif>
		<cfoutput>
			<p>
			<cfif url.start gt 1>
				<a href="#attributes.link#&start=#url.start-pageSize#">Previous</a>
			<cfelse>
				Previous
			</cfif>
			/
			<cfif url.start lt total>
				<a href="#attributes.link#&start=#url.start+pageSize#">Next</a>
			<cfelse>
				Next
			</cfif>
			</p>
		</cfoutput>
		
	</cfcase>
</cfswitch>