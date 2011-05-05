component {
	public any function init(){
		return this;
	}
	
	/*
	* @hint  get the properties from a specific meta data or component instance (by default, this)
	* @output false
	*/
	public struct function getProperties(required struct metaDataToCheck )
	{ 
		var i = -1;
		var theseProperties = {};
		var thisProperty = "";
		var md = arguments.metaDataToCheck;
		//if this metaData has properties, loop through them, populating a struct of properties
		if(structKeyExists(md,"properties")){
			for(i = 1; i LTE arrayLen(md.properties); i = i + 1){
				thisProperty = md.properties[i];
				theseProperties[thisProperty.name] = thisProperty;
			}
		}
		return theseProperties;
	}
	/**
	* @hint  a method for traversing the metaData to get properties up the tree, by default, looks at this
	* @output false
	*/
	public struct function getAllProperties(required struct metaDataToCheck)
	{
		var ii = 1;
		var allProperties = {};
		var md = arguments.metaDataToCheck;
	 
		//if this component is extended, recurse up the tree
		if(structKeyExists(arguments.metaDataToCheck,"extends")){
			allProperties = getAllProperties(arguments.metaDataToCheck.extends);
		}
		//append these properties to allProperties; allow overwrite to allow children properties to  over-ride parents
		structAppend(allProperties,getProperties(arguments.metaDataToCheck),true);
		return allProperties;
	}
	
	/**
	* @hint  a method for traversing the metaData to get function up the tree, by default, looks at this
	* @output false
	*/
	public struct function getAllFunctions(required struct metaDataToCheck)
	{
		var ii = 1;
		var allFunctions = {};
		var md = arguments.metaDataToCheck;
		if(structKeyExists(arguments.metaDataToCheck,"extends")){
			allFunctions = getAllFunctions(arguments.metaDataToCheck.extends);
		}
		structAppend(allFunctions,getFunctions(arguments.metaDataToCheck),true);

		//writeDump(allFunctions);abort;
		return allFunctions;
	}
	/*
	* @hint  get the properties from a specific meta data or component instance (by default, this)
	* @output false
	*/
	public struct function getFunctions(required struct metaDataToCheck )
	{ 
		var i = -1;
		var theseFunctions = {};
		var thisFunction = "";
		var md = arguments.metaDataToCheck;
		//writeDump(md);abort;
		//if this metaData has properties, loop through them, populating a struct of properties
		if(structKeyExists(md,"functions")){
			for(i = 1; i LTE arrayLen(md.functions); i = i + 1){
				thisFunction = md.functions[i];
				theseFunctions[thisFunction.name] = thisFunction;
			}
		}
		return theseFunctions;
	}
	public boolean function FunctionExists(required struct metaDataToCheck, required string functionNameToCheck)
	{
		var allFunctions = getAllFunctions( arguments.metaDataToCheck );
		return StructKeyExists(allFunctions, arguments.functionNameToCheck);
	}
	/**
	* @hint  return properties structures in an array
	* @output false
	*/ 
	public array function getAllPropertiesArray()
	{
		var allProps = getAllProperties();
		var aProperties = [];
		var key = '';
		var prop = '';
		for(key in allProps){
			prop = allProps[key];
			arrayappend(aProperties,prop);
		}
		return aProperties;
	}
}