<cfcomponent>
	<cfset this.name = "comiEditor" />
	<cfset this.sessionManagement = "true" />
	<cfset this.sessionTimeout=CreateTimeSpan(0,7,0,0) />
	<cfset this.clientStorage = "cookie" />
	<cfset this.scriptProtect = "none" />

	<cffunction name="onrequest">
		<cfargument name="targetPage" />

		<cfparam name="FORM.userName" default="" />
		<cfparam name="FORM.password" default="" />
		<cfparam name="SESSION.comiEditor.isAuthenticated" default="false" />
	
		<cfif isDefined("URL.logout")>
			<cfset SESSION.comiEditor.isAuthenticated = false />
			<cflocation url="index.cfm" addtoken="false" />
		</cfif>

		<cfinclude template="inc/config/settings.cfm" />
		<cfinclude template="inc/utilities/format.cfm" />

		<!--- already authenticated, load the requested page --->
		<cfif SESSION.comiEditor.isAuthenticated>
			<cfinclude template="#targetPage#" />
		<!--- attempting authentication --->
		<cfelseif FORM.username NEQ "" AND FORM.password NEQ "">
			<!--- hash the password --->
			<cfset loginCredentials = { username = FORM.username, passwordHash = hash(FORM.password, "SHA-512") } />
			<!--- loop through the valid users until there is a match on username --->
			<cfloop array="#comiEditor.authedUsers#" index="user">
				<cfif user.username EQ loginCredentials.username>
					<!--- if password matches, let them in --->
					<cfif user.passwordHash EQ loginCredentials.passwordHash>
						<cfset SESSION.comiEditor.isAuthenticated = true />
						<cfset SESSION.comiEditor.username = FORM.username/>
						<cfset SESSION.comiEditor.homeFolder = user.defaultFolder />
						<cflocation url="#CGI.script_name#?login=success#CGI.query_string##findNoCase("folder", CGI.query_string) GT 0 ? "" : "&folder="&SESSION.comiEditor.homeFolder#" addtoken="false" />
					</cfif>
				</cfif>
			</cfloop>
			
			<!--- no match, send them back to the form --->
			<cflocation url="#CGI.script_name#?#CGI.query_string#" addtoken="false" />
		<!--- not logged in, show the login form --->
		<cfelse>
			<cfinclude template="inc/views/editor/login.cfm" />
		</cfif>
	</cffunction>
</cfcomponent>
