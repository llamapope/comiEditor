<div class="navigator">
<cfinclude template="inc/views/navigator.cfm" />
</div>

<div class="editor">
<cfinclude template="inc/views/editor.cfm" />
</div>

<cftry>
<script src="navigator.js"></script>
<cfinclude template="inc/views/navigator.2.cfm" />
<cfcatch>
<cfdump var="#cfcatch#" />
</cfcatch>
</cftry>
