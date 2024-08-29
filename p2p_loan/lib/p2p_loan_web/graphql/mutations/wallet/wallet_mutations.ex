defmodule P2pLoan.GraphQL.Wallet.WalletMutations do
  use Absinthe.Schema.Notation

  alias P2pLoanWeb.GraphQL.Wallet.WalletResolver

  object :wallet_mutations do
    field :create_wallet, non_null(:wallet) do
      arg :amount, non_null(:decimal)
      #arg :owner_id, non_null(:string)
      arg :currency, non_null(:string)

      resolve &WalletResolver.create_wallet/3
    end
  end
end
