# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :p2p_loan,
  ecto_repos: [P2pLoan.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :p2p_loan, P2pLoanWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: P2pLoanWeb.ErrorHTML, json: P2pLoanWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: P2pLoan.PubSub,
  live_view: [signing_salt: "DSIGyzLM"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :p2p_loan, P2pLoan.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  p2p_loan: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  p2p_loan: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"


config :p2p_loan, :wallets_port, P2pLoan.LoanWalletsAdapter
config :p2p_loan, P2pLoan.EventStore, serializer: Commanded.Serialization.JsonSerializer

config :p2p_loan, P2pLoan.EventStore,
  pool_size: 10,
  queue_target: 50,
  queue_interval: 1_000,
  schema: "commanded"

config :p2p_loan, event_stores: [P2pLoan.EventStore]

config :p2p_loan, P2pLoan.CommandedApplication,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: P2pLoan.EventStore
  ],
  pubsub: :local,
  registry: :local

config :commanded_ecto_projections, repo: P2pLoan.Repo

config :p2p_loan, :salt, "YF1GKFH#GU#P"
