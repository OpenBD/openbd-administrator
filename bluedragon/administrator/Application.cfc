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
			
			Application.adminConsoleVersion = "1.0";
			Application.adminConsoleBuildDate = LSDateFormat(createDate(2008,10,01)) & " " & LSTimeFormat(createTime(11,15,00));
			
			Application.inited = true;
			
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="onRequestStart" access="public" output="false" returntype="boolean">
		<cfargument name="thePage" type="string" required="true" />
		
		<cfscript>
			// reload the application scope cfcs
			if (not structKeyExists(Application, "inited") or not Application.inited or structKeyExists(url, "reload")) {
				onApplicationStart();
			}
			
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="onRequestEnd" access="public" output="true" returntype="void">
		<cfargument name="thePage" type="string" required="true" />
		
		<cfinclude template="/bluedragon/administrator/template.cfm" />
	</cffunction>
	
</cfcomponent>