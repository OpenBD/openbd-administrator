<cfcomponent displayname="Chart" 
		output="false" 
		extends="Base" 
		hint="Manages chart settings - OpenBD Admin API">

	<cffunction name="getChartSettings" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the chart settings">
		<cfset var localConfig = getConfig() />
		
		<!--- cfchart section may not exist --->
		<cfif not structKeyExists(localConfig, "cfchart")>
			<cfset localConfig.cfchart = structNew() />
			<cfset localConfig.cfchart.cachesize = "1000" />
			<cfset localConfig.cfchart.storage = "file" />
			<cfset setConfig(localConfig) />
		</cfif>
		
		<cfreturn structCopy(localConfig.cfchart) />
	</cffunction>
	
	<cffunction name="saveChartSettings" access="public" output="false" returntype="void" 
			hint="Saves the chart settings">
	</cffunction>

</cfcomponent>