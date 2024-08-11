defmodule P2pLoan.CommandedRouter do
  use Commanded.Commands.Router


  alias P2pLoan.Wallets.WalletAggregate

  alias P2pLoan.Wallets.WalletCommands.CreateWalletCommand



  dispatch([CreateWalletCommand], to: WalletAggregate, identity: :id)

end
