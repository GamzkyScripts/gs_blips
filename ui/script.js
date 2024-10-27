$(() => {
	window.addEventListener('message', (event) => {
		const ev = event.data;

		if (ev.action === 'show') {
			$('.overlay-wrapper').fadeIn(200);
			$('#blip-title').text(ev.data.title);
			$('#blip-description').html(ev.data.description);
		} else if (ev.action === 'update') {
			$('#blip-title').text(ev.data.title);
			$('#blip-description').html(ev.data.description);
		} else if (ev.action === 'hide') {
			$('.overlay-wrapper').fadeOut(200);
		}
	});
});
