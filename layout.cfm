<!DOCTYPE html>
<html>
<head>
<title></title>

<link href="styles/vader/jquery-ui.css" rel="stylesheet" />
<link href="styles/comiEditor.css" rel="stylesheet" />
<link href="styles/editor.css" rel="stylesheet" />

<script src="scripts/jquery.js"></script>
<script src="scripts/jquery-ui.js"></script>

<script>
(function($){
	$(function(){
		$(".editor").tabs();
		$(".cmd a").button();
	});
})(jQuery);
</script>

<script src="editor.js"></script>
<script src="navigator.js"></script>

</head>

<body>

<div class="ui-widget" style="position:fixed;top:36px;left:0;right:0;bottom:0;">
	<div class="ui-widget-header">
		<div class="navigator">
			<cfinclude template="inc/views/navigator.cfm" />
		</div>	
	</div>
	<div class="editor" style="height: 100%">
		<ul>
			<li><a href="trainingwheels.cfm?folder=comiEditor&file=index.cfm">index.cfm</a></li>
			<li><a href="trainingwheels.cfm?folder=comiEditor/inc/config&file=users.js.cfm">users.js.cfm</a></li>
			<li><a href="trainingwheels.cfm?folder=/../redrover/views/movies&file=list.cfm">list.cfm</a></li>
			<li><a href="trainingwheels.cfm?folder=doesntexist/&file=die.cfm">die.cfm</a></li>
		</ul>
	</div>

</div>

</body>
</html>
