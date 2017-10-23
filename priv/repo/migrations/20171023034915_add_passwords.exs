defmodule Msgr.Repo.Migrations.AddPasswords do
  use Ecto.Migration

  def change do
		# code courtesy of Nathaniel Tuck, http://www.ccs.neu.edu/home/ntuck/courses/2017/09/cs4550/notes/10-passwords/notes.html
		alter table("users") do
			add :password_hash, :string
			add :pw_tries, :integer, null: false, default: 0
			add :pw_last_try, :utc_datetime
		end
  end
end
