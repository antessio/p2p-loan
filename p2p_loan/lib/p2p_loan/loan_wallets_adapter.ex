defmodule P2pLoan.LoanWalletsAdapter do
  @behaviour P2pLoan.Loans.WalletsPort

  alias P2pLoan.Wallets

  @impl true
  def move_money(from_owner_id, to_owner_id, amount)
      when is_binary(from_owner_id) and is_binary(to_owner_id) do
    from_wallet = Wallets.get_wallet_by_owner_id(from_owner_id)
    to_wallet = Wallets.get_wallet_by_owner_id(to_owner_id)
    move_money(from_wallet, to_wallet, amount)
  end

  @impl true
  def move_money(from_wallet, to_wallet, amount) do
    case Wallets.charge(from_wallet, amount)do
      {:ok, id} -> Wallets.top_up(to_wallet, amount)
      {:error, msg} -> {:error, msg}
    end
  end

  @impl true
  def charge(owner_id, amount) when  is_binary(owner_id) do
    Wallets.get_wallet_by_owner_id(owner_id)
    |> Wallets.charge(amount)
  end

  @impl true
  def charge(wallet, amount) do
    Wallets.charge(wallet, amount)
  end

  @impl true
  def get_wallet_by_owner_id(owner_id) do
    Wallets.get_wallet_by_owner_id(owner_id)
  end
end
