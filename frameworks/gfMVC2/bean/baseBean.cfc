component accessors="false" hint="Generic Base Bean" initmethod="init"  {
	variables.Storage = {}; 
	public any function init() {
		//variables.Storage = {};  
        return this; 
    }
	public void function createStorage(){
		$createStorage();
	}
	public void function setMemento( struct memento, boolean override = false ){
		lock scope="request" type="exclusive" timeout="10" {
			//$createStorage();
			StructAppend($getStorage(),arguments.memento, arguments.override);
		}
	}
	public struct function getMemento(){
		return $getStorage();
	}
	public struct function getCollection(){
		return getMemento();
	}
	public void function setValues(struct addToMemento) {
		setMemento(arguments.addToMemento,false);
	}
	public boolean function KeyExists(key) {
		return StructKeyExists($getStorage(), key);
	}
	public struct function getValues(array keyNames) {
		var returnValues = {};
		for (local.i = 1; local.i <= ArrayLen(keyNames); local.i++){
			returnValues[ keyNames[local.i] ] =  evaluate('this.get#keyNames[local.i]#()');
		}
		return returnValues;
	}
	public any function getValue(key) {   
        return $getStorage()[ arguments.key ];        
    } 
	public void function setValue(key, value) {   
        $getStorage()[ arguments.key ] = arguments.value; 
    } 
    public any function get() {
        return $getStorage()[ $getVarName( getFunctionCalledName() ) ];
    } 
    public function set(any value) { 
        $getStorage()[ $getVarName( getFunctionCalledName() ) ] = value; 
    }
	public function delete(key = '') { 
		if (trim(key) EQ '')
			StructDelete( $getStorage(), ReplaceNoCase( getFunctionCalledName(), 'delete','' ) );
		else if ( KeyExists(key) )
			StructDelete( $getStorage(), key );
    }
	public boolean function clear() { 
	 	$createStorage();
		return true;
    }
	public any function onMissingMethod(string missingMethodName, struct missingMethodArguments) {
		var throwError = true;
		if (left(arguments.missingMethodName, 3) == "set") {
			$registerDynamicFunctionCall(arguments.missingMethodName);
			evaluate( 'this.#arguments.missingMethodName#( arguments.missingMethodArguments[1] )' );
			throwError = false;
		}
		else if (left(arguments.missingMethodName, 3) == "get" and find('AND',arguments.missingMethodName) == 0) {
			registerFunctions( replace(arguments.missingMethodName, "get", "") );
			return evaluate( 'this.#arguments.missingMethodName#( arguments.missingMethodArguments[1] )' );
			throwError = false;
		}
		else if (left(missingMethodName, 3) == "get" and find('AND',arguments.missingMethodName) > 0 ) {
			var functionName = replace(arguments.missingMethodName, "get", "");
			var varNames =  ListToArray(ReReplace(functionName,'AND',',','all'));
			var returnValues = {};
			try{
				for (local.i = 1; local.i <= ArrayLen(varNames); local.i++){
					returnValues[ varNames[local.i] ] =  evaluate('this.get#varNames[local.i]#()');
				}
				return returnValues;
            }
            catch(Any e) {
				throwError = true;
            }
		}
		if (throwError) {
			throw('Function name #arguments.missingMethodName# not exists');
		}
	}
	public void function registerFunctions(varName_s){
		
		if ( IsSimpleValue( arguments.varName_s ) ) {
			$registerDynamicFunctionCall( 'set#arguments.varName_s#' );
			
		}
		else if ( IsArray( arguments.varName_s ) ){
			for (local.i = 1; local.i <= ArrayLen(arguments.varName_s); local.i++){
				$registerDynamicFunctionCall( 'set#arguments.varName_s[ local.i ]#' );
			}
		}
		else if ( IsStruct( arguments.varName_s ) ){
			for (local.varnam in arguments.varName_s){
				$registerDynamicFunctionCall( 'set#local.varnam#' );
			}
		}
	}
	public struct function $getStorage(){
		return variables.Storage;
	}
	private void function $createStorage(){ // Umm this is case sensitive
		var oApplicationCollection = createObject("java", "java.util.LinkedHashMap").init();
	 	variables.Storage = createObject("java", "java.util.Collections").synchronizedMap( oApplicationCollection );
	}
	
	private string function $getVarName(name){
		return mid(name,4,len(name)-3);
	}
	private void function $registerDynamicFunctionCall(required functionNameToMap) {
		arguments.getterFunctionNameToMap = replaceNoCase(functionNameToMap, "set", "get");
		arguments.deleteFunctionNameToMap = replaceNoCase(functionNameToMap, "set", "delete");
		
		/* Register dynamic function for the getter and setter */
		this[ arguments.getterFunctionNameToMap ] = get;
		this[ arguments.functionNameToMap ] = set;
		this[ arguments.deleteFunctionNameToMap ] = delete;
	}
} 