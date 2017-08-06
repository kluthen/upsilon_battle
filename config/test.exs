use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :upsilon_battle, UpsilonBattle.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :upsilon_battle, UpsilonBattle.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "bastien",
  password: "G6PVz5qUGbs0C90BemcI4EYFemyEKz",
  database: "upsilon_bastien_test",
  hostname: "ecumeurs.fr",
  pool: Ecto.Adapters.SQL.Sandbox
