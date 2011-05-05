component extends="orm.Model" {
	user function init(ApplicationSetting){
		setClass( 'user');
		setDAO( ApplicationSetting.getValue('hibernateSettings')['oDAO'] );
		return this;
	}

}