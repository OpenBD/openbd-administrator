<cfsilent>
	<cfparam name="mailMessage" type="string" default="" />
	<cfparam name="mailAvailable" type="boolean" default="true" />
	<cfparam name="spoolCount" type="numeric" default="-1" />
	<cfparam name="undeliveredCount" type="numeric" default="-1" />
	
	<cftry>
		<cfset mailSettings = Application.mail.getMailSettings() />
		<cfset charsets = Application.mail.getAvailableCharsets() />
		
		<cfcatch type="bluedragon.adminapi.mail">
			<cfset variableMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
	
	<cfif listLen(mailSettings.smtpserver, ",") gt 1>
		<cfset primarySMTPServer = listFirst(mailSettings.smtpserver) />
		<cfset backupSMTPServers = listRest(mailSettings.smtpserver) />
	<cfelse>
		<cfset primarySMTPServer = mailSettings.smtpserver />
		<cfset backupSMTPServers = "" />
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
			function validate(f) {
				if (f.smtpport.value != parseInt(f.smtpport.value)) {
					alert("The value of SMTP Port is not numeric");
					return false;
				} else if (f.timeout.value != parseInt(f.timeout.value)) {
					alert("The value of Timeout is not numeric");
					return false;
				} else if (f.threads.value != parseInt(f.threads.value)) {
					alert("The value of Mail Threads is not numeric");
					return false;
				} else if (f.interval.value != parseInt(f.interval.value)) {
					alert("The value of Spool Interval is not numeric");
				} else {
					return true;
				}
			}
		</script>
		
		<h3>Mail Settings</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
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
				/WEB-INF/lib directory) and restart Open BlueDragon to enable mail functionality.
			</p>
		</cfif>
		
		<form name="mailForm" action="_controller.cfm?action=processMailForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr>
				<td bgcolor="##f0f0f0" align="right">SMTP Server</td>
				<td bgcolor="##ffffff">
					<input type="text" name="smtpserver" size="40" value="#primarySMTPServer#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">SMTP Port</td>
				<td bgcolor="##ffffff">
					<input type="text" name="smtpport" size="3" maxlength="5" value="#mailSettings.smtpport#" />
				</td>
			</tr>
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
			<tr>
				<td bgcolor="##f0f0f0" align="right">Backup SMTP Server(s)</td>
				<td bgcolor="##ffffff">
					<input type="text" name="backupsmtpservers" size="40" value="#backupSMTPServers#" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" /></td>
			</tr>
		</table>
		</form>
		
		<h3>Mail Status</h3>
		
		<!--- TODO: add functionality to let user view/manage spooled and undelivered mail --->
		<ul>
			<li>Spooled Mail: #spoolCount# messages</li>
			<li>Undelivered Mail: #undeliveredCount# messages</li>
			<li><a href="_controller.cfm?action=respoolUndeliveredMail">Move All Undelivered Mail to Spool</a></li>
		</ul>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>