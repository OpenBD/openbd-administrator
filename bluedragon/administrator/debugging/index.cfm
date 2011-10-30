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
  <cfparam name="debuggingMessage" type="string" default="" />
  <cftry>
    <cfset debugSettings = Application.debugging.getDebugSettings() />
    <cfcatch type="bluedragon.adminapi.debugging">
      <cfset debuggingMessage = CFCATCH.Message />
      <cfset debuggingMessageType = "error" />
    </cfcatch>
  </cftry>
</cfsilent>
<cfsavecontent variable="request.content">
  <cfoutput>
    <script type="text/javascript">
      function validateDebugOutputForm(f) {
        if (f.highlight.value != parseInt(f.highlight.value)) {
          alert("The value of Highlight Execution Times is not numeric");
          return false;
        } else {
          return true;
        }
      }
    </script>
    
    <h2>Debug Settings</h2>
    
    <cfif StructKeyExists(session, "message") && session.message.text != "">
      <p class="#session.message.type#">#session.message.text#</p>
    </cfif>
    
    <cfif debuggingMessage != "">
      <p class="#debuggingMessageType#">#debuggingMessage#</p>
    </cfif>

    <cfif StructKeyExists(session, "errorFields") && ArrayLen(session.errorFields) gt 0>
      <p class="error">The following errors occurred:</p>
      <ul>
	<cfloop index="i" from="1" to="#ArrayLen(session.errorFields)#">
	  <li>#session.errorFields[i][2]#</li>
	</cfloop>
      </ul>
    </cfif>
    
    <form name="debugSettingsForm" action="_controller.cfm?action=processDebugSettingsForm" method="post">
      <table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
	<tr bgcolor="##dedede">
	  <td colspan="2"><strong>Debug &amp; Error Settings</strong></td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="debug">Extended Error Reporting</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="debug" id="debug" value="true"
		   <cfif debugSettings.system.debug> checked="true"</cfif> tabindex="1" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="runtimelogging">Runtime Error Logging</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="runtimelogging" id="runtimelogging" value="true"
		   <cfif debugSettings.system.runtimelogging> checked="true"</cfif> tabindex="2" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="enabled">Enable Debug Output</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="enabled" id="enabled" value="true"
		   <cfif debugSettings.debugoutput.enabled> checked="true"</cfif> tabindex="3" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="assert">Assertions</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="assert" id="assert" value="true"
		   <cfif debugSettings.system.assert> checked="true"</cfif> tabindex="4" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="slowquerylog">Slow Query Log</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="enableslowquerylog" id="enableslowquerylog" value="true" 
		   <cfif debugSettings.slowquerytime != -1> checked="true"</cfif> tabindex="5" />&nbsp;&nbsp;
	    <label for="slowquerytime">Log queries running more than</label>&nbsp;
	    <input type="text" name="slowquerytime" id="slowquerytime" size="4" maxlength="4" 
		   value="<cfif debugSettings.slowquerytime != -1>#debugSettings.slowquerytime#</cfif>" tabindex="6" />&nbsp;seconds&nbsp;
	    <img src="../images/arrow_refresh_small.png" height="16" width="16" 
		 alt="Requires Server Restart" title="Requires Server Restart" />
	  </td>
	</tr>
	<tr bgcolor="##dedede">
	  <td>&nbsp;</td>
	  <td><input type="submit" name="submit" value="Submit" tabindex="7" /></td>
	</tr>
      </table>
    </form>
    
    <br /><br />

    <form name="debugOutputForm" action="_controller.cfm?action=processDebugOutputForm" method="post" 
	  onsubmit="javascript:return validateDebugOutputForm(this);">
      <table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
	<tr bgcolor="##dedede">
	  <td colspan="2"><strong>Debug Output</strong></td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="executiontimes">Page Execution Times</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="executiontimes" id="executiontimes" value="true"
		   <cfif debugSettings.debugoutput.executiontimes.show> checked="true"</cfif> tabindex="8" />&nbsp;&nbsp;
	    <label for="highlight">Highlight times greater than</label>&nbsp;
	    <input type="text" name="highlight" id="highlight" size="4" maxlength="4" 
		   value="#debugSettings.debugoutput.executiontimes.highlight#" tabindex="9" />&nbsp;ms
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="database">Database Activity</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="database" id="database" value="true"
		   <cfif debugSettings.debugoutput.database.show> checked="true"</cfif> tabindex="10" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="exceptions">Exceptions</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="exceptions" id="exceptions" value="true"
		   <cfif debugSettings.debugoutput.exceptions.show> checked="true"</cfif> tabindex="11" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="tracepoints">Trace Points</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="tracepoints" id="tracepoints" value="true"
		   <cfif debugSettings.debugoutput.tracepoints.show> checked="true"</cfif> tabindex="12" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="timer">Timer Information</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="timer" id="timer" value="true"
		   <cfif debugSettings.debugoutput.timer.show> checked="true"</cfif> tabindex="13" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="variables">Variables</label></td>
	  <td bgcolor="##ffffff">
	    <input type="checkbox" name="variables" id="variables" value="true"
		   <cfif debugSettings.debugoutput.variables.show> checked="true"</cfif> tabindex="14" />
	  </td>
	</tr>
	<tr bgcolor="##dedede">
	  <td>&nbsp;</td>
	  <td><input type="submit" name="submit" value="Submit" tabindex="15" /></td>
	</tr>
      </table>
    </form>
    
    <br /><br />
    
    <form name="debugVariablesForm" action="_controller.cfm?action=processDebugVariablesForm" method="post">
      <table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
	<tr bgcolor="##dedede">
	  <td colspan="2"><strong>Debug and Error Variables</strong></td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right" valign="top">Variable Scopes</td>
	  <td bgcolor="##ffffff">
	    <table border="0" width="100%" cellpadding="2" cellspacing="2">
	      <tr>
		<td>
		  <input type="checkbox" name="local" id="local" value="true"
			 <cfif debugSettings.debugoutput.variables.local> checked="true"</cfif> tabindex="16" />
		  <label for="local">Local</label>
		</td>
		<td>
		  <input type="checkbox" name="url" id="url" value="true"
			 <cfif debugSettings.debugoutput.variables.url> checked="true"</cfif> tabindex="17" />
		  <label for="url">URL</label>
		</td>
		<td>
		  <input type="checkbox" name="session" id="session" value="true"
			 <cfif debugSettings.debugoutput.variables.session> checked="true"</cfif> tabindex="18" />
		  <label for="session">Session</label>
		</td>
	      </tr>
	      <tr>
		<td>
		  <input type="checkbox" name="variables" id="variablesScope" value="true"
			 <cfif debugSettings.debugoutput.variables.variables> checked="true"</cfif> tabindex="19" />
		  <label for="variablesScope">Variables</label>
		</td>
		<td>
		  <input type="checkbox" name="form" id="form" value="true"
			 <cfif debugSettings.debugoutput.variables.form> checked="true"</cfif> tabindex="20" />
		  <label for="form">Form</label>
		</td>
		<td>
		  <input type="checkbox" name="client" id="client" value="true"
			 <cfif debugSettings.debugoutput.variables.client> checked="true"</cfif> tabindex="21" />
		  <label for="client">Client</label>
		</td>
	      </tr>
	      <tr>
		<td>
		  <input type="checkbox" name="request" id="request" value="true"
			 <cfif debugSettings.debugoutput.variables.request> checked="true"</cfif> tabindex="22" />
		  <label for="request">Request</label>
		</td>
		<td>
		  <input type="checkbox" name="cookie" id="cookie" value="true"
			 <cfif debugSettings.debugoutput.variables.cookie> checked="true"</cfif> tabindex="23" />
		  <label for="cookie">Cookie</label>
		</td>
		<td>
		  <input type="checkbox" name="application" id="application" value="true"
			 <cfif debugSettings.debugoutput.variables.application> checked="true"</cfif> tabindex="24" />
		  <label for="application">Application</label>
		</td>
	      </tr>
	      <tr>
		<td>
		  <input type="checkbox" name="cgi" id="cgi" value="true"
			 <cfif debugSettings.debugoutput.variables.cgi> checked="true"</cfif> tabindex="25" />
		  <label for="cgi">CGI</label>
		</td>
		<td>
		  <input type="checkbox" name="cffile" id="cffile" value="true"
			 <cfif debugSettings.debugoutput.variables.cffile> checked="true"</cfif> tabindex="26" />
		  <label for="cffile">CFFILE</label>
		</td>
		<td>
		  <input type="checkbox" name="server" id="server" value="true"
			 <cfif debugSettings.debugoutput.variables.server> checked="true"</cfif> tabindex="27" />
		  <label for="server">Server</label>
		</td>
	      </tr>
	    </table>
	  </td>
	</tr>
	<tr bgcolor="##dedede">
	  <td>&nbsp;</td>
	  <td><input type="submit" name="submit" value="Submit" tabindex="28" /></td>
	</tr>
      </table>
    </form>
  </cfoutput>
</cfsavecontent>
