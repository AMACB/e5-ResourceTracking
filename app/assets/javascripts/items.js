function updateColors() {
	var white = true;
	$('.zebra').each(function() {
		if (white) {
			$(this).removeClass("bg-light").addClass("bg-white");
		} else {
			$(this).removeClass("bg-white").addClass("bg-light");
		}
		white = !white;
	});
};

function createEditForm(i) {
	$.get('/items/editform/' + i);
}