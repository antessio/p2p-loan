defmodule P2pLoan.Loans.Loan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "loans" do
    field :status, Ecto.Enum, values: [:requested, :verification, :approved, :refused, :expired]
    field :currency, :string
    field :owner_id, Ecto.UUID
    field :amount, :decimal
    field :interest_rate, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(loan, attrs) do
    loan
    |> cast(attrs, [:owner_id, :amount, :currency, :interest_rate, :status])
    |> validate_required([:owner_id, :amount, :currency, :status])
  end
end
