# test/support/data_case.ex
defmodule P2pLoan.CommandedCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Commanded.Assertions.EventAssertions
    end
  end

  defp start_repo() do
    case P2pLoan.Repo.start_link() do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
      {:error, error} -> {:error, error}
    end

  end

  setup do
    #start_repo()
    P2pLoan.TestingStorage.reset!()
    #{:ok, _} = Application.ensure_all_started(:p2p_loan)


    on_exit(fn ->
      #:ok = Application.stop(:p2p_loan)

      P2pLoan.TestingStorage.reset!()
    end)

    :ok
  end
end
