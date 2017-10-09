defmodule Msgr.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  import Msgr.Dates
  alias Msgr.Repo

  alias Msgr.Messages.Message
  alias Msgr.Users.Follow

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(from m in Message, order_by: [desc: m.inserted_at])
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
  def get_message!(id), do: Repo.get!(Message, id)

  def list_messages_by_userid(user_id) do
    Repo.all(from m in Message, where: m.user_id == ^user_id, order_by: [desc: m.inserted_at])
  end

  def get_user_feed(user_id) do
    query = from f in Follow, where: f.follower_id == ^user_id
    if length(Repo.all(query)) == 0 do
      Msgr.Messages.list_messages_by_userid(user_id)
    else
      Repo.all(from m in Message, join: f in subquery(query),
          on: f.subject_id == m.user_id or m.user_id == ^user_id,
          order_by: [desc: m.inserted_at])
    end
  end

  def get_message_time(id) do
    datetime = get_message!(id).inserted_at
    curr_day = Date.utc_today()
    curr_time = Time.utc_now()
    get_msg_time(datetime, curr_day, curr_time)
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
end
