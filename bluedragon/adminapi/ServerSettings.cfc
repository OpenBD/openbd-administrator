<cfcomponent displayname="ServerSettings" 
		output="false" 
		extends="Base" 
		hint="Manages server settings - OpenBD Admin API">
	
	<!--- PUBLIC METHODS --->
	<cffunction name="saveServerSettings" access="public" output="false" returntype="void" 
			hint="Saves updated server settings">
		<cfargument name="buffersize" type="numeric" required="true" hint="Response buffer size - 0 indicates to buffer the entire page" />
		<cfargument name="whitespacecomp" type="boolean" required="true" hint="Apply whitespace compression" />
		<cfargument name="errorhandler" type="string" required="true" hint="Path for the default error handler CFM template" />
		<cfargument name="missingtemplatehandler" type="string" required="true" hint="Path for the default missing template handler CFM template" />
		<cfargument name="defaultcharset" type="string" required="true" hint="The default character set" />
		<cfargument name="scriptprotect" type="boolean" required="true" hint="Apply global script protection - protects against cross-site scripting attacks" />
		<cfargument name="scriptsrc" type="string" required="true" hint="Default CFFORM script location" />
		<cfargument name="tempdirectory" type="string" required="true" hint="Default temp directory" />
		<cfargument name="assert" type="boolean" required="true" hint="Enable cfassert and assert()" />
		<cfargument name="component-cfc" type="string" required="true" hint="Path for the base CFC file for all CFCs" />
		
		<cfset var localConfig = getConfig() />
		<cfset var cfcFile = "" />
		
		<!--- need to make sure we can create a CFC if the user is setting component-cfc;
				this can still totally hose things up but they can always fix it via the XML file directly --->
		<cftry>
			<cffile action="read" file="#expandPath(arguments.component-cfc)#" variable="cfcFile" />
			<cfcatch type="any">
				<cfthrow message="Cannot read the base CFC file. Please verify this setting." type="bluedragon.adminapi.serversettings" />
			</cfcatch>
		</cftry>
		
		<!--- set the settings and set the config --->
		<cfscript>
			localConfig.system.buffersize = ToString(arguments.buffersize);
			localConfig.system.whitespacecomp = ToString(arguments.whitespacecomp);
			localConfig.system.errorhandler = arguments.errorhandler;
			localConfig.system.missingtemplatehandler = arguments.missingtemplatehandler;
			localConfig.system.defaultcharset = arguments.defaultcharset;
			localConfig.system.scriptprotect = ToString(argument.scriptprotect);
			localConfig.system.scriptsrc = arguments.scriptsrc;
			localConfig.system.tempdirectory = arguments.tempdirectory;
			localConfig.system.assert = ToString(arguments.assert);
			localConfig.system["component-cfc"] = arguments["component-cfc"];
			
			setConfig(localConfig);
		</cfscript>
	</cffunction>
	
	<cffunction name="getServerSettings" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the current server setting values">
		<cfset var localConfig = getConfig() />
		<cfset var updateConfig = false />
		
		<!--- some of the server settings may not be present in the xml file, so add the ones that don't exist --->
		<cfif not structKeyExists(localConfig.system, "scriptprotect")>
			<cfset localConfig.system.scriptprotect = "false" />
			<cfset updateConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.system, "scriptsrc")>
			<cfset localConfig.system.scriptsrc = "/bluedragon/scripts" />
			<cfset updateConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.system, "assert")>
			<cfset localConfig.system.assert = "false" />
			<cfset updateConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.system, "component-cfc")>
			<cfset localConfig.system["component-cfc"] = "/WEB-INF/bluedragon/component.cfc" />
			<cfset updateConfig = true />
		</cfif>
		
		<cfif updateConfig>
			<cfset setConfig(localConfig) />
		</cfif>
		
		<cfreturn structCopy(localConfig.system) />
	</cffunction>
	
	<cffunction name="getAvailableCharsets" access="public" output="false" returntype="struct" hint="Returns a struct containing the available charsets on the JVM">
		<cfreturn createObject("java", "java.nio.charset.Charset").availableCharsets() />
	</cffunction>
	
	<cffunction name="getDefaultCharset" access="public" output="false" returntype="string" hint="Returns the default charset for the JVM">
		<cfreturn createObject("java", "java.nio.charset.Charset").defaultCharset().name() />
	</cffunction>
	
</cfcomponent>