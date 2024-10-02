defmodule P2pLoan.GraphQL.Loan.LoanQueries do
  use Absinthe.Schema.Notation
  alias P2pLoanWeb.GraphQL.Loan.LoanResolvers

  object :loan_queries do
    field :get_loan, :loan do
      arg :id, non_null(:id)

      resolve &LoanResolvers.get_loan/2
    end

    field :get_all_loans, list_of(:loan) do
      resolve &LoanResolvers.get_loans/2
    end

    field :get_requested_loans, list_of(:loan) do
      resolve &LoanResolvers.get_requested_loans/2
    end

    field :get_my_loans, list_of(:loan) do
      resolve &LoanResolvers.get_my_loans/3
    end

    field :get_loan_contributions, list_of(:contribution) do
      arg :id, non_null(:id)
      resolve &LoanResolvers.get_loan_contributions/3
    end

  end
end
