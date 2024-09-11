defmodule P2pLoan.WalletsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `P2pLoan.Wallets` context.
  """

  @doc """
  Generate a unique wallet owner_id.
  """
  def unique_wallet_owner_id do
    Ecto.UUID.bingenerate()
  end

  @doc """
  Generate a wallet.
  """
  def wallet_fixture(attrs \\ %{}) do
    {:ok, wallet} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        currency: "some currency",
        owner_id: unique_wallet_owner_id()
      })
      |> P2pLoan.Wallets.create_wallet()

    wallet
  end
end
