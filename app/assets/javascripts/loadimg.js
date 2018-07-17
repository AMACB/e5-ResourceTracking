$(function() {
	$(".load-img-button").click(function() {
		$(this).after("<img src='" + $(this).data('rel') + "' alt='" + $(this).data('alt') + "' class='" + $(this).data('class') + "' />");
		$(this).remove();
	})
});