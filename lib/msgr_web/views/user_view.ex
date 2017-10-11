defmodule MsgrWeb.UserView do
  use MsgrWeb, :view
  alias MsgrWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    data = %{
      id: user.id,
      username: user.username,
      full_name: user.full_name,
    }
    data
  end
end

