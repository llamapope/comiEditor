<html>
<head>
<body>
<cfif NOT (isDefined("URL.task") AND URL.task EQ "upload")> 
	<div class="navigator">
	<cfinclude template="inc/views/navigator.2.cfm" />
	</div>

	<div class="editor">
		<cfinclude template="inc/views/editor.cfm" />
	
		<cfif fileExists(expandPath("./inc/config/#session.comiEditor.username#/dictionaries/index.cfm"))>
			<cfinclude template="inc/config/#session.comiEditor.username#/dictionaries/index.cfm" />
		<cfelseif fileExists(expandPath("./inc/config/default/dictionaries/index.cfm"))>
			<cfinclude template="inc/config/default/dictionaries/index.cfm" />
		</cfif>
	</div>

	<script src="navigator.js"></script>
</cfif>
<cftry>
	<cfinclude template="inc/views/navigator.cfm" />
<cfcatch>
	<cfdump var="#cfcatch#" />
</cfcatch>
</cftry>

</body>
</html>
