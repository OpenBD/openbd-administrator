<cfsavecontent variable="request.content">
<script type="text/javascript">
	function showHideAdvSettings() {
		var advSettings = document.getElementById('advancedSettings');
		var advSettingsButton = document.getElementById('advSettingsButton');
		
		if (advSettings.style.visibility == 'visible') {
			advSettingsButton.value = 'Show Advanced Settings';
			advSettings.style.display= 'none';
			advSettings.style.visibility = 'hidden';
		} else {
			advSettingsButton.value = 'Hide Advanced Settings';
			advSettings.style.display = 'inline';
			advSettings.style.visibility = 'visible';
		}
	}
</script>

<h3>Configure Datasource - MySQL 4/5</h3>
<br />

<form name="datasourceForm" action="" method="post" onsubmit="">
<table border="0">
	<tr>
		<td>Datasource Name</td>
		<td><input name="dsn" type="text" size="30" maxlength="50" /></td>
	</tr>
	<tr>
		<td>Database</td>
		<td><input name="database" type="text" size="30" maxlength="250" /></td>
	</tr>
	<tr>
		<td>Server</td>
		<td><input name="databaseServer" type="text" size="30" maxlength="250" /></td>
	</tr>
	<tr>
		<td>Port</td>
		<td><input name="serverPort" type="text" size="6" maxlength="5" /></td>
	</tr>
	<tr>
		<td>User Name</td>
		<td><input name="dbUserName" type="text" size="30" maxlength="50" /></td>
	</tr>
	<tr>
		<td>Password</td>
		<td><input name="dbPassword" type="text" size="30" maxlength="16" /></td>
	</tr>
	<tr>
		<td valign="top">Description</td>
		<td valign="top"><textarea name="description" rows="4" cols="40"></textarea></td>
	</tr>
	<tr>
		<td>
			<input type="button" id="advSettingsButton" name="showAdvSettings" value="Show Advanced Settings" onclick="javascript:showHideAdvSettings();" />
		</td>
		<td align="right">
			<input type="submit" name="submit" value="Submit" />
			<input type="button" name="cancel" value="Cancel" />
		</td>
	</tr>
</table>
<div id="advancedSettings" style="display:none;visibility:hidden;">
<br />
<table border="0">
	<tr>
		<td>Connection String</td>
		<td><input name="connectionString" type="text" size="30" /></td>
	</tr>
	<tr>
		<td>Initialization String</td>
		<td><input name="initializationString" type="text" size="30" /></td>
	</tr>
	<tr>
		<td valign="top">SQL Operations</td>
		<td valign="top">
			<table border="0">
				<tr>
					<td><input type="checkbox" name="sqlOperations" value="select" checked="true" />SELECT</td>
					<td><input type="checkbox" name="sqlOperations" value="insert" checked="true" />INSERT</td>
				</tr>
				<tr>
					<td><input type="checkbox" name="sqlOperations" value="update" checked="true" />UPDATE</td>
					<td><input type="checkbox" name="sqlOperations" value="delete" checked="true" />DELETE</td>
				</tr>
				<tr>
					<td><input type="checkbox" name="sqlOperations" value="update" checked="true" />Stored Procedures</td>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>Per-Request Connections</td>
		<td><input type="checkbox" name="perRequestConnections" value="1" checked="true" /></td>
	</tr>
	<tr>
		<td>Maximum Connections</td>
		<td><input type="text" name="maxConnections" size="4" maxlength="4" /></td>
	</tr>
	<tr>
		<td>Wait Timeout</td>
		<td><input type="text" name="waitTimeout" size="4" maxlength="4" /></td>
	</tr>
	<tr>
		<td>Usage Timeout</td>
		<td><input type="text" name="usageTimeout" size="4" maxlength="4" /></td>
	</tr>
	<tr>
		<td>Connection Retries</td>
		<td><input type="text" name="connectionRetries" size="4" maxlength="4" /></td>
	</tr>
</table>
</div>
</form>
</cfsavecontent>
