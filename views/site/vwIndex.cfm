<!---<cfdump var="#rc.getMemento()#">--->
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
