defmodule Msgr.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
			add :id, :uuid, primary_key: true
      add :full_name, :string
      add :email, :string
      add :username, :string
      add :bio, :text

      timestamps()
    end

  end
end
