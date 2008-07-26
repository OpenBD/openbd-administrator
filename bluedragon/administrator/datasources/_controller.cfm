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
		structDelete(session, "datasource", false);
		structDelete(session, "errorFields", false);
	</cfscript>
	
	<cfswitch expression="#args.action#">
		<cfcase value="addDatasource">
			<cfparam name="args.dsn" type="string" default="" />

			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif trim(args.dsn) is "">
				<cfset errorFields[errorFieldsIndex][1] = "dsn") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Datasource Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<!--- check to see if the datasource already exists --->
			<cfif Application.datasource.datasourceExists(args.dsn)>
				<cfset errorFields[errorFieldsIndex][1] = "dsn") />
				<cfset errorFields[errorFieldsIndex][2] = "A datasource with that name already exists" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="index.cfm" addtoken="false" />
			<cfelse>
				<!--- get the defaults for the db driver --->
				<cfset dbDriverDefaults = Application.datasource.getDriverInfo(datasourceconfigpage = args.datasourceconfigpage) />
				
				<!--- set default form values so we can use the same form for adds and edits  --->
				<cfscript>
					dsinfo = structNew();
					dsinfo.name = args.dsn;
					dsinfo.databasename = "";
					dsinfo.server = "";
					dsinfo.port = dbDriverDefaults.defaultport;
					dsinfo.username = "";
					dsinfo.password = "";
					dsinfo.description = "";
					dsinfo.initstring = "";
					dsinfo.sqlselect = true;
					dsinfo.sqlinsert = true;
					dsinfo.sqlupdate = true;
					dsinfo.sqldelete = true;
					dsinfo.sqlstoredprocedures = true;
					dsinfo.perrequestconnections = false;
					dsinfo.maxconnections = 24;
					dsinfo.connectiontimeout = 120;
					dsinfo.logintimeout = 120;
					dsinfo.connectionretries = 0;
					dsinfo.drivername = dbDriverDefaults.drivername;
					dsinfo.driverdescription = dbDriverDefaults.driverdescription;
					
					datasource = arrayNew(1);
					datasource[1] = StructCopy(dsinfo);
					
					session.datasource = datasource;
				</cfscript>
				
				<cflocation url="#args.datasourceconfigpage#" addtoken="false" />
			</cfif>
		</cfcase>
		
		<cfcase value="editDatasource">
			<cfparam name="args.dsn" type="string" default="" />
			
			<cfif trim(args.dsn) is "">
				<cfset session.message = "Please select a valid datasource to edit" />
				<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
			<cfelse>
				<cfset session.datasource = Application.datasource.getDatasources(args.dsn) />
				<cfset dbDriverDefaults = Application.datasource.getDriverInfo(drivername = session.datasource[1].drivername) />
				<cflocation url="#dbDriverDefaults.datasourceconfigpage#?action=update" addtoken="false" />
			</cfif>
		</cfcase>

		<cfcase value="processDatasourceForm">
			<cfparam name="args.name" type="string" default="" />
			<cfparam name="args.databasename" type="string" default="" />
			<cfparam name="args.server" type="string" default="" />
			<cfparam name="args.port" type="string" default="" />
			<cfparam name="args.sqlselect" type="boolean" default="false" />
			<cfparam name="args.sqlinsert" type="boolean" default="false" />
			<cfparam name="args.sqlupdate" type="boolean" default="false" />
			<cfparam name="args.sqldelete" type="boolean" default="false" />
			<cfparam name="args.sqlstoredprocedures" type="boolean" default="false" />
			<cfparam name="args.perrequestconnections" type="boolean" default="false" />
			<cfparam name="args.datasourceAction" type="string" default="create" />
			
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<!--- validate the form data --->
			<cfif trim(args.name) is "">
				<cfset errorFields[errorFieldsIndex][1] = "name") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Datasource Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.databasename) is "">
				<cfset errorFields[errorFieldsIndex][1] = "databasename") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Database Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.server) is "">
				<cfset errorFields[errorFieldsIndex][1] = "server") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Database Server cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.port) is "" or not isNumeric(trim(form.port))>
				<cfset errorFields[errorFieldsIndex][1] = "port") />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Server Port cannot be blank and must be numeric" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) neq 0>
				<!--- TODO: add nicer functionality so the entire form gets repopulated on error --->
				<cfset session.errorFields = errorFields />
				<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
			<cfelse>
				<cfset structDelete(session, "message", false) />
				<cfset structDelete(session, "errorFields", false)>
				<!--- No errors on the required fields so create/modify the datasource.
						If it's a create, need to check to see if the datasource already exists. --->
				<cfif args.datasourceAction is "create" and Application.datasource.datasourceExists(args.name)>
					<cfset session.message = "A datasource with that name already exists." />
					<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
				<cfelse>
					<cftry>
						<cfset Application.datasource.setDatasource(args.name, args.databasename, args.server, args.username, 
																		args.password, args.port, args.description, 
																		args.initstring, args.connectiontimeout, 
																		args.connectionretries, args.logintimeout, 
																		args.maxconnections, args.perrequestconnections, 
																		args.sqlselect, args.sqlinsert, args.sqlupdate, args.sqldelete, 
																		args.sqlstoredprocedures, args.drivername, 
																		args.datasourceAction, args.existingDatasourceName) />
						<cfcatch type="bluedragon.adminapi.datasource">
							<cfset session.message = CFCATCH.Message />
							<cflocation url="index.cfm" addtoken="false" />
						</cfcatch>
					</cftry>
					
					<cfset session.message = "The datasource was #args.datasourceAction#d successfully." />
					<cflocation url="index.cfm" addtoken="false" />
				</cfif>
			</cfif>
		</cfcase>
		
		<!--- TODO: implement verifyDatasource --->
		<cfcase value="verifyDatasource">
		</cfcase>

		<cfcase value="removeDatasource">
			<!--- make sure the datasource exists --->
			<cfif not Application.datasource.datasourceExists(args.dsn)>
				<cfset session.message = "The datasource you attempted to remove does not exist." />
				<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.datasource.deleteDatasource(args.dsn) />
					<cfcatch type="bluedragon.adminapi.datasource">
						<cfset session.message = CFCATCH.Message />
						<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
					</cfcatch>
				</cftry>
				
				<cfset session.message = "The datasource was removed successfully." />
				<cflocation url="index.cfm" addtoken="false" />
			</cfif>
		</cfcase>
		
		<cfcase value="resetDatabaseDrivers">
			<cftry>
				<cfset Application.datasource.getRegisteredDrivers(true) />
				<cfcatch type="bluedragon.adminapi.datasource">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="index.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The database drivers were reset successfully." />
			<cflocation url="index.cfm" addtoken="false" />
		</cfcase>
		
		<cfdefaultcase>
			<cfset session.message = "Invalid action" />
			<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
		</cfdefaultcase>
	</cfswitch>
</cfsilent>