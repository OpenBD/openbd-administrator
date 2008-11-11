<cfquery name="test2" datasource="m2cms" cachename="test">
	select * 
	from Person
</cfquery>

<cfdump var="#test2#" />