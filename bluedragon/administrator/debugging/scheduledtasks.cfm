<!---
    Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
    
    Contributing Developers:
    Matt Woodward - matt@mattwoodward.com

    This file is part of of the Open BlueDragon Administrator.

    The Open BlueDragon Administrator is free software: you can redistribute 
    it and/or modify it under the terms of the GNU General Public License 
    as published by the Free Software Foundation, either version 3 of the 
    License, or (at your option) any later version.

    The Open BlueDragon Administrator is distributed in the hope that it will 
    be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
    of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
    General Public License for more details.
    
    You should have received a copy of the GNU General Public License 
    along with the Open BlueDragon Administrator.  If not, see 
    <http://www.gnu.org/licenses/>.
--->
<cfsilent>
  <cfparam name="scheduledTaskMessage" type="string" default="" />
  <cfparam name="scheduledTasks" type="array" default="#arrayNew(1)#" />
  <cfparam name="scheduledTaskAction" type="string" default="create" />
  <cfparam name="scheduledTaskActionLabel" type="string" default="Create a" />
  
  <cftry>
    <cfset scheduledTasks = Application.scheduledTasks.getScheduledTasks() />
    <cfcatch type="bluedragon.adminapi.scheduledtasks">
      <cfset scheduledTaskMessage = CFCATCH.Message />
      <cfset scheduledTaskMessageType = "error" />
    </cfcatch>
  </cftry>
  
  <cfif StructKeyExists(session, "scheduledTask")>
    <cfset scheduledTask = session.scheduledTask[1] />
    
    <cfif !StructKeyExists(scheduledTask, "tasktype")>
      <cfset scheduledTask.tasktype = "" />
    </cfif>
    
    <cfset scheduledTaskAction = "update" />
    <cfset scheduledTaskActionLabel = "Edit">
    <cfelse>
      <cfset scheduledTask = {name:'', urltouse:'', porttouse:'', tasktype:'',
	                        startdate:'', starttime:'', enddate:'', endtime:'', 
	                        interval:-1, username:'', password:'', resolvelinks:false, 
                                requesttimeout:'', publish:false, publishpath:'', publishfile:'', 
	                        proxyserver:'', proxyport:''} />
  </cfif>
