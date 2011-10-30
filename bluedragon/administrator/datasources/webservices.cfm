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
  <cfparam name="webServiceRetrievalMessage" type="string" default="" />
  <cfparam name="webServiceFormMessage" type="string" default="" />
  <cfparam name="webServices" type="array" default="#arrayNew(1)#" />
  <cfparam name="webServiceAction" type="string" default="create" />
  <cfparam name="formActionText" type="string" default="Add" />
  
  <cfif StructKeyExists(session, "webService")>
    <cfset webService = session.webService[1] />
    <cfset webServiceAction = "update" />
    <cfset formActionText = "Update" />
    <cfelse>
      <cfset webService = StructNew() />
      <cfset webService.name = "" />
      <cfset webService.wsdl = "" />
      <cfset webService.username = "" />
      <cfset webService.password = "" />
  </cfif>
  
  <cftry>
    <cfset webServices = Application.webServices.getWebServices() />
    
    <!--- if session.webServiceStatus exists, either one or all webservices are being verified so add that info to 
	the webservices --->
    <cfif StructKeyExists(session, "webServiceStatus")>
      <cfloop index="i" from="1" to="#ArrayLen(session.webServiceStatus)#">
	<cfloop index="j" from="1" to="#ArrayLen(webServices)#">
	  <cfif session.webServiceStatus[i].name == webServices[j].name>
	    <cfset webServices[j].verified = session.webServiceStatus[i].verified />
	    <cfset webServices[j].message = session.webServiceStatus[i].message />
	  </cfif>
	</cfloop>
      </cfloop>
    </cfif>
    
    <cfcatch type="any">
      <cfset webServiceRetrievalMessage = CFCATCH.Message />
      <cfset webServiceRetrievalMessageType = "error" />
    </cfcatch>
  </cftry>
