defmodule P2pLoanWeb.GraphQL.Loan.LoanTypes do
  use Absinthe.Schema.Notation


  object :loan do
    field :id, non_null(:id)
    field :status, non_null(:string)
    field :owner_id, non_null(:string)
    field :amount, non_null(:decimal)
    field :currency, non_null(:string)
    field :duration, non_null(:integer)
    field :interest_rate, :decimal
    field :contributions, list_of(:contribution) do
      resolve fn loan, _args, _resolution ->
        batch({__MODULE__, :list_contributions_by_loan_id, P2pLoan.Loans.Contribution}, loan.id, fn batch_results ->
          {:ok, Map.get(batch_results, loan.id)}
        end)
      end
    end
  end

  def list_contributions_by_loan_id(_, loan_ids) do
    contributions = P2pLoan.Loans.list_contributions_by_loan_ids(loan_ids)
    Enum.group_by(contributions, fn contribution -> contribution.loan_id end)

  end

  object :contribution do
    field :currency, non_null(:string)
    field :contributor_id, non_null(:string)
    field :amount, non_null(:decimal)
  end
end
