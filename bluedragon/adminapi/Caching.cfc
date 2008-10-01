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
	
	<cffunction name="setFileCacheSettings" access="public" output="false" returntype="void" 
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
	
	<cffunction name="setQueryCacheSettings" access="public" output="false" returntype="void" 
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
	
	<cffunction name="getNumFilesInCache" access="public" output="false" returntype="numeric" 
			hint="Returns the number of files in the file cache">
		<cfreturn createObject("java", "com.naryx.tagfusion.cfm.file.cfmlFileCache").filesInCache() />
	</cffunction>
	
	<cffunction name="getNumQueriesInCache" access="public" output="false" returntype="numeric" 
			hint="Returns the number of queries in the cache">
		<cfreturn createObject("java", "com.naryx.tagfusion.cfm.sql.cfQUERY").activeQueryCache.getNumberQueries() />
	</cffunction>
	
</cfcomponent>