<cfset showAll = true />

<ul class="dictionaries">
<cfif find(URL.folder, "db/migrate") OR showAll>
<li>
<a href="#dbMigrate">dbMigrate</a>
<div class="details">
	<cfinclude template="wheels.dbmigrate.cfm" />
</div>
</li>
</cfif>
<cfif find(URL.folder, "views") OR showAll>
<li>
<a href="#viewHelpers">View Helpers</a>
<div class="details">
	<cfinclude template="wheels.viewHelpers.cfm" />
</div>
</li>
</cfif>
</ul>
