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
			function validate(f) {
				var timeCheck =  /(00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23):(0|1|2|3|4|5)\d{1}/;
				var dateCheck =  /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
				var numericCheck = /^\d{1,}$/;
				var urlCheck = /^(http|https|ftp):\/\//;
				var runIntervalValue = "";
				
				for (var i = 0; i < f.runinterval.length; i++) {
					if (f.runinterval[i].checked) {
						runIntervalValue = f.runinterval[i].value;
					}
				}
				
				if (f.name.value.length == 0) {
					alert("Please enter the task name");
					return false;
				} else if (f.urltouse.value.length == 0 || !urlCheck.test(f.urltouse.value)) {
					alert("Please enter a valid URL");
					return false;
				} else if (f.startdate.value.length > 0 && !dateCheck.test(f.startdate.value)) {
					alert("Please enter a valid start date");
					return false;
				} else if (f.starttime_duration.value.length == 0 && f.starttime_once.value.length == 0) {
					alert("Please enter a valid start time");
					return false;
				} else if (f.starttime_duration.value.length > 0 && !timeCheck.test(f.starttime_duration.value)) {
					alert("Please enter a valid start time");
					return false;
				} else if (f.enddate.value.length > 0 && !dateCheck(f.enddate.value)) {
					alert("Please enter a valid end date");
					return false;
				} else if (f.endtime_duration.value.length > 0 && !timeCheck.test(f.endtime_duration.value)) {
					alert("Please enter a valid end time");
					return false;
				} else if (runIntervalValue == "once" && (f.starttime_once.value.length == 0 || !timeCheck.test(f.starttime_once.value))) {
					alert("Please enter a valid start time for the one-time task");
					return false;
				} else if (runIntervalValue == "recurring" && f.tasktype.value == "") {
					alert("Please select the interval for the recurring task");
					return false;
				} else if (runIntervalValue == "recurring" && (f.starttime_recurring.value.length == 0 || !timeCheck.test(f.starttime_recurring.value))) {
					alert("Please enter a valid start time for the recurring task");
					return false;
				} else if (runIntervalValue == "daily" && (f.interval.value.length == 0 || !numericCheck(f.interval.value) || f.interval.value > 86400)) {
					alert("Please enter a valid number of seconds for the daily task.\nThis number may not exceed 86400.");
					return false;
				} else if (f.starttime_daily.value.length > 0 && !timeCheck.test(f.starttime_daily.value)) {
					alert("Please enter a valid start time for the daily task");
					return false;
				} else if (f.endtime_daily.value.length > 0 && !timeCheck.test(f.endtime_daily.value)) {
					alert("Please enter a valid end time for the daily task");
					return false;
				} else if (f.publish[0].checked && (f.publishpath.value.length == 0 || f.publishfile.value.length == 0)) {
					alert("Please enter a path and file name to which to publish the file");
					return false;
				} else if (f.requesttimeout.value.length > 0 && !numericCheck.test(f.requesttimeout.value)) {
					alert("Please enter a numeric value for request timeout");
					return false;
				}
				
				return true;
			}
			
			function deleteScheduledTask(task) {
				if(confirm("Are you sure you want to delete this scheduled task?")) {
					location.replace("_controller.cfm?action=deleteScheduledTask&name=" + task);
				}
			}
		</script>
		
		<h3>Scheduled Tasks</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif scheduledTaskMessage is not "">
			<p class="message">#scheduledTaskMessage#</p>
		</cfif>
		
		<cfif arrayLen(scheduledTasks) gt 0>
			<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="100%">
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
						<!--- TODO: enable this once 'pause' is added as an action for scheduled tasks in the engine <a href="_controller.cfm?action=pauseScheduledTask&name=#scheduledTasks[i].name#" alt="Pause Task" title="Pause Task"><img src="../images/control_pause_blue.png" border="0" width="16" height="16" /></a> --->
						<a href="_controller.cfm?action=editScheduledTask&name=#scheduledTasks[i].name#" alt="Edit Task" title="Edit Task"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
						<a href="javascript:void(0);" onclick="javascript:deleteScheduledTask('#scheduledTasks[i].name#');" alt="Delete Task" title="Delete Task"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
					</td>
					<td>#scheduledTasks[i].name#</td>
					<td>#scheduledTasks[i].urltouse#</td>
					<td>
						<cfif structKeyExists(scheduledTasks[i], "tasktype") and scheduledTasks[i].tasktype is not "">
							#lcase(scheduledTasks[i].tasktype)#
						<cfelse>
							every #scheduledTasks[i].interval# seconds
						</cfif>
					</td>
					<td>#scheduledTasks[i].startdate# #LSTimeFormat(scheduledTasks[i].starttime, "short")#</td>
					<td>#scheduledTasks[i].enddate#<cfif scheduledTasks[i].endtime is not ""> #LSTimeFormat(scheduledTasks[i].endtime, "short")#</cfif></td>
				</tr>
			</cfloop>
			</table>
		</cfif>
		
		<br /><br />
		
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
				<td bgcolor="##f0f0f0" align="right" valign="top">Duration</td>
				<td bgcolor="##ffffff">
					Start Date: <input type="text" name="startdate" size="10" maxlength="10" value="#scheduledTask.startdate#" />&nbsp;
					Start Time: <input type="text" name="starttime_duration" size="5" maxlength="5" value="#scheduledTask.starttime#" /><br />
					End Date: <input type="text" name="enddate" size="10" maxlength="10" value="#scheduledTask.enddate#" />&nbsp;
					End Time: <input type="text" name="endtime_duration" size="5" maxlength="5" value="#scheduledTask.endtime#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right" valign="top">Interval</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="runinterval" value="once"<cfif scheduledTask.tasktype is "ONCE" or scheduledTask.tasktype is ""> checked="true"</cfif> />
					One Time @ <input type="text" name="starttime_once" size="5" maxlength="5"<cfif scheduledTask.tasktype is "ONCE">value="#scheduledTask.starttime#"</cfif> /><br />
					<input type="radio" name="runinterval" value="recurring"<cfif (scheduledTask.tasktype is "DAILY" or scheduledTask.tasktype is "WEEKLY" or scheduledTask.tasktype is "MONTHLY") and scheduledTask.interval eq -1> checked="true"</cfif> />
					Recurring&nbsp;<select name="tasktype">
									<option value="" selected="true">- select -</option>
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
					<input type="text" name="urltouse" size="30"<cfif scheduledTask.urltouse is ""> value="http://"<cfelse> value="#scheduledTask.urltouse#"</cfif> />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Login Details</td>
				<td bgcolor="##ffffff">
					User Name: <input type="text" name="username" size="10" value="#scheduledTask.username#" />&nbsp;
					Password: <input type="password" name="password" size="10" value="#scheduledTask.password#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Proxy Server</td>
				<td bgcolor="##ffffff">
					<input type="text" name="proxyserver" size="30" value="#scheduledTask.proxyserver#" />&nbsp;
					Port <input type="text" name="proxyport" size="5" maxlength="5" value="#scheduledTask.proxyport#" /><!---
					TODO: enable this once proxyuser and proxypassword are added to the engine <br />
					User Name: <input type="text" name="proxyuser" size="20" value="#scheduledTask.proxyuser#" />&nbsp;
					Password: <input type="password" name="proxypassword" size="20" value="#scheduledTask.proxypassword#" /> --->
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right" valign="top">Publish Results to File</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="publish" value="true"<cfif structKeyExists(scheduledTask, "publish") and isBoolean(scheduledTask.publish) and scheduledTask.publish> checked="true"</cfif> />Yes&nbsp;
					<input type="radio" name="publish" value="false"<cfif (structKeyExists(scheduledTask, "publish") and (not isBoolean(scheduledTask.publish) or not scheduledTask.publish)) or not structKeyExists(scheduledTask, "publish")> checked="true"</cfif> />No<br />
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>Path:</td>
							<td><input type="text" name="publishpath" size="30" value="#scheduledTask.publishpath#" /></td>
						</tr>
						<tr>
							<td>Path Type:</td>
							<td>
								<input type="radio" name="uridirectory" value="true" />Relative&nbsp;
								<input type="radio" name="uridirectory" value="false" checked="true" />Absolute
							</td>
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