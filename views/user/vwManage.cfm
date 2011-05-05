<h1>User</h1>
<cfoutput>

<form action="#getLink('save')#" id="formUser" name="formUser" method="post">
<table class="mytable fixedWidth" cellpadding="0" cellspacing="0">
	<tr>
    	<th colspan="2" class="top"></th>
    </tr>	
	<tr>
		<td nowrap="nowrap"><label for="Firstname"><b>Firstname:</b></label> &nbsp;</td>
		<td>
        	<input class="inputField required" type="text" id="Firstname" name="Firstname" size="40" maxlength="100" value="#vc.user.getFirstname()#" />
    	</td>
	</tr>
	<tr>
		<td nowrap="nowrap"><label for="Lastname"><b>Lastname:</b></label> &nbsp;</td>
		<td>
        	<input class="inputField required" type="text" id="Lastname" name="Lastname" size="40" maxlength="100" value="#vc.user.getLastname()#" />
    	</td>
	</tr>
	<tr>
		<td nowrap="nowrap"><label for="email"><b>email:</b></label> &nbsp;</td>
		<td>
			<input class="inputField required email" type="text" id="email" name="email" size="40" maxlength="155" value="#vc.user.getEmail()#" />
    	</td>
	</tr>
	<tr>
		<td nowrap="nowrap"><label for="password"><b>password:</b></label> &nbsp;</td>
		<td>
			<input class="inputField required" minlength="6" type="password" id="password" name="password" size="40" value="#vc.user.getPassword()#" />
	    </td>
	</tr>
	<!---<tr>
		<td valign="top" class="td1">
			<b>Security Options:</b> &nbsp;
			<input type="hidden" name="securityExists" value="true">
		</td>
		<td class="td1">
			<input type="checkbox" name="c_security" value="23"> Content Management<br>
			<input type="checkbox" name="c_security" value="13"> Site Content<br>
		</td>
	</tr>--->
	<tr>
		<td nowrap="nowrap"><label for="StatusID"><b>Status:</b></label> &nbsp;</td>
		<td>
    	    <input type="checkbox" id="StatusID" name="StatusID"  value="1" #vc.user.getStatusAsHTML()# />
	    </td>
	</tr>
	<tr>
		<td class="td1">&nbsp;</td>
		<td class="td1">
			<cfif vc.user.getUserID() GT 0>
				<input type="submit" value="Update User" class="submit">
				<input type="hidden" name="UserID" value="#vc.user.getUserID()#">
			<cfelse>
				<input type="submit" value="Add User" class="submit">
			</cfif>
		</td>
	</tr>
</table>
</form>
</cfoutput>

<script>
$(document).ready(function(){
	$("#formUser").validate();
});
</script>