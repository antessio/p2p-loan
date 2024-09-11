defmodule P2pLoan.GraphQL.Loan.LoanMutations do
  use Absinthe.Schema.Notation

  alias P2pLoanWeb.GraphQL.Loan.LoanResolvers


  object :loan_mutations do
    field :loan_request, non_null(:loan) do
      arg :amount, non_null(:decimal)
      arg :currency, non_null(:string)
      arg :duration, non_null(:integer)

      ## TODO: use owner from the token
      resolve &LoanResolvers.request_loan/3
    end

    field :loan_approval, non_null(:loan) do
      arg :loan_id, non_null(:id)
      arg :interest_rate, non_null(:decimal)
      ## TODO: only admin
      resolve &LoanResolvers.approve_loan/2
    end

    field :loan_contribute, non_null(:loan) do
      arg :loan_id, non_null(:id)
      arg :contributor_id, non_null(:string)
      arg :contribution_amount, non_null(:decimal)
      ## TODO: take contributor id from token
      resolve &LoanResolvers.add_contribution/2
    end
  end
end
