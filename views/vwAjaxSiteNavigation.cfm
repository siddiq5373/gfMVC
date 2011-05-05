<cfoutput>
<ul id="nav" style="display:block;">
<cfloop array="#vc.ActivePages#" index="page">
	<li style="float:left;text-decoration:none; display:block;padding:4px 5px 4px 9px;"><a href="javascript:site.get(#page['ContentID']#)">#page['Title']#</a></li>
</cfloop>
</ul>
<br />
</cfoutput>
<!---


<script type="text/javascript">

function site() {
	var gfMVCEvent = new GFMVCEvent();
	gfMVCEvent.addEvent('site.page', 'pageContent','pageResponse');
	gfMVCEvent.addEvent('site.breadcrumb', 'breadcrumb','breadcrumbResponse');
	gfMVCEvent.addEvent('site.relatedContent', 'relatedContent','relatedContentResponse');
	
	this.get = function(ContentID){
		gfMVCEvent.dispatchEvent({'ContentID':ContentID});
	}
	
	this.pageResponse = function(response){
		console.log('Here @ pageContentResponse');
		//console.debug(response);
	}
	this.breadcrumbResponse = function(response){
		console.log('Here @ breadcrumbResponse');
		//console.debug(response);
	}
	this.relatedContentResponse = function(response){
		console.log('Here @ relatedContentResponse');
		//console.debug(response);
	}
}
var Site = new site();


</script>--->