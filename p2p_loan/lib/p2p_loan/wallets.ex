defmodule P2pLoan.Wallets do
  @moduledoc """
  The Wallets context.
  """

  import Ecto.Query, warn: false
  alias P2pLoan.Wallets.WalletCommands.ChargeCommand
  alias P2pLoan.Wallets.WalletCommands.TopUpCommand
  alias P2pLoan.Wallets.WalletCommands.CreateWalletCommand
  alias P2pLoan.CommandedApplication
  alias P2pLoan.Repo

  alias P2pLoan.Wallets.Wallet

  @doc """
  Returns the list of wallets.

  ## Examples

      iex> list_wallets()
      [%Wallet{}, ...]

  """
  def list_wallets do
    Repo.all(Wallet)
  end

  @doc """
  Gets a single wallet.

  Raises `Ecto.NoResultsError` if the Wallet does not exist.

  ## Examples

      iex> get_wallet!(123)
      %Wallet{}

      iex> get_wallet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wallet!(id), do: Repo.get!(Wallet, id)

  def get_wallet_with_movements!(id), do: Repo.get!(Wallet, id) |> Repo.preload(:movements)

  @doc """
  Creates a wallet.

  ## Examples

      iex> create_wallet(%{field: value})
      {:ok, %Wallet{}}

      iex> create_wallet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet(attrs \\ %{}) do
    command =
      attrs
      |> CreateWalletCommand.new()
      |> CreateWalletCommand.assign_id()

    case get_wallet_by_owner_id(command.owner_id) do
      nil ->
        case CommandedApplication.dispatch(command, consistency: :strong) do
          :ok -> {:ok, command.id}
          {:error, cause} -> {:error, cause}
        end

      w ->
        {:ok, w.id}
    end

    # CommandedApplication.dispatch(command)
    # {:ok, command.id}
  end

  @doc """
  Updates a wallet.

  ## Examples

      iex> update_wallet(wallet, %{field: new_value})
      {:ok, %Wallet{}}

      iex> update_wallet(wallet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet(%Wallet{} = wallet, attrs) do
    wallet
    |> Wallet.changeset(attrs)
    |> Repo.update()
  end

  def top_up(wallet_id, top_up_amount) when is_binary(wallet_id) do
    wallet = get_wallet!(wallet_id)

    case dispatch_top_up(wallet, top_up_amount) do
      :ok -> {:ok, wallet_id}
      :error -> {:error, "can't top-up the wallet"}
      {:error, error} -> {:error, dbg(error), "unexpected error"}
    end
  end

  defp dispatch_top_up(%Wallet{} = wallet, amount) when not is_nil(wallet) do
    %{amount: amount, id: wallet.id, currency: wallet.currency}
    |> TopUpCommand.new()
    |> CommandedApplication.dispatch(consistency: :strong)
  end

  defp dispatch_top_up(nil, _) do
    {:error, :no_existing_wallet, "wallet doesn't exist"}
  end

  def top_up(%Wallet{} = wallet, top_up_amount) do
    # wallet
    # |> Wallet.changeset(%{amount: Decimal.add(wallet.amount, top_up_amount)})
    # |> Repo.update()
    case dispatch_top_up(wallet, top_up_amount) do
      :ok -> {:ok, wallet.id}
      :error -> {:error, "can't top-up the wallet"}
    end
  end

  def charge(%Wallet{} = wallet, charge_amount) do
    case Decimal.lt?(
           wallet.amount,
           charge_amount
         ) do
      true ->
        {:error, "insufficient funds"}

      false ->
        case dispatchCharge(wallet, charge_amount) do
          :ok -> {:ok, wallet.id}
          :error -> {:error, "can't top-up the wallet"}
        end
    end
  end

  def charge(wallet_id, charge_amount) when is_binary(wallet_id) do
    wallet = get_wallet!(wallet_id)
    case Decimal.lt?(
           wallet.amount,
           charge_amount
         ) do
      true ->
        {:error, "insufficient funds"}

      false ->
        case dispatchCharge(wallet, charge_amount) do
          :ok -> {:ok, wallet.id}
          :error -> {:error, "can't top-up the wallet"}
        end
    end
  end

  defp dispatchCharge(wallet, amount) do
    %{amount: amount, id: wallet.id}
    |> ChargeCommand.new()
    |> CommandedApplication.dispatch(consistency: :strong)
  end

  def get_wallet_by_owner_id(owner_id) do
    from(w in Wallet, where: w.owner_id == ^owner_id)
    |> Repo.one()
  end

  @doc """
  Deletes a wallet.

  ## Examples

      iex> delete_wallet(wallet)
      {:ok, %Wallet{}}

      iex> delete_wallet(wallet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wallet(%Wallet{} = wallet) do
    Repo.delete(wallet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet changes.

  ## Examples

      iex> change_wallet(wallet)
      %Ecto.Changeset{data: %Wallet{}}

  """
  def change_wallet(%Wallet{} = wallet, attrs \\ %{}) do
    Wallet.changeset(wallet, attrs)
  end
end
