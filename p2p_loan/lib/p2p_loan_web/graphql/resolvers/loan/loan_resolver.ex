defmodule P2pLoanWeb.GraphQL.Loan.LoanResolvers do
  alias P2pLoan.Loans
  alias P2pLoan.Loans.LoanRequest
  alias P2pLoan.Loans.Contribution

  def get_loan(%{id: id}, _resolver) do
    {:ok, Loans.get_loan_with_contributions!(id)}
  end

  def get_loans(_args,_resolver) do
    {:ok, Loans.list_loans()}
  end

  def get_requested_loans(_args, _resolver) do
    {:ok, Loans.list_requested_loans()}
  end
  def request_loan(_resolver, %{ amount: amount, currency: currency, duration: duration},  %{context: %{current_user: current_user}}) do
    loan_request = %LoanRequest{owner_id: current_user.id, currency: currency, amount: amount, duration: duration}
    Loans.request_loan(loan_request)
  end
  def request_loan(_resolver, %{ amount: amount, currency: currency, duration: duration}, %{}) do
    {:error, message: "cannot request a loan, invalid user"}
  end

  def approve_loan(%{loan_id: loan_id, interest_rate: interest_rate}, _resolver) do
    Loans.get_loan!(loan_id)
    |> Loans.approve(interest_rate)
  end

  def add_contribution(%{loan_id: loan_id, contributor_id: contributor_id, contribution_amount: contribution_amount}, _resolver) do
    loan = Loans.get_loan_with_contributions!(loan_id)
    contribution = %Contribution{currency: loan.currency, amount: contribution_amount, contributor_id: contributor_id}
    case Loans.create_contribution(contribution, loan) do
      {:ok, l} -> case l do
        {:ok, x} -> x
        {:error, e} -> {:error, %{message: e}}
      end
      {:error, e} -> {:error, %{message: e}}
    end
  end
end
