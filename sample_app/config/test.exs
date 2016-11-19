use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sample_app, SampleApp.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sample_app, SampleApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sample_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure comeonin option
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pdkdf2_rounds, 1
