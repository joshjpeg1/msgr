defmodule MsgrWeb.UpdatesChannel do
  use MsgrWeb, :channel
	alias Phoenix.Socket
	alias Msgr.Messages
	alias Msgr.Users

  def join("updates:" <> u_id, payload, socket) do
    if authorized?(payload) do
			socket = socket
			|> Socket.assign(:name, u_id)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("message", %{"id" => id}, socket) do
		message = Messages.get_message!(id)
		followers = Users.get_follower_ids(message.user_id)
		broadcast socket, "message", %{"id" => id}
		{:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

end
