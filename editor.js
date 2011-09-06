;(function($){
	$(function(){
		$("form").each(function(){
			this.reset();
		});

		$("label").each(function(){
			var labelHelper = $(this).children("span");
			$(this).attr("text", labelHelper.text());
			labelHelper.css({right: "25px", position: "absolute", color: "#ddd", lineHeight: "1.6em" });
			labelHelper.click(function(){
			$(this).siblings("input:text, textarea").select();
			});
		});
		$("input:text, textarea").each(function(){
			if($(this).attr("value") == "") {
				$(this).addClass("prompt").attr("value", $(this).parent("label").attr("text"));
			}
		});

		$("input:text, textarea").focus(function(){
			if($(this).hasClass("prompt")) {
				$(this).removeClass("prompt").attr("value", "");
			}
		});
		$("input:text, textarea").blur(function(){
			if($(this).attr("value") == "") {
				$(this).addClass("prompt").attr("value", $(this).parent("label").attr("text"));
			}
		});
		$("form:not(:has([input=file]))").submit(function() {
			$(".prompt", $(this)).attr("value", "").removeClass("prompt");

			$(".message").stop().hide().css({opacity: 1}).attr("class", "message").addClass("pending").html("saving " + $("input[name=fileName]").val() + " ...").show();

			$.ajax({
				type: "post",
				data: {
					fileName: $("input[name=fileName]").val(),
					dir: $("input[name=dir]").val(),
					fileContent: $("textarea[name=fileContent]").val(),
					originalFile: $("input[name=originalFile]").val(),
					folder: $("input[name=folder]").val(),
					returnFormat: "json"
				},
				url: window.location.href,
				success: function(){
					if($("input[name=dir]").val()) {
						window.location = window.location.href.replace(/\/$/, "") + "/" + $("input[name=dir]").val();
					} else {
						$(".message").removeClass("pending").addClass("success").html($("input[name=fileName]").val() + " saved.").animate({opacity:0}, 5000);
					}
				},
				error: function(){
					$(".message").removeClass("pending").addClass("error").html("Save failed!").animate({opacity:0}, 10000);
				}
			});

			return false;
		});
		$("form textarea[name=fileContent]").focus();

	$("html,textarea").keydown(function(e){
		var selectionStart = this.selectionStart;
		var selectionEnd = this.selectionEnd;
		var scrollTop = this.scrollTop;
		var bubbleEvent = true;
		var newString = "";
		var prefix = "";
		var suffix = "";

		if(this.tagName.toLowerCase()=="textarea") {
			// tab
			if(e.keyCode == 9) {
				var tab = "\t";
				if(selectionStart == selectionEnd) {
					newString = this.value.split("");

					if(e.shiftKey && newString[selectionStart-1].search(/(\s)/) == 0) {
						newString.splice(selectionStart-1,1);
						this.value = newString.join("");
						this.setSelectionRange(selectionStart-1, selectionEnd-1);
					} else if(!e.shiftKey) {
						newString.splice(selectionStart,0,tab);
						this.value = newString.join("");
						this.setSelectionRange(selectionStart+1, selectionEnd+1);
					}
				// multiline selection
				} else {
					var regEx = /\n/g;
					var replaceText = "\n"+tab;
					var indentedText = "";
					var prefix = "";

					// outdent
					if(e.shiftKey) {
						regEx = /^[ |\t]/mg;
						replaceText = "";
						console.log(regEx);
						selectionStart = lineStart(this.value, lineEnd(this.value,selectionStart));
					// indent
					} else {
						selectionStart = lineStart(this.value, lineEnd(this.value,selectionStart), true);
						prefix = tab;
					}
					
					indentedText = prefix+this.value.slice(selectionStart,selectionEnd).replace(regEx,replaceText);
					
					this.value = this.value.slice(0,selectionStart)+indentedText+this.value.slice(selectionEnd,this.value.length);
					selectionEnd = lineEnd(this.value, selectionStart + indentedText.length);
					selectionStart += prefix.length;
					this.setSelectionRange(selectionStart, selectionEnd);
				}
				bubbleEvent = false;
			}// tab
			// End
			else if(e.keyCode == 35) {
				if(e.ctrlKey) {
					selectionEnd = this.value.length;
				} else {
					selectionEnd = lineEnd(this.value, selectionEnd, true);
				}
				
				if(!e.shiftKey) {
					selectionStart = selectionEnd;
				}
				this.setSelectionRange(selectionStart, selectionEnd);

				bubbleEvent = false;
			} // end
			// home
			else if(e.keyCode == 36) {
				if(e.ctrlKey) {
					selectionStart = 0;
				} else {
					selectionStart = lineStart(this.value, selectionStart, true);
				}
				if(!e.shiftKey) {
					selectionEnd = selectionStart;
				}
				this.setSelectionRange(selectionStart, selectionEnd);

				bubbleEvent = false;
			} // Home

			// ctrl + shift
			else if(e.ctrlKey && e.shiftKey) {
				if(e.keyCode == 68) {
					prefix = '<cfdump var="#';
					suffix = '#" />';

					newString = wrapText(this.value, prefix, suffix, selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart+prefix.length, selectionEnd+prefix.length);

					bubbleEvent = false;
				}// Ctrl + Shift + D = <cfdump var="#...#" />
				else if(e.keyCode == 79) {
					newString = wrapText(this.value, "<cfoutput>", "</cfoutput>", selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart+10, selectionEnd+10);

					bubbleEvent = false;
				}// Ctrl + Shift + O = <cfoutput>...</cfoutput>
				else if(e.keyCode == 51) {
					newString = wrapText(this.value, "#", "#", selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart, selectionEnd+2);

					bubbleEvent = false;
				}// Ctrl + Shift + 3 = #...#
				else if(e.keyCode == 222) {
					newString = wrapText(this.value, '"', '"', selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart, selectionEnd+2);

					bubbleEvent = false;
				}// Ctrl + Shift + " = "..."
				
			}// ctrl + shift

			// ctrl
			else if(e.ctrlKey) {
				// 3
				if(e.keyCode == 51) {
					newString = wrapText(this.value, "#", "#", selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart+1, selectionEnd+1);

					bubbleEvent = false;
				}// Ctrl + 3 = #...#
				// '
				else if(e.keyCode == 222) {
					newString = wrapText(this.value, "'", "'", selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart, selectionEnd+2);

					bubbleEvent = false;
				}// Ctrl + ' = '...'
				// [
				else if(e.keyCode == 219) {
					newString = wrapText(this.value, "[", "]", selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart, selectionEnd+2);

					bubbleEvent = false;
				}// Ctrl + [ = [...]
				// (
				else if(e.keyCode == 57) {
					newString = wrapText(this.value, "(", ")", selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart, selectionEnd+2);

					bubbleEvent = false;
				}// Ctrl + ( = (...)
				// D
				else if(e.keyCode == 68) {
					selectionStart = lineStart(this.value, selectionStart);
					selectionEnd = lineEnd(this.value, selectionEnd);

					newString = removeText(this.value, selectionStart-1, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart, selectionStart);

					bubbleEvent = false;
				}// Ctrl + D = Delete selected line(s)
			}//ctrl

		}// textarea
		else if(this.tagName.toLowerCase() == "html") {
			if(e.ctrlKey) {
				if(e.keyCode == 83) {
					$("form").submit();
					bubbleEvent = false;
				}// S + ctrl = save

				else if(e.keyCode == 81) {
					$("form").children("input:submit[name=cancel]").click();
					bubbleEvent = false;
				}// Q + ctrl = close
			}// ctrlKey
		}// body

		if(!bubbleEvent) {
			this.scrollTop = scrollTop;
		}

		return bubbleEvent;
	});//keydown()
});//onload()

function wrapText(text, startString, endString, startPosition, endPosition) {
	var result = insertText(text, endString, endPosition);
	result = insertText(result, startString, startPosition);

	return result;
}//wrapText()

function insertText(text, subString, position) {
	var result = text.split("");
	result.splice(position, 0, subString);
	result = result.join("");

	return result;
}//insertText()

function removeText(text, startPosition, endPosition) {
	var result = text.split("");
	result.splice(startPosition, endPosition-startPosition, "");
	result = result.join("");

	return result;
}//insertText()

function lineStart(text, position, smartHome) {
	var tempString = text.slice(0, position).split("\n");
	var lastLine = tempString[tempString.length-1];
	var linePosition = position - lastLine.length;
	var offset = 0;

	if(smartHome) {
		offset = lastLine.length - lastLine.replace(/^\s+/,"").length;

		if(linePosition + offset != position) {
			linePosition += offset;
		} else if(offset == 0) {
			linePosition = lineStart(text, lineEnd(text, linePosition, true), true);
		}
	}

	return linePosition;
}//lineStart()

function lineEnd(text, position, smartEnd) {
	var tempString = text.slice(position, text.length).split("\n");
	var firstLine = tempString[0];
	var linePosition = position + firstLine.length;

	if(smartEnd) {
		offset = firstLine.replace(/\s+$/,"").length - firstLine.length;
	
		if(linePosition + offset != position) {
			linePosition += offset;
		} else if(offset == 0) {
			linePosition = lineEnd(text, lineStart(text, linePosition, true), true);
		}
	}
	return linePosition;
}//lineEnd()

window.onbeforeunload = function(){
	var returnString = false;
	$("texarea").each(function(){
		if(this.defaultValue && this.defaultValue != this.value) {
			returnString = "This file has unsaved content. Navigating away from this page will lose any unsaved data.";		
		}
		alert(this);
	});

	if(returnString) {
		return returnString;
	}
};

})(jQuery);

