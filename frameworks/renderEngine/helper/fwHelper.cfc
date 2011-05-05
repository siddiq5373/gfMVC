component {
	public function init(){
		setID();
		return this;
	}
	private function setID(){
		variables.uuid = createUUID(); 
	}	
	private function setBindObject(oValue){
		if (isArray(arguments.oValue))
			request[getUUID()]['{bindObject}'] = arguments.oValue;
		else
			request[getUUID()]['{bindObject}'] = [ arguments.oValue ];
	}
	private function getBindObject(){
		var oData = request[getUUID()]['{bindObject}'];
		if (Not IsArray(oData)){
			return [];
		}
		return oData;
	}
	public function setEventDispatcher(oEventDispatcher){
		variables.oEventDispatcher = arguments.oEventDispatcher;
	}
	public function getEventDispatcher(){
		param name="variables.oEventDispatcher" default="#request.oEventDispatcher#";
		return variables.oEventDispatcher;
	}
	public function getUUID(){
		return variables.uuid;
	}
	public function getDynamicDataEvaluationType(){
		return { EvalObjectType = 'function', EvalObjectHelper='Helper'};
	}
	function getDataCollection(){
		return [];
	}
	/* Misc function */
	public function AltColor(){
		return ( ( (request[variables.uuid].iterator.CurrentIndex MOD 2 EQ 0)?true:false )  ); 
	}

	public function dispatchRegisteredEvents(EventName){
		var oEventDispatcher = getEventDispatcher();
		/* disptach mulitple Event */
		var vc = oEventDispatcher.dispatchEvent(event:arguments.EventName);
		if (! IsNull(vc.pages))
			setBindObject(vc.pages);
	}
}