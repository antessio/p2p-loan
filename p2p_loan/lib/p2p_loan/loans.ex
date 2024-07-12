defmodule P2pLoan.Loans do
  @moduledoc """
  The Loans context.
  """

  import Ecto.Query, warn: false
  alias P2pLoan.Loans
  alias P2pLoan.Repo

  alias P2pLoan.Loans.Loan
  alias P2pLoan.Loans.Contribution
  alias P2pLoan.Wallets

  defmodule P2pLoan.LoanRequest do
    @enforce_keys [:owner_id, :amount, :currency]
    defstruct [:owner_id, :amount, :currency]
  end

  @doc """
  Returns the list of loans.

  ## Examples

      iex> list_loans()
      [%Loan{}, ...]

  """
  def list_loans do
    Repo.all(Loan)
  end

  def list_requested_loans do
    from(l in Loan, where: l.status == :requested)
    |> Repo.all()
  end

  @doc """
  Gets a single loan.

  Raises `Ecto.NoResultsError` if the Loan does not exist.

  ## Examples

      iex> get_loan!(123)
      %Loan{}

      iex> get_loan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan!(id)do
    Repo.get!(Loan, id)
    |> Repo.preload(:contributions)
  end

  @doc """
  Creates a loan.

  ## Examples

      iex> create_loan(%{field: value})
      {:ok, %Loan{}}

      iex> create_loan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan(attrs \\ %{}) do
    %Loan{}
    |> Loan.changeset(attrs)
    |> Repo.insert()
  end

  def request_loan(owner_id, currency, amount) do
    %Loan{owner_id: owner_id, currency: currency, amount: amount, status: :requested}
    |> Repo.insert()

  end

  def approve(%Loan{} = loan, interest_rate)do
      # TODO: error in case the loan is not requested
      loan
      |> Loan.changeset(%{interest_rate: interest_rate, status: :approved})
      |> Repo.update()
  end

  @doc """
  Updates a loan.

  ## Examples

      iex> update_loan(loan, %{field: new_value})
      {:ok, %Loan{}}

      iex> update_loan(loan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan(%Loan{} = loan, attrs) do
    loan
    |> Loan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan.

  ## Examples

      iex> delete_loan(loan)
      {:ok, %Loan{}}

      iex> delete_loan(loan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan(%Loan{} = loan) do
    Repo.delete(loan)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan changes.

  ## Examples

      iex> change_loan(loan)
      %Ecto.Changeset{data: %Loan{}}

  """
  def change_loan(%Loan{} = loan, attrs \\ %{}) do
    Loan.changeset(loan, attrs)
  end

  @doc """
  Returns the list of contributions.

  ## Examples

      iex> list_contributions()
      [%Contribution{}, ...]

  """
  def list_contributions do
    Repo.all(Contribution)
  end

  @doc """
  Gets a single contribution.

  Raises `Ecto.NoResultsError` if the Contribution does not exist.

  ## Examples

      iex> get_contribution!(123)
      %Contribution{}

      iex> get_contribution!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contribution!(id), do: Repo.get!(Contribution, id)

  @doc """
  Creates a contribution.

  ## Examples

      iex> create_contribution(%{field: value})
      {:ok, %Contribution{}}

      iex> create_contribution(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contribution(%Contribution{} = contribution, %Loan{} = loan) do
    # TODO: error in case the loan is not approved
    wallet = Wallets.get_wallet_by_owner_id(contribution.contributor_id)
    # TODO: error in case the contributor wallet doesn't have enough money
    Repo.transaction(fn ->
      # TODO: event based
      Wallets.charge(wallet, contribution.amount)
      total_contributions = loan.contributions
      |> Enum.map(& &1.amount)
      |> Enum.reduce(contribution.amount, &Decimal.add/2)
      remaining_loan_amount = Decimal.to_float(Decimal.sub(loan.amount, total_contributions))
      loan_status = case remaining_loan_amount do
        t when t >= 0 -> :issued
        t when t < 0 -> loan.status
      end

      loan
      |> Ecto.build_assoc(:contributions, contribution)
      |> Repo.insert()

      loan
      |> Loan.changeset(%{status: loan_status})
      |> Repo.update
    end)

  end

  @doc """
  Updates a contribution.

  ## Examples

      iex> update_contribution(contribution, %{field: new_value})
      {:ok, %Contribution{}}

      iex> update_contribution(contribution, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contribution(%Contribution{} = contribution, attrs) do
    contribution
    |> Contribution.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a contribution.

  ## Examples

      iex> delete_contribution(contribution)
      {:ok, %Contribution{}}

      iex> delete_contribution(contribution)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contribution(%Contribution{} = contribution) do
    Repo.delete(contribution)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contribution changes.

  ## Examples

      iex> change_contribution(contribution)
      %Ecto.Changeset{data: %Contribution{}}

  """
  def change_contribution(%Contribution{} = contribution, attrs \\ %{}) do
    Contribution.changeset(contribution, attrs)
  end
end
