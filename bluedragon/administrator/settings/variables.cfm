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
	<cfparam name="variableMessage" type="string" default="" />
	
	<cftry>
		<cfset variableSettings = Application.variableSettings.getVariableSettings() />
		
		<cftry>
			<cfset datasources = Application.datasource.getDatasources() />
			<cfcatch type="bluedragon.adminapi.datasource">
				<cfset datasources = arrayNew(1) />
			</cfcatch>
		</cftry>
		
		<cfset chartSettings = Application.chart.getChartSettings() />
		
		<!--- need to extract application and session timeout values from the createTimeSpan value in the config settings --->
		<cfset startPos = find("(", variableSettings.applicationtimeout) + 1 />
		<cfset endPos = find(")", variableSettings.applicationtimeout) />
		<cfset applicationTimeout = mid(variableSettings.applicationtimeout, startPos, endPos - startPos) />
		
		<cfset startPos = find("(", variableSettings.sessiontimeout) + 1 />
		<cfset endPos = find(")", variableSettings.sessiontimeout) />
		<cfset sessionTimeout = mid(variableSettings.sessiontimeout, startPos, endPos - startPos) />
		
		<cfcatch type="bluedragon.adminapi.variableSettings">
			<cfset variableMessage = CFCATCH.Message />
			<cfset variableMessageType = "error" />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validate(f) {
				if (f.appTimeoutDays.value != parseInt(f.appTimeoutDays.value)) {
					alert("The value for application timeout days is not numeric.");
					return false;
				} else if (f.appTimeoutHours.value != parseInt(f.appTimeoutHours.value)) {
					alert("The value for application timeout hours is not numeric.");
					return false;
				} else if (f.appTimeoutMinutes.value != parseInt(f.appTimeoutMinutes.value)) {
					alert("The value for application timeout minutes is not numeric.");
					return false;
				} else if (f.appTimeoutSeconds.value != parseInt(f.appTimeoutSeconds.value)) {
					alert("The value for application timeout seconds is not numeric.");
					return false;
				} else if (f.sessionTimeoutDays.value != parseInt(f.sessionTimeoutDays.value)) {
					alert("The value for session timeout days is not numeric.");
					return false;
				} else if (f.sessionTimeoutHours.value != parseInt(f.sessionTimeoutHours.value)) {
					alert("The value for session timeout hours is not numeric.");
					return false;
				} else if (f.sessionTimeoutMinutes.value != parseInt(f.sessionTimeoutMinutes.value)) {
					alert("The value for session timeout minutes is not numeric.");
					return false;
				} else if (f.sessionTimeoutSeconds.value != parseInt(f.sessionTimeoutSeconds.value)) {
					alert("The value for session timeout seconds is not numeric.");
					return false;
				} else if (f.clientexpiry.value != parseInt(f.clientexpiry.value)) {
					alert("The value for client variable expiration days is not numeric.");
					return false;
				} else if (f.cfchartcachesize.value != parseInt(f.cfchartcachesize.value)) {
					alert("The value for CFCHART cache size is not numeric.");
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		<h3>Variable Settings</h3>
		
		<cfif structKeyExists(session, "message") and session.message.text is not "">
			<p class="#session.message.type#">#session.message.text#</p>
		</cfif>
		
		<cfif variableMessage is not "">
			<p class="#variableMessageType#">#variableMessage#</p>
		</cfif>

		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="error">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<form name="variableForm" action="_controller.cfm?action=processVariableForm" method="post" 
				onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Update Variable Settings</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Use J2EE Sessions</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="j2eesession" id="j2eesessionTrue" value="true"
							<cfif variableSettings.j2eesession> checked="true"</cfif> tabindex="1" />
					<label for="j2eesessionTrue">Yes</label>&nbsp;
					<input type="radio" name="j2eesession" id="j2eesessionFalse" value="false"
							<cfif not variableSettings.j2eesession> checked="true"</cfif> tabindex="2" />
					<label for="j2eesessionFalse">No</label>
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Default Application Timeout</td>
				<td bgcolor="##ffffff">
					<input type="text" name="appTimeoutDays" id="appTimeoutDays" size="3" maxlength="2" 
							value="#listFirst(applicationTimeout)#" tabindex="3" />
					&nbsp;<label for="appTimeoutDays">days</label>&nbsp;
					<input type="text" name="appTimeoutHours" id="appTimeoutHours" size="3" maxlength="2" 
							value="#listGetAt(applicationTimeout, 2)#" tabindex="4" />
					&nbsp;<label for="appTimeoutHours">hours</label>&nbsp;
					<input type="text" name="appTimeoutMinutes" id="appTimeoutMinutes" size="3" maxlength="2" 
							value="#listGetAt(applicationTimeout, 3)#" tabindex="5" />
					&nbsp;<label for="appTimeoutMinutes">mins</label>&nbsp;
					<input type="text" name="appTimeoutSeconds" id="appTimeoutSeconds" size="3" maxlength="2" 
							value="#listLast(applicationTimeout)#" tabindex="6" />
					&nbsp;<label for="appTimeoutSeconds">secs</label>
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Default Session Timeout</td>
				<td bgcolor="##ffffff">
					<input type="text" name="sessionTimeoutDays" id="sessionTimeoutDays" size="3" maxlength="2" 
							value="#listFirst(sessionTimeout)#" tabindex="7" />
					&nbsp;<label for="sessionTimeoutDays">days</label>&nbsp;
					<input type="text" name="sessionTimeoutHours" id="sessionTimeoutHours" size="3" maxlength="2" 
							value="#listGetAt(sessionTimeout, 2)#" tabindex="8" />
					&nbsp;<label for="sessionTimeoutHours">hours</label>&nbsp;
					<input type="text" name="sessionTimeoutMinutes" id="sessionTimeoutMinutes" size="3" maxlength="2" 
							value="#listGetAt(sessionTimeout, 3)#" tabindex="9" />
					&nbsp;<label for="sessionTimeoutMinutes">mins</label>&nbsp;
					<input type="text" name="sessionTimeoutSeconds" id="sessionTimeoutSeconds" size="3" maxlength="2" 
							value="#listLast(sessionTimeout)#" tabindex="10" />
					&nbsp;<label for="sessionTimeoutSeconds">secs</label>
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right" valign="top"><label for="clientstorage">Client Variable Storage</label></td>
				<td bgcolor="##ffffff">
					<select name="clientstorage" id="clientstorage" tabindex="11">
						<option value="cookie"<cfif variableSettings.clientstorage is "cookie"> selected="true"</cfif>>Cookies</option>
					<cfif arrayLen(datasources) gt 0>
						<cfloop index="i" from="1" to="#arrayLen(datasources)#">
						<option value="#datasources[i].name#"<cfif variableSettings.clientstorage is datasources[i].name> selected="true"</cfif>>#datasources[i].name#</option>
						</cfloop>
					</cfif>
					</select><br />
					<input type="checkbox" name="clientpurgeenabled" id="clientpurgeenabled" value="true"
							<cfif variableSettings.clientpurgeenabled> checked="true"</cfif> tabindex="12" />
					<label for="clientpurgeenabled">Enable purging of data that is</label>&nbsp;
					<input type="text" name="clientexpiry" id="clientexpiry" size="3" maxlength="3" 
							value="#variableSettings.clientexpiry#" tabindex="13" />
					&nbsp;<label for="clientexpiry">days old</label><br />
					<input type="checkbox" name="clientGlobalUpdatesDisabled" 
							id="clientGlobalUpdatesDisabled" value="true" 
							<cfif StructKeyExists(variableSettings, "clientGlobalUpdatesDisabled") 
									and variableSettings.clientGlobalUpdatesDisabled> checked="true"</cfif> tabindex="14" />
					<label for="clientGlobalUpdatesDisabled">Disable Global Client Variable Updates</label><br />
					<input type="checkbox" name="cf5clientdata" id="cf5clientdata" value="true"
							<cfif variableSettings.cf5clientdata> checked="true"</cfif> tabindex="15" />
					<label for="cf5clientdata">ColdFusion 5-compatible client data</label>&nbsp;
					<img src="../images/arrow_refresh_small.png" width="16" height="16" alt="Requires Server Restart" title="Requires Server Restart" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="cfchartstorage">CFCHART Storage</label></td>
				<td bgcolor="##ffffff">
					<select name="cfchartstorage" id="cfchartstorage" tabindex="16">
						<option value="file"<cfif chartSettings.storage is "file"> selected="true"</cfif>>File</option>
						<option value="session"<cfif chartSettings.storage is "session"> selected="true"</cfif>>Session</option>
					<cfif arrayLen(datasources) gt 0>
						<cfloop index="i" from="1" to="#arrayLen(datasources)#">
						<option value="#datasources[i].name#"<cfif chartSettings.storage is datasources[i].name> selected="true"</cfif>>
							<cfif structKeyExists(datasources[i], "displayname")>#datasources[i].displayname#<cfelse>#datasources[i].name#</cfif>
						</option>
						</cfloop>
					</cfif>
					</select>
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="cfchartcachesize">CFCHART Cache Size</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="cfchartcachesize" id="cfchartcachesize" size="5" maxlength="4" 
							value="#chartSettings.cachesize#" tabindex="17" /> charts
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" tabindex="18" /></td>
			</tr>
		</table>
		</form>
		<p><strong>Information Concerning Variable Settings</strong></p>
		<ul>
			<li>Changing the "ColdFusion 5-compatible client data" setting requires Open BlueDragon to be restarted.</li>
		</ul>
	</cfoutput>
</cfsavecontent>