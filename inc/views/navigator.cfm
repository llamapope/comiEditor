<cfparam name="URL.task" default="" />
<cfparam name="URL.action" default="" />
<cfparam name="URL.file" default="" />
<cfparam name="URL.dir" default="" />
<cfparam name="URL.folder" default="" />
<cfparam name="URL.cancel" default="" />

<cfset URL.folder = rereplace(URL.folder, "[^/]+/\.\./", "", "all") />
<cfset uploadFolder=URL.folder />
<cfset linkFolder = uploadFolder />

<cfif reFind("/\.\./SubDomains/([^/]*)(/?.*)", linkFolder)>
	<cfset linkFolder = "#rereplace("#linkFolder#", '/\.\./SubDomains/([^/]*)(/?.*)', 'http://\1.#CGI.SERVER_NAME#\2')#" />
<cfelseif find("/../wwwroot", linkFolder) GT 0>
	<cfset linkFolder = replaceNoCase(linkFolder, "/../wwwroot", "", "all") />
<cfelseif linkFolder NEQ "">
	<cfset linkFolder = "/#linkFolder#" />
</cfif>

<cfif URL.task IS "UPLOAD">
	<cfinclude template="editor/upload.cfm" />
	<cfabort />
</cfif>
<cfset editorScript="index.cfm" />

<cfsavecontent variable="htmlHead">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js"></script>
<link href="styles/comiEditor.css" rel="stylesheet" type="text/css" />
<script>
;(function($){
	$(function(){
		$("a.delete").click(function(e){
			var dialog = $("<div>Are you sure you want to delete this?</div>").appendTo("body");
			$(dialog).dialog({buttons:{"OK": function(){window.location=e.originalTarget.href + "&confirm=true";},"Cancel": function(){$(this).dialog("close");}}});
			return false;
		});
	});
})(jQuery);
</script>
</cfsavecontent>
<cfhtmlhead text="#htmlHead#" />

<div class="container">
<div class="cmd right">
<cfif fileExists("#expandPath('inc/config/#SESSION.comiEditor.username#/shortcuts.cfm')#")>
	<cfinclude template="../config/#SESSION.comiEditor.username#/shortcuts.cfm" />
<cfelse>
	<cfinclude template="../config/default/shortcuts.cfm" />
</cfif>
</div>
<cftry>
	<cfdirectory directory="#expandPath('/#uploadFolder#')#" name="dir" sort="type ASC, name ASC" />

<cfoutput>
<div class="cmd">
New:	<a href="#editorScript#?file=untitled&folder=#uploadFolder#">File</a> | <a href="#editorScript#?dir&folder=#uploadFolder#">Folder</a> | <a href="?task=upload&folder=#uploadFolder#">Upload</a> | <a href="#editorScript#?task=import&folder=#uploadFolder#">Import</a>
</div>
</cfoutput>

<div class="fileManager">
<cfif dir.recordCount GT 0>
	<cfoutput>
	<h1>#replaceNoCase(dir.directory[1], "d:\home\bignowhere.com", "")#</h1>
	<ul>
    <cftry>
    <cfif directoryExists(expandPath('../#uploadFolder#/..'))>
		<li><a href="?folder=#uploadFolder#/.." class="dir"><em>[Parent]</em></a></li>
    </cfif>
    <cfcatch type="security"><li><em>#CGI.SERVER_NAME#</em></li></cfcatch>
    </cftry>
	</cfoutput>
	<cfoutput query="dir">
		<li class="#URL.file EQ name?"saved":URL.cancel EQ name?"closed":""#">
		<cfif type EQ "file">
			<cfset fileExtension = rereplace(name, ".*\.([^\.]*)$", '\1') />
			<a href="#editorScript#?file=#name#&folder=#uploadFolder#" class="file">#name#</a>
		<cfelseif type EQ "dir">
			<a href="?folder=#uploadFolder##uploadFolder NEQ ""?"/":""##name#" class="#type#">#name#</a>
		</cfif>
			<div class="menu">
				<a href="#editorScript#?<cfif type EQ "file">file=#name#&<cfelseif type EQ "dir">dir=#name#&</cfif>action=delete&folder=#uploadFolder#" class="delete">Delete</a>
				<a href="#linkFolder#/#name#" target="_blank">View</a>
			</div>
		</li>
	</cfoutput>
	</ul>
<cfelse>
	<cftry>
		<cfif directoryExists(expandPath('../../../#uploadFolder#/..'))>
		<cfoutput>
			<li><a href="?folder=#uploadFolder#/.."><em>[Parent]</em></a></li>
		</cfoutput>
		</cfif>
		<cfcatch type="security"><li><em>#CGI.SERVER_NAME#</em></li></cfcatch>
	</cftry>
	<em>[No files in folder]</em>
</cfif>
</div>

<cfcatch type="security">
	<div class="error">
    <cfoutput>
    	Folder isn't accessible.
        <a href="?folder=#rereplace(uploadFolder, '(.*)/[^/]*$', '\1')#">Back</a>
        <a href="?folder">Reset</a>
    </cfoutput>
    </div>
</cfcatch>
</cftry>

<div class="message">
	<cfif URL.action EQ "delete">
		<cfoutput>
			<tt>'#URL.folder#/#URL.file##URL.dir#'</tt> deleted.
		</cfoutput>
	</cfif>
</div>

</div>
