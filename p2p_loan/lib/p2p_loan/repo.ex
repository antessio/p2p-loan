defmodule P2pLoan.Repo do
  use Ecto.Repo,
    otp_app: :p2p_loan,
    adapter: Ecto.Adapters.Postgres
end
