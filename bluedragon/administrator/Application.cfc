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
			Application.serverSettings = createObject("component", "bluedragon.adminapi.ServerSettings");
			Application.variableSettings = createObject("component", "bluedragon.adminapi.VariableSettings");
			
			Application.adminConsoleVersion = "0.5a";
			Application.adminConsoleBuildDate = LSDateFormat(createDate(2008,7,17)) & " " & LSTimeFormat(createTime(17,16,00));
			
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