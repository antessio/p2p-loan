defmodule P2pLoan.GraphQL.Mutations do
  use Absinthe.Schema.Notation

  import_types P2pLoan.GraphQL.Wallet.WalletMutations
  import_types P2pLoan.GraphQL.Loan.LoanMutations
end
