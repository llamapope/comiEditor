<cfif fileExists(expandPath(editor.file))>
	<cffile action="write" output="#editor.fileContents#" charset="utf-8" file="#expandPath(editor.file)#">
</cfif>
