<cfcomponent>
	<!--- no cfml files in this folder should be directly accessible --->
	<cffunction name="onRequest">
		<cfhtmlhead statuscode="404" statustext="Not Found" />
	</cffunction>
</cfcomponent>
