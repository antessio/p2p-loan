import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :testcontainers,
  enabled: false

config :p2p_loan, P2pLoan.Repo,
  username: "p2ploan",
  password: "p2ploan_pwd",
  hostname: "localhost",
  database: "p2ploandb_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :p2p_loan, P2pLoan.EventStore,
  serializer: EventStore.JsonSerializer,
  pool: Ecto.Adapters.SQL.Sandbox,
  username: "p2ploan",
  password: "p2ploan_pwd",
  hostname: "localhost",
  database: "p2ploandb_test",
  schema: "commanded"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :p2p_loan, P2pLoanWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "HE046xYItfkE1KtQz/vK+8VnlbwMKWD6tz7Wwl0j4OMUWUXSjXnSVXLk/lRmsbOR",
  server: false

# In test we don't send emails
config :p2p_loan, P2pLoan.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
