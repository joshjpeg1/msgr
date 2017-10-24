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

import add_follows from "./follow";
import add_like_btn_listener from "./like";
import socket from "./socket";

let handlebars = require("handlebars");
let channel = (window.user != null) ? null : socket.channel("updates:" + window.user_id, {});

function joinChannel() {
	if (channel != null) {
		channel.join()
			.receive("ok", resp => { console.log("Joined successfully", resp) })
			.receive("error", resp => { console.log("Unable to join", resp) })
	}
	channel.on("message", receiveMsg);
}

function receiveMsg(msg) {
	let dd = $($("#messages-feed")[0]);
	let get_path = dd.data('path');

	$.ajax({
		url: get_path,
		data: {id: msg.id},
		contentType: "application/json",
		dataType: "json",
		method: "GET",
		success: prependMsg,
	});
}

function prependMsg(resp) {
	let data = resp.data;
	let liked = false;
	if (user != null) {
		let likesArr = data.likes.data;
		for (var j = 0; j < likesArr.length; j++) {
			if (likesArr[j].id == user) {
				liked = true;
				break;
			}
		}
	}
	data.liked = liked;

	let dataArr = {data: [data]};

	let tt = $($("#messages-template")[0]);
	let code = tt.html();
	let tmpl = handlebars.compile(code);

	let dd = $($("#messages-feed")[0]);
	let get_path = dd.data('path');
	let user = dd.data('user-id');

	let like_path = $($("#like-path")[0]).data('path');

	dd.prepend(tmpl(dataArr));
	if (user != null) {
		let button = $(".like-btn")[0];
		add_like_btn_listener(button, like_path, user);
	}
}

$(function() {
	add_follows();
});

function post_message(create_path, content, u_id) {
	let data = {message: {user_id: u_id, content: content}};

	$.ajax({
		url: create_path,
		data: JSON.stringify(data),
		contentType: "application/json",
		dataType: "json",
		method: "POST",
		success: push_channel_message,
	});
}

function push_channel_message(resp) {
	channel.push("message", {id: resp.data.id});
}

function fetch_feed() {
	let tt = $($("#messages-template")[0]);
	let code = tt.html();
	let tmpl = handlebars.compile(code);

	let dd = $($("#messages-feed")[0]);
	let get_path = dd.data('path');
	let user = dd.data('user-id');

	let like_path = $($("#like-path")[0]).data('path');

	function got_feed(data) {
		let dataArr = data.data;
		for (var i = 0; i < dataArr.length; i++) {
			let liked = false;
			if (user != null) {
				let likesArr = dataArr[i].likes.data;
				for (var j = 0; j < likesArr.length; j++) {
					if (likesArr[j].id == user) {
						liked = true;
						break;
					}
				}
			}
			dataArr[i].liked = liked;
		}
		dd.html(tmpl(data));
		if (user != null) {
			$(".like-btn").each(function() {
				add_like_btn_listener(this, like_path, user);
			});
		}
		$(".content").each(function() {
			this.addEventListener("click", function() {
				message_modal_update($(this).data('message-id'));
			});
		});
	}

	$.ajax({
		url: get_path,
		data: {user_id: (user == undefined ? -1 : user)},
		contentType: "application/json",
		dataType: "json",
		method: "GET",
		success: got_feed,
	});
}

$(function() {
	if (!$("#signUp").length > 0) {
		// Wrong page
		return;
	}

	fetch_feed();
});

$(function() {
	if (!$("#create-post").length > 0) {
		// Wrong page
		return;
	}
	joinChannel();

	let bb = $($("#create-post")[0]);
	let create_path = bb.data('path');
	let textarea = $(bb.find(".form-control"));

	$(bb.find(".btn-msgr"))[0].addEventListener("click", function() {
		post_message(create_path, textarea.val(), bb.data('user-id'));
		textarea.val("");
		textarea.focus();
	});

	fetch_feed();
});

$(function() {
	let postBox = $($("#postBox")[0]);
	let newPost = $(postBox.find(".new-post"));
	let create_path = newPost.data('path');
	let textarea = $(newPost.find(".form-control"));

	$(newPost.find(".btn-msgr"))[0].addEventListener("click", function() {
		post_message(create_path, textarea.val(), newPost.data('user-id'));
		textarea.val("");
	});
});

$(function() {
	if (!$("#post-likes").length > 0) {
		// Wrong page.
		return;
	}

	let dd = $($("#post-likes")[0]);
	let like_path = dd.data('path');
	let user = dd.data('user');

	if (user != null) {
		$(".like-btn").each(function() {
			add_like_btn_listener(this, like_path, user);
		});
	}
	$(".content").each(function() {
			this.addEventListener("click", function() {
				message_modal_update($(this).data('message-id'));
			});
	});
});

function message_modal_update(m_id) {
	let dd = null;
	let get_path = null;
	let user = null;
	if (!$("#messages-feed").length > 0) {
		if (!$("#post-likes").length > 0) {
			return;
		}
		dd = $($("#post-likes")[0]);
		get_path = dd.data('message-path');
		user = dd.data('user');
	} else {
		dd = $($("#messages-feed")[0]);
		get_path = dd.data('path');
		user = dd.data('user-id');
	}

	$.ajax({
		url: get_path,
		data: {id: m_id},
		contentType: "application/json",
		dataType: "json",
		method: "GET",
		success: fill_modal,
	});

	function fill_modal(resp) {
		let data = resp.data;
		let liked = false;
		//let user = $($('#messages-feed')[0]).data('user-id');
		if (user != null) {
			let likesArr = data.likes.data;
			for (var j = 0; j < likesArr.length; j++) {
				if (likesArr[j].id == user) {
					liked = true;
					break;
				}
			}
		}
		data.liked = liked;

		let tt = $($("#msg-modal-template")[0]);
		let code = tt.html();
		let tmpl = handlebars.compile(code);

		let view = $($("#msg-view")[0]);
		let like_path = $($('#like-path')[0]).data('path');

		view.html(tmpl(data));
		view.find(".like-btn").each(function() {
			add_like_btn_listener(this, like_path, user);
		});
	}
}
