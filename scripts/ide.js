;(function($){
	$(function(){
		var ide = function(options) {
			arguments = $.extend({ containment: this, panels: $(this).children() }, options ? options : {});
			containment = arguments.containment ? $(arguments.containment) : $(this);
			panels = arguments.panels ? $(arguments.panels) : $(this).children();
			console.log(this);
			return this;
		};

		$.fn.ide = function(options, more) {
			console.log(ide(options));
		};
	});
})(jQuery);
