<cfif find(uploadFolder, "/") NEQ 1>
	Fixing uploadFolder variable. <cfoutput>#uploadFolder#</cfoutput> ->
	<cfset uploadFolder="#expandPath("/"&uploadFolder)#" />  <cfoutput>#uploadFolder#</cfoutput>
</cfif>

<cfif NOT isDefined("FORM.upload")>
	<form method="post" enctype="multipart/form-data" action="?task=upload&folder=<cfoutput>#URL.folder#</cfoutput>">
		<label>Upload a File<input type="file" name="upload" /></label>
		<label><input type="checkbox" name="overwrite" value="true" /> Overwrite?</label>
		<input type="submit" value="Upload" />
	</form>
<cfelse>
	<cfparam name="FORM.overwrite" default="false" type="boolean" />

	<cfif NOT directoryExists(uploadFolder)>
		Creating folder.... <cfoutput>#uploadFolder#</cfoutput>
		<cfdirectory action="create" directory="#uploadFolder#" />
	</cfif>

	<cffile  
	    action = "uploadall" 
	    destination = "#uploadFolder#" 
	    nameConflict = "#FORM.overwrite?"overwrite":"makeunique"#" 
	    result = "newUpload">
	
	<cfdump var="#newUpload#" />
	<cflocation url="index.cfm?folder=#URL.folder##newUpload.fileWasOverwritten?"overwrite=true":""#&uploaded=#serverFile#" addtoken="false" />
</cfif>

<cfdirectory action="list" directory="#uploadFolder#" name="dir" />
<cfdump var="#dir#" />
