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
		<cfparam name="SESSION.isAuthenticated" default="false" />
	
		<cfif NOT isNull(URL.logout)>
			<cfset SESSION.isAuthenticated = false />
			<cflocation url="index.cfm" addtoken="false" />
		</cfif>

		<cfinclude template="inc/config/settings.cfm" />

		<cfif SESSION.isAuthenticated>
			<cfinclude template="#targetPage#" />
		<cfelseif FORM.username NEQ "" AND FORM.password NEQ "">
		
			<cfset loginCredentials = { username = FORM.username, passwordHash = hash(FORM.password, "SHA-512") } />

			<cfif arrayFind(authedUsers, loginCredentials)>
				<cfset SESSION.isAuthenticated = true />
				<cfset SESSION.username = FORM.username/>
				<cfset SESSION.homeFolder = defaultFolders[loginCredentials.username]/>
				<cflocation url="#CGI.script_name#?login=success#CGI.query_string##findNoCase("folder", CGI.query_string) GT 0 ? "" : "&folder="&SESSION.homeFolder#" addtoken="false" />
			<cfelse>
				<cflocation url="#CGI.script_name#?#CGI.query_string#" addtoken="false" />
			</cfif>
		<cfelse>
			<cfoutput>
				<form action="?#CGI.QUERY_STRING#" method="post">
				    <label>
						Username
				       	<input type="text" name="username" value="#FORM.username#" />
					</label>
					<label>
						Password
				        <input type="password" name="password" value="#FORM.password#" />
				    </label>
				    <input type="submit" value="Let me in!" />
			    </form>
			</cfoutput>
		</cfif>
	</cffunction>
</cfcomponent>
