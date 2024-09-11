defmodule InMemoryEventStoreCase do
  use P2pLoan.DataCase

  alias Commanded.EventStore.Adapters.InMemory

  setup do
    {:ok, _apps} = Application.ensure_all_started(:p2p_loan)

    on_exit(fn ->
      :ok = Application.stop(:p2p_loan)
    end)
  end
end
