(function($){

$(function(){
	$(".fileManager li.dir:has(ul)").click(function(){
		$(this).children("ul").toggle();
		return false;
	});
	$(".fileManager li.file").click(function(event){
		event.stopPropagation();
	});
});

})(jQuery);
