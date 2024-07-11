defmodule P2pLoanWeb.LoanHTML do
  use P2pLoanWeb, :html

  embed_templates "loan_html/*"

  @doc """
  Renders a loan form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def loan_form(assigns)
end
