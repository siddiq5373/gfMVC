component accessors="true" displayname="Object Pooling by scope" {
	
	property name="ApplicationPoolStorage" type="any";
	property name="RequestPoolStorage" type="any";
	property name="WeekPoolStorage" type="any";
	
	public any function init(){
		var oApplicationReference = CreateObject("java","java.util.LinkedHashMap").init();
		var oWeakReference = createObject("java", "java.util.WeakHashMap").init();
		var oRequestReference = CreateObject("java","java.util.LinkedHashMap").init();
		
		setApplicationPoolStorage (  createObject("java", "java.util.Collections").synchronizedMap ( oApplicationReference ) );
		setWeekPoolStorage( createObject("java", "java.util.Collections").synchronizedMap( oWeakReference ) );
		setRequestPoolStorage( createObject("java", "java.util.Collections").synchronizedMap( oRequestReference ) );
		
		return this;
		
	}
	
	public any function getObject(any key, string poolType = 'Application'){
		var poolStorage = getApplicationPoolStorage();
		
		if ( poolStorage.containsKey(arguments.key) ){
			return poolStorage.get( arguments.key );
		}
	}
	
	public void function setObject(any key, any value, string poolType = 'Application'){
		var poolStorage = getApplicationPoolStorage();
		
		poolStorage.put( arguments.key,  arguments.value);

	}
	public boolean function exists(any key){
		var poolStorage = getApplicationPoolStorage();
		
		return poolStorage.containsKey(arguments.key);
	}
	
}
