<cfset authedUsers = [
	{
		username = "demo"
		passwordHash = hash("ChAnGEMeORDiE", "SHA-512")
	}

] />

<cfset defaultFolders = {
	demo = "/"
} />
