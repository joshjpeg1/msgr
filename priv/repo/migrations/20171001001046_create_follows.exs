defmodule Msgr.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :follower_id, references(:users, on_delete: :delete_all), null: false
      add :subject_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
	
		create index(:follows, [:follower_id])
		create index(:follows, [:subject_id])
  end
end
