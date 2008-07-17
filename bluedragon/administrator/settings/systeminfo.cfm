<cfsilent>
	<cfset adminAPIInfo = Application.serverSettings.getAdminAPIInfo() />
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<h3>System Information</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Server Status</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Server Name</td>
				<td bgcolor="##ffffff">#cgi.server_name#</td>
			</tr>
			<!--- TODO: get server start time and add uptime value --->
			<tr>
				<td align="right" bgcolor="##f0f0f0">Start Time</td>
				<td bgcolor="##ffffff">#server.coldfusion.expiration#</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Current Time</td>
				<td bgcolor="##ffffff">#LSDateFormat(now(), "dd mmm yyyy")# #LSTimeFormat(now(), "HH:mm:ss")#</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Uptime</td>
				<td bgcolor="##ffffff"></td>
			</tr>
		</table>
		
		<br />

		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Open BlueDragon and Java Information</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Open BlueDragon Product Version</td>
				<td bgcolor="##ffffff">#server.coldfusion.productversion#</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Operating System</td>
				<td bgcolor="##ffffff">#server.os.name# #server.os.arch# (#server.os.version#)</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Application Server</td>
				<td bgcolor="##ffffff">#server.coldfusion.appserver#</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Java Virtual Machine</td>
				<td bgcolor="##ffffff">#server.os.additionalinformation# (<a href="jvmproperties.cfm">JVM Properties</a>)</td>
			</tr>
		</table>
		
		<br />

		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Open BlueDragon Admin Console and Admin API Information</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Admin Console Version</td>
				<td bgcolor="##ffffff">#Application.adminConsoleVersion#</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Admin Console Build Date</td>
				<td bgcolor="##ffffff">#Application.adminConsoleBuildDate#</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Admin API Version</td>
				<td bgcolor="##ffffff">#adminAPIInfo.version#</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Admin API Build Date</td>
				<td bgcolor="##ffffff">#adminAPIInfo.builddate#</td>
			</tr>
		</table>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>
