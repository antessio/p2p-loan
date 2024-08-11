defmodule P2pLoan.GraphQL.Types do
  use Absinthe.Schema.Notation

  import_types P2pLoanWeb.GraphQL.Wallet.WalletTypes
  import_types P2pLoanWeb.GraphQL.Loan.LoanTypes
  import_types P2pLoanWeb.GraphQL.Account.AccontTypes
end
