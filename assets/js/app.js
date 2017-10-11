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

// Thank you to Nathaniel Tuck for supplying the base code: http://www.ccs.neu.edu/home/ntuck/courses/2017/09/cs4550/notes/07-ajax-cart/notes.html

$(function() {
	if (!$("#user-follows").length > 0) {
		// Wrong page
		return;
	}

	const textFollow = "Follow";
	const textFollowing = "Following";
	
	let dd = $($("#user-follows")[0]);
	let path = dd.data('path');

	function toggle_follow(button) {
		let f_id = button.data('follower-id');
		let s_id = button.data('subject-id');
		let following = button.data('following');

		let data = {follow: {follower_id: f_id, subject_id: s_id}};

		let method = following ? "DELETE" : "POST";
		
		$.ajax({
			url: path,
			data: JSON.stringify(data),
			contentType: "application/json",
			dataType: "json",
			method: method,
			success: update_button(button, following),
		});
	}

	function update_button(button, following) {
		$(button)[0].innerHTML = following ? textFollow : textFollowing;
		button.data('following', !following);
	}
	
	$(".follow-btn").each(function() {
		this.innerHTML = $(this).data('following') ? textFollowing : textFollow;
		this.addEventListener("click", function() {
			toggle_follow($(this));
		});
	});

});

$(function() {
	if (!$("#create-post").length > 0) {
		// Wrong page
		return;
	}

	let tt = $($("#messages-template")[0]);
	let code = tt.html();
	let tmpl = handlebars.compile(code);
	
	let dd = $($("#messages-feed")[0]);
	let get_path = dd.data('path');
	let user = dd.data('user-id');	

	let bb = $($("#create-post")[0]);
	let create_path = bb.data('path');
	
	let like_path = $($("#like-path")[0]).data('path');

	function post_message() {
		let content = $(bb.find(".form-control")).val();
		console.log(content);
		let u_id = bb.data('user-id');	

		let data = {message: {user_id: u_id, content: content}};

		$.ajax({
			url: create_path,
			data: JSON.stringify(data),
			contentType: "application/json",
			dataType: "json",
			method: "POST",
			success: fetch_feed,
		});

		$(bb.find(".form-control")).val("");
	}

	function fetch_feed() {
		function got_feed(data) {
			console.log(data);
			let dataArr = data.data;
			for (var i = 0; i < dataArr.length; i++) {
				let liked = false;
				let likesArr = dataArr[i].likes.data;
				for (var j = 0; j < likesArr.length; j++) {
					if (likesArr[j].id == user) {
						liked = true;
						break;
					}
				}
				dataArr[i].liked = liked;
			}
			dd.html(tmpl(data));
			add_like_button_listeners(like_path, user);
		}

		$.ajax({
			url: get_path,
			data: {user_id: user},
			contentType: "application/json",
			dataType: "json",
			method: "GET",
			success: got_feed,
		});
	}

	$(bb.find(".btn-msgr"))[0].addEventListener("click", function() {
		post_message();
	});

	fetch_feed();
});

function toggle_like(path, button, u_id) {
	let m_id = button.data('message-id');
	//let u_id = button.data('user-id');

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

function add_like_button_listeners(path, user) {
	$(".like-btn").each(function() {
		this.addEventListener("click", function() {
			toggle_like(path, $(this), user);
		});
	});
}

/*
$(function() {
	if (!$("#post-likes").length > 0) {
		// Wrong page.
		return;
	}

	let dd= $($("#post-likes")[0]);
	let path = dd.data('path');

});
*/
