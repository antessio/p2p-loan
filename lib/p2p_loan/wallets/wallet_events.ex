defmodule P2pLoan.Wallets.WalletEvents do

  defmodule WalletCreated do
    @derive Jason.Encoder
    defstruct [:id, :owner_id, :amount, :currency]
  end

  defmodule WalletTopUpExecuted do
    @derive Jason.Encoder
    defstruct [:id, :amount]
  end
  defmodule WalletOwnerTopUpExecuted do
    @derive Jason.Encoder
    defstruct [:owner_id, :amount]
  end

  defmodule WalletChargeExecuted do
    @derive Jason.Encoder
    defstruct [:id, :amount]
  end

  defmodule WalletChargeFailed do
    @derive Jason.Encoder
    defstruct [:id]
  end
end
