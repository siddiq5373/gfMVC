<cfdump var="#showEventInfo()#">
<cfdump var="#vc#" label="View Collection (vc)">
<cfdump var="#sayHello()#">
<cfdump var="#sessionObject#">
Foo Body

<cfscript>
	vc.addData = runEvent('foo.parentIndex');	
</cfscript>

<cfdump var="#vc.addData#">

<cfset renderView(Name:'viewlets.vwSiteMenu', event='foo.parentIndex') /><cfabort>


