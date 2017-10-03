# Credit to Nathaniel Tuck, http://www.ccs.neu.edu/home/ntuck/courses/2017/09/cs4550/notes/06-finish-cart/notes.html

defmodule MsgrWeb.SessionController do
  use MsgrWeb, :controller

  alias Msgr.Users

  def login(conn, %{"username_email" => input}) do
    user = Users.get_user_by_email(input)
    if user do
    else
      user = Users.get_user_by_username(input)
    end

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as #{user.username}")
      |> redirect(to: message_path(conn, :index))
    else
      conn
      |> put_session(:user_id, nil)
      |> put_flash(:error, "No such user")
      |> redirect(to: message_path(conn, :index))
    end
  end

  def logout(conn, _params) do
    conn
    |> put_session(:user_id, nil)
    |> put_flash(:info, "Logged out")
    |> redirect(to: message_path(conn, :index))
  end
end
