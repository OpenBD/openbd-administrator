<cfcomponent displayname="Caching" 
		output="false" 
		extends="Base" 
		hint="Manages caching - OpenBD Admin API">

	<cffunction name="getCachingSettings" access="public" output="false" returntype="struct" 
			hint="Returns an array containing the current caching settings (file, query, and current cache status).">
		<cfset var cachingSettings = structNew() />
		<cfset var localConfig = getConfig() />
		<cfset var doSetConfig = false />
		
		<!--- cfquery node may not exist --->
		<cfif NOT StructKeyExists(localConfig, "cfquery")>
			<cfset localConfig.cfquery = structNew() />
			<cfset localConfig.cfquery.cachecount = "1000" />
			<cfset doSetConfig = true />
		<cfelseif NOT StructKeyExists(localConfig.cfquery, "cachecount")>
			<cfset localConfig.cfquery.cachecount = "1000" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfset cachingSettings.cfquery.cachecount = localConfig.cfquery.cachecount />
		
		<!--- file node may not exist --->
		<cfif not structKeyExists(localConfig, "file")>
			<cfset localConfig.file = structNew() />
			<cfset localConfig.maxfiles = "1000" />
			<cfset localConfig.trustcache = "false" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.file, "maxfiles")>
			<cfset localConfig.file.maxfiles = "1000" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.file, "trustcache")>
			<cfset localConfig.file.trustcache = "false" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfset cachingSettings.file.maxfiles = localConfig.file.maxfiles />
		<cfset cachingSettings.file.trustcache = localConfig.file.trustcache />
		
		<cfif doSetConfig>
			<cfset setConfig(localConfig) />
		</cfif>
		
		<cfreturn structCopy(cachingSettings) />
	</cffunction>
	
	<cffunction name="saveFileCacheSettings" access="public" output="false" returntype="void" 
			hint="Updates the file cache settings">
		<cfargument name="maxfiles" type="numeric" required="true" hint="The maximum number of files to cache" />
		<cfargument name="trustcache" type="boolean" required="true" hint="Enable/disable trusted cache" />
		
		<cfset var localConfig = getConfig() />
		
		<cfif find(".", arguments.maxfiles) neq 0 or not isNumeric(arguments.maxfiles)>
			<cfthrow message="The value of the file cache count is not numeric" 
					type="bluedragon.adminapi.caching" />
		</cfif>
		
		<cfset localConfig.file.maxfiles = ToString(arguments.maxfiles) />
		<cfset localConfig.file.trustcache = ToString(arguments.trustcache) />
		
		<cfset setConfig(localConfig) />
	</cffunction>
	
	<cffunction name="saveQueryCacheSettings" access="public" output="false" returntype="void" 
			hint="Updates the query cache settings">
		<cfargument name="cachecount" type="numeric" required="true" hint="The maximum number of queries to cache" />
		
		<cfset var localConfig = getConfig() />
		
		<cfif find(".", arguments.cachecount) neq 0 or not isNumeric(arguments.cachecount)>
			<cfthrow message="The value of the query cache count is not numeric" 
					type="bluedragon.adminapi.caching" />
		</cfif>
		
		<cfset localConfig.cfquery.cachecount = ToString(arguments.cachecount) />
		
		<cfset setConfig(localConfig) />
	</cffunction>

</cfcomponent>