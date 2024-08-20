# test/support/storage.ex
defmodule P2pLoan.TestingStorage do
  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    reset_eventstore()
    reset_readstore()
  end

  defp reset_eventstore do
    config = P2pLoan.EventStore.config()

    {:ok, conn} =
      config
      |> EventStore.Config.default_postgrex_opts()
      |> Postgrex.start_link()

    EventStore.Storage.Initializer.reset!(conn, config)
  end

  defp reset_readstore do
    P2pLoan.Repo.query!(truncate_readstore_tables())
    #readstore_config = Application.get_env(:p2p_loan, P2pLoan.Repo)

    # {:ok, conn} = Postgrex.start_link(readstore_config)
    # Postgrex.query!(conn, truncate_readstore_tables(), [])
  end

  defp truncate_readstore_tables do
    """
    TRUNCATE TABLE
      wallets,
      loans,
      contributions,
      interest_charges
    RESTART IDENTITY
    CASCADE;
    """
  end
end
