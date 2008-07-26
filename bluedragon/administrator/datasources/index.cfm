<cfsilent>
	<cfparam name="datasourceRetrievalMessage" type="string" default="" />

	<cfset dbdrivers = arrayNew(1) />
	<cfset datasources = arrayNew(1) />

	<cftry>
		<cfset dbdrivers = Application.datasource.getRegisteredDrivers() />
		<cfcatch type="any">
			<cfset dbDriverRetrievalMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfset datasources = Application.datasource.getDatasources() />
		
		<!--- add the database driver description to the array of datasources --->
		<cfloop index="i" from="1" to="#arrayLen(datasources)#">
			<cfset datasources[i].driverdescription = Application.datasource.getDriverInfo(drivername = datasources[i].drivername).driverdescription />
		</cfloop>
		
		<cfcatch type="any">
			<cfset datasourceRetrievalMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
	
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validate(f) {
				var dsn = f.dsn.value;
				var dbType = f.dbType.value;
				// TODO: add a trim function here to check for dsns with only spaces
				if (f.dsn.value.length == 0) {
					alert("Please enter the datasource name");
					return false;
				} else if (f.dbType.value == "") {
					alert("Please select the database type");
					return false;
				} else {
					return true;
				}
			}
			
			function removeDatasource(dsn) {
				if(confirm("Are you sure you want to remove this datasource?")) {
					location.replace("_controller.cfm?action=removeDatasource&dsn=" + dsn);
				}
			}
			
			function resetDBDrivers() {
				if(confirm("Are you sure you want to reset the database driver list to the defaults?")) {
					location.replace("_controller.cfm?action=resetDatabaseDrivers");
				}
			}
		</script>
		
		<h3>Add Datasource</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="message">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<form name="addDatasource" action="_controller.cfm?action=addDatasource" method="post" onsubmit="javascript:return validate(this);">
		<table border="0">
			<tr>
				<td>Datasource Name</td>
				<td><input type="text" name="dsn" size="30" maxlength="50" /></td>
			</tr>
			<tr>
				<td>Database Type</td>
				<td>
					<select name="datasourceconfigpage">
						<option value="" selected="true">- select -</option>
					<cfloop index="i" from="1" to="#arrayLen(dbdrivers)#">
						<option value="#dbdrivers[i].datasourceconfigpage#">#dbdrivers[i].driverdescription#</option>
					</cfloop>
					</select>&nbsp;
					<a href="javascript:void(0);" onclick="javascript:resetDBDrivers()">Reset Database Drivers</a>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Add Datasource" /></td>
			</tr>
		</table>
		</form>
		
		<hr noshade="true" />
		<!--- TODO: put setting to auto-configure ODBC datasources here? assuming this would only be applicable to windows --->
		<h3>Datasources</h3>
		
		<cfif datasourceRetrievalMessage is not ""><p class="message">#datasourceRetrievalMessage#</p></cfif>
		
		<cfif arrayLen(datasources) eq 0>
			<p><strong><em>No dataources configured</em></strong></p>
		<cfelse>
		
		<table border="0" width="100%" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td width="100"><strong>Actions</strong></td>
				<td><strong>Datasource Name</strong></td>
				<td><strong>Description</strong></td>
				<td><strong>Database Type</strong></td>
				<td><strong>Status</strong></td>
			</tr>
		<cfloop index="i" from="1" to="#arrayLen(datasources)#">
			<!--- TODO: need to sort alphabetically --->
			<tr bgcolor="##ffffff">
				<td width="100">
					<a href="_controller.cfm?action=editDatasource&dsn=#datasources[i].name#" alt="Edit Datasource" title="Edit Datasource"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
					<a href="_controller.cfm?action=verifyDatasource&dsn=#datasources[i].name#" alt="Verify Datasource" title="Verify Datasource"><img src="../images/accept.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:removeDatasource('#datasources[i].name#');" alt="Remove Datasource" title="Remove Datasource"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
				</td>
				<td>#datasources[i].name#</td>
				<td><cfif structKeyExists(datasources[i], "description")>#datasources[i].description#<cfelse>&nbsp;</cfif></td>
				<td>#datasources[i].driverdescription#</td>
				<td>&nbsp;</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "dbDriverRetrievalMessage", false) />
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>
