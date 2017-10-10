defmodule Msgr.Messages.Like do
  use Ecto.Schema
  import Ecto.Changeset
  alias Msgr.Messages.Like


  schema "likes" do
    belongs_to :message, Msgr.Messages.Message
    belongs_to :user, Msgr.Users.User

    timestamps()
  end

  @doc false
  def changeset(%Like{} = like, attrs) do
    like
    |> cast(attrs, [:user_id, :message_id])
    |> validate_required([:user_id, :message_id])
  end
end
