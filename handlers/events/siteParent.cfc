component output="false" {
	
	public any function preEventBlah(event) {
		var vc = {};
		var uc = arguments.event.getEventCollection();
		vc.layout = 'publicSiteLayout1';
		if ( FindNoCase('/getin',CGI.SCRIPT_NAME) GT 0 )
			vc.layout = 'adminLayout';

		return vc;
	}
	public any function preTest(event) {
		var vc = {};
		var uc = arguments.event.getEventCollection();
		
		vc.Message1 = 'i am from parent pre test Event';

		return vc;
	}
	public any function test(event) {
		var vc = {};
		var uc = arguments.event.getEventCollection();
		
		vc.Message2 = 'i am from parent test Event';

		return vc;
	}	
}
