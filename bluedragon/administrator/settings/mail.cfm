<!---
	Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
	
	Contributing Developers:
	Matt Woodward - matt@mattwoodward.com
	Jordan Michaels - jordan@viviotech.net

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
	<cfparam name="mailMessage" type="string" default="" />
	<cfparam name="mailAvailable" type="boolean" default="true" />
	<cfparam name="spoolCount" type="numeric" default="-1" />
	<cfparam name="undeliveredCount" type="numeric" default="-1" />
	<cfparam name="mailServerAction" type="string" default="create" />
	<cfparam name="mailServerFormActionHeader" type="string" default="Add a" />
	
	<cftry>
		<cfset mailSettings = Application.mail.getMailSettings() />
		<cfset mailServers = Application.mail.getMailServers() />
		<cfset charsets = Application.mail.getAvailableCharsets() />
		
		<cfcatch type="bluedragon.adminapi.mail">
			<cfset mailMessage = CFCATCH.Message />
			<cfset mailMessageType = "error" />
		</cfcatch>
	</cftry>
	
	<!--- if session.mailServerStatus exists, either one or all mail servers are being verified so add that info to the 
			mail servers --->
	<cfif structKeyExists(session, "mailServerStatus")>
		<cfloop index="i" from="1" to="#arrayLen(session.mailServerStatus)#">
			<cfloop index="j" from="1" to="#arrayLen(mailServers)#">
				<cfif session.mailServerStatus[i].smtpserver is mailServers[j].smtpserver>
					<cfif structKeyExists(session.mailServerStatus[i], "verified")>
						<cfset mailServers[j].verified = session.mailServerStatus[i].verified />
					</cfif>
					
					<cfif structKeyExists(session.mailServerStatus[i], "message")>
						<cfset mailServers[j].message = session.mailServerStatus[i].message />
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>
	</cfif>
	
	<cfif structKeyExists(session, "mailServer")>
		<cfset mailServer = session.mailServer[1] />
		<cfset mailServerAction = "update" />
		<cfset mailServerFormActionHeader = "Edit" />
		
		<!--- port number may not be specified in the xml --->
		<cfif not StructKeyExists(mailServer, "smtpport")>
			<cfset mailServer.smtpport = 25 />
		</cfif>
	<cfelse>
		<cfset mailServer = structNew() />
		<cfset mailServer.smtpserver = "" />
		<cfset mailServer.smtpport = 25 />
		<cfset mailServer.username = "" />
		<cfset mailServer.password = "" />
		<cfset mailServer.isPrimary = false />
	</cfif>
	
	<cfset spoolCount = Application.mail.getSpooledMailCount() />
	<cfset undeliveredCount = Application.mail.getUndeliveredMailCount() />
	
	<!--- some java app servers don't ship with javamail, so try instantiating 
			a mail session and inform the user if a mail session object can't be created --->
	<cftry>
		<cfset mailSession = createObject("java", "javax.mail.Session") />
		<cfcatch type="any">
			<cfset mailAvailable = false />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validateMailServerForm(f) {
				if (f.smtpserver.value.length == 0) {
					alert("Please enter an SMTP server");
					return false;
				} else if (f.smtpport.value != parseInt(f.smtpport.value)) {
					alert("The value of SMTP Port is not numeric");
					return false;
				} else {
					return true;
				}
			}
			
			function validateMailSettingsForm(f) {
				if (f.timeout.value != parseInt(f.timeout.value)) {
					alert("The value of Timeout is not numeric");
					return false;
				} else if (f.threads.value != parseInt(f.threads.value)) {
					alert("The value of Mail Threads is not numeric");
					return false;
				} else if (f.interval.value != parseInt(f.interval.value)) {
					alert("The value of Spool Interval is not numeric");
					return false;
				} else {
					return true;
				}
			}
			
			function verifyAllMailServers() {
				location.replace("_controller.cfm?action=verifyMailServer");
			}
			
			function removeMailServer(mailServer) {
				if(confirm("Are you sure you want to remove this mail server?")) {
					location.replace("_controller.cfm?action=removeMailServer&mailServer=" + mailServer);
				}
			}
			
			function respoolUndeliveredMail() {
				var undeliveredCount = #undeliveredCount#;
				
				if (undeliveredCount == 0) {
					alert("No undelivered mail to respool");
				} else {
					if(confirm("Are you sure you want to respool all undelivered mail?")) {
						location.replace("_controller.cfm?action=respoolUndeliveredMail");
					}
				}
			}
			
			function triggerMailSpool() {
				var spoolCount = #spoolCount#;
				
				if (spoolCount == 0) {
					alert("The mail spool is currently empty");
				} else {
					if(confirm("Are you sure you want to trigger the mail spool?\nYou should only do this if the mail spool has been\nidle for a long period and you do not want to\nrestart OpenBD.")) {
						location.replace("_controller.cfm?action=triggerMailSpool");
					}
				}
			}
		</script>
		
		<h3>Mail</h3>
		
		<cfif structKeyExists(session, "message") and session.message.text is not "">
			<p class="#session.message.type#">#session.message.text#</p>
		</cfif>

		<cfif not mailAvailable>
			<h3>JavaMail Not Installed</h3>
			
			<p class="error">It appears that you do not hava JavaMail installed.</p>
			
			<p>
				Some Java application severs, such as <a href="http://tomcat.apache.org/" target="_blank">Apache Tomcat</a>, 
				do not ship with JavaMail. Without JavaMail installed, Open BlueDragon is unable to send mail.
			</p>
			
			<p>
				Please download <a href="http://java.sun.com/products/javamail/downloads/index.html" target="_blank">JavaMail</a> 
				and place mail.jar in your classpath (either in your application server's shared lib directory, or in 
				Open BlueDragon's /WEB-INF/lib directory), then restart Open BlueDragon or your servlet container to enable 
				mail functionality.
			</p>
		</cfif>

		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="error">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<table border="0" width="300" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td colspan="3"><strong>Mail Status</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right" width="140">Spooled Mail</td>
				<td bgcolor="##ffffff">#spoolCount#</td>
				<td bgcolor="##ffffff" width="40" align="center">
					<a href="javascript:void(0);" onclick="javascript:triggerMailSpool();" 
						alt="Trigger Mail Spool" title="Trigger Mail Spool">
						<img src="../images/arrow_refresh.png" height="16" width="16" border="0" />
					</a>
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Undelivered Mail</td>
				<td bgcolor="##ffffff">#undeliveredCount#</td>
				<td bgcolor="##ffffff" align="center">
					<a href="javascript:void(0);" onclick="javascript:respoolUndeliveredMail();" 
							alt="Respool Undelivered Mail" title="Respool Undelivered Mail">
						<img src="../images/email_go.png" height="16" width="16" border="0" />
					</a>
				</td>
			</tr>
		</table>
		
		<br /><br />
		
		<cfif arrayLen(mailServers) eq 0>
			<h3>Mail Servers</h3>
		
			<p><strong><em>No mail servers configured</em></strong></p>
		<cfelse>
		<table border="0" width="700" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td colspan="5"><strong>Mail Servers</strong></td>
			</tr>
			<tr bgcolor="##f0f0f0">
				<td width="100"><strong>Actions</strong></td>
				<td><strong>Mail Server</strong></td>
				<td><strong>Port</strong></td>
				<td><strong>Using Login</strong></td>
				<td><strong>Status</strong></td>
			</tr>
		<cfloop index="i" from="1" to="#arrayLen(mailServers)#">
			<cfif NOT IsDefined("mailServers[i].smtpport")>
				<cfset mailServers[i].smtpport = 25>
			</cfif>
			<tr <cfif not structKeyExists(mailServers[i], "verified")>bgcolor="##ffffff"<cfelseif mailServers[i].verified>bgcolor="##ccffcc"<cfelseif not mailServers[i].verified>bgcolor="##ffff99"</cfif>>
				<td width="100">
					<a href="_controller.cfm?action=editMailServer&mailServer=#mailServers[i].smtpserver#" 
						alt="Edit Mail Server" title="Edit Mail Server">
						<img src="../images/pencil.png" border="0" width="16" height="16" />
					</a>
					<a href="_controller.cfm?action=verifyMailServer&mailServer=#mailServers[i].smtpserver#" 
						alt="Verify Mail Server" title="Verify Mail Server">
						<img src="../images/accept.png" border="0" width="16" height="16" />
					</a>
					<a href="javascript:void(0);" onclick="javascript:removeMailServer('#mailServers[i].smtpserver#');" 
						alt="Remove Mail Server" title="Remove Mail Server">
						<img src="../images/cancel.png" border="0" width="16" height="16" />
					</a>
				</td>
				<td>
					<cfif i eq 1>
						<img src="../images/asterisk_yellow.png" height="16" width="16" alt="Primary Mail Server" 
							title="Primary Mail Server" />
					</cfif>
					#mailServers[i].smtpserver#
				</td>
				<td>#mailServers[i].smtpport#</td>
				<td>
					<cfif mailServers[i].username is not "">
						Yes
					<cfelse>
						No
					</cfif>
				</td>
				<td width="200">
					<cfif structKeyExists(mailServers[i], "verified")>
						<cfif mailServers[i].verified>
							<img src="../images/tick.png" width="16" height="16" alt="Mail Server Verified" 
								title="Mail Server Verified" />
						<cfelseif not mailServers[i].verified>
							<img src="../images/exclamation.png" width="16" height="16" alt="Mail Server Verification Failed" 
								title="Mail Server Verification Failed" /><br />
							#mailServers[i].message#
						</cfif>
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			</tr>
		</cfloop>
			<tr bgcolor="##dedede">
				<td colspan="5">
					<input type="button" name="verifyAll" id="verifyAll" value="Verify All Mail Servers" 
							onclick="javascript:verifyAllMailServers()" tabindex="1" />
				</td>
			</tr>
		</table>
		</cfif>
		
		<br /><br />

		<cfif mailMessage is not "">
			<p class="#mailMessageType#">#mailMessage#</p>
		</cfif>
		
		<form name="mailServerForm" action="_controller.cfm?action=processMailServerForm" method="post" 
				onsubmit="javascript:return validateMailServerForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>#mailServerFormActionHeader# Mail Server</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="smtpserver">SMTP Server</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="smtpserver" id="smtpserver" size="40" value="#mailServer.smtpserver#" tabindex="2" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="smtpport">SMTP Port</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="smtpport" id="smtpport" size="3" maxlength="5" value="#mailServer.smtpport#" 
							tabindex="3" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="username">User Name</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="username" id="username" size="40" value="#mailServer.username#" 
							tabindex="4" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="password">Password</label></td>
				<td bgcolor="##ffffff">
					<input type="password" name="password" id="password" size="40" value="#mailServer.password#" 
							tabindex="5" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="isPrimary">Primary</label></td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="isPrimary" id="isPrimary" value="true"
							<cfif mailServer.isPrimary> checked="true"</cfif> tabindex="6" />&nbsp;
					(Note: if only one mail server is defined, it will always be primary)
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="testConnection">Test Connection</label></td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="testConnection" id="testConnection" value="true" tabindex="7" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" tabindex="8" /></td>
			</tr>
		</table>
			<input type="hidden" name="mailServerAction" value="#mailServerAction#">
			<input type="hidden" name="existingSMTPServer" value="#mailServer.smtpserver#" />
		</form>
		
		<br /><br />
		
		<form name="mailSettingsForm" action="_controller.cfm?action=processMailSettingsForm" method="post" 
				onsubmit="javascript:return validateMailSettingsForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Global Mail Settings</strong> (these settings apply to all registered mail servers)</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="timeout">Timeout</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="timeout" id="timeout" size="3" maxlength="3" value="#mailSettings.timeout#" 
							tabindex="9" /> seconds
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="threads">Mail Threads</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="threads" id="threads" size="3" maxlength="3" value="#mailSettings.threads#" 
							tabindex="10" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="interval">Spool Interval</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="interval" id="interval" size="3" maxlength="5" value="#mailSettings.interval#" 
							tabindex="11" /> seconds
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="charset">Default CFMAIL Character Set</label></td>
				<td bgcolor="##ffffff">
					<select name="charset" id="charset" tabindex="12">
					<cfloop collection="#charsets#" item="charset">
						<option value="#charset#"<cfif mailSettings.charset is charset> selected="true"</cfif>>#charset#</option>
					</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="usessl">Use SSL</label></td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="usessl" id="usessl" value="true" tabindex="13" 
							<cfif mailSettings.usessl>checked="true"</cfif> />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="usessl">Use TLS</label></td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="usetls" id="usetls" value="true" tabindex="14" 
							<cfif mailSettings.usetls>checked="true"</cfif> />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="charset">Default CFMAIL Domain</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="domain" id="domain" size="40" value="#mailSettings.domain#" 
							tabindex="15" /><br />
					(Note: This value is used in the "message-id" mail part and not related to SMTP.)
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" tabindex="16" /></td>
			</tr>
		</table>
		</form>
	</cfoutput>
	<cfset structDelete(session, "mailServer", false) />
	<cfset structDelete(session, "mailServerStatus", false) />
</cfsavecontent>