component extends="orm.Model" {
	page function init(ApplicationSetting){
		setClass( 'content');
		setDAO( ApplicationSetting.getValue('hibernateSettings')['oDAO'] );
		return this;
	}
	
}