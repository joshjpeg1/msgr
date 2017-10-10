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
			Map.put(data, :user_username, like.user.username)
		else
			data
		end
  end
end
