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
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<h3>Security</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<form name="ipAddresses" action="_controller.cfm?action=processIPAddressesForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Allowed IP Addresses</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">
					Allow IPs<br />
					(comma-delimited)
				</td>
				<td bgcolor="##ffffff">
					<input type="text" name="allowIPs" size="50" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">
					Deny IPs<br />
					(comma-delimited)
				</td>
				<td bgcolor="##ffffff">
					<input type="text" name="denyIPs" size="50" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" />
				</td>
			</tr>
		</table>
		</form>
		
		<br />
		<br />

		<form name="adminConsolePassword" action="_controller.cfm?action=processAdminConsolePasswordForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Administration Console Password</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Password</td>
				<td bgcolor="##ffffff">
					<input type="password" name="password" size="30" maxlength="30" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Confirm Password</td>
				<td bgcolor="##ffffff">
					<input type="password" name="confirmPassword" size="30" maxlength="30" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" />
				</td>
			</tr>
		</table>
		</form>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>
