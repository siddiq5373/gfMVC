component accessors="true"  {
	property DAO;
	
	generic function init(ApplicationSetting){
		setDAO( ApplicationSetting.getValue('hibernateSettings')['oDAO'] );
		return this;
	}
	
	public any function get(string className, required string id, struct options) {
		if (isNull(options)) {
			arguments.options = {};
		}
		var class = getDAO().new(arguments.className);
		return getDAO().get(class, arguments.id);
	}
	
	public array function getAll(string className, required string ids, struct options) {
		if (isNull(options)) {
			arguments.options = {};
		}
		var class = getDAO().new(arguments.className);
		return getDAO().getAll(class, arguments.ids, arguments.options);
	}
	
	any function populateBean(string className, any data){
		var model = get(className, arguments.data.id);
		return getDAO().populate(model, arguments.data);
	}
	
	public any function new(string className, any data, boolean flush="true") {
		var class = getDAO().new(arguments.className);
		var model = EntityNew(className);
		
		if (structKeyExists(arguments, "data")) {
			model = getDAO().populate(model, data, '');
		}
		return model;
	}
	
	public any function save(any model, boolean flush="true") {
		return getDAO().save(model, flush);
	}
	
	public array function ServiceList(struct options) {

		if (isNull(options)) {
			arguments.options = {sort='Seq'};
		}
		return $List('service', arguments.options);
	}
	
	public array function $List(any model, struct options) {

		if (isNull(options)) {
			arguments.options = {};
		}
		return getDAO().list(arguments.model, arguments.options);
	}
	
}