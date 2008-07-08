<!---
	Copyright (C) 2008  David C. Epler - dcepler@dcepler.net

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--->
<cfcomponent name="datasource" 
		extends="bluedragon.adminapi.base" 
		displayname="datasource [OpenBD AdminAPI]" 
		hint="Add, modify, and delete OpenBD data sources">
	
	<!--- PUBLIC METHODS --->
	<cffunction name="createDatasource" access="public" output="false" returntype="void" hint="Creates a new datasource">
		<cfargument name="name" type="string" required="true" hint="OpenBD Datasource Name" />
		<cfargument name="databasename" type="string" required="true" hint="Database name on the database server" />
		<cfargument name="server" type="string" required="true" hint="Database server host name or IP address" />
		<cfargument name="dbType" type="string" required="true" hint="Database type (e.g. mysql5, sqlserver, postgres, other, etc.)" />
		<cfargument name="username" type="string" required="false" default="" hint="Database username" />
		<cfargument name="password" type="string" required="false" default="" hint="Database password" />
		<cfargument name="port"	type="numeric" required="false" default="0" hint="Port that is used to access the database server" />
		<cfargument name="description" type="string" required="false" default="" hint="A description of this data source" />
		<cfargument name="initstring" type="string" required="false" default="" hint="Additional initialization settings" />
		<cfargument name="connectiontimeout" type="numeric" required="false" default="120" hint="Number of seconds OpenBD maintains an unused connection before it is destroyed" />
		<cfargument name="connectionretries" type="numeric" required="false" default="0" hint="Number of connection retry attempts to make" />
		<cfargument name="logintimeout" type="numeric" required="false" default="120" hint="Number of seconds before OpenBD times out the data source connection login attempt" />
		<cfargument name="maxconnections" type="numeric" required="false" default="3" hint="Maximum number of simultaneous database connections" />
		<cfargument name="perrequestconnections" type="boolean" required="false" default="false" hint="Indication of whether or not to pool connections" />
		<cfargument name="sqlselect" type="boolean" required="false" default="true" hint="Allow SQL SELECT statements from this datasource" />
		<cfargument name="sqlinsert" type="boolean" required="false" default="true" hint="Allow SQL INSERT statements from this datasource" />
		<cfargument name="sqlupdate" type="boolean" required="false" default="true" hint="Allow SQL UPDATE statements from this datasource" />
		<cfargument name="sqldelete" type="boolean" required="false" default="true" hint="Allow SQL DELETE statements from this datasource" />
		<cfargument name="sqlstoredprocedures" type="boolean" required="false" default="true" hint="Allow SQL stored procedure calls from this datasource" />
		<cfargument name="drivername" type="string" required="false" default="" hint="JDBC Driver Name (class) to use" />
		
		<cfset var localConfig = getConfig() />
		<cfset var defaultSettings = structNew() />
		<cfset var datasourceSettings = structNew() />
		<cfset var datasourceVerified = false />
		
		<!--- make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "cfquery")) OR (NOT StructKeyExists(localConfig.cfquery, "datasource"))>
			<cfset localConfig.cfquery.datasource = ArrayNew(1) />
		</cfif>
		
		<cfdump var="#localConfig#" expand="true" />
		<cfabort />
		
		<!--- make sure the datasource doesn't already exist --->
		
		<!--- if we don't have a drivername or port, use the defaults for the database type --->
		<cfif arguments.drivername is "" or arguments.port eq 0>
			<cfset defaultSettings = getDBTypeDefaults(arguments.dbType) />
		</cfif>

		<cfif arguments.drivername is "">
			<cfset arguments.drivername = defaultSettings.drivername />
		</cfif>
		
		<cfif arguments.port eq 0>
			<cfset arguments.port = defaultSettings.port />
		</cfif>
		
		<!--- TODO: figure out how best to handle known database types vs. "other" type and when to throw an exception --->
		<!--- TODO: figure out how to incorporate file-based databases like the dreaded Access, Derby, etc. --->
		
		<!--- build up the datasource settings --->
		<cfscript>
			// build up the datasource settings
			datasourceSettings.name = trim(arguments.name);
			datasourceSettings.databasename = trim(arguments.databasename);
			datasourceSettings.username = trim(arguments.username);
			datasourceSettings.password = trim(arguments.password);
			datasourceSettings.drivername = trim(arguments.drivername);
			datasourceSettings.hoststring = formatJDBCURL(trim(arguments.drivername), trim(arguments.server), 
															trim(arguments.port), trim(arguments.databasename));
			datasourceSettings.initstring = trim(arguments.initstring);
			datasourceSettings.sqlselect = arguments.sqlselect;
			datasourceSettings.sqlinsert = arguments.sqlinsert;
			datasourceSettings.sqlupdate = arguments.sqlupdate;
			datasourceSettings.sqldelete = arguments.sqldelete;
			datasourceSettings.sqlstoredprocedures = arguments.sqlstoredprocedures;
			datasourceSettings.logintimeout = ToString(arguments.logintimeout);
			datasourceSettings.connectiontimeout = ToString(arguments.connectiontimeout);
			datasourceSettings.connectionretries = ToString(arguments.connectionretries);
			datasourceSettings.maxconnections = ToString(arguments.maxconnections);
			datasourceSettings.perrequestconnections = arguments.perrequestconnections;
			
			// prepend the new datasource to the localconfig array
			arrayPrepend(localConfig.cfquery.datasource, structCopy(datasourceSettings));
			
			// set the new config data
			setConfig(localConfig);
			
			// register the driver and verify the datasource
			registerDriver(arguments.drivername);
			//datasourceVerified = verifyDatasource(trim(arguments.name));
		</cfscript>
	</cffunction>

	<cffunction name="getDatasources" access="public" output="false" returntype="array" hint="Returns an array containing all the data sources or a specified data source">
		<cfargument name="dsnname" required="false" type="string" hint="The name of a data source to return data on" />
		<cfset var localConfig = getConfig() />
		<cfset var returnArray = "" />
		<cfset var dsnIndex = "" />
		
		<!--- Make sure there are datasources --->
		<cfif (NOT StructKeyExists(localConfig, "cfquery")) OR (NOT StructKeyExists(localConfig.cfquery, "datasource"))>
			<cfthrow message="No registered datasources" type="bluedragon.adminapi.datasource" />
		</cfif>
		
		<!--- Return entire data source array, unless a data source name is specified --->
		<cfif NOT IsDefined("arguments.dsnname")>
			<cfreturn localConfig.cfquery.datasource />
		<cfelse>
			<cfset returnArray = ArrayNew(1) />
			<cfloop index="dsnIndex" from="1" to="#ArrayLen(localConfig.cfquery.datasource)#">
				<cfif localConfig.cfquery.datasource[dsnIndex].name EQ arguments.dsnname>
					<cfset returnArray[1] = Duplicate(localConfig.cfquery.datasource[dsnIndex]) />
					<cfreturn returnArray />
				</cfif>
			</cfloop>
			<cfthrow message="#arguments.dsnname# not registered as a datasource" type="bluedragon.adminapi.datasource">
		</cfif>
	</cffunction>
	
	<cffunction name="deleteDatasource" access="public" output="false" returntype="void" hint="Delete the specified data source">
		<cfargument name="dsnname" required="true" type="string" hint="The name of the data source to be deleted" />
		<cfset var localConfig = getConfig() />

		<!--- Make sure there are datasources --->
		<cfif (NOT StructKeyExists(localConfig, "cfquery")) OR (NOT StructKeyExists(localConfig.cfquery, "datasource"))>
			<cfthrow message="No datasources defined" type="bluedragon.adminapi.datasource">		
		</cfif>

		<cfloop index="dsnIndex" from="1" to="#ArrayLen(localConfig.cfquery.datasource)#">
			<cfif localConfig.cfquery.datasource[dsnIndex].name EQ arguments.dsnname>
				<cfset ArrayDeleteAt(localConfig.cfquery.datasource, dsnIndex) />
				<cfset setConfig(localConfig) />
				<cfreturn />
			</cfif>
		</cfloop>
		<cfthrow message="#arguments.dsnname# not registered as a datasource" type="bluedragon.adminapi.datasource">
	</cffunction>

	
	<!--- PRIVATE METHODS --->
	<cffunction name="formatJDBCURL" access="private" output="false" returntype="string" hint="Formats a JDBC URL for a specific database driver type">
		<cfargument name="drivername" type="string" required="true" hint="The name of the database driver class" />
		<cfargument name="server" type="string" required="true" hint="The database server name or IP address" />
		<cfargument name="port" type="numeric" required="true" hint="The database server port" />
		<cfargument name="database" type="string" required="true" hint="The database name" />
		
		<cfset var jdbcURL = "" />
		
		<cfswitch expression="#arguments.drivername#">
			<cfcase value="com.mysql.jdbc.Driver">
				<!--- format is jdbc:mysql://[host][,failoverhost...][:port]/[database][?propertyName1][=propertyValue1][&propertyName2][=propertyValue2] --->
				<cfset jdbcURL = "jdbc:mysql://#arguments.server#:#arguments.port#/#arguments.database#" />
			</cfcase>
		</cfswitch>

		<cfreturn jdbcURL />
	</cffunction>
	
	<cffunction name="getDBTypeDefaults" access="private" output="false" returntype="struct" hint="Returns a struct containing default settings for a specific database type">
		<cfargument name="dbType" type="string" required="true" />
		
		<cfset var defaultSettings = structNew() />
		
		<cfswitch expression="#arguments.dbType#">
			<cfcase value="mysql5">
				<cfset defaultSettings.drivername = "com.mysql.jdbc.Driver" />
				<cfset defaultSettings.port = 3306 />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Cannot retrieve default settings for an unknown database type." type="bluedragon.adminapi.datasource" />
			</cfdefaultcase>
		</cfswitch>
		
		<cfreturn structCopy(defaultSettings) />
	</cffunction>
	
	<cffunction name="registerDriver" access="private" output="false" returntype="boolean" hint="">
		<cfargument name="class" type="string" required="true" hint="JDBC class name" />
	
		<cfset var javaClass = "" />
		<cfset var registerJDBCDriver = "" />
		<cftry>
			<cfset registerJDBCDriver = createObject("java", "java.lang.Class").forName(arguments.class) />
			
			<cfcatch type="any">
				<cfthrow message="Could not register #arguments.class#" type="bluedragon.adminapi.datasource" />
			</cfcatch>
		</cftry>

		<cfreturn true />
	</cffunction>

	<cffunction name="setMSSQL" access="public" output="false" returntype="void" hint="Creates or modifies a MS SQL Server data source">
		<cfargument name="name" type="string" required="true" hint="BlueDragon datasource name" />
		<cfargument name="servername" type="string" required="true" hint="Database server host name or IP address" />
		<cfargument name="databasename" type="string" required="true" hint="Databasename that corresponds to the data source" />
		<cfargument name="username" type="string" default="" hint="Database username" />
		<cfargument name="password" type="string" default="" hint="Database password" />
		<cfargument name="port"	type="numeric" default="1433" hint="Port that is used to access the database server (Default: 1433)" />
		<cfargument name="drivername" type="string" default="com.newatlanta.com.jturbo.driver.Driver" hint="JDBC Driver Name (class) to use" />
		<cfargument name="drivertype" type="numeric" default="0" hint="BlueDragon Driver Type (Default: 0)" />
		<cfargument name="drivertypedesc" type="string" default="Microsoft SQL Server (JTurbo)" hint="Driver Type Description" />
		<cfargument name="connectstring" type="string" default="" hint="" />
		<cfargument name="description" type="string" default="" hint="A description of this data source" />
		<cfargument name="connectiontimeout" type="numeric" default="120" hint="Number of seconds BlueDragon maintains an unused connection before it is destroyed" />
		<cfargument name="logintimeout" type="numeric" default="120" hint="Number of seconds before BlueDragon times out the data source connection login attempt" />
		<cfargument name="maxconnections" type="numeric" default="3" hint="Limit connections to this maximum amount" />
		<cfargument name="sqldelete" type="boolean" default="true" hint="Allow SQL DELETE statements" />
		<cfargument name="sqlinsert" type="boolean" default="true" hint="Allow SQL INSERT statements" />
		<cfargument name="sqlselect" type="boolean" default="true" hint="Allow SQL SELECT statements" />
		<cfargument name="sqlupdate" type="boolean" default="true" hint="Allow SQL UPDATE statements" />
		<cfargument name="sqlstoredprocedures" type="boolean" default="true" hint="Allow SQL stored procedure calls" />
		
		<cfset var localConfig = getConfig() />
		<cfset var dsnStruct = StructNew() />

		<!--- Make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "cfquery")) OR (NOT StructKeyExists(localConfig.cfquery, "datasource"))>
			<cfset localConfig.cfquery.datasource = ArrayNew(1) />
		</cfif>

		<!--- Build datasource Struct --->
		<cfset dsnStruct.name = arguments.name />
		<cfset dsnStruct.servername = arguments.servername />
		<cfset dsnStruct.databasename = arguments.databasename />
		<cfset dsnStruct.port = ToString(arguments.port) />
		<cfset dsnStruct.username = arguments.username />
		<cfset dsnStruct.password = arguments.password />
		<cfset dsnStruct.connectstring = arguments.connectstring />
		<cfset dsnStruct.description = arguments.description />
		<cfset dsnStruct.connectiontimeout = ToString(arguments.connectiontimeout) />
		<cfset dsnStruct.logintimeout = ToString(arguments.logintimeout) />
		<cfset dsnStruct.maxconnections = ToString(arguments.maxconnections) />
		<cfset dsnStruct.sqldelete = arguments.sqldelete />
		<cfset dsnStruct.sqlinsert = arguments.sqlinsert />
		<cfset dsnStruct.sqlselect = arguments.sqlselect />
		<cfset dsnStruct.sqlupdate = arguments.sqlupdate />
		<cfset dsnStruct.sqlstoredprocedures = arguments.sqlstoredprocedures />

		<!--- If using alternate "known" driver --->
		<cfswitch expression="#arguments.drivername#">
			<cfcase value="com.newatlanta.com.jturbo.driver.Driver">
				<cfset dsnStruct.drivertype = "0" />
				<cfset dsnStruct.drivertypedesc = "Microsoft SQL Server (JTurbo)" />
				<cfset dsnStruct.hoststring = "jdbc:JTurbo://" & arguments.servername & ":" & arguments.port & "/" & arguments.databasename />
			</cfcase>
			<cfcase value="net.sourceforge.jtds.jdbc.Driver">
				<cfset dsnStruct.drivertype = "4" />
				<cfset dsnStruct.drivertypedesc = "Microsoft SQL Server (jTDS)" />
				<cfset dsnStruct.hoststring = "jdbc:jtds:sqlserver://" & arguments.servername & ":" & arguments.port & "/" & arguments.databasename />
			</cfcase>
			<cfcase value="com.microsoft.jdbc.sqlserver.SQLServerDriver">
				<cfset dsnStruct.drivertype = "4" />
				<cfset dsnStruct.drivertypedesc = "Microsoft SQL Server (Microsoft)" />
				<cfset dsnStruct.hoststring = "jdbc:microsoft:sqlserver://" & arguments.servername & ":" & arguments.port & ";databasename=" & arguments.databasename />
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="Invalid drivername for SetMSSQL(), possibly use SetOther() instead" type="bluedragon.adminapi.datasource" />
			</cfdefaultcase>
		</cfswitch>

		<!--- Prepend it to the datasource array --->
		<cfset ArrayPrepend(localConfig.cfquery.datasource, Duplicate(dsnStruct)) />
		<cfset setConfig(localConfig) />
		
		<cfset registerDriver(arguments.drivername) />

		<!--- 
			Without verifying the DSN, BlueDragon Administration Application errors
			about dataSourceStatusArray[y].success and the DSN cannot be used
		--->
		<cfset verifyDSN(dsnStruct.name) />
	</cffunction>

	<cffunction name="setMySQL" access="public" output="false" returntype="void" hint="Creates or modifies a MySQL data source">
		<cfargument name="name" type="string" required="true" hint="BlueDragon datasource name" />
		<cfargument name="servername" type="string" required="true" hint="Database server host name or IP address" />
		<cfargument name="databasename" type="string" required="true" hint="Databasename that corresponds to the data source" />
		<cfargument name="username" type="string" default="" hint="Database username" />
		<cfargument name="password" type="string" default="" hint="Database password" />
		<cfargument name="port"	type="numeric" default="3306" hint="Port that is used to access the database server (Default: 3306)" />
		<cfargument name="drivername" type="string" default="com.mysql.jdbc.Driver" hint="JDBC Driver Name (class) to use" />
		<cfargument name="drivertype" type="numeric" default="2" hint="BlueDragon Driver Type (Default: 2)" />
		<cfargument name="drivertypedesc" type="string" default="MySQL" hint="Driver Type Description" />
		<cfargument name="connectstring" type="string" default="" hint="" />
		<cfargument name="description" type="string" default="" hint="A description of this data source" />
		<cfargument name="connectiontimeout" type="numeric" default="120" hint="Number of seconds BlueDragon maintains an unused connection before it is destroyed" />
		<cfargument name="logintimeout" type="numeric" default="120" hint="Number of seconds before BlueDragon times out the data source connection login attempt" />
		<cfargument name="maxconnections" type="numeric" default="3" hint="Limit connections to this maximum amount" />
		<cfargument name="sqldelete" type="boolean" default="true" hint="Allow SQL DELETE statements" />
		<cfargument name="sqlinsert" type="boolean" default="true" hint="Allow SQL INSERT statements" />
		<cfargument name="sqlselect" type="boolean" default="true" hint="Allow SQL SELECT statements" />
		<cfargument name="sqlupdate" type="boolean" default="true" hint="Allow SQL UPDATE statements" />
		<cfargument name="sqlstoredprocedures" type="boolean" default="true" hint="Allow SQL stored procedure calls" />
		
		<cfset var localConfig = getConfig() />
		<cfset var dsnStruct = StructNew() />

		<!--- Make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "cfquery")) OR (NOT StructKeyExists(localConfig.cfquery, "datasource"))>
			<cfset localConfig.cfquery.datasource = ArrayNew(1) />
		</cfif>

		<!--- Build datasource Struct --->
		<cfset dsnStruct.name = arguments.name />
		<cfset dsnStruct.servername = arguments.servername />
		<cfset dsnStruct.databasename = arguments.databasename />
		<cfset dsnStruct.port = ToString(arguments.port) />
		<cfset dsnStruct.drivername = arguments.drivername />
		<cfset dsnStruct.drivertype = ToString(arguments.drivertype) />
		<cfset dsnStruct.drivertypedesc = arguments.drivertypedesc />
		<cfset dsnStruct.username = arguments.username />
		<cfset dsnStruct.password = arguments.password />
		<cfset dsnStruct.hoststring = "jdbc:mysql://" & arguments.servername & ":" & arguments.port & "/" & arguments.databasename />
		<cfset dsnStruct.connectstring = arguments.connectstring />
		<cfset dsnStruct.description = arguments.description />
		<cfset dsnStruct.connectiontimeout = ToString(arguments.connectiontimeout) />
		<cfset dsnStruct.logintimeout = ToString(arguments.logintimeout) />
		<cfset dsnStruct.maxconnections = ToString(arguments.maxconnections) />
		<cfset dsnStruct.sqldelete = arguments.sqldelete />
		<cfset dsnStruct.sqlinsert = arguments.sqlinsert />
		<cfset dsnStruct.sqlselect = arguments.sqlselect />
		<cfset dsnStruct.sqlupdate = arguments.sqlupdate />
		<cfset dsnStruct.sqlstoredprocedures = arguments.sqlstoredprocedures />

		<!--- Prepend it to the datasource array --->
		<cfset ArrayPrepend(localConfig.cfquery.datasource, Duplicate(dsnStruct)) />
		<cfset setConfig(localConfig) />
		
		<cfset registerDriver(arguments.drivername) />

		<!--- 
			Without verifying the DSN, BlueDragon Administration Application errors
			about dataSourceStatusArray[y].success and the DSN cannot be used
		--->
		<cfset verifyDSN(dsnStruct.name) />
	</cffunction>

	<cffunction name="setOracle" access="public" output="false" returntype="void" hint="Creates or modifies an Oracle data source">
		<cfargument name="name" type="string" required="true" hint="BlueDragon datasource name" />
		<cfargument name="servername" type="string" required="true" hint="Database server host name or IP address" />
		<cfargument name="databasename" type="string" required="true" hint="Databasename that corresponds to the data source" />
		<cfargument name="username" type="string" default="" hint="Database username" />
		<cfargument name="password" type="string" default="" hint="Database password" />
		<cfargument name="port"	type="numeric" default="1521" hint="Port that is used to access the database server (Default: 1521)" />
		<cfargument name="drivername" type="string" default="oracle.jdbc.driver.OracleDriver" hint="JDBC Driver Name (class) to use" />
		<cfargument name="drivertype" type="numeric" default="1" hint="BlueDragon Driver Type (Default: 1)" />
		<cfargument name="drivertypedesc" type="string" default="Oracle (Thin Client)" hint="Driver Type Description" />
		<cfargument name="connectstring" type="string" default="" hint="" />
		<cfargument name="description" type="string" default="" hint="A description of this data source" />
		<cfargument name="connectiontimeout" type="numeric" default="120" hint="Number of seconds BlueDragon maintains an unused connection before it is destroyed" />
		<cfargument name="logintimeout" type="numeric" default="120" hint="Number of seconds before BlueDragon times out the data source connection login attempt" />
		<cfargument name="maxconnections" type="numeric" default="3" hint="Limit connections to this maximum amount" />
		<cfargument name="sqldelete" type="boolean" default="true" hint="Allow SQL DELETE statements" />
		<cfargument name="sqlinsert" type="boolean" default="true" hint="Allow SQL INSERT statements" />
		<cfargument name="sqlselect" type="boolean" default="true" hint="Allow SQL SELECT statements" />
		<cfargument name="sqlupdate" type="boolean" default="true" hint="Allow SQL UPDATE statements" />
		<cfargument name="sqlstoredprocedures" type="boolean" default="true" hint="Allow SQL stored procedure calls" />
		
		<cfset var localConfig = getConfig() />
		<cfset var dsnStruct = StructNew() />

		<!--- Make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "cfquery")) OR (NOT StructKeyExists(localConfig.cfquery, "datasource"))>
			<cfset localConfig.cfquery.datasource = ArrayNew(1) />
		</cfif>

		<!--- Build datasource Struct --->
		<cfset dsnStruct.name = arguments.name />
		<cfset dsnStruct.servername = arguments.servername />
		<cfset dsnStruct.databasename = arguments.databasename />
		<cfset dsnStruct.port = ToString(arguments.port) />
		<cfset dsnStruct.drivername = arguments.drivername />
		<cfset dsnStruct.drivertype = ToString(arguments.drivertype) />
		<cfset dsnStruct.drivertypedesc = arguments.drivertypedesc />
		<cfset dsnStruct.username = arguments.username />
		<cfset dsnStruct.password = arguments.password />
		<cfset dsnStruct.hoststring = "jdbc:oracle:thin:@" & arguments.servername & ":" & arguments.port & ":" & arguments.databasename />
		<cfset dsnStruct.connectstring = arguments.connectstring />
		<cfset dsnStruct.description = arguments.description />
		<cfset dsnStruct.connectiontimeout = ToString(arguments.connectiontimeout) />
		<cfset dsnStruct.logintimeout = ToString(arguments.logintimeout) />
		<cfset dsnStruct.maxconnections = ToString(arguments.maxconnections) />
		<cfset dsnStruct.sqldelete = arguments.sqldelete />
		<cfset dsnStruct.sqlinsert = arguments.sqlinsert />
		<cfset dsnStruct.sqlselect = arguments.sqlselect />
		<cfset dsnStruct.sqlupdate = arguments.sqlupdate />
		<cfset dsnStruct.sqlstoredprocedures = arguments.sqlstoredprocedures />

		<!--- Prepend it to the datasource array --->
		<cfset ArrayPrepend(localConfig.cfquery.datasource, Duplicate(dsnStruct)) />
		<cfset setConfig(localConfig) />
		
		<cfset registerDriver(arguments.drivername) />

		<!--- 
			Without verifying the DSN, BlueDragon Administration Application errors
			about dataSourceStatusArray[y].success and the DSN cannot be used
		--->
		<cfset verifyDSN(dsnStruct.name) />
	</cffunction>

	<cffunction name="setOther" access="public" output="false" returntype="void" hint="Creates or modifies a data source">
		<cfargument name="name" type="string" required="true" hint="BlueDragon datasource name" />
		<cfargument name="drivername" type="string" required="true" hint="JDBC Driver Name (class) to use" />
		<cfargument name="hoststring" type="string" required="true" hint="Host string (JDBC URL)" />
		<cfargument name="username" type="string" default="" hint="Database username" />
		<cfargument name="password" type="string" default="" hint="Database password" />
		<cfargument name="port"	type="numeric" default="0" hint="Port that is used to access the database server" />
		<cfargument name="drivertype" type="numeric" default="4" hint="BlueDragon Driver Type (Default: 4)" />
		<cfargument name="drivertypedesc" type="string" default="Other" hint="Driver Type Description" />
		<cfargument name="connectstring" type="string" default="" hint="" />
		<cfargument name="description" type="string" default="" hint="A description of this data source" />
		<cfargument name="connectiontimeout" type="numeric" default="120" hint="Number of seconds BlueDragon maintains an unused connection before it is destroyed" />
		<cfargument name="logintimeout" type="numeric" default="120" hint="Number of seconds before BlueDragon times out the data source connection login attempt" />
		<cfargument name="maxconnections" type="numeric" default="3" hint="Limit connections to this maximum amount" />
		<cfargument name="sqldelete" type="boolean" default="true" hint="Allow SQL DELETE statements" />
		<cfargument name="sqlinsert" type="boolean" default="true" hint="Allow SQL INSERT statements" />
		<cfargument name="sqlselect" type="boolean" default="true" hint="Allow SQL SELECT statements" />
		<cfargument name="sqlupdate" type="boolean" default="true" hint="Allow SQL UPDATE statements" />
		<cfargument name="sqlstoredprocedures" type="boolean" default="true" hint="Allow SQL stored procedure calls" />

		<cfset var localConfig = getConfig() />
		<cfset var dsnStruct = StructNew() />

		<!--- Make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "cfquery")) OR (NOT StructKeyExists(localConfig.cfquery, "datasource"))>
			<cfset localConfig.cfquery.datasource = ArrayNew(1) />
		</cfif>

		<!--- Build datasource Struct --->
		<cfset dsnStruct.connectiontimeout = ToString(arguments.connectiontimeout) />
		<cfset dsnStruct.connectstring = arguments.connectstring />
		<cfset dsnStruct.description = arguments.description />
		<cfset dsnStruct.drivername = arguments.drivername />
		<cfset dsnStruct.drivertype = ToString(arguments.drivertype) />
		<cfset dsnStruct.drivertypedesc = arguments.drivertypedesc />
		<cfset dsnStruct.hoststring = arguments.hoststring />
		<cfset dsnStruct.logintimeout = ToString(arguments.logintimeout) />
		<cfset dsnStruct.maxconnections = ToString(arguments.maxconnections) />
		<cfset dsnStruct.name = arguments.name />
		<cfset dsnStruct.password = arguments.password />
		<cfset dsnStruct.port = ToString(arguments.port) />
		<cfset dsnStruct.sqldelete = arguments.sqldelete />
		<cfset dsnStruct.sqlinsert = arguments.sqlinsert />
		<cfset dsnStruct.sqlselect = arguments.sqlselect />
		<cfset dsnStruct.sqlstoredprocedures = arguments.sqlstoredprocedures />
		<cfset dsnStruct.sqlupdate = arguments.sqlupdate />
		<cfset dsnStruct.username = arguments.username />

		<!--- Prepend it to the datasource array --->
		<cfset ArrayPrepend(localConfig.cfquery.datasource, Duplicate(dsnStruct)) />
		<cfset setConfig(localConfig) />

		<cfset registerDriver(arguments.drivername) />
		
		<!--- 
			Without verifying the DSN, BlueDragon Administration Application errors
			about dataSourceStatusArray[y].success and the DSN cannot be used
		--->
		<cfset verifyDSN(dsnStruct.name) />
	</cffunction>

	<cffunction name="setPostgreSQL" access="public" output="false" returntype="void" hint="Creates or modifies a PostgreSQL data source">
		<cfargument name="name" type="string" required="true" hint="BlueDragon datasource name" />
		<cfargument name="servername" type="string" required="true" hint="Database server host name or IP address" />
		<cfargument name="databasename" type="string" required="true" hint="Databasename that corresponds to the data source" />
		<cfargument name="username" type="string" default="" hint="Database username" />
		<cfargument name="password" type="string" default="" hint="Database password" />
		<cfargument name="port"	type="numeric" default="5432" hint="Port that is used to access the database server (Default: 5432)" />
		<cfargument name="drivername" type="string" default="org.postgresql.Driver" hint="JDBC Driver Name (class) to use" />
		<cfargument name="drivertype" type="numeric" default="5" hint="BlueDragon Driver Type (Default: 5)" />
		<cfargument name="drivertypedesc" type="string" default="PostgreSQL" hint="Driver Type Description" />
		<cfargument name="connectstring" type="string" default="" hint="" />
		<cfargument name="description" type="string" default="" hint="A description of this data source" />
		<cfargument name="connectiontimeout" type="numeric" default="120" hint="Number of seconds BlueDragon maintains an unused connection before it is destroyed" />
		<cfargument name="logintimeout" type="numeric" default="120" hint="Number of seconds before BlueDragon times out the data source connection login attempt" />
		<cfargument name="maxconnections" type="numeric" default="3" hint="Limit connections to this maximum amount" />
		<cfargument name="sqldelete" type="boolean" default="true" hint="Allow SQL DELETE statements" />
		<cfargument name="sqlinsert" type="boolean" default="true" hint="Allow SQL INSERT statements" />
		<cfargument name="sqlselect" type="boolean" default="true" hint="Allow SQL SELECT statements" />
		<cfargument name="sqlupdate" type="boolean" default="true" hint="Allow SQL UPDATE statements" />
		<cfargument name="sqlstoredprocedures" type="boolean" default="true" hint="Allow SQL stored procedure calls" />
		
		<cfset var localConfig = getConfig() />
		<cfset var dsnStruct = StructNew() />

		<!--- Make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "cfquery")) OR (NOT StructKeyExists(localConfig.cfquery, "datasource"))>
			<cfset localConfig.cfquery.datasource = ArrayNew(1) />
		</cfif>

		<!--- Build datasource Struct --->
		<cfset dsnStruct.name = arguments.name />
		<cfset dsnStruct.servername = arguments.servername />
		<cfset dsnStruct.databasename = arguments.databasename />
		<cfset dsnStruct.port = ToString(arguments.port) />
		<cfset dsnStruct.drivername = arguments.drivername />
		<cfset dsnStruct.drivertype = ToString(arguments.drivertype) />
		<cfset dsnStruct.drivertypedesc = arguments.drivertypedesc />
		<cfset dsnStruct.username = arguments.username />
		<cfset dsnStruct.password = arguments.password />
		<cfset dsnStruct.hoststring = "jdbc:postgresql://" & arguments.servername & ":" & arguments.port & "/" & arguments.databasename />
		<cfset dsnStruct.connectstring = arguments.connectstring />
		<cfset dsnStruct.description = arguments.description />
		<cfset dsnStruct.connectiontimeout = ToString(arguments.connectiontimeout) />
		<cfset dsnStruct.logintimeout = ToString(arguments.logintimeout) />
		<cfset dsnStruct.maxconnections = ToString(arguments.maxconnections) />
		<cfset dsnStruct.sqldelete = arguments.sqldelete />
		<cfset dsnStruct.sqlinsert = arguments.sqlinsert />
		<cfset dsnStruct.sqlselect = arguments.sqlselect />
		<cfset dsnStruct.sqlupdate = arguments.sqlupdate />
		<cfset dsnStruct.sqlstoredprocedures = arguments.sqlstoredprocedures />

		<!--- Prepend it to the datasource array --->
		<cfset ArrayPrepend(localConfig.cfquery.datasource, Duplicate(dsnStruct)) />
		<cfset setConfig(localConfig) />
		
		<cfset registerDriver(arguments.drivername) />

		<!--- 
			Without verifying the DSN, BlueDragon Administration Application errors
			about dataSourceStatusArray[y].success and the DSN cannot be used
		--->
		<cfset verifyDSN(dsnStruct.name) />
	</cffunction>

	<cffunction name="verifyDSN" access="public" output="false" returntype="boolean" hint="Verifies a datasource">
		<cfargument name="dsnname" type="string" required="true" hint="Datasource name to verify" />


		<!--- TODO: depler 20080505 - not exactly sure the correct java calls to replicate the functionality of the <cfadmin> below --->
		<!--- some possible ideas:
		<cfset cfEngine = createObject("java", "com.naryx.tagfusion.cfm.engine.cfEngine") />
		<cfset testDSN = createObject("java", "com.naryx.tagfusion.cfm.sql.cfDataSource").init(#arguments.dsnname#) />

		<cfset something = cfEngine.getDataSourceStatus().put(#arguments.dsnname#, createObject("java", "com.naryx.tagfusion.cfm.sql.cfDataSourceStatus")) />
		--->
		
		<!--- 
		<cfadmin password="#getSessionPassword()#" action="verifydatasource" name="#arguments.dsnname#">
		
		<cfif variables.datasource.success NEQ TRUE>
			<cfthrow message="#variables.datasource.errormessage#" type="bluedragon.adminapi.datasource" />
		</cfif>
		--->
		<cfreturn true />
	</cffunction>

</cfcomponent>
