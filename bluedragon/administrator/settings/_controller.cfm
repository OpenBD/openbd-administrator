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
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif find(".", args.buffersize) neq 0 or not isNumeric(args.buffersize)>
				<cfset errorFields[errorFieldsIndex][1] = "buffersize" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Response Buffer Size is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.defaultcharset) is "">
				<cfset errorFields[errorFieldsIndex][1] = "defaultcharset" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Default Character Set cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.scriptsrc) is "">
				<cfset errorFields[errorFieldsIndex][1] = "scriptsrc" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Default CFFORM Script Source Location cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.tempdirectory) is "">
				<cfset errorFields[errorFieldsIndex][1] = "tempdirectory" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Temp Directory Location cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.componentcfc) is "">
				<cfset errorFields[errorFieldsIndex][1] = "componentcfc" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Base ColdFusion Component (CFC) cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) neq 0>
				<!--- TODO: add nicer functionality so the entire form gets repopulated on error;
						maybe should repopulate things like tempdirectory and componentcfc with defaults --->
				<cfset session.errorFields = errorFields />
				<cflocation url="index.cfm" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.serverSettings.setServerSettings(args.buffersize, args.whitespacecomp, args.errorhandler, 
																			args.missingtemplatehandler, args.defaultcharset, 
																			args.scriptprotect, args.scriptsrc, args.tempdirectory, 
																			args.componentcfc) />
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
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif trim(args.name) is "">
				<cfset errorFields[errorFieldsIndex][1] = "name" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Logical Path cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.directory) is "">
				<cfset errorFields[errorFieldsIndex][1] = "directory" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Directory Path cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="mappings.cfm" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.mapping.setMapping(args.name, args.directory, 
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
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif find(".", args.maxfiles) neq 0 or not isNumeric(args.maxfiles)>
				<cfset errorFields[errorFieldsIndex][1] = "maxfiles" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of File Cache Size is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="caching.cfm" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.caching.setFileCacheSettings(args.maxfiles, args.trustcache) />
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
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif find(".", args.cachecount) neq 0 or not isNumeric(args.cachecount)>
				<cfset errorFields[errorFieldsIndex][1] = "cachecount" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Query Cache Size is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="caching.cfm" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.caching.setQueryCacheSettings(args.cachecount) />
					<cfcatch type="bluedragon.adminapi.caching">
						<cfset session.message = CFCATCH.Message />
						<cflocation url="caching.cfm" addtoken="false" />
					</cfcatch>
				</cftry>
				
				<cfset session.message = "The query cache settings were updated successfully." />
				<cflocation url="caching.cfm" addtoken="false" />
			</cfif>
		</cfcase>
		
		<!--- VARIABLES --->
		<cfcase value="processVariableForm">
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<!--- make sure all the numeric values are numeric --->
			<cfif find(".", args.appTimeoutDays) neq 0 or not isNumeric(args.appTimeoutDays)>
				<cfset errorFields[errorFieldsIndex][1] = "appTimeoutDays" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Default Application Timeout Days is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.appTimeoutHours) neq 0 or not isNumeric(args.appTimeoutHours)>
				<cfset errorFields[errorFieldsIndex][1] = "appTimeoutHours" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Default Application Timeout Hours is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.appTimeoutMinutes) neq 0 or not isNumeric(args.appTimeoutMinutes)>
				<cfset errorFields[errorFieldsIndex][1] = "appTimeoutMinutes" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Default Application Timeout Minutes is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.appTimeoutSeconds) neq 0 or not isNumeric(args.appTimeoutSeconds)>
				<cfset errorFields[errorFieldsIndex][1] = "appTimeoutSeconds" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Default Application Timeout Seconds is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.sessionTimeoutDays) neq 0 or not isNumeric(args.sessionTimeoutDays)>
				<cfset errorFields[errorFieldsIndex][1] = "sessionTimeoutDays" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Default Session Timeout Days is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.sessionTimeoutHours) neq 0 or not isNumeric(args.sessionTimeoutHours)>
				<cfset errorFields[errorFieldsIndex][1] = "sessionTimeoutHours" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Default Session Timeout Hours is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.sessionTimeoutMinutes) neq 0 or not isNumeric(args.sessionTimeoutMinutes)>
				<cfset errorFields[errorFieldsIndex][1] = "sessionTimeoutMinutes" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Default Session Timeout Minutes is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.sessionTimeoutSeconds) neq 0 or not isNumeric(args.sessionTimeoutSeconds)>
				<cfset errorFields[errorFieldsIndex][1] = "sessionTimeoutSeconds" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Default Session Timeout Seconds is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.clientexpiry) neq 0 or not isNumeric(args.clientexpiry)>
				<cfset errorFields[errorFieldsIndex][1] = "clientexpiry" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Client Variable Expiration Days is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.cfchartcachesize) neq 0 or not isNumeric(args.cfchartcachesize)>
				<cfset errorFields[errorFieldsIndex][1] = "cfchartcachesize" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of CFCHART Cache Size is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="variables.cfm" addtoken="false" />
			</cfif>
			
			<!--- handle checkboxes that may not come through --->
			<cfif not structKeyExists(args, "clientpurgeenabled")>
				<cfset args.clientpurgeenabled = false />
			</cfif>
			
			<cfif not structKeyExists(args, "cf5clientdata")>
				<cfset args.cf5clientdata = false />
			</cfif>
			
			<cftry>
				<cfset Application.variableSettings.setVariableSettings(args.j2eesession, args.appTimeoutDays, 
																			args.appTimeoutHours, args.appTimeoutMinutes, 
																			args.appTimeoutSeconds, args.sessionTimeoutDays, 
																			args.sessionTimeoutHours, args.sessionTimeoutMinutes, 
																			args.sessionTimeoutSeconds, args.clientstorage, 
																			args.clientpurgeenabled, args.clientexpiry, 
																			args.cf5clientdata) />
				<cfcatch type="bluedragon.adminapi.variableSettings">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="variables.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cftry>
				<cfset Application.chart.setChartSettings(args.cfchartcachesize, args.cfchartstorage) />
				<cfcatch type="bluedragon.adminapi.chart">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="variables.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The variable settings were updated successfully." />
			<cflocation url="variables.cfm" addtoken="false" />
		</cfcase>
		
		<!--- MAIL --->
		<cfcase value="processMailServerForm">
			<cfparam name="args.testConnection" type="boolean" default="false" />
			<cfparam name="args.isPrimary" type="boolean" default="false" />
			
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif trim(args.smtpserver) is "">
				<cfset errorFields[errorFieldsIndex][1] = "smtpserver" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of SMTP Server cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.smtpport) neq 0 or not isNumeric(args.smtpport)>
				<cfset errorFields[errorFieldsIndex][1] = "smtpport" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of SMTP Port is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="mail.cfm" addtoken="false" />
			</cfif>
			
			<cftry>
				<cfset Application.mail.setMailServer(args.smtpserver, args.smtpport, 
														args.username, args.password, 
														args.isPrimary, args.testConnection, 
														args.existingSMTPServer, args.mailServerAction) />
				<cfcatch type="bluedragon.adminapi.mail">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="mail.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The mail server was saved successfully." />
			<cflocation url="mail.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="processMailSettingsForm">
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif find(".", args.timeout) neq 0 or not isNumeric(args.timeout)>
				<cfset errorFields[errorFieldsIndex][1] = "timeout" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Timeout is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.threads) neq 0 or not isNumeric(args.threads)>
				<cfset errorFields[errorFieldsIndex][1] = "threads" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Mail Threads is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif find(".", args.interval) neq 0 or not isNumeric(args.interval)>
				<cfset errorFields[errorFieldsIndex][1] = "interval" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Spool Interval is not numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="mail.cfm" addtoken="false" />
			</cfif>
			
			<cftry>
				<cfset Application.mail.setMailSettings(args.timeout, args.threads, args.interval, 
														args.charset) />
				<cfcatch type="bluedragon.adminapi.mail">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="mail.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The mail settings were saved successfully." />
			<cflocation url="mail.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="editMailServer">
			<cftry>
				<cfset session.mailServer = Application.mail.getMailServers(args.mailServer) />
				<cfcatch type="any">
					<cfset session.message = CFCATCH.Message />
				</cfcatch>
			</cftry>
			
			<cflocation url="mail.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="verifyMailServer">
			<cfparam name="args.mailServer" type="string" default="" />
			<cfparam name="mailServers" type="array" default="#arrayNew(1)#" />
			
			<cfset session.mailServerStatus = ArrayNew(1)>
			
			<!--- is args.mailServer is not "" then we're verifying a single mail server; otherwise verify all --->
			<cfif args.mailServer is not "">
				<cfset mailServers = Application.mail.getMailServers(args.mailServer) />
			<cfelse>
				<cfset mailServers = Application.mail.getMailServers() />
			</cfif>
			
			<cfloop index="i" from="1" to="#arrayLen(mailServers)#">
				<cfset session.mailServerStatus[i].smtpserver = mailServers[i].smtpserver />
				
				<cftry>
					<cfset mailServerString = mailServers[i].smtpserver />
					
					<cfif mailServers[i].smtpport is not "">
						<cfset mailServerString = mailServerString & ":" & mailServers[i].smtpport />
					</cfif>
					
					<cfif mailServers[i].username is not "">
						<cfset mailServerString = mailServers[i].username & ":" & mailServers[i].password & "@" & mailServerString />
					</cfif>
					
					<cfset Application.mail.verifyMailServer(mailServerString) />
					
					<cfset session.mailServerStatus[i].verified = true />
					<cfset session.mailServerStatus[i].message = "" />
					<cfcatch type="bluedragon.adminapi.mail">
						<cfset session.mailServerStatus[i].verified = false />
						<cfset session.mailServerStatus[i].message = CFCATCH.Message />
					</cfcatch>
				</cftry>
			</cfloop>
			
			<cflocation url="mail.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="removeMailServer">
			<cftry>
				<cfset Application.mail.deleteMailServer(args.mailServer) />
				<cfcatch type="bluedragon.adminapi.mail">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="mail.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The mail server was removed successfully." />
			<cflocation url="mail.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="respoolUndeliveredMail">
			<cftry>
				<cfset Application.mail.respoolUndeliveredMail() />
				<cfcatch type="bluedragon.adminapi.mail">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="mail.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The undelivered mail was respooled successfully." />
			<cflocation url="mail.cfm" addtoken="false" />
		</cfcase>
		
		<!--- FONTS --->
		<cfcase value="processFontDirForm">
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif trim(args.fontDir) is "">
				<cfset errorFields[errorFieldsIndex][1] = "fontDir" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Font Directory cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="fonts.cfm" addtoken="false" />
			</cfif>
			
			<cftry>
				<cfset Application.fonts.setFontDirectory(args.fontDir, args.fontDirAction, args.existingFontDir) />
				<cfcatch type="bluedragon.adminapi.fonts">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="fonts.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The font directory was processed successfully." />
			<cflocation url="fonts.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="verifyFontDirectory">
			<cftry>
				<cfset Application.fonts.verifyFontDirectory(args.fontDir) />
				<cfcatch type="any">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="fonts.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The font directory was verified successfully." />
			<cflocation url="fonts.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="removeFontDirectory">
			<cftry>
				<cfset Application.fonts.deleteFontDirectory(args.fontDir) />
				<cfcatch type="any">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="fonts.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The font directory was removed successfully." />
			<cflocation url="fonts.cfm" addtoken="false" />
		</cfcase>
		
		<!--- DEFAULT CASE --->
		<cfdefaultcase>
			<cfset session.message = "Invalid action" />
			<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
		</cfdefaultcase>
	</cfswitch>
</cfsilent>