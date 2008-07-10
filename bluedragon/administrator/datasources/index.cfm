<cfsilent>
	<cfparam name="datasourceRetrievalMessage" type="string" default="" />
	
	<cfset datasources = arrayNew(1) />
	
	<cftry>
		<cfset datasources = Application.datasource.getDatasources() />
		<cfcatch>
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
			
			function updateDBInfo() {
				var f = document.forms.addDatasource;
				var dbType = f.dbType.value;
				
				switch(dbType) {
					case 'mssql-jtds':
						f.drivername = 'net.sourceforge.jtds.jdbc.Driver';
						break;
						
					case 'mssql-microsoft':
						f.drivername = 'com.microsoft.sqlserver.jdbc.SQLServerDriver';
						break;
					
					case 'mysql5':
						f.drivername = 'com.mysql.jdbc.Driver';
						break;
					
					case 'postgres':
						f.drivername = 'org.postgresql.Driver';
						break;
					
					default:
						alert('Invalid database type selection');
				}
			}
			
			function removeDatasource(dsn) {
				if(confirm("Are you sure you want to remove this datasource?")) {
					location.replace('_controller.cfm?action=removeDatasource&dsn=' + dsn);
				}
			}
		</script>
		
		<h3>Add Datasource</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
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
					<select name="dbType" onchange="javascript:updateDBInfo();">
						<option value="" selected="true">- select -</option>
						<option value="mssql-jtds">Microsoft SQL Server 2000/2005 (jTDS Driver)</option>
						<option value="mssql-microsoft">Microsoft SQL Server 2005 (Microsoft JDBC Driver)</option>
						<option value="mysql5">MySQL 4/5 (MySQL JDBC Driver)</option>
						<option value="postgres">PostgreSQL (PostgreSQL Driver)</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Add Datasource" /></td>
			</tr>
		</table>
			<input type="hidden" name="drivername" value="" />
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
					<a href="_controller.cfm?action=editDatasource&dsn=#datasources[i].name#&dbType=#datasources[i].dbtype#" alt="Edit Datasource" title="Edit Datasource"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
					<a href="_controller.cfm?action=verifyDatasource&dsn=#datasources[i].name#" alt="Verify Datasource" title="Verify Datasource"><img src="../images/accept.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:removeDatasource('#datasources[i].name#');" alt="Remove Datasource" title="Remove Datasource"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
				</td>
				<td>#datasources[i].name#</td>
				<td>#datasources[i].description#</td>
				<td>#datasources[i].drivername#</td>
				<td>&nbsp;</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
	</cfoutput>
</cfsavecontent>
