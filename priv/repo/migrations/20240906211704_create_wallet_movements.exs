defmodule P2pLoan.Repo.Migrations.CreateWalletMovements do
  use Ecto.Migration

  def change do
    create table(:wallet_movements, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :wallet_id, references(:wallets, on_delete: :delete_all, type: :uuid)
      add :amount, :decimal
      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:wallet_movements, [:wallet_id, :inserted_at])
  end
end
