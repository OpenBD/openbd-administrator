<!---
	Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
	
	Contributing Developers:
	David C. Epler - dcepler@dcepler.net
	Matt Woodward - matt@mattwoodward.com

	This file is part of of the Open BlueDragon Admin API.

	The Open BlueDragon Admin API is free software: you can redistribute 
	it and/or modify it under the terms of the GNU General Public License 
	as published by the Free Software Foundation, either version 3 of the 
	License, or (at your option) any later version.

	The Open BlueDragon Admin API is distributed in the hope that it will 
	be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
	General Public License for more details.
	
	You should have received a copy of the GNU General Public License 
	along with the Open BlueDragon Admin API.  If not, see 
	<http://www.gnu.org/licenses/>.
--->
<cfcomponent displayname="Fonts" 
		output="false" 
		extends="Base" 
		hint="Manage font directories - OpenBD Admin API">

	<cffunction name="getFontDirectories" access="public" output="false" returntype="array" 
			hint="Returns an array containing the defined font directories">
		<cfset var localConfig = getConfig() />
		<cfset var returnArray = ArrayNew(1) />
		<cfset var fontDir = "" />

		<cfset checkLoginStatus() />

		<!--- Make sure there are font directories --->
		<cfif NOT StructKeyExists(localConfig, "fonts") OR NOT StructKeyExists(localConfig.fonts, "dirs") 
				OR localConfig.fonts.dirs is "">
			<cfthrow message="No Font Directories Defined" type="bluedragon.adminapi.fonts" />
		<cfelse>
			<cfloop list="#localConfig.fonts.dirs#"  index="fontDir">
				<cfset arrayAppend(returnArray, fontDir) />
			</cfloop>
		</cfif>

		<cfreturn returnArray />
	</cffunction>

	<cffunction name="setFontDirectory" access="public" output="false" returntype="void" 
				hint="Creates font directory">
		<cfargument name="fontDirectory" type="string" required="true" hint="The physical path to the font directory" />
		<cfargument name="action" type="string" required="false" default="create" hint="Font directory action (create or update)" />
		<cfargument name="existingFontDirectory" type="string" required="false" default="" 
				hint="Existing font directory--used in the event of an update" />
		
		<cfset var localConfig = getConfig() />

		<cfset checkLoginStatus() />
		
		<!--- Make sure font directory structure exists, otherwise build it --->
		<cfif (NOT StructKeyExists(localConfig, "fonts")) OR (NOT StructKeyExists(localConfig.fonts, "dirs"))>
			<cfset localConfig.fonts = structNew() />
			<cfset localConfig.fonts.dirs = "" />
		</cfif>
		
		<!--- make sure we can hit the font directory --->
		<cftry>
			<cfif not directoryExists(arguments.fontDirectory)>
				<cfthrow message="The font directory specified is not accessible. Please verify that the directory exists and has the correct permissions." 
						type="bluedragon.adminapi.fonts" />
			</cfif>
			<cfcatch type="any">
				<cfthrow message="The font directory specified is not accessible. Please verify that the directory exists and has the correct permissions." 
						type="bluedragon.adminapi.fonts" />
			</cfcatch>
		</cftry>
		
		<!--- if this is an edit, delete the existing font directory --->
		<cfif arguments.action is "update">
			<cfset deleteFontDirectory(arguments.existingFontDirectory) />
			<cfset localConfig = getConfig() />
			
			<!--- if that was the only font directory, need to recreate the structure --->
			<cfif (NOT StructKeyExists(localConfig, "fonts")) OR (NOT StructKeyExists(localConfig.fonts, "dirs"))>
				<cfset localConfig.fonts = structNew() />
				<cfset localConfig.fonts.dirs = "" />
			</cfif>
		</cfif>
		
		<!--- make sure the font directory doesn't already exist, and add it if it doesn't --->
		<cfif listFind(localConfig.fonts.dirs, arguments.fontDirectory) eq 0>
			<!--- set the new font directory --->
			<cfset localConfig.fonts.dirs = listAppend(localConfig.fonts.dirs, arguments.fontDirectory) />
		
			<cfset setConfig(localConfig) />
		</cfif>
	</cffunction>
	
	<cffunction name="verifyFontDirectory" access="public" output="false" returntype="void" 
			hint="Verifies the font direcotry by running cfdirectory on the physical path">
		<cfargument name="fontDirectory" type="string" required="true" hint="The font directory to verify" />

		<cfset checkLoginStatus() />
		
		<cftry>
			<cfif not directoryExists(arguments.fontDirectory)>
				<cfthrow message="The font directory specified is not accessible. Please verify that the directory exists and has the correct permissions." 
						type="bluedragon.adminapi.fonts" />
			</cfif>
			<cfcatch type="any">
				<cfthrow message="The font directory specified is not accessible. Please verify that the directory exists and has the correct permissions." 
						type="bluedragon.adminapi.fonts" />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="deleteFontDirectory" access="public" output="false" returntype="void" 
			hint="Deletes the specified font directory">
		<cfargument name="fontDirectory" required="true" type="string" hint="The font directory to delete" />

		<cfset var localConfig = getConfig() />
		<cfset var i = 0 />

		<cfset checkLoginStatus() />
		
		<cfif (NOT StructKeyExists(localConfig, "fonts")) OR (NOT StructKeyExists(localConfig.fonts, "dirs"))>
			<cfthrow message="No Font Directories Defined" type="bluedragon.adminapi.fonts" />		
		</cfif>
		
		<cfloop index="i" from="1" to="#listLen(localConfig.fonts.dirs)#">
			<cfif listGetAt(localConfig.fonts.dirs, i) is arguments.fontDirectory>
				<cfset localConfig.fonts.dirs = listDeleteAt(localConfig.fonts.dirs, i) />
				<cfset setConfig(localConfig) />
				<cfreturn />
			</cfif>
		</cfloop>
		
		<cfthrow message="#arguments.fontDirectory# is not defined as a font directory" type="bluedragon.adminapi.fonts" />
	</cffunction>

</cfcomponent>