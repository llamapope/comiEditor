<cfparam name="URL.folder" default="" />

<cfset initialDir = expandPath("/#URL.folder#")>
<cfdirectory directory="#initialDir#" recurse="yes" name="files" sort="directory asc, type ASC, name ASC">

<cfset filterString = "WEB-INF,%/WEB-INF,.git,%/.git" />
<cfset filteredFiles = filterDir(files,filterString, initialDir) />

<cfoutput>
<div class="fileManager">
	<h2><cfoutput>#initialDir#</cfoutput></h2>
	#displayDirectoryTree(filteredFiles,initialDir,"edit/")#
</div>
</cfoutput>
