(function($){
    var filePathArray = [];
    
    $(function() {
    	// load each panel of the editor
		$(":not([id*=-])").each(function(){
			$.loadView("[id^=" + this.id + "-]");
		});
        
        $("body").on("submit", ".contextForm", function(){
            var now = new Date(); 
            var then = "<time>" + now.getFullYear()+'-'+pad(now.getMonth()+1)+'-'+pad(now.getDay()) + 
                ' '+pad(now.getHours())+':'+pad(now.getMinutes())+":"+pad(now.getSeconds()) + "</time>"; 
            
            var tagretName = "";
            var actionType = "";
            var actionVerb = "";
            
            if($(this).hasClass("new")) {
                actionVerb = "creating";
            } else if($(this).hasClass("rename")) {
                actionVerb = "renaming";
            } else {
            }
            console.log(this);
            
            if($(this).hasClass("file")) {
                targetName = $("[name=fileName]", this).val();
                actionType = "file";
            } else if($(this).hasClass("folder")) {
                targetName = $("[name=folderName]", this).val();
                actionType = "folder";
            }
            
            var filePath = "";
            
            if(actionVerb === "renaming") {
                filePath = $("[name=folder]", this).val() + " -> " + targetName;
            } else {
                filePath = $("[name=folder]", this).val() + "/" + targetName;
            }
            
            
            
            $("[id$=-console]").append($("<li/>").html(then + ' ' + actionVerb + ' ' + actionType + ' <a href="#file=' + filePath + '">' + filePath + '</a>... '));
            $("[id$=-console] li:last").attr("tabindex", "-1").focus();
            
            
            
            $.ajax({
                url: $(this).prop("action"),
                method: 'POST',
                data: $(this).serialize(),
                success: function(data) {
                    var timeDiff = new Date().getTime() - now.getTime();
                    var editor = ace.edit("editor");
                    
                    if(timeDiff < 1000) {
                        timeDiff += "ms";
                    } else {
                        timeDiff = timeDiff / 1000 + "s";
                    }
                   
                    $("[id$=-console] li:last").append(" " + $(data).text() + " <time>" + timeDiff + "</time>").focus();
                    editor.focus();
                    
                    var selectedFolder = $("[id$=-navigator] .selected");
                    
                    if(selectedFolder.is(".file") || actionVerb === "renaming") {
                        
                        selectedFolder = selectedFolder.closest(".dir:not(.selected)");
                    }
                    
                    // refresh folder
                    selectedFolder.trigger("click").trigger("click");
                    
                    var lastAction = $("[id$=-console] li:last a");
                    
                    if(actionType === "file") {
                        window.location.hash = lastAction.attr("href");
                    }
                },
                error: function(data) {
                    var timeDiff = new Date().getTime() - now.getTime();
                    var editor = ace.edit("editor");
                    
                    if(timeDiff < 1000) {
                        timeDiff += "ms";
                    } else {
                        timeDiff = timeDiff / 1000 + "s";
                    }
                    
                    $("[id$=-console] li:last").append($(data.responseText).text() + " <time>" + timeDiff + "</time>").focus();
                    editor.focus();
                },
                context: this
            });
            
            $(this).dialog('destroy');
            
            return false;
        });
        
        // set up the navigator event handlers
        $("[id$=-navigator]").on("contextmenu", "li", function(e){
            $("#navigationMenu").remove();
            
            // TODO: shift and control support... need to modify this (selected and active)
            $(".selected").removeClass("selected");
            $(this).addClass("selected");
            
            var menu = $("<nav id='navigationMenu'><ul><li class='newFile'>New File</li><li class='newFolder'>New Folder</li><li><hr></li><li class='rename'>Rename</li><li class='delete'>Delete</li><li><hr></li><li class='upload'>Upload*</li><li><hr></li><li>*commands don't work</li></ul></nav>").appendTo("body");

            var path = "";
            var $this = this;
            
            if($(this).is(".dir")) {
                path = "/" + $(this).children("span").text().trim();
            }
            
            // construct the path by concatenating all parent directory nodes' path attributes
            $(this).parents("li").each(function(){
				path = "/" + $(this).attr("params").replace(/^.*path=([^&]+)$/, "$1") + path;
			});
            
            if(path === '') {
                path = '/';
            }

            var contextFormDialog = $('<form class="contextForm" method="post" action="/ce/inc/ComiEditor.cfc"><input type="hidden" name="returnFormat" value="plain"/><input type="hidden" name="method" class="action"/><input type="hidden" name="folder" value="' + path + '"/></form>');
            
            $("li", menu).on('click', function(){
                var action = $(this).attr("class");
                
                if( action === 'newFile') {
                    contextFormDialog.addClass("new file");
                    $('<label>File Name <input type="text" name="fileName" value="index.cfm"></label>').appendTo(contextFormDialog);                
                } else if( action === 'newFolder') {
                    contextFormDialog.addClass("new folder");
                    $('<label>Folder Name <input type="text" name="folderName" value=""></label>').appendTo(contextFormDialog);                
                } else if( action === 'rename' ) {
                    contextFormDialog.addClass("rename");
                    if($($this).hasClass("file")) {
                        contextFormDialog.addClass("file");
                        action += "File";
                        $('<label>File Name <input type="text" name="fileName" value="' + $($this).children("span").text() + '"></label><input type="hidden" name="originalFileName" value="' + $($this).children("span").text() + '">').appendTo(contextFormDialog);
                    } else if($($this).hasClass("dir")) {
                        contextFormDialog.addClass("folder");
                        action += "Folder";
                        $('<label>Folder Name <input type="text" name="folderName" value="' + $($this).children("span").text() + '"></label><input type="hidden" name="originalFolderName" value="' + $($this).children("span").text() + '">').appendTo(contextFormDialog);
                    }
                } else if( action === 'delete' ) {
                    contextFormDialog.addClass("delete");
                    if($($this).hasClass("file")) {
                        contextFormDialog.addClass("file");
                        action += "File";
                        $('<div>Are you sure you want to delete this file?<br>' + path + '/' + $($this).children("span").text() + '<input type="hidden" name="fileName" value="' + $($this).children("span").text() + '"></div>').appendTo(contextFormDialog);
                    } else if($($this).hasClass("dir")) {
                        contextFormDialog.addClass("folder");
                        action += "Folder";
                        $('<div>Are you sure you want to delete this folder?<br>' + path + '</div>').appendTo(contextFormDialog);
                    }
                } else if( action === 'upload' ) {
                    contextFormDialog.addClass("upload");
                    
                    contextFormDialog.addClass("folder");
                    action += "Files";
                    $('<label>Files <input type="file" multiple name="uploads"></label>').appendTo(contextFormDialog);
                }
                
                $(".action", contextFormDialog).val(action);
                
                $(contextFormDialog).dialog({
                    title: $(this).text(),
                    modal: true,
                    buttons: {
                        Cancel: function() {
                            $(this).dialog('destroy');
                        }, OK: function() {
                            $(this).closest('.ui-dialog').find('form').submit();
                        }
                    },
                    open: function(){
                        $(":text:first", this).focus().select();
                    }
                });
            });

            menu.css({
                position: 'absolute',
                top: Math.min(e.pageY, $(this).closest("[id$=-navigator]").height() - menu.height() + 35),
                left: e.pageX,
                background: '#eee',
                border: 'solid 1px #ccc',
                padding: '5px 10px',
                zIndex: 999999,
                boxShadow: '0 0 5px #ddd'
            });
            
            $("ul", menu).css({ margin: 0, padding: 0, listStyle: 'none' });
            $("li", menu).css({ cursor: 'pointer' });
            return false;
		});
        
		// navigator click handler
		$("[id$=-navigator]").on("click", "li", function(e, callback){
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
					$(this).attr("params", "path="+path).children(".ui-icon").removeClass("ui-icon-folder-collapsed").addClass("ui-icon-folder-open");

					// set the status indicator to loading
					$(this).children(".status").addClass("loading");

					// fire off the ajax request to load the children of this node
					$.loadView(this, true, callback);

					// reset params to just this node's contribution (current folder name)
					$(this).attr("params", $(this).text());
				} else {
					// just open the collapsed folder structure
					$(this).addClass("ui-icon-folder-collapsed").removeClass("ui-icon-folder-open").find("ul").remove();
				}
			// file action
			} else if($(this).hasClass("file")) {
				path = "/";

				$(this).parents(".dir").each(function(){
					path = "/" + $(">span", this).text() + path;
				});

				var filePath = path + $(">span", this).text();
				window.location.hash = "file=" + filePath;
                
                $("#comiEditor-editor").attr("params", "file=" + filePath);
                $("#comiEditor-editor").empty();
                $.loadView("#comiEditor-editor", false);
			}

			// only one file/folder should ever be selected (unless control or shift is used...)
			// TODO: add shift and control support 
			$(".selected").removeClass("selected");

			// select the current item
			$(this).addClass("selected");
            
            // close the contextmenu if it is there
            $("#navigationMenu").remove();
            
            return false;
		});
        
        $(window).on("hashchange", function(){
            var filePath = window.location.hash.replace(/#.*file=\/?([^&]+).*/, '$1');
            filePathArray = filePath.split('/');
            
            $("#comiEditor-editor").attr("params", "file=/" + filePath);
            $("#comiEditor-editor").empty();
			$.loadView("#comiEditor-editor");
        }).trigger("hashchange");
	});
    
    $("body").on("click", function(){
        $("#navigationMenu").remove();
    });

	// cancel text selection on any element that has the unslectable attribute on any of it's parents
	document.onselectstart = function (e) {
		if ($(e.srcElement).parents("[unselectable]").length) {
			return false;
		}
	};

	// comiEditor loadView function
	$.loadView = function(selector, attachToDocument, callback) {
        if(attachToDocument!==undefined) { attachToDocument = true; }
        
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

                        if($(this).is("li")) {
                            $(this).append(t);
                        } else {
                            $(this).html(t);
                        }

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

							editor.commands.addCommands([{
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
							},
                            {
                                name: 'cfoutput',
                                bindKey: {
                                    win: 'Ctrl-Alt-O',
                                    mac: 'Ctrl-Command-O',
                                    sender: 'editor'
                                },
                                exec: function(editor, args, request) {
                                    var range = editor.getSelectionRange();
                                    var text = editor.session.getTextRange(range);
                                    
                                    editor.session.replace(range, "<cfoutput>"+text+"</cfoutput>");
                                }
                            },
                            {
                                name: 'cfdump',
                                bindKey: {
                                    win: 'Ctrl-Alt-D',
                                    mac: 'Ctrl-Shift-D',
                                    sender: 'editor'
                                },
                                exec: function(editor, args, request) {
                                    var range = editor.getSelectionRange();
                                    var text = editor.session.getTextRange(range);
                                    
                                    editor.session.replace(range, "<cfdump var='#"+text+"#'>");
                                }
                            },
                            {
                                name: 'cfdumpabort',
                                bindKey: {
                                    win: 'Ctrl-Shift-A',
                                    mac: 'Ctrl-Shift-A',
                                    sender: 'editor'
                                },
                                exec: function(editor, args, request) {
                                    var range = editor.getSelectionRange();
                                    var text = editor.session.getTextRange(range);
                                    
                                    editor.session.replace(range, "<cfdump var='#"+text+"#' abort>");
                                }
                            },
                            {
                                name: 'cfcomment',
                                bindKey: {
                                    win: 'Ctrl-Alt-M',
                                    mac: 'Ctrl-Command-M',
                                    sender: 'editor'
                                },
                                exec: function(editor, args, request) {
                                    var range = editor.getSelectionRange();
                                    var text = editor.session.getTextRange(range);
                                    
                                    editor.session.replace(range, "<!--- "+text+" --->");
                                }
                            }]);
						}
						else {
							t.attr("unselectable", "on").css({MozUserSelect:"none",webkitUserSelect:"none"});
                            
                            // if there is anything in the filePathArray still, and the parent element is the navigator panel, then open the current node in the filePathArray
                            if(filePathArray.length && t.closest("[id$=-navigator]").length) {
                                var firstNode = filePathArray.shift();
                                $("li span:contains("+ firstNode +")", this).each(function(){
                                    if($(this).text() == firstNode) {
                                        $(this).trigger("click");
                                    }
                                });
                            }
						}

						if(!$(this).parents().hasClass("panel")) {
							$(this).wrap($("<div></div>").addClass("panel"));
							$(this).parent(".panel").resizable({ handles: 'e' });
						}
						
						$(this).children(".status.loading").removeClass("loading");
                        
                        // fire the callback
                        if(typeof(callback) === "function") {
                            callback();
                        }
					} // success
                    
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
