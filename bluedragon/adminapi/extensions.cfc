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
<cfcomponent name="extensions" extends="bluedragon.adminapi.base" displayname="extensions [BD AdminAPI]" hint="Manages customtags, mappings, and CFXs in BlueDragon">

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

	<cffunction name="deleteCustomTagPath" access="public" output="false" returntype="void" hint="Deletes a customtag path">
		<cfargument name="path" required="true" type="string" hint="Path to customtag" />
		<cfset var localConfig = getConfig() />
		<cfset var listIndex = "" />

		<!--- Make sure there are Custom Tag Paths defined --->
		<cfif (NOT StructKeyExists(localConfig, "cfmlcustomtags")) OR (NOT StructKeyExists(localConfig.cfmlcustomtags, "mapping"))>
			<cfthrow message="No CustomTag Paths Defined" type="bluedragon.adminapi.extensions">		
		</cfif>
	
		<!--- Find index of path in list --->
		<cfset listIndex = ListFindNoCase(localConfig.cfmlcustomtags.mapping[1].directory, arguments.path, separator.path) />
		
		<!--- if found, remove customtag path from list --->
		<cfif listIndex>
			<cfset ListDeleteAt(localConfig.cfmlcustomtags.mapping[1].directory, listIndex, separator.path) />
			<cfset setConfig(localConfig) />
			<cfreturn />
		</cfif>
		<cfthrow message="#arguments.path# is not defined as a customtag path" type="bluedragon.adminapi.extensions">
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

	<cffunction name="deleteMapping" access="public" output="false" returntype="void" hint="Delete the specified mapping">
		<cfargument name="mapName" required="true" type="string" hint="Specifies a logical path name" />
		<cfset var localConfig = getConfig() />
		<cfset var mapIndex = "" />

		<!--- Make sure there are Mappings --->
		<cfif (NOT StructKeyExists(localConfig, "cfmappings")) OR (NOT StructKeyExists(localConfig.cfmappings, "mapping"))>
			<cfthrow message="No Mappings Defined" type="bluedragon.adminapi.extensions">		
		</cfif>

		<cfloop index="mapIndex" from="1" to="#ArrayLen(localConfig.cfmappings.mapping)#">
			<cfif localConfig.cfmappings.mapping[mapIndex].name EQ arguments.mapName>
				<cfset ArrayDeleteAt(localConfig.cfmappings.mapping, mapIndex) />
				<cfset setConfig(localConfig) />
				<cfreturn />
			</cfif>
		</cfloop>
		<cfthrow message="#arguments.mapName# is not defined as a mapping" type="bluedragon.adminapi.extensions">
	</cffunction>

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

	<cffunction name="getCustomTagPaths" access="public" output="false" returntype="array" hint="Returns an array of paths to customtags">
		<cfset var localConfig = getConfig() />

		<!--- Make sure there are Custom Tag Paths defined --->
		<cfif (NOT StructKeyExists(localConfig, "cfmlcustomtags")) OR (NOT StructKeyExists(localConfig.cfmlcustomtags, "mapping"))>
			<cfthrow message="No Custom Tag Paths Defined" type="bluedragon.adminapi.extensions">		
		</cfif>
	
		<!--- Return entire Custom Tag Path list as an array --->
		<cfreturn ListToArray(localConfig.cfmlcustomtags.mapping[1].directory, separator.path) />
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

	<cffunction name="getMappings" access="public" output="false" returntype="array" hint="Returns array of mappings which equate logical paths to directory paths">
		<cfargument name="mapName" required="false" type="string" hint="Specifies a logical path name" />
		<cfset var localConfig = getConfig() />
		<cfset var mapIndex = "" />
		<cfset var returnArray = ArrayNew(1) />

		<!--- Make sure there are Mappings --->
		<cfif (NOT StructKeyExists(localConfig, "cfmappings")) OR (NOT StructKeyExists(localConfig.cfmappings, "mapping"))>
			<cfthrow message="No Mappings Defined" type="bluedragon.adminapi.extensions">		
		</cfif>

		<!--- Return entire Mapping array, unless a map name is specified --->
		<cfif NOT IsDefined("arguments.mapName")>
			<cfreturn localConfig.cfmappings.mapping />
		<cfelse>
			<cfloop index="mapIndex" from="1" to="#ArrayLen(localConfig.cfmappings.mapping)#">
				<cfif localConfig.cfmappings.mapping[mapIndex].name EQ arguments.mapName>
					<cfset returnArray[1] = Duplicate(localConfig.cfmappings.mapping[mapIndex]) />
					<cfreturn returnArray />
				</cfif>
			</cfloop>
			<cfthrow message="#arguments.mapName# is not defined as a mapping" type="bluedragon.adminapi.extensions">
		</cfif>
	</cffunction>

	<cffunction name="setCPPCFX" access="public" output="false" returntype="void" hint="Registers a C++ CFX">
		<cfargument name="displayname" type="string" required="true" hint="Name of CFX tag to show in the Administrator" />
		<cfargument name="module" type="string" required="true" hint="Library module that implments the interface" />
		<cfargument name="description" type="string" default="" hint="Description of CFX tag" />
		<cfargument name="name"	 type="string" default="#arguments.displayname#" hint="Name of tag, beginning with cfx_" />
		<cfargument name="keeploaded" type="boolean" default="true" hint="Indicates if BlueDragon should keep the CFX tag in memory" />
		<cfargument name="function" type="string" default="ProcessTagRequest" hint="Name of the procedure that implements the tag" />
		
		<cfset var localConfig = getConfig() />
		<cfset var cppCFX = StructNew() />

		<!--- Make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "nativecustomtags")) OR (NOT StructKeyExists(localConfig.nativecustomtags, "mapping"))>
			<cfset localConfig.nativecustomtags.mapping = ArrayNew(1) />
		</cfif>

		<!--- Build C++ CFX Struct --->
		<cfset cppCFX.displayname = arguments.displayname />
		<cfset cppCFX.module = arguments.module />
		<cfset cppCFX.description = arguments.description />
		<cfset cppCFX.name = LCase(arguments.name) />
		<cfset cppCFX.keeploaded = arguments.keeploaded />
		<cfset cppCFX.function = arguments.function />

		<!--- Prepend it to the Java CFX array --->
		<cfset ArrayPrepend(localConfig.nativecustomtags.mapping, Duplicate(cppCFX)) />
	
		<cfset setConfig(localConfig) />
	</cffunction>

	<cffunction name="setCustomTagPath" access="public" output="false" returntype="void" hint="Defines a new path to customtags">
		<cfargument name="path" required="true" type="string" hint="Path to customtag" />
		<cfset var localConfig = getConfig() />

		<!--- Make sure there are Custom Tag Paths defined --->
		<cfif (NOT StructKeyExists(localConfig, "cfmlcustomtags")) OR (NOT StructKeyExists(localConfig.cfmlcustomtags, "mapping"))>
			<cfset localConfig.cfmlcustomtags.mapping = ArrayNew(1) />
			<cfset localConfig.cfmlcustomtags.mapping[1].name = "cf" />
		</cfif>
	
		<!--- Append customtag path to list --->
		<cfreturn ListAppend(localConfig.cfmlcustomtags.mapping[1].directory, arguments.path, separator.path) />

		<cfset setConfig(localConfig) />
	</cffunction>

	<cffunction name="setJavaCFX" access="public" output="false" returntype="void" hint="Registers a Java CFX">
		<cfargument name="displayname" type="string" required="true" hint="Name of CFX tag to show in the Administrator" />
		<cfargument name="class" type="string" required="true" hint="Class name (minus .class) that implments the interface" />
		<cfargument name="description" type="string" default="" hint="Description of CFX tag" />
		<cfargument name="name"	 type="string" default="#arguments.displayname#" hint="Name of tag, beginning with cfx_" />
		
		<cfset var localConfig = getConfig() />
		<cfset var javaCFX = StructNew() />

		<!--- Make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "javacustomtags")) OR (NOT StructKeyExists(localConfig.javacustomtags, "mapping"))>
			<cfset localConfig.javacustomtags.mapping = ArrayNew(1) />
		</cfif>
		
		<!--- Build Java CFX Struct --->
		<cfset javaCFX.displayname = arguments.displayname />
		<cfset javaCFX.class = arguments.class />
		<cfset javaCFX.description = arguments.description />
		<cfset javaCFX.name = LCase(arguments.name) />

		<!--- Prepend it to the Java CFX array --->
		<cfset ArrayPrepend(localConfig.javacustomtags.mapping, Duplicate(javaCFX)) />
	
		<cfset setConfig(localConfig) />
	</cffunction>

	<cffunction name="setMapping" access="public" output="false" returntype="void" hint="Creates a mapping, equating a logical path to a directory path">
		<cfargument name="mapName" type="string" required="true" hint="Mapping name to show in the Administrator - Logical path name" />
		<cfargument name="mapPath" type="string" required="true" hint="Directory path name" />
		<cfargument name="name"	 type="string" default="#arguments.mapName#" hint="Mapping name for lookup. (Defaults to lowercase on mapName)" />
		
		<cfset var localConfig = getConfig() />
		<cfset var mapping = StructNew() />

		<!--- Make sure configuration structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "cfmappings")) OR (NOT StructKeyExists(localConfig.cfmappings, "mapping"))>
			<cfset localConfig.cfmappings.mapping = ArrayNew(1) />
		</cfif>
		
		<!--- Build Mapping Struct --->
		<cfset mapping.displayname = arguments.mapName />
		<cfset mapping.directory = arguments.mapPath />
		<cfset mapping.name = LCase(arguments.name) />

		<!--- Prepend it to the Mapping array --->
		<cfset ArrayPrepend(localConfig.cfmappings.mapping, Duplicate(mapping)) />
	
		<cfset setConfig(localConfig) />
	</cffunction>

</cfcomponent>