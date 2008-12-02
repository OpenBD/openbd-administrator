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
		<cfset variables.api.version = "1.0" />
		<cfset variables.api.builddate = "20081114" />
		
		<!--- instantiate the udfs cfc here so it's available everywhere --->
		<cfset variables.udfs = createObject("component", "bluedragon.adminapi.utils.UDFs") />
		
		<!--- Grab some JVM specific information --->
		<cfset variables.separator.path = getJVMProperty("path.separator") />
		<cfset variables.separator.file = getJVMProperty("file.separator") />

		<cfif compareNoCase(left(getJVMProperty("os.name"), 7), "windows") eq 0>
			<cfset variables.isWindows = true />
		<cfelse>
			<cfset variables.isWindows = false />
		</cfif>

		<cfif not directoryExists(expandPath("/WEB-INF")) and getJVMProperty("jetty.home") is not "" 
				and getJVMProperty("jetty.home") is not "[null]">
			<cfset variables.isMultiContextJetty = true />
		<cfelse>
			<cfset variables.isMultiContextJetty = false />
		</cfif>
		
		<!--- Frequently used messages, should probably be moved to some internationalization routine (later, much later) --->
		<cfset variables.msg.NotImplemented = "Not Implemented Yet" />
		
		<cfset variables.msg.compatibility.NotImplemented = "Not yet implemented in OpenBD AdminAPI compatibility layer" />
		<cfset variables.msg.compatibility.Unsupported = "Unsupported by OpenBD AdminAPI compatibility layer" />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setConfig" access="package" output="false" returntype="void" roles="admin" 
			hint="Sets the server configuration and tells OpenBD to refresh its settings">
		<cfargument name="currentConfig" type="struct" required="true" 
				hint="The configuration struct, which is a struct representation of bluedragon.xml" />
		
		<cfset var admin = structNew() />
		
		<cflock scope="Server" type="exclusive" timeout="5">
			<cfset admin.server = duplicate(arguments.currentConfig) />
			<cfset admin.server.openbdadminapi.lastupdated = DateFormat(now(), "dd/mmm/yyyy") & " " & TimeFormat(now(), "HH:mm:ss") />
			<cfset admin.server.openbdadminapi.version = api.version />
			
			<cfset xmlConfig = createObject("java", "com.naryx.tagfusion.xmlConfig.xmlCFML").init(admin) />
			<cfset success = createObject("java", "com.naryx.tagfusion.cfm.engine.cfEngine").writeXmlFile(xmlConfig) />
		</cflock>
	</cffunction>

	<cffunction name="getConfig" access="package" output="false" returntype="struct" 
			hint="Returns a struct representation of the OpenBD server configuration (bluedragon.xml)">
		<cfset var admin = 0 />
		
		<cflock scope="Server" type="readonly" timeout="5">
			<cfset admin = createObject("java", "com.naryx.tagfusion.cfm.engine.cfEngine").getConfig().getCFMLData() />
		</cflock>

		<cfreturn admin.server />
	</cffunction>

	<cffunction name="getJVMProperty" access="public" output="false" returntype="any" 
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
	
	<cffunction name="getFileSeparator" access="public" output="false" returntype="string" 
			hint="Returns the platform-specific file separator">
		<cfreturn getJVMProperty("file.separator") />
	</cffunction>
	
	<cffunction name="getFullPath" access="public" output="false" returntype="string" 
			hint="Returns a platform-specific full path based on the full or relative path passed in">
		<cfargument name="thePath" type="string" required="true" />
		
		<cfset var fullPath = "" />
		
		<cfif left(arguments.thePath, 1) is "$">
			<cfset fullPath = right(arguments.thePath, len(arguments.thePath) - 1) />
		<cfelseif left(arguments.thePath, 1) is "/">
			<cfset fullPath = expandPath(arguments.thePath) />
		<cfelse>
			<cfset fullPath = arguments.thePath />
		</cfif>
		
		<cfreturn fullPath />
	</cffunction>
	
	<cffunction name="getIsMultContextJetty" access="public" output="false" returntype="boolean" roles="admin" 
			hint="Returns a boolean indicating whether or not this is running on the multi-context Jetty build">
		<cfreturn variables.isMultiContextJetty />
	</cffunction>
	
	<cffunction name="getAdminAPIInfo" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the basic information about the admin API (version and last build date)">
		<cfset var adminAPIInfo = structNew() />
		
		<cfset adminAPIInfo.version = variables.api.version />
		<cfset adminAPIInfo.builddate = variables.api.builddate />
		
		<cfreturn structCopy(adminAPIInfo) />
	</cffunction>
</cfcomponent>
