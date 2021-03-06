defmodule MsgrWeb.MessageController do
  use MsgrWeb, :controller

  alias Msgr.Messages
  alias Msgr.Messages.Message

	def index(conn, %{"user_id" => user_id}) do
		if user_id == "-1" do
			messages = Messages.list_messages
		else
			messages = Messages.get_user_feed(user_id)
		end
		render(conn, "index.json", messages: messages)
	end

	def index(conn, %{"id" => id}) do
		message = Messages.get_message!(id)
		render(conn, "show.json", message: message)
	end

  def index(conn, _params) do
    if user = get_session(conn, :user_id) do
      messages = Messages.get_user_feed(user)
    else
      messages = Messages.list_messages
    end
    render(conn, "index.html", messages: messages)
  end

  def new(conn, _params) do
    changeset = Messages.change_message(%Message{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"message" => message_params}) do
    IO.inspect(message_params)
    with {:ok, %Message{} = message} <- Messages.create_message(message_params) do
        conn
				|> put_status(:created)
        |> put_resp_header("location", message_path(conn, :index))
				|> render("show.json", message: message)
  	end
  end

  def edit(conn, %{"id" => id}) do
    message = Messages.get_message!(id)
    changeset = Messages.change_message(message)
    render(conn, "edit.html", message: message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Messages.get_message!(id)

    case Messages.update_message(message, message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message updated successfully.")
        |> redirect(to: message_path(conn, :show, message))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", message: message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Messages.get_message!(id)
    {:ok, _message} = Messages.delete_message(message)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> redirect(to: message_path(conn, :index))
  end
end
