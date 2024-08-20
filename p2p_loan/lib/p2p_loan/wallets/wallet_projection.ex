defmodule P2pLoan.Wallets.WalletProjection do
  alias P2pLoan.Repo
  alias P2pLoan.Wallets.WalletEvents.WalletTopUpExecuted
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

  project(%WalletTopUpExecuted{id: id, amount: amount} = event, _, fn multi ->
    wallet = Repo.get(Wallet, id)

    new_amount =
      IO.inspect(Decimal.add(wallet.amount, convert_decimal(amount)), label: "new amount")

    case wallet do
      nil ->
        multi

      w ->
        Ecto.Multi.update(
          multi,
          :wallet,
          Wallet.changeset(w, %{amount: new_amount})
        )
    end
  end)

  defp convert_decimal(amount) when is_binary(amount) do
    Decimal.new(amount)
  end

  defp convert_decimal(amount) do
    amount
  end
end
