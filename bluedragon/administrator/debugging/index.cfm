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
	<cfparam name="debuggingMessage" type="string" default="" />
	
	<cftry>
		<cfset debugSettings = Application.debugging.getDebugSettings() />
		<cfcatch type="bluedragon.adminapi.debugging">
			<cfset debuggingMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validateDebugOutputForm(f) {
				if (f.highlight.value != parseInt(f.highlight.value)) {
					alert("The value of Highlight Execution Times is not numeric");
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		<h3>Debug Settings</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif debuggingMessage is not "">
			<p class="message">#debuggingMessage#</p>
		</cfif>

		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="message">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<form name="debugSettingsForm" action="_controller.cfm?action=processDebugSettingsForm" method="post">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Debug &amp; Error Settings</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Extended Error Reporting</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="debug" value="true"<cfif debugSettings.system.debug> checked="true"</cfif> />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Runtime Error Logging</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="runtimelogging" value="true"<cfif debugSettings.system.runtimelogging> checked="true"</cfif> />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Enable Debug Output</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="enabled" value="true"<cfif debugSettings.debugoutput.enabled> checked="true"</cfif> />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Assertions</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="assert" value="true"<cfif debugSettings.system.assert> checked="true"</cfif> />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" /></td>
			</tr>
		</table>
		</form>
		
		<br /><br />

		<form name="debugOutputForm" action="_controller.cfm?action=processDebugOutputForm" method="post" onsubmit="javascript:return validateDebugOutputForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Debug Output</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Page Execution Times</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="executiontimes" value="true"<cfif debugSettings.debugoutput.executiontimes.show> checked="true"</cfif> />&nbsp;&nbsp;
					Highlight times greater than <input type="text" name="highlight" size="4" maxlength="4" value="#debugSettings.debugoutput.executiontimes.highlight#" /> ms
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Database Activity</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="database" value="true"<cfif debugSettings.debugoutput.database.show> checked="true"</cfif> />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Exceptions</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="exceptions" value="true"<cfif debugSettings.debugoutput.exceptions.show> checked="true"</cfif> />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Trace Points</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="tracepoints" value="true"<cfif debugSettings.debugoutput.tracepoints.show> checked="true"</cfif> />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Timer Information</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="timer" value="true"<cfif debugSettings.debugoutput.timer.show> checked="true"</cfif> />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Variables</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="variables" value="true"<cfif debugSettings.debugoutput.variables.show> checked="true"</cfif> />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" /></td>
			</tr>
		</table>
		</form>
		
		<br /><br />
		
		<form name="debugVariablesForm" action="_controller.cfm?action=processDebugVariablesForm" method="post">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Debug and Error Variables</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right" valign="top">Variable Scopes</td>
				<td bgcolor="##ffffff">
					<table border="0" width="100%" cellpadding="2" cellspacing="2">
						<tr>
							<td>
								<input type="checkbox" name="local" value="true"<cfif debugSettings.debugoutput.variables.local> checked="true"</cfif>>Local
							</td>
							<td>
								<input type="checkbox" name="url" value="true"<cfif debugSettings.debugoutput.variables.url> checked="true"</cfif>>URL
							</td>
							<td>
								<input type="checkbox" name="session" value="true"<cfif debugSettings.debugoutput.variables.session> checked="true"</cfif>>Session
							</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" name="variables" value="true"<cfif debugSettings.debugoutput.variables.variables> checked="true"</cfif>>Variables
							</td>
							<td>
								<input type="checkbox" name="form" value="true"<cfif debugSettings.debugoutput.variables.form> checked="true"</cfif>>Form
							</td>
							<td>
								<input type="checkbox" name="client" value="true"<cfif debugSettings.debugoutput.variables.client> checked="true"</cfif>>Client
							</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" name="request" value="true"<cfif debugSettings.debugoutput.variables.request> checked="true"</cfif>>Request
							</td>
							<td>
								<input type="checkbox" name="cookie" value="true"<cfif debugSettings.debugoutput.variables.cookie> checked="true"</cfif>>Cookie
							</td>
							<td>
								<input type="checkbox" name="application" value="true"<cfif debugSettings.debugoutput.variables.application> checked="true"</cfif>>Application
							</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" name="cgi" value="true"<cfif debugSettings.debugoutput.variables.cgi> checked="true"</cfif>>CGI
							</td>
							<td>
								<input type="checkbox" name="cffile" value="true"<cfif debugSettings.debugoutput.variables.cffile> checked="true"</cfif>>CFFILE
							</td>
							<td>
								<input type="checkbox" name="server" value="true"<cfif debugSettings.debugoutput.variables.server> checked="true"</cfif>>Server
							</td>
						</tr>
					</table>
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
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>