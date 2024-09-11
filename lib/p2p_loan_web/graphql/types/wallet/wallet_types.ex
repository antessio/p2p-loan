defmodule P2pLoanWeb.GraphQL.Wallet.WalletTypes do
  use Absinthe.Schema.Notation


  object :wallet do
    field :id, non_null(:id)
    field :amount, non_null(:decimal)
    field :owner_id, non_null(:string)
    field :currency, non_null(:string)
    field :movements, list_of(:movement) do
      resolve fn wallet, _args, _resolution ->
        batch({__MODULE__, :list_movement_by_wallet_id, P2pLoan.Wallets.WalletMovement}, wallet.id, fn batch_results ->
          {:ok, Map.get(batch_results, wallet.id)}
        end)
      end
    end
  end

  def list_movement_by_wallet_id(_, wallet_ids) do
    movements = P2pLoan.Wallets.list_movement_by_wallet_id(wallet_ids)
    Enum.group_by(movements, fn movement -> movement.wallet_id end)

  end

  object :movement do
    field :id, non_null(:id)
    field :amount, non_null(:decimal)
    field :inserted_at, non_null(:date)
  end
end
