<cfsilent>
	<cfparam name="form.name" type="string" default="" />
	<cfparam name="form.databasename" type="string" default="" />
	<cfparam name="form.server" type="string" default="" />
	<cfparam name="form.port" type="string" default="" />
	<cfparam name="form.sqlselect" type="boolean" default="false" />
	<cfparam name="form.sqlinsert" type="boolean" default="false" />
	<cfparam name="form.sqlupdate" type="boolean" default="false" />
	<cfparam name="form.sqldelete" type="boolean" default="false" />
	<cfparam name="form.sqlstoredprocedures" type="boolean" default="false" />
	<cfparam name="form.perrequestconnections" type="boolean" default="false" />
	<cfparam name="form.action" type="string" default="create" />
	
	<cfset errorFields = "" />
	
	<!--- validate the form data --->
	<cfif trim(form.name) is "">
		<cfset errorFields = listAppend(errorFields, "Datasource Name") />
	</cfif>
	
	<cfif trim(form.databasename) is "">
		<cfset errorFields = listAppend(errorFields, "Database Name") />
	</cfif>
	
	<cfif trim(form.server) is "">
		<cfset errorFields = listAppend(errorFields, "Database Server") />
	</cfif>
	
	<cfif trim(form.port) is "" or not isNumeric(trim(form.port))>
		<cfset errorFields = listAppend(errorFields, "Server Port") />
	</cfif>
	
	<cfif errorFields is not "">
		<!--- TODO: add nicer functionality so the entire form gets repopulated on error --->
		<cfset session.errorFields = errorFields />
		<cflocation url="#CGI.HTTP_REFERER#" />
	<cfelse>
		<cfset structDelete(session, "message", false) />
		<cfset structDelete(session, "errorFields", false)>
		<!--- No errors on the required fields so create/modify the datasource.
				If it's a create, need to check to see if the datasource already exists. --->
		<cfif form.action is "create" and Application.datasource.datasourceExists(form.name)>
			<cfset session.message = "A datasource with that name already exists." />
			<cflocation url="#CGI.HTTP_REFERER#" />
		<cfelse>
			<cftry>
				<cfset Application.datasource.saveDatasource(form.name, form.databasename, form.server, form.dbType, 
																form.username, form.password, form.port, form.description, 
																form.initstring, form.connectiontimeout, 
																form.connectionretries, form.logintimeout, 
																form.maxconnections, form.perrequestconnections, 
																form.sqlselect, form.sqlinsert, form.sqlupdate, form.sqldelete, 
																form.sqlstoredprocedures, form.drivername, form.action)>
				<cfcatch type="bluedragon.adminapi.datasource">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="#CGI.HTTP_REFERER#" />
				</cfcatch>
			</cftry>
		</cfif>
	</cfif>
</cfsilent>
