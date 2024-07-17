defmodule P2pLoan.GraphQL.Loan.LoanQueries do
  use Absinthe.Schema.Notation
  alias P2pLoanWeb.GraphQL.Loan.LoanTypes
  alias P2pLoanWeb.GraphQL.Loan.LoanResolvers

  object :loan_queries do
    field :get_loan, :loan do
      arg :id, non_null(:id)

      resolve &LoanResolvers.get_loan/2
    end

    field :get_all_loans, list_of(:loan) do
      resolve &LoanResolvers.get_loans/2
    end

  end
end
