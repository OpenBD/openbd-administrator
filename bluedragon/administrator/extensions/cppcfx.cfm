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
  <cfparam name="cfxTagMessage" type="string" default="" />
  <cfparam name="cfxTagMessageType" type="string" default="" />
  <cfparam name="cfxTag" type="struct" default="#structNew()#" />
  <cfparam name="cfxTagAction" type="string" default="create" />
  
  <cfif StructKeyExists(session, "cfxTag")>
    <cfset cfxTag = session.cfxTag />
    <cfset cfxAction = "update" />
    <cfset submitButtonAction = "Update" />
    <cfelse>
      <cfset cfxTag = {name:'', displayname:'cfx_', description:'', 
	               module:'', function:'', keeploaded:true, 
	               cfxAction:'create', submitButtonAction:'Register'} />
  </cfif>
</cfsilent>
<cfsavecontent variable="request.content">
  <cfoutput>
    <script type="text/javascript">
      function validate(f) {
        var tagNameTest = /^([a-zA-Z0-9_-]+)$/;
      
        if (f.name.value.length == 0) {
          alert("Please enter the tag name");
          return false;
        } else if (f.name.value.substring(0,4).toLowerCase() != 'cfx_') {
          alert("Custom tag names must start with cfx_");
          return false;
        } else if (!tagNameTest.test(f.name.value)) {
          alert("Custom tag names may only include alphanumeric characters, hypens, and underscores");
          return false;
        } else if (f.module.value.length == 0) {
          alert("Please enter the class name");
          return false;
        } else if (f.function.value.length == 0) {
          alert("Please enter the function name");
          return false;
        } else {
          return true;
        }
      }
    </script>
    
    <div class="row">
      <div class="pull-left">
	<h2>C++ CFX Tag</h2>
      </div>
      <div class="pull-right">
	<button data-controls-modal="moreInfo" data-backdrop="true" data-keyboard="true" class="btn primary">More Info</button>
      </div>
    </div>
    
    <cfif StructKeyExists(session, "message") && session.message.text != "">
      <p class="#session.message.type#">#session.message.text#</p>
    </cfif>
    
    <cfif cfxTagMessage != "">
      <p class="#cfxTagMessageType#">#cfxTagMessage#</p>
    </cfif>

    <cfif StructKeyExists(session, "errorFields") && ArrayLen(session.errorFields) gt 0>
      <p class="error">The following errors occurred:</p>
      <ul>
	<cfloop index="i" from="1" to="#ArrayLen(session.errorFields)#">
	  <li>#session.errorFields[i][2]#</li>
	</cfloop>
      </ul>
    </cfif>
    
    <form action="_controller.cfm?action=processCPPCFXForm" method="post" onsubmit="javascript:return validate(this);">
      <table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="600">
	<tr>
	  <td bgcolor="##f0f0f0"><strong><label for="name">Tag Name</label></strong></td>
	  <td bgcolor="##ffffff">
	    <input type="text" name="name" id="name" size="40" value="#cfxTag.displayname#" tabindex="1" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0"><strong><label for="module">Module Name</label></strong></td>
	  <td bgcolor="##ffffff">
	    <input type="text" name="module" id="module" size="40" value="#cfxTag.module#" tabindex="2" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0"><strong><label for="function">Function Name</label></strong></td>
	  <td bgcolor="##ffffff">
	    <input type="text" name="function" id="function" size="40" value="#cfxTag.function#" tabindex="3" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0"><strong>Keep Loaded</strong></td>
	  <td bgcolor="##ffffff">
	    <input type="radio" name="keeploaded" id="keeploadedTrue" value="true"
		   <cfif cfxTag.keeploaded> checked="true"</cfif> tabindex="4" />
	    <label for="keeploadedTrue">Yes</label>&nbsp;
	    <input type="radio" name="keeploaded" id="keeploadedFalse" value="false"
		   <cfif not cfxTag.keeploaded> checked="true"</cfif> tabindex="5" />
	    <label for="keeploadedFalse">No</label>
	  </td>
	</tr>
	<tr>
	  <td valign="top" bgcolor="##f0f0f0"><strong><label for="description">Description</label></strong></td>
	  <td valign="top" bgcolor="##ffffff">
	    <textarea name="description" id="description" cols="40" rows="6" tabindex="6">#cfxTag.description#</textarea>
	  </td>
	</tr>
	<tr bgcolor="##f0f0f0">
	  <td align="right">
	    <input type="button" name="cancel" id="cancel" value="Cancel" 
		   onclick="javascript:location.replace('cfxtags.cfm');" tabindex="7" />
	  </td>
	  <td>
	    <input type="submit" name="submit" id="submit" value="#submitButtonAction# C++ CFX Tag" tabindex="8" />
	  </td>
	</tr>
      </table>
      <input type="hidden" name="existingCFXName" value="#cfxTag.name#" />
      <input type="hidden" name="cfxAction" value="#cfxAction#" />
    </form>

    <div id="moreInfo" class="modal hide fade">
      <div class="modal-header">
	<a href="##" class="close">&times;</a>
	<h3>Important Information Concerning C++ Custom Tags</h3>
      </div>
      <div class="modal-body">
	<ul>
	  <li>The path to the C++ module may be specified as a full path or a relative path.</li>

	  <li>
	    When specifying a full physical path on UNIX-based systems (including GNU/Linux and Mac OS X), you must place 
	    a "$" at the beginning of the path. For example:<br />
	    $/usr/local/myPath
	  </li>
	  <li>
	    A path beginning with "/" is interpreted as a relative path from the web application root directory, which 
	    may be a subdirectory of the WEB-INF directory.
	  </li>
	</ul>
      </div>
    </div>
  </cfoutput>
</cfsavecontent>
