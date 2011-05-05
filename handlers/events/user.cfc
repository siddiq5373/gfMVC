component accessors="true" output="false" securedEvents="true" {
	
	public user function init() {
		
		return this;
	}
	
	public any function preEvent() {
		var vc = {};
		
		vc.layout = 'adminLayout';
		return vc;
	}
	
	public any function index(event) {
		var vc = {};
		
		//var userService = arguments.event.getUserService();
		vc.users = userService.list();
		
		vc.view = 'user.vwList';
		return vc;
	}
	
	public any function manage(event) {
		var vc = {};
		//var userService = arguments.event.getUserService();
		param name="URL.userID" default="0";
		if (URL.userID GT 0)
			vc.user = userService.get(URL.userID);
		else
			vc.user = userService.new();
		
		vc.view = 'user.vwManage';
		return vc;
	}
	/**
	* @injectServices generic
	*/
	public any function save(event) {
		var vc = {};
		var user = '';
		//var userService = arguments.event.getUserService();
		var FormCollection = arguments.event.getFormCollection();
		//var genericService = arguments.event.getGenericService();
		
		if ( Not StructKeyExists(FormCollection,'StatusID'))
			FormCollection.StatusID = 2;
			
		var status = genericService.get('Status',val(FormCollection.StatusID) );
		
		if (StructKeyExists(FormCollection, 'userID')  and val(FormCollection.userID) GT 0){
			FormCollection.ID = FormCollection.userID;
			user = userService.populate(data:FormCollection);
			user.setStatus(status);
			//writeDump(user);abort;
			userService.save(user);
			
			location('index.cfm?ac=user.manage&userID=#user.getUserID()#',false);
		}
		else {
			user = userService.new(data:FormCollection);
			user.setStatus(status);
			
			//writeDump(user);abort;
			userService.save(user);
			
			location('index.cfm?ac=user',false);			
		}
	}

}
