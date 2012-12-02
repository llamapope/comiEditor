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
		<cfsavecontent variable="editor.html"><cfinclude template="views/editor/#fixFileName(arguments.view)#.cfm"></cfsavecontent>

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

	<cffunction name="fixPath" output="false" access="remote">
		<cfargument name="path" required="true">
        
        <cfset requireAuth()>
        
        <cfif reFindNoCase("^(/(\.?[a-z0-9-_ ]+)*)+/?$", arguments.path) EQ 0>
            <cfheader statuscode="409" statustext="Conflict">
            
            <cfdump var="#arguments#">
            <cfoutput><h1>invalid path specified</h1></cfoutput>
            <cfabort>
        </cfif>
        
		<!--- don't allow any number of '.' characters before a slash. Verify this is sufficient to keep you from exposing your entire server's file system! --->
		<cfset arguments.path = rereplace(arguments.path, "\.+/", "/", "all")>

		<!--- force it to start at the root... for now. I don't want it to default to this folder if no path is supplied. Also, add a slash on the end, and then strip all extra slashes. --->
		<cfreturn rereplace("/#arguments.path#/", "/+", "/", "all")>
	</cffunction>
    
	<cffunction name="fixFileName" output="false" access="remote">
		<cfargument name="fileName" required="true">
        
        <cfset requireAuth()>
        
		<cfif reFindNoCase("^(\.?[a-z0-9-_ ]+)+$", arguments.fileName) EQ 0>
            <cfheader statuscode="409" statustext="Conflict">
            <cfoutput><h1>invalid filename</h1></cfoutput>
            <cfabort>
        </cfif>

		<!--- get rid of any leading or trailing spaces --->
		<cfreturn trim(arguments.fileName)>
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
        <cfargument name="folder" required="true">
        <cfargument name="fileName" required="true">
        
        <cfset requireAuth()>
        
        <cfset arguments.folder = fixPath(arguments.folder)>
        <cfset arguments.fileName = fixFileName(arguments.fileName)>
        
        <cfif directoryExists(expandPath(arguments.folder))>
            <cfif fileExists('#expandPath(arguments.folder)#/#arguments.fileName#')>
                <cfheader statuscode="409" statustext="Conflict">
                <cfoutput><h1>file already exists</h1></cfoutput>
                <cfabort>
            <cfelse>
                <cffile action="write" output="" charset="utf-8" file="#expandPath(arguments.folder)#/#arguments.fileName#">
            </cfif>
        <cfelse>
            <cfheader statuscode="409" statustext="Conflict">
            <cfoutput><h1>Folder does not exists</h1></cfoutput>
            <cfabort>
        </cfif>
        
        <cfreturn "<h2>file created</h2>">
    </cffunction>
    
    <cffunction name="renameFile" access="remote">
        <cfargument name="folder" required="true">
        <cfargument name="originalFileName" required="true">
        <cfargument name="fileName" required="true">
        
        <cfset requireAuth  ()>
        
        <cfset arguments.folder = fixPath(arguments.folder)>
        <cfset arguments.originalFileName = fixFileName(arguments.originalFileName)>
        <cfset arguments.fileName = fixFileName(arguments.fileName)>
        
        <cfif directoryExists(expandPath(arguments.folder))>
            <cfif fileExists('#expandPath(arguments.folder)#/#arguments.fileName#')>
                <cfheader statuscode="409" statustext="Conflict">
                <cfoutput><h1>file already exists</h1></cfoutput>
                <cfabort>
            <cfelseif fileExists('#expandPath(arguments.folder)#/#arguments.originalFileName#')>
                <cffile action="rename" source="#expandPath(arguments.folder)#/#arguments.originalFileName#" destination="#expandPath(arguments.folder)#/#arguments.fileName#">
            <cfelse>
                <cfheader statuscode="409" statustext="Conflict">
                <cfoutput><h1>file does not exists</h1></cfoutput>
                <cfabort>
            </cfif>
        <cfelse>
            <cfheader statuscode="409" statustext="Conflict">
            <cfoutput><h1>folder does not exists</h1></cfoutput>
            <cfabort>
        </cfif>
        
        <cfreturn "<h2>file renamed</h2>">
    </cffunction>
</cfcomponent>
