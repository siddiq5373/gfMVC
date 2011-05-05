component 
	displayname="basic functions" 
	output="false"
	accessors="true"
{
	property name="addEvent" type="string" default="" persistent="false" ;
	property name="editEvent" type="string" default="" persistent="false" ;
	property name="listEvent" type="string" default="" persistent="false" ;
	property name="deleteEvent" type="string" default="" persistent="false" ;
	property name="helperCFC" type="any" hint="Object Helper CFC" persistent="false" ;
	property name="meta" type="struct" persistent="false" ;
	
	public any function _set(required string property, any value) {
		if (structKeyExists(this, "set#property#")) {
			if (!structKeyExists(arguments, "value") or isNull(value) or (isSimpleValue(value) and value eq "")) {
				evaluate("set#property#(javaCast('null', ''))");
			}
			else {
				evaluate("set#property#(value)");
			}
		}
		return this;
	}

	
	public any function init(String FrameworkCachePath=''){
		if (StructKeyExists(arguments,FrameworkCachePath)) {
			if (trim(arguments.FrameworkCachePath) != '')
				variables.FrameworkCachePath = arguments.FrameworkCachePath;
		}
		return this;
	}
	/* Need this old school generic get and set concept might be really useful */
	public void function setValue(required key, required keyValue){
		variables[arguments.key] = arguments.keyValue;
	}
	public any function getValue(required key){
		if (StructKeyExists(variables,arguments.key))
			return variables[arguments.key];
		else
			return '';
	}
	public void function setMeta(required metaDataToCheck) {
		variables.metaDataToCheck = arguments.metaDataToCheck;
	}
	public any function getMeta() {
		if (NOT StructKeyExists(variables,'metaDataToCheck'))
			variables.metaDataToCheck = getMetaData(this);
		return variables.metaDataToCheck;
	}
	
	public any function getMetaHelper() {
		if (NOT StructKeyExists(Application,'oCFCMetaHelper')) {
			Application.oCFCMetaHelper = createObject('beanMetaHelper');
		}
		return Application.oCFCMetaHelper;
	}
	public any function getHelperCFC() {
		return variables.helperCFC;	
	}
	public function setHelperObject(HelperObject){
		var HelperObjectInstance = arguments.HelperObject;
		HelperObjectInstance.setBeanObject(this);
		setValue('HelperCFC',HelperObjectInstance);
	}
	public any function getHelperObject(){
		return getValue('HelperCFC');
	}

	private function $setMemento(){
		structAppend(variables,getMemento(),true);
	}
	public void function setMemento( struct memento ){
	    var i="";
	    var allProps= getMetaHelper().getAllProperties( getMeta() );
		var key = '';
		for(key in allProps){
			 if ( structKeyExists( arguments.memento, key ) ){
				variables[key] = arguments.memento[key];
				if ( key eq 'ObjectID' and getMetaHelper().FunctionExists(getMeta(), 'setKeyID') ){
					setKeyID( arguments.memento[key] );
				}
			}
		}
	}
	public struct function getMemento()
	{
		var instance = {};
		var key = '';
		for(key in getMetaHelper().getAllProperties( getMeta() )){
			if( structKeyExists(variables,key) )
		  		instance[key] = variables[key];
		}
		return instance;
	}
	public any function onMissingMethod() {
		if (FindNoCase('findBy', arguments.missingMethodName) GT 0){
			throw('function name '& arguments.missingMethodName & 'not found');
		}
		local.HelperObject = getValue('HelperCFC');
		local.result = evaluate('local.HelperObject.#arguments.missingMethodName#(argumentsCollection:arguments.missingMethodArguments)');
		return local.result;
	}
	private function $UCamelCase(value){
		return REReplaceNoCase(LCase(value),"(^[a-z*]|[ *][a-z*])","\U\1\E","all");
	}

}