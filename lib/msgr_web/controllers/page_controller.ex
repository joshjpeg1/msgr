defmodule MsgrWeb.PageController do
  use MsgrWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
