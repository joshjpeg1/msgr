defmodule MsgrWeb.FollowView do
  use MsgrWeb, :view
	alias MsgrWeb.FollowView

	def render("index.json", %{follows: follows}) do
    %{data: render_many(follows, FollowView, "follow.json")}
  end

  def render("show.json", %{follow: follow}) do
    %{data: render_one(follow, FollowView, "follow.json")}
  end


	def render("follow.json", %{follow: follow}) do
    data = %{
			id: follow.id,
      follower_id: follow.follower_id,
      subject_id: follow.subject_id
    }
    if Ecto.assoc_loaded?(follow.follower) do
    	data = Map.delete(data, :follower_id)
    	data = Map.put(data, :follower, %{id: follow.follower_id, username: follow.follower.username, full_name: follow.follower.full_name})
    end
    if Ecto.assoc_loaded?(follow.subject) do
      data = Map.delete(data, :subject_id)
      data = Map.put(data, :subject, %{id: follow.subject_id, username: follow.subject.username, full_name: follow.follower.full_name})
    end
    data
  end
end
