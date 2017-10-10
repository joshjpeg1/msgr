defmodule MsgrWeb.LikeController do
  use MsgrWeb, :controller

  alias Msgr.Messages
  alias Msgr.Messages.Like

  action_fallback MsgrWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    likes = Messages.list_likes_by_user(user_id)
    render(conn, "index.json", likes: likes)
  end

  def index(conn, %{"message_id" => message_id}) do
    likes = Messages.list_likes_by_message(message_id)
    render(conn, "index.json", likes: likes)
  end

  def index(conn, _params) do
    likes = Messages.list_likes()
    render(conn, "index.json", likes: likes)
  end

  def create(conn, %{"like" => like_params}) do
    like = Messages.get_like_by_user_message(like_params["user_id"], like_params["message_id"])
    if like do
        send_resp(conn, :no_content, "")
		else
    	with {:ok, %Like{} = like} <- Messages.create_like(like_params) do
      	conn
      	|> put_status(:created)
      	|> put_resp_header("location", like_path(conn, :show, like))
      	|> render("show.json", like: like)
    	end
		end
  end

  def show(conn, %{"id" => id}) do
    like = Messages.get_like!(id)
    render(conn, "show.json", like: like)
  end

  def update(conn, %{"id" => id, "like" => like_params}) do
    like = Messages.get_like!(id)

    with {:ok, %Like{} = like} <- Messages.update_like(like, like_params) do
      render(conn, "show.json", like: like)
    end
  end

  def delete(conn, %{"like" => like_params}) do
    like = Messages.get_like_by_user_message(like_params["user_id"], like_params["message_id"])
    if like do
      with {:ok, %Like{}} <- Messages.delete_like(like) do
        send_resp(conn, :no_content, "")
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    like = Messages.get_like!(id)
    with {:ok, %Like{}} <- Messages.delete_like(like) do
      send_resp(conn, :no_content, "")
    end
  end
end
