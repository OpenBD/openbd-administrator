<cfcomponent 
		displayname="SearchCollections" 
		output="false" 
		extends="Base" 
		hint="Manages search collections - OpenBD Admin API">
	
	<cffunction name="getSearchCollections" access="public" output="false" returntype="array" 
			hint="Returns an array containing defined search collections">
		<cfset var searchCollections = arrayNew(1) />
		<cfset var localConfig = getConfig() />
		
		<!--- check to see if the cfcollection node exists --->
		<cfif NOT structKeyExists(localConfig, "cfcollection") OR NOT structKeyExists(localConfig.cfcollection, "collection")>
			<cfthrow message="No search collections defined" type="bluedragon.adminapi.SearchCollection" />
		<cfelse>
			<cfreturn localConfig.cfcollection.collection />
		</cfif>
	</cffunction>
	
	<cffunction name="createSearchCollection" access="public" output="false" returntype="void" 
			hint="Creates a search collection">
		<cfargument name="name" type="string" required="true" hint="The name of the search collection" />
		<cfargument name="path" type="string" required="true" hint="The path where the search collection will be stored" />
		<cfargument name="language" type="string" required="true" hint="The language of the search collection" />
		<cfargument name="storebody" type="boolean" required="true" 
				hint="Boolean indicating whether or not to store the document body in the search collection" />
		
		<cfcollection action="create" >
		
		<cfset var localConfig = getConfig() />
		<cfset var i = 0 />
		<cfset var searchCollection = structNew() />
		
		<!--- cfcollection node may not exist --->
		<cfif not structKeyExists(localConfig, "cfcollection")>
			<cfset localConfig.cfcollection = structNew() />
			<cfset localConfig.cfcollection.collection = arrayNew(1) />
		</cfif>
		
		<!--- make sure a collection with this name doesn't already exist --->
		<cfloop index="i" from="1" to="#arrayLen(localConfig.cfcollection.collection)#">
			<cfif compareNoCase(localConfig.cfcollection.collection[i].name, arguments.name) eq 0>
				<cfthrow message="A collection with that name already exists" 
						type="bluedragon.adminapi.searchcollections" />
			</cfif>
		</cfloop>
		
		<!--- create the collection --->
		<cfset searchCollection.name = arguments.name />
		<cfset searchCollection.path = arguments.path />
		<cfset searchCollection.language = arguments.language />
		<cfset searchCollection.storebody = ToString(arguments.storebody) />
		
		<cfset arrayAppend(localConfig.cfcollection.collection, searchCollection) />
		
		<cfset setConfig(localConfig) />
	</cffunction>
	
	<cffunction name="deleteSearchCollections" access="public" output="false" returntype="void" 
			hint="Deletes one or more search collections by name">
		
	</cffunction>
	
	<cffunction name="getSupportedLanguages" access="public" output="false" returntype="array" 
			hint="Returns an array containing the supported languages for collections">
		<cfreturn createObject("java", "com.naryx.tagfusion.search.lucene.AnalyzerFactory").getSupportedLanguages() />
	</cffunction>
	
</cfcomponent>