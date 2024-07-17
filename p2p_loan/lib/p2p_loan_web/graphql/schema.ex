defmodule P2pLoanWeb.GraphQL.Schema do
  use Absinthe.Schema
  alias P2pLoan.Loans
  alias P2pLoan.Wallets

  alias P2pLoanWeb.GraphQL.Wallet.WalletResolver

  import_types Absinthe.Type.Custom

  import_types P2pLoan.GraphQL.Queries
  import_types P2pLoan.GraphQL.Mutations
  import_types P2pLoan.GraphQL.Types


  query do

    import_fields :wallet_queries
    import_fields :loan_queries

  end

  mutation do
    import_fields :create_wallet
  end




end
