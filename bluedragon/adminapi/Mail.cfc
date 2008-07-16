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

	<cffunction name="saveMailSettings" access="public" output="false" returntype="void" hint="Saves mail settings">
		<cfargument name="smtpserver" type="string" required="true" hint="SMTP servers including backup servers" />
		<cfargument name="smtpport" type="numeric" required="true" hint="The SMTP port" />
		<cfargument name="timeout" type="numeric" required="true" hint="The connection timeout in seconds" />
		<cfargument name="threads" type="numeric" required="true" hint="The number of threads to be used by cfmail" />
		<cfargument name="interval" type="numeric" required="true" hint="The spool polling interval in seconds" />
		<cfargument name="charset" type="string" required="true" hint="The default charset used by cfmail" />
		
		<cfset var localConfig = getConfig() />
		
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
	
</cfcomponent>