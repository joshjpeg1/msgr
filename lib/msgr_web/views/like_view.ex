defmodule MsgrWeb.LikeView do
  use MsgrWeb, :view
  alias MsgrWeb.LikeView

  def render("index.json", %{likes: likes}) do
    %{data: render_many(likes, LikeView, "like.json")}
  end

  def render("show.json", %{like: like}) do
    %{data: render_one(like, LikeView, "like.json")}
  end

  def render("like.json", %{like: like}) do
    data = %{
			id: like.id,
      user_id: like.user_id,
      message_id: like.message_id
		}

		if Ecto.assoc_loaded?(like.user) do
			data = Map.delete(data, :user_id)
			data = Map.put(data, :user, %{id: like.user_id, username: like.user.username, full_name: like.user.full_name})
		end
		if Ecto.assoc_loaded?(like.message) do
			data = Map.delete(data, :message_id)
			data = Map.put(data, :message, %{id: like.message_id, user_id: like.message.user_id, content: like.message.content})
		end
		data
  end
end
