<!---<cfdump var="#vc#"><cfabort>--->

<!---<cfset vc = runEvent('site.navigation') /> ---><!--- Can be loaded from helper function  --->

<cfoutput>
<ul id="nav" style="display:block;">
<cfloop array="#vc.ActivePages#" index="page">
	<li style="float:left;"><a href="#CGI.SCRIPT_NAME#?ContentID=#page['ContentID']#">#page['Title']#</a></li>
</cfloop>
</ul>
<br />
<!---<div style="clear:all;"></div>--->
</cfoutput>