<!---
	Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
	
	Contributing Developers:
	David C. Epler - dcepler@dcepler.net
	Matt Woodward - matt@mattwoodward.com

	This file is part of of the Open BlueDragon Admin API.

	The Open BlueDragon Admin API is free software: you can redistribute 
	it and/or modify it under the terms of the GNU General Public License 
	as published by the Free Software Foundation, either version 3 of the 
	License, or (at your option) any later version.

	The Open BlueDragon Admin API is distributed in the hope that it will 
	be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
	General Public License for more details.
	
	You should have received a copy of the GNU General Public License 
	along with the Open BlueDragon Admin API.  If not, see 
	<http://www.gnu.org/licenses/>.
--->
<cfcomponent displayname="Mail" 
		output="false" 
		extends="Base" 
		hint="Manages mail settings - OpenBD Admin API">

	<cffunction name="getMailSettings" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the mail settings">
		<cfset var localConfig = getConfig() />
		<cfset var doSetConfig = false />

		<cfset checkLoginStatus() />
		
		<!--- some of the mail settings may not exist --->
		<cfif not structKeyExists(localConfig.cfmail, "charset")>
			<cfset localConfig.cfmail.charset = getDefaultCharset() />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.cfmail, "interval")>
			<cfset localConfig.cfmail.interval = "240" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.cfmail, "threads")>
			<cfset localConfig.cfmail.threads = "1" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.cfmail, "timeout")>
			<cfset localConfig.cfmail.timeout = "60" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif doSetConfig>
			<cfset setConfig(localConfig) />
		</cfif>
		
		<cfreturn localConfig.cfmail />
	</cffunction>
	
	<cffunction name="setMailSettings" access="public" output="false" returntype="void" 
			hint="Saves mail settings">
		<cfargument name="timeout" type="numeric" required="true" hint="The connection timeout in seconds" />
		<cfargument name="threads" type="numeric" required="true" hint="The number of threads to be used by cfmail" />
		<cfargument name="interval" type="numeric" required="true" hint="The spool polling interval in seconds" />
		<cfargument name="charset" type="string" required="true" hint="The default charset used by cfmail" />
		
		<cfset var localConfig = getConfig() />

		<cfset checkLoginStatus() />
		
		<cfscript>
			localConfig.cfmail.timeout = ToString(arguments.timeout);
			localConfig.cfmail.threads = ToString(arguments.threads);
			localConfig.cfmail.interval = ToString(arguments.interval);
			localConfig.cfmail.charset = arguments.charset;

			setConfig(localConfig);
		</cfscript>
 	</cffunction>
	
	<cffunction name="getMailServers" access="public" output="false" returntype="array" 
			hint="Returns specific mail server information or all the registered mail servers">
		<cfargument name="mailServer" type="string" required="false" default="" hint="The mail server to retrieve" />
		
		<cfset var mailServers = arrayNew(1) />
		<cfset var mailServerList = "" />
		<cfset var theMailServer = "" />
		<cfset var returnMailServer = structNew() />
		<cfset var tempMailServer = structNew() />
		<cfset var localConfig = getConfig() />
		<cfset var doSetConfig = false />
		<cfset var i = 0 />

		<cfset checkLoginStatus() />

		<!--- some of the mail settings may not exist --->
		<cfif not structKeyExists(localConfig.cfmail, "threads")>
			<cfset localConfig.cfmail.threads = "1" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.cfmail, "charset")>
			<cfset localConfig.cfmail.charset = getDefaultCharset() />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.cfmail, "timeout")>
			<cfset localConfig.cfmail.timeout = "60" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif doSetConfig>
			<cfset setConfig(localConfig) />
		</cfif>
		
		<cfset mailServerList = localConfig.cfmail.smtpserver />
		
		<cfloop index="i" from="1" to="#listLen(mailServerList)#">
			<cfset tempMailServer = structNew() />
			<cfset theMailServer = listGetAt(mailServerList, i) />
			
			<cfif i eq 1>
				<cfset tempMailServer.isPrimary = true />
			<cfelse>
				<cfset tempMailServer.isPrimary = false />
			</cfif>
			
			<!--- if the server info has been formatted using port, username, and password, need to handle it differently --->
			<cfif find("@", theMailServer) gt 0>
				<cfset tempMailServer.smtpserver = listFirst(listLast(theMailServer, "@"), ":") />
				<cfset tempMailServer.smtpport = listLast(listLast(theMailServer, "@"), ":") />
				<cfset tempMailServer.username = listFirst(listFirst(theMailServer, "@"), ":") />
				<cfset tempMailServer.password = listLast(listFirst(theMailServer, "@"), ":") />
				<cfset arrayAppend(mailServers, tempMailServer) />
			<cfelseif find(":", theMailServer) gt 0>
				<cfset tempMailServer.smtpserver = listFirst(theMailServer, ":") />
				<cfset tempMailServer.smtpport = listLast(theMailServer, ":") />
				<cfset tempMailServer.username = "" />
				<cfset tempMailServer.password = "" />
				<cfset arrayAppend(mailServers, tempMailServer) />
			<cfelse>
				<cfset tempMailServer.smtpserver = theMailServer />
				<cfset tempMailServer.smtpport = localConfig.cfmail.smtpport />
				<cfset tempMailServer.username = "" />
				<cfset tempMailServer.password = "" />
				<cfset arrayAppend(mailServers, tempMailServer) />
			</cfif>
			
			<cfif arguments.mailServer is not "" and findNoCase(arguments.mailServer, theMailServer) gt 0>
				<cfset returnMailServer = tempMailServer />
			</cfif>
		</cfloop>
		
		<cfif arguments.mailServer is not "" and not structIsEmpty(returnMailServer)>
			<cfset mailServers = arrayNew(1) />
			<cfset mailServers[1] = returnMailServer />
		<cfelseif arguments.mailServer is not "" and (not isStruct(returnMailServer) or structIsEmpty(returnMailServer))>
			<cfthrow message="Could not retrieve the mail server information" type="bluedragon.adminapi.mail" />
		</cfif>
		
		<cfreturn mailServers />
	</cffunction>

	<cffunction name="setMailServer" access="public" output="false" returntype="void" 
			hint="Creates or updates a mail server">
		<cfargument name="smtpserver" type="string" required="true" hint="The SMTP server DNS name or IP address" />
		<cfargument name="smtpport" type="numeric" required="false" hint="The SMTP port" />
		<cfargument name="username" type="string" required="false" default="" hint="The SMTP server user name" />
		<cfargument name="password" type="string" required="false" default="" hint="The SMTP server password" />
		<cfargument name="isPrimary" type="boolean" required="false" default="true" 
				hint="Boolean indicating whether or not this is the primary mail server" />
		<cfargument name="testConnection" type="boolean" required="false" default="false" 
				hint="Boolean indicating to test mail server connectivity" />
		<cfargument name="existingSMTPServer" type="string" required="false" default="" 
				hint="Existing SMTP server DNS name or IP address; used for updates" />
		<cfargument name="action" type="string" required="false" default="create" hint="Action to take (create or update)" />
		
		<cfset var localConfig = getConfig() />
		<cfset var mailServer = "" />
		<cfset var mailSession = 0 />
		<cfset var transport = 0 />
		<cfset var errorMessage = "" />
		<cfset var i = 0 />
		<cfset var doSetConfig = false />

		<cfset checkLoginStatus() />

		<!--- some of the mail settings may not exist --->
		<cfif not structKeyExists(localConfig.cfmail, "threads")>
			<cfset localConfig.cfmail.threads = "1" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.cfmail, "charset")>
			<cfset localConfig.cfmail.charset = getDefaultCharset() />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.cfmail, "timeout")>
			<cfset localConfig.cfmail.timeout = "60" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif doSetConfig>
			<cfset setConfig(localConfig) />
		</cfif>
		
		<!--- make sure the mail server doesn't already exist --->
		<cfif arguments.action is "create" and listContainsNoCase(localConfig.cfmail.smtpserver, arguments.smtpserver)>
			<cfthrow message="The mail server DNS name or IP address is already in the list of registered mail servers" 
					type="bluedragon.adminapi.mail" />
		</cfif>
		
		<!--- format the mail server information based on the arguments provided --->
		<cfset mailServer = arguments.smtpserver />
		
		<cfif structKeyExists(arguments, "smtpport")>
			<cfset mailServer = mailServer & ":" & arguments.smtpport />
		<cfelse>
			<cfset mailServer = mailServer & ":25" />
		</cfif>
		
		<cfif arguments.username is not "">
			<cfset mailServer = arguments.username & ":" & arguments.password & "@" & mailServer />
		</cfif>

		<!--- test the connection if necessary --->
		<cfif arguments.testConnection>
			<cftry>
				<cfset verifyMailServer(mailServer) />
				<cfcatch type="any">
					<cfrethrow />
				</cfcatch>
			</cftry>
		</cfif>
		
		<!--- if this is an update, delete the existing server --->
		<cfif arguments.action is "update">
			<cfset deleteMailServer(arguments.existingSMTPServer) />
			<cfset localConfig = getConfig() />
		</cfif>
		
		<!--- if this server is primary, prepend it to the list; otherwise append it to the list --->
		<cfif arguments.isPrimary>
			<cfset localConfig.cfmail.smtpserver = listPrepend(localConfig.cfmail.smtpserver, mailServer) />
		<cfelse>
			<cfset localConfig.cfmail.smtpserver = listAppend(localConfig.cfmail.smtpserver, mailServer) />
		</cfif>
		
		<cfset setConfig(localConfig) />
	</cffunction>
	
	<cffunction name="deleteMailServer" access="public" output="false" returntype="void" 
			hint="Deletes a mail server from the list of available mail servers">
		<cfargument name="mailServer" type="string" required="true" hint="The mail server to delete from the list of available mail servers" />
		
		<cfset var localConfig = getConfig() />

		<cfset checkLoginStatus() />
		
		<cfloop index="i" from="1" to="#listLen(localConfig.cfmail.smtpserver)#">
			<cfif findNoCase(arguments.mailServer, listGetAt(localConfig.cfmail.smtpserver, i))>
				<cfset localConfig.cfmail.smtpserver = listDeleteAt(localConfig.cfmail.smtpserver, i) />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfset setConfig(localConfig) />
	</cffunction>
	
	<cffunction name="verifyMailServer" access="public" output="false" 
			hint="Verifies a mail server by connecting to the server via a JavaMail session">
		<cfargument name="mailServer" type="string" required="true" hint="The mail server to verify, in format 'server', 'server:port', or 'user:pass@server:port'" />
		
		<cfset var mailSession = 0 />
		<cfset var transport = 0 />
		<cfset var theMailServer = "" />
		<cfset var port = 25 />
		<cfset var username = "" />
		<cfset var password = "" />

		<cfset checkLoginStatus() />
		
		<cfif find("@", arguments.mailServer)>
			<cfset theMailServer = listFirst(listLast(arguments.mailServer, "@"), ":") />
			<cfset port = listLast(listLast(arguments.mailServer, "@"), ":") />
			<cfset username = listFirst(listFirst(arguments.mailServer, "@"), ":") />
			<cfset password = listLast(listFirst(arguments.mailServer, "@"), ":") />
		<cfelseif find(":", arguments.mailServer)>
			<cfset theMailServer = listFirst(arguments.mailServer, ":") />
			<cfset port = listLast(arguments.mailServer, ":") />
		<cfelse>
			<cfset theMailServer = arguments.mailServer />
		</cfif>
		
		<cftry>
			<cfset mailSession = createObject("java", "javax.mail.Session").getDefaultInstance(createObject("java", "java.util.Properties").init()) />
			<cfset transport = mailSession.getTransport("smtp") />
			<cfset transport.connect(theMailServer, JavaCast("int", port), username, password) />
			<cfset transport.close() />
			<cfcatch type="any">
				<cfthrow message="Mail server verification failed: #CFCATCH.Message#" type="bluedragon.adminapi.mail" />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getSpooledMailCount" access="public" output="false" returntype="numeric" 
			hint="Returns the number of files currently in the mail spool. If this returns -1 it means an error occurred while reading the spool directory.">
		<cfset var spoolCount = 0 />
		<cfset var spoolDirList = 0 />
		<cfset var mailSpoolPath = getMailSpoolPath() />

		<cfset checkLoginStatus() />
		
		<cftry>
			<cfdirectory action="list" directory="#mailSpoolPath#" name="spoolDirList" filter="*.email" />
			<cfset spoolCount = spoolDirList.RecordCount />
			<cfcatch type="any">
				<cfset spoolCount = -1 />
			</cfcatch>
		</cftry>
		
		<cfreturn spoolCount />
	</cffunction>
	
	<cffunction name="getUndeliveredMailCount" access="public" output="false" returntype="numeric" 
			hint="Returns the number of files currently in the undelivered mail directory. If this returns -1 it means an error occurred while reading the undelivered directory.">
		<cfset var undeliveredCount = 0 />
		<cfset var undeliveredDirList = 0 />
		<cfset var undeliveredMailPath = getUndeliveredMailPath() />

		<cfset checkLoginStatus() />

		<cftry>
			<cfdirectory action="list" directory="#undeliveredMailPath#" name="undeliveredDirList" filter="*.email" />
			<cfset undeliveredCount = undeliveredDirList.RecordCount />
			<cfcatch type="any">
				<cfset undeliveredCount = -1 />
			</cfcatch>
		</cftry>
		
		<cfreturn undeliveredCount />
	</cffunction>
	
	<cffunction name="respoolUndeliveredMail" access="public" output="false" returntype="void" 
			hint="Moves all the mail in the undelivered directory to the spool">
		<cfset var undeliveredMail = 0 />
		<cfset var undeliveredMailPath = getUndeliveredMailPath() />
		<cfset var mailSpoolPath = getMailSpoolPath() />

		<cfset checkLoginStatus() />

		<cfdirectory action="list" directory="#undeliveredMailPath#" name="undeliveredMail" filter="*.email" />
		
		<cfif undeliveredMail.RecordCount gt 0>
			<cfloop query="undeliveredMail">
				<cfif fileExists("#undeliveredMailPath##variables.separator.file##undeliveredMail.name#")>
					<cffile action="move" 
							source="#undeliveredMailPath##variables.separator.file##undeliveredMail.name#" 
							destination="#mailSpoolPath##variables.separator.file##undeliveredMail.name#" />
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="triggerMailSpool" access="public" output="false" returntype="void" 
			hint="Triggers the mail spool by grabbing the first mail file in the spool, parsing it, and sending it using cfmail. Used mainly following a move of mail files to the spool.">
		<cfset var mailFiles = 0 />
		<cfset var mailFile = "" />
		
		<cfdirectory action="list" directory="#getMailSpoolPath()#" name="mailFiles" filter="*.email" />
		
		<cfif mailFiles.RecordCount gt 0>
			<!--- grab the first file; if it's not there anymore, chances are that means the spool is active 
					so just forget about priming things --->
			<cfif fileExists(getMailSpoolPath() & variables.separator.file & mailFiles.name)>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="getMailSpoolPath" access="public" output="false" returntype="string" 
			hint="Returns the mail spool path">
		<cfset var mailSpoolPath = "" />
		
		<cfset checkLoginStatus() />

		<cfif variables.isMultiContextJetty>
			<cfset mailSpoolPath = "#getJVMProperty('jetty.home')##variables.separator.file#logs#variables.separator.file#openbd#variables.separator.file#cfmail#variables.separator.file#spool" />
		<cfelse>
			<cfset mailSpoolPath = expandPath("/WEB-INF/bluedragon/work/cfmail/spool") />
		</cfif>
		
		<cfreturn mailSpoolPath />
	</cffunction>
	
	<cffunction name="getUndeliveredMailPath" access="public" output="false" returntype="string" 
			hint="Returns the undelievered mail path">
		<cfset var undeliveredMailPath = "" />

		<cfset checkLoginStatus() />
		
		<cfif variables.isMultiContextJetty>
			<cfset undeliveredMailPath = "#getJVMProperty('jetty.home')##variables.separator.file#logs#variables.separator.file#openbd#variables.separator.file#cfmail#variables.separator.file#undelivered" />
		<cfelse>
			<cfset undeliveredMailPath = expandPath("/WEB-INF/bluedragon/work/cfmail/undelivered") />
		</cfif>
		
		<cfreturn undeliveredMailPath />
	</cffunction>
</cfcomponent>