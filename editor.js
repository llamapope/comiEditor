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
		$("form").submit(function() {
			$(".prompt", $(this)).attr("value", "").removeClass("prompt");
			return true;
		});
		$("form textarea[name=fileContent]").focus();

	$("html,textarea").keydown(function(e){
		var selectionStart = this.selectionStart;
		var selectionEnd = this.selectionEnd;
		var scrollTop = this.scrollTop;
		var bubbleEvent = true;
		var newString = "";

		if(this.tagName.toLowerCase()=="textarea") {
			// tab
			if(e.keyCode == 9) {
				if(selectionStart == selectionEnd) {
					newString = this.value.split("");

					if(e.shiftKey && newString[selectionStart-1].search(/( |\t)/) == 0) {
						newString.splice(selectionStart-1,1);
						this.value = newString.join("");
						this.setSelectionRange(selectionStart-1, selectionEnd-1);
						this.scrollTop = scrollTop;
					} else if(!e.shiftKey) {
						newString.splice(selectionStart,0,"\t");
						this.value = newString.join("");
						this.setSelectionRange(selectionStart+1, selectionEnd+1);
						this.scrollTop = scrollTop;
					}
				}
				bubbleEvent = false;
			}// tab

			// ctrl
			else if(e.ctrlKey && e.shiftKey) {
				if(e.keyCode == 79) {
					newString = wrapText(this.value, "<cfoutput>", "</cfoutput>", selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart+10, selectionEnd+10);

					bubbleEvent = false;
				}// Ctrl + Shift + O = <cfoutput>...</cfoutput>
				else if(e.keyCode == 51) {
					newString = wrapText(this.value, "#", "#", selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart+1, selectionEnd+1);

					bubbleEvent = false;
				}// Ctrl + Shift + 3 = #...#
				
			}// ctrl + shift
			else if(e.ctrlKey) {
				if(e.keyCode == 51) {
					newString = wrapText(this.value, "#", "#", selectionStart, selectionEnd);
					this.value = newString;
					this.setSelectionRange(selectionStart+1, selectionEnd+1);

					bubbleEvent = false;
				}// Ctrl + 3 = #...#
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

function lineStart(text, position) {
	var tempString = text.slice(0, position).split("\n");
	var lastLine = tempString[tempString.length-1];
	var linePosition = position - lastLine.length;
	return linePosition;
}//lineStart()

function lineEnd(text, position) {
	var tempString = text.slice(position, text.length).split("\n");
	var firstLine = tempString[0];
	var linePosition = position + firstLine.length;
	return linePosition;
}//lineEnd()

window.onbeforeunload = function(){
	var returnString = false;
	$("texarea").each(function(){
		if(this.defaultValue && this.defaultValue != this.value) {
			returnString = "This file has unsaved content. Navigating away from this page will lose any unsaved data.";
		}
	});

	if(returnString) {
		return returnString;
	}
};

})(jQuery);
