<cfsilent>
	<cfparam name="scheduledTaskMessage" type="string" default="" />
	<cfparam name="scheduledTasks" type="array" default="#arrayNew(1)#" />
	<cfparam name="scheduledTaskAction" type="string" default="create" />
	<cfparam name="scheduledTaskActionLabel" type="string" default="Create a" />
	
	<cftry>
		<cfset scheduledTasks = Application.scheduledTasks.getScheduledTasks() />
		<cfcatch type="bluedragon.adminapi.scheduledtasks">
			<cfset scheduledTaskMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
	
	<cfif structKeyExists(session, "scheduledTask")>
		<cfset scheduledTask = session.scheduledTask />
		<cfset scheduledTaskAction = "update" />
		<cfset scheduledTaskActionLabel = "Edit">
	<cfelse>
		<cfscript>
			scheduledTask = structNew();
			scheduledTask.name = "";
			scheduledTask.urltouse = "";
			scheduledTask.porttouse = "";
			scheduledTask.tasktype = "";
			scheduledTask.startdate = "";
			scheduledTask.starttime = "";
			scheduledTask.enddate = "";
			scheduledTask.endtime = "";
			scheduledTask.interval = -1;
			scheduledTask.username = "";
			scheduledTask.password = "";
			scheduledTask.resolvelinks = false;
			scheduledTask.requesttimeout = "";
			scheduledTask.publish = false;
			scheduledTask.publishpath = "";
			scheduledTask.publishfile = "";
			scheduledTask.proxyserver = "";
			scheduledTask.proxyport = "";
		</cfscript>
	</cfif>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
		</script>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif scheduledTaskMessage is not "">
			<p class="message">#scheduledTaskMessage#</p>
		</cfif>
		
		<cfif arrayLen(scheduledTasks) gt 0>
			<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="100%">
				<tr bgcolor="##dedede">
					<td colspan="6"><strong>Scheduled Tasks</strong></td>
				</tr>
				<tr bgcolor="##dedede">
					<td width="100"><strong>Actions</strong></td>
					<td><strong>Task</strong></td>
					<td><strong>URL</strong></td>
					<td><strong>Interval</strong></td>
					<td><strong>Start Date/Time</strong></td>
					<td><strong>End Date/Time</strong></td>
				</tr>
			<cfloop index="i" from="1" to="#arrayLen(scheduledTasks)#">
				<tr bgcolor="##ffffff">
					<td>
						<a href="_controller.cfm?action=runScheduledTask&name=#scheduledTasks[i].name#" alt="Run Task" title="Run Task"><img src="../images/control_play_blue.png" border="0" width="16" height="16" /></a>
						<a href="_controller.cfm?action=pauseScheduledTask&name=#scheduledTasks[i].name#" alt="Pause Task" title="Pause Task"><img src="../images/control_pause_blue.png" border="0" width="16" height="16" /></a>
						<a href="_controller.cfm?action=editScheduledTask&name=#scheduledTasks[i].name#" alt="Edit Task" title="Edit Task"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
						<a href="javascript:void(0);" onclick="javascript:deleteTask('#scheduledTasks[i].name#');" alt="Delete Task" title="Delete Task"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
					</td>
					<td>#scheduledTasks[i].name#</td>
					<td>#scheduledTasks[i].urltouse#</td>
					<td>
						<cfif scheduledTasks[i].tasktype is not "">
							#lcase(scheduledTasks[i].tasktype)#
						<cfelse>
							every #scheduledTasks[i].interval# seconds
						</cfif>
					</td>
					<td>#scheduledTasks[i].startdate# #LSTimeFormat(scheduledTasks[i].starttime, "short")#</td>
					<td>#scheduledTasks[i].enddate#<cfif scheduledTasks[i].endtime is not "">#LSTimeFormat(scheduledTasks[i].endtime, "short")#</cfif></td>
				</tr>
			</cfloop>
			</table>
		</cfif>
		
		<br />
		
		<form name="scheduledTaskForm" action="_controller.cfm?action=processScheduledTaskForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>#scheduledTaskActionLabel# Scheduled Task</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Task Name</td>
				<td bgcolor="##ffffff">
					<input type="text" name="name" size="30" maxlength="50" value="#scheduledTask.name#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Duration</td>
				<td bgcolor="##ffffff">
					Start Date: <input type="text" name="startdate" size="10" maxlength="10" value="#scheduledTask.startdate#" />&nbsp;
					End Date: <input type="text" name="enddate" size="10" maxlength="10" value="#scheduledTask.enddate#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right" valign="top">Interval</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="runinterval" value="once"<cfif scheduledTask.tasktype is "ONCE" or scheduledTask.tasktype is ""> checked="true"</cfif> />
					One Time @ <input type="text" name="starttime_once" size="5" maxlength="5"<cfif scheduledTask.tasktype is "ONCE">value="#scheduledTask.starttime#"</cfif> /><br />
					<input type="radio" name="runinterval" value="recurring"<cfif (scheduledTask.tasktype is "DAILY" or scheduledTask.tasktype is "WEEKLY" or scheduledTask.tasktype is "MONTHLY") and scheduledTask.interval eq -1> checked="true"</cfif> />
					Recurring&nbsp;<select name="tasktype">
									<option value="">- select -</option>
									<option value="DAILY"<cfif scheduledTask.tasktype is "DAILY" and scheduledTask.interval eq -1> selected="true"</cfif>>daily</option>
									<option value="WEEKLY"<cfif scheduledTask.tasktype is "WEEKLY" and scheduledTask.interval eq -1> selected="true"</cfif>>weekly</option>
									<option value="MONTHLY"<cfif scheduledTask.tasktype is "MONTHLY" and scheduledTask.interval eq -1> selected="true"</cfif>>monthly</option>
								</select>&nbsp;@&nbsp;
					<input type="text" name="starttime_recurring" size="5" maxlength="5"<cfif scheduledTask.tasktype is "DAILY" or scheduledTask.tasktype is "WEEKLY" or scheduledTask.tasktype is "MONTHLY">value="#scheduledTask.starttime#"</cfif> /><br />
					<input type="radio" name="runinterval" value="daily"<cfif scheduledTask.tasktype is "DAILY" and scheduledTask.interval neq -1> checked="true"</cfif> />
					Daily every <input type="text" name="interval" size="5" maxlength="5"<cfif scheduledTask.tasktype is "DAILY" and scheduledTask.interval neq -1> value="#scheduledTask.interval#"</cfif> />&nbsp;
					seconds from <input type="text" name="starttime_daily" size="5" maxlength="5"<cfif scheduledTask.tasktype is "DAILY" and scheduledTask.interval neq -1> value="#scheduledTask.starttime#"</cfif> />&nbsp;
					to <input type="text" name="endtime_daily" size="5" maxlength="5"<cfif scheduledTask.tasktype is "DAILY" and scheduledTask.interval neq -1> value="#scheduledTask.endtime#"</cfif> />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Full URL</td>
				<td bgcolor="##ffffff">
					<input type="text" size="30"<cfif scheduledTask.urltouse is ""> value="http://"<cfelse> value="#scheduledTask.urltouse#"</cfif> />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Login Details</td>
				<td bgcolor="##ffffff">
					User Name: <input type="text" name="username" size="20" value="#scheduledTask.username#" />&nbsp;
					Password: <input type="password" name="password" size="20" value="#scheduledTask.password#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Proxy Server</td>
				<td bgcolor="##ffffff">
					<input type="text" name="proxyserver" size="30" value="#scheduledTask.proxyserver#" />&nbsp;
					Port <input type="text" name="proxyport" size="5" maxlength="5" value="#scheduledTask.proxyport#" /><!--- <br />
					User Name: <input type="text" name="proxyuser" size="20" value="#scheduledTask.proxyuser#" />&nbsp;
					Password: <input type="password" name="proxypassword" size="20" value="#scheduledTask.proxypassword#" /> --->
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right" valign="top">Publish Results to File</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="publishfile" value="true"<cfif scheduledTask.publishfile is not ""> checked="true"</cfif> />Yes&nbsp;
					<input type="radio" name="publishfile" value="false"<cfif scheduledTask.publishfile is ""> checked="true"</cfif> />No<br />
					<!--- TODO: add "Path is a URI?" checkbox if needed --->
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>Path:</td>
							<td><input type="text" name="publishpath" size="30" value="#scheduledTask.publishpath#" /></td>
						</tr>
						<tr>
							<td>File Name:</td>
							<td><input type="text" name="publishfile" size="30" value="#scheduledTask.publishfile#" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Resolve Internal URLs</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="resolvelinks" value="true"<cfif scheduledTask.resolvelinks> checked="true"</cfif> />Yes&nbsp;
					<input type="radio" name="resolvelinks" value="false"<cfif (isBoolean(scheduledTask.resolvelinks) and not scheduledTask.resolvelinks) or scheduledTask.resolvelinks is ""> checked="true"</cfif> />No
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Request Timeout</td>
				<td bgcolor="##ffffff">
					<input type="text" name="requesttimeout" size="5" maxlength="5" value="#scheduledTask.requesttimeout#" /> seconds
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" />
				</td>
			</tr>
		</table>
			<input type="hidden" name="action" value="#scheduledTaskAction#" />
			<input type="hidden" name="existingScheduledTaskName" value="#scheduledTask.name#" />
		</form>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "scheduledTask", false) />
</cfsavecontent>