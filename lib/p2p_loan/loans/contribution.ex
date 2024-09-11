defmodule P2pLoan.Loans.Contribution do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "contributions" do
    field :currency, :string
    field :contributor_id, Ecto.UUID
    field :amount, :decimal
    belongs_to :loan, P2pLoan.Loans.Loan


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contribution, attrs) do
    contribution
    |> cast(attrs, [:contributor_id, :amount, :currency, :loan_id])
    |> validate_required([:contributor_id, :amount, :currency])
  end
end
