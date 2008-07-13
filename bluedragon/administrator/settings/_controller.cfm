<cfsilent>
	<cfparam name="args.action" type="string" default="" />
	
	<!--- clear out old session stuff --->
	<cfset structDelete(session, "errorFields", false) />
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "mapping", false) />
	
	<!--- stick everything in form and url into a struct for easy reference --->
	<cfset args = structNew() />
	
	<cfloop collection="#url#" item="urlKey">
		<cfset args[urlKey] = url[urlKey] />
	</cfloop>
	
	<cfloop collection="#form#" item="formKey">
		<cfset args[formKey] = form[formKey] />
	</cfloop>
	
	<cfswitch expression="#args.action#">
		<!--- SERVER SETTINGS --->
		<cfcase value="processServerSettingsForm">
			<cfset errorFields = arrayNew(1) />
			
			<cfif find(".", args.buffersize) neq 0 or not isNumeric(args.buffersize)>
				<cfset arrayAppend(errorFields, "buffersize") />
			</cfif>
			
			<cfif trim(args.defaultcharset) is "">
				<cfset arrayAppend(errorFields, "defaultcharset") />
			</cfif>
			
			<cfif trim(args.scriptsrc) is "">
				<cfset arrayAppend(errorFields, "scriptsrc") />
			</cfif>
			
			<cfif trim(args.tempdirectory) is "">
				<cfset arrayAppend(errorFields, "tempdirectory") />
			</cfif>
			
			<cfif trim(args.componentcfc) is "">
				<cfset arrayAppend(errorFields, "componentcfc") />
			</cfif>
			
			<cfif arrayLen(errorFields) neq 0>
				<!--- TODO: add nicer functionality so the entire form gets repopulated on error;
						maybe should repopulate things like tempdirectory and componentcfc with defaults --->
				<cfset session.errorFields = errorFields />
				<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.serverSettings.saveServerSettings(args.buffersize, args.whitespacecomp, args.errorhandler, 
																			args.missingtemplatehandler, args.defaultcharset, 
																			args.scriptprotect, args.scriptsrc, args.tempdirectory, 
																			args.assert, args.componentcfc) />
					<cfcatch type="bluedragon.adminapi.serversettings">
						<cfset session.message = CFCATCH.Message />
						<cflocation url="index.cfm" addtoken="false" />
					</cfcatch>
				</cftry>

				<cfset session.message = "The server settings were saved successfully." />
				<cflocation url="index.cfm" addtoken="false" />
			</cfif>
		</cfcase>
		
		<cfcase value="revertToPreviousSettings">
			<cftry>
				<cfset Application.serverSettings.revertToPreviousSettings() />
				<cfcatch type="bluedragon.adminapi.serversettings">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="index.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The previous server settings have been restored." />
			<cflocation url="index.cfm" addtoken="false" />
		</cfcase>
		
		<!--- MAPPINGS --->
		<cfcase value="editMapping">
			<cfset session.mapping = Application.mapping.getMappings(args.name) />
			<cflocation url="mappings.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="processMappingForm">
			<cfset errorFields = arrayNew(1) />
			
			<cfif trim(args.name) is "">
				<cfset arrayAppend(errorFields, "name") />
			</cfif>
			
			<cfif trim(args.directory) is "">
				<cfset arrayAppend(errorFields, "directory") />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<!--- TODO: add nicer functionality so the entire form gets repopulated on error;
						maybe should repopulate things like tempdirectory and componentcfc with defaults --->
				<cfset session.errorFields = errorFields />
				<cflocation url="mappings.cfm" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.mapping.saveMapping(args.name, args.directory, 
															args.mappingAction, args.existingMappingName) />
					<cfcatch type="bluedragon.adminapi.mapping">
						<cfset session.message = CFCATCH.Message />
						<cflocation url="mappings.cfm" addtoken="false" />
					</cfcatch>
				</cftry>
				
				<cfset session.message = "The mapping was #args.mappingAction#d successfully." />
				<cflocation url="mappings.cfm" addtoken="false" />
			</cfif>
		</cfcase>
		
		<cfcase value="verifyMapping">
			<cftry>
				<cfset Application.mapping.verifyMapping(args.name) />
				<cfcatch type="bluedragon.adminapi.mapping">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="mappings.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The mapping verified successfully." />
			<cflocation url="mappings.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="deleteMapping">
			<cftry>
				<cfset Application.mapping.deleteMapping(args.name) />
				<cfcatch type="bluedragon.adminapi.mapping">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="mappings.cfm" addtoken="false" />
				</cfcatch>
			</cftry>

			<cfset session.message =  "The mapping was deleted successfully."/>
			<cflocation url="mappings.cfm" addtoken="false" />
		</cfcase>
		
		<!--- CACHING --->
		<cfcase value="processFileCacheForm">
			<cfset errorFields = arrayNew(1) />
			
			<cfif find(".", args.maxfiles) neq 0 or not isNumeric(args.maxfiles)>
				<cfset arrayAppend(errorFields, "maxfiles") />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<!--- TODO: add nicer functionality so the entire form gets repopulated on error;
						maybe should repopulate things like tempdirectory and componentcfc with defaults --->
				<cfset session.errorFields = errorFields />
				<cflocation url="caching.cfm" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.caching.saveFileCacheSettings(args.maxfiles, args.trustcache) />
					<cfcatch type="bluedragon.adminapi.caching">
						<cfset session.message = CFCATCH.Message />
						<cflocation url="caching.cfm" addtoken="false" />
					</cfcatch>
				</cftry>
				
				<cfset session.message = "The file cache settings were updated successfully." />
				<cflocation url="caching.cfm" addtoken="false" />
			</cfif>
		</cfcase>
		
		<cfcase value="processQueryCacheForm">
			<cfset errorFields = arrayNew(1) />
			
			<cfif find(".", args.cachecount) neq 0 or not isNumeric(args.cachecount)>
				<cfset arrayAppend(errorFields, "cachecount") />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<!--- TODO: add nicer functionality so the entire form gets repopulated on error;
						maybe should repopulate things like tempdirectory and componentcfc with defaults --->
				<cfset session.errorFields = errorFields />
				<cflocation url="caching.cfm" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.caching.saveQueryCacheSettings(args.cachecount) />
					<cfcatch type="bluedragon.adminapi.caching">
						<cfset session.message = CFCATCH.Message />
						<cflocation url="caching.cfm" addtoken="false" />
					</cfcatch>
				</cftry>
				
				<cfset session.message = "The query cache settings were updated successfully." />
				<cflocation url="caching.cfm" addtoken="false" />
			</cfif>
		</cfcase>
		
		<!--- DEFAULT CASE --->
		<cfdefaultcase>
			<cfset session.message = "Invalid action" />
			<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
		</cfdefaultcase>
	</cfswitch>
</cfsilent>