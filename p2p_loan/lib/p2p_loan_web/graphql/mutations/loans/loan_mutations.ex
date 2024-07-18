defmodule P2pLoan.GraphQL.Loan.LoanMutations do
  use Absinthe.Schema.Notation
  alias P2pLoanWeb.GraphQL.Loan.LoanTypes
  alias P2pLoanWeb.GraphQL.Loan.LoanResolvers


  object :loan_mutations do
    field :loan_request, non_null(:loan) do
      arg :owner_id, non_null(:string)
      arg :amount, non_null(:decimal)
      arg :currency, non_null(:string)
      arg :duration, non_null(:integer)

      resolve &LoanResolvers.request_loan/2
    end

    field :loan_approval, non_null(:loan) do
      arg :loan_id, non_null(:id)
      arg :interest_rate, non_null(:decimal)

      resolve &LoanResolvers.approve_loan/2
    end
  end
end
