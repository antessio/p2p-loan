defmodule P2pLoan.Loans.WalletsPort do
  @moduledoc """
  Provides functionalities on wallets: move money, charge money, top-up
  """

  @callback move_money(from_owner_id :: String.t(), to_owner_id :: String.t(), amount :: Decimal.t()) :: :ok | :error
  def move_money(from_owner_id, to_owner_id, amount) when is_binary(from_owner_id) and is_binary(to_owner_id), do: adapter().move_money(from_owner_id, to_owner_id)

  @callback move_money(from_wallet :: P2pLoan.Wallets.Wallet.t(), to_wallet :: P2pLoan.Wallets.Wallet.t(),  amount :: Decimal.t()) :: :ok | :error
  def move_money(from_wallet, to_wallet, amount), do: adapter().move_money(from_wallet, to_wallet)

  @callback charge(owner_id :: String.t(), amount :: Decimal.t()) :: :ok | :error
  def charge(owner_id, amount) when is_binary(owner_id), do: adapter().charge(owner_id, amount)

  @callback charge(wallet :: P2pLoan.Wallets.Wallet.t(), amount :: Decimal.t()) :: :ok | :error
  def charge(wallet, amount), do: adapter().charge(wallet, amount)

  @callback get_wallet_by_owner_id(owner_id :: String.t()) :: P2pLoan.Wallets.Wallet.t()
  def get_wallet_by_owner_id(owner_id), do: adapter().get_wallet_by_owner_id(owner_id)

  defp adapter, do: Application.get_env(:wallets_port, __MODULE__)


end
