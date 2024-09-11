defmodule P2pLoan.EventStore do
  use EventStore, otp_app: :p2p_loan

    # Optional `init/1` function to modify config at runtime.
    def init(config) do
      {:ok, config}
    end

end
