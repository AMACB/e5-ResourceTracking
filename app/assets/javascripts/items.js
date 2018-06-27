function updateColors() {
	var white = true;
	$('.items-body div .row').each(function() {
		if (white) {
			$(this).removeClass("bg-light").addClass("bg-white");
		} else {
			$(this).removeClass("bg-white").addClass("bg-light");
		}
		white = !white;
	});
};