defmodule P2pLoan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias P2pLoan.Wallets.WalletSupervisor
  @impl true
  def start(_type, _args) do
    if Application.get_env(:testcontainers, :enabled, false) do
      {:ok, _container} = Testcontainers.Ecto.postgres_container(app: :p2p_loan)

      # to use mysql, change
      # `adapter: Ecto.Adapters.Postgres`
      # in lib/hello/repo.ex, to
      # `adapter: Ecto.Adapters.MyXQL`

      # {:ok, _container} = Testcontainers.Ecto.mysql_container(app: :hello)
    end

    children = [
      WalletSupervisor,
      P2pLoanWeb.Telemetry,
      P2pLoan.Repo,
      {DNSCluster, query: Application.get_env(:p2p_loan, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: P2pLoan.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: P2pLoan.Finch},
      # Start a worker by calling: P2pLoan.Worker.start_link(arg)
      # {P2pLoan.Worker, arg},
      # Start to serve requests, typically the last entry
      P2pLoanWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: P2pLoan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    P2pLoanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
