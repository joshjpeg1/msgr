// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

let handlebars = require("handlebars");

$(function() {
	if (!$("#likes-template").length > 0) {
		// Wrong page.
		return;
	}

	let tt = $($("#likes-template")[0]);
	let code = tt.html();
	let tmpl = handlebars.compile(code);

	let dd= $($("#post-likes")[0]);
	let path = dd.data('path');

	function toggle_like(button) {
		let m_id = button.data('message-id');
		let u_id = button.data('user-id');

		let data = {like: {user_id: u_id, message_id: m_id}};

		$(button)[0].classList.remove('icon--animated');
		let liked = $(button)[0].classList.contains('icon--selected');
		let method = liked ? "DELETE" : "POST";
		
		$.ajax({
			url: path,
			data: JSON.stringify(data),
			contentType: "application/json",
			dataType: "json",
			method: method,
			success: update_button(button, liked),
		});
	}

	function update_button(button, liked) {
		if (liked) {
			$(button)[0].classList.remove('icon--selected');
		} else {
			$(button)[0].classList.add('icon--selected');
			$(button)[0].classList.add('icon--animated');
			setTimeout(function() {
				$(button)[0].classList.remove('icon--animated');
			}, 1300);
		}
		$(button)[0].nextElementSibling.innerHTML = parseInt($(button)[0].nextElementSibling.innerHTML) + (liked ? -1 : 1);
	}

	dd.html(tmpl({}));

	$(".like-btn").each(function() {
		this.addEventListener("click", function() {
			toggle_like($(this));
		});
	});

});
