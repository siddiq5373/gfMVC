<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author 	 :	Luis Majano
Date     :	September 23, 2005
Description :
	This is a utilities library that are file related, most of them.


Modification History:
08/01/2006 - Added createFile(),getFileExtension()
10/10/2006 - Returntypes review.
----------------------------------------------------------------------->
<cfcomponent hint="This is a Utilities CFC" output="false" accessors="true" >
	<cfproperty name="pluginName" type="string" />
	<cfproperty name="pluginVersion" type="string" />
	<cfproperty name="pluginDescription" type="string" />
	<cfproperty name="pluginAuthor" type="string" />

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" access="public" returntype="Utilities" output="false">
		<cfscript>
			
			setpluginName("Utilities Plugin");
			setpluginVersion("1.1");
			setpluginDescription("This plugin provides various file/system/java utilities");
			setpluginAuthor("Luis Majano, Sana Ullah");

			
			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- UTILITY METHODS ------------------------------------------->

	<cffunction name="queryStringToStruct" output="false" returntype="struct" hint="Converts a querystring into a struct of name value pairs">
		<cfargument name="qs" type="string" required="true" default="" hint="The query string"/>
		<cfscript>
			var i 		 = 1;
			var results  = structnew();
			var thisVal  = "";
			
			// If conventions found, continue parsing
			for(i=1; i lte listLen(arguments.qs,"&"); i=i+1){
				thisVal = listGetAt(arguments.qs,i,"&");
				// Parse it out
				results[ getToken(thisVal,1,"=") ] = getToken(thisVal,2,"=");
			}//end loop over pairs
		
			return results;
		</cfscript>
	</cffunction>

	<cffunction name="isCFUUID" output="false" returntype="boolean" hint="Checks if a passed string is a valid UUID.">
		<cfargument name="inStr" type="string" required="true" />
		<cfreturn reFindNoCase("^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{16}$", inStr) />
	</cffunction>

	<!--- ************************************************************* --->
	
	<cffunction name="isSSL" output="false" returntype="boolean" hint="Tells you if you are in SSL mode or not.">
		<cfscript>
			if( isBoolean(cgi.server_port_secure) and cgi.server_port_secure ){
				return true;
			}
			else{
				return false;
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="IsEmail" access="public" returntype="boolean" output="false" hint="author Jeff Guillaume (jeff@kazoomis.com): Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains)">
		<cfargument name="str" 	type="any" 		required="true">
		<cfargument name="tlds" type="string" 	required="false" default="" hint="Additional top level domains to add to the evaluation.  Use a | to separate them"/>
		<cfscript>
		/**
		 * Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
		 * Update by David Kearns to support '
		 * SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
		 *
		 * @param str 	 The string to check. (Required)
		 * @return Returns a boolean.
		 * @author Jeff Guillaume (jeff@kazoomis.com)
		 * @version 2, August 15, 2002
		 */
	    /* tlds check */
	    if( len(trim(arguments.tlds)) ){ arguments.tlds = "|" & arguments.tlds; }
	    /* Check Verification */
		if (REFindNoCase("^['_a-z0-9-+]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|coop|info|jobs|mobi|museum|name|travel|post#arguments.tlds#))$",arguments.str))
			return TRUE;
		else
			return FALSE;
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="IsURL" access="public" returntype="boolean" output="false" hint="author Nathan Dintenfass (nathan@changemedia.com): A quick way to test if a string is a URL">
		<cfargument name="str" type="any" required="true">
		<cfscript>
		/**
		 * A quick way to test if a string is a URL
		 *
		 * @param stringToCheck 	 The string to check.
		 * @return Returns a boolean.
		 * @author Nathan Dintenfass (nathan@changemedia.com)
		 * @version 1, November 22, 2001
		 */
	    return REFindNoCase("^(((https?:|ftp:|gopher:)\/\/))[-[:alnum:]\?%,\.\/&##!@:=\+~_]+[A-Za-z0-9\/]$",arguments.str) NEQ 0;
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="sleeper" access="public" returntype="void" output="false" hint="Make the main thread of execution sleep for X amount of seconds.">
		<cfargument name="milliseconds" type="numeric" required="yes" hint="Milliseconds to sleep">
		<cfset CreateObject("java", "java.lang.Thread").sleep(arguments.milliseconds)>
	</cffunction>

	<!--- ************************************************************* --->
	
	<!--- PlaceHolder Replacer --->
	<cffunction name="placeHolderReplacer" access="public" returntype="any" hint="PlaceHolder Replacer for strings containing ${} patterns" output="false" >
		<!---************************************************************************************************ --->
		<cfargument name="str" 		required="true" type="any" hint="The string variable to look for replacements">
		<cfargument name="settings" required="true" type="any" hint="The structure of settings to use in replacing">
		<!---************************************************************************************************ --->
		<cfscript>
			var returnString = arguments.str;
			var regex = "\$\{([0-9a-z\-\.\_]+)\}";
			var lookup = 0;
			var varName = 0;
			var varValue = 0;
			/* Loop and Replace */
			while(true){
				/* Search For Pattern */
				lookup = reFindNocase(regex,returnString,1,true);	
				/* Found? */
				if( lookup.pos[1] ){
					/* Get Variable Name From Pattern */
					varName = mid(returnString,lookup.pos[2],lookup.len[2]);
					/* Lookup Value */
					if( structKeyExists(arguments.settings,varname) ){
						varValue = arguments.settings[varname];
					}
					else if( isDefined("arguments.settings.#varName#") ){
						varValue = Evaluate("arguments.settings.#varName#");
					}
					else{
						varValue = "VAR_NOT_FOUND";
					}
					/* Remove PlaceHolder Entirely */
					returnString = removeChars(returnString, lookup.pos[1], lookup.len[1]);
					/* Insert Var Value */
					returnString = insert(varValue, returnString, lookup.pos[1]-1);
				}
				else{
					break;
				}	
			}
			/* Return Parsed String. */
			return returnString;
		</cfscript>
	</cffunction>
	
	<!--- ************************************************************* --->
	
	<cffunction name="_serialize" access="public" returntype="string" output="false" hint="Serialize complex objects that implement serializable. Returns a binary string.">
		<!--- ************************************************************* --->
		<cfargument name="ComplexObject" type="any" required="true" hint="Any coldfusion primative data type and if cf8 componetns."/>
        <!--- ************************************************************* --->
		<cfscript>
            var ByteArrayOutput = CreateObject("java", "java.io.ByteArrayOutputStream").init();
            var ObjectOutput    = CreateObject("java", "java.io.ObjectOutputStream").init(ByteArrayOutput);
           
            /* Serialize the incoming object. */
            ObjectOutput.writeObject(arguments.ComplexObject);
            ObjectOutput.close();

            return ToBase64(ByteArrayOutput.toByteArray());
        </cfscript>
    </cffunction>
    
    <!--- Serialize an object to a file --->
    <cffunction name="_serializeToFile" access="public" returntype="void" output="false" hint="Serialize complex objects that implement serializable, into a file.">
		<!--- ************************************************************* --->
		<cfargument name="ComplexObject" type="any" required="true" hint="Any coldfusion primative data type and if cf8 componetns."/>
        <cfargument name="fileDestination" required="true" type="string" hint="The absolute path to the destination file to write to">
        <!--- ************************************************************* --->
		<cfscript>
            var FileOutput = CreateObject("java", "java.io.FileOutputStream").init("#arguments.fileDestination#");
            var ObjectOutput    = CreateObject("java", "java.io.ObjectOutputStream").init(FileOutput);
           
            /* Serialize the incoming object. */
            ObjectOutput.writeObject(arguments.ComplexObject);
            ObjectOutput.close();
        </cfscript>
    </cffunction>
    
    <!--- Deserialize a byte array --->
    <cffunction name="_deserialize" access="public" returntype="Any" output="false" hint="Deserialize a byte array">
        <!--- ************************************************************* --->
		<cfargument name="BinaryString" type="string" required="true" hint="The byte array string to deserialize"/>
        <!--- ************************************************************* --->
		<cfscript>
            var ByteArrayInput = CreateObject("java", "java.io.ByteArrayInputStream").init(toBinary(arguments.BinaryString));
    		var ObjectInput    = CreateObject("java", "java.io.ObjectInputStream").init(ByteArrayInput);
	        var obj = "";
	           
           	obj = ObjectInput.readObject();
            objectInput.close();
            
            return obj;
        </cfscript>
    </cffunction>
    
     <!--- Deserialize a byte array --->
    <cffunction name="_deserializeFromFile" access="public" returntype="Any" output="false" hint="Deserialize a byte array from a file">
        <!--- ************************************************************* --->
		<cfargument name="fileSource" required="true" type="string" hint="The absolute path to the source file to deserialize">
        <!--- ************************************************************* --->
		<cfscript>
			var object = "";
            var FileInput = CreateObject("java", "java.io.FileInputStream").init("#arguments.fileSource#");
    		var ObjectInput    = CreateObject("java", "java.io.ObjectInputStream").init(FileInput);
	           
           	/* Return inflated Object. */
           	object = ObjectInput.readObject();
           	ObjectInput.close();
           	
            return object;
        </cfscript>
    </cffunction>
   
   <cffunction name="marshallData" access="public" returntype="any" hint="Marshall data according to type" output="false" >
   		<!--- ******************************************************************************** --->
		<cfargument name="type" 		required="true" type="string" hint="The type to marshal to. Valid values are JSON, XML, WDDX, PLAIN">
  		<cfargument name="data" 		required="true" type="any" 	  hint="The data to marshal">
   		<cfargument name="encoding" 	required="false" type="string" default="utf-8" hint="The default character encoding to use"/>
		<!--- ************************************************************* --->
		<cfargument name="jsonCase" 		type="string"   required="false" default="lower" hint="JSON Only: Whether to use lower or upper case translations in the JSON transformation. Lower is default"/>
		<cfargument name="jsonQueryFormat" 	type="string" 	required="false" default="query" hint="JSON Only: query or array" />
		<!--- ************************************************************* --->
		<cfargument name="xmlColumnList"    type="string"   required="false" default="" hint="XML Only: Choose which columns to inspect, by default it uses all the columns in the query, if using a query">
		<cfargument name="xmlUseCDATA"  	type="boolean"  required="false" default="false" hint="XML Only: Use CDATA content for ALL values. The default is false">
		<cfargument name="xmlListDelimiter" type="string"   required="false" default="," hint="XML Only: The delimiter in the list. Comma by default">
		<cfargument name="xmlRootName"      type="string"   required="false" default="" hint="XML Only: The name of the initial root element of the XML packet">
		<!--- ******************************************************************************** --->
		<cfset var results = "">
   		<cfset var args = structnew()>
   		
		<!--- Validate Type --->
		<cfif not reFindNocase("^(JSON|PLAIN|XML|WDDX)$",arguments.type)>
			<cfthrow message="Invalid type" detail="The type you sent: #arguments.type# is invalid. Valid types are JSON, WDDX, XML and PLAIN" type="Utilities.InvalidType">
		</cfif>
		
		<!--- Marshall the data --->
		<cfif arguments.type eq "PLAIN">
			<cfset results = arguments.data>
		<cfelseif arguments.type eq "JSON">
			<cfscript>
				args.queryKeyCase 	= arguments.jsonCase;
				args.keyCase 		= arguments.jsonCase;
				args.data 			= arguments.data;
				args.queryFormat	= arguments.jsonQueryFormat;
				results 			= getPlugin("JSON").encode(argumentCollection=args);
			</cfscript>
		<cfelseif arguments.type eq "WDDX">
			<cfwddx action="cfml2wddx" input="#arguments.data#" output="results">
		<cfelseif arguments.type eq "XML">
			<cfscript>
				args.data = arguments.data;
				args.encoding = arguments.encoding;
				args.useCDATA = arguments.xmlUseCDATA;
				args.delimiter = arguments.xmlListDelimiter;
				args.rootName = arguments.xmlRootName;
				if( len(trim(arguments.xmlColumnList)) ){ args.columnlist = arguments.xmlColumnList; }
				results = getPlugin("XMLConverter").toXML(argumentCollection=args);
			</cfscript>
		</cfif>
		
		<!--- Return Marshalled data --->	
		<cfreturn results>
   </cffunction>
   
   
<!------------------------------------------- OS SPECIFIC METHODS ------------------------------------------->

	<!--- ************************************************************* --->

	<cffunction name="getOSFileSeparator" access="public" returntype="string" output="false" hint="Get the operating system's file separator character">
		<cfscript>
		var objFile =  createObject("java","java.lang.System");
		return objFile.getProperty("file.separator");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="getOSPathSeparator" access="public" returntype="string" output="false" hint="Get the operating system's path separator character.">
		<cfscript>
		var objFile =  createObject("java","java.lang.System");
		return objFile.getProperty("path.separator");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="getOSName" access="public" returntype="string" output="false" hint="Get the operating system's name">
		<cfscript>
		var objFile =  createObject("java","java.lang.System");
		return objFile.getProperty("os.name");
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="getInetHost" access="public" returntype="string" output="false" hint="Get the hostname of the executing machine.">
		<cfreturn CreateObject("java", "java.net.InetAddress").getLocalHost().getHostName()>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="getIPAddress" access="public" returntype="string" output="false" hint="Get the ip address of the executing hostname machine.">
		<cfreturn CreateObject("java", "java.net.InetAddress").getLocalHost().getHostAddress()>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="getJavaRuntime" access="public" returntype="string" output="false" hint="Get the java runtime version">
		<cfreturn CreateObject("java", "java.lang.System").getProperty("java.runtime.version")>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="getJavaVersion" access="public" returntype="string" output="false" hint="Get the java version.">
		<cfreturn CreateObject("java", "java.lang.System").getProperty("java.version")>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="getJVMfreeMemory" access="public" returntype="string" output="false" hint="Get the JVM's free memory.">
		<cfscript>
		return CreateObject("java", "java.lang.Runtime").getRuntime().freeMemory();
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="getJVMTotalMemory" access="public" returntype="string" output="false" hint="Get the JVM's total memory.">
		<cfreturn CreateObject("java", "java.lang.Runtime").getRuntime().totalMemory()>
	</cffunction>

	<!--- ************************************************************* --->

<!------------------------------------------- CFFILE FACADES ------------------------------------------->

	<!--- Upload File --->
	<cffunction name="uploadFile" access="public" hint="Facade to upload to a file, returns the cffile variable." returntype="any" output="false">
		<!--- ************************************************************* --->
		<cfargument name="FileField"         type="string" 	required="yes" 		hint="The name of the form field used to select the file">
		<cfargument name="Destination"       type="string" 	required="yes"      hint="The absolute path to the destination.">
		<cfargument name="NameConflict"      type="string"  required="false" default="makeunique" hint="Action to take if filename is the same as that of a file in the directory.">
		<cfargument name="Accept"            type="string"  required="false" default="" hint="Limits the MIME types to accept. Comma-delimited list.">
		<cfargument name="Attributes"  		 type="string"  required="false" default="Normal" hint="Comma-delimitted list of window file attributes">
		<cfargument name="Mode" 			 type="string"  required="false" default="755" 	  hint="The mode of the file for Unix systems, the default is 755">
		<!--- *************************************** --->

		<cfset var results = "">
		
		<cffile action="upload" 
				filefield="#arguments.FileField#" 
				destination="#arguments.Destination#" 
				nameconflict="#arguments.NameConflict#" 
				accept="#arguments.Accept#"
				mode="#arguments.Mode#"
				Attributes="#arguments.Attributes#"
				result="results">
		
		<cfreturn results>
	</cffunction>
   
	<!--- ************************************************************* --->

	<cffunction name="readFile" access="public" hint="Facade to Read a file's content" returntype="Any" output="false">
		<!--- ************************************************************* --->
		<cfargument name="FileToRead"	 		type="String"  required="yes" 	 hint="The absolute path to the file.">
		<cfargument name="ReadInBinaryFlag" 	type="boolean" required="false" default="false" hint="Read in binary flag.">
		<cfargument name="CharSet"				type="string"  required="false" default="" hint="CF File CharSet Encoding to use.">
		<cfargument name="CheckCharSetFlag" 	type="boolean" required="false" default="false" hint="Check the charset.">
		<!--- ************************************************************* --->
		<cfset var FileContents = "">
		<!--- Verify File Encoding to use --->
		<cfif arguments.CheckCharSetFlag><cfset arguments.charset = checkCharSet(arguments.CharSet)></cfif>
		<!--- Binary Test --->
		<cfif ReadInBinaryFlag>
			<cffile action="readbinary" file="#arguments.FileToRead#" variable="FileContents">
		<cfelse>
			<cfif arguments.charset neq "">
				<cffile action="read" file="#arguments.FileToRead#" variable="FileContents" charset="#arguments.charset#">
			<cfelse>
				<cffile action="read" file="#arguments.FileToRead#" variable="FileContents">
			</cfif>
		</cfif>
		<cfreturn FileContents>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="saveFile" access="public" hint="Facade to save a file's content" returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="FileToSave"	 		type="any"  	required="yes" 	 hint="The absolute path to the file.">
		<cfargument name="FileContents" 		type="any"  	required="yes"   hint="The file contents">
		<cfargument name="CharSet"				type="string"  	required="false" default="utf-8" hint="CF File CharSet Encoding to use.">
		<cfargument name="CheckCharSetFlag" 	type="boolean" required="false" default="false" hint="Check the charset.">
		<!--- ************************************************************* --->
		<!--- Verify File Encoding to use --->
		<cfif arguments.CheckCharSetFlag><cfset arguments.charset = checkCharSet(arguments.CharSet)></cfif>
		<cffile action="write" file="#arguments.FileToSave#" output="#arguments.FileContents#" charset="#arguments.charset#">
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="appendFile" access="public" hint="Facade to append to a file's content" returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="FileToSave"	 		type="any"  required="yes" 	 hint="The absolute path to the file.">
		<cfargument name="FileContents" 		type="any"  required="yes"   hint="The file contents">
		<cfargument name="CharSet"				type="string"  	required="false" default="utf-8" hint="CF File CharSet Encoding to use.">
		<cfargument name="CheckCharSetFlag" 	type="boolean" required="false" default="false" hint="Check the charset.">
		<!--- ************************************************************* --->
		<!--- Verify File Encoding to use --->
		<cfif arguments.CheckCharSetFlag><cfset arguments.charset = checkCharSet(arguments.CharSet)></cfif>
		<cffile action="append" file="#arguments.FileToSave#" output="#arguments.FileContents#" charset="#arguments.charset#">
	</cffunction>

	<!--- ************************************************************* --->
	
	<!--- sendFile --->
	<cffunction name="sendFile" output="false" access="public" returntype="void" hint="Send a file to the browser">
		<!--- ************************************************************* --->
		<cfargument name="file"	 				type="any"  	required="false" 	default="" hint="The absolute path to the file or a binary file">
		<cfargument name="name" 				type="string"  	required="false" 	default="" hint="The name to send the file to the browser. If not sent in, it will use the name of the file or a UUID for a binary file"/>
		<cfargument name="mimeType" 			type="string"  	required="false" 	default="" hint="A valid mime type to use. If not sent in, we will try to use a default one according to file extension"/>
		<cfargument name="disposition"  		type="string" 	required="false" 	default="attachment" hint="The browser content disposition (attachment/inline)"/>
		<cfargument name="abortAtEnd" 			type="boolean" 	required="false" 	default="false" hint="Do an abort after content sending"/>
		<cfargument name="extension" 			type="string" 	required="false" 	default="" hint="Only used if file is binary. e.g. jpg or gif"/>
		
		<!--- ************************************************************* --->

		<!--- Binary File? --->
		<cfif isBinary(arguments.file)>

			<!--- Create unique ID? --->
			<cfif len(trim(arguments.name)) eq 0>
				<cfset arguments.name = CreateUUID()>
			</cfif>
		
			<!--- No Extension in arguments? --->
			<cfif TRIM(arguments.extension) eq ''>
				<cfthrow message="Extension for binary file missing" detail="Please provide the extension argument when using a binary file" type="Utilities.ArgumentMissingException">
			</cfif>
			
		<cfelseif fileExists(arguments.file)>
		<!--- File with absolute path --->
			
			<!--- File name? --->
			<cfif len(trim(arguments.name)) eq 0>
				<cfset arguments.name = ripExtension(getFileFromPath(arguments.file))>
			</cfif>
			
			<!--- Set extension --->
			<cfset arguments.extension = listLast(arguments.file,".")>
		
		<cfelse>
			<!--- No binary file and no file found using absolute path --->
			<cfthrow message="File not found" detail="The file '#arguments.file#' cannot be located. Argument FILE requires an absolute file path or a binary file." type="Utilities.FileNotFoundException">
		</cfif>
		
		<!--- Lookup mime type for Extension? --->
		<cfif len(trim(arguments.mimetype)) eq 0>
			<cfset arguments.mimetype = getFileMimeType(extension)>
		</cfif>
		
		<!--- Set content header --->
		<cfheader name="content-disposition" value='#arguments.disposition#; filename="#arguments.name#.#extension#"'>
		<!--- Send file --->
		<cfif isBinary(arguments.file)>
			<cfcontent type="#arguments.mimetype#" variable="#arguments.file#"/>		
		<cfelse>
			<cfcontent type="#arguments.mimetype#" file="#arguments.file#">
		</cfif>
		
		<!--- Abort further processing? --->
		<cfif arguments.abortAtEnd><cfabort></cfif>
	</cffunction>

	<cffunction name="getFileMimeType" output="false" access="public" returntype="string" hint="Get's the file mime type for a given file extension">
		<cfargument name="extension" type="string" required="true" hint="e.g. jpg or gif" />
		
		<cfset var fileMimeType = ''>
		
		<cfswitch expression="#LCASE(arguments.extension)#">
			<cfcase value="txt,js,css,cfm,cfc,html,htm,jsp">
				<cfset fileMimeType = 'text/plain'>
			</cfcase>
			<cfcase value="gif">
				<cfset fileMimeType = 'image/gif'>
			</cfcase>
			<cfcase value="jpg">
				<cfset fileMimeType = 'image/jpg'>
			</cfcase>
			<cfcase value="png">
				<cfset fileMimeType = 'image/png'>
			</cfcase>
			<cfcase value="wav">
				<cfset fileMimeType = 'audio/wav'>
			</cfcase>
			<cfcase value="mp3">
				<cfset fileMimeType = 'audio/mpeg3'>
			</cfcase>
			<cfcase value="pdf">
				<cfset fileMimeType = 'application/pdf'>
			</cfcase>
			<cfcase value="zip">
				<cfset fileMimeType = 'application/zip'>
			</cfcase>
			<cfcase value="ppt">
				<cfset fileMimeType = 'application/vnd.ms-powerpoint'>
			</cfcase>
			<cfcase value="doc">
				<cfset fileMimeType = 'application/msword'>
			</cfcase>
			<cfcase value="xls">
				<cfset fileMimeType = 'application/vnd.ms-excel'>
			</cfcase>
			<cfdefaultcase>
				<cfset fileMimeType = 'application/octet-stream'>
			</cfdefaultcase>
		</cfswitch>
		 <!--- More mimeTypes: http://www.iana.org/assignments/media-types/application/ --->
		 
		 <cfreturn fileMimeType>
	</cffunction>

<!------------------------------------------- FILE/DIRECTORY SPECIFIC METHODS ------------------------------------------->

	<!--- ************************************************************* --->

	<cffunction name="FileLastModified" access="public" returntype="string" output="false" hint="Get the last modified date of a file">
		<!--- ************************************************************* --->
		<cfargument name="filename" type="string" required="yes">
		<!--- ************************************************************* --->
		<cfscript>
		var objFile =  createObject("java","java.io.File").init(JavaCast("string",arguments.filename));
		// Calculate adjustments fot timezone and daylightsavindtime
		var Offset = ((GetTimeZoneInfo().utcHourOffset)+1)*-3600;
		// Date is returned as number of seconds since 1-1-1970
		return DateAdd('s', (Round(objFile.lastModified()/1000))+Offset, CreateDateTime(1970, 1, 1, 0, 0, 0));
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="FileSize" access="public" returntype="string" output="false" hint="Get the filesize of a file.">
		<!--- ************************************************************* --->
		<cfargument name="filename"   type="string" required="yes">
		<cfargument name="sizeFormat" type="string" required="no" default="bytes"
					hint="Available formats: [bytes][kbytes][mbytes][gbytes]">
		<!--- ************************************************************* --->
		<cfscript>
		var objFile =  createObject("java","java.io.File");
		objFile.init(JavaCast("string", filename));
		if ( arguments.sizeFormat eq "bytes" )
			return objFile.length();
		if ( arguments.sizeFormat eq "kbytes" )
			return (objFile.length()/1024);
		if ( arguments.sizeFormat eq "mbytes" )
			return (objFile.length()/(1048576));
		if ( arguments.sizeFormat eq "gbytes" )
			return (objFile.length()/1073741824);
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="removeFile" access="public" hint="Remove a file using java.io.File" returntype="boolean" output="false">
		<!--- ************************************************************* --->
		<cfargument name="filename"	 		type="string"  required="yes" 	 hint="The absolute path to the file.">
		<!--- ************************************************************* --->
		<cfscript>
		var fileObj = createObject("java","java.io.File").init(JavaCast("string",arguments.filename));
		return fileObj.delete();
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="createFile" access="public" hint="Create a new empty fileusing java.io.File." returntype="void" output="false">
		<!--- ************************************************************* --->
		<cfargument name="filename"	 		type="String"  required="yes" 	 hint="The absolute path of the file to create.">
		<!--- ************************************************************* --->
		<cfscript>
		var fileObj = createObject("java","java.io.File").init(JavaCast("string",arguments.filename));
		fileObj.createNewFile();
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="FileCanWrite" access="public" hint="Check wether you can write to a file" returntype="boolean" output="false">
		<!--- ************************************************************* --->
		<cfargument name="Filename"	 type="String"  required="yes" 	 hint="The absolute path of the file to check.">
		<!--- ************************************************************* --->
		<cfscript>
		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.Filename));
		return FileObj.canWrite();
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="FileCanRead" access="public" hint="Check wether you can read a file" returntype="boolean" output="false">
		<!--- ************************************************************* --->
		<cfargument name="Filename"	 type="String"  required="yes" 	 hint="The absolute path of the file to check.">
		<!--- ************************************************************* --->
		<cfscript>
		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.Filename));
		return FileObj.canRead();
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="isFile" access="public" hint="Checks whether the filename argument is a file or not." returntype="boolean" output="false">
		<!--- ************************************************************* --->
		<cfargument name="Filename"	 type="String"  required="yes" 	 hint="The absolute path of the file to check.">
		<!--- ************************************************************* --->
		<cfscript>
		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.Filename));
		return FileObj.isFile();
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="isDirectory" access="public" hint="Check wether the filename argument is a directory or not" returntype="boolean" output="false">
		<!--- ************************************************************* --->
		<cfargument name="Filename"	 type="String"  required="yes" 	 hint="The absolute path of the file to check.">
		<!--- ************************************************************* --->
		<cfscript>
		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.Filename));
		return FileObj.isDirectory();
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="getAbsolutePath" access="public" output="false" returntype="string" hint="Turn any system path, either relative or absolute, into a fully qualified one">
		<!--- ************************************************************* --->
		<cfargument name="path" type="string" required="true" hint="Abstract pathname">
		<!--- ************************************************************* --->
		<cfscript>
		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.path));
		if(FileObj.isAbsolute()){
			return arguments.path;
		}
		else{
			return ExpandPath(arguments.path);
		}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="checkCharSet" access="public" output="false" returntype="string" hint="Check a charset with valid CF char sets, if invalid, it returns the framework's default character set">
		<!--- ************************************************************* --->
		<cfargument name="charset" type="string" required="true" hint="Charset to check">
		<!--- ************************************************************* --->
		<cfscript>
		if ( listFindNoCase(getController().getSetting("AvailableCFCharacterSets",1),lcase(arguments.charset)) )
			return getController().getSetting("DefaultFileCharacterSet",1);
		else
			return arguments.charset;
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->

	<cffunction name="ripExtension" access="public" returntype="string" output="false" hint="Rip the extension of a filename.">
		<cfargument name="filename" type="string" required="true">
		<cfreturn reReplace(arguments.filename,"\.[^.]*$","")>
	</cffunction>

	<!--- ************************************************************* --->


</cfcomponent>