<cfcomponent output="false" hint="Prevent security attacks where an unauthorized party attempts to access coldfusion files under /CFIDE/scripts/ajax/FCKeditor/editor/filemanager folder">
	<cfset this.name = "fckeditor_filemanager">
	<cffunction name="onRequestStart"> 
		<cfargument name="targetpage" required=true type="string" />
		<cfset verifyClient()>
		<cfreturn true>	
	</cffunction>
</cfcomponent>