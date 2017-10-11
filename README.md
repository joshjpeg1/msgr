# Msgr

## [`GitHub Repo`](https://github.com/joshjpeg1/msgr)
## [`Deployed App`](http://msgr.jpegdev.win/)

---

## Behavior

### Login
Users should be able to log in to the service by entering either their registered username or email address associated with their account.

User can then log out by pressing their profile image in the nav bar, then clicking log out.

Users can create accounts from the main screen when logged out, by clicking the Sign Up button.

### Posts
The main feed on the index page includes all posts on made by the user or the users that the user follow.

The feed on a user's page includes all posts that user has made.

A user can post new messages either from the post button in the navbar or the post button on the index page, which will take you to the new message page (currently relocated to its ow
n page instead of modal.

### Follows
A user can follow any other user and receive all their messages in their main feed.

To follow a user, click the follow button on their user page. To unfollow a user, click the following button on their user page.

You cannot follow yourself.

### Likes
Likes can be viewed either when looking at a single message or multiple in a list.

Any user can like another user's message. However, a user can like a message only once.

---

## Using deploy.sh
***NOTE:*** *Only users with access to the msgr server will be able to deploy the app.*

If you are such a user, simply run the command `./deploy.sh` in the root folder.

---

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
