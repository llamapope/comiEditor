<!DOCTYPE html>
<html>
<head>
<title>CodeHalf</title>
</head>
<body>
<cfoutput>

<script src="#editor.scripts#/ace/ace.js" type="text/javascript" charset="utf-8"></script>
<script src="#editor.scripts#/ace/theme-textmate.js" type="text/javascript" charset="utf-8"></script>
<script src="#editor.scripts#/ace/mode-html.js" type="text/javascript" charset="utf-8"></script>

<script src="#editor.scripts#/jquery.js" type="text/javascript"></script>
<script src="#editor.scripts#/jquery-ui.js" type="text/javascript"></script>
<script src="#editor.scripts#/jquery-contextmenu.js" type="text/javascript"></script>
<script src="#editor.scripts#/comiEditor.js" type="text/javascript"></script>
<script src="#editor.userFolder#/#editor.userScripts#/config.js" type="text/javascript"></script>
<style>
@import url("#editor.stylesheets#/style.css");
@import url("#editor.stylesheets#/#editor.theme#/jquery-ui.css");
@import url("#editor.userFolder#/css/style.css");
@import url("#editor.userFolder#/css/#editor.theme#/style.css");
</style>
</cfoutput>
<div id="comiEditor">
	<div id="comiEditor-mainMenu">Main Menu</div>
    <div id="comiEditor-userMenu"><a href="/ce/index_old.cfm?logout">Logout</a></div>
	<div id="comiEditor-navigator"></div>
	<div id="comiEditor-tasks">tasks</div>
	<div id="comiEditor-shortcuts">shortcuts</div>
	<div id="comiEditor-snipets">snipets</div>
	<div id="comiEditor-dictionary">dictionary</div>
	<div id="comiEditor-editor"></div>
	<div id="comiEditor-console"></div>
</div>

<cfoutput><script src="#editor.scripts#/ide.js"></script></cfoutput>
<script>
;(function($){
	$(function(){
		$("#comiEditor").ide();
	});
})(jQuery);

</script>

</body>
</html>
