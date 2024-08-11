defmodule P2pLoan.Wallets.WalletAggregate do
  defstruct [
    :id,
    :owner_id,
    :amount,
    :currency
  ]

  alias P2pLoan.Wallets.WalletEvents.WalletCreated
  alias P2pLoan.Wallets.WalletCommands.CreateWalletCommand
  alias P2pLoan.Wallets.WalletAggregate

  def execute(%WalletAggregate{id: nil}, %CreateWalletCommand{
        id: id,
        owner_id: owner_id,
        amount: amount,
        currency: currency
      })
      when amount >= 0 do
    %WalletCreated{
      id: id,
      owner_id: owner_id,
      amount: amount,
      currency: currency
    }
  end

  def execute(%WalletAggregate{id: nil}, %CreateWalletCommand{amount: amount}) when amount < 0 do
    {:error, :invalid_amount, "amount must be >= 0"}
  end

  def apply(%WalletAggregate{} = wallet, %WalletCreated{} = created) do
    %WalletAggregate{
      wallet
      | id: created.id,
        owner_id: created.owner_id,
        amount: created.amount,
        currency: created.currency
    }
  end
end
