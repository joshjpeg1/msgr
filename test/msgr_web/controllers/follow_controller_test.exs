defmodule MsgrWeb.FollowControllerTest do
  use MsgrWeb.ConnCase

  alias Msgr.Users

  @create_attrs %{follower_id: 42, subject_id: 42}
  @update_attrs %{follower_id: 43, subject_id: 43}
  @invalid_attrs %{follower_id: nil, subject_id: nil}

  def fixture(:follow) do
    {:ok, follow} = Users.create_follow(@create_attrs)
    follow
  end

  describe "index" do
    test "lists all follows", %{conn: conn} do
      conn = get conn, follow_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Follows"
    end
  end

  describe "new follow" do
    test "renders form", %{conn: conn} do
      conn = get conn, follow_path(conn, :new)
      assert html_response(conn, 200) =~ "New Follow"
    end
  end

  describe "create follow" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, follow_path(conn, :create), follow: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == follow_path(conn, :show, id)

      conn = get conn, follow_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Follow"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, follow_path(conn, :create), follow: @invalid_attrs
      assert html_response(conn, 200) =~ "New Follow"
    end
  end

  describe "edit follow" do
    setup [:create_follow]

    test "renders form for editing chosen follow", %{conn: conn, follow: follow} do
      conn = get conn, follow_path(conn, :edit, follow)
      assert html_response(conn, 200) =~ "Edit Follow"
    end
  end

  describe "update follow" do
    setup [:create_follow]

    test "redirects when data is valid", %{conn: conn, follow: follow} do
      conn = put conn, follow_path(conn, :update, follow), follow: @update_attrs
      assert redirected_to(conn) == follow_path(conn, :show, follow)

      conn = get conn, follow_path(conn, :show, follow)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, follow: follow} do
      conn = put conn, follow_path(conn, :update, follow), follow: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Follow"
    end
  end

  describe "delete follow" do
    setup [:create_follow]

    test "deletes chosen follow", %{conn: conn, follow: follow} do
      conn = delete conn, follow_path(conn, :delete, follow)
      assert redirected_to(conn) == follow_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, follow_path(conn, :show, follow)
      end
    end
  end

  defp create_follow(_) do
    follow = fixture(:follow)
    {:ok, follow: follow}
  end
end
