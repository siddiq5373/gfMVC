<cfscript>
public function setValue(key, value){
	//variable[key] = value;
	setVariable("#key#",value);	
}
public function getValue(key){
	//return variable[key];
	return evaluate(key);
}
public function exists(key){
	return StructKeyExists(variables,key);
}
public function getController(){
	return variables.Controller;
}
public function getConfig(){
	return variables.Config;
}
public function getEventMeta(){
	return variables.Meta;
}
public boolean function IsHandler(){
	return FindNoCase('.handlers.events.',variables.meta.name);
}
public boolean function IsListener(){
	return FindNoCase('.handlers.listeners.',variables.meta.name);
}
attributes.cfcInstance['getValue'] = getValue;
attributes.cfcInstance['setValue'] = setValue;
attributes.cfcInstance['getConfig'] = getConfig;
attributes.cfcInstance['getController'] = getController;
attributes.cfcInstance['getEventMeta'] = getEventMeta;
attributes.cfcInstance['exists'] = exists;
attributes.cfcInstance['IsHandler'] = IsHandler;
attributes.cfcInstance['IsListener'] = IsListener;

attributes.cfcInstance.setValue('Controller',attributes.Controller);
attributes.cfcInstance.setValue('Config', attributes.Controller.getConfig());
attributes.cfcInstance.setValue('Meta', attributes.cfcEventMeta);
if ( StructKeyExists(attributes.cfcEventMeta,'postProcess') ){
	attributes.cfcInstance.postProcess();abort;
}


</cfscript>

<cfexit method="exittag" />