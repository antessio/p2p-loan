defmodule P2pLoan.Repo.Migrations.AddLoanAttributes do
  use Ecto.Migration

  def change do
    alter table(:loans) do
      add :title, :string
      add :description, :string
    end
  end
end
