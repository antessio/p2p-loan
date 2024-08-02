defmodule P2pLoan.LoansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `P2pLoan.Loans` context.
  """
  alias P2pLoan.Loans.Loan
  alias P2pLoan.Loans.Contribution

  @doc """
  Generate a unique loan owner_id.
  """
  def unique_uuid do
    Ecto.UUID.generate()
  end

  def build_loan(:requested, loan) do
    defaults = %{amount: Decimal.from_float(120.5), currency: "EUR", duration: 10}
    %{amount: amount, currency: currency, duration: duration} = Map.merge(defaults, loan)

    %Loan{
      amount: amount,
      currency: currency,
      owner_id: unique_uuid(),
      status: :requested,
      duration: duration
    }
  end

  def build_loan(:requested) do
    build_loan(:requested, %{})
  end

  def build_loan(:approved, loan) do
    defaults = %{
      amount: Decimal.from_float(120.5),
      currency: "EUR",
      duration: 10,
      interest_rate: Decimal.new("3")
    }

    %{amount: amount, currency: currency, duration: duration, interest_rate: interest_rate} =
      Map.merge(defaults, loan)

    %Loan{
      amount: amount,
      currency: currency,
      owner_id: unique_uuid(),
      status: :approved,
      duration: duration,
      interest_rate: interest_rate
    }
  end


  def build_loan(:issued, loan \\ %{}) do
    defaults = %{
      amount: Decimal.from_float(120.5),
      currency: "EUR",
      duration: 10,
      interest_rate: Decimal.new("3"),
      contributions: [
        build_contribution(),
        build_contribution()
      ]
    }

    %{
      amount: amount,
      currency: currency,
      duration: duration,
      interest_rate: interest_rate,
      contributions: contributions
    } = Map.merge(defaults, loan)

    %Loan{
      amount: amount,
      currency: currency,
      owner_id: unique_uuid(),
      status: :issued,
      duration: duration,
      interest_rate: interest_rate,
      contributions: contributions
    }
  end

  # def build_loan(:issued, %{amount: amount \\ 120.5, currency: currency \\ "EUR", duration: duration \\ 10, interest_rate: interest_rate \\ 3}, contributions \\ []) do
  #   %Loan{
  #     amount: amount,
  #     currency: currency,
  #     owner_id: unique_uuid(),
  #     status: :requested,
  #     duration: duration,
  #     interest_rate: interest_rate,
  #     contributions: contributions
  #   }
  # end

  def build_contribution(contribution \\ %{}) do
    defaults = %{currency: "EUR", amount: 2020.02}
    %{currency: currency, amount: amount} = Map.merge(defaults, contribution)

    %Contribution{
      currency: currency,
      amount: amount,
      contributor_id: unique_uuid()
    }
  end

  def insert_loan(%Loan{} = loan) do
    loan
    # |> Loan.changeset()
    |> P2pLoan.Repo.insert!()
  end

  def insert_loan_with_contributions(%Loan{} = loan, contributions) do
    loan
    |> Ecto.build_assoc(:contributions, contributions)
    |> P2pLoan.Repo.insert!()
  end

  @doc """
  Generate a loan requested.
  """
  def loan_requested_fixture(%{amount: amount, currency: currency, duration: duration}) do
    {:ok, loan} =
      %Loan{
        amount: amount || 120.5,
        currency: currency || "EUR",
        owner_id: unique_uuid(),
        status: :requested,
        duration: duration || 10
      }
      |> P2pLoan.Repo.insert()

    loan
  end

  @doc """
  Generate a loan requested.
  """
  def loan_requested_fixture() do
    loan_requested_fixture(%{
      amount: Decimal.new("120.5"),
      currency: "EUR",
      duration: 10
    })
  end

  # @doc """
  # Generate a loan issued.
  # """
  # def loan_issued_fixture() do
  #   loan_issued_fixture(%{
  #     amount: 120.5,
  #     currency: "EUR",
  #     duration: 10,
  #     interst_rate: 30
  #   })
  # end

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
