defmodule Msgr.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  import Msgr.Dates
  alias Msgr.Repo

  alias Msgr.Messages.Message
  alias Msgr.Users.Follow
	alias Msgr.Users.User
	alias Msgr.Users

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(from m in Message, order_by: [desc: m.inserted_at])
  end

  def list_messages_by_userid(user_id) do
    Repo.all(from m in Message, where: m.user_id == ^user_id, order_by: [desc: m.inserted_at])
		|> Repo.preload(:user)
  end

  def get_user_feed(user_id) do
    query = from f in Follow, where: f.follower_id == ^user_id
    if length(Repo.all(query)) == 0 do
      Msgr.Messages.list_messages_by_userid(user_id)
    else
			query = from f in Follow, where: f.follower_id == ^user_id or f.subject_id == ^user_id
      Repo.all(from m in Message, join: f in subquery(query),
          on: f.subject_id == m.user_id, order_by: [desc: m.inserted_at])
			|> Enum.uniq()
			|> Repo.preload(:user)
    end
  end

	def find_mentions(content) do
		if String.contains?(content, "@") do
			mentions = String.split(content, " ")
			|> Enum.reduce([], fn(x, acc) -> 
				if String.starts_with?(x, "@") do
					user = Users.get_user_by_username(Regex.replace(~r/([^a-zA-Z0-9_])/, x, ""))
					if user do
						acc ++ ["<%= user_path(@conn, :show, " <> Integer.to_string(user.id) <> ") %>"]
					else
						acc
					end
				else
					acc
				end
			end)
		else
			content
		end
	end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id) do
		Repo.get!(Message, id)
		|> Repo.preload(:user)
	end

  def get_message_time(id) do
    datetime = get_message!(id).inserted_at
    get_msg_time(datetime, NaiveDateTime.utc_now())
	end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end
  
  alias Msgr.Messages.Like

  @doc """
  Returns the list of likes.

  ## Examples

      iex> list_likes()
      [%Like{}, ...]

  """
  def list_likes do
    Repo.all(Like)
		|> Repo.preload(:user)
		|> Repo.preload(:message)
  end

	def list_likes_by_user(user_id) do
		Repo.all(from l in Like, where: l.user_id == ^user_id)
		|> Repo.preload(:user)
		|> Repo.preload(:message)
	end

	def list_likes_by_message(message_id) do
		Repo.all(from l in Like, where: l.message_id == ^message_id)
		|> Repo.preload(:user)
		|> Repo.preload(:message)
	end

	def list_users_by_like(message_id) do
		query = from l in Like, where: l.message_id == ^message_id
		Repo.all(from u in User, join: l in subquery(query), on: l.user_id == u.id)
	end 

  @doc """
  Gets a single like.

  Raises `Ecto.NoResultsError` if the Like does not exist.

  ## Examples

      iex> get_like!(123)
      %Like{}

      iex> get_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_like!(id), do: Repo.get!(Like, id)
  
  def get_like_by_user_message(user_id, message_id) do
    Repo.get_by(Like, user_id: user_id, message_id: message_id)
  end

  def get_like_count(message_id) do
    length(Repo.all(from l in Like, where: l.message_id == ^message_id))
  end
 
  def did_user_like(user_id, message_id) do
    if get_like_by_user_message(user_id, message_id) do
      true
    else
      false
    end
  end
 
  @doc """
  Creates a like.

  ## Examples

      iex> create_like(%{field: value})
      {:ok, %Like{}}

      iex> create_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_like(attrs \\ %{}) do
		%Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a like.

  ## Examples

      iex> update_like(like, %{field: new_value})
      {:ok, %Like{}}

      iex> update_like(like, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_like(%Like{} = like, attrs) do
    like
    |> Like.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Like.

  ## Examples

      iex> delete_like(like)
      {:ok, %Like{}}

      iex> delete_like(like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_like(%Like{} = like) do
    Repo.delete(like)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking like changes.

  ## Examples

      iex> change_like(like)
      %Ecto.Changeset{source: %Like{}}

  """
  def change_like(%Like{} = like) do
    Like.changeset(like, %{})
  end
end
