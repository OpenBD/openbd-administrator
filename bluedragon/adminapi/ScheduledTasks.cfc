<cfcomponent displayname="ScheduledTasks" 
		output="false" 
		extends="Base" 
		hint="Manages scheduled tasks - OpenBD Admin API">

	<cffunction name="getScheduledTasks" access="public" output="false" returntype="array" 
			hint="Returns an array of scheduled tasks, or a specific scheduled task based on the task name passed in">
		<cfargument name="task" type="string" required="false" hint="The name of the scheduled task to retrieve" />
		
		<cfset var localConfig = getConfig() />
		<cfset var tasks = arrayNew(1) />
		<cfset var returnArray = arrayNew(1) />
		<cfset var i = 0 />
		
		<cfif not structKeyExists(localConfig, "cfschedule") or not structKeyExists(localConfig.cfschedule, "task")>
			<cfthrow message="No scheduled tasks configured" type="bluedragon.adminapi.scheduledtasks" />
		<cfelse>
			<cfif structKeyExists(arguments, "task")>
				<cfset tasks = localConfig.cfschedule.task />
				
				<cfloop index="i" from="1" to="#arrayLen(tasks)#">
					<cfif compareNoCase(tasks[i].name, arguments.task) eq 0>
						<cfset returnArray[1] = tasks[i] />
						<cfreturn returnArray />
					</cfif>
				</cfloop>
			<cfelse>
				<cfreturn localConfig.cfschedule.task />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="setScheduledTask" access="public" output="false" returntype="void" 
			hint="Creates or updates a scheduled task">
		<cfargument name="task" type="string" required="true" hint="The scheduled task name" />
		<cfargument name="url" type="string" required="true" hint="The URL the scheduled task will call" />
		<cfargument name="startdate" type="string" required="true" hint="The start date for the scheduled task" />
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
		<cfargument name="action" type="string" required="false" default="create" hint="The action to take on the scheduled task (create or update)" />
		
		<cfif arguments.action is "create" and scheduledTaskExists(arguments.task)>
			<cfthrow type="bluedragon.adminapi.scheduledtasks" message="A scheduled task with that name already exists" />
		</cfif>
		
		<cfdump var="#arguments#" />
		<cfabort />
		
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
	</cffunction>
	
	<cffunction name="scheduledTaskExists" access="public" output="false" returntype="boolean" 
			hint="Returns a boolean indicating whether or not a scheduled task with the name passed in exists">
		<cfargument name="task" type="string" required="true" hint="The name of the scheduled task to run" />
		
		<cfset var localConfig = getConfig() />
		<cfset var exists = false />
		<cfset var tasks = arrayNew(1) />
		<cfset var i = 0 />
		
		<cfif structKeyExists(localConfig, "cfschedule") and structKeyExists(localConfig.cfschedule, "task")>
			<cfset tasks = localConfig.cfschedule.task />
			
			<cfloop index="i" from="1" to="#arrayLen(tasks)#">
				<cfif compareNoCase(tasks[i].name, arguments.task) eq 0>
					<cfset exists = true />
					<cfbreak />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn exists />
	</cffunction>
	
	<cffunction name="runScheduledTask" access="public" output="false" returntype="void" hint="Runs a scheduled task">
		<cfargument name="task" type="string" required="true" hint="The name of the scheduled task to run" />
		
		<cfschedule action="run" task="#arguments.task#" />
	</cffunction>
	
	<cffunction name="deleteScheduledTask" access="public" output="false" returntype="void" 
			hint="Deletes a scheduled task">
		<cfargument name="task" type="string" required="true" hint="The name of the scheduled task to delete" />
		
		<cfschedule action="delete" task="#arguments.task#" />
	</cffunction>

</cfcomponent>