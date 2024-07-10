defmodule P2pLoan.Wallets.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field :currency, :string
    field :owner_id, Ecto.UUID
    field :amount, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:owner_id, :amount, :currency])
    |> validate_required([:owner_id, :amount, :currency])
    |> unique_constraint(:owner_id)
  end
end
