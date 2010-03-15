<div class="editor">
<cfinclude template="inc/views/editor.cfm" />

<cfif fileExists(expandPath("./inc/config/#session.comiEditor.username#/dictionaries/index.cfm"))>
	<cfinclude template="inc/config/#session.comiEditor.username#/dictionaries/index.cfm" />
<cfelseif fileExists(expandPath("./inc/config/default/dictionaries/index.cfm"))>
	<cfinclude template="inc/config/default/dictionaries/index.cfm" />
</cfif>

</div>
