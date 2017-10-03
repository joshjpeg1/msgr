# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Msgr.Repo.insert!(%Msgr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Msgr.Repo
alias Msgr.Users.User
alias Msgr.Users.Follow
alias Msgr.Messages.Message

Repo.insert!(%Follow{follower_id: 8, subject_id: 9})
