(function($){

$(function(){
	$(".fileManager li.dir").click(function(){
		$(this).children("ul").toggle();
		return false;
	});
});

})(jQuery);
