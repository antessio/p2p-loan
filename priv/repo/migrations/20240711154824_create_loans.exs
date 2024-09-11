defmodule P2pLoan.Repo.Migrations.CreateLoans do
  use Ecto.Migration

  def change do
    create table(:loans, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :owner_id, :uuid
      add :amount, :decimal
      add :currency, :string
      add :interest_rate, :decimal
      add :status, :string
      add :duration, :integer

      timestamps(type: :utc_datetime)
    end

  end
end
