# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :my_music,
  ecto_repos: [MyMusic.Repo],
  albums_json: System.get_env("ALBUMS_JSON")

# Configures the endpoint
config :my_music, MyMusicWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hZDGGBx5ZmJ9vsEO58L4Y9+554PNRZ3Ges236hXyMRCd2XH2GMiX6yB9M3IxI60I",
  render_errors: [view: MyMusicWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: MyMusic.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
