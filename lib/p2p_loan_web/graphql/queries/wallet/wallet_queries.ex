defmodule P2pLoan.GraphQL.Wallet.WalletQueries do
  use Absinthe.Schema.Notation

  alias P2pLoanWeb.GraphQL.Wallet.WalletResolver

  object :wallet_queries do
    field :get_wallets, list_of(:wallet) do
      resolve &WalletResolver.get_wallets/3
    end

    field :my_wallet, :wallet do
      resolve &WalletResolver.get_my_wallet/3
    end

  end
end
