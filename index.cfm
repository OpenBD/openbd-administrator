<!--- test datasources --->
<cfquery name="test" datasource="simplekms">
	select * from Category
</cfquery>

<cfdump var="#test#" expand="true" />

<cfoutput>isNumeric('123.45') = #isNumeric('123.45')#</cfoutput>