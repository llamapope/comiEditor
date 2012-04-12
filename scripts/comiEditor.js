(function($){
    var filePathArray = [];
    
	$(function() {
		// load each panel of the editor
		$(":not([id*=-])").each(function(){
			$.loadView("[id^=" + this.id + "-]");
		});

		// set up the navigator event handlers

		// navigator click handler
		$("[id$=-navigator]").delegate("li", "click", function(){
            // variable to store the path into
            var path = "";
            
			// directory action
			if($(this).hasClass("dir")) {
				// if there are no children, see if there should be any from the server
				if(!$(this).children("ul").length) {
					path = "";

					// store this node's contribution to the path
					path += "/" + $(this).text();

					// construct the path by concatenating all parent directory nodes' path attributes
					$(this).parents("li").each(function(){
						path = "/" + $(this).attr("params").replace(/^.*path=([^&]+)$/, "$1") + path;
					});

					// set the path paramater and add the folder icon
					$(this).attr("params", "path="+path).children(".ui-icon").toggleClass("ui-icon-folder-collapsed ui-icon-folder-open");

					// set the status indicator to loading
					$(this).children(".status").addClass("loading");

					// fire off the ajax request to load the children of this node
					$.loadView(this);

					// reset params to just this node's contribution (current folder name)
					$(this).attr("params", $(this).text());
				} else {
					// just open the collapsed folder structure
					$(this).children(".ui-icon").toggleClass("ui-icon-folder-collapsed ui-icon-folder-open").siblings("ul").toggle();
					// TODO: refresh folder! Don't want it to collapse or lose any children nodes though...
				}
			// file action
			} else if($(this).hasClass("file")) {
				path = "/";

				$(this).parents(".dir").each(function(){
					path = "/" + $(">span", this).text() + path;
				});

				var filePath = path + $(">span", this).text();				

				$("#comiEditor-editor").attr("params", "file=" + filePath);
				$("#comiEditor-editor").empty();
				$.loadView("#comiEditor-editor");

				window.location.hash = "file=" + filePath;
			}

			// only one file/folder should ever be selected (unless control or shift is used...)
			// TODO: add shift and control support 
			$(".selected").removeClass("selected");

			// select the current item
			$(this).addClass("selected");
		});
        
        if(window.location.hash) {
            var fileName = window.location.hash.replace(/#.*file=\/?([^&]+).*/, '$1');
            filePathArray = fileName.split('/');
        }
	});

	// cancel text selection on any element that has the unslectable attribute on any of it's parents
	document.onselectstart = function (e) {
		if ($(e.srcElement).parents("[unselectable]").length) {
			return false;
		}
	};

	// comiEditor loadView function
	$.loadView = function(selector) {
		$(selector).each(function(){
			var viewName = getViewName(this);

			if(viewName) {
				$.ajax({ url: "/ce/inc/comiEditor.cfc?method=load&returnformat=plain&view="+viewName,
					data: $(this).attr("params"),
					context: this,
					success: function(data){
						t = $(data);
						t.find(".dir").prepend($("<div></div>").addClass("ui-icon ui-icon-folder-collapsed"));
						t.find(".file").prepend($("<div></div>").addClass("ui-icon ui-icon-document"));
						t.find("li").prepend($("<div></div>").addClass("status"));

						$(this).append(t);

						if(t.is("#editor")) {
							var editor = ace.edit("editor");
							editor.setTheme("ace/theme/textmate");

							var saveParams = $(this).attr("params");

							var fileExtension = saveParams.replace(/.*\.([^\.]+)$/, '$1');
							var EditorMode = false;

							if(fileExtension == 'html' || fileExtension == 'cfm' || fileExtension == 'cfc') { 
								EditorMode = require("ace/mode/html").Mode;
							} else if(fileExtension == 'css') {
								EditorMode = require("ace/mode/css").Mode;
							} else if(fileExtension == 'js') {
								EditorMode = require("ace/mode/javascript").Mode;
							}

							if(EditorMode) {
								editor.getSession().setMode(new EditorMode());
							}

							editor.focus();

							var canon = require('pilot/canon');

							canon.addCommand({
								name: 'comiEditorSave',
								bindKey: {
									win: 'Ctrl-S',
									mac: 'Command-S',
									sender: 'editor'
								},
								exec: function(env, args, request) {
									var comiEditorSession = editor.getSession();
                                    
                                    var now = new Date(); 
                                    var then = "<time>" + now.getFullYear()+'-'+pad(now.getMonth()+1)+'-'+pad(now.getDay()) + 
                                        ' '+pad(now.getHours())+':'+pad(now.getMinutes())+":"+pad(now.getSeconds()) + "</time>"; 
                                    
                                    $("[id$=-console]").append($("<li/>").html(then + ' saving file <a href="#' + saveParams + '">' + saveParams.replace("file=", "") + "</a>"));
                                    $("[id$=-console] li:last").attr("tabindex", "-1").focus();
                                    

									$.ajax({
										type: "post",
										data: {
											fileContents: comiEditorSession.getValue()
										},
										url: "/ce/inc/comiEditor.cfc?method=save&returnformat=plain&"+saveParams,
										success: function(jqXHR, textStatus){
											//$(".message").removeClass("pending").addClass("success").html($("input[name=fileName]").val() + " saved.").animate({opacity:0}, 5000);
                                           var timeDiff = new Date().getTime() - now.getTime();
                                           
                                            if(timeDiff < 1000) {
                                                timeDiff += "ms";
                                            } else {
                                                timeDiff = timeDiff / 1000 + "s";
                                            }
                                           
											$("[id$=-console] li:last").append(" save complete <time>" + timeDiff + "</time>").focus();
                                            editor.focus();
										},
										error: function(jqXHR, textStatus, errorThrown){
											//$(".message").removeClass("pending").addClass("error").html("Save failed!").animate({opacity:0}, 10000);
											$("[id$=-console] li:last").append(" save failed - [" + errorThrown + "]").focus();
                                            editor.focus();
										}
									});
								}
							});
						}
						else {
							t.attr("unselectable", "on").css({MozUserSelect:"none",webkitUserSelect:"none"});
                            
                            // if there is anything in the filePathArray still, and the parent element is the navigator panel, then open the current node in the filePathArray
                            if(filePathArray.length && t.closest("[id$=-navigator]").length) {
                                var firstNode = filePathArray.shift();
                                $("li span:contains("+ firstNode +")", this).each(function(){
                                    if($(this).text() == firstNode) {
                                        $(this).click();
                                    }
                                });
                            }
						}

						if(!$(this).parents().hasClass("panel")) {
							$(this).wrap($("<div></div>").addClass("panel"));
							$(this).parent(".panel").resizable({ handles: 'e' });
						}
						
						$(this).children(".status.loading").removeClass("loading");
					}
				});
			}
		});
	};

	// function to retrieve a view by it's name, uses last part of the ID (after the '-' character)
	function getViewName(element) {
		var viewName = $(element).attr("view");
		if(!viewName && element.id) {
			viewName = element.id;
		} else {
			viewName = $(element).closest("[id*=-]").attr("id");
		}
		return viewName.replace(/.*-/, "");
	}
    
    function pad(string, padString, minLength) {
        padString = padString | 0;
        minLength = minLength | -2;
        string += '';
        return (minLength > 0 ? string : '') + Array(1 + Math.abs(minLength) - Math.min(string.length, Math.abs(minLength))).join(padString) + (minLength < 0 ? string : '');
    }
})(jQuery);