</cfsilent>
<cfsavecontent variable="request.content">
  <cfoutput>
    <script type="text/javascript">
      function validate(f) {
        if (f.name.value.length == 0) {
          alert("Please enter the web service name");
          return false;
        } else if (f.wsdl.value.length == 0) {
          alert("Please enter the WSDL URL for the web service");
          return false;
        } else {
          return true;
        }
      }
      
      function removeWebService(webService) {
        if(confirm("Are you sure you want to remove this web service?")) {
          location.replace("_controller.cfm?action=deleteWebService&name=" + webService);
        }
      }
      
      function verifyWebService(webService) {
        location.replace("_controller.cfm?action=verifyWebService&name=" + webService);
      }
      
      function verifyAllWebServices() {
        location.replace("_controller.cfm?action=verifyWebService");
      }
    </script>
    
    <div class="row">
      <div class="pull-left">
	<h3>#formActionText# Web Service</h3>
      </div>
      <div class="pull-right">
	<button data-controls-modal="moreInfo" data-backdrop="true" data-keyboard="true" class="btn primary">More Info</button>
      </div>
    </div>
    
    <cfif StructKeyExists(session, "message") && session.message.text != "">
      <p class="#session.message.type#">#session.message.text#</p>
    </cfif>
    
    <form name="webServiceForm" action="_controller.cfm?action=processWebServiceForm" method="post" 
	  onsubmit="javascript:return validate(this);">
      <table border="0">
	<tr>
	  <td><label for="name">Web Service Name</label></td>
	  <td>
	    <input type="text" name="name" id="name" size="30" maxlength="50" value="#webService.name#" tabindex="1" />
	  </td>
	</tr>
	<tr>
	  <td><label for="wsdl">WSDL URL</label></td>
	  <td>
	    <input type="text" name="wsdl" id="wsdl" size="30" value="#webService.wsdl#" tabindex="2" />
	  </td>
	</tr>
	<tr>
	  <td><label for="username">User Name</label></td>
	  <td>
	    <input type="text" name="username" id="username" size="30" maxlength="100" 
		   value="#webService.username#" tabindex="3" />
	  </td>
	</tr>
	<tr>
	  <td><label for="password">Password</label></td>
	  <td>
	    <input type="password" name="password" id="password" size="30" maxlength="100" 
		   value="#webService.password#" tabindex="4" />
	  </td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td><input type="submit" name="submit" value="#formActionText# Web Service" tabindex="5" /></td>
	</tr>
      </table>
      <input type="hidden" name="webServiceAction" value="#webServiceAction#" />
      <input type="hidden" name="existingWebServiceName" value="#webService.name#" />
    </form>
    
    <hr noshade="true" />

    <h3>Web Services</h3>

    <cfif webServiceRetrievalMessage != "">
      <p class="#webServiceRetrievalMessageType#">#webServiceRetrievalMessage#</p>
    </cfif>
    
    <cfif ArrayLen(webServices) == 0>
      <p><strong><em>No web services configured</em></strong></p>
      <cfelse>
	<table border="0" width="100%" cellpadding="2" cellspacing="1" bgcolor="##999999">
	  <tr bgcolor="##dedede">
	    <td width="100"><strong>Actions</strong></td>
	    <td><strong>Name</strong></td>
	    <td><strong>WSDL URL</strong></td>
	    <td><strong>User Name</strong></td>
	    <td><strong>Password</strong></td>
	    <td><strong>Status</strong></td>
	  </tr>
	  <cfloop index="i" from="1" to="#ArrayLen(webServices)#">
	    <tr <cfif !StructKeyExists(webServices[i], "verified")>bgcolor="##ffffff"<cfelseif webServices[i].verified>bgcolor="##ccffcc"<cfelseif !webServices[i].verified>bgcolor="##ffff99"</cfif>>
	      <td width="100">
		<a href="_controller.cfm?action=editWebService&name=#webServices[i].name#" alt="Edit Web Service" 
		   title="Edit Web Service">
		  <img src="../images/pencil.png" border="0" width="16" height="16" />
		</a>
		<a href="_controller.cfm?action=verifyWebService&name=#webServices[i].name#" alt="Verify Web Service" 
		   title="Verify Web Service">
		  <img src="../images/accept.png" border="0" width="16" height="16" />
		</a>
		<a href="javascript:void(0);" onclick="javascript:removeWebService('#webServices[i].name#');" 
		   alt="Remove Web Service" title="Remove Web Service">
		  <img src="../images/cancel.png" border="0" width="16" height="16" />
		</a>
	      </td>
	      <td><cfif StructKeyExists(webServices[i], "displayname")>#webServices[i].displayname#<cfelse>#webServices[i].name#</cfif></td>
	      <td>#webServices[i].wsdl#</td>
	      <td>#webServices[i].username#</td>
	      <td><cfif webServices[i].password != "">#RepeatString("*", 8)#</cfif></td>
	      <td width="200">
		<cfif StructKeyExists(webServices[i], "verified")>
		  <cfif webServices[i].verified>
		    <img src="../images/tick.png" width="16" height="16" alt="Web Service Verified" 
			 title="Web Service Verified" />
		    <cfelseif !webServices[i].verified>
		      <img src="../images/exclamation.png" width="16" height="16" alt="Web Service Verification Failed" 
			   title="Web Service Verification Failed" /><br />
		      #webServices[i].message#
		  </cfif>
		  <cfelse>
		    &nbsp;
		</cfif>
	      </td>
	    </tr>
	  </cfloop>
	  <tr bgcolor="##dedede">
	    <td colspan="6">
	      <input type="button" name="verifyAll" value="Verify All Web Services" 
		     onclick="javascript:verifyAllWebServices()" tabindex="6" />
	    </td>
	  </tr>
	</table>
    </cfif>

  <div id="moreInfo" class="modal hide fade">
    <div class="modal-header">
      <a href="##" class="close">&times;</a>
      <h3>Information Concerning Web Services</h3>
    </div>
    <div class="modal-body">
      <ul>
	<li>
	  If Open BlueDragon throws an internal error while attempting to add a web service, and the stack trace begins with 
	  "java.lang.NoClassDefFoundError: sun/tools/javac/Main", this indicates that you do not have Java's tools.jar in your classpath. 
	  Either add the appropriate tools.jar to your classpath or copy tools.jar to Open BlueDragon's WEB-INF/lib directory.
	</li>
      </ul>
    </div>
  </div>
  </cfoutput>
  <cfset StructDelete(session, "webServiceRetrievalMessage", false) />
  <cfset StructDelete(session, "webService", false) />
  <cfset StructDelete(session, "webServiceStatus", false) />
</cfsavecontent>
