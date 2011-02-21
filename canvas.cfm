<!DOCTYPE html>
<html>
<head>
	<title>comiEditor</title>
	<cfif reFindNoCase("android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0>
	<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
	</cfif>
	<style>
		html { height: 100%; }
		body { height: 100%; margin: 0; padding: 0; }
		canvas { display: block; color:  #0f0; font-size: 14px; font-family: monospace; cursor: text; overflow: scroll; }
	</style>

</head>
<body>

<cfparam name="URL.file" default="">
<cfif URL.file NEQ "">
	<cffile file="#expandPath(URL.file)#" variable="f" action="read"/>
<cfelse>
	<cfset f.contents = "">
</cfif>

<script>
	var file = { contents: <cfoutput>#serializeJSON(f)#</cfoutput> };
	file.lines = file.contents.split("\n");
</script>

<canvas></canvas>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="http://halffastsolutions.com/javascripts/jquery/jquery-mousewheel.min.js"></script>

<script>

;(function($) {
	$(function() {
		var canvas = $("canvas")[0];
		var context = canvas.getContext("2d");

		var cursorPosition = { row: 0, col: 0 };
		var scrollPosition = { x: 0, y: 0 };

		var moveLine = function(e, delta){
			scrollPosition.y += delta * -3 * lineHeight;

			if(scrollPosition.y < 0) {
				scrollPosition.y = 0;
			} else if(scrollPosition.y > file.lines.length * lineHeight - canvas.height) {
				scrollPosition.y = file.lines.length * lineHeight - canvas.height;
			}
			draw();
		};

		var keyHandler = function(e){

			if(e.keyCode == 38 && cursorPosition.row > 0) {
				cursorPosition.row -= 1;
			} else if(e.keyCode == 40 && cursorPosition.row < file.lines.length) {
				cursorPosition.row += 1;
			} else if(e.keyCode == 37 && cursorPosition.col > 0) {
				cursorPosition.col -= 1;
			} else if(e.keyCode == 39 && cursorPosition.col < file.lines[cursorPosition.row].length) {
				cursorPosition.col += 1;
			}

			draw();
		}

		$(canvas).mousewheel(moveLine);

		$(document).keypress(keyHandler);

		var fontSize = 14;
		var lineHeightFactor = 1.4;

		context.font = fontSize + "px monospace";

		var letterWidth = context.measureText("M").width;
		var lineHeight = fontSize * lineHeightFactor;

		var lineMarginWidth = 25;
		var marginLeft = 5;

		$(canvas).click(function(e){
			$(this).focus();
			var row = Math.floor((e.pageY + scrollPosition.y) / lineHeight);
			var col = Math.round((e.pageX - lineMarginWidth - marginLeft * 2 + scrollPosition.x) / letterWidth);

			cursorPosition.row = row;
			cursorPosition.col = col;

			draw();
		});

		// unused thus far
		function highlightLine(y) {
			var row = Math.floor((y) / lineHeight);

			context.fillStyle = "rgba(0, 100, 150, .2)";
			context.fillRect(0, (row - 1/2) * lineHeight, canvas.width, lineHeight);
		}
		
		function draw(e) {
			canvas.width = $(canvas).parent().innerWidth();
			canvas.height = $(canvas).parent().innerHeight();
			
			context.textBaseline = "middle";
			context.lineHeight = lineHeight;
			
			context.fillStyle = "#efe4d9";
			context.fillRect(0, 0, lineMarginWidth + marginLeft, canvas.height);

			context.strokeStyle = "#999";

			context.moveTo(lineMarginWidth + marginLeft + 0.5, 0);
			context.lineTo(lineMarginWidth + marginLeft + 0.5, canvas.height);

			context.stroke();

			for (var row = Math.floor(scrollPosition.y / lineHeight); row < file.lines.length && row * lineHeight < canvas.height + scrollPosition.y; row++) {
				context.textAlign = "right";
				context.fillStyle = "#999";
				
				context.font = fontSize * 7 / 10 + "px sans-serif";
				
				var renderPosition = { x: lineMarginWidth + marginLeft * 2 - scrollPosition.x + $(canvas).offset().right,
				                       y: row * lineHeight + 1/2 * lineHeight - scrollPosition.y + $(canvas).offset().left };
				
				context.fillText(row/1+1, lineMarginWidth, renderPosition.y);

				context.textAlign = "left";
				context.fillStyle = "#000";
				context.font = fontSize + "px monospace";

				context.save();

				context.beginPath();
				context.moveTo(lineMarginWidth + marginLeft, renderPosition.y - 1/2 * lineHeight);
				context.lineTo(canvas.width, renderPosition.y - 1/2 * lineHeight);
				context.lineTo(canvas.width, renderPosition.y + 1/2 * lineHeight);
				context.lineTo(lineMarginWidth + marginLeft, renderPosition.y + 1/2 * lineHeight);
	
				context.clip();

				var tabCount = 0;
				// tabSize is actually one less than the deisred amount of spaces, due to the existance of the tab character itself
				var tabSize = 4 - 1;

				for(var col = Math.floor(scrollPosition.x / letterWidth); col < file.lines[row].length && col * letterWidth < canvas.width + scrollPosition.x; col++) {
					if(file.lines[row][col] == "\t") {
						tabCount++;
					} else {
						context.fillText(file.lines[row][col], renderPosition.x + (col + tabCount * tabSize) * letterWidth, renderPosition.y);
					}

					if(cursorPosition.row == row && cursorPosition.col == col) {
						context.strokeStyle = "#222";

						context.beginPath();
						context.moveTo(renderPosition.x + (col) * letterWidth, renderPosition.y - 1/2 * lineHeight);
						context.lineTo(renderPosition.x + (col) * letterWidth, renderPosition.y + 1/2 * lineHeight);
	
						context.stroke();
					}
				}

				context.restore();
				
				if(cursorPosition.row == row) {
					context.fillStyle = "rgba(0, 100, 150, .1)";
					context.fillRect(0, renderPosition.y - 1/2 * lineHeight, canvas.width, lineHeight);
				}
			}
		}
		
		draw();

		$(window).resize(draw);
	
	});
})(jQuery);

</script>
</body>
</html>
