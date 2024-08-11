defmodule P2pLoanWeb.Graphql.Mutations.Accounts.UserMutations do

  use Absinthe.Schema.Notation

  alias P2pLoanWeb.Graphql.Resolvers.Account.AccountResolver

  object :account_mutations do
    field :signin, :session do
      arg(:email, :string)
      arg(:password, :string)
      resolve &AccountResolver.signin/3
    end
  end
end
