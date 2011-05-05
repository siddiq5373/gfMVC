<cfoutput>
<!--Begin Sidebar-->
	<div class="sidebar-list">
		<ul>
        	<li>
				<h3>Page Management<h3><a href="#getLink('page.manage')#">{+ Add Page }</a>
			</li>
			<cfloop array="#vc.pages#" index="page">
				<li>
					<a href="#getPageLink(page)#">#page.getTitle()#</a> 
				</li>
			</cfloop>
			
			<!---<li>
				<h3>Components<h3> 
			</li>
			<li>
				<a href="#getLink('Post.list')#">Posts</a> 
				<a href="#getLink('Job.list')#">Job Openings</a> 
				<a href="#getLink('Portfolio.List')#">Portfolio</a> 
				<a href="#getLink('Team.List')#">Team</a> 
				<a href="#getLink('Event.List')#">Events</a> 
			</li>--->
		
			<li>
				<h3>User Management<h3> 
			</li>			
			<li>
				<a href="#getLink(handler:'user')#">User Management</a> 
			</li>			
		</ul>
	</div>
</cfoutput>