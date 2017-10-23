defmodule Msgr.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Msgr.Users.User
	alias Msgr.Users

	# Password integration code courtesy of Nathaniel Tuck, http://www.ccs.neu.edu/home/ntuck/courses/2017/09/cs4550/notes/10-passwords/notes.html
  schema "users" do
    field :bio, :string
    field :email, :string
    field :full_name, :string
    field :username, :string
		field :password_hash, :string
		field :pw_tries, :integer
		field :pw_last_try, :utc_datetime

		field :password, :string, virtual: true
		field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :username, :bio, :password, :password_confirmation])
		|> validate_confirmation(:password)
		|> validate_password(:password)
		|> put_pass_hash()
    |> validate_required([:full_name, :email, :username, :bio, :password_hash])
  end

	def validate_password(changeset, field, options \\ []) do
		validate_change(changeset, field, fn _, password ->
			case valid_password?(password) do
				{:ok, _} -> []
				{:error, msg} -> [{field, options[:message] || msg}]
			end
		end)
	end

	def put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
		change(changeset, Comeonin.Argon2.add_hash(password))
	end

	def put_pass_hash(changeset), do: changeset

	def valid_password?(password) when byte_size(password) > 7 do
		{:ok, password}
	end

	def valid_password?(_), do: {:error, "The password is too short"}
end
