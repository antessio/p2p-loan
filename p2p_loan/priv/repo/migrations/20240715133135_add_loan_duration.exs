defmodule P2pLoan.Repo.Migrations.AddLoanDuration do
  use Ecto.Migration

  def change do
    alter table (:loans)do
      add :duration, :integer
    end

  end
end
