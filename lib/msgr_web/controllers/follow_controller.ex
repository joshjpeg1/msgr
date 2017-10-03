defmodule MsgrWeb.FollowController do
  use MsgrWeb, :controller

  alias Msgr.Users
  alias Msgr.Users.Follow

  def index(conn, _params) do
    follows = Users.list_follows()
    render(conn, "index.html", follows: follows)
  end

  def new(conn, _params) do
    changeset = Users.change_follow(%Follow{})
    render(conn, "new.html", changeset: changeset)
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

  def show(conn, %{"id" => id}) do
    follow = Users.get_follow!(id)
    render(conn, "show.html", follow: follow)
  end

  def edit(conn, %{"id" => id}) do
    follow = Users.get_follow!(id)
    changeset = Users.change_follow(follow)
    render(conn, "edit.html", follow: follow, changeset: changeset)
  end

  def update(conn, %{"id" => id, "follow" => follow_params}) do
    follow = Users.get_follow!(id)

    case Users.update_follow(follow, follow_params) do
      {:ok, follow} ->
        conn
        |> put_flash(:info, "Follow updated successfully.")
        |> redirect(to: follow_path(conn, :show, follow))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", follow: follow, changeset: changeset)
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
