defmodule P2pLoanWeb.GraphQL.Loan.LoanResolvers do
  alias P2pLoan.Loans
  alias P2pLoan.Loans.LoanRequest

  def get_loan(%{id: id}, _resolver) do
    {:ok, Loans.get_loan_with_contributions!(id)}
  end

  def get_loans(_args,_resolver) do
    {:ok, Loans.list_loans()}
  end

  def get_requested_loans(_args, _resolver) do
    {:ok, Loans.list_requested_loans()}
  end

  def request_loan(%{owner_id: owner_id, amount: amount, currency: currency, duration: duration}, _resolver) do
    loan_request = %LoanRequest{owner_id: owner_id, currency: currency, amount: amount, duration: duration}
    Loans.request_loan(loan_request)
  end

  def approve_loan(%{loan_id: loan_id, interest_rate: interest_rate}, _resolver) do
    Loans.get_loan!(loan_id)
    |> Loans.approve(interest_rate)
  end
end
