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
  <cfscript>
    contextPath = getPageContext().getRequest().getContextPath();
    
    if (contextPath is "/") {
      contextPath = "";
    }
    
    theSection = ListGetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, "/") - 1, "/");
    thePage = ListLast(CGI.SCRIPT_NAME, "/");
  </cfscript>
  <cfsetting showdebugoutput="false" />
</cfsilent>
<cfoutput>
  <html>
    <head>
      <title>Open BlueDragon Administrator</title>
      <link rel="shortcut icon" href="#contextPath#/bluedragon/administrator/images/favicon.ico" />
      <link rel="stylesheet" href="#contextPath#/bluedragon/administrator/css/bootstrap.css" type="text/css" />
      <script src="#contextPath#/bluedragon/administrator/js/jquery-1.6.4.min.js" type="text/javascript"></script>
      <script src="#contextPath#/bluedragon/administrator/js/bootstrap-dropdown.js" type="text/javascript"></script>
    </head>

    <body style="padding-top:40px;">
      <div class="container-fluid">
	<div class="topbar-wrapper" style="z-index: 5;">
	  <div class="topbar" data-dropdown="dropdown">
	    <div class="topbar-inner">
              <div class="container">
		<div class="pull-left"><img src="#contextPath#/bluedragon/administrator/images/openBD-204.jpg" border="0" height="40" width="204" /></div>
		<ul class="nav">
		  <li<cfif theSection is "administrator" and thePage is "index.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/index.cfm">Home</a></li>
		  <li class="dropdown<cfif theSection is 'settings'> active</cfif>">
		    <a href="##" class="dropdown-toggle">Server</a>
		    <ul class="dropdown-menu">
                      <li<cfif theSection is "settings" and thePage is "security.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/security.cfm">Security</a></li>
                      <li<cfif theSection is "settings" and ListFind("systeminfo.cfm,jvmproperties.cfm", thePage) neq 0> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/systeminfo.cfm">System Info</a></li>
		      <li<cfif theSection is "settings" and thePage is "index.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/index.cfm">Settings</a></li>
		      <li<cfif theSection is "settings" and thePage is "caching.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/caching.cfm">Caching</a></li>
		      <li<cfif theSection is "settings" and thePage is "variables.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/variables.cfm">Variables</a></li>
		      <li<cfif theSection is "settings" and thePage is "mappings.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/mappings.cfm">Mappings</a></li>
		      <li<cfif theSection is "settings" and thePage is "mail.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/mail.cfm">Mail</a></li>
		      <li<cfif theSection is "settings" and thePage is "fonts.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/fonts.cfm">Fonts</a></li>
		    </ul>
		  </li>
		  <li class="dropdown<cfif theSection is 'datasources'> active</cfif>">
		    <a href="##" class="dropdown-toggle">Data &amp; Services</a>
		    <ul class="dropdown-menu">
		      <li<cfif theSection is "datasources" and ListFind("index.cfm,h2-embedded.cfm,sqlserver-jtds.cfm,sqlserver2005-ms.cfm,mysql5.cfm,other.cfm,postgresql.cfm", thePage) neq 0> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/datasources/index.cfm">Datasources</a></li>
		      <li<cfif theSection is "datasources" and thePage is "collections.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/datasources/collections.cfm">Search Collections</a></li>
		    </ul>
		  </li>
		  <li class="dropdown<cfif theSection is 'debugging'> active</cfif>">
		    <a href="##" class="dropdown-toggle">Debugging & Logging</a>
		    <ul class="dropdown-menu">
		      <li<cfif theSection is "debugging" and thePage is "index.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/debugging/index.cfm">Debug Settings</a></li>
		      <li<cfif theSection is "debugging" and thePage is "ipaddresses.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/debugging/ipaddresses.cfm">Debug IP Addresses</a></li>
		      <li<cfif theSection is "debugging" and thePage is "scheduledtasks.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/debugging/scheduledtasks.cfm">Scheduled Tasks</a></li>
		      <li<cfif theSection is "debugging" and ListFind("logs.cfm,viewlogfile.cfm", thePage) neq 0> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/debugging/logs.cfm">Log Files</a></li>
		      <li<cfif theSection is "debugging" and ListFind("runtimeerrors.cfm,viewrtelog.cfm", thePage) neq 0> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/debugging/runtimeerrors.cfm">Runtime Error Logs</a></li>
		    </ul>
		  </li>
		  <li class="dropdown<cfif theSection is 'extensions'> active</cfif>">
		    <a href="##" class="dropdown-toggle">Extensions</a>
		    <ul class="dropdown-menu">
		      <li<cfif theSection is "extensions" and thePage is "customtagpaths.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/extensions/customtagpaths.cfm">Custom Tag Paths</a></li>
		      <li<cfif theSection is "extensions" and ListFind("cfxtags.cfm,javacfx.cfm,cppcfx.cfm", thePage) neq 0> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/extensions/cfxtags.cfm">CFX Tags</a></li>
		    </ul>
		  </li>
		</ul>
		<ul class="nav secondary-nav">
		  <li class="dropdown">
		    <a href="##" class="dropdown-toggle" style="width:120px;">Other Links</a>
		    <ul class="dropdown-menu">
		      <li><a href="http://www.openbd.org/manual" target="_blank">OpenBD Manual</a></li>
		      <li><a href="http://groups.google.com/group/openbd" target="_blank">OpenBD Google Group</a></li>
                      <li><a href="http://www.openbd.org" target="_blank">OpenBD Web Site</a></li>
		      <li><a href="http://wiki.openbd.org" target="_blank">OpenBD Wiki</a></li>
		      <li><a href="http://openbdcookbook.org" target="_blank">OpenBD Cookbook</a></li>
		      <li><a href="http://groups.google.com/group/cfml-conventional-wisdom" target="_blank">CFML Conventional Wisdom</a></li>
		      <li><a href="http://code.google.com/p/openbluedragon-admin-app/" target="_blank">OpenBD Admin Console Project</a></li>
		    </ul>
		  </li>
		  <li><a href="#contextPath#/bluedragon/administrator/_loginController.cfm?action=logout">Logout</a></li>
		</ul>
              </div>
	    </div><!-- /topbar-inner -->
	  </div><!-- /topbar -->
	</div><!-- /topbar-wrapper -->

	<div class="sidebar">
	  <h5>Server</h5>
	  <ul>
	    <li<cfif theSection is "settings" and thePage is "security.cfm"> class="active"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/security.cfm">Security</a></li>
	    <li<cfif theSection is "settings" and listFind("systeminfo.cfm,jvmproperties.cfm", thePage) neq 0> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/systeminfo.cfm">System Information</a></li>
	    <li<cfif theSection is "settings" and thePage is "index.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/index.cfm">Settings</a></li>
	    <li<cfif theSection is "settings" and thePage is "caching.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/caching.cfm">Caching</a></li>
	    <li<cfif theSection is "settings" and thePage is "variables.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/variables.cfm">Variables</a></li>
	    <li<cfif theSection is "settings" and thePage is "mappings.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/mappings.cfm">Mappings</a></li>
	    <li<cfif theSection is "settings" and thePage is "mail.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/mail.cfm">Mail</a></li>
	    <li<cfif theSection is "settings" and thePage is "fonts.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/fonts.cfm">Fonts</a></li>
	    <!--- TODO: implement thread page --->
	    <!--- <li<cfif theSection is "settings" and thePage is "threads.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/settings/threads.cfm">Threads</a></li> --->
	  </ul>
	  <h5>Data &amp; Services</h5>
	  <ul>
	    <li<cfif theSection is "datasources" and listFind("index.cfm,h2-embedded.cfm,sqlserver-jtds.cfm,sqlserver2005-ms.cfm,mysql5.cfm,other.cfm,postgresql.cfm", thePage) neq 0> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/datasources/index.cfm">Datasources</a></li>
	    <!--- TODO: implement runtime state page --->
	    <!--- <li<cfif theSection is "datasources" and thePage is "runtimestate.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/datasources/runtimestate.cfm">Runtime State</a></li> --->
	    <li<cfif theSection is "datasources" and thePage is "collections.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/datasources/collections.cfm">Search Collections</a></li>
	    <li<cfif theSection is "datasources" and thePage is "webservices.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/datasources/webservices.cfm">Web Services</a></li>
	  </ul>
	  <h5>Debugging &amp; Logging</h5>
	  <ul>
	    <li<cfif theSection is "debugging" and thePage is "index.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/debugging/index.cfm">Debug Settings</a></li>
	    <li<cfif theSection is "debugging" and thePage is "ipaddresses.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/debugging/ipaddresses.cfm">Debug IP Addresses</a></li>
	    <li<cfif theSection is "debugging" and thePage is "scheduledtasks.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/debugging/scheduledtasks.cfm">Scheduled Tasks</a></li>
	    <li<cfif theSection is "debugging" and listFind("logs.cfm,viewlogfile.cfm", thePage) neq 0> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/debugging/logs.cfm">Log Files</a></li>
	    <li<cfif theSection is "debugging" and listFind("runtimeerrors.cfm,viewrtelog.cfm", thePage) neq 0> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/debugging/runtimeerrors.cfm">Runtime Error Logs</a></li>
	  </ul>
	  <h5>Extensions</h5>
	  <ul>
	    <li<cfif theSection is "extensions" and thePage is "customtagpaths.cfm"> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/extensions/customtagpaths.cfm">Custom Tag Paths</a></li>
	    <li<cfif theSection is "extensions" and listFind("cfxtags.cfm,javacfx.cfm,cppcfx.cfm", thePage) neq 0> class="highlight"</cfif>><a href="#contextPath#/bluedragon/administrator/extensions/cfxtags.cfm">CFX Tags</a></li>
	  </ul>
	</div>
	
	<div class="content">
	  #Replace(request.content, "${contextPath}", contextPath, "ALL")#
	</div>

	<div class="clearfix">
	  Copyright &copy; 2008 - #Year(Now())# 
	  <a href="http://www.openbd.org" target="_blank">Open BlueDragon Project</a>
	  Version #Application.adminConsoleVersion# - #Application.adminConsoleBuildDate#
	</div>
      </div>
    </body>
  </html>
</cfoutput>
