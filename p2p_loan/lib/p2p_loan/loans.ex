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
  alias P2pLoan.Wallets.Wallet
  alias P2pLoan.Loans.InterestCharge


  defmodule LoanRequest do
    @enforce_keys [:owner_id, :amount, :currency, :duration]
    defstruct [:owner_id, :amount, :currency, :duration]
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
  end

  def get_loan_with_contributions!(id)do
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

  def request_loan(%LoanRequest{} = loan_request) do
    %Loan{owner_id: loan_request.owner_id, currency: loan_request.currency, amount: loan_request.amount, status: :requested, duration: loan_request.duration}
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

  def list_contributions_by_loan_ids(loan_ids) do
    from(c in Contribution, where: c.loan_id in ^loan_ids)
    |> Repo.all()
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
  def create_contribution(%Contribution{} = contribution, %Loan{} = loan) when loan.status == :approved  do

    wallet = Wallets.get_wallet_by_owner_id(contribution.contributor_id)
    cond do
      wallet.amount < contribution.amount -> {:error, "#{wallet.owner_id} has not enough money"}
      true -> {:ok, add_contribution(wallet, loan, contribution)}
    end


  end

  def add_contribution(%Wallet{} = wallet, %Loan{} = loan, %Contribution{} = contribution) do
    Repo.transaction(fn ->
      remaining_loan_amount = get_remaining_loan_amount(loan)
      |> Decimal.to_float

      loan_status = case remaining_loan_amount do
        t when t > 0 -> loan.status
        t when t <= 0 -> :ready_to_be_issued
      end

      if remaining_loan_amount > 0 do
        Wallets.charge(wallet, contribution.amount)
        remaining_loan_amount = remaining_loan_amount - Decimal.to_float(contribution.amount)

        loan
        |> Ecto.build_assoc(:contributions, contribution)
        |> Repo.insert()
      end
      loan
        |> Loan.changeset(%{status: loan_status})
        |> Repo.update

    end)
  end

  def create_contribution(_, %Loan{} = loan) when loan.status != :approved do
    {:error, "loan is expected to be approved but is #{loan.status}"}
  end


  def get_remaining_loan_amount(%Loan{} = loan) do
    total_contributions = loan.contributions
      |> Enum.map(& &1.amount)
      |> Enum.reduce(Decimal.new(0), &Decimal.add/2)
    Decimal.sub(loan.amount, total_contributions)
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



  @doc """
  Returns the list of interest_chargges.

  ## Examples

      iex> list_interest_chargges()
      [%InterestCharge{}, ...]

  """
  def list_interest_chargges do
    Repo.all(InterestCharge)
  end

  @doc """
  Gets a single interest_charge.

  Raises `Ecto.NoResultsError` if the Interest charge does not exist.

  ## Examples

      iex> get_interest_charge!(123)
      %InterestCharge{}

      iex> get_interest_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_interest_charge!(id), do: Repo.get!(InterestCharge, id)

  @doc """
  Creates a interest_charge.

  ## Examples

      iex> create_interest_charge(%{field: value})
      {:ok, %InterestCharge{}}

      iex> create_interest_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_interest_charge(attrs \\ %{}) do
    %InterestCharge{}
    |> InterestCharge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a interest_charge.

  ## Examples

      iex> update_interest_charge(interest_charge, %{field: new_value})
      {:ok, %InterestCharge{}}

      iex> update_interest_charge(interest_charge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_interest_charge(%InterestCharge{} = interest_charge, attrs) do
    interest_charge
    |> InterestCharge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a interest_charge.

  ## Examples

      iex> delete_interest_charge(interest_charge)
      {:ok, %InterestCharge{}}

      iex> delete_interest_charge(interest_charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_interest_charge(%InterestCharge{} = interest_charge) do
    Repo.delete(interest_charge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking interest_charge changes.

  ## Examples

      iex> change_interest_charge(interest_charge)
      %Ecto.Changeset{data: %InterestCharge{}}

  """
  def change_interest_charge(%InterestCharge{} = interest_charge, attrs \\ %{}) do
    InterestCharge.changeset(interest_charge, attrs)
  end


  def issue(%Loan{} = loan) do
    Repo.transaction(fn ->
      loan.contributions
      |> Enum.flat_map(& convert_to_interest_charges(&1, loan))
      |> Enum.each(fn ic -> Repo.insert(ic) end)

      loan
      |> Loan.changeset(%{status: :issued})
      |> Repo.update()
    end)

  end

  def convert_to_interest_charges(contribution, %Loan{} = loan) do
    number_of_months = loan.duration*12
    amount = Decimal.mult(contribution.amount, loan.interest_rate)
    |> Decimal.div(100)
    |> Decimal.add(contribution.amount)
    |> Decimal.div(number_of_months)

    now = DateTime.utc_now()
    Stream.iterate(now, & DateTime.new!(Date.shift(&1, month: 1), DateTime.to_time(&1)))
    |> Enum.take(number_of_months)
    |> Enum.map(& %InterestCharge{status: :to_pay, amount: amount, due_date: DateTime.truncate(&1, :second), debtor_id: contribution.contributor_id, loan: loan})
    |> Enum.to_list
  end

  def get_interest_charges(loan_id) do
    loan = Loans.get_loan!(loan_id)
    |> Repo.preload(:interest_charges)
    loan.interest_charges
  end
end
