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

	<cffunction name="deleteMailServer" access="public" returntype="void" output="false" hint="">
		<cfthrow message="Not Implemented Yet" type="bluedragon.adminapi.Mail">
	</cffunction>

	<cffunction name="getAvailableMailCharsets" access="public" returntype="array" output="false" hint="Returns an array of the character sets available for Mail.">
		<cfobject type="java" action="create" name="charset" class="java.nio.charset.Charset">
		<cfreturn StructKeyArray(charset.availableCharsets()) />
	</cffunction>

	<cffunction name="getMailProperty" access="public" returntype="any" output="false" hint="Returns the value of specified mail property">
		<cfargument name="propertyName" required="true" type="any" hint="Valid Properties are:<ul><li>CharSet</li><li>Interval</li></ul>" />

		<cfif NOT ListFindNoCase("charset,interval", arguments.propertyName)>
			<cfthrow message="Invalid Mail Property: #arguments.propertyName#" type="bluedragon.adminapi.mail">
		</cfif>
		
		<cfset var localConfig = getConfig() />
		<cfset var returnValue = Evaluate("localConfig.cfmail." & LCase(arguments.propertyName)) />
		
		<cfreturn returnValue />
	</cffunction>

	<cffunction name="getMailServers" access="public" returntype="array" output="false" hint="">
		<cfthrow message="Not Implemented Yet" type="bluedragon.adminapi.mail">
	</cffunction>

	<cffunction name="setMailProperty" access="public" returntype="void" output="false" hint="Sets mail property to value specified">
		<cfargument name="propertyName" required="yes" hint="Valid Properties are:<ul><li>CharSet</li><li>Interval</li></ul>">
		<cfargument name="propertyValue" required="yes" hint="Value for the specified mail property">

		<cfset var localConfig = getConfig() />

		<cfswitch expression="#LCase(arguments.propertyName)#">
			<cfcase value="charset">
				<cfif ListFind(ArrayToList(getAvailableMailCharsets()), arguments.propertyValue)>
					<cfset localConfig.cfmail.charset = arguments.propertyValue />
				<cfelse>
					<cfthrow message="Unsupported Mail Charset: #arguments.propertyValue#" type="bluedragon.adminapi.mail">
				</cfif>
				
			</cfcase>
			<cfcase value="interval">
				<cfset localConfig.cfmail.interval = ToString(arguments.propertyValue) />
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="Invalid Mail Property: #arguments.propertyName#" type="bluedragon.adminapi.mail">
			</cfdefaultcase>
		</cfswitch>

		<cfset setConfig(localConfig) />
	</cffunction>

	<cffunction name="setMailServer" access="public" returntype="void" output="false" hint="Adds a new mail server">
		<cfargument name="server" type="string" required="true" hint="Name of mail server">
		<cfargument name="port" type="numeric" default="25" hint="Port number of mail server">

		<cfset var localConfig = getConfig() />
		<cfset localConfig.cfmail.smtpserver = arguments.server />
		<cfset localConfig.cfmail.smtpport = ToString(arguments.port) />
		<cfset setConfig(localConfig) />
	</cffunction>

</cfcomponent>