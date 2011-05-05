<cfcomponent>
	<cffunction name="uploadFile" output="false" hint="Upload file from the script">
	    <cfargument name="formfield" required="yes" hint="form field that contains the uploaded file">
	    <cfargument name="dest" required="yes" hint="folder to save file. relative to web root">
	    <cfargument name="conflict" required="no" type="string" default="MakeUnique">
	    <cfargument name="mimeTypesList" required="no" type="string" hint="mime types allowed to be uploaded" default="image/jpg,image/jpeg,image/gif,image/png,application/pdf,application/excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.ms-excel,image/pjpeg">
	
	    <cffile action="upload" fileField="#arguments.formField#" destination="#arguments.dest#" accept="#arguments.mimeTypesList#" nameConflict="#arguments.conflict#">
	
	    <cfreturn cffile>
	</cffunction>
	
	<cffunction name="uploadOneFile" output="false" hint="Upload file from the script">
	    <cfargument name="formfield" required="yes" hint="form field that contains the uploaded file">
	    <cfargument name="dest" required="yes" hint="folder to save file. relative to web root">
	    <cfargument name="conflict" required="no" type="string" default="MakeUnique">
	    <cfargument name="mimeTypesList" required="no" type="string" hint="mime types allowed to be uploaded" default="image/jpg,image/jpeg,image/gif,image/png,application/pdf,application/excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.ms-excel,image/pjpeg">
	
	    <cffile action="upload" destination="#expandpath(arguments.dest)#" accept="#arguments.mimeTypesList#" nameConflict="#arguments.conflict#">
	
	    <cfreturn cffile>
	</cffunction>
	
	<cffunction name="uploadAllFiles" output="false" hint="Upload multiple files from the script">
		 <cfargument name="dest" required="yes" hint="folder to save file. relative to web root">
		 
		<cffile action="uploadall" destination="#expandpath('#arguments.path#')#" nameconflict="makeunique" result="local.uploadResult">
		
		<cfreturn local.uploadResult />
	</cffunction>
	
</cfcomponent>