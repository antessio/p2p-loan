defmodule P2pLoan.Repo.Migrations.CreateContributions do
  use Ecto.Migration

  def change do
    create table(:contributions) do
      add :contributor_id, :uuid
      add :amount, :decimal
      add :currency, :string
      add :loan_id, references(:loans, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:contributions, [:loan_id])
  end
end
