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
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif trim(args.directory) is "">
				<cfset errorFields[errorFieldsIndex][1] = "directory") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Custom Tag Path cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
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
		
		<!--- CFX TAGS --->
		<cfcase value="editJavaCFXTag">
			<cftry>
				<cfset session.cfxTag = Application.extensions.getJavaCFX(args.cfxTag).get(0) />
				<cfcatch type="bluedragon.adminapi.extensions">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="cfxtags.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cflocation url="javacfx.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="processJavaCFXForm">
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif trim(args.name) is "">
				<cfset errorFields[errorFieldsIndex][1] = "name") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Tag Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif lCase(left(args.name, 4)) is not "cfx_">
				<cfset errorFields[errorFieldsIndex][1] = "name") />
				<cfset errorFields[errorFieldsIndex][2] = "The Tag Name must begin with cfx_" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif REFindNoCase("^([a-zA-Z0-9_-]+)$", args.name) eq 0>
				<cfset errorFields[errorFieldsIndex][1] = "name") />
				<cfset errorFields[errorFieldsIndex][2] = "The Tag Name must not include special characters" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.class) is "">
				<cfset errorFields[errorFieldsIndex][1] = "class") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Class Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="javacfx.cfm" addtoken="false" />
			</cfif>
			
			<cftry>
				<cfset Application.extensions.setJavaCFX(args.name, args.class, 
															args.description, args.name, 
															args.existingCFXName, args.cfxAction) />
				<cfcatch type="bluedragon.adminapi.extensions">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="javacfx.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The Java CFX tag was saved successfully." />
			<cflocation url="cfxtags.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="deleteJavaCFXTag">
			<cftry>
				<cfset Application.extensions.deleteJavaCFX(args.name) />
				<cfcatch type="bluedragon.adminapi.extensions">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="cfxtags.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The CFX tag was deleted successfully." />
			<cflocation url="cfxtags.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="editCPPCFXTag">
			<cftry>
				<cfset session.cfxTag = Application.extensions.getCPPCFX(args.cfxTag).get(0) />
				<cfcatch type="bluedragon.adminapi.extensions">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="cfxtags.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cflocation url="cppcfx.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="processCPPCFXForm">
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif trim(args.name) is "">
				<cfset errorFields[errorFieldsIndex][1] = "name") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Tag Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif lCase(left(args.name, 4)) is not "cfx_">
				<cfset errorFields[errorFieldsIndex][1] = "name") />
				<cfset errorFields[errorFieldsIndex][2] = "The Tag Name must begin with cfx_" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif REFindNoCase("^([a-zA-Z0-9_-]+)$", args.name) eq 0>
				<cfset errorFields[errorFieldsIndex][1] = "name") />
				<cfset errorFields[errorFieldsIndex][2] = "The Tag Name must not include special characters" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.module) is "">
				<cfset errorFields[errorFieldsIndex][1] = "module") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Module Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.function) is "">
				<cfset errorFields[errorFieldsIndex][1] = "function") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Function Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="cppcfx.cfm" addtoken="false" />
			</cfif>
			
			<cftry>
				<cfset Application.extensions.setCPPCFX(args.name, args.module, 
															args.description, args.name, 
															args.keeploaded, args.function, 
															args.existingCFXName, args.cfxAction) />
				<cfcatch type="bluedragon.adminapi.extensions">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="cppcfx.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The C++ CFX tag was saved successfully." />
			<cflocation url="cfxtags.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="deleteCPPCFXTag">
			<cftry>
				<cfset Application.extensions.deleteCPPCFX(args.name) />
				<cfcatch type="bluedragon.adminapi.extensions">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="cfxtags.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The CFX tag was deleted successfully." />
			<cflocation url="cfxtags.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="verifyCFXTag">
			<cftry>
				<cfset Application.extensions.verifyCFXTag(args.name, args.type) />
				<cfcatch type="bluedragon.adminapi.extensions">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="cfxtags.cfm" addtoken="false" />
				</cfcatch>
			</cftry>

			<cfset session.message = "The CFX tag was verified successfully." />
			<cflocation url="cfxtags.cfm" addtoken="false" />
		</cfcase>
		
		<!--- DEFAULT CASE --->
		<cfdefaultcase>
			<cfset session.message = "Invalid action" />
			<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
		</cfdefaultcase>
	</cfswitch>
</cfsilent>