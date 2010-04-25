<!---
	Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
	
	Contributing Developers:
	Matt Woodward - matt@mattwoodward.com

	This file is part of of the Open BlueDragon Administrator.

	The Open BlueDragon Administrator is free software: you can redistribute 
	it and/or modify it under the terms of the GNU General Public License 
	as published by the Free Software Foundation, either version 3 of the 
	License, or (at your option) any later version.

	The Open BlueDragon Administrator is distributed in the hope that it will 
	be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
	General Public License for more details.
	
	You should have received a copy of the GNU General Public License 
	along with the Open BlueDragon Administrator.  If not, see 
	<http://www.gnu.org/licenses/>.
--->
<cfsilent>
	<cfparam name="url.dsn" type="string" default="" />
	<cfparam name="url.action" type="string" default="create" />
	
	<cfif not structKeyExists(session, "datasource")>
		<cfset session.message.text = "An error occurred while processing the datasource action." />
		<cfset session.message.type = "error" />
		<cflocation url="index.cfm" addtoken="false" />
	</cfif>
	
	<cfset dsinfo = session.datasource[1] />
	<cfset dsinfo.filepath = "" />
	<cfset dsinfo.mode = "H2Native" />
	<cfset dsinfo.ignorecase = true />
	
	<cfif dsinfo.hoststring is not "">
		<cfset dsinfo.filepath = listFirst(dsinfo.hoststring, ";") />
		
		<cfif findNoCase(":file:", dsinfo.filepath) eq 0>
			<cfset dsinfo.filepath = right(dsinfo.filepath, len(dsinfo.filepath) - 8) />
		<cfelse>
			<cfset dsinfo.filepath = right(dsinfo.filepath, len(dsinfo.filepath) - 13) />
		</cfif>

		<cfset dsinfo.filepath = left(dsinfo.filepath, len(dsinfo.filepath) - (len(dsinfo.databasename) + 1)) />

		<cfif dsinfo.filepath is Application.datasource.getDefaultH2DatabasePath()>
			<cfset dsinfo.filepath = "" />
		</cfif>
		
		<cfset modeStart = findNoCase("MODE=", dsinfo.hoststring) />
		
		<cfif modeStart neq 0>
			<cfset modeEnd = find(";", dsinfo.hoststring, modeStart) />
			
			<cfif modeEnd eq 0>
				<cfset modeEnd = len(dsinfo.hoststring) />
			</cfif>
			
			<cfset dsinfo.mode = mid(dsinfo.hoststring, modeStart, modeEnd - modeStart + 1) />
			<cfset dsinfo.mode = right(dsinfo.mode, len(dsinfo.mode) - 5) />
		</cfif>
		
		<cfset ignoreCaseStart = findNoCase("IGNORECASE=", dsinfo.hoststring) />
		
		<cfif ignoreCaseStart neq 0>
			<cfset ignoreCaseEnd = find(";", dsinfo.hoststring, ignoreCaseStart) />

			<cfif ignoreCaseEnd eq 0>
				<cfset ignoreCaseEnd = len(dsinfo.hoststring) />
			</cfif>
			
			<cfset dsinfo.ignorecase = mid(dsinfo.hoststring, ignoreCaseStart, ignoreCaseEnd - ignoreCaseStart + 1) />
			<cfset dsinfo.ignorecase = right(dsinfo.ignorecase, len(dsinfo.ignorecase) - 11) />
			
			<cfif right(dsinfo.ignorecase, 1) is ";">
				<cfset dsinfo.ignorecase = left(dsinfo.ignorecase, len(dsinfo.ignorecase) - 1) />
			</cfif>
		</cfif>
	</cfif>
	
	<!--- added connectstring so need to set to a default in case it doesn't exist in the xml --->
	<cfif not StructKeyExists(dsinfo, "connectstring")>
		<cfset dsinfo.connectstring = "" />
	</cfif>
