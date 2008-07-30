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
		</script>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<h3>Mail Status</h3>
		
		<!--- TODO: add functionality to let user view/manage spooled and undelivered mail --->
		<ul>
			<li>Spooled Mail: #spoolCount# messages</li>
			<li>Undelivered Mail: #undeliveredCount# messages</li>
			<li><a href="_controller.cfm?action=respoolUndeliveredMail">Move All Undelivered Mail to Spool</a></li>
		</ul>
		
		<h3>Mail Servers</h3>
		
		<cfif arrayLen(mailServers) eq 0>
			<p><strong><em>No mail servers configured</em></strong></p>
		<cfelse>
		<table border="0" width="700" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td width="100"><strong>Actions</strong></td>
				<td><strong>Mail Server</strong></td>
				<td><strong>Port</strong></td>
				<td><strong>Using Login</strong></td>
				<td><strong>Status</strong></td>
			</tr>
		<cfloop index="i" from="1" to="#arrayLen(mailServers)#">
			<tr <cfif not structKeyExists(mailServers[i], "verified")>bgcolor="##ffffff"<cfelseif mailServers[i].verified>bgcolor="##ccffcc"<cfelseif not mailServers[i].verified>bgcolor="##ffff99"</cfif>>
				<td width="100">
					<a href="_controller.cfm?action=editMailServer&mailServer=#mailServers[i].smtpserver#" alt="Edit Mail Server" title="Edit Mail Server"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
					<a href="_controller.cfm?action=verifyMailServer&mailServer=#mailServers[i].smtpserver#" alt="Verify Mail Server" title="Verify Mail Server"><img src="../images/accept.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:removeMailServer('#mailServers[i].smtpserver#');" alt="Remove Mail Server" title="Remove Mail Server"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
				</td>
				<td>
					<cfif i eq 1>
						<img src="../images/asterisk_yellow.png" height="16" width="16" alt="Primary Mail Server" title="Primary Mail Server" />
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
							<img src="../images/tick.png" width="16" height="16" alt="Mail Server Verified" title="Mail Server Verified" />
						<cfelseif not mailServers[i].verified>
							<img src="../images/exclamation.png" width="16" height="16" alt="Mail Server Verification Failed" title="Mail Server Verification Failed" /><br />
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
					<input type="button" name="verifyAll" value="Verify All Mail Servers" onclick="javascript:verifyAllMailServers()" />
				</td>
			</tr>
		</table>
		</cfif>

		<h3>#mailServerFormActionHeader# Mail Server</h3>
		
		<cfif mailMessage is not "">
			<p class="message">#mailMessage#</p>
		</cfif>
		
		<cfif not mailAvailable>
			<p class="message">It appears that you do not hava JavaMail installed.</p>
			
			<p>
				Some Java application severs, such as <a href="http://tomcat.apache.org/">Tomcat</a>, do not ship with JavaMail. 
				Without JavaMail installed, Open BlueDragon is unable to send mail.
			</p>
			
			<p>
				Please download <a href="http://java.sun.com/products/javamail/downloads/index.html">JavaMail</a> and place 
				mail.jar in your classpath (either in your application server's shared lib directory, or in Open BlueDragon's 
				/WEB-INF/lib directory), and restart Open BlueDragon to enable mail functionality.
			</p>
		</cfif>

		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="message">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<form name="mailServerForm" action="_controller.cfm?action=processMailServerForm" method="post" onsubmit="javascript:return validateMailServerForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr>
				<td bgcolor="##f0f0f0" align="right">SMTP Server</td>
				<td bgcolor="##ffffff">
					<input type="text" name="smtpserver" size="40" value="#mailServer.smtpserver#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">SMTP Port</td>
				<td bgcolor="##ffffff">
					<input type="text" name="smtpport" size="3" maxlength="5" value="#mailServer.smtpport#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">User Name</td>
				<td bgcolor="##ffffff">
					<input type="text" name="username" size="40" value="#mailServer.username#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Password</td>
				<td bgcolor="##ffffff">
					<input type="password" name="password" size="40" value="#mailServer.password#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Primary</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="isPrimary" value="true"<cfif mailServer.isPrimary> checked="true"</cfif> />&nbsp;
					(Note: if only one mail server is defined, it will always be primary)
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Test Connection</td>
				<td bgcolor="##ffffff">
					<input type="checkbox" name="testConnection" value="true" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" /></td>
			</tr>
		</table>
			<input type="hidden" name="mailServerAction" value="#mailServerAction#">
			<input type="hidden" name="existingSMTPServer" value="#mailServer.smtpserver#" />
		</form>
		
		<h3>Global Mail Settings</h3>
		
		<p>These settings apply to all registered mail servers.</p>

		<form name="mailSettingsForm" action="_controller.cfm?action=processMailSettingsForm" method="post" onsubmit="javascript:return validateMailSettingsForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr>
				<td bgcolor="##f0f0f0" align="right">Timeout</td>
				<td bgcolor="##ffffff">
					<input type="text" name="timeout" size="3" maxlength="3" value="#mailSettings.timeout#" /> seconds
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Mail Threads</td>
				<td bgcolor="##ffffff">
					<input type="text" name="threads" size="3" maxlength="3" value="#mailSettings.threads#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Spool Interval</td>
				<td bgcolor="##ffffff">
					<input type="text" name="interval" size="3" maxlength="5" value="#mailSettings.interval#" /> seconds
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Default CFMAIL Character Set</td>
				<td bgcolor="##ffffff">
					<select name="charset">
					<cfloop collection="#charsets#" item="charset">
						<option value="#charset#"<cfif mailSettings.charset is charset> selected="true"</cfif>>#charset#</option>
					</cfloop>
					</select>
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
	<cfset structDelete(session, "mailServer", false) />
	<cfset structDelete(session, "mailServerStatus", false) />
</cfsavecontent>