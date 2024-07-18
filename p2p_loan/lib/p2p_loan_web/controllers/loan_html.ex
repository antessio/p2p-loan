defmodule P2pLoanWeb.LoanHTML do
  use P2pLoanWeb, :html

  alias P2pLoan.Loans
  embed_templates "loan_html/*"

  @doc """
  Renders a loan form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def loan_form(assigns)


  def get_remaining_loan_amount(loan_id) do
    Loans.get_loan_with_contributions!(loan_id)
    |> Loans.get_remaining_loan_amount
  end
end
