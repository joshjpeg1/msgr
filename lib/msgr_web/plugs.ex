# Credit to Nathaniel Tuck, https://github.com/NatTuck/nu_mart/blob/class-0928/lib/nu_mart_web/plugs.ex
defmodule MsgrWeb.Plugs do
  import Plug.Conn

  def fetch_user(conn, _opts) do
    user_id = get_session(conn, :user_id)
    if user_id do
      user = Msgr.Users.get_user!(user_id)
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end
end
