
<!---<cfdump var="#getComponentMetaData('sampleApp.handlers.events.site')#"><cfabort>--->
Test View

<cfset vc1 = runEvent( name:'site.index', eventArgs:{ContentID=3} ) />
<cfset vc2 = runEvent( name:'site.index', eventArgs:{ContentID=2} ) />
<cfset vc3 = runEvent( name:'site.index', eventArgs:{ContentID=4} ) />

<cfdump var="#vc1#" expand="false" />
<cfdump var="#vc2#" expand="false" />
<cfdump var="#vc3#" expand="false" />

<cfdump var="#request.eventsFired#">

<cfdump var="#CacheGetAllIds()#">

<cfdump var="#vc#">