# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     P2pLoan.Repo.insert!(%P2pLoan.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Ecto.UUID
P2pLoan.Repo.insert!(%P2pLoan.Wallets.Wallet{owner_id: UUID.generate(), currency: "EUR", amount: Decimal.new(:rand.uniform(10000000)) })
