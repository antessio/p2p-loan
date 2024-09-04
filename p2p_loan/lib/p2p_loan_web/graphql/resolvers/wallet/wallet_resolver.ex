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

  def get_my_wallet(_args, _resolver, %{context: %{current_user: current_user}}) do
    {:ok, Wallets.get_wallet_by_owner_id(current_user.id)}
  end
  def get_my_wallet(_args, _resolver, %{}) do
    {:error, "forbidden"}
  end


  def create_wallet(args, _resolution, _) do

    create_wallet_result = args
    |> Map.put_new(:owner_id, "2c444821-038b-45c2-a19a-a4e349d1aefc")
    |> Wallets.create_wallet()
    case create_wallet_result do
      {:ok, wallet_id} ->
        {:ok, %{id: wallet_id}}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, "Changeset error #{P2pLoanWeb.GraphQL.Error.charset_error_to_string(changeset)}"}

      _ ->
        {:error, "Unexpected error"}
    end
  end
end
