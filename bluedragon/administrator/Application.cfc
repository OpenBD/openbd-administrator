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
<cfcomponent displayname"Application" output="false" hint="Application.cfc for OpenBD administrator">

	<cfscript>
		this.name = "OpenBDAdminConsole";
		this.sessionmanagement = true;
	</cfscript>
	
	<cffunction name="onApplicationStart" access="public" output="false" returntype="boolean">
		<cfscript>
			Application.administrator = createObject("component", "bluedragon.adminapi.Administrator");
			Application.caching = createObject("component", "bluedragon.adminapi.Caching");
			Application.chart = createObject("component", "bluedragon.adminapi.Chart");
			Application.datasource = createObject("component", "bluedragon.adminapi.Datasource");
			Application.debugging = createObject("component", "bluedragon.adminapi.Debugging");
			Application.extensions = createObject("component", "bluedragon.adminapi.Extensions");
			Application.fonts = createObject("component", "bluedragon.adminapi.Fonts");
			Application.mail = createObject("component", "bluedragon.adminapi.Mail");
			Application.mapping = createObject("component", "bluedragon.adminapi.Mapping");
			Application.scheduledTasks = createObject("component", "bluedragon.adminapi.ScheduledTasks");
			Application.searchCollections = createObject("component", "bluedragon.adminapi.SearchCollections");
			Application.serverSettings = createObject("component", "bluedragon.adminapi.ServerSettings");
			Application.variableSettings = createObject("component", "bluedragon.adminapi.VariableSettings");
			Application.webServices = createObject("component", "bluedragon.adminapi.WebServices");
			
			Application.adminConsoleVersion = "1.4";
			Application.adminConsoleBuildDate = LSDateFormat(createDate(2010,10,27)) & " " & LSTimeFormat(createTime(00,00,00));
			
			// Need to make sure the basic security nodes exist in bluedragon.xml. Other potential missing nodes
			// are handled as the related pages within the administrator are hit.
			Application.administrator.setInitialSecurity();
			
			Application.inited = true;
			
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="onRequestStart" access="public" output="false" returntype="boolean">
		<cfargument name="thePage" type="string" required="true" />
		
		<!--- handle the allow/deny IP addresses --->
		<cfset var allowedIPs = Application.administrator.getAllowedIPs() />
		<cfset var allowedIP = "" />
		<cfset var deniedIPs = Application.administrator.getDeniedIPs() />
		<cfset var deniedIP = "" />
		<cfset var allow = false />
		<cfset var remoteAddrOctets = "" />
		<cfset var allowedIPOctets = "" />
		<cfset var deniedIPOctets = "" />
		<cfset var octetMatchCount = 0 />
		<cfset var contextPath = "" />
		<cfset var i = 0 />
		
		<cfif not structKeyExists(Application, "inited") or not Application.inited or structKeyExists(url, "reload")>
			<cfset onApplicationStart() />
		</cfif>
		
		<!--- never deny localhost for safety's sake --->
 		<cfif CGI.REMOTE_ADDR is not "127.0.0.1" and (allowedIPs is not "" or deniedIPs is not "")>
			<!--- check denied IPs first--these take precedence over allows --->
			<cfif deniedIPs is not "">
				<!--- if it's an exact match, obviously we abort --->
				<cfif listFind(deniedIPs, CGI.REMOTE_ADDR, ",")>
					<cfabort />
				<!--- if there are wildcards, need to check further --->
				<cfelseif listContains(deniedIPs, "*", ",")>
					<cfloop list="#deniedIPs#" index="deniedIP">
						<cfset octetMatchCount = 0 />
						
						<cfif listFind(deniedIP, "*", ".") neq 0>
							<cfset remoteAddrOctets = listToArray(CGI.REMOTE_ADDR, ".") />
							<cfset deniedIPOctets = listToArray(deniedIP, ".") />
							
							<cfloop index="i" from="1" to="#arrayLen(deniedIPOctets)#">
								<cfif remoteAddrOctets[i] eq deniedIPOctets[i] 
										or deniedIPOctets[i] is "*">
									<cfset octetMatchCount = octetMatchCount + 1 />
								</cfif>
							</cfloop>
							
							<cfif octetMatchCount eq arrayLen(deniedIPOctets)>
								<cfabort />
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			
			<!--- check allow IPs --->
			<cfif allowedIPs is not "">
				<cfif listContains(allowedIPs, "*", ",")>
					<cfloop list="#allowedIPs#" index="allowedIP">
						<cfset octetMatchCount = 0 />
						
						<cfif listFind(allowedIP, "*", ".") neq 0>
							<cfset remoteAddrOctets = listToArray(CGI.REMOTE_ADDR, ".") />
							<cfset allowedIPOctets = listToArray(allowedIP, ".") />
							
							<cfloop index="i" from="1" to="#arrayLen(allowedIPOctets)#">
								<cfif remoteAddrOctets[i] eq allowedIPOctets[i] 
										or allowedIPOctets[i] is "*">
									<cfset octetMatchCount = octetMatchCount + 1 />
								</cfif>
							</cfloop>
							
							<cfif octetMatchCount neq arrayLen(allowedIPOctets)>
								<cfabort />
							</cfif>
						</cfif>
					</cfloop>
				<cfelseif not listFind(allowedIPs, CGI.REMOTE_ADDR, ",")>
					<cfabort />
				</cfif>
			</cfif>
		</cfif>

		<cfif not Application.administrator.isUserLoggedIn() 
				and listLast(CGI.SCRIPT_NAME, "/") is not "login.cfm" 
				and listLast(CGI.SCRIPT_NAME, "/") is not "_loginController.cfm">
			<cfset contextPath = getPageContext().getRequest().getContextPath() />
			
			<cfif contextPath is "/">
				<cfset contextPath = "" />
			</cfif>
			
			<cflocation url="#contextPath#/bluedragon/administrator/login.cfm" addtoken="false" />
		</cfif>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="onRequestEnd" access="public" output="true" returntype="void">
		<cfargument name="thePage" type="string" required="true" />
		
		<!--- clear out any lingering session data that's already been output --->
		<cfset structDelete(session, "message", false) />
		<cfset structDelete(session, "errorFields", false) />
		
		<cfif listLast(CGI.SCRIPT_NAME, "/") is "login.cfm">
			<cfinclude template="/bluedragon/administrator/blankTemplate.cfm" />
		<cfelse>
			<cfinclude template="/bluedragon/administrator/template.cfm" />
		</cfif>
	</cffunction>
	
</cfcomponent>