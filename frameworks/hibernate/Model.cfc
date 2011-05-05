component {
	property DAO;
	property validator; // use hyrule to validate objects - not implemented
	property Class;
	
	public any function init(any oEntity){
		if (!IsNull(oEntity))
			setClass( arguments.oEntity );
		return this;
	}
	
	/* getters */
	public any function getDAO() {
		setDAO();
		return variables.oDAO;
	}
	public any function getDataHelper() {
		setDataHelper();
		return variables.oDataHelper;
	}
	public any function getClass() {
		return variables.oEntity;
	}
	/* setters */
	public void function setClass(any oEntity) {
		variables.oEntity = new "model.#arguments.oEntity#"();
	}
	public void function setDataHelper() {
		if ( NOT StructKeyExists(variables,'oDataHelper') )
			variables.oDataHelper = new helpers.data();
	}
	public void function setDAO(any oDAO) {
		if (!IsNull(arguments.oDAO))
			variables.oDAO = arguments.oDAO;
			
		if ( NOT StructKeyExists(variables,'oDAO') )
			variables.oDAO = new DAO();
	}
	/* Public Functions */
	public numeric function count() {
		return getDAO().count(this.getClass());
	}

	public numeric function countWhere(required struct parameters) {
		return getDAO().countWhere(this.getClass(), parameters);
	}

	public void function delete(boolean flush="true") {
		getDAO().delete(this.getClass(), flush);
	}
	public boolean function exists(string id) {
		if (isNull(id)) {
			return getDAO().exists(this.getClass());
		}
		return getDAO().exists(this.getClass(), id);
	}

	public array function findAll(required string query, struct parameters, struct options) {
		if (isNull(parameters)) {
			parameters = {};
		}
		if (isNull(options)) {
			options = {};
		}
		return getDAO().findAll(this.getClass(), query, parameters, options);
	}

	public any function findWhere(required struct parameters, struct options) {
		if (isNull(options)) {
			options = {};
		}
		return getDAO().findWhere(this.getClass(), parameters, options);
	}

	public array function findAllWhere(required struct parameters, struct options) {
		if (isNull(options)) {
			options = {};
		}
		return getDAO().findAllWhere(this.getClass(), parameters, options);
	}
	
	public array function getAll(required string ids, struct options) {
		if (isNull(options)) {
			arguments.options = {};
		}
		return getDAO().getAll(this.getClass(), arguments.ids, arguments.options);
	}
	public array function list(struct options) {

		if (isNull(options)) {
			arguments.options = {};
		}
		return getDAO().list(this.getClass(), arguments.options);
	}

	public any function new(any data, string properties="") {
		//var model = getDAO().new(this.getClass());
		var className = ListLast(getMetaData(this.getClass()).name,'.');
		var model = EntityNew(className);
		if (structKeyExists(arguments, "data")) {
			model = getDAO().populate(model, data, properties);
		}
		//writeDump(model.getStatus());abort;
		return model;
	}


	public any function _get(required string property) {
		var value = "";
		if (structKeyExists(this.getClass(), "get#property#")) {
			value = evaluate("get#property#()");
		}
		else {
			if (right(property, 2) == "ID") {
				var relationship = left(property, len(property)-2);
				if (structKeyExists(this.getClass(), "get#relationship#")) {
					var related = evaluate("get#relationship#()");
					if (!isNull(related)) {
						value = related.getID();
					}
				}
			}
		}
		if (isNull(value)) {
			value = "";
		}
		return value;
	}

	public any function get(required string id, any data) {
		var model = getDAO().get(this.getClass(), id);

		if (!Isnull(arguments.data) and structKeyExists(arguments, "data")) {
			model.populate(data);
		}
		
		return model;
	}

	
	any function populateBean(){
		var model = getDAO().get(this.getClass(), arguments.data.id);
		
		return populateModel(model,arguments.data);
	}

	void function merge(required any entity){
		var objects = arrayNew(1);

		if( not isArray(arguments.entities) ){
			arrayAppend(objects, arguments.entities);
		}
		else{
			objects = arguments.entities;
		}

		for( var x=1; x lte arrayLen(objects); x++){
			entityMerge( objects[x] );
		}

	}

	public any function populateModel(any model, any data, string properties="") {
		return getDAO().populate(model, data, properties);
	}
	
	public any function populate(any data, string properties="") {
		if (StructKeyExists(data,'id')){
			var model = get(data.id);
			return populateModel(model, data,properties);
		}
		else
			return getDAO().populate(this.getClass(), data, properties);
	}

	public any function save(any model, boolean flush="true") {
		return getDAO().save(model, flush);
	}

	public array function getErrors() {
		var result = validator.validate(this.getClass());
		return result.getErrors();
	}

	public boolean function has(required string property) {
		var value = _get(property);
		return getDataHelper().count(value) > 0;
	}

	public boolean function hasErrors() {
		var result = validator.validate(this.getClass());
		return result.hasErrors();
	}

	public any function _set(required string property, any value) {
		if (structKeyExists(this.getClass(), "set#property#")) {
			if (!structKeyExists(arguments, "value") or isNull(value) or (isSimpleValue(value) and value eq "")) {
				evaluate("set#property#(javaCast('null', ''))");
			}
			else {
				evaluate("set#property#(value)");
			}
		}
		return this;
	}
	public boolean function validate() {
		var result = validator.validate(this.getClass());
		return result.hasErrors();
	}
	public any function showgExecutedQueries() {
		return getDAO().getExecutedQueries();
	}

	public any function dynamicMissingMethod() {
		var missingMethodName = getFunctionCalledName();
		var missingMethodArguments = arguments;

		return getDAO().missingMethod(this.getClass(), missingMethodName, missingMethodArguments[1]);
	}
	
	public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
		//this[ arguments.missingMethodName ] = dynamicMissingMethod;abort;
		//return evaluate( 'this.#arguments.missingMethodName#( arguments.missingMethodArguments )' );
		return getDAO().missingMethod(this.getClass(), missingMethodName, missingMethodArguments);
	}
}