
<h1>Welcome to the home page</h1>
<cfdump var="#vc#" label="View Collection (vc)">
<cfdump var="#rc#" label="Request Collection (rc)">
<cfdump var="#sessionObject#">
<cfoutput>

<form name="postFrm" action="#CGI.SCRIPT_NAME#" method="post">
<!---	<input type="hidden" name="#getEventName()#" value="#rc.CurrentEvent#Action" />--->
	<input type="hidden" name="#getEventName()#" value="auth.loginAction" />
	
	un : <input type="text" id="userName" name="userName" value="" /> <br />
	pw : <input type="password" id="userPassword" name="userPassword" value="" />

	<input type="submit" id="submitform" value="Submit for" />
</form></cfoutput>

<!---<cfdump var="#runEvent('foo.index')#">--->
<!---<cfdump var="#sayHello()#">--->

<!---<cfoutput>
#renderView('foo.vwIndex')#
</cfoutput>

<cfoutput>
#runEvent('foo.index')#
</cfoutput>--->
<!---<cfdump var="#sayHello()#">--->