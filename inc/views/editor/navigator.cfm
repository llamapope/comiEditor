<cfdirectory name="dir" action="list" directory="#expandPath(editor.path)#">
<cfquery dbtype="query" name="sortedDir">
	SELECT * FROM dir
	ORDER BY type, name
</cfquery>
<ul>
<cfoutput query="sortedDir">
	<li class="#lcase(type)#">#name#</li>
</cfoutput>
</ul>
