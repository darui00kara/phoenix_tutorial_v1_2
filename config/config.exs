# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_tutorial_v1_2,
  ecto_repos: [PhoenixTutorialV12.Repo]

# Configures the endpoint
config :phoenix_tutorial_v1_2, PhoenixTutorialV12.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SqE6I4x2Dn68OE/jfNH1bHhtPONBhW8kwwmK9o/mBgAPUd+FHCdldpN6GnfCStHL",
  render_errors: [view: PhoenixTutorialV12.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixTutorialV12.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
