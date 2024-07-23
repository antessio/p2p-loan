defmodule P2pLoanWeb.LoanController do
  use P2pLoanWeb, :controller

  alias P2pLoan.Loans
  alias P2pLoan.Loans.Loan
  alias P2pLoan.Loans.Contribution
  alias P2pLoan.Loans.LoanRequest


  def index(conn, _params) do
    loans = Loans.list_loans()
    render(conn, :index, loans: loans)
  end

  def new(conn, _params) do
    changeset = Loans.change_loan(%Loan{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"loan" => loan_params}) do
    {duration, _} = Integer.parse(loan_params["duration"])
    amount = Decimal.new(loan_params["amount"])
    loan_request = %LoanRequest{owner_id: loan_params["owner_id"], currency: loan_params["currency"], amount: amount, duration: duration}
    case Loans.request_loan(loan_request) do
      {:ok, loan} ->
        conn
        |> put_flash(:info, "Loan created successfully.")
        |> redirect(to: ~p"/loans/#{loan}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    loan = Loans.get_loan_with_contributions!(id)
    render(conn, :show, loan: loan)
  end

  def edit(conn, %{"id" => id}) do
    loan = Loans.get_loan!(id)
    changeset = Loans.change_loan(loan)
    render(conn, :edit, loan: loan, changeset: changeset)
  end

  def update(conn, %{"id" => id, "loan" => loan_params}) do
    loan = Loans.get_loan!(id)

    case Loans.approve(loan, Decimal.new(loan_params["interest_rate"])) do
      {:ok, loan} ->
        conn
        |> put_flash(:info, "Loan updated successfully.")
        |> redirect(to: ~p"/loans/#{loan}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, loan: loan, changeset: changeset)
    end
  end

  def issue(conn, %{"id" => id})do
    loan = Loans.get_loan_with_contributions!(id)
    Loans.issue(loan)

    conn |> redirect(to: ~p"/loans/#{loan}")

  end
  def delete(conn, %{"id" => id}) do
    loan = Loans.get_loan!(id)
    {:ok, _loan} = Loans.delete_loan(loan)

    conn
    |> put_flash(:info, "Loan deleted successfully.")
    |> redirect(to: ~p"/loans")
  end


  def add_contributor(conn, %{"id" => id, "loan" => contribution_params})do

    loan = Loans.get_loan_with_contributions!(id)
    contribution = %Contribution{currency: loan.currency, amount: Decimal.new(contribution_params["contributor_amount"]), contributor_id: contribution_params["contributor_id"]}
    case Loans.create_contribution(contribution, loan) do
      {:ok, contributor} ->
        conn
        |> put_flash(:info, "Loan contributor added.")
        |> redirect(to: ~p"/loans/#{loan}")
      {:error, message} -> conn
      |> put_flash(:error, message)
      |> redirect(to: ~p"/loans/#{loan}")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, loan: loan, changeset: changeset)
    end
  end

  def get_add_contributor(conn, %{"id" => id}) do
    loan = Loans.get_loan_with_contributions!(id)
    changeset = Loans.change_loan(loan)
    render(conn, :add_contributor, loan: loan, changeset: changeset)
  end

  def delete_contributor(conn, %{"id" => id, "contributor_id" => contributor_id})do
    contribution = Loans.get_contribution!(contributor_id)
    {:ok, _} = Loans.delete_contribution(contribution)

    conn
    |> put_flash(:info, "Contribution deleted successfully.")
    |> redirect(to: ~p"/loans/#{id}")
  end

  def get_interest_charges(conn, %{"id" => id}) do
    interest_charges = Loans.get_interest_charges(id)
    render(conn, :interest_charges, loan_id: id, interest_charges: interest_charges)
  end

  def get_interest_charge_processing(conn, %{"id" => id}) do
    loan = Loans.get_loan_with_contributions!(id)
    changeset = Loans.change_loan(loan)
    render(conn, :interest_charge_processing, loan: loan, changeset: changeset)
  end

  def process_interest_charges(conn, %{"id"=>id, "loan" => %{"target_date" => t}}) do
    {:ok, target_date, _} = DateTime.from_iso8601("#{t}T00:00:00Z")
    case Loans.charge_interests(id, target_date) do
      :ok-> conn
      |> put_flash(:info, "Processed correctly #{target_date}.")
      |> redirect(to: ~p"/loans/#{id}/interest_charges")
      :error -> conn
      |> put_flash(:error, "Error processing #{target_date}.")
      |> redirect(to: ~p"/loans/#{id}/interest_charges")
    end
  end
end
