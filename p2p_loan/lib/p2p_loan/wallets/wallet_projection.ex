defmodule P2pLoan.Wallets.WalletProjection do
  alias P2pLoan.Repo
  alias P2pLoan.Wallets.WalletEvents.WalletTopUpExecuted
  alias P2pLoan.Wallets.Wallet
  alias P2pLoan.Wallets.WalletEvents.WalletCreated

  use Commanded.Projections.Ecto,
    name: "P2pLoan.Projectors.Wallet",
    application: P2pLoan.CommandedApplication,
    consistency: :strong,
    repo: P2pLoan.Repo

  project(%WalletCreated{} = wallet_created, _, fn multi ->
    Ecto.Multi.insert(multi, :wallet, %Wallet{
      id: wallet_created.id,
      owner_id: wallet_created.owner_id,
      amount: Decimal.new(wallet_created.amount),
      currency: wallet_created.currency
    })
  end)

  project(%WalletTopUpExecuted{id: id, amount: amount} = event, metadata, fn multi ->
    wallet = Repo.get(Wallet, id)

    case wallet do
      nil -> multi
      w ->
        Ecto.Multi.update(
          multi,
          :wallet,
          Wallet.changeset(w, %{amount: Decimal.add(wallet.amount, convert_decimal(amount))})
        )
    end
  end)

  # @impl Commanded.Projections.Ecto
  # def after_update(event, metadata, changes) do
  #   # Use the event, metadata, or `Ecto.Multi` changes and return `:ok`
  #   IO.inspect(event, label: "after update event")
  #   IO.inspect(metadata, label: "after update metadata")
  #   IO.inspect(changes, label: "after update changes")
  #   :ok
  # end



  defp convert_decimal(amount) when is_binary(amount) do
    Decimal.new(amount)
  end

  defp convert_decimal(amount) do
    amount
  end
end
