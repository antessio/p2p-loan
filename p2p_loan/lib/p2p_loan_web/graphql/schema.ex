defmodule P2pLoanWeb.GraphQL.Schema do
  use Absinthe.Schema

  alias P2pLoanWeb.GraphQL.Middleware.HandleChangesetErrors


  import_types Absinthe.Type.Custom

  import_types P2pLoan.GraphQL.Queries
  import_types P2pLoan.GraphQL.Mutations
  import_types P2pLoan.GraphQL.Types


  query do

    import_fields :wallet_queries
    import_fields :loan_queries

  end

  mutation do
    import_fields :wallet_mutations
    import_fields :loan_mutations
  end


  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [HandleChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end


end