</cfsilent>
<cfsavecontent variable="request.content">
  <cfoutput>
    <script type="text/javascript">
      function validate(f) {
        var timeCheck =  /(1|2|3|4|5|6|7|8|9|00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23):(0|1|2|3|4|5)\d{1}/;
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
	} else if (f.urltouse.value.length == 0 || !urlCheck.test(f.urltouse.value) || 
	           (urlCheck.test(f.urltouse.value) && f.urltouse.value.length <= 7)) {
          alert("Please enter a valid URL");
          return false;
        } else if (f.porttouse.value.length > 0 && !numericCheck(f.porttouse.value)) {
          alert("Please enter a valid numeric value for the port");
          return false;
        } else if (f.startdate.value.length > 0 && !dateCheck.test(f.startdate.value)) {
	  alert("Please enter a valid start date");
	  return false;
	} else if (f.enddate.value.length > 0 && !dateCheck(f.enddate.value)) {
	  alert("Please enter a valid end date");
	  return false;
	} else if (runIntervalValue == "once" && (f.starttime_once.value.length == 0 || 
	  !timeCheck.test(f.starttime_once.value))) {
	  alert("Please enter a valid start time for the one-time task");
	  return false;
	} else if (runIntervalValue == "recurring" && f.tasktype.value == "") {
	  alert("Please select the interval for the recurring task");
	  return false;
	} else if (runIntervalValue == "recurring" && (f.starttime_recurring.value.length == 0 || 
	  !timeCheck.test(f.starttime_recurring.value))) {
	  alert("Please enter a valid start time for the recurring task");
	  return false;
	} else if (runIntervalValue == "daily" && (f.interval.value.length == 0 || !numericCheck(f.interval.value) || 
	  f.interval.value > 86400)) {
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
    
    <h2>Scheduled Tasks</h2>
    
    <cfif StructKeyExists(session, "message") && session.message.text != "">
      <p class="#session.message.type#">#session.message.text#</p>
    </cfif>
    
    <cfif scheduledTaskMessage != "">
      <p class="#scheduledTaskMessageType#">#scheduledTaskMessage#</p>
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
	<cfloop index="i" from="1" to="#ArrayLen(scheduledTasks)#">
	  <tr bgcolor="##ffffff">
	    <td>
	      <a href="_controller.cfm?action=runScheduledTask&name=#scheduledTasks[i].name#" alt="Run Task" 
		 title="Run Task">
		<img src="../images/control_play_blue.png" border="0" width="16" height="16" />
	      </a>
	      <!--- TODO: enable this once 'pause' is added as an action for scheduled tasks in the engine 
		  <a href="_controller.cfm?action=pauseScheduledTask&name=#scheduledTasks[i].name#" alt="Pause Task" 
		     title="Pause Task">
		    <img src="../images/control_pause_blue.png" border="0" width="16" height="16" />
		  </a> --->
	      <a href="_controller.cfm?action=editScheduledTask&name=#URLEncodedFormat(scheduledTasks[i].name)#" alt="Edit Task" 
		 title="Edit Task">
		<img src="../images/pencil.png" border="0" width="16" height="16" />
	      </a>
	      <a href="javascript:void(0);" onclick="javascript:deleteScheduledTask('#scheduledTasks[i].name#');" 
		 alt="Delete Task" title="Delete Task">
		<img src="../images/cancel.png" border="0" width="16" height="16" />
	      </a>
	    </td>
	    <td>#scheduledTasks[i].name#</td>
	    <td>#scheduledTasks[i].urltouse#</td>
	    <td>
	      <cfif StructKeyExists(scheduledTasks[i], "tasktype") && scheduledTasks[i].tasktype != "">
		#LCase(scheduledTasks[i].tasktype)# 
		<cfif scheduledTasks[i].interval != -1>
		  every #scheduledTasks[i].interval# seconds
		  <cfelse>
		    @ #LSTimeFormat(scheduledTasks[i].starttime, "short")#
		</cfif>
		<cfelseif !StructKeyExists(scheduledTasks[i], "tasktype") && 
			  structKeyExists(scheduledTasks[i], "interval") && 
			  scheduledTasks[i].interval != "">
		  Every #scheduledTasks[i].interval# seconds
	      </cfif>
	    </td>
	    <td>#scheduledTasks[i].startdate# #LSTimeFormat(scheduledTasks[i].starttime, "short")#</td>
	    <td>
	      #scheduledTasks[i].enddate#
	      <cfif scheduledTasks[i].endtime != "">&nbsp;#LSTimeFormat(scheduledTasks[i].endtime, "short")#</cfif>
	    </td>
	  </tr>
	</cfloop>
      </table>
    </cfif>
    
    <br /><br />

    <cfif StructKeyExists(session, "errorFields") && ArrayLen(session.errorFields) gt 0>
      <p class="error">The following errors occurred:</p>
      <ul>
	<cfloop index="i" from="1" to="#ArrayLen(session.errorFields)#">
	  <li>#session.errorFields[i][2]#</li>
	</cfloop>
      </ul>
    </cfif>
    
    <form name="scheduledTaskForm" action="_controller.cfm?action=processScheduledTaskForm" method="post" 
	  onsubmit="javascript:return validate(this);">
      <table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
	<tr bgcolor="##dedede">
	  <td colspan="2"><strong>#scheduledTaskActionLabel# Scheduled Task</strong></td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="name">Task Name</label></td>
	  <td bgcolor="##ffffff">
	    <input type="text" name="name" id="name" size="30" maxlength="50" value="#scheduledTask.name#" tabindex="1" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right" valign="top">Duration</td>
	  <td bgcolor="##ffffff">
	    <label for="startdate">Start Date:</label>&nbsp;
	    <input type="text" name="startdate" id="startdate" size="10" maxlength="10" 
		   value="#scheduledTask.startdate#" tabindex="2" />&nbsp;
	    <label for="enddate">End Date:</label>&nbsp;
	    <input type="text" name="enddate" id="enddate" size="10" maxlength="10" 
		   value="#scheduledTask.enddate#" tabindex="3" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right" valign="top">Interval</td>
	  <td bgcolor="##ffffff">
	    <input type="radio" name="runinterval" id="runintervalOnce" value="once"
		   <cfif scheduledTask.tasktype == "ONCE"> checked="true"</cfif> tabindex="4" />
	    <label for="runintervalOnce">One Time</label>&nbsp;
	    <label for="starttime_once">@</label>&nbsp;
	    <input type="text" name="starttime_once" id="starttime_once" size="5" maxlength="5"
		   <cfif scheduledTask.tasktype == "ONCE" && scheduledTask.starttime != ""> value="#timeFormat(scheduledTask.starttime, 'HH:mm')#"</cfif> 
		   tabindex="5" /><br />
	    <input type="radio" name="runinterval" id="runintervalRecurring" value="recurring"
		   <cfif (scheduledTask.tasktype == "DAILY" || scheduledTask.tasktype == "WEEKLY" || scheduledTask.tasktype == "MONTHLY") && scheduledTask.interval == -1> checked="true"</cfif> 
		   tabindex="6" />
	    <label for="runintervalRecurring">Recurring</label>&nbsp;
	    <select name="tasktype" id="tasktype" tabindex="7">
	      <option value="" selected="true">- select -</option>
	      <option value="DAILY"<cfif scheduledTask.tasktype == "DAILY" && scheduledTask.interval == -1> selected="true"</cfif>>daily</option>
	      <option value="WEEKLY"<cfif scheduledTask.tasktype == "WEEKLY" && scheduledTask.interval == -1> selected="true"</cfif>>weekly</option>
	      <option value="MONTHLY"<cfif scheduledTask.tasktype == "MONTHLY" && scheduledTask.interval == -1> selected="true"</cfif>>monthly</option>
	    </select>
	    &nbsp;<label for="starttime_recurring">@</label>&nbsp;
	    <input type="text" name="starttime_recurring" id="starttime_recurring" size="5" maxlength="5"
		   <cfif scheduledTask.interval == -1 && 
			 (scheduledTask.tasktype == "DAILY" || 
			 scheduledTask.tasktype == "WEEKLY" || 
			 scheduledTask.tasktype == "MONTHLY")>value="#timeFormat(scheduledTask.starttime, 'HH:mm')#"</cfif> 
		   tabindex="8" /><br />
	    <input type="radio" name="runinterval" id="runintervalDaily" value="daily"
		   <cfif (scheduledTask.tasktype == "" || scheduledTask.tasktype == "DAILY") && 
			 scheduledTask.interval != -1> checked="true"</cfif> tabindex="9" />
	    <label for="runintervalDaily">Daily</label>&nbsp;
	    <label for="interval">every</label>&nbsp;
	    <input type="text" name="interval" id="interval" size="5" maxlength="5"
		   <cfif (scheduledTask.tasktype == "" || scheduledTask.tasktype == "DAILY") && 
			 scheduledTask.interval != -1> value="#scheduledTask.interval#"</cfif> 
		   tabindex="10" />&nbsp;
	    seconds&nbsp;
	    <label for="starttime_daily">from</label>&nbsp;
	    <input type="text" name="starttime_daily" id="starttime_daily" size="5" maxlength="5"
		   <cfif (scheduledTask.tasktype == "" || scheduledTask.tasktype == "DAILY") && 
			 scheduledTask.interval != -1> value="#timeFormat(scheduledTask.starttime, 'HH:mm')#"</cfif> 
		   tabindex="11" />&nbsp;
	    <label for="endtime_daily">to</label>&nbsp;
	    <input type="text" name="endtime_daily" id="endtime_daily" size="5" maxlength="5"
		   <cfif (scheduledTask.tasktype == "" || scheduledTask.tasktype == "DAILY") && 
			 scheduledTask.interval != -1 && scheduledTask.endtime != ""> value="#timeFormat(scheduledTask.endtime, 'HH:mm')#"</cfif> 
		   tabindex="12" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right" valign="top"><label for="urltouse">Full URL</label></td>
	  <td bgcolor="##ffffff">
	    <input type="text" name="urltouse" id="urltouse" size="56"
		   <cfif scheduledTask.urltouse == ""> value="http://"<cfelse> value="#scheduledTask.urltouse#"</cfif> 
		   tabindex="13" /><br />
	    <label for="porttouse">Port</label>&nbsp;
	    <input type="text" name="porttouse" id="porttouse" size="5" maxlength="5"
		   <cfif scheduledTask.porttouse == -1 || scheduledTask.porttouse == ""> value=""<cfelse> value="#scheduledTask.porttouse#"</cfif> 
		   tabindex="14" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right">Login Details</td>
	  <td bgcolor="##ffffff">
	    <label for="username">User Name:</label>&nbsp;
	    <input type="text" name="username" id="username" size="10" value="#scheduledTask.username#" tabindex="15" />&nbsp;
	    <label for="password">Password</label>:&nbsp;
	    <input type="password" name="password" id="password" size="10" value="#scheduledTask.password#" tabindex="16" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right" valign="top"><label for="proxyserver">Proxy Server</label></td>
	  <td bgcolor="##ffffff">
	    <input type="text" name="proxyserver" id="proxyserver" size="56" value="#scheduledTask.proxyserver#" tabindex="17" /><br />
	    <label for="proxyport">Port</label>&nbsp;
	    <input type="text" name="proxyport" id="proxyport" size="5" maxlength="5" value="#scheduledTask.proxyport#" 
		   tabindex="18" />
	    <!---
		TODO: enable this once proxyuser and proxypassword are added to the engine <br />
		User Name: <input type="text" name="proxyuser" size="20" value="#scheduledTask.proxyuser#" />&nbsp;
		Password: <input type="password" name="proxypassword" size="20" value="#scheduledTask.proxypassword#" /> --->
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right" valign="top">Publish Results to File</td>
	  <td bgcolor="##ffffff">
	    <input type="radio" name="publish" id="publishTrue" value="true"
		   <cfif StructKeyExists(scheduledTask, "publish") && IsBoolean(scheduledTask.publish) && scheduledTask.publish> checked="true"</cfif> 
		   tabindex="19" />
	    <label for="publishTrue">Yes</label>&nbsp;
	    <input type="radio" name="publish" id="publishFalse" value="false"
		   <cfif (StructKeyExists(scheduledTask, "publish") && (!IsBoolean(scheduledTask.publish) || !scheduledTask.publish)) || !StructKeyExists(scheduledTask, "publish")> checked="true"</cfif> 
		   tabindex="20" />
	    <label for="publishFalse">No</label><br />
	    <table border="0" cellpadding="0" cellspacing="0">
	      <tr>
		<td><label for="publishpath">Path:</label></td>
		<td>
		  <input type="text" name="publishpath" id="publishpath" size="46" 
			 value="#scheduledTask.publishpath#" tabindex="21" />
		</td>
	      </tr>
	      <tr>
		<td>Path Type:</td>
		<td>
		  <input type="radio" name="uridirectory" id="uridirectoryTrue" value="true" tabindex="22" />
		  <label for="uridirectoryTrue">Relative</label>&nbsp;
		  <input type="radio" name="uridirectory" id="uridirectoryFalse" value="false" 
			 checked="true" tabindex="23" />
		  <label for="uridirectoryFalse">Absolute</label>
		</td>
	      </tr>
	      <tr>
		<td><label for="publishfile">File Name:</label></td>
		<td>
		  <input type="text" name="publishfile" id="publishfile" size="46" 
			 value="#scheduledTask.publishfile#" tabindex="24" />
		</td>
	      </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right">Resolve Internal URLs</td>
	  <td bgcolor="##ffffff">
	    <input type="radio" name="resolvelinks" id="resolvelinksTrue" value="true"
		   <cfif scheduledTask.resolvelinks> checked="true"</cfif> tabindex="25" />
	    <label for="resolvelinksTrue">Yes</label>&nbsp;
	    <input type="radio" name="resolvelinks" id="resolvelinksFalse" value="false"
		   <cfif (IsBoolean(scheduledTask.resolvelinks) && !scheduledTask.resolvelinks) || scheduledTask.resolvelinks == ""> checked="true"</cfif> 
		   tabindex="26" />
	    <label for="resolvelinksFalse">No</label>
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="requesttimeout">Request Timeout</label></td>
	  <td bgcolor="##ffffff">
	    <input type="text" name="requesttimeout" id="requesttimeout" size="5" maxlength="5" 
		   value="#scheduledTask.requesttimeout#" tabindex="27" /> seconds
	  </td>
	</tr>
	<tr bgcolor="##dedede">
	  <td>&nbsp;</td>
	  <td>
	    <input type="submit" name="submit" value="Submit" tabindex="28" />
	  </td>
	</tr>
      </table>
      <input type="hidden" name="scheduledTaskAction" value="#scheduledTaskAction#" />
      <input type="hidden" name="existingScheduledTaskName" value="#scheduledTask.name#" />
    </form>
  </cfoutput>
  <cfset StructDelete(session, "scheduledTask", false) />
</cfsavecontent>
