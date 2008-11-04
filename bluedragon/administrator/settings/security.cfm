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
	<cfset allowedIPs = Application.administrator.getAllowedIPs() />
	<cfset deniedIPs = Application.administrator.getDeniedIPs() />
</cfsilent>
<cfsavecontent variable="request.content">
	<script type="text/javascript">
		function validatePasswordForm(f) {
			if (f.password.value != f.confirmPassword.value) {
				alert("The password fields do not match");
				return false;
			}
			
			return true;
		}
	</script>
	
	<cfoutput>
		<h3>Security</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif structKeyExists(session, "errorFields") and isArray(session.errorFields)>
			<p class="message">The following errors occurred:</p>
			
			<ul>
				<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
					<li>#session.errorFields[i][2]#</li>
				</cfloop>
			</ul>
		</cfif>
		
		<form name="ipAddresses" action="_controller.cfm?action=processIPAddressForm" method="post">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Allowed IP Addresses</strong> (comma-delimited, * for wildcard)</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Allow IPs</td>
				<td bgcolor="##ffffff">
					<input type="text" name="allowIPs" size="70" value="#allowedIPs#" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Deny IPs</td>
				<td bgcolor="##ffffff">
					<input type="text" name="denyIPs" size="70" value="#deniedIPs#" />
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

		<form name="adminConsolePassword" action="_controller.cfm?action=processAdminConsolePasswordForm" method="post" onsubmit="javascript:return validatePasswordForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Administration Console Password</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">New Password</td>
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
		
		<p><strong>Important Information Concerning Security</strong></p>
		
		<ul>
			<li>
				The localhost address (127.0.0.1) will never be blocked from accessing the admin console, even 
				if it is added to the deny IP list.
			</li>
			<li>
				A blank allow IP list will allow access to the admin console from any IP address, provided 
				the IP address is not in the deny list.
			</li>
			<li>
				A blank deny IP list will allow access to the admin console from any IP address, provided 
				the allow list is blank.
			</li>
			<li>
				If the allow IP list is not blank, only those IP addresses listed in the allow 
				list will be allowed to access the admin console, even if the deny list is blank.
			</li>
			<li>
				Wildcards are allowed in the IP address list to include all ranges of an IP address. 
				For example, 192.168.* would allow access from all IP addresses the begin with 192.168.
			</li>
			<li>
				The deny IP list takes precedence over the allow IP list when an overlap occurs. This 
				means that if an IP address is a match for both the allow and deny list, the IP address 
				will be denied.
			</li>
			<li>
				The IP access list controls access to the entire admin console. 
				<strong>This includes the login page.</strong> If the IP address from which you are 
				attempting to access the admin console is not allowed access, then you will not be 
				able to access the admin console regardless of the password setting.
			</li>
			<li>
				A blank password is allowed but not recommended. Remember that even with a blank 
				password, the IP address list will control access to the admin console, so you could 
				have a blank password and control access to the admin console using only the IP 
				address lists.
			</li>
			<li>
				Remember that when all else fails, you may always access your server's filesystem directly 
				and modify the bluedragon.xml file manually to correct any IP address or password issues 
				that may be blocking access to the admin console.
			</li>
		</ul>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>
