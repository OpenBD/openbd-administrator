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
  <cfparam name="ipAddressMessage" type="string" default="" />
  
  <cftry>
    <cfset ipAddresses = Application.debugging.getDebugIPAddresses() />
    <cfcatch type="bluedragon.adminapi.debugging">
      <cfset debuggingMessage = CFCATCH.Message />
      <cfset debuggingMessageType = "error" />
    </cfcatch>
  </cftry>
</cfsilent>
<cfsavecontent variable="request.content">
  <cfoutput>
    <script type="text/javascript">
      function validateAddIPAddressForm(f) {
        var ipCheck = /^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})$/;
        if (!ipCheck.test(f.ipaddress.value)) {
          alert("Please enter a valid IP address.");
          return false;
        } else {
          return true;
        }
      }
      
      function validateEditIPAddressForm(f) {
        if (f.ipaddresses.value.length == 0) {
          alert("Please select IP addresses to remove.");
          return false;
        } else {
          return true;
        }
      }
    </script>
    
    <h2>Debug IP Addresses</h2>
    
    <cfif structKeyExists(session, "message") and session.message.text is not "">
      <p class="#session.message.type#">#session.message.text#</p>
    </cfif>
    
    <cfif ipAddressMessage is not "">
      <p class="#ipAddressMessageType#">#ipAddressMessage#</p>
    </cfif>

    <cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
      <p class="error">The following errors occurred:</p>
      <ul>
	<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
	  <li>#session.errorFields[i][2]#</li>
	</cfloop>
      </ul>
    </cfif>
    
    <form name="addIPAddressForm" action="_controller.cfm?action=addIPAddress" method="post" 
	  onsubmit="javascript:return validateAddIPAddressForm(this);">
      <table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
	<tr bgcolor="##dedede">
	  <td colspan="2"><strong>Add IP Address</strong></td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="ipaddress">New IP Address</label></td>
	  <td bgcolor="##ffffff">
	    <input type="text" name="ipaddress" id="ipaddress" size="16" maxlength="15" tabindex="1" />
	  </td>
	</tr>
	<tr bgcolor="##dedede">
	  <td>&nbsp;</td>
	  <td>
	    <input type="button" name="addLocalIP" value="Add Local" tabindex="2" 
		   onclick="javascript:location.replace('_controller.cfm?action=addLocalIP');" />
	    <input type="submit" name="submit" value="Submit" tabindex="3" />
	  </td>
	</tr>
      </table>
    </form>
    
    <br /><br />

    <form name="editIPAddressForm" action="_controller.cfm?action=removeIPAddresses" method="post" 
	  onsubmit="javascript:return validateEditIPAddressForm(this);">
      <table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
	<tr bgcolor="##dedede">
	  <td colspan="2"><strong>Edit IP Addresses</strong></td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right" valign="top"><label for="ipaddresses">Configured IP Addresses</label></td>
	  <td bgcolor="##ffffff">
	    <select name="ipaddresses" id="ipaddresses" size="5" multiple="true" style="width:20em;" tabindex="4">
	      <cfif arrayLen(ipAddresses) gt 0>
		<cfloop index="i" from="1" to="#arrayLen(ipAddresses)#">
		  <option value="#ipAddresses[i]#">#ipAddresses[i]#</option>
		</cfloop>
	      </cfif>
	    </select>
	  </td>
	</tr>
	<tr bgcolor="##dedede">
	  <td>&nbsp;</td>
	  <td><input type="submit" name="submit" value="Remove Selected IPs" tabindex="5" /></td>
	</tr>
      </table>
    </form>
  </cfoutput>
</cfsavecontent>
