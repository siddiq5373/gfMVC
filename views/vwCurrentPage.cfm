<cfimport prefix="" taglib="/gfmvc/renderer" />
<cfif !IsNull(vc.page) and isObject(vc.page)>
	<cfoutput>
	
	<h1>#vc.page.getTitle()#</h1>
	<section>
		#vc.page.getHtmlText()#
	</section>
	</cfoutput>
<cfelse>
	Page Not Found
</cfif>

<renderView name="vwTest" event="site.navigation" vc='{"param1":"coo"}' />

<!---<cfdump var="#FORM#">--->

<!---<cfdump var="#request.eventsFired#">--->