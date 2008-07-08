<cfsilent>
	<cfset message = "" />
	<cfset datasources = arrayNew(1) />
	
	<cftry>
		<cfset datasources = Application.datasource.getDatasources() />
		<cfcatch type="bluedragon.adminapi.datasource">
			<cfset message = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>

<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function processAddDatasource(f) {
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
					f.action = f.dbType.value + ".cfm";
					f.submit();
					return true;
				}
			}
		</script>
		
		<form name="addDatasource" action="" method="post" onsubmit="javascript:return processAddDatasource(this);">
		<h3>Add Datasource</h3>
		<table border="0">
			<tr>
				<td>Datasource Name</td>
				<td><input type="text" name="dsn" size="30" maxlength="50" /></td>
			</tr>
			<tr>
				<td>Database Type</td>
				<td>
					<select name="dbType">
						<option value="" selected="true">- select -</option>
						<option value="mysql5">MySQL 4/5</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Add" /></td>
			</tr>
		</table>
		</form>
		
		<hr noshade="true" />

		<cfif message is not ""><p>#message#</p></cfif>
		
		<cfdump var="#datasources#" expand="true" />
	</cfoutput>
</cfsavecontent>
