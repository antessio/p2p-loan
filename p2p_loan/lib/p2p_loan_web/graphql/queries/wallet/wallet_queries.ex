defmodule P2pLoan.GraphQL.Wallet.WalletQueries do
  use Absinthe.Schema.Notation
  alias P2pLoanWeb.GraphQL.Wallet.WalletTypes
  alias P2pLoanWeb.GraphQL.Wallet.WalletResolver

  object :wallet_queries do
    field :get_wallets, list_of(:wallet) do

      resolve &WalletResolver.get_wallets/2
    end
  end
end
