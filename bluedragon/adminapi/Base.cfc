<!--- TODO: need to come up with the copyright holder for this project --->
<!--- TODO: add gplv3 header on all the files --->
<!---
	Copyright (C) 2008  David C. Epler - dcepler@dcepler.net

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
<cfcomponent displayname="Base" 
		output="false" 
		hint="Base CFC for OpenBD Admin API CFCs">

	<cfset init() />

	<cffunction name="init" access="package" output="false" returntype="any" hint="Initialize base">
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

	<cffunction name="getSessionPassword" access="private" output="false" returntype="string" hint="Returns the session password">
		<cfreturn Decrypt(ToString(ToBinary(cookie.bdauthorization_)), "00CE55488350C475DC8A9FEAE82743FA") />
	</cffunction>

	<cffunction name="setSessionPassword" access="package" output="false" returntype="void" hint="Sets the session password">
		<cfargument name="adminPassword" type="string" required="true" hint="The administrator password" />
		<cfset cookie.bdauthorization_ = ToBase64(Encrypt(arguments.adminPassword, "00CE55488350C475DC8A9FEAE82743FA")) />
	</cffunction>
	
	<cffunction name="setConfig" access="package" output="false" returntype="void">
		<cfargument name="currentConfig" type="struct" required="true" hint="The configuration struct, which is a struct representation of bluedragon.xml" />
		
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

	<cffunction name="getConfig" access="package" output="false" returntype="struct">
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

	<cffunction name="isAdminUser" access="package" output="false" returntype="boolean">
		<cfif getSessionPassword() EQ "">
			<cfreturn FALSE />
		</cfif>
		<cfreturn TRUE />
	</cffunction>

	<cffunction name="getJVMProperty" access="package" output="false" returntype="any" hint="Retrieves a specific JVM property">
		<cfargument name="propertyName" type="string" required="true" />
		
		<cfset var jvmProperty = createObject("java", "java.lang.System") />
		
		<cfreturn jvmProperty.getProperty(arguments.propertyName) />
	</cffunction>
	
	<cffunction name="getAvailableCharsets" access="public" output="false" returntype="struct" hint="Returns a struct containing the available charsets on the JVM">
		<cfreturn createObject("java", "java.nio.charset.Charset").availableCharsets() />
	</cffunction>
	
	<cffunction name="getDefaultCharset" access="public" output="false" returntype="string" hint="Returns the default charset for the JVM">
		<cfreturn createObject("java", "java.nio.charset.Charset").defaultCharset().name() />
	</cffunction>
	
	<cffunction name="getAdminAPIInfo" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the basic information about the admin API (version and last build date)">
		<cfset var adminAPIInfo = structNew() />
		
		<cfset adminAPIInfo.version = variables.api.version />
		<cfset adminAPIInfo.builddate = variables.api.builddate />
		
		<cfreturn structCopy(adminAPIInfo) />
	</cffunction>

	<cffunction name="dump" access="package" output="true" returntype="void">
		<cfargument name="value" required="true">
		<cfdump var="#arguments.value#">
	</cffunction>
</cfcomponent>
