defmodule P2pLoanWeb.GraphQL.Wallet.WalletTypes do
  use Absinthe.Schema.Notation


  object :wallet do
    field :id, non_null(:id)
    field :amount, non_null(:decimal)
    field :owner_id, non_null(:string)
    field :currency, non_null(:string)
  end
end
