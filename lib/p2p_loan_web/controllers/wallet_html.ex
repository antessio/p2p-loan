defmodule P2pLoanWeb.WalletHTML do
  use P2pLoanWeb, :html

  embed_templates "wallet_html/*"

  @doc """
  Renders a wallet form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def wallet_form(assigns)
end
