defmodule MsgrWeb.LikeControllerTest do
  use MsgrWeb.ConnCase

  alias Msgr.Messages
  alias Msgr.Messages.Like

  @create_attrs %{message_id: 42, user_id: 42}
  @update_attrs %{message_id: 43, user_id: 43}
  @invalid_attrs %{message_id: nil, user_id: nil}

  def fixture(:like) do
    {:ok, like} = Messages.create_like(@create_attrs)
    like
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all likes", %{conn: conn} do
      conn = get conn, like_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create like" do
    test "renders like when data is valid", %{conn: conn} do
      conn = post conn, like_path(conn, :create), like: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, like_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "message_id" => 42,
        "user_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, like_path(conn, :create), like: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update like" do
    setup [:create_like]

    test "renders like when data is valid", %{conn: conn, like: %Like{id: id} = like} do
      conn = put conn, like_path(conn, :update, like), like: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, like_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "message_id" => 43,
        "user_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, like: like} do
      conn = put conn, like_path(conn, :update, like), like: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete like" do
    setup [:create_like]

    test "deletes chosen like", %{conn: conn, like: like} do
      conn = delete conn, like_path(conn, :delete, like)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, like_path(conn, :show, like)
      end
    end
  end

  defp create_like(_) do
    like = fixture(:like)
    {:ok, like: like}
  end
end
