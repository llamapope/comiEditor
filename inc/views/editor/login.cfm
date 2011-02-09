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