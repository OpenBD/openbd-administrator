<cfcomponent displayname="VariableSettings" 
		output="false" 
		extends="Base" 
		hint="Manages variable settings - OpenBD Admin API">

	<cffunction name="getVariableSettings" access="public" output="false" returntype="struct" 
			hint="Returns an array containing the current variable settings">
		<cfset var localConfig = getConfig() />
		<cfset var doSetConfig = false />
		
		<!--- some of the cfapplication nodes may not exist --->
		<cfif not structKeyExists(localConfig.cfapplication, "clientpurgeenabled")>
			<cfset localConfig.cfapplication.clientpurgeenabled = "true" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.cfapplication, "cf5clientdata")>
			<cfset localConfig.cfapplication.cf5clientdata = "false" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.cfapplication, "clientexpiry")>
			<cfset localConfig.cfapplication.clientexpiry = "90" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif not structKeyExists(localConfig.cfapplication, "clientGlobalUpdatesDisabled")>
			<cfset localConfig.cfapplication.clientGlobalUpdatesDisabled = "true" />
			<cfset doSetConfig = true />
		</cfif>
		
		<cfif doSetConfig>
			<cfset setConfig(localConfig) />
		</cfif>
		
		<cfreturn structCopy(localConfig.cfapplication) />
	</cffunction>


</cfcomponent>