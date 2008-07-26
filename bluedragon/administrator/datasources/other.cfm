<cfsavecontent variable="request.content">
<cfoutput>
	<cfparam name="url.dsn" type="string" default="" />
	<cfparam name="url.action" type="string" default="create" />
	
	<cfif not structKeyExists(session, "datasource")>
		<cfset session.message = "An error occurred while processing the datasource action." />
		<cflocation url="index.cfm" addtoken="false" />
	</cfif>
	
	<cfset dsinfo = session.datasource[1] />
	
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
		
		function validate(f) {
			var ok = true;
			
			if (f.name.value.length == 0) {
				alert("Please enter the datasource name");
				ok = false;
			} else if (f.hoststring.value.length == 0) {
				alert("Please enter the JDBC URL");
				ok = false;
			} else if (f.drivername.value.length == 0) {
				alert("Please enter the JDBC driver name");
				ok = false;
			}
			
			return ok;
		}
	</script>
	<h3>Configure Datasource - Other</h3>
	<br />
	<cfif structKeyExists(session, "message")>
	<p style="color:red;font-weight:bold;">#session.message#</p>
	</cfif>

	<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
		<p class="message">The following errors occurred:</p>
		<ul>
		<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
			<li>#session.errorFields[i][2]#</li>
		</cfloop>
		</ul>
	</cfif>
	
	<!--- TODO: need explanatory tooltips/mouseovers on all these settings, esp. 'per request connections' which 
			from my understanding is the opposite of Adobe CF's description 'maintain connections across client requests'--->
	<!--- TODO: pull default driver and port values from the datasource.cfc --->
	<form name="datasourceForm" action="_controller.cfm?action=processDatasourceForm" method="post" onsubmit="return validate(this);">
	<table border="0">
		<tr>
			<td>OpenBD Datasource Name</td>
			<td><input name="name" type="text" size="30" maxlength="50" value="#dsinfo.name#" /></td>
		</tr>
		<tr>
			<td valign="top">JDBC URL</td>
			<td valign="top">
				<textarea name="hoststring" cols="40" rows="4">#dsinfo.hoststring#</textarea>
			</td>
		</tr>
		<tr>
			<td>Driver Class</td>
			<td><input name="drivername" type="text" size="30" maxlength="250" value="#dsinfo.drivername#" /></td>
		</tr>
		<tr>
			<td>User Name</td>
			<td><input name="username" type="text" size="30" maxlength="50" value="#dsinfo.username#" /></td>
		</tr>
		<!--- TODO: need to figure out how to handle the password once things are encrypted --->
		<tr>
			<td>Password</td>
			<td><input name="password" type="password" size="30" maxlength="16" value="#dsinfo.password#" /></td>
		</tr>
		<tr>
			<td valign="top">Description</td>
			<td valign="top">
				<textarea name="description" rows="4" cols="40"><cfif structKeyExists(dsinfo, "description")>#dsinfo.description#</cfif></textarea>
			</td>
		</tr>
		<tr>
			<td>
				<input type="button" id="advSettingsButton" name="showAdvSettings" value="Show Advanced Settings" onclick="javascript:showHideAdvSettings();" />
			</td>
			<td align="right">
				<input type="submit" name="submit" value="Submit" />
				<input type="button" name="cancel" value="Cancel" onclick="javascript:location.replace('index.cfm');" />
			</td>
		</tr>
	</table>
	<div id="advancedSettings" style="display:none;visibility:hidden;">
	<br />
	<table border="0">
		<tr>
			<td valign="top">Initialization String</td>
			<td valign="top"><textarea name="initstring" rows="4" cols="40"></textarea></td>
		</tr>
		<tr>
			<td valign="top">SQL Operations</td>
			<td valign="top">
				<table border="0">
					<tr>
						<td><input type="checkbox" name="sqlselect" value="true"<cfif dsinfo.sqlselect> checked="true"</cfif> />SELECT</td>
						<td><input type="checkbox" name="sqlinsert" value="true"<cfif dsinfo.sqlinsert> checked="true"</cfif> />INSERT</td>
					</tr>
					<tr>
						<td><input type="checkbox" name="sqlupdate" value="true"<cfif dsinfo.sqlupdate> checked="true"</cfif> />UPDATE</td>
						<td><input type="checkbox" name="sqldelete" value="true"<cfif dsinfo.sqldelete> checked="true"</cfif> />DELETE</td>
					</tr>
					<tr>
						<td><input type="checkbox" name="sqlstoredprocedures" value="true"<cfif dsinfo.sqlstoredprocedures> checked="true"</cfif> />Stored Procedures</td>
						<td>&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>Per-Request Connections</td>
			<td><input type="checkbox" name="perrequestconnections" value="true"<cfif dsinfo.perrequestconnections> checked="true"</cfif> /></td>
		</tr>
		<tr>
			<td>Maximum Connections</td>
			<td><input type="text" name="maxconnections" size="4" maxlength="4" value="#dsinfo.maxconnections#" /></td>
		</tr>
		<tr>
			<td>Connection Timeout</td>
			<td><input type="text" name="connectiontimeout" size="4" maxlength="4" value="#dsinfo.connectiontimeout#" /></td>
		</tr>
		<tr>
			<td>Login Timeout</td>
			<td><input type="text" name="logintimeout" size="4" maxlength="4" value="#dsinfo.logintimeout#" /></td>
		</tr>
		<tr>
			<td>Connection Retries</td>
			<td><input type="text" name="connectionretries" size="4" maxlength="4" value="#dsinfo.connectionretries#" /></td>
		</tr>
		<!--- TODO: add "use unicode" checkbox or make user add that into the init string? --->
	</table>
	</div>
		<input type="hidden" name="drivername" value="#dsinfo.drivername#" />
		<input type="hidden" name="datasourceAction" value="#url.action#" />
		<input type="hidden" name="existingDatasourceName" value="#dsinfo.name#" />
	</form>
</cfoutput>
<cfset structDelete(session, "message", false) />
<cfset structDelete(session, "datasource", false) />
<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>
