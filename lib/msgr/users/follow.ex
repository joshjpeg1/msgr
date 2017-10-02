defmodule Msgr.Users.Follow do
  use Ecto.Schema
  import Ecto.Changeset
  alias Msgr.Users.Follow

  schema "follows" do
    belongs_to :follower, Msgr.Users.User
    belongs_to :subject, Msgr.Users.User

    timestamps()
  end

  @doc false
  def changeset(%Follow{} = follow, attrs) do
    follow
    |> cast(attrs, [:follower_id, :subject_id])
    |> validate_required([:follower_id, :subject_id])
  end
end
