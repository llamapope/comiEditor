<cffunction name="wikiFormat">
	<cfargument name="text" required="true" />
	<cfargument name="lineFormat" default="unix" />
	<cfset var loc={endl=chr(10), text=arguments.text} />

	<cfif lineFormat IS "unix">
		<cfset loc.endl = chr(10) />
		<cfset loc.text = replace(loc.text, chr(13)&chr(10), chr(10), "all") />
	</cfif>

	<!--- strip HTML elements that will cause issues --->
	<cfset loc.text=replace(loc.text,">","&gt;","all")>
	<cfset loc.text=replace(loc.text,"<","&lt;","all")>

	<cfset loc.text=rereplace(loc.text,"\*\*([^\*\*]+)\*\*","<strong>\1</strong>","all")>
	<cfset loc.text=rereplace(loc.text,"//([^//]+)//","<em>\1</em>","all")>
	<cfset loc.text=rereplace(loc.text,"__([^__]+)__",'<u>\1</u>',"all")>
	<cfset loc.text=rereplace(loc.text,"--([^--]+)--",'<s>\1</s>',"all")>
	<cfset loc.text=rereplace(loc.text,"{{([^}}]+)}}",'<tt>\1</tt>',"all")>
	<cfset loc.text=rereplace(loc.text,"\^\^([^\^\^]+)\^\^",'<sup>\1</sup>',"all")>
	<cfset loc.text=rereplace(loc.text,",,([^,,]+),,",'<sub>\1</sub>',"all")>
	<cfset loc.text=rereplace(loc.text,"!!([^!!]+)!!",'<big>\1</big>',"all")>
	<cfset loc.text=rereplace(loc.text,";;([^;;]+);;",'<small>\1</small>',"all")>
	<cfset loc.text=rereplace(loc.text,"\[\[([^\]]+)/]]",'<div>attr:\1</div>',"all")>
	<cfset loc.text=rereplace(loc.text," \* ",'\1<li>',"all")>	
		
	<cfset html="">
	<cfset loc.text=rereplacenocase(loc.text,"(?m)([\S]+)[\r\n][\r\n]([\S]+)[\r\n]$","\1<br />\2","all")>
	<cfloop list="#loc.text#" delimiters="#loc.endl#" index="i">
		<!--- headers --->
		<cfif refind("^(\+{1,6})",i)>
			<cfset headerSize=rereplace(i,"^(\+{1,6})(.+)","\1")>
			<cfset headersize=len(headersize)>
			<cfset i=rereplace(i,"^(\+{1,6}[\s?]+)(.+)","<h#headersize#>\2</h#headersize#>","all")>
			<cfset html&=i>
		<!--- div start tag --->
		<cfelseif refind("^\[\[([##\.]?)(([a-zA-Z]+)([\d_-]+)?(\s)?)+",i)>
			<cfset html&="<div">
			<cfif refind("^\[\[(##)(([a-zA-Z]+)([\d_-]+)?)+",i)>
				<cfset html&=rereplace(i,"^\[\[(##)(([a-zA-Z]+)([\d_-]+)?)+.+"," id='\3'","all")>
			</cfif>
			<cfif refind("(([\.\s])?([a-zA-Z]+)([\d_-]+)?)+",i)>
				<cfset html&=" class='">
				<cfset html&=rereplace(i,"(^\[\[##\w+\s)?(([a-zA-Z]+)([\d_-]+)?(\s)?)","\3\5","all")>
				<cfset html&="'">
			</cfif>
			<cfset html&=">">
		<!--- everything else - paragraphs --->
		<cfelseif NOT refind("^([\s]+)?<([^>])+>",i)>
			<cfset html&="<p>#i#</p>">
		<cfelse>
			<cfset html&="#i#">
		</cfif>
		<cfset html&="#loc.endl#">
	</cfloop>
	
	<cfreturn html>
</cffunction>
