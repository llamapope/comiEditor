<cfsetting enablecfoutputonly="true">

<cfif structKeyExists(URL, "AjaxUploadFrame")>
	<cfabort>
</cfif>

<cfparam name="URL.folder" default="/files">

<cfset uploadFolder = URL.folder>

<cfif NOT directoryExists(expandPath(uploadFolder))>
	<cfdirectory action="create" directory="#expandPath(uploadFolder)#">
</cfif>

<!---
<cfif NOT directoryExists(expandPath(uploadFolder&"/thumbnails"))>
	<cfdirectory action="create" directory="#expandPath(uploadFolder&"/thumbnails")#">
</cfif>
--->

<cfif structKeyExists(FORM, "test")>
	<cffile action="upload" fileField="test" destination="#expandPath(uploadFolder)#" nameconflict="overwrite" result="test">
<!---
	<cfimage
	    action = "resize"
	    height = "30%"
	    source = "#test.serverDirectory#/#test.serverFile#"
	    width = "30%"
	    destination = "#expandPath(uploadFolder)#/thumbnails/#test.serverFile#"
	    overwrite = "yes">
--->
	<cfabort>
</cfif>

<cfheader statuscode="500" statustext="Internal Server Error">
