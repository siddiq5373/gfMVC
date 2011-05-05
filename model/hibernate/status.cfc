component table="tblStatus" persistent="true" displayname="Status Info" hint="Status Info" output="false"
{
	property name="StatusID" generator="native" sqltype="integer" fieldtype="id";
	property name="Code" ormtype="string" length="50"; 
	property name="Name" ormtype="string" length="100";
	property name="Description" ormtype="string" length="255";
	
}