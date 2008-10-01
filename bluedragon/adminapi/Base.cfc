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
<cfcomponent displayname="Base" 
		output="false" 
		hint="Base CFC for OpenBD Admin API CFCs">

	<cfset init() />

	<cffunction name="init" access="package" output="false" returntype="any" hint="Constructor">
		<cfset variables.api.version = "0.1a" />
		<cfset variables.api.builddate = "20080710" />

		<!--- Grab some JVM specific information (no guessing or hacks) --->
		<cfset variables.separator.path = getJVMProperty("path.separator") />
		<cfset variables.separator.file = getJVMProperty("file.separator") />
		
		<!--- Frequently used messages, should probably be moved to some internationalization routine (later, much later) --->
		<cfset variables.msg.NotImplemented = "Not Implemented Yet" />
		
		<cfset variables.msg.compatibility.NotImplemented = "Not implemented yet by OpenBD AdminAPI compatibility layer" />
		<cfset variables.msg.compatibility.Unsupported = "Unsupported by OpenBD AdminAPI Compatibility Layer" />

		<cfreturn this />
	</cffunction>

	<cffunction name="getSessionPassword" access="private" output="false" returntype="string" 
			hint="Returns the session password">
		<cfreturn Decrypt(ToString(ToBinary(cookie.bdauthorization_)), "00CE55488350C475DC8A9FEAE82743FA") />
	</cffunction>

	<cffunction name="setSessionPassword" access="package" output="false" returntype="void" 
			hint="Sets the session password">
		<cfargument name="adminPassword" type="string" required="true" hint="The administrator password" />
		<cfset cookie.bdauthorization_ = ToBase64(Encrypt(arguments.adminPassword, "00CE55488350C475DC8A9FEAE82743FA")) />
	</cffunction>
	
	<cffunction name="setConfig" access="package" output="false" returntype="void" 
			hint="Sets the server configuration and tells OpenBD to refresh its settings">
		<cfargument name="currentConfig" type="struct" required="true" 
				hint="The configuration struct, which is a struct representation of bluedragon.xml" />
		
		<!--- <cfif isAdminUser()> --->
			<cflock scope="Server" type="exclusive" timeout="5">
				<cfset admin.server = duplicate(arguments.currentConfig) />
				<cfset admin.server.openbdadminapi.lastupdated = DateFormat(now(), "dd/mmm/yyyy") & " " & TimeFormat(now(), "HH:mm:ss") />
				<cfset admin.server.openbdadminapi.version = api.version />
				
				<cfset xmlConfig = createObject("java", "com.naryx.tagfusion.xmlConfig.xmlCFML").init(admin) />
				<cfset success = createObject("java", "com.naryx.tagfusion.cfm.engine.cfEngine").writeXmlFile(xmlConfig) />

				<!--- <cfadmin password="#getSessionPassword()#" action="write"> --->
			</cflock>
<!---
		<cfelse>
			<cfthrow message="Not Authorized" type="bluedragon.adminapi">
		</cfif>
--->
	</cffunction>

	<cffunction name="getConfig" access="package" output="false" returntype="struct" 
			hint="Returns a struct representation of the OpenBD server configuration (bluedragon.xml)">
		<cfset var admin = "" />
		
		<!---<cfif isAdminUser()> --->
			<cflock scope="Server" type="readonly" timeout="5">
				<cfset admin = createObject("java", "com.naryx.tagfusion.cfm.engine.cfEngine").getConfig().getCFMLData() />
				<!--- <cfadmin password="#getSessionPassword()#" action="read"> --->
			</cflock>
<!---			
		<cfelse>
			<cfthrow message="Not Authorized" type="bluedragon.adminapi">
		</cfif>
--->
		<cfreturn admin.server />
	</cffunction>

	<cffunction name="isAdminUser" access="package" output="false" returntype="boolean" 
			hint="Returns a boolean indicating whether or not an admin user is logged in">
		<cfif getSessionPassword() EQ "">
			<cfreturn false />
		</cfif>
		<cfreturn true />
	</cffunction>

	<cffunction name="getJVMProperty" access="package" output="false" returntype="any" 
			hint="Retrieves a specific JVM property">
		<cfargument name="propertyName" type="string" required="true" hint="The JVM property to return" />
		
		<cfreturn createObject("java", "java.lang.System").getProperty(arguments.propertyName) />
	</cffunction>

	<cffunction name="getJVMProperties" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the JVM properties">
		<cfreturn createObject("java", "java.lang.System").getProperties() />
	</cffunction>
	
	<cffunction name="getAvailableCharsets" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the available charsets on the JVM">
		<cfreturn createObject("java", "java.nio.charset.Charset").availableCharsets() />
	</cffunction>
	
	<cffunction name="getDefaultCharset" access="public" output="false" returntype="string" 
			hint="Returns the default charset for the JVM">
		<cfreturn createObject("java", "java.nio.charset.Charset").defaultCharset().name() />
	</cffunction>
	
	<cffunction name="getAdminAPIInfo" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the basic information about the admin API (version and last build date)">
		<cfset var adminAPIInfo = structNew() />
		
		<cfset adminAPIInfo.version = variables.api.version />
		<cfset adminAPIInfo.builddate = variables.api.builddate />
		
		<cfreturn structCopy(adminAPIInfo) />
	</cffunction>

	<cffunction name="dump" access="package" output="true" returntype="void" 
			hint="Dumps whatever variable is passed in">
		<cfargument name="value" type="any" required="true" hint="The variable to dump" />
		<cfdump var="#arguments.value#" />
	</cffunction>
</cfcomponent>
