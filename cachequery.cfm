<cfquery name="test2" datasource="test">
	select * 
	from Person
</cfquery>

<cfdump var="#test2#" />