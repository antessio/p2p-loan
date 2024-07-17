defmodule P2pLoan.GraphQL.Queries do
  use Absinthe.Schema.Notation

  import_types P2pLoan.GraphQL.Wallet.WalletQueries
  import_types P2pLoan.GraphQL.Loan.LoanQueries
end
