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
  <cfparam name="logFilesMessage" type="string" default="" />

  <cfset logFiles = ArrayNew(1) />

  <cftry>
    <cfset logFiles = Application.debugging.getLogFiles() />
    <cfcatch type="any">
      <cfset logFilesMessage = CFCATCH.Message />
      <cfset logFilesMessageType = "error" />
    </cfcatch>
  </cftry>
</cfsilent>
<cfsavecontent variable="request.content">
  <cfoutput>
    <script type="text/javascript">
      /*function deleteLogFile(logFile) {
        if(confirm("Are you sure you want to delete this log file?")) {
          location.replace("_controller.cfm?action=deleteLogFile&logFile=" + logFile);
        }
      }
      
      function archiveLogFile(logFile) {
        if(confirm("Are you sure you want to archive this log file?\nThis will delete your oldest log file of this type\nand rotate all other log files back one position.")) {
          location.replace("_controller.cfm?action=archiveLogFile&logFile=" + logFile);
        }
      }*/
      
      function downloadLogFile(logFile) {
        window.open("downloadlogfile.cfm?logFile=" + logFile);
      }
    </script>
    
    <h2>Log Files</h2>
    
    <cfif StructKeyExists(session, "message") && session.message.text != "">
      <p class="#session.message.type#">#session.message.text#</p>
    </cfif>
    
    <cfif logFilesMessage != "">
      <p class="#logFilesMessageType#">#logFilesMessage#</p>
    </cfif>
    
    <cfif ArrayLen(logFiles) == 0>
      <p><strong><em>No log files available</em></strong></p>
      <cfelse>
	<table border="0" width="100%" cellpadding="2" cellspacing="1" bgcolor="##999999">
	  <tr bgcolor="##dedede">
	    <td width="100"><strong>Actions</strong></td>
	    <td><strong>Log File</strong></td>
	    <td><strong>Size</strong></td>
	    <td><strong>Last Updated</strong></td>
	  </tr>
	  <cfloop index="i" from="1" to="#ArrayLen(logFiles)#">
	    <tr bgcolor="##ffffff">
	      <td width="100">
		<a href="viewlogfile.cfm?logFile=#logFiles[i].name#" alt="View Log File" title="View Log File"><img src="../images/page_find.png" border="0" width="16" height="16" /></a>
		<a href="javascript:void(0);" onclick="javascript:downloadLogFile('#logFiles[i].name#');" alt="Download Log File" title="Download Log File"><img src="../images/disk.png" border="0" width="16" height="16" /></a>
		<!--- TODO: deleting and archiving log files didn't currently jive with how the openbd engine deals with log files, so commenting this out for now --->
		<!--- <a href="javascript:void(0);" onclick="javascript:archiveLogFile('#logFiles[i].name#');" alt="Archive Log File" title="Archive Log File"><img src="../images/folder_page.png" border="0" width="16" height="16" /></a>
		    <a href="javascript:void(0);" onclick="javascript:deleteLogFile('#logFiles[i].name#');" alt="Delete Log File" title="Delete Log File"><img src="../images/cancel.png" border="0" width="16" height="16" /></a> --->
	      </td>
	      <td><a href="viewlogfile.cfm?logFile=#logFiles[i].name#" alt="View Log File" title="View Log File">#logFiles[i].name#</a></td>
	      <td>#logFiles[i].size#</td>
	      <td>#logFiles[i].datelastmodified#</td>
	    </tr>
	  </cfloop>
	</table>
    </cfif>
  </cfoutput>
</cfsavecontent>
