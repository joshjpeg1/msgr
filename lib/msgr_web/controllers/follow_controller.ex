defmodule MsgrWeb.FollowController do
  use MsgrWeb, :controller

  alias Msgr.Users
  alias Msgr.Users.Follow

  def index(conn, _params) do
    follows = Users.list_follows()
    render(conn, "index.json", follows: follows)
  end

  def create(conn, %{"follow" => follow_params}) do
    case Users.create_follow(follow_params) do
      {:ok, follow} ->
        user = follow.subject_id
        conn
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

	def delete(conn, %{"follow" => follow_params}) do
    follow = Users.get_follow_by_users(follow_params["follower_id"], follow_params["subject_id"])
    if follow do
      with {:ok, %Follow{}} <- Users.delete_follow(follow) do
        send_resp(conn, :no_content, "")
      end
    end
  end


  def delete(conn, %{"id" => id}) do
    follow = Users.get_follow!(id)
    user = follow.subject_id
    {:ok, _follow} = Users.delete_follow(follow)

    conn
    |> redirect(to: user_path(conn, :show, user))
  end

  def delete(conn, %{"follower_id" => follower_id, "subject_id" => subject_id}) do
    Users.Follow.delete(Users.get_follow_by_users(follower_id, subject_id).id)
  end
end
