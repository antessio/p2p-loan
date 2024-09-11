defmodule P2pLoan.Repo.Migrations.CreateInterestCharges do
  use Ecto.Migration

  def change do
    create table(:interest_charges, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :debtor_id, :uuid
      add :loan_id, references(:loans, on_delete: :delete_all, type: :uuid)
      add :amount, :decimal
      add :status, :string
      add :due_date, :utc_datetime

      timestamps(type: :utc_datetime)
    end
    create index(:interest_charges, [:debtor_id])
    create index(:interest_charges, [:loan_id])
    create index(:interest_charges, [:status, :due_date])
  end
end
