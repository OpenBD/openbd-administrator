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
<cfcomponent displayname="Extensions" 
		output="false" 
		extends="Base" 
		hint="Manages customtags and CFXs - OpenBD Admin API">
	
	<!--- CUSTOM TAG PATHS --->
	<cffunction name="getCustomTagPaths" access="public" output="false" returntype="array" hint="Returns an array of paths to customtags">
		<cfset var localConfig = getConfig() />

		<!--- Make sure there are Custom Tag Paths defined --->
		<cfif NOT StructKeyExists(localConfig, "cfmlcustomtags") OR NOT StructKeyExists(localConfig.cfmlcustomtags, "mapping")>
			<cfthrow message="No Custom Tag Paths Defined" type="bluedragon.adminapi.extensions" />		
		</cfif>
	
		<!--- Return entire Custom Tag Path list as an array --->
		<cfreturn ListToArray(localConfig.cfmlcustomtags.mapping[1].directory, separator.path) />
	</cffunction>

	<cffunction name="setCustomTagPath" access="public" output="false" returntype="void" hint="Defines a new path to customtags">
		<cfargument name="path" type="string" required="true" hint="Custom tag path" />
		<cfargument name="customTagPathAction" type="string" required="true" hint="The action to perform (create or edit)" />
		
		<cfset var localConfig = getConfig() />
		<cfset var tempPath = "" />
		
		<!--- Make sure there are Custom Tag Paths defined --->
		<cfif (NOT StructKeyExists(localConfig, "cfmlcustomtags")) OR (NOT StructKeyExists(localConfig.cfmlcustomtags, "mapping"))>
			<cfset localConfig.cfmlcustomtags.mapping = ArrayNew(1) />
			<cfset localConfig.cfmlcustomtags.mapping[1].name = "cf" />
		</cfif>
		
		<!--- if this is an update, delete the existing custom tag path --->
		<cfif arguments.customTagPathAction is "update">
			<cfset deleteCustomTagPath(arguments.path) />
		</cfif>
		
		<!--- verify the custom tag path --->
		<cftry>
			<cfif left(arguments.path, 1) is "$">
				<cfset tempPath = right(arguments.path, len(arguments.path) - 1) />
			<cfelse>
				<cfset tempPath = expandPath(arguments.path) />
			</cfif>
			
			<cfif not directoryExists(tempPath)>
				<cfthrow message="The custom tag path specified is not accessible. Please verify that the directory exists and has the correct permissions." 
						type="bluedragon.adminapi.extensions" />
			</cfif>
			<cfcatch type="any">
				<cfthrow message="The custom tag path specified is not accessible. Please verify that the directory exists and has the correct permissions." 
						type="bluedragon.adminapi.extensions" />
			</cfcatch>
		</cftry>
		
		<cfset localConfig.cfmlcustomtags.mapping[1].directory = ListAppend(localConfig.cfmlcustomtags.mapping[1].directory, arguments.path, separator.path) />

		<cfset setConfig(localConfig) />
	</cffunction>

	<cffunction name="deleteCustomTagPath" access="public" output="false" returntype="void" hint="Deletes a custom tag path">
		<cfargument name="path" type="string" required="true" hint="Custom tag path to delete" />
		<cfset var localConfig = getConfig() />
		<cfset var listIndex = "" />

		<!--- Make sure there are Custom Tag Paths defined --->
		<cfif (NOT StructKeyExists(localConfig, "cfmlcustomtags")) OR (NOT StructKeyExists(localConfig.cfmlcustomtags, "mapping"))>
			<cfthrow message="No Custom Tag Paths Defined" type="bluedragon.adminapi.extensions" />		
		</cfif>
	
		<!--- Find index of path in list --->
		<cfset listIndex = ListFindNoCase(localConfig.cfmlcustomtags.mapping[1].directory, arguments.path, separator.path) />
		
		<!--- if found, remove customtag path from list --->
		<cfif listIndex neq 0>
			<cfset localConfig.cfmlcustomtags.mapping[1].directory = ListDeleteAt(localConfig.cfmlcustomtags.mapping[1].directory, listIndex, separator.path) />
			<cfset setConfig(localConfig) />
		<cfelse>
			<cfthrow message="#arguments.path# is not defined as a customtag path" type="bluedragon.adminapi.extensions" />
		</cfif>
	</cffunction>
	
	<cffunction name="verifyCustomTagPath" access="public" output="false" returntype="void" hint="Verifies a custom tag path by running directoryexists() on the path">
		<cfargument name="path" type="string" required="true" hint="Custom tag path to verify" />
		
		<cfset var localConfig = getConfig() />
		
		<!--- Make sure there are Custom Tag Paths defined --->
		<cfif (NOT StructKeyExists(localConfig, "cfmlcustomtags")) OR (NOT StructKeyExists(localConfig.cfmlcustomtags, "mapping"))>
			<cfthrow message="No Custom Tag Paths Defined" type="bluedragon.adminapi.extensions" />		
		</cfif>

		<!--- verify the custom tag path --->
		<cftry>
			<cfif left(arguments.path, 1) is "$">
				<cfset tempPath = right(arguments.path, len(arguments.path) - 1) />
			<cfelse>
				<cfset tempPath = expandPath(arguments.path) />
			</cfif>
			
			<cfif not directoryExists(tempPath)>
				<cfthrow message="The custom tag path specified is not accessible. Please verify that the directory exists and has the correct permissions." 
						type="bluedragon.adminapi.extensions" />
			</cfif>
			<cfcatch type="any">
				<cfthrow message="The custom tag path specified is not accessible. Please verify that the directory exists and has the correct permissions." 
						type="bluedragon.adminapi.extensions" />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<!--- CFX TAGS --->
	<cffunction name="getCPPCFX" access="public" output="false" returntype="array" hint="List the names of all registered C++ CFX tags or a specified C++ CFX tag">
		<cfargument name="cfxname" required="false" type="string" hint="Specifies a CFX tag name" />
		<cfset var localConfig = getConfig() />
		<cfset var cfxIndex = "" />
		<cfset var returnArray = ArrayNew(1) />
		
		<!--- Make sure there are C++ CFXs --->
		<cfif (NOT StructKeyExists(localConfig, "nativecustomtags")) OR (NOT StructKeyExists(localConfig.nativecustomtags, "mapping"))>
			<cfthrow message="No registered C++ CFXs" type="bluedragon.adminapi.extensions">		
		</cfif>
		
		<!--- Return entire C++ CFX array, unless a CFX name is specified --->
		<cfif NOT IsDefined("arguments.cfxname")>
			<cfreturn localConfig.nativecustomtags.mapping />
		<cfelse>
			<cfloop index="cfxIndex" from="1" to="#ArrayLen(localConfig.nativecustomtags.mapping)#">
				<cfif localConfig.nativecustomtags.mapping[cfxIndex].name EQ arguments.cfxname>
					<cfset returnArray[1] = Duplicate(localConfig.nativecustomtags.mapping[cfxIndex]) />
					<cfreturn returnArray />
				</cfif>
			</cfloop>
			<cfthrow message="#arguments.cfxname# not registered as a C++ CFX" type="bluedragon.adminapi.extensions">
		</cfif>
	</cffunction>

	<cffunction name="setCPPCFX" access="public" output="false" returntype="void" hint="Registers a C++ CFX">
		<cfargument name="displayname" type="string" required="true" hint="Name of CFX tag to show in the Administrator" />
		<cfargument name="module" type="string" required="true" hint="Library module that implments the interface" />
		<cfargument name="description" type="string" required="true" hint="Description of CFX tag" />
		<cfargument name="name"	type="string" required="true" default="#arguments.displayname#" hint="Name of tag, beginning with cfx_" />
		<cfargument name="keeploaded" type="boolean" required="true" hint="Indicates if BlueDragon should keep the CFX tag in memory" />
		<cfargument name="function" type="string" required="true" hint="Name of the procedure that implements the tag" />
		<cfargument name="existingCFXName" type="string" required="true" hint="The existing CFX tag name--used on updates" />
		<cfargument name="action" type="string" required="true" hint="Action to take (create or update)" />
		
		<cfset var localConfig = getConfig() />
		<cfset var cppCFX = StructNew() />
		<cfset var tempFile = "" />
		<cfset var temp = "" />
		
		<!--- Make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "nativecustomtags")) OR (NOT StructKeyExists(localConfig.nativecustomtags, "mapping"))>
			<cfset localConfig.nativecustomtags.mapping = ArrayNew(1) />
		</cfif>
		
		<!--- make sure we can read the module --->
		<cfif left(arguments.module, 1) is "$">
			<cfset tempFile = right(arguments.module, len(arguments.module) - 1) />
		<cfelse>
			<cfset tempFile = expandPath(arguments.module) />
		</cfif>
		
		<cftry>
			<cffile action="read" file="#tempFile#" variable="temp" />
			<cfcatch type="any">
				<cfthrow message="An error occurred while attempting to read #tempFile#. #CFCATCH.Message#" 
						type="bluedragon.adminapi.extensions" />
			</cfcatch>
		</cftry>

		<!--- if this is an update, delete the existing tag --->
		<cfif arguments.action is "update">
			<cfset deleteCPPCFX(LCase(arguments.existingCFXName)) />
			<cfset localConfig = getConfig() />

			<cfif (NOT StructKeyExists(localConfig, "nativecustomtags")) OR (NOT StructKeyExists(localConfig.nativecustomtags, "mapping"))>
				<cfset localConfig.nativecustomtags.mapping = ArrayNew(1) />
			</cfif>
		</cfif>
		
		<cfscript>
			cppCFX.displayname = arguments.displayname;
			cppCFX.module = arguments.module;
			cppCFX.description = arguments.description;
			cppCFX.name = LCase(arguments.name);
			cppCFX.keeploaded = ToString(arguments.keeploaded);
			cppCFX.function = arguments.function;
			
			arrayPrepend(localConfig.nativecustomtags.mapping, structCopy(cppCFX));
			
			setConfig(localConfig);
		</cfscript>
	</cffunction>

	<cffunction name="deleteCPPCFX" access="public" output="false" returntype="void" hint="Delete a C++ CFX tag">
		<cfargument name="cfxname" required="true" type="string" hint="Specifies a CFX tag name" />
		<cfset var localConfig = getConfig() />
		<cfset var cfxIndex = "" />

		<!--- Make sure there are C++ CFXs --->
		<cfif (NOT StructKeyExists(localConfig, "nativecustomtags")) OR (NOT StructKeyExists(localConfig.nativecustomtags, "mapping"))>
			<cfthrow message="No registered C++ CFXs" type="bluedragon.adminapi.extensions">		
		</cfif>

		<cfloop index="cfxIndex" from="1" to="#ArrayLen(localConfig.nativecustomtags.mapping)#">
			<cfif localConfig.nativecustomtags.mapping[cfxIndex].name EQ arguments.cfxname>
				<cfset ArrayDeleteAt(localConfig.nativecustomtags.mapping, cfxIndex) />
				<cfset setConfig(localConfig) />
				<cfreturn />
			</cfif>
		</cfloop>
		<cfthrow message="#arguments.cfxname# not registered as a C++ CFX" type="bluedragon.adminapi.extensions">
	</cffunction>

	<cffunction name="getJavaCFX" access="public" output="false" returntype="array" hint="List the names of all registered Java CFX tags or a specified Java CFX tag">
		<cfargument name="cfxname" required="false" type="string" hint="Specifies a CFX tag name" />
		<cfset var localConfig = getConfig() />
		<cfset var cfxIndex = "" />
		<cfset var returnArray = ArrayNew(1) />

		<!--- Make sure there are Java CFXs --->
		<cfif (NOT StructKeyExists(localConfig, "javacustomtags")) OR (NOT StructKeyExists(localConfig.javacustomtags, "mapping"))>
			<cfthrow message="No registered Java CFXs" type="bluedragon.adminapi.extensions">		
		</cfif>

		<!--- Return entire Java CFX array, unless a CFX name is specified --->
		<cfif NOT IsDefined("arguments.cfxname")>
			<cfreturn localConfig.javacustomtags.mapping />
		<cfelse>
			<cfloop index="cfxIndex" from="1" to="#ArrayLen(localConfig.javacustomtags.mapping)#">
				<cfif localConfig.javacustomtags.mapping[cfxIndex].name EQ arguments.cfxname>
					<cfset returnArray[1] = Duplicate(localConfig.javacustomtags.mapping[cfxIndex]) />
					<cfreturn returnArray />
				</cfif>
			</cfloop>
			<cfthrow message="#arguments.cfxname# not registered as a Java CFX" type="bluedragon.adminapi.extensions">
		</cfif>
	</cffunction>

	<cffunction name="setJavaCFX" access="public" output="false" returntype="void" hint="Registers a Java CFX">
		<cfargument name="displayname" type="string" required="true" hint="Name of CFX tag to show in the Administrator" />
		<cfargument name="class" type="string" required="true" hint="Class name (minus .class) that implments the interface" />
		<cfargument name="description" type="string" required="true" hint="Description of CFX tag" />
		<cfargument name="name"	type="string" required="true" hint="Name of tag, beginning with cfx_" />
		<cfargument name="existingCFXName" type="string" required="true" hint="The existing CFX tag name--used for updates in case the name changes" />
		<cfargument name="action" type="string" required="true" hint="The action being take (create or update)" />

		<cfset var localConfig = getConfig() />
		<cfset var javaCFX = StructNew() />
		<cfset var javaObj = 0 />

		<!--- Make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "javacustomtags")) OR (NOT StructKeyExists(localConfig.javacustomtags, "mapping"))>
			<cfset localConfig.javacustomtags.mapping = ArrayNew(1) />
		</cfif>
		
		<!--- see if we can create an instance of the java class they're using as the custom tag --->
		<cftry>
			<cfset javaObject = createObject("java", arguments.class) />
			<cfcatch type="any">
				<cfthrow message="Could not instantiate the Java class for the CFX tag." 
						type="bluedragon.adminapi.extensions" />
			</cfcatch>
		</cftry>
		
		<!--- if this is an update, delete the existing tag --->
		<cfif arguments.action is "update">
			<cfset deleteJavaCFX(LCase(arguments.existingCFXName)) />
			<cfset localConfig = getConfig() />

			<cfif (NOT StructKeyExists(localConfig, "javacustomtags")) OR (NOT StructKeyExists(localConfig.javacustomtags, "mapping"))>
				<cfset localConfig.javacustomtags.mapping = ArrayNew(1) />
			</cfif>
		</cfif>
		
		<cfscript>
			javaCFX.displayname = arguments.displayname;
			javaCFX.class = arguments.class;
			javaCFX.description = arguments.description;
			javaCFX.name = LCase(arguments.name);
			
			arrayPrepend(localConfig.javacustomtags.mapping, structCopy(javaCFX));
			
			setConfig(localConfig);
		</cfscript>
	</cffunction>

	<cffunction name="deleteJavaCFX" access="public" output="false" returntype="void" hint="Delete a Java CFX tag">
		<cfargument name="cfxname" required="true" type="string" hint="Specifies a CFX tag name" />
		<cfset var localConfig = getConfig() />
		<cfset var cfxIndex = "" />

		<!--- Make sure there are Java CFXs --->
		<cfif (NOT StructKeyExists(localConfig, "javacustomtags")) OR (NOT StructKeyExists(localConfig.javacustomtags, "mapping"))>
			<cfthrow message="No registered Java CFXs" type="bluedragon.adminapi.extensions">		
		</cfif>

		<cfloop index="cfxIndex" from="1" to="#ArrayLen(localConfig.javacustomtags.mapping)#">
			<cfif localConfig.javacustomtags.mapping[cfxIndex].name EQ arguments.cfxname>
				<cfset ArrayDeleteAt(localConfig.javacustomtags.mapping, cfxIndex) />
				<cfset setConfig(localConfig) />
				<cfreturn />
			</cfif>
		</cfloop>
		<cfthrow message="#arguments.cfxname# not registered as a Java CFX" type="bluedragon.adminapi.extensions">
	</cffunction>
	
	<cffunction name="verifyCFXTag" access="public" output="false" returntype="void" 
			hint="Verifies a CFX tag by instantiating the Java class or doing a file read on the specified DLL">
		<cfargument name="cfxname" required="true" type="string" hint="The CFX tag name" />
		<cfargument name="type" required="true" type="string" hint="The type of CFX tag to verify (java or cpp)" />
		
		<cfset var cfxTag = 0 />
		<cfset var tempFile = "" />
		<cfset var temp = 0 />
		
		<cfif arguments.type is "java">
			<cftry>
				<cfset cfxTag = getJavaCFX(arguments.cfxname).get(0) />
				<cfcatch type="any">
					<cfthrow message="An error occurred while retrieving the Java CFX tag information from the server configuration. #CFCATCH.Message#" 
							type="bluedragon.adminapi.extensions" />
				</cfcatch>
			</cftry>
			
			<cftry>
				<cfset temp = createObject("java", cfxTag.class) />
				<cfcatch type="any">
					<cfthrow message="Could not instantiate the Java class for the CFX tag." 
							type="bluedragon.adminapi.extensions" />
				</cfcatch>
			</cftry>
		<cfelseif arguments.type is "cpp">
			<cfset cfxTag = getCPPCFX(arguments.cfxname) />
			
			<cftry>
				<cfset cfxTag = getCPPCFX(arguments.cfxname).get(0) />
				<cfcatch type="any">
					<cfthrow message="An error occurred while retrieving the C++ CFX tag information from the server configuration. #CFCATCH.Message#" 
							type="bluedragon.adminapi.extensions" />
				</cfcatch>
			</cftry>
			
			<cfif left(cfxTag.module, 1) is "$">
				<cfset tempFile = right(cfxTag.module, len(cfxTag.module) - 1) />
			<cfelse>
				<cfset tempFile = expandPath(cfxTag.module) />
			</cfif>
			
			<cftry>
				<cffile action="read" file="#tempFile#" variable="temp" />
				<cfcatch type="any">
					<cfthrow message="An error occurred while attempting to read #tempFile#. #CFCATCH.Message#" 
							type="bluedragon.adminapi.extensions" />
				</cfcatch>
			</cftry>
		</cfif>
	</cffunction>

</cfcomponent>