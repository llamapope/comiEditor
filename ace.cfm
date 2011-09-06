<cfsilent>
<cfif URL.file NEQ "">
	<cffile file="#expandPath(URL.file)#" variable="f" action="read"/>
<cfelse>
	<cfset f = "">
</cfif>
</cfsilent><pre id="editor" style="margin: 0; width:100%;height:100%"><cfoutput>#trim(htmlEditFormat(f))#</cfoutput></pre>
