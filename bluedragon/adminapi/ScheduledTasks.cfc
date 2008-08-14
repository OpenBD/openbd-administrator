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
	
	<cffunction name="setScheduledTask" access="public" output="false" returntype="void" 
			hint="Creates or updates a scheduled task">
		<cfargument name="task" type="string" required="true" hint="The scheduled task name" />
		<cfargument name="url" type="string" required="true" hint="The URL the scheduled task will call" />
		<cfargument name="startdate" type="date" required="true" hint="The start date for the scheduled task" />
		<cfargument name="starttime" type="string" required="true" hint="The start time for the scheduled task" />
		<cfargument name="interval" type="string" required="true" 
				hint="The interval at which to run the scheduled task (number of seconds, once, daily, weekly, or monthly)" />
		<cfargument name="enddate" type="string" required="false" default="" hint="The end date for the scheduled task" />
		<cfargument name="endtime" type="string" required="false" default="" hint="The end time for the scheduled task" />
		<cfargument name="username" type="string" required="false" default="" hint="User name required by the URL being called by the scheduled task" />
		<cfargument name="password" type="string" required="false" default="" hint="Password required by the URL being called by the scheduled task" />
		<cfargument name="proxyserver" type="string" required="false" default="" hint="Proxy server to use for the scheduled task" />
		<cfargument name="proxyport" type="string" required="false" default="" hint="Proxy server port to use for the scheduled task" />
		<cfargument name="publish" type="boolean" required="false" default="false" 
				hint="Boolean indicating whether or not to publish the results of the scheduled task to a file" />
		<cfargument name="path" type="string" required="false" default="" hint="The path to which to publish the results of the scheduled task" />
		<cfargument name="uridirectory" type="boolean" required="false" default="false" 
				hint="Boolean indicating whether or not the path to which the file will be published is relative (true) or absolute (false)" />
		<cfargument name="file" type="string" required="false" default="" hint="The file name to which to publish the results of the scheduled task" />
		<cfargument name="resolveurl" type="boolean" required="false" default="false" 
				hint="Boolean indicating whether or not to resolve internal URLs to full URLs" />
		<cfargument name="requesttimeout" type="numeric" required="false" default="30" hint="The request timeout for the scheduled task" />
		
		<cftry>
			<cfschedule action="update" 
						task="#arguments.task#" 
						url="#arguments.url#" 
						operation="HTTPRequest" 
						startdate="#arguments.startdate#" 
						starttime="#arguments.starttime#" 
						interval="#arguments.interval#" 
						enddate="#arguments.enddate#" 
						endtime="#arguments.endtime#" 
						username="#arguments.username#" 
						password="#arguments.password#" 
						proxyserver="#arguments.proxyserver#" 
						proxyport="#arguments.proxyport#" 
						publish="#arguments.publish#" 
						path="#arguments.path#" 
						uridirectory="#arguments.uridirectory#" 
						file="#arguments.file#" 
						resolveurl="#arguments.resolveurl#" 
						requesttimeout="#arguments.requesttimeout#" />
			<cfcatch type="any">
				<cfthrow type="bluedragon.adminapi.scheduledtasks" message="#CFCATCH.Message#" />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="deleteScheduledTask" access="public" output="false" returntype="void" 
			hint="Deletes a scheduled task">
		<cfargument name="task" type="string" required="true" hint="The name of the scheduled task to delete" />
		
		<cftry>
			<cfschedule action="delete" task="#arguments.task#" />
			<cfcatch type="any">
				<cfthrow type="bluedragon.adminapi.scheduledtasks" message="#CFCATCH.Message#" />
			</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>