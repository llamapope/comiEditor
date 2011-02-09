<cfdirectory name="dir" action="list" directory="#expandPath(editor.path)#">
<cfquery dbtype="query" name="sortedDir">
	SELECT * FROM dir
	ORDER BY type, name
</cfquery>
<cfoutput><ul></cfoutput>
<cfoutput query="sortedDir">
	<li class="#lcase(type)#">#name#</li>
</cfoutput>
<cfoutput></ul></cfoutput>
