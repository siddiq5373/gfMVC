component 
	table="tblContent" 
	entityname="content"
	persistent="true" 
	displayname="Content" 
	hint="Main Content" 
	output="false"	
	
{
	property name="ContentID" generator="native" sqltype="integer" fieldtype="id";
	property name="Title" ormtype="string" length="100" notnull="true";
	property name="Abstract" ormtype="string" length="255" notnull="false";
	property name="HTMLText" ormtype="text" notnull="true";
	
	property name="MetaTitle" ormtype="string" length="100" notnull="false";
	property name="MetaDescription" ormtype="string" length="255" notnull="false";

	property name="HighPriorityEndDate" ormtype="date" datatype="date" sqltype="datetime";
	property name="IsHighPriority" ormtype="boolean" datatype="boolean" sqltype="bit" dbdefault="0";

	property name="EffectiveDate" ormtype="date" datatype="date" sqltype="datetime";
	property name="ExpireDate" ormtype="date" datatype="date" sqltype="datetime";
	
	/* all of them needs to go at base class level */
	property name="CreatedDate" ormtype="timestamp" datatype="datetime" sqltype="datetime";
	property name="ContentModifiedDate" ormtype="timestamp" column="ModifiedDate" datatype="datetime" sqltype="datetime";
	
	property name="CreatedBy" fieldType="many-to-one" cfc="user" column="UserID" fkcolumn="CreatedBy";
	property name="ModifiedBy" fieldType="many-to-one"  cfc="user"  column="UserID" fkcolumn="ModifiedBy";
	
	property name="Status"fieldType="many-to-one" cfc="status" column="StatusID" fkcolumn="StatusID";

	function preInsert(){
		setCreatedDate(now());
		
		if (getMetaTitle() EQ '')
			setMetaTitle( getTitle() );
		
	}
	
	function preUpdate(){

		if (getMetaTitle() EQ '')
			setMetaTitle( getTitle() );

		setContentModifiedDate(now());
	}
	
	function getModifiedDate(string dtFormat = 'mm/dd/yyyy hh:mm:ss'){
		if (IsNull(getContentModifiedDate()))
			local.ModifiedDate = getCreatedDate();
		else
			local.ModifiedDate = getContentModifiedDate();

		return DateFormat(local.ModifiedDate, arguments.dtFormat);

	}
	function getLastModifiedDate( dtFormat = 'mm/dd/yyyy' ){
		return getModifiedDate(arguments.dtFormat);
	}
	string function getStatusAsHTML(){ // this might be helper function

		if ( IsNull(getStatus()) OR (isArray(getStatus()) and ArrayLen(getStatus()) EQ 0 ) )
			return '';
		else if (!IsNull(getStatus()) and !IsNull(getStatus().getStatusID()) and getStatus().getStatusID() EQ 1)
			return 'checked';
		else
			return '';
	}
	
	string function getButtonText(){ // this might be helper function
	
		if (!IsNull(getContentID()) and getContentID() GT 0)
			return 'Update';
		else
			return 'Add';
	}

	string function getSEOLink(){ // needs to be at the base class level
		var Title =  getTitle();
		if (Title EQ 'Home')
			return '';
		Title = REReplace(Title, "[;\\/:""*?<>|\!\+\-\=\.`\##\&_\(\)\[\]\%\^\$\@~\',\{\}]+", "", "ALL");
		return REReplace(Title, "[[:space:]]","-", "all" );
	}

}