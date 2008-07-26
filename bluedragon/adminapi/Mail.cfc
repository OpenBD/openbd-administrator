<!---
	Copyright (C) 2005  David C. Epler - dcepler@dcepler.net

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--->
<cfcomponent displayname="Mail" 
		output="false" 
		extends="Base" 
		hint="Manages mail settings - OpenBD Admin API">

	<cffunction name="getMailSettings" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the mail settings">
		<cfset var localConfig = getConfig() />
		<cfset var doSetConfig = false />
		
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
		
		<cfreturn localConfig.cfmail />
	</cffunction>

	<cffunction name="setMailSettings" access="public" output="false" returntype="void" hint="Saves mail settings">
		<cfargument name="smtpserver" type="string" required="true" 
				hint="Comma-delimited list of SMTP servers including backup servers" />
		<cfargument name="smtpport" type="numeric" required="true" hint="The SMTP port" />
		<cfargument name="timeout" type="numeric" required="true" hint="The connection timeout in seconds" />
		<cfargument name="threads" type="numeric" required="true" hint="The number of threads to be used by cfmail" />
		<cfargument name="interval" type="numeric" required="true" hint="The spool polling interval in seconds" />
		<cfargument name="charset" type="string" required="true" hint="The default charset used by cfmail" />
		<cfargument name="testConnection" type="boolean" required="false" default="false" 
				hint="Boolean indicating to test mail server connectivity" />
		
		<cfset var localConfig = getConfig() />
		<cfset var mailSession = 0 />
		<cfset var transport = 0 />
		<cfset var mailServer = 0 />
		<cfset var errorMessage = "" />
		
		<cfif arguments.testConnection>
			<!--- need to test all the servers --->
			<cfloop list="#arguments.smtpserver#" index="mailServer">
				<cftry>
					<cfset mailSession = createObject("java", "javax.mail.Session").getDefaultInstance(createObject("java", "java.util.Properties").init()) />
					<cfset transport = mailSession.getTransport("smtp") />
					<cfset transport.connect(mailServer, "", "") />
					<cfcatch type="any">
						<cfif errorMessage is "">
							<cfset errorMessage = "Mail server connection failed for the following mail server(s): " />
						</cfif>
						
						<cfset errorMessage = errorMessage & mailServer & ", " />
					</cfcatch>
				</cftry>
			</cfloop>
			
			<cfif errorMessage is not "">
				<cfset errorMessage = left(errorMessage, len(errorMessage) - 2) />
				<cfthrow message="#errorMessage#" type="bluedragon.adminapi.mail" />
			</cfif>
		</cfif>
		
		<cfscript>
			localConfig.cfmail.smtpserver = arguments.smtpserver;
			localConfig.cfmail.smtpport = ToString(arguments.smtpport);
			localConfig.cfmail.timeout = ToString(arguments.timeout);
			localConfig.cfmail.threads = ToString(arguments.threads);
			localConfig.cfmail.interval = ToString(arguments.interval);
			localConfig.cfmail.charset = arguments.charset;

			setConfig(localConfig);
		</cfscript>
 	</cffunction>
	
	<cffunction name="getSpooledMailCount" access="public" output="false" returntype="numeric" 
			hint="Returns the number of files currently in the mail spool. If this returns -1 it means an error occurred while reading the spool directory.">
		<cfset var spoolCount = 0 />
		<cfset var spoolDirList = 0 />
		
		<cftry>
			<cfdirectory action="list" directory="#ExpandPath('/WEB-INF/bluedragon/work/cfmail/spool')#" name="spoolDirList" />
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
		<cfset var undeliveredlDirList = 0 />
		
		<cftry>
			<cfdirectory action="list" directory="#ExpandPath('/WEB-INF/bluedragon/work/cfmail/undelivered')#" name="undeliveredDirList" />
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
		
		<cfdirectory action="list" directory="#expandPath('/WEB-INF/bluedragon/work/cfmail/undelivered')#" name="undeliveredMail" filter="*.email" />
		
		<cfif undeliveredMail.RecordCount gt 0>
			<cfloop query="undeliveredMail">
				<cffile action="move" source="#expandPath('/WEB-INF/bluedragon/work/cfmail/undelivered/#undeliveredMail.name#')#" 
						destination="#expandPath('/WEB-INF/bluedragon/work/cfmail/spool/#undeliveredMail.name#')#" />
			</cfloop>
		</cfif>
	</cffunction>
</cfcomponent>