component 
	table="tblUser" 
	entityname="user"
	persistent="true" 
	displayname="User" 
	hint="users" 
	output="false"	
	
{
	property name="UserID" generator="native" sqltype="integer" fieldtype="id";
	property name="LoginName" ormtype="string" length="100" notnull="false" ;
	property name="Password" ormtype="string" length="100" notnull="true";
	
	property name="FirstName" ormtype="string" length="100" notnull="true";
	property name="LastName" ormtype="string" length="100" notnull="true";
	property name="Email" ormtype="string" length="255" notnull="true";
	
	property name="LastLoggedIn" ormtype="date" datatype="datetime" sqltype="datetime" notnull="false" ;
	
	/* all of them needs to go at base class level */
	property name="CreatedDate" ormtype="timestamp" datatype="datetime" sqltype="datetime";
	property name="UserModifiedDate" ormtype="timestamp" column="ModifiedDate" datatype="datetime" sqltype="datetime";

	property name="CreatedBy" fieldType="many-to-one" cfc="user" column="UserID" fkcolumn="CreatedBy";
	property name="ModifiedBy" fieldType="many-to-one"  cfc="user"  column="UserID" fkcolumn="ModifiedBy";
	property name="Status"fieldType="many-to-one" cfc="status" column="StatusID" fkcolumn="StatusID";
	
	
	function preInsert(){
		setCreatedDate(now());
		setLoginName(getEmail());
	}

	function preUpdate(){
		setUserModifiedDate(now());
	}
	
	function getModifiedDate(){
		if (IsNull(this.UserModifiedDate))
			local.ModifiedDate = getCreatedDate();
		else
			local.ModifiedDate = this.UserModifiedDate;

		return DateFormat(local.ModifiedDate,'mm/dd/yyyy hh:mm:ss');

	}
	
	string function getStatusAsHTML(){ // has to be loaded in the helper function
	
		if (!IsNull(getStatus()) and getStatus().getStatusID() EQ 1)
			return 'checked';
		else
			return '';
	}
}