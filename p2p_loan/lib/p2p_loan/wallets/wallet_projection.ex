defmodule P2pLoan.Wallets.WalletProjection do
  alias P2pLoan.Wallets.Wallet
  alias P2pLoan.Wallets.WalletEvents.WalletCreated

  use Commanded.Projections.Ecto,
    name: "P2pLoan.Projectors.Wallet",
    application: P2pLoan.CommandedApplication,
    consistency: :strong

  project(%WalletCreated{} = wallet_created, _, fn multi ->
    Ecto.Multi.insert(multi, :wallet, %Wallet{
      id: wallet_created.id,
      owner_id: wallet_created.owner_id,
      amount: Decimal.new(wallet_created.amount),
      currency: wallet_created.currency
    })
  end)
end
