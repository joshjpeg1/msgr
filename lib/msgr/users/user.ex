defmodule Msgr.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Msgr.Users.User

  schema "users" do
    field :bio, :string
    field :email, :string
    field :full_name, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :username, :bio])
    |> validate_required([:full_name, :email, :username, :bio])
  end
end
