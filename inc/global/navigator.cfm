<cffunction name="filterDir">
	<cfargument name="fileQuery" type="query">
	<cfargument name="filterList" type="string">
	<cfargument name="basePath" type="string" default="#expandPath("./")#">
	<cfargument name="filterListDelim" type="string" default=",">
	<cfargument name="filterPathDelim" type="string" default="/">
	<cfargument name="osPathDelim" type="string" default="#getFileSeperator()#">

	<cfset var i = 1 />
	
	<cfif filterPathDelim NEQ osPathDelim>
		<cfset arguments.filterList = listChangeDelims(arguments.filterList, arguments.osPathDelim, arguments.filterPathDelim) />
	</cfif>
	
	<cfset arguments.basePath = rereplace(arguments.basePath, "\#arguments.osPathDelim#$", "") />
	
	<cfquery dbtype="query" name="filesFiltered">
	SELECT * FROM fileQuery
	WHERE
	NOT (
	<cfloop list="#arguments.filterList#" index="dir" delimiters="#arguments.filterListDelim#">
		directory LIKE '#arguments.basePath##arguments.osPathDelim##dir#<cfif NOT find("%", dir)>%</cfif>'
		OR (
			directory LIKE '#arguments.basePath#<cfif listLen(dir, arguments.osPathDelim) GT 1>#arguments.osPathDelim##rereplace(dir, "\#arguments.osPathDelim#[^\#arguments.osPathDelim#]+$", "")#</cfif>'
			AND name LIKE '#rereplace(dir, ".*?\#arguments.osPathDelim#([^\#arguments.osPathDelim#]+)$", "\1")#'
		)
		<cfif i++ NEQ listLen(arguments.filterList)>
			OR
		</cfif>
	</cfloop>
	)
	</cfquery>
	<cfreturn filesFiltered />
</cffunction>

<cffunction name="getFileSeperator">
	<cfset var seperator = "" />
	
	<cftry>
		<cfset seperator = createObject("java","java.io.File").separator />
	<cfcatch>
		<cfset seperator = "/" />
	</cfcatch>
	</cftry>
	
	<cfreturn seperator />
</cffunction>

<cffunction name="displayDirectoryTree" returnType="string" output="false">
	<cfargument name="files" type="query" required="true">
	<cfargument name="parent" type="string" required="true">
	<cfargument name="replacePathWith" type="string" default="" />
	<cfargument name="osPathDelim" type="string" default="#getFileSeperator()#">
	<cfargument name="webPathDelim" type="string" default="/">
	<cfargument name="depth" type="numeric" default="1">
	<cfargument name="basePath" type="string" default="#arguments.parent#" />
	
	<cfset var result = "" />
	<cfset var justMyKids = "" />
	<cfset var loc = {basePath=arguments.basePath} />

	<cfquery name="justMyKids" dbtype="query">
	select	*
	from	arguments.files
	where	directory = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rereplace(arguments.parent,"[\#osPathDelim#]$","")#">
	</cfquery>
	<cfif justMyKids.recordCount GT 0>
		<cfsavecontent variable="result">
			<cfoutput><ul class="level#depth#"></cfoutput>
			<cfoutput query="justMyKids">
				<cfset loc.i = 0 />
				<cfloop list="#arguments.basePath#" index="loc.basePath">
					<cfset loc.i++ />
					<cfset loc.basePath = rereplace(loc.basePath,"[\#osPathDelim#]$","") />
					<cfif find(loc.basePath, directory)>
						<cfif listLen(arguments.replacePathWith) GTE loc.i>
							<cfset loc.replacePathWith = listGetAt(arguments.replacePathWith, loc.i) />
						<cfelse>
							<cfset loc.replacePathWith = arguments.replacePathWith />
						</cfif>
 
						<cfset loc.folder = replace(directory, loc.basePath, rereplace(loc.replacePathWith,"[\#osPathDelim#]$","")) />
						<cfbreak />
					<cfelse>
						<cfset loc.folder = directory />
					</cfif>
				</cfloop>
				<li class="#lCase(type)#<cfif currentRow EQ 1> first<cfelseif currentRow EQ justMyKids.recordCount> last</cfif>">
					<a href="#listChangeDelims(loc.folder, arguments.webPathDelim, arguments.osPathDelim)##arguments.webPathDelim#<cfif type IS "file">&file=</cfif>#name#">
						#name#
					</a>
				<cfif type is "Dir">
					#displayDirectoryTree(arguments.files, directory & arguments.osPathDelim & name, arguments.replacePathWith, arguments.osPathDelim, arguments.webPathDelim, arguments.depth+1, arguments.basePath)#
				</cfif>
				</li>
			</cfoutput>
			<cfoutput></ul></cfoutput>
		</cfsavecontent>
	</cfif>

	<cfreturn result />
</cffunction>
