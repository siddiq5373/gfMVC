/**
* @injectServices test
* @gfMVC:cache
*/
component accessors="true" output="false" extends="siteParent" {
	
	public site function init() {
		
		return this;
	}
	
	public any function preEvent(event) {
		var vc = {};
		var uc = arguments.event.getEventCollection();
		vc.layout = 'publicSiteLayout1';
		if ( FindNoCase('/getin',CGI.SCRIPT_NAME) GT 0 )
			vc.layout = 'adminLayout';

		return vc;
	}

	public any function navigation(event) {
		var vc = {};
		//var siteService = arguments.event.getSiteService();
		vc.ActivePages = siteService.getActivePages(); // Cache this one at preHandler
		//writeDump(vc.ActivePages);
		//abort;
		return vc;
	}
	/**
	* @injectServices foo
	*/
	public any function index(event) {
		var vc = {}; // View Collection available only for the current view
		var uc = arguments.event.getEventCollection();
		//writeDump(FORM);abort;
		
		if ( FindNoCase('/getin',CGI.SCRIPT_NAME) GT 0 )
			location('#CGI.SCRIPT_NAME#?ac=admin', false);
		else {
			vc.view = 'vwHomePage';
			if (StructKeyExists(uc,'ContentID')) {
				vc.page = siteService.getCurrentPage(val(uc.ContentID));
				vc.view = 'vwCurrentPage';
			}
		}	

		return vc;
	}
	
	public any function page(event) {
		var vc = {};
		var fc = arguments.event.getEventCollection();
		//var siteService = arguments.event.getSiteService();
		param name="fc.ContentID" default="0";
		vc.page = siteService.getCurrentPage(val(fc.ContentID));
		vc.view = 'vwCurrentPage';

		return vc;
	}
	public any function navigationAjax(event) {
		var vc = {};
		//var siteService = arguments.event.getSiteService();
		vc.ActivePages = siteService.getActivePages();
		
		vc.view = 'vwAjaxSiteNavigation';
		return vc;
	}
	public any function breadcrumb(event) {
		var vc = {};
		var fc = arguments.event.getEventCollection();
		param name="fc.ContentID" default="0";
		
		vc.PageID = fc.ContentID;
		vc.view = 'vwSiteBreadCrumb';
		return vc;
	}
	
	public any function relatedContent(event) {
		var vc = {};
		var fc = arguments.event.getEventCollection();
		param name="fc.ContentID" default="0";
		
		vc.PageID = fc.ContentID;
		vc.view = 'vwRelatedContent';
		return vc;
	}
	
	public any function postEvent(event) {
		var vc = {};
		if (event.IsGFAjaxRequest())
			vc.layout = 'ajaxLayout';
			
		return vc;
	}
	
}
