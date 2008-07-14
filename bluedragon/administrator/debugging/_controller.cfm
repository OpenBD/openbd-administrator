<cfsilent>
	<cfparam name="args.action" type="string" default="" />
	
	<!--- stick everything in form and url into a struct for easy reference --->
	<cfset args = structNew() />
	
	<cfloop collection="#url#" item="urlKey">
		<cfset args[urlKey] = url[urlKey] />
	</cfloop>
	
	<cfloop collection="#form#" item="formKey">
		<cfset args[formKey] = form[formKey] />
	</cfloop>
	
	<!--- clear out any lingering session stuff --->
	<cfscript>
		structDelete(session, "message", false);
		structDelete(session, "errorFields", false);
	</cfscript>
	
	<cfswitch expression="#args.action#">
		<!--- DEBUG SETTINGS --->
		<cfcase value="processDebugSettingsForm">
			<cfif not structKeyExists(args, "debug")>
				<cfset args.debug = false />
			</cfif>
			
			<cfif not structKeyExists(args, "runtimelogging")>
				<cfset args.runtimelogging = false />
			</cfif>
			
			<cfif not structKeyExists(args, "enabled")>
				<cfset args.enabled = false />
			</cfif>
			
			<cfif not structKeyExists(args, "assert")>
				<cfset args.assert = false />
			</cfif>
			
			<cftry>
				<cfset Application.debugging.saveDebugSettings(args.debug, args.runtimelogging, 
																args.enabled, args.assert) />
				<cfcatch type="bluedragon.adminapi.debugging">
					<cfset seession.message = CFCATCH.Message />
					<cflocation url="index.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The debug settings were saved successfully." />
			<cflocation url="index.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="processDebugOutputForm">
			<cfset errorFields = arrayNew(1) />
			
			<cfif find(".", args.highlight) neq 0 or not isNumeric(args.highlight)>
				<cfset arrayAppend(errorFields, "highlight") />
				<cflocation url="index.cfm" addtoken="false" />
			</cfif>
			
			<cfif not structKeyExists(args, "executiontimes")>
				<cfset args.executiontimes = false />
			</cfif>
			
			<cfif not structKeyExists(args, "database")>
				<cfset args.database = false />
			</cfif>
			
			<cfif not structKeyExists(args, "exceptions")>
				<cfset args.exceptions = false />
			</cfif>
			
			<cfif not structKeyExists(args, "tracepoints")>
				<cfset args.tracepoints = false />
			</cfif>
			
			<cfif not structKeyExists(args, "timer")>
				<cfset args.timer = false />
			</cfif>
			
			<cfif not structKeyExists(args, "variables")>
				<cfset args.variables = false />
			</cfif>
			
			<cftry>
				<cfset Application.debugging.saveDebugOutputSettings(args.executiontimes, args.highlight, 
																		args.database, args.exceptions, 
																		args.tracepoints, args.timer, 
																		args.variables) />
				<cfcatch type="bluedragon.adminapi.debugging">
					<cfset seession.message = CFCATCH.Message />
					<cflocation url="index.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The debug output settings were saved successfully." />
			<cflocation url="index.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="processDebugVariablesForm">
			<cfif not structKeyExists(args, "local")>
				<cfset args.local = false />
			</cfif>
			
			<cfif not structKeyExists(args, "url")>
				<cfset args.url = false />
			</cfif>
			
			<cfif not structKeyExists(args, "session")>
				<cfset args.session = false />
			</cfif>
			
			<cfif not structKeyExists(args, "variables")>
				<cfset args.variables = false />
			</cfif>
			
			<cfif not structKeyExists(args, "form")>
				<cfset args.form = false />
			</cfif>
			
			<cfif not structKeyExists(args, "client")>
				<cfset args.client = false />
			</cfif>
			
			<cfif not structKeyExists(args, "request")>
				<cfset args.request = false />
			</cfif>
			
			<cfif not structKeyExists(args, "cookie")>
				<cfset args.cookie = false />
			</cfif>
			
			<cfif not structKeyExists(args, "application")>
				<cfset args.application = false />
			</cfif>
			
			<cfif not structKeyExists(args, "cgi")>
				<cfset args.cgi = false />
			</cfif>
			
			<cfif not structKeyExists(args, "cffile")>
				<cfset args.cffile = false />
			</cfif>
			
			<cfif not structKeyExists(args, "server")>
				<cfset args.server = false />
			</cfif>
			
			<cftry>
				<cfset Application.debugging.saveDebugVariablesSettings(args.local, args.url, args.session, 
																		args.variables, args.form, args.client, 
																		args.request, args.cookie, args.application, 
																		args.cgi, args.cffile, args.server) />
				<cfcatch type="bluedragon.adminapi.debugging">
					<cfset seession.message = CFCATCH.Message />
					<cflocation url="index.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The debug variables settings were saved successfully." />
			<cflocation url="index.cfm" addtoken="false" />
		</cfcase>
		
		<!--- DEBUG IPS --->
		<cfcase value="addLocalIP">
			<cftry>
				<cfset Application.debugging.addLocalIPAddress() />
				<cfcatch type="bluedragon.adminapi.debugging">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="ipaddresses.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cflocation url="ipaddresses.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="addIPAddress">
			<cfset errorFields = arrayNew(1) />
			
			<cfif REFindNoCase("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})$", args.ipaddress) eq 0>
				<cfset arrayAppend(errorFields, "ipaddress") />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="ipaddresses.cfm" addtoken="false" />
			</cfif>
			
			<cftry>
				<cfset Application.debugging.addDebugIPAddresses(args.ipaddress)>
				<cfcatch type="bluedragon.adminapi.debugging">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="ipaddresses.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cflocation url="ipaddresses.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="removeIPAddresses">
			<cfset errorFields = arrayNew(1) />
			
			<cfif trim(args.ipaddresses) is "">
				<cfset arrayAppend(errorFields, "ipaddresses") />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="ipaddresses.cfm" addtoken="false" />
			</cfif>
			
			<cftry>
				<cfset Application.debugging.removeDebugIPAddresses(args.ipaddresses)>
				<cfcatch type="bluedragon.adminapi.debugging">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="ipaddresses.cfm" addtoken="false" />
				</cfcatch>
			</cftry>

			<cflocation url="ipaddresses.cfm" addtoken="false" />
		</cfcase>
		
		<!--- DEFAULT CASE --->
		<cfdefaultcase>
			<cfset session.message = "Invalid action" />
			<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
		</cfdefaultcase>
	</cfswitch>
</cfsilent>