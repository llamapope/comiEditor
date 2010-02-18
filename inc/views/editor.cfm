<cfparam name="FORM.fileName" default="" />
<cfparam name="FORM.fileContent" default="" />
<cfparam name="FORM.folder" default="" />
<cfparam name="FORM.dir" default="" />
<cfparam name="FORM.originalFile" default="" />
<cfparam name="FORM.cancel" default="" />

<cfset trim(FORM.fileContent) />

<cfparam name="URL.file" default="" />
<cfparam name="URL.action" default="" />
<cfparam name="URL.folder" default="#FORM.folder#" />
<cfparam name="URL.dir" default="false" />

<cfset uploadFolder = URL.folder />

<cfset filePattern = "[a-zA-Z\._0-9\- !,@$]+" />
<cfif URL.dir EQ "">
	<cfset mode = "Create Folder" />
<cfelse>
	<cfset mode="Create" />
</cfif>

<cftry>
	<cfif FORM.dir NEQ "">
		<cfif NOT isValid("regex", FORM.dir, filePattern)>
			<cfthrow message="Folder name is invalid." detail="Refresh <a href='./?folder=#uploadFolder#'>the listing</a> and try editing the file again." />
		<cfelse>
			<cfdirectory action="create" directory="#expandPath('/')##uploadFolder#/#FORM.dir#" />
			<cflocation url="index.cfm?file=#URL.file#&dir=#FORM.dir#&folder=#uploadFolder#" addtoken="false" />	
		</cfif>
        <cfelseif FORM.cancel IS "Cancel">
                <cflocation url="index.cfm?cancel=#FORM.fileName#&folder=#uploadFolder#" addtoken="false" />
	<cfelseif FORM.fileName NEQ "">
		<cfif NOT isValid("regex", FORM.fileName, filePattern)>
			<cfthrow message="File name is invalid." detail="Fix the file name and try again.<em>Pattern: #filePattern#</em>" />
		<cfelse>
			<cffile action="write" output="#FORM.fileContent#" charset="utf-8" file="#expandPath('/')##uploadFolder#/#FORM.fileName#" />
			<cfif FORM.originalFile NEQ "" AND lCase(FORM.originalFile) NEQ lCase(FORM.fileName)>
				<cfif fileExists("#expandPath('/')##uploadFolder#/#FORM.originalFile#")>
					<cffile action="delete" file="#expandPath('/')##uploadFolder#/#FORM.originalFile#" />
				</cfif>
			</cfif>
			<cflocation url="index.cfm?file=#FORM.fileName#&folder=#uploadFolder#" addtoken="false" />
		</cfif>
	<cfelseif URL.file NEQ "">
		<cfif NOT isValid("regex", URL.file, filePattern)>
			<cfthrow message="File name is invalid." detail="Refresh <a href='./'>the listing</a> and try editing the file again." />
		<cfelseif lCase(URL.action) EQ "delete">
			<cfif fileExists("#expandPath('/')##uploadFolder#/#URL.file#")>
				<cffile action="delete" file="#expandPath('/')##uploadFolder#/#URL.file#" />
				<cflocation url="index.cfm?file=#URL.file#&action=delete&folder=#uploadFolder#" addtoken="false" />
			</cfif>
		<cfelseif fileExists("#expandPath('/')##uploadFolder#/#URL.file#")>
			<cfset mode="Edit" />
			<cffile action="read" file="#expandPath('/')##uploadFolder#/#URL.file#" variable="fileEdit" />
			<cfset FORM.fileName = URL.file />
			<cfset FORM.fileContent = fileEdit />
		<cfelse>
			<cfset mode="Create" />
			<cfset FORM.fileName = URL.file />
		</cfif>
	<cfelseif URL.dir NEQ "">
		<cfif NOT isValid("regex", URL.dir, filePattern)>
			<cfthrow message="Folder name is invalid." detail="Refresh <a href='./'>the listing</a> and try editing the file again." />
		<cfelseif lCase(URL.action) EQ "delete">
			<cfif isDefined("URL.confirm") AND URL.confirm EQ true>
				<cfif DirectoryExists("#expandPath('/')##uploadFolder#/#URL.dir#")>
					<cfdirectory action="delete" directory="#expandPath('/')##uploadFolder#/#URL.dir#" recurse="true" />
					<cflocation url="index.cfm?dir=#URL.dir#&action=delete&folder=#uploadFolder#" addtoken="false" />
				<cfelse>
					Directory doesn't exist.
					<pre>
	<cfoutput>#expandPath('/')##uploadFolder#/#URL.dir#</cfoutput>
					</pre>
				</cfif>
			<cfelse>
			<cfoutput>
				<p>Are you sure you want to delete the folder #expandPath('/')##uploadFolder#/#URL.dir# and all of its contents?</p>
				<a href="?dir=#URL.dir#&action=delete&folder=#uploadFolder#&confirm=true">Delete <tt>'#URL.dir#'</tt></a> <a href="index.cfm?dir=#URL.dir#&action=cancel&folder=#uploadFolder#">Cancel</a>
				<p>This action cannot be undone.</p><cfabort/>
			</cfoutput>
			</cfif>
		</cfif>
	</cfif>
<cfcatch>
	<cfoutput>
	<div class="error">
		<h1>#cfcatch.message#</h1>
		<p>#cfcatch.detail#</p>
	</div>
	</cfoutput>
</cfcatch>
</cftry>

<style>
@import "styles/editor.css.cfm";
</style>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script src="editor.js"></script>

<cfoutput>
<form method="post">
<cfif mode EQ "Create Folder">
	<label>
		<span>Folder Name</span>
		<input type="text" name="dir" value="#FORM.dir#" />
	</label>
<cfelse>
	<label>
		<span>File Name</span>
		<input type="text" name="fileName" value="#FORM.fileName#" />
	</label>
	<label>
		<span>File Content</span>
		<textarea wrap="off" spellcheck="false" cols="80" id="editor" name="fileContent">#replaceNoCase(rereplace(trim(FORM.fileContent), "&([a-z]*;)", "&amp;\1", "all"), "<", "&lt;", "all")#</textarea>
	</label>
</cfif>
	<input type="hidden" name="originalFile" value="#URL.file#" />
	<input type="hidden" name="folder" value="#URL.folder#" />
	<input type="submit" value="#mode IS "edit"?"Save":mode#" />
        <input type="submit" name="cancel" value="Cancel" />

<div class="controlBox">
<a href="##maximize" class="window">Maximize Editor</a>
</div>
</form>

<cfif fileExists(expandPath("../config/#session.comiEditor.username#/dictionaries/index.cfm"))>
	<cfinclude template="../config/#session.comiEditor.username#/dictionaries/index.cfm" />
<cfelseif fileExists(expandPath("../config/default/dictionaries/index.cfm"))>
	<cfinclude template="../config/default/dictionaries/index.cfm" />
</cfif>
</cfoutput>

<script>
$(".window").toggle(function() {
	var css = {position: "fixed", height: "100%",top: 0,bottom:0,left:0,right:0};
	$(this).text("Restore Editor");
	$("#editor", $(this).parents("form")).css(css);
	$(this).parent().addClass("restore");
	return false;
},
function() {
	$(this).text("Maximize Editor");
	$("#editor", $(this).parents("form")).css({position: "static", height: "80%"});return false;
	$(this).parent().removeClass("restore");
	return false;
});
</script>
<style>
.controlBox { position: absolute; z-index: 1000;bottom: 10px; right: 5px; }
.controlBox.restore { position: fixed; top: 4px; bottom: auto; right: 20px; }
</style>
