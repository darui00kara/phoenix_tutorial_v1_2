# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sample_app,
  ecto_repos: [SampleApp.Repo]

# Configures the endpoint
config :sample_app, SampleApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "l6nSjSnkJnvD4uybKMwFYMTXksA2eEQDQRU8NPf8B6221bx+EVe1fFBN3uDAg03l",
  render_errors: [view: SampleApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SampleApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Scrivener
config :scrivener_html,
  routes_helper: SampleApp.Router.Helpers

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
