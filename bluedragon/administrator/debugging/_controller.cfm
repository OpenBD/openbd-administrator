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
  <cfparam name="args.action" type="string" default="" />
  
  <!--- stick everything in form and url into a struct for easy reference --->
  <cfset args = StructNew() />
  
  <cfloop collection="#url#" item="urlKey">
    <cfset args[urlKey] = url[urlKey] />
  </cfloop>
  
  <cfloop collection="#form#" item="formKey">
    <cfset args[formKey] = form[formKey] />
  </cfloop>
  
  <!--- clear out any lingering session stuff --->
  <cfscript>
    StructDelete(session, "message", false);
    StructDelete(session, "errorFields", false);
  </cfscript>
  
  <cfswitch expression="#args.action#">
    <!--- DEBUG SETTINGS --->
    <cfcase value="processDebugSettingsForm">
      <cfset errorFields = ArrayNew(2) />
      <cfset errorFieldsIndex = 1 />
      
      <cfif args.slowquerytime != "" && (Find(".", args.slowquerytime) != 0 || !IsNumeric(args.slowquerytime))>
	<cfset errorFields[errorFieldsIndex][1] = "slowquerytime" />
	<cfset errorFields[errorFieldsIndex][2] = "The value of Slow Query Time is not numeric" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif ArrayLen(errorFields) gt 0>
	<cfset session.errorFields = errorFields />
	<cflocation url="index.cfm" addtoken="false" />
      </cfif>
      
      <cfif !StructKeyExists(args, "debug")>
	<cfset args.debug = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "runtimelogging")>
	<cfset args.runtimelogging = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "enabled")>
	<cfset args.enabled = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "assert")>
	<cfset args.assert = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "enableslowquerylog") || args.slowquerytime == "">
	<cfset args.enableslowquerylog = false />
	<cfset args.slowquerytime = -1 />
      </cfif>
      
      <cftry>
	<cfset Application.debugging.saveDebugSettings(args.debug, args.runtimelogging, 
	       args.enabled, args.assert, 
	       args.enableslowquerylog, args.slowquerytime) />
	<cfcatch type="bluedragon.adminapi.debugging">
	  <cfset session.message.text = CFCATCH.Message />
	  <cfset session.message.type = "error" />
	  <cflocation url="index.cfm" addtoken="false" />
	</cfcatch>
      </cftry>
      
      <cfset session.message.text = "The debug settings were saved successfully." />
      <cfset session.message.type = "info" />
      <cflocation url="index.cfm" addtoken="false" />
    </cfcase>
    
    <cfcase value="processDebugOutputForm">
      <cfset errorFields = ArrayNew(2) />
      <cfset errorFieldsIndex = 1 />
      
      <cfif Find(".", args.highlight) != 0 || !IsNumeric(args.highlight)>
	<cfset errorFields[errorFieldsIndex][1] = "highlight" />
	<cfset errorFields[errorFieldsIndex][2] = "The value of Highlight Execution Times is not numeric" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif arrayLen(errorFields) gt 0>
	<cfset session.errorFields = errorFields />
	<cflocation url="index.cfm" addtoken="false" />
      </cfif>
      
      <cfif !StructKeyExists(args, "executiontimes")>
	<cfset args.executiontimes = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "database")>
	<cfset args.database = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "exceptions")>
	<cfset args.exceptions = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "tracepoints")>
	<cfset args.tracepoints = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "timer")>
	<cfset args.timer = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "variables")>
	<cfset args.variables = false />
      </cfif>
      
      <cftry>
	<cfset Application.debugging.setDebugOutputSettings(args.executiontimes, args.highlight, 
	       args.database, args.exceptions, 
	       args.tracepoints, args.timer, 
	       args.variables) />
	<cfcatch type="bluedragon.adminapi.debugging">
	  <cfset seession.message = CFCATCH.Message />
	  <cflocation url="index.cfm" addtoken="false" />
	</cfcatch>
      </cftry>
      
      <cfset session.message.text = "The debug output settings were saved successfully." />
      <cfset session.message.type = "info" />
      <cflocation url="index.cfm" addtoken="false" />
    </cfcase>
    
    <cfcase value="processDebugVariablesForm">
      <cfif !StructKeyExists(args, "local")>
	<cfset args.local = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "url")>
	<cfset args.url = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "session")>
	<cfset args.session = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "variables")>
	<cfset args.variables = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "form")>
	<cfset args.form = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "client")>
	<cfset args.client = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "request")>
	<cfset args.request = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "cookie")>
	<cfset args.cookie = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "application")>
	<cfset args.application = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "cgi")>
	<cfset args.cgi = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "cffile")>
	<cfset args.cffile = false />
      </cfif>
      
      <cfif !StructKeyExists(args, "server")>
	<cfset args.server = false />
      </cfif>
      
      <cftry>
	<cfset Application.debugging.setDebugVariablesSettings(args.local, args.url, args.session, 
	       args.variables, args.form, args.client, 
	       args.request, args.cookie, args.application, 
	       args.cgi, args.cffile, args.server) />
	<cfcatch type="bluedragon.adminapi.debugging">
	  <cfset session.message = CFCATCH.Message />
	  <cflocation url="index.cfm" addtoken="false" />
	</cfcatch>
      </cftry>
      
      <cfset session.message.text = "The debug variables settings were saved successfully." />
      <cfset session.message.type = "info" />
      <cflocation url="index.cfm" addtoken="false" />
    </cfcase>
    
    <!--- DEBUG IPS --->
    <cfcase value="addLocalIP">
      <cftry>
	<cfset Application.debugging.addLocalIPAddress() />
	<cfcatch type="bluedragon.adminapi.debugging">
	  <cfset session.message.text = CFCATCH.Message />
	  <cfset session.message.type = "error" />
	  <cflocation url="ipaddresses.cfm" addtoken="false" />
	</cfcatch>
      </cftry>
      
      <cfset session.message.text = "The local IP address was added." />
      <cfset session.message.type = "info" />
      <cflocation url="ipaddresses.cfm" addtoken="false" />
    </cfcase>
    
    <cfcase value="addIPAddress">
      <cfset errorFields = ArrayNew(2) />
      <cfset errorFieldsIndex = 1 />
      
      <cfif REFindNoCase("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})$", args.ipaddress) eq 0>
	<cfset errorFields[errorFieldsIndex][1] = "ipaddress" />
	<cfset errorFields[errorFieldsIndex][2] = "The IP Address value does not appear to be valid" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif ArrayLen(errorFields) gt 0>
	<cfset session.errorFields = errorFields />
	<cflocation url="ipaddresses.cfm" addtoken="false" />
      </cfif>
      
      <cftry>
	<cfset Application.debugging.addDebugIPAddresses(args.ipaddress)>
	  <cfcatch type="bluedragon.adminapi.debugging">
	    <cfset session.message.text = CFCATCH.Message />
	    <cfset session.message.type = "error" />
	    <cflocation url="ipaddresses.cfm" addtoken="false" />
	  </cfcatch>
      </cftry>
      
      <cfset session.message.text = "The IP addresses were successfully added." />
      <cfset session.message.type = "info" />
      <cflocation url="ipaddresses.cfm" addtoken="false" />
    </cfcase>
    
    <cfcase value="removeIPAddresses">
      <cfset errorFields = ArrayNew(2) />
      <cfset errorFieldsIndex = 1 />
      
      <cfif Trim(args.ipaddresses) == "">
	<cfset errorFields[errorFieldsIndex][1] = "ipaddresses" />
	<cfset errorFields[errorFieldsIndex][2] = "No IP address to remove was selected" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif ArrayLen(errorFields) gt 0>
	<cfset session.errorFields = errorFields />
	<cflocation url="ipaddresses.cfm" addtoken="false" />
      </cfif>
      
      <cftry>
	<cfset Application.debugging.removeDebugIPAddresses(args.ipaddresses)>
	  <cfcatch type="bluedragon.adminapi.debugging">
	    <cfset session.message.text = CFCATCH.Message />
	    <cfset session.message.type = "error" />
	    <cflocation url="ipaddresses.cfm" addtoken="false" />
	  </cfcatch>
      </cftry>
      
      <cfset session.message.text = "The IP addresses were removed." />
      <cfset session.message.type = "info" />
      <cflocation url="ipaddresses.cfm" addtoken="false" />
    </cfcase>
    
    <!--- LOGGING --->
    <cfcase value="archiveLogFile">
      <cftry>
	<cfset Application.debugging.archiveLogFile(args.logFile) />
	<cfcatch type="bluedragon.adminapi.debugging">
	  <cfset session.message.text = CFCATCH.Message />
	  <cfset session.message.type = "error" />
	  <cflocation url="logs.cfm" addtoken="false" />
	</cfcatch>
      </cftry>
      
      <cfset session.message.text = "The log file was archived successfully." />
      <cfset session.message.type = "info" />
      <cflocation url="logs.cfm" addtoken="false" />
    </cfcase>
    
    <cfcase value="deleteLogFile">
      <cftry>
	<cfset Application.debugging.deleteLogFile(args.logFile) />
	<cfcatch type="any">
	  <cfset session.message.text = CFCATCH.Message />
	  <cfset session.message.type = "error" />
	  <cflocation url="logs.cfm" addtoken="false" />
	</cfcatch>
      </cftry>
      
      <cfset session.message.text = "The log file was deleted successfully." />
      <cfset session.message.type = "info" />
      <cflocation url="logs.cfm" addtoken="false" />
    </cfcase>
    
    <cfcase value="deleteRuntimeErrorLog">
      <cftry>
	<cfset Application.debugging.deleteRuntimeErrorLog(args.rteLog) />
	<cfcatch type="any">
	  <cfset session.message.text = CFCATCH.Message />
	  <cfset session.message.type = "error" />
	  <cflocation url="runtimeerrors.cfm" addtoken="false" />
	</cfcatch>
      </cftry>
      
      <cfset session.message.text = "The runtime error log was deleted successfully." />
      <cfset session.message.type = "info" />
      <cflocation url="runtimeerrors.cfm" addtoken="false" />
    </cfcase>
    
    <cfcase value="deleteAllRuntimeErrorLogs">
      <cftry>
	<cfset Application.debugging.deleteAllRuntimeErrorLogs() />
	<cfcatch type="any">
	  <cfset session.message.text = CFCATCH.Message />
	  <cfset session.message.type = "error" />
	  <cflocation url="runtimeerrors.cfm" addtoken="false" />
	</cfcatch>
      </cftry>

      <cfset session.message.text = "The runtime error logs were deleted successfully." />
      <cfset session.message.type = "info" />
      <cflocation url="runtimeerrors.cfm" addtoken="false" />
    </cfcase>
    
    <!--- SCHEDULED TASKS --->
    <cfcase value="processScheduledTaskForm">
      <cfset errorFields = ArrayNew(2) />
      <cfset errorFieldsIndex = 1 />
      
      <cfif Trim(args.name) == "">
	<cfset errorFields[errorFieldsIndex][1] = "name" />
	<cfset errorFields[errorFieldsIndex][2] = "A name for the scheduled task is required" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif Trim(args.urltouse) == "" || !IsValid("url", args.urltouse)>
	<cfset errorFields[errorFieldsIndex][1] = "urltouse" />
	<cfset errorFields[errorFieldsIndex][2] = "A valid URL for the scheduled task is required" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif Trim(args.porttouse) != "" && !IsNumeric(Trim(args.porttouse))>
	<cfset errorFields[errorFieldsIndex][1] = "porttouse" />
	<cfset errorFields[errorFieldsIndex][2] = "Please enter a numeric value for the port" />
	<cfset errorFieldsIndex++ />
	<cfelse>
	  <cfset args.porttouse = -1 />
      </cfif>
      
      <cfif Trim(args.proxyport) != "" && !IsNumeric(Trim(args.proxyport))>
	<cfset errorFields[errorFieldsIndex][1] = "proxyport" />
	<cfset errorFields[errorFieldsIndex][2] = "Please enter a numeric value for the proxy port" />
	<cfset errorFieldsIndex++ />
	<cfelse>
	  <cfset args.proxyport = 80 />
      </cfif>
      
      <cfif args.runinterval == "once" && !IsValid("time", Trim(args.starttime_once))>
	<cfset errorFields[errorFieldsIndex][1] = "starttime_once" />
	<cfset errorFields[errorFieldsIndex][2] = "Please enter a valid start time" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif args.runinterval == "recurring" && !IsValid("time", Trim(args.starttime_recurring))>
	<cfset errorFields[errorFieldsIndex][1] = "starttime_recurring" />
	<cfset errorFields[errorFieldsIndex][2] = "Please enter a valid start time" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif args.runinterval == "daily" && !IsValid("time", Trim(args.starttime_daily))>
	<cfset errorFields[errorFieldsIndex][1] = "starttime_daily" />
	<cfset errorFields[errorFieldsIndex][2] = "Please enter a valid start time" />
	<cfset errorFieldsIndex++ />
      </cfif>

      <cfif Trim(args.endtime_daily) != "" && !IsValid("time", args.endtime_daily)>
	<cfset errorFields[errorFieldsIndex][1] = "endtime_daily" />
	<cfset errorFields[errorFieldsIndex][2] = "Please enter a valid end time for the daily task" />
	<cfset errorFieldsIndex++ />
      </cfif>

      <cfif Trim(args.enddate) != "" && !IsValid("date", args.enddate)>
	<cfset errorFields[errorFieldsIndex][1] = "enddate" />
	<cfset errorFields[errorFieldsIndex][2] = "Please enter a valid end date" />
	<cfset errorFieldsIndex++ />
      </cfif>

      <cfif args.runinterval == "recurring" && Trim(args.tasktype) == "">
	<cfset errorFields[errorFieldsIndex][1] = "tasktype" />
	<cfset errorFields[errorFieldsIndex][2] = "Please select the interval for the recurring task" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif args.runinterval == "daily" && (Trim(args.interval) == "" || !IsNumeric(args.interval) || args.interval gt 86400)>
	<cfset errorFields[errorFieldsIndex][1] = "interval" />
	<cfset errorFields[errorFieldsIndex][2] = "Please enter a valid number of seconds for the daily task. This number may not exceed 86400." />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif StructKeyExists(args, "publish") && args.publish && 
	    (Trim(args.publishpath) == "" || Trim(args.publishfile) == "")>
	<cfset errorFields[errorFieldsIndex][1] = "publishpath" />
	<cfset errorFields[errorFieldsIndex][2] = "Please enter a path and file name to which to publish the file" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif Trim(args.requesttimeout) == "" || !IsNumeric(args.requesttimeout)>
	<cfset errorFields[errorFieldsIndex][1] = "requesttimeout" />
	<cfset errorFields[errorFieldsIndex][2] = "Please enter a numeric value for request timeout" />
	<cfset errorFieldsIndex++ />
      </cfif>
      
      <cfif ArrayLen(errorFields) gt 0>
	<cfset session.errorFields = errorFields />
	<cflocation url="scheduledtasks.cfm" addtoken="false" />
      </cfif>
      
      <cftry>
	<cfif !IsValid("date", args.startdate)>
	  <cfset args.startdate = DateFormat(now(), "mm/dd/yyyy") />
	  <cfelse>
	    <cfset args.startdate = DateFormat(args.startdate, "mm/dd/yyyy") />
	</cfif>
	
	<cfif args.runinterval == "once">
	  <cfset args.starttime = TimeFormat(args.starttime_once, "HH:mm") />
	  <cfset args.interval = "ONCE" />
	  <cfelseif args.runinterval == "recurring">
	    <cfset args.starttime = TimeFormat(args.starttime_recurring, "HH:mm") />
	    <cfset args.interval = args.tasktype />
	    <cfelseif args.runinterval == "daily">
	      <cfset args.starttime = TimeFormat(args.starttime_daily, "HH:mm") />
	</cfif>
	
	<cfif Trim(args.enddate) != "">
	  <cfset args.enddate = DateFormat(args.enddate, "mm/dd/yyyy") />
	</cfif>
	
	<cfif args.runinterval == "daily" && Trim(args.endtime_daily) != "">
	  <cfset args.endtime = TimeFormat(args.endtime_daily, "HH:mm") />
	  <cfelse>
	    <cfset args.endtime = "" />
	</cfif>

	<cfset Application.scheduledTasks.setScheduledTask(args.name, args.urltouse, args.startdate, args.starttime, 
	       args.interval, args.porttouse, args.enddate, args.endtime, 
	       args.username, args.password, 
	       args.proxyserver, args.proxyport, args.publish, 
	       args.publishpath, args.uridirectory, args.publishfile, 
	       args.resolvelinks, args.requesttimeout, args.scheduledTaskAction) />

	<cfif CompareNoCase(args.name, args.existingScheduledTaskName) != 0>
	  <cfset Application.scheduledTasks.deleteScheduledTask(args.existingScheduledTaskName) />
	</cfif>
	
	<cfcatch type="bluedragon.adminapi.scheduledtasks">
	  <cfset session.message.text = CFCATCH.Message />
	  <cfset session.message.type = "error" />
	  <cflocation url="scheduledtasks.cfm" addtoken="false" />
	</cfcatch>
      </cftry>
      
      <cfset session.message.text = "The scheduled task was #args.scheduledTaskAction#d successfully" />
      <cfset session.message.type = "info" />
      <cflocation url="scheduledtasks.cfm" addtoken="false" />
    </cfcase>
    
    <cfcase value="runScheduledTask">
      <cftry>
	<cfset Application.scheduledTasks.runScheduledTask(args.name) />
	<cfcatch type="bluedragon.adminapi.scheduledtasks">
	  <cfset session.message.text = CFCATCH.Message />
	  <cfset session.message.type = "error" />
	  <cflocation url="scheduledtasks.cfm" addtoken="false" />
	</cfcatch>
      </cftry>

      <cfset session.message.text = "The scheduled task was run successfully." />
      <cfset session.message.type = "info" />
      <cflocation url="scheduledtasks.cfm" addtoken="false" />
    </cfcase>
    
    <cfcase value="editScheduledTask">
      <cfset session.scheduledTask = Application.scheduledTasks.getScheduledTasks(args.name) />
      <cflocation url="scheduledtasks.cfm" addtoken="false" />
    </cfcase>
    
    <cfcase value="deleteScheduledTask">
      <cftry>
	<cfset Application.scheduledTasks.deleteScheduledTask(args.name) />
	<cfcatch type="bluedragon.adminapi.scheduledtasks">
	  <cfset session.message.text = CFCATCH.Message />
	  <cfset session.message.type = "error" />
	  <cflocation url="scheduledtasks.cfm" addtoken="false" />
	</cfcatch>
      </cftry>
      
      <cfset session.message.text = "The scheduled task was deleted successfully." />
      <cfset session.message.type = "info" />
      <cflocation url="scheduledtasks.cfm" addtoken="false" />
    </cfcase>
    
    <!--- DEFAULT CASE --->
    <cfdefaultcase>
      <cfset session.message.text = "Invalid action" />
      <cfset session.message.type = "error" />
      <cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
    </cfdefaultcase>
  </cfswitch>
</cfsilent>
