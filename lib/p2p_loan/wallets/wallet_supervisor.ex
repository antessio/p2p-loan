defmodule P2pLoan.Wallets.WalletSupervisor do
  use Supervisor


  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      P2pLoan.CommandedApplication,
      P2pLoan.Wallets.WalletProjection
    ]
    Supervisor.init(
      children,
      strategy: :one_for_one
    )
  end
end
