defmodule P2pLoan.GraphQL.Wallet.WalletMutations do
  use Absinthe.Schema.Notation
  alias P2pLoanWeb.GraphQL.Wallet.WalletTypes
  alias P2pLoanWeb.GraphQL.Wallet.WalletResolver

  object :create_wallet do
    field :create_wallet, non_null(:wallet) do
      arg :amount, non_null(:decimal)
      arg :owner_id, non_null(:string)
      arg :currency, non_null(:string)

      resolve &WalletResolver.create_wallet/2
    end
  end
end
