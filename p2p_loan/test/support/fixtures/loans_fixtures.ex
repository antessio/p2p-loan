defmodule P2pLoan.LoansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `P2pLoan.Loans` context.
  """

  @doc """
  Generate a unique loan owner_id.
  """
  def unique_loan_owner_id do
    raise "implement the logic to generate a unique loan owner_id"
  end

  @doc """
  Generate a loan.
  """
  def loan_fixture(attrs \\ %{}) do
    {:ok, loan} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        currency: "some currency",
        interest_rate: "120.5",
        owner_id: unique_loan_owner_id(),
        status: "some status"
      })
      |> P2pLoan.Loans.create_loan()

    loan
  end
end
