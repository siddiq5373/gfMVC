component accessors="true" output="false" securedEvents="true" {
	
	public page function init() {
		
		return this;
	}
	
	public any function preEvent(event) {
		var vc = {};
		if (event.IsGFAjaxRequest())
			vc.layout = 'ajaxLayout';
		else
			vc.layout = 'adminLayout';

		return vc;
	}
	
	public any function navigation(event) {
		var vc = {};
		
		//var pageService = arguments.event.getPageService();
		vc.pages = pageService.list();
		return vc;
	}
	
	public any function index(event) {
		var vc = {};
		
		//var pageService = arguments.event.getPageService();
		vc.pages = pageService.list();
		
		vc.view = 'page.vwList';
		return vc;
	}
	
	public any function list(event) {
		var vc = {};
		//var pageService = arguments.event.getPageService();
		vc.pages = pageService.list();
		vc.view = 'page.vwList';
		return vc;
	}
	
	public any function manage(event) {
		var vc = {};
		//var pageService = arguments.event.getPageService();

		param name="URL.ContentID" default="0";
		if (URL.ContentID GT 0)
			vc.page = pageService.get(URL.ContentID);
		else
			vc.page = pageService.new();

		vc.view = 'page.vwManage';
		return vc;
	}
	
	/**
	* @injectServices generic
	*/
	public any function save(event) {
		var vc = {};
		var page = '';
		//var pageService = arguments.event.getPageService();
		//var genericService = arguments.event.getGenericService();
		
		var FormCollection = arguments.event.getFormCollection();

		param name="FormCollection.keyValue" default="ContentID";
		
		if ( Not StructKeyExists(FormCollection,'StatusID'))
			FormCollection.StatusID = 2;
			
		var status = genericService.get('Status',val(FormCollection.StatusID) );
		
		if (StructKeyExists(FormCollection, FormCollection.keyValue) and val(FormCollection[ FormCollection.keyValue ]) GT 0){
			FormCollection.ID = FormCollection[ FormCollection.keyValue ];
			FormCollection.ContentID = FormCollection[ FormCollection.keyValue ];
			page = pageService.populateBean(data:FormCollection );
			page.setStatus(status);
			
			pageService.save(page, true);
			location('index.cfm?ac=page.manage&#FormCollection.keyValue#=#page.getContentID()#',false);
		}
		else {
			StructDelete(FormCollection,'StatusID');
			page = pageService.new(data:FormCollection);
			page.setStatus(status);
			pageService.save(page);
			
			location('index.cfm?ac=admin',false);			
		}
	}

}
