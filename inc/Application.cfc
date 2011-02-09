<cfcomponent>
	<cfset this.name = "comiEditor">
	<cfset this.sessionManagement = "true" />
	<cfset this.sessionTimeout=CreateTimeSpan(0,7,0,0) />
	<cfset this.clientStorage = "cookie" />

	<cfsetting enablecfoutputonly="true">

	<!--- no cfml files in this folder should be directly accessible --->
	<cffunction name="onRequest">
		<cfargument name="targetPage">
		<cfif arguments.targetPage EQ "/comiEditor/inc/comiEditor.cfc">
			<cfoutput><cfinclude template="#arguments.targetPage#"></cfoutput>
		</cfif>
	</cffunction>
</cfcomponent>
