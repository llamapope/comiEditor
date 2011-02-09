;(function($){
	$(function() {
		// load each panel of the editor
		$(":not([id*=-])").each(function(){
			$.loadView("[id^=" + this.id + "-]");
		});

		// set up the navigator event handlers

		// navigator click handler
		$("[id$=-navigator]").delegate("li", "click", function(){
			// directory action
			if($(this).hasClass("dir")) {
				// if there are no children, see if there should be any from the server
				if(!$(this).children("ul").length) {
					// variable to store the path into
					var path = "";

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
			}

			// only one file/folder should ever be selected (unless control or shift is used...)
			// TODO: add shift and control support 
			$(".selected").removeClass("selected");

			// select the current item
			$(this).addClass("selected");
		});
	});

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

						if(!$(this).parents().hasClass("panel")) {
							$(this).wrap($("<div></div>").addClass("panel"));
							$(this).parent(".panel").resizable({ handles: 'e' });
						}
						
						$(this).children(".status.loading").removeClass("loading");
					}
				});
			}
		});
	}

	function getViewName(element) {
		var viewName = $(element).attr("view");
		if(!viewName && element.id) {
			viewName = element.id;
		} else {
			viewName = $(element).closest("[id*=-]").attr("id");
		}
		return viewName.replace(/.*-/, "");
	}
})(jQuery);
