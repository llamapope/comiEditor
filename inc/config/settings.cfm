<cffunction name="jsonSettings">
		<cfargument name="params">
		<cfargument name="fileName" default="users.js.cfm">
		
		<cfset var loc = {
			fileName = arguments.fileName,
			returnValue = ""
		}>

		<cfif NOT FileExists(loc.fileName)>
			<cfif NOT FileExists("#ExpandPath('./')##loc.fileName#")>
				<cfif NOT FileExists("#ExpandPath('./')#/comiEditor/inc/config/#loc.fileName#")>
					<cfset loc.fileName = "">
				<cfelse>
					<cfset loc.fileName = "#ExpandPath('./')#comiEditor/inc/config/#loc.fileName#">
				</cfif>
			<cfelse>
				<cfset loc.fileName = "#ExpandPath('./')##loc.fileName#">
			</cfif>
		</cfif>
		
		<cfif isDefined("arguments.params.newUsers")>
			<cfset newRoutes = {}>
			<cfloop list="#params.newUsers#" index="newUser">
				<cfset newUsers[newUser] = params[newUser]>
			</cfloop>
			<cfset newUsers = serializeJson(newUsers)>
			<cffile action="write" output="#newUsers#" file="#loc.fileName#">
			
			<cfset application.wheels.appLocations = jsonSettings() />
			<cfset session.flash.routesSet="Application Routes were set successfully.">
			<cflocation url="?" addtoken="false">
		</cfif>
	
		<cffile action="read" file="#loc.fileName#" variable="loc.settingsFile">

		<cfset loc.settingsJson = trim(loc.settingsFile)>
		<cfset loc.returnValue = DeserializeJson(loc.settingsJson)>

		<cfreturn loc.returnValue>
	</cffunction>

<cfset comiEditor.authedUsers = jsonSettings() />