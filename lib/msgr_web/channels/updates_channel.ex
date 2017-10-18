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
		followers = Users.list_followers(message.user_id)
		|> Enum.map(fn(f) -> 
			MsgrWeb.Endpoint.broadcast("updates:" <> Integer.to_string(f.id), "message", %{"id" => id}) 
			end)
		broadcast socket, "message", %{"id" => id}
		{:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

end
