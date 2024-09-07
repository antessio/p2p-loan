defmodule P2pLoan.Wallets.WalletMovement do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "wallet_movements" do
    field :amount, :decimal
    belongs_to :wallet, P2pLoan.Wallets.Wallet
    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end

end
