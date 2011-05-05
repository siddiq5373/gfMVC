<cfswitch expression="#thisTAG.executionmode#">
	<cfcase value="start">
		<cfparam name="attributes.fieldName" default="ObjectIDs" />
		<cfparam name="attributes.keyName" default="ServiceID" />
		<cfparam name="attributes.value" />
		<cfparam name="attributes.relationship" default="many2many" />
		<cfparam name="attributes.event" default="ServiceList" />
		<cfparam name="attributes.rc" default="#caller.rc#" />
		<cfparam name="attributes.sessionObject" default="#caller.sessionObject#" />
		<cfparam name="attributes.AppKey" default="#caller.AppKey#" />
		<cfset data = caller.runEvent('general.#attributes.event#') />
	</cfcase>
	
	<cfcase value="end">
		<cfif IsNUll(attributes.value)>
			<cfset attributes.value = [] />
		</cfif>
		<!---<cfset qSelectedValues = EntityToQuery(attributes.value) />
		<cfdump var="#qSelectedValues#"><cfabort>
		<cfdump var="#ValueList(qSelectedValues, attributes.keyName)#">--->
		<cfoutput>
		<cfif IsArray(data.ListingData)>
			<cfif attributes.relationship EQ "many2one">
				<select name="#attributes.fieldName#" id="#attributes.fieldName#">
					<cfloop array="#data.ListingData#" index="object">
						<option value="#object.getKeyValue()#" <cfif IsObject(attributes.value) and attributes.value.getKeyValue() EQ object.getKeyValue()> selected="selected"</cfif> /> #object.getName()#</option>
					</cfloop>
				</select>
			<cfelse>
				<label for="#attributes.fieldName#">
				<cfloop array="#data.ListingData#" index="object">
					<input type="checkbox" id="#attributes.fieldName##object.getKeyValue()#" name="#attributes.fieldName#"  value="#object.getKeyValue()#" <cfif ArrayFind(attributes.value,object)> checked="checked"</cfif> /> #object.getName()#
				</cfloop>
				</label>
			</cfif>
        </cfif>	        
		</cfoutput>
	</cfcase>
</cfswitch>