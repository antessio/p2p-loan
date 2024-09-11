defmodule P2pLoanWeb.GraphQL.Account.AccontTypes do
  use Absinthe.Schema.Notation


  object :session do
    field :token, non_null(:string)
  end
end
