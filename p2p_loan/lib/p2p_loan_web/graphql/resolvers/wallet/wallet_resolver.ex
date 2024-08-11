defmodule P2pLoanWeb.GraphQL.Wallet.WalletResolver do
  alias P2pLoan.Wallets

  def get_wallets(_args, _resolver, %{context: %{current_user: current_user}}) do

    case current_user.is_admin do
      true -> {:ok, Wallets.list_wallets()}
      false -> {:error, "cannot see all the wallets"}
    end
    # {:ok, Wallets.list_wallets()}
  end
  def get_wallets(_args, _resolver, %{}) do
    {:error, "cannot see all the wallets"}
  end


  def create_wallet(args, _resolution, %{context: %{current_user: current_user}}) do
    case Wallets.create_wallet(%{args | owner_id: current_user.id}) do
      {:ok, wallet_id} ->
        {:ok, %{id: wallet_id}}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, "Changeset error #{P2pLoanWeb.GraphQL.Error.charset_error_to_string(changeset)}"}

      _ ->
        {:error, "Unexpected error"}
    end
  end
end
