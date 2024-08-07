defmodule P2pLoan.Loans.InterestCharge do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "interest_charges" do

    field :status, Ecto.Enum, values: [:paid, :expired, :to_pay]
    field :debtor_id, Ecto.UUID
    field :amount, :decimal
    field :due_date, :utc_datetime
    belongs_to :loan, P2pLoan.Loans.Loan
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(interest_charge, attrs) do
    interest_charge
    |> cast(attrs, [:debtor_id, :loan_id, :amount, :status, :due_date])
    |> validate_required([:debtor_id, :loan_id, :amount, :status, :due_date])
  end
end
