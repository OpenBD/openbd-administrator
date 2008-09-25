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
<cfcomponent displayname="Datasource" 
		output="false" 
		extends="Base" 
		hint="Manages datasources - OpenBD Admin API">
	
	<!--- PUBLIC METHODS --->
	<cffunction name="setDatasource" access="public" output="false" returntype="void" hint="Creates or updates a datasource">
		<cfargument name="name" type="string" required="true" hint="OpenBD Datasource Name" />
		<cfargument name="databasename" type="string" required="false" default="" hint="Database name on the database server" />
		<cfargument name="server" type="string" required="false" default="" hint="Database server host name or IP address" />
		<cfargument name="port"	type="numeric" required="false" default="0" hint="Port that is used to access the database server" />
		<cfargument name="username" type="string" required="false" default="" hint="Database username" />
		<cfargument name="password" type="string" required="false" default="" hint="Database password" />
		<cfargument name="hoststring" type="string" required="false" default="" 
				hint="JDBC URL for 'other' database types. Databasename, server, and port arguments are ignored if a hoststring is provided." />
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
		<cfargument name="drivername" type="string" required="false" default="" hint="JDBC driver class to use" />
		<cfargument name="action" type="string" required="false" default="create" hint="Action to take on the datasource (create or update)" />
		<cfargument name="existingDatasourceName" type="string" required="false" default="" hint="The existing (old) datasource name so we know what to delete if this is an update" />
		<cfargument name="verificationQuery" type="string" required="false" default="" hint="Custom verification query for 'other' driver types" />
		
		<cfset var localConfig = getConfig() />
		<cfset var defaultSettings = structNew() />
		<cfset var datasourceSettings = structNew() />
		<cfset var driver = 0 />
		<cfset var datasourceVerified = false />
		
		<!--- make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "cfquery")) OR (NOT StructKeyExists(localConfig.cfquery, "datasource"))>
			<cfset localConfig.cfquery.datasource = ArrayNew(1) />
		</cfif>

		<!--- register the driver--this will tell us whether or not openbd can hit the driver --->
		<cftry>
			<cfset registerDriver(arguments.drivername) />
			<cfcatch type="bluedragon.adminapi.datasource">
				<cfrethrow />
			</cfcatch>
		</cftry>
		
		<!--- if the datasource already exists and this isn't an update, throw an error --->
		<cfif arguments.action is "create" and datasourceExists(arguments.name)>
			<cfthrow message="The datasource already exists" type="bluedragon.adminapi.datasource" />
		</cfif>
		
		<!--- if this is an update, delete the existing datasource --->
		<cfif arguments.action is "update">
			<cfset deleteDatasource(arguments.existingDatasourceName) />
			<cfset localConfig = getConfig() />
			
			<!--- if we're editing the only remaining datasource, need to recreate the datasource struture --->
			<cfif NOT StructKeyExists(localConfig, "cfquery") OR NOT StructKeyExists(localConfig.cfquery, "datasource")>
				<cfset localConfig.cfquery.datasource = ArrayNew(1) />
			</cfif>
		</cfif>
		
		<!--- TODO: figure out how to incorporate file-based databases like the dreaded Access, Derby, etc. --->
		
		<cfif arguments.hoststring is "">
			<!--- if we don't have a port, use the defaults for the database type --->
			<cfif arguments.port eq 0>
				<cfset defaultSettings = getDriverInfo(arguments.drivername) />
				<cfset arguments.port = defaultSettings.port />
			</cfif>
	
			<cfset datasourceSettings.hoststring = formatJDBCURL(trim(arguments.drivername), trim(arguments.server), 
																trim(arguments.port), trim(arguments.databasename)) />
		<cfelse>
			<cfset arguments.port = "" />
			<cfset datasourceSettings.hoststring = trim(arguments.hoststring) />
			<cfset datasourceSettings.verificationquery = trim(arguments.verificationQuery) />
		</cfif>
		
		<!--- build up the universal datasource settings --->
		<cfscript>
			datasourceSettings.name = trim(lcase(arguments.name));
			datasourceSettings.displayname = arguments.name;
			datasourceSettings.databasename = trim(arguments.databasename);
			datasourceSettings.server = trim(arguments.server);
			datasourceSettings.port = trim(ToString(arguments.port));
			datasourceSettings.username = trim(arguments.username);
			datasourceSettings.password = trim(arguments.password);
			datasourceSettings.description = trim(arguments.description);
			datasourceSettings.drivername = trim(arguments.drivername);
			datasourceSettings.initstring = trim(arguments.initstring);
			datasourceSettings.sqlselect = ToString(arguments.sqlselect);
			datasourceSettings.sqlinsert = ToString(arguments.sqlinsert);
			datasourceSettings.sqlupdate = ToString(arguments.sqlupdate);
			datasourceSettings.sqldelete = ToString(arguments.sqldelete);
			datasourceSettings.sqlstoredprocedures = ToString(arguments.sqlstoredprocedures);
			datasourceSettings.logintimeout = ToString(arguments.logintimeout);
			datasourceSettings.connectiontimeout = ToString(arguments.connectiontimeout);
			datasourceSettings.connectionretries = ToString(arguments.connectionretries);
			datasourceSettings.maxconnections = ToString(arguments.maxconnections);
			datasourceSettings.perrequestconnections = ToString(arguments.perrequestconnections);
			
			// prepend the new datasource to the localconfig array
			arrayPrepend(localConfig.cfquery.datasource, structCopy(datasourceSettings));
			
			// update the config
			setConfig(localConfig);
		</cfscript>
		
		<cftry>
			<cfset datasourceVerified = verifyDatasource(trim(arguments.name)) />
			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getDatasources" access="public" output="false" returntype="array" 
			hint="Returns an array containing all the data sources or a specified data source">
		<cfargument name="dsn" type="string" required="false" default="" hint="The name of the datasource to return" />
		
		<cfset var localConfig = getConfig() />
		<cfset var returnArray = "" />
		<cfset var dsnIndex = "" />
		
		<!--- Make sure there are datasources --->
		<cfif NOT StructKeyExists(localConfig, "cfquery") OR NOT StructKeyExists(localConfig.cfquery, "datasource")>
			<cfthrow message="No registered datasources" type="bluedragon.adminapi.datasource" />
		</cfif>
		
		<!--- Return entire data source array, unless a data source name is specified --->
		<cfif NOT IsDefined("arguments.dsn") or arguments.dsn is "">
			<cfreturn localConfig.cfquery.datasource />
		<cfelse>
			<cfset returnArray = ArrayNew(1) />
			<cfloop index="dsnIndex" from="1" to="#ArrayLen(localConfig.cfquery.datasource)#">
				<cfif localConfig.cfquery.datasource[dsnIndex].name EQ arguments.dsn>
					<cfset returnArray[1] = Duplicate(localConfig.cfquery.datasource[dsnIndex]) />
					<cfreturn returnArray />
				</cfif>
			</cfloop>
			<cfthrow message="#arguments.dsn# not registered as a datasource" type="bluedragon.adminapi.datasource">
		</cfif>
	</cffunction>
	
	<cffunction name="datasourceExists" access="public" output="false" returntype="boolean" 
				hint="Returns a boolean indicating whether or not a datasource with the specified name exists">
		<cfargument name="dsn" type="string" required="true" hint="The datasource name to check" />
		
		<cfset var dsnExists = true />
		<cfset var localConfig = getConfig() />
		<cfset var i = 0 />
		
		<cfif not StructKeyExists(localConfig, "cfquery") or not StructKeyExists(localConfig.cfquery, "datasource")>
			<!--- no datasources at all, so this one doesn't exist ---->
			<cfset dsnExists = false />
		<cfelse>
			<cfloop index="i" from="1" to="#ArrayLen(localConfig.cfquery.datasource)#">
				<cfif localConfig.cfquery.datasource[i].name is arguments.dsn>
					<cfset dsnExists = true />
					<cfbreak />
				<cfelse>
					<cfset dsnExists = false />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn dsnExists />
	</cffunction>
	
	<cffunction name="deleteDatasource" access="public" output="false" returntype="void" hint="Delete the specified data source">
		<cfargument name="dsn" required="true" type="string" hint="The name of the data source to be deleted" />
		<cfset var localConfig = getConfig() />

		<!--- Make sure there are datasources --->
		<cfif (NOT StructKeyExists(localConfig, "cfquery")) OR (NOT StructKeyExists(localConfig.cfquery, "datasource"))>
			<cfthrow message="No datasources defined" type="bluedragon.adminapi.datasource">		
		</cfif>

		<cfloop index="dsnIndex" from="1" to="#ArrayLen(localConfig.cfquery.datasource)#">
			<cfif localConfig.cfquery.datasource[dsnIndex].name EQ arguments.dsn>
				<cfset ArrayDeleteAt(localConfig.cfquery.datasource, dsnIndex) />
				<cfset setConfig(localConfig) />
				<cfreturn />
			</cfif>
		</cfloop>
		<cfthrow message="#arguments.dsn# not registered as a datasource" type="bluedragon.adminapi.datasource">
	</cffunction>
	
	<cffunction name="getRegisteredDrivers" access="public" output="false" returntype="array" 
			hint="Returns an array containing all the database drivers that are 'known' to OpenBD. If the node doesn't exist in the XML we'll create it and populate it with the standard driver information. Note we can't guarantee the user will have the drivers installed/in their classpath but that should throw an error if they try to add a datasource that uses a driver they don't have.">
		<cfargument name="resetDrivers" type="boolean" required="false" default="false" />
		
		<cfset var localConfig = getConfig() />
		<cfset var dbDriverInfo = structNew() />
		
		<cfif arguments.resetDrivers>
			<cfset StructDelete(localConfig.cfquery, "dbdrivers", false) />
		</cfif>
		
		<cfif not StructKeyExists(localConfig.cfquery, "dbdrivers")>
			<!--- add the dbdrivers node with the default drivers that should be shipping with OpenBD --->
			<cfscript>
				localConfig.cfquery.dbdrivers = structNew();
				localConfig.cfquery.dbdrivers.driver = arrayNew(1);
				
				// mysql (provider: mysql)
				dbDriverInfo.name = "mysql 4/5";
				dbDriverInfo.datasourceconfigpage = "mysql5.cfm";
				dbDriverInfo.version = "5.1.6";
				dbDriverInfo.drivername = "com.mysql.jdbc.Driver";
				dbDriverInfo.driverdescription = "MySQL 4/5 (MySQL)";
				dbDriverInfo.jdbctype = "4";
				dbDriverInfo.provider = "MySQL";
				dbDriverInfo.defaultport = "3306";
				
				arrayAppend(localConfig.cfquery.dbdrivers.driver, structCopy(dbDriverInfo));
				
				// mssql (provider: ms)
				dbDriverInfo.name = "microsoft sql server 2005 (microsoft)";
				dbDriverInfo.datasourceconfigpage = "sqlserver2005-ms.cfm";
				dbDriverInfo.version = "1.2";
				dbDriverInfo.drivername = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
				dbDriverInfo.driverdescription = "Microsoft SQL Server 2005 (Microsoft)";
				dbDriverInfo.jdbctype = "4";
				dbDriverInfo.provider = "Microsoft";
				dbDriverInfo.defaultport = "1433";
				
				arrayAppend(localConfig.cfquery.dbdrivers.driver, structCopy(dbDriverInfo));
				
				// mssql (provider: jtds)
				dbDriverInfo.name = "microsoft sql server (jtds)";
				dbDriverInfo.datasourceconfigpage = "sqlserver-jtds.cfm";
				dbDriverInfo.version = "1.2.2";
				dbDriverInfo.drivername = "net.sourceforge.jtds.jdbc.Driver";
				dbDriverInfo.driverdescription = "Microsoft SQL Server (jTDS)";
				dbDriverInfo.jdbctype = "4";
				dbDriverInfo.provider = "jTDS";
				dbDriverInfo.defaultport = "1433";
				
				arrayAppend(localConfig.cfquery.dbdrivers.driver, structCopy(dbDriverInfo));
				
				// postgresql (provider: postgres)
				dbDriverInfo.name = "postgresql (postgresql)";
				dbDriverInfo.datasourceconfigpage = "postgresql.cfm";
				dbDriverInfo.version = "8.3-603";
				dbDriverInfo.drivername = "org.postgresql.Driver";
				dbDriverInfo.driverdescription = "PostgreSQL (PostgreSQL)";
				dbDriverInfo.jdbctype = "4";
				dbDriverInfo.provider = "PostgreSQL";
				dbDriverInfo.defaultport = "5432";
				
				arrayAppend(localConfig.cfquery.dbdrivers.driver, structCopy(dbDriverInfo));
				
				// "other" (user-configured jdbc)
				dbDriverInfo.name = "other";
				dbDriverInfo.datasourceconfigpage = "other.cfm";
				dbDriverInfo.version = "";
				dbDriverInfo.drivername = "";
				dbDriverInfo.driverdescription = "Other JDBC Driver";
				dbDriverInfo.jdbctype = "";
				dbDriverInfo.provider = "";
				dbDriverInfo.defaultport = "";
				
				arrayAppend(localConfig.cfquery.dbdrivers.driver, structCopy(dbDriverInfo));
				
				setConfig(localConfig);
			</cfscript>
		</cfif>

		<cfreturn getConfig().cfquery.dbdrivers.driver />
	</cffunction>
	
	<cffunction name="getDriverInfo" access="public" output="false" returntype="struct" 
			hint="Returns a struct containing the information for a particular driver. Currently this is pulled by the driver config page but this can be expanded to get the driver info by other attributes.">
		<cfargument name="datasourceconfigpage" type="string" required="false" default="" />
		<cfargument name="drivername" type="string" required="false" default="" />
		
		<cfset var dbdrivers = getConfig().cfquery.dbdrivers.driver />
		<cfset var driverInfo = structNew() />
		<cfset var i = 0 />
		
		<cfif arguments.datasourceconfigpage is not "">
			<cfloop index="i" from="1" to="#arrayLen(dbdrivers)#" step="1">
				<cfif dbdrivers[i].datasourceconfigpage is arguments.datasourceconfigpage>
					<cfset driverInfo = dbdrivers[i] />
					<cfbreak />
				</cfif>
			</cfloop>
		<cfelseif arguments.drivername is not "">
			<cfloop index="i" from="1" to="#arrayLen(dbdrivers)#" step="1">
				<cfif dbdrivers[i].drivername is arguments.drivername>
					<cfset driverInfo = dbdrivers[i] />
					<cfbreak />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn driverInfo />
	</cffunction>
	
	<cffunction name="verifyDatasource" access="public" output="false" returntype="boolean" hint="Verifies a datasource">
		<cfargument name="dsn" type="string" required="true" hint="Datasource name to verify" />
		
		<cfset var verified = false />
		<cfset var datasource = getDatasources(arguments.dsn).get(0) />
		<cfset var driverManager = createObject("java", "java.sql.DriverManager") />
		<cfset var dbcon = 0 />
		<cfset var stmt = 0 />
		<cfset var rs = 0 />
		
		<!--- check that we can hit the driver --->
		<cftry>
			<cfset registerDriver(datasource.drivername) />
			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
		
		<!--- run a verification query based on the driver; need to do this in java so we get a clean connection, because 
				otherwise the connection from openbd may be cached/pooled so changes to things like server name don't 
				get picked up --->
		<cfswitch expression="#datasource.drivername#">
			<!--- mysql and postgres --->
			<cfcase value="com.mysql.jdbc.Driver,org.postgresql.Driver">
				<cftry>
					<cfset dbcon = driverManager.getConnection(datasource.hoststring, datasource.username, datasource.password) />
					<cfset stmt = dbcon.createStatement() />
					<cfset rs = stmt.executeQuery("SELECT NOW()") />
					
					<cfif rs.next()>
						<cfset verified = true />
					</cfif>
					<cfcatch type="any">
						<cfthrow message="Could not verify datasource: #CFCATCH.Message#" 
								type="bluedragon.adminapi.datasource" />
					</cfcatch>
				</cftry>
			</cfcase>
			
			<!--- sql server --->
			<cfcase value="com.microsoft.sqlserver.jdbc.SQLServerDriver,net.sourceforge.jtds.jdbc.Driver" delimiters=",">
				<cftry>
					<cfset dbcon = driverManager.getConnection(datasource.hoststring, datasource.username, datasource.password) />
					<cfset stmt = dbcon.createStatement() />
					<cfset rs = stmt.executeQuery("SELECT 1") />
					
					<cfif rs.next()>
						<cfset verified = true />
					</cfif>
					<cfcatch type="any">
						<cfthrow message="Could not verify datasource: #CFCATCH.Message#" 
								type="bluedragon.adminapi.datasource" />
					</cfcatch>
				</cftry>
			</cfcase>
			
			<!--- 'other' database types --->
			<cfdefaultcase>
				<!---try to use the custom verification query; otherwise throw an error --->
				<cfif structKeyExists(datasource, "verificationquery") and datasource.verificationquery is not "">
					<cftry>
						<cfset dbcon = driverManager.getConnection(datasource.hoststring, datasource.username, datasource.password) />
						<cfset stmt = dbcon.createStatement() />
						<cfset rs = stmt.executeQuery(datasource.verificationquery) />
						
						<cfif rs.next()>
							<cfset verified = true />
						</cfif>
						<cfcatch type="any">
							<cfthrow message="Could not verify datasource using driver #datasource.drivername#: #CFCATCH.Message#" 
									type="bluedragon.adminapi.datasource" />
						</cfcatch>
					</cftry>
				<cfelse>
					<cfthrow message="Cannot verify custom JDBC driver datasources without a verification query. Please add a verification query to this datasource and try again." 
							type="bluedragon.adminapi.datasource" />
				</cfif>
			</cfdefaultcase>
		</cfswitch>
		
		<cfreturn verified />
	</cffunction>
	
	<!--- PRIVATE METHODS --->
	<cffunction name="formatJDBCURL" access="private" output="false" returntype="string" 
			hint="Formats a JDBC URL for a specific database driver type">
		<cfargument name="drivername" type="string" required="true" hint="The name of the database driver class" />
		<cfargument name="server" type="string" required="true" hint="The database server name or IP address" />
		<cfargument name="port" type="numeric" required="true" hint="The database server port" />
		<cfargument name="database" type="string" required="true" hint="The database name" />
		
		<cfset var jdbcURL = "" />
		
		<cfswitch expression="#arguments.drivername#">
			<cfcase value="com.mysql.jdbc.Driver">
				<!--- url format: jdbc:mysql://[host][,failoverhost...][:port]/[database][?propertyName1][=propertyValue1][&propertyName2][=propertyValue2] --->
				<cfset jdbcURL = "jdbc:mysql://#arguments.server#:#arguments.port#/#arguments.database#" />
			</cfcase>
			
			<cfcase value="com.microsoft.sqlserver.jdbc.SQLServerDriver">
				<!--- url format: jdbc:sqlserver://[serverName[\instanceName][:portNumber]][;property=value[;property=value]] --->
				<cfset jdbcURL = "jdbc:sqlserver://#arguments.server#:#arguments.port#;databaseName=#arguments.database#" />
			</cfcase>
			
			<cfcase value="net.sourceforge.jtds.jdbc.Driver">
				<!--- url format: jdbc:jtds:<server_type>://<server>[:<port>][/<database>][;<property>=<value>[;...]] --->
				<cfset jdbcURL = "jdbc:jtds:sqlserver://#arguments.server#:#arguments.port#/#arguments.database#" />
			</cfcase>
			
			<cfcase value="org.postgresql.Driver">
				<!--- url format: jdbc:postgresql://host:port/database --->
				<cfset jdbcURL = "jdbc:postgresql://#arguments.server#:#arguments.port#/#arguments.database#" />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow message="Cannot format a JDBC URL for unknown driver types" type="bluedragon.adminapi.datasource" />
			</cfdefaultcase>
		</cfswitch>

		<cfreturn jdbcURL />
	</cffunction>
	
	<cffunction name="registerDriver" access="private" output="false" returntype="boolean" 
			hint="Registers a driver class to make sure it exists and is available in the classpath">
		<cfargument name="class" type="string" required="true" hint="JDBC class name" />
	
		<cfset var javaClass = "" />
		<cfset var registerJDBCDriver = "" />
		
		<cftry>
			<cfset registerJDBCDriver = createObject("java", "java.lang.Class").forName(arguments.class) />
			
			<cfcatch type="any">
				<cfthrow message="Could not register database driver #arguments.class#. Please make sure this driver is in your classpath." 
						type="bluedragon.adminapi.datasource" />
			</cfcatch>
		</cftry>

		<cfreturn true />
	</cffunction>
</cfcomponent>
