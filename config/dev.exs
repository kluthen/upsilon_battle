use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :upsilon_battle, UpsilonBattle.Endpoint,
  http: [port: 4005],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :upsilon_battle, UpsilonBattle.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :upsilon_battle, UpsilonBattle.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "bastien",
  password: "G6PVz5qUGbs0C90BemcI4EYFemyEKz",
  database: "upsilon_bastien",
  hostname: "ecumeurs.fr",
  pool_size: 10

# Master config: 
# config :upsilon_battle, UpsilonBattle.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "master",
#   password: "zJYj3gV6EVYSrOoNFw2AmB1JyWvyTz",
#   database: "upsilon_master",
#   hostname: "ecumeurs.fr",
#   pool_size: 10
# 