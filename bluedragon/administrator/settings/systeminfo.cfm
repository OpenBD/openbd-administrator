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
	<cfset adminAPIInfo = Application.serverSettings.getAdminAPIInfo() />
	<cfset serverStartTime = Application.serverSettings.getServerStartTime() />
	<cfset serverUptime = Application.serverSettings.getServerUpTime("struct") />
	<cfset memoryInfo = SystemMemory() />
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<h3>System Information</h3>

		<cfif structKeyExists(session, "message") and session.message.text is not "">
			<p class="#session.message.type#">#session.message.text#</p>
		</cfif>
		
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Server Status</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Server Name</td>
				<td bgcolor="##ffffff">#cgi.server_name#</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Start Time</td>
				<td bgcolor="##ffffff">#LSDateFormat(serverStartTime, "dd mmm yyyy")# #LSTimeFormat(serverStartTime, "HH:mm:ss")#</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Current Time</td>
				<td bgcolor="##ffffff">#LSDateFormat(now(), "dd mmm yyyy")# #LSTimeFormat(now(), "HH:mm:ss")#</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Uptime</td>
				<td bgcolor="##ffffff">#serverUptime.days# Days #serverUptime.hours# Hours #serverUptime.minutes# Minutes #serverUptime.seconds# Seconds</td>
			</tr>
		</table>
		
		<br />
		<br />

		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Application and Session Status</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0" width="300">Number of Running Applications</td>
				<td bgcolor="##ffffff">#ApplicationCount()#</td>
			</tr>
			<tr>
				<td align="right" valign="top" bgcolor="##f0f0f0">Running Applications</td>
				<td bgcolor="##ffffff" valign="top">
					<cfif ArrayLen(ApplicationList()) gt 0>
					<table>
						<cfloop array="#ApplicationList()#" index="app">
						<tr>
							<td>#app#</td>
							<td>
								<a href="_controller.cfm?action=unloadApplication&applicationName=#app#">
									<img src="../images/cancel.png" border="0" width="16" height="16" alt="Unload Application" title="Unload Application" />
								</a>
							</td>
						</tr>
						</cfloop>
					</table>
					</cfif>
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Number of Active Sessions</td>
				<td bgcolor="##ffffff">#SessionCount()#</td>
			</tr>
		</table>
		
		<br />
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
				<td align="right" bgcolor="##f0f0f0">Open BlueDragon Build Date</td>
				<td bgcolor="##ffffff">#server.bluedragon.builddate#</td>
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
		<br />

		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>JVM Memory Information</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Used</td>
				<td bgcolor="##ffffff">#Round(memoryInfo.used / 1048576)# MB</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Free</td>
				<td bgcolor="##ffffff">#Round(memoryInfo.free / 1048576)# MB</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Total</td>
				<td bgcolor="##ffffff">#Round(memoryInfo.total / 1048576)# MB</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Max</td>
				<td bgcolor="##ffffff">#Round(memoryInfo.max / 1048576)# MB</td>
			</tr>
		</table>
		
		<br />
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
</cfsavecontent>
