defmodule P2pLoan.Wallets.WalletMovement do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, UUIDv7, autogenerate: true}
  @foreign_key_type :binary_id
  schema "wallet_movements" do
    field :amount, :decimal
    belongs_to :wallet, P2pLoan.Wallets.Wallet
    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(wallet_movement, attrs) do
    wallet_movement
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end


end
