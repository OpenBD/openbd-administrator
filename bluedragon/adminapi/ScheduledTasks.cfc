<cfcomponent displayname="ScheduledTasks" 
		output="false" 
		extends="Base" 
		hint="Manages scheduled tasks - OpenBD Admin API">

	<cffunction name="getScheduledTasks" access="public" output="false" returntype="array" 
			hint="Returns an array of scheduled tasks">
		<cfset var localConfig = getConfig() />
		
		<cfif not structKeyExists(localConfig, "cfschedule") or not structKeyExists(localConfig.cfschedule, "task")>
			<cfthrow message="No scheduled tasks configured" type="bluedragon.adminapi.scheduledtasks" />
		<cfelse>
			<cfreturn localConfig.cfschedule.task />
		</cfif>
	</cffunction>

</cfcomponent>