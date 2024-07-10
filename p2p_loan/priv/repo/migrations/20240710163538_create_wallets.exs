defmodule P2pLoan.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :owner_id, :uuid
      add :amount, :decimal
      add :currency, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:wallets, [:owner_id])
  end
end
