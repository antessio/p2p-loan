defmodule P2pLoanWeb.GraphQL.Loan.LoanTypes do
  use Absinthe.Schema.Notation


  object :loan do
    field :id, non_null(:id)
    field :status, non_null(:string)
    field :user_id, non_null(:string)
    field :amount, non_null(:decimal)
    field :interest_rate, :decimal
  end
end
