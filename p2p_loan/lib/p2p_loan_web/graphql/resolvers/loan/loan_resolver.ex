defmodule P2pLoanWeb.GraphQL.Loan.LoanResolvers do
  alias P2pLoan.Loans

  def get_loan(%{id: id}, _resolver) do
    {:ok, Loans.get_loan!(id)}
  end

  def get_loans(_args,_resolver) do
    {:ok, Loans.list_loans()}
  end
end
