component {
	site function init(){
		//writeDump(ObjectFactory);abort;
		
		return this;
	}
	
	any function getActivePages(){
		return ORMExecuteQuery('select new map( ContentID as ContentID, Title as Title ) from content p where p.Status.Code = ?',['Active'], false );
	}
	
	public any function index$(any ContentID = 0){
		var vc = {};
		vc.page = getCurrentPage(arguments.ContentID);
		return vc;
		//writeDump(arguments);abort;
	}
	
	
	any function getCurrentPage(ContentID){
		return ORMExecuteQuery('from content p where p.Status.Code = ? and p.ContentID = ?',['Active',arguments.ContentID], true );
	}
	
}