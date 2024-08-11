
alias P2pLoan.CommandedApplication
alias P2pLoan.Wallets.WalletAggregate
alias P2pLoan.Wallets.WalletCommands.CreateWalletCommand


uuid = Ecto.UUID.generate()
command = %CreateWalletCommand{id: uuid, amount: 0, currency: "EUR", owner_id: "0d6bf219-5e06-4cf2-bc4c-a44f814d9d98"}

CommandedApplication.dispatch(command)

CommandedApplication.aggregate_state(WalletAggregate, uuid)
