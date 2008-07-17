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
		<cfargument name="component-cfc" type="string" required="true" hint="Path for the base CFC file for all CFCs" />
		
		<cfset var localConfig = getConfig() />
		<cfset var tempFile = "" />
		<cfset var tempPath = "" />
		
		<!--- do some trimming of the string values for good measure --->
		<cfscript>
			arguments.errorhandler = trim(arguments.errorhandler);
			arguments.missingtemplatehandler = trim(arguments.missingtemplatehandler);
			arguments.scriptsrc = trim(arguments.scriptsrc);
			arguments.tempdirectory = trim(arguments.tempdirectory);
			arguments["component-cfc"] = trim(arguments["component-cfc"]);
		</cfscript>
		
		<!--- need to make sure we can create a CFC if the user is setting component-cfc;
				this can still totally hose things up but they can always fix it via the XML file directly --->
		<cfif left(arguments["component-cfc"], 1) is "$">
			<cfset tempPath = right(arguments["component-cfc"], len(arguments["component-cfc"]) - 1) />
		<cfelse>
			<cfset tempPath = expandPath(arguments["component-cfc"]) />
		</cfif>
		
		<cftry>
			<cffile action="read" file="#tempPath#" variable="tempFile" />
			<cfcatch type="any">
				<cfthrow message="Cannot read the base CFC file. Please verify this setting." 
						type="bluedragon.adminapi.serversettings" />
			</cfcatch>
		</cftry>
		
		<!--- See if we can load the errorhandler, missingtemplatehandler, tempdirectory, and scriptsrc.
				Assuming it's just the openbd internals that need the $ to figure out how to handle
				the paths so we'll chop that off if it exists here just for validation purposes. --->
		<cfif arguments.errorhandler is not "">
			<cfif left(arguments.errorhandler, 1) is "$">
				<cfset tempPath = right(arguments.errorhandler, len(arguments.errorhandler) - 1) />
			<cfelse>
				<cfset tempPath = expandPath(arguments.errorhandler) />
			</cfif>
			<cftry>
				<cffile action="read" file="#tempPath#" variable="tempFile" />
				<cfcatch type="any">
					<cfthrow message="Cannot read the specified error handler. Please verify this setting." 
							type="bluedragon.adminapi.serversettings" />
				</cfcatch>
			</cftry>
		</cfif>
		
		<cfif arguments.missingtemplatehandler is not "">
			<cfif left(arguments.missingtemplatehandler, 1) is "$">
				<cfset tempPath = right(arguments.missingtemplatehandler, len(arguments.missingtemplatehandler) - 1) />
			<cfelse>
				<cfset tempPath = expandPath(arguments.missingtemplatehandler) />
			</cfif>
			<cftry>
				<cffile action="read" file="#tempPath#" variable="tempFile" />
				<cfcatch type="any">
					<cfthrow message="Cannot read the specified missing template handler. Please verify this setting." 
							type="bluedragon.adminapi.serversettings" />
				</cfcatch>
			</cftry>
		</cfif>
		
		<cfif arguments.tempdirectory is not "">
			<cfif left(arguments.tempdirectory, 1) is "$">
				<cfset tempPath = right(arguments.tempdirectory, len(arguments.tempdirectory) - 1) />
			<cfelse>
				<cfset tempPath = expandPath(arguments.tempdirectory) />
			</cfif>
			<cftry>
				<cfif not directoryExists(tempPath)>
					<cfthrow message="Cannot read the specified temp directory. Please verify this setting." 
							type="bluedragon.adminapi.serversettings" />
				</cfif>
				<cfcatch type="any">
					<cfthrow message="Cannot read the specified temp directory. Please verify this setting." 
							type="bluedragon.adminapi.serversettings" />
				</cfcatch>
			</cftry>
		</cfif>
		
		<cfif arguments.scriptsrc is not "">
			<cfif left(arguments.scriptsrc, 1) is "$">
				<cfset tempPath = right(arguments.scriptsrc, len(arguments.scriptsrc) - 1) />
			<cfelse>
				<cfset tempPath = expandPath(arguments.scriptsrc) />
			</cfif>
			<cftry>
				<cfif not directoryExists(tempPath)>
					<cfthrow message="Cannot read the specified script source directory. Please verify this setting." 
							type="bluedragon.adminapi.serversettings" />
				</cfif>
				<cfcatch type="any">
					<cfthrow message="Cannot read the specified script source directory. Please verify this setting." 
							type="bluedragon.adminapi.serversettings" />
				</cfcatch>
			</cftry>
		</cfif>
		
		<!--- set the settings and set the config --->
		<cfscript>
			localConfig.system.buffersize = ToString(arguments.buffersize);
			localConfig.system.whitespacecomp = ToString(arguments.whitespacecomp);
			localConfig.system.errorhandler = arguments.errorhandler;
			localConfig.system.missingtemplatehandler = arguments.missingtemplatehandler;
			localConfig.system.defaultcharset = arguments.defaultcharset;
			localConfig.system.scriptprotect = ToString(arguments.scriptprotect);
			localConfig.system.scriptsrc = arguments.scriptsrc;
			localConfig.system.tempdirectory = arguments.tempdirectory;
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
	
	<cffunction name="revertToPreviousSettings" access="public" output="false" returntype="void" 
			hint="Reverts to the previous server settings by replacing bluedragon.xml with 'lastfile' from the config file">
		<cfset var localConfig = getConfig() />
		<cfset var lastFile = "" />
		
		<cftry>
			<cffile action="read" file="#localConfig.system.lastfile#" variable="lastFile" />
			<cfcatch type="any">
				<cfthrow message="Could not read the previous configuration file." type="bluedragon.adminapi.serversettings" />
			</cfcatch>
		</cftry>
		
		<!--- TODO: finish implementing reverting to previous settings --->
	</cffunction>
	
	<cffunction name="getJVMProperties" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the JVM properties">
		<cfreturn createObject("java", "java.lang.System").getProperties() />
	</cffunction>
	
</cfcomponent>