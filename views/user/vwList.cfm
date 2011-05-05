
<cfoutput>
{ <a href="#getLink('manage')#">+ Add User</a> }

<h1>Users</h1>
<table class="mytable" cellpadding="0" cellspacing="0">
	<tr>
    	<th colspan="3" class="top">&nbsp;</th>
    </tr>	
	
	<tr>
		<th>Name</th>
		<th>Status</th>
		<th>Modified</th>
	</tr>
	
	<cfloop array="#vc.users#" index="user">
		<tr>
			<td class="td1">
				<a href="#getLink('manage&userID=#user.getUserID()#')#">#user.getFirstname()# #user.getLastname()#</a>
			</td>
			<td class="td1">#user.getStatus().getDescription()#</td>
			<td class="td1">#user.getModifiedDate()#</td>						
		</tr>
	</cfloop>
	
</table>
</cfoutput>