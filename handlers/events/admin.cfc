component accessors="true" output="false" {
	public admin function init() {
		return this;
	}
	
	public any function preEvent(event) {
		var vc = {};
		
		var oSession = arguments.event.getSessionObject();
		
		var rc = arguments.event.getRequestCollection();
		vc.layout = 'adminLayout';
		
		if (NOT oSession.KeyExists('IsLoggedIn') or NOT oSession.getIsLoggedIn() ) {
			vc.view = 'admin.vwLogin';
		}
		else
			vc.view = 'admin.vwDashDoard';
		
		return vc;
	}
	
	public any function index(event) {
		var vc = {};

		return vc;
	}
	
	/**
	*	@injectServices user
	*/
	public any function login(event) {
		var vc = {};
		//var userService = arguments.event.getUserService();
		var oSession = arguments.event.getSessionObject();
		var FormCollection = arguments.event.getEventCollection();
		if (structIsEmpty(FormCollection)){
			location('#CGI.SCRIPT_NAME#?ac=admin', false);
		}
		
		//var user = userService.auth(FormCollection.email, FormCollection.Password);

		var user = userService.findByEmailAndPassword(FormCollection.email, FormCollection.Password);

		if (IsNull(user) or user.getEmail() EQ ''){
			oSession.setErrorMessage('Invalid account');
		}
		else {
			oSession.setUser(user);
			oSession.setIsLoggedIn(true);
		}
		location('#CGI.SCRIPT_NAME#?ac=admin', false);
	}
	
	public any function logout(event) {
		var oSession = arguments.event.getSessionObject();
		
		oSession.setIsLoggedIn(false);
		
		location('#CGI.SCRIPT_NAME#', false);
	}
}
