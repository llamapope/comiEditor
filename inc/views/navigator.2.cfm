<cfparam name="URL.folder" default="" />
<!---
<cfset initialDir = expandPath("/")>
<cfdirectory directory="#initialDir#" recurse="yes" name="files" sort="directory asc, type ASC, name ASC">

<cfset filterString = "WEB-INF,%/WEB-INF,.git,%/.git,images/%" />
<cfset filteredFiles = filterDir(files,filterString, initialDir) />

<cfoutput>
<div class="fileManager">
	<h2><cfoutput>#initialDir#</cfoutput></h2>
	#displayDirectoryTree(files=filteredFiles,parent=initialDir,replacePathWith="?folder=,?folder=miscellaneous/comiEditor/",basePath="#expandPath("/")#,/home/pope/git/llamapope/comiEditor/")#
</div>
</cfoutput>
--->
