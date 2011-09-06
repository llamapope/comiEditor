<cfparam name="URL.file" default="">
<cfif URL.file NEQ "">
	<cffile file="#expandPath(URL.file)#" variable="f" action="read"/>
<cfelse>
	<cfset f = "">
</cfif>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="/ce/scripts/jquery-mousewheel.min.js"></script>

<script>
	var file = { contents: <cfoutput>#serializeJSON(f)#</cfoutput> };
	file.lines = file.contents.split("\n");
</script>

<canvas></canvas>

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
			var row = Math.floor((e.pageY + scrollPosition.y - $(canvas).offset().top) / lineHeight);
			var col = Math.round((e.pageX - lineMarginWidth - marginLeft * 2 + scrollPosition.x - $(canvas).offset().left) / letterWidth);

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
				
				var renderPosition = { x: lineMarginWidth + marginLeft * 2 - scrollPosition.x,
				                       y: row * lineHeight + 1/2 * lineHeight - scrollPosition.y };
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
