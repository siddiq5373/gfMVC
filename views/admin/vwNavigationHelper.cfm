<cfscript>
function getPageLink(_page){
	var ac = 'page.manage';
	var page = arguments._page;
	//var pageType = page.getPageType().getTypeCode();
	
	return getLink('#ac#&ContentID=#page.getContentID()#');
}	
</cfscript>
