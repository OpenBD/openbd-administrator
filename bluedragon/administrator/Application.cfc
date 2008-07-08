<cfcomponent displayname"Application" output="false" hint="Application.cfc for OpenBD administrator">

	<cfscript>
		this.name = "OpenBDAdminConsole";
		this.sessionmanagement = true;
	</cfscript>
	
	<cffunction name="onApplicationStart" access="public" output="false" returntype="boolean">
		<cfscript>
			Application.administrator = createObject("component", "bluedragon.adminapi.administrator");
			Application.datasource = createObject("component", "bluedragon.adminapi.datasource");
			Application.extensions = createObject("component", "bluedragon.adminapi.extensions");
			Application.mail = createObject("component", "bluedragon.adminapi.mail");
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