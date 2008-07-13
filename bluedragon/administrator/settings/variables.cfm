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
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif variableMessage is not "">
			<p class="message">#variableMessage#</p>
		</cfif>
		
		<form name="variableForm" action="_controller.cfm?action=processVariableForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr>
				<td bgcolor="##f0f0f0" align="right">Use J2EE Sessions</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="j2eesession" value="true"<cfif variableSettings.j2eesession> checked="true"</cfif> /> Yes&nbsp;
					<input type="radio" name="j2eesession" value="false"<cfif not variableSettings.j2eesession> checked="true"</cfif> />No
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Application Timeout</td>
				<td bgcolor="##ffffff">
					<input type="text" name="appTimeoutDays" size="3" maxlength="2" value="#listFirst(applicationTimeout)#"> days&nbsp;
					<input type="text" name="appTimeoutHours" size="3" maxlength="2" value="#listGetAt(applicationTimeout, 2)#"> hours&nbsp;
					<input type="text" name="appTimeoutMinutes" size="3" maxlength="2" value="#listGetAt(applicationTimeout, 3)#"> mins&nbsp;
					<input type="text" name="appTimeoutSeconds" size="3" maxlength="2" value="#listLast(applicationTimeout)#"> secs
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Session Timeout</td>
				<td bgcolor="##ffffff">
					<input type="text" name="sessionTimeoutDays" size="3" maxlength="2" value="#listFirst(sessionTimeout)#"> days&nbsp;
					<input type="text" name="sessionTimeoutHours" size="3" maxlength="2" value="#listGetAt(sessionTimeout, 2)#"> hours&nbsp;
					<input type="text" name="sessionTimeoutMinutes" size="3" maxlength="2" value="#listGetAt(sessionTimeout, 3)#"> mins&nbsp;
					<input type="text" name="sessionTimeoutSeconds" size="3" maxlength="2" value="#listLast(sessionTimeout)#"> secs
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right" valign="top">Client Variable Storage</td>
				<td bgcolor="##ffffff">
					<select name="clientstorage">
						<option value="cookie"<cfif variableSettings.clientstorage is "cookie"> selected="true"</cfif>>Cookies</option>
					<cfif arrayLen(datasources) gt 0>
						<cfloop index="i" from="1" to="#arrayLen(datasources)#">
						<option value="#datasources[i].name#"<cfif variableSettings.clientstorage is datasources[i].name> selected="true"</cfif>>#datasources[i].name#</option>
						</cfloop>
					</cfif>
					</select><br />
					<input type="checkbox" name="clientpurgeenabled" value="true"<cfif variableSettings.clientpurgeenabled> checked="true"</cfif> />Enable purging of data that is <input type="text" name="clientexpiry" size="3" maxlength="3" /> days old<br />
					<input type="checkbox" name="cf5clientdata" value="true"<cfif variableSettings.cf5clientdata> checked="true"</cfif> />ColdFusion 5-compatible client data
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">CFCHART Storage</td>
				<td bgcolor="##ffffff">
					<select name="cfchartstorage">
						<option value="file"<cfif chartSettings.storage is "file"> selected="true"</cfif>>File</option>
						<option value="session"<cfif chartSettings.storage is "session"> selected="true"</cfif>>Session</option>
					<cfif arrayLen(datasources) gt 0>
						<cfloop index="i" from="1" to="#arrayLen(datasources)#">
						<option value="#datasources[i].name#"<cfif chartSettings.storage is datasources[i].name> selected="true"</cfif>>#datasources[i].name#</option>
						</cfloop>
					</cfif>
					</select>
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">CFCHART Cache Size</td>
				<td bgcolor="##ffffff">
					<input type="text" name="cfchartcachesize" size="5" maxlength="4" value="#chartSettings.cachesize#" /> charts
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" /></td>
			</tr>
		</table>
		</form>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>