</cfsilent>
<cfsavecontent variable="request.content">
<cfoutput>
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
			} else if (f.databasename.value.length == 0) {
				alert("Please enter the database name");
				ok = false;
			} else if (f.server.value.length == 0) {
				alert("Please enter the database server");
				ok = false;
			} else if (f.port.value.length == 0) {
				alert("Please enter the database server port");
				ok = false;
			}
			
			return ok;
		}
	</script>
	<h3>Configure Datasource - H2 Embedded</h3>
	<br />
	<cfif structKeyExists(session, "message") and session.message.text is not "">
		<p class="#session.message.type#">#session.message.text#</p>
	</cfif>

	<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
		<p class="error">The following errors occurred:</p>
		<ul>
		<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
			<li>#session.errorFields[i][2]#</li>
		</cfloop>
		</ul>
	</cfif>
	
	<!--- TODO: need explanatory tooltips/mouseovers on all these settings, esp. 'per request connections' which 
			from my understanding is the opposite of Adobe CF's description 'maintain connections across client requests'--->
	<form name="datasourceForm" action="_controller.cfm?action=processDatasourceForm" method="post" 
			onsubmit="return validate(this);">
	<table border="0">
		<tr>
			<td><label for="name">OpenBD Datasource Name</td>
			<td><input name="name" id="name" type="text" size="30" maxlength="50" value="#dsinfo.name#" tabindex="1" /></td>
		</tr>
		<tr>
			<td valign="top"><label for="databasename">Database Name</label></td>
			<td valign="top">
				<input name="databasename" id="databasename" type="text" size="30" maxlength="250" 
						value="#dsinfo.databasename#" tabindex="2" /><br />
				<em>(Minimum 3 characters. The database will be created if it doesn't exist.)</em>
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="filepath">File Path</label></td>
			<td valign="top">
				<input name="filepath" id="filepath" type="text" size="30" value="#dsinfo.filepath#" tabindex="3" /><br />
				<em>(Leave blank for default path. Do not include database name.)</em>
			</td>
		</tr>
		<tr>
			<td><label for="mode">Compatibility Mode</label></td>
			<td>
				<select name="mode" id="mode" tabindex="4">
					<option value="H2Native"<cfif dsinfo.mode is "H2Native"> selected="true"</cfif>>None (H2 Native)</option>
					<option value="Derby"<cfif dsinfo.mode is "Derby"> selected="true"</cfif>>Derby</option>
					<option value="HSQLDB"<cfif dsinfo.mode is "HSQLDB"> selected="true"</cfif>>HSQLDB</option>
					<option value="MSSQLServer"<cfif dsinfo.mode is "MSSQLServer"> selected="true"</cfif>>Microsoft SQL Server</option>
					<option value="MySQL"<cfif dsinfo.mode is "MySQL"> selected="true"</cfif>>MySQL</option>
					<option value="Oracle"<cfif dsinfo.mode is "Oracle"> selected="true"</cfif>>Oracle</option>
					<option value="PostgreSQL"<cfif dsinfo.mode is "PostgreSQL"> selected="true"</cfif>>PostgreSQL</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>Case Sensitive?</td>
			<td>
				<input type="radio" name="ignorecase" id="ignorecaseFalse" value="false"
						<cfif not dsinfo.ignorecase> checked="true"</cfif> tabindex="5" />
				<label for="ignorecaseFalse">Yes</label>&nbsp;
				<input type="radio" name="ignorecase" id="ignorecaseTrue" value="true"
						<cfif dsinfo.ignorecase> checked="true"</cfif> tabindex="6" />
				<label for="ignorecaseTrue">No</label>
			</td>
		</tr>
		<tr>
			<td><label for="username">User Name</label></td>
			<td>
				<input name="username" id="username" type="text" size="30" maxlength="50" value="#dsinfo.username#" tabindex="7" />
			</td>
		</tr>
		<tr>
			<td><label for="password">Password</label></td>
			<td>
				<input name="password" id="password" type="password" size="30" value="#dsinfo.password#" tabindex="8" />
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="description">Description</label></td>
			<td valign="top">
				<textarea name="description" id="description" rows="4" cols="40" tabindex="9"><cfif structKeyExists(dsinfo, "description")>#dsinfo.description#</cfif></textarea>
			</td>
		</tr>
		<tr>
			<td>
				<input type="button" id="advSettingsButton" name="showAdvSettings" value="Show Advanced Settings" 
						onclick="javascript:showHideAdvSettings();" tabindex="10" />
			</td>
			<td align="right">
				<input type="submit" name="submit" value="Submit" tabindex="11" />
				<input type="button" name="cancel" value="Cancel" 
						onclick="javascript:location.replace('index.cfm');" tabindex="12" />
			</td>
		</tr>
	</table>
	<div id="advancedSettings" style="display:none;visibility:hidden;">
	<br />
	<table border="0">
		<tr>
			<td valign="top"><label for="connectstring">Connection String</label></td>
			<td valign="top">
				<textarea name="connectstring" id="connectstring" rows="4" cols="40" tabindex="13">#dsinfo.connectstring#</textarea>
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="initstring">Initialization String</label></td>
			<td valign="top">
				<textarea name="initstring" id="initstring" rows="4" cols="40" tabindex="14">#dsinfo.initstring#</textarea>
			</td>
		</tr>
		<tr>
			<td valign="top">SQL Operations</td>
			<td valign="top">
				<table border="0">
					<tr>
						<td>
							<input type="checkbox" name="sqlselect" id="sqlselect" value="true"
									<cfif dsinfo.sqlselect> checked="true"</cfif> tabindex="15" />
							<label for="sqlselect">SELECT</label>
						</td>
						<td>
							<input type="checkbox" name="sqlinsert" id="sqlinsert" value="true"
									<cfif dsinfo.sqlinsert> checked="true"</cfif> tabindex="16" />
							<label for="sqlinsert">INSERT</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="sqlupdate" id="sqlupdate" value="true"
									<cfif dsinfo.sqlupdate> checked="true"</cfif> tabindex="17" />
							<label for="sqlupdate">UPDATE</label>
						</td>
						<td>
							<input type="checkbox" name="sqldelete" id="sqldelete" value="true"
									<cfif dsinfo.sqldelete> checked="true"</cfif> tabindex="18" />
							<label for="sqldelete">DELETE</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="sqlstoredprocedures" id="sqlstoredprocedures" value="true"
									<cfif dsinfo.sqlstoredprocedures> checked="true"</cfif> tabindex="19" />
							<label for="sqlstoredprocedures">Stored Procedures</label>
						</td>
						<td>&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td><label for="perrequestconnections">Per-Request Connections</label></td>
			<td>
				<input type="checkbox" name="perrequestconnections" id="perrequestconnections" value="true"
						<cfif dsinfo.perrequestconnections> checked="true"</cfif> tabindex="20" />
			</td>
		</tr>
		<tr>
			<td><label for="maxconnections">Maximum Connections</label></td>
			<td>
				<input type="text" name="maxconnections" id="maxconnections" size="4" maxlength="4" 
						value="#dsinfo.maxconnections#" tabindex="21" />
			</td>
		</tr>
		<tr>
			<td><label for="connectiontimeout">Connection Timeout</label></td>
			<td>
				<input type="text" name="connectiontimeout" id="connectiontimeout" size="4" maxlength="10" 
						value="#dsinfo.connectiontimeout#" tabindex="22" />
			</td>
		</tr>
		<tr>
			<td><label for="logintimeout">Login Timeout</label></td>
			<td>
				<input type="text" name="logintimeout" id="logintimeout" size="4" maxlength="4" 
						value="#dsinfo.logintimeout#" tabindex="23" />
			</td>
		</tr>
		<tr>
			<td><label for="connectionretries">Connection Retries</label></td>
			<td>
				<input type="text" name="connectionretries" id="connectionretries" size="4" maxlength="4" 
						value="#dsinfo.connectionretries#" tabindex="24" />
			</td>
		</tr>
	</table>
	</div>
		<input type="hidden" name="drivername" value="#dsinfo.drivername#" />
		<input type="hidden" name="datasourceAction" value="#url.action#" />
		<input type="hidden" name="existingDatasourceName" value="#dsinfo.name#" />
		<input type="hidden" name="dbtype" value="h2embedded" />
	</form>
</cfoutput>
<cfset structDelete(session, "datasource", false) />
</cfsavecontent>
