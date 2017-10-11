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

Repo.delete_all(User)
josh = Repo.insert!(%User{full_name: "Josh Pensky", email: "joshpensky@msgr.com", username: "josh_jpeg", bio: "I draw things"})
aoun = Repo.insert!(%User{full_name: "Joseph Aoun", email: "aounson@neu.edu", username: "ilovehuskies", bio: "I hate dining hall workers"})
eric = Repo.insert!(%User{full_name: "Eric Harris", email: "ebharris@you.me", username: "yinyangbangarang", bio: "I love pandas"})
nath = Repo.insert!(%User{full_name: "Nathan Fielder", email: "nathan4u@cc.com", username: "onyourside", bio: "So, you wanna, like, hang out sometime? It's cool if not..."})

Repo.delete_all(Message)
gmsg = Repo.insert!(%Message{content: "Can we have you on for an episode, @ilovehuskies? The idea: pay dining hall workers near to nothing and have them sign a non-compete so they have to work for you", user_id: nath.id})
Repo.insert!(%Message{content: "This is such a cool website", user_id: josh.id})
Repo.insert!(%Message{content: "I wish more websites were this cool", user_id: josh.id})
Repo.insert!(%Message{content: "Man this site looks nothing like Twitter!", user_id: josh.id})
Repo.insert!(%Message{content: "Bio says it all", user_id: aoun.id})

#Repo.delete_all(Follow)
#Repo.insert!(%Follow{follower_id: josh.id, subject_id: nath.id})
#Repo.insert!(%Follow{follower_id: josh.id, subject_id: eric.id})
#Repo.insert!(%Follow{follower_id: eric.id, subject_id: josh.id})
#Repo.insert!(%Follow{follower_id: nath.id, subject_id: aoun.id})

Repo.delete_all(Like)
Repo.insert!(%Like{user_id: josh.id, message_id: gmsg.id})
