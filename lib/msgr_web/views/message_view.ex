defmodule MsgrWeb.MessageView do
  use MsgrWeb, :view
  alias MsgrWeb.MessageView
	alias Msgr.Messages

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, MessageView, "message.json")}
  end


  def render("message.json", %{message: message}) do
    data = %{
      id: message.id,
      content: message.content,
      user_id: message.user_id,
			timestamp: Messages.get_message_time(message.id),
    }
		
		data = Map.put(data, :likes, MsgrWeb.UserView.render("index.json", %{users: Messages.list_users_by_like(message.id)}))
    if Ecto.assoc_loaded?(message.user) do
      data = Map.delete(data, :user_id)
      data = Map.put(data, :user, %{id: message.user_id, username: message.user.username, full_name: message.user.full_name})
    end
    data
  end
end

