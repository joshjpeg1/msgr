export default function add_like_btn_listener(btn, path, user) {
  btn.addEventListener("click", function() {
    toggle_like(path, $(btn), user);
  });
}

function toggle_like(path, button, u_id) {
  let m_id = button.data('message-id');
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
