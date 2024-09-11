defmodule P2pLoan.Wallets.WalletAggregate do
  defstruct [
    :id,
    :owner_id,
    :amount,
    :currency
  ]

  alias P2pLoan.Wallets.WalletEvents.WalletChargeExecuted
  alias P2pLoan.Wallets.WalletCommands.ChargeCommand
  alias P2pLoan.Wallets.WalletEvents.WalletTopUpExecuted

  alias P2pLoan.Wallets.WalletCommands.TopUpCommand
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

  def execute(%WalletAggregate{}, %TopUpCommand{} = command) do
    %WalletTopUpExecuted{
      id: command.id,
      amount: command.amount
    }
  end

  def execute(%WalletAggregate{}, %ChargeCommand{} = command) do
    %WalletChargeExecuted{
      id: command.id,
      amount: command.amount
    }
  end


  def apply(%WalletAggregate{} = wallet, %WalletTopUpExecuted{} = event) do

    %WalletAggregate{
      wallet
      | amount: Decimal.add(wallet.amount, convert_decimal(event.amount))
    }
  end

  def apply(%WalletAggregate{} = wallet, %WalletChargeExecuted{} = event) do
    %WalletAggregate{
      wallet
      | amount: Decimal.sub(wallet.amount, convert_decimal(event.amount))
    }
  end

  defp convert_decimal(amount) when is_binary(amount) do
    Decimal.new(amount)
  end
  defp convert_decimal(amount) do
    amount
  end
end
