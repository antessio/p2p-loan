defmodule P2pLoan.Repo.Migrations.CreateLoans do
  use Ecto.Migration

  def change do
    create table(:loans) do
      add :owner_id, :uuid
      add :amount, :decimal
      add :currency, :string
      add :interest_rate, :decimal
      add :status, :string

      timestamps(type: :utc_datetime)
    end

  end
end
