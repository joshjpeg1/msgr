defmodule Msgr.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Msgr.Messages.Message

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "messages" do
    field :content, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
