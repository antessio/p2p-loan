defmodule P2pLoanWeb.GraphQL.Wallet.WalletResolver do
  alias P2pLoan.Wallets

  def get_wallets(_args, _resolver) do
    {:ok, Wallets.list_wallets()}
  end

  def create_wallet(args, _resolution) do
    case Wallets.create_wallet(args) do
      {:ok, wallet } -> {:ok, wallet}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, "Changeset error #{P2pLoanWeb.GraphQL.Error.charset_error_to_string(changeset)}"}
      _ -> {:error, "Unexpected error"}
    end
  end


end
