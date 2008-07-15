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
		<!--- CUSTOM TAG PATHS --->
		<cfcase value="processCustomTagPathForm">
			<cfset errorFields = arrayNew(1) />
			
			<cfif trim(args.directory) is "">
				<cfset arrayAppend(errorFields, "directory") />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="customtagpaths.cfm" addtoken="false" />
			</cfif>
			
			<cftry>
				<cfset Application.extensions.setCustomTagPath(args.directory, args.customTagPathAction) />
				<cfcatch type="bluedragon.adminapi.extensions">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="customtagpaths.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The custom tag path was #args.customTagPathAction#d successfully" />
			<cflocation url="customtagpaths.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="deleteCustomTagPath">
			<cftry>
				<cfset Application.extensions.deleteCustomTagPath(args.directory) />
				<cfcatch type="bluedragon.adminapi.extensions">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="customtagpaths.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The custom tag path was deleted successfully" />
			<cflocation url="customtagpaths.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="verifyCustomTagPath">
			<cftry>
				<cfset Application.extensions.verifyCustomTagPath(args.directory) />
				<cfcatch type="bluedragon.adminapi.extensions">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="customtagpaths.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The custom tag path was verified successfully." />
			<cflocation url="customtagpaths.cfm" addtoken="false" />
		</cfcase>
		
		<!--- DEFAULT CASE --->
		<cfdefaultcase>
			<cfset session.message = "Invalid action" />
			<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
		</cfdefaultcase>
	</cfswitch>
</cfsilent>