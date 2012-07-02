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
    
    <cffunction name="requireAuth">
        <cfparam name="SESSION.comiEditor.isAuthenticated" default="false">
        <cfif !SESSION.comiEditor.isAuthenticated>
            <cfheader statuscode="401" statustext="Unauthorized">
            <cfoutput><h1>Access Denied</h1><p>You don't have permission to do this action or your session has timed out.</p></cfoutput>
            <cfabort>
        </cfif>
    </cffunction>

	<cffunction name="embed" output="false" access="remote">
		<cfset requireAuth()>
        
        <cfset editor = variables.editor>
        
		<cfsavecontent variable="editor.html"><cfinclude template="views/templates/index.cfm"></cfsavecontent>

		<cfreturn editor.html>
	</cffunction>

	<cffunction name="load" access="remote">
		<cfargument name="path" default="#variables.editor.path#">
		<cfset requireAuth()>
        
        <cfset editor = variables.editor>

		<cfset editor.path = fixPath(arguments.path)>
		<cfsavecontent variable="editor.html"><cfinclude template="views/editor/#fixPath(arguments.view)#.cfm"></cfsavecontent>

		<cfreturn editor.html>
	</cffunction>

	<cffunction name="save" access="remote">
		<cfargument name="file" required="true">
		<cfargument name="fileContents" required="true">
        
        <cfset requireAuth()>
        
		<cfset editor = variables.editor>

		<cfset editor.file = fixPath(arguments.file)>
		<cfset editor.fileContents = arguments.fileContents>

		<cfif fileExists(expandPath(editor.file))>
            <cffile action="write" output="#editor.fileContents#" charset="utf-8" file="#expandPath(editor.file)#">
        </cfif>
	</cffunction>

	<cffunction name="fixPath" output="false">
		<cfargument name="path" required="true">
        <cfset requireAuth()>
		<!--- force it to start at the root... for now. I don't want it to default to this folder if no path is supplied. Also, strip all extra slashes. --->
		<cfset arguments.path = rereplace("/#arguments.path#", "/+", "/", "all")>

		<!--- don't allow any number of '.' characters before a slash. Verify this is sufficient to keep you from exposing your entire server's file system! --->
		<cfreturn rereplace(arguments.path, "\.+/", "/", "all")>
	</cffunction>

	<cffunction name="open" access="remote" output="false">
		<cfargument name="file" required="true">
		<cfsilent>
        <cfset requireAuth()>
		<cfset var loc = {result=""}>
		<cfset arguments.file = fixPath(arguments.file)>
	
		<cfif fileExists(expandPath(arguments.file))>
			<cffile action="read" file="#expandPath(arguments.file)#" variable="loc.result">
		</cfif>
<cfdump var="#loc#" /><cfabort>
		</cfsilent>		
		<cfcontent reset="true"><cfreturn loc.result>
	</cffunction>
    
    <cffunction name="newFile" access="remote">
        <cfset requireAuth()>
        
        <cfif directoryExists(expandPath(FORM.folder))>
            <cfif fileExists('#expandPath(FORM.folder)#/#FORM.fileName#')>
                <cfheader statuscode="409" statustext="Conflict">
                <cfoutput><h1>File already exists</h1></cfoutput>
                <cfabort>
            <cfelse>
                <cffile action="write" output="" charset="utf-8" file="#expandPath(FORM.folder)#/#FORM.fileName#">
            </cfif>
        <cfelse>
            <cfheader statuscode="409" statustext="Conflict">
            <cfoutput><h1>Folder does not exists</h1></cfoutput>
            <cfabort>
        </cfif>
    </cffunction>
</cfcomponent>
