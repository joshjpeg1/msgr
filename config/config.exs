# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :msgr,
  ecto_repos: [Msgr.Repo]

# Configures the endpoint
config :msgr, MsgrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bhkQNhHJ317Hpde6jC2VCMrwk8nGo1ZK42E1y2yvov6w5qoz1pDMR4WGtmaS3ibT",
  render_errors: [view: MsgrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Msgr.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
