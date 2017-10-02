defmodule Msgr.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :full_name, :string, null: false
      add :email, :string, null: false
      add :username, :string, null: false
      add :bio, :text, null: false

      timestamps()
    end

  end
end
