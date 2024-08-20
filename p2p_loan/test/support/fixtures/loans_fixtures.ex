defmodule P2pLoan.LoansFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `P2pLoan.Loans` context.
  """
  alias P2pLoan.Wallets
  alias P2pLoan.Loans.Loan
  alias P2pLoan.Wallets.Wallet
  alias P2pLoan.Loans.Contribution
  alias P2pLoan.Loans.InterestCharge

  @doc """
  Generate a unique loan owner_id.
  """
  def unique_uuid do
    Ecto.UUID.generate()
  end

  def build_wallet(wallet) do
    defaults = %{
      amount: Decimal.from_float(120.5),
      currency: "EUR",
      owner_id: unique_uuid()
    }

    %{amount: amount, currency: currency, owner_id: owner_id} =
      Map.merge(defaults, wallet)

    %Wallet{
      owner_id: owner_id,
      currency: currency,
      amount: amount
    }
  end

  def build_loan(:requested, loan \\ %{}) do
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

  def a_loan(loan \\ %{}) do
    %{
      amount: Decimal.from_float(120.5),
      currency: "EUR",
      duration: 10,
      owner_id: unique_uuid(),
      interest_rate: Decimal.new("3"),
      status: :requested,
      contributions: [],
      interest_charges: []
    }
    |> Map.merge(Enum.into(loan, %{}))
    |> then(&struct!(Loan, &1))
  end

  def build_loan(:approved, loan) do
    %{
      amount: Decimal.from_float(120.5),
      currency: "EUR",
      duration: 10,
      interest_rate: Decimal.new("3"),
      contributions: []
    }
    |> Map.merge(Enum.into(loan, %{}))
    |> then(&struct!(Loan, &1))
  end

  def build_loan(:ready_to_be_issued, loan) do
    defaults = %{
      amount: Decimal.from_float(120.5),
      currency: "EUR",
      duration: 10,
      interest_rate: Decimal.new("3"),
      contributions: [build_contribution(), build_contribution()]
    }

    %{
      amount: amount,
      currency: currency,
      duration: duration,
      interest_rate: interest_rate,
      contributions: contributions
    } =
      Map.merge(defaults, loan)

    %Loan{
      amount: amount,
      currency: currency,
      owner_id: unique_uuid(),
      status: :ready_to_be_issued,
      duration: duration,
      interest_rate: interest_rate,
      contributions: contributions
    }
  end

  def build_loan(:issued, loan) do
    defaults = %{
      amount: Decimal.from_float(120.5),
      currency: "EUR",
      duration: 10,
      interest_rate: Decimal.new("3"),
      contributions: [
        build_contribution(),
        build_contribution()
      ],
      interest_charges: []
    }

    %{
      amount: amount,
      currency: currency,
      duration: duration,
      interest_rate: interest_rate,
      contributions: contributions,
      interest_charges: interest_charges
    } = Map.merge(defaults, loan)

    %Loan{
      amount: amount,
      currency: currency,
      owner_id: unique_uuid(),
      status: :issued,
      duration: duration,
      interest_rate: interest_rate,
      contributions: contributions,
      interest_charges: interest_charges
    }
  end

  def build_contribution(contribution \\ %{}) do
    defaults = %{currency: "EUR", amount: Decimal.from_float(2020.02)}
    %{currency: currency, amount: amount} = Map.merge(defaults, contribution)

    %Contribution{
      currency: currency,
      amount: amount,
      contributor_id: unique_uuid()
    }
  end

  def build_interest_charge(interest_charge \\ %{}) do
    %{
      status: :to_pay,
      debtor_id: unique_uuid(),
      amount: Decimal.new(3000),
      due_date:
        DateTime.utc_now()
        |> DateTime.add(1, :day)
        |> DateTime.truncate(:second)
    }
    |> Map.merge(Enum.into(interest_charge, %{}))
    |> then(&struct!(InterestCharge, &1))
  end

  def insert_loan(%Loan{} = loan) do
    loan
    |> P2pLoan.Repo.insert!()
  end

  def insert_loan_with_contributions(%Loan{} = loan) do
      loan
      |> P2pLoan.Repo.insert!()
  end

  def insert_wallet(%Wallet{} = wallet) do
    {:ok, id} = Wallets.create_wallet(wallet)
    Wallets.get_wallet!(id)
    # wallet
    # |> P2pLoan.Repo.insert!()
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
        owner_id: unique_uuid(),
        status: "some status"
      })
      |> P2pLoan.Loans.create_loan()

    loan
  end
end
