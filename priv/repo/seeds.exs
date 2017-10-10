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
alias Msgr.Messages.Like


Repo.insert!(%User{full_name: "Josh Pensky", email: "joshpensky@msgr.com", username: "josh_jpeg", bio: "I draw things"})
Repo.insert!(%User{full_name: "Joseph Aoun", email: "aounson@neu.edu", username: "ilovehuskies", bio: "I hate dining hall workers"})
Repo.insert!(%User{full_name: "Eric Harris", email: "ebharris@you.me", username: "yinyangbangarang", bio: "I love pandas"})
Repo.insert!(%User{full_name: "Nathan Fielder", email: "nathan4u@cc.com", username: "onyourside", bio: "So, you wanna, like, hang out sometime? It's cool if not..."})

Repo.insert!(%Follow{follower_id: 1, subject_id: 4})
Repo.insert!(%Follow{follower_id: 1, subject_id: 3})
Repo.insert!(%Follow{follower_id: 3, subject_id: 1})
Repo.insert!(%Follow{follower_id: 4, subject_id: 2})

Repo.insert!(%Message{content: "Can we have you on for an episode, @ilovehuskies? The idea: pay dining hall workers near to nothing and have them sign a non-compete so they have to work for you", user_id: 4})
Repo.insert!(%Message{content: "This is such a cool website", user_id: 1})
Repo.insert!(%Message{content: "I wish more websites were this cool", user_id: 1})
Repo.insert!(%Message{content: "Man this site looks nothing like Twitter!", user_id: 1})
Repo.insert!(%Message{content: "Bio says it all", user_id: 2})

Repo.insert!(%Like{user_id: 1, message_id: 1})
