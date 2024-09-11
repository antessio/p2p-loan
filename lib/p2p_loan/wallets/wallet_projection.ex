defmodule P2pLoan.Wallets.WalletProjection do
  alias P2pLoan.Wallets.WalletEvents.WalletChargeExecuted
  alias P2pLoan.Wallets.WalletMovement
  alias P2pLoan.Repo
  alias P2pLoan.Wallets.WalletEvents.WalletTopUpExecuted
  alias P2pLoan.Wallets.Wallet
  alias P2pLoan.Wallets.WalletEvents.WalletCreated

  use Commanded.Projections.Ecto,
    name: "P2pLoan.Projectors.Wallet",
    application: P2pLoan.CommandedApplication,
    consistency: :strong,
    repo: P2pLoan.Repo

  project(
    %WalletCreated{id: id, owner_id: owner_id, currency: currency, amount: amount},
    _,
    fn multi ->
      amount = amount || Decimal.new(0)
      currency = currency || "EUR"

      Ecto.Multi.insert(multi, :wallet, %Wallet{
        id: id,
        owner_id: owner_id,
        amount: Decimal.new(amount),
        currency: currency
      })
    end
  )

  project(%WalletTopUpExecuted{id: id, amount: amount} = event, metadata, fn multi ->
    wallet = Repo.get(Wallet, id)
    amount_decimal = convert_decimal(amount)
    case wallet do
      nil ->
        multi

      w ->
        Ecto.Multi.update(
          multi,
          :wallet,
          Wallet.changeset(w, %{amount: Decimal.add(wallet.amount, amount_decimal)})
          ### TODO: create wallet movement event
        )
        |> Ecto.Multi.insert(
          :wallet_movement,
          Ecto.build_assoc(w, :movements, %{amount: amount_decimal, wallet: w})
        )
    end
  end)

  project(%WalletChargeExecuted{id: id, amount: amount} = event, metadata, fn multi ->
    wallet = Repo.get(Wallet, id)
    amount_decimal = convert_decimal(amount)
    case wallet do
      nil ->
        multi

      w ->
        Ecto.Multi.update(
          multi,
          :wallet,
          Wallet.changeset(w, %{amount: Decimal.sub(wallet.amount, amount_decimal)})
          ### TODO: create wallet movement event
        )
        |> Ecto.Multi.insert(
          :wallet_movement,
          Ecto.build_assoc(w, :movements, %{amount: Decimal.negate(amount_decimal), wallet: w})
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
