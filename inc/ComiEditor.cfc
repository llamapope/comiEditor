<cfcomponent output="false">

	<cfset variables.editorRoot = "/ce">

	<cfset variables.editor = {
		editorRoot = editorRoot,
		scripts = "#editorRoot#/scripts",
		userFolder = "#editorRoot#/config/llama",
		userScripts = "scripts",
		stylesheets = "#editorRoot#/styles",
		theme = "vader",
		path = "/"
	}>

	<cffunction name="embed" output="false" access="remote">
		<cfset editor = variables.editor>
		<cfsavecontent variable="editor.html"><cfinclude template="views/templates/index.cfm"></cfsavecontent>

		<cfreturn editor.html>
	</cffunction>

	<cffunction name="load" access="remote">
		<cfargument name="path" default="#variables.editor.path#">
		<cfset editor = variables.editor>

		<cfset editor.path = fixPath(arguments.path)>
		<cfsavecontent variable="editor.html"><cfinclude template="views/editor/#fixPath(arguments.view)#.cfm"></cfsavecontent>

		<cfreturn editor.html>
	</cffunction>

	<cffunction name="save" access="remote">
		<cfargument name="file" required="true">
		<cfargument name="fileContents" required="true">

		<cfset editor = variables.editor>

		<cfset editor.file = fixPath(arguments.file)>
		<cfset editor.fileContents = arguments.fileContents>

		<cfsavecontent variable="editor.html"><cfinclude template="views/editor/save.cfm"></cfsavecontent>

		<cfreturn editor.html>
	</cffunction>

	<cffunction name="fixPath" output="false">
		<cfargument name="path" required="true">
		<!--- force it to start at the root... for now. I don't want it to default to this folder if no path is supplied. Also, strip all extra slashes. --->
		<cfset arguments.path = rereplace("/#arguments.path#", "/+", "/", "all")>

		<!--- don't allow any number of '.' characters before a slash. Verify this is sufficient to keep you from exposing your entire server's file system! --->
		<cfreturn rereplace(arguments.path, "\.+/", "/", "all")>
	</cffunction>

	<cffunction name="open" access="remote" output="false">
		<cfargument name="file" required="true">
		<cfsilent>
		<cfset var loc = {result=""}>
		<cfset arguments.file = fixPath(arguments.file)>
	
		<cfif fileExists(expandPath(arguments.file))>
			<cffile action="read" file="#expandPath(arguments.file)#" variable="loc.result">
		</cfif>
<cfdump var="#loc#" /><cfabort>
		</cfsilent>		
		<cfcontent reset="true"><cfreturn loc.result>
	</cffunction>
</cfcomponent>
