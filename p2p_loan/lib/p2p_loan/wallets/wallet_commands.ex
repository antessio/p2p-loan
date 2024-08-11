defmodule P2pLoan.Wallets.WalletCommands do
  defmodule TopUpCommand do
    use ExConstructor
    defstruct [:owner_id, :amount, :currency]
  end

  defmodule CreateWalletCommand do
    use ExConstructor
    defstruct [:id, :owner_id, :amount, :currency]

    alias P2pLoan.Wallets.WalletCommands.CreateWalletCommand

    def assign_id(%CreateWalletCommand{} = command) do
      %CreateWalletCommand{
        command
        | id: Ecto.UUID.generate()
      }
    end
  end

  defmodule ChargeCommand do
    defstruct [:owner_id, :amount, :currency]
  end

  defmodule MoveMoney do
    defstruct [:from_owner_id, :to_owner_id, :amount, :currency]
  end
end
