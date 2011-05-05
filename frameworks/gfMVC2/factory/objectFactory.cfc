component accessors="false" output="false" initmethod="objectFactory" serializable="true" {
	property name="objectStorage" type="struct";
	
	this.registerObject = setObject;
	
	objectFactory function objectFactory( string AppKey = CreateUUID() ){
	
		variables.objectStorage = {};
		variables.objectStorageAppKey = arguments.AppKey;
		
		//CachePut(variables.objectStorageAppKey, variables.objectStorage);
		//variables.objectStorage[ variables.objectStorageAppKey ] = {};
		
		return this;
	}
	private any function getCacheKey(string objectKey){
		return Hash( LCase( variables.objectStorageAppKey  &'-'& arguments.objectKey) );
	}
	
	public any function exists(string Key){
		var ObjectKey =  getCacheKey( arguments.Key );
		var objectStorage = variables.objectStorage;
		
		return structKeyExists(objectStorage, ObjectKey);
		
	}
	public any function getObject(string Key, initParams = StructNew()){
		var objectProperty = {};
		var ObjectKey =  getCacheKey( arguments.Key );
		var objectStorage = variables.objectStorage;
		
		if ( structKeyExists(objectStorage, ObjectKey) )
			objectProperty = objectStorage[ObjectKey]['object'];
		else
			objectProperty = CacheGet( ObjectKey );

		if ( isNull(objectProperty) ) {
			objectProperty = setObject(objectFullPath:arguments.Key, initParams:arguments.initParams);
		}
		if ( Not structIsEmpty(objectProperty) and objectStorage[ObjectKey][ 'IsSingleton' ] ){
			var ObjectExists = isObject( objectStorage[ObjectKey]['object'] );
			if (ObjectExists)
				 return objectStorage[ObjectKey]['object'];
			else {
				lock scope="Application" timeout="30" type="exclusive" {
					objectStorage[ObjectKey]['object'] = newInstance( objectStorage[ObjectKey]['object'] );
					if ( objectProperty[ ObjectKey ] [ 'scope' ] EQ 'Application' )
						variables.objectStorage[ObjectKey] = objectProperty;
					else if ( objectProperty[ ObjectKey ] [ 'scope' ] EQ 'EHCache' ){
						CachePut(cacheKey, objectProperty);
					}
				}
				return objectStorage[ObjectKey]['object'];
			} 
		}
	}
	
	public any function setObject(any objectFullPath, string key = '', initParams=StructNew(),  boolean IsSingleton = true, string ObjectKey = '', boolean IsLazy = true, string scope = 'Application'){
		var cacheKey = '';
		var objectProperty = {};
		if (arguments.key EQ ''){
			arguments.key = getCacheKey( arguments.objectFullPath );
		}
		else 
			arguments.key = getCacheKey( arguments.key );

		cacheKey = arguments.key;
		StructAppend(objectProperty,arguments);
		
		objectProperty.object = arguments.objectFullPath;
		
		if (NOT IsObject(objectProperty.object) and arguments.IsSingleton and arguments.IsLazy){
			objectProperty.object = newInstance(arguments.objectFullPath, arguments.initParams);
		}
		lock scope="Application" timeout="30" type="exclusive" {
			if (arguments.scope eq 'EHCache'){
				CachePut(cacheKey, objectProperty);
			}
			else if (arguments.scope eq 'Application'){
				variables.objectStorage[cacheKey] = objectProperty;
			}
		}
		return objectProperty;
	}
	
	private any function newInstance( string objectFullPath, initParams = StructNew() ){
		//return createObject(arguments.objectFullPath);	
		return new "#arguments.objectFullPath#"(argumentCollection:initParams);	
	}
	
	
	
}