defmodule Msgr.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :message_id, references(:messages, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:likes, [:message_id])
    create index(:likes, [:user_id])
  end
end
