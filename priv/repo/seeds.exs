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

Repo.delete_all(User)

Repo.insert!(%User{full_name: "Josh Pensky", email: "joshpensky@example.com", username: "josh_jpeg", bio: "I draw things."})
Repo.insert!(%User{full_name: "twenty griffinteen", email: "griffin@mcelroyshows.com", username: "griffinmcelroy", bio: "Polygon Video Producer, MBMBaM Co-Brother, Adventure Zone DM, and Diesel Jeans"})
Repo.insert!(%User{full_name: "Scott Pilgrim", email: "scott@amazon.ca", username: "WallacesB", bio: "Bread makes you FAT?!"})
