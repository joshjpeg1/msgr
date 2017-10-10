defmodule MsgrWeb.Router do
  use MsgrWeb, :router
  import MsgrWeb.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_user
  end

  scope "/", MsgrWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/follows", FollowController
    resources "/messages", MessageController
    post "/sessions", SessionController, :login
    delete "/sessions", SessionController, :logout
  end

  # Other scopes may use custom stacks.
  scope "/api", MsgrWeb do
    pipe_through :api

    resources "/likes", LikeController, except: [:new, :edit]
    delete "/likes", LikeController, :delete
  end
end
