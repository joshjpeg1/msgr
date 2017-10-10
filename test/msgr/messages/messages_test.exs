defmodule Msgr.MessagesTest do
  use Msgr.DataCase

  alias Msgr.Messages

  describe "messages" do
    alias Msgr.Messages.Message

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Messages.create_message(@valid_attrs)
      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, message} = Messages.update_message(message, @update_attrs)
      assert %Message{} = message
      assert message.content == "some updated content"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end

  describe "likes" do
    alias Msgr.Messages.Like

    @valid_attrs %{message: "7488a646-e31f-11e4-aace-600308960662", user: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{message: "7488a646-e31f-11e4-aace-600308960668", user: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{message: nil, user: nil}

    def like_fixture(attrs \\ %{}) do
      {:ok, like} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_like()

      like
    end

    test "list_likes/0 returns all likes" do
      like = like_fixture()
      assert Messages.list_likes() == [like]
    end

    test "get_like!/1 returns the like with given id" do
      like = like_fixture()
      assert Messages.get_like!(like.id) == like
    end

    test "create_like/1 with valid data creates a like" do
      assert {:ok, %Like{} = like} = Messages.create_like(@valid_attrs)
      assert like.message == "7488a646-e31f-11e4-aace-600308960662"
      assert like.user == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_like(@invalid_attrs)
    end

    test "update_like/2 with valid data updates the like" do
      like = like_fixture()
      assert {:ok, like} = Messages.update_like(like, @update_attrs)
      assert %Like{} = like
      assert like.message == "7488a646-e31f-11e4-aace-600308960668"
      assert like.user == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_like/2 with invalid data returns error changeset" do
      like = like_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_like(like, @invalid_attrs)
      assert like == Messages.get_like!(like.id)
    end

    test "delete_like/1 deletes the like" do
      like = like_fixture()
      assert {:ok, %Like{}} = Messages.delete_like(like)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_like!(like.id) end
    end

    test "change_like/1 returns a like changeset" do
      like = like_fixture()
      assert %Ecto.Changeset{} = Messages.change_like(like)
    end
  end

  describe "likes" do
    alias Msgr.Messages.Like

    @valid_attrs %{message_id: 42, user_id: 42}
    @update_attrs %{message_id: 43, user_id: 43}
    @invalid_attrs %{message_id: nil, user_id: nil}

    def like_fixture(attrs \\ %{}) do
      {:ok, like} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_like()

      like
    end

    test "list_likes/0 returns all likes" do
      like = like_fixture()
      assert Messages.list_likes() == [like]
    end

    test "get_like!/1 returns the like with given id" do
      like = like_fixture()
      assert Messages.get_like!(like.id) == like
    end

    test "create_like/1 with valid data creates a like" do
      assert {:ok, %Like{} = like} = Messages.create_like(@valid_attrs)
      assert like.message_id == 42
      assert like.user_id == 42
    end

    test "create_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_like(@invalid_attrs)
    end

    test "update_like/2 with valid data updates the like" do
      like = like_fixture()
      assert {:ok, like} = Messages.update_like(like, @update_attrs)
      assert %Like{} = like
      assert like.message_id == 43
      assert like.user_id == 43
    end

    test "update_like/2 with invalid data returns error changeset" do
      like = like_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_like(like, @invalid_attrs)
      assert like == Messages.get_like!(like.id)
    end

    test "delete_like/1 deletes the like" do
      like = like_fixture()
      assert {:ok, %Like{}} = Messages.delete_like(like)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_like!(like.id) end
    end

    test "change_like/1 returns a like changeset" do
      like = like_fixture()
      assert %Ecto.Changeset{} = Messages.change_like(like)
    end
  end
end
