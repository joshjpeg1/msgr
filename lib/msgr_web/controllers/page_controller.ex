defmodule MsgrWeb.PageController do
  use MsgrWeb, :controller

  def index(conn, _params) do
    redirect conn, to: message_path(conn, :index)
  end
end
