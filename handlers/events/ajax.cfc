component accessors="true" output="false" securedEvents="false" {
	
	public ajax function init() {
		
		return this;
	}
	
	public any function preEvent() {
		var vc = {};
		
		vc.layout = 'adminLayout';
		return vc;
	}
	
	public any function navigation(event) {
		var vc = {};
		
		//var pageService = arguments.event.getPageService();
		//var pageService = event.getORMModel( 'Page' );
		
		vc.pages = pageService.readAsObject(returnType:'Array');

		if (NOT IsArray(vc.pages) )
			vc.pages = [];
		//writeDump(vc.pages);abort;
		return vc;
	}
	
	public any function index(event) {
		var vc = {};
		
		//var pageService = event.getORMModel( 'Page' );
		//vc.pages = pageService.list();
		
		vc.view = 'page.vwList';
		return vc;
	}
	public any function breadcrumb(event) {
		var vc = {};
		
		//var pageService = event.getORMModel( 'Page' );
		//vc.pages = pageService.list();
		
		vc.view = 'page.vwBreadcrumb';
		return vc;
	}
	public any function relatedContent(event) {
		var vc = {};
		
		//var pageService = event.getORMModel( 'Page' );
		//vc.pages = pageService.list();
		
		vc.view = 'page.vwRelatedContent';
		return vc;
	}
	
	public any function list(event) {
		var vc = {};
		var pageService = event.getORMModel( 'Page' );
 		var page = {};
		page['Title'] = 'Page Title';
		page['Body'] = 'Page Content';
		page['Footer'] = 'Page Content';
		
		//vc.data = serializeJSON(page);
		vc.view = 'page.vwList';
		return vc;
	}
	
	/*
	* @eventPool {key:URL.pageID,scope:request}
	*/
	public any function manage(event) {
		var vc = {};
		var pageService = arguments.event.getORMModel( 'Page' );

		param name="URL.pageID" default="0";
		if (URL.pageID GT 0)
			vc.page = pageService.findByKeyAsObject(URL.pageID);
		else
			vc.page = pageService.new();
		//writeDump(vc.page);abort;
		//vc.layout = 'adminLayout';
		vc.view = 'page.vwManage';
		
		return vc;
	}

	public any function save(event) {
		var fc = arguments.event.getFORMCollection();
		
		local.pageService = event.getORMModel( 'Page' );
		
		local.pageService.save(argumentCollection:fc);
		
		location('index.cfm?ac=admin',false);
		
	}
	
}

