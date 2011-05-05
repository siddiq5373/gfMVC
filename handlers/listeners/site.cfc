component {
	public any function init(){
		return this;	
	}

	public any function index(vc){
		vc.coo = 'i am here at listener';
	}
}