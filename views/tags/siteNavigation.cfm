<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
	<cfoutput>
	<!--Begin Sidebar-->
		<div class="sidebar-list">
			<ul>
            	<li>
					<h3>Page Management<h3><a href="#caller.getLink('page.manage')#">{+ Add Page }</a>
				</li>
				<li>&nbsp;</li>
				<li>
					<a href="#caller.getLink(handler:'page')#">Home</a> 
				</li>			
				<li>
					<a href="#caller.getLink(handler:'page')#">News</a> 	
				</li>			
				
				<li>
					<h3>User Management<h3> 
				</li>			
				<li>
					<a href="#caller.getLink(handler:'user')#">User Management</a> 
				</li>			
				<li>
					<h3>Category Management<h3> 
				</li>			
				<li>
					<a href="#caller.getLink(handler:'category')#">Category Management</a> 
				</li>
			</ul>
		</div>
	
	</cfoutput>
	<!--End Sidebar-->
	</cfcase>
	<cfcase value="end">
	</cfcase>
</cfswitch>