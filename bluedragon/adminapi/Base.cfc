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

	<cffunction access="package" name="init" output="false" returntype="any" displayname="init" hint="Initialize base">

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

	<!---
	
	--->
	<cffunction access="private" name="getSessionPassword" output="false" returntype="string">
		<cfreturn Decrypt(ToString(ToBinary(cookie.bdauthorization_)), "00CE55488350C475DC8A9FEAE82743FA") />
	</cffunction>

	<!---
	
	--->
	<cffunction access="package" name="setSessionPassword" output="false" returntype="void">
		<cfargument name="adminPassword" type="string" required="yes">
		<cfset cookie.bdauthorization_ = ToBase64(Encrypt(arguments.adminPassword, "00CE55488350C475DC8A9FEAE82743FA")) />
	</cffunction>
	
	<!---
	
	--->
	<cffunction access="package" name="setConfig" output="false" returntype="void">
		<cfargument name="currentConfig" type="variableName" required="yes">
		
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

	<!---
	
	--->
	<cffunction access="package" name="getConfig" output="false" returntype="struct">
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

	<!---
	
	--->
	<cffunction access="package" name="isAdminUser" output="false" returntype="boolean">
		<cfif getSessionPassword() EQ "">
			<cfreturn FALSE />
		</cfif>
		<cfreturn TRUE />
	</cffunction>

	<!---
	
	--->
	<cffunction access="package" name="getJVMProperty" output="false" returntype="any">
		<cfargument name="propertyName" type="string" required="true" />
		<cfobject type="java" action="create" name="jvmProperty" class="java.lang.System">
		<cfreturn jvmProperty.getProperty(arguments.propertyName) />
	</cffunction>
	
	<!---
	
	--->
	<cffunction access="package" name="dump" output="true" returntype="void">
		<cfargument name="value" required="yes">
		<cfdump var="#arguments.value#">
	</cffunction>
	
</cfcomponent>
