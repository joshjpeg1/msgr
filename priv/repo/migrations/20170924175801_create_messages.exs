defmodule Msgr.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
			add :id, :uuid, primary_key: true
      add :content, :text
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:messages, [:user_id])
  end
end
