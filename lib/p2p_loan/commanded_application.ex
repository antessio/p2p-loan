defmodule P2pLoan.CommandedApplication do
  use Commanded.Application, otp_app: :p2p_loan
  router(P2pLoan.CommandedRouter)

  def init(config) do
    {:ok, config}
  end
end
