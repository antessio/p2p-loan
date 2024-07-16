defmodule P2pLoan.Loans.Loan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "loans" do
    field :status, Ecto.Enum, values: [:requested, :approved, :ready_to_be_issued, :issued, :refused, :expired]
    field :currency, :string
    field :owner_id, Ecto.UUID
    field :amount, :decimal
    field :interest_rate, :decimal

    has_many :contributions, P2pLoan.Loans.Contribution
    has_many :interest_charges, P2pLoan.Loans.InterestCharge

    field :duration, :integer
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(loan, attrs) do
    loan
    |> cast(attrs, [:owner_id, :amount, :currency, :interest_rate, :status, :duration])
    |> validate_required([:owner_id, :amount, :currency, :status, :duration])
  end
end
