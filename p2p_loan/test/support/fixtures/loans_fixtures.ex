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

  @doc """
  Generate a contribution.
  """
  def contribution_fixture(attrs \\ %{}) do
    {:ok, contribution} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        contributor_id: "7488a646-e31f-11e4-aace-600308960662",
        currency: "some currency"
      })
      |> P2pLoan.Loans.create_contribution()

    contribution
  end

  @doc """
  Generate a interest_charge.
  """
  def interest_charge_fixture(attrs \\ %{}) do
    {:ok, interest_charge} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        debtor_id: "7488a646-e31f-11e4-aace-600308960662",
        due_date: ~U[2024-07-14 13:16:00Z],
        loan_id: "7488a646-e31f-11e4-aace-600308960662",
        status: "some status"
      })
      |> P2pLoan.Loans.create_interest_charge()

    interest_charge
  end
end
