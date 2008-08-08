<cfsilent>
	<cfparam name="scheduledTaskMessage" type="string" default="" />
	<cfparam name="scheduledTasks" type="array" default="#arrayNew(1)#" />
	
	<cftry>
		<cfset scheduledTasks = Application.scheduledTasks.getScheduledTasks() />
		<cfcatch type="bluedragon.adminapi.scheduledtasks">
			<cfset scheduledTaskMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
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
					<td colspan="5"><strong>Scheduled Tasks</strong></td>
				</tr>
				<tr bgcolor="##dedede">
					<td width="100"><strong>Actions</strong></td>
					<td><strong>Task</strong></td>
					<td><strong>URL</strong></td>
					<td><strong>Start/End</strong></td>
					<td><strong>Interval</strong></td>
				</tr>
			<cfloop index="i" from="1" to="#arrayLen(scheduledTasks)#">
				<tr bgcolor="##ffffff">
					<td>
						<a href="_controller.cfm?action=" alt="Edit Task" title="Edit Task"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
						<a href="_controller.cfm?action=" alt="Run Task" title="Run Task"><img src="../images/accept.png" border="0" width="16" height="16" /></a>
						<a href="javascript:void(0);" onclick="javascript:deleteTask();" alt="Delete Task" title="Delete Task"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
					</td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</cfloop>
			</table>
		</cfif>
		
		<br />
		
		<form name="scheduledTaskForm" action="_controller.cfm?action=processScheduledTaskForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Create a Scheduled Task</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Task Name</td>
				<td bgcolor="##ffffff">
					<input type="text" name="name" size="30" maxlength="50" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Duration</td>
				<td bgcolor="##ffffff">
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" />
				</td>
			</tr>
		</table>
		</form>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>