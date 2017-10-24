const textFollow = "Follow";
const textFollowing = "Following";

export default function add_follows() {
	if (!$("#user-follows").length > 0) {
		// Wrong page
		return;
	}

	let dd = $($("#user-follows")[0]);
	let path = dd.data('path');

	$(".follow-btn").each(function() {
		this.innerHTML = $(this).data('following') ? textFollowing : textFollow;
		this.addEventListener("click", function() {
			toggle_follow($(this), path);
		});
	});
}

function update_button(button, following) {
	$(button)[0].innerHTML = following ? textFollow : textFollowing;
	button.data('following', !following);
}

function toggle_follow(button, path) {
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
